Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C79EEC00140
	for <kvmarm@archiver.kernel.org>; Tue, 26 Jul 2022 14:49:20 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4FC1F4C790;
	Tue, 26 Jul 2022 10:49:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5Krn3kR5xH1D; Tue, 26 Jul 2022 10:49:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 460504C78F;
	Tue, 26 Jul 2022 10:49:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3F6854C78B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jul 2022 10:49:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id B5JKto3U23vk for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Jul 2022 10:49:17 -0400 (EDT)
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 070394C789
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jul 2022 10:49:16 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by sin.source.kernel.org (Postfix) with ESMTPS id 23D92CE1784;
 Tue, 26 Jul 2022 14:49:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58FE2C433D6;
 Tue, 26 Jul 2022 14:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1658846950;
 bh=6qe77S7H9yLJcTguoEah7bWjYEDj8Rr8Be/b5etbPYs=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=FsYX4Uq4Hm49BLpGwC2L0jCbnphx9BSNKb1oJefNVr103LWLNFo2dJEUpOspPNmR8
 mo0mnGe6xOSqBAP4hmQWMfHjtB+wulW4SvebGSs6OAo5T+OumbOsHNfeWQWI4BngWz
 LNJNU5gsiAH5WXPvmVH3jxR2SLAaZgk5HfglW3X9nhxCCpPtFMeRX4tWbM+G960/Bx
 RQnef+RP5z3YY27ojllPVSKfq/zV8p5KuZ9GS8yQGfEYfP9jtzpb+rfkgOM8QiBwAB
 en/N94oNvsM6VLT9UaARuZwAcxkPMuRoGfgR03fKl2ediKrsArE8/8fziGoG+kFKm5
 SCOwm9X/qVK2Q==
Date: Tue, 26 Jul 2022 15:49:02 +0100
From: Mark Brown <broonie@kernel.org>
To: Kalesh Singh <kaleshsingh@google.com>
Subject: Re: [PATCH v6 06/17] arm64: stacktrace: Add description of
 stacktrace/common.h
Message-ID: <Yt/+3qpSqtntXzpY@sirena.org.uk>
References: <20220726073750.3219117-1-kaleshsingh@google.com>
 <20220726073750.3219117-7-kaleshsingh@google.com>
MIME-Version: 1.0
In-Reply-To: <20220726073750.3219117-7-kaleshsingh@google.com>
X-Cookie: All rights reserved.
Cc: wangkefeng.wang@huawei.com, catalin.marinas@arm.com, ast@kernel.org,
 vincenzo.frascino@arm.com, will@kernel.org, android-mm@google.com,
 maz@kernel.org, kvmarm@lists.cs.columbia.edu, madvenka@linux.microsoft.com,
 kernel-team@android.com, elver@google.com,
 linux-arm-kernel@lists.infradead.org, andreyknvl@gmail.com,
 linux-kernel@vger.kernel.org, mhiramat@kernel.org
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
Content-Type: multipart/mixed; boundary="===============3375043288984427066=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


--===============3375043288984427066==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="VvhY7zJe39DOaRz/"
Content-Disposition: inline


--VvhY7zJe39DOaRz/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 26, 2022 at 12:37:39AM -0700, Kalesh Singh wrote:

> Add brief description on how to use stacktrace/common.h to implement
> a stack unwinder.

Reviewed-by: Mark Brown <broonie@kernel.org>

--VvhY7zJe39DOaRz/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmLf/t0ACgkQJNaLcl1U
h9Dq9Qf+M8Vw3uujBFIzWTDAk2o46YySw1X4f/3zirbpelSLiA92qxcFQx6PGkJX
DEX9sfHtytc3vnSGvG/Xnsp+AKHSq3l6ON9FYvU3wJRTRPRnkuz4UPHydRipyjsm
eFp3c8+crrbRjcShB8nckslrRtberLCJDMKeVXoN9m0x3dXaBqkaYgiM1NyhCPZa
3YNRCGE0zGsqVxPW3fRCW0SQY2mrpjBZC/sE4Xg805v8hgXqhNb656/EUhSOUC4P
YWixP6TJUIf/hqhckzlebKuYc64LpI07KIsv4hmG7S/T8SxqxGATDQ1Rg3y7ySZ7
Zs/RPpBZPRgr7ZgrOqBKLdMg1QDXLQ==
=AZ9B
-----END PGP SIGNATURE-----

--VvhY7zJe39DOaRz/--

--===============3375043288984427066==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============3375043288984427066==--
