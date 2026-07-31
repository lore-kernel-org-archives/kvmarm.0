Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFAFD3D5645
	for <kvmarm@lists.linux.dev>; Fri, 31 Jul 2026 12:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785502727; cv=none; b=FahvXPfcyYPWV8guYSteb55h6Q1GGE/zw0DgS4NFQ1sxvB/rQzw2RYNCYrndvnwFiAkqlDwGgDt+Yz+rrkctXjtD+thb+Yt9pVROt+EN/CDKdt5V+X/RKYVVa3m7NZqIP6Fkf3KtS1w4LAT3A6aF7qsi7a5mSv0Z7P1eVP/k/V4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785502727; c=relaxed/simple;
	bh=8813yvnyDeriAi/z4rMYKeWBdX1+P9XLAnQLEMypPu8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=WHIqmDNdPIdTv2UrRscRERn7ePuq1+VPZa20tiYu8LvvZaQATbbnhwWpZF3eDPSaqg6WJ3KhX7+5JGTedoilXDLNDGMr23EYLQ3TUau4hdPb8NfWvKjAMjlemdsfOTGmUbQ+x8oCQWV6ocRviuOhe0WN6PBvfgjdM1nracT9GXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XbreZBbC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XbreZBbC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8949D1F000E9;
	Fri, 31 Jul 2026 12:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785502725;
	bh=1eAgOG23kG2hwbKt5TUHtXw6/msMGxn35aOjjgI058Y=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XbreZBbCMx1UkSES7bPi98gQvgA1CghPjwKIbtKXxtTDREIrvw5u5pW71i+9bSQiv
	 VEgRwVLyn83V08H9QX/T7ZiGBUIVyjZ8PEVbt1o7wj0/0UNeNhazJa2fBSXkMU1XBA
	 b2hJA+IRIo5QbRP/SEYO5uf+hNuPkJZZ5pUVrvcgy4f9CaBJlXp8SbpQEaD3KJaNWO
	 X3N1a1+w7WcG7fAxyeQxqtuMH8kXkrP5m6QcFuIpzjU21isOMR0BjRZmvc3NGyatWf
	 HMc+ukBG/gfT8o/iouE0xQeXorj8ck59xiIAmBDh764ayaj5dT84IjX6e000eHBL5W
	 ruB+4+fY8XtwA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v17 07/14] KVM: arm64: Forward GCS exceptions to nested
 guests
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mark Brown" <broonie@kernel.org>
Cc: "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260731-arm64-gcs-v17-7-5e39ca01b14e@kernel.org>
References: <20260731-arm64-gcs-v17-0-5e39ca01b14e@kernel.org>
 <20260731-arm64-gcs-v17-7-5e39ca01b14e@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 31 Jul 2026 12:58:41 +0000
Message-Id: <20260731125842.8949D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] GCS data check exceptions from the L1 hypervisor context incorrect=
ly trigger a host-side WARN_ON_ONCE and an UNDEFINED exception injection in=
stead of being forwarded.
--

--- Patch [7]: [PATCH v17 07/14] KVM: arm64: Forward GCS exceptions to nest=
ed guests ---
commit c532b4ba16abdf3ea91375bafb69e02b935e5151
Author: Mark Brown <broonie@kernel.org>

KVM: arm64: Forward GCS exceptions to nested guests

This commit adds handling to forward GCS exceptions to the hypervisor
when a nested guest has HFGITR_EL2.nGCSSTR_EL1 clear or for a GCS data
check exception in an L2 guest.

> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> index 54aedf93c78b6..9db3508917937 100644
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c
[ ... ]
> +/*
> + * We might get GCS exceptions that need to be forwarded to the
> + * hypervisor when a nested guest has HFGITR_EL2.nGCSSTR_EL1 clear, or
> + * for a GCS data check exception for a L2 guest.
> + */
>  static int kvm_handle_gcs(struct kvm_vcpu *vcpu)
>  {
> -	/* We don't expect GCS, so treat it with contempt */
> -	if (kvm_has_feat(vcpu->kvm, ID_AA64PFR1_EL1, GCS, IMP))
> -		WARN_ON_ONCE(1);
> +	if (!kvm_has_gcs(vcpu->kvm)) {
> +		kvm_inject_undefined(vcpu);
> +		return 1;
> +	}
> =20
> +	if (is_nested_ctxt(vcpu)) {

[Severity: High]
Does is_nested_ctxt() incorrectly filter out the L1 hypervisor context?

If a VHE L1 hypervisor (or its L1 host userspace) executes a GCS instruction
that generates a GCS data check exception, the hardware targets EL1. Due to
HCR_EL2.NV =3D 1, this is redirected to L0 KVM.

Since is_nested_ctxt(vcpu) returns false for L1 hypervisor contexts
(because is_hyp_ctxt(vcpu) is true), this check will fail and fall through
to injecting an UNDEFINED exception.

Should this use vcpu_has_nv(vcpu) instead to ensure exceptions from both L1
and L2 contexts are properly forwarded to the virtual EL2?

> +		kvm_inject_nested_sync(vcpu, kvm_vcpu_get_esr(vcpu));
> +		return 1;
> +	}
> +
> +	WARN_ON_ONCE(1);

[Severity: High]
Is it possible for an unprivileged L1 userspace process using GCS to trigger
this WARN_ON_ONCE?

Since the is_nested_ctxt() check above falls through for L1 contexts, a
legitimate GCS fault in L1 (such as mismatching a return address on the sha=
dow
stack) could reach this warning. This would allow an L1 guest to trigger a
host-side kernel warning (kernel log DoS) and crash the L1 VM.

>  	kvm_inject_undefined(vcpu);
>  	return 1;
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260731-arm64-gcs-=
v17-0-5e39ca01b14e@kernel.org?part=3D7
