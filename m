Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CBE67E105
	for <kvmarm@lists.linux.dev>; Mon, 24 Aug 2026 18:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787597779; cv=none; b=h+gSSqma5i793/EhYIn80yWoY5szM7H9SDFdhHo9XHhjKd+U2qdVUL1OyHHUU20h+RZtMf1cpVDqqDHRDTmPyX3WbpeN5lFVt/R6iLHwfMqUtpl+Y7I48CSTOVPvTtUkNWlTgbafgk2ZibKgBGe/M5C1MZV28L03L54W4LWkYJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787597779; c=relaxed/simple;
	bh=iWACwrhd17/iCK/5W0MLyyV6nXGnQzhmiCVLYdYBT9E=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=EwiZMVoOMTTw77SrEPiBtqH2tIEzwyk7xLEe6M/XpkSiwAtRmMF6t9xV1lW0uiIzn+DhO1SHApiGzor0MT7UR0ZT2pPKCsU6Wc/RlIwVSwjpPmxLdOIifAksMi0w3KMLEd59g7IJrVwOG8b9zxmXjgebEJPX51kpBdWMClNY2dM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MRZLmkI0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MRZLmkI0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEC5F1F000E9;
	Mon, 24 Aug 2026 18:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787597778;
	bh=Ud0nZqIIziLKGuHOgjXNyh0AaCyR7FfpJfi1gu36FUo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=MRZLmkI03Z6IpKd8AhLHPy73G3v2/iHQ44sOZ+KNM1WPmh+ti4dgYUJmxgGYIPdQY
	 XwZwUb9miX/RXr9dlOxi63GcHm3kOnRicdN0U/c0cmnr8IHi8Km3nTNE+6S2HjksXy
	 Jm7yxff/ZZKJmCpSm4hRmDE+3OmZVOZEJL8kzBlq44zoseKAwbcoNAUBRXNBCU3MAS
	 Y+TLJqFflkBpcp11NnjggDP4YeVM+5YZW3Ow/ndDpzSxl7iioVAy4ZIWeWJvCLPA+v
	 Pd2j/EKmswmJ4ntkFT9QSVTFl/4D1Z3/itnOPbZAF3sXgVmP0eOG6OgNxIX1L0Xc13
	 Ere4hhIOS3UMQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3] arm64: Don't read GMID_EL1 when MTE is disabled
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fuad Tabba" <fuad.tabba@linux.dev>
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260824184155.2644646-1-fuad.tabba@linux.dev>
References: <20260824184155.2644646-1-fuad.tabba@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 24 Aug 2026 18:56:17 +0000
Message-Id: <20260824185617.EEC5F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Kernel panic on non-MTE hardware caused by unsanitized command-lin=
e overrides in gmid_el1_accessible().
--

--- Patch [1]: [PATCH v3] arm64: Don't read GMID_EL1 when MTE is disabled -=
--
commit ff2144eb5268c6bf4e244c7063fffca15d574919
Author: Fuad Tabba <fuad.tabba@linux.dev>

arm64: Don't read GMID_EL1 when MTE is disabled

This patch prevents __cpuinfo_store_cpu() from reading the GMID_EL1 register
when MTE is disabled, avoiding a host panic when pKVM injects an UNDEF. It
introduces a new helper to check if MTE is accessible by evaluating both
CONFIG_ARM64_MTE and the raw ID_AA64PFR1_EL1 combined with command-line
overrides.

Cc: stable@vger.kernel.org

> diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm=
/cpufeature.h
> index d90040fb9de6c..aaf267c7eb243 100644
> --- a/arch/arm64/include/asm/cpufeature.h
> +++ b/arch/arm64/include/asm/cpufeature.h
[ ... ]
> @@ -1085,6 +1085,21 @@ static inline bool cpu_has_lpa2(void)
>  #endif
>  }
> =20
> +/*
> + * Reading GMID_EL1 when the kernel has disabled MTE traps to EL2, and t=
he raw
> + * ID_AA64PFR1_EL1 reflects neither CONFIG_ARM64_MTE nor the cmdline ove=
rride.
> + */
> +static inline bool gmid_el1_accessible(u64 pfr1)
> +{
> +	if (!IS_ENABLED(CONFIG_ARM64_MTE))
> +		return false;
> +
> +	pfr1 &=3D ~id_aa64pfr1_override.mask;
> +	pfr1 |=3D id_aa64pfr1_override.val;
> +
> +	return id_aa64pfr1_mte(pfr1);
> +}

[Severity: High]
Does this manual application of the command-line override bypass the standa=
rd
feature sanitization?

If a user specifies a command-line override to explicitly enable MTE on
hardware that does not natively support it (e.g., id_aa64pfr1.mte=3D1), this
code applies the raw id_aa64pfr1_override directly.

Normally, the cpufeature framework uses arm64_ftr_safe_value() to drop unsa=
fe
overrides that attempt to enable unimplemented hardware features. Because t=
his
function skips that sanitization, it will return true for an invalid overri=
de,
leading to an UNDEF exception and kernel panic when __cpuinfo_store_cpu()
subsequently attempts to read the unallocated GMID_EL1 register.

Could this check be adjusted to use a sanitized value or ensure unsafe
overrides are safely ignored?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260824184155.2644=
646-1-fuad.tabba@linux.dev?part=3D1
