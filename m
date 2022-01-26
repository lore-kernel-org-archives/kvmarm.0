Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3F9BC2BA4C
	for <kvmarm@archiver.kernel.org>; Wed, 26 Jan 2022 15:24:21 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 310E749ECB;
	Wed, 26 Jan 2022 10:24:21 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XDnVWaS1hTSQ; Wed, 26 Jan 2022 10:24:20 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2419A49ECA;
	Wed, 26 Jan 2022 10:24:20 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 401DE49ECA
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Jan 2022 10:24:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0AMBF9XJ5IS8 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 26 Jan 2022 10:24:17 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2890E49EC5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Jan 2022 10:24:17 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 01BC4618B0;
 Wed, 26 Jan 2022 15:24:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 082DFC340E3;
 Wed, 26 Jan 2022 15:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1643210655;
 bh=a9fGZLyR6UIMHjhj3fwTDtIy/5FmZ3+TtczWHOoCjN4=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=AfLDOYjuN743LLtaoX9Qr8mxEnozFrFTlQhFTTalAzArQrARdZ97G0f0ZipCfbf6q
 YaUusTvYWMke/whoKaLkm0I30jPshTmJFZ6ncjrtbCbyZV2nfUi8cuolY9oNALqLaq
 DgEAwDKO3afwilZ1fZdS0hEjcMtNAUNxJpPh9TGn++1uCUFcYFxYJUcX0Q5kZW1WS6
 atP38oN+90AHAXRukeSDb0aiXo3B+1k1JKOoqYE+X9TFSYdoYsZWqGQjHsEbSWrext
 GbyOpBb+il9zlj/+GoE5zaTNv3ZfX3bEZ+jvsUXidLRQYfULOsdtJLh395CAMtFdIb
 NgOisSDVKMORg==
Date: Wed, 26 Jan 2022 15:24:08 +0000
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
 Shuah Khan <skhan@linuxfoundation.org>, Shuah Khan <shuah@kernel.org>
Subject: Re: [PATCH v9 40/40] squqsh traps
Message-ID: <YfFnmC5vekv06d3K@sirena.org.uk>
References: <20220126151120.3811248-1-broonie@kernel.org>
 <20220126151120.3811248-41-broonie@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20220126151120.3811248-41-broonie@kernel.org>
X-Cookie: Use only in a well-ventilated area.
Cc: Basant Kumar Dwivedi <Basant.KumarDwivedi@arm.com>,
 Luis Machado <luis.machado@arm.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>,
 linux-arm-kernel@lists.infradead.org, linux-kselftest@vger.kernel.org,
 Alan Hayward <alan.hayward@arm.com>, kvmarm@lists.cs.columbia.edu,
 Salil Akerkar <Salil.Akerkar@arm.com>
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
Content-Type: multipart/mixed; boundary="===============2209852348642851959=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


--===============2209852348642851959==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="XXERhi+4WkANTGAx"
Content-Disposition: inline


--XXERhi+4WkANTGAx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 26, 2022 at 03:11:20PM +0000, Mark Brown wrote:
> ---
>  arch/arm64/kvm/fpsimd.c          | 22 ++++++++++------------
>  arch/arm64/kvm/hyp/nvhe/switch.c | 20 ++++++++++----------
>  arch/arm64/kvm/hyp/vhe/switch.c  |  4 ++--
>  3 files changed, 22 insertions(+), 24 deletions(-)

Ugh, sorry - looks like I didn't finish my rebase.  Will resend.

--XXERhi+4WkANTGAx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmHxZ5cACgkQJNaLcl1U
h9DP7gf/biXfHH4ssvVCSo4MY7iDJVG06yJclefMZnDT4ExfXt05ibBeLYLfn/AD
uLVNjo9VzbP5SiT2ibZlPgN/kp6IIzIxyfjdMWh4tUXUcSz14ls5cJ9uIchL+kX3
9GC/PCvWP4Wqi2VBKa+XmS753OzmDiO10zo6Ayd8B4jEOR0OsMy5lBQtP0vgXLSx
c4Kvl/eaU0PmfH+4Syvkh0eUJorE4rYnAX9AxNTNx8HixxHstmlCar2rQ+FJMULg
WW0wbUAfptm18jEz3fHT3TmeKfKYvHKaelcQ21b+1mysGxdiQZm8IEM6FwNUD98t
pKGGVXTtereZqpkVzqEElcMS6sOqJg==
=t+YB
-----END PGP SIGNATURE-----

--XXERhi+4WkANTGAx--

--===============2209852348642851959==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============2209852348642851959==--
