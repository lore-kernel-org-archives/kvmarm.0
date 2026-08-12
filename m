Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4990321E097
	for <kvmarm@lists.linux.dev>; Wed, 12 Aug 2026 19:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786563140; cv=none; b=kOQkkV3UjgIWFY/7+0CzGzMn35UHN48NRaLvYOqamsWIph2nywvOokK5/BmsoszChRR9fnIVw+MQfGq+T9gXzjiC5N7RK78YiFfHQoIf7nFY7yd68Wk9SzDjDXVorJIlwnFSrcDU+Gw3yusa4xgCCgXCKSZx4QC2A/6SHBlwRFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786563140; c=relaxed/simple;
	bh=afLZ+QxEJHFLC9npPGlWHd8b0CsS643E04/bWoU0UCw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=solsqEL7Jx0vGirr4VOrqBFWtiq0dW+hAAlvNkV601dNXtpf+gZN7YYdlqMC2dQW4eNpZuaef5F6F63MeiOmJ4sWBGU4ptSNPT/WyA7kQm+dTMZmER9MulZUvoucMKM4sppGx9+f0rYfalMvJc3Rvv91Q5ZoK9sxa+acqpMUQkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S0QLr9hL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S0QLr9hL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD3B41F000E9;
	Wed, 12 Aug 2026 19:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786563138;
	bh=0x/MXPBLacf8BpJzLCogNMaUscn6aARIpCexozdSkzg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=S0QLr9hLnHNfM6i5JigfMZkUcaSE2K8vA3R36rcZ6r+2PkXkmCqvKwNPJ3528jtYZ
	 q+DtgxPts+Fr6yGcBBfvNCej8NQcgweAhf0bW7Wc9ML3ou/M2Hq+0wR++t2BqUCm5y
	 aMk8Xp5hGbyuT+50TQbuLI3/Mffj9sL/psdtgDIbSAvrmUh4Fyx6uufKCtVsj98sbc
	 QQQMkYHAJU9YFdFcjveFangvaCWzm/yH4vDR4WwKdqFz7B/mrnTaU/yvcOR0NRHx/W
	 q+6X/0ddmBrrblD11Cfd3MMj2dFvYOBG4HoVzxJ692IMlceWvcqlljRWo+qJW0gAD6
	 DTJ/35ld0Pbmw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v19 07/14] KVM: arm64: Forward GCS exceptions to nested
 guests
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mark Brown" <broonie@kernel.org>
Cc: kvmarm@lists.linux.dev, "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20260812-arm64-gcs-v19-7-9105afd828ac@kernel.org>
References: <20260812-arm64-gcs-v19-0-9105afd828ac@kernel.org>
 <20260812-arm64-gcs-v19-7-9105afd828ac@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 12 Aug 2026 19:32:18 +0000
Message-Id: <20260812193218.AD3B41F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] `kvm_handle_gcs` uses `vcpu_has_nv(vcpu)` instead of `is_nested_=
ctxt(vcpu)` to forward GCS exceptions, bypassing safety warnings and misrou=
ting unexpected L1 traps.
--

--- Patch [7]: [PATCH v19 07/14] KVM: arm64: Forward GCS exceptions to nest=
ed guests ---
commit f418917369df0c1bc3138d818288366ea3e842e1
Author: Mark Brown <broonie@kernel.org>

KVM: arm64: Forward GCS exceptions to nested guests

This commit adds handling to forward GCS exceptions to nested guests when
HFGITR_EL2.nGCSSTR_EL1 is clear or for GCS data check exceptions in an L2
guest.

> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> index 54aedf93c78b6..63dcc4a0e69a8 100644
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
> +	if (vcpu_has_nv(vcpu)) {

[Severity: Medium]
Does this code use the correct check for nested execution here?

By checking vcpu_has_nv() instead of is_nested_ctxt(), if an unexpected GCS
trap occurs while executing the L1 guest, KVM will erroneously forward the
trap to the L1 virtual EL2.

Should this check be is_nested_ctxt(vcpu) so that unexpected L1 traps fall
through to the host WARN_ON_ONCE and correctly inject an UNDEF?

> +		kvm_inject_nested_sync(vcpu, kvm_vcpu_get_esr(vcpu));
> +		return 1;
> +	}
> +
> +	WARN_ON_ONCE(1);
>  	kvm_inject_undefined(vcpu);
>  	return 1;
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260812-arm64-gcs-=
v19-0-9105afd828ac@kernel.org?part=3D7
