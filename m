Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F37239FCB6
	for <kvmarm@lists.linux.dev>; Wed,  1 Apr 2026 13:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775050512; cv=none; b=mPzZkSYM9fwVbWNnD/MTIn7imYw2I+i+sipHtahNtzlNIEmzY1aW/h9XSXJsvJkpiBK/TCrWlkI5WT/LWRFHmMVjhDjZsN/lLeAsl1fZ6yhLMx0hW718BtdSlBylAQue0LTgDAw1QpcteVO+n465ahp+yjuspIXw++mYMhyZ/bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775050512; c=relaxed/simple;
	bh=2TAiYxjzVwdqX//M0tim4X32TxlCbCXsOAveLah/O3U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W7vwqlm5W2abpnT7dGZ5aXJMQ6idjhtmgxmUCNPYuhKCzauHcSLonIUghxh5w1S4HlnPYxw4LBuxL6nyZYmzDtK/F2KXJfobRlQXNFOTJnNOb47I1gXsXNAV/bMGBX0JJ+cwXFaSGUrJgJuDwjdGYWqBbHN+k0ZzWBXhc1SixkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TcM/v+IF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TcM/v+IF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CF9EC116C6;
	Wed,  1 Apr 2026 13:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775050511;
	bh=2TAiYxjzVwdqX//M0tim4X32TxlCbCXsOAveLah/O3U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TcM/v+IFj6IIz8mSM13m6fQRWoKjz3T3opLQesDd1Z+ZC9PoV4La0283nxpxB9Oo4
	 /2TRb1M8hfSxS8sbSONGcKVEsJyQxRK8MXIBAV5zC/VfYC7tVxztfehS7EwbTFflfB
	 Wizi9VyGmvSvFf+6lsHR+zKTGnYizea5QPOrLBMLsAuhX0nutizORO4CwCtHgowehq
	 m2hXmRxrrJUbiKoUkBcl32rFlujrY7g3fLnqFocajl/UAfNbSMEDQFZdRbV/PoSC2/
	 tr13xLcdMemmVKWLIyKAUrmyUkA6KhJ4EU/0OlOVcySGIaER3DA93gZ7wkW+55F2F2
	 mFPQxguyJ5nRA==
Date: Wed, 1 Apr 2026 14:35:05 +0100
From: Mark Brown <broonie@kernel.org>
To: Will Deacon <will@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Quentin Perret <qperret@google.com>, Fuad Tabba <tabba@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Mostafa Saleh <smostafa@google.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>, Aishwarya.TCV@arm.com
Subject: Re: [PATCH v5 11/38] KVM: arm64: Split teardown hypercall into two
 phases
Message-ID: <ab5383dd-b3c9-4f08-97fe-b96d14850dd5@sirena.org.uk>
References: <20260330144841.26181-1-will@kernel.org>
 <20260330144841.26181-12-will@kernel.org>
 <0cf948e9-be64-4c75-97f8-a560442eb5d2@sirena.org.uk>
 <acwfcFytYX7eHAUZ@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="HMblpO9oyn5+ZS2O"
Content-Disposition: inline
In-Reply-To: <acwfcFytYX7eHAUZ@willie-the-truck>
X-Cookie: "Yo baby yo baby yo."


--HMblpO9oyn5+ZS2O
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 31, 2026 at 08:24:32PM +0100, Will Deacon wrote:
> On Tue, Mar 31, 2026 at 08:15:40PM +0100, Mark Brown wrote:

> > We've started seeing WARN_ON()s generated in -next on N1DSP when running
> > kvm-unit-tests under pKVM:

> > 1821 23:03:59.721620  <4>[   17.558270] ------------[ cut here ]------------
> > 1822 23:03:59.725053  <4>[   17.558274] WARNING: arch/arm64/kvm/pkvm.c:373 at __pkvm_pgtable_stage2_unshare+0xbc/0xfc, CPU#3: qemu-system-aar/390

> Aha! That's probably the thing I tried to fix today. Please can you try
> these patches on top?

> https://lore.kernel.org/r/20260331155056.28220-1-will@kernel.org

Yes, those seem to stop the warnings showing up.

--HMblpO9oyn5+ZS2O
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmnNHwkACgkQJNaLcl1U
h9B31wf+Ml5vYmGKXL7N1xiYL/XeWbiWf7r2JRHRkjOJyiyzZiwO3OnrLa0cx3qB
spVaiKrjPytYNV5eRyswYHvA08EkE6szcvY+D/zrDCow/y9AFnewd7PPaT5+OhBP
hZRO7Au/xkZcU7E0k6FQP3WHviUtYpcNUxFU4X563qagE2makCX0DVDOT0Nr3696
A0qom3PNXvZdAtWnaTzFtoPMwE+KmmJhIXM6R7RoXEFNFaw5uXaJAf4Bcx6Z8/8U
ML1v86MQNx+zRfO4Zup4Vl2nw7k2d7AOygbZp5/5WDCBCyvX4AbmvAaeLXMkUUor
pCCV+EU1wVK+7QFHvo1YqNh5TcQE/g==
=QqUb
-----END PGP SIGNATURE-----

--HMblpO9oyn5+ZS2O--
