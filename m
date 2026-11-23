Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795462497;
	b=bKL/NKdoH80Z1wRzBZtubXP4M0jtJIjNSZH0A+4muv5IGSmvJu4xtjo5kWeD+ZFQZ2Kz
	 4Wy6B7wNA6Y8+QW1Hs/xhKIQmMFF6o4HcOYw4dIsAnawMY6TW2/H8N30q/QYTvWhnYkk6
	 p8ylAr/bGON9eKUXxr4nxLXjFIXrBAxOsXioQuZ2wHoo2alQyco4zwACuKo7Q6LmDUFtV
	 Lrh6qOK+16RyEFsZLRPZCZv0K3GgYF8Nwla7xKhHhPcOMHq8ojm6VmyBgbyr6lQnBuXkA
	 KjbHkBjwEzk0DPMFpwMbnZUMpXAlJXtTLH7mo7sdewtPY6SZ6w5JIXsEiejdR7Guj1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795462497;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=P9smyWWFNbqZ0JC5hQlWxI90ybr781jHhc3XD7suVuE=;
	b=gL1KVd+ZQl8QhTVrZQlKA1h61ZKnTXEm88IXvacaLUWZwJ4pIbH9RJiDxHh/SgkLTm5s
	 ENYgCyvk6dmYzvZcvpFTxXHARYD4NvQNxi/zcGY6Z+CtkxgMnHuSuI3xJ1GRQe4W931h9
	 MAnJs8XA6bfVYe2C4LuYxmR36Gjhb8RIhwHc8bKld7mQi5hXvficmQqu6vouNpBc9W7zc
	 sVFOpUYYz94Cq0Fd5KpIZqcQ0TLxidAFkm24TJjgSLUUAwxzv3HeSqnR3ymKglSSA62bN
	 eyaOZ4PBOZOPvlEOeuYcqf5jLPG0Bx09I5zmofTFhlCLz7QhQoaFGJbGtwzwOagNUQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ONrNRncj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DE23606A31A;
	Mon, 23 Nov 2026 19:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ONrNRncj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 457E61F000C0;
	Mon, 23 Nov 2026 19:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795462496;
	bh=P9smyWWFNbqZ0JC5hQlWxI90ybr781jHhc3XD7suVuE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ONrNRncjUgabik9vUUm2LrPo2AuAwo9+/QszLkCuVKHeEir3TXKVm7GdxTutH4Im7
	 iejkMb0B5CaMEgpcb0H5gKTI7nC1SyvdO3ro4hWtXEs5whiKQ21HL9WaVmaShvglNA
	 7eVTMde8N9mitr7QwZxfEuZYh8+utqfkCj23ThUWTsri2mgTxEOEhsBfvWJ1j8OhvB
	 6yii5aGEMXqGoPXz02y2PQLvU2SPCiRbB/hub9vvRAcZxzu53kFO9gCnc0Mh55YFIF
	 LHaexEv9+NFHIlS211LfY7tDE+L4//6p9f6X7qpLumVX9JGn0Ptx9eUp+wp/zTea4K
	 X+q4eXzxaaX7Q==
Message-ID: <sashiko-outbox-229945@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/3] KVM: arm64: Add enum support to idreg sanitisation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, kvm@vger.kernel.org
Cc: "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20261123192457.8700-2-maz@kernel.org>
References: <20261123192457.8700-1-maz@kernel.org>
 <20261123192457.8700-2-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 23 Nov 2026 19:34:55 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] KVM: arm64: oversized value in field_prep() in
  compute_idreg_field_deps()
--

commit db63f3732a88cac7f7573382f03761fa97deb813
Author: Marc Zyngier <maz@kernel.org>

KVM: arm64: Add enum support to idreg sanitisation

This commit extends the ID register dependency framework to evaluate nested
ordered enum feature descriptors and compute the corresponding RES0 and RES1
masks for ID register fields.

> diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
> index 6f668148ccc11..9763d021a5ecd 100644
> --- a/arch/arm64/kvm/config.c
> +++ b/arch/arm64/kvm/config.c

[ ... ]

> @@ -1557,6 +1571,27 @@ static const struct reg_feat_map_desc *idreg_feat_=
maps[] =3D {
>  	&id_aa64mmfr3_el1_desc,
>  };
> =20
> +static struct resx compute_idreg_field_deps(struct kvm *kvm,
> +					    const struct reg_bits_to_feat_map *map)
> +{
> +	const struct reg_bits_to_feat_map *tmp;
> +	struct resx resx;
> +
> +	/*
> +	 * Assume the enum values are ordered in reverse order of
> +	 * capability (from most to least capable). A NULL callback
> +	 * value indicates the ultimate fallback (not implemented).
> +	 */
> +	for (tmp =3D map->idreg_field_deps; tmp->match; tmp++)
> +		if (tmp->match(kvm))
> +			break;
> +
> +	resx.res0 =3D field_prep(map->bits, ~(tmp->bits));
> +	resx.res1 =3D field_prep(map->bits, tmp->bits);
> +
> +	return resx;
> +}

[Severity: Low]
Can passing ~(tmp->bits) to field_prep() trigger a compile-time BUILD_BUG_ON
("field_prep: value too large for the field") if the compiler constant-folds
map->bits and tmp->bits?

tmp->bits is a 64-bit unsigned value holding an unshifted field value, so
~(tmp->bits) always has upper bits set outside the field width, which
violates __BF_FIELD_CHECK_MASK() in __FIELD_PREP().  Computing resx.res1
first and deriving resx.res0 as map->bits & ~resx.res1 avoids passing an
out-of-range value to field_prep().

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261123192457.8700=
-1-maz@kernel.org?part=3D1
