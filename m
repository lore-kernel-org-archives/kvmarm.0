Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4F10C433F5
	for <kvmarm@archiver.kernel.org>; Fri,  8 Apr 2022 11:57:07 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7131A4B1EF;
	Fri,  8 Apr 2022 07:57:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id oZiBNU5XFLdZ; Fri,  8 Apr 2022 07:57:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 631FF4B1C7;
	Fri,  8 Apr 2022 07:57:06 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 81C9749F20
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Apr 2022 07:57:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4hFVdTU8a7od for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Apr 2022 07:57:04 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 78BE74B26D
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Apr 2022 07:57:04 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 04C9962052;
 Fri,  8 Apr 2022 11:57:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0364C385AC;
 Fri,  8 Apr 2022 11:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1649419023;
 bh=bmQq9+Hs9ppK5+d67ccvsBsIxc0wnK8U9AX00pV28UM=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=kdT7VrKgERpz6H4g0Eu0VPv3wDk4LaznrjXEOOcUAwPK2+RPH9B9JZjKqYi1Gaq1I
 /jHUkjwP/weuEYXpOKQMV+87cbmUc/DPOB8k576V+nvFBycvLHUR67bOO5nWnXbltw
 0xjYjQTQvJclU5dTKAsQ27UVQBHDXMlZ+eZ4/FoM49/KFjHPZlFqpZ/GJa4bq1OqLS
 YUTghrIvhgPuaWDj1+VgtFCSLsi3VnhvVz4JlR6yZRpDi7fOf2PFZeVg98GZPZUWbD
 yb316O29amWhCpPI1yl8SkfLRUwRQlfXw7/ycz+F/RzYCR8TLNuoOarsVsraVfexqw
 qUYhWYCPCyLwA==
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>,
 Shuah Khan <shuah@kernel.org>
Subject: [PATCH v13 27/39] arm64/sme: Provide Kconfig for SME
Date: Fri,  8 Apr 2022 12:43:16 +0100
Message-Id: <20220408114328.1401034-28-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220408114328.1401034-1-broonie@kernel.org>
References: <20220408114328.1401034-1-broonie@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1406; h=from:subject;
 bh=bmQq9+Hs9ppK5+d67ccvsBsIxc0wnK8U9AX00pV28UM=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBiUB/UAxUEsFosscV36+F0kLBR+bmSz16+f2YTgKsR
 gljSoxOJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCYlAf1AAKCRAk1otyXVSH0K8cB/
 9M/j4kluR0Nrf2PPhLPCfVpZ34in89IgJVEACGFfEItsnA/C33CFqs2QvlC8zaEqpG88e38zGMLXgU
 5kbntrCLMRKEqHBVMyJktNYx85/CGpiI1PLwCHm7cvffPwYOCEEX6rl7igQuDNonrCDiqNBhkkxERm
 RCsIrSi4i4jk2wLOgCCJoo79snBtSHYoLVdYLAltEY4j/zDWFrfQ1Xyd8+Q618woOEhkkoZHPT7MKZ
 BVAnDJlPLoLL6O25AnJ1cwjGSKTWc4dBqJUTRvIMOLnfnG897E7dnAOCYLSZBbbTRpHiI8Lq3SjO1y
 UqE2tnkb0ENKzmXla0EieLy5XQxo1x
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB
Cc: Basant Kumar Dwivedi <Basant.KumarDwivedi@arm.com>,
 Luis Machado <luis.machado@arm.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>,
 Mark Brown <broonie@kernel.org>, linux-arm-kernel@lists.infradead.org,
 linux-kselftest@vger.kernel.org, Alan Hayward <alan.hayward@arm.com>,
 kvmarm@lists.cs.columbia.edu, Salil Akerkar <Salil.Akerkar@arm.com>,
 Luca Salabrino <luca.scalabrino@arm.com>
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
index 57c4c995965f..0897984918e8 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -1939,6 +1939,17 @@ config ARM64_SVE
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
