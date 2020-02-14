Return-Path: <SRS0=Bd71=4C=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5186DC2BA83
	for <kvmarm@archiver.kernel.org>; Fri, 14 Feb 2020 14:52:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D4E962168B
	for <kvmarm@archiver.kernel.org>; Fri, 14 Feb 2020 14:52:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D4E962168B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 362EA4A531;
	Fri, 14 Feb 2020 09:52:25 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ncxEUqTnXeBv; Fri, 14 Feb 2020 09:52:24 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0FFB14AE9E;
	Fri, 14 Feb 2020 09:52:24 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C5C534A7FD
 for <kvmarm@lists.cs.columbia.edu>; Fri, 14 Feb 2020 09:52:22 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id R9VVI5992xs0 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 14 Feb 2020 09:52:21 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9314C4A531
 for <kvmarm@lists.cs.columbia.edu>; Fri, 14 Feb 2020 09:52:21 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C8E04328;
 Fri, 14 Feb 2020 06:52:20 -0800 (PST)
Received: from localhost (unknown [10.37.6.21])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4BC8E3F6CF;
 Fri, 14 Feb 2020 06:52:20 -0800 (PST)
Date: Fri, 14 Feb 2020 14:52:18 +0000
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH] arm64: kvm: Annotate assembly using modern annoations
Message-ID: <20200214145218.GN4827@sirena.org.uk>
References: <20200213153820.32049-1-broonie@kernel.org>
 <b25323d02c76441ee12c206f07907383@kernel.org>
 <20200214114027.GA4827@sirena.org.uk>
 <e8e8da7f1e02e9c2f8e67968697bdf85@kernel.org>
MIME-Version: 1.0
In-Reply-To: <e8e8da7f1e02e9c2f8e67968697bdf85@kernel.org>
X-Cookie: Shipping not included.
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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
Content-Type: multipart/mixed; boundary="===============7803602830886920341=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


--===============7803602830886920341==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="D9sZ58tf58331Q5M"
Content-Disposition: inline


--D9sZ58tf58331Q5M
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 14, 2020 at 02:19:18PM +0000, Marc Zyngier wrote:
> On 2020-02-14 11:40, Mark Brown wrote:
> > On Thu, Feb 13, 2020 at 09:36:56PM +0000, Marc Zyngier wrote:
> > > On 2020-02-13 15:38, Mark Brown wrote:

> > > >  	.align	11
> > > > -ENTRY(__bp_harden_hyp_vecs_start)
> > > > +SYM_CODE_START_NOALIGN(__bp_harden_hyp_vecs)
> > > > +SYM_INNER_LABEL(__bp_harden_hyp_vecs_start, SYM_L_GLOBAL)

> > > Why isn't SYM_CODE_START_NOALIGN enough? And what is the rational for

> > The _start and _end labels that were there before are explicitly
> > referenced by code, removing them would break the build.

> But if we're going to clean things up, I'd rather we actually do that.
> The only time __bp_harden_hyp_vecs_end is used is when computing the
> size of the vectors, and that'd better be BP_HARDEN_EL2_SLOTS * 2kB
> (which can be statically asserted at compile time).

OK, I'll drop this bit of the patch and send a separate change for this
since it's more than a direct substitution.

For reference the underlying goal here is to be able to use
SYM_FUNC_START to add BTI annotations to assembly functions for
in-kernel BTI, the cleanup is just a byproduct.

> > > the _NOALIGN, btw? I'd expect an alignment of 2kB to be more than
> > > enough.

> > So that the explicit .align above takes effect rather than anything the
> > macro decides to do, I'm trying to err on the side of caution here.

> I don't think we need this. The macros should do the right thing, and
> be fixed if they don't.

OK, I'll just use a regular annotation - the explicit .align isn't
documented so I don't really know what it's supposed to be doing.

--D9sZ58tf58331Q5M
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl5GtCEACgkQJNaLcl1U
h9BreggAgSerbtdbm5K5UiEHgG67hxxU6BHNa834eGlNqgI8m+g5oqW1fAgziN20
7/3iZlKvyiwOxJT3lHnzcWxIO6BAaYMA13e7rtbS9+FgUtkghQg6Ssu69U7YxOsl
+bLRBts5KorIN5N4rbzASY8d1rGVs6TlrkuhD0XvC3dRDPbp7GkdlfQTHVft21lE
LjnKPQnbWZokp+2mwypFsrZ3Cs5e/SKMZk+PuovNWArdugoojirFuoKuUoXB0kHs
cMKUubb8nt4NcU392PL+WLlyDrrx6+2WhRNIXh/3mUwNIbcriY+8Uk6JnkKAfLa8
SBRVSZzdw0X4NFD8qXRxQNtEC1kdGQ==
=mDv2
-----END PGP SIGNATURE-----

--D9sZ58tf58331Q5M--

--===============7803602830886920341==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============7803602830886920341==--
