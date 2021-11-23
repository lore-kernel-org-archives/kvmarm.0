Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 981C8C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 23 Nov 2021 12:33:30 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0FE1E4B1C8;
	Tue, 23 Nov 2021 07:33:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Nijmincv+fI2; Tue, 23 Nov 2021 07:33:28 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BF0AB4B1B6;
	Tue, 23 Nov 2021 07:33:28 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C7ABF4B1B3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Nov 2021 07:33:27 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lNeciYJ4ofDz for <kvmarm@lists.cs.columbia.edu>;
 Tue, 23 Nov 2021 07:33:26 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C06324B178
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Nov 2021 07:33:26 -0500 (EST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E78A6102A;
 Tue, 23 Nov 2021 12:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1637670805;
 bh=qeoJNcSgbBVk7r1DYK17Di/fl8glCyyr/Yvfx5GDx/c=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=TX5eiN6+XilYYUL2SB8jn4QVFlWbUuHBQjnohU3/wSIUZw98IL2SZkakd5+SusLcf
 HRhThGUf5UAlOhNFUJri/JFoZcG06SNeE+NrvgvyPzG0+1sMWgLilRoWt7qDke/ujd
 vA1ezHAHjXGtHgbbijftkUuyf1PufTW4F1DvduD1jWCKIEtEGSTfW1NsjCMESu9jBo
 aivRIRZnjVzR9s71dwl8+hRT+pFJuJ3/k8UpgVYZjta2uglXn6yuPLAyFs7wUuygqa
 Pcm2F9GlX2vMOJ80YCUuWRFlnfvtIhZ5hxL+M8es3q2542A/Ch1Q1xn4xAbsTO6wjN
 wPxhsFIFLFQgA==
Date: Tue, 23 Nov 2021 12:33:20 +0000
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 2/5] KVM: arm64: Get rid of host SVE tracking/saving
Message-ID: <YZzfkO+HawhyZSjt@sirena.org.uk>
References: <20211028111640.3663631-1-maz@kernel.org>
 <20211028111640.3663631-3-maz@kernel.org>
 <5ab3836f-2b39-2ff5-3286-8258addd01e4@huawei.com>
 <871r38dvyr.wl-maz@kernel.org> <YZvaKOLPxwFE9vQz@sirena.org.uk>
 <87v90kcb8u.wl-maz@kernel.org> <YZvhuD7cVU/4AaFC@sirena.org.uk>
 <87mtlvchbe.wl-maz@kernel.org>
MIME-Version: 1.0
In-Reply-To: <87mtlvchbe.wl-maz@kernel.org>
X-Cookie: A closed mouth gathers no foot.
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
Content-Type: multipart/mixed; boundary="===============1581569331785590650=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


--===============1581569331785590650==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="q//FCEjhiy9XzDIz"
Content-Disposition: inline


--q//FCEjhiy9XzDIz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 23, 2021 at 10:11:33AM +0000, Marc Zyngier wrote:
> Mark Brown <broonie@kernel.org> wrote:

> > We don't need to change the ABI, the ABI just says we zero the registers
> > that aren't shared with FPSIMD.  Instead of doing that on taking a SVE
> > access trap to reenable SVE after having disabled TIF_SVE we could do

> That's not the point I'm trying to make.

> Userspace expects to have lost SVE information over a syscall (even if
> the VL is 128, it expects to have lost P0..P15 and FFR). How do you
> plan to tell userspace that this behaviour has changed?

My point is that this doesn't need to change.  Userspace can't tell if
we zeroed the non-shared state on syscall or on some later access trap.

--q//FCEjhiy9XzDIz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmGc348ACgkQJNaLcl1U
h9A32Qf/Q7Q5jbrsFshgkZUBzFoqpvW0snt8h5uAD6T9O2p4YA5CaPXHdfHWiLIQ
iQqziZPS0Yz6EMaiwfIx6BKYzWacpwT/k3uKbyT3tUxaWo9y7XrDrAqyqlBr24Zi
XUAcppKtKYkugRLQ2aLWEjxA5x3lv2N5yK5xvRLeP+ogP1k5HPfJsU82fG81Kh17
zXksTe5o+AlSttOE25+UAcO7tUkY0OxorMjdaF+ih7OCiZlXn30dNheNniPRzxP8
+3M6ZchCoNcFNETThDNGvg+9Kt3TACRFYQsHRJk6fq4mIw9VLkVv3n93vhgzFK5n
pVgD3/8+7m+I7Bj5iObRveR1nxSLaQ==
=3P0L
-----END PGP SIGNATURE-----

--q//FCEjhiy9XzDIz--

--===============1581569331785590650==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============1581569331785590650==--
