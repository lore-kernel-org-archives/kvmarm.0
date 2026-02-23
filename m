Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCA6530FC16
	for <kvmarm@lists.linux.dev>; Mon, 23 Feb 2026 16:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771863981; cv=none; b=OzsBecZud1XbJFUM7qIFy3aWbNTRFTOiDewRKjGDL0VVdiiFoQDQIK4rmjcL1Niu4IkXTPMHRk6O6+EicX2BRSzKew3LYWQxXws/r/hfOyETSo8XGhMTkoVmZpVtb0t7yXPdx4wezEnnvaT4g5EXZTKK6Jl2bEi2/UcOWIQFPtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771863981; c=relaxed/simple;
	bh=pjlJTGlsJO1Ix7UMDzBnbBF88dmXRCCbMLYgEcN0bTs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DcTuuv+NA666L6EuNYqLesdWbrn31yPgJtgqje3tyLAtJPSHujT7OLv7nGG1203fYIk9HKa5Xv90r4c0rsJj+dux485k/djP+qCYXLQUg80xcTXXTEmdIoy73dHWXC72l5sXILJnGN7EuVFUCQ0D8qfJhqj28yY7i3Z2+AyS8s8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UQ742djL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UQ742djL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7935AC116C6;
	Mon, 23 Feb 2026 16:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771863981;
	bh=pjlJTGlsJO1Ix7UMDzBnbBF88dmXRCCbMLYgEcN0bTs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UQ742djLUOR9uCTuDgFv1BHjkvtZ0go9om6TRtYF4O5rXsHef1n0FK/FUPv825fTD
	 AcHpiIJODjOE1wQvN3iA8fkXJThLnxw4ZFOmBufYZ0bskYcZtJIo171bLu2Hvg7iIZ
	 WqjFdfg4r1694+1lEGzhLW+8OO++fQAcUo0xK9GyQ8XZTVasr3GDl4l/aSRSiDJk4Q
	 kTxhFCv6HT7na7mf6A9zMUl1jUB9PqT4kS2DberS4v4NiGxOQ8isDK4Ltd/gCgXl64
	 pxztz5B8IA84M5DY6GY7aK3AJpCZ6qh7IH8ATgJ13v2J3aPBB6d+2OEcd9Gz3pz1kK
	 kZSox4p/JcmTw==
Date: Mon, 23 Feb 2026 16:26:16 +0000
From: Mark Brown <broonie@kernel.org>
To: Fuad Tabba <tabba@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Joey Gouly <joey.gouly@arm.com>, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Mark Rutland <mark.rutland@arm.com>
Subject: Re: pKVM breakage in mainline on n1sdp
Message-ID: <ba75b3b1-ee6f-4e97-a9ee-8eb848a69807@sirena.org.uk>
References: <60916cb6-f460-4751-b910-f63c58700ad0@sirena.org.uk>
 <87bjhie67o.wl-maz@kernel.org>
 <CA+EHjTwzjjNuZSQExZUsGAXWdaH=Uf=z4ks2XQAXqaU4DcmD9w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="aqb+ut7wXhB5soxA"
Content-Disposition: inline
In-Reply-To: <CA+EHjTwzjjNuZSQExZUsGAXWdaH=Uf=z4ks2XQAXqaU4DcmD9w@mail.gmail.com>
X-Cookie: My LESLIE GORE record is BROKEN ...


--aqb+ut7wXhB5soxA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Feb 22, 2026 at 08:34:57AM +0000, Fuad Tabba wrote:
> On Sat, 21 Feb 2026 at 10:33, Marc Zyngier <maz@kernel.org> wrote:

> > [+ Fuad for the protected mode stuff]

> I'm unable to reproduce it, but I think the following might be the fix:
> https://lore.kernel.org/all/20260222083352.89503-1-tabba@google.com/

Followed up there, that looks to be it - thanks again!

--aqb+ut7wXhB5soxA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmmcf6gACgkQJNaLcl1U
h9D/bgf/ST5dxO+Lyvga154SvVeGOj/YvBqIN3TmsOOB92SbGvjASumzq26G04nR
9pKbxjRgbAWolw9uU42DBPA5osGkhkAvqRUczhujTUFe01PNwuxoQ4tVrHSVysr/
4dnN8fGwaQPgMOsV9wShjwV3V8z6Q20UZX6x20iVstA+g6S0dizUqUnperEohvTy
zhYmy7e9nZOmhCj24OsE/hKj9WBqSQuQ1j8kV40cMfKQ7HJVeBu/jhC2SDk4JDWE
AO/80iavSUHlKha67qByAVEB2jo9uRhk8KjewYGIt9Bg1Rd896dL1GtO5xGWYM6o
wJ5Iqf6jSwfhQF6VQgDbVLVeEXIMyw==
=Ui5B
-----END PGP SIGNATURE-----

--aqb+ut7wXhB5soxA--
