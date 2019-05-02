Return-Path: <SRS0=zWKl=TC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5985C43219
	for <kvmarm@archiver.kernel.org>; Thu,  2 May 2019 09:22:29 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 631322075E
	for <kvmarm@archiver.kernel.org>; Thu,  2 May 2019 09:22:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 631322075E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AC52F4A4B9;
	Thu,  2 May 2019 05:22:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id OVWD-XCe83bx; Thu,  2 May 2019 05:22:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CF0194A4F3;
	Thu,  2 May 2019 05:22:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E597D4A4C0
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 May 2019 05:22:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3q8XKovL-vHp for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 May 2019 05:22:24 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EA0434A4BF
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 May 2019 05:22:23 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 53AA5374;
 Thu,  2 May 2019 02:22:23 -0700 (PDT)
Received: from [10.1.197.45] (e112298-lin.cambridge.arm.com [10.1.197.45])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F39A33F5AF;
 Thu,  2 May 2019 02:22:20 -0700 (PDT)
Subject: Re: [PATCH v5 5/5] KVM: arm/arm64: support chained PMU counters
To: Andrew Murray <andrew.murray@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>,
 Marc Zyngier <marc.zyngier@arm.com>
References: <20190501163131.43175-1-andrew.murray@arm.com>
 <20190501163131.43175-6-andrew.murray@arm.com>
From: Julien Thierry <julien.thierry@arm.com>
Message-ID: <f5579140-9ec0-6ffe-78ff-c1cd757a4198@arm.com>
Date: Thu, 2 May 2019 10:22:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20190501163131.43175-6-andrew.murray@arm.com>
Content-Language: en-US
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
Message-ID: <20190502092218.0Ov8NikHW-9v4rPIEjHbBtJ-fPvaovyaTxyDekww3bc@z>

Hi Andrew,

I have a few remarks. I don't think it's anything major, nor that the
approach need to be changed.

On 01/05/2019 17:31, Andrew Murray wrote:
> ARMv8 provides support for chained PMU counters, where an event type
> of 0x001E is set for odd-numbered counters, the event counter will
> increment by one for each overflow of the preceding even-numbered
> counter. Let's emulate this in KVM by creating a 64 bit perf counter
> when a user chains two emulated counters together.
> 
> For chained events we only support generating an overflow interrupt
> on the high counter. We use the attributes of the low counter to
> determine the attributes of the perf event.
> 
> Suggested-by: Marc Zyngier <marc.zyngier@arm.com>
> Signed-off-by: Andrew Murray <andrew.murray@arm.com>
> ---
>  include/kvm/arm_pmu.h |   2 +
>  virt/kvm/arm/pmu.c    | 242 ++++++++++++++++++++++++++++++++++++------
>  2 files changed, 214 insertions(+), 30 deletions(-)
> 
> diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
> index b73f31baca52..8b434745500a 100644
> --- a/include/kvm/arm_pmu.h
> +++ b/include/kvm/arm_pmu.h
> @@ -22,6 +22,7 @@
>  #include <asm/perf_event.h>
>  
>  #define ARMV8_PMU_CYCLE_IDX		(ARMV8_PMU_MAX_COUNTERS - 1)
> +#define ARMV8_PMU_MAX_COUNTER_PAIRS	((ARMV8_PMU_MAX_COUNTERS + 1) >> 1)
>  
>  #ifdef CONFIG_KVM_ARM_PMU
>  
> @@ -34,6 +35,7 @@ struct kvm_pmc {
>  struct kvm_pmu {
>  	int irq_num;
>  	struct kvm_pmc pmc[ARMV8_PMU_MAX_COUNTERS];
> +	DECLARE_BITMAP(chained, ARMV8_PMU_MAX_COUNTER_PAIRS);
>  	bool ready;
>  	bool created;
>  	bool irq_level;
> diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
> index ae1e886d4a1a..91f098ca6b28 100644
> --- a/virt/kvm/arm/pmu.c
> +++ b/virt/kvm/arm/pmu.c
> @@ -25,28 +25,130 @@
>  #include <kvm/arm_vgic.h>
>  
>  static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx);
> +
> +#define PERF_ATTR_CFG1_KVM_PMU_CHAINED 0x1
> +
> +static struct kvm_vcpu *kvm_pmc_to_vcpu(struct kvm_pmc *pmc)> +{
> +	struct kvm_pmu *pmu;
> +	struct kvm_vcpu_arch *vcpu_arch;
> +
> +	pmc -= pmc->idx;
> +	pmu = container_of(pmc, struct kvm_pmu, pmc[0]);

Nit: The only caller of this seems to only require access to the pmu
that the pmc belongs to. So we could change the function and stop here.


> +	vcpu_arch = container_of(pmu, struct kvm_vcpu_arch, pmu);
> +	return container_of(vcpu_arch, struct kvm_vcpu, arch);
> +}
> +
>  /**
> - * kvm_pmu_get_counter_value - get PMU counter value
> + * kvm_pmu_pmc_is_chained - determine if the pmc is chained
> + * @pmc: The PMU counter pointer
> + */
> +static bool kvm_pmu_pmc_is_chained(struct kvm_pmc *pmc)
> +{
> +	struct kvm_vcpu *vcpu = kvm_pmc_to_vcpu(pmc);
> +
> +	return test_bit(pmc->idx >> 1, vcpu->arch.pmu.chained);
> +}
> +
> +/**
> + * kvm_pmu_pmc_is_high_counter - determine if select_idx is a high/low counter
> + * @select_idx: The counter index
> + */
> +static bool kvm_pmu_pmc_is_high_counter(u64 select_idx)
> +{
> +	return select_idx & 0x1;
> +}
> +
> +/**
> + * kvm_pmu_get_canonical_pmc - obtain the canonical pmc
> + * @pmc: The PMU counter pointer
> + *
> + * When a pair of PMCs are chained together we use the low counter (canonical)
> + * to hold the underlying perf event.
> + */
> +static struct kvm_pmc *kvm_pmu_get_canonical_pmc(struct kvm_pmc *pmc)
> +{
> +	if (kvm_pmu_pmc_is_chained(pmc) && (pmc->idx & 1))

Nit: It's a bit odd that you have that function right above that tests
if an index is high counter but don't use it here.

> +		return pmc - 1;
> +
> +	return pmc;
> +}
> +
> +/**
> + * kvm_pmu_event_is_chained - determine if the event type is chain
>   * @vcpu: The vcpu pointer
>   * @select_idx: The counter index
>   */
> -u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx)
> +static bool kvm_pmu_event_is_chained(struct kvm_vcpu *vcpu, u64 select_idx)

Nit: I found myself easily confused between kvm_pmu_event_is_chained()
and kvm_pmu_pmc_is_chained(). Naming is also a bit odd because
kvm_pmu_event_is_chained() doesn't operate on a perf_event.

Could we name it kvm_pmu_idx_has_chain_evtype() or
kvm_pmu_cnt_in_chain_evtype() ?

>  {
> -	u64 counter, reg, enabled, running;
> -	struct kvm_pmu *pmu = &vcpu->arch.pmu;
> -	struct kvm_pmc *pmc = &pmu->pmc[select_idx];
> +	u64 eventsel, reg;
>  
> -	reg = (select_idx == ARMV8_PMU_CYCLE_IDX)
> -	      ? PMCCNTR_EL0 : PMEVCNTR0_EL0 + select_idx;
> -	counter = __vcpu_sys_reg(vcpu, reg);
> +	select_idx |= 0x1;
> +
> +	if (select_idx == ARMV8_PMU_CYCLE_IDX)
> +		return false;
> +
> +	reg = PMEVTYPER0_EL0 + select_idx;
> +	eventsel = __vcpu_sys_reg(vcpu, reg) & ARMV8_PMU_EVTYPE_EVENT;
> +
> +	return armv8pmu_evtype_is_chain(eventsel);
> +}
> +
> +/**
> + * kvm_pmu_get_pair_counter_value - get PMU counter value
> + * @vcpu: The vcpu pointer
> + * @pmc: The PMU counter pointer
> + */
> +static u64 kvm_pmu_get_pair_counter_value(struct kvm_vcpu *vcpu,
> +					  struct kvm_pmc *pmc)
> +{
> +	u64 counter, counter_high, reg, enabled, running;
> +
> +	pmc = kvm_pmu_get_canonical_pmc(pmc);

kvm_pmu_pmc_is_chained() works both on the canonical and high counter
doesn't it? We could only "retrieve" the canonical one when we know we
have a chained counter.

Makes a bit less operations in the case of non-chained counters (modulo
compiler optimizations).

> +	if (kvm_pmu_pmc_is_chained(pmc)) {
> +		reg = PMEVCNTR0_EL0 + pmc->idx;
> +
> +		counter = __vcpu_sys_reg(vcpu, reg);
> +		counter_high = __vcpu_sys_reg(vcpu, reg + 1);
> +
> +		counter = lower_32_bits(counter) | (counter_high << 32);
> +	} else {
> +		reg = (pmc->idx == ARMV8_PMU_CYCLE_IDX)
> +		      ? PMCCNTR_EL0 : PMEVCNTR0_EL0 + pmc->idx;
> +		counter = __vcpu_sys_reg(vcpu, reg);
> +	}
>  
> -	/* The real counter value is equal to the value of counter register plus
> +	/*
> +	 * The real counter value is equal to the value of counter register plus
>  	 * the value perf event counts.
>  	 */
>  	if (pmc->perf_event)
>  		counter += perf_event_read_value(pmc->perf_event, &enabled,
>  						 &running);
>  
> +	if (!kvm_pmu_pmc_is_chained(pmc))
> +		counter &= pmc->bitmask;

This part seems a bit weird to me, especially since the mask is applied
unconditionally right after in kvm_pmu_get_counter_value(). (And is
applied as well for non-chained counters in the only other called of
this function).

Maybe we can drop this?

> +
> +	return counter;
> +}
> +
> +/**
> + * kvm_pmu_get_counter_value - get PMU counter value
> + * @vcpu: The vcpu pointer
> + * @select_idx: The counter index
> + */
> +u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx)
> +{
> +	u64 counter;
> +	struct kvm_pmu *pmu = &vcpu->arch.pmu;
> +	struct kvm_pmc *pmc = &pmu->pmc[select_idx];
> +
> +	counter = kvm_pmu_get_pair_counter_value(vcpu, pmc);
> +
> +	if (kvm_pmu_pmc_is_chained(pmc) &&
> +	    kvm_pmu_pmc_is_high_counter(select_idx))
> +		counter >>= 32;
> +
>  	return counter & pmc->bitmask;
>  }
>  
> @@ -74,6 +176,8 @@ void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu, u64 select_idx, u64 val)
>   */
>  static void kvm_pmu_release_perf_event(struct kvm_pmc *pmc)
>  {
> +	pmc = kvm_pmu_get_canonical_pmc(pmc);
> +
>  	if (pmc->perf_event) {
>  		perf_event_disable(pmc->perf_event);
>  		perf_event_release_kernel(pmc->perf_event);
> @@ -89,15 +193,27 @@ static void kvm_pmu_release_perf_event(struct kvm_pmc *pmc)
>   */
>  static void kvm_pmu_stop_counter(struct kvm_vcpu *vcpu, struct kvm_pmc *pmc)
>  {
> -	u64 counter, reg;
> +	u64 counter, counter_low, counter_high, reg;
>  
> -	if (pmc->perf_event) {
> +	pmc = kvm_pmu_get_canonical_pmc(pmc);
> +	if (!pmc->perf_event)
> +		return;
> +
> +	if (kvm_pmu_pmc_is_chained(pmc)) {
> +		counter_low = kvm_pmu_get_counter_value(vcpu, pmc->idx);
> +		counter_high = kvm_pmu_get_counter_value(vcpu, pmc->idx + 1);
> +
> +		reg = PMEVCNTR0_EL0 + pmc->idx;
> +		__vcpu_sys_reg(vcpu, reg) = counter_low;
> +		__vcpu_sys_reg(vcpu, reg + 1) = counter_high;
> +	} else {
>  		counter = kvm_pmu_get_counter_value(vcpu, pmc->idx);
>  		reg = (pmc->idx == ARMV8_PMU_CYCLE_IDX)
>  		       ? PMCCNTR_EL0 : PMEVCNTR0_EL0 + pmc->idx;
>  		__vcpu_sys_reg(vcpu, reg) = counter;
> -		kvm_pmu_release_perf_event(pmc);
>  	}
> +
> +	kvm_pmu_release_perf_event(pmc);
>  }
>  
>  /**
> @@ -115,6 +231,8 @@ void kvm_pmu_vcpu_reset(struct kvm_vcpu *vcpu)
>  		pmu->pmc[i].idx = i;
>  		pmu->pmc[i].bitmask = 0xffffffffUL;
>  	}
> +
> +	bitmap_zero(vcpu->arch.pmu.chained, ARMV8_PMU_MAX_COUNTER_PAIRS);
>  }
>  
>  /**
> @@ -162,7 +280,18 @@ void kvm_pmu_enable_counter_mask(struct kvm_vcpu *vcpu, u64 val)
>  		if (!(val & BIT(i)))
>  			continue;
>  
> -		pmc = &pmu->pmc[i];
> +		pmc = kvm_pmu_get_canonical_pmc(&pmu->pmc[i]);

kvm_pmu_pmc_is_chained() works on both counters of a pair, and if we
have a non-canonical counter (i.e. high counter of a chain), we do a
"continue;", so I don't think we need to retrieve the canonical pmc here.

> +
> +		/*
> +		 * For high counters of chained events we must recreate the
> +		 * perf event with the long (64bit) attribute set.
> +		 */
> +		if (kvm_pmu_pmc_is_chained(pmc) &&
> +		    kvm_pmu_pmc_is_high_counter(i)) {
> +			kvm_pmu_create_perf_event(vcpu, i);
> +			continue;
> +		}
> +
>  		if (pmc->perf_event) {
>  			perf_event_enable(pmc->perf_event);
>  			if (pmc->perf_event->state != PERF_EVENT_STATE_ACTIVE)
> @@ -191,7 +320,18 @@ void kvm_pmu_disable_counter_mask(struct kvm_vcpu *vcpu, u64 val)
>  		if (!(val & BIT(i)))
>  			continue;
>  
> -		pmc = &pmu->pmc[i];
> +		pmc = kvm_pmu_get_canonical_pmc(&pmu->pmc[i]);

Same.

> +
> +		/*
> +		 * For high counters of chained events we must recreate the
> +		 * perf event with the long (64bit) attribute unset.
> +		 */
> +		if (kvm_pmu_pmc_is_chained(pmc) &&
> +		    kvm_pmu_pmc_is_high_counter(i)) {
> +			kvm_pmu_create_perf_event(vcpu, i);
> +			continue;
> +		}
> +
>  		if (pmc->perf_event)
>  			perf_event_disable(pmc->perf_event);
>  	}
> @@ -281,17 +421,6 @@ void kvm_pmu_sync_hwstate(struct kvm_vcpu *vcpu)
>  	kvm_pmu_update_state(vcpu);
>  }
>  
> -static inline struct kvm_vcpu *kvm_pmc_to_vcpu(struct kvm_pmc *pmc)
> -{
> -	struct kvm_pmu *pmu;
> -	struct kvm_vcpu_arch *vcpu_arch;
> -
> -	pmc -= pmc->idx;
> -	pmu = container_of(pmc, struct kvm_pmu, pmc[0]);
> -	vcpu_arch = container_of(pmu, struct kvm_vcpu_arch, pmu);
> -	return container_of(vcpu_arch, struct kvm_vcpu, arch);
> -}
> -
>  /**
>   * When the perf event overflows, set the overflow status and inform the vcpu.
>   */
> @@ -389,11 +518,19 @@ static bool kvm_pmu_counter_is_enabled(struct kvm_vcpu *vcpu, u64 select_idx)
>  static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx)
>  {
>  	struct kvm_pmu *pmu = &vcpu->arch.pmu;
> -	struct kvm_pmc *pmc = &pmu->pmc[select_idx];
> +	struct kvm_pmc *pmc = kvm_pmu_get_canonical_pmc(&pmu->pmc[select_idx]);
>  	struct perf_event *event;
>  	struct perf_event_attr attr;
>  	u64 eventsel, counter, reg, data;
>  
> +	/*
> +	 * For chained counters the event type and filtering attributes are
> +	 * obtained from the low/even counter. We also use this counter to
> +	 * determine if the event is enabled/disabled.
> +	 */
> +	if (kvm_pmu_event_is_chained(vcpu, select_idx))
> +		select_idx &= ~1UL;
> +

With both this and the pmc initialization it feels like we're doing
double the work/open coding things.

You could delay initialization of pmc here, after adjusting the
selec_idx to:

	pmc = pmu->pmc[select_idx];

>  	reg = (select_idx == ARMV8_PMU_CYCLE_IDX)
>  	      ? PMCCFILTR_EL0 : PMEVTYPER0_EL0 + select_idx;
>  	data = __vcpu_sys_reg(vcpu, reg);
> @@ -418,12 +555,28 @@ static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx)
>  	attr.config = (select_idx == ARMV8_PMU_CYCLE_IDX) ?
>  		ARMV8_PMUV3_PERFCTR_CPU_CYCLES : eventsel;
>  
> -	counter = kvm_pmu_get_counter_value(vcpu, select_idx);
> -	/* The initial sample period (overflow count) of an event. */
> -	attr.sample_period = (-counter) & pmc->bitmask;
> +	counter = kvm_pmu_get_pair_counter_value(vcpu, pmc);
> +
> +	if (kvm_pmu_event_is_chained(vcpu, pmc->idx)) {

Nit: At that point I feel like kvm_pmu_pmc_is_chained() is a simpler
operation. (If we update the evtype we call the create function again
after setting the pair bitmap anyway, right?)

Cheers,

-- 
Julien Thierry
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
