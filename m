Return-Path: <SRS0=pYg6=PQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF58DC433EF
	for <kvmarm@archiver.kernel.org>; Thu, 28 Oct 2021 13:14:39 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6E2CE61139
	for <kvmarm@archiver.kernel.org>; Thu, 28 Oct 2021 13:14:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 6E2CE61139
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 084314B1DD;
	Thu, 28 Oct 2021 09:14:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5UJNhdMhLRvg; Thu, 28 Oct 2021 09:14:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CE8B74B1A4;
	Thu, 28 Oct 2021 09:14:37 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1DD834B164
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Oct 2021 09:14:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HLR0U9fKTUd8 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 28 Oct 2021 09:14:34 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CA8BE4B159
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Oct 2021 09:14:34 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED12661130;
 Thu, 28 Oct 2021 13:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1635426872;
 bh=C1zcco3bTHMOEHdKG2K0ubtIXS9WB8cgc60pAqatfuM=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=F0wjY9u/vzPiiOcYBGLPCdlL8W/wye2808zGSSQAVBVvHo/k6qFihwjODj6AWxUpD
 4TnjpzUad9tFa0QeVAscGyxf79lr7ZUDOhs8nhxG/Wq0OjKAnOBuSUuH+wFnP2HJGz
 lXCelmjWvayCluyGPRNQO5W4RR5klCwzcqgUXrm6/Z6JqwyrJHa4kORFN/B7iKiOIH
 aZAfoTQLXefS5RE/GyokVWq4IJNcXln+AsQ9c1U936K4kHiTiCMUexLy/qF5oFxNt1
 rjbthJ4kZ+lyzX2khiduaBRJLZz1TBUgRtkthU2PGlO2zKrHyz+tE56i/WjAwPFWg8
 ye00MdxCfpgig==
Date: Thu, 28 Oct 2021 14:14:27 +0100
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 5/5] arm64/fpsimd: Document the use of
 TIF_FOREIGN_FPSTATE by KVM
Message-ID: <YXqiM08YPeyYley5@sirena.org.uk>
References: <20211028111640.3663631-1-maz@kernel.org>
 <20211028111640.3663631-6-maz@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20211028111640.3663631-6-maz@kernel.org>
X-Cookie: try again
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
Content-Type: multipart/mixed; boundary="===============5377555904069889524=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


--===============5377555904069889524==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="58r1ffgyFCvuxbm+"
Content-Disposition: inline


--58r1ffgyFCvuxbm+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 28, 2021 at 12:16:40PM +0100, Marc Zyngier wrote:
> The bit of documentation that talks about TIF_FOREIGN_FPSTATE
> does not mention the ungodly tricks that KVM plays with this flag.
>=20
> Try and document this for the posterity.

Reviwed-by: Mark Brown <broonie@kernel.org>

--58r1ffgyFCvuxbm+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmF6ojMACgkQJNaLcl1U
h9ADwwf+LD87gkZpKtme+gaULezsWo6+93ZLEdBBNTy13T2KQTAbi5wtv2tjrTh0
eCnrIjgyz35mSb3pF+vNn8+iyUBuELXFfK5+ZapkpduIBwY2tNLKCXQrpg28gVWV
AuZR6K7b3fktMxMM+vU2zMIacVr50uDT0Ba5BCUpcg0YwvRKORG4W+0UqetRjizz
ZfceGiGUd46iepoa5clJXJhZ1eJrUb9FLnekPOEcEUqs7Q1G5bF3Zoifc1JeDtdv
e38oMmLfKtwi8DSLfto5jPgb2/xYGBT1FATkdmDtGJaLhIggmkiNyzaugvwbY/BZ
MUYuoAUf80pcTiFpov2Kn7FWnw2R4g==
=+aPl
-----END PGP SIGNATURE-----

--58r1ffgyFCvuxbm+--

--===============5377555904069889524==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============5377555904069889524==--
