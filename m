From: Mark Brown <broonie@kernel.org>
Subject: Re: next-20160222 build: 5 failures 9 warnings (next-20160222)
Date: Wed, 24 Feb 2016 13:16:44 +0900
Message-ID: <20160224041644.GS18327@sirena.org.uk>
References: <E1aXlz4-000486-Pb@optimist> <20160222100832.GX18327@sirena.org.uk>
 <56CAE5E6.7030707@arm.com> <20160224032842.GK18327@sirena.org.uk>
 <20160224144859.027a3564@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8308784072604412626=="
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B3E4D412E6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Feb 2016 23:10:29 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id M9bLUVJF7xoP for <kvmarm@lists.cs.columbia.edu>;
 Tue, 23 Feb 2016 23:10:29 -0500 (EST)
Received: from mezzanine.sirena.org.uk (mezzanine.sirena.org.uk
 [106.187.55.193])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D5D4740FA2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Feb 2016 23:10:28 -0500 (EST)
In-Reply-To: <20160224144859.027a3564@canb.auug.org.au>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linaro-kernel@lists.linaro.org, kernel-build-reports@lists.linaro.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-next@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu


--===============8308784072604412626==
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="Y8YhpITADfETs1ua"
Content-Disposition: inline


--Y8YhpITADfETs1ua
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 24, 2016 at 02:48:59PM +1100, Stephen Rothwell wrote:
> On Wed, 24 Feb 2016 12:28:42 +0900 Mark Brown <broonie@kernel.org> wrote:

> > That didn't work out unfortunately, the error is still there today.

> Yeah, the patch didn't hit -next yesterday and I missed the opportunity
> to fix in manually.  However, it should be fixed in today's linux-next
> (out in a few hours, hopefully).

Ah, good - it was just too late rather than not working.

--Y8YhpITADfETs1ua
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJWzS6qAAoJECTWi3JdVIfQhE0H/RGT5Z5Tg43U/CdMcn4EtdsV
9c9aSnKZ74MM5TjOug2haucEbWGzjarzsSfv5cTQTsWcZ4/D7yRRTv2Q3J+qAuCI
UqyMGhYgAwPRm6vFXXj+jONIsBQ3mZoT4YrFyk1TnyzvVtMYY2mfTZsGThDG/Vdl
YB26uJRjGX+to4xGWyCGFKgdka5gvdpt/XXwFoSmI3QRRC3jysAJVfMamezyAt7h
QyBgusEFq+iJhc52MuWENkmMtoBTsclNQLNmu3xqxMuhlZY8xei5oUY3gpyzPl9d
vBgoO8auiuqWs4fDA++yw2U6EiPDxrrBKTK51HaDJagGrlGr8AZ5M/QyjZDxv8U=
=e6+k
-----END PGP SIGNATURE-----

--Y8YhpITADfETs1ua--

--===============8308784072604412626==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============8308784072604412626==--
