From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [RFC PATCH 2/2] KVM: arm64: Eliminate most redundant FPSIMD
 saves and restores
Date: Fri, 2 Mar 2018 12:17:56 +0000
Message-ID: <20180302121752.GF32331@e103592.cambridge.arm.com>
References: <1518805771-15346-1-git-send-email-Dave.Martin@arm.com>
 <1518805771-15346-3-git-send-email-Dave.Martin@arm.com>
 <20180223170844.GB7396@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20180223170844.GB7396@cbox>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Feb 23, 2018 at 06:08:44PM +0100, Christoffer Dall wrote:
> Hi Dave,

Thanks for the input, and apologies for the slow response on this...

> On Fri, Feb 16, 2018 at 06:29:31PM +0000, Dave Martin wrote:
> > Currently, KVM doesn't know how host tasks interact with the cpu
> > FPSIMD regs, and the host doesn't knoe how vcpus interact with the
> > regs.  As a result, KVM must currently switch the FPSIMD state
> > rather defensively in order to avoid anybody's state getting
> > corrupted: in particular, the host and guest FPSIMD state must be
> > fully swapped on each iteration of the run loop.
> > 
> > This patch integrates KVM more closely with the host FPSIMD context
> > switch machinery, to enable better tracking of whose state is in
> > the FPSIMD regs.  This brings some advantages: KVM can tell whether
> > the host has any live state in the regs and can avoid saving them
> > if not; also, KVM can tell when and if the host clobbers the vcpu
> > state in the regs, to avoid reloading them before reentering the
> > guest.
> > 
> > As well as avoiding the host state being unecessarily saved, this
> > should also mean that the vcpu state can survive context switch
> > when there is no kernel-mode NEON use and no entry to userspace,
> > such as when ancillary kernel threads preempt a vcpu.
> > 
> > This patch cannot eliminate the need to save the guest context
> > eefore enabling interrupts, becuase softirqs may use kernel- mode
> > NEON and trash the vcpu regs.  However, provding that doesn't
> > happen the reload cost is at least saved on the next run loop
> > iteration.
> > 
> > Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> > 
> > ---
> > 
> > Caveat: this does *not* currently deal properly with host SVE state,
> > though supporting that shouldn't be drastically different.
> 
> It's a bit outside the capacity of my brain to think about that a well
> for the moment, but if we can agree on the overall approach of doing
> FPSIMD first, then hopefully I can understand the SVE challenge later.
> 
> > ---
> >  arch/arm64/include/asm/fpsimd.h      |  1 +
> >  arch/arm64/include/asm/kvm_host.h    | 10 +++++++-
> >  arch/arm64/include/asm/thread_info.h |  1 +
> >  arch/arm64/include/uapi/asm/kvm.h    | 14 +++++-----
> >  arch/arm64/kernel/fpsimd.c           |  7 ++++-
> >  arch/arm64/kvm/hyp/switch.c          | 21 +++++++++------
> >  virt/kvm/arm/arm.c                   | 50 ++++++++++++++++++++++++++++++++++++
> >  7 files changed, 88 insertions(+), 16 deletions(-)
> > 
> > diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsimd.h
> > index f4ce4d6..1f78631 100644
> > --- a/arch/arm64/include/asm/fpsimd.h
> > +++ b/arch/arm64/include/asm/fpsimd.h
> > @@ -76,6 +76,7 @@ extern void fpsimd_preserve_current_state(void);
> >  extern void fpsimd_restore_current_state(void);
> >  extern void fpsimd_update_current_state(struct user_fpsimd_state const *state);
> >  
> > +extern void fpsimd_flush_state(struct fpsimd_state *state);
> >  extern void fpsimd_flush_task_state(struct task_struct *target);
> >  extern void sve_flush_cpu_state(void);
> >  
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index b463b5e..95ffb54 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -192,7 +192,13 @@ enum vcpu_sysreg {
> >  #define NR_COPRO_REGS	(NR_SYS_REGS * 2)
> >  
> >  struct kvm_cpu_context {
> > -	struct kvm_regs	gp_regs;
> > +	union {
> > +		struct kvm_regs	gp_regs;
> > +		struct {
> > +			__KVM_REGS_COMMON
> 
> This is clearly horrible, and I hope we can potentially avoid this by
> refering to the user_fpsimd_state directly where needed instead.

Note, this RFC series is a big open-coded bodge, and I make no claim
that it takes an optimal or clean approach yet...


For struct kvm_cpu_context, the problem I hit was that this internal
struct is exposed rather directly to userspace via ioctl, yet the host-
side context tracking logic requires additional contents.

There are various possible solutions, but what I propose here is not one
of them!  It's just a cheap hack that minimises the amount of code that
needs to change elsewhere.

> 
> > +			struct fpsimd_state fpsimd_state;
> > +		};
> > +	};
> >  	union {
> >  		u64 sys_regs[NR_SYS_REGS];
> >  		u32 copro[NR_COPRO_REGS];
> > @@ -235,6 +241,8 @@ struct kvm_vcpu_arch {
> >  
> >  	/* Pointer to host CPU context */
> >  	kvm_cpu_context_t *host_cpu_context;
> > +	struct user_fpsimd_state *host_fpsimd_state; /* hyp va */
> > +	bool guest_fpsimd_loaded;
> >  	struct {
> >  		/* {Break,watch}point registers */
> >  		struct kvm_guest_debug_arch regs;
> > diff --git a/arch/arm64/include/asm/thread_info.h b/arch/arm64/include/asm/thread_info.h
> > index 740aa03c..9f1fa1a 100644
> > --- a/arch/arm64/include/asm/thread_info.h
> > +++ b/arch/arm64/include/asm/thread_info.h
> > @@ -94,6 +94,7 @@ void arch_release_task_struct(struct task_struct *tsk);
> >  #define TIF_32BIT		22	/* 32bit process */
> >  #define TIF_SVE			23	/* Scalable Vector Extension in use */
> >  #define TIF_SVE_VL_INHERIT	24	/* Inherit sve_vl_onexec across exec */
> > +#define TIF_MAPPED_TO_HYP	25	/* task_struct mapped to Hyp (KVM) */
> >  
> >  #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
> >  #define _TIF_NEED_RESCHED	(1 << TIF_NEED_RESCHED)
> > diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> > index 9abbf30..c3392d2 100644
> > --- a/arch/arm64/include/uapi/asm/kvm.h
> > +++ b/arch/arm64/include/uapi/asm/kvm.h
> > @@ -45,14 +45,16 @@
> >  #define KVM_REG_SIZE(id)						\
> >  	(1U << (((id) & KVM_REG_SIZE_MASK) >> KVM_REG_SIZE_SHIFT))
> >  
> > -struct kvm_regs {
> > -	struct user_pt_regs regs;	/* sp = sp_el0 */
> > -
> > -	__u64	sp_el1;
> > -	__u64	elr_el1;
> > -
> > +#define __KVM_REGS_COMMON					\
> > +	struct user_pt_regs regs;	/* sp = sp_el0 */	\
> > +								\
> > +	__u64	sp_el1;						\
> > +	__u64	elr_el1;					\
> > +								\
> >  	__u64	spsr[KVM_NR_SPSR];
> >  
> > +struct kvm_regs {
> > +	__KVM_REGS_COMMON
> >  	struct user_fpsimd_state fp_regs;
> >  };
> >  
> > diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
> > index 138efaf..c46e11f 100644
> > --- a/arch/arm64/kernel/fpsimd.c
> > +++ b/arch/arm64/kernel/fpsimd.c
> > @@ -1073,12 +1073,17 @@ void fpsimd_update_current_state(struct user_fpsimd_state const *state)
> >  	local_bh_enable();
> >  }
> >  
> > +void fpsimd_flush_state(struct fpsimd_state *st)
> > +{
> > +	st->cpu = NR_CPUS;
> > +}
> > +
> >  /*
> >   * Invalidate live CPU copies of task t's FPSIMD state
> >   */
> >  void fpsimd_flush_task_state(struct task_struct *t)
> >  {
> > -	t->thread.fpsimd_state.cpu = NR_CPUS;
> > +	fpsimd_flush_state(&t->thread.fpsimd_state);
> >  }
> >  
> >  static inline void fpsimd_flush_cpu_state(void)
> > diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> > index a0a63bc..b88e83f 100644
> > --- a/arch/arm64/kvm/hyp/switch.c
> > +++ b/arch/arm64/kvm/hyp/switch.c
> > @@ -91,7 +91,11 @@ static inline void activate_traps_vhe(struct kvm_vcpu *vcpu)
> >  
> >  	val = read_sysreg(cpacr_el1);
> >  	val |= CPACR_EL1_TTA;
> > -	val &= ~(CPACR_EL1_FPEN | CPACR_EL1_ZEN);
> > +
> > +	val &= ~CPACR_EL1_ZEN;
> > +	if (!vcpu->arch.guest_fpsimd_loaded)
> > +		val &= ~CPACR_EL1_FPEN;
> > +
> >  	write_sysreg(val, cpacr_el1);
> >  
> >  	write_sysreg(kvm_get_hyp_vector(), vbar_el1);
> > @@ -104,7 +108,10 @@ static inline void __hyp_text __activate_traps_nvhe(struct kvm_vcpu *vcpu)
> >  	__activate_traps_common(vcpu);
> >  
> >  	val = CPTR_EL2_DEFAULT;
> > -	val |= CPTR_EL2_TTA | CPTR_EL2_TFP | CPTR_EL2_TZ;
> > +	val |= CPTR_EL2_TTA | CPTR_EL2_TZ;
> > +	if (!vcpu->arch.guest_fpsimd_loaded)
> > +		val |= CPTR_EL2_TFP;
> > +
> >  	write_sysreg(val, cptr_el2);
> >  }
> >  
> > @@ -423,7 +430,6 @@ int kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
> >  
> >  	if (fp_enabled) {
> >  		__fpsimd_save_state(&guest_ctxt->gp_regs.fp_regs);
> > -		__fpsimd_restore_state(&host_ctxt->gp_regs.fp_regs);
> >  		__fpsimd_save_fpexc32(vcpu);
> >  	}
> >  
> > @@ -491,7 +497,6 @@ int __hyp_text __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu)
> >  
> >  	if (fp_enabled) {
> >  		__fpsimd_save_state(&guest_ctxt->gp_regs.fp_regs);
> > -		__fpsimd_restore_state(&host_ctxt->gp_regs.fp_regs);
> >  		__fpsimd_save_fpexc32(vcpu);
> >  	}
> >  
> > @@ -507,8 +512,6 @@ int __hyp_text __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu)
> >  void __hyp_text __hyp_switch_fpsimd(u64 esr __always_unused,
> >  				    struct kvm_vcpu *vcpu)
> >  {
> > -	kvm_cpu_context_t *host_ctxt;
> > -
> >  	if (has_vhe())
> >  		write_sysreg(read_sysreg(cpacr_el1) | CPACR_EL1_FPEN,
> >  			     cpacr_el1);
> > @@ -518,9 +521,11 @@ void __hyp_text __hyp_switch_fpsimd(u64 esr __always_unused,
> >  
> >  	isb();
> >  
> > -	host_ctxt = kern_hyp_va(vcpu->arch.host_cpu_context);
> > -	__fpsimd_save_state(&host_ctxt->gp_regs.fp_regs);
> > +	if (vcpu->arch.host_fpsimd_state)
> > +		__fpsimd_save_state(vcpu->arch.host_fpsimd_state);
> > +
> >  	__fpsimd_restore_state(&vcpu->arch.ctxt.gp_regs.fp_regs);
> > +	vcpu->arch.guest_fpsimd_loaded = true;
> >  
> >  	/* Skip restoring fpexc32 for AArch64 guests */
> >  	if (!(read_sysreg(hcr_el2) & HCR_RW))
> > diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> > index 6de7641..0330e1f 100644
> > --- a/virt/kvm/arm/arm.c
> > +++ b/virt/kvm/arm/arm.c
> > @@ -329,6 +329,10 @@ void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu)
> >  
> >  int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
> >  {
> > +	/* Mark this vcpu's FPSIMD state as non-live initially: */
> > +	fpsimd_flush_state(&vcpu->arch.ctxt.fpsimd_state);
> > +	vcpu->arch.guest_fpsimd_loaded = false;
> > +
> >  	/* Force users to call KVM_ARM_VCPU_INIT */
> >  	vcpu->arch.target = -1;
> >  	bitmap_zero(vcpu->arch.features, KVM_VCPU_MAX_FEATURES);
> > @@ -631,6 +635,9 @@ static void check_vcpu_requests(struct kvm_vcpu *vcpu)
> >  int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
> >  {
> >  	int ret;
> > +	struct fpsimd_state *guest_fpsimd = &vcpu->arch.ctxt.fpsimd_state;
> > +	struct user_fpsimd_state *host_fpsimd =
> > +		&current->thread.fpsimd_state.user_fpsimd;
> >  
> >  	if (unlikely(!kvm_vcpu_initialized(vcpu)))
> >  		return -ENOEXEC;
> > @@ -650,6 +657,17 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
> >  	if (run->immediate_exit)
> >  		return -EINTR;
> >  
> > +	WARN_ON(!current->mm);
> > +
> > +	if (!test_thread_flag(TIF_MAPPED_TO_HYP)) {
> > +		ret = create_hyp_mappings(host_fpsimd, host_fpsimd + 1,
> > +					  PAGE_HYP);
> > +		if (ret)
> > +			return ret;
> > +
> > +		set_thread_flag(TIF_MAPPED_TO_HYP);
> > +	}
> > +
> 
> I have an alternate approach to this, see below.
> 
> >  	vcpu_load(vcpu);
> >  
> >  	kvm_sigset_activate(vcpu);
> > @@ -680,6 +698,23 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
> >  
> >  		local_irq_disable();
> >  
> > +		/*
> > +		 * host_fpsimd_state indicates to hyp that there is host state
> > +		 * to save, and where to save it:
> > +		 */
> > +		if (test_thread_flag(TIF_FOREIGN_FPSTATE))
> > +			vcpu->arch.host_fpsimd_state = NULL;
> > +		else
> > +			vcpu->arch.host_fpsimd_state = kern_hyp_va(host_fpsimd);
> > +
> > +		vcpu->arch.guest_fpsimd_loaded =
> > +			!fpsimd_foreign_fpstate(guest_fpsimd);
> 
> This is an awful lot of logic in the critical path...

Are you concerned about cost here, or complexity, or both?

I don't have a good feel for the overall cost of world switch yet.


There should be scope for pushing some work outside the loop, but for
now I didn't want to make too many assumptions.

> > +
> > +		BUG_ON(system_supports_sve());
> > +
> > +		BUG_ON(vcpu->arch.guest_fpsimd_loaded &&
> > +		       vcpu->arch.host_fpsimd_state);
> > +
> >  		kvm_vgic_flush_hwstate(vcpu);
> >  
> >  		/*
> > @@ -774,6 +809,9 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
> >  		if (static_branch_unlikely(&userspace_irqchip_in_use))
> >  			kvm_timer_sync_hwstate(vcpu);
> >  
> > +		/* defend against kernel-mode NEON in softirq */
> > +		local_bh_disable();
> > +
> >  		/*
> >  		 * We may have taken a host interrupt in HYP mode (ie
> >  		 * while executing the guest). This interrupt is still
> > @@ -786,6 +824,18 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
> >  		 */
> >  		local_irq_enable();
> >  
> > +		if (vcpu->arch.guest_fpsimd_loaded) {
> > +			set_thread_flag(TIF_FOREIGN_FPSTATE);
> > +			fpsimd_bind_state_to_cpu(&vcpu->arch.ctxt.fpsimd_state);
> > +
> > +			/*
> > +			 * Protect ourselves against a softirq splatting the
> > +			 * FPSIMD state once irqs are enabled:
> > +			 */
> > +			fpsimd_save_state(guest_fpsimd);
> > +		}
> > +		local_bh_enable();
> > +
> 
> And this seems farily involved as well.  The overlapping

Note, part of the reason this looks a mess is that I didn't want to
factor prematurely, or give a misleading impression of how much work
needs to be done here.

> local_bh_disable with enabling irqs doesn't fell very nice, although it
> may be correct.

I know what you mean, but this does crop up as a natural pattern when
considering conditional critical sections.  Because we're not dealing
with an asynchronous event here though, we could move the
local_bh_disable() to be unconditional, outside local_irq_disable().

(Anyway, this is a digression because this is all a big hack ;)

> The main issue is that we still save the guest FPSIMD state on every
> exit from the guest.
> 
> >  		/*
> >  		 * We do local_irq_enable() before calling guest_exit() so
> >  		 * that if a timer interrupt hits while running the guest we
> > -- 
> > 2.1.4
> > 
> 
> Building on these patches, I tried putting together something along the
> lines of what I had imagined, but it's still untested (read, it doesn't
> actually work).  If you think the approach is not completely crazy, I'm
> happy to test it, and make it work for 32-bit etc.
> 
> commit e3f20ac5eab166d9257710486b9ceafb034195bf
> Author: Christoffer Dall <christoffer.dall@linaro.org>
> Date:   Fri Feb 23 17:23:57 2018 +0100
> 
>     KVM: arm/arm64: Introduce kvm_arch_vcpu_run_pid_change
>     
>     KVM/ARM differs from other architectures in having to maintain an
>     additional virtual address space from that of the host and the guest,
>     because we split the execution of KVM across both EL1 and EL2.
>     
>     This results in a need to explicitly map data structures into EL2 (hyp)
>     which are accessed from the hyp code.  As we are about to be more clever
>     with our FPSIMD handling, which stores data on the task struct and uses
>     thread_info flags, we have to map the currently executing task struct
>     into the EL2 virtual address space.
>     
>     However, we don't want to do this on every KVM_RUN, because it is a
>     fairly expensive operation to walk the page tables, and the common
>     execution mode is to map a single thread to a VCPU.  By introducing a
>     hook that architectures can select with HAVE_KVM_VCPU_RUN_PID_CHANGE, we
>     do not introduce overhead for other architectures, but have a simple way
>     to only map the data we need when required for arm64.
>     
>     Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> 
> diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
> index 2257dfcc44cc..5b2c8d8c9722 100644
> --- a/arch/arm64/kvm/Kconfig
> +++ b/arch/arm64/kvm/Kconfig
> @@ -39,6 +39,7 @@ config KVM
>  	select HAVE_KVM_IRQ_ROUTING
>  	select IRQ_BYPASS_MANAGER
>  	select HAVE_KVM_IRQ_BYPASS
> +	select HAVE_KVM_VCPU_RUN_PID_CHANGE
>  	---help---
>  	  Support hosting virtualized guest machines.
>  	  We don't support KVM with 16K page tables yet, due to the multiple
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index ac0062b74aed..10a37b122f6f 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1272,4 +1272,13 @@ static inline long kvm_arch_vcpu_async_ioctl(struct file *filp,
>  }
>  #endif /* CONFIG_HAVE_KVM_VCPU_ASYNC_IOCTL */
>  
> +#ifdef CONFIG_HAVE_KVM_VCPU_RUN_PID_CHANGE
> +int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu);
> +#else
> +static inline int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
> +{
> +	return 0;
> +}
> +#endif /* CONFIG_HAVE_KVM_VCPU_RUN_PID_CHANGE */
> +
>  #endif
> diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
> index cca7e065a075..72143cfaf6ec 100644
> --- a/virt/kvm/Kconfig
> +++ b/virt/kvm/Kconfig
> @@ -54,3 +54,6 @@ config HAVE_KVM_IRQ_BYPASS
>  
>  config HAVE_KVM_VCPU_ASYNC_IOCTL
>         bool
> +
> +config HAVE_KVM_VCPU_RUN_PID_CHANGE
> +       bool
> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> index 0330e1f8fb09..99eb52559f24 100644
> --- a/virt/kvm/arm/arm.c
> +++ b/virt/kvm/arm/arm.c
> @@ -867,6 +867,23 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  	return ret;
>  }
>  
> +#ifdef CONFIG_ARM64
> +int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
> +{
> +	struct task_struct *tsk = current;
> +	int ret;
> +
> +	/*
> +	 * Make sure struct thread_info (and TIF flags) and the fpsimd state
> +	 * are visible to hyp.
> +	 */
> +	ret = create_hyp_mappings(tsk, tsk + 1, PAGE_HYP);
> +	if (!ret)
> +		vcpu->arch.hyp_current = kern_hyp_va(current);
> +	return ret;
> +}
> +#endif
> +
>  static int vcpu_interrupt_line(struct kvm_vcpu *vcpu, int number, bool level)
>  {
>  	int bit_index;
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 4501e658e8d6..dbd35abe7d9c 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2551,8 +2551,13 @@ static long kvm_vcpu_ioctl(struct file *filp,
>  		oldpid = rcu_access_pointer(vcpu->pid);
>  		if (unlikely(oldpid != current->pids[PIDTYPE_PID].pid)) {
>  			/* The thread running this VCPU changed. */
> -			struct pid *newpid = get_task_pid(current, PIDTYPE_PID);
> +			struct pid *newpid;
>  
> +			r = kvm_arch_vcpu_run_pid_change(vcpu);

Sure, this looks like a better approach.  I hadn't fully understood what
assumptions we do/don't make about the association between pid and vcpu:
since there is already logic for this, it totally makes sense to handle
the task_struct remapping via a hook here rather than reinventing it
deeper inside the run ioctl...

> +			if (r)
> +				break;
> +
> +			newpid = get_task_pid(current, PIDTYPE_PID);
>  			rcu_assign_pointer(vcpu->pid, newpid);
>  			if (oldpid)
>  				synchronize_rcu();
> 
> commit 6bb55488489d69885b51819add3690da523be12a (HEAD -> kvm-vfp-integration-rfc)
> Author: Christoffer Dall <christoffer.dall@linaro.org>
> Date:   Fri Feb 23 17:58:17 2018 +0100
> 
>     KVM: arm64: Be more lazy with switching KVM guest FPSIMD state
>     
>     We currently save the FPSIMD state back from the CPU on every exit, when
>     the guest has touched the FPSIMD state.
>     
>     We can try to avoid this by changing the state that is tracked by the
>     kernel FPSIMD mechanism to the KVM guest state, and keep track of this
>     using additional thread flag.  Whenever we go back to userspace from the
>     KVM_RUN ioctl, we check if we switched to the KVM state, and make sure
>     the state is copied back.
>     
>     Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 95ffb54daec2..df819376ae9a 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -241,8 +241,14 @@ struct kvm_vcpu_arch {
>  
>  	/* Pointer to host CPU context */
>  	kvm_cpu_context_t *host_cpu_context;
> -	struct user_fpsimd_state *host_fpsimd_state; /* hyp va */
> -	bool guest_fpsimd_loaded;
> +	struct task_struct *hyp_current;
> +
> +	/*
> +	 * If FPSIMD registers are valid when entering the guest, this is
> +	 * where we store the host userspace register state.
> +	 */
> +	struct user_fpsimd_state host_fpsimd_state;
> +

If we have this in the vcpu, what's the point of mapping task_struct
into hyp?  Conversely, if we must map task_struct into hyp anyway for
other reasons, what's the point of putting this data in the vcpu struct
and then subsequently having to copy/reload it when we get back to the
host?

>  	struct {
>  		/* {Break,watch}point registers */
>  		struct kvm_guest_debug_arch regs;
> diff --git a/arch/arm64/include/asm/thread_info.h b/arch/arm64/include/asm/thread_info.h
> index 9f1fa1a49bb4..6ec3c8b51898 100644
> --- a/arch/arm64/include/asm/thread_info.h
> +++ b/arch/arm64/include/asm/thread_info.h
> @@ -94,7 +94,7 @@ void arch_release_task_struct(struct task_struct *tsk);
>  #define TIF_32BIT		22	/* 32bit process */
>  #define TIF_SVE			23	/* Scalable Vector Extension in use */
>  #define TIF_SVE_VL_INHERIT	24	/* Inherit sve_vl_onexec across exec */
> -#define TIF_MAPPED_TO_HYP	25	/* task_struct mapped to Hyp (KVM) */
> +#define TIF_KVM_GUEST_FPSTATE	25	/* current's FP state belongs to KVM */
>  
>  #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
>  #define _TIF_NEED_RESCHED	(1 << TIF_NEED_RESCHED)
> diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> index b88e83fc76c8..a1034e880d6e 100644
> --- a/arch/arm64/kvm/hyp/switch.c
> +++ b/arch/arm64/kvm/hyp/switch.c
> @@ -17,6 +17,7 @@
>  
>  #include <linux/types.h>
>  #include <linux/jump_label.h>
> +#include <linux/thread_info.h>
>  #include <uapi/linux/psci.h>
>  
>  #include <kvm/arm_psci.h>
> @@ -28,6 +29,15 @@
>  #include <asm/fpsimd.h>
>  #include <asm/debug-monitors.h>
>  
> +#define hyp_current(vcpu) ((vcpu)->arch.hyp_current)
> +
> +#define hyp_set_thread_flag(vcpu, flag) \
> +	set_ti_thread_flag(&hyp_current(vcpu)->thread_info, flag)
> +#define hyp_clear_thread_flag(vcpu, flag) \
> +	clear_ti_thread_flag(&hyp_current(vcpu)->thread_info, flag)
> +#define hyp_test_thread_flag(vcpu, flag) \
> +	test_ti_thread_flag(&hyp_current(vcpu)->thread_info, flag)
> +

This seems a lot of effort to go to just to give hyp a single flag it
can communicate to the host.

Simply copying the flag in and out from the run loop (as I currently do)
feels probably cheaper, but I'm only guessing...

>  static bool __hyp_text __fpsimd_enabled_nvhe(void)
>  {
>  	return !(read_sysreg(cptr_el2) & CPTR_EL2_TFP);
> @@ -85,7 +95,7 @@ static void __hyp_text __deactivate_traps_common(void)
>  	write_sysreg(0, pmuserenr_el0);
>  }
>  
> -static inline void activate_traps_vhe(struct kvm_vcpu *vcpu)
> +static void __hyp_text activate_traps_vhe(struct kvm_vcpu *vcpu)
>  {
>  	u64 val;
>  
> @@ -93,7 +103,8 @@ static inline void activate_traps_vhe(struct kvm_vcpu *vcpu)
>  	val |= CPACR_EL1_TTA;
>  
>  	val &= ~CPACR_EL1_ZEN;
> -	if (!vcpu->arch.guest_fpsimd_loaded)
> +	if (!hyp_test_thread_flag(vcpu, TIF_KVM_GUEST_FPSTATE) ||
> +	    hyp_test_thread_flag(vcpu, TIF_FOREIGN_FPSTATE))
>  		val &= ~CPACR_EL1_FPEN;
>  
>  	write_sysreg(val, cpacr_el1);
> @@ -109,7 +120,8 @@ static inline void __hyp_text __activate_traps_nvhe(struct kvm_vcpu *vcpu)
>  
>  	val = CPTR_EL2_DEFAULT;
>  	val |= CPTR_EL2_TTA | CPTR_EL2_TZ;
> -	if (!vcpu->arch.guest_fpsimd_loaded)
> +	if (!hyp_test_thread_flag(vcpu, TIF_KVM_GUEST_FPSTATE) ||
> +	    hyp_test_thread_flag(vcpu, TIF_FOREIGN_FPSTATE))
>  		val |= CPTR_EL2_TFP;
>  
>  	write_sysreg(val, cptr_el2);
> @@ -512,6 +524,13 @@ int __hyp_text __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu)
>  void __hyp_text __hyp_switch_fpsimd(u64 esr __always_unused,
>  				    struct kvm_vcpu *vcpu)
>  {
> +	struct user_fpsimd_state *current_fpsimd =
> +		&hyp_current(vcpu)->thread.fpsimd_state.user_fpsimd;
> +	struct user_fpsimd_state *guest_fpsimd =
> +		&vcpu->arch.ctxt.gp_regs.fp_regs;
> +	struct user_fpsimd_state *host_fpsimd =
> +		&vcpu->arch.host_fpsimd_state;
> +
>  	if (has_vhe())
>  		write_sysreg(read_sysreg(cpacr_el1) | CPACR_EL1_FPEN,
>  			     cpacr_el1);
> @@ -521,11 +540,27 @@ void __hyp_text __hyp_switch_fpsimd(u64 esr __always_unused,
>  
>  	isb();
>  
> -	if (vcpu->arch.host_fpsimd_state)
> -		__fpsimd_save_state(vcpu->arch.host_fpsimd_state);
> +	/*
> +	 * We trapped on guest FPSIMD access.  There are two situations:
> +	 *   (1) This is the first use of FPSIMD by the guest for this ioctl
> +	 *       invocation.  We make sure the host userspace state is backed
> +	 *       up (either from the CPU or from memory).
> +	 *   (2) We were preempted or a softirq called kernel_neon_being.  We
> +	 *       rely on the kernel fpsimd machinery to have saved our state
> +	 *       and we simply restore it.
> +	 */
> +	if (!hyp_test_thread_flag(vcpu, TIF_KVM_GUEST_FPSTATE)) {
> +		if (!hyp_test_thread_flag(vcpu, TIF_FOREIGN_FPSTATE))
> +			__fpsimd_save_state(host_fpsimd);
> +		else
> +			memcpy(host_fpsimd, current_fpsimd, sizeof(*host_fpsimd));
> +		__fpsimd_restore_state(guest_fpsimd);
> +	} else {
> +		__fpsimd_restore_state(current_fpsimd);
> +	}
>  
> -	__fpsimd_restore_state(&vcpu->arch.ctxt.gp_regs.fp_regs);
> -	vcpu->arch.guest_fpsimd_loaded = true;
> +	hyp_clear_thread_flag(vcpu, TIF_FOREIGN_FPSTATE);
> +	hyp_set_thread_flag(vcpu, TIF_KVM_GUEST_FPSTATE);
>  
>  	/* Skip restoring fpexc32 for AArch64 guests */
>  	if (!(read_sysreg(hcr_el2) & HCR_RW))
> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> index 99eb52559f24..2fe59aff2099 100644
> --- a/virt/kvm/arm/arm.c
> +++ b/virt/kvm/arm/arm.c
> @@ -329,10 +329,6 @@ void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu)
>  
>  int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
>  {
> -	/* Mark this vcpu's FPSIMD state as non-live initially: */
> -	fpsimd_flush_state(&vcpu->arch.ctxt.fpsimd_state);
> -	vcpu->arch.guest_fpsimd_loaded = false;
> -
>  	/* Force users to call KVM_ARM_VCPU_INIT */
>  	vcpu->arch.target = -1;
>  	bitmap_zero(vcpu->arch.features, KVM_VCPU_MAX_FEATURES);
> @@ -635,9 +631,6 @@ static void check_vcpu_requests(struct kvm_vcpu *vcpu)
>  int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  {
>  	int ret;
> -	struct fpsimd_state *guest_fpsimd = &vcpu->arch.ctxt.fpsimd_state;
> -	struct user_fpsimd_state *host_fpsimd =
> -		&current->thread.fpsimd_state.user_fpsimd;
>  
>  	if (unlikely(!kvm_vcpu_initialized(vcpu)))
>  		return -ENOEXEC;
> @@ -659,15 +652,6 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  
>  	WARN_ON(!current->mm);
>  
> -	if (!test_thread_flag(TIF_MAPPED_TO_HYP)) {
> -		ret = create_hyp_mappings(host_fpsimd, host_fpsimd + 1,
> -					  PAGE_HYP);
> -		if (ret)
> -			return ret;
> -
> -		set_thread_flag(TIF_MAPPED_TO_HYP);
> -	}
> -
>  	vcpu_load(vcpu);
>  
>  	kvm_sigset_activate(vcpu);
> @@ -698,23 +682,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  
>  		local_irq_disable();
>  
> -		/*
> -		 * host_fpsimd_state indicates to hyp that there is host state
> -		 * to save, and where to save it:
> -		 */
> -		if (test_thread_flag(TIF_FOREIGN_FPSTATE))
> -			vcpu->arch.host_fpsimd_state = NULL;
> -		else
> -			vcpu->arch.host_fpsimd_state = kern_hyp_va(host_fpsimd);
> -
> -		vcpu->arch.guest_fpsimd_loaded =
> -			!fpsimd_foreign_fpstate(guest_fpsimd);
> -
>  		BUG_ON(system_supports_sve());
>  
> -		BUG_ON(vcpu->arch.guest_fpsimd_loaded &&
> -		       vcpu->arch.host_fpsimd_state);
> -
>  		kvm_vgic_flush_hwstate(vcpu);
>  
>  		/*
> @@ -809,9 +778,6 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  		if (static_branch_unlikely(&userspace_irqchip_in_use))
>  			kvm_timer_sync_hwstate(vcpu);
>  
> -		/* defend against kernel-mode NEON in softirq */
> -		local_bh_disable();
> -
>  		/*
>  		 * We may have taken a host interrupt in HYP mode (ie
>  		 * while executing the guest). This interrupt is still
> @@ -824,18 +790,6 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  		 */
>  		local_irq_enable();
>  
> -		if (vcpu->arch.guest_fpsimd_loaded) {
> -			set_thread_flag(TIF_FOREIGN_FPSTATE);
> -			fpsimd_bind_state_to_cpu(&vcpu->arch.ctxt.fpsimd_state);
> -
> -			/*
> -			 * Protect ourselves against a softirq splatting the
> -			 * FPSIMD state once irqs are enabled:
> -			 */
> -			fpsimd_save_state(guest_fpsimd);
> -		}
> -		local_bh_enable();
> -
>  		/*
>  		 * We do local_irq_enable() before calling guest_exit() so
>  		 * that if a timer interrupt hits while running the guest we
> @@ -863,6 +817,25 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  
>  	kvm_sigset_deactivate(vcpu);
>  
> +	if (test_thread_flag(TIF_KVM_GUEST_FPSTATE)) {

How does that flag get cleared?  Should this be
test_and_clear_thread_flag()?

> +		struct user_fpsimd_state *current_fpsimd =
> +			&current->thread.fpsimd_state.user_fpsimd;
> +		struct user_fpsimd_state *guest_fpsimd =
> +			&vcpu->arch.ctxt.gp_regs.fp_regs;
> +		struct user_fpsimd_state *host_fpsimd =
> +			&vcpu->arch.host_fpsimd_state;
> +
> +		local_bh_disable();
> +		if (!test_thread_flag(TIF_FOREIGN_FPSTATE))
> +			__fpsimd_save_state(guest_fpsimd);
> +		else
> +			memcpy(guest_fpsimd, current_fpsimd, sizeof(*guest_fpsimd));

Eh?

> +
> +		memcpy(current_fpsimd, host_fpsimd, sizeof(*current_fpsimd));
> +		set_thread_flag(TIF_FOREIGN_FPSTATE);
> +		local_bh_enable();
> +	}
> +
>  	vcpu_put(vcpu);
>  	return ret;
>  }

So, if I understand correctly we page the vcpu's fpsimd state in and
out of current->thread.fpsimd_state.  If preempted in the run loop,
then the host will treat the fpsimd regs as belonging to the host task
and save them as normal, while KVM has the real host regs stashed off
in the vcpu struct.  Exit from the run loop for any reason is required
to restore current->thread.fpsimd_state with the host data.

This adds some cost, but outside the loop.  It also doesn't allow the
guest fpsimd state to linger in the CPU across preemption and be
subsequently reused without reloading -- this was my end goal, but
would have optimised a rare case and may not be the best idea unless it
brings simplification elsewhere.

If ptrace can extract the regs while in the run loop then we would have
a problem, but I don't think this is possible.  None of the ptrace hooks
are included on this path IIUC.


I need to have a think about this, but the overall idea seems sound for
the FPSIMD-only case.  I'm a little concerned about how it would be
extended for SVE, since SVE is still a separately allocated block that's
not part of thread_struct, and the host's SVE context block will not
necessarily be large enough to store the guest's SVE state etc.


I still have some work to do on my approach and I'd like to see where
I can get to -- however, between the two I think a good hybrid can be
found.

Cheers
---Dave
