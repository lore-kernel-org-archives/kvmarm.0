Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81815194AE0
	for <kvmarm@lists.linux.dev>; Thu,  6 Jun 2024 12:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717678511; cv=none; b=po007JPc4y9YtuOMCPfk4//aSz95WcgtW5lifXZIubPwRsEf6rb+Ir31rtZNA8ehhD5XZCfJajPkp7wXyI1QhsQlH7iA5fXtGUeDKytWvuUPHTtUq3IAFgMj364BA/JfNr7u+R7qq6FmEW+kwzTPJdwUZqMMm1NpUsXdBQ0Nn9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717678511; c=relaxed/simple;
	bh=4IwL5TMXym1xJIqA+cFv8P8UGyeK+yDwm9+bgbBWBgw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aBJLEsaI7fcgT6Ru+ZS0XbbmGHp7F8UTQaT8yqbVjRcojqvqS0n+s6EJn2ReuDenlbI05KLMub3yGP5omee5m5UBKTH8qRLYFXyspB8PFbvHqUBVyGEAegNrvv7bylNRrSDyhPHc6Y7wU1S+4CO9Q9/Lwu5QQ4CVpE/L1w7MUhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Cg382LYe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Cg382LYe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCAFDC2BD10;
	Thu,  6 Jun 2024 12:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717678511;
	bh=4IwL5TMXym1xJIqA+cFv8P8UGyeK+yDwm9+bgbBWBgw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Cg382LYe241gFoD+93O7+yVba/mV0E04mDgwXwsBuw7X/QBVS2PgxrkfWEAOpyYmB
	 k61cORaf/NceG6gqEIPNNbBcWmBtMZaVLvQR8G35vZEDiz4y6a5LR0DDxOW81LZeHS
	 95fWF614j7jSDd5izQ5oG0KsSjgN2x8Z3j/whGqKuZvCuD5GG51cEJ+iG1pH0TmNXC
	 KtUS5F2fxAJuXjOTtdSABZCtg9tlFhC2Vofc2Hy9rBku0g68Q/V5oZLcvZH4O88XT2
	 t/h3Zk76Xog4zfvE/ypsEjSa3ZNuEAel/pbk8uI4fQaFcRV8+Ovog4QQFJIjQSsn4Z
	 OsUBUf0rBuBJg==
Date: Thu, 6 Jun 2024 13:55:05 +0100
From: Mark Brown <broonie@kernel.org>
To: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	maz@kernel.org, will@kernel.org, qperret@google.com,
	seanjc@google.com, alexandru.elisei@arm.com,
	catalin.marinas@arm.com, philmd@linaro.org, james.morse@arm.com,
	suzuki.poulose@arm.com, oliver.upton@linux.dev,
	mark.rutland@arm.com, joey.gouly@arm.com, rananta@google.com,
	yuzenghui@huawei.com
Subject: Re: [PATCH v2] KVM: arm64: Allocate for maximum vector length for
 pKVM host sve state
Message-ID: <3546bc48-3224-4f51-916a-305a656391ad@sirena.org.uk>
References: <20240606092623.2236172-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="NXL31tlP3lQL+Zqd"
Content-Disposition: inline
In-Reply-To: <20240606092623.2236172-1-tabba@google.com>
X-Cookie: Simulated picture.


--NXL31tlP3lQL+Zqd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 06, 2024 at 10:26:23AM +0100, Fuad Tabba wrote:

> @@ -1031,7 +1032,12 @@ static void vec_probe_vqs(struct vl_info *info,
> =20
>  		vq =3D sve_vq_from_vl(vl); /* skip intervening lengths */
>  		set_bit(__vq_to_bit(vq), map);
> +
> +		if (!max_vl)
> +			max_vl =3D vl;
>  	}
> +
> +	info->max_cpu_vl =3D max((int) max_vl, info->max_cpu_vl);
>  }
> =20
>  /*

As discussed I'm much more comfortable doing this in line with the rest
of the discovery and not having vec_probe_vqs() modify global state.  We
also really ought to have some validation that late CPUs aren't doing
anything funky too, even if we don't actually need it now.

--NXL31tlP3lQL+Zqd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmZhsagACgkQJNaLcl1U
h9C6sgf8C9pz3Aah3d3rkqgzKEuyzqVT59oZE+WF/CZA8QcvW8g9RWqcLRgr01Gz
evM9BvqJt/+RbhYki6IZo+GIfuFHntVtUXzwDkeJZiqxOhbDIqYkxOuJ/F2mCQqv
MIxyd++QtQSGsjJVkaYj+fJN/kf6XP36vvzmANu8NYqZhoGdRiEsOHW9nvGXzyKO
hhHs8Tj2YumtVhSyngBl3WB7f8SRhIKtgRCvPXWiCTtdfIQV0fxu+D8XYnZIvawy
5jWMJ61I3XpXCozpC7EpmniJHXiAaR8DXg+BteIBHshibo4awkGYgrLGn7hUr0Cc
BXjRcTeDTl4D5p5e3/wcjRqp9dxR8w==
=kYGU
-----END PGP SIGNATURE-----

--NXL31tlP3lQL+Zqd--
