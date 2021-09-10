Return-Path: <SRS0=KxuI=OA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B47DC433F5
	for <kvmarm@archiver.kernel.org>; Fri, 10 Sep 2021 08:30:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B56186113A
	for <kvmarm@archiver.kernel.org>; Fri, 10 Sep 2021 08:30:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org B56186113A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 408334B19F;
	Fri, 10 Sep 2021 04:30:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GqLZnTXmsNkK; Fri, 10 Sep 2021 04:30:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 461B34B17E;
	Fri, 10 Sep 2021 04:30:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0C1FA4B156
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Sep 2021 04:30:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2EGHlWlrYbal for <kvmarm@lists.cs.columbia.edu>;
 Fri, 10 Sep 2021 04:30:53 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F047F4B105
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Sep 2021 04:30:52 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 804DE610C7;
 Fri, 10 Sep 2021 08:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1631262650;
 bh=SPE/jxAWcGR+hp29mSZ8jiX1DlvUPpFpsR5GhteB0/Y=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=rdJTsYlW1nmMWC/XtoK6daUP0VO8FY3FIh1eEbhc0bA4TLMp4fdNC/Ao4iwuJXK3D
 dGt5CnHrKC4JPe2ecUBMN+m+xd4jNM3dutWCGFPHphKFjhrflJ3sRsyv+Q2vGOIPKA
 noZtdu76LaegO4L2ET5NFaMoRI+VHTXjCGe431PTdzXiVqjs7ShWcIQT0bD82ZvPbP
 4TrEeSGJuduSBz7QKG0Qll8pN6a6vBsuxLt/lbdkJ8UpNRuAlAS9pGiPia/tDUjrxH
 Q/mQsefp9NxaMmU2pdVLcUXvGXw1DnI+jYAwaggg+KqSvXHe4M49w74RAo/4cxc5sW
 iW6ChlD5IMz3g==
Date: Fri, 10 Sep 2021 09:30:11 +0100
From: Mark Brown <broonie@kernel.org>
To: Raghavendra Rao Ananta <rananta@google.com>
Subject: Re: [PATCH v4 02/18] KVM: arm64: selftests: Add sysreg.h
Message-ID: <20210910083011.GA4474@sirena.org.uk>
References: <20210909013818.1191270-1-rananta@google.com>
 <20210909013818.1191270-3-rananta@google.com>
 <20210909171755.GF5176@sirena.org.uk>
 <CAJHc60yJ6621=TezncgsMR+DdYxzXY1oF-QLeARwq8HowH6sVQ@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAJHc60yJ6621=TezncgsMR+DdYxzXY1oF-QLeARwq8HowH6sVQ@mail.gmail.com>
X-Cookie: You are standing on my toes.
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
 linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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
Content-Type: multipart/mixed; boundary="===============4759820707852993463=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


--===============4759820707852993463==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="SLDf9lqlvOQaIe6s"
Content-Disposition: inline


--SLDf9lqlvOQaIe6s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Sep 09, 2021 at 01:06:31PM -0700, Raghavendra Rao Ananta wrote:
> On Thu, Sep 9, 2021 at 10:18 AM Mark Brown <broonie@kernel.org> wrote:

> > >  create mode 100644 tools/testing/selftests/kvm/include/aarch64/sysreg.h

> > Can we arrange to copy this at build time rather than having a duplicate
> > copy we need to keep in sync?  We have some stuff to do this for uapi
> > headers already.

> That's a great idea actually (I wasn't aware of it). But, probably
> should've mentioned it earlier, I had a hard time compiling the header
> as is so I modified it a little bit and made the definitions of
> [write|read]_sysreg_s() similar to the ones in kvm-unit-tests.
> I'll try my best to get the original format working and try to
> implement your idea if it works.

One option would be to do something like split out the bits that can be
shared into a separate header which can be included from both places and
then have the header with the unsharable bits include that.  Something
like sysreg.h and sysreg_defs.h for example.

--SLDf9lqlvOQaIe6s
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmE7F5IACgkQJNaLcl1U
h9DaOwf+IKLvC2prK1SBAm+BeUSM4HW6iFJLUaEoQBFNBFbKI1JLEvcDGWwF4PQ/
zF8K1mWNAZNuqG3g3sx1pZ++IXy2reWVG6Dchp8SOs20ahX654NRhdALQ8xHmgtH
CHUDOB0Yh4TnmPiaKSbPvAGb0k3qgc+Et/45zJVhfejUqH7o6HYNMzzT296sGKak
0tST6itO7q+JqfrNOxp6FXJNB+ikd59ByaA06Xbv7jvP3xp8cYVRuOy42QhWi3Wo
XAIw3BInkhRgwi+/CdRtKhwq1sm1+beeBZ90DgsLCgb1Z1phbVRMiUcbFhzEQ9Tn
o4+sFQj+1FxkCY0Os7WkC2bBY/o1uQ==
=XPRc
-----END PGP SIGNATURE-----

--SLDf9lqlvOQaIe6s--

--===============4759820707852993463==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============4759820707852993463==--
