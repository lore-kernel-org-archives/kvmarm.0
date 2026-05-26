Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CCFB388E77
	for <kvmarm@lists.linux.dev>; Tue, 26 May 2026 15:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779810331; cv=none; b=dazCMo+P8Ro7pGZmqAW1CtvFVYAJjsBZeBKp8A4RaGNENb1j6yC3KeIO17irbBNn6ulbHfvLSaCN3TUryIfvCYYihSdmCfXpchtqOWc553yeN0NcOpU7z17/utxJVyK7oY+y8gc0D7PCuiaKppW/Vi+02QzJR//oHQwfQMh5QGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779810331; c=relaxed/simple;
	bh=ng5tVAf/Y9+5wzN0yP6ogMfsFxqAJF42Imb3+FGMJWA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kkgcrNaAesu56OWEfKLiARC1hbqOZoZy4Zo1k8ID4WPIpiNztwzseJ4XtGS/f5crpC/BvdpC8MVI/INmK9A1wbIQwmFm+7JXF88oRFRHvRDVNDRbOfpKG+sIPeR24zHllJs+bVvoswt+TRNgYdolRxGPTEOWmYSbXiFrARto7VA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GVWBQDRp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GVWBQDRp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 580B51F000E9;
	Tue, 26 May 2026 15:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779810330;
	bh=ng5tVAf/Y9+5wzN0yP6ogMfsFxqAJF42Imb3+FGMJWA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GVWBQDRp4XIaWfBddG8ecFA49ZakCGR832YOdwFJpq7Z+vug5y1r6yARQ3i7wAK1b
	 T8cPF0vd4Z05vghzwRSzqLKHEH5/Yn422G1TSl2sbDdDie0VD/fRPfc7plhbE2/1F5
	 y7u6TjbUB0aCQ68l/J/wWLl8qqFJuhVbpvbwC9cuw11rL7/X7ieDjRexuA7XQaBph6
	 LmNPt2Ov5rPqKKN+oqI83yWadRh6yuHFPojhhWdJwtEeL3oinVcRtk5vqAZbuQJFXl
	 fl2MEPtslwS7dX7HzRxwfe63vd9NZ6KuVB/Sm603gGYL79r74oVFWGhB0oq2JG4ADM
	 XNgzUsy8k2utg==
Date: Tue, 26 May 2026 16:45:25 +0100
From: Mark Brown <broonie@kernel.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	catalin.marinas@arm.com, james.morse@arm.com, maz@kernel.org,
	oupton@kernel.org, tabba@google.com, will@kernel.org
Subject: Re: [PATCH 08/18] arm64: fpsimd: Use assembler for baseline SME
 instructions
Message-ID: <e3544477-c7e3-4732-b671-e19488555b98@sirena.org.uk>
References: <20260521132556.584676-1-mark.rutland@arm.com>
 <20260521132556.584676-9-mark.rutland@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="tJKC2+pbRzUnN+C1"
Content-Disposition: inline
In-Reply-To: <20260521132556.584676-9-mark.rutland@arm.com>
X-Cookie: You are fairminded, just and loving.


--tJKC2+pbRzUnN+C1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 21, 2026 at 02:25:46PM +0100, Mark Rutland wrote:
> We currently support assemblers which do not support SME instructions,
> and have macros to manually encode SME instructions. This was
> necessary historically as SME support was developed before assembler
> support was widely available, but things have changed:

Reviewed-by: Mark Brown <broonie@kernel.org>

--tJKC2+pbRzUnN+C1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmoVwBQACgkQJNaLcl1U
h9BHKQf/XKETxo4uu2TkYw3D8d2MmXbwgMh5F1puR3pxuDJw1t0YzjQ358cYcp3y
zkApc8WbI3iT0myH3nXv8aIEanMr+1eDk54jPfzHm1IhxtbOfJWbrgjggB83WTFA
QOrflsgO5/GP+FzNXvPRYkHwdxj7BIa+GKKGDAXVLZSD2IYzW6DZ6SeFVeq753yt
sUH3Y1mvT5j1M2ceBfaz4aNo2HBRo4aA0WjReKod6bwgI7BJSLNvqvxHh5boI0g4
NsU6ILtIXxqp5+JEhpPnkB0quweSNpgIQksCjcEbbvLarS8kR9DiSiY9AsvtNuah
fA8/1zqWoLD1XPo64ddWtvI+tTyRCg==
=kIcV
-----END PGP SIGNATURE-----

--tJKC2+pbRzUnN+C1--
