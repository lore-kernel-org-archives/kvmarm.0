Return-Path: <SRS0=UwAz=HY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69B6AC433E6
	for <kvmarm@archiver.kernel.org>; Mon, 22 Feb 2021 11:58:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9D4AE64E2E
	for <kvmarm@archiver.kernel.org>; Mon, 22 Feb 2021 11:58:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9D4AE64E2E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=posteo.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 354BE4B17E;
	Mon, 22 Feb 2021 06:58:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@posteo.net
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hnFirJ7Vy-ls; Mon, 22 Feb 2021 06:58:39 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 320844B18B;
	Mon, 22 Feb 2021 06:58:34 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CCF5F4B12B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Feb 2021 04:35:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8HVPc8tBjF53 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 22 Feb 2021 04:35:32 -0500 (EST)
Received: from mout01.posteo.de (mout01.posteo.de [185.67.36.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8532D4B115
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Feb 2021 04:35:32 -0500 (EST)
Received: from submission (posteo.de [89.146.220.130]) 
 by mout01.posteo.de (Postfix) with ESMTPS id D0E0A16005C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Feb 2021 10:35:30 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.net; s=2017;
 t=1613986530; bh=VPHrBPyLWdSROwekyI2lxigDlO6mhV3Y1pk0vkdayCs=;
 h=Date:From:To:Cc:Subject:From;
 b=qrD0gdkeKCP5FiQbuP5EF4YpxR2sONuHqXB2z2ddKvno1JgWf1VK6LRZ3OHIMPh3a
 rx7Wuq1Me/AOI1GLIgywjXsjM/rK01Rs/qp772S4+xPc/fgv80mg+j8oJKdhXygqxP
 likGuez7xHrrPGWshef54ywO7PfVFNkCJ2oy+r8QT514Nzgr7CCTwfkERbbxZrbhCS
 WY348x0gnOMuwooJ27rrxghsv4n+gDVAF4YyeqhxdrOE+8qVfZnmKunbiGEo0w2UMd
 WT39ntn0RwwUQ6U0Fp+1kEqOfonrnPN9o6VGo9JWriA+Tt7fIWA5k8GA4SdntTAW1r
 JDDr/Cm5LKtpw==
Received: from customer (localhost [127.0.0.1])
 by submission (posteo.de) with ESMTPSA id 4DkcVP5xZcz6tml;
 Mon, 22 Feb 2021 10:35:25 +0100 (CET)
Date: Mon, 22 Feb 2021 10:35:25 +0100
From: Jonathan =?utf-8?Q?Neusch=C3=A4fer?= <j.ne@posteo.net>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v7 23/23] [DO NOT MERGE] arm64: Cope with CPUs stuck in
 VHE mode
Message-ID: <YDN6BtDhzmF5OtBO@latitude>
References: <20210208095732.3267263-1-maz@kernel.org>
 <20210208095732.3267263-24-maz@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20210208095732.3267263-24-maz@kernel.org>
X-Mailman-Approved-At: Mon, 22 Feb 2021 06:58:33 -0500
Cc: Srinivas Ramana <sramana@codeaurora.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Hector Martin <marcan@marcan.st>,
 linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
 Will Deacon <will@kernel.org>, Ajay Patil <pajay@qti.qualcomm.com>,
 Prasad Sodagudi <psodagud@codeaurora.org>, kernel-team@android.com,
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
Content-Type: multipart/mixed; boundary="===============8384262059381688296=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


--===============8384262059381688296==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="b/B7fiZwBVN17PG/"
Content-Disposition: inline


--b/B7fiZwBVN17PG/
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Feb 08, 2021 at 09:57:32AM +0000, Marc Zyngier wrote:
> It seems that the CPU known as Apple M1 has the terrible habit
> of being stuck with HCR_EL2.E2H=3D=3D1, in violation of the architecture.

Minor nitpick from the sideline: The M1 SoC has two kinds of CPU in it
(Icestorm and Firestorm), which makes "CPU known as Apple M1" a bit
imprecise.

In practicality it seems unlikely though, that Icestorm and Firestorm
act differently with regards to the code in this patch.


Best regards,
Jonathan Neusch=C3=A4fer

>=20
> Try and work around this deplorable state of affairs by detecting
> the stuck bit early and short-circuit the nVHE dance. It is still
> unknown whether there are many more such nuggets to be found...
>=20
> Reported-by: Hector Martin <marcan@marcan.st>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kernel/head.S     | 33 ++++++++++++++++++++++++++++++---
>  arch/arm64/kernel/hyp-stub.S | 28 ++++++++++++++++++++++++----
>  2 files changed, 54 insertions(+), 7 deletions(-)
[...]

--b/B7fiZwBVN17PG/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEvHAHGBBjQPVy+qvDCDBEmo7zX9sFAmAzet0ACgkQCDBEmo7z
X9vfWRAAgmO7sXidDBGjzOX7cP0Tb4rOOlQY06r6tQhTtim1xJkOSpzsGJTepdaD
9hZXErHxdvCEZY/QrxZW0VpZ1W4IEDXZBvGXcfvxL7JPvbbt+mZ4QD9zZa4ue8ZJ
9LKcRSFfjsKh0+Llu+PFyqe09XqAjtRDEv0QWsyC7HYRNHmVy2lMop8IiMLcVrM3
8t3UUsflQpMQr4nFRBqgvOxK5ydrDSP8R1v6HBOVEp3FH4X/FOPO8Mbo/zcXHSMX
LOvj0dCmQt9Rnm7wPkp1xbVTTD7MngQO5Df1DRm1o1lx9mxGQcIDerAoI1GRRNiA
WHXO3EqxEaZAkMa08bAZzBMGARpVk9YukqQOAwiWVzpH5/YRuSGDqufzV5e2Z37J
00e1wX501ZgcduRiO+MlDD88PBPAF8ok8zm3ZwvXSs5FQr88kLGGmmiGlIe2VMNF
MYt0P3j6g/Fnv7bXd8PlXohjIPVd5w0pIUm/AYqBVTmgSchP3he1CfJzQy5ICQlh
+svzK/vxqI19FibpUjZ3t8qsiLmlyHoeA1KwQwbueMbxs76QqDMA0ZuvVN6Xt3ot
BBAP/EcFvrFw55KxIMEPhxYsPT/OoG78RFhq0hVe7ht/8q0UF6gcFvUFla0T39oK
JmKkQSqicoo79PtzMMcKUigpmrkt3NgSgNy4o+70oYnFRVpm2g4=
=mdQE
-----END PGP SIGNATURE-----

--b/B7fiZwBVN17PG/--

--===============8384262059381688296==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============8384262059381688296==--
