From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v5 09/12] KVM: arm64: introduce vcpu->arch.debug_ptr
Date: Thu, 4 Jun 2015 12:56:39 +0200
Message-ID: <20150604105639.GE7657@cbox>
References: <1432891828-4816-1-git-send-email-alex.bennee@linaro.org>
 <1432891828-4816-10-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B70E652EE7
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Jun 2015 06:45:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eVD7OvuoWYXF for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Jun 2015 06:45:57 -0400 (EDT)
Received: from mail-lb0-f176.google.com (mail-lb0-f176.google.com
 [209.85.217.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AD12A52E64
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Jun 2015 06:45:55 -0400 (EDT)
Received: by lbcue7 with SMTP id ue7so24799377lbc.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 04 Jun 2015 03:55:58 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1432891828-4816-10-git-send-email-alex.bennee@linaro.org>
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

On Fri, May 29, 2015 at 10:30:25AM +0100, Alex Benn=E9e wrote:
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
> ---
>  arch/arm/kvm/arm.c                |   3 +
>  arch/arm64/include/asm/kvm_asm.h  |  24 +++-----
>  arch/arm64/include/asm/kvm_host.h |  12 +++-
>  arch/arm64/kernel/asm-offsets.c   |   6 ++
>  arch/arm64/kvm/hyp.S              | 107 +++++++++++++++++---------------
>  arch/arm64/kvm/sys_regs.c         | 126 +++++++++++++++++++++++++++++++-=
------
>  6 files changed, 188 insertions(+), 90 deletions(-)
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
> index e2db6a6..e5040b6 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -108,11 +108,21 @@ struct kvm_vcpu_arch {
>  	/* Exception Information */
>  	struct kvm_vcpu_fault_info fault;
>  =

> -	/* Debug state */
> +	/* Guest debug state */
>  	u64 debug_flags;
>  =

> +	/*
> +	 * For debugging the guest we need to keep a set of debug
> +	 * registers which can override the guests own debug state

the guest's

> +	 * while being used. These are set via the KVM_SET_GUEST_DEBUG
> +	 * ioctl.

Which ones are set via the KVM_SET_GUEST_DEBUG ioctl?

This comment doesn't feel like it's properly explaining the fields
below, because it feels like there's missing a set of registers for this
to add up.  I would suggest rewording this comment to something like:

  We maintain more than a single set of debug registers to support
  debugging the guest from the host and to maintain separate host and
  guest state during world switches.  vcpu_debug_state are the debug
  registers of the vcpu as the guest sees them.  host_debug_state are
  the host registers which are saved and restored during world switches.

  debug_ptr points to the set of debug registers that should be loaded
  onto the hardware when running the guest.

That is, assuming I got this right.

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
> index 9c4897d..1940a4c 100644
> --- a/arch/arm64/kvm/hyp.S
> +++ b/arch/arm64/kvm/hyp.S
> @@ -228,7 +228,7 @@
>  	stp	x24, x25, [x3, #160]
>  .endm
>  =

> -.macro save_debug type
> +.macro save_debug type regsz offsz
>  	// x4: pointer to register set
>  	// x5: number of registers to skip
>  	// x6..x22 trashed
> @@ -258,22 +258,22 @@
>  	add	x22, x22, x5, lsl #2
>  	br	x22
>  1:
> -	str	x21, [x4, #(15 * 8)]
> -	str	x20, [x4, #(14 * 8)]
> -	str	x19, [x4, #(13 * 8)]
> -	str	x18, [x4, #(12 * 8)]
> -	str	x17, [x4, #(11 * 8)]
> -	str	x16, [x4, #(10 * 8)]
> -	str	x15, [x4, #(9 * 8)]
> -	str	x14, [x4, #(8 * 8)]
> -	str	x13, [x4, #(7 * 8)]
> -	str	x12, [x4, #(6 * 8)]
> -	str	x11, [x4, #(5 * 8)]
> -	str	x10, [x4, #(4 * 8)]
> -	str	x9, [x4, #(3 * 8)]
> -	str	x8, [x4, #(2 * 8)]
> -	str	x7, [x4, #(1 * 8)]
> -	str	x6, [x4, #(0 * 8)]
> +	str	\regsz\()21, [x4, #(15 * \offsz)]
> +	str	\regsz\()20, [x4, #(14 * \offsz)]
> +	str	\regsz\()19, [x4, #(13 * \offsz)]
> +	str	\regsz\()18, [x4, #(12 * \offsz)]
> +	str	\regsz\()17, [x4, #(11 * \offsz)]
> +	str	\regsz\()16, [x4, #(10 * \offsz)]
> +	str	\regsz\()15, [x4, #(9 * \offsz)]
> +	str	\regsz\()14, [x4, #(8 * \offsz)]
> +	str	\regsz\()13, [x4, #(7 * \offsz)]
> +	str	\regsz\()12, [x4, #(6 * \offsz)]
> +	str	\regsz\()11, [x4, #(5 * \offsz)]
> +	str	\regsz\()10, [x4, #(4 * \offsz)]
> +	str	\regsz\()9, [x4, #(3 * \offsz)]
> +	str	\regsz\()8, [x4, #(2 * \offsz)]
> +	str	\regsz\()7, [x4, #(1 * \offsz)]
> +	str	\regsz\()6, [x4, #(0 * \offsz)]
>  .endm
>  =

>  .macro restore_sysregs
> @@ -318,7 +318,7 @@
>  	msr	mdscr_el1,	x25
>  .endm
>  =

> -.macro restore_debug type
> +.macro restore_debug type regsz offsz
>          // x4: pointer to register set
>          // x5: number of registers to skip
>  	// x6..x22 trashed
> @@ -327,22 +327,22 @@
>  	add	x22, x22, x5, lsl #2
>  	br	x22
>  1:
> -	ldr	x21, [x4, #(15 * 8)]
> -	ldr	x20, [x4, #(14 * 8)]
> -	ldr	x19, [x4, #(13 * 8)]
> -	ldr	x18, [x4, #(12 * 8)]
> -	ldr	x17, [x4, #(11 * 8)]
> -	ldr	x16, [x4, #(10 * 8)]
> -	ldr	x15, [x4, #(9 * 8)]
> -	ldr	x14, [x4, #(8 * 8)]
> -	ldr	x13, [x4, #(7 * 8)]
> -	ldr	x12, [x4, #(6 * 8)]
> -	ldr	x11, [x4, #(5 * 8)]
> -	ldr	x10, [x4, #(4 * 8)]
> -	ldr	x9, [x4, #(3 * 8)]
> -	ldr	x8, [x4, #(2 * 8)]
> -	ldr	x7, [x4, #(1 * 8)]
> -	ldr	x6, [x4, #(0 * 8)]
> +	ldr	\regsz\()21, [x4, #(15 * \offsz)]
> +	ldr	\regsz\()20, [x4, #(14 * \offsz)]
> +	ldr	\regsz\()19, [x4, #(13 * \offsz)]
> +	ldr	\regsz\()18, [x4, #(12 * \offsz)]
> +	ldr	\regsz\()17, [x4, #(11 * \offsz)]
> +	ldr	\regsz\()16, [x4, #(10 * \offsz)]
> +	ldr	\regsz\()15, [x4, #(9 * \offsz)]
> +	ldr	\regsz\()14, [x4, #(8 * \offsz)]
> +	ldr	\regsz\()13, [x4, #(7 * \offsz)]
> +	ldr	\regsz\()12, [x4, #(6 * \offsz)]
> +	ldr	\regsz\()11, [x4, #(5 * \offsz)]
> +	ldr	\regsz\()10, [x4, #(4 * \offsz)]
> +	ldr	\regsz\()9, [x4, #(3 * \offsz)]
> +	ldr	\regsz\()8, [x4, #(2 * \offsz)]
> +	ldr	\regsz\()7, [x4, #(1 * \offsz)]
> +	ldr	\regsz\()6, [x4, #(0 * \offsz)]
>  =

>  	adr	x22, 1f
>  	add	x22, x22, x5, lsl #2
> @@ -601,6 +601,7 @@ __restore_sysregs:
>  __save_debug:
>  	// x0: base address for vcpu context
>  	// x2: ptr to current CPU context
> +	// x3: ptr to debug reg struct
>  	// x4/x5: trashed
>  =

>  	mrs	x26, id_aa64dfr0_el1
> @@ -611,16 +612,16 @@ __save_debug:
>  	sub	w25, w26, w25		// How many WPs to skip
>  =

>  	mov     x5, x24
> -	add	x4, x2, #CPU_SYSREG_OFFSET(DBGBCR0_EL1)
> -	save_debug dbgbcr
> -	add	x4, x2, #CPU_SYSREG_OFFSET(DBGBVR0_EL1)
> -	save_debug dbgbvr
> +	add	x4, x3, #DEBUG_BCR
> +	save_debug dbgbcr w 4
> +	add	x4, x3, #DEBUG_BVR
> +	save_debug dbgbvr x 8
>  =

>  	mov     x5, x25
> -	add	x4, x2, #CPU_SYSREG_OFFSET(DBGWCR0_EL1)
> -	save_debug dbgwcr
> -	add	x4, x2, #CPU_SYSREG_OFFSET(DBGWVR0_EL1)
> -	save_debug dbgwvr
> +	add	x4, x3, #DEBUG_WCR
> +	save_debug dbgwcr w 4
> +	add	x4, x3, #DEBUG_WVR
> +	save_debug dbgwvr x 8
>  =

>  	mrs	x21, mdccint_el1
>  	str	x21, [x2, #CPU_SYSREG_OFFSET(MDCCINT_EL1)]
> @@ -640,16 +641,16 @@ __restore_debug:
>  	sub	w25, w26, w25		// How many WPs to skip
>  =

>  	mov     x5, x24
> -	add	x4, x2, #CPU_SYSREG_OFFSET(DBGBCR0_EL1)
> -	restore_debug dbgbcr
> -	add	x4, x2, #CPU_SYSREG_OFFSET(DBGBVR0_EL1)
> -	restore_debug dbgbvr
> +	add	x4, x3, #DEBUG_BCR
> +	restore_debug dbgbcr w 4
> +	add	x4, x3, #DEBUG_BVR
> +	restore_debug dbgbvr x 8
>  =

>  	mov     x5, x25
> -	add	x4, x2, #CPU_SYSREG_OFFSET(DBGWCR0_EL1)
> -	restore_debug dbgwcr
> -	add	x4, x2, #CPU_SYSREG_OFFSET(DBGWVR0_EL1)
> -	restore_debug dbgwvr
> +	add	x4, x3, #DEBUG_WCR
> +	restore_debug dbgwcr w 4
> +	add	x4, x3, #DEBUG_WVR
> +	restore_debug dbgwvr x 8
>  =

>  	ldr	x21, [x2, #CPU_SYSREG_OFFSET(MDCCINT_EL1)]
>  	msr	mdccint_el1, x21
> @@ -688,6 +689,7 @@ ENTRY(__kvm_vcpu_run)
>  	bl __save_sysregs
>  =

>  	compute_debug_state 1f
> +	add	x3, x0, #VCPU_HOST_DEBUG_STATE
>  	bl	__save_debug
>  1:
>  	activate_traps
> @@ -703,6 +705,8 @@ ENTRY(__kvm_vcpu_run)
>  	bl __restore_fpsimd
>  =

>  	skip_debug_state x3, 1f
> +	ldr	x3, [x0, #VCPU_DEBUG_PTR]
> +	kern_hyp_va x3
>  	bl	__restore_debug
>  1:
>  	restore_guest_32bit_state
> @@ -723,6 +727,8 @@ __kvm_vcpu_return:
>  	bl __save_sysregs
>  =

>  	skip_debug_state x3, 1f
> +	ldr	x3, [x0, #VCPU_DEBUG_PTR]
> +	kern_hyp_va x3
>  	bl	__save_debug
>  1:
>  	save_guest_32bit_state
> @@ -745,6 +751,7 @@ __kvm_vcpu_return:
>  	// already been saved. Note that we nuke the whole 64bit word.
>  	// If we ever add more flags, we'll have to be more careful...
>  	str	xzr, [x0, #VCPU_DEBUG_FLAGS]
> +	add	x3, x0, #VCPU_HOST_DEBUG_STATE
>  	bl	__restore_debug
>  1:
>  	restore_host_regs
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index c370b40..405403e 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -211,6 +211,48 @@ static bool trap_debug_regs(struct kvm_vcpu *vcpu,
>  	return true;
>  }
>  =

> +static inline bool trap_debug32(struct kvm_vcpu *vcpu,
> +				const struct sys_reg_params *p,
> +				const struct sys_reg_desc *rd)
> +{
> +	__u32 *r =3D (__u32 *) ((void * )&vcpu->arch.vcpu_debug_state + rd->reg=
);

Does this work on BE systems?

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
> +static inline void reset_debug32(struct kvm_vcpu *vcpu, const struct sys=
_reg_desc *rd)
> +{
> +	__u32 *r =3D (__u32 *) ((void * )&vcpu->arch.vcpu_debug_state + rd->reg=
);

Does this work on BE systems?

> +	*r =3D rd->val;
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
> @@ -240,16 +282,20 @@ static void reset_mpidr(struct kvm_vcpu *vcpu, cons=
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
> +	  trap_debug32, reset_debug32,					\
> +	  offsetof(struct kvm_guest_debug_arch, dbg_bcr[(n)]), 0},	\
>  	/* DBGWVRn_EL1 */						\
>  	{ Op0(0b10), Op1(0b000), CRn(0b0000), CRm((n)), Op2(0b110),	\
> -	  trap_debug_regs, reset_val, (DBGWVR0_EL1 + (n)), 0 },		\
> +	  trap_debug64, reset_debug64,					\
> +	  offsetof(struct kvm_guest_debug_arch, dbg_wvr[(n)]), 0 },	\
>  	/* DBGWCRn_EL1 */						\
>  	{ Op0(0b10), Op1(0b000), CRn(0b0000), CRm((n)), Op2(0b111),	\
> -	  trap_debug_regs, reset_val, (DBGWCR0_EL1 + (n)), 0 }
> +	  trap_debug32, reset_debug32,					\
> +	  offsetof(struct kvm_guest_debug_arch, dbg_wcr[(n)]), 0}
>  =

>  /*
>   * Architected system registers.
> @@ -502,37 +548,23 @@ static bool trap_dbgidr(struct kvm_vcpu *vcpu,
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
> -
>  #define DBG_BCR_BVR_WCR_WVR(n)					\
>  	/* DBGBVRn */						\
>  	{ Op1( 0), CRn( 0), CRm((n)), Op2( 4), trap_debug32,	\
> -	  NULL, (cp14_DBGBVR0 + (n) * 2) },			\
> +	  NULL, offsetof(struct kvm_guest_debug_arch, dbg_bvr[(n)]) },	\
>  	/* DBGBCRn */						\
>  	{ Op1( 0), CRn( 0), CRm((n)), Op2( 5), trap_debug32,	\
> -	  NULL, (cp14_DBGBCR0 + (n) * 2) },			\
> +	  NULL, offsetof(struct kvm_guest_debug_arch, dbg_bcr[(n)]) },			\
>  	/* DBGWVRn */						\
>  	{ Op1( 0), CRn( 0), CRm((n)), Op2( 6), trap_debug32,	\
> -	  NULL, (cp14_DBGWVR0 + (n) * 2) },			\
> +	  NULL, offsetof(struct kvm_guest_debug_arch, dbg_wvr[(n)]) },			\
>  	/* DBGWCRn */						\
>  	{ Op1( 0), CRn( 0), CRm((n)), Op2( 7), trap_debug32,	\
> -	  NULL, (cp14_DBGWCR0 + (n) * 2) }
> +	  NULL, offsetof(struct kvm_guest_debug_arch, dbg_wcr[(n)]) }
>  =

>  #define DBGBXVR(n)						\
>  	{ Op1( 0), CRn( 1), CRm((n)), Op2( 1), trap_debug32,	\
> -	  NULL, cp14_DBGBXVR0 + n * 2 }
> +	  NULL, offsetof(struct kvm_guest_debug_arch, dbg_bvr[(n)])+sizeof(__u3=
2) }

Does this work on BE systems?

>  =

>  /*
>   * Trapped cp14 registers. We generally ignore most of the external
> @@ -1288,6 +1320,42 @@ static int demux_c15_set(u64 id, void __user *uadd=
r)
>  	}
>  }
>  =

> +static int debug_set32(struct kvm_vcpu *vcpu, const struct sys_reg_desc =
*rd,
> +		const struct kvm_one_reg *reg, void __user *uaddr)
> +{
> +	__u32 *r =3D (__u32 *) ((void * )&vcpu->arch.vcpu_debug_state + rd->reg=
);

Does this work on BE systems?

> +	if (copy_from_user(uaddr, r, KVM_REG_SIZE(reg->id)) !=3D 0)

don't you risk copying beyond the boundaries of the array elements here
because KVM_REG_SIZE() is always 64 bits?

> +		return -EFAULT;
> +	return 0;
> +}
> +
> +static int debug_set64(struct kvm_vcpu *vcpu, const struct sys_reg_desc =
*rd,
> +		const struct kvm_one_reg *reg, void __user *uaddr)
> +{
> +	__u64 *r =3D (__u64 *) ((void * )&vcpu->arch.vcpu_debug_state + rd->reg=
);
> +	if (copy_from_user(uaddr, r, KVM_REG_SIZE(reg->id)) !=3D 0)
> +		return -EFAULT;
> +	return 0;
> +}
> +
> +static int debug_get32(struct kvm_vcpu *vcpu, const struct sys_reg_desc =
*rd,
> +		const struct kvm_one_reg *reg, void __user *uaddr)
> +{
> +	__u32 *r =3D (__u32 *) ((void * )&vcpu->arch.vcpu_debug_state + rd->reg=
);

Does this work on BE systems?

> +	if (copy_to_user(uaddr, r, KVM_REG_SIZE(reg->id)) !=3D 0)

don't you risk reading beyond the boundaries of the array elements here
because KVM_REG_SIZE() is always 64 bits?

> +		return -EFAULT;
> +	return 0;
> +}
> +
> +static int debug_get64(struct kvm_vcpu *vcpu, const struct sys_reg_desc =
*rd,
> +	const struct kvm_one_reg *reg, void __user *uaddr)
> +{
> +	__u64 *r =3D (__u64 *) ((void * )&vcpu->arch.vcpu_debug_state + rd->reg=
);
> +	if (copy_to_user(uaddr, r, KVM_REG_SIZE(reg->id)) !=3D 0)
> +		return -EFAULT;
> +	return 0;
> +}
> +
>  int kvm_arm_sys_reg_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_=
reg *reg)
>  {
>  	const struct sys_reg_desc *r;
> @@ -1303,6 +1371,12 @@ int kvm_arm_sys_reg_get_reg(struct kvm_vcpu *vcpu,=
 const struct kvm_one_reg *reg
>  	if (!r)
>  		return get_invariant_sys_reg(reg->id, uaddr);
>  =

> +	if (r->access =3D=3D trap_debug64)
> +		return debug_get64(vcpu, r, reg, uaddr);
> +
> +	if (r->access =3D=3D trap_debug32)
> +		return debug_get32(vcpu, r, reg, uaddr);
> +
>  	return reg_to_user(uaddr, &vcpu_sys_reg(vcpu, r->reg), reg->id);
>  }
>  =

> @@ -1321,6 +1395,12 @@ int kvm_arm_sys_reg_set_reg(struct kvm_vcpu *vcpu,=
 const struct kvm_one_reg *reg
>  	if (!r)
>  		return set_invariant_sys_reg(reg->id, uaddr);
>  =

> +	if (r->access =3D=3D trap_debug64)
> +		return debug_set64(vcpu, r, reg, uaddr);
> +
> +	if (r->access =3D=3D trap_debug32)
> +		return debug_set32(vcpu, r, reg, uaddr);
> +
>  	return reg_from_user(&vcpu_sys_reg(vcpu, r->reg), uaddr, reg->id);
>  }
>  =

> -- =

> 2.4.1
> =

Thanks,
-Christoffer
