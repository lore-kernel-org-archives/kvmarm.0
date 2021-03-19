Return-Path: <SRS0=QSSN=IR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5591C433C1
	for <kvmarm@archiver.kernel.org>; Fri, 19 Mar 2021 16:42:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1C8E261983
	for <kvmarm@archiver.kernel.org>; Fri, 19 Mar 2021 16:42:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1C8E261983
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A2F6B4B5FE;
	Fri, 19 Mar 2021 12:42:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Y5mkUuATovyh; Fri, 19 Mar 2021 12:42:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9D7CC4B605;
	Fri, 19 Mar 2021 12:42:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0739A4B5FE
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Mar 2021 12:42:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RRrLGp5-FLlI for <kvmarm@lists.cs.columbia.edu>;
 Fri, 19 Mar 2021 12:42:42 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1418F4B5F2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Mar 2021 12:42:42 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5594B6197D;
 Fri, 19 Mar 2021 16:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1616172160;
 bh=VvUapEq2wKe3jRL/2pb7xke5nb1W78nB9EG7oF+dI0E=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=JTaq5qq1C71cvBEa8m+Q0Nbhc5upiRJe/SjVFYBRLZmkfeAbqo/sg0DGGYx68+PEr
 AWfGuefxzylcaIlKZfkJoJalo4AYTnupqTIT3Py1VpRyxq5fX2ntvqQvftDyNnngbO
 eV2Nm0OCgW7zid1MmShZ7DlFiwSEYWxROortaSSIMROq14ShsblOK2r8/C8gxlBg/W
 pXXPUDRmuYRixaNLV6DYomItoSXmxWiuW5Abk+no/FSr1/1agoOWvWaaSwjqFGHqt5
 ymTlHQmKKXuUV5amaO4XQUXo2MP2DlRXaNo7dj6OYJqqRPGTIHQEZpFFq8qip8iWbh
 YSGn80oH4OfaQ==
Date: Fri, 19 Mar 2021 16:42:36 +0000
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 05/11] arm64: sve: Provide a conditional update
 accessor for ZCR_ELx
Message-ID: <20210319164236.GH5619@sirena.org.uk>
References: <20210318122532.505263-1-maz@kernel.org>
 <20210318122532.505263-6-maz@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20210318122532.505263-6-maz@kernel.org>
X-Cookie: No purchase necessary.
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: kernel-team@android.com, kvm@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu,
 Will Deacon <will@kernel.org>, dave.martin@arm.com,
 linux-arm-kernel@lists.infradead.org, daniel.kiss@arm.com
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
Content-Type: multipart/mixed; boundary="===============3205493831752587636=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


--===============3205493831752587636==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="GBDnBH7+ZvLx8QD4"
Content-Disposition: inline


--GBDnBH7+ZvLx8QD4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 18, 2021 at 12:25:26PM +0000, Marc Zyngier wrote:

> A common pattern is to conditionally update ZCR_ELx in order
> to avoid the "self-synchronizing" effect that writing to this
> register has.
>=20
> Let's provide an accessor that does exactly this.

Reviewed-by: Mark Brown <broonie@kernel.org>

> +#define sve_cond_update_zcr_vq(val, reg)		\
> +	do {						\
> +		u64 __zcr =3D read_sysreg_s((reg));	\
> +		u64 __new =3D __zcr & ~ZCR_ELx_LEN_MASK;	\
> +		__new |=3D (val) & ZCR_ELx_LEN_MASK;	\
> +		if (__zcr !=3D __new)			\
> +			write_sysreg_s(__new, (reg));	\
> +	} while (0)
> +

Do compilers actually do much better with this than with a static
inline like the other functions in this header?  Seems like something
they should be figuring out.

--GBDnBH7+ZvLx8QD4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmBU1HsACgkQJNaLcl1U
h9CM/gf+N7nbcXjDF0+HU24muCH+sUwbBDrs3PP+0I2Sqcmu0zMshrnD7tuL5xNU
lWckrtiVBzELjoz0UfVEl+sh+pzeh7fUZHEB3Bbz4AFQYxJhusvp3auTiN8DfWs4
YM6T4hoSYAE8QpnPtz2N8llENkU5mudFoRnp6cZHK/7nGp/A5c+ZTsBp01UO8p/C
vl+eSWW7J07t5txdE8m19+a8GTmyHbI9Fl8Op5jR+9rfcRarVTcpMIszYwc+bwan
O2DTbyC8ZeHKjCxpwh1zIXCy2WgUUFWHW/XOPZmhWooOfWlZQy67j/9jLgJs/cCi
qwMvWZUBJaRClgmANXsPOg92w13MLg==
=QV3R
-----END PGP SIGNATURE-----

--GBDnBH7+ZvLx8QD4--

--===============3205493831752587636==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============3205493831752587636==--
