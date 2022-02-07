Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3743EC433F5
	for <kvmarm@archiver.kernel.org>; Mon,  7 Feb 2022 15:25:12 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DF34049EE0;
	Mon,  7 Feb 2022 10:25:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QeMyELpgHqlJ; Mon,  7 Feb 2022 10:25:10 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AE70C43C96;
	Mon,  7 Feb 2022 10:25:10 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B63940E06
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Feb 2022 10:25:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wpa2Y+-P5Pek for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Feb 2022 10:25:08 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BA2E349ED1
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Feb 2022 10:25:06 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 3D38561035;
 Mon,  7 Feb 2022 15:25:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BE7FC36AE7;
 Mon,  7 Feb 2022 15:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1644247505;
 bh=0LXVZ77sgiyan75W9C44HaIY6F6dypE6Mf2Hnz/Bc3A=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=PPZ3hqqmm2nZFYixtIxBDi/n8wJ4SInSsGQCeryXGmKFUxcNdkd6WN5C6Y7I0GOHP
 ZxeMOAoA0pTUoXs3jVqTGfKDRc8yP9Uy2NhIIBKyGcw35JqvlunRjn20erZi6tuRZm
 6ulQeSP2sBdVqrnXB9fyk7Yztshi2rsJFOd8+TOL+ff0dRUtr+XkGLODFCpqxi2syp
 6TnNmAlVIpaRRynDGuwvS2wL9HPFmB5RRi73ZqMTAap+AT5ZkUhgAQmcDW47g47mH6
 xaoCG+BhCFPf5tqoQnUN5bPmLS4V5qFigh/nic90QW8/EjSSChRhPzYasIyP5ziCWq
 weTh8vfPoGxqg==
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>,
 Shuah Khan <shuah@kernel.org>
Subject: [PATCH v11 29/40] arm64/sme: Provide Kconfig for SME
Date: Mon,  7 Feb 2022 15:20:58 +0000
Message-Id: <20220207152109.197566-30-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220207152109.197566-1-broonie@kernel.org>
References: <20220207152109.197566-1-broonie@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1350; h=from:subject;
 bh=0LXVZ77sgiyan75W9C44HaIY6F6dypE6Mf2Hnz/Bc3A=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBiATjbVts5UABagGOE8w0L9uxLUlD7a0GrMKov9DKx
 XcFomxqJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCYgE42wAKCRAk1otyXVSH0KaaB/
 49J9mPnsLXrFT/8vK4pZY+/SiE+qf5g85M7/oCF82uKTUiL6JEjrcuXjcl9vh5jHgbI5i1wUXa9JIu
 hzAQAKvQFERK9erAOBiEakfjy2VupUR3BvcbLFWTVYDS+W8wMxGI3fhu3lqZ7WAzuO9Q/BIfQ03HD/
 M0DJP8KNmAyxGDWn0nw2CZR9RqbV9Qde6b4nodeWszgtQXEllvUgutvcgTFauYzMFDTb6g2KDWRfVa
 KbZW12jxTBPMTiU+deFSYRX4q26/E+XZbs+0U9gtsiXFVPjwvsZJRavSRcD+1O46eg8ocD3r8rcspH
 UUcbkyEbX01suJ8N5q6RjsNd4TAxVx
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
