Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF1B31A23BC;
	Wed, 18 Dec 2024 13:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734527764; cv=none; b=itDM1xKP6TW+aoOdsdRwFptHEMPPVwT/vDMJR7KoKOPCezv+3YBU0+70pJwLnqLVOFD5SUCzyqr0KyIosFZH/pEy1F85OD53K3ty0gJfFfE/Zfq8fSihWhjNbWo/xNwZNS950g3uGAqnR8U1YwdSeBn5HFVm1+J3KDe984ZkD9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734527764; c=relaxed/simple;
	bh=l9forY4klmLDyr2OClnwW4+1ETo7go2MZPlvCu9Tm70=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JlSOcMLIGwq4AvowhTdPbVnV+TC4SYN2fpXZnBIT0Rc59TZK8dabWR6YqkBFWIENrOqNfT2cwnLB9M0EIDeCZmCpQFrDUjCznQaWWNlXWmSvaMEP0d1WBi0uGDPUp1Y7fXl/hkSri/oaXBfFAZedL/bbYa3SdO0hj5pb7SyRrco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IG8ey8h7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IG8ey8h7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7621C4CEE0;
	Wed, 18 Dec 2024 13:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734527764;
	bh=l9forY4klmLDyr2OClnwW4+1ETo7go2MZPlvCu9Tm70=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IG8ey8h7//M4ep2eQPtNzmQ8JBMXfkC0HjavAValvFR2p2oxKGATDfBRrwdyp10QI
	 5Te4pTFdFXcs6SdxHV9VBP4HjwDV28C47Ilz24ZQ/mtVnAAo7QSz2DmS9OHgSh9ZvF
	 imDlZQmSkSLNZMLnMC7uG7B+r+PN+M5smDvI++Fgi9B44WADmPA9meRdHYaajwzrez
	 RnfvXhtzGN41I/wa+t5fLW5mCrMHLvTOisq3JHgzQLr2E8SllGXbX8cg7qWeXWVlOC
	 zAtJC34JiB2ex/yb+GFV/E1/NAiDsTlyxOgdE+AV+mLVvXtgVtkgvFjxVyc0O5evwq
	 prjOiw8gzGccA==
Date: Wed, 18 Dec 2024 13:15:58 +0000
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Rob Herring <robh@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Jonathan Corbet <corbet@lwn.net>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	kvmarm@lists.linux.dev, linux-doc@vger.kernel.org
Subject: Re: [PATCH V3 6/7] arm64/boot: Enable EL2 requirements for
 FEAT_Debugv8p9
Message-ID: <bdd53fdb-9ba2-4d55-870f-9cb40e1e6b21@sirena.org.uk>
References: <20241216040831.2448257-1-anshuman.khandual@arm.com>
 <20241216040831.2448257-7-anshuman.khandual@arm.com>
 <20241216234251.GA629562-robh@kernel.org>
 <c64709f7-e1c6-482e-8665-912be50b15bd@arm.com>
 <CAL_Jsq+EO_s49sSK3JQQEDDpcndf4hSpM_gfoe8tZ8=4y3f-tg@mail.gmail.com>
 <86jzbxqrtw.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="txhY7J+znJqGvstk"
Content-Disposition: inline
In-Reply-To: <86jzbxqrtw.wl-maz@kernel.org>
X-Cookie: The heart is wiser than the intellect.


--txhY7J+znJqGvstk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 18, 2024 at 09:10:51AM +0000, Marc Zyngier wrote:

> But I don't think we should be prescriptive about the state of these
> registers, as long as the potential traps are correctly handled.

The rest of the document is written in terms of explicit register
values, if we're changing approach we should probably update all the
existing requirements to be written in the same way since having a mix
of approaches tends to be a big red flag that there should be different
handling.  Consistency will make the document clearer and easier for
people to work with.

FWIW there is an explict note in the document about the fact that it's
an as-if rule:

|                                                Where the values documented
| disable traps it is permissible for these traps to be enabled so long as
| those traps are handled transparently by higher exception levels as though
| the values documented were set.

=66rom when I raised this before.

--txhY7J+znJqGvstk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmdiyw0ACgkQJNaLcl1U
h9AC4Af/X9JZs6LZP10tQfJ6uKA8Yyksj9YhS5543bjN12DgFPQm0JsICS9sGEul
G5/NmFfdWBKCKdUc6lqA54+fM8OaeM4aS62sh1/V2dZF9sfNUH5GCwEJt93treZp
DRA4GBM7d1DPGE4hpHdsQry//bElhMdERuMyGtLiPuUQMzirXaqw7iKCGd7KjznO
+cl2mVx3k0y3YV2qNPyjmPHp2Bub5PgpqJO7/2bl4lkBZnotd2JLocKUrpMkW3c7
2p0+B7o+v99TUT0DsDelNf1afHOaz1T5kHjRYLJHzc8apkjiiboR2k9fYXVmnxhy
9jgklnvNB/i1DnMonWre4izlrkjEiQ==
=w+6F
-----END PGP SIGNATURE-----

--txhY7J+znJqGvstk--
