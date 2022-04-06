Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A623C433EF
	for <kvmarm@archiver.kernel.org>; Wed,  6 Apr 2022 18:51:10 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A2B9741174;
	Wed,  6 Apr 2022 14:51:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id v8Ks4YAzCeKU; Wed,  6 Apr 2022 14:51:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 62D7F49E17;
	Wed,  6 Apr 2022 14:51:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 00CC341174
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Apr 2022 14:51:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MDiwEeZUVcun for <kvmarm@lists.cs.columbia.edu>;
 Wed,  6 Apr 2022 14:51:07 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 05BCD49E17
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Apr 2022 14:51:06 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 1D182618E5;
 Wed,  6 Apr 2022 18:51:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EDC7C385A3;
 Wed,  6 Apr 2022 18:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1649271065;
 bh=2fT+20Z739gNXrMUeQltBNML4IctEm0mvhoLD0BqRsY=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=XSiP2cDt1x0DqNO2Zkcw/tFGQnVFNVwo+wo36rzGp9fKkEZdMtEM25bZcYVWSy6gd
 MrZlVB+fddCQ/0nqJUZ5jIh/a2eBXR2NeDllcrJanw7oZYg4xl+w9A4729bk/nqjln
 CMKsgZCcibH2Fnln0QAkjSu8vKyH/Bq0byanmZ6j7TmaZEXlz1IcKel5ZMn55Gnk7K
 D5y5OwOHdswAQ6VccJLrwsJ4MzmqaEhUhB5jc1gxvXE48C247v8jqCF/gK2DeOeYZh
 60Wak0CcIlGHFbvU1LVUCYhG7OIuPy5ndy/aY1/GUsbaABdidnwynV+3ZuwZedd3ti
 FpIpN14uWXe9A==
Date: Wed, 6 Apr 2022 19:50:52 +0100
From: Mark Brown <broonie@kernel.org>
To: Szabolcs Nagy <Szabolcs.Nagy@arm.com>
Subject: Re: [PATCH v12 06/40] arm64/sme: Provide ABI documentation for SME
Message-ID: <Yk3hDLe8Cce8zkvI@sirena.org.uk>
References: <20220225165923.1474372-1-broonie@kernel.org>
 <20220225165923.1474372-7-broonie@kernel.org>
 <20220311172051.GA257833@arm.com> <YiuYMcR8zk73eBLo@sirena.org.uk>
 <YkXRUlaoyDKQqndc@arm.com>
MIME-Version: 1.0
In-Reply-To: <YkXRUlaoyDKQqndc@arm.com>
X-Cookie: Look ere ye leap.
Cc: Marc Zyngier <maz@kernel.org>,
 Basant KumarDwivedi <Basant.KumarDwivedi@arm.com>,
 Will Deacon <will@kernel.org>, Luis Machado <Luis.Machado@arm.com>,
 Catalin Marinas <Catalin.Marinas@arm.com>, Alan Hayward <Alan.Hayward@arm.com>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
 "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
 Shuah Khan <skhan@linuxfoundation.org>, Shuah Khan <shuah@kernel.org>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
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
Content-Type: multipart/mixed; boundary="===============1963391041374537850=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


--===============1963391041374537850==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="H1j3yX+RCi/MNkHL"
Content-Disposition: inline


--H1j3yX+RCi/MNkHL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 31, 2022 at 04:05:38PM +0000, Szabolcs Nagy wrote:

> i think it's slightly better to treat ZA like TPIDR2,
> so only clear if CLONE_SETTLS is set.

> otherwise in principle the child can return to the frame
> where ZA was used and expect it to work (it's hard to
> come up with a reason why would some code do that, but
> this is valid in a single-threaded fork child).

=46rom an implementation point of view it's a bit clearer if we just
always preserve PSTATE.ZA and ZA contents on clone() and clear them on
exec.  Do you see a problem with that?

--H1j3yX+RCi/MNkHL
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmJN4QsACgkQJNaLcl1U
h9D/0Af/X1DilGAOK3sriwKJp5fLyyuDLxIFTmLf9TjhEV4uEC9eB8UJsletqocL
+v7AV/5HwBHKEgvMsbfwpGseBv50gcsQDFsqoW7oxanOYYqzM8HRYoLnDWdficvJ
1wWCX6YKDmMAwk1l0RxACHCWEa2kUP2DBP+R9hM0AQxJJA7TLp3uynOSpiTTFj/G
XYiKrekc9LKiFYK75M9M0pmdN5yU0vRUVMoM5ktKxoyGwrM6ti6TGHOR4i9MWcMr
oYZhizp9w4mkngBuOSYyx/hXmrzonZ2czTAoDER0BMjkVyyCD8GiVE/o6zAJnZ5x
vbmt37o9xQoZ52+YJfzipOm70jAZow==
=KTCH
-----END PGP SIGNATURE-----

--H1j3yX+RCi/MNkHL--

--===============1963391041374537850==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============1963391041374537850==--
