Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7803346AF2C
	for <kvmarm@lists.linux.dev>; Thu, 17 Sep 2026 21:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789681906; cv=none; b=jvAHab0mwtlkp14KHaY2aK1URhIcySHi3ThL+UZrS4EmvsqESfDgkQcDtdJRzVUZ2LrXS1ykSmNhJTgqmpHI6Ml2xJYCW9NWupa4ji7nHJKkI7++i88fea0HSoZ2MnmUCbxXKjVhhKEljf/Q/67zmMOKdyOqXEa8iVBXwiCMLx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789681906; c=relaxed/simple;
	bh=wcUbYXBnoW7eYkJDDIrDGvUwANZrcJclSbmZvJXcfag=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=fjdAdP0m7bm34nEdQiPEz4OLnbpymgfz/rWxCm9f7OvC2DXCisuxyt1mE+0gFMY36aCs1+h17wOqJv2smaOQyfXBwrA88pkk6oDTT04r15XDF5/Q9umgmJmubgUrRul4z4FQNFzydRr0Gs8N2CYlIEtCfvilzHEDcZCoiAirAco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MyKNtqIs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MyKNtqIs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B50A91F000FF;
	Thu, 17 Sep 2026 21:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789681905;
	bh=39MN9e30GmgqXpOq5gcOzcTElnpqc84j7OnAkUyubOs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=MyKNtqIsWKWZ0KrC9iq6Q1u+3g3R4GvK6so54gT+wcGAsfCySkDeqfDGsNyQgtXhw
	 13s4gSsGqc33SDQiAHiXGj4yaF8ta1AWfrd/sbgLZLngkEEqpG6w3QdpKnGA4eunFO
	 lE8VTXNdoGsolZUx8WfOS7rJBRJve6RNk1IKaIuyvehpb3/PCRvN0YtruTTEnMtEuh
	 zV0P3cGsS4xDr5Vzutnp/ZUgM0jkSqF2pqOqQh1GS0WTma4vwFeXxtt7O3I3+mRTcu
	 S41udkoPVqOR8tOX+VllHCK8NX6AIEwy5Qmp16ieksVmxcTKRSqop6+JGYvAvfqcel
	 ivyLNUoDblkTA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 1/4] KVM: arm64: nv: Don't advertise FEAT_LPA2 for
 guest stage-1
Reply-To: sashiko-reviews@lists.linux.dev
To: "Wei-Lin Chang" <weilin.chang@arm.com>
Cc: "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20260917214215.74135-2-weilin.chang@arm.com>
References: <20260917214215.74135-1-weilin.chang@arm.com>
 <20260917214215.74135-2-weilin.chang@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 17 Sep 2026 21:51:44 +0000
Message-Id: <20260917215144.B50A91F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] arm64: kvm: exact equality check for FEAT_LPA2 leaks future CPU =
features to guest
--

commit 04c3c148ddb66ae2c7e9c401ce8ccd1c725fafd5
Author: Wei-Lin Chang <weilin.chang@arm.com>

KVM: arm64: nv: Don't advertise FEAT_LPA2 for guest stage-1

This commit sanitizes ID_AA64MMFR0_EL1 to prevent advertising FEAT_LPA2
to nested guests for non-stage-2 granule size fields (TGRAN4, TGRAN16).
It explicitly clears and resets the fields to IMP when the 52-bit values
are detected.

> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c

[ ... ]

> @@ -1731,6 +1731,17 @@ u64 limit_nv_id_reg(struct kvm *kvm, u32 reg, u64 =
val)
>  		/* Hide CNTPOFF if present */
>  		val =3D ID_REG_LIMIT_FIELD_ENUM(val, ID_AA64MMFR0_EL1, ECV, IMP);
> =20
> +		/* NV does not support FEAT_LPA2. */
> +		if (SYS_FIELD_GET(ID_AA64MMFR0_EL1, TGRAN4, val) =3D=3D ID_AA64MMFR0_E=
L1_TGRAN4_52_BIT) {
> +			val &=3D ~ID_AA64MMFR0_EL1_TGRAN4;
> +			val |=3D SYS_FIELD_PREP_ENUM(ID_AA64MMFR0_EL1, TGRAN4, IMP);
> +		}

[Severity: Medium]
Could this exact equality check fail to cap future values of TGRAN4?

If a future hardware extension introduces a CPUID value where TGRAN4 is
greater than ID_AA64MMFR0_EL1_TGRAN4_52_BIT, this condition would be
bypassed. This could expose unsupported capabilities to nested guests on
future hardware, potentially leading to guest crashes or page table
corruption when the guest attempts to use 52-bit translation granules.

> +
> +		if (SYS_FIELD_GET(ID_AA64MMFR0_EL1, TGRAN16, val) =3D=3D ID_AA64MMFR0_=
EL1_TGRAN16_52_BIT) {
> +			val &=3D ~ID_AA64MMFR0_EL1_TGRAN16;
> +			val |=3D SYS_FIELD_PREP_ENUM(ID_AA64MMFR0_EL1, TGRAN16, IMP);
> +		}

[Severity: Medium]
Similarly, could this equality check leak future values of TGRAN16 greater
than ID_AA64MMFR0_EL1_TGRAN16_52_BIT?

Would it be safer to handle both of these limits using
ID_REG_LIMIT_FIELD_ENUM instead of exact equality checks to ensure
future monotonic CPUID values remain properly capped?

> +
>  		/* Disallow unsupported S2 page sizes */
>  		switch (PAGE_SIZE) {

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917214215.7413=
5-1-weilin.chang@arm.com?part=3D1
