From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v6 09/12] KVM: arm64: introduce vcpu->arch.debug_ptr
Date: Wed, 24 Jun 2015 13:42:36 +0200
Message-ID: <20150624114236.GB22785@cbox>
References: <1434716630-18260-1-git-send-email-alex.bennee@linaro.org>
 <1434716630-18260-10-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D417F56CBF
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Jun 2015 07:31:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PqDSKnNWRS-S for <kvmarm@lists.cs.columbia.edu>;
 Wed, 24 Jun 2015 07:31:41 -0400 (EDT)
Received: from mail-lb0-f181.google.com (mail-lb0-f181.google.com
 [209.85.217.181])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EC29A56C70
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Jun 2015 07:31:40 -0400 (EDT)
Received: by lbbwc1 with SMTP id wc1so24575980lbb.2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Jun 2015 04:42:36 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1434716630-18260-10-git-send-email-alex.bennee@linaro.org>
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

On Fri, Jun 19, 2015 at 01:23:47PM +0100, Alex Benn=E9e wrote:
> This introduces a level of indirection for the debug registers. Instead
> of using the sys_regs[] directly we store registers in a structure in
> the vcpu. As we are no longer tied to the layout of the sys_regs[] we
> can make the copies size appropriate for control and value registers.
> =

> This also entails updating the sys_regs code to access this new
> structure. Instead of passing a register index we now pass an offset
> into the kvm_guest_debug_arch structure.
> =

> We also need to ensure the GET/SET_ONE_REG ioctl operations store the
> registers in their correct location.
> =

> Signed-off-by: Alex Benn=E9e <alex.bennee@linaro.org>
> =

> ---
> v6:
>   - fix up some ws issues
>   - correct clobber info
>   - re-word commentary in kvm_host.h
>   - fix endian access issues for aarch32 fields
>   - revert all KVM_GET/SET_ONE_REG to 64bit (also see ABI update)
> ---
>  arch/arm/kvm/arm.c                |   3 +
>  arch/arm64/include/asm/kvm_asm.h  |  24 +++----
>  arch/arm64/include/asm/kvm_host.h |  16 ++++-
>  arch/arm64/kernel/asm-offsets.c   |   6 ++
>  arch/arm64/kvm/hyp.S              |  24 ++++---
>  arch/arm64/kvm/sys_regs.c         | 148 +++++++++++++++++++++++++++++---=
------
>  6 files changed, 161 insertions(+), 60 deletions(-)
> =

> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
> index 9b3ed6d..0d17c7b 100644
> --- a/arch/arm/kvm/arm.c
> +++ b/arch/arm/kvm/arm.c
> @@ -279,6 +279,9 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
>  	/* Set up the timer */
>  	kvm_timer_vcpu_init(vcpu);
>  =

> +	/* Set the debug registers to be the guests */
> +	vcpu->arch.debug_ptr =3D &vcpu->arch.vcpu_debug_state;
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
> index e2db6a6..9697daf 100644
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
> diff --git a/arch/arm64/kvm/hyp.S b/arch/arm64/kvm/hyp.S
> index ee7f649..fa593fa 100644
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
> index c370b40..79d4e52 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -211,6 +211,43 @@ static bool trap_debug_regs(struct kvm_vcpu *vcpu,
>  	return true;
>  }
>  =

> +/* Used when AArch32 kernels trap to mapped debug registers */
> +static inline bool trap_debug32(struct kvm_vcpu *vcpu,
> +				const struct sys_reg_params *p,
> +				const struct sys_reg_desc *rd)
> +{
> +	__u32 *r =3D (__u32 *) ((void * )&vcpu->arch.vcpu_debug_state + rd->reg=
);

This still looks like something that's asking for BE trouble.  Why not
access the register as a __u64 as it is and then only special-case it
somehow for the XVR thingy...  Perhaps a separate function, see below.

> +	if (p->is_write) {
> +		*r =3D *vcpu_reg(vcpu, p->Rt);
> +		vcpu->arch.debug_flags |=3D KVM_ARM64_DEBUG_DIRTY;
> +	} else {
> +		*vcpu_reg(vcpu, p->Rt) =3D *r;
> +	}
> +
> +	return true;
> +}
> +
> +static inline bool trap_debug64(struct kvm_vcpu *vcpu,
> +				const struct sys_reg_params *p,
> +				const struct sys_reg_desc *rd)
> +{
> +	__u64 *r =3D (__u64 *) ((void * )&vcpu->arch.vcpu_debug_state + rd->reg=
);
> +	if (p->is_write) {
> +		*r =3D *vcpu_reg(vcpu, p->Rt);
> +		vcpu->arch.debug_flags |=3D KVM_ARM64_DEBUG_DIRTY;
> +	} else {
> +		*vcpu_reg(vcpu, p->Rt) =3D *r;
> +	}
> +
> +	return true;
> +}
> +
> +static inline void reset_debug64(struct kvm_vcpu *vcpu, const struct sys=
_reg_desc *rd)
> +{
> +	__u64 *r =3D (__u64 *) ((void * )&vcpu->arch.vcpu_debug_state + rd->reg=
);
> +	*r =3D rd->val;
> +}
> +
>  static void reset_amair_el1(struct kvm_vcpu *vcpu, const struct sys_reg_=
desc *r)
>  {
>  	u64 amair;
> @@ -240,16 +277,20 @@ static void reset_mpidr(struct kvm_vcpu *vcpu, cons=
t struct sys_reg_desc *r)
>  #define DBG_BCR_BVR_WCR_WVR_EL1(n)					\
>  	/* DBGBVRn_EL1 */						\
>  	{ Op0(0b10), Op1(0b000), CRn(0b0000), CRm((n)), Op2(0b100),	\
> -	  trap_debug_regs, reset_val, (DBGBVR0_EL1 + (n)), 0 },		\
> +	  trap_debug64, reset_debug64,					\
> +	  offsetof(struct kvm_guest_debug_arch, dbg_bvr[(n)]), 0 },	\
>  	/* DBGBCRn_EL1 */						\
>  	{ Op0(0b10), Op1(0b000), CRn(0b0000), CRm((n)), Op2(0b101),	\
> -	  trap_debug_regs, reset_val, (DBGBCR0_EL1 + (n)), 0 },		\
> +	  trap_debug64, reset_debug64,					\
> +	  offsetof(struct kvm_guest_debug_arch, dbg_bcr[(n)]), 0},	\
>  	/* DBGWVRn_EL1 */						\
>  	{ Op0(0b10), Op1(0b000), CRn(0b0000), CRm((n)), Op2(0b110),	\
> -	  trap_debug_regs, reset_val, (DBGWVR0_EL1 + (n)), 0 },		\
> +	  trap_debug64, reset_debug64,					\
> +	  offsetof(struct kvm_guest_debug_arch, dbg_wvr[(n)]), 0 },	\
>  	/* DBGWCRn_EL1 */						\
>  	{ Op0(0b10), Op1(0b000), CRn(0b0000), CRm((n)), Op2(0b111),	\
> -	  trap_debug_regs, reset_val, (DBGWCR0_EL1 + (n)), 0 }
> +	  trap_debug64, reset_debug64,					\
> +	  offsetof(struct kvm_guest_debug_arch, dbg_wcr[(n)]), 0}
>  =

>  /*
>   * Architected system registers.
> @@ -502,42 +543,51 @@ static bool trap_dbgidr(struct kvm_vcpu *vcpu,
>  	}
>  }
>  =

> -static bool trap_debug32(struct kvm_vcpu *vcpu,
> -			 const struct sys_reg_params *p,
> -			 const struct sys_reg_desc *r)
> -{
> -	if (p->is_write) {
> -		vcpu_cp14(vcpu, r->reg) =3D *vcpu_reg(vcpu, p->Rt);
> -		vcpu->arch.debug_flags |=3D KVM_ARM64_DEBUG_DIRTY;
> -	} else {
> -		*vcpu_reg(vcpu, p->Rt) =3D vcpu_cp14(vcpu, r->reg);
> -	}
> -
> -	return true;
> -}
> +/* AArch32 debug register mappings
> + *
> + * AArch32 DBGBVRn is mapped to DBGBVRn_EL1[31:0]
> + * AArch32 DBGBXVRn is mapped to DBGBVRn_EL1[63:32]
> + *
> + * All control registers and watchpoint value registers are mapped to
> + * the lower 32 bits of their AArch64 equivalents.
> + *
> + * We also need to ensure we deal with endian differences when
> + * mapping a partial AArch64 register.
> + */
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
> +#ifdef CONFIG_CPU_BIG_ENDIAN
> +#define DBG_AA32_LOW_OFFSET	sizeof(__u32)
> +#define DBG_AA32_HIGH_OFFSET	0
> +#else
> +#define DBG_AA32_LOW_OFFSET	0
> +#define DBG_AA32_HIGH_OFFSET	sizeof(__u32)
> +#endif
> +
> +#define DBG_BCR_BVR_WCR_WVR(n)						\
> +	/* DBGBVRn */							\
> +	{ Op1( 0), CRn( 0), CRm((n)), Op2( 4), trap_debug32,		\
> +	  NULL, offsetof(struct kvm_guest_debug_arch, dbg_bvr[(n)])	\
> +	  + DBG_AA32_LOW_OFFSET },					\
> +	/* DBGBCRn */							\
> +	{ Op1( 0), CRn( 0), CRm((n)), Op2( 5), trap_debug32,		\
> +	  NULL, offsetof(struct kvm_guest_debug_arch, dbg_bcr[(n)]) },	\

why doesn't this need + DBG_AA32_LOW_OFFSET?

> +	/* DBGWVRn */							\
> +	{ Op1( 0), CRn( 0), CRm((n)), Op2( 6), trap_debug32,		\
> +	  NULL, offsetof(struct kvm_guest_debug_arch, dbg_wvr[(n)])	\
> +	  + DBG_AA32_LOW_OFFSET },					\
> +	/* DBGWCRn */							\
> +	{ Op1( 0), CRn( 0), CRm((n)), Op2( 7), trap_debug32,		\
> +	  NULL, offsetof(struct kvm_guest_debug_arch, dbg_wcr[(n)]) }

ditto ?

I find this quite hard to read and adding this offset on the separate
line doesn't seem to help.

Perhaps you should just bite the bullet and have separate accessor
functions for the wvr/wcr/bcr/bvr arrays and just pass the register
number.

Thanks,
-Christoffer
