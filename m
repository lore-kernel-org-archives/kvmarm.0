Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 663C8494833
	for <kvmarm@lists.linux.dev>; Thu,  1 Oct 2026 12:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790858429; cv=none; b=FPt0Uzqhtm88KaoI0F09oTkm9G1bhEk7NiqCfkfpH/ma53k1fQTgq/XdBX3EzzWTyUXGvA9GqduQA5OTdS0KG7WVc9pcT1IKE+FZA6ZiH1t8Ry1rgiJJtxsYp0d2DyyeGJwbvA/jryFDssIzp8+x/tt3sty6jMPHbCeaQCmLsKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790858429; c=relaxed/simple;
	bh=p9Bt9snaGXFi5lQNeISUaahtli2d4y4fOslP8S6mzQA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=HLL6QfvjLuSVvhJgumHXObMeRmSmcImlHdZg4oNUj1paPflaohjsaJUV3tby+F/zyQUOavJC/YK1K7Ntg0H45YD5ZsxVDxHxge32RJmTLT0EOzUHXIY/3DI9+VcwxncYUMWd4j8pee3jTbBKpwbABQ51D2ZRwSgh6obovttsLMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q8XgB+x4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q8XgB+x4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF2FE1F00899;
	Thu,  1 Oct 2026 12:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790858428;
	bh=+CiVGsmn580atI76xUXeV3XSZbCfcdUr0U0Ge9qPZbI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Q8XgB+x4WCHeEQjhAdALNEFvccaDAoyEinOk7W2JBfb7HqknQr1ZS0Ert2a3cGmxF
	 aTlse4GN8AU0hKUvdN6pChSnkhciOYn/9KOhoLfjr803HOXt2QYNmFKAeLdyltgUX4
	 +Zte6jJ4Ok3W6FS9y1R+GhX975qLxbHW2QTWPyhbF6+3k7q1XxpyJ/xZJjdxM660yX
	 MOXMBXFnt+O7jxRtYh+GWiagZmv72wGyuxn3KcYVu83z50cFAbA4PXDQIyWPRyeaqC
	 4KJlHeFwZescmjgFnmAdiRPnX3Dii6Y7+wE0dQGYjJO5CDq718gc1qzp9vJdnvSQaQ
	 rAhgnjr1gyo7A==
From: sashiko-bot@kernel.org
Subject: Re: [RFC 10/12] arm64: Support TLBIP instructions
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?S3Jpc3RpbmEgTWFydMWhZW5rbw==?= <kristina.martsenko@arm.com>
Cc: "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20261001110655.461473-11-kristina.martsenko@arm.com>
References: <20261001110655.461473-1-kristina.martsenko@arm.com>
 <20261001110655.461473-11-kristina.martsenko@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 01 Oct 2026 12:40:27 +0000
Message-Id: <20261001124027.AF2FE1F00899@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] arm64: tlbflush: ipas2e1is() calls __tlbi instead of __tlbip, drop=
ping domain ID
- [High] arm64: tlbflush: macro precedence bug in __tlbip() destroys domain=
 ID
--

commit f57328676d294e62d35d640905ead85c0b306e45
Author: Kristina Mart=C5=A1enko <kristina.martsenko@arm.com>

arm64: Support TLBIP instructions

This commit modifies the TLBI helper functions in tlbflush.h to support
issuing TLBIP instructions when requested. It introduces the __tlbip macro
to pass 128-bit arguments containing a TLBI domain ID in two consecutive GP=
Rs.

> diff --git a/arch/arm64/include/asm/tlbflush.h b/arch/arm64/include/asm/t=
lbflush.h
> index b51df8e0ce631..dac35568570ff 100644
> --- a/arch/arm64/include/asm/tlbflush.h
> +++ b/arch/arm64/include/asm/tlbflush.h
> @@ -41,11 +41,26 @@
> =20
>  #define __tlbi(op, ...)		__TLBI_N(op, ##__VA_ARGS__, 1, 0)
> =20
> +#define __tlbip(op, arg) do {		\
> +	register u64 low asm ("x0") =3D (u64)arg;					\
> +	register u64 high asm ("x1") =3D (u64)(arg >> 64);			\

[Severity: High]
Does this macro expansion drop the upper 64 bits of arg when passed an
expression?

When __tlbip_user() calls this macro with a bitwise OR expression, the
expansion for the high register becomes:

    (u64)((arg) | (u128)USER_ASID_FLAG >> 64)

Because the bitwise shift operator (>>) has higher precedence than bitwise =
OR
(|), the shift applies only to USER_ASID_FLAG, yielding 0. This evaluates to
(u64)((arg) | 0), which truncates the 128-bit argument to its lower 64 bits=
 and
causes the domain ID to be lost.

Should the macro definition enclose arg in parentheses, like ((arg) >> 64)?

> +										\
> +	asm (ARM64_ASM_PREAMBLE ".arch_extension tlbid\n"			\
> +	     "tlbip " #op ", %0, %1\n"						\
> +	  : : "r" (low), "r" (high));						\
> +} while (0)
> +
>  #define __tlbi_user(op, arg) do {						\
>  	if (arm64_kernel_unmapped_at_el0())					\
>  		__tlbi(op, (arg) | USER_ASID_FLAG);				\
>  } while (0)
> =20
> +#define __tlbip_user(op, arg) do {						\
> +	if (arm64_kernel_unmapped_at_el0()) {					\
> +		__tlbip(op, (arg) | (u128)USER_ASID_FLAG);			\
> +	}									\
> +} while (0)
> +

[ ... ]

> -static __always_inline void ipas2e1is(u64 arg)
> +static __always_inline void ipas2e1is(bool tlbip, u128 arg)
>  {
> -	__tlbi(ipas2e1is, arg);
> +	if (tlbip)
> +		__tlbi(ipas2e1is, arg);

[Severity: High]
Does this branch mistakenly issue a regular TLBI instruction instead of a
TLBIP?

By calling __tlbi() instead of __tlbip() when tlbip is true, the 128-bit
argument is truncated, the domain ID is discarded, and domain-targeted stag=
e-2
TLB invalidations will fail to apply to the correct domain.

Should this use __tlbip(ipas2e1is, arg) instead?

> +	else
> +		__tlbi(ipas2e1is, (u64)arg);
>  }
>

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261001110655.4614=
73-1-kristina.martsenko@arm.com?part=3D10
