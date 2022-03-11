Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5775EC433EF
	for <kvmarm@archiver.kernel.org>; Fri, 11 Mar 2022 18:43:11 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B0C9B410FF;
	Fri, 11 Mar 2022 13:43:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QW2wLyob9p7R; Fri, 11 Mar 2022 13:43:09 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8D91049EF8;
	Fri, 11 Mar 2022 13:43:09 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4CE40410FF
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Mar 2022 13:43:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PuwIbaMG3H4q for <kvmarm@lists.cs.columbia.edu>;
 Fri, 11 Mar 2022 13:43:08 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 12F7941071
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Mar 2022 13:43:08 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 394EEB82C8D;
 Fri, 11 Mar 2022 18:43:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C86FC340E9;
 Fri, 11 Mar 2022 18:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1647024184;
 bh=RrVVysxT2emlyWxm/g1Qt6qpkNRxKkUnB1UtTlEBZDk=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=V0hx8kaQOvPo5d+JsID8DCUcRVYA/9JKlWUTHoBde4H5v1q075qdsyCzzqxNWI9K6
 Uipf6JGi2OaK696PkyT15/gNPYEc2ka3zdPQXuxlsgPsgdZ6FTq2QpFTFbbyln/jqg
 gLjfMUDNwHSuDnoqIETI4CG0Eq+fngWjrel1N+vYwJACTw96c9D93J9EDfvDnMSHB+
 bwWKB+pFMbkFxLzztwVrBASUK+GUuuObfWH5orW1KuQfgOVtrkJrIxb0Sq1Fjl6WKd
 jVswPChCJQnoob9dOVcAvSAvcRMXwEZZ3qhXFwrkZ/T87uadesCom/b6a/0bMBzpTw
 gSFDCxmTM15bQ==
Date: Fri, 11 Mar 2022 18:42:57 +0000
From: Mark Brown <broonie@kernel.org>
To: Szabolcs Nagy <Szabolcs.Nagy@arm.com>
Subject: Re: [PATCH v12 06/40] arm64/sme: Provide ABI documentation for SME
Message-ID: <YiuYMcR8zk73eBLo@sirena.org.uk>
References: <20220225165923.1474372-1-broonie@kernel.org>
 <20220225165923.1474372-7-broonie@kernel.org>
 <20220311172051.GA257833@arm.com>
MIME-Version: 1.0
In-Reply-To: <20220311172051.GA257833@arm.com>
X-Cookie: A fool and his money are soon popular.
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
Content-Type: multipart/mixed; boundary="===============6330149786217907369=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


--===============6330149786217907369==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="P5FpQBAMTKNjQe4J"
Content-Disposition: inline


--P5FpQBAMTKNjQe4J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Mar 11, 2022 at 05:21:21PM +0000, Szabolcs Nagy wrote:
> The 02/25/2022 16:58, Mark Brown wrote:

> i would s/SVE vector/streaming mode SVE vector/

Done.

> > +* On creation fork() or clone() the newly created process will have PSTATE.SM
> > +  and PSTATE.ZA cleared.

> is there a reason why fork() clears ZA?

> i think this is a minor issue, but the usual expectation is that
> on thread creation thread local state is reset in the child, but
> in a forked child the state is the same as in the parent (where
> ZA is preserved according to the first rule).

It was partly consistency with SM and the SVE state (though that is also
covered by just being in a system call unlike ZA) and partly concerns
about what happens if the fork() happens in library code which isn't SME
aware - it would end up carrying around a copy of ZA with associated
power and performance impacts if it doesn't exec().  Overall it seemed
like there would to be less potential for unpleasant surprises if we
consistently discard the data.

That's not a *super* strongly held opinion though, we could switch to
preserving whenever we preserve TPIDR2.

--P5FpQBAMTKNjQe4J
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmIrmDEACgkQJNaLcl1U
h9CtVgf/emgab4posEBW5QNnCwbr98z+484BhiatXjbXYG6tH0E7iQUHCY53CcUB
6JHVU8laUrdAOY8Uya/zJp0U0ImMViJSoOuOlmXRQbJwarTl8N41LEYcGRA1fN1G
PH9dIgTiIH7450skNgveMIyowlOYNRTbx5VorbMMjpI2W1KVNXiIkv5ceZeuJCB5
Vt8tpy5w0fZIBf7E3MvvuX/dCRmLIt9HYjm89c8R2khh08EOTybNnCW1N6qVha/4
uryFjdSIVmtHtY8JdOuYtoPVjSBeQSNETHTVEJBEAw9TtEy5CegR637koRZcX9dk
dmCp0qt6sIrDte8ZT3efTMlXQTUQYQ==
=Yz0U
-----END PGP SIGNATURE-----

--P5FpQBAMTKNjQe4J--

--===============6330149786217907369==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============6330149786217907369==--
