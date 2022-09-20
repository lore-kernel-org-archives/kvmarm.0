Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6D6BC54EE9
	for <kvmarm@archiver.kernel.org>; Tue, 20 Sep 2022 18:53:12 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1DB164B62A;
	Tue, 20 Sep 2022 14:53:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id f55RKpWjN2GU; Tue, 20 Sep 2022 14:53:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D75774B639;
	Tue, 20 Sep 2022 14:53:10 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 98CF04B62D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 14:53:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jWncBOQfTdf3 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Sep 2022 14:53:08 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 82A624B62A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 14:53:08 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 05F4162579;
 Tue, 20 Sep 2022 18:53:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C19D9C433C1;
 Tue, 20 Sep 2022 18:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1663699985;
 bh=F7NZPxhiHwhor+Aq2QonfgUxr7+36g9Lmfik1sR/04M=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=e0TZpXXFTuAkieVI6/kAeQBlH2rcR3pz9b8u6XSAtsnMCS9eneQkUWB6JQGKWocfk
 6DDz5/2+p1NlgRreAAusdCZOZq36wHB/BlD52kNdRhVniV8sdu+Jq8TaOfYyGD1jCd
 RFdrDlQBRiD7Brg1rxjqUkGW0E55GOd7b2+LsTvxVGCXQ79Zdc6yBu6b0N634OtAz+
 LR2nB+2a/lfOxXZ4tlhoF0PHB8NE/LzdG7Wexe+pMbbQcFVtgDMjUMk9bJ6rze/OQ/
 VyRkc2t+Uu9JJ4kYSFYIDztxJ9vVTxvSpriVBm/TtldSf5eR9nentheQAZJ3IQZSdP
 HoLXdq8LhFNZA==
Date: Tue, 20 Sep 2022 19:53:01 +0100
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v3 4/7] arm64/fpsimd: Stop using TIF_SVE to manage
 register saving in KVM
Message-ID: <YyoMDV6w24ssItUo@sirena.org.uk>
References: <20220815225529.930315-1-broonie@kernel.org>
 <20220815225529.930315-5-broonie@kernel.org>
 <87v8phkjmf.wl-maz@kernel.org>
MIME-Version: 1.0
In-Reply-To: <87v8phkjmf.wl-maz@kernel.org>
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
Content-Type: multipart/mixed; boundary="===============4610620106635694893=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


--===============4610620106635694893==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="cqyqGDMTFvUCF8iZ"
Content-Disposition: inline


--cqyqGDMTFvUCF8iZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 20, 2022 at 07:04:24PM +0100, Marc Zyngier wrote:
> Mark Brown <broonie@kernel.org> wrote:

> > -	switch (last->to_save) {
> > -	case FP_STATE_TASK:
> > -		break;
> > -	case FP_STATE_FPSIMD:
> > -		WARN_ON_ONCE(save_sve_regs);
> > -		break;
> > -	case FP_STATE_SVE:
> > -		WARN_ON_ONCE(!save_sve_regs);
> > -		break;
> > -	}

> Given how short-lived this code is, consider dropping it altogether.
> Actually, the previous patch would make a lot more sense if it was
> merged with this one.

My thinking here is to introduce the state tracking and the
behaviour change separately to make it easier to unpick things if
anything goes wrong, it means that the behaviour change is in
clearly isolated patches separate to the more wide spread changes
to behaviour.  The early patches make it more explicit what we
are currently doing, the later ones do new things.

--cqyqGDMTFvUCF8iZ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmMqDA0ACgkQJNaLcl1U
h9Dmqgf/cQ/kF+T9w2CYcH19DRBERCzn6IM0t4mu/PWcV5gkPisivxFyuHMt3zOm
0WVPIAiZNDnNl4hRHSrMETax8wbUqtCErbYaR9fcVke9r2zqdvnvxCfzVZvrM4ml
3m5QjM/WybheLPqvWXjCq0oz23vmCi6xPHit82/wt8fUn9ZAA4BBbnNxvLOA6Ths
GxJO9lLK4EfU75TX0g8mOtiPI2iPRhh96Zejv4A4zzcK57CeVnAjWi9mCpe6SrPd
HIiYhKVVzm/eIa+u7FyYzQR83ODPPnSLekXNp4KaLpmmwqXYljLYkv2OsLrg0bQd
lzveDsRj8Zct02/oDtlaXgBvnoYJPQ==
=fgQL
-----END PGP SIGNATURE-----

--cqyqGDMTFvUCF8iZ--

--===============4610620106635694893==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============4610620106635694893==--
