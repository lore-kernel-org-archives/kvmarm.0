Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E079DDA9;
	Thu,  2 Jul 2026 16:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010053; cv=none; b=XKFVqVBt/zKiXAyZq0C3+JtLEUdL80mV9Zq3FmsvH2aTV8sTokvzBP68JwEaZOZ2wMiJ8zUwYE922Um/vRmtCxdO73ithKVvxPWO+wo9rCK+5X31orIdaADCspCZX/0HlVIaMZOOGSlHcnjVCC8MxEt87ASR9NwyQ6rhuihKSqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010053; c=relaxed/simple;
	bh=/BwVKU4/EYRGzGudRNMo3XVmKsBCRZpDRhEbdBbzKoM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=aQhWjSYJY9s4qHyR+Cc8CF8CAe+OfAUiteFBZVShqsJPLT/mUT5hyv/C3rfi+Q4RWnuSTXld5cQ5W3jRqcqATtYKHgur6dZ4UNIIfETOtZmWHG82tS5u+tUz9Tg+EAID6B7jOG6JS11SvTVwywPl5CA01kPr8d/iAd997Y+li/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jfbXkmcI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jfbXkmcI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2F861F00A3E;
	Thu,  2 Jul 2026 16:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783010052;
	bh=AwmSoyC+R3Nkde5sRhhpB73YmX0vapTyXLf5K9Mx7E4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jfbXkmcIHprpY8IJhUTOmn9MX7bixJTIHzr6ekF5bEHD0PdDzwH83UoqxZo5H+uZQ
	 TiBrOqsRxScKwwlj7BXyOyk8fqWJyH01U9Kl+yrAGu0kxX1GPUZcGRaG57Ld4nlwEX
	 oKQU6OXiITg5wRCr1bEkABC2ZcEaTeUrtJcH6/LXFsJd8xT3QTicvasHHayRbxXFVc
	 Dnz60NODYO/puM8YCfJz/bYz8ScyUhVq+kKR8VS+4EaKdk3UkvSDedotAcNQRvMxQ9
	 j4ftd4XNp4tfUKSPCwM7dkHmSisnCy3WLw+F728X/4OcJ0Mte9cgJw/UCwazIpdkVv
	 PVvH18ywP5B2Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 03/28] KVM: arm64: Merge guest's HCRX_EL2 using
 NV_HCRX_GUEST_EXCLUDE
Reply-To: sashiko-reviews@lists.linux.dev
To: "Marc Zyngier" <maz@kernel.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20260702160248.1377250-4-maz@kernel.org>
References: <20260702160248.1377250-1-maz@kernel.org>
 <20260702160248.1377250-4-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 02 Jul 2026 16:34:11 +0000
Message-Id: <20260702163411.C2F861F00A3E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Missing RES0 Sanitization / Unsafe Register Merge for HCRX_EL2
--

commit a8dae7a323ff7e33355d5cb4c144294087a9bbfa
Author: Marc Zyngier <maz@kernel.org>
KVM: arm64: Merge guest's HCRX_EL2 using NV_HCRX_GUEST_EXCLUDE

This commit changes how the guest-provided HCRX_EL2 value is merged with
the host's value. It replaces positive masking with an exclusion list
of bits that the guest is not allowed to override.

> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp=
/include/hyp/switch.h
> index 4bf624a49591d..8e5f492f39086 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h

[ ... ]

> @@ -350,8 +368,8 @@ static inline void __activate_traps_common(struct kvm=
_vcpu *vcpu)
>  		u64 hcrx =3D vcpu->arch.hcrx_el2;
>  		if (is_nested_ctxt(vcpu)) {
>  			u64 val =3D __vcpu_sys_reg(vcpu, HCRX_EL2);
> -			hcrx |=3D val & __HCRX_EL2_MASK;
> -			hcrx &=3D ~(~val & __HCRX_EL2_nMASK);
> +			hcrx |=3D (val & ~NV_HCRX_GUEST_EXCLUDE);
> +			hcrx &=3D ~(~val & ~NV_HCRX_GUEST_EXCLUDE);

[Severity: High]
Does this allow an untrusted L1 guest to write garbage to the
architecturally RES0 bits of the physical HCRX_EL2 register?

By switching from a positive mask to a negative exclusion mask, any bits
not explicitly excluded are now merged into the host value.

If the guest modifies its VNCR page at the VNCR_HCRX_EL2 offset and sets
RES0 bits, these bits would be passed through. Since hcrx_feat_map lacks
FORCE_RES0(HCRX_EL2_RES0), KVM's register mask application in
kvm_vcpu_apply_reg_masks() will fail to clear them before they reach this
merge point in __activate_traps_common().

Could this lead to unpredictable behavior if the physical hardware
register is written with garbage in those RES0 bits?

>  		}
> =20
>  		ctxt_sys_reg(hctxt, HCRX_EL2) =3D read_sysreg_s(SYS_HCRX_EL2);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260702160248.1377=
250-1-maz@kernel.org?part=3D3
