Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC23EC433EF
	for <kvmarm@archiver.kernel.org>; Mon, 22 Nov 2021 17:58:11 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B3C34B172;
	Mon, 22 Nov 2021 12:58:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2DQ7f5loT2h1; Mon, 22 Nov 2021 12:58:10 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 260AF4B0E6;
	Mon, 22 Nov 2021 12:58:10 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4CB424B0E1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Nov 2021 12:58:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CtdYV0YvSU6L for <kvmarm@lists.cs.columbia.edu>;
 Mon, 22 Nov 2021 12:58:07 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2013A4B0C5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Nov 2021 12:58:07 -0500 (EST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id B97BC60C4A;
 Mon, 22 Nov 2021 17:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1637603885;
 bh=xaPvWRRZLplWuTj6zfL8WONxOMLolZjyxQW/VUcabzM=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=TaGnGGcyBXQBLJ9W61wVeyz/MNc33lttcCzOEXoIzohiqYDXGAVQhE/bdAdCQXoBo
 Ji9T5Zp7wrEbdDIlf9DGI/ID7+/9eAuP+S/XvPWVFA06C0C1GR8bWQErfGKxKAKPs7
 BaIHVWzvDJo+7Lr4fSQAcdza1HzrY7X46t4hqxjL0W2a0jSq8m/ROoxl6lW7P2Y1To
 O8bUzzD65jVr0byC6hNreFKUVASfB3oUMhvcfA0i6vnpZECT08FV5sKjJBK0n+axbr
 lCSWQlBgmjz62gQHH5T6bmkD11Y4a0ZKB0GMMhq9rJs63xQaDPaOz4QvipZTMPSCIQ
 wHO6s9Sz4CcBg==
Date: Mon, 22 Nov 2021 17:58:00 +0000
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 2/5] KVM: arm64: Get rid of host SVE tracking/saving
Message-ID: <YZvaKOLPxwFE9vQz@sirena.org.uk>
References: <20211028111640.3663631-1-maz@kernel.org>
 <20211028111640.3663631-3-maz@kernel.org>
 <5ab3836f-2b39-2ff5-3286-8258addd01e4@huawei.com>
 <871r38dvyr.wl-maz@kernel.org>
MIME-Version: 1.0
In-Reply-To: <871r38dvyr.wl-maz@kernel.org>
X-Cookie: Lake Erie died for your sins.
Cc: kernel-team@android.com, kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
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
Content-Type: multipart/mixed; boundary="===============1312281066326142411=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


--===============1312281066326142411==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="4ejJzEuy+GX8OnS7"
Content-Disposition: inline


--4ejJzEuy+GX8OnS7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 22, 2021 at 03:57:32PM +0000, Marc Zyngier wrote:
> Zenghui Yu <yuzenghui@huawei.com> wrote:

> > Nit: This removes the only user of __sve_save_state() helper. Should we
> > still keep it in fpsimd.S?

> I was in two minds about that, as I'd like to eventually be able to
> use SVE for protected guests, where the hypervisor itself has to be in
> charge of the FP/SVE save-restore.

> But that's probably several months away, and I can always revert a
> deletion patch if I need to, so let's get rid of it now.

While we're on the subject of potential future work we might in future
want to not disable SVE on every syscall if (as seems likely) it turns
out that that's more performant for small vector lengths which would
mean some minor reshuffling here to do something like convert the saved
state to FPSIMD and drop TIF_SVE in _vcpu_load_fp().  As with using SVE
in protected guests that can just be done when needed though.

--4ejJzEuy+GX8OnS7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmGb2icACgkQJNaLcl1U
h9BczQf+IBminM9LlYcrYBFvkLv1xG/VjhSrXo0RiCzpz5QehpsZDC2Xycu4+seo
7y5r3IXniQ0R4FAA68e9D2FT/ubuwBJ72cZ/eBdW5QWMFoX0dZMk3v+/YiDVxch0
hr/ZUAVDB6qsgjVXoUeuYJxfBuxlDnDUbB4zMw+PjP9mMcgg9aTzO4kgQ8VHd9q0
OkCT/fyP1zl0yaKtcFXeg2fsJWvJgOp+SnwQ+z5ht1jnCkb2t+iXO48wpg0YETtd
Uw5m/QMMsg/7Sy2WBjCB/gY2ThljfBpLY9CgbESPFNbyamfxDF/NWJZs6Bs/qHOB
y0I6Gy6DMi9nbVMYHcuZgcq+XzWlOg==
=9M+3
-----END PGP SIGNATURE-----

--4ejJzEuy+GX8OnS7--

--===============1312281066326142411==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============1312281066326142411==--
