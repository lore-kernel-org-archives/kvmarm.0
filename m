Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 897B7C433EF
	for <kvmarm@archiver.kernel.org>; Mon,  6 Jun 2022 10:31:18 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EB6134B19F;
	Mon,  6 Jun 2022 06:31:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UoLzUy2HO6nI; Mon,  6 Jun 2022 06:31:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CB31C411C7;
	Mon,  6 Jun 2022 06:31:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B7AAB40DAE
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Jun 2022 06:31:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4jhvYqCubvHi for <kvmarm@lists.cs.columbia.edu>;
 Mon,  6 Jun 2022 06:31:14 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A9A12408BA
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Jun 2022 06:31:14 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 2C920B8175A;
 Mon,  6 Jun 2022 10:31:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FABFC385A9;
 Mon,  6 Jun 2022 10:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1654511471;
 bh=RzOj554rH8+MebtKLp8kUafMWsaG9Hef1Y0se144nuw=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=M2jerxXte/nWPfN9/KLPlfIsFVhxt5fA7IR9FDTE2ociPH8vepgnv3VAfdROdbYj7
 QTxN2T3uUXtilsAJg3CscfyiCPQZ5OWbHuX28b5u0nlRFtcHAe01YbErEk/v01jNSf
 sdkO7ca5lxhgBI648V0bNh/s+ikQn0fgraephBuSfkVGgFI7d3qocR7o8HhhwSczOI
 sWKDCsO+9TUmVDDuVeajhUgQZt4XRgs7RkoDg1zusidQKjlNINIfU1H4nUlRZmB7hk
 0D+/rMolPsbj/o3wRUnSBlaZBbUnlUB3RPoJmOtEf1HhIeBqRxaQhhAES+SKdNkMmq
 SwMf1zd+AgAmw==
Date: Mon, 6 Jun 2022 11:31:05 +0100
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 04/18] KVM: arm64: Move FP state ownership from flag to a
 tristate
Message-ID: <Yp3XaeZFnlNOIE7t@sirena.org.uk>
References: <20220528113829.1043361-1-maz@kernel.org>
 <20220528113829.1043361-5-maz@kernel.org>
 <YpnQ43WaGH96MxyY@sirena.org.uk> <874k0y5gkv.wl-maz@kernel.org>
MIME-Version: 1.0
In-Reply-To: <874k0y5gkv.wl-maz@kernel.org>
X-Cookie: Bedfellows make strange politicians.
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
Content-Type: multipart/mixed; boundary="===============8938403344695653776=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


--===============8938403344695653776==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="rQudSunjvuay9MSf"
Content-Disposition: inline


--rQudSunjvuay9MSf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 06, 2022 at 09:41:52AM +0100, Marc Zyngier wrote:
> Mark Brown <broonie@kernel.org> wrote:
> > On Sat, May 28, 2022 at 12:38:14PM +0100, Marc Zyngier wrote:

> > > - FP_STATE_CLEAN
> > > - FP_STATE_HOST_DIRTY
> > > - FP_STATE_GUEST_DIRTY

> > I had to think a bit more than I liked about the _DIRTY in the
> > names of the host and guest flags, but that's really just
> > bikeshedding and not a meaningful issue.

> Another option was:

> - FP_STATE_FREE
> - FP_STATE_HOST_OWNED
> - FP_STATE_GUEST_OWNED

> I don't mind wither way.

I think I do prefer that option, but like I say it's bikeshedding.

--rQudSunjvuay9MSf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmKd12kACgkQJNaLcl1U
h9AVGgf/dlk9EDtEzQer5KaGtvG5vJiwknDihIt6gs7N2qOR6G8a4oZMsGZRbjke
2fRtcpAeFmhvRB70c7YTQ5YWy7tQLlCDvuC2wKYren2Z3bj3tnX6SQXiwPD37yAI
fS9sZrICl7Cy4H65S2fX/Lc0g1aec5uIMmFLhtTXoswUeMpNUqHBPp162VS10bGT
dhBD7IuuZqnYHzxLaMX87xG1NRR8IMmaDO+3Lgy2cHUoZ+z/2S+1lKLFA9BolVEA
cWzvrkbLq4kwH4/FRnc6sR/67DAD3yrrjELW5OL7vokRgdlYQ5XZ5gK92R15KTPD
Tx84jFJFDqsZYgJWsiDRldwbWFGwOQ==
=yN1j
-----END PGP SIGNATURE-----

--rQudSunjvuay9MSf--

--===============8938403344695653776==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============8938403344695653776==--
