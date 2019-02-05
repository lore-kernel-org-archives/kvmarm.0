From: Julien Thierry <julien.thierry@arm.com>
Subject: Re: [PATCH v2 5/5] KVM: arm/arm64: support chained PMU counters
Date: Tue, 5 Feb 2019 14:33:03 +0000
Message-ID: <11a8c800-5c1d-08ce-9d85-402ca89727a3@arm.com>
References: <1549299218-44714-1-git-send-email-andrew.murray@arm.com>
 <1549299218-44714-6-git-send-email-andrew.murray@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 070B64A2E4
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Feb 2019 09:33:10 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QSJ5aIgbHUGe for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 Feb 2019 09:33:08 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 22BE74A2AC
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Feb 2019 09:33:08 -0500 (EST)
In-Reply-To: <1549299218-44714-6-git-send-email-andrew.murray@arm.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Murray <andrew.murray@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, Marc Zyngier <marc.zyngier@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Andrew,

On 04/02/2019 16:53, Andrew Murray wrote:
> Emulate chained PMU counters by creating a single 64 bit event counter
> for a pair of chained KVM counters.
> 
> Signed-off-by: Andrew Murray <andrew.murray@arm.com>
> ---
>  include/kvm/arm_pmu.h |   1 +
>  virt/kvm/arm/pmu.c    | 321 +++++++++++++++++++++++++++++++++++++++++---------
>  2 files changed, 269 insertions(+), 53 deletions(-)
> 
> diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
> index b73f31b..8e691ee 100644
> --- a/include/kvm/arm_pmu.h
> +++ b/include/kvm/arm_pmu.h
> @@ -29,6 +29,7 @@ struct kvm_pmc {
>  	u8 idx;	/* index into the pmu->pmc array */
>  	struct perf_event *perf_event;
>  	u64 bitmask;
> +	u64 overflow_count;
>  };
>  
>  struct kvm_pmu {
> diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
> index a64aeb2..9318130 100644
> --- a/virt/kvm/arm/pmu.c
> +++ b/virt/kvm/arm/pmu.c
> @@ -24,9 +24,25 @@
>  #include <kvm/arm_pmu.h>
>  #include <kvm/arm_vgic.h>
>  
> +#define ARMV8_PMUV3_PERFCTR_CHAIN 0x1E

I find it a bit awkward to have this redefined here.

Maybe we could define a helper in kvm_host.h:
bool kvm_pmu_typer_is_chain(u64 typer);

That would always return false for arm32?

> +static void kvm_pmu_stop_release_perf_event_pair(struct kvm_vcpu *vcpu,
> +					    u64 pair_low);
> +static void kvm_pmu_stop_release_perf_event(struct kvm_vcpu *vcpu,
> +					      u64 select_idx);
> +static void kvm_pmu_sync_counter_enable_pair(struct kvm_vcpu *vcpu, u64 pair_low);
>  static void kvm_pmu_sync_counter_enable(struct kvm_vcpu *vcpu, u64 select_idx);
>  static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx);
> -static void kvm_pmu_stop_counter(struct kvm_vcpu *vcpu, struct kvm_pmc *pmc);
> +
> +/**
> + * kvm_pmu_counter_is_high_word - is select_idx high counter of 64bit event
> + * @pmc: The PMU counter pointer
> + * @select_idx: The counter index
> + */
> +static inline bool kvm_pmu_counter_is_high_word(struct kvm_pmc *pmc)
> +{
> +	return ((pmc->perf_event->attr.config1 & 0x1)
> +		&& (pmc->idx % 2));
> +}
>  
>  /**
>   * kvm_pmu_get_counter_value - get PMU counter value
> @@ -35,22 +51,70 @@ static void kvm_pmu_stop_counter(struct kvm_vcpu *vcpu, struct kvm_pmc *pmc);
>   */
>  u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx)
>  {
> -	u64 counter, reg, enabled, running;
> +	u64 counter_idx, reg, enabled, running, incr;
>  	struct kvm_pmu *pmu = &vcpu->arch.pmu;
>  	struct kvm_pmc *pmc = &pmu->pmc[select_idx];
>  
>  	reg = (select_idx == ARMV8_PMU_CYCLE_IDX)
>  	      ? PMCCNTR_EL0 : PMEVCNTR0_EL0 + select_idx;
> -	counter = __vcpu_sys_reg(vcpu, reg);
> +	counter_idx = __vcpu_sys_reg(vcpu, reg);

I'm not sure I understand the "_idx" suffix for this variable. This
holds a counter value, not and index. Right?


>  
>  	/* The real counter value is equal to the value of counter register plus
>  	 * the value perf event counts.
>  	 */
> -	if (pmc->perf_event)
> -		counter += perf_event_read_value(pmc->perf_event, &enabled,
> +	if (pmc->perf_event) {
> +		incr = perf_event_read_value(pmc->perf_event, &enabled,
>  						 &running);
>  
> -	return counter & pmc->bitmask;
> +		if (kvm_pmu_counter_is_high_word(pmc)) {
> +			u64 counter_low, counter;
> +
> +			reg = (select_idx == ARMV8_PMU_CYCLE_IDX)
> +			      ? PMCCNTR_EL0 : PMEVCNTR0_EL0 + select_idx - 1;
> +			counter_low = __vcpu_sys_reg(vcpu, reg);
> +			counter = lower_32_bits(counter_low) | (counter_idx << 32);
> +			counter_idx = upper_32_bits(counter + incr);
> +		} else {
> +			counter_idx += incr;
> +		}
> +	}
> +
> +	return counter_idx & pmc->bitmask;
> +}
> +
> +/**
> + * kvm_pmu_counter_is_enabled - is a counter active
> + * @vcpu: The vcpu pointer
> + * @select_idx: The counter index
> + */
> +static bool kvm_pmu_counter_is_enabled(struct kvm_vcpu *vcpu, u64 select_idx)
> +{
> +	u64 mask = kvm_pmu_valid_counter_mask(vcpu);
> +
> +	return (__vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMU_PMCR_E) &&
> +	       (__vcpu_sys_reg(vcpu, PMCNTENSET_EL0) & mask & BIT(select_idx));
> +}
> +
> +/**
> + * kvnm_pmu_event_is_chained - is a pair of counters chained and enabled
> + * @vcpu: The vcpu pointer
> + * @select_idx: The low counter index
> + */
> +static bool kvm_pmu_event_is_chained(struct kvm_vcpu *vcpu, u64 pair_low)
> +{
> +	u64 eventsel, reg;
> +
> +	reg = (pair_low + 1 == ARMV8_PMU_CYCLE_IDX)
> +	      ? PMCCFILTR_EL0 : PMEVTYPER0_EL0 + pair_low + 1;
> +	eventsel = __vcpu_sys_reg(vcpu, reg) & ARMV8_PMU_EVTYPE_EVENT;
> +	if (eventsel != ARMV8_PMUV3_PERFCTR_CHAIN)
> +		return false;
> +
> +	if (kvm_pmu_counter_is_enabled(vcpu, pair_low) !=
> +	    kvm_pmu_counter_is_enabled(vcpu, pair_low + 1))
> +		return false;
> +
> +	return true;
>  }
>  
>  /**
> @@ -61,29 +125,45 @@ u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx)
>   */
>  void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu, u64 select_idx, u64 val)
>  {
> -	u64 reg;
> -	struct kvm_pmu *pmu = &vcpu->arch.pmu;
> -	struct kvm_pmc *pmc = &pmu->pmc[select_idx];
> +	u64 reg, pair_low;
>  
>  	reg = (select_idx == ARMV8_PMU_CYCLE_IDX)
>  	      ? PMCCNTR_EL0 : PMEVCNTR0_EL0 + select_idx;
>  	__vcpu_sys_reg(vcpu, reg) += (s64)val - kvm_pmu_get_counter_value(vcpu, select_idx);
>  
> -	kvm_pmu_stop_counter(vcpu, pmc);
> -	kvm_pmu_sync_counter_enable(vcpu, select_idx);
> +	pair_low = (select_idx % 2) ? select_idx - 1 : select_idx;
> +
> +	/* Recreate the perf event to reflect the updated sample_period */
> +	if (kvm_pmu_event_is_chained(vcpu, pair_low)) {
> +		kvm_pmu_stop_release_perf_event_pair(vcpu, pair_low);
> +		kvm_pmu_sync_counter_enable_pair(vcpu, pair_low);
> +	} else {
> +		kvm_pmu_stop_release_perf_event(vcpu, select_idx);
> +		kvm_pmu_sync_counter_enable(vcpu, select_idx);
> +	}
>  }
>  
>  /**
>   * kvm_pmu_release_perf_event - remove the perf event
>   * @pmc: The PMU counter pointer
>   */
> -static void kvm_pmu_release_perf_event(struct kvm_pmc *pmc)
> +static void kvm_pmu_release_perf_event(struct kvm_vcpu *vcpu,
> +				       struct kvm_pmc *pmc)
>  {
> -	if (pmc->perf_event) {
> -		perf_event_disable(pmc->perf_event);
> +	struct kvm_pmu *pmu = &vcpu->arch.pmu;
> +	struct kvm_pmc *pmc_alt;
> +	u64 pair_alt;
> +
> +	pair_alt = (pmc->idx % 2) ? pmc->idx - 1 : pmc->idx + 1;
> +	pmc_alt = &pmu->pmc[pair_alt];
> +
> +	if (pmc->perf_event)
>  		perf_event_release_kernel(pmc->perf_event);
> -		pmc->perf_event = NULL;
> -	}
> +
> +	if (pmc->perf_event == pmc_alt->perf_event)
> +		pmc_alt->perf_event = NULL;
> +
> +	pmc->perf_event = NULL;
>  }
>  
>  /**
> @@ -91,22 +171,65 @@ static void kvm_pmu_release_perf_event(struct kvm_pmc *pmc)
>   * @vcpu: The vcpu pointer
>   * @pmc: The PMU counter pointer
>   *
> - * If this counter has been configured to monitor some event, release it here.
> + * If this counter has been configured to monitor some event, stop it here.
>   */
>  static void kvm_pmu_stop_counter(struct kvm_vcpu *vcpu, struct kvm_pmc *pmc)
>  {
>  	u64 counter, reg;
>  
>  	if (pmc->perf_event) {
> +		perf_event_disable(pmc->perf_event);
>  		counter = kvm_pmu_get_counter_value(vcpu, pmc->idx);
>  		reg = (pmc->idx == ARMV8_PMU_CYCLE_IDX)
>  		       ? PMCCNTR_EL0 : PMEVCNTR0_EL0 + pmc->idx;
>  		__vcpu_sys_reg(vcpu, reg) = counter;
> -		kvm_pmu_release_perf_event(pmc);
>  	}
>  }
>  
>  /**
> + * kvm_pmu_stop_release_perf_event_pair - stop and release a pair of counters
> + * @vcpu: The vcpu pointer
> + * @pmc_low: The PMU counter pointer for lower word
> + * @pmc_high: The PMU counter pointer for higher word
> + *
> + * As chained counters share the underlying perf event, we stop them
> + * both first before discarding the underlying perf event
> + */
> +static void kvm_pmu_stop_release_perf_event_pair(struct kvm_vcpu *vcpu,
> +					    u64 idx_low)
> +{
> +	struct kvm_pmu *pmu = &vcpu->arch.pmu;
> +	struct kvm_pmc *pmc_low = &pmu->pmc[idx_low];
> +	struct kvm_pmc *pmc_high = &pmu->pmc[idx_low + 1];
> +
> +	/* Stopping a counter involves adding the perf event value to the
> +	 * vcpu sys register value prior to releasing the perf event. As
> +	 * kvm_pmu_get_counter_value may depend on the low counter value we
> +	 * must always stop the high counter first
> +	 */
> +	kvm_pmu_stop_counter(vcpu, pmc_high);
> +	kvm_pmu_stop_counter(vcpu, pmc_low);
> +
> +	kvm_pmu_release_perf_event(vcpu, pmc_high);
> +	kvm_pmu_release_perf_event(vcpu, pmc_low);
> +}
> +
> +/**
> + * kvm_pmu_stop_release_perf_event - stop and release a counter
> + * @vcpu: The vcpu pointer
> + * @select_idx: The counter index
> + */
> +static void kvm_pmu_stop_release_perf_event(struct kvm_vcpu *vcpu,
> +					      u64 select_idx)
> +{
> +	struct kvm_pmu *pmu = &vcpu->arch.pmu;
> +	struct kvm_pmc *pmc = &pmu->pmc[select_idx];
> +
> +	kvm_pmu_stop_counter(vcpu, pmc);
> +	kvm_pmu_release_perf_event(vcpu, pmc);
> +}
> +
> +/**
>   * kvm_pmu_vcpu_reset - reset pmu state for cpu
>   * @vcpu: The vcpu pointer
>   *
> @@ -117,7 +240,7 @@ void kvm_pmu_vcpu_reset(struct kvm_vcpu *vcpu)
>  	struct kvm_pmu *pmu = &vcpu->arch.pmu;
>  
>  	for (i = 0; i < ARMV8_PMU_MAX_COUNTERS; i++) {
> -		kvm_pmu_stop_counter(vcpu, &pmu->pmc[i]);
> +		kvm_pmu_stop_release_perf_event(vcpu, i);
>  		pmu->pmc[i].idx = i;
>  		pmu->pmc[i].bitmask = 0xffffffffUL;
>  	}
> @@ -134,7 +257,7 @@ void kvm_pmu_vcpu_destroy(struct kvm_vcpu *vcpu)
>  	struct kvm_pmu *pmu = &vcpu->arch.pmu;
>  
>  	for (i = 0; i < ARMV8_PMU_MAX_COUNTERS; i++)
> -		kvm_pmu_release_perf_event(&pmu->pmc[i]);
> +		kvm_pmu_release_perf_event(vcpu, &pmu->pmc[i]);
>  }
>  
>  u64 kvm_pmu_valid_counter_mask(struct kvm_vcpu *vcpu)
> @@ -167,53 +290,115 @@ static void kvm_pmu_enable_counter(struct kvm_vcpu *vcpu, u64 select_idx)
>  }
>  
>  /**
> + * kvm_pmu_sync_counter_enable - reenable a counter if it should be enabled
> + * @vcpu: The vcpu pointer
> + * @select_idx: The counter index
> + */
> +static void kvm_pmu_sync_counter_enable(struct kvm_vcpu *vcpu,
> +					    u64 select_idx)
> +{
> +	kvm_pmu_enable_counter_mask(vcpu, BIT(select_idx));
> +}
> +
> +/**
> + * kvm_pmu_sync_counter_enable_pair - reenable a pair if they should be enabled
> + * @vcpu: The vcpu pointer
> + * @pair_low: The low counter index
> + */
> +static void kvm_pmu_sync_counter_enable_pair(struct kvm_vcpu *vcpu, u64 pair_low)
> +{
> +	kvm_pmu_enable_counter_mask(vcpu, BIT(pair_low) | BIT(pair_low + 1));
> +}
> +
> +/**
> + * kvm_pmu_enable_counter_pair - enable counters pair at a time
> + * @vcpu: The vcpu pointer
> + * @val: counters to enable
> + * @pair_low: The low counter index
> + */
> +static void kvm_pmu_enable_counter_pair(struct kvm_vcpu *vcpu, u64 val,
> +					u64 pair_low)
> +{
> +	struct kvm_pmu *pmu = &vcpu->arch.pmu;
> +	struct kvm_pmc *pmc_low = &pmu->pmc[pair_low];
> +	struct kvm_pmc *pmc_high = &pmu->pmc[pair_low + 1];
> +
> +	if (kvm_pmu_event_is_chained(vcpu, pair_low)) {
> +		if (pmc_low->perf_event != pmc_high->perf_event)
> +			kvm_pmu_stop_release_perf_event_pair(vcpu, pair_low);
> +	}
> +
> +	if (val & BIT(pair_low))
> +		kvm_pmu_enable_counter(vcpu, pair_low);
> +
> +	if (val & BIT(pair_low+1))

Style nit: I think there should be spaces around the '+', might be worth
running checkpatch to check for other style stuff.

> +		kvm_pmu_enable_counter(vcpu, pair_low + 1);
> +}
> +
> +/**
>   * kvm_pmu_enable_counter_mask - enable selected PMU counters
>   * @vcpu: The vcpu pointer
> - * @val: the value guest writes to PMCNTENSET register
> + * @val: the value guest writes to PMCNTENSET register or a subset
>   *
>   * Call perf_event_enable to start counting the perf event
>   */
>  void kvm_pmu_enable_counter_mask(struct kvm_vcpu *vcpu, u64 val)
>  {
>  	int i;
> +	u64 mask = kvm_pmu_valid_counter_mask(vcpu);
> +	u64 set = __vcpu_sys_reg(vcpu, PMCNTENSET_EL0) & mask;
>  
>  	if (!(__vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMU_PMCR_E) || !val)
>  		return;
>  
> -	for (i = 0; i < ARMV8_PMU_MAX_COUNTERS; i++) {
> -		if (!(val & BIT(i)))
> -			continue;
> -
> -		kvm_pmu_enable_counter(vcpu, i);
> -	}
> +	for (i = 0; i < ARMV8_PMU_MAX_COUNTERS; i += 2)
> +		kvm_pmu_enable_counter_pair(vcpu, val & set, i);
>  }
>  
>  /**
> - * kvm_pmu_sync_counter_enable - reenable a counter if it should be enabled
> + * kvm_pmu_disable_counter - disable selected PMU counter
>   * @vcpu: The vcpu pointer
>   * @select_idx: The counter index
>   */
> -static void kvm_pmu_sync_counter_enable(struct kvm_vcpu *vcpu,
> -					    u64 select_idx)
> +static void kvm_pmu_disable_counter(struct kvm_vcpu *vcpu, u64 select_idx)
>  {
> -	u64 set = __vcpu_sys_reg(vcpu, PMCNTENSET_EL0);
> +	struct kvm_pmu *pmu = &vcpu->arch.pmu;
> +	struct kvm_pmc *pmc = &pmu->pmc[select_idx];
>  
> -	if (set & BIT(select_idx))
> -		kvm_pmu_enable_counter_mask(vcpu, BIT(select_idx));
> +	if (pmc->perf_event) {
> +		perf_event_disable(pmc->perf_event);
> +		if (pmc->perf_event->state != PERF_EVENT_STATE_ACTIVE)
> +			kvm_debug("fail to enable perf event\n");
> +	}
>  }
>  
>  /**
> - * kvm_pmu_disable_counter - disable selected PMU counter
> - * @vcpu: The vcpu pointer
> - * @pmc: The counter to disable
> + * kvm_pmu_disable_counter_pair - disable counters pair at a time
> + * @val: counters to disable
> + * @pair_low: The low counter index
>   */
> -static void kvm_pmu_disable_counter(struct kvm_vcpu *vcpu, u64 select_idx)
> +static void kvm_pmu_disable_counter_pair(struct kvm_vcpu *vcpu, u64 val,
> +					 u64 pair_low)
>  {
>  	struct kvm_pmu *pmu = &vcpu->arch.pmu;
> -	struct kvm_pmc *pmc = &pmu->pmc[select_idx];
> +	struct kvm_pmc *pmc_low = &pmu->pmc[pair_low];
> +	struct kvm_pmc *pmc_high = &pmu->pmc[pair_low + 1];
> +
> +	if (!kvm_pmu_event_is_chained(vcpu, pair_low)) {
> +		if (pmc_low->perf_event == pmc_high->perf_event) {
> +			if (pmc_low->perf_event) {
> +				kvm_pmu_stop_release_perf_event_pair(vcpu,
> +								pair_low);
> +				kvm_pmu_sync_counter_enable_pair(vcpu, pair_low);
> +			}
> +		}
> +	}
>  
> -	if (pmc->perf_event)
> -		perf_event_disable(pmc->perf_event);
> +	if (val & BIT(pair_low))
> +		kvm_pmu_disable_counter(vcpu, pair_low);
> +
> +	if (val & BIT(pair_low + 1))
> +		kvm_pmu_disable_counter(vcpu, pair_low + 1);
>  }
>  
>  /**
> @@ -230,12 +415,8 @@ void kvm_pmu_disable_counter_mask(struct kvm_vcpu *vcpu, u64 val)
>  	if (!val)
>  		return;
>  
> -	for (i = 0; i < ARMV8_PMU_MAX_COUNTERS; i++) {
> -		if (!(val & BIT(i)))
> -			continue;
> -
> -		kvm_pmu_disable_counter(vcpu, i);
> -	}
> +	for (i = 0; i < ARMV8_PMU_MAX_COUNTERS; i += 2)
> +		kvm_pmu_disable_counter_pair(vcpu, val, i);
>  }
>  
>  static u64 kvm_pmu_overflow_status(struct kvm_vcpu *vcpu)
> @@ -346,6 +527,17 @@ static void kvm_pmu_perf_overflow(struct perf_event *perf_event,
>  
>  	__vcpu_sys_reg(vcpu, PMOVSSET_EL0) |= BIT(idx);
>  
> +	if (kvm_pmu_event_is_chained(vcpu, idx)) {
> +		struct kvm_pmu *pmu = &vcpu->arch.pmu;
> +		struct kvm_pmc *pmc_high = &pmu->pmc[idx + 1];
> +
> +		if (!(--pmc_high->overflow_count)) {
> +			__vcpu_sys_reg(vcpu, PMOVSSET_EL0) |= BIT(idx + 1);
> +			pmc_high->overflow_count = U32_MAX + 1UL;
> +		}
> +
> +	}
> +
>  	if (kvm_pmu_overflow_status(vcpu)) {
>  		kvm_make_request(KVM_REQ_IRQ_PENDING, vcpu);
>  		kvm_vcpu_kick(vcpu);
> @@ -440,6 +632,10 @@ static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx)
>  	    select_idx != ARMV8_PMU_CYCLE_IDX)
>  		return;
>  
> +	/* Handled by even event */
> +	if (eventsel == ARMV8_PMUV3_PERFCTR_CHAIN)
> +		return;
> +
>  	memset(&attr, 0, sizeof(struct perf_event_attr));
>  	attr.type = PERF_TYPE_RAW;
>  	attr.size = sizeof(attr);
> @@ -452,6 +648,9 @@ static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx)
>  	attr.config = (select_idx == ARMV8_PMU_CYCLE_IDX) ?
>  		ARMV8_PMUV3_PERFCTR_CPU_CYCLES : eventsel;
>  
> +	if (kvm_pmu_event_is_chained(vcpu, select_idx))
> +		attr.config1 |= 0x1;

I'm not very familiar with the usage of perf attributes configs, but is
there any chance we could name this flag? Even if only for the local
file? Something like PERF_ATTR_CFG1_KVM_PMU_CHAINED (unless there is an
existing naming convention for event attributes).

Thanks,

-- 
Julien Thierry
