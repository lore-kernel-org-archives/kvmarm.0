Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E225C4167B
	for <kvmarm@archiver.kernel.org>; Thu, 22 Dec 2022 12:34:49 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A43014BA2D;
	Thu, 22 Dec 2022 07:34:48 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id EePAibobIOZd; Thu, 22 Dec 2022 07:34:47 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6C2404BA30;
	Thu, 22 Dec 2022 07:34:47 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7C9064BA24
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Dec 2022 07:34:46 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id j+RFrOWvQdG5 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 22 Dec 2022 07:34:44 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2C1724B651
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Dec 2022 07:34:44 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id ACDBEB81D2C;
 Thu, 22 Dec 2022 12:34:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 218ECC433EF;
 Thu, 22 Dec 2022 12:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1671712481;
 bh=SoUlKjruLAgmysN53PLLgolAxy8ONwQLBGr4rmVIuJY=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=gbBGDP/BwjO6VuqInuMUl3mUlhPY5IL8s2Zxf0ZgF9Jq6pVjLycAas/L4tgBWDi4Y
 i0WhJVOWLhd90ZYwHWz1ihEMeovTmmtNHdSBA6W0OOQ1zKbvkdtTPqBKiXEK1UwoVh
 fyHcdtOv+jdU2dbQD72dirKW773rERILnG981t6045Evnhdo1WGDV9jasqIpElVf3a
 +FYs/LWza5xKTZUGyO6QWZi/nYSuhu9QDYFx5jGTqPvlCF/4nBArMlAiSIw4aoAwLs
 euMpOcRiJQqL1IUwbKrbzjiOtaiAQrSLZuUM9VkndsItm2kC/IhSDNM9oOYK9ovUdb
 JuoL5eUo9zUoQ==
Date: Thu, 22 Dec 2022 12:34:35 +0000
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 2/2] KVM: arm64: Remove use of ARM64_FEATURE_MASK()
Message-ID: <Y6RO29H8AmnswBN7@sirena.org.uk>
References: <20221221-kvm-sysreg-cleanup-v1-0-112ddb14fb4e@kernel.org>
 <20221221-kvm-sysreg-cleanup-v1-2-112ddb14fb4e@kernel.org>
 <86h6xnbp9m.wl-maz@kernel.org>
MIME-Version: 1.0
In-Reply-To: <86h6xnbp9m.wl-maz@kernel.org>
X-Cookie: Yes, but which self do you want to be?
Cc: Will Deacon <will@kernel.org>, linux-kernel@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.linux.dev,
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
Content-Type: multipart/mixed; boundary="===============1356009134181872998=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


--===============1356009134181872998==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="uTei0FHqHVjcuC9J"
Content-Disposition: inline


--uTei0FHqHVjcuC9J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 22, 2022 at 12:23:49PM +0000, Marc Zyngier wrote:
> Mark Brown <broonie@kernel.org> wrote:

> > the users to directly use the generated mask macros, writing
> >=20
> > 	#define ARM64_FEATURE_MASK(x)	(x##_MASK)
> >=20
> > obviously looks redundant and if we look at the users updating them tur=
ns

> If the two are strictly equivalent, then let's use the former as it
> results in a tiny diff.

They are.  I'm tempted to move the define to a KVM header to discourage
new use.

> Constantly repainting these files causes no end of conflicts when
> rebasing large series (pKVM, NV...), and makes backporting of fixes
> much harder than it should be. Specially considering that there is a
> single occcurence of an ID register with non-4bit fields.

> Just put a FIXME in the various files so that people do the repainting
> as they change this code.

OK.  It does result in the half transitioned files looking really messy
which for the main arm64 code I'd expect to generate complaints but like
you say the conversions have their disadvantages too so if you're OK
with it.

--uTei0FHqHVjcuC9J
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmOkTtoACgkQJNaLcl1U
h9CX2wf+Mr0zawe5JO17RyNpOixFQbndFDrQ6JzyoyjinZK+cBjbADY3prZW16hp
CCFP/ftgz2YyhtWB0KLmg4fEu8uFNSpigJTgp6QBQrcNMwxTmw7deXNhBjO4XmUi
wkI0k5icx1lAMKAL3GtzQ7iIJx/t7N1SfesN5O+cbc84JLERXCu+lceQMXDWaz7C
qcCFkE6623GbytuBg3w6OOUmqB8SlRYQ9n8AMk8NEZ2YC+Urc6XokKfsnkPx5byR
tAN5rOLxRp7XZ27Ej3GWRxOWt/Gyu2AhY+X+9Ikqv+91Qs9nFhtCO1eBpXCQW8J7
QmS1xDMeVtlehDH+1w1XUdDXVh5dGg==
=Jggo
-----END PGP SIGNATURE-----

--uTei0FHqHVjcuC9J--

--===============1356009134181872998==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============1356009134181872998==--
