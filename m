Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 319B4C433FE
	for <kvmarm@archiver.kernel.org>; Tue,  8 Feb 2022 19:00:39 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AFCD8400DB;
	Tue,  8 Feb 2022 14:00:38 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cn4nBw7u7Vrl; Tue,  8 Feb 2022 14:00:34 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C3A6A40597;
	Tue,  8 Feb 2022 14:00:34 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A45BA40597
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Feb 2022 14:00:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id j8EX41ZP3OzV for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Feb 2022 14:00:29 -0500 (EST)
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BF671400DB
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Feb 2022 14:00:28 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by sin.source.kernel.org (Postfix) with ESMTPS id 78FD8CE1C14;
 Tue,  8 Feb 2022 19:00:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF3E1C004E1;
 Tue,  8 Feb 2022 19:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1644346823;
 bh=qrS1Vlr/4mU9OvdM6IQ4PpO1KsGpMz/etCIFE5XJCqU=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=UVnBtXEQlxYHtLZxmvqA5oTtUzHJ4yEDraZ4v4d012OkoofVcc47uaMnwH6yx5GjX
 uJDsXfCowOs23SBSSkPCmNVPSwBF2VtIVIGZnBnLKqR9HcSzrGcv2HCCkVN37ZMULO
 cInvSPyP1+a6U/BAS80UCJsiEMv4EZfIuPlqYMC0BnVQ561jkVebGpdysNJgYVvo2a
 Nxue5p7KtcpIJckPlzsLmGi6EPSqTha6MTJJaAlywaY03r4MtKhgUg6nTSxJPDTUE4
 mCnYIyqmBV6hcNF8vMpecMvlklE+cuhzp05aBZ7TYyIrkAKLob/lnZFnC9Jl3qLHj8
 jvFw6n3fRi9YA==
Date: Tue, 8 Feb 2022 19:00:15 +0000
From: Mark Brown <broonie@kernel.org>
To: Shuah Khan <skhan@linuxfoundation.org>
Subject: Re: [PATCH v11 06/40] arm64/sme: Provide ABI documentation for SME
Message-ID: <YgK9v7u+FcBTB1ur@sirena.org.uk>
References: <20220207152109.197566-1-broonie@kernel.org>
 <20220207152109.197566-7-broonie@kernel.org>
 <49da0f58-7a20-e557-54c3-34bd7074f711@linuxfoundation.org>
 <YgKQTLwW+ha5XNx8@sirena.org.uk> <YgK4kKrSs6e9seG8@sirena.org.uk>
 <e6d76104-b7f6-1588-d734-1a09c2990299@linuxfoundation.org>
MIME-Version: 1.0
In-Reply-To: <e6d76104-b7f6-1588-d734-1a09c2990299@linuxfoundation.org>
X-Cookie: This is your fortune.
Cc: Marc Zyngier <maz@kernel.org>,
 Basant Kumar Dwivedi <Basant.KumarDwivedi@arm.com>,
 Will Deacon <will@kernel.org>, Luis Machado <luis.machado@arm.com>,
 Szabolcs Nagy <szabolcs.nagy@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 linux-arm-kernel@lists.infradead.org, linux-kselftest@vger.kernel.org,
 Alan Hayward <alan.hayward@arm.com>, Shuah Khan <shuah@kernel.org>,
 kvmarm@lists.cs.columbia.edu, Salil Akerkar <Salil.Akerkar@arm.com>
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
Content-Type: multipart/mixed; boundary="===============6604443325752202012=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


--===============6604443325752202012==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="aKB5IBghvV+gkZZ7"
Content-Disposition: inline


--aKB5IBghvV+gkZZ7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 08, 2022 at 11:48:39AM -0700, Shuah Khan wrote:
> On 2/8/22 11:38 AM, Mark Brown wrote:

> > I can't find any free format plain text files with SPDX in them, even
> > really prominent stuff like README.  The process documentation is silent

> There are about 570+ files under Documentation directory that have SPDX
> including Documentation/index.rst

> Based on a recent doc patch I did, I have seen warns during doc build
> about the missing SPDX.

> Let's add it now so it doesn't need fixing later.

Sure, there are lots of structured files in there like .rst ones which
have SPDX headers but this is just a free format text file so it's not
clear what if any format to use.

--aKB5IBghvV+gkZZ7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmICvb8ACgkQJNaLcl1U
h9DU1Qf+KAR7JeDHRsKJ/YQVuWJcSDE6c6z2Tjf8ZwPHn682/7koBB6v58r8xLbN
69vnZXlSXj1UmmxwFM6tkXFVhIbUWiweizW6bEJoL1WeBe6EJixIFuO2DjnxW3aA
W0PrLVnZN/gZ6NfsWv69eCm0iz+PNMiXPZNRsiKevMfgg4PFE7D9z+RxcPgvr/A4
1YCQ0iEpzk6DcZfoS1iFvfVWwg8JLyzcEJLMs2jTxh933B2ivGIDqNJ3cuCP2Pg3
jdZB8S+Q2ek2xVgEVvDmeuramzooZYZpVXf74oUv1xE7yk37rP+38xE3Fla4SKIG
GZIUDpV2xEu9zmqt9LFENTQYxy+X/A==
=N8EW
-----END PGP SIGNATURE-----

--aKB5IBghvV+gkZZ7--

--===============6604443325752202012==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============6604443325752202012==--
