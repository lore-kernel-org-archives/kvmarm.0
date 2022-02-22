Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF66BC433EF
	for <kvmarm@archiver.kernel.org>; Tue, 22 Feb 2022 18:17:14 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 53CC049EF5;
	Tue, 22 Feb 2022 13:17:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hJKzftt4P8We; Tue, 22 Feb 2022 13:17:12 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A323E49F33;
	Tue, 22 Feb 2022 13:17:12 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4CCCE49ED1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Feb 2022 13:17:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3mQY1a9IFRxb for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Feb 2022 13:17:03 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 67802404B2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Feb 2022 13:17:03 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 49F35612D5;
 Tue, 22 Feb 2022 18:17:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76747C340E8;
 Tue, 22 Feb 2022 18:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1645553821;
 bh=MAUQrzPoVyGg35iV25GX0SuNLSauz5QYCshu0X7ErLA=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=K4kP1d/3LrMcCtQIdy6XWKMykzzzOuz/P0APllZGT9z+ZJzhwtiiupPwtqy3SjuDW
 OqBmQRWKFa5ghDAKphXUsDxiT/+PwSduUbmQe301RAiZv76X7kSrtdxdnLbKbcb94X
 9I7S//e7/GO5vLmQl6fxnNtLfBw3l+3yXmqSvVBqv6IjbPUJQfKNiEsp2aS7ur8E/r
 v3KFlb5PHuO9c7f2J6s9Q1fhmTAeAoavc4J1rlmIdkItvAz2p9AyEbNZy3aF0bSS+y
 OCCRxnC9+ts15C4bQ/7RxMZKP6yfvpf/BU5dUp3fQH0cWd/VWrTY4SWtunBd0xFM5E
 5DuBpayL2zRPQ==
Date: Tue, 22 Feb 2022 18:16:55 +0000
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v11 18/40] arm64/sme: Implement traps and syscall
 handling for SME
Message-ID: <YhUol4EV0OTyXmDw@sirena.org.uk>
References: <20220207152109.197566-1-broonie@kernel.org>
 <20220207152109.197566-19-broonie@kernel.org>
 <YhUjZZGaTW4FAkvM@arm.com>
MIME-Version: 1.0
In-Reply-To: <YhUjZZGaTW4FAkvM@arm.com>
X-Cookie: I smell a wumpus.
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
Content-Type: multipart/mixed; boundary="===============8917342854883531412=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


--===============8917342854883531412==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="bBZysAYOWnT5sYmR"
Content-Disposition: inline


--bBZysAYOWnT5sYmR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 22, 2022 at 05:54:45PM +0000, Catalin Marinas wrote:
> On Mon, Feb 07, 2022 at 03:20:47PM +0000, Mark Brown wrote:

> > On syscall we exit streaming mode if we were previously in it and ensure
> > that all but the lower 128 bits of the registers are zeroed while
> > preserving the state of ZA. This follows the aarch64 PCS for SME, ZA
> > state is preserved over a function call and streaming mode is exited.

> I'm not sure this is entirely correct about the PCS. The caller must
> disable SM if the function it calls is not compatible. But it's fine for
> the kernel to impose this at the ABI level.

Yeah, I was thinking of it as being constructive error handling for
being a normal function - if this were within userspace then the risk
for the caller would be a SIGILL when the called function tries to do
something that's invalid in streaming mode.  I'll tweak the text.

> > +	if (system_supports_sme() && test_thread_flag(TIF_SME) &&
> > +	    !restore_sve_regs) {
> > +		int sve_vq_minus_one;
> > +
> > +		sve_vq_minus_one = sve_vq_from_vl(task_get_sve_vl(current)) - 1;
> > +		sve_set_vq(sve_vq_minus_one);
> > +		sve_flush_live(true, sve_vq_minus_one);
> > +	}

> Shouldn't the SVE state be flushed by the hardware when switching to
> streaming mode?

Ah, yes - this is now the case.  In earlier revisions of the
specification it was implementation defined if the state was zeroed or
preserved so we had to clear but with the current version the state will
always be zeroed so the flush is redundant and can be deleted.

> > +	/*
> > +	 * If SME is active then exit streaming mode.  If ZA is active
> > +	 * then flush the SVE registers but leave userspace access to
> > +	 * both SVE and SME enabled, otherwise disable SME for the
> > +	 * task and fall through to disabling SVE too.  This means
> > +	 * that after a syscall we never have any SME register state
> > +	 * to track, if this changes the KVM code will need updating.
> > +	 */

> By "we never have any SME register state to track" I understand that we
> drop the ZA state as well which AFAICT is not the case.

s/SME/streaming SVE/

--bBZysAYOWnT5sYmR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmIVKJYACgkQJNaLcl1U
h9BEpQf/cXSopp2p1A/Lku6H/oZh6fssrxuAE1d6Kc7xr0F8rm7Fn9qhanZDObJI
2MIqPGdjBSEzYGjyOR32r/VxF9P7vPgBgjqEGYxCzdcgHru4zlbAacjSCDwbSH1Q
DX0KrOr69cZw/INCqiut5BC282Q3aY14mQXHuEgIfiCe/gBFV2IA/eHNOm36OrXZ
AFEB8z6AcIMp4n8AaaNQ33jlF2Ut5RexB4UPzVAW+V9zTj/QsivB2kT9//QvEjlj
4QE2dkuDGLN+tQYTS9AesKgqdEY/wkyqn0GU7AxP5NNxrHgWpLU9MSROuL/A6UKp
RyQaqzly7DOdxjud5bZXnVNRAjR77w==
=QLrH
-----END PGP SIGNATURE-----

--bBZysAYOWnT5sYmR--

--===============8917342854883531412==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============8917342854883531412==--
