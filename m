Return-Path: <SRS0=Bd71=4C=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49473C2BA83
	for <kvmarm@archiver.kernel.org>; Fri, 14 Feb 2020 15:04:41 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D0A9224649
	for <kvmarm@archiver.kernel.org>; Fri, 14 Feb 2020 15:04:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D0A9224649
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 247624AEA5;
	Fri, 14 Feb 2020 10:04:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id CFe8iQzLM-MQ; Fri, 14 Feb 2020 10:04:39 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 15E4A4AE95;
	Fri, 14 Feb 2020 10:04:39 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 36BFD4AE95
 for <kvmarm@lists.cs.columbia.edu>; Fri, 14 Feb 2020 10:04:38 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id I7+ugZglqY5H for <kvmarm@lists.cs.columbia.edu>;
 Fri, 14 Feb 2020 10:04:37 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 24ED14A5A3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 14 Feb 2020 10:04:37 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B4156328;
 Fri, 14 Feb 2020 07:04:36 -0800 (PST)
Received: from localhost (unknown [10.37.6.21])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 363BC3F6CF;
 Fri, 14 Feb 2020 07:04:36 -0800 (PST)
Date: Fri, 14 Feb 2020 15:04:34 +0000
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH] arm64: kvm: Annotate assembly using modern annoations
Message-ID: <20200214150434.GO4827@sirena.org.uk>
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
Content-Type: multipart/mixed; boundary="===============4245105576788195669=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


--===============4245105576788195669==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="LwbuP8dfxhLLLUfV"
Content-Disposition: inline


--LwbuP8dfxhLLLUfV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 14, 2020 at 02:19:18PM +0000, Marc Zyngier wrote:

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

I just realized that the same structure is also being used for
__smccc_workaround_1_smc which doesn't have such an obviously fixed
size - am I missing something with that one?  I'll take a look at it
anyway.

--LwbuP8dfxhLLLUfV
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl5GtwEACgkQJNaLcl1U
h9C6/gf/dZ6CtQcwHYEN6oFASyB51OXGzJdcZkv/VIX98G/ByskCFG7dgYE4gsG6
hyT6EQu0CcXoTfCAz4FqNsryk1KYMDx71IAc5qrJlXu9iRyYDYB9awTGRsuU2On5
v8Xvha0NBJlHNC17Dk/NfbM1j/urZON4L5qUExVNdxSENwn+oPulMswqC5embVAh
nDaRYqmNJlqAL6RAJ14TLc6+jMOUU3QHcl77ZVsh24zxBNLrSw9wunUmSGG3utGo
3yfMzcOFRWZTOrL31/kWHd1CsKgglwwMf+kt/sKHfdAFvMcNfHToSZVh2k+sobE8
mjF9n7OPM3TwxJAnhonkX1OX6lYC6g==
=e5Z9
-----END PGP SIGNATURE-----

--LwbuP8dfxhLLLUfV--

--===============4245105576788195669==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============4245105576788195669==--
