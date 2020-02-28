Return-Path: <SRS0=iQbv=4Q=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA80FC3F2CD
	for <kvmarm@archiver.kernel.org>; Fri, 28 Feb 2020 15:22:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 63C812469F
	for <kvmarm@archiver.kernel.org>; Fri, 28 Feb 2020 15:22:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 63C812469F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A03D44AF1E;
	Fri, 28 Feb 2020 10:22:25 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lwfplA85lXHw; Fri, 28 Feb 2020 10:22:24 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8188B4AFBF;
	Fri, 28 Feb 2020 10:22:24 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8FDCA4AFB7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Feb 2020 10:22:23 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zBDMlxR12yXO for <kvmarm@lists.cs.columbia.edu>;
 Fri, 28 Feb 2020 10:22:22 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6B5BE4AF1E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Feb 2020 10:22:22 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C442831B;
 Fri, 28 Feb 2020 07:22:21 -0800 (PST)
Received: from localhost (unknown [10.37.6.21])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 457573F73B;
 Fri, 28 Feb 2020 07:22:21 -0800 (PST)
Date: Fri, 28 Feb 2020 15:22:19 +0000
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH 12/18] arm64: kernel: Convert to modern annotations for
 assembly functions
Message-ID: <20200228152219.GA4956@sirena.org.uk>
References: <20200218195842.34156-1-broonie@kernel.org>
 <20200218195842.34156-13-broonie@kernel.org>
 <CAKv+Gu9Bt93hCaOUrgtfYWp+BU4gheVf2Y==PXVyMZcCssRLQg@mail.gmail.com>
 <20200228133718.GB4019108@arrakis.emea.arm.com>
MIME-Version: 1.0
In-Reply-To: <20200228133718.GB4019108@arrakis.emea.arm.com>
X-Cookie: There Is No Cabal.
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
 Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <maz@kernel.org>,
 kvmarm <kvmarm@lists.cs.columbia.edu>,
 linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
 Will Deacon <will@kernel.org>, "David S. Miller" <davem@davemloft.net>,
 "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
 <linux-crypto@vger.kernel.org>
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
Content-Type: multipart/mixed; boundary="===============6063282828981046151=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


--===============6063282828981046151==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="1yeeQ81UyVL57Vl7"
Content-Disposition: inline


--1yeeQ81UyVL57Vl7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 28, 2020 at 01:37:18PM +0000, Catalin Marinas wrote:
> On Fri, Feb 28, 2020 at 01:41:21PM +0100, Ard Biesheuvel wrote:

> > This hunk is going to conflict badly with the EFI tree. I will
> > incorporate this change for v5.7, so could you please just drop it
> > from this patch?

Will do for any reposts.

> I wonder whether it would be easier to merge all these patches at
> 5.7-rc1, once most of the major changes went in.

Only thing I can think that doing that might cause issue with is if
people are doing work that's not likely to make it in this cycle then
it'd be some extra rebasing or carrying of out of tree patches they'd
need to do (plus obviously this series might pick up new conflicts
itself).  It's not a completely automated process unfortunately,
especially with trying to fix up some of the problems with the existing
annotations changing the output.  But yeah, we could do that.

--1yeeQ81UyVL57Vl7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl5ZMCgACgkQJNaLcl1U
h9Di0Qf/VWvMvqHepDi/x0ZXGJfY242zVkoLHcIp9UV0+4JT0IyKVRbIsBf/DfdM
CjvFlDIqp3m35lh9dEDlKUi+0Pynyd/SXEsIyGf4vl5OrWGVUZoTSiWsy00gWp5e
RFpAo4g4nxGRc4t86UeHZyu9D2+ezFOioFfmCWWmOZZOVKV+DBph+ct/pRqLogJ8
PyTeSZqJZYmOHQxxe68/jU/bIIhohgxh15poE4vYjVZZaD82+oNANqy0seFJ/rSu
7Lr3SduLDq7WeVMo/jYb4u3uOZVHvBCKwhktF1c3t602RBQhm+8pNKh33AFUOsRO
twDGT/8JVuS8HI1K0+7fIlfd4zPxHg==
=/8sV
-----END PGP SIGNATURE-----

--1yeeQ81UyVL57Vl7--

--===============6063282828981046151==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============6063282828981046151==--
