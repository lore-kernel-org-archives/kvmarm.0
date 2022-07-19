Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB721C43334
	for <kvmarm@archiver.kernel.org>; Tue, 19 Jul 2022 19:35:58 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 29B964D266;
	Tue, 19 Jul 2022 15:35:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pBfdrGQO9mq6; Tue, 19 Jul 2022 15:35:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CAB364D2A9;
	Tue, 19 Jul 2022 15:35:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AA81F4D230
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Jul 2022 15:35:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qwKFvGOMNvQY for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Jul 2022 15:35:54 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3090F4D20D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Jul 2022 15:35:54 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 1FD866186B;
 Tue, 19 Jul 2022 19:35:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37198C341C6;
 Tue, 19 Jul 2022 19:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1658259352;
 bh=Qg6YkBmuBlja6LeIGdlnFWdXJUjQm1l7cF8EaM+cBxQ=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=CVJt7KlGpt5vFgxktKqZLhu8FvPQ3QrMUv0aFxtVEo2arGqH5DFmB2cBBs5dlbrQI
 lIYivftSc98bPEuyWFb4AxIuhPjX3bGAM8OTQALSmV8UwySxRlCLIQyCGzDgtvMx2L
 YTFLtqWuvh06vbzQyV0+sGp9ohSzDpXuHV/SvgZ9YYghhF4kpEAOUBO62YIHEcFWTa
 +T+MrBODpFil5Z2HfFRmrywFoUw8ZCTSQVTNF9mByYu/syi/Tvh9iqhPCeG6h8kv60
 GYzUOFUmccFLMWg6Tl378CD+Y11Lff967XaMxEk3rHrKDbivpI2gGkJwR5Op3EqfsF
 xCOxgyn2KmwVQ==
Date: Tue, 19 Jul 2022 20:35:46 +0100
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v2 7/7] arm64/sve: Don't zero non-FPSIMD register state
 on syscall by default
Message-ID: <YtcHkkwiDZTEpWrZ@sirena.org.uk>
References: <20220620124158.482039-1-broonie@kernel.org>
 <20220620124158.482039-8-broonie@kernel.org>
 <YtbraaDE0eJhRHkx@arm.com>
MIME-Version: 1.0
In-Reply-To: <YtbraaDE0eJhRHkx@arm.com>
X-Cookie: We have ears, earther...FOUR OF THEM!
Cc: Marc Zyngier <maz@kernel.org>, Zhang Lei <zhang.lei@jp.fujitsu.com>,
 Andre Przywara <andre.przywara@arm.com>, Will Deacon <will@kernel.org>,
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
Content-Type: multipart/mixed; boundary="===============7348892065846054139=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


--===============7348892065846054139==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="DGsKteio2rdJZD7S"
Content-Disposition: inline


--DGsKteio2rdJZD7S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 19, 2022 at 06:35:37PM +0100, Catalin Marinas wrote:
> On Mon, Jun 20, 2022 at 01:41:58PM +0100, Mark Brown wrote:

> > The documented syscall ABI specifies that the SVE state not shared with
> > FPSIMD is undefined after a syscall. Currently we implement this by
> > always flushing this register state to zero, ensuring consistent
> > behaviour but introducing some overhead in the case where we can return
> > directly to userspace without otherwise needing to update the register
> > state. Take advantage of the flexibility offered by the documented ABI
> > and instead leave the SVE registers untouched in the case where can
> > return directly to userspace.

> Do you have some rough numbers to quantify the gain? I suspect the
> vector length doesn't matter much.

I got some benchmarking done with fp-pidbench (which like I think I say
somewhere in the series is a nonsense benchmark but still) which showed
an IIRC approximately 1% or so win from a similar change that was fairly
consistent over a few implementations.  Unfortunately I don't yet have
access to systems that would allow me to benchmark directly and
nobody's got back with numbers for this specific code, the numbers were
with some earlier proof of concept work.

There is some vector length dependency when we move over 128 bits, at
128 bits there's no state in the Z registers that isn't shared with the
V registers so we can and do already skip handling them entirely which
makes the overhead of zeroing noticably lower, beyond that the cost
should be stable.  The additional cost for the Z registers was *about*
the same as that of just doing the P registers IIRC, that does track
with doing an additional 32 floating point operations.

128 bit systems are in general a bit of a special case for optimisation
due to the reduced extra state.

> Where does the zeroing happen now? IIRC it's only done on a subsequent
> trap to SVE and that's a lot more expensive (unless the code has changed
> since last time I looked).

At the minute we drop SVE permission for userspace on syscall entry, the
actual zeroing for the task happens when it next takes a SVE trap prior
to reenabling SVE for EL0.

> So if it's the actual subsequent trap that adds the overhead, maybe
> zeroing the regs while leaving TIF_SVE on won't be that bad.

Yeah, it's definitely *much* less exciting than the win from avoiding
the SVE trap.

> > The sysctl is disabled by default since it is anticipated that the risk
> > of disruption to userspace is low. As well as being within the
> > documented ABI this new behaviour mirrors the standard function call ABI
> > for SVE in the AAPCS which should mean that compiler generated code is
> > unlikely to rely on the current behaviour, the main risk is from hand
> > coded assembly which directly invokes syscalls. The new behaviour is
> > also what is currently implemented by qemu user mode emulation.

> IIRC both Will and Mark R commented in the past that they'd like the
> current de-facto ABI to become the official one. I'll let them comment.

That would be good.  I've not heard anything from Will either directly
or indirectly.  Mark R has indicated privately directly to me that he
originally pushed for the currently implemented behaviour and prefers
it.  Marc Zyngier has previously noted publicly the current behaviour
being a consideration in the context of discusion of optimisation ideas
like this one, I was a bit surprised that he commented on an earlier
patch in the series but not this one.  You have previously pushed back
on an attempt to document the current ABI, that was the main motivation
for writing this patch. =20

I don't have a particular opinion either way but I do feel strongly that
we should either take advantage of the currently documented ABI or
document our actual ABI, right now we've got the worst of both worlds so
we should make a decision and pick one of those options.

> > -	if (test_thread_flag(TIF_SVE)) {
> > +	if (sve_syscall_regs_clear && test_thread_flag(TIF_SVE)) {
> >  		unsigned int sve_vq_minus_one;

> >  		sve_vq_minus_one =3D sve_vq_from_vl(task_get_sve_vl(current)) - 1;

> If we leave TIF_SVE on, does it mean that we incur an overhead on
> context switching? E.g. something like hackbench with lots of syscalls
> communicating between threads would unnecessarily context switch the SVE

It is true that in the context switch case if we zero on syscall entry
then we end up zeroing and then discarding the SVE state but in the
context of the context switch and a future SVE trap that should be
tolerable, and if the task doesn't use SVE between switches in syscalls
then it'll not have SVE enabled be impacted either way.

> state. Maybe there's something handling this but IIUC fpsimd_save()
> seems to only check TIF_SVE.

As of patch 6 in this series fpsimd_save() checks both TIF_SVE and
in_syscall() when using FP_STATE_TASK so we should only save the FPSIMD
state if we're in a syscall, in that patch we remove the clearing of
TIF_SVE on syscall and update fpsimd_save() to also check in_syscall()
when deciding what to save.  Prior to that we're keeping the behaviour
the same so fpsimd_sve() is only checking TIF_SVE, it's these last two
patches that intend to introduce behaviour changes.

--DGsKteio2rdJZD7S
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmLXB5IACgkQJNaLcl1U
h9CSlQf9Ghv3BpMV6249u4nBjNKZ4vnC/QtyBlyGSxN+0afhLrVBcbtrCERaN6ta
yYCfCOtd4mX68JLn5GGiL8LZrimFuptD4HvGcOfJSssuFR/Kfa8hlNzZGz6Uo1sF
n9V8PhL2viUClUC4TWW9DDnYTVJH1tP6M9pEYFNUfJmX7uNHFSo+mYyexwAL4tQK
jMZ9WsRBpezDZApe4gzaWdemqGiNWpKnupOkDI9bB/SljawvAJqcosl/0xdJT+fC
+BmKguHVQoz+Bzy7/08zG/T+lucLZdAl9AhCQqyT+WDPnJ7rm1uiytGznNJKN/sI
p6AbWvOSFFlvVaQ4boXEqPXvnZ8+rw==
=iXkA
-----END PGP SIGNATURE-----

--DGsKteio2rdJZD7S--

--===============7348892065846054139==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============7348892065846054139==--
