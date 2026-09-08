Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D852D534441;
	Tue,  8 Sep 2026 16:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788886631; cv=none; b=jvv8u4/Yz4G5tdjspwkM4kGFpExS/8smYckRQ9UJo2QPvaT/4hy34KRJfYjuXFyiD5lp7gKwVGu+TSmvGlLoZAZnEcSPunAbGv+E7NxALZtJWKaeqQZ16ZYLq1n34w4MfLNIk+1/1WUAIwvBMEd7Csh1zXZvjumohNZuCBugujw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788886631; c=relaxed/simple;
	bh=BQ72hC7FvvdiPt6lZyLBuLAHWTl9blRiPTF8/SSIp0U=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=nSsgzI+ClzMR81vw5nU9GucjZT7ajhGfvPf8gS9AxaTXmUjLatcWrg4M31lhsGx2ukXJX7fpUOC2FFDJMri0l0KyXJUlUAD6jIuPikBC3A6+h2Pqujpk4atLrzE9PZFltnytzjG7eMLoSj1ojfSxfLLGIA2Nux98/wy6EeEPZ3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xxc2TEnn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xxc2TEnn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2799B1F00A3D;
	Tue,  8 Sep 2026 16:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788886629;
	bh=eTo0a5rr1uNawzqYrn7FaCEIUiM51g4mT38NjcCOk/M=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Xxc2TEnnKlBx1BmcqUNV8fKuyxVLOpO0hZUS7/iLaxT4ibl3svLxzSF1UtQJtwBNF
	 1GBLfQXWLlJvtwU50aP4xvQrAbGLXyqlU3ZQhglP/u3tYCkADknEE9BhbVK2xEFCg7
	 fHnq28oy2Gt5SKifuzyzDFYpxpepJfdYSJUIlP3CfCAWt3feXCDpCnmSV0127JamB0
	 4z2FsfRRrr71i2XCuFf913wysdWl6u6BZxsv/sTTq/wOfnBG+iIBtYTui+51ka+YUc
	 0+Ay+M1ZwSntOfMEpe/z2bh7vV5U5k+j1JurGkNn2IbM4baF3Jyz5dVQYDL7/uFggS
	 /xpsTSnwXSmuw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v17 16/20] KVM: arm64: CCA: Provide register list for
 unfinalized RECs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Suzuki K Poulose" <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, "Marc Zyngier" <maz@kernel.org>, "Oliver
 Upton" <oupton@kernel.org>
In-Reply-To: <20260908162223.1683432-17-suzuki.poulose@arm.com>
References: <20260908162223.1683432-1-suzuki.poulose@arm.com>
 <20260908162223.1683432-17-suzuki.poulose@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 08 Sep 2026 16:57:08 +0000
Message-Id: <20260908165709.2799B1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] Mismatch between KVM_GET_REG_LIST implementation for RECs and it=
s commit message / comment.
--

commit ce52f6b2727531d94e14139ee2966392538b6218
Author: Jean-Philippe Brucker <jpb@kernel.org>

KVM: arm64: CCA: Provide register list for unfinalized RECs

This commit modifies the KVM_GET_REG_LIST ioctl handler to allow fetching
the register list for Realm Execution Contexts (RECs) before the VCPUs are
fully finalized, provided SVE is finalized. It adjusts the size probing and
array copying logic to prevent -EPERM errors during late REC finalization.

> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
[ ... ]
> @@ -1980,6 +1980,18 @@ static int kvm_arm_vcpu_set_events(struct kvm_vcpu=
 *vcpu,
>  	return __kvm_arm_vcpu_set_events(vcpu, events);
>  }
> =20
> +/*
> + * Realm VCPUs can be finalized after the Realm descriptor is created.
> + * Allow the register list for RECs before the VCPUs are finalized, but
> + * after the SVE is finalized.
> + */
> +static bool kvm_arm_vcpu_reg_list_allowed(struct kvm_vcpu *vcpu)
> +{
> +	if (kvm_arm_vcpu_is_finalized(vcpu))
> +		return true;
> +	return vcpu_is_rec(vcpu);
> +}

[Severity: Medium]
Does this logic in kvm_arm_vcpu_reg_list_allowed() unconditionally allow
RECs, bypassing the SVE finalization check? The comment explicitly states
"but after the SVE is finalized," yet if the VCPU is a REC, this path
returns true regardless of the SVE finalization status.

> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> --- a/arch/arm64/kvm/guest.c
> +++ b/arch/arm64/kvm/guest.c
[ ... ]
> @@ -616,9 +616,6 @@ static int copy_sve_reg_indices(const struct kvm_vcpu=
 *vcpu,
>  	if (!vcpu_has_sve(vcpu))
>  		return 0;
> =20
> -	/* Policed by KVM_GET_REG_LIST: */
> -	WARN_ON(!kvm_arm_vcpu_sve_finalized(vcpu));
> -
>  	/*
>  	 * Enumerate this first, so that userspace can save/restore in
>  	 * the order reported by KVM_GET_REG_LIST:
> @@ -628,6 +625,9 @@ static int copy_sve_reg_indices(const struct kvm_vcpu=
 *vcpu,
>  		return -EFAULT;
>  	++num_regs;
> =20
> +	if (!kvm_arm_vcpu_sve_finalized(vcpu))
> +		return num_regs;
> +

[Severity: Medium]
Does this return a positive success code (num_regs) rather than an error?

The commit message states that "a KVM_GET_REG_LIST call that only probes
for the array size will now succeed even if SVE is not finalized, but that
seems harmless since the following KVM_GET_REG_LIST with the full array
will fail."=20

Returning a positive number of registers here in copy_sve_reg_indices()
causes the full array fetch to succeed silently instead of failing as the
commit message claims.

>  	for (i =3D 0; i < slices; i++) {
>  		for (n =3D 0; n < SVE_NUM_ZREGS; n++) {
>  			reg =3D KVM_REG_ARM64_SVE_ZREG(n, i);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908162223.1683=
432-1-suzuki.poulose@arm.com?part=3D16
