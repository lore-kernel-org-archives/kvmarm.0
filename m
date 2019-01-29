From: Julien Thierry <julien.thierry@arm.com>
Subject: Re: [PATCH 4/4] KVM: arm/arm64: support chained PMU counters
Date: Tue, 29 Jan 2019 09:07:58 +0000
Message-ID: <63d34a64-0a6a-d6fa-55b4-103fd4ca16e7@arm.com>
References: <1548154197-5470-1-git-send-email-andrew.murray@arm.com>
 <1548154197-5470-5-git-send-email-andrew.murray@arm.com>
 <75737475-4013-65a5-dc80-af6ec35868f9@arm.com>
 <20190128171331.GD16627@e119886-lin.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 41D224A321
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Jan 2019 04:08:03 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RfOiQflvdlTE for <kvmarm@lists.cs.columbia.edu>;
 Tue, 29 Jan 2019 04:08:01 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7CBF44A2BE
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Jan 2019 04:08:01 -0500 (EST)
In-Reply-To: <20190128171331.GD16627@e119886-lin.cambridge.arm.com>
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
To: Andrew Murray <andrew.murray@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu



On 28/01/2019 17:13, Andrew Murray wrote:
> On Tue, Jan 22, 2019 at 02:59:48PM +0000, Julien Thierry wrote:
>> Hi Andrew
>>
>> On 22/01/2019 10:49, Andrew Murray wrote:
>>> Emulate chained PMU counters by creating a single 64 bit event counter
>>> for a pair of chained KVM counters.
>>>
>>> Signed-off-by: Andrew Murray <andrew.murray@arm.com>
>>> ---
>>>  include/kvm/arm_pmu.h |   2 +
>>>  virt/kvm/arm/pmu.c    | 308 +++++++++++++++++++++++++++++++++++++++++---------
>>>  2 files changed, 258 insertions(+), 52 deletions(-)
>>>
>>> diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
>>> index f87fe20..d4f3b28 100644
>>> --- a/include/kvm/arm_pmu.h
>>> +++ b/include/kvm/arm_pmu.h
>>> @@ -29,6 +29,8 @@ struct kvm_pmc {
>>>  	u8 idx;	/* index into the pmu->pmc array */
>>>  	struct perf_event *perf_event;
>>>  	u64 bitmask;
>>> +	u64 sample_period;
>>> +	u64 left;
>>>  };
>>>  
>>>  struct kvm_pmu {
>>> diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
>>> index 1921ca9..d111d5b 100644
>>> --- a/virt/kvm/arm/pmu.c
>>> +++ b/virt/kvm/arm/pmu.c
>>> @@ -24,10 +24,26 @@
>>>  #include <kvm/arm_pmu.h>
>>>  #include <kvm/arm_vgic.h>
>>>  
>>> +#define ARMV8_PMUV3_PERFCTR_CHAIN 0x1E
>>> +static void kvm_pmu_stop_release_perf_event_pair(struct kvm_vcpu *vcpu,
>>> +					    u64 pair_low);
>>> +static void kvm_pmu_stop_release_perf_event_single(struct kvm_vcpu *vcpu,
>>> +					      u64 select_idx);
>>> +static void kvm_pmu_reenable_enabled_pair(struct kvm_vcpu *vcpu, u64 pair_low);
>>>  static void kvm_pmu_reenable_enabled_single(struct kvm_vcpu *vcpu, u64 pair);
>>>  static void kvm_pmu_counter_create_enabled_perf_event(struct kvm_vcpu *vcpu,
>>>  						      u64 select_idx);
>>> -static void kvm_pmu_stop_counter(struct kvm_vcpu *vcpu, struct kvm_pmc *pmc);
>>> +
>>> +/**
>>> + * kvm_pmu_counter_is_high_word - is select_idx high counter of 64bit event
>>> + * @pmc: The PMU counter pointer
>>> + * @select_idx: The counter index
>>> + */
>>> +static inline bool kvm_pmu_counter_is_high_word(struct kvm_pmc *pmc)
>>> +{
>>> +	return ((pmc->perf_event->attr.config1 & 0x1)
>>> +		&& (pmc->idx % 2));
>>> +}
>>>  
>>>  /**
>>>   * kvm_pmu_get_counter_value - get PMU counter value
>>> @@ -36,7 +52,7 @@ static void kvm_pmu_stop_counter(struct kvm_vcpu *vcpu, struct kvm_pmc *pmc);
>>>   */
>>>  u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx)
>>>  {
>>> -	u64 counter, reg, enabled, running;
>>> +	u64 counter, reg, enabled, running, incr;
>>>  	struct kvm_pmu *pmu = &vcpu->arch.pmu;
>>>  	struct kvm_pmc *pmc = &pmu->pmc[select_idx];
>>>  
>>> @@ -47,14 +63,53 @@ u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx)
>>>  	/* The real counter value is equal to the value of counter register plus
>>>  	 * the value perf event counts.
>>>  	 */
>>> -	if (pmc->perf_event)
>>> -		counter += perf_event_read_value(pmc->perf_event, &enabled,
>>> +	if (pmc->perf_event) {
>>> +		incr = perf_event_read_value(pmc->perf_event, &enabled,
>>>  						 &running);
>>>  
>>> +		if (kvm_pmu_counter_is_high_word(pmc))
>>> +			incr = upper_32_bits(incr);
>>> +		counter += incr;
>>> +	}
>>> +
>>>  	return counter & pmc->bitmask;
>>>  }
>>>  
>>>  /**
>>> + * kvm_pmu_counter_is_enabled - is a counter active
>>> + * @vcpu: The vcpu pointer
>>> + * @select_idx: The counter index
>>> + */
>>> +static bool kvm_pmu_counter_is_enabled(struct kvm_vcpu *vcpu, u64 select_idx)
>>> +{
>>> +	u64 mask = kvm_pmu_valid_counter_mask(vcpu);
>>> +
>>> +	return (__vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMU_PMCR_E) &&
>>> +	       (__vcpu_sys_reg(vcpu, PMCNTENSET_EL0) & mask & BIT(select_idx));
>>> +}
>>> +
>>> +/**
>>> + * kvnm_pmu_event_is_chained - is a pair of counters chained and enabled
>>> + * @vcpu: The vcpu pointer
>>> + * @select_idx: The low counter index
>>> + */
>>> +static bool kvm_pmu_event_is_chained(struct kvm_vcpu *vcpu, u64 pair_low)
>>> +{
>>> +	u64 eventsel;
>>> +
>>> +	eventsel = __vcpu_sys_reg(vcpu, PMEVTYPER0_EL0 + pair_low + 1) &
>>> +			ARMV8_PMU_EVTYPE_EVENT;
>>> +	if (eventsel != ARMV8_PMUV3_PERFCTR_CHAIN)
>>> +		return false;
>>> +
>>> +	if (kvm_pmu_counter_is_enabled(vcpu, pair_low) !=
>>> +	    kvm_pmu_counter_is_enabled(vcpu, pair_low + 1))
>>> +		return false;
>>> +
>>> +	return true;
>>> +}
>>> +
>>> +/**
>>>   * kvm_pmu_set_counter_value - set PMU counter value
>>>   * @vcpu: The vcpu pointer
>>>   * @select_idx: The counter index
>>> @@ -62,29 +117,45 @@ u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx)
>>>   */
>>>  void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu, u64 select_idx, u64 val)
>>>  {
>>> -	u64 reg;
>>> -	struct kvm_pmu *pmu = &vcpu->arch.pmu;
>>> -	struct kvm_pmc *pmc = &pmu->pmc[select_idx];
>>> +	u64 reg, pair_low;
>>>  
>>>  	reg = (select_idx == ARMV8_PMU_CYCLE_IDX)
>>>  	      ? PMCCNTR_EL0 : PMEVCNTR0_EL0 + select_idx;
>>>  	__vcpu_sys_reg(vcpu, reg) += (s64)val - kvm_pmu_get_counter_value(vcpu, select_idx);
>>>  
>>> -	kvm_pmu_stop_counter(vcpu, pmc);
>>> -	kvm_pmu_reenable_enabled_single(vcpu, select_idx);
>>> +	pair_low = (select_idx % 2) ? select_idx - 1 : select_idx;
>>
>> Don't really know if it's better but you can write it as:
>>
>> 	pair_low = select_idx & ~(1ULL);
>>
>> But the compiler might already optimize it.
>>
> 
> That's quite neat, though I'll leave it as it is, that seems clearer to me.
> 
>>> +
>>> +	/* Recreate the perf event to reflect the updated sample_period */
>>> +	if (kvm_pmu_event_is_chained(vcpu, pair_low)) {
>>> +		kvm_pmu_stop_release_perf_event_pair(vcpu, pair_low);
>>> +		kvm_pmu_reenable_enabled_pair(vcpu, pair_low);
>>> +	} else {
>>> +		kvm_pmu_stop_release_perf_event_single(vcpu, select_idx);
>>> +		kvm_pmu_reenable_enabled_single(vcpu, select_idx);
>>> +	}
>>>  }
>>>  
>>>  /**
>>>   * kvm_pmu_release_perf_event - remove the perf event
>>>   * @pmc: The PMU counter pointer
>>>   */
>>> -static void kvm_pmu_release_perf_event(struct kvm_pmc *pmc)
>>> +static void kvm_pmu_release_perf_event(struct kvm_vcpu *vcpu,
>>> +				       struct kvm_pmc *pmc)
>>>  {
>>> -	if (pmc->perf_event) {
>>> -		perf_event_disable(pmc->perf_event);
>>> +	struct kvm_pmu *pmu = &vcpu->arch.pmu;
>>> +	struct kvm_pmc *pmc_alt;
>>> +	u64 pair_alt;
>>> +
>>> +	pair_alt = (pmc->idx % 2) ? pmc->idx - 1 : pmc->idx + 1;
>>> +	pmc_alt = &pmu->pmc[pair_alt];
>>> +
>>> +	if (pmc->perf_event)
>>>  		perf_event_release_kernel(pmc->perf_event);
>>> -		pmc->perf_event = NULL;
>>> -	}
>>> +
>>> +	if (pmc->perf_event == pmc_alt->perf_event)
>>> +		pmc_alt->perf_event = NULL;
>>
>> Shouldn't we release pmc_alt->perf_event before setting it to NULL?
> 
> No, becuase these are the same event, we don't want to free the same
> event twice.
> 

Irrefutable logic, I don't know what I was thinking.

>>
>>> +
>>> +	pmc->perf_event = NULL;
>>>  }
>>>  
>>>  /**
>>> @@ -92,22 +163,60 @@ static void kvm_pmu_release_perf_event(struct kvm_pmc *pmc)
>>>   * @vcpu: The vcpu pointer
>>>   * @pmc: The PMU counter pointer
>>>   *
>>> - * If this counter has been configured to monitor some event, release it here.
>>> + * If this counter has been configured to monitor some event, stop it here.
>>>   */
>>>  static void kvm_pmu_stop_counter(struct kvm_vcpu *vcpu, struct kvm_pmc *pmc)
>>>  {
>>>  	u64 counter, reg;
>>>  
>>>  	if (pmc->perf_event) {
>>> +		perf_event_disable(pmc->perf_event);
>>>  		counter = kvm_pmu_get_counter_value(vcpu, pmc->idx);
>>>  		reg = (pmc->idx == ARMV8_PMU_CYCLE_IDX)
>>>  		       ? PMCCNTR_EL0 : PMEVCNTR0_EL0 + pmc->idx;
>>>  		__vcpu_sys_reg(vcpu, reg) = counter;
>>> -		kvm_pmu_release_perf_event(pmc);
>>>  	}
>>>  }
>>>  
>>>  /**
>>> + * kvm_pmu_stop_release_perf_event_pair - stop and release a pair of counters
>>> + * @vcpu: The vcpu pointer
>>> + * @pmc_low: The PMU counter pointer for lower word
>>> + * @pmc_high: The PMU counter pointer for higher word
>>> + *
>>> + * As chained counters share the underlying perf event, we stop them
>>> + * both first before discarding the underlying perf event
>>> + */
>>> +static void kvm_pmu_stop_release_perf_event_pair(struct kvm_vcpu *vcpu,
>>> +					    u64 idx_low)
>>> +{
>>> +	struct kvm_pmu *pmu = &vcpu->arch.pmu;
>>> +	struct kvm_pmc *pmc_low = &pmu->pmc[idx_low];
>>> +	struct kvm_pmc *pmc_high = &pmu->pmc[idx_low + 1];
>>> +
>>> +	kvm_pmu_stop_counter(vcpu, pmc_low);
>>> +	kvm_pmu_stop_counter(vcpu, pmc_high);
>>> +
>>> +	kvm_pmu_release_perf_event(vcpu, pmc_low);
>>> +	kvm_pmu_release_perf_event(vcpu, pmc_high);
>>
>> Hmmm, I think there is some confusion between what this function and
>> kvm_pmu_release_perf_event() should do, at this point
>> pmc_high->perf_event == NULL and we can't release it.
>>
> 
> Don't forget that for paired events, both pmc_{low,high} refer to the
> same perf_event. (This is why we stop the counters individually before
> releasing them - so that we can use the event information whilst working
> out the counter value of pmc_high).
> 
> Or is there something I'm missing?
>  

No, I think I'm the one who got confused between chained registers and
the fact that we try to enable counters two by two.

It's probably best to ignore my comments concerning the release event
stuff :) .

Thanks for explaining.

Cheers,

-- 
Julien Thierry
