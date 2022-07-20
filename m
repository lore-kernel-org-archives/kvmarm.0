Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1030C43334
	for <kvmarm@archiver.kernel.org>; Wed, 20 Jul 2022 12:32:14 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 258F24CC54;
	Wed, 20 Jul 2022 08:32:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dTR-JfhDTB02; Wed, 20 Jul 2022 08:32:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E5E894D484;
	Wed, 20 Jul 2022 08:32:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A9EEB4D403
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Jul 2022 08:32:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Yg--TSMv0sPk for <kvmarm@lists.cs.columbia.edu>;
 Wed, 20 Jul 2022 08:32:10 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7A2EA4D3ED
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Jul 2022 08:32:10 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id A6FFB61789;
 Wed, 20 Jul 2022 12:32:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 746DCC3411E;
 Wed, 20 Jul 2022 12:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1658320329;
 bh=BuZmmB4yLTGdRIt2ncTmYybwoVvnL6pinwz3NzIQra4=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=qtqxpwZJc/jHRDfGkag3EA+OXfM1+I5Ph5uPB5uNILthUn6xURsiwznbdsqBFJ0He
 EPh4Q5jaAsN5r4TwSAgu/BUv1svS7aUyaFwTX8s4A9HuaSL8+KhwzxgXBq1yKs/q21
 WNjBt9ArGqZxSp6ybCvOOy7Tz1T/COD/A0nsj879Hz1kuidnfupPatQK/fKlISTTx8
 XqXsiUjb+MXpRNyz0LWY8FvaNd3ybhrYgkd0rj1Hbx5ju7v22sAphFZoHO9Jz0bZbq
 eidlU/TfI9uRqOCxiqi5BAwSP2aNXimR5YG8rQz1MdMSS6v6XeUOZjMHr5SD8Gvc7S
 f2WsM/8BI2k2w==
Date: Wed, 20 Jul 2022 13:32:02 +0100
From: Mark Brown <broonie@kernel.org>
To: Will Deacon <will@kernel.org>
Subject: Re: [PATCH v2 7/7] arm64/sve: Don't zero non-FPSIMD register state
 on syscall by default
Message-ID: <Ytf1wo1PLZyhxNg2@sirena.org.uk>
References: <20220620124158.482039-1-broonie@kernel.org>
 <20220620124158.482039-8-broonie@kernel.org>
 <YtbraaDE0eJhRHkx@arm.com> <YtcHkkwiDZTEpWrZ@sirena.org.uk>
 <20220720092022.GB15752@willie-the-truck>
MIME-Version: 1.0
In-Reply-To: <20220720092022.GB15752@willie-the-truck>
X-Cookie: I exist, therefore I am paid.
Cc: Marc Zyngier <maz@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 Zhang Lei <zhang.lei@jp.fujitsu.com>, Andre Przywara <andre.przywara@arm.com>,
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
Content-Type: multipart/mixed; boundary="===============4669394735169014188=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


--===============4669394735169014188==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="1HLM6S7c58QHSSqD"
Content-Disposition: inline


--1HLM6S7c58QHSSqD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 20, 2022 at 10:20:23AM +0100, Will Deacon wrote:
> On Tue, Jul 19, 2022 at 08:35:46PM +0100, Mark Brown wrote:
> > On Tue, Jul 19, 2022 at 06:35:37PM +0100, Catalin Marinas wrote:

> > > > The sysctl is disabled by default since it is anticipated that the risk
> > > > of disruption to userspace is low. As well as being within the
> > > > documented ABI this new behaviour mirrors the standard function call ABI
> > > > for SVE in the AAPCS which should mean that compiler generated code is
> > > > unlikely to rely on the current behaviour, the main risk is from hand
> > > > coded assembly which directly invokes syscalls. The new behaviour is
> > > > also what is currently implemented by qemu user mode emulation.

> > > IIRC both Will and Mark R commented in the past that they'd like the
> > > current de-facto ABI to become the official one. I'll let them comment.

> > That would be good.  I've not heard anything from Will either directly
> > or indirectly.  Mark R has indicated privately directly to me that he
> > originally pushed for the currently implemented behaviour and prefers
> > it.  Marc Zyngier has previously noted publicly the current behaviour
> > being a consideration in the context of discusion of optimisation ideas
> > like this one, I was a bit surprised that he commented on an earlier
> > patch in the series but not this one.  You have previously pushed back
> > on an attempt to document the current ABI, that was the main motivation
> > for writing this patch.

> I remember discussing this somewhere at some point with somebody, but that's
> not a tonne of use!

> My opinion is that the observable behaviour is what matters. So if we
> documented that the register state is "undefined" but it is in fact always
> zero, then we should fix the documentation.

It's always zero with Linux, never zeroed by qemu user.

> Does that help?

Yes, that's clear thanks though it does differ from what Catalin has
said about keeping the flexibility in the documentation - Catalin?

--1HLM6S7c58QHSSqD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmLX9cEACgkQJNaLcl1U
h9CuqggAgfcODdULzHaAIeGpEUqgg6vEuPj7Oqq5P3fKj3Rx1T7yh0q09XRur+OY
tGUn9Xsiv0UyspLSYSm4vHWOsTIBxyr8YWn1eQGT/xGsjV4bw4Bd//0TMjeCN5zI
0GWbHpYGKWbnHkdiFpA99PmQh8Uegu60eofmAZQjG8wn+qwHGTpvj5ITNGphkVrZ
iGnJHPj6JuJiO57NOZIfVvRrltQfeZRnX8cDRBuUTFg8TZ89Tti775WKoRauh5lV
lb+8wRpJ4TzXtduAU1zuPuqH86l3gZpVpucO6W/RjiG87m/q1N/d/4QbMjZWxSpd
og6y1FJ0U7A32m/H35LoAriu7rIIHg==
=rzTC
-----END PGP SIGNATURE-----

--1HLM6S7c58QHSSqD--

--===============4669394735169014188==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============4669394735169014188==--
