Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 911F33F44F0
	for <kvmarm@lists.linux.dev>; Thu, 18 Jun 2026 12:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781785763; cv=none; b=qBLyXl6TUSJ3O907bIvGBqcwtz3Xl3/AkE/k91mkp29bDac7Qc+RV7hPl3FuZ48wgdzsfCdrhUCxkrfnLSzyMtwoqcutV0gPBPmamWeWUdVLbRhw4DwPnRmH4BrC8lrYWKUOpNPZkjmEw6uLTKI9bgAbhF+6VU0WxT3UL4hLGPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781785763; c=relaxed/simple;
	bh=5RvUAPSc0KzPqKJ6Iprk4RI4IeNFuxU+PLMyzeXQm8E=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=UdePXV5Qkao55ncVIo+H9Zi+kp+eJrnePdQZ357zZgpsUquY5bgqXX3F8HiZ/7iSx4XBuaiup4B0Na1utVmF3v7k4KSqFvL1slwkSTW7fgkf98u02ncI25Z/NMHns+be9Olz4YIS1GGsr0vYdoU1uE/7ksnj6KxFskbDGMwRPJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OkeJwXWa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OkeJwXWa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F224E1F000E9;
	Thu, 18 Jun 2026 12:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781785762;
	bh=BEeFXqlUntmf+yCTkmjzOOWguwLPFms+8PeK8ezZ/0E=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OkeJwXWamidJywECPOVxG74mqpg47WMCWkGH5zh5exevTR/xrQnEgHgD9st7hwhsl
	 HdP5YbnDGML13W+Tdy+scP3I9wPsma0AxR9NGlYEO3BcZqxWrEVPF61AUxaTuxMTEr
	 lR8vnSfuFwx/NgWqzRgvx6mcWgNZomoigCzOXPb2o+ZpDwPXtSLAlbE7i9O7LwnyfG
	 FqTkWXbyaOH+1WQK4GR1du811ppYs7hbdlPFD5uUXkxb82VNoF7ekTz5ic2bg8O+qa
	 KHu1Y7d5gU7xmtYJQblhtwREm4oaaJ5+JwQSh51EWXq7K0uQDYf4QrDPpKUGX3Tfgg
	 al5tBKs9j5eGw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 3/7] KVM: arm64: Unconditionally set IL for injected
 abort exceptions
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fuad Tabba" <tabba@google.com>
Cc: "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260618121643.4105064-4-tabba@google.com>
References: <20260618121643.4105064-1-tabba@google.com>
 <20260618121643.4105064-4-tabba@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 18 Jun 2026 12:29:21 +0000
Message-Id: <20260618122921.F224E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Unconditional IL=3D1 in inject_abt64() creates invalid ESR state f=
or Address Size faults.
--

commit 5d93cc0ddb43cdfa88e555d446e07e55b7334637
Author: Fuad Tabba <tabba@google.com>

KVM: arm64: Unconditionally set IL for injected abort exceptions

This commit unconditionally sets the ESR_ELx_IL bit to 1 for injected
aborts, assuming the FSC is always EXTABT or SEA_TTW.

> diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
> index 9dfae1bcdf992..444d219b02174 100644
> --- a/arch/arm64/kvm/inject_fault.c
> +++ b/arch/arm64/kvm/inject_fault.c

[ ... ]

> @@ -138,11 +138,10 @@ static void inject_abt64(struct kvm_vcpu *vcpu, boo=
l is_iabt, unsigned long addr
>  		pend_sync_exception(vcpu);
> =20
>  	/*
> -	 * Build an {i,d}abort, depending on the level and the
> -	 * instruction set. Report an external synchronous abort.
> +	 * Build an {i,d}abort, depending on the level.
> +	 * Report an external synchronous abort.
>  	 */
> -	if (kvm_vcpu_trap_il_is32bit(vcpu))
> -		esr |=3D ESR_ELx_IL;
> +	esr |=3D ESR_ELx_IL;

[Severity: High]
Does this unconditional setting of IL=3D1 cause an architecturally invalid
syndrome for Address Size faults?

If a guest executing in AArch32 EL0 issues a 16-bit instruction (such as a
16-bit LDR) that triggers a Stage-2 Address Size fault, the IL bit should
accurately reflect the size of the trapped instruction (0 for 16-bit).

Looking at kvm_inject_size_fault(), it injects the abort by calling
inject_abt64() via the __kvm_inject_sea() call chain, and then modifies the
FSC to 0 (Address Size Fault):

arch/arm64/kvm/inject_fault.c:kvm_inject_size_fault() {
    ...
    /* inject_abt64() forces IL=3D1 earlier in the call chain */
    ...
    esr &=3D ~GENMASK_ULL(5, 0);
    vcpu_write_sys_reg(vcpu, esr, exception_esr_elx(vcpu));
    ...
}

Will KVM now inject the Address Size fault with IL=3D1 instead of IL=3D0,
potentially causing the guest OS exception handler to incorrectly advance
the Program Counter by 4 bytes instead of 2 during fault unwinding?

> =20
>  	/*
>  	 * Here, the guest runs in AArch64 mode when in EL1. If we get

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260618121643.4105=
064-1-tabba@google.com?part=3D3
