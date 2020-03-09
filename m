Return-Path: <SRS0=IHVC=42=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB6A9C10F27
	for <kvmarm@archiver.kernel.org>; Mon,  9 Mar 2020 17:55:20 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 695B920727
	for <kvmarm@archiver.kernel.org>; Mon,  9 Mar 2020 17:55:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 695B920727
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D16034A1FA;
	Mon,  9 Mar 2020 13:55:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1VMlG4wFZihm; Mon,  9 Mar 2020 13:55:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B0F0D4A4A0;
	Mon,  9 Mar 2020 13:55:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6C1C04A483
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Mar 2020 13:55:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yMQ5THruqjPf for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Mar 2020 13:55:16 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 682654A1FA
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Mar 2020 13:55:16 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 101541FB;
 Mon,  9 Mar 2020 10:55:16 -0700 (PDT)
Received: from localhost (unknown [10.37.6.21])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 877C23F67D;
 Mon,  9 Mar 2020 10:55:15 -0700 (PDT)
Date: Mon, 9 Mar 2020 17:55:14 +0000
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH 12/18] arm64: kernel: Convert to modern annotations for
 assembly functions
Message-ID: <20200309175514.GL4101@sirena.org.uk>
References: <20200218195842.34156-1-broonie@kernel.org>
 <20200218195842.34156-13-broonie@kernel.org>
 <CAKv+Gu9Bt93hCaOUrgtfYWp+BU4gheVf2Y==PXVyMZcCssRLQg@mail.gmail.com>
 <20200228133718.GB4019108@arrakis.emea.arm.com>
 <20200228152219.GA4956@sirena.org.uk>
 <20200309175203.GE4124965@arrakis.emea.arm.com>
MIME-Version: 1.0
In-Reply-To: <20200309175203.GE4124965@arrakis.emea.arm.com>
X-Cookie: Above all things, reverence yourself.
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
Content-Type: multipart/mixed; boundary="===============0265228286663283589=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


--===============0265228286663283589==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="bFUYW7mPOLJ+Jd2A"
Content-Disposition: inline


--bFUYW7mPOLJ+Jd2A
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 09, 2020 at 05:52:03PM +0000, Catalin Marinas wrote:

> I queued this series for 5.7, apart from patch 12. I'll try to fix any
> conflicts with whatever patches I'm adding but may drop some of them if
> they conflict badly with code in -next (not likely). We'll revisit at
> -rc1 to see what's left.

Thanks.

--bFUYW7mPOLJ+Jd2A
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl5mgwEACgkQJNaLcl1U
h9C/Gwf+I7COBLhEJB5O4BpJwqHs8Eu6fm4Xs3yxlGbeuJsbvREuUQ6Nla07nK/y
3LjxWqI38XL2N7Ruw7KfHzAfvZa0yZIkERdKFnP3Ycy6tRNp8miugtgK4qrPyO9I
8wuH7ulbNMafqQVx4LQqQbLpRck31y4qUQk76JMjWFpqT23Hu/wCr+UpOKWc/Vke
eDb4XriX32xLsHDeh5W5FJL6vFkxYfgyhi9Tmw4C5EXTE+8Kn5FLls5as9GBUwEZ
jm4VHcWUntxBCjWaesLvxDPUazFabAJIjLVGwtqXKZO0/7yLzxf7fE0AKdG3PQc8
s5lYxilRm61ZWeaHvnDGcfoS0/wX7A==
=/gTP
-----END PGP SIGNATURE-----

--bFUYW7mPOLJ+Jd2A--

--===============0265228286663283589==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============0265228286663283589==--
