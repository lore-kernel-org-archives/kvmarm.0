Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 324CBC4332F
	for <kvmarm@archiver.kernel.org>; Tue,  8 Feb 2022 16:23:24 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 814EC4B13E;
	Tue,  8 Feb 2022 11:23:23 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HGWC2pfUKN8F; Tue,  8 Feb 2022 11:23:21 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E68624B10C;
	Tue,  8 Feb 2022 11:23:21 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 554524B10C
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Feb 2022 11:23:21 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dQxhK+OXlS9A for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Feb 2022 11:23:20 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 619F34B0FC
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Feb 2022 11:23:20 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id A375C616DB;
 Tue,  8 Feb 2022 16:23:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB9D6C004E1;
 Tue,  8 Feb 2022 16:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1644337399;
 bh=7EjAF78EZ5QWa+t6GFhhwSedAHtA4f8i1cRtLq4H/cI=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=jDs1Y+chouwfHWvO7jOyLHsTVlM/IoxwKUiK1fD/NrGAbyps7In4U2A/F8W11aPFg
 6u2Bn4/JYITl887j/ZJ3vlUzMd0MGj68hhoV1UR52z9x1zDHX646F6BgrNHWOfP4OO
 /+oNHpszZvHmETmEBsgJNzQ4Aqebn5qYj3lEg2Q5yLgJCFC5tGzDN9cmtCG0mX3Zeh
 loPIxk6kuoyLX4JwnrINX2ytdglLgwK93/Z4i5l/B9fpB3yUriAcEqxQFog9rDapg/
 eFNlO0lkxxlsZOcsf9ccHMh7n6ebC1vmAGrfj1VtMqzIGArDa+jRYNh8VYd4KqhP6t
 ZS9ECDSHKojOQ==
Date: Tue, 8 Feb 2022 16:23:12 +0000
From: Mark Brown <broonie@kernel.org>
To: Shuah Khan <skhan@linuxfoundation.org>
Subject: Re: [PATCH v11 34/40] kselftest/arm64: sme: Provide streaming mode
 SVE stress test
Message-ID: <YgKY8NluYQxbeUw7@sirena.org.uk>
References: <20220207152109.197566-1-broonie@kernel.org>
 <20220207152109.197566-35-broonie@kernel.org>
 <3b173e0e-7651-b820-26c4-37d1cbe94224@linuxfoundation.org>
MIME-Version: 1.0
In-Reply-To: <3b173e0e-7651-b820-26c4-37d1cbe94224@linuxfoundation.org>
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
Content-Type: multipart/mixed; boundary="===============7429027702152420827=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


--===============7429027702152420827==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="+Dm2AwXmRIQQetd4"
Content-Disposition: inline


--+Dm2AwXmRIQQetd4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 07, 2022 at 05:40:08PM -0700, Shuah Khan wrote:

> > +child_died () {
> > +	cleanup
> > +	exit 1

> Is this a failure condition?

Yes.

--+Dm2AwXmRIQQetd4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmICmPAACgkQJNaLcl1U
h9CldAgAhU51Tq/k4inkyhHPj1IrMyCrf7zKGWMmKVj5+FGBYpRrg6i/Oc5u9sek
8onQDXFuxVi/0m9JbTxcTfFRULR+we2mg8JqUwkcDRvw7WOK+nx/EZlDchMcEZXA
kZAj7RPINQHWN0NGJW5+++67YCCc+1GHTuyUYktMuqD/Z7w0Zyi61KZDr8hria4y
W5XvfpAWrwUGIu5QFRk28lZfs2D2BbZI+YkqYqb7xGAEHMkm4OOudIoSK/xTv5hl
2d+DAQ3T29QJEc3OObLyn4KB8Eo+XJLhoGhkJ6v8uj4jf65MMrzadjWg9Z8e1We7
+N7K7kMJljE6v9aVYNvPosEGJOufzw==
=TjlJ
-----END PGP SIGNATURE-----

--+Dm2AwXmRIQQetd4--

--===============7429027702152420827==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============7429027702152420827==--
