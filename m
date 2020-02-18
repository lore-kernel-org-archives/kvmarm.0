Return-Path: <SRS0=SKU0=4G=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44609C34026
	for <kvmarm@archiver.kernel.org>; Tue, 18 Feb 2020 19:59:34 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 054452464E
	for <kvmarm@archiver.kernel.org>; Tue, 18 Feb 2020 19:59:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 054452464E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AF2E84AF97;
	Tue, 18 Feb 2020 14:59:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 13BAl9rRlC1D; Tue, 18 Feb 2020 14:59:32 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AB0424AF8D;
	Tue, 18 Feb 2020 14:59:32 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CFABF4AF3B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Feb 2020 14:59:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ncWUrk7lOC2v for <kvmarm@lists.cs.columbia.edu>;
 Tue, 18 Feb 2020 14:59:30 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D35114AF48
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Feb 2020 14:59:29 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9EC6931B;
 Tue, 18 Feb 2020 11:59:29 -0800 (PST)
Received: from localhost (unknown [10.37.6.21])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 22BE63F68F;
 Tue, 18 Feb 2020 11:59:28 -0800 (PST)
From: Mark Brown <broonie@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 16/18] arm64: sdei: Annotate SDEI entry points using new style
 annotations
Date: Tue, 18 Feb 2020 19:58:40 +0000
Message-Id: <20200218195842.34156-17-broonie@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200218195842.34156-1-broonie@kernel.org>
References: <20200218195842.34156-1-broonie@kernel.org>
MIME-Version: 1.0
Cc: Mark Brown <broonie@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org
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

In an effort to clarify and simplify the annotation of assembly
functions new macros have been introduced. These replace ENTRY and
ENDPROC with two different annotations for normal functions and those
with unusual calling conventions.

The SDEI entry points are currently annotated as normal functions but
are called from non-kernel contexts with non-standard calling convention
and should therefore be annotated as such so do so.

Signed-off-by: Mark Brown <broonie@kernel.org>
Acked-by: James Morse <james.Morse@arm.com>
---
 arch/arm64/kernel/entry.S | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index 7439f29946fb..e5d4e30ee242 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -938,7 +938,7 @@ NOKPROBE(ret_from_fork)
  */
 .ltorg
 .pushsection ".entry.tramp.text", "ax"
-ENTRY(__sdei_asm_entry_trampoline)
+SYM_CODE_START(__sdei_asm_entry_trampoline)
 	mrs	x4, ttbr1_el1
 	tbz	x4, #USER_ASID_BIT, 1f
 
@@ -960,7 +960,7 @@ ENTRY(__sdei_asm_entry_trampoline)
 	ldr	x4, =__sdei_asm_handler
 #endif
 	br	x4
-ENDPROC(__sdei_asm_entry_trampoline)
+SYM_CODE_END(__sdei_asm_entry_trampoline)
 NOKPROBE(__sdei_asm_entry_trampoline)
 
 /*
@@ -970,14 +970,14 @@ NOKPROBE(__sdei_asm_entry_trampoline)
  * x2: exit_mode
  * x4: struct sdei_registered_event argument from registration time.
  */
-ENTRY(__sdei_asm_exit_trampoline)
+SYM_CODE_START(__sdei_asm_exit_trampoline)
 	ldr	x4, [x4, #(SDEI_EVENT_INTREGS + S_ORIG_ADDR_LIMIT)]
 	cbnz	x4, 1f
 
 	tramp_unmap_kernel	tmp=x4
 
 1:	sdei_handler_exit exit_mode=x2
-ENDPROC(__sdei_asm_exit_trampoline)
+SYM_CODE_END(__sdei_asm_exit_trampoline)
 NOKPROBE(__sdei_asm_exit_trampoline)
 	.ltorg
 .popsection		// .entry.tramp.text
@@ -1003,7 +1003,7 @@ SYM_DATA_END(__sdei_asm_trampoline_next_handler)
  * follow SMC-CC. We save (or retrieve) all the registers as the handler may
  * want them.
  */
-ENTRY(__sdei_asm_handler)
+SYM_CODE_START(__sdei_asm_handler)
 	stp     x2, x3, [x1, #SDEI_EVENT_INTREGS + S_PC]
 	stp     x4, x5, [x1, #SDEI_EVENT_INTREGS + 16 * 2]
 	stp     x6, x7, [x1, #SDEI_EVENT_INTREGS + 16 * 3]
@@ -1086,6 +1086,6 @@ alternative_else_nop_endif
 	tramp_alias	dst=x5, sym=__sdei_asm_exit_trampoline
 	br	x5
 #endif
-ENDPROC(__sdei_asm_handler)
+SYM_CODE_END(__sdei_asm_handler)
 NOKPROBE(__sdei_asm_handler)
 #endif /* CONFIG_ARM_SDE_INTERFACE */
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
