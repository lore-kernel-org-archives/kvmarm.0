Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A7871F3D56
	for <kvmarm@lists.linux.dev>; Tue, 25 Aug 2026 05:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787635131; cv=none; b=UyXuRwMw4rpFCuhpGQe3EpCQSJUHaT0JM+t61ftGXg1XA+f5jNItVSDQBwur34zwajG2wotslOWGCncv/HWNNWACMFeJlY0phkEElI6WrsJWfzEDtEh6lPopZTWZZdWcf2TRUpg3ya1tQrxx/fhcoZc2AUV0oKCOUuyYPholtRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787635131; c=relaxed/simple;
	bh=qWOsz5UmTYiTYnLzOOMGSUOqII493WgqGkCH0aw+ssM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=SuDeqU0Egu3YeUceChFym3Cx+0GhdW+TyBe14gUhKRwuhHX9X9wrU64Dr6ZodG+7VZB+FEyVDfKrVtX3woWqaDv4ovhGic3Nc4hIftbkqlCVTOCCI0lRXR3kY73pUmWY/A43Mq7wRG+TSCdZr3RWpgOTUEvm5A0zYLlFuEbDig4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dKDGy1Qk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dKDGy1Qk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72F691F000E9;
	Tue, 25 Aug 2026 05:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787635129;
	bh=FidoLps9L8YFy3buwGQs8VqWjJXTCiXLehpwAfffUEU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dKDGy1QkbTPEw9Apzgcg/XEBzEIShROCIdkl5DxdqjrE8x6E1TX63ILtR51RNE2xJ
	 IFkhvhGfiuzITRHdVzJGs1jzEgiXoPpa2dRNzn+MFzn4hZmXtPgOxV6wSA4uv+ZI1f
	 QD43zywhBRxwPXc7y3BH466Wpkn3BuXqoXrGFENTBZ3DoE05/2HIfasR2jbASxc4ZX
	 p0GK2SN6WsLik/nRAhSTSwTUKeUTUO1lsoWBITQh3qr0xAGge5bkJJ0/nP7Cw6MjNa
	 NqgAnYVr8ES/b2TxmxqtesvIJkh3z1y+MDqiyV4bqdoOGRV9qPeZdvplrrpCFV0QGw
	 c3D9IwXg0TaRA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] KVM: arm64: Honour the SPMC FF-A RX/TX buffer size
 limits
Reply-To: sashiko-reviews@lists.linux.dev
To: "Kim Mankyum" <mankyum.kim@samsung.com>
Cc: "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260825-master-v2-1-f8af766d1f34@samsung.com>
References: <20260825-master-v2-1-f8af766d1f34@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 25 Aug 2026 05:18:48 +0000
Message-Id: <20260825051849.72F691F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] pKVM falsely returns FFA_RET_NOT_SUPPORTED for FFA_FEATURES(FFA_RX=
TX_MAP) if the negotiated RX/TX buffer size is not exactly 4K, 16K, or 64K.
--

--- Patch [1]: [PATCH v2] KVM: arm64: Honour the SPMC FF-A RX/TX buffer siz=
e limits ---
commit c54f99ee793f554a1aaa1ae79c05911b9c5014aa
Author: Kim Mankyum <mankyum.kim@samsung.com>

KVM: arm64: Honour the SPMC FF-A RX/TX buffer size limits

This commit updates pKVM to negotiate the FF-A RX/TX buffer size with the
SPMC instead of defaulting it to PAGE_SIZE. It computes the supported size
in hyp_ffa_post_init(), stores it in hyp_ffa_rxtx_sz, and exposes it to the
host via FFA_FEATURES.

Link: https://patch.msgid.link/20260820-master-v1-1-ea602b6d3860@samsung.com

> diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> index a327c2bbb6b64..c3379d1e8fd74 100644
> --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
[ ... ]
> @@ -723,6 +732,26 @@ static bool do_ffa_features(struct arm_smccc_1_2_reg=
s *res,
>  	}
> =20
>  	switch (id) {
> +	case FFA_RXTX_MAP:
> +	case FFA_FN64_RXTX_MAP:
> +		switch (hyp_ffa_rxtx_sz) {
> +		case SZ_4K:
> +			prop =3D FFA_FEAT_RXTX_MIN_SZ_4K;
> +			break;
> +		case SZ_16K:
> +			prop =3D FFA_FEAT_RXTX_MIN_SZ_16K;
> +			break;
> +		case SZ_64K:
> +			prop =3D FFA_FEAT_RXTX_MIN_SZ_64K;
> +			break;
> +		default:
> +			ret =3D FFA_RET_NOT_SUPPORTED;
> +		}
> +

[Severity: High]
If the SPMC negotiates an intermediate buffer size, won't this switch fall
through to the default case and return FFA_RET_NOT_SUPPORTED?

For example, hyp_ffa_post_init() can compute an 8K size if max_rxtx_sz is 8K
and the capacity is larger:

hyp_ffa_post_init() {
	...
	max_rxtx_sz =3D FIELD_GET(FFA_FEAT_RXTX_MAX_SZ_MASK, res.a2) * FFA_PAGE_SI=
ZE;
	if (max_rxtx_sz && max_rxtx_sz < min_rxtx_sz)
		max_rxtx_sz =3D min_rxtx_sz;

	/* A maximum of 0 means the SPMC does not enforce an upper bound. */
	hyp_ffa_rxtx_sz =3D min(max_rxtx_sz ?: capacity, capacity);
	...
}

Should do_ffa_features() be updated to handle intermediate sizes like 8K or
32K, instead of strictly requiring an exact match for 4K, 16K, or 64K?

> +		if (!ret && hyp_ffa_version >=3D FFA_VERSION_1_2)
> +			prop |=3D FIELD_PREP(FFA_FEAT_RXTX_MAX_SZ_MASK,
> +					    hyp_ffa_rxtx_sz / FFA_PAGE_SIZE);
> +		goto out_handled;
>  	case FFA_MEM_SHARE:
[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260825-master-v2-=
1-f8af766d1f34@samsung.com?part=3D1
