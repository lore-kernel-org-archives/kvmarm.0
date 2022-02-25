Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB476C433EF
	for <kvmarm@archiver.kernel.org>; Fri, 25 Feb 2022 17:36:24 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5D19F4B928;
	Fri, 25 Feb 2022 12:36:24 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HE+5bGiACAjo; Fri, 25 Feb 2022 12:36:22 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A192249EDE;
	Fri, 25 Feb 2022 12:36:22 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A20E4B952
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Feb 2022 12:36:21 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id X-hLqy5-F2zj for <kvmarm@lists.cs.columbia.edu>;
 Fri, 25 Feb 2022 12:36:20 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8D9B849E22
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Feb 2022 12:36:19 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 6D317B832D8;
 Fri, 25 Feb 2022 17:36:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97D39C340E7;
 Fri, 25 Feb 2022 17:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1645810577;
 bh=SiXh1GlTPzJ80ou8d0q75uEEfBAwCwDfZii7Ka/3bc4=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=udpT4g9lCKkmUAphqul2boEFltV/bjRgD9/o1VV/ihjQHWjyaRbPX9LDTmJU/NPKz
 +Yk+QlG4X+tMdFnn5GjV49142nRO/JXD/zdjuy933aIzrMiEnQhvB7qFkXiby9/Zg4
 KZlgZVbBHhd94dTVDhiOKEtLN6VsONLISVbVzvAWcfbl2oewyqef3DVBWC3WK8bgsw
 u6jH4Z9kHiUwWTrl6m+zAvhgPRXF2tKse2jtZkxFBegp9x3TSOfdzXpRifb9bwhJMg
 /dDRIl+KxmxTp4KGTSGolHoZjoiuhsT0ZrnGsCnbpW0FtZhRZjd3MqIxFPVSX6dRxM
 63b/kOwCu35wA==
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>,
 Shuah Khan <shuah@kernel.org>
Subject: [PATCH v12 29/40] arm64/sme: Provide Kconfig for SME
Date: Fri, 25 Feb 2022 16:59:12 +0000
Message-Id: <20220225165923.1474372-30-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220225165923.1474372-1-broonie@kernel.org>
References: <20220225165923.1474372-1-broonie@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1406; h=from:subject;
 bh=SiXh1GlTPzJ80ou8d0q75uEEfBAwCwDfZii7Ka/3bc4=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBiGQrhwdYzL9L7Qrfdei4bFgf3dSM8vVVLSAm/CYiz
 vV7SIlmJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCYhkK4QAKCRAk1otyXVSH0DYeB/
 0T+wlUUZhxCKS58D35CrirM55QLjgJEaAbj3go2HNzocTreEjqgrzqdis4qGqEwm8F46vWM/+WvZ2u
 PQejUbA2DRKGJSo/tTHggJ0ZywRn7PnbSlV/S5mNE6g2oGW549oN3QFLFCBo1RoSOvv+PGOGXfdZR4
 egAZvKuNhz0UBtb0bt9/Gyp6DflybEJc21Gc5+CObkj0743i2ipNxXKtaNSPU26KABLYdbtYUwYHDQ
 GvfqgZLDXt3HlZITSdIi478IDuNPi39EkalRJGoGfVxjIVFUfIu19zHgPRc39RJLS8TO/tvhD4tb68
 wargCI+8LblSAux/RqDrnf5dWBMmnE
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB
Cc: Basant Kumar Dwivedi <Basant.KumarDwivedi@arm.com>,
 Luis Machado <luis.machado@arm.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>,
 Mark Brown <broonie@kernel.org>, linux-arm-kernel@lists.infradead.org,
 linux-kselftest@vger.kernel.org, Alan Hayward <alan.hayward@arm.com>,
 kvmarm@lists.cs.columbia.edu, Salil Akerkar <Salil.Akerkar@arm.com>
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Now that basline support for the Scalable Matrix Extension (SME) is present
introduce the Kconfig option allowing it to be built. While the feature
registers don't impose a strong requirement for a system with SME to
support SVE at runtime the support for streaming mode SVE is mostly
shared with normal SVE so depend on SVE.

Signed-off-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm64/Kconfig | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index cbcd42decb2a..4fd7574866cc 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -1924,6 +1924,17 @@ config ARM64_SVE
 	  booting the kernel.  If unsure and you are not observing these
 	  symptoms, you should assume that it is safe to say Y.
 
+config ARM64_SME
+	bool "ARM Scalable Matrix Extension support"
+	default y
+	depends on ARM64_SVE
+	help
+	  The Scalable Matrix Extension (SME) is an extension to the AArch64
+	  execution state which utilises a substantial subset of the SVE
+	  instruction set, together with the addition of new architectural
+	  register state capable of holding two dimensional matrix tiles to
+	  enable various matrix operations.
+
 config ARM64_MODULE_PLTS
 	bool "Use PLTs to allow module memory to spill over into vmalloc area"
 	depends on MODULES
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
