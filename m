Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98B6F37DEBE
	for <kvmarm@lists.linux.dev>; Mon, 31 Aug 2026 21:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788210029; cv=none; b=NI+G5QnUmNhkGzUcciSNi+CH7lSyvzhrRCfTNzEWg+cQdiIuzwszluwibe4KZLAXuN8srg5JfBd++NBzM6nKlQpfBjIpgEjSV3Bv3rSYNFfxFO/2Uqthj9/Zu35L6uP3FXa0JDw4JSyVvCXQuJCxNr1BCLbANkXGUEH4u1atKTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788210029; c=relaxed/simple;
	bh=1c0oN7CyVzB3Ia01m8s7PYn/StOVCvCFDI1oA6r0IHg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=p4i76NeWXNnpy677ARmg5vs3G0a9nTngPKsM5MORQjjF9rJIA0M3Hc2BKbSOclTQY4Uv0Ygpx6kvwloSBAVuEK03GyGNv2tYGpBBdZG7KgB+mtuUNgTm135aWTttHQGfag53UvEJIaO4pHs7iQJwqexJqviD5DoPanR0FPqrMG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g+aPf3Ed; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g+aPf3Ed"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0C331F000E9;
	Mon, 31 Aug 2026 21:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788210028;
	bh=oU1Mfjf5twTLUjQyiu+pAL3+hPAAVtyONrh/HjEkB7U=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=g+aPf3Ed7xc7Y0/PicaJyoQwqjemLjm2OQ81wd97F0Cs8IlIUXKdYUJqYcapmUPyZ
	 StoTIe+rwKpkwmmTYlN5o/dh3XCzutYMsG1LQyVeWKEIuQ6NEFMJtsyf8xegV4DFwp
	 H5Ge3zRWh3GJfhMAW2M8s9bmoCehCKBSTZgvPN3kWiP3/5Yrs7JMbuyHe8ZB52pLvz
	 qXmHeyw4VRzd2t04OxAJvN+FxLNlpdCxqgCIFvSROJ9NFtMh7rWY7dBCgobR4OqKp4
	 mjymXgKeuwRPHBGwEJuw32/o0CSq97uniTTtSip/7K4qNzm9eH+5yo3oqRbx094tTx
	 6EaejSY0ajqNA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 08/17] KVM: arm64: Implement HVC handling for protected
 guests at EL2
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fuad Tabba" <fuad.tabba@linux.dev>
Cc: "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20260831163421.272420-9-fuad.tabba@linux.dev>
References: <20260831163421.272420-1-fuad.tabba@linux.dev>
 <20260831163421.272420-9-fuad.tabba@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 31 Aug 2026 21:00:27 +0000
Message-Id: <20260831210027.E0C331F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] kvm_handle_pvm_hvc64 incorrectly intercepts ARM_SMCCC_ARCH_FEATURE=
S_FUNC_ID and unconditionally returns NOT_SUPPORTED for Spectre mitigations=
 (ARCH_WORKAROUND_1, 2, 3), leaving protected guests vulnerable.
--

commit 3a993faeabc602db9d44970bfb0c7813227c0324
Author: Fuad Tabba <fuad.tabba@linux.dev>

KVM: arm64: Implement HVC handling for protected guests at EL2

This commit extends kvm_handle_pvm_hvc64() to handle SMCCC_VERSION,
SMCCC_ARCH_FEATURES, and the vendor hypervisor call UID at EL2. It also
adds handlers to forward protected guest HVCs to the host.

> diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkv=
m.c
> index af334318d0a03..0fe11f95e2e26 100644
> --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
> +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c

[ ... ]

> @@ -1144,8 +1144,37 @@ bool kvm_handle_pvm_hvc64(struct kvm_vcpu *vcpu, u=
64 *exit_code)
>  {
>  	u64 val[4] =3D { SMCCC_RET_INVALID_PARAMETER };
>  	bool handled =3D true;
> +	u32 feature;
> +	uuid_t uuid;
> =20
>  	switch (smccc_get_function(vcpu)) {

[ ... ]

> +	case ARM_SMCCC_ARCH_FEATURES_FUNC_ID:
> +		/* SUCCESS only for the architecture calls EL2 implements. */
> +		feature =3D smccc_get_arg1(vcpu);
> +		switch (feature) {
> +		case ARM_SMCCC_VERSION_FUNC_ID:
> +		case ARM_SMCCC_ARCH_FEATURES_FUNC_ID:
> +			val[0] =3D SMCCC_RET_SUCCESS;
> +			break;
> +		default:
> +			val[0] =3D SMCCC_RET_NOT_SUPPORTED;
> +			break;

[Severity: High]
Does this catch-all default case inadvertently disable Spectre mitigations
in the protected guest kernel?

When the guest OS boots, it queries ARM_SMCCC_ARCH_FEATURES_FUNC_ID for
ARM_SMCCC_ARCH_WORKAROUND_1 (and others) to check availability. Because this
default case blindly returns SMCCC_RET_NOT_SUPPORTED, the guest will assume
the workarounds are unavailable.

Could this allow an untrusted guest userspace process to exploit transient
execution attacks (like V2, V4, BHB) and leak guest kernel or other guest
userspace memory?

> +		}
> +		break;

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260831163421.2724=
20-1-fuad.tabba@linux.dev?part=3D8
