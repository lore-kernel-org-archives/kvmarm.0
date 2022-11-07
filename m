Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70A68C4332F
	for <kvmarm@archiver.kernel.org>; Mon,  7 Nov 2022 15:11:21 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D366A4B8B9;
	Mon,  7 Nov 2022 10:11:20 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5GR4W0n6uxhL; Mon,  7 Nov 2022 10:11:19 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A882B4B893;
	Mon,  7 Nov 2022 10:11:19 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 121FE4B877
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Nov 2022 10:11:19 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IdxzZTrFJRt8 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Nov 2022 10:11:18 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DFB464B84C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Nov 2022 10:11:17 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 4FBAEB811E7;
 Mon,  7 Nov 2022 15:11:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC3D5C433D6;
 Mon,  7 Nov 2022 15:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1667833875;
 bh=wVgLPr5v//yG11ovNQ85JwEVr3YQFb/RyVao7hWCqlk=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=V+0FY/orTZt8mOb9jO02zZqXQwJgbcIqcYmXk5XODvNm+QnTru0kqiwIgZzaEb2yr
 9uvDsafbDYZ01c2d00etldMGUDc1+dUoRrbFmBhB1N0OgKexApvC2ihASE52yjy17S
 Lsrae0+c0CNWW5+llsspm0oIcF55qpxyF7NGLJ0nXjE5JAehXOUn3LqSvqHved8SRL
 WZLO3njMrB5bVHxGYdg5+WK661dy1GDviEhzfDKFjKg4FcqnWV4JhylF2jpCqN2W0M
 YKMBEkMrKHeGxQ/+EHwhvg6xcKoqSfufHleq5vjKgtjXBnIeZ9FwwsBR6Z3xuJI31x
 kXzAi1jwTAmMw==
Date: Mon, 7 Nov 2022 15:11:07 +0000
From: Mark Brown <broonie@kernel.org>
To: Rob Herring <robh@kernel.org>
Subject: Re: [PATCH v3 3/8] arm64/sysreg: Convert SPE registers to automatic
 generation
Message-ID: <Y2kgC9QlBwvXTLe6@sirena.org.uk>
References: <20220825-arm-spe-v8-7-v3-0-87682f78caac@kernel.org>
 <20220825-arm-spe-v8-7-v3-3-87682f78caac@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20220825-arm-spe-v8-7-v3-3-87682f78caac@kernel.org>
X-Cookie: Minimum charge for booths.
Cc: Peter Zijlstra <peterz@infradead.org>,
 Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 Arnaldo Carvalho de Melo <acme@kernel.org>, linux-perf-users@vger.kernel.org,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@kernel.org>,
 Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 Namhyung Kim <namhyung@kernel.org>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 James Clark <james.clark@arm.com>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4855655160262654782=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


--===============4855655160262654782==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="2G3Dfetw2HrPyugm"
Content-Disposition: inline


--2G3Dfetw2HrPyugm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 04, 2022 at 10:55:03AM -0500, Rob Herring wrote:

> Convert all the SPE register defines to automatic generation. No
> functional changes.
>=20
> New registers and fields for SPEv1.2 are added with the conversion.
>=20
> Some of the PMBSR MSS field defines are kept as the automatic generation
> has no way to create multiple names for the same register bits. The
> meaning of the MSS field depends on other bits.

Reviewed-by: Mark Brown <broonie@kernel.org>

> +Sysreg	PMSNEVFR_EL1	3	0	9	9	1
> +Field	63:0	E
> +EndSysreg

JFTR as noted last time this looks nothing like the spec but is clearly
a sensible interpretation.

I do note that one advantage of doing this register by register rather
than en masse is that it makes it a lot easier to avoid re-reviewing the
same register...

--2G3Dfetw2HrPyugm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmNpIAoACgkQJNaLcl1U
h9DvBgf9EuKrsvAgMvRabqAgl2mo979wY3OQJcNNexlQAPguIlNJOpjdL2Dvko0o
oHza2RbBfzmfHVQEMoiqbN+VUN9QxV7jgiP/50FrhH3G5oADAMRfYY6ubrg6STfw
1/KlPkOiDj02yrS3S4rqH8gBbJ+OKWmxqFT2mINdB14b50FiSJ2++nKphUYHsS0D
IRzNoBLllDsd+NqlXoQ4ma12NpJPOCpF+UOnIha7ersIgXxzrWyNQEkw48uWyg+g
xjMyRJZvZW59hE4HPXl/6EypHNrnIBlAVzX+JE3vnep7cn5Y0STit5s53L7kkTsD
B9N0R8ar/bOBI7vJMDHmI7qHigyuew==
=WP8T
-----END PGP SIGNATURE-----

--2G3Dfetw2HrPyugm--

--===============4855655160262654782==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============4855655160262654782==--
