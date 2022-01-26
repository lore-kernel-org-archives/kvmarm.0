Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 800BDC28CF5
	for <kvmarm@archiver.kernel.org>; Wed, 26 Jan 2022 20:13:30 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F23154B0B9;
	Wed, 26 Jan 2022 15:13:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HYd3itKy2MGl; Wed, 26 Jan 2022 15:13:28 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E9C914B0DB;
	Wed, 26 Jan 2022 15:13:28 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5F84F4B0B9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Jan 2022 15:13:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jUJnbWw51vNy for <kvmarm@lists.cs.columbia.edu>;
 Wed, 26 Jan 2022 15:13:27 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5627D4A10E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Jan 2022 15:13:27 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 9CE22B81EA6;
 Wed, 26 Jan 2022 20:13:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D4CCC340E3;
 Wed, 26 Jan 2022 20:13:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1643228004;
 bh=hmQwvBpYksIzl7tcb2EWb3VBLUCZuCxu0fG9RHpcc/A=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=c5brgLcOgZMJcUiF847vR77ELwVGIwtvyWnad09uOpkGBhYsb0BJ+W3OLZxHifz9O
 jSczxpKBaMUyGvHAxdLo9EqY5sFIeK68bjApwhDDDQ6vOKzRD+CjKZ90O99Mx2CSp/
 Xyz3kZ2FBleEAFziaBLYEcmzoawON03dFy24I9QyEbR75X9sBr4Z4EzrExYbgzYkOf
 A8xjnQGDmQ1ZnDmSlo7GWJAnr/aJbjl7Re9ngOoKYGJe9U2AVWRLJvfiVt6SgS+Ptf
 zrTHv1oLmuyamYZ9TnUMFII0PXoIVAOgW2yNu6ML/1XktIAXuLuXyUQu6VXn4Gjimy
 /t58lS0pg2mBw==
Date: Wed, 26 Jan 2022 20:13:18 +0000
From: Mark Brown <broonie@kernel.org>
To: Shuah Khan <skhan@linuxfoundation.org>
Subject: Re: [PATCH v3] kselftest: kvm/arm64: Skip tests if we can't create a
 vgic-v3
Message-ID: <YfGrXr1/NGREULnB@sirena.org.uk>
References: <20220126145242.3473836-1-broonie@kernel.org>
 <4424dd30-f74b-006f-b540-dbaf02e45e28@linuxfoundation.org>
 <YfGmk1I8l+ROoE/k@sirena.org.uk>
 <48c44d74-6668-7823-ada6-0285a8b32a35@linuxfoundation.org>
MIME-Version: 1.0
In-Reply-To: <48c44d74-6668-7823-ada6-0285a8b32a35@linuxfoundation.org>
X-Cookie: Use only in a well-ventilated area.
Cc: Marc Zyngier <maz@kernel.org>, linux-kselftest@vger.kernel.org,
 Shuah Khan <shuah@kernel.org>, kvmarm@lists.cs.columbia.edu,
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
Content-Type: multipart/mixed; boundary="===============4402730077649576464=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


--===============4402730077649576464==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="HNasRwzf7887euQs"
Content-Disposition: inline


--HNasRwzf7887euQs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 26, 2022 at 01:03:44PM -0700, Shuah Khan wrote:
> On 1/26/22 12:52 PM, Mark Brown wrote:

> > If the function fails for any reason other than the system not
> > supporting vgic-v3 it will abort rather than return.

> Hmm. vgic_v3_setup() return gic_fd looks like and the interface says
> Return: GIC file-descriptor or negative error code upon failure

Yes, but in reality the only return other than a valid file descriptor
is just -1 rather than a useful error code.

> I don't follow the abort part.

All the TEST_ASSERTS() in the code (including those in the functions
called) are calls to test_assert() in assert.c which if the test
asserted isn't true will print some diagnostics and call exit(), the
general idiom is to give up immediately on error.

--HNasRwzf7887euQs
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmHxq14ACgkQJNaLcl1U
h9CC/Qf+PVOAm5Wc6qrMXiY0e8FQ6SOhccpSgyoFbwUUJet/ReDC1snRgYGn+vTx
O+LMTd3nvNcl2guAo+rUn/0bvyUFgINvvECors31R6gMO/y8m5rsQwP+2Hsf5FMY
bLpy1Jd3olD/cXw8gstIq8X8HMvfGO5q2Kt4Pk4L1Bi73K6E37vG/CydsE21n1jc
KI3JYbj2Zk41ylo8a/rfqcO7xQuhj3e+B2jT0Wll7+JyDCMZd69Cni/13mYBLy9e
mudYeJfwt1HZWxNqltl9KWZ221u+Mkek/aCHfklyFLVIDcI0D/p8dT/Xmw0amWaI
mnmMSKKsnsVFZ6VbdLE+kgHKKKPi9w==
=q/Nf
-----END PGP SIGNATURE-----

--HNasRwzf7887euQs--

--===============4402730077649576464==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============4402730077649576464==--
