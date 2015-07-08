From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v8 08/11] KVM: arm64: introduce vcpu->arch.debug_ptr
Date: Wed, 8 Jul 2015 12:02:21 +0200
Message-ID: <20150708100221.GD13530@cbox>
References: <1436286603-15192-1-git-send-email-alex.bennee@linaro.org>
 <1436286603-15192-9-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0E8DA58070
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Jul 2015 05:50:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dfRyD49Vm7TW for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Jul 2015 05:50:47 -0400 (EDT)
Received: from mail-lb0-f179.google.com (mail-lb0-f179.google.com
 [209.85.217.179])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C219B5806F
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Jul 2015 05:50:46 -0400 (EDT)
Received: by lbbpo10 with SMTP id po10so52841858lbb.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 08 Jul 2015 03:02:18 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1436286603-15192-9-git-send-email-alex.bennee@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc: kvm@vger.kernel.org, jan.kiszka@siemens.com, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, Russell King <linux@arm.linux.org.uk>, Richard Weinberger <richard@nod.at>, Gleb Natapov <gleb@kernel.org>, zhichao.huang@linaro.org, Catalin Marinas <catalin.marinas@arm.com>, bp@suse.de, marc.zyngier@arm.com, Andre Przywara <andre.przywara@arm.com>, r65777@freescale.com, linux-arm-kernel@lists.infradead.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, open list <linux-kernel@vger.kernel.org>, dahi@linux.vnet.ibm.com, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Jul 07, 2015 at 05:30:00PM +0100, Alex Benn=E9e wrote:
> This introduces a level of indirection for the debug registers. Instead
> of using the sys_regs[] directly we store registers in a structure in
> the vcpu. The new kvm_arm_reset_debug_ptr() sets the debug ptr to the
> guest context.
> =

> Because we no longer give the sys_regs offset for the sys_reg_desc->reg
> field, but instead the index into a debug-specific struct we need to
> add a number of additional trap functions for each register. Also as the
> generic generic user-space access code no longer works we have

nit: you have generic twice

> introduced a new pair of function pointers to the sys_reg_desc structure
> to override the generic code when needed.
> =

> Signed-off-by: Alex Benn=E9e <alex.bennee@linaro.org>
> =


Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>

Thanks,
-Christoffer

> ---
> v6:
>   - fix up some ws issues
>   - correct clobber info
>   - re-word commentary in kvm_host.h
>   - fix endian access issues for aarch32 fields
>   - revert all KVM_GET/SET_ONE_REG to 64bit (also see ABI update)
> v7
>   - new fn kvm_arm_reset_debug_ptr(), stubbed for arm
>   - split trap fns into bcr,bvr,bcr,wvr and wxvr
>   - add set/get fns to sys_regs_desc
>   - reg_to_dbg/dbg_to_reg helpers for 32bit support
> v8
>   - rm #if 0 left over from re-factor
>   - re-word reset_ptr comment
>   - fix inadvertent whitespace changes
>   - rename get/set to get_user/set_user
>   - update commit wording
>   - re-factor dbg_to_reg/reg_to_dbg
>   - add newlines to keep checkpatch happy
>   - ensure 63:32 of debug registers untouched by aarch32
> ---
>  arch/arm/include/asm/kvm_host.h   |   1 +
>  arch/arm/kvm/arm.c                |   2 +
>  arch/arm64/include/asm/kvm_asm.h  |  24 ++--
>  arch/arm64/include/asm/kvm_host.h |  17 ++-
>  arch/arm64/kernel/asm-offsets.c   |   6 +
>  arch/arm64/kvm/debug.c            |   9 ++
>  arch/arm64/kvm/hyp.S              |  24 ++--
>  arch/arm64/kvm/sys_regs.c         | 274 ++++++++++++++++++++++++++++++++=
+++---
>  arch/arm64/kvm/sys_regs.h         |   6 +
>  9 files changed, 316 insertions(+), 47 deletions(-)
> =

> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_h=
ost.h
> index 746c0c69..825c337 100644
> --- a/arch/arm/include/asm/kvm_host.h
> +++ b/arch/arm/include/asm/kvm_host.h
> @@ -239,5 +239,6 @@ static inline void kvm_arch_sched_in(struct kvm_vcpu =
*vcpu, int cpu) {}
>  static inline void kvm_arm_init_debug(void) {}
>  static inline void kvm_arm_setup_debug(struct kvm_vcpu *vcpu) {}
>  static inline void kvm_arm_clear_debug(struct kvm_vcpu *vcpu) {}
> +static inline void kvm_arm_reset_debug_ptr(struct kvm_vcpu *vcpu) {}
>  =

>  #endif /* __ARM_KVM_HOST_H__ */
> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
> index af60e6f..525473f 100644
> --- a/arch/arm/kvm/arm.c
> +++ b/arch/arm/kvm/arm.c
> @@ -279,6 +279,8 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
>  	/* Set up the timer */
>  	kvm_timer_vcpu_init(vcpu);
>  =

> +	kvm_arm_reset_debug_ptr(vcpu);
> +
>  	return 0;
>  }
>  =

> diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kv=
m_asm.h
> index d6b507e..e997404 100644
> --- a/arch/arm64/include/asm/kvm_asm.h
> +++ b/arch/arm64/include/asm/kvm_asm.h
> @@ -46,24 +46,16 @@
>  #define	CNTKCTL_EL1	20	/* Timer Control Register (EL1) */
>  #define	PAR_EL1		21	/* Physical Address Register */
>  #define MDSCR_EL1	22	/* Monitor Debug System Control Register */
> -#define DBGBCR0_EL1	23	/* Debug Breakpoint Control Registers (0-15) */
> -#define DBGBCR15_EL1	38
> -#define DBGBVR0_EL1	39	/* Debug Breakpoint Value Registers (0-15) */
> -#define DBGBVR15_EL1	54
> -#define DBGWCR0_EL1	55	/* Debug Watchpoint Control Registers (0-15) */
> -#define DBGWCR15_EL1	70
> -#define DBGWVR0_EL1	71	/* Debug Watchpoint Value Registers (0-15) */
> -#define DBGWVR15_EL1	86
> -#define MDCCINT_EL1	87	/* Monitor Debug Comms Channel Interrupt Enable R=
eg */
> +#define MDCCINT_EL1	23	/* Monitor Debug Comms Channel Interrupt Enable R=
eg */
>  =

>  /* 32bit specific registers. Keep them at the end of the range */
> -#define	DACR32_EL2	88	/* Domain Access Control Register */
> -#define	IFSR32_EL2	89	/* Instruction Fault Status Register */
> -#define	FPEXC32_EL2	90	/* Floating-Point Exception Control Register */
> -#define	DBGVCR32_EL2	91	/* Debug Vector Catch Register */
> -#define	TEECR32_EL1	92	/* ThumbEE Configuration Register */
> -#define	TEEHBR32_EL1	93	/* ThumbEE Handler Base Register */
> -#define	NR_SYS_REGS	94
> +#define	DACR32_EL2	24	/* Domain Access Control Register */
> +#define	IFSR32_EL2	25	/* Instruction Fault Status Register */
> +#define	FPEXC32_EL2	26	/* Floating-Point Exception Control Register */
> +#define	DBGVCR32_EL2	27	/* Debug Vector Catch Register */
> +#define	TEECR32_EL1	28	/* ThumbEE Configuration Register */
> +#define	TEEHBR32_EL1	29	/* ThumbEE Handler Base Register */
> +#define	NR_SYS_REGS	30
>  =

>  /* 32bit mapping */
>  #define c0_MPIDR	(MPIDR_EL1 * 2)	/* MultiProcessor ID Register */
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/k=
vm_host.h
> index e2db6a6..461d288 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -108,11 +108,25 @@ struct kvm_vcpu_arch {
>  	/* Exception Information */
>  	struct kvm_vcpu_fault_info fault;
>  =

> -	/* Debug state */
> +	/* Guest debug state */
>  	u64 debug_flags;
>  =

> +	/*
> +	 * We maintain more than a single set of debug registers to support
> +	 * debugging the guest from the host and to maintain separate host and
> +	 * guest state during world switches. vcpu_debug_state are the debug
> +	 * registers of the vcpu as the guest sees them.  host_debug_state are
> +	 * the host registers which are saved and restored during world switche=
s.
> +	 *
> +	 * debug_ptr points to the set of debug registers that should be loaded
> +	 * onto the hardware when running the guest.
> +	 */
> +	struct kvm_guest_debug_arch *debug_ptr;
> +	struct kvm_guest_debug_arch vcpu_debug_state;
> +
>  	/* Pointer to host CPU context */
>  	kvm_cpu_context_t *host_cpu_context;
> +	struct kvm_guest_debug_arch host_debug_state;
>  =

>  	/* VGIC state */
>  	struct vgic_cpu vgic_cpu;
> @@ -265,5 +279,6 @@ static inline void kvm_arch_sched_in(struct kvm_vcpu =
*vcpu, int cpu) {}
>  void kvm_arm_init_debug(void);
>  void kvm_arm_setup_debug(struct kvm_vcpu *vcpu);
>  void kvm_arm_clear_debug(struct kvm_vcpu *vcpu);
> +void kvm_arm_reset_debug_ptr(struct kvm_vcpu *vcpu);
>  =

>  #endif /* __ARM64_KVM_HOST_H__ */
> diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offs=
ets.c
> index dfb25a2..1a8e97c 100644
> --- a/arch/arm64/kernel/asm-offsets.c
> +++ b/arch/arm64/kernel/asm-offsets.c
> @@ -116,10 +116,16 @@ int main(void)
>    DEFINE(VCPU_FAR_EL2,		offsetof(struct kvm_vcpu, arch.fault.far_el2));
>    DEFINE(VCPU_HPFAR_EL2,	offsetof(struct kvm_vcpu, arch.fault.hpfar_el2)=
);
>    DEFINE(VCPU_DEBUG_FLAGS,	offsetof(struct kvm_vcpu, arch.debug_flags));
> +  DEFINE(VCPU_DEBUG_PTR,	offsetof(struct kvm_vcpu, arch.debug_ptr));
> +  DEFINE(DEBUG_BCR, 		offsetof(struct kvm_guest_debug_arch, dbg_bcr));
> +  DEFINE(DEBUG_BVR, 		offsetof(struct kvm_guest_debug_arch, dbg_bvr));
> +  DEFINE(DEBUG_WCR, 		offsetof(struct kvm_guest_debug_arch, dbg_wcr));
> +  DEFINE(DEBUG_WVR, 		offsetof(struct kvm_guest_debug_arch, dbg_wvr));
>    DEFINE(VCPU_HCR_EL2,		offsetof(struct kvm_vcpu, arch.hcr_el2));
>    DEFINE(VCPU_MDCR_EL2,	offsetof(struct kvm_vcpu, arch.mdcr_el2));
>    DEFINE(VCPU_IRQ_LINES,	offsetof(struct kvm_vcpu, arch.irq_lines));
>    DEFINE(VCPU_HOST_CONTEXT,	offsetof(struct kvm_vcpu, arch.host_cpu_cont=
ext));
> +  DEFINE(VCPU_HOST_DEBUG_STATE, offsetof(struct kvm_vcpu, arch.host_debu=
g_state));
>    DEFINE(VCPU_TIMER_CNTV_CTL,	offsetof(struct kvm_vcpu, arch.timer_cpu.c=
ntv_ctl));
>    DEFINE(VCPU_TIMER_CNTV_CVAL,	offsetof(struct kvm_vcpu, arch.timer_cpu.=
cntv_cval));
>    DEFINE(KVM_TIMER_CNTVOFF,	offsetof(struct kvm, arch.timer.cntvoff));
> diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
> index d439eb8..e0947b7 100644
> --- a/arch/arm64/kvm/debug.c
> +++ b/arch/arm64/kvm/debug.c
> @@ -67,6 +67,15 @@ void kvm_arm_init_debug(void)
>  }
>  =

>  /**
> + * kvm_arm_reset_debug_ptr - reset the debug ptr to point to the vcpu st=
ate
> + */
> +
> +void kvm_arm_reset_debug_ptr(struct kvm_vcpu *vcpu)
> +{
> +	vcpu->arch.debug_ptr =3D &vcpu->arch.vcpu_debug_state;
> +}
> +
> +/**
>   * kvm_arm_setup_debug - set up debug related stuff
>   *
>   * @vcpu:	the vcpu pointer
> diff --git a/arch/arm64/kvm/hyp.S b/arch/arm64/kvm/hyp.S
> index 77c08df..f56e93f 100644
> --- a/arch/arm64/kvm/hyp.S
> +++ b/arch/arm64/kvm/hyp.S
> @@ -600,6 +600,7 @@ __restore_sysregs:
>  /* Save debug state */
>  __save_debug:
>  	// x2: ptr to CPU context
> +	// x3: ptr to debug reg struct
>  	// x4/x5/x6-22/x24-26: trashed
>  =

>  	mrs	x26, id_aa64dfr0_el1
> @@ -610,15 +611,15 @@ __save_debug:
>  	sub	w25, w26, w25		// How many WPs to skip
>  =

>  	mov	x5, x24
> -	add	x4, x2, #CPU_SYSREG_OFFSET(DBGBCR0_EL1)
> +	add	x4, x3, #DEBUG_BCR
>  	save_debug dbgbcr
> -	add	x4, x2, #CPU_SYSREG_OFFSET(DBGBVR0_EL1)
> +	add	x4, x3, #DEBUG_BVR
>  	save_debug dbgbvr
>  =

>  	mov	x5, x25
> -	add	x4, x2, #CPU_SYSREG_OFFSET(DBGWCR0_EL1)
> +	add	x4, x3, #DEBUG_WCR
>  	save_debug dbgwcr
> -	add	x4, x2, #CPU_SYSREG_OFFSET(DBGWVR0_EL1)
> +	add	x4, x3, #DEBUG_WVR
>  	save_debug dbgwvr
>  =

>  	mrs	x21, mdccint_el1
> @@ -628,6 +629,7 @@ __save_debug:
>  /* Restore debug state */
>  __restore_debug:
>  	// x2: ptr to CPU context
> +	// x3: ptr to debug reg struct
>  	// x4/x5/x6-22/x24-26: trashed
>  =

>  	mrs	x26, id_aa64dfr0_el1
> @@ -638,15 +640,15 @@ __restore_debug:
>  	sub	w25, w26, w25		// How many WPs to skip
>  =

>  	mov	x5, x24
> -	add	x4, x2, #CPU_SYSREG_OFFSET(DBGBCR0_EL1)
> +	add	x4, x3, #DEBUG_BCR
>  	restore_debug dbgbcr
> -	add	x4, x2, #CPU_SYSREG_OFFSET(DBGBVR0_EL1)
> +	add	x4, x3, #DEBUG_BVR
>  	restore_debug dbgbvr
>  =

>  	mov	x5, x25
> -	add	x4, x2, #CPU_SYSREG_OFFSET(DBGWCR0_EL1)
> +	add	x4, x3, #DEBUG_WCR
>  	restore_debug dbgwcr
> -	add	x4, x2, #CPU_SYSREG_OFFSET(DBGWVR0_EL1)
> +	add	x4, x3, #DEBUG_WVR
>  	restore_debug dbgwvr
>  =

>  	ldr	x21, [x2, #CPU_SYSREG_OFFSET(MDCCINT_EL1)]
> @@ -686,6 +688,7 @@ ENTRY(__kvm_vcpu_run)
>  	bl __save_sysregs
>  =

>  	compute_debug_state 1f
> +	add	x3, x0, #VCPU_HOST_DEBUG_STATE
>  	bl	__save_debug
>  1:
>  	activate_traps
> @@ -701,6 +704,8 @@ ENTRY(__kvm_vcpu_run)
>  	bl __restore_fpsimd
>  =

>  	skip_debug_state x3, 1f
> +	ldr	x3, [x0, #VCPU_DEBUG_PTR]
> +	kern_hyp_va x3
>  	bl	__restore_debug
>  1:
>  	restore_guest_32bit_state
> @@ -721,6 +726,8 @@ __kvm_vcpu_return:
>  	bl __save_sysregs
>  =

>  	skip_debug_state x3, 1f
> +	ldr	x3, [x0, #VCPU_DEBUG_PTR]
> +	kern_hyp_va x3
>  	bl	__save_debug
>  1:
>  	save_guest_32bit_state
> @@ -743,6 +750,7 @@ __kvm_vcpu_return:
>  	// already been saved. Note that we nuke the whole 64bit word.
>  	// If we ever add more flags, we'll have to be more careful...
>  	str	xzr, [x0, #VCPU_DEBUG_FLAGS]
> +	add	x3, x0, #VCPU_HOST_DEBUG_STATE
>  	bl	__restore_debug
>  1:
>  	restore_host_regs
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index c370b40..158bae7 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -211,6 +211,203 @@ static bool trap_debug_regs(struct kvm_vcpu *vcpu,
>  	return true;
>  }
>  =

> +/*
> + * reg_to_dbg/dbg_to_reg
> + *
> + * A 32 bit write to a debug register leave top bits alone
> + * A 32 bit read from a debug register only returns the bottom bits
> + *
> + * All writes will set the KVM_ARM64_DEBUG_DIRTY flag to ensure the
> + * hyp.S code switches between host and guest values in future.
> + */
> +static inline void reg_to_dbg(struct kvm_vcpu *vcpu,
> +			      const struct sys_reg_params *p,
> +			      u64 *dbg_reg)
> +{
> +	u64 val =3D *vcpu_reg(vcpu, p->Rt);
> +
> +	if (p->is_32bit) {
> +		val &=3D 0xffffffffUL;
> +		val |=3D ((*dbg_reg >> 32) << 32);
> +	}
> +
> +	*dbg_reg =3D val;
> +	vcpu->arch.debug_flags |=3D KVM_ARM64_DEBUG_DIRTY;
> +}
> +
> +static inline void dbg_to_reg(struct kvm_vcpu *vcpu,
> +			      const struct sys_reg_params *p,
> +			      u64 *dbg_reg)
> +{
> +	u64 val =3D *dbg_reg;
> +
> +	if (p->is_32bit)
> +		val &=3D 0xffffffffUL;
> +
> +	*vcpu_reg(vcpu, p->Rt) =3D val;
> +}
> +
> +static inline bool trap_bvr(struct kvm_vcpu *vcpu,
> +			    const struct sys_reg_params *p,
> +			    const struct sys_reg_desc *rd)
> +{
> +	u64 *dbg_reg =3D &vcpu->arch.vcpu_debug_state.dbg_bvr[rd->reg];
> +
> +	if (p->is_write)
> +		reg_to_dbg(vcpu, p, dbg_reg);
> +	else
> +		dbg_to_reg(vcpu, p, dbg_reg);
> +
> +	return true;
> +}
> +
> +static int set_bvr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
> +		const struct kvm_one_reg *reg, void __user *uaddr)
> +{
> +	__u64 *r =3D &vcpu->arch.vcpu_debug_state.dbg_bvr[rd->reg];
> +
> +	if (copy_from_user(uaddr, r, KVM_REG_SIZE(reg->id)) !=3D 0)
> +		return -EFAULT;
> +	return 0;
> +}
> +
> +static int get_bvr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
> +	const struct kvm_one_reg *reg, void __user *uaddr)
> +{
> +	__u64 *r =3D &vcpu->arch.vcpu_debug_state.dbg_bvr[rd->reg];
> +
> +	if (copy_to_user(uaddr, r, KVM_REG_SIZE(reg->id)) !=3D 0)
> +		return -EFAULT;
> +	return 0;
> +}
> +
> +static inline void reset_bvr(struct kvm_vcpu *vcpu,
> +			     const struct sys_reg_desc *rd)
> +{
> +	vcpu->arch.vcpu_debug_state.dbg_bvr[rd->reg] =3D rd->val;
> +}
> +
> +static inline bool trap_bcr(struct kvm_vcpu *vcpu,
> +			    const struct sys_reg_params *p,
> +			    const struct sys_reg_desc *rd)
> +{
> +	u64 *dbg_reg =3D &vcpu->arch.vcpu_debug_state.dbg_bcr[rd->reg];
> +
> +	if (p->is_write)
> +		reg_to_dbg(vcpu, p, dbg_reg);
> +	else
> +		dbg_to_reg(vcpu, p, dbg_reg);
> +
> +	return true;
> +}
> +
> +static int set_bcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
> +		const struct kvm_one_reg *reg, void __user *uaddr)
> +{
> +	__u64 *r =3D &vcpu->arch.vcpu_debug_state.dbg_bcr[rd->reg];
> +
> +	if (copy_from_user(uaddr, r, KVM_REG_SIZE(reg->id)) !=3D 0)
> +		return -EFAULT;
> +
> +	return 0;
> +}
> +
> +static int get_bcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
> +	const struct kvm_one_reg *reg, void __user *uaddr)
> +{
> +	__u64 *r =3D &vcpu->arch.vcpu_debug_state.dbg_bcr[rd->reg];
> +
> +	if (copy_to_user(uaddr, r, KVM_REG_SIZE(reg->id)) !=3D 0)
> +		return -EFAULT;
> +	return 0;
> +}
> +
> +static inline void reset_bcr(struct kvm_vcpu *vcpu,
> +			     const struct sys_reg_desc *rd)
> +{
> +	vcpu->arch.vcpu_debug_state.dbg_bcr[rd->reg] =3D rd->val;
> +}
> +
> +static inline bool trap_wvr(struct kvm_vcpu *vcpu,
> +			    const struct sys_reg_params *p,
> +			    const struct sys_reg_desc *rd)
> +{
> +	u64 *dbg_reg =3D &vcpu->arch.vcpu_debug_state.dbg_wvr[rd->reg];
> +
> +	if (p->is_write)
> +		reg_to_dbg(vcpu, p, dbg_reg);
> +	else
> +		dbg_to_reg(vcpu, p, dbg_reg);
> +
> +	return true;
> +}
> +
> +static int set_wvr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
> +		const struct kvm_one_reg *reg, void __user *uaddr)
> +{
> +	__u64 *r =3D &vcpu->arch.vcpu_debug_state.dbg_wvr[rd->reg];
> +
> +	if (copy_from_user(uaddr, r, KVM_REG_SIZE(reg->id)) !=3D 0)
> +		return -EFAULT;
> +	return 0;
> +}
> +
> +static int get_wvr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
> +	const struct kvm_one_reg *reg, void __user *uaddr)
> +{
> +	__u64 *r =3D &vcpu->arch.vcpu_debug_state.dbg_wvr[rd->reg];
> +
> +	if (copy_to_user(uaddr, r, KVM_REG_SIZE(reg->id)) !=3D 0)
> +		return -EFAULT;
> +	return 0;
> +}
> +
> +static inline void reset_wvr(struct kvm_vcpu *vcpu,
> +			     const struct sys_reg_desc *rd)
> +{
> +	vcpu->arch.vcpu_debug_state.dbg_wvr[rd->reg] =3D rd->val;
> +}
> +
> +static inline bool trap_wcr(struct kvm_vcpu *vcpu,
> +			    const struct sys_reg_params *p,
> +			    const struct sys_reg_desc *rd)
> +{
> +	u64 *dbg_reg =3D &vcpu->arch.vcpu_debug_state.dbg_wcr[rd->reg];
> +
> +	if (p->is_write)
> +		reg_to_dbg(vcpu, p, dbg_reg);
> +	else
> +		dbg_to_reg(vcpu, p, dbg_reg);
> +
> +	return true;
> +}
> +
> +static int set_wcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
> +		const struct kvm_one_reg *reg, void __user *uaddr)
> +{
> +	__u64 *r =3D &vcpu->arch.vcpu_debug_state.dbg_wcr[rd->reg];
> +
> +	if (copy_from_user(uaddr, r, KVM_REG_SIZE(reg->id)) !=3D 0)
> +		return -EFAULT;
> +	return 0;
> +}
> +
> +static int get_wcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
> +	const struct kvm_one_reg *reg, void __user *uaddr)
> +{
> +	__u64 *r =3D &vcpu->arch.vcpu_debug_state.dbg_wcr[rd->reg];
> +
> +	if (copy_to_user(uaddr, r, KVM_REG_SIZE(reg->id)) !=3D 0)
> +		return -EFAULT;
> +	return 0;
> +}
> +
> +static inline void reset_wcr(struct kvm_vcpu *vcpu,
> +			     const struct sys_reg_desc *rd)
> +{
> +	vcpu->arch.vcpu_debug_state.dbg_wcr[rd->reg] =3D rd->val;
> +}
> +
>  static void reset_amair_el1(struct kvm_vcpu *vcpu, const struct sys_reg_=
desc *r)
>  {
>  	u64 amair;
> @@ -240,16 +437,16 @@ static void reset_mpidr(struct kvm_vcpu *vcpu, cons=
t struct sys_reg_desc *r)
>  #define DBG_BCR_BVR_WCR_WVR_EL1(n)					\
>  	/* DBGBVRn_EL1 */						\
>  	{ Op0(0b10), Op1(0b000), CRn(0b0000), CRm((n)), Op2(0b100),	\
> -	  trap_debug_regs, reset_val, (DBGBVR0_EL1 + (n)), 0 },		\
> +	  trap_bvr, reset_bvr, n, 0, get_bvr, set_bvr },		\
>  	/* DBGBCRn_EL1 */						\
>  	{ Op0(0b10), Op1(0b000), CRn(0b0000), CRm((n)), Op2(0b101),	\
> -	  trap_debug_regs, reset_val, (DBGBCR0_EL1 + (n)), 0 },		\
> +	  trap_bcr, reset_bcr, n, 0, get_bcr, set_bcr },		\
>  	/* DBGWVRn_EL1 */						\
>  	{ Op0(0b10), Op1(0b000), CRn(0b0000), CRm((n)), Op2(0b110),	\
> -	  trap_debug_regs, reset_val, (DBGWVR0_EL1 + (n)), 0 },		\
> +	  trap_wvr, reset_wvr, n, 0,  get_wvr, set_wvr },		\
>  	/* DBGWCRn_EL1 */						\
>  	{ Op0(0b10), Op1(0b000), CRn(0b0000), CRm((n)), Op2(0b111),	\
> -	  trap_debug_regs, reset_val, (DBGWCR0_EL1 + (n)), 0 }
> +	  trap_wcr, reset_wcr, n, 0,  get_wcr, set_wcr }
>  =

>  /*
>   * Architected system registers.
> @@ -516,28 +713,55 @@ static bool trap_debug32(struct kvm_vcpu *vcpu,
>  	return true;
>  }
>  =

> -#define DBG_BCR_BVR_WCR_WVR(n)					\
> -	/* DBGBVRn */						\
> -	{ Op1( 0), CRn( 0), CRm((n)), Op2( 4), trap_debug32,	\
> -	  NULL, (cp14_DBGBVR0 + (n) * 2) },			\
> -	/* DBGBCRn */						\
> -	{ Op1( 0), CRn( 0), CRm((n)), Op2( 5), trap_debug32,	\
> -	  NULL, (cp14_DBGBCR0 + (n) * 2) },			\
> -	/* DBGWVRn */						\
> -	{ Op1( 0), CRn( 0), CRm((n)), Op2( 6), trap_debug32,	\
> -	  NULL, (cp14_DBGWVR0 + (n) * 2) },			\
> -	/* DBGWCRn */						\
> -	{ Op1( 0), CRn( 0), CRm((n)), Op2( 7), trap_debug32,	\
> -	  NULL, (cp14_DBGWCR0 + (n) * 2) }
> -
> -#define DBGBXVR(n)						\
> -	{ Op1( 0), CRn( 1), CRm((n)), Op2( 1), trap_debug32,	\
> -	  NULL, cp14_DBGBXVR0 + n * 2 }
> +/* AArch32 debug register mappings
> + *
> + * AArch32 DBGBVRn is mapped to DBGBVRn_EL1[31:0]
> + * AArch32 DBGBXVRn is mapped to DBGBVRn_EL1[63:32]
> + *
> + * All control registers and watchpoint value registers are mapped to
> + * the lower 32 bits of their AArch64 equivalents. We share the trap
> + * handlers with the above AArch64 code which checks what mode the
> + * system is in.
> + */
> +
> +static inline bool trap_xvr(struct kvm_vcpu *vcpu,
> +			    const struct sys_reg_params *p,
> +			    const struct sys_reg_desc *rd)
> +{
> +	u64 *dbg_reg =3D &vcpu->arch.vcpu_debug_state.dbg_bvr[rd->reg];
> +
> +	if (p->is_write) {
> +		u64 val =3D *dbg_reg;
> +
> +		val &=3D 0xffffffffUL;
> +		val |=3D *vcpu_reg(vcpu, p->Rt) << 32;
> +		*dbg_reg =3D val;
> +
> +		vcpu->arch.debug_flags |=3D KVM_ARM64_DEBUG_DIRTY;
> +	} else {
> +		*vcpu_reg(vcpu, p->Rt) =3D *dbg_reg >> 32;
> +	}
> +
> +	return true;
> +}
> +
> +#define DBG_BCR_BVR_WCR_WVR(n)						\
> +	/* DBGBVRn */							\
> +	{ Op1( 0), CRn( 0), CRm((n)), Op2( 4), trap_bvr, NULL, n }, 	\
> +	/* DBGBCRn */							\
> +	{ Op1( 0), CRn( 0), CRm((n)), Op2( 5), trap_bcr, NULL, n },	\
> +	/* DBGWVRn */							\
> +	{ Op1( 0), CRn( 0), CRm((n)), Op2( 6), trap_wvr, NULL, n },	\
> +	/* DBGWCRn */							\
> +	{ Op1( 0), CRn( 0), CRm((n)), Op2( 7), trap_wcr, NULL, n }
> +
> +#define DBGBXVR(n)							\
> +	{ Op1( 0), CRn( 1), CRm((n)), Op2( 1), trap_xvr, NULL, n }
>  =

>  /*
>   * Trapped cp14 registers. We generally ignore most of the external
>   * debug, on the principle that they don't really make sense to a
> - * guest. Revisit this one day, whould this principle change.
> + * guest. Revisit this one day, would this principle change.
>   */
>  static const struct sys_reg_desc cp14_regs[] =3D {
>  	/* DBGIDR */
> @@ -1303,6 +1527,9 @@ int kvm_arm_sys_reg_get_reg(struct kvm_vcpu *vcpu, =
const struct kvm_one_reg *reg
>  	if (!r)
>  		return get_invariant_sys_reg(reg->id, uaddr);
>  =

> +	if (r->get_user)
> +		return (r->get_user)(vcpu, r, reg, uaddr);
> +
>  	return reg_to_user(uaddr, &vcpu_sys_reg(vcpu, r->reg), reg->id);
>  }
>  =

> @@ -1321,6 +1548,9 @@ int kvm_arm_sys_reg_set_reg(struct kvm_vcpu *vcpu, =
const struct kvm_one_reg *reg
>  	if (!r)
>  		return set_invariant_sys_reg(reg->id, uaddr);
>  =

> +	if (r->set_user)
> +		return (r->set_user)(vcpu, r, reg, uaddr);
> +
>  	return reg_from_user(&vcpu_sys_reg(vcpu, r->reg), uaddr, reg->id);
>  }
>  =

> diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
> index d411e25..eaa324e 100644
> --- a/arch/arm64/kvm/sys_regs.h
> +++ b/arch/arm64/kvm/sys_regs.h
> @@ -55,6 +55,12 @@ struct sys_reg_desc {
>  =

>  	/* Value (usually reset value) */
>  	u64 val;
> +
> +	/* Custom get/set_user functions, fallback to generic if NULL */
> +	int (*get_user)(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
> +			const struct kvm_one_reg *reg, void __user *uaddr);
> +	int (*set_user)(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
> +			const struct kvm_one_reg *reg, void __user *uaddr);
>  };
>  =

>  static inline void print_sys_reg_instr(const struct sys_reg_params *p)
> -- =

> 2.4.5
> =
