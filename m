From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3 08/11] KVM: arm: implement dirty bit mechanism for
 debug registers
Date: Tue, 30 Jun 2015 11:20:20 +0200
Message-ID: <20150630092020.GP11332@cbox>
References: <1434969694-7432-1-git-send-email-zhichao.huang@linaro.org>
 <1434969694-7432-9-git-send-email-zhichao.huang@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1434969694-7432-9-git-send-email-zhichao.huang@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Zhichao Huang <zhichao.huang@linaro.org>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, alex.bennee@linaro.org, will.deacon@arm.com, huangzhichao@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jun 22, 2015 at 06:41:31PM +0800, Zhichao Huang wrote:
> The trapping code keeps track of the state of the debug registers,
> allowing for the switch code to implement a lazy switching strategy.
> 
> Signed-off-by: Zhichao Huang <zhichao.huang@linaro.org>
> ---
>  arch/arm/include/asm/kvm_asm.h  |  3 +++
>  arch/arm/include/asm/kvm_host.h |  3 +++
>  arch/arm/kernel/asm-offsets.c   |  1 +
>  arch/arm/kvm/coproc.c           | 39 ++++++++++++++++++++++++++++++++++++--
>  arch/arm/kvm/interrupts_head.S  | 42 +++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 86 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/include/asm/kvm_asm.h b/arch/arm/include/asm/kvm_asm.h
> index ba65e05..4fb64cf 100644
> --- a/arch/arm/include/asm/kvm_asm.h
> +++ b/arch/arm/include/asm/kvm_asm.h
> @@ -64,6 +64,9 @@
>  #define cp14_DBGDSCRext	65	/* Debug Status and Control external */
>  #define NR_CP14_REGS	66	/* Number of regs (incl. invalid) */
>  
> +#define KVM_ARM_DEBUG_DIRTY_SHIFT	0
> +#define KVM_ARM_DEBUG_DIRTY		(1 << KVM_ARM_DEBUG_DIRTY_SHIFT)
> +
>  #define ARM_EXCEPTION_RESET	  0
>  #define ARM_EXCEPTION_UNDEFINED   1
>  #define ARM_EXCEPTION_SOFTWARE    2
> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
> index 3d16820..09b54bf 100644
> --- a/arch/arm/include/asm/kvm_host.h
> +++ b/arch/arm/include/asm/kvm_host.h
> @@ -127,6 +127,9 @@ struct kvm_vcpu_arch {
>  	/* System control coprocessor (cp14) */
>  	u32 cp14[NR_CP14_REGS];
>  
> +	/* Debug state */
> +	u32 debug_flags;
> +
>  	/*
>  	 * Anything that is not used directly from assembly code goes
>  	 * here.
> diff --git a/arch/arm/kernel/asm-offsets.c b/arch/arm/kernel/asm-offsets.c
> index 9158de0..e876109 100644
> --- a/arch/arm/kernel/asm-offsets.c
> +++ b/arch/arm/kernel/asm-offsets.c
> @@ -185,6 +185,7 @@ int main(void)
>    DEFINE(VCPU_FIQ_REGS,		offsetof(struct kvm_vcpu, arch.regs.fiq_regs));
>    DEFINE(VCPU_PC,		offsetof(struct kvm_vcpu, arch.regs.usr_regs.ARM_pc));
>    DEFINE(VCPU_CPSR,		offsetof(struct kvm_vcpu, arch.regs.usr_regs.ARM_cpsr));
> +  DEFINE(VCPU_DEBUG_FLAGS,	offsetof(struct kvm_vcpu, arch.debug_flags));
>    DEFINE(VCPU_HCR,		offsetof(struct kvm_vcpu, arch.hcr));
>    DEFINE(VCPU_IRQ_LINES,	offsetof(struct kvm_vcpu, arch.irq_lines));
>    DEFINE(VCPU_HSR,		offsetof(struct kvm_vcpu, arch.fault.hsr));
> diff --git a/arch/arm/kvm/coproc.c b/arch/arm/kvm/coproc.c
> index eeee648..fc0c2ef 100644
> --- a/arch/arm/kvm/coproc.c
> +++ b/arch/arm/kvm/coproc.c
> @@ -220,14 +220,49 @@ bool access_vm_reg(struct kvm_vcpu *vcpu,
>  	return true;
>  }
>  
> +/*
> + * We want to avoid world-switching all the DBG registers all the
> + * time:
> + *
> + * - If we've touched any debug register, it is likely that we're
> + *   going to touch more of them. It then makes sense to disable the
> + *   traps and start doing the save/restore dance
> + * - If debug is active (ARM_DSCR_MDBGEN set), it is then mandatory
> + *   to save/restore the registers, as the guest depends on them.
> + *
> + * For this, we use a DIRTY bit, indicating the guest has modified the
> + * debug registers, used as follow:
> + *
> + * On guest entry:
> + * - If the dirty bit is set (because we're coming back from trapping),
> + *   disable the traps, save host registers, restore guest registers.
> + * - If debug is actively in use (ARM_DSCR_MDBGEN set),
> + *   set the dirty bit, disable the traps, save host registers,
> + *   restore guest registers.
> + * - Otherwise, enable the traps
> + *
> + * On guest exit:
> + * - If the dirty bit is set, save guest registers, restore host
> + *   registers and clear the dirty bit. This ensure that the host can
> + *   now use the debug registers.
> + *
> + * Notice:
> + * - For ARMv7, if the CONFIG_HAVE_HW_BREAKPOINT is set in the guest,
> + *   debug is always actively in use (ARM_DSCR_MDBGEN set).
> + *   We have to do the save/restore dance in this case, because the
> + *   host and the guest might use their respective debug registers
> + *   at any moment.

so doesn't this pretty much invalidate the whole saving/dirty effort?

Guests configured from for example multi_v7_defconfig will then act like
this and you will save/restore all these registers always.

Wouldn't a better approach be to enable trapping to hyp mode most of the
time, and simply clear the enabled bit of any host-used break- or
wathcpoints upon guest entry, perhaps maintaining a bitmap of which ones
must be re-set when exiting the guest, and thereby drastically reducing
the amount of save/restore code you'd have to perform.

Of course, you'd also have to keep track of whether the guest has any
breakpoints or watchpoints enabled for when you do the full save/restore
dance.

That would also avoid all issues surrounding accesses to DBGDSCRext
register I think.

> + */
>  static bool trap_debug32(struct kvm_vcpu *vcpu,
>  			const struct coproc_params *p,
>  			const struct coproc_reg *r)
>  {
> -	if (p->is_write)
> +	if (p->is_write) {
>  		vcpu->arch.cp14[r->reg] = *vcpu_reg(vcpu, p->Rt1);
> -	else
> +		vcpu->arch.debug_flags |= KVM_ARM_DEBUG_DIRTY;
> +	} else {
>  		*vcpu_reg(vcpu, p->Rt1) = vcpu->arch.cp14[r->reg];
> +	}
>  
>  	return true;
>  }
> diff --git a/arch/arm/kvm/interrupts_head.S b/arch/arm/kvm/interrupts_head.S
> index a20b9ad..5662c39 100644
> --- a/arch/arm/kvm/interrupts_head.S
> +++ b/arch/arm/kvm/interrupts_head.S
> @@ -1,4 +1,6 @@
>  #include <linux/irqchip/arm-gic.h>
> +#include <asm/hw_breakpoint.h>
> +#include <asm/kvm_asm.h>
>  #include <asm/assembler.h>
>  
>  #define VCPU_USR_REG(_reg_nr)	(VCPU_USR_REGS + (_reg_nr * 4))
> @@ -407,6 +409,46 @@ vcpu	.req	r0		@ vcpu pointer always in r0
>  	mcr	p15, 2, r12, c0, c0, 0	@ CSSELR
>  .endm
>  
> +/* Assume vcpu pointer in vcpu reg, clobbers r5 */
> +.macro skip_debug_state target
> +	ldr	r5, [vcpu, #VCPU_DEBUG_FLAGS]
> +	cmp	r5, #KVM_ARM_DEBUG_DIRTY
> +	bne	\target
> +1:
> +.endm
> +
> +/* Compute debug state: If ARM_DSCR_MDBGEN or KVM_ARM_DEBUG_DIRTY
> + * is set, we do a full save/restore cycle and disable trapping.
> + *
> + * Assumes vcpu pointer in vcpu reg
> + *
> + * Clobbers r5, r6
> + */
> +.macro compute_debug_state target
> +	// Check the state of MDSCR_EL1
> +	ldr	r5, [vcpu, #CP14_OFFSET(cp14_DBGDSCRext)]
> +	and	r6, r5, #ARM_DSCR_MDBGEN
> +	cmp	r6, #0

you can just do 'ands' here, or even tst and you don't have to touch r6.

> +	beq	9998f	   // Nothing to see there
> +
> +	// If ARM_DSCR_MDBGEN bit was set, we must set the flag
> +	mov	r5, #KVM_ARM_DEBUG_DIRTY
> +	str	r5, [vcpu, #VCPU_DEBUG_FLAGS]
> +	b	9999f	   // Don't skip restore
> +
> +9998:
> +	// Otherwise load the flags from memory in case we recently
> +	// trapped
> +	skip_debug_state \target
> +9999:
> +.endm
> +
> +/* Assume vcpu pointer in vcpu reg, clobbers r5 */
> +.macro clear_debug_dirty_bit
> +	mov	r5, #0
> +	str	r5, [vcpu, #VCPU_DEBUG_FLAGS]
> +.endm
> +
>  /*
>   * Save the VGIC CPU state into memory
>   *
> -- 
> 1.7.12.4
> 
Thanks,
-Christoffer
