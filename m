From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3 6/6] KVM: arm/arm64: support chained PMU counters
Date: Wed, 20 Feb 2019 13:36:59 +0000
Message-ID: <20190220133659.76a19f7d@why.wild-wind.fr.eu.org>
References: <1550497684-26046-1-git-send-email-andrew.murray@arm.com>
 <1550497684-26046-7-git-send-email-andrew.murray@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 669084A2E7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Feb 2019 08:37:10 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id V20+cmpXZcZk for <kvmarm@lists.cs.columbia.edu>;
 Wed, 20 Feb 2019 08:37:08 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0C34E4A1FA
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Feb 2019 08:37:07 -0500 (EST)
In-Reply-To: <1550497684-26046-7-git-send-email-andrew.murray@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Murray <andrew.murray@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, 18 Feb 2019 13:48:04 +0000
Andrew Murray <andrew.murray@arm.com> wrote:

> Emulate chained PMU counters by creating a single 64 bit event counter
> for a pair of chained KVM counters.
> 
> Signed-off-by: Andrew Murray <andrew.murray@arm.com>
> ---
>  include/kvm/arm_pmu.h |   1 +
>  virt/kvm/arm/pmu.c    | 322 +++++++++++++++++++++++++++++++++++++++++---------
>  2 files changed, 270 insertions(+), 53 deletions(-)
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
> index 524b27f..2852dc4 100644
> --- a/virt/kvm/arm/pmu.c
> +++ b/virt/kvm/arm/pmu.c
> @@ -24,9 +24,26 @@
>  #include <kvm/arm_pmu.h>
>  #include <kvm/arm_vgic.h>
>  
> +static void kvm_pmu_stop_release_perf_event_pair(struct kvm_vcpu *vcpu,
> +					    u64 pair_low);
> +static void kvm_pmu_stop_release_perf_event(struct kvm_vcpu *vcpu,
> +					      u64 select_idx);
> +static void kvm_pmu_sync_counter_enable_pair(struct kvm_vcpu *vcpu, u64 pair_low);
>  static void kvm_pmu_sync_counter_enable(struct kvm_vcpu *vcpu, u64 select_idx);
>  static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx);
> -static void kvm_pmu_stop_counter(struct kvm_vcpu *vcpu, struct kvm_pmc *pmc);
> +
> +#define PERF_ATTR_CFG1_KVM_PMU_CHAINED 0x1
> +
> +/**
> + * kvm_pmu_counter_is_high_word - is select_idx high counter of 64bit event
> + * @pmc: The PMU counter pointer
> + * @select_idx: The counter index

What is select_idx here?

> + */
> +static inline bool kvm_pmu_counter_is_high_word(struct kvm_pmc *pmc)
> +{
> +	return ((pmc->perf_event->attr.config1 & PERF_ATTR_CFG1_KVM_PMU_CHAINED)
> +		&& (pmc->idx % 2));

nit: This is usually expressed as 'idx & 1', but that's not a big deal.

> +}
>  
>  /**
>   * kvm_pmu_get_counter_value - get PMU counter value
> @@ -35,22 +52,70 @@ static void kvm_pmu_stop_counter(struct kvm_vcpu *vcpu, struct kvm_pmc *pmc);
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

Sorry, but the _idx suffix is baffling. What you seem to have here is a
counter value, not an index. 'counter' was the right name.

>  
>  	/* The real counter value is equal to the value of counter register plus
>  	 * the value perf event counts.
>  	 */
> -	if (pmc->perf_event)
> -		counter += perf_event_read_value(pmc->perf_event, &enabled,
> +	if (pmc->perf_event) {
> +		incr = perf_event_read_value(pmc->perf_event, &enabled,
>  						 &running);

nit: please align the function arguments.

>  
> -	return counter & pmc->bitmask;
> +		if (kvm_pmu_counter_is_high_word(pmc)) {
> +			u64 counter_low, counter;
> +
> +			reg = (select_idx == ARMV8_PMU_CYCLE_IDX)
> +			      ? PMCCNTR_EL0 : PMEVCNTR0_EL0 + select_idx - 1;

Why do you cater for the cycle counter here? It would feel wrong if we
could reach this code with the cycle counter, given that it is 64bit
and doesn't need any of this.

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

Again, what does chaining with the cycle counter mean? You shouldn't be
able to get here if pair_low >= 30.

> +	eventsel = __vcpu_sys_reg(vcpu, reg) & ARMV8_PMU_EVTYPE_EVENT;
> +	if (!armv8pmu_evtype_is_chain(eventsel))
> +		return false;

OK, so this works with the cycle counter only because
PMCCFILTR_EL0[15:0] are RES0. I'd expect something a bit more robust.

> +
> +	if (kvm_pmu_counter_is_enabled(vcpu, pair_low) !=
> +	    kvm_pmu_counter_is_enabled(vcpu, pair_low + 1))
> +		return false;
> +
> +	return true;
>  }
>  
>  /**
> @@ -61,29 +126,45 @@ u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx)
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

Let's get real:

	pair_low = select_idx & ~1UL;

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

Missing documentation update.

>   */
> -static void kvm_pmu_release_perf_event(struct kvm_pmc *pmc)
> +static void kvm_pmu_release_perf_event(struct kvm_vcpu *vcpu,
> +				       struct kvm_pmc *pmc)
>  {
> -	if (pmc->perf_event) {
> -		perf_event_disable(pmc->perf_event);
> +	struct kvm_pmu *pmu = &vcpu->arch.pmu;

The PMU structure is only a container_of away. See kvm_pmc_to_vcpu.

> +	struct kvm_pmc *pmc_alt;
> +	u64 pair_alt;
> +
> +	pair_alt = (pmc->idx % 2) ? pmc->idx - 1 : pmc->idx + 1;

	pair_alt = pmc->idx ^ 1;

> +	pmc_alt = &pmu->pmc[pair_alt];
> +
> +	if (pmc->perf_event)
>  		perf_event_release_kernel(pmc->perf_event);
> -		pmc->perf_event = NULL;
> -	}
> +
> +	if (pmc->perf_event == pmc_alt->perf_event)
> +		pmc_alt->perf_event = NULL;

Some people say that you shouldn't use pointers to memory that has
already been freed. I don't really care, but this code strikes be a
pretty fragile.

I'd rather see something like:

	if (pmc->perf_event) {
		if (pmc->perf_event == pmc_alt->perf_event)
			pmc_alt->perf_event = NULL;

		perf_event_release_kernel(pmc->perf_event);
		pmc->perf_event = NULL;
	}

which follows the current model, and doesn't mess with pointers post
release. I also wonder why you don't rely on the primitives you've
defined already (kvm_pmu_event_is_chained), and start reinventing it.

Another thing that strikes me as odd is that all of a sudden, you
start, dealing with this as full 64bit counter. Up to this point,
you've been looking at it as a two separate counters. Here, you deal
with both of them at once. I think this is a better approach, but
consistency is key.

> +
> +	pmc->perf_event = NULL;
>  }
>  
>  /**
> @@ -91,22 +172,65 @@ static void kvm_pmu_release_perf_event(struct kvm_pmc *pmc)
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

The ever changing semantics of these functions are becoming pretty
tedious to follow. I suggest you define the semantic of your choosing
early, and stick to it. This patch is only supposed to add 64bit
counter support, and seems to contain all kind of infrastructure bits
that should be better located in a separate patch.

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

Comment style (I think Christoffer mentioned this already).

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

OK, I definitely dislike this kind of construct. Why don't we have a
single 'stop_release' function that has deals with everything? You
already have the infrastructure. Use it to introduce some abstraction.

> +
> +/**
>   * kvm_pmu_vcpu_reset - reset pmu state for cpu
>   * @vcpu: The vcpu pointer
>   *
> @@ -117,7 +241,7 @@ void kvm_pmu_vcpu_reset(struct kvm_vcpu *vcpu)
>  	struct kvm_pmu *pmu = &vcpu->arch.pmu;
>  
>  	for (i = 0; i < ARMV8_PMU_MAX_COUNTERS; i++) {
> -		kvm_pmu_stop_counter(vcpu, &pmu->pmc[i]);
> +		kvm_pmu_stop_release_perf_event(vcpu, i);
>  		pmu->pmc[i].idx = i;
>  		pmu->pmc[i].bitmask = 0xffffffffUL;
>  	}
> @@ -134,7 +258,7 @@ void kvm_pmu_vcpu_destroy(struct kvm_vcpu *vcpu)
>  	struct kvm_pmu *pmu = &vcpu->arch.pmu;
>  
>  	for (i = 0; i < ARMV8_PMU_MAX_COUNTERS; i++)
> -		kvm_pmu_release_perf_event(&pmu->pmc[i]);
> +		kvm_pmu_release_perf_event(vcpu, &pmu->pmc[i]);
>  }
>  
>  u64 kvm_pmu_valid_counter_mask(struct kvm_vcpu *vcpu)
> @@ -167,53 +291,115 @@ static void kvm_pmu_enable_counter(struct kvm_vcpu *vcpu, u64 select_idx)
>  }
>  
>  /**
> + * kvm_pmu_sync_counter_enable - reenable a counter if it should be enabled

Why the 'if it should be enabled'? Shouldn't it be 'just do it'?

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

I find this double condition very odd. How can the second be false if
the first is true? Or rather, why does the first condition matter at
all?

> +	}
> +
> +	if (val & BIT(pair_low))
> +		kvm_pmu_enable_counter(vcpu, pair_low);
> +
> +	if (val & BIT(pair_low + 1))
> +		kvm_pmu_enable_counter(vcpu, pair_low + 1);
> +}
> +
> +/**
>   * kvm_pmu_enable_counter_mask - enable selected PMU counters
>   * @vcpu: The vcpu pointer
> - * @val: the value guest writes to PMCNTENSET register
> + * @val: the value guest writes to PMCNTENSET register or a subset

A subset? of what? from where?

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

Again, I find this construct troubling.

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
> @@ -230,12 +416,8 @@ void kvm_pmu_disable_counter_mask(struct kvm_vcpu *vcpu, u64 val)
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

If disable_counter() was 64bit aware, we shouldn't need any of this.

>  }
>  
>  static u64 kvm_pmu_overflow_status(struct kvm_vcpu *vcpu)
> @@ -346,6 +528,17 @@ static void kvm_pmu_perf_overflow(struct perf_event *perf_event,
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
> @@ -442,6 +635,10 @@ static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx)
>  	    select_idx != ARMV8_PMU_CYCLE_IDX)
>  		return;
>  
> +	/* Handled by even event */
> +	if (armv8pmu_evtype_is_chain(eventsel))
> +		return;
> +
>  	memset(&attr, 0, sizeof(struct perf_event_attr));
>  	attr.type = PERF_TYPE_RAW;
>  	attr.size = sizeof(attr);
> @@ -454,6 +651,9 @@ static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx)
>  	attr.config = (select_idx == ARMV8_PMU_CYCLE_IDX) ?
>  		ARMV8_PMUV3_PERFCTR_CPU_CYCLES : eventsel;
>  
> +	if (kvm_pmu_event_is_chained(vcpu, select_idx))
> +		attr.config1 |= PERF_ATTR_CFG1_KVM_PMU_CHAINED;
> +
>  	counter = kvm_pmu_get_counter_value(vcpu, select_idx);
>  	/* The initial sample period (overflow count) of an event. */
>  	attr.sample_period = (-counter) & pmc->bitmask;
> @@ -466,6 +666,14 @@ static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx)
>  		return;
>  	}
>  
> +	if (kvm_pmu_event_is_chained(vcpu, select_idx)) {
> +		struct kvm_pmc *pmc_next = &pmu->pmc[select_idx + 1];
> +
> +		pmc_next->perf_event = event;
> +		counter = kvm_pmu_get_counter_value(vcpu, select_idx + 1);
> +		pmc_next->overflow_count = (-counter) & pmc->bitmask;
> +	}
> +
>  	pmc->perf_event = event;
>  }
>  
> @@ -482,17 +690,25 @@ static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx)
>  void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
>  				    u64 select_idx)
>  {
> -	struct kvm_pmu *pmu = &vcpu->arch.pmu;
> -	struct kvm_pmc *pmc = &pmu->pmc[select_idx];
> -	u64 reg, event_type = data & ARMV8_PMU_EVTYPE_MASK;
> -
> -	kvm_pmu_stop_counter(vcpu, pmc);
> +	u64 eventsel, event_type, pair_low, reg;
>  
>  	reg = (select_idx == ARMV8_PMU_CYCLE_IDX)
>  	      ? PMCCFILTR_EL0 : PMEVTYPER0_EL0 + select_idx;
>  
> -	__vcpu_sys_reg(vcpu, reg) = event_type;
> -	kvm_pmu_sync_counter_enable(vcpu, select_idx);
> +	eventsel = data & ARMV8_PMU_EVTYPE_EVENT;
> +	event_type = data & ARMV8_PMU_EVTYPE_MASK;
> +	pair_low = (select_idx % 2) ? select_idx - 1 : select_idx;
> +
> +	if (kvm_pmu_event_is_chained(vcpu, pair_low) ||
> +	    armv8pmu_evtype_is_chain(eventsel)) {
> +		kvm_pmu_stop_release_perf_event_pair(vcpu, pair_low);
> +		__vcpu_sys_reg(vcpu, reg) = event_type;
> +		kvm_pmu_sync_counter_enable_pair(vcpu, pair_low);
> +	} else {
> +		kvm_pmu_stop_release_perf_event(vcpu, pair_low);
> +		__vcpu_sys_reg(vcpu, reg) = event_type;
> +		kvm_pmu_sync_counter_enable(vcpu, pair_low);
> +	}
>  }
>  
>  bool kvm_arm_support_pmu_v3(void)

I've stopped early, as I think the way you handle pairs of register is
not completely right. There is a distinct lack of abstraction which
doesn't fill me with confidence, and the edge case of counter 30
requires some care.

I think you should rework this patch to work with a more generic view
of a counter, rather than trying to cram the single/dual counter in
every single place.

As it stands, I'm not planning to take this into 5.1. Hopefully you'll
have the time to rework it for 5.2.

Thanks,

	M.
-- 
Without deviation from the norm, progress is not possible.
