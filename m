Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DBFAC433F5
	for <kvmarm@archiver.kernel.org>; Mon, 13 Dec 2021 07:41:21 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CA5764B1D3;
	Mon, 13 Dec 2021 02:41:20 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DnRVg198o-Ww; Mon, 13 Dec 2021 02:41:19 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5EA7E4B1BF;
	Mon, 13 Dec 2021 02:41:19 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7D5D24B16E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Dec 2021 02:41:17 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ODwfxW8rVY3T for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Dec 2021 02:41:14 -0500 (EST)
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com
 [209.85.215.171])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C1A5F4B1BF
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Dec 2021 02:41:14 -0500 (EST)
Received: by mail-pg1-f171.google.com with SMTP id q16so13788622pgq.10
 for <kvmarm@lists.cs.columbia.edu>; Sun, 12 Dec 2021 23:41:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=VWuzoFHG0d8LjlvKt48+/OYL7Fm6OIxRT5SyW/HMU+Y=;
 b=rT89O9PC6vR85MmfsBymFwWrDAb2z7bH5jmP7ODY0eYt7mbaKylV9y82OoVyF3y18F
 Np5l89C2QR5woAO0vKsY2x882kld1Zbro46N7VPNcYU+Lyu6Lkn/58cjB07V2TytRFCp
 fXAszxmYgBTPRtu8L6AblMbb8MfOvl7Sm3c6MtUiYEyxpxEmP+aawqDyuS6TVVzqnIGh
 FR7bpUO8vR2Vrg0hpUvssVf2Kg3NK3uiNcdq0lMvfxxQC8iyrIIIT70dR+CeMEJBVDgr
 bYdF4EZ3b2LuAKN/IqevNJEX1IDT2j8R7wbuNRkiliU74wLmpQ/16JU8pfAh7FNxxvYd
 5hLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=VWuzoFHG0d8LjlvKt48+/OYL7Fm6OIxRT5SyW/HMU+Y=;
 b=igL2h2H2Y5V6tnK5nHsVhbCpBr+TVvjC3hmydvHTeCvqGEem8/eeYtYFQQyl8qKkVz
 925/WatCvJjbgHydXIyEWVco9BrR8/5C4UsY8Xkh7sOvaRRT7RT3REczGUz3RvmiRMBr
 36QJzTOq+XnmvKMGqdPIBB1vUQH8+lfvybSrFF2cFeae0LEyvVGinEimcjSSlklwUYpN
 iL+sRQMFTM9Pk9TqGeMCbrVYgFdtTbWu9AN/Thsi8E4KBBa8uAWUSpUl87+8RjJhp1MV
 mgiraHP7VfO0P/yG4fliYU8SeEsaQATQOY36+e/0bA3MND++7cHhxc6Ac6xQjsIkJUj8
 Ji6g==
X-Gm-Message-State: AOAM530n3KQtQ4TGkgyjq3Cy594BNkBnh0g1YBNDvHqSixFraCAue4nG
 m4QXqSjlUxByBYMPnd968UnYPIfr+uERLZhXNytHMA==
X-Google-Smtp-Source: ABdhPJy0bG163GpiPi7BmHKptzoU6xbJMSSkCtDHrnLtIUcZtcMJmRMqIJ8EfY12RKPbBHTXJ7RnSVJFdn7zf4+dDVg=
X-Received: by 2002:a63:d945:: with SMTP id e5mr2972159pgj.514.1639381273605; 
 Sun, 12 Dec 2021 23:41:13 -0800 (PST)
MIME-Version: 1.0
References: <20211206170223.309789-1-alexandru.elisei@arm.com>
 <20211206170223.309789-5-alexandru.elisei@arm.com>
 <Ya9s2HIuMmWYFIQm@monolith.localdoman>
 <CAAeT=Fz2D+axfn7-eO1MMO8R3w-C_XhVxb-_upC0zqyFr4D0GQ@mail.gmail.com>
 <YbCLGHkxI+uNGDTb@monolith.localdoman>
In-Reply-To: <YbCLGHkxI+uNGDTb@monolith.localdoman>
From: Reiji Watanabe <reijiw@google.com>
Date: Sun, 12 Dec 2021 23:40:57 -0800
Message-ID: <CAAeT=FzY45w-6J1C41MATWY21-dvOoNYHLz8Wx2jrVAREY9_yA@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] KVM: arm64: Refuse to run VCPU if the PMU doesn't
 match the physical CPU
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: maz@kernel.org, mingo@redhat.com, tglx@linutronix.de, will@kernel.org,
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

Hi Alex,

On Wed, Dec 8, 2021 at 2:38 AM Alexandru Elisei
<alexandru.elisei@arm.com> wrote:
>
> Hi Reiji,
>
> Thank you for the review!
>
> On Tue, Dec 07, 2021 at 11:54:51PM -0800, Reiji Watanabe wrote:
> > Hi Alex,
> >
> > On Tue, Dec 7, 2021 at 6:18 AM Alexandru Elisei
> > <alexandru.elisei@arm.com> wrote:
> > >
> > > Hi,
> > >
> > > On Mon, Dec 06, 2021 at 05:02:23PM +0000, Alexandru Elisei wrote:
> > > > Userspace can assign a PMU to a VCPU with the KVM_ARM_VCPU_PMU_V3_SET_PMU
> > > > device ioctl. If the VCPU is scheduled on a physical CPU which has a
> > > > different PMU, the perf events needed to emulate a guest PMU won't be
> > > > scheduled in and the guest performance counters will stop counting. Treat
> > > > it as an userspace error and refuse to run the VCPU in this situation.
> > > >
> > > > The VCPU is flagged as being scheduled on the wrong CPU in vcpu_load(), but
> > > > the flag is cleared when the KVM_RUN enters the non-preemptible section
> > > > instead of in vcpu_put(); this has been done on purpose so the error
> > > > condition is communicated as soon as possible to userspace, otherwise
> > > > vcpu_load() on the wrong CPU followed by a vcpu_put() would clear the flag.
> > > >
> > > > Suggested-by: Marc Zyngier <maz@kernel.org>
> > > > Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> > > > ---
> > > > I agonized for hours about the best name for the VCPU flag and the
> > > > accessors. If someone has a better idea, please tell me and I'll change
> > > > them.
> > > >
> > > >  Documentation/virt/kvm/devices/vcpu.rst |  6 +++++-
> > > >  arch/arm64/include/asm/kvm_host.h       | 12 ++++++++++++
> > > >  arch/arm64/include/uapi/asm/kvm.h       |  3 +++
> > > >  arch/arm64/kvm/arm.c                    | 19 +++++++++++++++++++
> > > >  arch/arm64/kvm/pmu-emul.c               |  1 +
> > > >  5 files changed, 40 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/Documentation/virt/kvm/devices/vcpu.rst b/Documentation/virt/kvm/devices/vcpu.rst
> > > > index c82be5cbc268..9ae47b7c3652 100644
> > > > --- a/Documentation/virt/kvm/devices/vcpu.rst
> > > > +++ b/Documentation/virt/kvm/devices/vcpu.rst
> > > > @@ -128,7 +128,11 @@ systems where there are at least two CPU PMUs on the system.
> > > >
> > > >  Note that KVM will not make any attempts to run the VCPU on the physical CPUs
> > > >  associated with the PMU specified by this attribute. This is entirely left to
> > > > -userspace.
> > > > +userspace. However, attempting to run the VCPU on a physical CPU not supported
> > > > +by the PMU will fail and KVM_RUN will return with
> > > > +exit_reason = KVM_EXIT_FAIL_ENTRY and populate the fail_entry struct by setting
> > > > +hardare_entry_failure_reason field to KVM_EXIT_FAIL_ENTRY_CPU_UNSUPPORTED and
> > > > +the cpu field to the processor id.
> > > >
> > > >  2. GROUP: KVM_ARM_VCPU_TIMER_CTRL
> > > >  =================================
> > > > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > > > index 2a5f7f38006f..0c453f2e48b6 100644
> > > > --- a/arch/arm64/include/asm/kvm_host.h
> > > > +++ b/arch/arm64/include/asm/kvm_host.h
> > > > @@ -385,6 +385,8 @@ struct kvm_vcpu_arch {
> > > >               u64 last_steal;
> > > >               gpa_t base;
> > > >       } steal;
> > > > +
> > > > +     cpumask_var_t supported_cpus;
> > > >  };
> > > >
> > > >  /* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
> > > > @@ -420,6 +422,7 @@ struct kvm_vcpu_arch {
> > > >  #define KVM_ARM64_EXCEPT_MASK                (7 << 9) /* Target EL/MODE */
> > > >  #define KVM_ARM64_DEBUG_STATE_SAVE_SPE       (1 << 12) /* Save SPE context if active  */
> > > >  #define KVM_ARM64_DEBUG_STATE_SAVE_TRBE      (1 << 13) /* Save TRBE context if active  */
> > > > +#define KVM_ARM64_ON_UNSUPPORTED_CPU (1 << 14) /* Physical CPU not in supported_cpus */
> > > >
> > > >  #define KVM_GUESTDBG_VALID_MASK (KVM_GUESTDBG_ENABLE | \
> > > >                                KVM_GUESTDBG_USE_SW_BP | \
> > > > @@ -460,6 +463,15 @@ struct kvm_vcpu_arch {
> > > >  #define vcpu_has_ptrauth(vcpu)               false
> > > >  #endif
> > > >
> > > > +#define vcpu_on_unsupported_cpu(vcpu)                                        \
> > > > +     ((vcpu)->arch.flags & KVM_ARM64_ON_UNSUPPORTED_CPU)
> > > > +
> > > > +#define vcpu_set_on_unsupported_cpu(vcpu)                            \
> > > > +     ((vcpu)->arch.flags |= KVM_ARM64_ON_UNSUPPORTED_CPU)
> > > > +
> > > > +#define vcpu_clear_on_unsupported_cpu(vcpu)                          \
> > > > +     ((vcpu)->arch.flags &= ~KVM_ARM64_ON_UNSUPPORTED_CPU)
> > > > +
> > > >  #define vcpu_gp_regs(v)              (&(v)->arch.ctxt.regs)
> > > >
> > > >  /*
> > > > diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> > > > index 1d0a0a2a9711..d49f714f48e6 100644
> > > > --- a/arch/arm64/include/uapi/asm/kvm.h
> > > > +++ b/arch/arm64/include/uapi/asm/kvm.h
> > > > @@ -414,6 +414,9 @@ struct kvm_arm_copy_mte_tags {
> > > >  #define KVM_PSCI_RET_INVAL           PSCI_RET_INVALID_PARAMS
> > > >  #define KVM_PSCI_RET_DENIED          PSCI_RET_DENIED
> > > >
> > > > +/* run->fail_entry.hardware_entry_failure_reason codes. */
> > > > +#define KVM_EXIT_FAIL_ENTRY_CPU_UNSUPPORTED  (1ULL << 0)
> > > > +
> > > >  #endif
> > > >
> > > >  #endif /* __ARM_KVM_H__ */
> > > > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > > > index e4727dc771bf..1124c3efdd94 100644
> > > > --- a/arch/arm64/kvm/arm.c
> > > > +++ b/arch/arm64/kvm/arm.c
> > > > @@ -327,6 +327,10 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
> > > >
> > > >       vcpu->arch.mmu_page_cache.gfp_zero = __GFP_ZERO;
> > > >
> > > > +     if (!zalloc_cpumask_var(&vcpu->arch.supported_cpus, GFP_KERNEL))
> > > > +             return -ENOMEM;
> >
> > It appears that vcpu->arch.supported_cpus needs to be freed
> > if kvm_arch_vcpu_create() fails after it is allocated.
> > (kvm_vgic_vcpu_init() or create_hyp_mappings() might fail)
>
> I missed that, thank you for pointing it out.
>
> >
> >
> > > > +     cpumask_copy(vcpu->arch.supported_cpus, cpu_possible_mask);
> > > > +
> > > >       /* Set up the timer */
> > > >       kvm_timer_vcpu_init(vcpu);
> > > >
> > > > @@ -354,6 +358,7 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
> > > >       if (vcpu->arch.has_run_once && unlikely(!irqchip_in_kernel(vcpu->kvm)))
> > > >               static_branch_dec(&userspace_irqchip_in_use);
> > > >
> > > > +     free_cpumask_var(vcpu->arch.supported_cpus);
> > > >       kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_cache);
> > > >       kvm_timer_vcpu_terminate(vcpu);
> > > >       kvm_pmu_vcpu_destroy(vcpu);
> > > > @@ -432,6 +437,9 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
> > > >       if (vcpu_has_ptrauth(vcpu))
> > > >               vcpu_ptrauth_disable(vcpu);
> > > >       kvm_arch_vcpu_load_debug_state_flags(vcpu);
> > > > +
> > > > +     if (!cpumask_test_cpu(smp_processor_id(), vcpu->arch.supported_cpus))
> > > > +             vcpu_set_on_unsupported_cpu(vcpu);
> > > >  }
> > > >
> > > >  void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
> > > > @@ -822,6 +830,17 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
> > > >                */
> > > >               preempt_disable();
> > > >
> > > > +             if (unlikely(vcpu_on_unsupported_cpu(vcpu))) {
> > > > +                     vcpu_clear_on_unsupported_cpu(vcpu);
> > > > +                     run->exit_reason = KVM_EXIT_FAIL_ENTRY;
> > > > +                     run->fail_entry.hardware_entry_failure_reason
> > > > +                             = KVM_EXIT_FAIL_ENTRY_CPU_UNSUPPORTED;
> > > > +                     run->fail_entry.cpu = smp_processor_id();
> > >
> > > I just realised that this is wrong for the same reason that KVM doesn't
> > > clear the unsupported CPU flag on vcpu_put: a vcpu_put/load that happened
> > > after the vcpu_load that set the flag and before preemption is disabled
> > > could mean that now the thread is executing on a different physical CPU
> > > than the physical CPU that caused the flag to be set. To make things worse,
> > > this CPU might even be in supported_cpus, which would be extremely
> > > confusing for someone trying to descipher what went wrong.
> > >
> > > I see three solutions here:
> > >
> > > 1. Drop setting the fail_entry.cpu field.
> > >
> > > 2. Make vcpu_put clear the flag, which means that if the flag is set here
> > > then the VCPU is definitely executing on the wrong physical CPU and
> > > smp_processor_id() will be useful.
> > >
> > > 3. Carry the unsupported CPU ID information in a new field in struct
> > > kvm_vcpu_arch.
> > >
> > > I honestly don't have a preference. Maybe slightly towards solution number
> > > 2, as it makes the code symmetrical and removes the subtletly around when
> > > the VCPU flag is cleared. But this would be done at the expense of
> > > userspace possibly finding out a lot later (or never) that something went
> > > wrong.
> > >
> > > Thoughts?
> >
> > IMHO, I would prefer 2, which is symmetrical and straightforward,
> > out of those three options.  Unless KVM checks the thread's CPU
> > affinity, userspace possibly finds that out a lot later anyway.
>
> Agreed.
>
> >
> > BTW, kvm_vcpu_pmu_restore_guest/kvm_vcpu_pmu_restore_host, which
> > are (indirectly) called from vcpu_load/vcpu_put, seems to attempt
> > to read/writes pmccfiltr_el0, which is present only when FEAT_PMUv3
> > is implemented, even if the current CPU does not support FEAT_PMUv3.
>
> I think that's a different problem, independent of this patch. There are
> other places where KVM touches the PMU registers based on
> kvm_arm_support_pmu_v3() instead of checking that the CPU has a PMU
> (__activate_traps_common() comes to mind). As far as I can tell, this
> unusual configuration works with perf because perf calls
> pmu->filter_match() before scheduling in an event, although I haven't heard
> of such a SoC existing (does not mean it doesn't exist!).

Yes, I agree that this is a different problem, and I understand
there are other codes that have the same problem.
(I just wanted to mention the problem because you might be interested
in the problem from the changes and purpose of the series)

Thank you for your comment !
Reiji
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
