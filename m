Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37503C433F5
	for <kvmarm@archiver.kernel.org>; Wed,  1 Dec 2021 13:30:18 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 80AE64B1D2;
	Wed,  1 Dec 2021 08:30:17 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pYiLiN4NIQLj; Wed,  1 Dec 2021 08:30:16 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 486274B210;
	Wed,  1 Dec 2021 08:30:16 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BB39F4B1D2
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Dec 2021 08:30:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GOszfILGVd-J for <kvmarm@lists.cs.columbia.edu>;
 Wed,  1 Dec 2021 08:30:13 -0500 (EST)
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1C2264B175
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Dec 2021 08:30:13 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by sin.source.kernel.org (Postfix) with ESMTPS id 7D01ACE1D5C;
 Wed,  1 Dec 2021 13:30:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55571C53FAD;
 Wed,  1 Dec 2021 13:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1638365403;
 bh=03NvP3rtGXIB44jdTVoaqF1hAROkeujLt9oWcwTYciQ=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=Aqq8mbqJV9iJlkVO3sm+k+UuMWYsI4cOGf3gf8KnZkpo6n57F3tLHLS5v7+cWwnzZ
 FqTeHFD+vCzhmouOWJiQPeofYPRfvDpflQi1GavRjUbOHbl/k2O2rxL+VojQxs4may
 ZMr46q7oxa9s9ziuxEfJqtRP82txYHYGd7Ky+9AR5yb6fGfHW9sRgKzkBsk3zmmU4q
 +sCqU8n/hDiG+iYb6pMC2FdGdRslLLx0u7iAQ72c2d6Wx3l2sE1+RdERDvAtm8Utay
 tFftn2szDNcJHat9JLSdc3C/as5K+Xao6AuqqU1wrUes8FumBB9xE7CpCClKSkfjVo
 mqffFD16OXxeg==
Date: Wed, 1 Dec 2021 13:29:58 +0000
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v3 5/6] KVM: arm64: Stop mapping current thread_info at EL2
Message-ID: <Yad41lTBoUkt8lZi@sirena.org.uk>
References: <20211201120436.389756-1-maz@kernel.org>
 <20211201120436.389756-6-maz@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20211201120436.389756-6-maz@kernel.org>
X-Cookie: All true wisdom is found on T-shirts.
Cc: kernel-team@android.com, kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
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
Content-Type: multipart/mixed; boundary="===============1576163482500335634=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


--===============1576163482500335634==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="cZE6w7K3Kpb3PE91"
Content-Disposition: inline


--cZE6w7K3Kpb3PE91
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 01, 2021 at 12:04:35PM +0000, Marc Zyngier wrote:
> Now that we can track an equivalent of TIF_FOREIGN_FPSTATE, drop
> the mapping of current's thread_info at EL2.

Reviwed-by: Mark Brown <broonie@kernel.org>

--cZE6w7K3Kpb3PE91
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmGneNUACgkQJNaLcl1U
h9AhZwf/S6EbpxJbOPrC+y6KTi4WpcMaVfokcHdVC+OM2NfsJ4E/RNW21N+UrB6k
GOpmtrFQcy5+ww6odUoCv001V+ctHtEv40MOZB3W7t+EccEhKW5LgrD5xsDQ8jbB
RfInaPSvytz4Zu9JXiovO4doD59+RuK9+kwwP2odeUZ9/g7v6alsKqKFEQwpcOM9
Y0RjZ0Lf7fgmihm9goswCmfzSliaug0pK0KF7wizybjRkpuSRXEinkla2AT5gJQy
4+w9/eZrdwVCx3IS9iNqVSqA0esNVZCG3fbIxM3yv30voK34oDdhHhOWZoJKlq40
zNlJhIuqxJpUQaU7JZosijOMOnrC6Q==
=nlYP
-----END PGP SIGNATURE-----

--cZE6w7K3Kpb3PE91--

--===============1576163482500335634==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============1576163482500335634==--
