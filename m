Return-Path: <SRS0=HUCa=TW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CB58C282CE
	for <kvmarm@archiver.kernel.org>; Wed, 22 May 2019 13:49:06 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A5FD120863
	for <kvmarm@archiver.kernel.org>; Wed, 22 May 2019 13:49:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A5FD120863
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 28B154A319;
	Wed, 22 May 2019 09:49:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zID9m9Wx9QH6; Wed, 22 May 2019 09:49:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 985954A417;
	Wed, 22 May 2019 09:49:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1DAB64A319
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 May 2019 09:49:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id puDjegqvgjvJ for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 May 2019 09:49:01 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 015714A1FA
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 May 2019 09:49:00 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4A8AC80D;
 Wed, 22 May 2019 06:49:00 -0700 (PDT)
Received: from localhost (unknown [10.37.6.20])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D455C3F575;
 Wed, 22 May 2019 06:48:59 -0700 (PDT)
Date: Wed, 22 May 2019 14:48:58 +0100
From: Andrew Murray <andrew.murray@arm.com>
To: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v7 5/5] KVM: arm/arm64: support chained PMU counters
Message-ID: <20190522134857.GB8268@e119886-lin.cambridge.arm.com>
References: <20190521155228.903-1-andrew.murray@arm.com>
 <20190521155228.903-6-andrew.murray@arm.com>
 <42142487-4059-dbfb-062c-0839c1f0ea51@arm.com>
 <20190522103537.GZ8268@e119886-lin.cambridge.arm.com>
 <37b16e12-cc0e-1d27-17f9-9bd1a326610f@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <37b16e12-cc0e-1d27-17f9-9bd1a326610f@arm.com>
User-Agent: Mutt/1.10.1+81 (426a6c1) (2018-08-26)
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

On Wed, May 22, 2019 at 12:50:43PM +0100, Marc Zyngier wrote:
> On 22/05/2019 11:35, Andrew Murray wrote:
> > On Tue, May 21, 2019 at 05:31:47PM +0100, Marc Zyngier wrote:
> >> On 21/05/2019 16:52, Andrew Murray wrote:
> >>> ARMv8 provides support for chained PMU counters, where an event type
> >>> of 0x001E is set for odd-numbered counters, the event counter will
> >>> increment by one for each overflow of the preceding even-numbered
> >>> counter. Let's emulate this in KVM by creating a 64 bit perf counter
> >>> when a user chains two emulated counters together.
> >>>
> >>> For chained events we only support generating an overflow interrupt
> >>> on the high counter. We use the attributes of the low counter to
> >>> determine the attributes of the perf event.
> >>>
> >>> Suggested-by: Marc Zyngier <marc.zyngier@arm.com>
> >>> Signed-off-by: Andrew Murray <andrew.murray@arm.com>
> >>> ---
> >>>  include/kvm/arm_pmu.h |   2 +
> >>>  virt/kvm/arm/pmu.c    | 246 ++++++++++++++++++++++++++++++++++++------
> >>>  2 files changed, 215 insertions(+), 33 deletions(-)
> >>>
> >>> diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
> >>> index b73f31baca52..8b434745500a 100644
> >>> --- a/include/kvm/arm_pmu.h
> >>> +++ b/include/kvm/arm_pmu.h
> >>> @@ -22,6 +22,7 @@
> >>>  #include <asm/perf_event.h>
> >>>  
> >>>  #define ARMV8_PMU_CYCLE_IDX		(ARMV8_PMU_MAX_COUNTERS - 1)
> >>> +#define ARMV8_PMU_MAX_COUNTER_PAIRS	((ARMV8_PMU_MAX_COUNTERS + 1) >> 1)
> >>>  
> >>>  #ifdef CONFIG_KVM_ARM_PMU
> >>>  
> >>> @@ -34,6 +35,7 @@ struct kvm_pmc {
> >>>  struct kvm_pmu {
> >>>  	int irq_num;
> >>>  	struct kvm_pmc pmc[ARMV8_PMU_MAX_COUNTERS];
> >>> +	DECLARE_BITMAP(chained, ARMV8_PMU_MAX_COUNTER_PAIRS);
> >>>  	bool ready;
> >>>  	bool created;
> >>>  	bool irq_level;
> >>> diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
> >>> index ae1e886d4a1a..4b0981c402c6 100644
> >>> --- a/virt/kvm/arm/pmu.c
> >>> +++ b/virt/kvm/arm/pmu.c
> >>> @@ -25,28 +25,128 @@
> >>>  #include <kvm/arm_vgic.h>
> >>>  
> >>>  static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx);
> >>> +
> >>> +#define PERF_ATTR_CFG1_KVM_PMU_CHAINED 0x1
> >>> +
> >>> +static struct kvm_vcpu *kvm_pmc_to_vcpu(struct kvm_pmc *pmc)
> >>> +{
> >>> +	struct kvm_pmu *pmu;
> >>> +	struct kvm_vcpu_arch *vcpu_arch;
> >>> +
> >>> +	pmc -= pmc->idx;
> >>> +	pmu = container_of(pmc, struct kvm_pmu, pmc[0]);
> >>> +	vcpu_arch = container_of(pmu, struct kvm_vcpu_arch, pmu);
> >>> +	return container_of(vcpu_arch, struct kvm_vcpu, arch);
> >>> +}
> >>> +
> >>>  /**
> >>> - * kvm_pmu_get_counter_value - get PMU counter value
> >>> + * kvm_pmu_pmc_is_chained - determine if the pmc is chained
> >>> + * @pmc: The PMU counter pointer
> >>> + */
> >>> +static bool kvm_pmu_pmc_is_chained(struct kvm_pmc *pmc)
> >>> +{
> >>> +	struct kvm_vcpu *vcpu = kvm_pmc_to_vcpu(pmc);
> >>> +
> >>> +	return test_bit(pmc->idx >> 1, vcpu->arch.pmu.chained);
> >>> +}
> >>> +
> >>> +/**
> >>> + * kvm_pmu_pmc_is_high_counter - determine if select_idx is a high/low counter
> >>> + * @select_idx: The counter index
> >>> + */
> >>> +static bool kvm_pmu_pmc_is_high_counter(u64 select_idx)
> >>> +{
> >>> +	return select_idx & 0x1;
> >>> +}
> >>> +
> >>> +/**
> >>> + * kvm_pmu_get_canonical_pmc - obtain the canonical pmc
> >>> + * @pmc: The PMU counter pointer
> >>> + *
> >>> + * When a pair of PMCs are chained together we use the low counter (canonical)
> >>> + * to hold the underlying perf event.
> >>> + */
> >>> +static struct kvm_pmc *kvm_pmu_get_canonical_pmc(struct kvm_pmc *pmc)
> >>> +{
> >>> +	if (kvm_pmu_pmc_is_chained(pmc) &&
> >>> +	    kvm_pmu_pmc_is_high_counter(pmc->idx))
> >>> +		return pmc - 1;
> >>> +
> >>> +	return pmc;
> >>> +}
> >>> +
> >>> +/**
> >>> + * kvm_pmu_idx_has_chain_evtype - determine if the event type is chain
> >>>   * @vcpu: The vcpu pointer
> >>>   * @select_idx: The counter index
> >>>   */
> >>> -u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx)
> >>> +static bool kvm_pmu_idx_has_chain_evtype(struct kvm_vcpu *vcpu, u64 select_idx)
> >>>  {
> >>> -	u64 counter, reg, enabled, running;
> >>> -	struct kvm_pmu *pmu = &vcpu->arch.pmu;
> >>> -	struct kvm_pmc *pmc = &pmu->pmc[select_idx];
> >>> +	u64 eventsel, reg;
> >>>  
> >>> -	reg = (select_idx == ARMV8_PMU_CYCLE_IDX)
> >>> -	      ? PMCCNTR_EL0 : PMEVCNTR0_EL0 + select_idx;
> >>> -	counter = __vcpu_sys_reg(vcpu, reg);
> >>> +	select_idx |= 0x1;
> >>> +
> >>> +	if (select_idx == ARMV8_PMU_CYCLE_IDX)
> >>> +		return false;
> >>> +
> >>> +	reg = PMEVTYPER0_EL0 + select_idx;
> >>> +	eventsel = __vcpu_sys_reg(vcpu, reg) & ARMV8_PMU_EVTYPE_EVENT;
> >>> +
> >>> +	return armv8pmu_evtype_is_chain(eventsel);
> >>> +}
> >>> +
> >>> +/**
> >>> + * kvm_pmu_get_pair_counter_value - get PMU counter value
> >>> + * @vcpu: The vcpu pointer
> >>> + * @pmc: The PMU counter pointer
> >>> + */
> >>> +static u64 kvm_pmu_get_pair_counter_value(struct kvm_vcpu *vcpu,
> >>> +					  struct kvm_pmc *pmc)
> >>> +{
> >>> +	u64 counter, counter_high, reg, enabled, running;
> >>> +
> >>> +	if (kvm_pmu_pmc_is_chained(pmc)) {
> >>> +		pmc = kvm_pmu_get_canonical_pmc(pmc);
> >>> +		reg = PMEVCNTR0_EL0 + pmc->idx;
> >>> +
> >>> +		counter = __vcpu_sys_reg(vcpu, reg);
> >>> +		counter_high = __vcpu_sys_reg(vcpu, reg + 1);
> >>> +
> >>> +		counter = lower_32_bits(counter) | (counter_high << 32);
> >>> +	} else {
> >>> +		reg = (pmc->idx == ARMV8_PMU_CYCLE_IDX)
> >>> +		      ? PMCCNTR_EL0 : PMEVCNTR0_EL0 + pmc->idx;
> >>> +		counter = __vcpu_sys_reg(vcpu, reg);
> >>> +	}
> >>>  
> >>> -	/* The real counter value is equal to the value of counter register plus
> >>> +	/*
> >>> +	 * The real counter value is equal to the value of counter register plus
> >>>  	 * the value perf event counts.
> >>>  	 */
> >>>  	if (pmc->perf_event)
> >>>  		counter += perf_event_read_value(pmc->perf_event, &enabled,
> >>>  						 &running);
> >>>  
> >>> +	return counter;
> >>> +}
> >>> +
> >>> +/**
> >>> + * kvm_pmu_get_counter_value - get PMU counter value
> >>> + * @vcpu: The vcpu pointer
> >>> + * @select_idx: The counter index
> >>> + */
> >>> +u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx)
> >>> +{
> >>> +	u64 counter;
> >>> +	struct kvm_pmu *pmu = &vcpu->arch.pmu;
> >>> +	struct kvm_pmc *pmc = &pmu->pmc[select_idx];
> >>> +
> >>> +	counter = kvm_pmu_get_pair_counter_value(vcpu, pmc);
> >>> +
> >>> +	if (kvm_pmu_pmc_is_chained(pmc) &&
> >>> +	    kvm_pmu_pmc_is_high_counter(select_idx))
> >>> +		counter >>= 32;
> >>> +
> >>>  	return counter & pmc->bitmask;
> >>>  }
> >>>  
> >>> @@ -74,6 +174,7 @@ void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu, u64 select_idx, u64 val)
> >>>   */
> >>>  static void kvm_pmu_release_perf_event(struct kvm_pmc *pmc)
> >>>  {
> >>> +	pmc = kvm_pmu_get_canonical_pmc(pmc);
> >>>  	if (pmc->perf_event) {
> >>>  		perf_event_disable(pmc->perf_event);
> >>>  		perf_event_release_kernel(pmc->perf_event);
> >>> @@ -91,13 +192,24 @@ static void kvm_pmu_stop_counter(struct kvm_vcpu *vcpu, struct kvm_pmc *pmc)
> >>>  {
> >>>  	u64 counter, reg;
> >>>  
> >>> -	if (pmc->perf_event) {
> >>> +	pmc = kvm_pmu_get_canonical_pmc(pmc);
> >>> +	if (!pmc->perf_event)
> >>> +		return;
> >>> +
> >>> +	if (kvm_pmu_pmc_is_chained(pmc)) {
> >>> +		counter = kvm_pmu_get_pair_counter_value(vcpu, pmc);
> >>> +
> >>> +		reg = PMEVCNTR0_EL0 + pmc->idx;
> >>> +		__vcpu_sys_reg(vcpu, reg) = counter & pmc->bitmask;
> >>> +		__vcpu_sys_reg(vcpu, reg + 1) = (counter >> 32) & pmc->bitmask;
> >>
> >> There is something odd here: You use the same mask for both half of the
> >> counter. The second one doesn't make much sense, and the first one makes
> >> me wonder... Why isn't bitmask a 64bit quantity in this case?
> >>
> > 
> > Yes it's incorrect, the second bitmask should have been pmc+1's bitmask. (In
> > the previous revision of this series the sysreg values were populated by two
> > calls to kvm_pmu_get_counter_value with pmc and pmc+1 - I introduced this error
> > when using kvm_pmu_get_pair_counter_value instead).
> > 
> > My rationale has been that the __vcpu_sys_reg's should represent the underlying
> > hardware registers. This means a 64 bit register with the first 32 bits RES0 for
> > PMEVCNTR<n> registers (chained or otherwise) and a 64 bit register for PMCCNTR.
> > We currently use the bitmask to mask off the RES0 bits in kvm_pmu_get_counter_value
> > when requested by access_pmu_evcntr (to match the counter width). (And thus I've
> > treated bitmask as the width of the counter *within* each register).
> 
> Well, the truncation is a property of the counter registers, and that's
> what we should honor. The bitmask is a property associated to the perf
> event, allowing us to only consider the useful bits.
> 
> > It may be possible, for chained counters, to use only the register value and
> > bitmask in the canonical (just as we do now for the perf_event). Thus for chained
> > counters the bitmask is stored in the low counter and is always 64 bits, and the
> > 64 bit counter value is also only stored in the low counter vcpu_sys_reg register.
> > 
> > This means we could calculate the sample_period with the canonical bitmask (instead
> > of the hunk you also commented on). However it means that in kvm_pmu_get_counter_value
> > we'd have to mask out the RES0 bits indexes that are not the cycle counter. We
> > would also have to write the value of the high counter upon demotion from chained
> > to unchained in kvm_pmu_update_pmc_chained.
> > 
> > Does this seem a better approach to you?
> 
> It would be much better. It would certainly make it clear that there is
> a difference between the perf_event and the emulated counter.

It looks like we don't really need the bitmask seeing as it the information it holds
can be deduced by the pmc->idx and ARM ARM. I'll respin with the latest feedback and
without the bitmask.

Thanks for the feedback.

Thanks,

Andrew Murray

> 
> Thanks,
> 
> 	M.
> -- 
> Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
