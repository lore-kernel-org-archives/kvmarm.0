Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7318AC352A1
	for <kvmarm@archiver.kernel.org>; Tue,  6 Dec 2022 18:20:38 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D3DA84B27F;
	Tue,  6 Dec 2022 13:20:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rMzzAlGZA+Pn; Tue,  6 Dec 2022 13:20:36 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 90AB44B278;
	Tue,  6 Dec 2022 13:20:36 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 739C941016
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Dec 2022 13:20:35 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jzpXap7mo2nw for <kvmarm@lists.cs.columbia.edu>;
 Tue,  6 Dec 2022 13:20:34 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 52D1A40CDE
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Dec 2022 13:20:34 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 15E6561852;
 Tue,  6 Dec 2022 18:20:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B958BC433C1;
 Tue,  6 Dec 2022 18:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1670350832;
 bh=T9UHAdLSg/MknZgZmsb/1izlnh+4dsvzvBWofrFnvPE=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=luoPid1iZfu97Vys9ehffT9v4D2YjnhX+hRe3Ze191e72jhYr66Qn06GryAP2duoZ
 1RE42tKko+FstPRliilBSUoanqmmlntF0Pwo/idQGwcxuI/UuVL9j03fZmPKxdhkk+
 ynMXSyLih0xdWhwPts8R+zucxOoOpuza+6JtctEtRruJOu8kpnSCddjejE++z12uVw
 oZ7vQ6u40msrAkSwhs6iSArVxG9wWO8kyPUU+6QRdWGRwUoS3ZMNnIywOsy55uXO/U
 3XIlwh1bM24m6SWYrLm72pJ+zUKLyiEF+XNwOwxBcjC+vo8okKnW3XIgAkS1JOL7Rg
 GpG/RdgMc7ZGA==
Date: Tue, 6 Dec 2022 18:20:21 +0000
From: Mark Brown <broonie@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Subject: Re: [GIT PULL] KVM/arm64 updates for 6.2
Message-ID: <Y4+H5Vwy/aLvjqbw@sirena.org.uk>
References: <20221205155845.233018-1-maz@kernel.org>
 <3230b8bd-b763-9ad1-769b-68e6555e4100@redhat.com>
 <Y4+FmDM7E5WYP3zV@google.com>
MIME-Version: 1.0
In-Reply-To: <Y4+FmDM7E5WYP3zV@google.com>
X-Cookie: Save gas, don't use the shell.
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Andrew Jones <andrew.jones@linux.dev>, Usama Arif <usama.arif@bytedance.com>,
 Bagas Sanjaya <bagasdotme@gmail.com>, Ben Gardon <bgardon@google.com>,
 "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 Marek Szyprowski <m.szyprowski@samsung.com>, Marc Zyngier <maz@kernel.org>,
 Steven Price <steven.price@arm.com>, linux-arm-kernel@lists.infradead.org,
 Jakub Kicinski <kuba@kernel.org>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>, kvmarm@lists.linux.dev,
 Peter Collingbourne <pcc@google.com>,
 Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
 Cornelia Huck <cohuck@redhat.com>, Zhiyuan Dai <daizhiyuan@phytium.com.cn>,
 Paolo Bonzini <pbonzini@redhat.com>, Andrew Morton <akpm@linux-foundation.org>
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
Content-Type: multipart/mixed; boundary="===============6928520888084943507=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


--===============6928520888084943507==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="syV9s6Ni/PXJMYNU"
Content-Disposition: inline


--syV9s6Ni/PXJMYNU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 06, 2022 at 06:10:32PM +0000, Sean Christopherson wrote:

> Alternatively, we could have a dedicated selftests/kvm tree (or branch)?

> I almost suggested doing that on multiple occasions this cycle, but ultimately
> decided not to because it would effectively mean splitting series that touch KVM
> and selftests into different trees, which would create a different kind of
> dependency hell.  Or maybe a hybrid approach where series that only (or mostly?)
> touch selftests go into a dedicated tree?

Some other subsystems do have a separate branch for kselftests.  One
fairly common occurrence is that the selftests branch ends up failing to
build independently because someone adds new ABI together with a
selftest but the patches adding the ABI don't end up on the same branch
as the tests which try to use them.  That is of course resolvable but
it's a common friction point.

--syV9s6Ni/PXJMYNU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmOPh+UACgkQJNaLcl1U
h9CC7Af+MMWaPoSDO/Esk9zkroLyT2xIe855zDLbqscWMEyns5kByu5KOIbQMuI9
SUhH+Y3GvUDFrbipnIGOlU8gxrsFFta9BlEMNiisNoSMlJv2SmKDb9HZfZBYpiOt
GlmJZ0i3yxKFOsLjWnxgo62AJheT4sE8wADRIPAkPxAWRyz3KGFBesc5EooCxLNt
T/jqOtoRqoakiaejBd3eMQxKlMNdOcpqSoiOjjpWgzWOEUULA7wHa1oDRwO5W6Zr
upb+KoHtzlYfa1UHiW3+8kg9vAk8MyBnvG0Bx6Xu6/0im6Is5WpQUc9ofnR26eLZ
6aL4C8fUDYOKXdy6pfD6XAboCNuEtA==
=GF2/
-----END PGP SIGNATURE-----

--syV9s6Ni/PXJMYNU--

--===============6928520888084943507==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============6928520888084943507==--
