Return-Path: <SRS0=AfIE=TV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FC69C04AAF
	for <kvmarm@archiver.kernel.org>; Tue, 21 May 2019 16:46:39 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B09692173E
	for <kvmarm@archiver.kernel.org>; Tue, 21 May 2019 16:46:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B09692173E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3DC254A4C3;
	Tue, 21 May 2019 12:46:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zD28hTmZgs1n; Tue, 21 May 2019 12:46:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 028BF4A4BE;
	Tue, 21 May 2019 12:46:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 184F94A4A4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 May 2019 12:46:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PWDD1lNSP7wR for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 May 2019 12:46:32 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5BC564A477
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 May 2019 12:46:32 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CE9DE374;
 Tue, 21 May 2019 09:46:31 -0700 (PDT)
Received: from [10.37.9.19] (unknown [10.37.9.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4D3753F718;
 Tue, 21 May 2019 09:46:30 -0700 (PDT)
Subject: Re: [PATCH v7 5/5] KVM: arm/arm64: support chained PMU counters
To: Andrew Murray <andrew.murray@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>,
 Marc Zyngier <marc.zyngier@arm.com>
References: <20190521155228.903-1-andrew.murray@arm.com>
 <20190521155228.903-6-andrew.murray@arm.com>
From: Julien Thierry <julien.thierry@arm.com>
Message-ID: <d6e0efaa-162c-e606-54e9-cfe74b228bf4@arm.com>
Date: Tue, 21 May 2019 17:46:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190521155228.903-6-andrew.murray@arm.com>
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Andrew,

On 05/21/2019 04:52 PM, Andrew Murray wrote:
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
>  virt/kvm/arm/pmu.c    | 246 ++++++++++++++++++++++++++++++++++++------
>  2 files changed, 215 insertions(+), 33 deletions(-)
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
> index ae1e886d4a1a..4b0981c402c6 100644
> --- a/virt/kvm/arm/pmu.c
> +++ b/virt/kvm/arm/pmu.c
> @@ -25,28 +25,128 @@
>  #include <kvm/arm_vgic.h>
>  
>  static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx);
> +
> +#define PERF_ATTR_CFG1_KVM_PMU_CHAINED 0x1
> +
> +static struct kvm_vcpu *kvm_pmc_to_vcpu(struct kvm_pmc *pmc)
> +{
> +	struct kvm_pmu *pmu;
> +	struct kvm_vcpu_arch *vcpu_arch;
> +
> +	pmc -= pmc->idx;
> +	pmu = container_of(pmc, struct kvm_pmu, pmc[0]);
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
> +	if (kvm_pmu_pmc_is_chained(pmc) &&
> +	    kvm_pmu_pmc_is_high_counter(pmc->idx))
> +		return pmc - 1;
> +
> +	return pmc;
> +}
> +
> +/**
> + * kvm_pmu_idx_has_chain_evtype - determine if the event type is chain
>   * @vcpu: The vcpu pointer
>   * @select_idx: The counter index
>   */
> -u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx)
> +static bool kvm_pmu_idx_has_chain_evtype(struct kvm_vcpu *vcpu, u64 select_idx)
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
> +	if (kvm_pmu_pmc_is_chained(pmc)) {
> +		pmc = kvm_pmu_get_canonical_pmc(pmc);
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
> @@ -74,6 +174,7 @@ void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu, u64 select_idx, u64 val)
>   */
>  static void kvm_pmu_release_perf_event(struct kvm_pmc *pmc)
>  {
> +	pmc = kvm_pmu_get_canonical_pmc(pmc);
>  	if (pmc->perf_event) {
>  		perf_event_disable(pmc->perf_event);
>  		perf_event_release_kernel(pmc->perf_event);
> @@ -91,13 +192,24 @@ static void kvm_pmu_stop_counter(struct kvm_vcpu *vcpu, struct kvm_pmc *pmc)
>  {
>  	u64 counter, reg;
>  
> -	if (pmc->perf_event) {
> +	pmc = kvm_pmu_get_canonical_pmc(pmc);
> +	if (!pmc->perf_event)
> +		return;
> +
> +	if (kvm_pmu_pmc_is_chained(pmc)) {
> +		counter = kvm_pmu_get_pair_counter_value(vcpu, pmc);
> +
> +		reg = PMEVCNTR0_EL0 + pmc->idx;
> +		__vcpu_sys_reg(vcpu, reg) = counter & pmc->bitmask;
> +		__vcpu_sys_reg(vcpu, reg + 1) = (counter >> 32) & pmc->bitmask;
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
> @@ -115,6 +227,8 @@ void kvm_pmu_vcpu_reset(struct kvm_vcpu *vcpu)
>  		pmu->pmc[i].idx = i;
>  		pmu->pmc[i].bitmask = 0xffffffffUL;
>  	}
> +
> +	bitmap_zero(vcpu->arch.pmu.chained, ARMV8_PMU_MAX_COUNTER_PAIRS);
>  }
>  
>  /**
> @@ -154,6 +268,7 @@ void kvm_pmu_enable_counter_mask(struct kvm_vcpu *vcpu, u64 val)
>  	int i;
>  	struct kvm_pmu *pmu = &vcpu->arch.pmu;
>  	struct kvm_pmc *pmc;
> +	struct perf_event *perf_event;
>  
>  	if (!(__vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMU_PMCR_E) || !val)
>  		return;
> @@ -163,9 +278,21 @@ void kvm_pmu_enable_counter_mask(struct kvm_vcpu *vcpu, u64 val)
>  			continue;
>  
>  		pmc = &pmu->pmc[i];
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
> +		pmc = kvm_pmu_get_canonical_pmc(pmc);

But pmc is already a canonical pmc, we don't need to call
kvm_pmu_get_canonical_pmc(). The condition above is the same as the one
use in kvm_pmu_get_canonical_pmc(), so no "non canonical" pmc ever
reaches that point. I would understand putting a comment to clarify that
fact.

>  		if (pmc->perf_event) {
>  			perf_event_enable(pmc->perf_event);
> -			if (pmc->perf_event->state != PERF_EVENT_STATE_ACTIVE)
> +			if (perf_event->state != PERF_EVENT_STATE_ACTIVE)

You forgot to set perf_event.

>  				kvm_debug("fail to enable perf event\n");
>  		}
>  	}
> @@ -192,6 +319,18 @@ void kvm_pmu_disable_counter_mask(struct kvm_vcpu *vcpu, u64 val)
>  			continue;
>  
>  		pmc = &pmu->pmc[i];
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
> +		pmc = kvm_pmu_get_canonical_pmc(pmc);

Same as the enable case, we know pmc is already canonical, no need to
call the function.

Thanks,

-- 
Julien Thierry
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
