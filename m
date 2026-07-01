Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 480E1347514
	for <kvmarm@lists.linux.dev>; Wed,  1 Jul 2026 20:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782939372; cv=none; b=jO3ZB+ZPjDAaE6K17XWXsPwLPm4c6K7ND+a9fpCUSNV7SWbJNrK06tGiOBSaAn7qbDTBfJKz42UaDz1Qvo8H3VRaOQ4TVxp7HBXCkyDga0GruYBYL4syuiXwnc6rzIHD989j50gSsfte3y3sHYv5HdpV+HrzkFPUs2sJYoEEAvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782939372; c=relaxed/simple;
	bh=lYHvHu/DMj38a13ilyT9SCdihJwz+PKdHRiAsZB9q5M=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Tj6gThinDmk6GnjDOVSw6HUKUFQQMgu7+8IdW30mLzju3zc20Ukkiykfk3iKUya7KiqbDyu+K0ytwMgjZtmBk1ruyiWU3IwHuwxNy71i9hTyhsM+yvjEe7TN47fWxY6LZgcrwkuOuUKnufOgp178kbndC8/LunmfbhuOJog7g7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ur8E5uGb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ur8E5uGb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA5971F000E9;
	Wed,  1 Jul 2026 20:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782939370;
	bh=Z7AIkw6EuF9f8qndTmupN/Zb/7w933pXN4nhkaOTciA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Ur8E5uGbmSz3BqTypW3dJaPrmOzc00Jmirnk6+EIMnFH76xFo7Ecael85j9luO3iC
	 ww0KtMGtbekJTOKG0hM2NeGFF8fBEI4EY4URA8KDKd9LxmQ2TR23/NLnxQlbVAm5Iy
	 ObMeFXc0jNg322lr6xSootmGZHDzJHRoTZC5pWG/1BLqf2iqcBvKQjjAd8FvnsQDAV
	 SfXrHkBGSW5VXfnEw1/JOxbE8FUiqcA0wxjWdaQ/Zwkbu7I7njSUyP5PfVbZWjR47I
	 klnMnHKFpQZeOmSXpbuOpftalobIeho1cqxUsUR1tEl5e94QmQZlO2e8lRr1t7y9dU
	 4tORsHY1ccufA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/5] arm64: Treat HCR_EL2.E2H as RES1 when
 ID_AA64MMFR4_EL1.E2H0 is negative
Reply-To: sashiko-reviews@lists.linux.dev
To: "Colton Lewis" <coltonlewis@google.com>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260701204342.2654385-3-coltonlewis@google.com>
References: <20260701204342.2654385-1-coltonlewis@google.com>
 <20260701204342.2654385-3-coltonlewis@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 01 Jul 2026 20:56:10 +0000
Message-Id: <20260701205610.AA5971F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] The `ubfx` instruction zeroes out the upper bits of `x0`, causing =
the subsequent `tbnz` instruction to test a bit that is unconditionally zer=
o, meaning the branch to the VHE-only boot path is never taken.
--

commit 917edd241242a39cab8dc68759b48cf9583ba1a0
Author: Marc Zyngier <maz@kernel.org>

arm64: Treat HCR_EL2.E2H as RES1 when ID_AA64MMFR4_EL1.E2H0 is negative

This commit tweaks early boot logic in init_el2 to check ID_AA64MMFR4_EL1.E=
2H0
before HCR_EL2.E2H. It aims to properly support CPUs that advertise
VHE-onlyness with a negative E2H0 value. I see this issue was addressed in a
later commit (b196767cce7549b6fb016f11fb98e5c15bbcaa71), but I wanted to po=
int
it out here for the historical record.

Link: https://lore.kernel.org/r/20240122181344.258974-8-maz@kernel.org

> diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
> index 6517bf2644a08..e32c8dd0b17a7 100644
> --- a/arch/arm64/kernel/head.S
> +++ b/arch/arm64/kernel/head.S

[ ... ]

> @@ -589,25 +589,32 @@ SYM_INNER_LABEL(init_el2, SYM_L_LOCAL)
>  	mov_q	x1, INIT_SCTLR_EL1_MMU_OFF
> =20
>  	/*
> -	 * Fruity CPUs seem to have HCR_EL2.E2H set to RES1,
> -	 * making it impossible to start in nVHE mode. Is that
> -	 * compliant with the architecture? Absolutely not!
> +	 * Compliant CPUs advertise their VHE-onlyness with
> +	 * ID_AA64MMFR4_EL1.E2H0 < 0. HCR_EL2.E2H can be
> +	 * RES1 in that case.
> +	 *
> +	 * Fruity CPUs seem to have HCR_EL2.E2H set to RES1, but
> +	 * don't advertise it (they predate this relaxation).
>  	 */
> +	mrs_s	x0, SYS_ID_AA64MMFR4_EL1
> +	ubfx	x0, x0, #ID_AA64MMFR4_EL1_E2H0_SHIFT, #ID_AA64MMFR4_EL1_E2H0_WIDTH
> +	tbnz	x0, #(ID_AA64MMFR4_EL1_E2H0_SHIFT + ID_AA64MMFR4_EL1_E2H0_WIDTH - =
1), 1f

[Severity: High]
Does this tbnz instruction in init_el2 check a bit that was just cleared?

The ubfx instruction extracts the 4-bit field to x0[3:0] and explicitly=20
zero-extends the rest of the register. Since the shift is 24 and the width=
=20
is 4, the bit being tested by tbnz (24 + 4 - 1 =3D 27) will always evaluate=
=20
to zero after the ubfx operation.

Will this cause the kernel to bypass the intended VHE-only boot path and fa=
il=20
to boot in hVHE mode on systems without FEAT_E2H0?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260701204342.2654=
385-1-coltonlewis@google.com?part=3D2
