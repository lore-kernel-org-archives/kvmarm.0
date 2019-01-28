From: Andrew Murray <andrew.murray@arm.com>
Subject: Re: [PATCH 4/4] KVM: arm/arm64: support chained PMU counters
Date: Mon, 28 Jan 2019 17:13:31 +0000
Message-ID: <20190128171331.GD16627@e119886-lin.cambridge.arm.com>
References: <1548154197-5470-1-git-send-email-andrew.murray@arm.com>
 <1548154197-5470-5-git-send-email-andrew.murray@arm.com>
 <75737475-4013-65a5-dc80-af6ec35868f9@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BB6FF4A39E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Jan 2019 12:13:36 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xryq57xz8lZa for <kvmarm@lists.cs.columbia.edu>;
 Mon, 28 Jan 2019 12:13:34 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 998824A2BE
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Jan 2019 12:13:34 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <75737475-4013-65a5-dc80-af6ec35868f9@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Julien Thierry <julien.thierry@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Jan 22, 2019 at 02:59:48PM +0000, Julien Thierry wrote:
> Hi Andrew
> 
> On 22/01/2019 10:49, Andrew Murray wrote:
> > Emulate chained PMU counters by creating a single 64 bit event counter
> > for a pair of chained KVM counters.
> > 
> > Signed-off-by: Andrew Murray <andrew.murray@arm.com>
> > ---
> >  include/kvm/arm_pmu.h |   2 +
> >  virt/kvm/arm/pmu.c    | 308 +++++++++++++++++++++++++++++++++++++++++---------
> >  2 files changed, 258 insertions(+), 52 deletions(-)
> > 
> > diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
> > index f87fe20..d4f3b28 100644
> > --- a/include/kvm/arm_pmu.h
> > +++ b/include/kvm/arm_pmu.h
> > @@ -29,6 +29,8 @@ struct kvm_pmc {
> >  	u8 idx;	/* index into the pmu->pmc array */
> >  	struct perf_event *perf_event;
> >  	u64 bitmask;
> > +	u64 sample_period;
> > +	u64 left;
> >  };
> >  
> >  struct kvm_pmu {
> > diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
> > index 1921ca9..d111d5b 100644
> > --- a/virt/kvm/arm/pmu.c
> > +++ b/virt/kvm/arm/pmu.c
> > @@ -24,10 +24,26 @@
> >  #include <kvm/arm_pmu.h>
> >  #include <kvm/arm_vgic.h>
> >  
> > +#define ARMV8_PMUV3_PERFCTR_CHAIN 0x1E
> > +static void kvm_pmu_stop_release_perf_event_pair(struct kvm_vcpu *vcpu,
> > +					    u64 pair_low);
> > +static void kvm_pmu_stop_release_perf_event_single(struct kvm_vcpu *vcpu,
> > +					      u64 select_idx);
> > +static void kvm_pmu_reenable_enabled_pair(struct kvm_vcpu *vcpu, u64 pair_low);
> >  static void kvm_pmu_reenable_enabled_single(struct kvm_vcpu *vcpu, u64 pair);
> >  static void kvm_pmu_counter_create_enabled_perf_event(struct kvm_vcpu *vcpu,
> >  						      u64 select_idx);
> > -static void kvm_pmu_stop_counter(struct kvm_vcpu *vcpu, struct kvm_pmc *pmc);
> > +
> > +/**
> > + * kvm_pmu_counter_is_high_word - is select_idx high counter of 64bit event
> > + * @pmc: The PMU counter pointer
> > + * @select_idx: The counter index
> > + */
> > +static inline bool kvm_pmu_counter_is_high_word(struct kvm_pmc *pmc)
> > +{
> > +	return ((pmc->perf_event->attr.config1 & 0x1)
> > +		&& (pmc->idx % 2));
> > +}
> >  
> >  /**
> >   * kvm_pmu_get_counter_value - get PMU counter value
> > @@ -36,7 +52,7 @@ static void kvm_pmu_stop_counter(struct kvm_vcpu *vcpu, struct kvm_pmc *pmc);
> >   */
> >  u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx)
> >  {
> > -	u64 counter, reg, enabled, running;
> > +	u64 counter, reg, enabled, running, incr;
> >  	struct kvm_pmu *pmu = &vcpu->arch.pmu;
> >  	struct kvm_pmc *pmc = &pmu->pmc[select_idx];
> >  
> > @@ -47,14 +63,53 @@ u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx)
> >  	/* The real counter value is equal to the value of counter register plus
> >  	 * the value perf event counts.
> >  	 */
> > -	if (pmc->perf_event)
> > -		counter += perf_event_read_value(pmc->perf_event, &enabled,
> > +	if (pmc->perf_event) {
> > +		incr = perf_event_read_value(pmc->perf_event, &enabled,
> >  						 &running);
> >  
> > +		if (kvm_pmu_counter_is_high_word(pmc))
> > +			incr = upper_32_bits(incr);
> > +		counter += incr;
> > +	}
> > +
> >  	return counter & pmc->bitmask;
> >  }
> >  
> >  /**
> > + * kvm_pmu_counter_is_enabled - is a counter active
> > + * @vcpu: The vcpu pointer
> > + * @select_idx: The counter index
> > + */
> > +static bool kvm_pmu_counter_is_enabled(struct kvm_vcpu *vcpu, u64 select_idx)
> > +{
> > +	u64 mask = kvm_pmu_valid_counter_mask(vcpu);
> > +
> > +	return (__vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMU_PMCR_E) &&
> > +	       (__vcpu_sys_reg(vcpu, PMCNTENSET_EL0) & mask & BIT(select_idx));
> > +}
> > +
> > +/**
> > + * kvnm_pmu_event_is_chained - is a pair of counters chained and enabled
> > + * @vcpu: The vcpu pointer
> > + * @select_idx: The low counter index
> > + */
> > +static bool kvm_pmu_event_is_chained(struct kvm_vcpu *vcpu, u64 pair_low)
> > +{
> > +	u64 eventsel;
> > +
> > +	eventsel = __vcpu_sys_reg(vcpu, PMEVTYPER0_EL0 + pair_low + 1) &
> > +			ARMV8_PMU_EVTYPE_EVENT;
> > +	if (eventsel != ARMV8_PMUV3_PERFCTR_CHAIN)
> > +		return false;
> > +
> > +	if (kvm_pmu_counter_is_enabled(vcpu, pair_low) !=
> > +	    kvm_pmu_counter_is_enabled(vcpu, pair_low + 1))
> > +		return false;
> > +
> > +	return true;
> > +}
> > +
> > +/**
> >   * kvm_pmu_set_counter_value - set PMU counter value
> >   * @vcpu: The vcpu pointer
> >   * @select_idx: The counter index
> > @@ -62,29 +117,45 @@ u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx)
> >   */
> >  void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu, u64 select_idx, u64 val)
> >  {
> > -	u64 reg;
> > -	struct kvm_pmu *pmu = &vcpu->arch.pmu;
> > -	struct kvm_pmc *pmc = &pmu->pmc[select_idx];
> > +	u64 reg, pair_low;
> >  
> >  	reg = (select_idx == ARMV8_PMU_CYCLE_IDX)
> >  	      ? PMCCNTR_EL0 : PMEVCNTR0_EL0 + select_idx;
> >  	__vcpu_sys_reg(vcpu, reg) += (s64)val - kvm_pmu_get_counter_value(vcpu, select_idx);
> >  
> > -	kvm_pmu_stop_counter(vcpu, pmc);
> > -	kvm_pmu_reenable_enabled_single(vcpu, select_idx);
> > +	pair_low = (select_idx % 2) ? select_idx - 1 : select_idx;
> 
> Don't really know if it's better but you can write it as:
> 
> 	pair_low = select_idx & ~(1ULL);
> 
> But the compiler might already optimize it.
> 

That's quite neat, though I'll leave it as it is, that seems clearer to me.

> > +
> > +	/* Recreate the perf event to reflect the updated sample_period */
> > +	if (kvm_pmu_event_is_chained(vcpu, pair_low)) {
> > +		kvm_pmu_stop_release_perf_event_pair(vcpu, pair_low);
> > +		kvm_pmu_reenable_enabled_pair(vcpu, pair_low);
> > +	} else {
> > +		kvm_pmu_stop_release_perf_event_single(vcpu, select_idx);
> > +		kvm_pmu_reenable_enabled_single(vcpu, select_idx);
> > +	}
> >  }
> >  
> >  /**
> >   * kvm_pmu_release_perf_event - remove the perf event
> >   * @pmc: The PMU counter pointer
> >   */
> > -static void kvm_pmu_release_perf_event(struct kvm_pmc *pmc)
> > +static void kvm_pmu_release_perf_event(struct kvm_vcpu *vcpu,
> > +				       struct kvm_pmc *pmc)
> >  {
> > -	if (pmc->perf_event) {
> > -		perf_event_disable(pmc->perf_event);
> > +	struct kvm_pmu *pmu = &vcpu->arch.pmu;
> > +	struct kvm_pmc *pmc_alt;
> > +	u64 pair_alt;
> > +
> > +	pair_alt = (pmc->idx % 2) ? pmc->idx - 1 : pmc->idx + 1;
> > +	pmc_alt = &pmu->pmc[pair_alt];
> > +
> > +	if (pmc->perf_event)
> >  		perf_event_release_kernel(pmc->perf_event);
> > -		pmc->perf_event = NULL;
> > -	}
> > +
> > +	if (pmc->perf_event == pmc_alt->perf_event)
> > +		pmc_alt->perf_event = NULL;
> 
> Shouldn't we release pmc_alt->perf_event before setting it to NULL?

No, becuase these are the same event, we don't want to free the same
event twice.

> 
> > +
> > +	pmc->perf_event = NULL;
> >  }
> >  
> >  /**
> > @@ -92,22 +163,60 @@ static void kvm_pmu_release_perf_event(struct kvm_pmc *pmc)
> >   * @vcpu: The vcpu pointer
> >   * @pmc: The PMU counter pointer
> >   *
> > - * If this counter has been configured to monitor some event, release it here.
> > + * If this counter has been configured to monitor some event, stop it here.
> >   */
> >  static void kvm_pmu_stop_counter(struct kvm_vcpu *vcpu, struct kvm_pmc *pmc)
> >  {
> >  	u64 counter, reg;
> >  
> >  	if (pmc->perf_event) {
> > +		perf_event_disable(pmc->perf_event);
> >  		counter = kvm_pmu_get_counter_value(vcpu, pmc->idx);
> >  		reg = (pmc->idx == ARMV8_PMU_CYCLE_IDX)
> >  		       ? PMCCNTR_EL0 : PMEVCNTR0_EL0 + pmc->idx;
> >  		__vcpu_sys_reg(vcpu, reg) = counter;
> > -		kvm_pmu_release_perf_event(pmc);
> >  	}
> >  }
> >  
> >  /**
> > + * kvm_pmu_stop_release_perf_event_pair - stop and release a pair of counters
> > + * @vcpu: The vcpu pointer
> > + * @pmc_low: The PMU counter pointer for lower word
> > + * @pmc_high: The PMU counter pointer for higher word
> > + *
> > + * As chained counters share the underlying perf event, we stop them
> > + * both first before discarding the underlying perf event
> > + */
> > +static void kvm_pmu_stop_release_perf_event_pair(struct kvm_vcpu *vcpu,
> > +					    u64 idx_low)
> > +{
> > +	struct kvm_pmu *pmu = &vcpu->arch.pmu;
> > +	struct kvm_pmc *pmc_low = &pmu->pmc[idx_low];
> > +	struct kvm_pmc *pmc_high = &pmu->pmc[idx_low + 1];
> > +
> > +	kvm_pmu_stop_counter(vcpu, pmc_low);
> > +	kvm_pmu_stop_counter(vcpu, pmc_high);
> > +
> > +	kvm_pmu_release_perf_event(vcpu, pmc_low);
> > +	kvm_pmu_release_perf_event(vcpu, pmc_high);
> 
> Hmmm, I think there is some confusion between what this function and
> kvm_pmu_release_perf_event() should do, at this point
> pmc_high->perf_event == NULL and we can't release it.
>

Don't forget that for paired events, both pmc_{low,high} refer to the
same perf_event. (This is why we stop the counters individually before
releasing them - so that we can use the event information whilst working
out the counter value of pmc_high).

Or is there something I'm missing?
 
> > +}
> > +
> > +/**
> > + * kvm_pmu_stop_release_perf_event_single - stop and release a counter
> > + * @vcpu: The vcpu pointer
> > + * @select_idx: The counter index
> > + */
> > +static void kvm_pmu_stop_release_perf_event_single(struct kvm_vcpu *vcpu,
> > +					      u64 select_idx)
> > +{
> > +	struct kvm_pmu *pmu = &vcpu->arch.pmu;
> > +	struct kvm_pmc *pmc = &pmu->pmc[select_idx];
> > +
> > +	kvm_pmu_stop_counter(vcpu, pmc);
> > +	kvm_pmu_release_perf_event(vcpu, pmc);
> > +}
> > +
> > +/**
> >   * kvm_pmu_vcpu_reset - reset pmu state for cpu
> >   * @vcpu: The vcpu pointer
> >   *
> > @@ -118,7 +227,7 @@ void kvm_pmu_vcpu_reset(struct kvm_vcpu *vcpu)
> >  	struct kvm_pmu *pmu = &vcpu->arch.pmu;
> >  
> >  	for (i = 0; i < ARMV8_PMU_MAX_COUNTERS; i++) {
> > -		kvm_pmu_stop_counter(vcpu, &pmu->pmc[i]);
> > +		kvm_pmu_stop_release_perf_event_single(vcpu, i);
> >  		pmu->pmc[i].idx = i;
> >  		pmu->pmc[i].bitmask = 0xffffffffUL;
> >  	}
> > @@ -136,7 +245,7 @@ void kvm_pmu_vcpu_destroy(struct kvm_vcpu *vcpu)
> >  
> >  	for (i = 0; i < ARMV8_PMU_MAX_COUNTERS; i++) {
> >  		struct kvm_pmc *pmc = &pmu->pmc[i];
> > -		kvm_pmu_release_perf_event(pmc);
> > +		kvm_pmu_release_perf_event(vcpu, pmc);
> >  	}
> >  }
> >  
> > @@ -171,49 +280,81 @@ static void kvm_pmu_enable_counter_single(struct kvm_vcpu *vcpu, u64 select_idx)
> >  }
> >  
> >  /**
> > - * kvm_pmu_enable_counter - enable selected PMU counter
> > + * kvm_pmu_reenable_enabled_single - reenable a counter if it should be enabled
> >   * @vcpu: The vcpu pointer
> > - * @val: the value guest writes to PMCNTENSET register
> > - *
> > - * Call perf_event_enable to start counting the perf event
> > + * @select_idx: The counter index
> >   */
> > -void kvm_pmu_enable_counter(struct kvm_vcpu *vcpu, u64 val)
> > +static void kvm_pmu_reenable_enabled_single(struct kvm_vcpu *vcpu,
> > +					    u64 select_idx)
> >  {
> > -	int i;
> > +	u64 mask = kvm_pmu_valid_counter_mask(vcpu);
> > +	u64 set = __vcpu_sys_reg(vcpu, PMCNTENSET_EL0) & mask;
> >  
> > -	if (!(__vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMU_PMCR_E) || !val)
> > +	if (!(__vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMU_PMCR_E))
> >  		return;
> >  
> > -	for (i = 0; i < ARMV8_PMU_MAX_COUNTERS; i++) {
> > -		if (!(val & BIT(i)))
> > -			continue;
> > +	if (set & BIT(select_idx))
> > +		kvm_pmu_enable_counter_single(vcpu, select_idx);
> > +}
> >  
> > -		kvm_pmu_enable_counter_single(vcpu, i);
> > +/**
> > + * kvm_pmu_reenable_enabled_pair - reenable a pair if they should be enabled
> > + * @vcpu: The vcpu pointer
> > + * @pair_low: The low counter index
> > + */
> > +static void kvm_pmu_reenable_enabled_pair(struct kvm_vcpu *vcpu, u64 pair_low)
> > +{
> > +	kvm_pmu_reenable_enabled_single(vcpu, pair_low);
> > +	kvm_pmu_reenable_enabled_single(vcpu, pair_low+1);
> > +}
> > +
> > +/**
> > + * kvm_pmu_enable_counter_pair - enable counters pair at a time
> > + * @vcpu: The vcpu pointer
> > + * @val: counters to enable
> > + * @pair_low: The low counter index
> > + */
> > +static void kvm_pmu_enable_counter_pair(struct kvm_vcpu *vcpu, u64 val,
> > +					u64 pair_low)
> > +{
> > +	struct kvm_pmu *pmu = &vcpu->arch.pmu;
> > +	struct kvm_pmc *pmc_low = &pmu->pmc[pair_low];
> > +	struct kvm_pmc *pmc_high = &pmu->pmc[pair_low + 1];
> > +
> > +	if (kvm_pmu_event_is_chained(vcpu, pair_low)) {
> > +		if (pmc_low->perf_event != pmc_high->perf_event)
> > +			kvm_pmu_stop_release_perf_event_pair(vcpu, pair_low);
> >  	}
> > +
> > +	if (val & BIT(pair_low))
> > +		kvm_pmu_enable_counter_single(vcpu, pair_low);
> > +
> > +	if (val & BIT(pair_low+1))
> > +		kvm_pmu_enable_counter_single(vcpu, pair_low + 1);
> >  }
> >  
> >  /**
> > - * kvm_pmu_reenable_enabled_single - reenable a counter if it should be enabled
> > + * kvm_pmu_enable_counter - enable selected PMU counter
> >   * @vcpu: The vcpu pointer
> > - * @select_idx: The counter index
> > + * @val: the value guest writes to PMCNTENSET register
> > + *
> > + * Call perf_event_enable to start counting the perf event
> >   */
> > -static void kvm_pmu_reenable_enabled_single(struct kvm_vcpu *vcpu,
> > -					    u64 select_idx)
> > +void kvm_pmu_enable_counter(struct kvm_vcpu *vcpu, u64 val)
> >  {
> > -	u64 mask = kvm_pmu_valid_counter_mask(vcpu);
> > -	u64 set = __vcpu_sys_reg(vcpu, PMCNTENSET_EL0) & mask;
> > +	int i;
> >  
> > -	if (!(__vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMU_PMCR_E))
> > +	if (!(__vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMU_PMCR_E) || !val)
> >  		return;
> >  
> > -	if (set & BIT(select_idx))
> > -		kvm_pmu_enable_counter_single(vcpu, select_idx);
> > +	for (i = 0; i < ARMV8_PMU_MAX_COUNTERS; i += 2)
> > +		kvm_pmu_enable_counter_pair(vcpu, val, i);
> >  }
> >  
> >  /**
> >   * kvm_pmu_disable_counter - disable selected PMU counter
> >   * @vcpu: The vcpu pointer
> > - * @pmc: The counter to dissable
> > + * @select_idx: The counter index
> >   */
> >  static void kvm_pmu_disable_counter_single(struct kvm_vcpu *vcpu,
> >  					   u64 select_idx)
> > @@ -221,8 +362,40 @@ static void kvm_pmu_disable_counter_single(struct kvm_vcpu *vcpu,
> >  	struct kvm_pmu *pmu = &vcpu->arch.pmu;
> >  	struct kvm_pmc *pmc = &pmu->pmc[select_idx];
> >  
> > -	if (pmc->perf_event)
> > +	if (pmc->perf_event) {
> >  		perf_event_disable(pmc->perf_event);
> > +		if (pmc->perf_event->state != PERF_EVENT_STATE_ACTIVE)
> > +			kvm_debug("fail to enable perf event\n");
> > +	}
> > +}
> > +
> > +/**
> > + * kvm_pmu_disable_counter_pair - disable counters pair at a time
> > + * @val: counters to disable
> > + * @pair_low: The low counter index
> > + */
> > +static void kvm_pmu_disable_counter_pair(struct kvm_vcpu *vcpu, u64 val,
> > +					 u64 pair_low)
> > +{
> > +	struct kvm_pmu *pmu = &vcpu->arch.pmu;
> > +	struct kvm_pmc *pmc_low = &pmu->pmc[pair_low];
> > +	struct kvm_pmc *pmc_high = &pmu->pmc[pair_low + 1];
> > +
> > +	if (!kvm_pmu_event_is_chained(vcpu, pair_low)) {
> > +		if (pmc_low->perf_event == pmc_high->perf_event) {
> > +			if (pmc_low->perf_event) {
> > +				kvm_pmu_stop_release_perf_event_pair(vcpu,
> > +								pair_low);
> > +				kvm_pmu_reenable_enabled_pair(vcpu, pair_low);
> > +			}
> > +		}
> > +	}
> > +
> > +	if (val & BIT(pair_low))
> > +		kvm_pmu_disable_counter_single(vcpu, pair_low);
> > +
> > +	if (val & BIT(pair_low + 1))
> > +		kvm_pmu_disable_counter_single(vcpu, pair_low + 1);
> >  }
> >  
> >  /**
> > @@ -239,12 +412,8 @@ void kvm_pmu_disable_counter(struct kvm_vcpu *vcpu, u64 val)
> >  	if (!val)
> >  		return;
> >  
> > -	for (i = 0; i < ARMV8_PMU_MAX_COUNTERS; i++) {
> > -		if (!(val & BIT(i)))
> > -			continue;
> > -
> > -		kvm_pmu_disable_counter_single(vcpu, i);
> > -	}
> > +	for (i = 0; i < ARMV8_PMU_MAX_COUNTERS; i += 2)
> > +		kvm_pmu_disable_counter_pair(vcpu, val, i);
> >  }
> >  
> >  static u64 kvm_pmu_overflow_status(struct kvm_vcpu *vcpu)
> > @@ -355,6 +524,17 @@ static void kvm_pmu_perf_overflow(struct perf_event *perf_event,
> >  
> >  	__vcpu_sys_reg(vcpu, PMOVSSET_EL0) |= BIT(idx);
> >  
> > +	if (kvm_pmu_event_is_chained(vcpu, idx + 1)) {
> 
> Doesn't kvm_pmu_event_is_chained() expect the low part of the counter pair?

Ah yes, good catch.

Thanks,

Andrew Murray

> 
> Cheers,
> 
> -- 
> Julien Thierry
