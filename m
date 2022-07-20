Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA1D0C43334
	for <kvmarm@archiver.kernel.org>; Wed, 20 Jul 2022 13:51:49 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 23AAA4D0D8;
	Wed, 20 Jul 2022 09:51:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QJcwbatT0uJ0; Wed, 20 Jul 2022 09:51:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D11934D26D;
	Wed, 20 Jul 2022 09:51:47 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C6E084D0D8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Jul 2022 09:51:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Pjqgo1d4E+p8 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 20 Jul 2022 09:51:45 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7DF904CEDD
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Jul 2022 09:51:45 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 96F48617BF;
 Wed, 20 Jul 2022 13:51:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1576C3411E;
 Wed, 20 Jul 2022 13:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1658325102;
 bh=WLNAEsodR7iIYDpdG8QWDR/PrwilJK3XeSpXkZTDY2w=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=ac/DoCuZDd9e1rdKDAoKxup1cp2zTq6UeyPH4bCVgAoHj4a/LYWmus1sjCA7fg6TE
 By/JC0zpdlqLNhtD1sfcZ8kuzgrjgpcz34PHt1IY4Uk4sClwjPzvLRTZC0jTylvWRi
 +zIn67yYowzDYJMAay5MH5z7okF9FJtwlnLfKynnzykrJ3zRcAmdweS4F9Km/69gJI
 vU7hnp7xx90YfeD8T38yMa6N3GLCF8Wwll4CRZ1KJxaNeNba3k7lnY5bZdVCRlnZzp
 Tn1IBcy/xHUYnFozv6SyKgc1LDt5/CZz7ZKtvEmMRj7MrsCCcnwhG3cYA1Na/NdsAP
 ismHnzROZzzRQ==
Date: Wed, 20 Jul 2022 14:51:36 +0100
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 2/7] arm64/fpsimd: Track the saved FPSIMD state type
 separately to TIF_SVE
Message-ID: <YtgIaElkAUBopyj5@sirena.org.uk>
References: <20220620124158.482039-1-broonie@kernel.org>
 <20220620124158.482039-3-broonie@kernel.org>
 <87ilo4kmvx.wl-maz@kernel.org> <YswMB2v9TqPJHDM1@sirena.org.uk>
 <87h73nlnw0.wl-maz@kernel.org> <YsxHhx3PaPRZCLmF@sirena.org.uk>
 <877d48yvf0.wl-maz@kernel.org>
MIME-Version: 1.0
In-Reply-To: <877d48yvf0.wl-maz@kernel.org>
X-Cookie: I exist, therefore I am paid.
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
Content-Type: multipart/mixed; boundary="===============1792218300727437766=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


--===============1792218300727437766==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="mL4PpyHqG5JSlilg"
Content-Disposition: inline


--mL4PpyHqG5JSlilg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 20, 2022 at 10:40:03AM +0100, Marc Zyngier wrote:
> Mark Brown <broonie@kernel.org> wrote:

> > Yes, someone might forget to update the state type but my experience
> > with this code is that it's a lot easier to spot "this is writing new
> > state, did it update the state type?" than "this is writing new state,
> > did it call the helper that implicitly updates the state type or the
> > other one?".

> My experience in maintaining the KVM code is that the least state
> leaks outside of this sort of helpers, the least problematic they
> are. I'd rather have multiple helpers that have different *documented*
> behaviours than expecting the random hacker to know (or in this case,
> *guess*) when or not to add some extra state-twiddling. It also makes
> the code far more readable because it is self-contained.

> If this series is supposed to help making things more maintainable,
> then this is one way to do it.

There's nothing self contained going on, and based on what the users are
doing it isn't at all obvious to me that taking a copy of the data in
another format should be part of the same operation as deciding which
format should be the live data.  I'm all for helpers but between that
and the direct awareness the users already need to have of what's going
on I'm just not seeing that a combined convert and make active operation
is jumping out as something that should be a helper.

--mL4PpyHqG5JSlilg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmLYCGcACgkQJNaLcl1U
h9A9lAf+KsshpVtFMfCIPQ7YfV9FJ/8TNdhqstSBm+LsLSxem/9fwjNsHmIezqN7
QHwffeXB5DF8x2uajj6p4c2x/Zi0zpCdj8mXELDHXKiNb5LlK2Ow5TEOYPEAnnoE
ctw41Zm5Uzyq4ZDlAkS/4Zs17zqYJLAlUdbnGEAjWyuUeUxBzcHHNYs1WAQ0MS4w
gOmSao6CsvXCUvPQbbPe6FMeygkHFYeHv/JjFsJneOR8KeC2ajEJ7RMZVup/DfC1
BeqC282+NRvXbp11B/rVjeDLw2xDWXWXcqgOCR8WcuWvgUNMr0VC36DF2Aunzma0
AWPC9NvbDN+vKLiu+m+79BsOFiWxVQ==
=XQmM
-----END PGP SIGNATURE-----

--mL4PpyHqG5JSlilg--

--===============1792218300727437766==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============1792218300727437766==--
