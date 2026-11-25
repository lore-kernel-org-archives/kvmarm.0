Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622137;
	b=LaD5S16PQWGxMLLkx1Bkkn1a3rGGgDrvPTRAxBDZzfM/XASdOiuQL01N8/Y9H9vMCLQu
	 2wrOn1QUoEM6cnGh399ig/qX5H5D66C5kSIDzqKMalv0y9HQd/6IKK3tx06IgIxiEOuGR
	 vZ2sVeNxQBobo/FmhOFOYqbbO+xZStQL19JmsNGcMzT9cPJxjGOw3fllMnYm6UV1uR+Cg
	 QCdm5vs3kju5EIPjMCaMI9KRMmNQoj1UlTRGZzf9PRxl3O6f4UV+a1ACRtbEAkF8MWl6R
	 tt3Fww4/5pcwkFiyqFgAcC/1GymaIQFeKvnbzk2nGfISLzOw7UWp4He786Mzg7kOhew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622137;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=r62sQwX3TtcfdrrxWd6LqSL929Twi5LmE8HULa72YDc=;
	b=Npbrk6L+OFz6mf4KOZjQVCv+XdGNbjs61F39F0bC9DH6IlZ9R0hEirif+0FciInUUXYO
	 QbkcS5uCeSOhgTaY4/q7K+vH8gbmaY9qy2II/EpbkezbKoHAFkAZRELO98MPNl02q8qpe
	 zm2KHh//82QF4LQeQoEpFTyE4vxRfVQ++1KNcubYqqbSARADVTflzxJicqR/dTVUVOu5+
	 Z4sH4vHdqBl9tQF/f5BK8ToSMjUtMjL8llteJuAPvo5vZ6HLYZhfqPsBT4Jn2I81aW1sB
	 C/wewZ7bWSRYuq9hiK9nGM+X4SzYh9YVcvJGZO1WYiLGdi00y0jl+iee+RaOYE5ynPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZKlIM7vN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29C35606A326;
	Wed, 25 Nov 2026 15:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZKlIM7vN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A9751F000CA;
	Wed, 25 Nov 2026 15:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795622136;
	bh=r62sQwX3TtcfdrrxWd6LqSL929Twi5LmE8HULa72YDc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZKlIM7vNwIpCl1UegKviBWyp+pnWJx00PHAa5vOAvg4/NyNqRyVfmIAFF0Ybnsn6H
	 ovw6nAOquYWofqx8nfCB1Winns9lTvIJly67urBVR7OweOjM1EfU6KSw0dYVrPsIbu
	 K/w/xHFbG3ySdRIscgeSsM3SMx3FrxEcZ3bmpyT8/NpVcPzLC3Fu9db6HhWgLJw7+q
	 oUdF3UDPrPOrUHa6B10eONpjxK0Mp80TumXwHmh2CnhxXdWRtTytoCN5MS0iK6C8Sl
	 sCaRPbiuPaecvk8Fb07W7Bv1guNxtlt9D+1putLiQ4ou77NTOQnGsU3bFsOwvVm7w0
	 T+abkQ2jFb49g==
Message-ID: <sashiko-outbox-233684@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 09/20] KVM: arm64: Report an incomplete feature map
 with WARN_ON()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fuad Tabba" <fuad.tabba@linux.dev>, kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>
In-Reply-To: <20261125153911.106793-10-fuad.tabba@linux.dev>
References: <20261125153911.106793-1-fuad.tabba@linux.dev>
 <20261125153911.106793-10-fuad.tabba@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 25 Nov 2026 15:55:36 +0000
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
- [Low] KVM: arm64: unused str parameter and name field in
  check_feat_map()
--

commit ef16fb792e699aa85734a7167ff79fe6521ee780
Author: Fuad Tabba <fuad.tabba@linux.dev>

KVM: arm64: Report an incomplete feature map with WARN_ON()

This commit replaces the kvm_err() call in check_feat_map() with WARN_ON()
so that arch/arm64/kvm/config.c can be built into the nVHE hypervisor
without depending on printk().

> diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
> index c65cf1dd27330..eef5ca50fc382 100644
> --- a/arch/arm64/kvm/config.c
> +++ b/arch/arm64/kvm/config.c
> @@ -1409,9 +1409,7 @@ static void __init check_feat_map(const struct reg_=
bits_to_feat_map *map,
>  		if (!((map[i].flags & FORCE_RESx) && (map[i].bits & resx)))
>  			mask |=3D map[i].bits;
> =20
> -	if (mask !=3D ~resx)
> -		kvm_err("Undefined %s behaviour, bits %016llx\n",
> -			str, mask ^ ~resx);
> +	WARN_ON(mask !=3D ~resx);
>  }

[Severity: Low]
Does replacing kvm_err() with WARN_ON() leave the str parameter of
check_feat_map() and struct reg_feat_map_desc::name unused?

check_reg_desc() passing r->name to check_feat_map() was the only reader
of struct reg_feat_map_desc::name.  Leaving str and name in place triggers
an unused-parameter warning under W=3D3 and, once config.c is built into
nVHE hyp, keeps unused string literals and relocation entries in
.hyp.rodata and .hyp.reloc, while the bare WARN_ON() across the 23
check_reg_desc() calls in check_feature_map() no longer reports which
register or bits failed.  Either str and struct reg_feat_map_desc::name
should be removed, or check_feat_map(), check_reg_desc() and
check_feature_map() could be guarded with #ifndef __KVM_NVHE_HYPERVISOR__
so the host init check keeps logging the register name and mismatched
bits.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261125153911.1067=
93-1-fuad.tabba@linux.dev?part=3D9
