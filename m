Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 919C3C433EF
	for <kvmarm@archiver.kernel.org>; Wed,  8 Dec 2021 10:38:29 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E827E4B128;
	Wed,  8 Dec 2021 05:38:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9KuP2eN3l3We; Wed,  8 Dec 2021 05:38:26 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E59CF4B102;
	Wed,  8 Dec 2021 05:38:26 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ADAA54B0FB
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Dec 2021 05:38:25 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kybUpXM7PQuv for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Dec 2021 05:38:23 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AE5114031F
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Dec 2021 05:38:23 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 76416ED1;
 Wed,  8 Dec 2021 02:38:22 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B7D9F3F5A1;
 Wed,  8 Dec 2021 02:38:20 -0800 (PST)
Date: Wed, 8 Dec 2021 10:38:16 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Reiji Watanabe <reijiw@google.com>
Subject: Re: [PATCH v2 4/4] KVM: arm64: Refuse to run VCPU if the PMU doesn't
 match the physical CPU
Message-ID: <YbCLGHkxI+uNGDTb@monolith.localdoman>
References: <20211206170223.309789-1-alexandru.elisei@arm.com>
 <20211206170223.309789-5-alexandru.elisei@arm.com>
 <Ya9s2HIuMmWYFIQm@monolith.localdoman>
 <CAAeT=Fz2D+axfn7-eO1MMO8R3w-C_XhVxb-_upC0zqyFr4D0GQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAAeT=Fz2D+axfn7-eO1MMO8R3w-C_XhVxb-_upC0zqyFr4D0GQ@mail.gmail.com>
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

Hi Reiji,

Thank you for the review!

On Tue, Dec 07, 2021 at 11:54:51PM -0800, Reiji Watanabe wrote:
> Hi Alex,
> 
> On Tue, Dec 7, 2021 at 6:18 AM Alexandru Elisei
> <alexandru.elisei@arm.com> wrote:
> >
> > Hi,
> >
> > On Mon, Dec 06, 2021 at 05:02:23PM +0000, Alexandru Elisei wrote:
> > > Userspace can assign a PMU to a VCPU with the KVM_ARM_VCPU_PMU_V3_SET_PMU
> > > device ioctl. If the VCPU is scheduled on a physical CPU which has a
> > > different PMU, the perf events needed to emulate a guest PMU won't be
> > > scheduled in and the guest performance counters will stop counting. Treat
> > > it as an userspace error and refuse to run the VCPU in this situation.
> > >
> > > The VCPU is flagged as being scheduled on the wrong CPU in vcpu_load(), but
> > > the flag is cleared when the KVM_RUN enters the non-preemptible section
> > > instead of in vcpu_put(); this has been done on purpose so the error
> > > condition is communicated as soon as possible to userspace, otherwise
> > > vcpu_load() on the wrong CPU followed by a vcpu_put() would clear the flag.
> > >
> > > Suggested-by: Marc Zyngier <maz@kernel.org>
> > > Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> > > ---
> > > I agonized for hours about the best name for the VCPU flag and the
> > > accessors. If someone has a better idea, please tell me and I'll change
> > > them.
> > >
> > >  Documentation/virt/kvm/devices/vcpu.rst |  6 +++++-
> > >  arch/arm64/include/asm/kvm_host.h       | 12 ++++++++++++
> > >  arch/arm64/include/uapi/asm/kvm.h       |  3 +++
> > >  arch/arm64/kvm/arm.c                    | 19 +++++++++++++++++++
> > >  arch/arm64/kvm/pmu-emul.c               |  1 +
> > >  5 files changed, 40 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/Documentation/virt/kvm/devices/vcpu.rst b/Documentation/virt/kvm/devices/vcpu.rst
> > > index c82be5cbc268..9ae47b7c3652 100644
> > > --- a/Documentation/virt/kvm/devices/vcpu.rst
> > > +++ b/Documentation/virt/kvm/devices/vcpu.rst
> > > @@ -128,7 +128,11 @@ systems where there are at least two CPU PMUs on the system.
> > >
> > >  Note that KVM will not make any attempts to run the VCPU on the physical CPUs
> > >  associated with the PMU specified by this attribute. This is entirely left to
> > > -userspace.
> > > +userspace. However, attempting to run the VCPU on a physical CPU not supported
> > > +by the PMU will fail and KVM_RUN will return with
> > > +exit_reason = KVM_EXIT_FAIL_ENTRY and populate the fail_entry struct by setting
> > > +hardare_entry_failure_reason field to KVM_EXIT_FAIL_ENTRY_CPU_UNSUPPORTED and
> > > +the cpu field to the processor id.
> > >
> > >  2. GROUP: KVM_ARM_VCPU_TIMER_CTRL
> > >  =================================
> > > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > > index 2a5f7f38006f..0c453f2e48b6 100644
> > > --- a/arch/arm64/include/asm/kvm_host.h
> > > +++ b/arch/arm64/include/asm/kvm_host.h
> > > @@ -385,6 +385,8 @@ struct kvm_vcpu_arch {
> > >               u64 last_steal;
> > >               gpa_t base;
> > >       } steal;
> > > +
> > > +     cpumask_var_t supported_cpus;
> > >  };
> > >
> > >  /* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
> > > @@ -420,6 +422,7 @@ struct kvm_vcpu_arch {
> > >  #define KVM_ARM64_EXCEPT_MASK                (7 << 9) /* Target EL/MODE */
> > >  #define KVM_ARM64_DEBUG_STATE_SAVE_SPE       (1 << 12) /* Save SPE context if active  */
> > >  #define KVM_ARM64_DEBUG_STATE_SAVE_TRBE      (1 << 13) /* Save TRBE context if active  */
> > > +#define KVM_ARM64_ON_UNSUPPORTED_CPU (1 << 14) /* Physical CPU not in supported_cpus */
> > >
> > >  #define KVM_GUESTDBG_VALID_MASK (KVM_GUESTDBG_ENABLE | \
> > >                                KVM_GUESTDBG_USE_SW_BP | \
> > > @@ -460,6 +463,15 @@ struct kvm_vcpu_arch {
> > >  #define vcpu_has_ptrauth(vcpu)               false
> > >  #endif
> > >
> > > +#define vcpu_on_unsupported_cpu(vcpu)                                        \
> > > +     ((vcpu)->arch.flags & KVM_ARM64_ON_UNSUPPORTED_CPU)
> > > +
> > > +#define vcpu_set_on_unsupported_cpu(vcpu)                            \
> > > +     ((vcpu)->arch.flags |= KVM_ARM64_ON_UNSUPPORTED_CPU)
> > > +
> > > +#define vcpu_clear_on_unsupported_cpu(vcpu)                          \
> > > +     ((vcpu)->arch.flags &= ~KVM_ARM64_ON_UNSUPPORTED_CPU)
> > > +
> > >  #define vcpu_gp_regs(v)              (&(v)->arch.ctxt.regs)
> > >
> > >  /*
> > > diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> > > index 1d0a0a2a9711..d49f714f48e6 100644
> > > --- a/arch/arm64/include/uapi/asm/kvm.h
> > > +++ b/arch/arm64/include/uapi/asm/kvm.h
> > > @@ -414,6 +414,9 @@ struct kvm_arm_copy_mte_tags {
> > >  #define KVM_PSCI_RET_INVAL           PSCI_RET_INVALID_PARAMS
> > >  #define KVM_PSCI_RET_DENIED          PSCI_RET_DENIED
> > >
> > > +/* run->fail_entry.hardware_entry_failure_reason codes. */
> > > +#define KVM_EXIT_FAIL_ENTRY_CPU_UNSUPPORTED  (1ULL << 0)
> > > +
> > >  #endif
> > >
> > >  #endif /* __ARM_KVM_H__ */
> > > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > > index e4727dc771bf..1124c3efdd94 100644
> > > --- a/arch/arm64/kvm/arm.c
> > > +++ b/arch/arm64/kvm/arm.c
> > > @@ -327,6 +327,10 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
> > >
> > >       vcpu->arch.mmu_page_cache.gfp_zero = __GFP_ZERO;
> > >
> > > +     if (!zalloc_cpumask_var(&vcpu->arch.supported_cpus, GFP_KERNEL))
> > > +             return -ENOMEM;
> 
> It appears that vcpu->arch.supported_cpus needs to be freed
> if kvm_arch_vcpu_create() fails after it is allocated.
> (kvm_vgic_vcpu_init() or create_hyp_mappings() might fail)

I missed that, thank you for pointing it out.

> 
> 
> > > +     cpumask_copy(vcpu->arch.supported_cpus, cpu_possible_mask);
> > > +
> > >       /* Set up the timer */
> > >       kvm_timer_vcpu_init(vcpu);
> > >
> > > @@ -354,6 +358,7 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
> > >       if (vcpu->arch.has_run_once && unlikely(!irqchip_in_kernel(vcpu->kvm)))
> > >               static_branch_dec(&userspace_irqchip_in_use);
> > >
> > > +     free_cpumask_var(vcpu->arch.supported_cpus);
> > >       kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_cache);
> > >       kvm_timer_vcpu_terminate(vcpu);
> > >       kvm_pmu_vcpu_destroy(vcpu);
> > > @@ -432,6 +437,9 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
> > >       if (vcpu_has_ptrauth(vcpu))
> > >               vcpu_ptrauth_disable(vcpu);
> > >       kvm_arch_vcpu_load_debug_state_flags(vcpu);
> > > +
> > > +     if (!cpumask_test_cpu(smp_processor_id(), vcpu->arch.supported_cpus))
> > > +             vcpu_set_on_unsupported_cpu(vcpu);
> > >  }
> > >
> > >  void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
> > > @@ -822,6 +830,17 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
> > >                */
> > >               preempt_disable();
> > >
> > > +             if (unlikely(vcpu_on_unsupported_cpu(vcpu))) {
> > > +                     vcpu_clear_on_unsupported_cpu(vcpu);
> > > +                     run->exit_reason = KVM_EXIT_FAIL_ENTRY;
> > > +                     run->fail_entry.hardware_entry_failure_reason
> > > +                             = KVM_EXIT_FAIL_ENTRY_CPU_UNSUPPORTED;
> > > +                     run->fail_entry.cpu = smp_processor_id();
> >
> > I just realised that this is wrong for the same reason that KVM doesn't
> > clear the unsupported CPU flag on vcpu_put: a vcpu_put/load that happened
> > after the vcpu_load that set the flag and before preemption is disabled
> > could mean that now the thread is executing on a different physical CPU
> > than the physical CPU that caused the flag to be set. To make things worse,
> > this CPU might even be in supported_cpus, which would be extremely
> > confusing for someone trying to descipher what went wrong.
> >
> > I see three solutions here:
> >
> > 1. Drop setting the fail_entry.cpu field.
> >
> > 2. Make vcpu_put clear the flag, which means that if the flag is set here
> > then the VCPU is definitely executing on the wrong physical CPU and
> > smp_processor_id() will be useful.
> >
> > 3. Carry the unsupported CPU ID information in a new field in struct
> > kvm_vcpu_arch.
> >
> > I honestly don't have a preference. Maybe slightly towards solution number
> > 2, as it makes the code symmetrical and removes the subtletly around when
> > the VCPU flag is cleared. But this would be done at the expense of
> > userspace possibly finding out a lot later (or never) that something went
> > wrong.
> >
> > Thoughts?
> 
> IMHO, I would prefer 2, which is symmetrical and straightforward,
> out of those three options.  Unless KVM checks the thread's CPU
> affinity, userspace possibly finds that out a lot later anyway.

Agreed.

> 
> BTW, kvm_vcpu_pmu_restore_guest/kvm_vcpu_pmu_restore_host, which
> are (indirectly) called from vcpu_load/vcpu_put, seems to attempt
> to read/writes pmccfiltr_el0, which is present only when FEAT_PMUv3
> is implemented, even if the current CPU does not support FEAT_PMUv3.

I think that's a different problem, independent of this patch. There are
other places where KVM touches the PMU registers based on
kvm_arm_support_pmu_v3() instead of checking that the CPU has a PMU
(__activate_traps_common() comes to mind). As far as I can tell, this
unusual configuration works with perf because perf calls
pmu->filter_match() before scheduling in an event, although I haven't heard
of such a SoC existing (does not mean it doesn't exist!).

Thanks,
Alex

> 
> Thanks,
> Reiji
> 
> 
> >
> > > +                     ret = 0;
> > > +                     preempt_enable();
> > > +                     break;
> > > +             }
> > > +
> > >               kvm_pmu_flush_hwstate(vcpu);
> > >
> > >               local_irq_disable();
> > > diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> > > index 618138c5f792..471fe0f734ed 100644
> > > --- a/arch/arm64/kvm/pmu-emul.c
> > > +++ b/arch/arm64/kvm/pmu-emul.c
> > > @@ -954,6 +954,7 @@ static int kvm_arm_pmu_v3_set_pmu(struct kvm_vcpu *vcpu, int pmu_id)
> > >               arm_pmu = entry->arm_pmu;
> > >               if (arm_pmu->pmu.type == pmu_id) {
> > >                       kvm_pmu->arm_pmu = arm_pmu;
> > > +                     cpumask_copy(vcpu->arch.supported_cpus, &arm_pmu->supported_cpus);
> > >                       ret = 0;
> > >                       goto out_unlock;
> > >               }
> > > --
> > > 2.34.1
> > >
> > > _______________________________________________
> > > kvmarm mailing list
> > > kvmarm@lists.cs.columbia.edu
> > > https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
> > _______________________________________________
> > kvmarm mailing list
> > kvmarm@lists.cs.columbia.edu
> > https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
