Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DEFDC4332F
	for <kvmarm@archiver.kernel.org>; Mon, 19 Dec 2022 17:52:19 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C41114B90B;
	Mon, 19 Dec 2022 12:52:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id z7qUw7gy5pad; Mon, 19 Dec 2022 12:52:17 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 88C774B906;
	Mon, 19 Dec 2022 12:52:17 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 658324B901
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Dec 2022 12:52:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id x3IxiD7Dc8uY for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Dec 2022 12:52:15 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 34BC64B8D3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Dec 2022 12:52:15 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 34A1E61093;
 Mon, 19 Dec 2022 17:52:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33C2AC433EF;
 Mon, 19 Dec 2022 17:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1671472333;
 bh=omnk1EvftJxQZKK4tFNl78eH7ggIgQG8DRMsnWyBp38=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=dHRiMbVZ3RofwcmucbbxHiWnKKCyyOlCx1ztiN1W8TWZJOMTSy1A8lM0131J+SQ4W
 IxEGB9p/fKEijrcT6ntjOGiRswr1zujSVUh+YQEJdmumqVwAeUsBJmICp/UsuJkavX
 neDh1bJ96fNh9J0+Dmv7ienF2yJzvbtnWe8Eph8gmqL4zYZHu+mY7Wv4jqC3tGJJy3
 vbvQ1Al9FdpIzb8iUWRSx6pnHhjHoQI84bUndWDGGTZkFoatbWKorzyiZcyvgbaDRq
 296Dh4cd60qnYK1Aaj5DeZwFua1efEq4UtKkR/xxPFlL51pKUCHcdVcqffqN6RlBiV
 e51q1ZLqj90uA==
Date: Mon, 19 Dec 2022 17:52:06 +0000
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v3 1/7] arm64/sysreg: Convert CCSIDR_EL1 to automatic
 generation
Message-ID: <Y6CkxueMwWPBMV7h@sirena.org.uk>
References: <20221218051412.384657-1-akihiko.odaki@daynix.com>
 <20221218051412.384657-2-akihiko.odaki@daynix.com>
 <87cz8hez0i.wl-maz@kernel.org>
 <1ef32b0c-6cee-75f7-e1e0-ede1f5b9a016@daynix.com>
 <87bko0g8m2.wl-maz@kernel.org> <Y6B8fzaFSwmJ5VC1@sirena.org.uk>
 <86o7rzpg6i.wl-maz@kernel.org>
MIME-Version: 1.0
In-Reply-To: <86o7rzpg6i.wl-maz@kernel.org>
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
Content-Type: multipart/mixed; boundary="===============0323513121143038458=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


--===============0323513121143038458==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="oz/pzyR4HiMnUm6B"
Content-Disposition: inline


--oz/pzyR4HiMnUm6B
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 19, 2022 at 03:27:17PM +0000, Marc Zyngier wrote:
> Mark Brown <broonie@kernel.org> wrote:

> > fully represent everything in the spec yet.  For things like the
> > registers with multiple possible views it's much more effort which
> > shouldn't get in the way of progress on features but with something like
> > this just updating the tool so we can match the architecture spec is the
> > right thing.

> I was tempted to add a Namespace tag that wouldn't generate the sysreg
> #defines, but only generate the fields with a feature-specific
> namespace. For example:

I think this is roughly where we'd end up - I was using the term view
when thinking about it but that's just bikeshed.

> Sysreg	CCSIDR_EL1	3	1	0	0	0
> Res0	63:32
> Unkn	31:28
> Field	27:13	NumSets
> Field	12:3	Associativity
> Field	2:0	LineSize
> EndSysreg
>=20
> Namespace CCIDX CCSIDR_EL1
> Res0	63:56
> Field	55:32	NumSets
> Res0	31:25
> Field	24:3	Associativity
> Field	2:0	LineSize
> EndSysreg

Yeah, something like that.  I think we also want a way to label bits in
the root register as only existing in namespaces/views for things where
there's no default (eg, where a feature adds two views at once or things
have been there since the base architecture), and I wasn't sure if it
made sense to nest the declaration of the views inside the Sysreg (I'm
tempted to think it's more trouble than it's worth especially on the
tooling side).

I also wanted to go through and do an audit of all the current registers
to make sure there were no nasty cases that'd complicate things.  I
don't think there'd be anything but...

> the later generating:

> #define CCIDR_EL1_CCIDX_RES0		(GENMASK(63, 56) | GENMASK(31, 25))
> #define	CCIDR_EL1_CCIDX_NumSets		GENMASK(55, 32)
> #define	CCIDR_EL1_CCIDX_Associativity	GENMASK(24, 3)
> #define CCIDR_EL1_CCIDX_LineSize	GENMASK(2, 0)

> Thoughts?

Definitely that for the output.

--oz/pzyR4HiMnUm6B
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmOgpMYACgkQJNaLcl1U
h9DU0Af/SvoqDYexlOme2j0EORslcib1fD+HrBcMgXD/y5b//5a3p3SAmFlAd4P3
pITNOWvrGAqXP/YLGgwMnnHaZqSk/lHr5+FvqNJPuYPesoqDVIC7essCYZxx/7Oj
A1/UNsvXnMc8PctXZwv8zUPDYv0K3kgr6Tyh/gkeCU1MSzoKLoSTBQ7R3fa2KkC1
RTjeUddshIpTQwHmB+I6YNKCAirDHOs4oF6A5fyrh+lOIyUXmer7tMTX0SEKkbtz
zdHKY0Ul8u0P0IQm65LWYBeC1pz8rwp7RBhKkWbGMORv24PaeI5t1yzxeJhdFYLN
yYJbS34/t/gl9viuV6jBiFvnr3meVA==
=Gj9m
-----END PGP SIGNATURE-----

--oz/pzyR4HiMnUm6B--

--===============0323513121143038458==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============0323513121143038458==--
