Return-Path: <SRS0=hkx2=G5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61563C433DB
	for <kvmarm@archiver.kernel.org>; Tue, 26 Jan 2021 14:07:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C067B22B2C
	for <kvmarm@archiver.kernel.org>; Tue, 26 Jan 2021 14:07:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C067B22B2C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1F2AA4B2DB;
	Tue, 26 Jan 2021 09:07:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qQoEMnByQGmu; Tue, 26 Jan 2021 09:07:53 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B64564B2D4;
	Tue, 26 Jan 2021 09:07:53 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 919A24B2D1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jan 2021 09:07:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MMIZIGHKMoHd for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Jan 2021 09:07:50 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 079DC4B299
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jan 2021 09:07:50 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7A901106F;
 Tue, 26 Jan 2021 06:07:49 -0800 (PST)
Received: from slackpad.fritz.box (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 423FE3F68F;
 Tue, 26 Jan 2021 06:07:48 -0800 (PST)
Date: Tue, 26 Jan 2021 14:06:53 +0000
From: Andre Przywara <andre.przywara@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [RFC PATCH] KVM: arm64: Avoid unconditional PMU register access
Message-ID: <20210126140653.051ab5b8@slackpad.fritz.box>
In-Reply-To: <e9881351d7c36aac18356b62a54e8e94@kernel.org>
References: <20210118173054.188160-1-andre.przywara@arm.com>
 <e9881351d7c36aac18356b62a54e8e94@kernel.org>
Organization: Arm Ltd.
X-Mailer: Claws Mail 3.17.1 (GTK+ 2.24.31; x86_64-slackware-linux-gnu)
MIME-Version: 1.0
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Mon, 25 Jan 2021 18:40:40 +0000
Marc Zyngier <maz@kernel.org> wrote:

Hi Marc,

thanks for having a look!

> On 2021-01-18 17:30, Andre Przywara wrote:
> > The ARM PMU is an optional CPU feature, so we should consult the CPUID
> > registers before accessing any PMU related registers.
> > However the KVM code accesses some PMU registers (PMUSERENR_EL0 and
> > PMSEL_EL0) unconditionally, when activating the traps.
> > This wasn't a problem so far, because every(?) silicon implements the
> > PMU, with KVM guests being the lone exception, and those never ran
> > KVM host code.
> > 
> > As this is about to change with nested virt, we need to guard PMU
> > register accesses with a proper CPU feature check.
> > 
> > Add a new CPU capability, which marks whether we have at least the 
> > basic
> > PMUv3 registers available. Use that in the KVM VHE code to check before
> > accessing the PMU registers.
> > 
> > Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> > ---
> > Hi,
> > 
> > not sure a new CPU capability isn't a bit over the top here, and we 
> > should
> > use a simple static key instead?  
> 
> Yes, I think this is a bit excessive, specially as we already have
> a predicate for the HW having a PMU (or the PMU being able on the
> host, which amounts to the same thing). I'm definitely not keen
> on adding more another one that has slightly different semantics.
> 
> How about this instead, completely untested?

Thanks, I was hoping for something like this, just didn't have any clue
where in the tree to put the pieces into.

I gave that a spin, and that fixes the issue as well. One comments
below:

> diff --git a/arch/arm64/kernel/image-vars.h 
> b/arch/arm64/kernel/image-vars.h
> index 23f1a557bd9f..5aa9ed1e9ec6 100644
> --- a/arch/arm64/kernel/image-vars.h
> +++ b/arch/arm64/kernel/image-vars.h
> @@ -101,6 +101,9 @@ KVM_NVHE_ALIAS(__stop___kvm_ex_table);
>   /* Array containing bases of nVHE per-CPU memory regions. */
>   KVM_NVHE_ALIAS(kvm_arm_hyp_percpu_base);
> 
> +/* PMU available static key */
> +KVM_NVHE_ALIAS(kvm_arm_pmu_available);
> +
>   #endif /* CONFIG_KVM */
> 
>   #endif /* __ARM64_KERNEL_IMAGE_VARS_H */
> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h 
> b/arch/arm64/kvm/hyp/include/hyp/switch.h
> index 54f4860cd87c..6c1f51f25eb3 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> @@ -90,15 +90,18 @@ static inline void __activate_traps_common(struct 
> kvm_vcpu *vcpu)
>   	 * counter, which could make a PMXEVCNTR_EL0 access UNDEF at
>   	 * EL1 instead of being trapped to EL2.
>   	 */
> -	write_sysreg(0, pmselr_el0);
> -	write_sysreg(ARMV8_PMU_USERENR_MASK, pmuserenr_el0);
> +	if (kvm_arm_support_pmu_v3()) {
> +		write_sysreg(0, pmselr_el0);
> +		write_sysreg(ARMV8_PMU_USERENR_MASK, pmuserenr_el0);
> +	}
>   	write_sysreg(vcpu->arch.mdcr_el2, mdcr_el2);
>   }
> 
>   static inline void __deactivate_traps_common(void)
>   {
>   	write_sysreg(0, hstr_el2);
> -	write_sysreg(0, pmuserenr_el0);
> +	if (kvm_arm_support_pmu_v3())
> +		write_sysreg(0, pmuserenr_el0);
>   }
> 
>   static inline void ___activate_traps(struct kvm_vcpu *vcpu)
> diff --git a/arch/arm64/kvm/perf.c b/arch/arm64/kvm/perf.c
> index d45b8b9a4415..198fa4266b2d 100644
> --- a/arch/arm64/kvm/perf.c
> +++ b/arch/arm64/kvm/perf.c
> @@ -11,6 +11,8 @@
> 
>   #include <asm/kvm_emulate.h>
> 
> +DEFINE_STATIC_KEY_FALSE(kvm_arm_pmu_available);
> +
>   static int kvm_is_in_guest(void)
>   {
>           return kvm_get_running_vcpu() != NULL;
> @@ -48,6 +50,14 @@ static struct perf_guest_info_callbacks kvm_guest_cbs 
> = {
> 
>   int kvm_perf_init(void)
>   {
> +	/*
> +	 * Check if HW_PERF_EVENTS are supported by checking the number of
> +	 * hardware performance counters. This could ensure the presence of
> +	 * a physical PMU and CONFIG_PERF_EVENT is selected.
> +	 */
> +	if (perf_num_counters() > 0)
> +		static_branch_enable(&kvm_arm_pmu_available);
> +
>   	return perf_register_guest_info_callbacks(&kvm_guest_cbs);
>   }
> 
> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> index 247422ac78a9..8d5ff7f3d416 100644
> --- a/arch/arm64/kvm/pmu-emul.c
> +++ b/arch/arm64/kvm/pmu-emul.c
> @@ -817,16 +817,6 @@ u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool 
> pmceid1)
>   	return val & mask;
>   }
> 
> -bool kvm_arm_support_pmu_v3(void)
> -{
> -	/*
> -	 * Check if HW_PERF_EVENTS are supported by checking the number of
> -	 * hardware performance counters. This could ensure the presence of
> -	 * a physical PMU and CONFIG_PERF_EVENT is selected.
> -	 */
> -	return (perf_num_counters() > 0);
> -}
> -
>   int kvm_arm_pmu_v3_enable(struct kvm_vcpu *vcpu)
>   {
>   	if (!kvm_vcpu_has_pmu(vcpu))
> diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
> index 8dcb3e1477bc..45631af820cd 100644
> --- a/include/kvm/arm_pmu.h
> +++ b/include/kvm/arm_pmu.h
> @@ -13,6 +13,13 @@
>   #define ARMV8_PMU_CYCLE_IDX		(ARMV8_PMU_MAX_COUNTERS - 1)
>   #define ARMV8_PMU_MAX_COUNTER_PAIRS	((ARMV8_PMU_MAX_COUNTERS + 1) >> 1)
> 
> +DECLARE_STATIC_KEY_FALSE(kvm_arm_pmu_available);
> +
> +static __always_inline bool kvm_arm_support_pmu_v3(void)
> +{
> +	return static_branch_likely(&kvm_arm_pmu_available);
> +}
> +

Doesn't that definition belong into the part below, guarded by
CONFIG_HW_PERF_EVENTS? Otherwise disabling CONFIG_ARM_PMU will break
compilation, as kvm_arm_support_pmu_v3() is defined twice.

And speaking of which, the actual code in question here, above in
hyp/switch.h, sounds like taking care of an architectural trait, that
is independent from the host using the performance counters? So it
should be executed regardless of the host kernel supporting Linux'
ARM_PMU feature? At the moment disabling ARM_PMU skips this system
register setup, is that intended?
Or do I understand the comment in __activate_traps_common() wrongly, and
this is only an issue if the host kernel might be using performance
counters itself?

Cheers,
Andre

>   #ifdef CONFIG_HW_PERF_EVENTS
> 
>   struct kvm_pmc {
> @@ -47,7 +54,6 @@ void kvm_pmu_software_increment(struct kvm_vcpu *vcpu, 
> u64 val);
>   void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val);
>   void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
>   				    u64 select_idx);
> -bool kvm_arm_support_pmu_v3(void);
>   int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu,
>   			    struct kvm_device_attr *attr);
>   int kvm_arm_pmu_v3_get_attr(struct kvm_vcpu *vcpu,
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
