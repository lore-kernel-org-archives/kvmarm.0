Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7714C54EE9
	for <kvmarm@archiver.kernel.org>; Tue, 20 Sep 2022 18:09:24 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 561E94B600;
	Tue, 20 Sep 2022 14:09:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dY3wPFw-bC7i; Tue, 20 Sep 2022 14:09:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 490F34B630;
	Tue, 20 Sep 2022 14:09:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1578D4B600
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 14:09:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rczGh18v80J1 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Sep 2022 14:09:21 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DCCD14B24C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 14:09:20 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 9F980B82BDE;
 Tue, 20 Sep 2022 18:09:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6ABFC433D6;
 Tue, 20 Sep 2022 18:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1663697358;
 bh=IIE2Zez7/a1Qc1VfKvs+5cgbTBSAcI81MQ0uNGej81k=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=pMCbSfXW0auMJ8qdBUOJUWWMcdlqjby77wNDSZrfbtznHTzJrnkXJ7mVuJpWMKdoE
 X6r3WHJkLHyB0R4AL6RNcgP/DxYgyHsrRRYn/7LbQzIhYi2gcVxGaKAj7xKI1L79Xe
 fVzEJ5uMMx3wlV6fcEOie4HC7o+aT3kyBidHfIzDsKrwxLti++kAl/FoJTbzRSBjm6
 DsL1h/QBIc97Xu8S63i4vZZJ5YZ8cO8byyPcsP1UWgwUYMtgSFdezOr8mHSTI6jFqd
 VDnLxBQykRWIBdW0UKjtOd3pTOryhACTeZbYChUdhuqAJ+VUqcyNSfSTZCiI0lVyQ8
 YKSoAJjFqVtxw==
Date: Tue, 20 Sep 2022 19:09:15 +0100
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v3 2/7] arm64/fpsimd: Track the saved FPSIMD state type
 separately to TIF_SVE
Message-ID: <YyoBy+HuHj5XRXKG@sirena.org.uk>
References: <20220815225529.930315-1-broonie@kernel.org>
 <20220815225529.930315-3-broonie@kernel.org>
 <87y1uej7dm.wl-maz@kernel.org>
MIME-Version: 1.0
In-Reply-To: <87y1uej7dm.wl-maz@kernel.org>
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
Content-Type: multipart/mixed; boundary="===============1899766398920930825=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


--===============1899766398920930825==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="F2TYRAB+02knW1Ru"
Content-Disposition: inline


--F2TYRAB+02knW1Ru
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 20, 2022 at 06:14:13PM +0100, Marc Zyngier wrote:
> Mark Brown <broonie@kernel.org> wrote:

> > When we save the state for the floating point registers this can be done
> > in the form visible through either the FPSIMD V registers or the SVE Z and
> > P registers. At present we track which format is currently used based on
> > TIF_SVE and the SME streaming mode state but particularly in the SVE case
> > this limits our options for optimising things, especially around syscalls.
> > Introduce a new enum in thread_struct which explicitly states which format
> > is active and keep it up to date when we change it.

> > At present we do not use this state except to verify that it has the
> > expected value when loading the state, future patches will introduce
> > functional changes.

> > +	enum fp_state fp_type;

> Is it a state or a type? Some consistency would help. Also, what does

We can bikeshed this either way - the state currently stored is
of a particular type.  I'll probably go for type.

> this represent? Your commit message keeps talking about the FP/SVE
> state for the host, but this is obviously a guest-related structure.
> How do the two relate?

The commit message talks about saving the floating point state in
general which is something we do for both the host and the guest.
The optimisation cases I am focusing on right now are more on
host usage but the complexity with tracking that currently blocks
them crosses both host and guest, indeed the biggest improvement
overall is probably that tracking the guest state stops requiring
us to fiddle with the host task's state which to me at least
makes things clearer.

--F2TYRAB+02knW1Ru
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmMqAcoACgkQJNaLcl1U
h9Dyfgf8DqcSgSpIMFm7ghAZD34enLc6Td4USGjfJ5GqsGTZZvbo9m32uPxEnjDp
mmDbT0uo7d1BG2QR1GiHgPQGW6UwgMf1RjG4T1lFi83JknKpUkaOUsDR4PPejUok
aQjLxK2rr6FJku55sbPpOo7u4oidNjJDNRlNnLvdVCE1gZmj+nBD+FY77tDw5Y3e
2n8NBwqU6T1B6kEgwgm0siCB19IrZhXfGn1M0u6HLm4IL2h2BGgb8P9dC2yJkteE
ZeD/KvVziahNq8ZFb9mqyGEKl9fZzaXEzwSAK5VnPXhEoaWs8vT7jDS1TZEiMG19
hQN9AZJW2bYsKpHx0tEHnfeiDhzaNw==
=uRBY
-----END PGP SIGNATURE-----

--F2TYRAB+02knW1Ru--

--===============1899766398920930825==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============1899766398920930825==--
