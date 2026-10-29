Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793294598;
	b=36KS+dA3RuVh2UdOtD0XzqDrCPVrY7P7GNjc/29fWAjobLZpYIem3FNbbfZ+i9/yVtbZ
	 4LmvIUaxatLZIRN53Y7w983bI7Uca/Ep88+rq3OVffUT23E6jzxxISWVsuDRRQ4Um+cW2
	 65Yy9g4zh6F+Cbo7EzIC9JTfHVwOj/yV7c4Hr1MNexRnzqKWgQvUdZoE1X6hHkC26OdTM
	 N1e+6ns5Adkqn8E9UCrXiFoTLKKC+hZHwuJMlwrLACoUFczVm2QVFts1QyasxEjXvQx6T
	 DLclPKy9d0uBNM8MbZisU18FgpJR9K2KtUvH/npvYXyzzHeYlnVmBuIYJ7BzjPh1gQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793294598;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=r30TIeUAui4tnRc46h6W8Ks73suv2dC7aDdGQZCwDmc=;
	b=nbYlpOIlRdgHViNS0avE+GwivGiUNFy3oYYp90L3R5CWJc371+acJSbFgafqm8CQxMf5
	 Tqw2e0cVJztuvlau/sv9ib9663M7rRc+PfTcpKQV9PUMeZhyotlKMi+WrPJAFLt1oDOKq
	 K9qwaNmf5ZIejC9NYHRNUtT1e/aBDwLWWM4MOpTKy8E0gTspwZUDJpYObo92DXZG4e7oa
	 J8/tGnuQWk46gn5AwobC2atjY0xgAdmtBVBjjvf4hD6PIgqzhcgrOcx4Oz02I6Zifk/CY
	 P7enAadAp5yBoVYEDZfKdef4Q4NOyxbxlpUlhglKWJy15OomdGxiNcNdHeA+VuXazrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Wb2T9Xal;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D085606A32A;
	Thu, 29 Oct 2026 17:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Wb2T9Xal
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AB371F01825;
	Thu, 29 Oct 2026 17:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793294597;
	bh=r30TIeUAui4tnRc46h6W8Ks73suv2dC7aDdGQZCwDmc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Wb2T9XalRuJqgvn79Fri18OfjNmi047MvRSD+Z5HF8lsc2CNsRfwCqb3EA6sYcR9n
	 xW1588bhbT73aQEKdSZ5D5+PovfGORB5RnBPi6KUH5dVSW3XrkpaUwoZePtDSM9gX6
	 KzJyrdYAR3h/77KGGWjYhJIOhakhM/warxezB4227wvu4v/i6gWfs4iU1j0QO1pqzn
	 33HEBDIEJdbXkC4afs62Z1ip7DDHkzkCqRHF+QSF2eR4g0kilwF0Rmvb3N1sDy3A9y
	 sIUJsKXp13VutcT1Qd9ChuFbhCK5NRmP9sGKmYBeh5Z/D6a+UXnwGBKd3n1B5nNFEx
	 EIu2/mLSmXjtA==
Date: Thu, 29 Oct 2026 17:23:11 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: maz@kernel.org, oupton@kernel.org, fuad.tabba@linux.dev, 
	joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	will@kernel.org, mark.rutland@arm.com, linux-perf-users@vger.kernel.org, 
	catalin.marinas@arm.com, james.clark@linaro.org
Subject: Re: [RFC PATCH v7 17/28] KVM: arm64: Apply a RES0 mask to
 PMBLIMITR_EL1 writes
Message-ID: <auNpx6vxFmREVbrE@gremlin>
References: <20260903160623.315525-1-alexandru.elisei@arm.com>
 <20260903160623.315525-18-alexandru.elisei@arm.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260903160623.315525-18-alexandru.elisei@arm.com>

On Thu, Sep 03, 2026 at 05:06:12PM +0100, Alexandru Elisei wrote:
> PMBLIMITR_EL1 is special, because it has feature enable fields. If those

OK, so this is one of the buffer regs that traps in KVM right?

Maybe worth explicitly calling that out, just so it's clear.

> features are hidden from a guest, ignore them when the guest or the VMM
> attempt to set them.
>
> The least significant bits of the buffer limit address are RES0 based on
> the smallest granule implemented. Make sure they are treated as zero even
> if the smallest granule exposed to the VM is larger than what the hardware
> implements.
>
> Note that it is up to the user to write to the SPE buffer registers only
> after the VM features have been configured in the VM id registers.
>
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>

Obviously sashiko had some feedback on this also, but a few things to
address here as below! :)

> ---
>  Documentation/virt/kvm/devices/vcpu.rst |  3 ++
>  arch/arm64/include/asm/kvm_spe.h        |  7 +++++
>  arch/arm64/kvm/spe.c                    | 40 +++++++++++++++++++++++--
>  arch/arm64/kvm/sys_regs.c               | 38 +++++++++++++++++++++--
>  4 files changed, 83 insertions(+), 5 deletions(-)
>
> diff --git a/Documentation/virt/kvm/devices/vcpu.rst b/Documentation/virt/kvm/devices/vcpu.rst
> index e2eac48b9d28..eb352760869c 100644
> --- a/Documentation/virt/kvm/devices/vcpu.rst
> +++ b/Documentation/virt/kvm/devices/vcpu.rst
> @@ -383,3 +383,6 @@ the in-kernel irqchip has been initialized.
>
>  KVM will refuse to run the VCPU and KVM_RUN will return an error if the SPE
>  feature has been set for the VCPU, but SPE hasn't been initialized.
> +
> +Attempting to access any of the SPE registers until SPE has been initialized on
> +the VCPU will fail with -EBUSY.
> diff --git a/arch/arm64/include/asm/kvm_spe.h b/arch/arm64/include/asm/kvm_spe.h
> index 56dc9e660bef..3d8e9720daca 100644
> --- a/arch/arm64/include/asm/kvm_spe.h
> +++ b/arch/arm64/include/asm/kvm_spe.h
> @@ -14,6 +14,7 @@ struct kvm_device_attr;
>  struct arm_spe_pmu;
>  struct kvm_spe {
>  	struct arm_spe_pmu *spe_pmu;
> +	u64 pmblimitr_el1_res0_mask;
>  };
>
>  struct kvm_vcpu_spe {
> @@ -26,6 +27,8 @@ bool kvm_supports_spe(void);
>  #define vcpu_has_spe(vcpu)					\
>  	(vcpu_has_feature(vcpu, KVM_ARM_VCPU_SPE))
>
> +bool kvm_vcpu_spe_initialized(struct kvm_vcpu *vcpu);
> +
>  int kvm_spe_vcpu_first_run_init(struct kvm_vcpu *vcpu);
>  void kvm_spe_destroy_vm(struct kvm *kvm);
>
> @@ -54,6 +57,10 @@ static __always_inline bool kvm_supports_spe(void)
>
>  #define vcpu_has_spe(vcpu)	false
>
> +static inline bool kvm_vcpu_spe_initialized(struct kvm_vcpu *vcpu)
> +{
> +	return false;
> +}
>  static inline int kvm_spe_vcpu_first_run_init(struct kvm_vcpu *vcpu)
>  {
>  	return 0;
> diff --git a/arch/arm64/kvm/spe.c b/arch/arm64/kvm/spe.c
> index 6a00a44c73ed..8c173a1f48bd 100644
> --- a/arch/arm64/kvm/spe.c
> +++ b/arch/arm64/kvm/spe.c
> @@ -60,13 +60,43 @@ bool kvm_supports_spe(void)
>  	return !list_empty(&spe_pmus);
>  }
>
> -int kvm_spe_vcpu_first_run_init(struct kvm_vcpu *vcpu)
> +bool kvm_vcpu_spe_initialized(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_vcpu_spe *vcpu_spe = &vcpu->arch.vcpu_spe;
>
> -	if (!vcpu_spe->initialized)
> +	return vcpu_spe->initialized;
> +}
> +
> +static void kvm_spe_compute_pmblimitr_el1_res0_mask(struct kvm *kvm)
> +{
> +	u64 res0_mask = GENMASK_ULL(11, 8) | BIT(6) | GENMASK_ULL(4, 3);

Maybe worth a comment saying what you're res0-ing here by default?

> +
> +	if (!kvm_has_feat(kvm, ID_AA64DFR2_EL1, SPE_nVM, IMP))
> +		res0_mask |= PMBLIMITR_EL1_nVM_MASK;

Getting the LLM to dig in a bit on this says:

#define SYS_ID_AA64DFR2_EL1                             sys_reg(3, 0, 0, 5, 2)

Matches:

	ID_FILTERED(ID_AA64DFR0_EL1, id_aa64dfr0_el1, ...)
	ID_SANITISED(ID_AA64DFR1_EL1),
	ID_UNALLOCATED(5,2), <--- here

In sys_regs.c, i.e. not wired up and:

	if (!kvm_has_feat(kvm, ID_AA64DFR2_EL1, SPE_nVM, IMP))

Is always true.

So can this just be something like:

	/*
	 * ID_AA64DFR2_EL1 is not exposed to guests, so FEAT_SPE_nVM is never
	 * enabled.
	 */
	res0_mask |= PMBLIMITR_EL1_nVM_MASK;

Perhaps?

> +
> +	if (!kvm_has_feat_enum(kvm, ID_AA64MMFR0_EL1, TGRAN4, NI))

I was very confused by this btw, but it turns out that TGRAN4 = NOT
supports TGRAN4. But then the 'NI' == not implemented... :)) So ! here
means not not, i.e. does, so nothing to do.

Why the _enum() btw?

Could this just be:

	kvm_has_feat(kvm, ID_AA64MMFR0_EL1, TGRAN4, IMP)

?

> +		goto set_mask;

While it involves more nesting, I think it'd be clearer to just do
something like:

	/* If 4 KB unsupported, extend res0 to 16 KiB or 64 KiB granule size. */
	if (!kvm_has_feat(kvm, ID_AA64MMFR0_EL1, TGRAN4, IMP)) {
		if (kvm_has_feat(kvm, ID_AA64MMFR0_EL1, TGRAN16, IMP))
			res0_mask |= GENMASK_ULL(13, 12);
		else
			res0_mask |= GENMASK_ULL(15, 12);
	}

Are these magic numbers really necessary in general btw? Can you not use
defined values? That would eliminate the need for too many comments too
actually.

If I go off pattern matching I see (the very long line :P):

#define PMBLIMITR_EL1_RES0                              (UL(0) | GENMASK_ULL(11, 8) | GENMASK_ULL(6, 6) | GENMASK_ULL(4, 3))

So:

	u64 res0_mask = GENMASK_ULL(11, 8) | BIT(6) | GENMASK_ULL(4, 3);

Could be:

	u64 res0_mask = PMBLIMITR_EL1_RES0;

And you could do similar things for the rest I think?

Like:

	/* If 4 KB unsupported, extend res0 to 16 KiB or 64 KiB granule size. */
	if (!kvm_has_feat(kvm, ID_AA64MMFR0_EL1, TGRAN4, IMP)) {
		if (kvm_has_feat(kvm, ID_AA64MMFR0_EL1, TGRAN16, IMP))
			res0_mask |= PMBLIMITR_EL1_LIMIT & (SZ_16K - 1);
		else
			res0_mask |= PMBLIMITR_EL1_LIMIT & (SZ_64K - 1);
	}

> +
> +	if (kvm_has_feat(kvm, ID_AA64MMFR0_EL1, TGRAN16, IMP))
> +		res0_mask |= GENMASK_ULL(13, 12);
> +	else
> +		res0_mask |= GENMASK_ULL(15, 12);
> +
> +set_mask:
> +	WRITE_ONCE(kvm->arch.kvm_spe.pmblimitr_el1_res0_mask, res0_mask);

RE: The sashiko thing about WRITE_ONCE()/READ_ONCE() pairing (valid I
think), could you just compute this in kvm_vm_finalize_sys_regs() on first
run, rather than in kvm_spe_vcpu_first_run_init() below?

Then that, under the config lock, will be a single writer with no vCPUs
racing?

> +}
> +
> +int kvm_spe_vcpu_first_run_init(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm *kvm = vcpu->kvm;
> +	struct kvm_spe *kvm_spe = &kvm->arch.kvm_spe;
> +
> +	if (!kvm_vcpu_spe_initialized(vcpu))
>  		return -EINVAL;
>
> +	if (!kvm_spe->pmblimitr_el1_res0_mask)
> +		kvm_spe_compute_pmblimitr_el1_res0_mask(kvm);
> +
>  	return 0;
>  }
>
> @@ -85,8 +115,12 @@ void kvm_spe_destroy_vm(struct kvm *kvm)
>
>  bool kvm_spe_write_sysreg(struct kvm_vcpu *vcpu, int reg, u64 val)
>  {
> +	struct kvm_spe *kvm_spe = &vcpu->kvm->arch.kvm_spe;
> +
>  	switch (reg) {
>  	case PMBLIMITR_EL1:
> +		val &= ~kvm_spe->pmblimitr_el1_res0_mask;

The bot raised this potentially allowing raw writes I think, as the mask is
only actually set up on first run, so it does seem sensible then I think to
recalculate the value of PMBLIMITR_EL1 at first run time.

(Also obviously sashiko noted the need for a READ_ONCE() of the mask here
also!)

> +		fallthrough;
>  	case PMBSR_EL1:
>  	case PMBPTR_EL1:
>  		__vcpu_assign_sys_reg(vcpu, reg, val);
> @@ -217,7 +251,7 @@ int kvm_spe_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
>  	if (!vcpu_has_spe(vcpu))
>  		return -ENODEV;
>
> -	if (vcpu_spe->initialized)
> +	if (kvm_vcpu_spe_initialized(vcpu))
>  		return -EBUSY;
>
>  	switch (attr->attr) {
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 89b01b6ac783..4c4bf88c9aa5 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1563,6 +1563,38 @@ static unsigned int spe_visibility(const struct kvm_vcpu *vcpu,
>  	return REG_HIDDEN;
>  }
>
> +static int set_user_spe_sysreg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
> +			       u64 val)
> +{
> +	int reg = r->reg;
> +
> +	if (!kvm_vcpu_spe_initialized(vcpu))
> +		return -EBUSY;

I know the bot raised this -EBUSY return. Digging into it, it seems it's 4.84
from Documentation/virt/kvm/api.rst, i.e. the KVM_GET_REG_LIST docs:

	This ioctl returns the guest registers that are supported for the
	KVM_GET_ONE_REG/KVM_SET_ONE_REG calls.

You said to sashiko that you update the interrupt level here via a
PMBSR_EL1 write in a later patch, but I think that's questionable in
general.

The semantics seem clear that this should be a plain write, and if it's
sometimes not correct to take a further action (i.e. initialisation has not
completed yet), that implies it should live somewhere else.

So I'd update things to keep this as a plain read/write, and do whatever
else you need to do at the right time, e.g. at first run?

Given that I think the right thing to do here is to remove the checks, I
_think_ everything should still work fine right?

> +
> +	if (reg == PMBLIMITR_EL1 || reg == PMBPTR_EL1 || reg == PMBSR_EL1)
> +		kvm_spe_write_sysreg(vcpu, reg, val);
> +	else
> +		__vcpu_assign_sys_reg(vcpu, reg, val);
> +
> +	return 0;
> +}
> +
> +static int get_user_spe_sysreg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
> +			       u64 *val)
> +{
> +	int reg = r->reg;
> +
> +	if (!kvm_vcpu_spe_initialized(vcpu))
> +		return -EBUSY;

Similar comments here to the above obviously.

> +
> +	if (reg == PMBLIMITR_EL1 || reg == PMBPTR_EL1 || reg == PMBSR_EL1)

Hmm some duplication here, and you do also elsewhere adjust behaviour based
on buffer registers or not, so could this be separated out into a
predicate?

> +		*val = kvm_spe_read_sysreg(vcpu, reg);
> +	else
> +		*val = __vcpu_sys_reg(vcpu, reg);
> +
> +	return 0;
> +}
> +
>  static bool access_spe_reg(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>  			   const struct sys_reg_desc *r)
>  {
> @@ -1610,11 +1642,13 @@ static bool access_spe_reg(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>
>  #define SPE_SYS_REG(name)						\
>  	SYS_DESC(SYS_##name), .reg = name, .access = access_spe_reg,	\
> -	.reset = reset_val, .val = 0, .visibility = spe_visibility
> +	.reset = reset_val, .val = 0, .visibility = spe_visibility,	\
> +	.set_user = set_user_spe_sysreg, .get_user = get_user_spe_sysreg
>
>  #define SPE_UNTRAPPED_REG(name)						\
>  	SYS_DESC(SYS_##name), .reg = name, .access = undef_access,	\
> -	.reset = reset_val, .val = 0, .visibility = spe_visibility
> +	.reset = reset_val, .val = 0, .visibility = spe_visibility,	\
> +	.set_user = set_user_spe_sysreg, .get_user = get_user_spe_sysreg

Similar comment about the duplication of these as per previous patch review :)

>
>  /* Macro to expand the AMU counter and type registers*/
>  #define AMU_AMEVCNTR0_EL0(n) { SYS_DESC(SYS_AMEVCNTR0_EL0(n)), undef_access }
> --
> 2.43.0
>
>

--
Cheers, Lorenzo
