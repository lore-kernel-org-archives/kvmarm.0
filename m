Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1EF6C001B2
	for <kvmarm@archiver.kernel.org>; Thu, 22 Dec 2022 11:45:44 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C72F4B9EA;
	Thu, 22 Dec 2022 06:45:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id EtHZ3yPSn4sT; Thu, 22 Dec 2022 06:45:39 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AC11D4BA85;
	Thu, 22 Dec 2022 06:45:39 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B4354B9EA
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Dec 2022 06:45:38 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ss6+BaCZHf7u for <kvmarm@lists.cs.columbia.edu>;
 Thu, 22 Dec 2022 06:45:37 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 33EEE4BA81
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Dec 2022 06:45:37 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id B9295B81B93;
 Thu, 22 Dec 2022 11:45:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DB3EC433EF;
 Thu, 22 Dec 2022 11:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1671709534;
 bh=Y1cUmhwFo68wOtgbAIPgTlOJqv2cgBsiYek52x4QyLI=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=NhqH8gIh8S0yGDM0PVbhOtJk43xinTwAfGKXCt8ddSLPmt7TbaegxtQ69r2Ninb0G
 H6lLZtScQoHkXCoSnWhj4xCI155ft3FBmzyIp7g0XS2ahTd+Wpe0zxV5QVau5vXc9f
 ErCMQIKyIy5cbddGIYhY0eeKn23yGov6apS7m2sM4yWKx2QwMJZ2ZVIOB2vxSgAGzq
 f7+dj3ldV4IRrBgKKUIt25Bx+PMpfRf28oNs+MzQNFRs6C3h5EyHSPd9SBiwPBFDrk
 YNOV3uMOZRcymr51KlhoTLIXCXfRM6PdRmHACURz5FcjGFLOjTyuRz1ZVWhf3jQTB2
 IVcoNEFhXp6pA==
Date: Thu, 22 Dec 2022 11:45:27 +0000
From: Mark Brown <broonie@kernel.org>
To: Akihiko Odaki <akihiko.odaki@daynix.com>
Subject: Re: [PATCH v4 2/7] arm64/sysreg: Convert CCSIDR_EL1 to automatic
 generation
Message-ID: <Y6RDV/mQ2mo+/YFk@sirena.org.uk>
References: <20221221204016.658874-1-akihiko.odaki@daynix.com>
 <20221221204016.658874-3-akihiko.odaki@daynix.com>
MIME-Version: 1.0
In-Reply-To: <20221221204016.658874-3-akihiko.odaki@daynix.com>
X-Cookie: Yes, but which self do you want to be?
Cc: Alyssa Rosenzweig <alyssa@rosenzweig.io>, Hector Martin <marcan@marcan.st>,
 Mathieu Poirier <mathieu.poirier@linaro.org>, Marc Zyngier <maz@kernel.org>,
 Sven Peter <sven@svenpeter.dev>, linux-kernel@vger.kernel.org,
 Will Deacon <will@kernel.org>, asahi@lists.linux.dev,
 Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.linux.dev,
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
Content-Type: multipart/mixed; boundary="===============5604558559325281733=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


--===============5604558559325281733==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="8fq1k0An7gXXTJSP"
Content-Disposition: inline


--8fq1k0An7gXXTJSP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 22, 2022 at 05:40:11AM +0900, Akihiko Odaki wrote:
> Convert CCSIDR_EL1 to automatic generation as per DDI0487I.a.

Might've been worth mentioning the multiple layouts in the commit log
but not a big deal.  Handling them does seem like something we can defer
to followup work along with improving the tooling:

Reviewed-by: Mark Brown <broonie@kernel.org>

--8fq1k0An7gXXTJSP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmOkQ1cACgkQJNaLcl1U
h9CUewf/XdZaVW2Uv/Z3iqOKHr50VNgD1bhn33H2JxeBdFCuW9DEeqk+UmT9OAn1
/M6ad30jxa09jOzWoXjzXnYv+0C8j3PbqHq2kSzC3STG+QNbXfBjsvd1tZaOJatS
RRAB64oajyZnJJ3M8Tz1Nw43kLLOajfnGUBrIuGS0PIncg6MwVHkoL2bLNdaSlIE
/ExWW/i18Y0Q2ac08HqRWdwxCvlYDz09+2ErTO5Y1tfgpMLFwT+4mzGGgIJj+xTO
08pzg4SobMMhopkHAeDlaX8WeAOaGqWRbAObM69IhckyHp9Pb0J9cAbPeTfIY/WU
JtFMeiXboDywUYGBM7B+6pt8N4r5Mg==
=0KQ7
-----END PGP SIGNATURE-----

--8fq1k0An7gXXTJSP--

--===============5604558559325281733==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============5604558559325281733==--
