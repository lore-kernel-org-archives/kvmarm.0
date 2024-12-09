Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2CDB1A23A2
	for <kvmarm@lists.linux.dev>; Mon,  9 Dec 2024 14:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733753156; cv=none; b=IdlIvr4HxYoWFzFA374mTUJNT64ug2EBLrjnuyppzLwp5N4qTmodd15iMQD6iGUhuQQDPu3MJM7yZoSBWp0NxgeDhM2EBWljynfYo+BcsjWHUWpQUw9vPINKN8+MaNLN3ApqsWNtmi/mthPA/J+acpENJceoc4MjJ7qLhVJwMHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733753156; c=relaxed/simple;
	bh=TtWfRQ26OIhM7EeP/8RgbWs9Yf5wwY/1/Y9HcoU6Mkw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cUmCLawIc6OHRhwH06vnKLJKckhK5+rtOhs2/YLdwrDb1CP8JQXgFl4VvR5tAe6LwI0SxX7jqGtRDcbX7U3eRY/sK0+Wrp5BOLAkRXY+GV9Yg44qfEFYzbScmDPF3DGWPJgHO+9pJFTtm6p3fGe2uSnhi1AV33LjzttW/U5eRWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FFiJhMoV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FFiJhMoV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2283C4CED1;
	Mon,  9 Dec 2024 14:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733753156;
	bh=TtWfRQ26OIhM7EeP/8RgbWs9Yf5wwY/1/Y9HcoU6Mkw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FFiJhMoVz9wtNpUFVkpnA743TrXqCKzFC5Fs1K0IYtqJXoDA9aglbIjTO9h8vsOpW
	 un9zS1OJoAcFQ1cT/6+4XcKWP6Ro+wSWGlv4zxXuuxAy5UqvGNrIwILDFbgtS/KMeb
	 pdCN46SnXhyYsECzrDi6OLrv3Fx4cdyxUCRzQTt4TVU3XsLPmA1gjehUmjZBrCR4ML
	 TUhVXvDxyMeZEbNVl00aDm/ffuH6+74ApHtwApjQpQf0K7c1D4c1jrhjBum6gX3J+z
	 LR3p/FcQ946lsxQfNUsWHAs4yq9QcVbtyig7360UNzcbtVaQfSWUFxQ28CoJoMKad1
	 iKnvFxXmRHenQ==
Date: Mon, 9 Dec 2024 14:05:51 +0000
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Joey Gouly <joey.gouly@arm.com>
Subject: Re: [PATCH 1/4] arm64/sysreg: Allow a 'Mapping' descriptor for
 system registers
Message-ID: <06726aa6-3be0-434c-9870-3d40a5ff24f9@sirena.org.uk>
References: <20241207190740.2607673-1-maz@kernel.org>
 <20241207190740.2607673-2-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="m5vTs3lMncUYB5AX"
Content-Disposition: inline
In-Reply-To: <20241207190740.2607673-2-maz@kernel.org>
X-Cookie: Lensmen eat Jedi for breakfast.


--m5vTs3lMncUYB5AX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Dec 07, 2024 at 07:07:37PM +0000, Marc Zyngier wrote:
> *EL02 and *_EL12 system registers are actually only accessors for
> EL0 and EL1 registers accessed from EL2 when HCR_EL2.E2H=3D=3D1. They
> do not have fields of their own.
>=20
> To that effect, introduce a 'Mapping' entry, describing which
> system register an _EL12 register maps to.
>=20
> Implementation wise, this is handled the same was as Fields,
> which ls only a comment.

With Mark Rutland's suggested clarifications

Reviewed-by: Mark Brown <broonie@kernel.org

--m5vTs3lMncUYB5AX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmdW+T8ACgkQJNaLcl1U
h9Czvwf+PSttBMTnItSkDEFFS3RT0/CsH9qdmk0+RQXLDaxb6bfvwBfoYsD09/Rn
dfVBjFLNKYoGMGzQxrqlLryqki3CnjmMGdZzuqhkcKEVZIfpzVmredUfH9uwIKZr
E3q4MNiEyd8vv4tnNoC9wDQ6mVm5/qBjph9yfY8MxVlQHQdMrFgqx+HSRHDn6ZKE
OSFhU7L6blyxaz1pIwEEfiRhBsG+ZaXop39NUIYa+k1NbUfNxy41zrGAap1a65La
ISAaxuNoHVMH3JuvKSh9j1L2yvLGXXOUPXB3j9dqZnPGKcf8aWQQ+VdFCgh+blJu
16oUCFJqBy6IvLuhCB0NlgO5P3sV8g==
=gLmv
-----END PGP SIGNATURE-----

--m5vTs3lMncUYB5AX--
