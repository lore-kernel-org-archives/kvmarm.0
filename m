Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F8B3C433EF
	for <kvmarm@archiver.kernel.org>; Tue, 25 Jan 2022 12:52:30 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 66C7C40E64;
	Tue, 25 Jan 2022 07:52:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id whuY+xfNrUZ2; Tue, 25 Jan 2022 07:52:29 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3F84D40FD6;
	Tue, 25 Jan 2022 07:52:29 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C7FA440FD3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Jan 2022 07:52:27 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lXED9G7VcaIF for <kvmarm@lists.cs.columbia.edu>;
 Tue, 25 Jan 2022 07:52:26 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A1D9840C02
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Jan 2022 07:52:26 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 8010761354;
 Tue, 25 Jan 2022 12:52:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5C87C340E8;
 Tue, 25 Jan 2022 12:52:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1643115144;
 bh=v0FpQ2FqcGsRyWxNTDzGDDdUHBpQFuTqv/W9HGKRr/E=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=MAUsOJDG7jv8KWz7/qbyX9tPKq29KB8ajYN+T6vd0AzxvyMlhZObgNQLmo0fBORbt
 8/W9UcLtNg3lJ5/vuFjE5K+JS24ytUuHBkmKikam6SJQDQ7PjjPOTu2Epui6eRZKId
 yds1FqJ6rx6iKE3nIzphE6iGlP/D2lsWwPfmjaJKQYLPLxqUNWPUUdeoifMzR11+Lx
 +OxEku+cBS78xkynrWuLjcGq9xYkH/eglXwS26dS0aclHRNE3/IWCe56YHfl6+x4UE
 ZpELsAeltyMVf7P1IhhZbJeAJgK3TmyPjGjy3SyhUdSPIoMo754sqtccNQoHlVkobT
 Zm15izsNhSsSA==
Date: Tue, 25 Jan 2022 12:52:18 +0000
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v8 26/38] KVM: arm64: Handle SME host state when running
 guests
Message-ID: <Ye/ygvnlzPKYT2z6@sirena.org.uk>
References: <20220125001114.193425-1-broonie@kernel.org>
 <20220125001114.193425-27-broonie@kernel.org>
 <87wnio6n7d.wl-maz@kernel.org>
MIME-Version: 1.0
In-Reply-To: <87wnio6n7d.wl-maz@kernel.org>
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
Content-Type: multipart/mixed; boundary="===============7512132537346091300=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


--===============7512132537346091300==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="g/kTMzpZSB0D4ujj"
Content-Disposition: inline


--g/kTMzpZSB0D4ujj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 25, 2022 at 11:59:02AM +0000, Marc Zyngier wrote:
> Mark Brown <broonie@kernel.org> wrote:

> > +	if (has_vhe()) {
> > +		if (system_supports_sme()) {

> nit:	if (has_vhe() && system_supports_sme()) {

> saves you one level of indentation.

Yes, for now.  IIRC there was some other stuff there when I had some of
the code for doing the register switching properly.

> > +			/* Also restore EL0 state seen on entry */
> > +			if (vcpu->arch.flags & KVM_ARM64_HOST_SME_ENABLED)
> > +				sysreg_clear_set(CPACR_EL1, 0,
> > +						 CPACR_EL1_SMEN_EL0EN |
> > +						 CPACR_EL1_SMEN_EL1EN);
> > +			else
> > +				sysreg_clear_set(CPACR_EL1,
> > +						 CPACR_EL1_SMEN_EL0EN,
> > +						 CPACR_EL1_SMEN_EL1EN);

> I find the use of CPACR_EL1_SMEN in some cases and its individual bits
> in some others pretty confusing. I understand that you have modelled
> it after the SVE code, but maybe this is a mistake we don't need to
> repeat. I'd be in favour of directly exposing the individual bits in
> all cases.

OK, it is just the KVM code that uses the plain ZEN.  I'll add a cleanup
patch for that at the start of the series for ZEN I guess otherwise it
looks worse, though that will inflate the size of the series a bit.

--g/kTMzpZSB0D4ujj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmHv8oEACgkQJNaLcl1U
h9AbDgf7BGgVAuzrvNsIsDdC5IPALhwPBZ4yHOUqqUx68sa/YCRWjKn/HIIzHQb7
ZpmK+BCPHMwsaq9L1U0pKc2R9fv1Tysq718RzbjkakHjDTjX/myMdOURVGo+PvJc
cRwvN7J67L7uphIGBs9Zw7eFe7hZ/UhaXqUA2DcR8wEGxM3INgLzi8mlGpUPBCMN
4d+glYNXhy4CA+GOqBbAhi99Ap29zBBi7a2+97eUviYrUWuSIylEKJYnt7mEvqRd
PncYFUlT+3VTIKGZxj+xqK+c70dJ7vvLm6kLWx/KMOexeJ9uJcCXkyeo4UVfBneh
ShqSHbhaHl1BeVT5rFN8GMCOKu0ckA==
=EO4F
-----END PGP SIGNATURE-----

--g/kTMzpZSB0D4ujj--

--===============7512132537346091300==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============7512132537346091300==--
