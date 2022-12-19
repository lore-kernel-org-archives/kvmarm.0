Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AB7CC4332F
	for <kvmarm@archiver.kernel.org>; Mon, 19 Dec 2022 13:12:49 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D247F4B895;
	Mon, 19 Dec 2022 08:12:48 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jg92HGHLQ49l; Mon, 19 Dec 2022 08:12:46 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 95F3F4B897;
	Mon, 19 Dec 2022 08:12:46 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 11C8A4B895
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Dec 2022 08:12:45 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Afj+khQ3gH5a for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Dec 2022 08:12:42 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C91AB4B894
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Dec 2022 08:12:42 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 7717F60D54;
 Mon, 19 Dec 2022 13:12:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7697AC433EF;
 Mon, 19 Dec 2022 13:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1671455560;
 bh=SiMFS9SNL7VYiasdR0xL2Aevm/BpT8USH6YhYIrsfUY=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=eqVew1bp3uy/a0JBIUl09xCTjov+uyF9y0VHQcgJTkpUQV3Q9yatct81MNxAI6T5Q
 vqC5Uzm8fN9jkotNS2GHIOMbxubhBhvMwCS7IcvKSoQQmrb5Lrvn53xI1qe3i19px9
 bFnaWGIXiCD5Fkg9bGm+IBx5AF7xN7f2AbQCgVfZYicHzaR9mXwE8NnjHUtLFtt1Qz
 9hkaYwOQS09wuZjjqWStfEUD0SWSo/jAHT1+6B96bohPEkFg+45+qusvXF9PBx2hPO
 06F12uVmyVUudH1tYGHATZt2qIviIWwx0O/LEKf+AASEGwxRa1owTJdMeAiJIdv31d
 nMchHFhuc1xBA==
Date: Mon, 19 Dec 2022 13:12:34 +0000
From: Mark Brown <broonie@kernel.org>
To: Akihiko Odaki <akihiko.odaki@daynix.com>
Subject: Re: [PATCH 1/3] arm64/sysreg: Add CCSIDR2_EL1
Message-ID: <Y6BjQiR5gUhIAyIS@sirena.org.uk>
References: <20221211051700.275761-1-akihiko.odaki@daynix.com>
 <20221211051700.275761-2-akihiko.odaki@daynix.com>
MIME-Version: 1.0
In-Reply-To: <20221211051700.275761-2-akihiko.odaki@daynix.com>
X-Cookie: Pay toll ahead.
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
Content-Type: multipart/mixed; boundary="===============1506932292999279636=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


--===============1506932292999279636==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="oTrc6UTzbBTSf7fh"
Content-Disposition: inline


--oTrc6UTzbBTSf7fh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Dec 11, 2022 at 02:16:58PM +0900, Akihiko Odaki wrote:
> CCSIDR2_EL1 was added with FEAT_CCIDX.

This corresponds to the definition in DDI0487I.a.

Reviewed-by: Mark Brown <broonie@kernel.org>

--oTrc6UTzbBTSf7fh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmOgY0EACgkQJNaLcl1U
h9AhTQf/SdZDrzwS6EDB4hBMBmeYOfYy8tMZjCFZ05VY8WKbOIpl2TpdAOUOVINE
mqpmP7yEg56sP+rldgR+KjcL0T1AF5pyKZ2kU+HQdzo11FiFg6e2ulTSl+VFG4Fn
ztcTgaWLUqTyttNyiBo7Suadzo/T7SsNIh7s5Rnd1USz4yvvtCasI3C/btgVGZIs
HLBhVNOdRhLP6HyuTi43qMAaIT+UO4I78tEtt+NABG1fCx0jlMdzaxZG+JyQtaeX
6yMxIOCHnc86P2vK1FeopSTYD2ZJbUy+LcX50HCKp/4OsU6SscxZ8t8MjOA8EgkW
AZw9As6VAbETFTDokR+8/RmJLt4BGg==
=6/73
-----END PGP SIGNATURE-----

--oTrc6UTzbBTSf7fh--

--===============1506932292999279636==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============1506932292999279636==--
