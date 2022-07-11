Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC898C433EF
	for <kvmarm@archiver.kernel.org>; Mon, 11 Jul 2022 15:53:53 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 636744B7E2;
	Mon, 11 Jul 2022 11:53:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9oedTzjUV8i7; Mon, 11 Jul 2022 11:53:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E4DE74B947;
	Mon, 11 Jul 2022 11:53:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C8FAB4B7E2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Jul 2022 11:53:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aY9GAgxwH7sa for <kvmarm@lists.cs.columbia.edu>;
 Mon, 11 Jul 2022 11:53:49 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8475C4B655
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Jul 2022 11:53:49 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 7D89A6104F;
 Mon, 11 Jul 2022 15:53:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60709C34115;
 Mon, 11 Jul 2022 15:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1657554828;
 bh=x/+NZrQLovhCePrLFzt1Pdb82Zb5l1wuMFjM9DHfgmY=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=gnInIpun1pwBAmpjyvYNLaw5+bxpNSn7kzGJlBAlSvmjvF2c4PEagn5JscfL7wJBj
 KNOJ+Jlk7qHDeeor28oAZo2UWcif0mCjqbzWWN9orsgrefbr+JuW/1zAcwOaH98XTV
 f2gTWapSrLQraD6qP1NIuqVmEj2PJyCuNFnPhhIJs8IIa4NZV31QF2U1a/2ADMdnti
 pPFAQFXqsvUDajAzaN4+d2uQf3kDZ0b3X6zRcOn6OJXAsnZiMC6RQWtPbJkkvs9+9B
 heeYY9ARAaSPQn23wBZ7E9ZI9R30AE+316HIXiklV8k6hGeFtxNmruStuk7HerxCO5
 Xg8v8L/SrQ4gQ==
Date: Mon, 11 Jul 2022 16:53:43 +0100
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 2/7] arm64/fpsimd: Track the saved FPSIMD state type
 separately to TIF_SVE
Message-ID: <YsxHhx3PaPRZCLmF@sirena.org.uk>
References: <20220620124158.482039-1-broonie@kernel.org>
 <20220620124158.482039-3-broonie@kernel.org>
 <87ilo4kmvx.wl-maz@kernel.org> <YswMB2v9TqPJHDM1@sirena.org.uk>
 <87h73nlnw0.wl-maz@kernel.org>
MIME-Version: 1.0
In-Reply-To: <87h73nlnw0.wl-maz@kernel.org>
X-Cookie: I am NOMAD!
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
Content-Type: multipart/mixed; boundary="===============2511590477898223236=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


--===============2511590477898223236==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="WrRSAYoHS7qTuBgz"
Content-Disposition: inline


--WrRSAYoHS7qTuBgz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 11, 2022 at 03:33:51PM +0100, Marc Zyngier wrote:
> Mark Brown <broonie@kernel.org> wrote:
> > On Mon, Jul 11, 2022 at 10:40:50AM +0100, Marc Zyngier wrote:
> > > Mark Brown <broonie@kernel.org> wrote:

> > > > +	enum fp_state *type;

> > > For consistency: s/type/fp_type/ ?

> > Sure if nobody else wants a different bikeshed.  It really needs a
> > longer name like fp_state_t or something but that had it's own problems
> > with non-idiomaticness.

> I'm not talking about the name of the type, but about the name of the
> member in the struct fpsimd_last_state_struct. I'd like it to be
> homogeneous to the name you use in struct kvm_vcpu_arch. 'type' is way

Ah, sure I can do that.  I had thought this being in the FP last state
structure made things clear here.

> > > > -	    thread_sm_enabled(&task->thread))
> > > > +	    thread_sm_enabled(&task->thread)) {
> > > >  		sve_to_fpsimd(task);
> > > > +		task->thread.fp_type = FP_STATE_FPSIMD;

> > > Can you move this assignment into the sve_to_fpsimd() helper?

> > There are cases where we want a FPSIMD version of the state for
> > reading but don't want to affect the actual state of the process
> > (eg, if someone reads the FPSIMD registers via ptrace) so we don't
> > want to change the active register state just because we converted
> > it.  Adding another API that does the convert and update didn't feel
> > like it was helping since you then have to remember which API does
> > what and we already have lots of similarly named functions for
> > slightly different contexts.

> I still think the state conversion should be self contained.
> Sprinkling this context tracking is bound to end-up with a bug, while
> documenting what is to be used when, or with a helper named
> explicitly enough ("extract_fp_from_sve()" springs to mind) for
> ptrace.

My experience trying to follow and update this code has been that
layering on more helpers just shifts the potential for bugs around -
it's easy to have the calling context using the wrong helper and looking
correct, or to spend time cross checking if the helper in a particular
context is the right one.  Sometimes this happens because something
about the calling context changed rather than due to writing a new use.
Yes, someone might forget to update the state type but my experience
with this code is that it's a lot easier to spot "this is writing new
state, did it update the state type?" than "this is writing new state,
did it call the helper that implicitly updates the state type or the
other one?".

Since these callers are already explicitly peering into the data in one
form or another (like reading or writing the actual register values, and
including for some checking the type information) it seems reasonable
for them to also be doing updates to the type selection explicitly.  It
does also make the error handling a little neater, if we are switching
between state types then in the case of error we just leave things using
the old, unmodified state.

--WrRSAYoHS7qTuBgz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmLMR4YACgkQJNaLcl1U
h9CaxQf+MF1YRCkg87ipxPvssfDyCksfPEAgFg6Z+wbtMZQjaoxxrGc88Shl6l8f
3regxSfb4AN34gaZ9N4xbDN5hhkDo9aWHZSdvS/tZZpXutGLDyCjUcWDiui+J+q9
42HYQ5+0WXew++6U+hLFLW/oHSZfAOX+uWl66O9FaDOVD8jRXh/HlVt6A+0QBSeR
QGY7eBNNayhrCVUyoKHn3APiyYxWvPDI92ku+2zxoM8UjPVkzkGUn4x6zG9VvUUX
7AnYkx/BlmbCR4maEjHX6Y2reTzL4Q5nYCyuOaAYPzZfBgiQl+LRrnGs528MeBlU
GdADUJ6KhrAi4gP0PRnYMzIKzlBh1A==
=1Z/E
-----END PGP SIGNATURE-----

--WrRSAYoHS7qTuBgz--

--===============2511590477898223236==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============2511590477898223236==--
