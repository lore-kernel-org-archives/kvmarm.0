Return-Path: <SRS0=hkx2=G5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5267DC433DB
	for <kvmarm@archiver.kernel.org>; Tue, 26 Jan 2021 14:36:33 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C7A4822D58
	for <kvmarm@archiver.kernel.org>; Tue, 26 Jan 2021 14:36:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C7A4822D58
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 365EC4B2E5;
	Tue, 26 Jan 2021 09:36:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KzCTDZTvVzyl; Tue, 26 Jan 2021 09:36:30 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D56A54B2D4;
	Tue, 26 Jan 2021 09:36:30 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 324554B2CA
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jan 2021 09:36:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sy+QQ5-wqBhp for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Jan 2021 09:36:28 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BF8914B2C3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jan 2021 09:36:28 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 9B5F222D58;
 Tue, 26 Jan 2021 14:36:27 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1l4PSD-00A9KQ-Hs; Tue, 26 Jan 2021 14:36:25 +0000
MIME-Version: 1.0
Date: Tue, 26 Jan 2021 14:36:25 +0000
From: Marc Zyngier <maz@kernel.org>
To: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [RFC PATCH] KVM: arm64: Avoid unconditional PMU register access
In-Reply-To: <20210126140653.051ab5b8@slackpad.fritz.box>
References: <20210118173054.188160-1-andre.przywara@arm.com>
 <e9881351d7c36aac18356b62a54e8e94@kernel.org>
 <20210126140653.051ab5b8@slackpad.fritz.box>
User-Agent: Roundcube Webmail/1.4.10
Message-ID: <0299261d1ecb13da8ca86dcdc50854ad@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: andre.przywara@arm.com, catalin.marinas@arm.com,
 will@kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 2021-01-26 14:06, Andre Przywara wrote:
> On Mon, 25 Jan 2021 18:40:40 +0000
> Marc Zyngier <maz@kernel.org> wrote:
> 
> Hi Marc,
> 
> thanks for having a look!
> 
>> On 2021-01-18 17:30, Andre Przywara wrote:
>> > The ARM PMU is an optional CPU feature, so we should consult the CPUID
>> > registers before accessing any PMU related registers.
>> > However the KVM code accesses some PMU registers (PMUSERENR_EL0 and
>> > PMSEL_EL0) unconditionally, when activating the traps.
>> > This wasn't a problem so far, because every(?) silicon implements the
>> > PMU, with KVM guests being the lone exception, and those never ran
>> > KVM host code.
>> >
>> > As this is about to change with nested virt, we need to guard PMU
>> > register accesses with a proper CPU feature check.
>> >
>> > Add a new CPU capability, which marks whether we have at least the
>> > basic
>> > PMUv3 registers available. Use that in the KVM VHE code to check before
>> > accessing the PMU registers.
>> >
>> > Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>> > ---
>> > Hi,
>> >
>> > not sure a new CPU capability isn't a bit over the top here, and we
>> > should
>> > use a simple static key instead?
>> 
>> Yes, I think this is a bit excessive, specially as we already have
>> a predicate for the HW having a PMU (or the PMU being able on the
>> host, which amounts to the same thing). I'm definitely not keen
>> on adding more another one that has slightly different semantics.
>> 
>> How about this instead, completely untested?
> 
> Thanks, I was hoping for something like this, just didn't have any clue
> where in the tree to put the pieces into.
> 
> I gave that a spin, and that fixes the issue as well. One comments
> below:
> 
>> diff --git a/arch/arm64/kernel/image-vars.h
>> b/arch/arm64/kernel/image-vars.h
>> index 23f1a557bd9f..5aa9ed1e9ec6 100644
>> --- a/arch/arm64/kernel/image-vars.h
>> +++ b/arch/arm64/kernel/image-vars.h
>> @@ -101,6 +101,9 @@ KVM_NVHE_ALIAS(__stop___kvm_ex_table);
>>   /* Array containing bases of nVHE per-CPU memory regions. */
>>   KVM_NVHE_ALIAS(kvm_arm_hyp_percpu_base);
>> 
>> +/* PMU available static key */
>> +KVM_NVHE_ALIAS(kvm_arm_pmu_available);
>> +
>>   #endif /* CONFIG_KVM */
>> 
>>   #endif /* __ARM64_KERNEL_IMAGE_VARS_H */
>> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h
>> b/arch/arm64/kvm/hyp/include/hyp/switch.h
>> index 54f4860cd87c..6c1f51f25eb3 100644
>> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
>> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
>> @@ -90,15 +90,18 @@ static inline void __activate_traps_common(struct
>> kvm_vcpu *vcpu)
>>   	 * counter, which could make a PMXEVCNTR_EL0 access UNDEF at
>>   	 * EL1 instead of being trapped to EL2.
>>   	 */
>> -	write_sysreg(0, pmselr_el0);
>> -	write_sysreg(ARMV8_PMU_USERENR_MASK, pmuserenr_el0);
>> +	if (kvm_arm_support_pmu_v3()) {
>> +		write_sysreg(0, pmselr_el0);
>> +		write_sysreg(ARMV8_PMU_USERENR_MASK, pmuserenr_el0);
>> +	}
>>   	write_sysreg(vcpu->arch.mdcr_el2, mdcr_el2);
>>   }
>> 
>>   static inline void __deactivate_traps_common(void)
>>   {
>>   	write_sysreg(0, hstr_el2);
>> -	write_sysreg(0, pmuserenr_el0);
>> +	if (kvm_arm_support_pmu_v3())
>> +		write_sysreg(0, pmuserenr_el0);
>>   }
>> 
>>   static inline void ___activate_traps(struct kvm_vcpu *vcpu)
>> diff --git a/arch/arm64/kvm/perf.c b/arch/arm64/kvm/perf.c
>> index d45b8b9a4415..198fa4266b2d 100644
>> --- a/arch/arm64/kvm/perf.c
>> +++ b/arch/arm64/kvm/perf.c
>> @@ -11,6 +11,8 @@
>> 
>>   #include <asm/kvm_emulate.h>
>> 
>> +DEFINE_STATIC_KEY_FALSE(kvm_arm_pmu_available);
>> +
>>   static int kvm_is_in_guest(void)
>>   {
>>           return kvm_get_running_vcpu() != NULL;
>> @@ -48,6 +50,14 @@ static struct perf_guest_info_callbacks 
>> kvm_guest_cbs
>> = {
>> 
>>   int kvm_perf_init(void)
>>   {
>> +	/*
>> +	 * Check if HW_PERF_EVENTS are supported by checking the number of
>> +	 * hardware performance counters. This could ensure the presence of
>> +	 * a physical PMU and CONFIG_PERF_EVENT is selected.
>> +	 */
>> +	if (perf_num_counters() > 0)
>> +		static_branch_enable(&kvm_arm_pmu_available);
>> +
>>   	return perf_register_guest_info_callbacks(&kvm_guest_cbs);
>>   }
>> 
>> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
>> index 247422ac78a9..8d5ff7f3d416 100644
>> --- a/arch/arm64/kvm/pmu-emul.c
>> +++ b/arch/arm64/kvm/pmu-emul.c
>> @@ -817,16 +817,6 @@ u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, 
>> bool
>> pmceid1)
>>   	return val & mask;
>>   }
>> 
>> -bool kvm_arm_support_pmu_v3(void)
>> -{
>> -	/*
>> -	 * Check if HW_PERF_EVENTS are supported by checking the number of
>> -	 * hardware performance counters. This could ensure the presence of
>> -	 * a physical PMU and CONFIG_PERF_EVENT is selected.
>> -	 */
>> -	return (perf_num_counters() > 0);
>> -}
>> -
>>   int kvm_arm_pmu_v3_enable(struct kvm_vcpu *vcpu)
>>   {
>>   	if (!kvm_vcpu_has_pmu(vcpu))
>> diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
>> index 8dcb3e1477bc..45631af820cd 100644
>> --- a/include/kvm/arm_pmu.h
>> +++ b/include/kvm/arm_pmu.h
>> @@ -13,6 +13,13 @@
>>   #define ARMV8_PMU_CYCLE_IDX		(ARMV8_PMU_MAX_COUNTERS - 1)
>>   #define ARMV8_PMU_MAX_COUNTER_PAIRS	((ARMV8_PMU_MAX_COUNTERS + 1) >> 
>> 1)
>> 
>> +DECLARE_STATIC_KEY_FALSE(kvm_arm_pmu_available);
>> +
>> +static __always_inline bool kvm_arm_support_pmu_v3(void)
>> +{
>> +	return static_branch_likely(&kvm_arm_pmu_available);
>> +}
>> +
> 
> Doesn't that definition belong into the part below, guarded by
> CONFIG_HW_PERF_EVENTS? Otherwise disabling CONFIG_ARM_PMU will break
> compilation, as kvm_arm_support_pmu_v3() is defined twice.

Yes, I fixed that already (after the kbuild robot shouted at me...).

> And speaking of which, the actual code in question here, above in
> hyp/switch.h, sounds like taking care of an architectural trait, that
> is independent from the host using the performance counters? So it
> should be executed regardless of the host kernel supporting Linux'
> ARM_PMU feature? At the moment disabling ARM_PMU skips this system
> register setup, is that intended?
> Or do I understand the comment in __activate_traps_common() wrongly, 
> and
> this is only an issue if the host kernel might be using performance
> counters itself?

There are multiple things at play here:

- If there is no HW PMU, we shouldn't touch these registers.
   This is what this patch fixes

- If there is a HW PMU, but that the host kernel doesn't
   have any PMU support compiled in, it is the same as not
   having a PMU at all as far as the guest is concerned
   (because we handle the PMU as an in-kernel perf client).
   The PMU accesses will trap, and we will inject UNDEF
   exceptions. The actual state of the HW PMU is pretty
   much irrelevant in this case.

- If there is a PMU handled by the host, but that the guest
   isn't configured for one, that's where things become a bit
   muddy. We really should check for the PMU being enabled for
   the guest, but that's a couple of pointers away, probably
   slower than just writing two sysregs without synchronisation.
   So we just do that.

- If there is a PMU in both host and guest, then these writes
   are really mandatory (see 21cbe3cc8a for the gory details
   of the PMSELR_EL0 handling).

Anyway, I'll write some commit messages and post the patches.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
