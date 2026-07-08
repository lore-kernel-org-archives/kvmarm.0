Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B99B626158B
	for <kvmarm@lists.linux.dev>; Wed,  8 Jul 2026 22:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783551570; cv=none; b=CR3oshVYRRcV1dgR1rBi4zupYYyx2nXHLhH4YUjTRMQ6yEYm6yGOTUnC76WhTqWtKrEz3k2+XkEBrjJOW3QQMmykzcG6elDuo+gJYRPmuBLt5c21HEywRT9e6KvBGxO1/MdukEEU54jYE/C9C7eIvnWKbEaxxfBepNg+p9Bq59U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783551570; c=relaxed/simple;
	bh=KlUaHVEe++9WD9V49EqQNsbmJnOn1MAAFCMQijbxpkw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=T3ygTH8yRagqST6NcYtP6y7uOSt8gNK82MQ68CChgagcvF2pxFZmJIBhyCqmarij029BY118PgfwxUkOqEn3vNxxb7gPlj3JT+8D/F2SMHNUmcbtc4kCddIQfpxr4t1Qyhcvl3PdKgIpiiFCAwcxNE7KGubZE/LjMwhGCiB9Rfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WBoR/ccz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WBoR/ccz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D8841F000E9;
	Wed,  8 Jul 2026 22:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783551568;
	bh=qiqISiNFs1AGzYhRUG67sY7skaj3Lb5IS+CtinetH8s=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WBoR/cczmF8ByU6CWhWbPQB5Rs/RCTrdJtic785Tk9gNEFrFPgFBAhbGHPcn/WNlV
	 LLdkqiy949MDeYv1RfagLhieeFVNEIPkcVBuDhryQ/f9KiEeEIdtc1FNa7AGUgzFjs
	 h09dbNfVc12A6wsY0uFHaSP6HLkpviRTOxU+qSQH3D2JYafnZPKoCzfrL6m3MA8LHY
	 tQFJqYvuFVp497EIHwzRcwn8R1d0eNKU9ogcSwQxYG+6Y9AIdUL3/YZlyekfkDSdYO
	 Hk/Iw/9tmGipDPozfiMrcACRTSfuvSuqWbYF7wWVYXcK35fRqrIlmsejv8HMVqE6Uh
	 iDwwH7q8TrWgA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 6.6 v2 2/6] arm64: Treat HCR_EL2.E2H as RES1 when
 ID_AA64MMFR4_EL1.E2H0 is negative
Reply-To: sashiko-reviews@lists.linux.dev
To: "Colton Lewis" <coltonlewis@google.com>
Cc: kvmarm@lists.linux.dev, "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20260708225124.4130846-3-coltonlewis@google.com>
References: <20260708225124.4130846-1-coltonlewis@google.com>
 <20260708225124.4130846-3-coltonlewis@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 08 Jul 2026 22:59:27 +0000
Message-Id: <20260708225928.0D8841F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [High] The feature check for `ID_AA64MMFR4_EL1.E2H0 < 0` will always eval=
uate to false because `tbnz` tests a bit that has been unconditionally clea=
red by `ubfx`.

Pre-existing issues:
- [High] Writes to control-plane system registers (`SYS_SCTLR_EL12` and `sc=
tlr_el1`) are not immediately followed by an `isb()` instruction.
--

--- Patch [2]: [PATCH 6.6 v2 2/6] arm64: Treat HCR_EL2.E2H as RES1 when ID_=
AA64MMFR4_EL1.E2H0 is negative ---
commit c23e23c763b1ca2a9cc5f6843036bd8b47bf9194
Author: Marc Zyngier <maz@kernel.org>

arm64: Treat HCR_EL2.E2H as RES1 when ID_AA64MMFR4_EL1.E2H0 is negative
   =20
For CPUs that have ID_AA64MMFR4_EL1.E2H0 as negative, it is important
to avoid the boot path that sets HCR_EL2.E2H=3D0. This patch tweaks init_el2
to look at ID_AA64MMFR4_EL1.E2H0 first.
   =20
Link: https://lore.kernel.org/r/20240122181344.258974-8-maz@kernel.org

> diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
> index 6517bf2644a08..e32c8dd0b17a7 100644
> --- a/arch/arm64/kernel/head.S
> +++ b/arch/arm64/kernel/head.S
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
Does this bit test evaluate correctly? The ubfx instruction extracts 4 bits
starting at the shift and places them into bits 3:0 of x0, zero-extending
the rest of the register.

However, the tbnz instruction here tests a bit based on the original shift
amount plus the width minus 1. Because the upper bits of x0 are
unconditionally cleared by ubfx, will this branch ever be taken?

> +
>  	mrs	x0, hcr_el2
>  	and	x0, x0, #HCR_E2H
> -	cbz	x0, 1f
> -
> +	cbz	x0, 2f
> +1:
>  	/* Set a sane SCTLR_EL1, the VHE way */
>  	pre_disable_mmu_workaround
>  	msr_s	SYS_SCTLR_EL12, x1
>  	mov	x2, #BOOT_CPU_FLAG_E2H

[Severity: High]
This is a pre-existing issue, but does this system register write need an
immediate isb()?

According to ARM64 context synchronization rules, writes to control-plane
system registers like SYS_SCTLR_EL12 must be followed by an isb() as the
very next instruction. Here, a mov instruction intervenes, which might
observe architecturally undefined pipeline state.

> -	b	2f
> +	b	3f
> =20
> -1:
> +2:
>  	pre_disable_mmu_workaround
>  	msr	sctlr_el1, x1
>  	mov	x2, xzr

[Severity: High]
This is a pre-existing issue, but is the nVHE path missing an isb() here
as well?=20

Similar to the VHE path above, msr sctlr_el1, x1 is immediately followed by=
 a
mov instruction rather than a synchronization barrier.

> -2:
> +3:
>  	__init_el2_nvhe_prepare_eret

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260708225124.4130=
846-1-coltonlewis@google.com?part=3D2
