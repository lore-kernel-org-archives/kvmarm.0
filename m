Return-Path: <SRS0=NVHA=GO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DB29C433DB
	for <kvmarm@archiver.kernel.org>; Mon, 11 Jan 2021 13:28:39 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3F1D82255F
	for <kvmarm@archiver.kernel.org>; Mon, 11 Jan 2021 13:28:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3F1D82255F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E08854B245;
	Mon, 11 Jan 2021 08:28:38 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qvYGtTThe1UM; Mon, 11 Jan 2021 08:28:37 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DBB494B243;
	Mon, 11 Jan 2021 08:28:28 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 14B0E4B22A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Jan 2021 08:28:26 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1mHW17ni-ba3 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 11 Jan 2021 08:28:25 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D7E034B21B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Jan 2021 08:28:24 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id EBD36221EC;
 Mon, 11 Jan 2021 13:28:23 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kyxF8-006gPD-81; Mon, 11 Jan 2021 13:28:22 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 linux-kernel@vger.kernel.org
Subject: [PATCH v3 03/21] arm64: Turn the MMU-on sequence into a macro
Date: Mon, 11 Jan 2021 13:27:53 +0000
Message-Id: <20210111132811.2455113-4-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210111132811.2455113-1-maz@kernel.org>
References: <20210111132811.2455113-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
 catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com,
 dbrazdil@google.com, alexandru.elisei@arm.com, ardb@kernel.org,
 jingzhangos@google.com, pajay@qti.qualcomm.com, psodagud@codeaurora.org,
 sramana@codeaurora.org, james.morse@arm.com, julien.thierry.kdev@gmail.com,
 suzuki.poulose@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Prasad Sodagudi <psodagud@codeaurora.org>,
 Srinivas Ramana <sramana@codeaurora.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Ajay Patil <pajay@qti.qualcomm.com>,
 kernel-team@android.com, Will Deacon <will@kernel.org>,
 Ard Biesheuvel <ardb@kernel.org>
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

Turning the MMU on is a popular sport in the arm64 kernel, and
we do it more than once, or even twice. As we are about to add
even more, let's turn it into a macro.

No expected functional change.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/assembler.h | 17 +++++++++++++++++
 arch/arm64/kernel/head.S           | 19 ++++---------------
 arch/arm64/mm/proc.S               | 12 +-----------
 3 files changed, 22 insertions(+), 26 deletions(-)

diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
index bf125c591116..8cded93f99c3 100644
--- a/arch/arm64/include/asm/assembler.h
+++ b/arch/arm64/include/asm/assembler.h
@@ -675,6 +675,23 @@ USER(\label, ic	ivau, \tmp2)			// invalidate I line PoU
 	.endif
 	.endm
 
+/*
+ * Set SCTLR_EL1 to the passed value, and invalidate the local icache
+ * in the process. This is called when setting the MMU on.
+ */
+.macro set_sctlr_el1, reg
+	msr	sctlr_el1, \reg
+	isb
+	/*
+	 * Invalidate the local I-cache so that any instructions fetched
+	 * speculatively from the PoC are discarded, since they may have
+	 * been dynamically patched at the PoU.
+	 */
+	ic	iallu
+	dsb	nsh
+	isb
+.endm
+
 /*
  * Check whether to yield to another runnable task from kernel mode NEON code
  * (which runs with preemption disabled).
diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index a0dc987724ed..28e9735302df 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -703,16 +703,9 @@ SYM_FUNC_START(__enable_mmu)
 	offset_ttbr1 x1, x3
 	msr	ttbr1_el1, x1			// load TTBR1
 	isb
-	msr	sctlr_el1, x0
-	isb
-	/*
-	 * Invalidate the local I-cache so that any instructions fetched
-	 * speculatively from the PoC are discarded, since they may have
-	 * been dynamically patched at the PoU.
-	 */
-	ic	iallu
-	dsb	nsh
-	isb
+
+	set_sctlr_el1	x0
+
 	ret
 SYM_FUNC_END(__enable_mmu)
 
@@ -883,11 +876,7 @@ SYM_FUNC_START_LOCAL(__primary_switch)
 	tlbi	vmalle1				// Remove any stale TLB entries
 	dsb	nsh
 
-	msr	sctlr_el1, x19			// re-enable the MMU
-	isb
-	ic	iallu				// flush instructions fetched
-	dsb	nsh				// via old mapping
-	isb
+	set_sctlr_el1	x19			// re-enable the MMU
 
 	bl	__relocate_kernel
 #endif
diff --git a/arch/arm64/mm/proc.S b/arch/arm64/mm/proc.S
index ece785477bdc..c967bfd30d2b 100644
--- a/arch/arm64/mm/proc.S
+++ b/arch/arm64/mm/proc.S
@@ -291,17 +291,7 @@ skip_pgd:
 	/* We're done: fire up the MMU again */
 	mrs	x17, sctlr_el1
 	orr	x17, x17, #SCTLR_ELx_M
-	msr	sctlr_el1, x17
-	isb
-
-	/*
-	 * Invalidate the local I-cache so that any instructions fetched
-	 * speculatively from the PoC are discarded, since they may have
-	 * been dynamically patched at the PoU.
-	 */
-	ic	iallu
-	dsb	nsh
-	isb
+	set_sctlr_el1	x17
 
 	/* Set the flag to zero to indicate that we're all done */
 	str	wzr, [flag_ptr]
-- 
2.29.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
