Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64841C63703
	for <kvmarm@archiver.kernel.org>; Wed,  7 Dec 2022 14:16:49 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CA6A740CDE;
	Wed,  7 Dec 2022 09:16:48 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pu8SOoPn75gY; Wed,  7 Dec 2022 09:16:47 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8A9AC4B3EA;
	Wed,  7 Dec 2022 09:16:47 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 05B3B4B3DD
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Dec 2022 09:16:46 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aooXx8kNmqCG for <kvmarm@lists.cs.columbia.edu>;
 Wed,  7 Dec 2022 09:16:44 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id ADD9540C1B
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Dec 2022 09:16:44 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id BF90361798;
 Wed,  7 Dec 2022 14:16:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86871C433C1;
 Wed,  7 Dec 2022 14:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1670422603;
 bh=r3u8Dix8avniHqNjnYoG3w/Uhbpr86KS5aLsZSxY9h4=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=PfLETTKsFfL9c3rBgI7mKeD+wjxVnNTwOjYgUIX9CV7ItKFN2QB/maSG16lWXJueh
 SBmkoc+C4jZArNpcDOvaNLjrxV5acIjXboi+Xy764T1Iie+AlkFcJz49uPBSbff1lf
 CHfqeSSt9U6OZ7NykFsw9hWr1XYSWttUw+kUn0LpJOebbE6OENJZ6o6eFf5m46Zf4U
 bWkrafdEJr+rXy4fK1RB1ngvs6XNSNMmnVPMbCDEuAl3zvA578DTfGPyuli716TlS7
 VjvsgmXY6yabmrK9WaQlZPITOi46yVGKGlhNORBqEjCh+/ib84MLij/KDgzm+1lz0O
 dS4bcXMpp4qKg==
Date: Wed, 7 Dec 2022 14:16:36 +0000
From: Mark Brown <broonie@kernel.org>
To: Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v14 16/39] arm64/sme: Implement traps and syscall
 handling for SME
Message-ID: <Y5CgRPbjOChpHQEJ@sirena.org.uk>
References: <20220419112247.711548-1-broonie@kernel.org>
 <20220419112247.711548-17-broonie@kernel.org>
 <e57552ea-37fb-07da-8560-e26bae8205cd@huawei.com>
MIME-Version: 1.0
In-Reply-To: <e57552ea-37fb-07da-8560-e26bae8205cd@huawei.com>
X-Cookie: What!?  Me worry?
Cc: Marc Zyngier <maz@kernel.org>,
 Basant Kumar Dwivedi <Basant.KumarDwivedi@arm.com>,
 Will Deacon <will@kernel.org>, Luis Machado <luis.machado@arm.com>,
 Szabolcs Nagy <szabolcs.nagy@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Alan Hayward <alan.hayward@arm.com>,
 Salil Akerkar <Salil.Akerkar@arm.com>, linux-kselftest@vger.kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>, Shuah Khan <shuah@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 Luca Salabrino <luca.scalabrino@arm.com>
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
Content-Type: multipart/mixed; boundary="===============5687295232641267255=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


--===============5687295232641267255==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="xw/WPICFk6OpWXHF"
Content-Disposition: inline


--xw/WPICFk6OpWXHF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 07, 2022 at 10:00:17PM +0800, Zenghui Yu wrote:
> On 2022/4/19 19:22, Mark Brown wrote:

> > +	/*
> > +	 * If SME is active then exit streaming mode.  If ZA is active
> > +	 * then flush the SVE registers but leave userspace access to
> > +	 * both SVE and SME enabled, otherwise disable SME for the
> > +	 * task and fall through to disabling SVE too.  This means

> It looks a bit confusing to me that in the current implementation, if
> ZA is *not* active, we don't actually go to disable SME for the task
> (which IMHO can be disabled as user-space is not actively using it now).

Unlike SVE there's no overhead from leaving SME enabled, the enable bits
for SM and ZA tell us if there is extra register state to be saved so we
don't have to worry about the costs there like we do with SVE.  The only
reason for not just unconditionally enabling SME is the potentially
large backing storage required for the registers, if a task isn't using
SME there's no need to impose that overhead.  If we disable SME for
userspace after the storage has been allocated then we just require an
additional trip through EL1 to reenable it for any future usage which
would hurt performance but not really gain us anything otherwise.  We
don't want to discurage applications from disabling ZA when not in use
given that there's likely to be physical overheads from keeping it
enabled.

> > +		if (svcr & SYS_SVCR_EL0_SM_MASK)
> > +			sme_smstop_sm();

> As per the SME syscall ABI

> | On syscall PSTATE.SM will be cleared and the SVE registers will be
> | handled as per the standard SVE ABI.

> and the SVE syscall ABI

> | On syscall, V0..V31 are preserved (as without SVE).  Thus, bits
> | [127:0] of Z0..Z31 are preserved.  All other bits of Z0..Z31, and all
> | of P0..P15 and FFR become zero on return from a syscall.

> Can we infer from the documentation that V0-V31 should be preserved on
> return from a syscall? But with sme_smstop_sm(), all implemented bits of
> Z0-Z31 are set to zero by hardware. Is this intentional?

> Please fix me up if I've mis-read things here.

No, the intention is to say that we exit streaming mode and then handle
things as per the non-streaming ABI.  Exiting streaming mode has the
effect of clearing the values as you say.

--xw/WPICFk6OpWXHF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmOQoEQACgkQJNaLcl1U
h9DT2Qf/ZwEng2pEy0USKIPgcxnkZZTR1rImCaFy06I5mkGLN2DsF874tUEjlLVH
m3jTS9+Ekzmj+bHTrJ/E93HzlWGmWaAx+zAQy/Hx67A/wOraXL00RRSYjZ2QrHTm
0mZTDm2Cv6Y/Aqep2HbZAAyoyckjJXslXQZdpSM2ZHm3ZEWxUigtc+xHkQDw58qQ
/ZASpPtcm19SinaFJXXP4wPv5CU2hm1kXGvwdg16weggR5ro/3za6RFB63Up1VQ7
KQkppEUTmEaM4grb0JAYHFcr+gFcKIbXCaLqtkrClziQrHlAPJ/Rr9CXSTCuC8S/
K1UFr0G52c72xm1AZd1w9MrWDFOhuA==
=abex
-----END PGP SIGNATURE-----

--xw/WPICFk6OpWXHF--

--===============5687295232641267255==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============5687295232641267255==--
