Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0DB425CC57
	for <kvmarm@lists.linux.dev>; Thu, 28 May 2026 16:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779986391; cv=none; b=vFJzs9LBerLSx8v8sdGu3DJRTVK0p846bDZQ+ZzJms5+d3QhrbUrE126t3D++fgnERKEeuJyYuHUP3eKQIzfM6JWcpNj+7+Uqz9uCajwxhTqOMr+HlwYDiY1SJNn2HsM4NzzibdF2/XE5XWD4hd3lITh2op3E/HPZAOrQD4LNiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779986391; c=relaxed/simple;
	bh=qaM9MYgoCxmvP7LVeRZfF5cHR1sFNTz2MOf5x31q8Y4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C5mT8B4pURYevpgpmaJjwl+TjEh8DLmhzbBnmalMdz05S4Daw1fdPliGygoRtWCKBdsuOxT3bmtjoxyMfiFzS5jE8fQd/lhRd1sQdW++E42g3xamHm/PoQ8rA9B6GahjPUWGRmo3jVnKZJmCz90dbx3YuBTdteTedn+P4fIQIuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HbDyuYsn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HbDyuYsn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C02621F000E9;
	Thu, 28 May 2026 16:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779986390;
	bh=Mm4lTGbp5AhLO9VmKrf8pXms0KjfqVinspNjmknVf1Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HbDyuYsncZxpMLAQ20zyEh2HM6EmHABuhMvF8xaXXpS8YnjWj6pY6gwPd4q87DRcr
	 nG26ufiEsDC+oDij6IWocPXYP+sSL1IHhRHPtpNliI+bk/3oqLSjihaXaMyR61AW5Y
	 UJz6Yo1aBajl4sRdRcC7ItkZUWjyxEz4mjSRksAWqb6i41JqvLpOj+boh+VdkyriJz
	 2FTZR5uROYa6F142xOtgll/h74SJYKHf1pVtmQtjf18XBiekIG9D59DcdlZXmMVG6F
	 nDE8hlkHQldT5g8vwHCBDib75nH7ykUYBIZ6k0oyTZ/6lnAkPfu2xPa4KjbSzG3nhW
	 oiRxoVfMIN/7Q==
Date: Thu, 28 May 2026 17:39:46 +0100
From: Mark Brown <broonie@kernel.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	catalin.marinas@arm.com, james.morse@arm.com, maz@kernel.org,
	oupton@kernel.org, tabba@google.com, will@kernel.org
Subject: Re: [PATCH 12/18] arm64: fpsimd: Move fpsimd save/restore inline
Message-ID: <2ac4035c-75e3-4a62-bfd8-7b4179d030db@sirena.org.uk>
References: <20260521132556.584676-1-mark.rutland@arm.com>
 <20260521132556.584676-13-mark.rutland@arm.com>
 <0f666889-fabe-4cdd-9fd2-d87808329dbd@sirena.org.uk>
 <ahhqEs1DhShRpgXF@J2N7QTR9R3.cambridge.arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="36wiTHak1laAI5AT"
Content-Disposition: inline
In-Reply-To: <ahhqEs1DhShRpgXF@J2N7QTR9R3.cambridge.arm.com>
X-Cookie: Someone is speaking well of you.


--36wiTHak1laAI5AT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 28, 2026 at 05:15:14PM +0100, Mark Rutland wrote:

> Based on that discussion on the last patch, I've updated the commit
> message for this patch say:

>   I've used the SVE sequence for restoring FPCR, which uses an
>   unconditional write to FPCR, rather than the conditional write used by
>   the FPSIMD assembly sequence. I believe that in practice, this doesn't
>   matter to a real workload, and given it's possible for the
>   mis-predicted branch to cost more than the necessary
>   micro-architectural synchronization, I strongly suspect any
>   performance impact is within the noise.=20

>   Looking at the history, the FPSIMD assembly sequence was changed to
>   use a conditional write to FPCR since 2014 in commit:

>     5959e25729a5 ("arm64: fpsimd: avoid restoring fpcr if the contents ha=
ven't change")

>   ... as described in the commit message, this was based on an
>   expectation of implementation style, and was not based on
>   benchmarking.

Thanks, that clarifies the issues and addresses all the concerns I had.

--36wiTHak1laAI5AT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmoYb9EACgkQJNaLcl1U
h9Dpfgf8CAJOiRw31sAIWe8H3yaZEXezd/x30puODL3sR2Ozk0mtgYr2ut7fx1at
PuC7RVIxZGxqjh2ctdUzYHUNR7E94pevOCx9AJ6I/mi08fM1UvgKknCd+auE+n0b
RVjUPEuLL6z/LKOi/G+xMJ4/B0AhRmnr378P+xhqmUixJan/c/F5+XO0rAdWKZhp
m0t26y6HEpe8qmwzntExQZns/jtZbba/3vdcWAgrhBZlCdjHTfujCKa4ubGi40CY
yMm+R0LYRHBEgxzkxS2NzXqZ3IJjq+QxviI1k/X9QREw42ZgjbxLqiLdPk+Fjkv5
qTjIXIuVn9S/iOg4xzmq5VrcE0Eo/w==
=7o2Z
-----END PGP SIGNATURE-----

--36wiTHak1laAI5AT--
