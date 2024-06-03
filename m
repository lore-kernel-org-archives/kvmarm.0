Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26B81757E0
	for <kvmarm@lists.linux.dev>; Mon,  3 Jun 2024 14:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717424364; cv=none; b=lr14fSZViTWDrdoWg04ycvb+tlRxfXFN38wnYsXubxgjcPsd5988ukx4VexGPOCB5yYFQ6FQuCI/fLJCZc9j5m09GwYv67dSIGZh5GwNYhmUhOjk6WxiqhObKbk4i9lGiBRKNJs/Rnw4jZNZf9s0MdVC5Moz1m+cijP+cgcCDSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717424364; c=relaxed/simple;
	bh=w/FeM6vjOM5eZkMU+sThk+CL1d5zWsm8ueav2gEMuv0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j54WK/eyli03ghJgfRN3rPr6NRUgX6o7oh49SFxMDxVONI1S8maiJu/MM5/lko/L9BN0CCnf6et/Jdd4DXiH+AJUtfQmPzk284z8eQmyeHa+7CA+k1/ONrpFaFPWwvueql468RK0iy7Kt64lsciMi2HXwBnXqgV9bTjK5VzBqjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iMLr33C+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iMLr33C+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DB19C2BD10;
	Mon,  3 Jun 2024 14:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717424363;
	bh=w/FeM6vjOM5eZkMU+sThk+CL1d5zWsm8ueav2gEMuv0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iMLr33C+0AHvneYKPCyOtDDD1CZh78jR6UYcAhB7+WN3iG2C2bj05pS1sik+a1MKe
	 4FJ5Cs0BZuGAEOL8yQ64UC1o0NwZSE98GmPY5g/4NzH6q6Hi2RJRfAj302g0QdbIF/
	 f2OyFwtXDVHVa5Qlq5Lsd7XbRp9o1+wBWHA5VFX57c06dlb5/JgW/CkcY73UwOw6gK
	 2MT7BhE7eudCXwSxsCRPJP7waNJvHBHFC1KSIwsJjQo2nogCGCkwpD96EtU+A4OO7n
	 P3zo2CenAGvSutbD5gvhh1+2LkbkMRq3O2mIVFV5m/vwfpfuTYAwaHUQk51lg7lcqz
	 qRPBQeRhqpkTw==
Date: Mon, 3 Jun 2024 15:19:17 +0100
From: Mark Brown <broonie@kernel.org>
To: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	maz@kernel.org, will@kernel.org, qperret@google.com,
	seanjc@google.com, alexandru.elisei@arm.com,
	catalin.marinas@arm.com, philmd@linaro.org, james.morse@arm.com,
	suzuki.poulose@arm.com, oliver.upton@linux.dev,
	mark.rutland@arm.com, joey.gouly@arm.com, rananta@google.com,
	yuzenghui@huawei.com
Subject: Re: [PATCH v4 2/9] KVM: arm64: Fix prototype for
 __sve_save_state/__sve_restore_state
Message-ID: <186354b0-9ae8-46c7-832d-7df4c0a197e8@sirena.org.uk>
References: <20240603122852.3923848-1-tabba@google.com>
 <20240603122852.3923848-3-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="oG0kumO8Ayd/8h5v"
Content-Disposition: inline
In-Reply-To: <20240603122852.3923848-3-tabba@google.com>
X-Cookie: Don't let your status become too quo!


--oG0kumO8Ayd/8h5v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 03, 2024 at 01:28:44PM +0100, Fuad Tabba wrote:
> Since the prototypes for __sve_save_state/__sve_restore_state at
> hyp were added, the underlying macro has acquired a third
> parameter for saving/restoring ffr.
>=20
> Fix the prototypes to account for the third parameter, and
> restore the ffr for the guest since it is saved.

Reviewed-by: Mark Brown <broonie@kernel.org>

The change to fix restore should be sent as a bug fix.

--oG0kumO8Ayd/8h5v
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmZd0OQACgkQJNaLcl1U
h9BBXwf/fmiSST0dpDrwUYlTPciSaX8ZqOi/eeT3km58ltHFpfsTysGED5dzDnvU
jpm55xfMBnJIlXZDxtBKQ4sN62fLAegIUFMM6D1Y2d5FHLwijQisnwGJmtXh36gT
xx02cdSED9ONAvguUfrgf7T0Lnjh+zHKhJPMOv2rXyxonxBXOlGyNzGahNXhlD0k
MXfvGObhgAAsKOtmVU/ockkUL5h97SAH2KTf8H93BnsayEopRnAGhRZdFfp6AwDW
JBkNkasNjQ+IKz0NtJvOwHVlZV62d0J12E/r2xXA5o5nVLdvtKBHBVKL3bLWgIN5
x2fNBw0UayrQFzPGCIkDCgFDjsGsTQ==
=bktW
-----END PGP SIGNATURE-----

--oG0kumO8Ayd/8h5v--
