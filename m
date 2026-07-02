Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5782036F8EA;
	Thu,  2 Jul 2026 18:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783017291; cv=none; b=gkbNljRU4uKoJz0NOyUEZImFGfTWtgoWeZwaR923aUoJ90D9DUIpY7Kfawi0G+ZCdnQogvTP8pMOghPgC1TFxjy4ziXa/BrwddC3e9gzsG1pGtj5Q6k/BWqUOUwMQrg41zDj8aGVzncEnMmwJIMJf1EZP49DOlouO3nd0Uqnj0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783017291; c=relaxed/simple;
	bh=rfM2MaieXbLxE400yBYlbqYJ35JfI9bzY82lHqQGwTs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=upLhfkQU63BUh5CEWoFpET/dhsQ3t/A+xfKRY7U2uqmNKOIAuE5GA7NTVUceiPDgUDifvMhtrtbgepWN5lQZjZcAiAuZZ6OL1IAucQ7knhfQsgk7quXSDXHqkJST410pEr9sQWSsn/mIxsi2yhi4jXe00qsd3MctD68NZGjfZAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Sj3xW9c/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Sj3xW9c/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B14E81F000E9;
	Thu,  2 Jul 2026 18:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783017290;
	bh=OOtLZyiO1yv6YfRJ7zDe+xzqYIZsaEXUbBqMX+24dns=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Sj3xW9c/JNp9muAFkUpOM9KYcXmHI4C+XU3/eePH09dXLcu0pO18/PP1Z58kWXRTj
	 cVoYSbkxdPYOLqk35R7hSPf1ofy6mSRu1bLb3aaOZBvUigfDJw9wCwa9Cl6OcWWguE
	 MzTnAfc1c13KRIXAKZmf+4dPekyzamNKpII0xPuMqfS7wsc47OCknTrO3iv9rzCbva
	 XFEeHZ0gXjMRYwRnWR6ZgkrZ3a5HJXEqquWXSHHrZ1T0saBA8fr2YiYv3fhfwGp+ox
	 p11Dg8/ZY1SpifPfZw5QehgQDJWzQjkGPKD2zNebBnsKi/nJIc+7NtL9wAnuX93a7m
	 ngHD3Fm+TJU1Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 04/28] KVM: arm64: Drop __HCRX_EL2_* masks
Reply-To: sashiko-reviews@lists.linux.dev
To: "Marc Zyngier" <maz@kernel.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20260702160248.1377250-5-maz@kernel.org>
References: <20260702160248.1377250-1-maz@kernel.org>
 <20260702160248.1377250-5-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 02 Jul 2026 18:34:49 +0000
Message-Id: <20260702183449.B14E81F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Unsanitized architectural RES0/RES1 bits in HCRX_EL2 allow nested =
guests to enable hidden hardware features and trigger CONSTRAINED UNPREDICT=
ABLE behavior.
--

commit c528765403e37bb993d380c50856d508033ad43a
Author: Marc Zyngier <maz@kernel.org>

KVM: arm64: Drop __HCRX_EL2_* masks

This patch removes the legacy __HCRX_EL2_* masks and the manual RES1
sanitization in get_reg_fixed_bits(). It intends to rely on existing
auto-generated masks and boot-time checks to prevent unhandled bits from
being exploited.

> diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
> index 0622162b089e5..16d8148dc3f12 100644
> --- a/arch/arm64/kvm/config.c
> +++ b/arch/arm64/kvm/config.c
[ ... ]
> @@ -933,7 +933,7 @@ static const struct reg_bits_to_feat_map hcrx_feat_ma=
p[] =3D {
>  };
> =20
> =20
> -static const DECLARE_FEAT_MAP(hcrx_desc, __HCRX_EL2,
> +static const DECLARE_FEAT_MAP(hcrx_desc, HCRX_EL2,
>  			      hcrx_feat_map, FEAT_HCX);

[Severity: High]
This is a pre-existing issue, but hcrx_feat_map lacks FORCE_RES0 and
FORCE_RES1 declarations. Unlike other system register maps, this means
compute_reg_resx_bits() will omit the architectural RES0/RES1 bits from
the KVM masks.

[ ... ]
> @@ -1579,7 +1579,6 @@ struct resx get_reg_fixed_bits(struct kvm *kvm, enu=
m vcpu_sysreg reg)
>  		break;
>  	case HCRX_EL2:
>  		resx =3D compute_reg_resx_bits(kvm, &hcrx_desc, 0, 0);
> -		resx.res1 |=3D __HCRX_EL2_RES1;
>  		break;

[Severity: High]
Does removing this manual mask leave the RES1 bits completely unsanitized?

Since hcrx_feat_map doesn't supply the architectural bits to
compute_reg_resx_bits(), a nested guest might be able to write arbitrary
values to the HCRX_EL2 VNCR page.=20

When KVM reads this in __activate_traps_common(), it only masks
NV_HCRX_GUEST_EXCLUDE before writing directly to the physical SYS_HCRX_EL2:

arch/arm64/kvm/hyp/include/hyp/switch.h:__activate_traps_common() {
        ...
        u64 val =3D __vcpu_sys_reg(vcpu, HCRX_EL2);
        hcrx |=3D (val & ~NV_HCRX_GUEST_EXCLUDE);
        hcrx &=3D ~(~val & ~NV_HCRX_GUEST_EXCLUDE);
        ...
        write_sysreg_s(hcrx, SYS_HCRX_EL2);
}

Could this allow the guest to bypass hypervisor feature emulation or trigger
CONSTRAINED UNPREDICTABLE hardware states?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260702160248.1377=
250-1-maz@kernel.org?part=3D4
