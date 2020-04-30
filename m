Return-Path: <SRS0=Ot4E=6O=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97CB7C8300D
	for <kvmarm@archiver.kernel.org>; Thu, 30 Apr 2020 09:39:37 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2CF13214D8
	for <kvmarm@archiver.kernel.org>; Thu, 30 Apr 2020 09:39:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="nQOE4vPY"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2CF13214D8
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=canb.auug.org.au
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D05F74B555;
	Thu, 30 Apr 2020 05:39:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@canb.auug.org.au
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id h5-0L3IEc-iW; Thu, 30 Apr 2020 05:39:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AB7A94B52D;
	Thu, 30 Apr 2020 05:39:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B64524B508
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Apr 2020 05:39:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aXoXTdaHzaFx for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Apr 2020 05:39:31 -0400 (EDT)
Received: from ozlabs.org (ozlabs.org [203.11.71.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 81F834B505
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Apr 2020 05:39:31 -0400 (EDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest
 SHA256) (No client certificate requested)
 by mail.ozlabs.org (Postfix) with ESMTPSA id 49CVhL1mfPz9sPF;
 Thu, 30 Apr 2020 19:39:14 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
 s=201702; t=1588239567;
 bh=+q3qK7ThA6S0SUMv93CvqoJgpSGdg5tNFF2TPvf35hI=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=nQOE4vPYnSb9Gz4jmhcJfj+a1yh87FOuKiuzmd4oxYn5IhsI/Dnpwzmq52qQW0pQf
 M0tApzyZI9uxTdAiPF4s0Nkcmvsx1nkje8SKC9VWyRlEJIRIX73CXIJEF4ai+ol2DI
 zjGTMwOLdpx2CnZhmjov0yXsGp5XA5MkdfXI+vDu21NiH3qaAKsho+OsYLhyDQuPyb
 oOyc6EHycC/flK5ft9w6rIq/dmjl65Ag+k1HTd5JfXzHzqtobx0BmmMKwqCk3977qq
 93M3QGH4Y94A9KzFtlczuY8Tg4jfonKEvSz3r0vaMgH4N7dojOCJC3EIRX7AZLVqeW
 5SR7cffZTwIrQ==
Date: Thu, 30 Apr 2020 19:39:10 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Will Deacon <will@kernel.org>
Subject: Re: [PATCH] arm64: kvm: fix gcc-10 shift warning
Message-ID: <20200430193910.294842c4@canb.auug.org.au>
In-Reply-To: <20200430082927.GA18615@willie-the-truck>
References: <20200429185657.4085975-1-arnd@arndb.de>
 <20200430090251.715f6bf0@why>
 <20200430082927.GA18615@willie-the-truck>
MIME-Version: 1.0
Cc: Rich Felker <dalias@libc.org>, Geert Uytterhoeven <geert+renesas@glider.be>,
 Catalin Marinas <catalin.marinas@arm.com>, Paul Mackerras <paulus@samba.org>,
 kvmarm@lists.cs.columbia.edu, Jonas Bonn <jonas@southpole.se>,
 Brian Cain <bcain@codeaurora.org>, Marc Zyngier <maz@kernel.org>,
 Russell King <linux@armlinux.org.uk>, Ley Foon Tan <ley.foon.tan@intel.com>,
 Mike Rapoport <rppt@linux.ibm.com>,
 Benjamin Herrenschmidt <benh@kernel.crashing.org>,
 Fenghua Yu <fenghua.yu@intel.com>, Arnd Bergmann <arnd@arndb.de>,
 Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>,
 Stafford Horne <shorne@gmail.com>, Guan Xuetao <gxt@pku.edu.cn>,
 linux-arm-kernel@lists.infradead.org,
 Christophe Leroy <christophe.leroy@c-s.fr>, Tony Luck <tony.luck@intel.com>,
 Yoshinori Sato <ysato@users.sourceforge.jp>, linux-kernel@vger.kernel.org,
 Michael Ellerman <mpe@ellerman.id.au>, Paolo Bonzini <pbonzini@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>
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
Content-Type: multipart/mixed; boundary="===============5536399358252091315=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

--===============5536399358252091315==
Content-Type: multipart/signed; boundary="Sig_/xzv.XEbMG=15e_LStDYa1s9";
 protocol="application/pgp-signature"; micalg=pgp-sha256

--Sig_/xzv.XEbMG=15e_LStDYa1s9
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Will,

On Thu, 30 Apr 2020 09:29:28 +0100 Will Deacon <will@kernel.org> wrote:
>
> On Thu, Apr 30, 2020 at 09:02:51AM +0100, Marc Zyngier wrote:
> > On Wed, 29 Apr 2020 20:56:20 +0200
> > Arnd Bergmann <arnd@arndb.de> wrote:
> >  =20
> > > Fixes: 22998131ab33 ("arm64: add support for folded p4d page tables")
>=20
> Happy to queue via arm64 for 5.8. Does that work for you, Arnd, or were y=
ou
> planning to get this in sooner than that?

The commit that this fixes is in Andrew's patch series in linux-next,
so it should just go in there.

--=20
Cheers,
Stephen Rothwell

--Sig_/xzv.XEbMG=15e_LStDYa1s9
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl6qnL4ACgkQAVBC80lX
0GzToAf/bXREqbiltcjG5hxNdpU1I4moIKv6bFtCjrnCW5muA2pCR3xx5Twzm5UG
Mw36RWbLqcQwOOcH9RtlCFe0zq1DEgPvShaF1lTh8n5dybdjKbCzSFsP6uoSZ/1i
rcT/rZ1GC/9zCOvI8MUYb748fIMdC5zeZOGpTPzYL8HPV4+65nY3+OMT8+0IS2JS
kJACY35PygG1QnWjF7JmwfBnAGe3M3jJ2OJe1IiF8lR6max8qziACp5cGHxAMq3B
d+XyW62Jfft6iGyz4+RAslfELwJXtLqgnJPy3NoJDy3eSghTCCh43mjuRctsVctk
7aYaVXRjxdDyfLBn013vvyPbIibusQ==
=6Ce6
-----END PGP SIGNATURE-----

--Sig_/xzv.XEbMG=15e_LStDYa1s9--

--===============5536399358252091315==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============5536399358252091315==--
