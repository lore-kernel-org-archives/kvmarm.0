Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD585C2BA4C
	for <kvmarm@archiver.kernel.org>; Wed, 26 Jan 2022 12:52:33 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 442D041014;
	Wed, 26 Jan 2022 07:52:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wChiPtZ-jsns; Wed, 26 Jan 2022 07:52:32 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 29C0D40E00;
	Wed, 26 Jan 2022 07:52:32 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 319F240BC2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Jan 2022 07:52:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hYxQp5U2b3Tl for <kvmarm@lists.cs.columbia.edu>;
 Wed, 26 Jan 2022 07:52:30 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 14CA54078F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Jan 2022 07:52:30 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id B105AB81CD5;
 Wed, 26 Jan 2022 12:52:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9FEAC340E3;
 Wed, 26 Jan 2022 12:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1643201547;
 bh=o2ZPJgY1sa/GtYmc6gEf6NfJ0zITH9GxAUVpWbAb3CE=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=OJekI4r5r99zAqN5bCDTLJie3E9Ni+9K8wZE0XNqAiniPEkixzy1mB3sXeODxLEMA
 w+0K79JwfzySFaw7TOtsGGeCEB4Sfl+ukHQb6iL1aajNNALQ2jV0zaZ3MDCFvIWArj
 knl6CxiiNMLX3uA6SyWqsW1NnJi/CyqvqacMg1Z1nJlzP/WKi8v5yAauLrPgizdvad
 43QO4kvZOYF6o6/iNuSiGaehVDMDT4NNrkMkrHdRYnWJdfV5ARgyjmTuU7dHM4xqNO
 4xIS3MSrvX4hI/q+e4oJy6ewCmh5eU71aLVVDiDvOx59jBEf4bz9znMbDRdDgbGj85
 VQKmS8ryPF4hA==
Date: Wed, 26 Jan 2022 12:52:22 +0000
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH] kselftest: kvm/arm64: Skip tests if we can't create a
 vgic-v3
Message-ID: <YfFEBlsUH+dMxmku@sirena.org.uk>
References: <20220125192851.3907611-1-broonie@kernel.org>
 <87h79q7tln.wl-maz@kernel.org>
MIME-Version: 1.0
In-Reply-To: <87h79q7tln.wl-maz@kernel.org>
X-Cookie: Use only in a well-ventilated area.
Cc: linux-kselftest@vger.kernel.org, Shuah Khan <shuah@kernel.org>,
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
Content-Type: multipart/mixed; boundary="===============3452108231035492894=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


--===============3452108231035492894==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="yqSnZDWT+mQxO4gU"
Content-Disposition: inline


--yqSnZDWT+mQxO4gU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 26, 2022 at 09:07:48AM +0000, Marc Zyngier wrote:
> Mark Brown <broonie@kernel.org> wrote:

> >  	/* Distributor setup */
> > -	gic_fd = kvm_create_device(vm, KVM_DEV_TYPE_ARM_VGIC_V3, false);
> > +	gic_fd = kvm_create_device(vm, KVM_DEV_TYPE_ARM_VGIC_V3, true);

> So you now only test whether it is possible to create a virtual GICv3,
> but don't actually create it. How does this work?

Oh, that's rather obscure in the API - so the file descriptor returned
if the test flag is specified can't actually be used?

--yqSnZDWT+mQxO4gU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmHxRAUACgkQJNaLcl1U
h9AvJQf9GPAYtZanstoIG/vcqbA26bVsQFGfS/00XrVuAL2Gbc7mGcVXqn87KWGx
hUpfjqbMlgfEAqSX8xudmJKLmHxxkFce8M49ZoeP0/nN1oxvCTftYEKOO+YH8xFO
diP9rAIH4DGjH8szv7dzRE8KCSW0Svj8xwvBZm9SZJs7nqcZ1AcBN0iA2HRWCgK8
V1irsnWI852LlcDfaYetrsr6WN169e/PXBNNuISNIqsDQDe9gYDFJNHIWzB3hV3n
t2C3m3maET8C2vJukqxEe8Dv0E7A0Uofa4H8C6Y+Yae6HWd3cpD9WrSr7PfrW1un
zS0RmqmmTTactke64zug0VjVbgRjvg==
=8u2k
-----END PGP SIGNATURE-----

--yqSnZDWT+mQxO4gU--

--===============3452108231035492894==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============3452108231035492894==--
