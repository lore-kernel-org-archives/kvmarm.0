Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F078DC433F5
	for <kvmarm@archiver.kernel.org>; Tue, 25 Jan 2022 00:17:12 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A819D49EC1;
	Mon, 24 Jan 2022 19:17:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id n8PKZmXwX2Pc; Mon, 24 Jan 2022 19:17:11 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7A6C849EF1;
	Mon, 24 Jan 2022 19:17:11 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8940F49EC1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 24 Jan 2022 19:17:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mtiO6JBH+rkp for <kvmarm@lists.cs.columbia.edu>;
 Mon, 24 Jan 2022 19:17:09 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9BF0C49B12
 for <kvmarm@lists.cs.columbia.edu>; Mon, 24 Jan 2022 19:17:08 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 32C3161548;
 Tue, 25 Jan 2022 00:17:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FB75C340E8;
 Tue, 25 Jan 2022 00:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1643069827;
 bh=QxDCYADgLO7Ate8OqAbdluQUXHUE34NK/8kXtjiy66A=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=jwC+s/7s94IsN7xSs2fr74xXB9CNZSVS0T/UINwK4FVSpeellMAhwM5ftVTk2cMfX
 qrGljkUqSxZUmlghBi/UmyStKhSCDiPHDMvqQF5Lbut6kc9j7kZvHuWAGXRVEHG+04
 u9tk2Yl5iUjM3Ssq3/NDsKupqNMSQOG9Jh0wvqcDe3WSMhdIotF1Ktdch9wulcBpGa
 gOamL/50BrX4Zb+W/v0mYwJLGmVLXifKR7yLpw9uu4dvvJQ0VbYzE6xSao7oq3eqqt
 iRiy0mNdZjxBB39y+SG7LjpSROBg283Q19fZxIDCYUbFBIbQ22IHnWRPN+McXgHmBx
 gY2KmN7Z1WsMw==
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>,
 Shuah Khan <shuah@kernel.org>
Subject: [PATCH v8 27/38] arm64/sme: Provide Kconfig for SME
Date: Tue, 25 Jan 2022 00:11:03 +0000
Message-Id: <20220125001114.193425-28-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220125001114.193425-1-broonie@kernel.org>
References: <20220125001114.193425-1-broonie@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1350; h=from:subject;
 bh=QxDCYADgLO7Ate8OqAbdluQUXHUE34NK/8kXtjiy66A=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBh70AWO5EXNCblah8mNd3crJRe3Ue7ZJ3oWFjj+/Wo
 dCuJNvuJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCYe9AFgAKCRAk1otyXVSH0BRgB/
 43Rva4UBWdtRzqPyhOUWBLfKjPH+8W7qDQFEuBCWTBj9PcLCl7b3lqFoqWdz7f7Qh+oi4KPAg8L8Pq
 U/4fNAtROOuNwNWSy+9K1tvhIXTOtRLFWAOrkEMKlsroEaTyWQkXIGRK6pNnrwOhGRVml84jxrGJTz
 BXTmnkfvXknHbP/3oCE0mNkSX+G20BjFLsYeq3xbJYqnb3RQFUQxBNQc7Zz1t8lnwtQqh3LeiRNzks
 HSd/T5Ltg6on+j4Rf5i9XQazm35+Z/hwTMzb+g/0fB1Fme+T6snLoXjaUkROof30/TLcGloORR63sB
 w5gSLsrwFsrdLcAQlcWEgGgVaTd+xw
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
---
 arch/arm64/Kconfig | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 6978140edfa4..f60f3b04ddf5 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -1839,6 +1839,17 @@ config ARM64_SVE
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
