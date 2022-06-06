Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3DABC433EF
	for <kvmarm@archiver.kernel.org>; Mon,  6 Jun 2022 12:17:07 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 171C849EF6;
	Mon,  6 Jun 2022 08:17:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MSE3BFnD5gZM; Mon,  6 Jun 2022 08:17:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DEE8249F0A;
	Mon,  6 Jun 2022 08:17:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2C86649F0A
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Jun 2022 08:17:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id i35i-NwEH84m for <kvmarm@lists.cs.columbia.edu>;
 Mon,  6 Jun 2022 08:17:03 -0400 (EDT)
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8523349EF6
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Jun 2022 08:17:02 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by sin.source.kernel.org (Postfix) with ESMTPS id 49E82CE1A91;
 Mon,  6 Jun 2022 12:16:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE360C34119;
 Mon,  6 Jun 2022 12:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1654517814;
 bh=DbMgnzFRDeClTcRHZKl9h6of7GFtoGX1BaOdzUKuVpM=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=B7z7FHJhSOsxG0qlrZKrOsoSS0uQvLJlGQZEVqpzl9lgWj/QKHPYxDbBXCkm4m7vN
 3UPBWK5UUxcCS9dIdcVwFkn1w66aFkXyQVjUHTJQvU4VRheyvpMZ3yOnNGThcpMCXD
 CqBoIe+Lg8zvxsW2Zh4v06JNQUgtrdcUQkMlzp9PE6CYNeL5loiRQCMzD2M0isBP7b
 qbCpIv6eP3tzuJ1LA+citjUdU8c2lAHs98cf30MTjA/hsijoZPHXx3mr9RBMDPU4z2
 5QK6wKQkbFOmY9S3XZ2aDkyIA2MUaw+8LLcD8dnpxwN7VIqVHjj73B896O/GS8f9ih
 l3GfBYwo+i8hQ==
Date: Mon, 6 Jun 2022 13:16:48 +0100
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 01/18] KVM: arm64: Always start with clearing SVE flag on
 load
Message-ID: <Yp3wMETNdDWtNhaY@sirena.org.uk>
References: <20220528113829.1043361-1-maz@kernel.org>
 <20220528113829.1043361-2-maz@kernel.org>
 <YpTXsgd1MPpJEjUJ@sirena.org.uk> <87y1ya3uan.wl-maz@kernel.org>
MIME-Version: 1.0
In-Reply-To: <87y1ya3uan.wl-maz@kernel.org>
X-Cookie: Bedfellows make strange politicians.
Cc: kernel-team@android.com, kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 stable@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
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
Content-Type: multipart/mixed; boundary="===============4978007607230260456=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


--===============4978007607230260456==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="B+OWqsOhQgqxaqa/"
Content-Disposition: inline


--B+OWqsOhQgqxaqa/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 06, 2022 at 12:28:32PM +0100, Marc Zyngier wrote:
> Mark Brown <broonie@kernel.org> wrote:
> > On Sat, May 28, 2022 at 12:38:11PM +0100, Marc Zyngier wrote:

> > > We probably never saw the issue because no VMM uses SVE, but
> > > that's still pretty bad. Unconditionally clearing the flag
> > > on vcpu load addresses the issue.

> > Unless I'm missing something since we currently always disable
> > SVE on syscall even if the VMM were using SVE for some reason
> > (SVE memcpy()?) we should already have disabled SVE for EL0 in
> > sve_user_discard() during kernel entry so EL0 access to SVE
> > should be disabled in the system register by the time we get
> > here.

> Indeed. And this begs the question: what is this code actually doing?
> Is there any way we can end-up running a guest with any valid host SVE
> state?

> I remember being >this< close to removing that code some time ago, and
> only stopped because I vaguely remembered Dave Martin convincing me at
> some point that it was necessary. I'm unable to piece the argument
> together again though.

I've stared at that code a few times as well, I think I'd ended up
assuming it was some path to do with preempting and context switching
but in that case I've never been clear why there'd be anything left that
we'd need to preserve, or if we do why we don't just force a
fpsimd_save().  It's possible this was from some earlier stage in review
where the ABI didn't allow us to discard the SVE register state, or that
it's there as defensive programming so for future work where we don't
just disable on entry.

Conicidentally I am going to post some patches later today or tomorrow
which leave SVE enabled on syscall, they still have the hook for
disabling it when entering KVM though so we'd still not need to save the
EL0 state and the above should still apply.

--B+OWqsOhQgqxaqa/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmKd8C8ACgkQJNaLcl1U
h9AuDQf/VtGwAYDRDXwCU0D9tcpQJP64CtZ/QTytBLvoK2LGjER1sF9NO52CsDv2
LKMCVNLg64qR5K+eB9ruX6ER3XOtEP1ttwQNvNVkZxmx7uHi2zZA/8FVdy+5RHYH
651Hye9Gxe0Pq/dUj5H0Ij4eauwvOYahcpvoI+XDHNyM5DGjayLuqJX2BOFhfMvp
bSYpgzr63deaSi/Hm7d+zD/EFupGNoMcKJ2aYFbRx29AUeriEe+q2yR7wAiwXhbG
ZB6s+YX23A75vW7S1G3ujaPKAVenINEhfg8hGZ2G9GeJUw8iT6ckCm2CYAp6hurz
b8rnsx2vN0U9BYAo+aQrx24rn8sz0Q==
=8N3B
-----END PGP SIGNATURE-----

--B+OWqsOhQgqxaqa/--

--===============4978007607230260456==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============4978007607230260456==--
