Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF719C433F5
	for <kvmarm@archiver.kernel.org>; Wed,  4 May 2022 13:41:27 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4DA094B105;
	Wed,  4 May 2022 09:41:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GtCSNdurVyaz; Wed,  4 May 2022 09:41:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4887C4B11A;
	Wed,  4 May 2022 09:41:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 512A049F3D
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 May 2022 09:41:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5rR9racs0p3g for <kvmarm@lists.cs.columbia.edu>;
 Wed,  4 May 2022 09:41:24 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 396C249E45
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 May 2022 09:41:24 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id CD6E2B825A5;
 Wed,  4 May 2022 13:41:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB540C385A8;
 Wed,  4 May 2022 13:41:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1651671681;
 bh=jw7zUbrlhazFO3+mVKiDdtJjleKdC7a/rqXJoqbRRpM=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=T8Df1X+FRxZQW16keZRhs1DfbXX/QajNJBXsAq3JC/F7pNyFVVguLvW04dqGEzxll
 2m7zRulLXO6gmNN1bHwYxpD3NDmymFNRYOtIoQLc7JpdG3dCYVBuk0Xlo0rZg+GEP5
 QMmCEum9+S/p8BRdu3eMqaHWtM+YtGqmqsZ5YcDypl9CAyAAhifzZiJP1jLhwn/JR6
 EwrS3jmd0SEm+58pbHr/Sz7NQKdozpO98NY9iueHVqBm8z9CuU3K2UQuTxgdt2fIfS
 DW6XwiOG4fh1W4bzs4cjyO/xNwrHHsysKbdDCqOVWNJEa/hkNpaO+H1C0nWSIfIBOa
 DxfwWRpGPBy6Q==
Date: Wed, 4 May 2022 14:41:13 +0100
From: Mark Brown <broonie@kernel.org>
To: Kalesh Singh <kaleshsingh@google.com>
Subject: Re: [PATCH v2 1/5] KVM: arm64: Factor out common stack unwinding logic
Message-ID: <YnKCeci08OY7uk0N@sirena.org.uk>
References: <20220502191222.4192768-1-kaleshsingh@google.com>
 <20220502191222.4192768-2-kaleshsingh@google.com>
MIME-Version: 1.0
In-Reply-To: <20220502191222.4192768-2-kaleshsingh@google.com>
X-Cookie: Mother is the invention of necessity.
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>, Marco Elver <elver@google.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Alexei Starovoitov <ast@kernel.org>,
 will@kernel.org, maz@kernel.org, kvmarm@lists.cs.columbia.edu,
 "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>,
 linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
 surenb@google.com, Peter Collingbourne <pcc@google.com>,
 linux-kernel@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>
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
Content-Type: multipart/mixed; boundary="===============3878148182053302462=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


--===============3878148182053302462==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="JeDypAEY5KrfMCxE"
Content-Disposition: inline


--JeDypAEY5KrfMCxE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 02, 2022 at 12:12:01PM -0700, Kalesh Singh wrote:
> Factor out the stack unwinding logic common to both the host kernel and
> the nVHE hypersivor into __unwind_next(). This allows for reuse in the
> nVHE hypervisor stack unwinding (later in this series).

Reviewed-by: Mark Brown <broonie@kernel.org>

--JeDypAEY5KrfMCxE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmJygngACgkQJNaLcl1U
h9Bnigf/SrnKbQKJZQjo1OskfncvQ0A42sToBqNL5kFNTNT7vFVbZwv1bx3TllPk
HvffoX8n/CrQ3ly+MQjLaS2sLBmjn/pHC735ihAUGl8O/UtYP3T0A90WK28Hw+vE
yEPVzhzm7fKGIK97QdbVqaKsDZmFifbEFfL51BQpbCZessqwuQq/ZnmvNKg9je0S
C6TMpY4yEn9mVEWSS5LBcBYVOlt8O9Kz2gNUA5irxdVcnzTG1iwYmiAO6F3Yv1to
OxU+Hnlu+v1lG7ZV4V6+ngrr+RCeSFKEDCGCAlDHnvamwWW7flrIwqAXzP1DzTx+
1AKWv2X394fnYOpTbckzPzzUV6G7mQ==
=/zNs
-----END PGP SIGNATURE-----

--JeDypAEY5KrfMCxE--

--===============3878148182053302462==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============3878148182053302462==--
