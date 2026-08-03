Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEC5B23BD02
	for <kvmarm@lists.linux.dev>; Mon,  3 Aug 2026 23:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785800506; cv=none; b=cfCnijvRv6WKRvRJlaPTDa4XABkjKdKJbsnszc8Zsgy/f+3aPtjN4zW/tdsqpHrqMLLrijj9+IpyOrcsu1iT/1zLFl8fltU3DQ+ong5GhHQZuJZDHRQ/AyPErlDrs2XyNFM9sAX4BumkD6mVQB78IjrbYdgIRXjQBTtOeFmPxlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785800506; c=relaxed/simple;
	bh=JW56EkAgYxB2vJC5MqWkrbFIQxS3LDfsZaxqjL9DWtM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=QACIUUe34kSNHLwh8fRH+eTZM1E96+jV1+gwGvft6sBO/LPnq5esxrSDHfkdnt82P3B7d1WP8P4ETjq5aU01Xhg6bU57VzJZr6wFiAkLbiwuXbSYUaswoYzZIpr9CmMR5J6eOLj6T92WPQPg/eN5FUNCDC0dNn59Xex3rpcmjB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iCgzKToN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iCgzKToN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48E161F000E9;
	Mon,  3 Aug 2026 23:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785800505;
	bh=U8/od2fEhMv79PcgvxgiaaNVihLF2SxwxmUyNmpriYU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=iCgzKToNwjijy9fRSg0N+w8LdrLKi+8fav9GXqMhtSOqSWSKtbin4tTQ8Q+0edQR1
	 tV/NT350OzBxeoQvgAYssmjWiXLKd6+SHDSNMRd39bC+K+64v9w2rDuqESlP4mXi0q
	 cHcUclLC6/9zmjmEU0kXWp4CuaAEQ7Im8PiIPRvQ1rOkoVeJ5E7KelnzzXcsG4Zh8G
	 v914yoRKw4rZgRbQDmb7FnnY9Cs3U02uKiAaFuDpvDIJViVzUAnC8RVvzqWk6H9Lj0
	 9j5umdcCIyUG+g42Y3v2uHFKF8SXf+nxmUaM045p/i1kzVohi062Y9+K8yojbvVbc7
	 Sf/Qz8Ilk62Ow==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v18 06/14] KVM: arm64: Validate GCS exception lock when
 emulating ERET
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mark Brown" <broonie@kernel.org>
Cc: "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260803-arm64-gcs-v18-6-fd8c40f5ad88@kernel.org>
References: <20260803-arm64-gcs-v18-0-fd8c40f5ad88@kernel.org>
 <20260803-arm64-gcs-v18-6-fd8c40f5ad88@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 03 Aug 2026 23:41:44 +0000
Message-Id: <20260803234145.48E161F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] kvm_check_illegal_exlock_return() incorrectly reads the host's phy=
sical GCSCR_EL1 register instead of the guest's virtual registers when emul=
ating an ERET.
--

--- Patch [6]: [PATCH v18 06/14] KVM: arm64: Validate GCS exception lock wh=
en emulating ERET ---
commit 1a99244e8c449893f9c88233d42b775527985630
Author: Mark Brown <broonie@kernel.org>

KVM: arm64: Validate GCS exception lock when emulating ERET

This commit adds validation for a GCS-specific case where an illegal
exception return can be generated due to an EXLOCK mismatch, emulating this
behavior for nested guests.

> diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm=
/kvm_nested.h
> index 012d711034d17..b2343f67d15b7 100644
> --- a/arch/arm64/include/asm/kvm_nested.h
> +++ b/arch/arm64/include/asm/kvm_nested.h
[ ... ]
> @@ -240,6 +240,45 @@ static inline bool kvm_auth_eretax(struct kvm_vcpu *=
vcpu, u64 *elr)
>  }
>  #endif
> =20
> +#ifdef CONFIG_ARM64_GCS
> +/*
> + * A subset of the pseudocode ELFromSPSR(), validity checks are
> + * assumed to have been done in code that is not GCS specific.
> + */
> +static inline int exlock_el_from_spsr(u64 spsr)
> +{
> +	return FIELD_GET(GENMASK(3, 2), spsr);
> +}
> +
> +/* See IllegalExceptionReturn() pseudocode */
> +static inline bool kvm_check_illegal_exlock_return(struct kvm_vcpu *vcpu,
> +						   u64 spsr)
> +{
> +	u64 cur_el, target_el;
> +
> +	if (!kvm_has_gcs(vcpu->kvm))
> +		return false;
> +
> +	if (vcpu->arch.ctxt.regs.pstate & PSR_EXLOCK_BIT)
> +		return false;
> +
> +	cur_el =3D exlock_el_from_spsr(vcpu->arch.ctxt.regs.pstate);
> +	target_el =3D exlock_el_from_spsr(spsr);
> +
> +	if (cur_el !=3D target_el)
> +		return false;
> +
> +	return read_sysreg_el1(SYS_GCSCR) & GCSCR_ELx_EXLOCKEN;

[Severity: High]
Does this code read the host's physical GCSCR_EL1 hardware register instead
of the nested guest's virtual register?

When emulating an ERET for a nested guest, this validation is called in the
slow path:

kvm_check_illegal_exception_return()
   kvm_check_illegal_exlock_return()

At this point, the world switch has already finished, meaning the physical
registers hold the host's state. Reading the physical SYS_GCSCR here will
cause the nested guest's ERET behavior to be evaluated against the host
userspace configuration, which might incorrectly trigger or miss architectu=
rally
required exception injections.

Should this fetch the guest's virtual register via vcpu_read_sys_reg()
instead, depending on the value of cur_el?

> +}
> +
> +#else
> +static inline bool kvm_check_illegal_exlock_return(struct kvm_vcpu *vcpu,
> +						   u64 spsr)
> +{
> +	return false;
> +}
> +#endif
[ ... ]
> diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nes=
ted.c
> index b32742d9dd73e..0f0723f22000a 100644
> --- a/arch/arm64/kvm/emulate-nested.c
> +++ b/arch/arm64/kvm/emulate-nested.c
[ ... ]
> @@ -2740,10 +2740,13 @@ static u64 kvm_check_illegal_exception_return(str=
uct kvm_vcpu *vcpu, u64 spsr)
>  	 * - trying to return to an illegal M value
>  	 * - trying to return to a 32bit EL
>  	 * - trying to return to EL1 with HCR_EL2.TGE set
> +	 * - GCSCR_ELx.EXLOCKEN is 1 and PSTATE.EXLOCK is 0 when attempting
> +	 *   to return from ELx the same EL.
>  	 */
>  	if (mode =3D=3D PSR_MODE_EL3t   || mode =3D=3D PSR_MODE_EL3h ||
>  	    mode =3D=3D 0b00001         || (mode & BIT(1))       ||
>  	    (spsr & PSR_MODE32_BIT) ||
> +	    kvm_check_illegal_exlock_return(vcpu, spsr) ||
>  	    (vcpu_el2_tge_is_set(vcpu) && (mode =3D=3D PSR_MODE_EL1t ||
>  					   mode =3D=3D PSR_MODE_EL1h))) {
>  		u64 mask;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260803-arm64-gcs-=
v18-0-fd8c40f5ad88@kernel.org?part=3D6
