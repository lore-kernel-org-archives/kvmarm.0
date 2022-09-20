Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CD8CC6FA82
	for <kvmarm@archiver.kernel.org>; Tue, 20 Sep 2022 18:32:57 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8E35B4B10B;
	Tue, 20 Sep 2022 14:32:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id msO57RY9iPkT; Tue, 20 Sep 2022 14:32:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 48F134B601;
	Tue, 20 Sep 2022 14:32:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 991FD4B125
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 14:32:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8mwPVqvaqfrt for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Sep 2022 14:32:54 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 25E414B10B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 14:32:54 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 2C02362C30;
 Tue, 20 Sep 2022 18:32:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E67F3C433C1;
 Tue, 20 Sep 2022 18:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1663698772;
 bh=4gCGGvNVdHn884SylM/GIo6Xl70CZg4dLv1Oi0fNSqs=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=tNSNRjSV/3lKfWA4qvWuaxIDQNgWyBGrJ0HodVDgZyv+ixzmixAGJLa4JprHcl1Xj
 z41cFgCQFapvAW2lUqDnB3OfsQzqz8KbuBPVI/IMBt+bbNyvTYTY4XDJsrkdyNWaiz
 02t21ydPfuZALGVyBEGnAPEE7gVAuCcEE0P0YaJOIukTmcJJlrQUR7Qn5yeH51Rz8O
 h5ZMQsrzjsiVTFDwcuxZSTe0DjnLnNtY/KcszzvqIw5/8p3VdhBuuwoOc+34kO4RT2
 f6IhuKVqGoPcBx3uk2Ku+fEWTINDqjgsXI24+JXjjGaz78jnlvr8mdNzj2s3StWfq9
 O4e7rXr1tWypg==
Date: Tue, 20 Sep 2022 19:32:49 +0100
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v3 3/7] arm64/fpsimd: Have KVM explicitly say which FP
 registers to save
Message-ID: <YyoHUS0ZPQvvjrte@sirena.org.uk>
References: <20220815225529.930315-1-broonie@kernel.org>
 <20220815225529.930315-4-broonie@kernel.org>
 <87wn9yj5l0.wl-maz@kernel.org>
MIME-Version: 1.0
In-Reply-To: <87wn9yj5l0.wl-maz@kernel.org>
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
Content-Type: multipart/mixed; boundary="===============6906169315830240854=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


--===============6906169315830240854==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Kau3HDJ3G1WN9QYn"
Content-Disposition: inline


--Kau3HDJ3G1WN9QYn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 20, 2022 at 06:52:59PM +0100, Marc Zyngier wrote:
> On Mon, 15 Aug 2022 23:55:25 +0100,
> Mark Brown <broonie@kernel.org> wrote:

> >  enum fp_state {
> > +	FP_STATE_TASK,		/* Save based on current, invalid as fp_type */

> How is that related to the FP_TYPE_TASK in the commit message? What

TYPE in the commit message should be STATE.

> does this 'invalid as fp_type' mean?

It means that using FP_STATE_TASK as a value for the fp_type
member of the task struck recording what type of state is
currently stored for the task is not valid, one of the other two
values representing what was actually saved must be chosen.

> > +	/*
> > +	 * For now we're just validating that the requested state is
> > +	 * consistent with what we'd otherwise work out.

> Nit: work out? or worked out? the "we'd" doesn't help disambiguate it
> for a non-native speaker.

we'd =3D=3D we would so work out to match the tense.

> >  void fpsimd_bind_state_to_cpu(struct user_fpsimd_state *st, void *sve_=
state,
> >  			      unsigned int sve_vl, void *za_state,
> >  			      unsigned int sme_vl, u64 *svcr,
> > -			      enum fp_state *type)
> > +			      enum fp_state *type, enum fp_state to_save)

> OK, how many discrete arguments are we going to pass to this function,
> which most of them are part the vcpu structure? It really feels like
> what you want is a getter for the per-cpu structure, and let the KVM
> code do the actual business. If this function was supposed to provide
> some level of abstraction, well, it's a fail.

I agree that this is not an ideal interface, I am merely
following the previously chosen idiom since I haven't been able
to figure out why we were doing it in the first place and with a
lot of these things it turns out that there's some actual reason.

It's not even like fpsimd_bind_task_to_cpu() has ever been
written in terms of this function, there's two parallel
implementations.  My best guess was that it was some combination
of not peering at KVM internals and keeping struct
fpsimd_last_state_struct internal to fpsimd.c (since we're
effectively just passing one of those in in a more verbose form)
but never anything solid enough to be sure.

> >  void kvm_arch_vcpu_ctxsync_fp(struct kvm_vcpu *vcpu)
> >  {
> > +	enum fp_state fp_type;
> > +
> >  	WARN_ON_ONCE(!irqs_disabled());
> > =20
> >  	if (vcpu->arch.fp_state =3D=3D FP_STATE_GUEST_OWNED) {
> > +		if (vcpu_has_sve(vcpu))
> > +			fp_type =3D FP_STATE_SVE;

> Eventually, I'd like to relax this, and start tracking the actual use
> of the guest rather than assuming that SVE guest use SVE at all times
> (odds are they won't).

> I hope this series still leaves us with this option.

Yes, it probably makes it more tractable with KVM being able to
just say what type of state it wants to save so there's less to
take care of syncing with the host task so the code is a lot more
direct - it will just be a case of setting the desired fp_type
whenever a decision is made about what state type to save.

--Kau3HDJ3G1WN9QYn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmMqB1AACgkQJNaLcl1U
h9AhPAf/RmK2od7fqUEd5u8ml4vpFinVTkXdN8NTxJ5vRCRaDzyn1/yt8SHlz8tA
92DIlNoIRVN0S69lBbjITuzS8r2NKEM5wIoq+zKpRS6RaKQJyQK8Uk9mW8UAtk6i
pADL23UuCpBYkjSF0krvFnHQsGc9p/wGZRIQ8IYbc+n+VzOi53+UxPorWIMQehEu
+MDpfbZxB5fJE4AGIxAwdbAgTTDIwosKMUqJHnwkXaB9Kq+p3BAI7T7k82Ad2cwc
cKM/1OJTFYYrah0WRu7mA9v2MShjXgSDbIqc7qSWBPuUifkmSVfoAWgrXQZE/BJl
Cw5Hlf4SiFcRKdaIha8OIu31mMIFJA==
=/4PY
-----END PGP SIGNATURE-----

--Kau3HDJ3G1WN9QYn--

--===============6906169315830240854==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============6906169315830240854==--
