Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13B6DC433F5
	for <kvmarm@archiver.kernel.org>; Thu, 10 Feb 2022 19:46:02 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6E5F149F31;
	Thu, 10 Feb 2022 14:46:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id aAEuwdOpTM4b; Thu, 10 Feb 2022 14:46:01 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2CE0F49EE2;
	Thu, 10 Feb 2022 14:46:01 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 44B2149EE2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Feb 2022 14:45:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zjS6MvZCCLUa for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Feb 2022 14:45:58 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EA63A49EAC
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Feb 2022 14:45:57 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id ECF8E615A1;
 Thu, 10 Feb 2022 19:45:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23B65C004E1;
 Thu, 10 Feb 2022 19:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1644522356;
 bh=2/d36OBbSBxlblWgpunNGQoCjUN3lbA5kTgumqeqpPU=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=hFbJvvg04LiXsdxqp6J+MMjRBfSHyXxF5SVtvHBUdfAm7Tj4ATmmEzAHLmTBxRgPG
 hZ6h65hQbrjz/1OZL+FLZ88/UQFYsgpDS9ZpSQJJQlYuLj4Mvad8D2YkkQVOtZrd+7
 M5RIbw4bhYAaFRYrbLF7buIt+7Sbv48m+xefrr6EEVj5dlWQ3gluyjQAzol45/adwO
 nJhEDnOU3gxFUV3QG2E00X0r7mDzhnFVVz6cyJd+uJpbg/nn7y3tXbEHOvA4glITdS
 YTCo4xt963J3T4ojxuVhxKp6lsstxLHYdvg8895QDpEqO4TnHDHjU3/vPHheFjxNUp
 D8md5Wf4M+yWA==
Date: Thu, 10 Feb 2022 19:45:49 +0000
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v11 06/40] arm64/sme: Provide ABI documentation for SME
Message-ID: <YgVrbc4fFrA0Vjh2@sirena.org.uk>
References: <20220207152109.197566-1-broonie@kernel.org>
 <20220207152109.197566-7-broonie@kernel.org>
 <YgVaTounTtunlGU6@arm.com>
MIME-Version: 1.0
In-Reply-To: <YgVaTounTtunlGU6@arm.com>
X-Cookie: Only God can make random selections.
Cc: Basant Kumar Dwivedi <Basant.KumarDwivedi@arm.com>,
 Will Deacon <will@kernel.org>, Luis Machado <luis.machado@arm.com>,
 Szabolcs Nagy <szabolcs.nagy@arm.com>, Marc Zyngier <maz@kernel.org>,
 Shuah Khan <skhan@linuxfoundation.org>, linux-arm-kernel@lists.infradead.org,
 linux-kselftest@vger.kernel.org, Alan Hayward <alan.hayward@arm.com>,
 Shuah Khan <shuah@kernel.org>, kvmarm@lists.cs.columbia.edu,
 Salil Akerkar <Salil.Akerkar@arm.com>
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
Content-Type: multipart/mixed; boundary="===============4775894684611347889=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


--===============4775894684611347889==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ucqnplsdaKjxWywi"
Content-Disposition: inline


--ucqnplsdaKjxWywi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 10, 2022 at 06:32:46PM +0000, Catalin Marinas wrote:
> On Mon, Feb 07, 2022 at 03:20:35PM +0000, Mark Brown wrote:

> > +It is implementation defined which if any parts of the SVE state are shared
> > +between streaming and non-streaming modes.  When switching between modes
> > +via software interfaces such as ptrace if no register content is provided as
> > +part of switching no state will be assumed to be shared and everything will
> > +be zeroed.

> Is there anything other than ptrace() here? I read the sigreturn() case
> below but did not say anything about changing PSTATE.SM via the
> sigcontext. I guess it's similar to ptrace().

The signal handling code requires that register data be provided to
restore with either form of SVE data, this falls out of the existing
requirement that register data be provided for SVE.

> > +4.  System call behaviour
> > +-------------------------

> > +* On syscall PSTATE.ZA is preserved, if PSTATE.ZA==1 then the contents of the
> > +  ZA matrix are preserved.

> Sorry if this was discussed. What is the rationale for preserving the ZA
> registers on syscall? We don't do this for the top part of the Z
> registers.

In both cases it's mirroring the expected PCS which is that for normal
functions they must be called with streaming mode disabled, the high
bits of Z may be changed and there is a lazy saving scheme for ZA.  The
handling of the Z registers falls out of a combination of the fact that
the low bits are shared with the V registers and a desire to
interoperate with binaries that are only aware of FPSIMD.

See:

  https://github.com/rsandifo-arm/abi-aa/blob/sme-aapcs64/aapcs64/aapcs64.rst

for the PCS (it's an open pull request on the AAPCS), if we disable ZA
we should really cooperate with the lazy save scheme for ZA in section
6.5 which would involve writing to userspace buffers.  Given that we
need to support preserving ZA for cases where userspace is preempted
it's not really much effort to do that, if userspace doesn't want the
cost it can disable ZA before doing a syscall and it means that syscalls
don't push userspace code that would otherwise not do anything with ZA
to have problems interoperating with the lazy saving scheme.

If we don't preserve ZA then userspace will be forced to save it when
enabled which increases overall costs, if we do preserve ZA then it's no
more expensive for the kernel to save it than userspace, we avoid the
cost of restoring in the case where return directly to userspace without
context switching and if we do future work to save more lazily then we
may be able to avoid some of the saves.

> > +  as normal.

> What does that mean? Is this as per the sve.rst doc (unspecified but
> zeroed in practice)?

Yes, we will exit streaming mode and proceed as per sve.rst and the rest
of the ABI.

> > +* Neither the SVE registers nor ZA are used to pass arguments to or receive
> > +  results from any syscall.
> > +
> > +* On creation fork() or clone() the newly created process will have PSTATE.SM
> > +  and PSTATE.ZA cleared.

> This looks slightly inconsistent with the first bullet point on ZA being
> preserved on syscalls. Why do these differ?

Largely just because it's more complicated to implement copying the ZA
backing store for this and it seemed more likely that someone would be
surprised by a new process getting stuck carrying a potentially large
copy of ZA around that it was unaware of than that someone would
actually want that to happen.  It's not a particularly strongly held
opinon.

> > +[4] ARM IHI0055C
> > +    http://infocenter.arm.com/help/topic/com.arm.doc.ihi0055c/IHI0055C_beta_aapcs64.pdf
> > +    http://infocenter.arm.com/help/topic/com.arm.doc.subset.swdev.abi/index.html
> > +    Procedure Call Standard for the ARM 64-bit Architecture (AArch64)

> The second link no longer works. I also couldn't find any reference to
> [4] but there's a lot of text to scan, so I may have missed it.

We don't referenced it, it's just carried over from SVE.

--ucqnplsdaKjxWywi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmIFa2wACgkQJNaLcl1U
h9AJwgf/Ypezgo+N1Oozlkua7rL21V3dADz3wxpSkFNz+XMGuu4D9jB5MQMFQ2wt
T9nTi48TNkn+0KIronwPWFZU8HJgScMUdTMCbc5vH1zbcmwvl6yo81kFZvLV3WTv
Wnic6YqHhO8DDI3yEv+4qb9VzrcMHJ3CfJmBdZHMChHl0kZtebtOr8OOv/VdTQ7g
bVKliNO14tPkP1n46GnuCX9E9PTyf00wXxBsPJSJN6xJka79shXNS1QiamJtskb+
fsYYtmlLcOMvX0pV3ECRlUsN2RrjRfAR67/AD47A2Bu5izFbrn6t2+1NwNi8RLgJ
isjUK1vyHHxXlcogPQqvcLCHK0+QTw==
=4wmD
-----END PGP SIGNATURE-----

--ucqnplsdaKjxWywi--

--===============4775894684611347889==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============4775894684611347889==--
