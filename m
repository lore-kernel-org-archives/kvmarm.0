Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B50BA3563E1
	for <kvmarm@lists.linux.dev>; Thu, 18 Jun 2026 12:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781785972; cv=none; b=S81v9k4RJGfhjmprY+9czeCH4XCZjRhRU4Bg8zs7aZr6nD754hXnPEU16zeMpCrpkq4spFTW1rtW+ve3RAvUvc+xjwUFXFc5YhooDq8yzTYeUcp3pfUsLrXdxZ+pv+DwO3vV7Ck7Vws5ta3bG0qZ4lXJStinbl1514UAlLH/hWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781785972; c=relaxed/simple;
	bh=bajdJkZtQRMepEjNWEnMafCUtu+rx2Bg9ttrDwCiYW0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=GHCbVp8E/Gqn8vY1bkZJkz/n3ExFNDmOg0DMPHRcsFA1OxOO/lK61mlHdAhoMSHVm6hituDfwzWgHPwrTloWgxb3OXK9QqfyHM6330kTD7qLJk6IGsCcQ1mNXNJf+boRsJ5BV7OX26ZW6Y1lT5R3vS+3iDUk8T2+hNYBZYyTJTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L5j+h7UD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L5j+h7UD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 260FC1F000E9;
	Thu, 18 Jun 2026 12:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781785971;
	bh=59ticRpySzM+J9evMnwDwkF+nFMvw2XgK3BWfw3+GW0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=L5j+h7UDecHflnTGqNGxaK/3zpnPzqYgjJh4BkFCao+XkzcRUF2c7/EH3hkkSmEBl
	 lrNAsEBY796nbXEgQxV+a+RirrhKDDZB9kSpAcAkFh0rx+Rzf8ZNY3k+CYAAKr5YiM
	 B4qJV0gjgw1XdY9PE/TtIV4pqJvVX61Z6IHvuWYBzsERylkWqkPtNN0InBf7Yw9cut
	 ID5YBkBfEEFh2xtL3pw5wnIl9RsZYL4Zv8PnewisxgRxzsO8a6PPHVq+y00Xy3v4zk
	 eWI4eMVJJhOr3Fugjoao7senGXilyo1FISdfbALnTxdkjNWYYIDQfHiNLvQU6N+wsa
	 NV2PwsubCezWw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 5/7] KVM: arm64: Set IL for emulated SError injection
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fuad Tabba" <tabba@google.com>
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260618121643.4105064-6-tabba@google.com>
References: <20260618121643.4105064-1-tabba@google.com>
 <20260618121643.4105064-6-tabba@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 18 Jun 2026 12:32:50 +0000
Message-Id: <20260618123251.260FC1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] kvm_inject_nested_sea() passes an Instruction/Data Abort EC instea=
d of an SError EC when FEAT_EASE converts a Synchronous External Abort into=
 an SError.
- [High] The constructed ESR for a nested SError is discarded during inject=
ion because kvm_inject_el2_exception() never writes it to the guest's ESR_E=
L2.
--

commit da891cfcd9b452feacd8b631f8c20dae39b009fc
Author: Fuad Tabba <tabba@google.com>

KVM: arm64: Set IL for emulated SError injection

kvm_inject_serror_esr() constructs an SError syndrome without IL. The
architecture mandates IL=3D1 for SError unconditionally.

> diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
> index 444d219b02174..d6c4fc16f8795 100644
> --- a/arch/arm64/kvm/inject_fault.c
> +++ b/arch/arm64/kvm/inject_fault.c
> @@ -381,7 +381,7 @@ int kvm_inject_serror_esr(struct kvm_vcpu *vcpu, u64 =
esr)
>  	 */
>  	if (!serror_is_masked(vcpu)) {
>  		pend_serror_exception(vcpu);
> -		esr |=3D FIELD_PREP(ESR_ELx_EC_MASK, ESR_ELx_EC_SERROR);
> +		esr |=3D FIELD_PREP(ESR_ELx_EC_MASK, ESR_ELx_EC_SERROR) | ESR_ELx_IL;
>  		vcpu_write_sys_reg(vcpu, esr, exception_esr_elx(vcpu));
>  		return 1;
>  	}

[Severity: High]
This isn't a bug introduced by this patch, but while reviewing this SError
injection logic, I noticed an issue in how ESR is constructed for nested
SErrors. When SCTLR2_ELx.EASE is set and a Synchronous External Abort is
converted to an SError, does kvm_inject_nested_sea() pass an incorrect
Exception Class?

In arch/arm64/kvm/emulate-nested.c:kvm_inject_nested_sea():

	if (__vcpu_sys_reg(vcpu, SCTLR2_EL2) & SCTLR2_EL1_EASE)
		return kvm_inject_nested(vcpu, esr, except_type_serror);

The esr variable retains the previously constructed IABT/DABT Exception
Class instead of being reconstructed with ESR_ELx_EC_SERROR. Does this
present an invalid syndrome to the nested guest hypervisor, since the
architecture mandates that ESR_ELx.EC must be 0x2F (SError) when an
External abort is treated as an SError?=20

Also, does this unconditionally update FAR_EL2, which is architecturally
incorrect for an SError?

[Severity: High]
This is also a pre-existing issue, but there appears to be a problem where
the constructed ESR for a nested SError is discarded during injection. Does
kvm_inject_el2_exception() fail to write the esr_el2 argument to ESR_EL2?

In arch/arm64/kvm/emulate-nested.c:kvm_inject_el2_exception():

	case except_type_serror:
		kvm_pend_exception(vcpu, EXCEPT_AA64_EL2_SERR);
		break;

Unlike the synchronous exception case, the esr_el2 argument isn't written
to the guest's ESR_EL2. Since the downstream exception entry path
enter_exception64() does not write ESR_ELx, does this result in the nested
guest hypervisor receiving an SError with a stale, unmodified ESR_EL2?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260618121643.4105=
064-1-tabba@google.com?part=3D5
