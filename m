Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6978C4A2A70;
	Thu,  3 Sep 2026 16:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788453479; cv=none; b=nDK46KeMz/CriP80osjhK5Vwt+wXrXBbzB9XT33m1kyDm9J0SFXt1F4D5c9o3nbwrL7IV/Nr1Y1hIHnsZ2dKeROxVn9I1eOKSCfnVMZBi6LLRnIKH8t/9kLS2PsFlOzTMHQB5JpJJXSUd8d1JM9Ib8Q/2qcEC923qswRZhUJeKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788453479; c=relaxed/simple;
	bh=fecX+pqvnuopmCSDzsq7IOiawsMBKS+PkA38prE3t2A=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=mATTui67zmiQkNnEMbBmxM7+zPPSbSZ523W7GUIc8F9t4tJhncV8b/7t83tyaiQCuKOM2cy4xSkUODkHEDedeyS1Dly7Gra45yFdBXya5W6FtBJh+p+N1v8QGQnkYUWePRUj7PCMRD54cd+j1hQjQlsNuCnvs+v/AIZi3S1gq60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hJKTvSNx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hJKTvSNx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22D8D1F000E9;
	Thu,  3 Sep 2026 16:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788453478;
	bh=AMU3P0LvJmUZF+USC/jZEdYHKeRHDJWghxKBdvWkGjc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hJKTvSNx/XBy92Vt9nH2j3I38bktYOqhKaNJmAS5Jfp8qTNt6o2wn5wPou4goht/L
	 RAiMYMTc6OTrayCsM2kLG0RjrG2ngeCzNOReK8WHF51tQHnbt/MSKxKDUgxXdWG3FA
	 qV2k1CNFPP3eAvv+r8+NSJFWavucnrhsrCE5+Kmbywx7qjJdCHTh89c2JLllEpiAM6
	 SJdnk/0X5i2LKgzGefkSBdf1+y/QhkGjQRMrZ8wXxNN7CgFCdrZn//3stQkAVytfBM
	 axjktFDbc7X1YWeOR4gs/av0m+1mafty3iTDfTYY9ZBfkC+XPc0PYEuTpgaM58jHml
	 6YcGJrYR3sNEw==
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v7 17/28] KVM: arm64: Apply a RES0 mask to
 PMBLIMITR_EL1 writes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alexandru Elisei" <alexandru.elisei@arm.com>
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org
In-Reply-To: <20260903160623.315525-18-alexandru.elisei@arm.com>
References: <20260903160623.315525-1-alexandru.elisei@arm.com>
 <20260903160623.315525-18-alexandru.elisei@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 16:37:57 +0000
Message-Id: <20260903163758.22D8D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [Critical] get_user_spe_sysreg() and set_user_spe_sysreg() return -EBUSY =
before SPE initialization, violating the KVM_GET_REG_LIST contract.
- [High] Userspace can bypass the PMBLIMITR_EL1 RES0 mask by writing to the=
 register before the first KVM_RUN.
- [Low] Missing READ_ONCE() when accessing pmblimitr_el1_res0_mask causes a=
 data race.
--

commit 1270412c2611a30b1f16a0aa9858eb290c7f9768
Author: Alexandru Elisei <alexandru.elisei@arm.com>

KVM: arm64: Apply a RES0 mask to PMBLIMITR_EL1 writes

This commit introduces a RES0 mask for PMBLIMITR_EL1 to hide unsupported
granule sizes from the guest. It computes this mask during the vCPU's
first run and applies it when userspace or the guest writes to the register.

> diff --git a/arch/arm64/kvm/spe.c b/arch/arm64/kvm/spe.c
> index 6a00a44c73edf..8c173a1f48bd4 100644
> --- a/arch/arm64/kvm/spe.c
> +++ b/arch/arm64/kvm/spe.c
[ ... ]
> @@ -60,13 +60,43 @@ bool kvm_supports_spe(void)
[ ... ]
>  int kvm_spe_vcpu_first_run_init(struct kvm_vcpu *vcpu)
>  {
> +	struct kvm *kvm =3D vcpu->kvm;
> +	struct kvm_spe *kvm_spe =3D &kvm->arch.kvm_spe;
> =20
> -	if (!vcpu_spe->initialized)
> +	if (!kvm_vcpu_spe_initialized(vcpu))
>  		return -EINVAL;
> =20
> +	if (!kvm_spe->pmblimitr_el1_res0_mask)

[Severity: Low]
Does this plain read of pmblimitr_el1_res0_mask need a READ_ONCE() to
prevent compiler-induced load tearing?

The mask is updated locklessly using WRITE_ONCE() inside
kvm_spe_compute_pmblimitr_el1_res0_mask(). Without a READ_ONCE() here,
concurrent vCPU executions could trigger a data race.

> +		kvm_spe_compute_pmblimitr_el1_res0_mask(kvm);
> =20
>  	return 0;
>  }
> @@ -85,8 +115,12 @@ void kvm_spe_destroy_vm(struct kvm *kvm)
> =20
>  bool kvm_spe_write_sysreg(struct kvm_vcpu *vcpu, int reg, u64 val)
>  {
> +	struct kvm_spe *kvm_spe =3D &vcpu->kvm->arch.kvm_spe;
> +
>  	switch (reg) {
>  	case PMBLIMITR_EL1:
> +		val &=3D ~kvm_spe->pmblimitr_el1_res0_mask;

[Severity: High]
Can userspace bypass this RES0 sanitization?

If the VMM calls KVM_SET_ONE_REG for PMBLIMITR_EL1 before running the vCPU
for the first time, pmblimitr_el1_res0_mask will still be 0.

Because the mask isn't computed until the first run, the bitwise NOT evalua=
tes
to all 1s (val &=3D ~0), which leaves the user-provided value unmodified and
potentially exposes the host hardware to unsupported granule configurations.

[Severity: Low]
Does this mask read also need a READ_ONCE() to safely pair with the
WRITE_ONCE() update, similar to the check in kvm_spe_vcpu_first_run_init()?

> +		fallthrough;
>  	case PMBSR_EL1:
>  	case PMBPTR_EL1:
>  		__vcpu_assign_sys_reg(vcpu, reg, val);

> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 89b01b6ac7830..4c4bf88c9aa53 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
[ ... ]
> @@ -1563,6 +1563,38 @@ static unsigned int spe_visibility(const struct kv=
m_vcpu *vcpu,
>  	return REG_HIDDEN;
>  }
> =20
> +static int set_user_spe_sysreg(struct kvm_vcpu *vcpu, const struct sys_r=
eg_desc *r,
> +			       u64 val)
> +{
> +	int reg =3D r->reg;
> +
> +	if (!kvm_vcpu_spe_initialized(vcpu))
> +		return -EBUSY;

[Severity: Critical]
Does returning -EBUSY here break the KVM_GET_REG_LIST ABI contract?

spe_visibility() currently exposes SPE registers based purely on
vcpu_has_spe(). Because of this, KVM_GET_REG_LIST will advertise the SPE
registers immediately after a vCPU is created with the SPE feature.

If a VMM queries the register list and then calls KVM_GET_ONE_REG or
KVM_SET_ONE_REG before KVM_ARM_VCPU_SPE_INIT is called, it will unexpectedly
hit this -EBUSY path and fail. The KVM API requires that any register
returned by KVM_GET_REG_LIST must be successfully readable via
KVM_GET_ONE_REG.

> +
> +	if (reg =3D=3D PMBLIMITR_EL1 || reg =3D=3D PMBPTR_EL1 || reg =3D=3D PMB=
SR_EL1)
> +		kvm_spe_write_sysreg(vcpu, reg, val);
> +	else
> +		__vcpu_assign_sys_reg(vcpu, reg, val);
> +
> +	return 0;
> +}
> +
> +static int get_user_spe_sysreg(struct kvm_vcpu *vcpu, const struct sys_r=
eg_desc *r,
> +			       u64 *val)
> +{
> +	int reg =3D r->reg;
> +
> +	if (!kvm_vcpu_spe_initialized(vcpu))
> +		return -EBUSY;
> +
> +	if (reg =3D=3D PMBLIMITR_EL1 || reg =3D=3D PMBPTR_EL1 || reg =3D=3D PMB=
SR_EL1)
> +		*val =3D kvm_spe_read_sysreg(vcpu, reg);
> +	else
> +		*val =3D __vcpu_sys_reg(vcpu, reg);
> +
> +	return 0;
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260903160623.3155=
25-1-alexandru.elisei@arm.com?part=3D17
