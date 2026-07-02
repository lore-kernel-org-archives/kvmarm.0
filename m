Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 824D83A6B99;
	Thu,  2 Jul 2026 16:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009700; cv=none; b=swyjXODDWWVGFP9e5BQRDiXmctdHPGE+VCUPx+VgReCiUFtAPCoP1eogLYtWbnNRaKZB37ZeQn0oxTpw932DQj1UZDJTd3qE7wPIPlY7Pb3m4Ap4e748MJ5t/2W4EJYo4rtiM0eNvC+tMt+daNtyf/TwOt5aEn1+/ybMqKqVu2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009700; c=relaxed/simple;
	bh=YZtx7FicGuo2ZQg6kLwnphmWkM3QJoabNXSfysMMR6Q=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=C/IY95WgoCbZzRDXHswhcLMVAUhs9uKftZMmG8T6dJiS7Y3m0pr94jPOhSetZ8MJcxKArmllsgXIxdjVy0xZzUpJDFrXZWkucMP0zpx6cde51Ycp8evlrYDp8O6e+SBne6kPTe+BAwqv2P0SI9EqrQwBvEbvWQG1OeaI7l9Ats8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GScRDoLK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GScRDoLK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D5CE1F00A3D;
	Thu,  2 Jul 2026 16:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783009696;
	bh=GQvfeBO5KmqUbuxipvt5AfkfMvKAqHItUAv5ICJw7gc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GScRDoLKLfSdh8ibzsYDmjyh9RoZElALOiIYJnWvPVeP+SkejYT0LlB8LqrZvznHV
	 mnQDyGVtM2inXuYajbfrpFwQ7UUSMQCWi1H+5cEgC1mfLJPEPWdc+5Wj0gK/wbHlaa
	 923/zOXMXYoAzJpaXMUQ4kMlveEnjdOoOuccOBb7C/bjVHGTTRshKSR+WLtRcBa8mN
	 bfiRx88tii9isU7nSL40v7OTWa/+PfC9kWFJokUbu6tbKHRuMrATVvBEi07rxh8LWp
	 iYuZ9kAeQ0LarAfWb0pGzU2JDnOjqHYn0bWa1HDYmy0rzuriOAjsRSmunhGWQq41+Q
	 Ho9cOP3R5T0Gw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 05/28] KVM: arm64: Plumb HCRX_EL2.SRMASKEn in HCRX_EL2
 sanitisation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Marc Zyngier" <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20260702160248.1377250-6-maz@kernel.org>
References: <20260702160248.1377250-1-maz@kernel.org>
 <20260702160248.1377250-6-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 02 Jul 2026 16:28:15 +0000
Message-Id: <20260702162816.7D5CE1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Missing RES0 constraints in system register feature map for `HCRX_=
EL2` allows nested guests to set reserved hardware bits.
--

commit 5fb0fde52515a7e2e03636fdc18f15c38a091ddd
Author: Marc Zyngier <maz@kernel.org>

KVM: arm64: Plumb HCRX_EL2.SRMASKEn in HCRX_EL2 sanitisation

This patch adds the HCRX_EL2.SRMASKEn bit to the HCRX_EL2 feature map to
enable FEAT_SRMASK for a guest. It also updates the system register
definitions to reflect the new bit field.

> diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
> --- a/arch/arm64/kvm/config.c
> +++ b/arch/arm64/kvm/config.c
> @@ -904,6 +904,7 @@ static const DECLARE_FEAT_MAP_FGT(hdfgwtr2_desc, hdfg=
wtr2_masks,
> =20
> =20
>  static const struct reg_bits_to_feat_map hcrx_feat_map[] =3D {
> +	NEEDS_FEAT(HCRX_EL2_SRMASKEn, FEAT_SRMASK),

[Severity: High]
This isn't a bug introduced by this patch, but a pre-existing issue in
hcrx_feat_map: does the omission of FORCE_RES0(HCRX_EL2_RES0) and
FORCE_RES1(HCRX_EL2_RES1) allow a nested guest to set architecturally reser=
ved
hardware bits?

Because FORCE_RES0(HCRX_EL2_RES0) is omitted from this array, the architect=
ural
RES0 bits (like 63:27, 25, 21:17) are not included in the virtual RES0 mask.
If a nested guest writes a 1 to these RES0 bits, KVM's dynamic mask applica=
tion
in __vcpu_sys_reg() will leave those bits unmodified.

When KVM later transitions to the guest, it will write this unsanitized val=
ue
directly to the host's hardware SYS_HCRX_EL2 register. Can this violate
architectural invariants and trigger CONSTRAINED UNPREDICTABLE behavior or
silently enable unknown future hardware features?

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260702160248.1377=
250-1-maz@kernel.org?part=3D5
