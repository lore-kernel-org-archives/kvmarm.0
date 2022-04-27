Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E41EFC433EF
	for <kvmarm@archiver.kernel.org>; Wed, 27 Apr 2022 12:55:23 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 407014B246;
	Wed, 27 Apr 2022 08:55:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Et+pWOoRK1FJ; Wed, 27 Apr 2022 08:55:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 360484B0EC;
	Wed, 27 Apr 2022 08:55:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 25BC140C23
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Apr 2022 08:55:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pFrKmE0IPvCK for <kvmarm@lists.cs.columbia.edu>;
 Wed, 27 Apr 2022 08:55:20 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 315A540BEF
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Apr 2022 08:55:20 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 0692C61B6F;
 Wed, 27 Apr 2022 12:55:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8B3AC385A7;
 Wed, 27 Apr 2022 12:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1651064118;
 bh=ik025cWnUzwdoaHADK+8h2P9IwsEUWm7IYWCYLZ3Jmg=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=T+i0/1kDtoLN4lXDDBShq+2y/9AjkB2EDS2HGL59B2GVbZVSHFLMFI2iTGmhB55Pm
 G2qJ7eRlYss/3N16yNlEjyQHtH6m5Xn2Gg+bkgFFm130OzwdDYUgXYEN3vS111WcxV
 RunHMvRYgf2B+/9ehX3uFKa0N3fWlJT2Y01yHeYuZeXv87rIMA6mNC+B0r+NdXuSGa
 F6gJ/XrReTvS+1IYdxynJ/UwVynkvISIfRmoZDttysELDFY8p3EIdnzIjMdAh1N0wL
 twIYyIoL72QOiOO74U0gIxogwtz6FS/osi9ScCyYjCYuIc4gqzYYxztSpYI5tebGsm
 YlXq5skDtDSwg==
Date: Wed, 27 Apr 2022 13:55:11 +0100
From: Mark Brown <broonie@kernel.org>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH v14 27/39] arm64/sme: Provide Kconfig for SME
Message-ID: <Ymk9L2TwsjLSRj6g@sirena.org.uk>
References: <20220419112247.711548-1-broonie@kernel.org>
 <20220419112247.711548-28-broonie@kernel.org>
 <CGME20220426221433eucas1p253f6350eacf87d8cac2c05adc903656e@eucas1p2.samsung.com>
 <64573cca-4bd6-a65e-0ba2-867c6488e82c@samsung.com>
MIME-Version: 1.0
In-Reply-To: <64573cca-4bd6-a65e-0ba2-867c6488e82c@samsung.com>
X-Cookie: Buckle up!
Cc: Marc Zyngier <maz@kernel.org>,
 Basant Kumar Dwivedi <Basant.KumarDwivedi@arm.com>,
 Will Deacon <will@kernel.org>, Luis Machado <luis.machado@arm.com>,
 Szabolcs Nagy <szabolcs.nagy@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Alan Hayward <alan.hayward@arm.com>,
 linux-arm-kernel@lists.infradead.org, linux-kselftest@vger.kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>, Shuah Khan <shuah@kernel.org>,
 kvmarm@lists.cs.columbia.edu, Salil Akerkar <Salil.Akerkar@arm.com>,
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
Content-Type: multipart/mixed; boundary="===============0698791982863891018=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


--===============0698791982863891018==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="2+6n7qNJEoo8AZc1"
Content-Disposition: inline


--2+6n7qNJEoo8AZc1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 27, 2022 at 12:14:32AM +0200, Marek Szyprowski wrote:

> This patchset landed in linux next-20220426. By default SME is enabled=20
> and it breaks CPU hot-plug on all my arm64 test systems. Bisect points=20
> this patch, because it finally enables this feature. Here is a report=20
> from QEMU's arm64 virt machine:

This is the cpucaps infrastructure not being able to cope with FA64
since it's in a register which is only there if the base SME feature is
there.  It works during boot because we have custom code for walking
through the registers there, and it works for the hwcaps for both SVE
and SME because at first look we don't seem to recheck them for
secondaries.

--2+6n7qNJEoo8AZc1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmJpPS4ACgkQJNaLcl1U
h9Cm/gf/XectKTe1EPTDGmPeHt7Fg7pjBk2H/X3bRTO4VmKCmI1P6wPHSWH4Ptuz
iSzT5q3m/XwjpS5B1z9ENjQ5NQ6zC3fMlxM1qHfP+qZsmpob4YCHQldLcz2csfSU
d93ZoESxuheQ0+NGOXdhu9cl2vudTkiDeoqlJZca33anZj8+wi+eIefciDrnJ9fk
/QfoA1uIBhxeqvSo2EEvi3FP1RmxioztTOFI+XH9TqRmy2jx40kfXMcb6qqUQfc0
GZkEqViat/I/x/f6yUQ6oIhR+q1t85gc+jQz9dkb8TyHI6NgTR3ySIekdezwCgSW
2G8Eee5LXK21k5wIOM0WkIeFSE/iGA==
=MFEc
-----END PGP SIGNATURE-----

--2+6n7qNJEoo8AZc1--

--===============0698791982863891018==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============0698791982863891018==--
