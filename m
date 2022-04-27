Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93C46C433F5
	for <kvmarm@archiver.kernel.org>; Wed, 27 Apr 2022 22:13:34 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 05EB54B208;
	Wed, 27 Apr 2022 18:13:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7PDIHOv5YFwq; Wed, 27 Apr 2022 18:13:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DB5834B1FC;
	Wed, 27 Apr 2022 18:13:32 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6E0BC4B1FC
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Apr 2022 18:13:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NG662M58yTjr for <kvmarm@lists.cs.columbia.edu>;
 Wed, 27 Apr 2022 18:13:30 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 381594B1F0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Apr 2022 18:13:30 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 17B3E61E28;
 Wed, 27 Apr 2022 22:13:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44740C385A7;
 Wed, 27 Apr 2022 22:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1651097608;
 bh=hVI7V6tAgi1A90bdp9aCrTZJAYccb/n9NxF5+xjLUts=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=Nbah56KvoPPS/tybp1pv9Rg4dqKVf6B9xBDOxibS/qOtqQKLnOGQNU9VSofJ6NO0D
 C4kZUal7Kvxt61U7EROjPEM/MkxWYkrH8plTAHYzDmh1vzGRDqbpfkyBzidS3dp16H
 QfKAENUQGnygJ+fbhgDIaxO4xSlKQARbtEuaQ2XAUY+fv9OS1hXU1lLpF7B9rPxSNZ
 wWEIejxtfnns7LPd6v0LSre5wJ8sRx0J+S5pkCeZANPsRYgXI4m07FLxBMScVXUWzy
 1a4nrpPr++YYQYkjZBDn9TmY1iAnBl2+5yJffc70S08PAMcW3DZaQHtwofGHn2NOrJ
 5OQJc1Z+p3dKw==
Date: Wed, 27 Apr 2022 23:13:21 +0100
From: Mark Brown <broonie@kernel.org>
To: Qian Cai <quic_qiancai@quicinc.com>
Subject: Re: [PATCH v14 00/39] arm64/sme: Initial support for the Scalable
 Matrix Extension
Message-ID: <YmnAAScScNWQhx2U@sirena.org.uk>
References: <20220419112247.711548-1-broonie@kernel.org>
 <20220427170858.GA2009@qian> <Yml599vM948wXt6g@sirena.org.uk>
 <20220427210800.GB2047@qian>
MIME-Version: 1.0
In-Reply-To: <20220427210800.GB2047@qian>
X-Cookie: Buckle up!
Cc: Marc Zyngier <maz@kernel.org>,
 Basant Kumar Dwivedi <Basant.KumarDwivedi@arm.com>,
 Will Deacon <will@kernel.org>, Luis Machado <luis.machado@arm.com>,
 Szabolcs Nagy <szabolcs.nagy@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Alan Hayward <alan.hayward@arm.com>,
 Salil Akerkar <Salil.Akerkar@arm.com>, linux-kselftest@vger.kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>, Shuah Khan <shuah@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 Luca Salabrino <luca.scalabrino@arm.com>
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
Content-Type: multipart/mixed; boundary="===============4092129354746042362=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


--===============4092129354746042362==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="s56lCtxHwIKgHoFx"
Content-Disposition: inline


--s56lCtxHwIKgHoFx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 27, 2022 at 05:08:00PM -0400, Qian Cai wrote:
> On Wed, Apr 27, 2022 at 06:14:31PM +0100, Mark Brown wrote:

> > Can you try with=20

> >    https://lore.kernel.org/r/20220427130828.162615-1-broonie@kernel.org

> > please?

> Yes, it works fine so far.

Great, thanks for checking.  Catalin applied it now so hopefully -next
will be sorted in the next day or so.

--s56lCtxHwIKgHoFx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmJpwAEACgkQJNaLcl1U
h9C8ZAf/UQ3640lBx7Z1uHTUWnJ6PVc4sUJpBlwJS4OlkdIzeptcNuhZt7GMNYfT
kXpFO2AiFKIlUMLG80jeWXmYgOjt6XD0AnxZT4ogK0ttLrVZVvchItlm6MDA8MFc
u/MYet5MiWEAOMbr/FpVNLCnq6og3e5E57SPzpyJOOvSblxOA8gKDkukTT/A9VrY
E+3CQ3l1vELiCkhnMnLIMml/j3zfCm62sI09ePshhrwkY4mJHEq5ZDYzHo26EefY
e93/X7J6ZUpo97s4dNVFuUGu7VyAmfRTMHRCETQ/e7cyrU73WYRBiN+YLP4Jzd63
zYiv7sMi9rj3ywSH7lhAeeJYuO7tPA==
=gjuG
-----END PGP SIGNATURE-----

--s56lCtxHwIKgHoFx--

--===============4092129354746042362==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============4092129354746042362==--
