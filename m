Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48441C433EF
	for <kvmarm@archiver.kernel.org>; Mon, 11 Jul 2022 11:40:03 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9045B4BAF1;
	Mon, 11 Jul 2022 07:40:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rsi+OBWJkpZg; Mon, 11 Jul 2022 07:40:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 405FA4BAF8;
	Mon, 11 Jul 2022 07:40:01 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 24CA24BAF1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Jul 2022 07:40:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id amZ5Qec1j2VP for <kvmarm@lists.cs.columbia.edu>;
 Mon, 11 Jul 2022 07:39:59 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EF9744BAF0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Jul 2022 07:39:58 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 986FE60FE0;
 Mon, 11 Jul 2022 11:39:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D601C34115;
 Mon, 11 Jul 2022 11:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1657539597;
 bh=QcFhSO3fDZ8CQR8r/d4xSKbVigxb4JkiwP86JO7BYks=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=Yyt/V9Wyq5kpJzo2SS/VP2ZaKYur6ASdzwiTEJeE2PUGRRBF5Y6j/VNDjbPd/Xd25
 M4C9IeS70QiVzZh7I+jKkWWzORxEemLq1DfOyL42II4pzUJWYskq4NenfrwPVC5tvF
 z9kV3ryf8qvIN2GW2QKhlzSshK6kEvVjj3G8Ajy5kEDA1VCT5r9YkCxCRRsB7xJdn6
 M6DhPfDp1O1bKdYVf4ZzKkuJ9sARzTiN8RSDXRVJNyzuF1OC8etIy0tf5t1VFR1h0N
 KusO28VGaeEvDxqx3WHe2u9ZllJapdITfcLT5fatQ2R3PI/razyGeNgIpgB6v6K9H8
 VLREyawt0h6pQ==
Date: Mon, 11 Jul 2022 12:39:51 +0100
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 2/7] arm64/fpsimd: Track the saved FPSIMD state type
 separately to TIF_SVE
Message-ID: <YswMB2v9TqPJHDM1@sirena.org.uk>
References: <20220620124158.482039-1-broonie@kernel.org>
 <20220620124158.482039-3-broonie@kernel.org>
 <87ilo4kmvx.wl-maz@kernel.org>
MIME-Version: 1.0
In-Reply-To: <87ilo4kmvx.wl-maz@kernel.org>
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
Content-Type: multipart/mixed; boundary="===============6058515328204458932=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


--===============6058515328204458932==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="YVW2UW0qiFmtedHO"
Content-Disposition: inline


--YVW2UW0qiFmtedHO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 11, 2022 at 10:40:50AM +0100, Marc Zyngier wrote:
> Mark Brown <broonie@kernel.org> wrote:

> > +	enum fp_state *type;

> For consistency: s/type/fp_type/ ?

Sure if nobody else wants a different bikeshed.  It really needs a
longer name like fp_state_t or something but that had it's own problems
with non-idiomaticness.

> >  	if (test_and_clear_tsk_thread_flag(task, TIF_SVE) ||
> > -	    thread_sm_enabled(&task->thread))
> > +	    thread_sm_enabled(&task->thread)) {
> >  		sve_to_fpsimd(task);
> > +		task->thread.fp_type = FP_STATE_FPSIMD;

> Can you move this assignment into the sve_to_fpsimd() helper?

There are cases where we want a FPSIMD version of the state for reading
but don't want to affect the actual state of the process (eg, if someone
reads the FPSIMD registers via ptrace) so we don't want to change the
active register state just because we converted it.  Adding another API
that does the convert and update didn't feel like it was helping since
you then have to remember which API does what and we already have lots
of similarly named functions for slightly different contexts.

> >  	} else {
> >  		fpsimd_to_sve(current);
> > +		current->thread.fp_type = FP_STATE_SVE;

> Same thing here.

There's not the same issue with reading FPSIMD state via the SVE APIs
but for consistency it seems best to always leave these updates in the
callers.

> > --- a/arch/arm64/kernel/ptrace.c
> > +++ b/arch/arm64/kernel/ptrace.c
> > @@ -892,8 +892,7 @@ static int sve_set_common(struct task_struct *target,
> >  		ret = __fpr_set(target, regset, pos, count, kbuf, ubuf,
> >  				SVE_PT_FPSIMD_OFFSET);
> >  		clear_tsk_thread_flag(target, TIF_SVE);
> > -		if (type == ARM64_VEC_SME)
> > -			fpsimd_force_sync_to_sve(target);

> I don't get this particular change. Can you please clarify?

That should probably be shifted to a later patch in the series, I think
I just rebased it to the wrong place.

--YVW2UW0qiFmtedHO
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmLMDAcACgkQJNaLcl1U
h9ANmwf/QKiXnauXjm6MI0qckKX0gB0dAd3z82l8Z/CXxGBMHmLCx5uHAuLwYbRb
VMaUfRDQz3mHrW+SBnZMV93Hu8EuCnNwFXgOiWM2Z5/x0PgBaqr9tAjzgGTwP1kR
PmGtE9t7k0mGf0kTd4dr04bakeSiTAQogfIFPKmZDXHq39BXQj4rou4TjD4yh/3L
UlVALroKLwFmfA1h+m4TM6jRtQuwQOqzVfrVbIHygPGVYYJLDOdYnmctRJM3GtnT
PNRtb/athlHcLBlHetXaBcdMKAbwimwtoYS7rgwvNvv2RvQWhnXFO40Mc0yExFfQ
CabCVdlqOoF/m4caKpNeiamSqP7/Gg==
=Lk2Y
-----END PGP SIGNATURE-----

--YVW2UW0qiFmtedHO--

--===============6058515328204458932==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============6058515328204458932==--
