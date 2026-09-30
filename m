Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8A1A4D8D93
	for <kvmarm@lists.linux.dev>; Wed, 30 Sep 2026 22:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790806472; cv=none; b=HrcwYZ7AncvVKqXEQ8kN2y4wBjhkOiDu3VPxmyLX2+PsTQ88uMo0Ko4cRIIyWQGJsw6oF2ubVkZ1KJwViHmNVZQw5uvLYqj1fFTBcyAI4IhTQzUVOFIHzoeT+xTqwpwRVfxpTVfjm1v71Z10CbhwVVWv42KEYV1IPvz6k4yhoH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790806472; c=relaxed/simple;
	bh=DD2ChJDZgs8K9aSaGOYPMda61mrpTtplqwFwDl6UiVQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=T6Ob+d0qKr6m1Q+CYcbFFSqNQ24PyqhUyHtGoDB1MwwvtyFTEp92U1fdNwwut7AfyqlD1lJqz1BuJBGHjAQZjksM4itlLjro5xhxrxekTsAW5QLsV4y1pCcvTO1wkbqbpLOKgOGvdm/jpjEQu9Gefkz7msUq6xT4/PQK7uEoYbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FhMljKDI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FhMljKDI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A7291F000FF;
	Wed, 30 Sep 2026 22:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790806470;
	bh=cctNTqKtVUYy6+6vzwwagGb9rbHgKyqcWT9g12HXSbQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FhMljKDIFoBibaGt0b6a/vM1a0jD61C+O6jQiv8wPzQUYCrET1PoaoWbYjYiIlOHt
	 0Ok7kIptNCdRU1kJQMdk9UVyCcqJ/FCibNKz9dKrgYXCwXl+uuoEpo/6Jul4pI6FrK
	 2LHM6DWn/fYzzDUY0ReYkXGwqv++xClswnSTlI+QpG/gnPqXXrP35X18HDtwcDe/Cb
	 IX5tDnL7x9fX1RFhYtNpZ4eWlcok83Cg/pGWt8ORJ/XvFQLBtXD9CO/MXkNnXIl6qP
	 aqzL/nWEOLirlaNjccEI3qSotNAcUYXqZqZgRaPs8SVfUcKbQEfwx1hboocmIcPw2a
	 WKc4xUujcTN/g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v21 14/15] tools: Synchronise the kernel esr.h
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mark Brown" <broonie@kernel.org>
Cc: "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260930-arm64-gcs-v21-14-3556644cd927@kernel.org>
References: <20260930-arm64-gcs-v21-0-3556644cd927@kernel.org>
 <20260930-arm64-gcs-v21-14-3556644cd927@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 30 Sep 2026 22:14:29 +0000
Message-Id: <20260930221430.3A7291F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] tools: incorrect mapping of ESR_ELx_FSC_ADDRSZ_nL for level -1
--

commit 29c713adc7b9f4531e116d3021bff33ab6d602a4
Author: Mark Brown <broonie@kernel.org>

tools: Synchronise the kernel esr.h

This commit synchronizes the tools version of the arm64 esr.h header with
the main kernel header to pick up definitions for GCS.

> diff --git a/tools/arch/arm64/include/asm/esr.h b/tools/arch/arm64/includ=
e/asm/esr.h
> index f3c6403e5ef2b..24c6ebe3fd416 100644
> --- a/tools/arch/arm64/include/asm/esr.h
> +++ b/tools/arch/arm64/include/asm/esr.h
[ ... ]
> @@ -119,6 +123,16 @@
>  #define ESR_ELx_FSC_SEA_TTW(n)	(0x14 + (n))
>  #define ESR_ELx_FSC_SECC	(0x18)
>  #define ESR_ELx_FSC_SECC_TTW(n)	(0x1c + (n))
> +#define ESR_ELx_FSC_EXCL_ATOMIC	(0x35)
> +#define ESR_ELx_FSC_ADDRSZ	(0x00)
> +
> +/*
> + * Annoyingly, the negative levels for Address size faults aren't laid o=
ut
> + * contiguously (or in the desired order)
> + */
> +#define ESR_ELx_FSC_ADDRSZ_nL(n)	((n) =3D=3D -1 ? 0x25 : 0x2C)

[Severity: Medium]
Does this ESR_ELx_FSC_ADDRSZ_nL macro incorrectly map level -1 Address
Size faults to 0x25 instead of 0x29?

If tools/arch/arm64/include/asm/esr.h is meant to be synchronized with the
kernel header, diverging here causes user-space tools (such as KVM selftests
or perf) to misdecode or incorrectly inject Address Size faults for level -=
1.
Any tool compiling against this header and invoking ESR_ELx_FSC_ADDRSZ_L(-1)
would receive 0x25 rather than the correct hardware encoding 0x29.

> +#define ESR_ELx_FSC_ADDRSZ_L(n)		((n) < 0 ? ESR_ELx_FSC_ADDRSZ_nL(n) : \
> +						   (ESR_ELx_FSC_ADDRSZ + (n)))
> =20
>  /* Status codes for individual page table levels */
>  #define ESR_ELx_FSC_ACCESS_L(n)	(ESR_ELx_FSC_ACCESS + (n))

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260930-arm64-gcs-=
v21-0-3556644cd927@kernel.org?part=3D14
