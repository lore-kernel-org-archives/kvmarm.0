Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0C0AC54EE9
	for <kvmarm@archiver.kernel.org>; Thu, 22 Sep 2022 12:18:39 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2D3D2408AB;
	Thu, 22 Sep 2022 08:18:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0zmzPhiq47VE; Thu, 22 Sep 2022 08:18:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CCF69410FF;
	Thu, 22 Sep 2022 08:18:37 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ED670404CD
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Sep 2022 08:18:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Lg1oXVqRKxUx for <kvmarm@lists.cs.columbia.edu>;
 Thu, 22 Sep 2022 08:18:35 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9EC8B402A9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Sep 2022 08:18:35 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id ED2A260BBE;
 Thu, 22 Sep 2022 12:18:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF931C433D6;
 Thu, 22 Sep 2022 12:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1663849114;
 bh=hBJ1HPUqhMSz2ZLzOLvEDQZTDuUwhJ1yHQTFU2MtdkE=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=ey5/yqCA/Obq8UW1iMxX0mTx1fQ1T1i6LQx696s14gNvD4Gh11nAVNOHNSmYdbe0C
 fO28jPXuELpnPy+oJ1UjORnwyS5FNUsLCfoXCGHs7TQUuJijAepSLu0Z/U0NtZl9Pw
 dOWBEOZ83Q72oA82EtRKkQNFdbyWZ6U6SozwMxXfwgu2D8OEolmxPyutjaqS48c/Ls
 Q7ymzVuzWucih5WybLK4ZNhAWxw6w4ete8e5UdXSTGAPGP0CZk1AVh3xM4+SxuKB9n
 vJL0YsPFeI8WHsgsEyEE4LOyplDr/R/NViJKIlHTWaLNAQoLJEGKFWTDKpmrmzlwt8
 rGUIulJwxwRyw==
Date: Thu, 22 Sep 2022 13:18:30 +0100
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v3 3/7] arm64/fpsimd: Have KVM explicitly say which FP
 registers to save
Message-ID: <YyxSloe6PBV1EuI1@sirena.org.uk>
References: <20220815225529.930315-1-broonie@kernel.org>
 <20220815225529.930315-4-broonie@kernel.org>
 <87wn9yj5l0.wl-maz@kernel.org> <YyoHUS0ZPQvvjrte@sirena.org.uk>
 <87leqck4ba.wl-maz@kernel.org>
MIME-Version: 1.0
In-Reply-To: <87leqck4ba.wl-maz@kernel.org>
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
Content-Type: multipart/mixed; boundary="===============8267725324392040735=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


--===============8267725324392040735==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="wyErPB4wFLKJM+lG"
Content-Disposition: inline


--wyErPB4wFLKJM+lG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 21, 2022 at 06:47:21PM +0100, Marc Zyngier wrote:
> Mark Brown <broonie@kernel.org> wrote:

> > It means that using FP_STATE_TASK as a value for the fp_type
> > member of the task struck recording what type of state is
> > currently stored for the task is not valid, one of the other two
> > values representing what was actually saved must be chosen.

> Then this definitely represents something else, and shouldn't be a
> state or a type, whatever you decide to call it in the end. There is
> the state of the FP/SVE unit, and what some piece of SW wants to
> save. They match in some cases, and differ in other (the TASK
> value). I'd rather you encode them as them as different types to lift
> the ambiguity.

I did try the other way as well and found it was creating it's
own problems - you end up with two almost identical enums which
need to be separately named in some meaningful yet not
excessively verbose fashion and have to remember which one to use
in which context.

> > > OK, how many discrete arguments are we going to pass to this function,
> > > which most of them are part the vcpu structure? It really feels like
> > > what you want is a getter for the per-cpu structure, and let the KVM
> > > code do the actual business. If this function was supposed to provide
> > > some level of abstraction, well, it's a fail.

> > I agree that this is not an ideal interface, I am merely
> > following the previously chosen idiom since I haven't been able
> > to figure out why we were doing it in the first place and with a
> > lot of these things it turns out that there's some actual reason.

> Huh. If we're changing anything around this code, we'd better
> understand what we are doing...

I'm confident I understand well enough what it's doing, I'm just
really unclear on why it's written the way it is.

> > It's not even like fpsimd_bind_task_to_cpu() has ever been
> > written in terms of this function, there's two parallel
> > implementations.  My best guess was that it was some combination
> > of not peering at KVM internals and keeping struct
> > fpsimd_last_state_struct internal to fpsimd.c (since we're
> > effectively just passing one of those in in a more verbose form)
> > but never anything solid enough to be sure.

> Up to you, but adding extra parameters to this function really feels
> like the wrong thing to do.

Indeed, I'm not a big fan myself.  I also don't want to get this
and some other work I'm doing tied up on stylistic improvements
to what's already there which seem likely introduce additional
iterations - I'd rather loop back on this as a separate thing
later.

--wyErPB4wFLKJM+lG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmMsUpMACgkQJNaLcl1U
h9Dn8gf/VXKjeCwKtmtAjAoJnje8QrNnDTHn4XyuLl38b5Lf/pTDzFgxT6GsPJ8j
OZh+t/1oF/KZ+aPm+wjK7P40Kw8b52KfrFAQuASp7rvjgTm0lqdLEgpcEz0pzeAX
L4F+vLnvA3e9OCoH+4vUyxEm/1xkY4TECVya3x1Wx9Q04pC9rOKnstUUNkJgpIdP
Wm3J62WcPYP6gJjgJM+78ylGfTo4c6Vle7MBzmykP4eo7RMpC4rMPP/bqoK+M6KS
/OXmJm7Ob2j5prCDZt0AQJAqQX/BUHN8z2uqC8+p7m0VOHNXpKwngh5UkIk4k214
AWZABBMTJSObu1JeBHW8x89OoFiw5Q==
=VaNg
-----END PGP SIGNATURE-----

--wyErPB4wFLKJM+lG--

--===============8267725324392040735==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============8267725324392040735==--
