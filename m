Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3140C4332F
	for <kvmarm@archiver.kernel.org>; Fri, 21 Oct 2022 10:45:13 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B2AB4B6C5;
	Fri, 21 Oct 2022 06:45:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vApydkG6IVqQ; Fri, 21 Oct 2022 06:45:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1DC874B6E2;
	Fri, 21 Oct 2022 06:45:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 27B8D4B6C5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 21 Oct 2022 06:45:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id R2nVS7Ww8o3g for <kvmarm@lists.cs.columbia.edu>;
 Fri, 21 Oct 2022 06:45:10 -0400 (EDT)
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CBB0B4B4D7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 21 Oct 2022 06:45:09 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by sin.source.kernel.org (Postfix) with ESMTPS id C4032CE2A4F;
 Fri, 21 Oct 2022 10:45:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4577AC433D6;
 Fri, 21 Oct 2022 10:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1666349102;
 bh=J7/tgj0zGETukgrM7kBytQZ9k9B0vXsbKGc9ccx9mwE=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=V9jDZnDKZ4ly7SGBtpEnWUgSo4oWfTF5Tv5/EN3XbynhRsqs7T/+03XWHp8sWs19C
 fqPEyZlxOMIm/DIr91kDpoegLD5bWdFWE436SY/ZCTgVhfL7HCd5nwposBFyPMxiJN
 Wte9FNAJstcg5uEgiE0eW28UDAUT1sztXXp//DpJkRihq6g33sH2F+NOiHbDuzqADJ
 VgftPFM+qTuDk8loSTSeZoAaRH4XTtdCLQw6nvSxMTBGjxc+wrwMSCSRoWeuZRlytC
 s+GXOnyHtrqpiTVy5QKJpaFeZT8Ved/SAanLjeMtWF0cgFlzkBTyVncTW6IoATAPkY
 qYh/4h4oY+VeA==
Date: Fri, 21 Oct 2022 11:44:54 +0100
From: Mark Brown <broonie@kernel.org>
To: Rob Herring <robh@kernel.org>
Subject: Re: [PATCH v2 3/7] arm64/sysreg: Convert SPE registers to automatic
 generation
Message-ID: <Y1J4JhJZs9w1zn6q@sirena.org.uk>
References: <20220825-arm-spe-v8-7-v2-0-e37322d68ac0@kernel.org>
 <20220825-arm-spe-v8-7-v2-3-e37322d68ac0@kernel.org>
 <Y1FcRNhFpZxZ7AMx@sirena.org.uk>
 <CAL_JsqLVjWH-x3jxGQpJ3ax_ddvBqHd-P2DE=DEnrknoHuq+Qg@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAL_JsqLVjWH-x3jxGQpJ3ax_ddvBqHd-P2DE=DEnrknoHuq+Qg@mail.gmail.com>
X-Cookie: On the eighth day, God created FORTRAN.
Cc: Peter Zijlstra <peterz@infradead.org>, Marc Zyngier <maz@kernel.org>,
 linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
 linux-perf-users@vger.kernel.org,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.linux.dev,
 Namhyung Kim <namhyung@kernel.org>, Will Deacon <will@kernel.org>,
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
Content-Type: multipart/mixed; boundary="===============2250782632420515376=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


--===============2250782632420515376==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="h8OqzCyx1D8l8y4i"
Content-Disposition: inline


--h8OqzCyx1D8l8y4i
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 20, 2022 at 02:51:02PM -0500, Rob Herring wrote:
> On Thu, Oct 20, 2022 at 9:33 AM Mark Brown <broonie@kernel.org> wrote:

> > > +Field        11:8    EA

> > This looks like it should be described as an enum.

>     0b0000    Not_Described
>     0b0001    Ignored
>     0b0010    SError

> What's the preferred case here?

Either option is good for case I think, it's a taste question - going
with upper case is more the kernel coding style so fine there, though
sometimes it makes things hard to read.

--h8OqzCyx1D8l8y4i
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmNSeCYACgkQJNaLcl1U
h9Atiwf+OSs1WYEEU3S40lQi7fccTKxTPnixytK3Sph02dBD9R/EnwsFK6DnnBsA
hyaxC2aWvjmz1oplivZ7qQwM6CKRyfPoi3f62/L2Ne0A+PILHTWjsr8CRkYHaipd
iPss2Dszd5K65d9ZULDEuUR6tgCWodejetEY1bCu3g7dtB2ZoZPDlfXnvssxm3MP
pKjj58ynCwhGeHMJ6T7ASJOmvvkLbTvLTni4MJ7o56/ltB0+JuNyf28MQzRiG+Ts
A19juSTfZvW8g6aG9P2+byuIXeMJJyas2bz46021mDn6Ch/jkrIfeIsVVlf8UpCp
gHbpAw48zWWXQbb3phklP/cvtYisSQ==
=/DQ9
-----END PGP SIGNATURE-----

--h8OqzCyx1D8l8y4i--

--===============2250782632420515376==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============2250782632420515376==--
