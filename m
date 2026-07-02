Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 078EA414DE1;
	Thu,  2 Jul 2026 16:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009714; cv=none; b=V3sAb7A2CdZnGm/m//I3xl7zE8zNa1PAGc+lMN7iMFpYIPELViSca+nVs8Ek9Tz1xgjCX7qA5nBfLWiaYG1JaqIHaxM4x6raar4Ibf8jg/LmYCMvx4id8/b9WWIi7hzZ2Uuk3C2LZZRKb2dJmo4nyF+ceOAHbF79uLuHtLM27ws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009714; c=relaxed/simple;
	bh=+fnMyEA1SoLoFVyArlLnj1I0RH+5p6l+jG22xG5NWtY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Ft1W0xxy715aqABeodK3Mt69Gw77kdgzl3Hs5xzdJOg1a9aC8qubBDfiNv6OC2req0JGJH8Mz3VsJA9tO9rklnMA9PgIoLvRYtmSWHnKzQ2tcinrZpdCnAxzqdE5hZI+2OrlMtM5JIx+5N6FX4ic25S9Nlm0McusaXlMBZhBbQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lHKrH05m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lHKrH05m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D2661F00A3D;
	Thu,  2 Jul 2026 16:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783009711;
	bh=xqjSxXSxkFnMe7xvsCuCNhfIuUZJwk7JvxoqbN3voQg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lHKrH05mX3+v9mk2AcMFBAupzydcPSJYEGnvoBp28c9uDkPrR90kubYh6w9KnTxeK
	 waYBkN2d3Lvz3YA3nxIv7AZDnL+I0HRr5SkEavO+c1/OgvtkKBU+NZ+w4zramOs1B6
	 d1rx/M+X0EkMDRUIrlXZncTNfHWaXn1TEnWfriq2BmD8KjlvYZHq+8jNU4NyEVWbNq
	 IQsn2fWAJZivlTRESfdL9ZgJjr4ULzDkH3VE/dhy5FCToOXjHoZeAAtkkmMBf+0AyA
	 pTICroSPiz8ARfvDh8NbLe2y6jTg6yQTmpZ89tfQYIa9FDPgrHQUdynMWjF2e1+A0f
	 PahSzKrzRxHzg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 11/28] KVM: arm64: Expose FEAT_NV2p1 to NV guests
Reply-To: sashiko-reviews@lists.linux.dev
To: "Marc Zyngier" <maz@kernel.org>
Cc: kvm@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260702160248.1377250-12-maz@kernel.org>
References: <20260702160248.1377250-1-maz@kernel.org>
 <20260702160248.1377250-12-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 02 Jul 2026 16:28:30 +0000
Message-Id: <20260702162831.4D2661F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Inconsistent preservation of `ID_AA64MMFR4_EL1` feature fields bas=
ed on host support for `ARM64_HAS_NV2P1` (and later `ARM64_HAS_NV3`), leadi=
ng to uncontrolled UAPI feature leaks and migration breakages.
--

commit 11eacfaa8962f15232e1ae99c1e9f7d1dfee6846
Author: Marc Zyngier <maz@kernel.org>

KVM: arm64: Expose FEAT_NV2p1 to NV guests

This commit exposes the FEAT_NV2p1 feature to nested virtualization guests.
It does so by updating the ID_AA64MMFR4_EL1 feature register limits in
limit_nv_id_reg() based on host support.

> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -1740,7 +1740,11 @@ u64 limit_nv_id_reg(struct kvm *kvm, u32 reg, u64 =
val)
>  		if (test_bit(KVM_ARM_VCPU_HAS_EL2_E2H0, kvm->arch.vcpu_features)) {
>  			val =3D 0;
>  		} else {
> -			val =3D SYS_FIELD_PREP_ENUM(ID_AA64MMFR4_EL1, NV_frac, NV2_ONLY);
> +			if (cpus_have_final_cap(ARM64_HAS_NV2P1))
> +				val =3D ID_REG_LIMIT_FIELD_ENUM(val, ID_AA64MMFR4_EL1, NV_frac, NV2P=
1);
> +			else
> +				val =3D SYS_FIELD_PREP_ENUM(ID_AA64MMFR4_EL1, NV_frac, NV2_ONLY);

[Severity: High]
Does this introduce inconsistent preservation of ID_AA64MMFR4_EL1 feature f=
ields?

When the host supports NV2P1, KVM uses ID_REG_LIMIT_FIELD_ENUM(), which only
modifies the NV_frac field and preserves the rest of the original val. This=
=20
means the guest will inherit other host-populated feature bits from
ID_AA64MMFR4_EL1 (like ASID2, HACDBS, FGWTE3, etc.).

However, if the host is NV2-only, it falls back to the original assignment
using SYS_FIELD_PREP_ENUM(), which effectively wipes out all other fields in
val.

Could this uncontrolled feature leak cause guest-visible state divergence b=
ased
on the underlying hardware and break live migration?

>  			val &=3D ~ID_AA64MMFR4_EL1_E2H0;
>  			val |=3D SYS_FIELD_PREP_ENUM(ID_AA64MMFR4_EL1, E2H0, NI_NV1);
>  		}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260702160248.1377=
250-1-maz@kernel.org?part=3D11
