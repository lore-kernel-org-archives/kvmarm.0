Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B854A3F44F7
	for <kvmarm@lists.linux.dev>; Thu, 18 Jun 2026 12:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781785845; cv=none; b=ia22H8tk3LdXF7Bon0LYoJqjxedmgEXzm76FIXpLxFHOjGXtwcz4gEIEwByB7DkqqKezwbclQEkcJ6ANarxtbG9bx4n5X9E6OQJQwlAvB8txbtOd32+S7ytNt7v+b8HJxpAamLuX7o1s/1A1XnawzM24iyG8rv+VRgb1q/f+SeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781785845; c=relaxed/simple;
	bh=AGzzutgdr1QnTmfe0dbXD/mjoszdCTv+X+QRG9NJYWg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=cEOlU0sww5fdJPa0TGjpeqGGnGbI65G4pamDSAZILdY1ozo1bZhAyNM3BIn9L+OQD5/U+nRimiz8tvN8gN0fuAA9jzvceGxuYwxnJvEIX5vEqAF8yA4wHpQO3R4oZKhP8UBtlB1MlbbhSW0nMboe2p4TdFN7IOrL/Zn2Qnprs6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gpkEeARR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gpkEeARR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D1C21F000E9;
	Thu, 18 Jun 2026 12:30:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781785843;
	bh=5y6v8ZsYwDvPA5+RWKYM5KtyOLzz96eyc05u+ojcGoM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gpkEeARRILYympYNuxXftrrdB1abNaH6zmkBV4GutSuhEkODnb14k+2JZ7w6Fw2T2
	 9+bY8DrsM9oznPhdS8nNmQ35VHBYnKehuMgM83VrMia/MvaiHZQ3rmdx5CzkOsjURP
	 kFuATHvD5FG8qaECax6Lp36HkXck7HNe2dBa5aWJ+S2ONTKZu95Lw0vFWN9Kz6v8JD
	 GTd5QqIY3UBetB5kWwvIYEgK7nvUEBcH94h7GaS/Fg2BjybYcMpe3rjI7if3G37KBa
	 ArKEU15MhrczX07Wax4PXf74o4k/02yQD3THwPP5uJsEXsx50sv6HgBSU47csytHNc
	 Py02INfbBHlpA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 2/7] KVM: arm64: Unconditionally set IL for injected
 undefined exceptions
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fuad Tabba" <tabba@google.com>
Cc: "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20260618121643.4105064-3-tabba@google.com>
References: <20260618121643.4105064-1-tabba@google.com>
 <20260618121643.4105064-3-tabba@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 18 Jun 2026 12:30:42 +0000
Message-Id: <20260618123043.5D1C21F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Nested SError exception injection silently drops the ESR_EL2 value.
--

commit e7d1337c1e8d6db55c7b9ce2682f4c52e85c3f44
Author: Fuad Tabba <tabba@google.com>

KVM: arm64: Unconditionally set IL for injected undefined exceptions

This commit simplifies the inject_undef64() exception injection path by
unconditionally setting the IL bit, as the architecture mandates IL=3D1 for
EC=3D0 (Unknown).

> diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
> index 89982bd3345f6..9dfae1bcdf992 100644
> --- a/arch/arm64/kvm/inject_fault.c
> +++ b/arch/arm64/kvm/inject_fault.c
> @@ -170,14 +170,7 @@ void kvm_inject_sync(struct kvm_vcpu *vcpu, u64 esr)
> =20
>  static void inject_undef64(struct kvm_vcpu *vcpu)
>  {
> -	u64 esr =3D (ESR_ELx_EC_UNKNOWN << ESR_ELx_EC_SHIFT);
> -
> -	/*
> -	 * Build an unknown exception, depending on the instruction
> -	 * set.
> -	 */
> -	if (kvm_vcpu_trap_il_is32bit(vcpu))
> -		esr |=3D ESR_ELx_IL;
> +	u64 esr =3D (ESR_ELx_EC_UNKNOWN << ESR_ELx_EC_SHIFT) | ESR_ELx_IL;
> =20
>  	kvm_inject_sync(vcpu, esr);
>  }

[Severity: High]
This isn't a bug introduced by this patch, but while reviewing the exception
injection changes, I noticed a pre-existing issue in the nested SError
injection path.

In arch/arm64/kvm/emulate-nested.c, kvm_inject_nested_serror() constructs
the ESR for the nested SError and passes it down to kvm_inject_nested():

arch/arm64/kvm/emulate-nested.c:kvm_inject_nested_serror() {
	...
	esr |=3D FIELD_PREP(ESR_ELx_EC_MASK, ESR_ELx_EC_SERROR);
	return kvm_inject_nested(vcpu, esr, except_type_serror);
}

However, when this esr reaches kvm_inject_el2_exception(), the value is
silently discarded:

arch/arm64/kvm/emulate-nested.c:kvm_inject_el2_exception() {
	...
	switch (type) {
	case except_type_sync:
		kvm_pend_exception(vcpu, EXCEPT_AA64_EL2_SYNC);
		vcpu_write_sys_reg(vcpu, esr_el2, ESR_EL2);
		break;
	case except_type_irq:
		kvm_pend_exception(vcpu, EXCEPT_AA64_EL2_IRQ);
		break;
	case except_type_serror:
		kvm_pend_exception(vcpu, EXCEPT_AA64_EL2_SERR);
		break;
	...
}

Because the except_type_serror case breaks without writing esr_el2 to
ESR_EL2 (unlike the except_type_sync case), the constructed syndrome is
completely dropped.

Since enter_exception64() does not dynamically update ESR_ELx, will the
guest hypervisor observe a stale ESR_EL2 when handling the injected SError?

Could this cause the guest to misinterpret the error, potentially leading
to incorrect functional behavior or a guest panic?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260618121643.4105=
064-1-tabba@google.com?part=3D2
