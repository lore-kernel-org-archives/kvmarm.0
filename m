Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BDA5C54EE9
	for <kvmarm@archiver.kernel.org>; Tue, 20 Sep 2022 20:21:42 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7E5774B73D;
	Tue, 20 Sep 2022 16:21:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 81w40hFUzTVv; Tue, 20 Sep 2022 16:21:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7812E4B6B2;
	Tue, 20 Sep 2022 16:21:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 801334B634
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 16:21:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KpJfleEROUx2 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Sep 2022 16:21:39 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1D3BE4B24C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 16:21:39 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 2664B62163;
 Tue, 20 Sep 2022 20:21:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6CB2C433C1;
 Tue, 20 Sep 2022 20:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1663705297;
 bh=l1GLTJA/m1XVU3ZjU0vCVTqDe9aGlD0ORTBZbGJFTqk=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=B7Pc/7AJAACBcTX/ZhN+U6+D7NdIdYaRuZtAd1n38z1woZ/kmfQNYSsB10x8ly+uF
 /sqNI/kJ+x2ivzyZGB/xtl+nmm5eCxciT5aKXZOduVI8c5tYp80x8GjbRnnkcvF8+C
 dXB2aCTgyMQdLcXtm6hgnC9pDpUOO/+qsxpRvjzjyR7dED0Ujpnu/Ob/UX/DWHaAZZ
 p5e6+eUZdbOYSakpR4aRGzLr4rymQ6rKN/oW2zv/Q1vGC6LS9Leh/Z74HNsSZiH1t4
 mbC9rZ9i6u+9GxJVhyMi6+nyOWXkItpcCk1otpkd6qh5lavQ1mjeDE7OEBEtgS5RfL
 v9Pcf7kG90IRQ==
Date: Tue, 20 Sep 2022 21:21:33 +0100
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v3 1/7] KVM: arm64: Discard any SVE state when entering
 KVM guests
Message-ID: <YyogzYzVbb3mvZWM@sirena.org.uk>
References: <20220815225529.930315-1-broonie@kernel.org>
 <20220815225529.930315-2-broonie@kernel.org>
 <87zgeuj8ry.wl-maz@kernel.org>
MIME-Version: 1.0
In-Reply-To: <87zgeuj8ry.wl-maz@kernel.org>
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
Content-Type: multipart/mixed; boundary="===============1090233814087965391=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


--===============1090233814087965391==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="L1LA5iGPjhkxC+4F"
Content-Disposition: inline


--L1LA5iGPjhkxC+4F
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 20, 2022 at 05:44:01PM +0100, Marc Zyngier wrote:
> Mark Brown <broonie@kernel.org> wrote:

> >  void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu)
> >  {
> >  	BUG_ON(!current->mm);
> > -	BUG_ON(test_thread_flag(TIF_SVE));
> > +
> > +	fpsimd_kvm_prepare();
>=20
> Why is this *before* the check against system_supports_fpsimd()? I
> don't think the architecture allows SVE without FP, for obvious
> reasons...

Good point, though now that I think about it I can't think of a
requirement for FP when implementing SME (there's certainly not
one for SVE).  There's no use for that hook now though.

--L1LA5iGPjhkxC+4F
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmMqIMwACgkQJNaLcl1U
h9B3NAf/T8qpVcPV98O2cYJ+RYHrFGjL6ALzKAuvy82ZYqwwBrZEqlznTVx2opUU
xegwtZjPU8W/oN74tefc3yvd31E0ILH6AmWr6Blchzoy0wG75KEZvTJcVJsYycK3
qC2DA2OnMIn9ZtjwDhk5OB21PoQL+V+4U6osCdCSqEsUWv9hq3nxMyUrepsTKRrn
U3Lj7LyASjM/rYFY8guvzsk/NlYvIUAbZmyYGxWPd7kcsT+mAD3URPn1+IyTYQWv
wf0f1g5aVXKQmHH0ALboh05bG4YOeyFT9qBfq1Q1P3EQ2I7ckJQUEmwQPTd6B5FK
xYktRByXTG7pgjeAxhQ9CaJ3nm0J8w==
=IUNe
-----END PGP SIGNATURE-----

--L1LA5iGPjhkxC+4F--

--===============1090233814087965391==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============1090233814087965391==--
