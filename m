Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E11FC433EF
	for <kvmarm@archiver.kernel.org>; Tue, 25 Jan 2022 13:34:14 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F3C540C0A;
	Tue, 25 Jan 2022 08:34:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QCx9xtk1j-oN; Tue, 25 Jan 2022 08:34:12 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7611A49E44;
	Tue, 25 Jan 2022 08:34:12 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D7B2E40E3D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Jan 2022 08:34:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TlOR6Pz9y0sQ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 25 Jan 2022 08:34:10 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8767840D34
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Jan 2022 08:34:10 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 2271E614D0;
 Tue, 25 Jan 2022 13:34:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F8D9C340E0;
 Tue, 25 Jan 2022 13:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1643117648;
 bh=pJMyQhuuFBmj58qKusgKdVkV+CnMwFe0bFQsGC9tLjI=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=d7MlSLh5uI+RmIexbdKv7iK8kzfAQOIXtZANjrj123XSXrn/rqNVnW5zY5h7OVowK
 XKnY0UsvEhgJ3I5pJ+YbIrSlu3nIQgWoLt+UjuneRZM0CJpW1vjq4/d9nJSjNfaSVo
 S6MpTWg6ywQLDKBZMK+KVMmkRAUU36pQHoW0VGiAHXRnHwVmkQVZmZ6Px+26sqkE1C
 bDUmicdu0VoCHMp37X6QiZG/h7t53cdYdFkTfT1o0cQxeDrj0TDpN9T1czGpGHJtGZ
 weIeABHpELXG6gpOxfZsjE6ChRhwT8Q54vDxRfgHMkysIUlECLx9Rq/3SHvSr5w0Tq
 j6sfqoebxenWg==
Date: Tue, 25 Jan 2022 13:34:02 +0000
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v8 26/38] KVM: arm64: Handle SME host state when running
 guests
Message-ID: <Ye/8SoZn2TJeShrl@sirena.org.uk>
References: <20220125001114.193425-1-broonie@kernel.org>
 <20220125001114.193425-27-broonie@kernel.org>
 <87wnio6n7d.wl-maz@kernel.org> <Ye/ygvnlzPKYT2z6@sirena.org.uk>
 <87tuds6jbo.wl-maz@kernel.org>
MIME-Version: 1.0
In-Reply-To: <87tuds6jbo.wl-maz@kernel.org>
X-Cookie: The second best policy is dishonesty.
Cc: Basant Kumar Dwivedi <Basant.KumarDwivedi@arm.com>,
 Will Deacon <will@kernel.org>, Luis Machado <luis.machado@arm.com>,
 Szabolcs Nagy <szabolcs.nagy@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
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
Content-Type: multipart/mixed; boundary="===============4465142471860528906=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


--===============4465142471860528906==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="83e/iXmvSHvukbBv"
Content-Disposition: inline


--83e/iXmvSHvukbBv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 25, 2022 at 01:22:51PM +0000, Marc Zyngier wrote:
> Mark Brown <broonie@kernel.org> wrote:

> > > I find the use of CPACR_EL1_SMEN in some cases and its individual bits
> > > in some others pretty confusing. I understand that you have modelled
> > > it after the SVE code, but maybe this is a mistake we don't need to
> > > repeat. I'd be in favour of directly exposing the individual bits in
> > > all cases.

> > OK, it is just the KVM code that uses the plain ZEN.  I'll add a cleanup
> > patch for that at the start of the series for ZEN I guess otherwise it
> > looks worse, though that will inflate the size of the series a bit.

> I'm happy to merge such a patch early if that helps.

That'd be good.  There's also similar stuff going on with FPEN BTW
(which is I imagine where the SVE stuff came from).

--83e/iXmvSHvukbBv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmHv/EkACgkQJNaLcl1U
h9DQPQf9GCKTKy4vTTTLzIlWshJTSRt31q72CwCyj/DNyVIr6JptpqeVFdrCGzmd
q1jbV7gjgj4AUBvx1sdjnLYAZr9JkGEMqJRYZ9u/23bkeGHx4hlTJUDwTunyBPrV
018rqaAibQu02YHYieZvvcWchrSLo+OG/L9OKcOcuaBxcvthPCYDoaDPs76/cEG+
1bQvnst3cfuSPSD+GXcssAZPbXSvmGcXViVOZ5dyVB36N3XVXG89zPs/4PtGBoO5
RVUPOZq/sq4PzR+0e7lV4xKjVkMmkfqFzYquLueE3XBVHY9vhLbwNdu12Qf+31Ss
qRhpcxR98hOBToPYMpwJgD1sip7+QA==
=IIxh
-----END PGP SIGNATURE-----

--83e/iXmvSHvukbBv--

--===============4465142471860528906==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============4465142471860528906==--
