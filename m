Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FD2425B0B9
	for <kvmarm@lists.linux.dev>; Fri, 31 Jul 2026 21:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785531776; cv=none; b=cKww3YZXrNok5BtwHPKbNR/VFu16FFlpr2C1L01e6kLHPFHlheaAFDdvxu9QfOqTrbi3q4B9vgwUnH6zQRIZr7cAQBnell9jDqrf0Qx4LOd3SFD0kTXma5x7Y3ypK1iUIqvEqdlJYALzWcBeNgR/5lNGy4tjhofZTkhSphoAw68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785531776; c=relaxed/simple;
	bh=QkeKMWfRvGQGIRkec28GzdU37YXCWD/4HYR+F/vO8ds=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Z+GcNiVu/fIx2/8X7PAtu5e0yJnLojKm5GXIiFCOQOy1PVRhGR2mdvJM8mMPIXWWEumyu5JleOY19RUIwvCPoMfyq+f1xPZcJQfMU7+lHyW+xSS+JOteEf8rcCOO7JS9is9c5JapgDX2y3HwP2Md2W4/MrmOz+TyVxoc44yrTCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jzCY+DC3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jzCY+DC3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF3961F00AC4;
	Fri, 31 Jul 2026 21:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785531774;
	bh=5W4CxjnwADJ2YRpo9OhXP3u56MxvSylWeGDqCDKpObc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jzCY+DC3eaR4zZbepqy/I6aDCPzJhII4tSrEhzjMsial9yO2WB9pZ9IUlDubBK37s
	 sP5BZTtaAyWsyuqvdrtmbIqfB91ZfQx4dAjlVTP9ZgLNOgQjssbeGBHwkOW4evhngG
	 fMJgelaZEPMaDQa/GhoSMOXKlq6yO0mLEYe/n2Jw84tro9r9DpARp8wt7Numxckymt
	 tONt01QIcmKgC0a4DjpidnPnfjwJjRsIOXcrHS28w3CZNstzIKveumFJjGqdNZeu4a
	 Zyo49/wwfe7xULecNOOddT/2aTBkWqXUXN0Nx9peckdwFXJuBmD+C77NCKTs3sh/6V
	 iIE+NqDTBAz+Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/2] KVM: arm64: Finalize guest-wide sysregs prior to
 per-vCPU sysregs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mark Brown" <broonie@kernel.org>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260731-kvm-arm64-idreg-final-v1-1-3de2a5616dc6@kernel.org>
References: <20260731-kvm-arm64-idreg-final-v1-0-3de2a5616dc6@kernel.org>
 <20260731-kvm-arm64-idreg-final-v1-1-3de2a5616dc6@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 31 Jul 2026 21:02:54 +0000
Message-Id: <20260731210254.AF3961F00AC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Numeric range iteration over sparse `enum vcpu_sysreg` values.
- [High] TOCTOU race allows userspace to modify VM ID registers after initi=
alization has begun, causing inconsistent KVM state.
--

--- Patch [1]: [PATCH 1/2] KVM: arm64: Finalize guest-wide sysregs prior to=
 per-vCPU sysregs ---
commit 2366ff54838e2cdbf8037630978a72215c68a9b6
Author: Mark Brown <broonie@kernel.org>

KVM: arm64: Finalize guest-wide sysregs prior to per-vCPU sysregs
   =20
In commit d82d09d5ba4b ("KVM: arm64: Don't skip per-vcpu NV
initialisation") the NV register sanitisation was moved earlier in
kvm_finalize_sys_regs() so that it runs for each vCPU rather than only
once per guest. This means that for the first vCPU it runs prior to vGIC
finalization, but the vGIC finalization updates the ID registers which
the NV initialization uses so we may end up with a mismatch. For
example, HFGRTR_EL2.ICC_IGRPENn_EL1 depends on GICv3 being enabled in
ID_AA64PFR0_EL1.GIC so may be mistakenly marked or not marked as RES0.

Split the initialization which runs once per guest into a separate
function and run that before the per-vCPU initialisation for NV,
renaming the per-vCPU function to make it clear that it does per-vCPU
setup.

Fixes: d82d09d5ba4b ("KVM: arm64: Don't skip per-vcpu NV initialisation")

> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 50adfff75be82..2b75e1d5ca8db 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -931,7 +931,7 @@ int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcp=
u)
>  			return ret;
>  	}
> =20
> -	ret =3D kvm_finalize_sys_regs(vcpu);
> +	ret =3D kvm_vcpu_finalize_sys_regs(vcpu);
>  	if (ret)
>  		return ret;

[Severity: High]
This is a pre-existing issue, but does dropping the config_lock here leave a
window where userspace can still modify VM ID registers?

Since kvm_vcpu_finalize_sys_regs() takes and then drops
kvm->arch.config_lock, and KVM_ARCH_FLAG_HAS_RAN_ONCE is not set until
much later in kvm_arch_vcpu_run_pid_change(), a concurrent secondary
vCPU thread could invoke KVM_SET_ONE_REG to modify an ID register.

The ioctl handler set_id_reg() in sys_regs.c permits the write because
kvm_vm_has_ran_once(kvm) is still false:

	if (kvm_vm_has_ran_once(vcpu->kvm)) {
		if (val !=3D read_id_reg(vcpu, rd))
			ret =3D -EBUSY;

Could this lead to inconsistent internal feature configuration between
sysreg_masks set in kvm_init_nv_sysregs and traps computed in
kvm_calculate_traps?

[ ... ]
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 5d5c579d45790..958d7ef78785f 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
[ ... ]
> @@ -5825,6 +5814,29 @@ int kvm_finalize_sys_regs(struct kvm_vcpu *vcpu)
> +/*
> + * Because this can be called once per CPU, changes must be idempotent.
> + */
> +int kvm_vcpu_finalize_sys_regs(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm *kvm =3D vcpu->kvm;
> +	int ret;
> +
> +	guard(mutex)(&kvm->arch.config_lock);
> +
> +	ret =3D kvm_vm_finalize_sys_regs(kvm);
> +	if (ret)
> +		return ret;
> +
> +	if (vcpu_has_nv(vcpu)) {
> +		ret =3D kvm_init_nv_sysregs(vcpu);

[Severity: High]
This isn't a bug introduced by this patch, but does the function called here
iterate over the sparse enum vcpu_sysreg using a numeric range?

Looking at kvm_init_nv_sysregs() in arch/arm64/kvm/nested.c:

	for (enum vcpu_sysreg sr =3D __SANITISED_REG_START__; sr < NR_SYS_REGS; sr=
++)
		__vcpu_rmw_sys_reg(vcpu, sr, |=3D, 0);

Iterating over a numeric range of enum vcpu_sysreg values traverses gaps
in the enumeration space, as VNCR-mapped entries are sparsely numbered by
their byte offsets. Does this unconditionally traverse sparse gaps and
silently touch unintended offsets, leading to state desynchronization?

> +		if (ret)
> +			return ret;
> +	}
> +
> +	return 0;
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260731-kvm-arm64-=
idreg-final-v1-0-3de2a5616dc6@kernel.org?part=3D1
