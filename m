Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3D7DEAC6;
	Tue, 17 Dec 2024 15:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734449452; cv=none; b=YKfG69zgjFn4hqnBNlC8koN3ESIK6oAR7iXva2vO0xKEekWUMpOzWWz9e6Sqg/LIwscS8ZnHXYpKxi6Ob8QLzUUcw8lFRZ+zsoOyQktyi2+zeTOgcDBzKRfyNVN9G3tMemgoCWSnic4A5MUNtDKnMbhBRGZO76m0NV6x3vhOPGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734449452; c=relaxed/simple;
	bh=CIAcHeU4KM0O0CufWD9C+h0Wc+x23DDtuyagNJApBrQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J3PsBRdk03Aul9UBkSTjJv1RiQceS/mXsm5sGf04h39e/TIb3V5dpB7kEz9JgNk0jeJgICVoQCHxLZBqCMcLD5UIWkScIjji4Hur+VtlzxgTkuyTtg/yezHk/BRzlONJhQ0L0XBbNrThLJZ+ClckAUy5Kt5I7BWOZzM5WkJqr2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fHdjj97s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fHdjj97s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 116FAC4CED3;
	Tue, 17 Dec 2024 15:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734449452;
	bh=CIAcHeU4KM0O0CufWD9C+h0Wc+x23DDtuyagNJApBrQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fHdjj97sxjzlNB3JK2Jpom62ElP+sskc6RpMxqUzFdy1MJIU8pdwrzCKmlqTxphtu
	 wZZYcZTr+b2roHFxNbQJ4PO3P+qWN+wcxgmSlFv/7fCBKCCISumweHZYvtzfy56fcv
	 TlGM1WzXWB06WMZiqF6m+tDkA3B0QiN3mKueXZniKxvmIwVpupZMhQYe8L5hWnKxZr
	 KmnzAza4mhqx0NKquNEaPmQn9KW3m95hs8MnGP07ejynBmVLG+x3BwsxU4zeI3Vn6+
	 wT8rtjDt+H8xxJ4u63aivg44oL2q52v7ek98DnJJynhJrcBpiozTK2AGttBDSM8Zc/
	 XtEFj9XkVyyBg==
Date: Tue, 17 Dec 2024 15:30:46 +0000
From: Mark Brown <broonie@kernel.org>
To: Rob Herring <robh@kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, maz@kernel.org,
	ryan.roberts@arm.com, Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH V2 18/46] arm64/sysreg: Add register fields for PMUACR_EL1
Message-ID: <a442bca4-d1c0-4f3e-ae13-4836caec2da9@sirena.org.uk>
References: <20241210055311.780688-1-anshuman.khandual@arm.com>
 <20241210055311.780688-19-anshuman.khandual@arm.com>
 <20241216231505.GA601635-robh@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="dR49XDTrrQMzBub5"
Content-Disposition: inline
In-Reply-To: <20241216231505.GA601635-robh@kernel.org>
X-Cookie: The sum of the Universe is zero.


--dR49XDTrrQMzBub5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 16, 2024 at 05:15:05PM -0600, Rob Herring wrote:
> On Tue, Dec 10, 2024 at 11:22:43AM +0530, Anshuman Khandual wrote:

> > +Sysreg	PMUACR_EL1	3	0	9	14	4

> I already added this and various other PMUv3.9 registers you've added=20
> here in v6.12 and v6.13. So are you on an old base or the tool allows=20
> multiple definitions? If the latter, that should be fixed.

The tool is written in awk and hence *really* dumb so it's not going to
notice this, and so long as the resulting definitions are identical the
compiler won't either.  It would indeed be nice if the tooling were able
to detect this.

--dR49XDTrrQMzBub5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmdhmSUACgkQJNaLcl1U
h9C1zwf/eDf1On3DPPEQMj1fRbUgVwTEP7S7Jc5mAoMoX8wBFrshSjIwgW9wg3B+
DS6A3ns+eySSevDhGpLNhRhuWchooLog1sTGI5O97W/nRI58uuoWyks9j3+AEVwz
ML8wD+D6C8gXRdid6N7Nd2zhiOFHa7A2L2KxDr0lxR3IrODIZKpgm3RhUo5v6jdy
OqLG2rOjBZVdK0wTiJyUwvYLMeNxu1Hc0d7qRfwHcLIVvUj5OlSxvZ3/YeYE0i8W
+0E8PlHFs7iRqOJ+vBpH8Ksp7SWkmwFNrT9yW/Qis8dJe3RwPmVLOXf6+prZNh9l
DRTSdF21zIoBq2h5t3q+3oCUyUgWPw==
=Opzu
-----END PGP SIGNATURE-----

--dR49XDTrrQMzBub5--
