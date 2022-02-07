Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6629C433F5
	for <kvmarm@archiver.kernel.org>; Mon,  7 Feb 2022 15:24:51 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5F2D540AEB;
	Mon,  7 Feb 2022 10:24:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Gz7RdT8YJCKb; Mon,  7 Feb 2022 10:24:50 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F018549E49;
	Mon,  7 Feb 2022 10:24:49 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 26E8D411D2
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Feb 2022 10:24:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qonssLvBQRXz for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Feb 2022 10:24:48 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F36B449EE0
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Feb 2022 10:24:47 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 8C4936149E;
 Mon,  7 Feb 2022 15:24:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43228C340F2;
 Mon,  7 Feb 2022 15:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1644247486;
 bh=+stvVyRnz2H4xbnaEtKWfcp0/IPDCeyODbC6Y5cXcCY=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=BeGQY67CXRWkA02czlOg4e4dKQhn1vgI0TX0Kzvk92P2fXSxyJ5PZWf6JYjOh28HG
 p/fcLBFTTYtSxmJ0HdA+tLpc5Dt3SvtdUu0aCiagxYI6IPJ2FfmB6Q3516WmUXUlvr
 sK843zAnWjjzJQUIN0M3GElhb43EQjDIaRJSDys7IPjJ/sroNZ+Q09hJGxtT4+A3i/
 TMZLeRX92xt/Zwsfw0+rQCGsDpmCTfoa3kob31yRRRK/nCjSj3rCJpcSsa4I3pUOyg
 3pgwkQtQ4m1aZ8I99dU4lZt6qIvRyb7UXGx/s9GxtOAaCYuZ/siUWdvC4Lq+H3sC9r
 9f5S4Sk87qJ/A==
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>,
 Shuah Khan <shuah@kernel.org>
Subject: [PATCH v11 24/40] arm64/sme: Disable streaming mode and ZA when
 flushing CPU state
Date: Mon,  7 Feb 2022 15:20:53 +0000
Message-Id: <20220207152109.197566-25-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220207152109.197566-1-broonie@kernel.org>
References: <20220207152109.197566-1-broonie@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1128; h=from:subject;
 bh=+stvVyRnz2H4xbnaEtKWfcp0/IPDCeyODbC6Y5cXcCY=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBiATjXZjkrllyw3wrZv65gkzLMq7K6hvi8wR5NerZM
 dVGlefyJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCYgE41wAKCRAk1otyXVSH0NQpB/
 9paVTph2pBZxYnT/c1ExiDXuHtp0fK3bfvDPEFT3bvWk96GqS7QwDkwaX2TuIM/QS8Ip7+6FM11I1z
 /Od20Ab96ZmMgKUnlxByL9hKw4g+pQcJB8Wqz4V6cV185sLmu8Dij7x/1+35pVPTOwft4FvC+uBe2a
 SSAcH1i11FngQ+xBNThdmdvo+2KWxm8L1AZ98cMW5EcyROtHRU/Bt4sM5M1+GhqyNJFqCD1vP06tLb
 bs5P0ELeLusAiGHNUThbDtTZbuNMANSC5axgd6WIFW7mUbGV4ZtsVHJsSID+dxJlsU5Bys1zUzt8hF
 TFjiL/AwQ/WxnrY43MddYL5xVG+cdM
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

Both streaming mode and ZA may increase power consumption when they are
enabled and streaming mode makes many FPSIMD and SVE instructions undefined
which will cause problems for any kernel mode floating point so disable
both when we flush the CPU state. This covers both kernel_neon_begin() and
idle and after flushing the state a reload is always required anyway.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/kernel/fpsimd.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index 8b111b7f2006..e00d3a9e919c 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -1762,6 +1762,15 @@ static void fpsimd_flush_cpu_state(void)
 {
 	WARN_ON(!system_supports_fpsimd());
 	__this_cpu_write(fpsimd_last_state.st, NULL);
+
+	/*
+	 * Leaving streaming mode enabled will cause issues for any kernel
+	 * NEON and leaving streaming mode or ZA enabled may increase power
+	 * consumption.
+	 */
+	if (system_supports_sme())
+		sme_smstop();
+
 	set_thread_flag(TIF_FOREIGN_FPSTATE);
 }
 
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
