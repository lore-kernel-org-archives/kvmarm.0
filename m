Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C94339A4A4
	for <kvmarm@lists.linux.dev>; Tue,  1 Sep 2026 22:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788300555; cv=none; b=eSpo0nETV8ZD2Tw3BOB7cVnSzkehoo5D9m2YpmbAkzZf4OMNk4EjnWiEP3K6G5YyfbqC2m/U7CcROQ6X/L6Th6xV/m5YZvlizMOFLJWxECIWYWxZ4Xl8gKLr2AfwAqnAXZN42N3DQtablVm30mke4s+cu6YNO/Pqn/mRJpzI03Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788300555; c=relaxed/simple;
	bh=0QKzP8NomqWOLJG+JkOrMzFuvv3+v/sdRh+MowI1JLM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=uNUyRFEKKpNf9CDSrsqCVoAWPpJ39CjcqnqTE9VWkSkdfDDekcmsfaowtOA/r8VciOLLL0OlbXcujciXnJK2CUMaODMv21JgUZQFGcUu3Yvhj1VlOIzW9bXXifuQe9qH4RrBhVkRJ8DEd+UYOWfLoT8DVs/3KeQWPzjBeTaCRzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RI3GX2Kj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RI3GX2Kj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9BC11F000E9;
	Tue,  1 Sep 2026 22:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788300553;
	bh=6aZ/WFfOg99SDa3sOC0xtwbyslQbYfh0AZcmTqeAxdY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RI3GX2KjjvWSIHkdW6kf3rKJxvJkrFkG4DzMKdnxcQoi49tmRJKprbmUZV4Bu3JPo
	 0Ih6vhxK8D8cfzIKYVOlJPK2rHdCmD/vOeClFkIbLmZEAp2dN2v3obw3UNsnPIYZ1D
	 5FWjVaUvHgg2YP6uYbWfaWMpkDv5hxUYss10Z+WYNAa565/HpEdU1CFMK0xAIxTjRj
	 YC0SHLYtvHHAPCj2BZXFGb7zIX0UiHp+/meKGOI14E1DdYRBUwdCSgMmV4KA0jJTOQ
	 s7T0ox7ERG5APmkr22pZXz7yJBu8868M4b8ZtMb47AL64sxLU/W7VnLrUE3LiPParc
	 wAd3C8sh3gPRg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v20 07/14] KVM: arm64: Forward GCS exceptions to nested
 guests
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mark Brown" <broonie@kernel.org>
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260901-arm64-gcs-v20-7-f31750bdfadb@kernel.org>
References: <20260901-arm64-gcs-v20-0-f31750bdfadb@kernel.org>
 <20260901-arm64-gcs-v20-7-f31750bdfadb@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 01 Sep 2026 22:09:13 +0000
Message-Id: <20260901220913.B9BC11F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] Incorrect context check for forwarding GCS exceptions to a neste=
d hypervisor.
--

commit 2265e268ea1606e4aa21cb8062727c3b949089d6
Author: Mark Brown <broonie@kernel.org>

KVM: arm64: Forward GCS exceptions to nested guests

For nested guests where HFGITR_EL2.nGCSSTR_EL1 is clear or when there are
L2 GCS data check exceptions we need to forward the exception to the guest.
Add handling to do so.

> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> index db37678dcb05c..a8198e96fcb41 100644
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c

[ ... ]

> +static int kvm_handle_gcs(struct kvm_vcpu *vcpu)
>  {
> -	/* We don't expect GCS, so treat it with contempt */
> -	if (kvm_has_feat(vcpu->kvm, ID_AA64PFR1_EL1, GCS, IMP))
> -		WARN_ON_ONCE(1);
> +	if (!kvm_has_gcs(vcpu->kvm)) {
> +		kvm_inject_undefined(vcpu);
> +		return 1;
> +	}
> =20
> +	if (vcpu_has_nv(vcpu)) {
> +		kvm_inject_nested_sync(vcpu, kvm_vcpu_get_esr(vcpu));
> +		return 1;
> +	}

[Severity: Medium]
Is it correct to only check vcpu_has_nv() here without verifying if the vCPU
is currently executing in a nested context?

If a hardware or hypervisor bug causes a GCS exception to trap to the host
while running L1's EL2, vcpu_has_nv() will be true, but it shouldn't be
forwarded to the guest. Instead of falling back to the WARN_ON_ONCE() and
undefined exception injection at the end of kvm_handle_gcs(), this would
silently emulate an exception to L1's EL2, potentially corrupting its state.

Should this condition also check is_nested_ctxt(vcpu) to ensure we are
actually running a nested guest before forwarding the exception?

> +
> +	WARN_ON_ONCE(1);
>  	kvm_inject_undefined(vcpu);
>  	return 1;
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260901-arm64-gcs-=
v20-0-f31750bdfadb@kernel.org?part=3D7
