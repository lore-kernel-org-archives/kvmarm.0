From: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [RFC PATCH 3/8] KVM: arm64: Optimise FPSIMD handling to reduce
 guest/host thrashing
Date: Thu, 26 Apr 2018 13:21:22 +0200
Message-ID: <20180426112122.GB13249@C02W217FHV2R.local>
References: <1524242802-21163-1-git-send-email-Dave.Martin@arm.com>
 <1524242802-21163-4-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6088D49F8B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Apr 2018 07:12:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id l4qOe9i2+YVC for <kvmarm@lists.cs.columbia.edu>;
 Thu, 26 Apr 2018 07:11:58 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 89D9549EA4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Apr 2018 07:11:58 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <1524242802-21163-4-git-send-email-Dave.Martin@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Dave Martin <Dave.Martin@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Christoffer Dall <cdall@kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Apr 20, 2018 at 05:46:37PM +0100, Dave Martin wrote:
> This patch refactors KVM to align the host and guest FPSIMD
> save/restore logic with each other for arm64.  This reduces the
> number of redundant save/restore operations that must occur, and
> reduces the common-case IRQ blackout time during guest exit storms
> by saving the host state lazily and optimising away the need to
> restore the host state before returning to the run loop.
> 
> Four hooks are defined in order to enable this:
> 
>  * kvm_arch_vcpu_run_map_fp():
>    Called on PID change to map necessary bits of current to Hyp.
> 
>  * kvm_arch_vcpu_load_fp():
>    Set up FP/SIMD for entering the KVM run loop (parse as
>    "vcpu_load fp").
> 
>  * kvm_arch_vcpu_park_fp():
>    Get FP/SIMD into a safe state for re-enabling interrupts after a
>    guest exit back to the run loop.
> 
>    For arm64 specifically, this involves updating the host kernel's
>    FPSIMD context tracking metadata so that kernel-mode NEON use
>    will cause the vcpu's FPSIMD state to be saved back correctly
>    into the vcpu struct.  This must be done before re-enabling
>    interrupts because kernel-mode NEON may be used my softirqs.
> 
>  * kvm_arch_vcpu_put_fp():
>    Save guest FP/SIMD state back to memory and dissociate from the
>    CPU ("vcpu_put fp").
> 
> Also, the arm64 FPSIMD context switch code is updated to enable it
> to save back FPSIMD state for a vcpu, not just current.  A few
> helpers drive this:
> 
>  * fpsimd_bind_state_to_cpu(struct user_fpsimd_state *fp):
>    mark this CPU as having context fp (which may belong to a vcpu)
>    currently loaded in its registers.  This is the non-task
>    equivalent of the static function fpsimd_bind_to_cpu() in
>    fpsimd.c.
> 
>  * task_fpsimd_save():
>    exported to allow KVM to save the guest's FPSIMD state back to
>    memory on exit from the run loop.
> 
>  * fpsimd_flush_state():
>    invalidate any context's FPSIMD state that is currently loaded.
>    Used to disassociate the vcpu from the CPU regs on run loop exit.
> 
> These changes allow the run loop to enable interrupts (and thus
> softirqs that may use kernel-mode NEON) without having to save the
> guest's FPSIMD state eagerly.
> 
> Some new vcpu_arch fields are added to make all this work.  Because
> host FPSIMD state can now be saved back directly into current's
> thread_struct as appropriate, host_cpu_context is no longer used
> for preserving the FPSIMD state.  However, it is still needed for
> preserving other things such as the host's system registers.  To
> avoid ABI churn, the redundant storage space in host_cpu_context is
> not removed for now.
> 
> arch/arm is not addressed by this patch and continues to use its
> current save/restore logic.  It could provide implementations of
> the helpers later if desired.
> 
> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> 
> ---
> 
> Changes since RFC v3:
> 
> Requested by Christoffer Dall:
> 
>  * Remove fpsimd_flush_state(), which nothing uses.
>    Inline it back into fpsimd_flush_task_state().
> 
>  * Add __hyp_text anootation to update_fp_enabled().
> 
> Other:
> 
>  * Remove fp_enabled().
> 
>    Now that we have an explicit field vcpu->arch.fp_enabled to
>    indicate whether the guest's FPSIMD state is loaded, we can use
>    this to determine when to save FPEXC_EL1 for 32-bit guests.
>    This brings the logic for FPEXC_EL1 save back into line with the
>    (updated) logic for restore of this register, and simplifies the
>    code a bit.
> 
> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> ---
>  arch/arm/include/asm/kvm_host.h   |   8 +++
>  arch/arm64/include/asm/fpsimd.h   |   5 ++
>  arch/arm64/include/asm/kvm_host.h |  18 +++++++
>  arch/arm64/kernel/fpsimd.c        |  24 ++++++---
>  arch/arm64/kvm/Makefile           |   2 +-
>  arch/arm64/kvm/fpsimd.c           | 109 ++++++++++++++++++++++++++++++++++++++
>  arch/arm64/kvm/hyp/switch.c       |  50 +++++++++--------
>  virt/kvm/arm/arm.c                |  14 ++---
>  8 files changed, 187 insertions(+), 43 deletions(-)
>  create mode 100644 arch/arm64/kvm/fpsimd.c
> 
> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
> index c6a7495..3fe01c7 100644
> --- a/arch/arm/include/asm/kvm_host.h
> +++ b/arch/arm/include/asm/kvm_host.h
> @@ -300,6 +300,14 @@ int kvm_arm_vcpu_arch_get_attr(struct kvm_vcpu *vcpu,
>  int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
>  			       struct kvm_device_attr *attr);
>  
> +/*
> + * VFP/NEON switching is all done by the hyp switch code, so no need to
> + * coordinate with host context handling for this state:
> + */
> +static inline void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu) {}
> +static inline void kvm_arch_vcpu_park_fp(struct kvm_vcpu *vcpu) {}
> +static inline void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu) {}
> +
>  /* All host FP/SIMD state is restored on guest exit, so nothing to save: */
>  static inline void kvm_fpsimd_flush_cpu_state(void) {}
>  
> diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsimd.h
> index aa7162a..a1c5127 100644
> --- a/arch/arm64/include/asm/fpsimd.h
> +++ b/arch/arm64/include/asm/fpsimd.h
> @@ -41,6 +41,8 @@ struct task_struct;
>  extern void fpsimd_save_state(struct user_fpsimd_state *state);
>  extern void fpsimd_load_state(struct user_fpsimd_state *state);
>  
> +extern void task_fpsimd_save(void);
> +
>  extern void fpsimd_thread_switch(struct task_struct *next);
>  extern void fpsimd_flush_thread(void);
>  
> @@ -49,7 +51,10 @@ extern void fpsimd_preserve_current_state(void);
>  extern void fpsimd_restore_current_state(void);
>  extern void fpsimd_update_current_state(struct user_fpsimd_state const *state);
>  
> +extern void fpsimd_bind_state_to_cpu(struct user_fpsimd_state *state);
> +
>  extern void fpsimd_flush_task_state(struct task_struct *target);
> +extern void fpsimd_flush_cpu_state(void);
>  extern void sve_flush_cpu_state(void);
>  
>  /* Maximum VL that SVE VL-agnostic software can transparently support */
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index ab46bc7..2fbfbda 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -30,6 +30,7 @@
>  #include <asm/kvm.h>
>  #include <asm/kvm_asm.h>
>  #include <asm/kvm_mmio.h>
> +#include <asm/thread_info.h>
>  
>  #define __KVM_HAVE_ARCH_INTC_INITIALIZED
>  
> @@ -235,6 +236,12 @@ struct kvm_vcpu_arch {
>  
>  	/* Pointer to host CPU context */
>  	kvm_cpu_context_t *host_cpu_context;
> +
> +	struct thread_info *host_thread_info;	/* hyp VA */
> +	struct user_fpsimd_state *host_fpsimd_state;	/* hyp VA */
> +	bool host_sve_in_use;	/* backup for host TIF_SVE while in guest */
> +	bool fp_enabled;
> +
>  	struct {
>  		/* {Break,watch}point registers */
>  		struct kvm_guest_debug_arch regs;
> @@ -417,6 +424,17 @@ static inline void __cpu_init_stage2(void)
>  		  "PARange is %d bits, unsupported configuration!", parange);
>  }
>  
> +/* Guest/host FPSIMD coordination helpers */
> +int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu);
> +void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu);
> +void kvm_arch_vcpu_park_fp(struct kvm_vcpu *vcpu);
> +void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu);
> +
> +static inline int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
> +{
> +	return kvm_arch_vcpu_run_map_fp(vcpu);
> +}
> +

nit: It would be nicer to only add the arm64 hook the way they should be
in this patch, and remove the #ifdef CONFIG_ARM64 thing that gets
removed in this patch from patch 1.

>  /*
>   * All host FP/SIMD state is restored on guest exit, so nothing needs
>   * doing here except in the SVE case:
> diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
> index 87a3536..7f74374 100644
> --- a/arch/arm64/kernel/fpsimd.c
> +++ b/arch/arm64/kernel/fpsimd.c
> @@ -270,13 +270,15 @@ static void task_fpsimd_load(void)
>  }
>  
>  /*
> - * Ensure current's FPSIMD/SVE storage in thread_struct is up to date
> + * Ensure current's FPSIMD/SVE storage in memory is up to date
>   * with respect to the CPU registers.
>   *
>   * Softirqs (and preemption) must be disabled.
>   */
> -static void task_fpsimd_save(void)
> +void task_fpsimd_save(void)
>  {
> +	struct user_fpsimd_state *st = __this_cpu_read(fpsimd_last_state.st);
> +
>  	WARN_ON(!in_softirq() && !irqs_disabled());
>  
>  	if (!test_thread_flag(TIF_FOREIGN_FPSTATE)) {
> @@ -291,10 +293,9 @@ static void task_fpsimd_save(void)
>  				return;
>  			}
>  
> -			sve_save_state(sve_pffr(current),
> -				       &current->thread.uw.fpsimd_state.fpsr);
> +			sve_save_state(sve_pffr(current), &st->fpsr);
>  		} else
> -			fpsimd_save_state(&current->thread.uw.fpsimd_state);
> +			fpsimd_save_state(st);

Is this equivalent to what we had before, because we'll have run
something that sets this cpu's fpsimd_last_state to current's
user_fpsimd_state, when scheduling this thread?

>  	}
>  }
>  
> @@ -1012,6 +1013,17 @@ static void fpsimd_bind_to_cpu(void)
>  	current->thread.fpsimd_cpu = smp_processor_id();
>  }
>  
> +void fpsimd_bind_state_to_cpu(struct user_fpsimd_state *st)
> +{
> +	struct fpsimd_last_state_struct *last =
> +		this_cpu_ptr(&fpsimd_last_state);
> +
> +	WARN_ON(!in_softirq() && !irqs_disabled());
> +
> +	last->st = st;
> +	last->sve_in_use = false;
> +}
> +
>  /*
>   * Load the userland FPSIMD state of 'current' from memory, but only if the
>   * FPSIMD state already held in the registers is /not/ the most recent FPSIMD
> @@ -1064,7 +1076,7 @@ void fpsimd_flush_task_state(struct task_struct *t)
>  	t->thread.fpsimd_cpu = NR_CPUS;
>  }
>  
> -static inline void fpsimd_flush_cpu_state(void)
> +void fpsimd_flush_cpu_state(void)
>  {
>  	__this_cpu_write(fpsimd_last_state.st, NULL);
>  }

You could consider factoring out all changes to kernel/fpsimd.c into a
separate patch explaining why it's correct, which may make bisecting
potential bugs easier, but on the other hand it keeps the changes in the
patch where they're used.  Just a thought.

> diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
> index 93afff9..0f2a135 100644
> --- a/arch/arm64/kvm/Makefile
> +++ b/arch/arm64/kvm/Makefile
> @@ -19,7 +19,7 @@ kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/psci.o $(KVM)/arm/perf.o
>  kvm-$(CONFIG_KVM_ARM_HOST) += inject_fault.o regmap.o va_layout.o
>  kvm-$(CONFIG_KVM_ARM_HOST) += hyp.o hyp-init.o handle_exit.o
>  kvm-$(CONFIG_KVM_ARM_HOST) += guest.o debug.o reset.o sys_regs.o sys_regs_generic_v8.o
> -kvm-$(CONFIG_KVM_ARM_HOST) += vgic-sys-reg-v3.o
> +kvm-$(CONFIG_KVM_ARM_HOST) += vgic-sys-reg-v3.o fpsimd.o
>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/aarch32.o
>  
>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic.o
> diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
> new file mode 100644
> index 0000000..cc7a068
> --- /dev/null
> +++ b/arch/arm64/kvm/fpsimd.c
> @@ -0,0 +1,109 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * arch/arm64/kvm/fpsimd.c: Guest/host FPSIMD context coordination helpers
> + *
> + * Copyright 2018 Arm Limited
> + * Author: Dave Martin <Dave.Martin@arm.com>
> + */
> +#include <linux/bottom_half.h>
> +#include <linux/sched.h>
> +#include <linux/thread_info.h>
> +#include <linux/kvm_host.h>
> +#include <asm/kvm_host.h>
> +#include <asm/kvm_mmu.h>
> +
> +/*
> + * Called on entry to KVM_RUN unless this vcpu previously ran at least
> + * once and the most recent prior KVM_RUN for this vcpu was called from
> + * the same task as current (highly likely).
> + *
> + * This is guaranteed to execute before kvm_arch_vcpu_load_fp(vcpu),
> + * such that on entering hyp the relevant parts of current are already
> + * mapped.
> + */
> +int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu)
> +{
> +	int ret;
> +
> +	struct thread_info *ti = &current->thread_info;
> +	struct user_fpsimd_state *fpsimd = &current->thread.uw.fpsimd_state;
> +
> +	/*
> +	 * Make sure the host task thread flags and fpsimd state are
> +	 * visible to hyp:
> +	 */
> +	ret = create_hyp_mappings(ti, ti + 1, PAGE_HYP);
> +	if (ret)
> +		goto error;
> +
> +	ret = create_hyp_mappings(fpsimd, fpsimd + 1, PAGE_HYP);
> +	if (ret)
> +		goto error;
> +
> +	vcpu->arch.host_thread_info = kern_hyp_va(ti);
> +	vcpu->arch.host_fpsimd_state = kern_hyp_va(fpsimd);
> +error:
> +	return ret;
> +}
> +
> +/*
> + * Prepare vcpu for saving the host's FPSIMD state and loading the guest's.
> + * The actual loading is done by the FPSIMD access trap taken to hyp.
> + *
> + * Here, we just set the correct metadata to indicate that the FPSIMD
> + * state in the cpu regs (if any) belongs to current, and where to write
> + * it back to if/when a FPSIMD access trap is taken.
> + *
> + * TIF_SVE is backed up here, since it may get clobbered with guest state.
> + * This flag is restored by kvm_arch_vcpu_put_fp(vcpu).

I don't fully understand how TIF_SVE gets clobbered, but perhaps that's
in preparation for a future patch.  (Me keeps reading).

> + */
> +void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu)
> +{
> +	BUG_ON(system_supports_sve());
> +	BUG_ON(!current->mm);
> +
> +	vcpu->arch.fp_enabled = false;
> +	vcpu->arch.host_fpsimd_state =
> +		kern_hyp_va(&current->thread.uw.fpsimd_state);
> +	vcpu->arch.host_sve_in_use = !!test_thread_flag(TIF_SVE);
> +}
> +
> +/*
> + * If the guest FPSIMD state was loaded, mark the CPU FPSIMD regs as
> + * dirty for vcpu so that they will be written back if the kernel
> + * clobbers them due to kernel-mode NEON before re-entry into the guest.
> + */
> +void kvm_arch_vcpu_park_fp(struct kvm_vcpu *vcpu)
> +{
> +	WARN_ON_ONCE(!irqs_disabled());
> +
> +	if (vcpu->arch.fp_enabled) {
> +		fpsimd_bind_state_to_cpu(&vcpu->arch.ctxt.gp_regs.fp_regs);
> +		clear_thread_flag(TIF_FOREIGN_FPSTATE);
> +		clear_thread_flag(TIF_SVE);
> +	}
> +}
> +
> +/*
> + * Write back the vcpu FPSIMD regs if they are dirty, and invalidate the
> + * cpu FPSIMD regs so that they can't be spuriously reused if this vcpu
> + * disappears and another task or vcpu appears that recycles the same
> + * struct fpsimd_state.
> + */
> +void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu)
> +{
> +	local_bh_disable();
> +
> +	if (vcpu->arch.fp_enabled) {
> +		task_fpsimd_save();

Just to make sure I'm getting this right: This is safe, because even if
after we exited the VM, before we call this function, if we take a
softirq that has overwritten our fpsimd state, then kernel_neon_begin()
will have set TIF_FOREIGN_FPSTATE, and task_fpsimd_save() won't actually
do anything, and kernel_neon_begin() will have alreay saved the VCPU's
fpsimd state.  Is that right?

> +		fpsimd_flush_cpu_state();
> +		set_thread_flag(TIF_FOREIGN_FPSTATE);
> +	}
> +
> +	if (vcpu->arch.host_sve_in_use)
> +		set_thread_flag(TIF_SVE);
> +	else
> +		clear_thread_flag(TIF_SVE);
> +
> +	local_bh_enable();
> +}
> diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> index c438ad8..0900c2a 100644
> --- a/arch/arm64/kvm/hyp/switch.c
> +++ b/arch/arm64/kvm/hyp/switch.c
> @@ -27,15 +27,16 @@
>  #include <asm/kvm_mmu.h>
>  #include <asm/fpsimd.h>
>  #include <asm/debug-monitors.h>
> +#include <asm/thread_info.h>
>  
> -static bool __hyp_text __fpsimd_enabled_nvhe(void)
> +static bool __hyp_text update_fp_enabled(struct kvm_vcpu *vcpu)
>  {
> -	return !(read_sysreg(cptr_el2) & CPTR_EL2_TFP);
> -}
> +	if (vcpu->arch.host_thread_info->flags & _TIF_FOREIGN_FPSTATE) {
> +		vcpu->arch.host_fpsimd_state = NULL;
> +		vcpu->arch.fp_enabled = false;
> +	}
>  
> -static bool fpsimd_enabled_vhe(void)
> -{
> -	return !!(read_sysreg(cpacr_el1) & CPACR_EL1_FPEN);
> +	return vcpu->arch.fp_enabled;
>  }
>  
>  /* Save the 32-bit only FPSIMD system register state */
> @@ -92,7 +93,10 @@ static void activate_traps_vhe(struct kvm_vcpu *vcpu)
>  
>  	val = read_sysreg(cpacr_el1);
>  	val |= CPACR_EL1_TTA;
> -	val &= ~(CPACR_EL1_FPEN | CPACR_EL1_ZEN);
> +	val &= ~CPACR_EL1_ZEN;
> +	if (!update_fp_enabled(vcpu))
> +		val &= ~CPACR_EL1_FPEN;
> +
>  	write_sysreg(val, cpacr_el1);
>  
>  	write_sysreg(kvm_get_hyp_vector(), vbar_el1);
> @@ -105,7 +109,10 @@ static void __hyp_text __activate_traps_nvhe(struct kvm_vcpu *vcpu)
>  	__activate_traps_common(vcpu);
>  
>  	val = CPTR_EL2_DEFAULT;
> -	val |= CPTR_EL2_TTA | CPTR_EL2_TFP | CPTR_EL2_TZ;
> +	val |= CPTR_EL2_TTA | CPTR_EL2_TZ;
> +	if (!update_fp_enabled(vcpu))
> +		val |= CPTR_EL2_TFP;
> +
>  	write_sysreg(val, cptr_el2);
>  }
>  
> @@ -394,7 +401,6 @@ int kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_cpu_context *host_ctxt;
>  	struct kvm_cpu_context *guest_ctxt;
> -	bool fp_enabled;
>  	u64 exit_code;
>  
>  	host_ctxt = vcpu->arch.host_cpu_context;
> @@ -416,19 +422,14 @@ int kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
>  		/* And we're baaack! */
>  	} while (fixup_guest_exit(vcpu, &exit_code));
>  
> -	fp_enabled = fpsimd_enabled_vhe();
> -
>  	sysreg_save_guest_state_vhe(guest_ctxt);
>  
>  	__deactivate_traps(vcpu);
>  
>  	sysreg_restore_host_state_vhe(host_ctxt);
>  
> -	if (fp_enabled) {
> -		__fpsimd_save_state(&guest_ctxt->gp_regs.fp_regs);
> -		__fpsimd_restore_state(&host_ctxt->gp_regs.fp_regs);
> +	if (vcpu->arch.fp_enabled)
>  		__fpsimd_save_fpexc32(vcpu);
> -	}
>  
>  	__debug_switch_to_host(vcpu);
>  
> @@ -440,7 +441,6 @@ int __hyp_text __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_cpu_context *host_ctxt;
>  	struct kvm_cpu_context *guest_ctxt;
> -	bool fp_enabled;
>  	u64 exit_code;
>  
>  	vcpu = kern_hyp_va(vcpu);
> @@ -472,8 +472,6 @@ int __hyp_text __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu)
>  		/* And we're baaack! */
>  	} while (fixup_guest_exit(vcpu, &exit_code));
>  
> -	fp_enabled = __fpsimd_enabled_nvhe();
> -
>  	__sysreg_save_state_nvhe(guest_ctxt);
>  	__sysreg32_save_state(vcpu);
>  	__timer_disable_traps(vcpu);
> @@ -484,11 +482,8 @@ int __hyp_text __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu)
>  
>  	__sysreg_restore_state_nvhe(host_ctxt);
>  
> -	if (fp_enabled) {
> -		__fpsimd_save_state(&guest_ctxt->gp_regs.fp_regs);
> -		__fpsimd_restore_state(&host_ctxt->gp_regs.fp_regs);
> +	if (vcpu->arch.fp_enabled)
>  		__fpsimd_save_fpexc32(vcpu);
> -	}
>  
>  	/*
>  	 * This must come after restoring the host sysregs, since a non-VHE
> @@ -502,8 +497,6 @@ int __hyp_text __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu)
>  void __hyp_text __hyp_switch_fpsimd(u64 esr __always_unused,
>  				    struct kvm_vcpu *vcpu)
>  {
> -	kvm_cpu_context_t *host_ctxt;
> -
>  	if (has_vhe())
>  		write_sysreg(read_sysreg(cpacr_el1) | CPACR_EL1_FPEN,
>  			     cpacr_el1);
> @@ -513,14 +506,19 @@ void __hyp_text __hyp_switch_fpsimd(u64 esr __always_unused,
>  
>  	isb();
>  
> -	host_ctxt = kern_hyp_va(vcpu->arch.host_cpu_context);
> -	__fpsimd_save_state(&host_ctxt->gp_regs.fp_regs);
> +	if (vcpu->arch.host_fpsimd_state) {
> +		__fpsimd_save_state(vcpu->arch.host_fpsimd_state);
> +		vcpu->arch.host_fpsimd_state = NULL;
> +	}
> +
>  	__fpsimd_restore_state(&vcpu->arch.ctxt.gp_regs.fp_regs);
>  
>  	/* Skip restoring fpexc32 for AArch64 guests */
>  	if (!(read_sysreg(hcr_el2) & HCR_RW))
>  		write_sysreg(vcpu->arch.ctxt.sys_regs[FPEXC32_EL2],
>  			     fpexc32_el2);
> +
> +	vcpu->arch.fp_enabled = true;
>  }
>  
>  static const char __hyp_panic_string[] = "HYP panic:\nPS:%08llx PC:%016llx ESR:%08llx\nFAR:%016llx HPFAR:%016llx PAR:%016llx\nVCPU:%p\n";
> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> index cd38d7d..4fcf6fe 100644
> --- a/virt/kvm/arm/arm.c
> +++ b/virt/kvm/arm/arm.c
> @@ -363,10 +363,12 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>  	kvm_vgic_load(vcpu);
>  	kvm_timer_vcpu_load(vcpu);
>  	kvm_vcpu_load_sysregs(vcpu);
> +	kvm_arch_vcpu_load_fp(vcpu);
>  }
>  
>  void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>  {
> +	kvm_arch_vcpu_put_fp(vcpu);
>  	kvm_vcpu_put_sysregs(vcpu);
>  	kvm_timer_vcpu_put(vcpu);
>  	kvm_vgic_put(vcpu);
> @@ -773,6 +775,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  		if (static_branch_unlikely(&userspace_irqchip_in_use))
>  			kvm_timer_sync_hwstate(vcpu);
>  
> +		kvm_arch_vcpu_park_fp(vcpu);
> +
>  		/*
>  		 * We may have taken a host interrupt in HYP mode (ie
>  		 * while executing the guest). This interrupt is still
> @@ -816,16 +820,6 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  	return ret;
>  }
>  
> -#ifdef CONFIG_ARM64
> -int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
> -{
> -	struct task_struct *tsk = current;
> -
> -	/* Make sure the host task fpsimd state is visible to hyp: */
> -	return create_hyp_mappings(tsk, tsk + 1, PAGE_HYP);
> -}
> -#endif
> -
>  static int vcpu_interrupt_line(struct kvm_vcpu *vcpu, int number, bool level)
>  {
>  	int bit_index;
> -- 
> 2.1.4
> 
Besides the cosmetic comments and questions above, this all looks good
to me!

Thanks,
-Christoffer
