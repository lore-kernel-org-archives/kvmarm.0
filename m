Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34FFEC4332F
	for <kvmarm@archiver.kernel.org>; Mon, 19 Dec 2022 14:51:03 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B6D134B8A0;
	Mon, 19 Dec 2022 09:51:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id s3t6smwPAxnc; Mon, 19 Dec 2022 09:51:01 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B39814B8A3;
	Mon, 19 Dec 2022 09:51:01 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 18AA44B89F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Dec 2022 09:51:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id u1GYqyebUmMu for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Dec 2022 09:50:57 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C74384B887
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Dec 2022 09:50:57 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 689F0B80E4F;
 Mon, 19 Dec 2022 14:50:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0526C433D2;
 Mon, 19 Dec 2022 14:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1671461455;
 bh=QxVPwZP8m+jsCHTTeqcdIpyCXjsptf4gIKs8BSGJBL4=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=Fly9y9GIhJwybfs+jroXKqdVzCJpHS4TqdxKwymyTZFKCIMk0mi2eb8IXsa1IZUFB
 7+N+Hv2jidaCNb+0CgIDr+p5cXuRXnCNPRwrY3Lad7uXROxpPf2m0t0wvJ+JEYoktP
 jUoI2CdzAkou6aamyEzAUZPpNMsY8icPDBWhpyL0SASaXMFRNrbrfHoOVFypoR6loJ
 ZQDnsNIP2VEhwT+0l0Kro4cXki1gCwCE3zegD+ucmls7eITliIHHuWXq7cZsK8yisN
 4uWwNj4weUVrPQXC0R2wpDweNqgjFdQK+JYM9wF5u6M3Utnyhs5KJhr0SK7qJd30Jg
 KKM2Kjx3NLJ8w==
Date: Mon, 19 Dec 2022 14:50:48 +0000
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 1/3] arm64/sysreg: Add CCSIDR2_EL1
Message-ID: <Y6B6SNADJQkNRoLO@sirena.org.uk>
References: <20221211051700.275761-1-akihiko.odaki@daynix.com>
 <20221211051700.275761-2-akihiko.odaki@daynix.com>
 <Y6BjQiR5gUhIAyIS@sirena.org.uk>
 <6363f9d0979be5aedfb04db4810b71a4@kernel.org>
MIME-Version: 1.0
In-Reply-To: <6363f9d0979be5aedfb04db4810b71a4@kernel.org>
X-Cookie: Pay toll ahead.
Cc: Alyssa Rosenzweig <alyssa@rosenzweig.io>, Hector Martin <marcan@marcan.st>,
 Akihiko Odaki <akihiko.odaki@daynix.com>,
 Mathieu Poirier <mathieu.poirier@linaro.org>, Will Deacon <will@kernel.org>,
 Sven Peter <sven@svenpeter.dev>, linux-kernel@vger.kernel.org,
 asahi@lists.linux.dev, Catalin Marinas <catalin.marinas@arm.com>,
 kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
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
Content-Type: multipart/mixed; boundary="===============8554060694131463434=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


--===============8554060694131463434==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="mYp6zYSC3VWc2bxT"
Content-Disposition: inline


--mYp6zYSC3VWc2bxT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Dec 19, 2022 at 02:47:25PM +0000, Marc Zyngier wrote:

> Since you're reviewing some of this, please have a look at v3[1],
> which outlined a limitation of the sysreg generation tool as well
> as a potential fix.

Hrm, would've been nice to be CCed on stuff for the tool :/

--mYp6zYSC3VWc2bxT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmOgekcACgkQJNaLcl1U
h9ATOwf+M1ng9YlS25c373o/kUeoQ5yAyHdggFm6EfdGWuWfd556L8Rr9T/1HCUR
mFg67pwzlcmhBwX/BHbdjzAjYWvNmP5LzKO7G46uEksPmxNc4WCriBBR8jlsOvR1
dj0JsWF58BWDZg8jcnuotHTUNcDvU5RfLG8T9jcmN4dUXOz0xa/fh02oQfnbr8vE
f4jcRljPZGpF6pWNdAfKDJSvjrSq5QBU1gwo88nKXnuY1gq3GI6aLNFun/CP4iVm
1msraBt+TC6A2S09vcA6jaGW2bfgZGmWIS27Y3ZN+IzNlwKZ1YfsezF4EiLk/BmG
OeaDj3aqNy6h8EgioVkCGVZ8EyRisA==
=epbW
-----END PGP SIGNATURE-----

--mYp6zYSC3VWc2bxT--

--===============8554060694131463434==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============8554060694131463434==--
