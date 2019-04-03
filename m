From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v7 12/27] KVM: arm64/sve: System register context switch
 and access support
Date: Wed, 3 Apr 2019 21:39:43 +0200
Message-ID: <20190403193943.nv7s36yf2nkzvzwo@kamzik.brq.redhat.com>
References: <1553864452-15080-1-git-send-email-Dave.Martin@arm.com>
 <1553864452-15080-13-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BABB64A42B
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Apr 2019 15:39:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dMCpWVmQMGDo for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 Apr 2019 15:39:49 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 398464A3B4
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Apr 2019 15:39:49 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <1553864452-15080-13-git-send-email-Dave.Martin@arm.com>
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
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>, Julien Grall <julien.grall@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Mar 29, 2019 at 01:00:37PM +0000, Dave Martin wrote:
> This patch adds the necessary support for context switching ZCR_EL1
> for each vcpu.
> 
> ZCR_EL1 is trapped alongside the FPSIMD/SVE registers, so it makes
> sense for it to be handled as part of the guest FPSIMD/SVE context
> for context switch purposes instead of handling it as a general
> system register.  This means that it can be switched in lazily at
> the appropriate time.  No effort is made to track host context for
> this register, since SVE requires VHE: thus the hosts's value for
> this register lives permanently in ZCR_EL2 and does not alias the
> guest's value at any time.
> 
> The Hyp switch and fpsimd context handling code is extended
> appropriately.
> 
> Accessors are added in sys_regs.c to expose the SVE system
> registers and ID register fields.  Because these need to be
> conditionally visible based on the guest configuration, they are
> implemented separately for now rather than by use of the generic
> system register helpers.  This may be abstracted better later on
> when/if there are more features requiring this model.
> 
> ID_AA64ZFR0_EL1 is RO-RAZ for MRS/MSR when SVE is disabled for the
> guest, but for compatibility with non-SVE aware KVM implementations
> the register should not be enumerated at all for KVM_GET_REG_LIST
> in this case.  For consistency we also reject ioctl access to the
> register.  This ensures that a non-SVE-enabled guest looks the same
> to userspace, irrespective of whether the kernel KVM implementation
> supports SVE.
> 
> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> Reviewed-by: Julien Thierry <julien.thierry@arm.com>
> Tested-by: zhang.lei <zhang.lei@jp.fujitsu.com>
> 
> ---
> 
> Changes since v5:
> 
>  * Port to the renamed visibility() framework.
> 
>  * Swap visiblity() helpers so that they appear by the relevant accessor
>    functions.
> 
>  * [Julien Grall] With the visibility() checks, {get,set}_zcr_el1()
>    degenerate to doing exactly what the common code does, so drop them.
> 
>    The ID_AA64ZFR0_EL1 handlers are still needed to provide contitional
>    RAZ behaviour.  This could be moved to the common code too, but since
>    this is a one-off case I don't do this for now.  We can address this
>    later if other regs need to follow the same pattern.
> 
>  * [Julien Thierry] Reset ZCR_EL1 to a fixed value using reset_val
>    instead of using relying on reset_unknown() honouring set bits in val
>    as RES0.
> 
>    Most of the bits in ZCR_EL1 are RES0 anyway, and many implementations
>    of SVE will support larger vectors than 128 bits, so 0 seems as good
>    a value as any to expose guests that forget to initialise this
>    register properly.
> ---
>  arch/arm64/include/asm/kvm_host.h |  1 +
>  arch/arm64/include/asm/sysreg.h   |  3 ++
>  arch/arm64/kvm/fpsimd.c           |  9 ++++-
>  arch/arm64/kvm/hyp/switch.c       |  3 ++
>  arch/arm64/kvm/sys_regs.c         | 83 ++++++++++++++++++++++++++++++++++++---
>  5 files changed, 93 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index ad4f7f0..22cf484 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -121,6 +121,7 @@ enum vcpu_sysreg {
>  	SCTLR_EL1,	/* System Control Register */
>  	ACTLR_EL1,	/* Auxiliary Control Register */
>  	CPACR_EL1,	/* Coprocessor Access Control */
> +	ZCR_EL1,	/* SVE Control */
>  	TTBR0_EL1,	/* Translation Table Base Register 0 */
>  	TTBR1_EL1,	/* Translation Table Base Register 1 */
>  	TCR_EL1,	/* Translation Control Register */
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index 5b267de..4d6262d 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -454,6 +454,9 @@
>  #define SYS_ICH_LR14_EL2		__SYS__LR8_EL2(6)
>  #define SYS_ICH_LR15_EL2		__SYS__LR8_EL2(7)
>  
> +/* VHE encodings for architectural EL0/1 system registers */
> +#define SYS_ZCR_EL12			sys_reg(3, 5, 1, 2, 0)
> +
>  /* Common SCTLR_ELx flags. */
>  #define SCTLR_ELx_DSSBS	(_BITUL(44))
>  #define SCTLR_ELx_ENIA	(_BITUL(31))
> diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
> index 1cf4f02..7053bf4 100644
> --- a/arch/arm64/kvm/fpsimd.c
> +++ b/arch/arm64/kvm/fpsimd.c
> @@ -103,14 +103,21 @@ void kvm_arch_vcpu_ctxsync_fp(struct kvm_vcpu *vcpu)
>  void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu)
>  {
>  	unsigned long flags;
> +	bool host_has_sve = system_supports_sve();
> +	bool guest_has_sve = vcpu_has_sve(vcpu);
>  
>  	local_irq_save(flags);
>  
>  	if (vcpu->arch.flags & KVM_ARM64_FP_ENABLED) {
> +		u64 *guest_zcr = &vcpu->arch.ctxt.sys_regs[ZCR_EL1];
> +
>  		/* Clean guest FP state to memory and invalidate cpu view */
>  		fpsimd_save();
>  		fpsimd_flush_cpu_state();
> -	} else if (system_supports_sve()) {
> +
> +		if (guest_has_sve)
> +			*guest_zcr = read_sysreg_s(SYS_ZCR_EL12);
> +	} else if (host_has_sve) {
>  		/*
>  		 * The FPSIMD/SVE state in the CPU has not been touched, and we
>  		 * have SVE (and VHE): CPACR_EL1 (alias CPTR_EL2) has been
> diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> index 3563fe6..9d46066 100644
> --- a/arch/arm64/kvm/hyp/switch.c
> +++ b/arch/arm64/kvm/hyp/switch.c
> @@ -351,6 +351,9 @@ static bool __hyp_text __hyp_switch_fpsimd(struct kvm_vcpu *vcpu)
>  
>  	__fpsimd_restore_state(&vcpu->arch.ctxt.gp_regs.fp_regs);
>  
> +	if (vcpu_has_sve(vcpu))
> +		write_sysreg_s(vcpu->arch.ctxt.sys_regs[ZCR_EL1], SYS_ZCR_EL12);
> +
>  	/* Skip restoring fpexc32 for AArch64 guests */
>  	if (!(read_sysreg(hcr_el2) & HCR_RW))
>  		write_sysreg(vcpu->arch.ctxt.sys_regs[FPEXC32_EL2],
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index c86a7b0..09e9b06 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1051,10 +1051,7 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
>  			 (u32)r->CRn, (u32)r->CRm, (u32)r->Op2);
>  	u64 val = raz ? 0 : read_sanitised_ftr_reg(id);
>  
> -	if (id == SYS_ID_AA64PFR0_EL1) {
> -		if (val & (0xfUL << ID_AA64PFR0_SVE_SHIFT))
> -			kvm_debug("SVE unsupported for guests, suppressing\n");
> -
> +	if (id == SYS_ID_AA64PFR0_EL1 && !vcpu_has_sve(vcpu)) {
>  		val &= ~(0xfUL << ID_AA64PFR0_SVE_SHIFT);
>  	} else if (id == SYS_ID_AA64ISAR1_EL1) {
>  		const u64 ptrauth_mask = (0xfUL << ID_AA64ISAR1_APA_SHIFT) |
> @@ -1101,6 +1098,81 @@ static int reg_from_user(u64 *val, const void __user *uaddr, u64 id);
>  static int reg_to_user(void __user *uaddr, const u64 *val, u64 id);
>  static u64 sys_reg_to_index(const struct sys_reg_desc *reg);
>  
> +/* Visibility overrides for SVE-specific control registers */
> +static unsigned int sve_visibility(const struct kvm_vcpu *vcpu,
> +				   const struct sys_reg_desc *rd)
> +{
> +	if (vcpu_has_sve(vcpu))
> +		return 0;
> +
> +	return REG_HIDDEN_USER | REG_HIDDEN_GUEST;
> +}
> +
> +/* Visibility overrides for SVE-specific ID registers */
> +static unsigned int sve_id_visibility(const struct kvm_vcpu *vcpu,
> +				      const struct sys_reg_desc *rd)
> +{
> +	if (vcpu_has_sve(vcpu))
> +		return 0;
> +
> +	return REG_HIDDEN_USER;
> +}
> +
> +/* Generate the emulated ID_AA64ZFR0_EL1 value exposed to the guest */
> +static u64 guest_id_aa64zfr0_el1(const struct kvm_vcpu *vcpu)
> +{
> +	if (!vcpu_has_sve(vcpu))
> +		return 0;
> +
> +	return read_sanitised_ftr_reg(SYS_ID_AA64ZFR0_EL1);
> +}
> +
> +static bool access_id_aa64zfr0_el1(struct kvm_vcpu *vcpu,
> +				   struct sys_reg_params *p,
> +				   const struct sys_reg_desc *rd)
> +{
> +	if (p->is_write)
> +		return write_to_read_only(vcpu, p, rd);
> +
> +	p->regval = guest_id_aa64zfr0_el1(vcpu);
> +	return true;
> +}
> +
> +static int get_id_aa64zfr0_el1(struct kvm_vcpu *vcpu,
> +		const struct sys_reg_desc *rd,
> +		const struct kvm_one_reg *reg, void __user *uaddr)
> +{
> +	u64 val;
> +
> +	if (!vcpu_has_sve(vcpu))
> +		return -ENOENT;

This shouldn't be necessary. The visibility check in
kvm_arm_sys_reg_get_reg already covers it.

> +
> +	val = guest_id_aa64zfr0_el1(vcpu);
> +	return reg_to_user(uaddr, &val, reg->id);
> +}
> +
> +static int set_id_aa64zfr0_el1(struct kvm_vcpu *vcpu,
> +		const struct sys_reg_desc *rd,
> +		const struct kvm_one_reg *reg, void __user *uaddr)
> +{
> +	const u64 id = sys_reg_to_index(rd);
> +	int err;
> +	u64 val;
> +
> +	if (!vcpu_has_sve(vcpu))
> +		return -ENOENT;

Also not necessary.

> +
> +	err = reg_from_user(&val, uaddr, id);
> +	if (err)
> +		return err;
> +
> +	/* This is what we mean by invariant: you can't change it. */
> +	if (val != guest_id_aa64zfr0_el1(vcpu))
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
>  /*
>   * cpufeature ID register user accessors
>   *
> @@ -1346,7 +1418,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  	ID_SANITISED(ID_AA64PFR1_EL1),
>  	ID_UNALLOCATED(4,2),
>  	ID_UNALLOCATED(4,3),
> -	ID_UNALLOCATED(4,4),
> +	{ SYS_DESC(SYS_ID_AA64ZFR0_EL1), access_id_aa64zfr0_el1, .get_user = get_id_aa64zfr0_el1, .set_user = set_id_aa64zfr0_el1, .visibility = sve_id_visibility },
>  	ID_UNALLOCATED(4,5),
>  	ID_UNALLOCATED(4,6),
>  	ID_UNALLOCATED(4,7),
> @@ -1383,6 +1455,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  
>  	{ SYS_DESC(SYS_SCTLR_EL1), access_vm_reg, reset_val, SCTLR_EL1, 0x00C50078 },
>  	{ SYS_DESC(SYS_CPACR_EL1), NULL, reset_val, CPACR_EL1, 0 },
> +	{ SYS_DESC(SYS_ZCR_EL1), NULL, reset_val, ZCR_EL1, 0, .visibility = sve_visibility },
>  	{ SYS_DESC(SYS_TTBR0_EL1), access_vm_reg, reset_unknown, TTBR0_EL1 },
>  	{ SYS_DESC(SYS_TTBR1_EL1), access_vm_reg, reset_unknown, TTBR1_EL1 },
>  	{ SYS_DESC(SYS_TCR_EL1), access_vm_reg, reset_val, TCR_EL1, 0 },

Mixing designated and non-designated initializers isn't particularly nice,
but I guess it's valid, and the simple alternatives are probably worse.

Thanks,
drew
