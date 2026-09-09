Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0EAF456DFD
	for <kvmarm@lists.linux.dev>; Wed,  9 Sep 2026 22:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788993914; cv=none; b=ZH11li8iykNAM1gJ/m7sP1kC6fUbEwXHFIn3oqx1wfkfT3dPvknN9VMLTL+8efotPuj41/NLcqL7fdAlWAqnmJ73+MoIYYhMUkvEV3qB+gwwDWepo6811EjYO0VC77CPXAkXFLmkAlcTrcBi88+zKRdMiYcvwbEw8bT1isSp6j8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788993914; c=relaxed/simple;
	bh=GUMG6FO/IxwLWtuSXw2Kgh5Qv9VWx1Nd5sC3jb38ykg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=P6Mvs+5EoiN2cT6HtymXcHPMSe+tzM5ci5lfx1Dvcvdz9D/dJcG5VPeV0aVRG0ZncyPM/yrSHWlZUMCxCvuxBrwh28/L+cWFzVwk5a3UfsVWW1WGozrvuNMzOhSmg4TKCojxxbBH3LejMMDutZg1GpgspeLdq7I65fd3H6wXPEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZPQ2bqsn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZPQ2bqsn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7F0D1F00898;
	Wed,  9 Sep 2026 22:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788993899;
	bh=hnCYvoMqJIEapvWBirdau7OMDw2VSINl9MtHe4/KMdI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZPQ2bqsnUYFW2mfwojer4R4ZBhQD75BeV8b4QE9H0XHazTDusn5gZQqp7q+YWuaAu
	 9NzI9kO0tIG1miTY3GYr5ZuPSAwgCHshH+XZA20rbswn1WDb67oQ1mh7YPeM+N/EwC
	 UKnZQzKB+L5Rv5RDPz0h50e+HnmlvxRfodPO7jkdIaw+uA/k2eYvI+MD3bBcfOjQv7
	 VpWiFqna6LVOlxqkIFVCjydJYgSXunPCupCCt47d7Buwe310OS7tUEjb3lfo/M6kCz
	 ub0AW47PwGbUSQkn8xu6soOS4EZ2qWXZ8GNSH7V6q/qCgFaZ15Ru0EzZ946DwdKTlg
	 kUxzZ4sxkyMJQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v1 1/3] KVM: arm64: nv: Don't advertise FEAT_LPA2 for
 guest stage-1
Reply-To: sashiko-reviews@lists.linux.dev
To: "Wei-Lin Chang" <weilin.chang@arm.com>
Cc: "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20260909222015.3046432-2-weilin.chang@arm.com>
References: <20260909222015.3046432-1-weilin.chang@arm.com>
 <20260909222015.3046432-2-weilin.chang@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 09 Sep 2026 22:44:58 +0000
Message-Id: <20260909224458.E7F0D1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] Equality checks for TGRAN4 and TGRAN16 fail to mask future archi=
tectural enum values, leaking unsupported hardware capabilities to NV guest=
s.
--

commit 6c2ebbb5542b3e22eaee90b7cf8d8cbbc9704e7c
Author: Wei-Lin Chang <weilin.chang@arm.com>

KVM: arm64: nv: Don't advertise FEAT_LPA2 for guest stage-1

There is no FEAT_LPA2 support for NV guests as of now, but we missed
limiting it for the non-stage-2 granule size fields (TGRAN4, TGRAN16) in
ID_AA64MMFR0_EL1. Add the sanitisation.

> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index 17123f0b6daba..4d1884b32fc48 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -1731,6 +1731,19 @@ u64 limit_nv_id_reg(struct kvm *kvm, u32 reg, u64 =
val)
>  		/* Hide CNTPOFF if present */
>  		val =3D ID_REG_LIMIT_FIELD_ENUM(val, ID_AA64MMFR0_EL1, ECV, IMP);
> =20
> +		/* NV does not support FEAT_LPA2. */
> +		if (SYS_FIELD_GET(ID_AA64MMFR0_EL1, TGRAN4, val) =3D=3D
> +		    ID_AA64MMFR0_EL1_TGRAN4_52_BIT) {

[Severity: Medium]
Will this exact equality check fail to mask future architectural enum value=
s?

If future hardware implements a capability enum value greater than 52_BIT f=
or
TGRAN4, this check will evaluate to false, leaking the unsupported capabili=
ty
to NV guests.

Could this be capped instead, perhaps using inequalities or the
ID_REG_LIMIT_FIELD_ENUM macro, to maintain forward compatibility?

> +			val &=3D ~ID_AA64MMFR0_EL1_TGRAN4;
> +			val |=3D SYS_FIELD_PREP_ENUM(ID_AA64MMFR0_EL1, TGRAN4, IMP);
> +		}
> +
> +		if (SYS_FIELD_GET(ID_AA64MMFR0_EL1, TGRAN16, val) =3D=3D
> +		    ID_AA64MMFR0_EL1_TGRAN16_52_BIT) {

[Severity: Medium]
Similarly, will this exact equality check fail to mask future unsigned capa=
bility
values greater than 52_BIT for TGRAN16?

> +			val &=3D ~ID_AA64MMFR0_EL1_TGRAN16;
> +			val |=3D SYS_FIELD_PREP_ENUM(ID_AA64MMFR0_EL1, TGRAN16, IMP);
> +		}
> +
>  		/* Disallow unsupported S2 page sizes */
>  		switch (PAGE_SIZE) {
>  		case SZ_64K:

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260909222015.3046=
432-1-weilin.chang@arm.com?part=3D1
