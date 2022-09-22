Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1ADDC6FA82
	for <kvmarm@archiver.kernel.org>; Thu, 22 Sep 2022 11:44:48 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2DC294B092;
	Thu, 22 Sep 2022 07:44:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BuVY5aKvmHPX; Thu, 22 Sep 2022 07:44:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D34BC49EEF;
	Thu, 22 Sep 2022 07:44:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E380749EC2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Sep 2022 07:44:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oPqGyXu5xHHJ for <kvmarm@lists.cs.columbia.edu>;
 Thu, 22 Sep 2022 07:44:44 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CD4BF49DE3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Sep 2022 07:44:44 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id F0D7E62C9E;
 Thu, 22 Sep 2022 11:44:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E09DCC433D7;
 Thu, 22 Sep 2022 11:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1663847083;
 bh=Er67ejPFn30SMmoQ2Hl6Exp7BE9E0rqNfAdLEvMZkr8=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=kQuq84F9q+Lmn3wBD+l9ml9EKYV0NpwCbN2AMA9LuZ/cEfkL+6EHEAvzBXmoOCCbd
 dTrTilu9ERs0UzcWm8KTgcy3F+ZHvQoJDChNNjjnodF1+vBa7fi0+V9EevYrsPTmSm
 3n4UUCCU0cPBlpR9/Wh+2RXkcidZV5xNZ3v/M/xA3nzh912j0Ame1rwKwuP2NQzbhf
 kQw4kXjGxwH/VioKFxyYeZbnKzyui83YwQUL8rsPA+EVb1eaXY5iRGrsp0OVBnd0eX
 pMS77cJtYWl5MTQNKbvdv2iRCGg7XdgM009bnOftMvAtV42hBqduLnUmS+gGTiDaQF
 DiTY4C0UNm+mg==
Date: Thu, 22 Sep 2022 12:44:40 +0100
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v3 1/7] KVM: arm64: Discard any SVE state when entering
 KVM guests
Message-ID: <YyxKqI7wguFT9Ose@sirena.org.uk>
References: <20220815225529.930315-1-broonie@kernel.org>
 <20220815225529.930315-2-broonie@kernel.org>
 <87zgeuj8ry.wl-maz@kernel.org> <YyogzYzVbb3mvZWM@sirena.org.uk>
 <87mtask51r.wl-maz@kernel.org>
MIME-Version: 1.0
In-Reply-To: <87mtask51r.wl-maz@kernel.org>
X-Cookie: One FISHWICH coming up!!
Cc: Catalin Marinas <catalin.marinas@arm.com>,
 Zhang Lei <zhang.lei@jp.fujitsu.com>, Andre Przywara <andre.przywara@arm.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
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
Content-Type: multipart/mixed; boundary="===============7589229697888290839=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


--===============7589229697888290839==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="HN0Rn8ON707UM9Q7"
Content-Disposition: inline


--HN0Rn8ON707UM9Q7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 21, 2022 at 06:31:28PM +0100, Marc Zyngier wrote:
> Mark Brown <broonie@kernel.org> wrote:

> > There's no use for that hook now though.

> Care to clarify?

We don't do anything for SME even if we were to support SME with
no FP properly.

--HN0Rn8ON707UM9Q7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmMsSqcACgkQJNaLcl1U
h9D5Fwf8C9d/KlsobsBQdhW04pJXSnQXM+h5q25WXvrA6gwcLt2q+sOIeHCnV/7n
ilEdGR0rIBopYMewK1beYnxYQdFUz8jt8W6bnKmDuyrqJWrmTF38znPQAI/e2kjD
UbSl1u9Gc7Jl0rPq2JXL2J/oc7hTBpEKAT4glhTs08Bol5sBuz6E4lZ51A1piSHJ
3gTbFmkcdpyVnbn6DfADYm8e0C8N7rKU3RkqfvjiGdnT1vz7sEAhJJU1w1kEk3Yy
DY+oIpEZKd+Hs4evDnhjI8TEPjBRad57JSRNuIt1VfGu5RcOBtXXf+/8lzg7mhDv
CBLm+7USdvcsvqID1CDMScmhWeq08g==
=ud8S
-----END PGP SIGNATURE-----

--HN0Rn8ON707UM9Q7--

--===============7589229697888290839==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============7589229697888290839==--
