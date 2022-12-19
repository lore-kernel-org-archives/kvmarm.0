Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59634C4332F
	for <kvmarm@archiver.kernel.org>; Mon, 19 Dec 2022 15:00:40 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DA0AE4B882;
	Mon, 19 Dec 2022 10:00:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4QLZCnSnRCc2; Mon, 19 Dec 2022 10:00:35 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F2304B89D;
	Mon, 19 Dec 2022 10:00:35 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E8CA24B882
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Dec 2022 10:00:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id s8mxKB3BnfwX for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Dec 2022 10:00:33 -0500 (EST)
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1FE7B4B889
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Dec 2022 10:00:33 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by sin.source.kernel.org (Postfix) with ESMTPS id 0415FCE0F5D;
 Mon, 19 Dec 2022 15:00:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDE70C433D2;
 Mon, 19 Dec 2022 15:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1671462024;
 bh=JbD1CERCvAqPiTchVboz7aWPTf4CqkVZl5hSSLWV8+Y=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=TWOHbnn13mEX9dougL+e1l5NCO4uC1JocxLiRTSuLMFPPooSOsduPqT9WpQeOtG6O
 w2zJBKPFa+CLq98BUmfOJTMjK7bvGLBCpvveQ1ekQ8bR2LmWkgnufJ4Obi/Awvwz3M
 n7qP1lNleQHNul8coOBFRf32nkDXxU7wxe4tfgcU8ogUOrPfC1Itbs9hxlkmwndsXj
 2rBH/FnRTPol7uGGixifpUdUvmPnbyxy+o72SDzNKVoOPR7m7cPSHLft1yAfwpc1h5
 lGiwqAGg8ay3BTPXtyoQlRsnMWvSY6wtMMPNexp2/Kzyu25GTC7kKoU8xhzOMlmWgc
 3GMADB2IG5MTQ==
Date: Mon, 19 Dec 2022 15:00:15 +0000
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v3 1/7] arm64/sysreg: Convert CCSIDR_EL1 to automatic
 generation
Message-ID: <Y6B8fzaFSwmJ5VC1@sirena.org.uk>
References: <20221218051412.384657-1-akihiko.odaki@daynix.com>
 <20221218051412.384657-2-akihiko.odaki@daynix.com>
 <87cz8hez0i.wl-maz@kernel.org>
 <1ef32b0c-6cee-75f7-e1e0-ede1f5b9a016@daynix.com>
 <87bko0g8m2.wl-maz@kernel.org>
MIME-Version: 1.0
In-Reply-To: <87bko0g8m2.wl-maz@kernel.org>
X-Cookie: I brake for chezlogs!
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
Content-Type: multipart/mixed; boundary="===============2612328144419890194=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


--===============2612328144419890194==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="u5kU4UMJcC0W4wyS"
Content-Disposition: inline


--u5kU4UMJcC0W4wyS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Dec 18, 2022 at 01:11:01PM +0000, Marc Zyngier wrote:
> Akihiko Odaki <akihiko.odaki@daynix.com> wrote:

> > arch/arm64/tools/gen-sysreg.awk does not allow a hole and requires all
> > bits are described hence these descriptions. If you have an
> > alternative idea I'd like to hear.

> I'd simply suggest creating an UNKNOWN field encompassing bits
> [21:28]. Alternatively, feel free to try the patch below, which allows
> you to describe these 4 bits as "Unkn	31:28", similar to Res0/Res1.

I agree, where practical we should add new field types and other
features as needed rather than trying to shoehorn things into what the
tool currently supports.  It is very much a work in progress which can't
fully represent everything in the spec yet.  For things like the
registers with multiple possible views it's much more effort which
shouldn't get in the way of progress on features but with something like
this just updating the tool so we can match the architecture spec is the
right thing.

> Define an 'Unkn' field type modeled after the Res0/Res1 types
> to allow such description. This allows the generation of

I'd be tempted to spell out Unknown fully since Unkn is not such a
common abbreviation but I can see the desire to keep the name shorter
and it doesn't really matter so either way:

Reviewed-by: Mark Brown <broonie@kernel.org>

--u5kU4UMJcC0W4wyS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmOgfH4ACgkQJNaLcl1U
h9BsAgf/SbrRls2l2YJ4ke3IATlZrBSMsZVI98FuGsLwHeKknHxUHGkJKrMfdbk4
diEmW0Bk69Cn4VAzsMwg7l0x8JMGJwE94sMyUwX0DOC0r1xI/KrAxhS/PetsIlVv
tJQPP9FYO33oJmjDsAqCwaO90Qkdk4I7QrDos/eO+yucA6tISgrM95FSufMwTZqX
9pu8j5CizDnf77pZIXVUjhDMVzdqJsiGg3YTuHZpDXdfXq/COW4ECCMKB25GmCSh
/pB2NEvWJoX6ZiDoyi7XxokmMv8nOPnMYyahTM1jO2N5tEcav9E4t9levchdQ5n0
PTo3pY7o2LisFYorkFn5o4eys9hYRw==
=BwsC
-----END PGP SIGNATURE-----

--u5kU4UMJcC0W4wyS--

--===============2612328144419890194==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============2612328144419890194==--
