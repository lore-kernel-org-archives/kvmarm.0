Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AACE2C2BA4C
	for <kvmarm@archiver.kernel.org>; Wed, 26 Jan 2022 19:53:03 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 09CFB4B086;
	Wed, 26 Jan 2022 14:53:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Rhm84-v1scFO; Wed, 26 Jan 2022 14:53:02 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0C5354B0C5;
	Wed, 26 Jan 2022 14:53:02 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3415A4B08E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Jan 2022 14:53:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gZSTx60UicCZ for <kvmarm@lists.cs.columbia.edu>;
 Wed, 26 Jan 2022 14:53:00 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E10B24B086
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Jan 2022 14:52:59 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 331A5B81AC2;
 Wed, 26 Jan 2022 19:52:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAF9DC340E3;
 Wed, 26 Jan 2022 19:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1643226776;
 bh=lYnTOPW2Pkwco72TKCwFmkv1sef05aWRjM7kJ34pSNk=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=Lf/8QN+efHRUBfI9x5RtjPSYqDl/9+Vt/n2mflRhwUO2g89GtR9sqOYZUNtdYNxCK
 Mxk5v9efCffbhIjWYHHpgWYumiMyHVdaop1XSqTwg0Mw3nubmEf6oCr8mn51BryUhy
 rg9YqUPniua+/iqn5yaYxlnm0BbFA6WAZ5aMNUUA16sFRsFmTelG4tOfr3B6ZIEDuN
 R9s0/LtCeR4Uh0TFGhEx7IgPuXiZwxBpkECopl+QpWaomzGihDbbIGf6y4jdoCDWWd
 /58BRDmHaJDOgxiC34WfnJaiOQyQ8uP6fI5JuMG4e9OTEOs2FidzXFWhC1TQLDCcJh
 FCiyXMswOy3NQ==
Date: Wed, 26 Jan 2022 19:52:51 +0000
From: Mark Brown <broonie@kernel.org>
To: Shuah Khan <skhan@linuxfoundation.org>
Subject: Re: [PATCH v3] kselftest: kvm/arm64: Skip tests if we can't create a
 vgic-v3
Message-ID: <YfGmk1I8l+ROoE/k@sirena.org.uk>
References: <20220126145242.3473836-1-broonie@kernel.org>
 <4424dd30-f74b-006f-b540-dbaf02e45e28@linuxfoundation.org>
MIME-Version: 1.0
In-Reply-To: <4424dd30-f74b-006f-b540-dbaf02e45e28@linuxfoundation.org>
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
Content-Type: multipart/mixed; boundary="===============1291116105345185331=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


--===============1291116105345185331==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="URcG2D/2QfQA1Gjm"
Content-Disposition: inline


--URcG2D/2QfQA1Gjm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 26, 2022 at 12:22:41PM -0700, Shuah Khan wrote:
> On 1/26/22 7:52 AM, Mark Brown wrote:

> > +	ret = vgic_v3_setup(vm, nr_vcpus, 64, GICD_BASE_GPA, GICR_BASE_GPA);
> > +	if (ret < 0) {
> > +		print_skip("Failed to create vgic-v3");

> Printing the negative error code returned by vgic_v3_setup will be useful.

If the function fails for any reason other than the system not
supporting vgic-v3 it will abort rather than return.

--URcG2D/2QfQA1Gjm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmHxppIACgkQJNaLcl1U
h9Drpwf/VP/AtJtHPAgAVlI1NnA4IzzzhMgNH0jsweAqajJFm2bSjc/BLmWJ1PH6
MdO7y23ckqvapSbg9Gmlw/AhR495m4AmRf1h0mMNdGo6D8fljhbRT0ICiw24GpI9
H0Tz3wMrTPIIVpr3Iq/LvXYSeLZ0qHsVpZAKC6NoBN/Iok5fWOJBcCvwNMkBsgyl
GmseUwlAfaHmJxuVX18ZesoAw6poYVHbRjcVEMlsVgl49DOq6yXemS7us3bhr6qJ
265lzlaP2T1j5nM6lfTORUGlFlWMYLd3Uj3V40iU9zCWiJT5H5VY1Dd0w6vdewOd
7vKTsJkiQGSaPF5f3+qcgNNIP/1qeg==
=IcN4
-----END PGP SIGNATURE-----

--URcG2D/2QfQA1Gjm--

--===============1291116105345185331==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============1291116105345185331==--
