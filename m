Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2612CC4332F
	for <kvmarm@archiver.kernel.org>; Wed, 21 Dec 2022 13:34:50 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8CE844B823;
	Wed, 21 Dec 2022 08:34:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qehou-l5OK5k; Wed, 21 Dec 2022 08:34:49 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7E67D4B7B0;
	Wed, 21 Dec 2022 08:34:49 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 30BFB4B7B0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Dec 2022 08:34:48 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id begUTpZe1B8K for <kvmarm@lists.cs.columbia.edu>;
 Wed, 21 Dec 2022 08:34:45 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DE4484B721
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Dec 2022 08:34:45 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 3E7F1617C2;
 Wed, 21 Dec 2022 13:34:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FF18C433F0;
 Wed, 21 Dec 2022 13:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1671629685;
 bh=WqWR0d44+oC0M51OxsJIk5oYzW5Ewe38o6BJGMCz944=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=QSN6k2D3YaVWrsm0u1NnBATOWav1SPvpxVC5Qc3+KeNG4kFYC5BhBlpRUkUuffEHo
 V7tOKTKpWTi8p82CMsN7tiDvBA34Uc1gR7mMrdwD315dPO5RUP3u85SpQ0++9C9XaO
 2jBoCAhOVg/6bnz+J+IrkfN6pKwcqMCBkxJnLjIa+S//8J7fIjJSNTFLO9YbpkprCy
 hSHebH+WnK21ogAZxqRvkBPiFJRQGgodD3QxNpdDb7As0CjBWyOB/YTyDeIjg7Ahq6
 Xv60z9ryBv4gfT4g7hDGD/dYkBebh4LupvK57Dh5AYlcZNaLCVPy71ZI8vvhrX82oa
 KcjdrPs5K23xg==
Date: Wed, 21 Dec 2022 13:34:38 +0000
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH] KVM: arm64: Synchronize SMEN on vcpu schedule out
Message-ID: <Y6MLbsTpNI4E+5qe@sirena.org.uk>
References: <20221220105024.13484-1-dongbo4@huawei.com>
 <86v8m6bcuh.wl-maz@kernel.org>
MIME-Version: 1.0
In-Reply-To: <86v8m6bcuh.wl-maz@kernel.org>
X-Cookie: Programming is an unnatural act.
Cc: Dong Bo <dongbo4@huawei.com>, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
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
Content-Type: multipart/mixed; boundary="===============5855085209842560219=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


--===============5855085209842560219==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="X1wLM/v5tW57IqQt"
Content-Disposition: inline


--X1wLM/v5tW57IqQt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 20, 2022 at 10:15:18AM +0000, Marc Zyngier wrote:
> Dong Bo <dongbo4@huawei.com> wrote:

> > If we have VHE and need to reenable SME for host in
> > kvm_arch_vcpu_put_fp, CPACR.SMEN is modified from 0 to 1. Trap
> > control for reading SVCR is modified from enable to disable.
> > Synchronization is needed before reading SVCR later in
> > fpsimd_save, or it may cause sync exception which can not be
> > handled by host.

Reviewed-by: Mark Brown <broonie@kernel.org>

--X1wLM/v5tW57IqQt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmOjC24ACgkQJNaLcl1U
h9BfMgf/Q43z96bvYnITDmaGHJxEC1F3oW2EdvKLoge3nzDZJTbsZX1jqW5k6Hes
vfx8GK+A0zVG6XqyT6MpRm6WIldfEpQwTtvdTDFs1DiY2GEpfQozQKllrquASy9W
W3B1UCB90Dv4c519bT3WRCInlUpHRJijyj/m4cijPK4bhLWqVlJXEPJCZ9kZtd3+
zaoOdLKZliZ4qYYe1KydiQO+tBNtSwflYRRfD0taUdpYPjDURuIcGubtuwdOkAqa
4enKZHb2JCUxTuBqOw9ocMglWfRjG+RtRmTdqHap1s0dmP0ywB7v79TBty2HYd7A
JcOErjeidYrL4XN6aYR91H1EtqhvKg==
=+pAK
-----END PGP SIGNATURE-----

--X1wLM/v5tW57IqQt--

--===============5855085209842560219==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============5855085209842560219==--
