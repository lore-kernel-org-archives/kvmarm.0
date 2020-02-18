Return-Path: <SRS0=SKU0=4G=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C849EC34026
	for <kvmarm@archiver.kernel.org>; Tue, 18 Feb 2020 19:59:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8E51324125
	for <kvmarm@archiver.kernel.org>; Tue, 18 Feb 2020 19:59:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8E51324125
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 47C4B4AF77;
	Tue, 18 Feb 2020 14:59:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id K1RxHZ-ppz4A; Tue, 18 Feb 2020 14:59:11 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 49F264AF7A;
	Tue, 18 Feb 2020 14:59:11 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 964DC4AF46
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Feb 2020 14:59:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ELppdqYFMSm9 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 18 Feb 2020 14:59:08 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A0DA24AF48
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Feb 2020 14:59:07 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4B5C5FEC;
 Tue, 18 Feb 2020 11:59:07 -0800 (PST)
Received: from localhost (unknown [10.37.6.21])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C1D9C3F68F;
 Tue, 18 Feb 2020 11:59:06 -0800 (PST)
From: Mark Brown <broonie@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 06/18] arm64: entry-ftrace.S: Convert to modern annotations
 for assembly functions
Date: Tue, 18 Feb 2020 19:58:30 +0000
Message-Id: <20200218195842.34156-7-broonie@kernel.org>
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

In an effort to clarify and simplify the annotation of assembly functions
in the kernel new macros have been introduced. These replace ENTRY and
ENDPROC and also add a new annotation for static functions which previously
had no ENTRY equivalent. Update the annotations in the core kernel code to
the new macros.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/kernel/entry-ftrace.S | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/kernel/entry-ftrace.S b/arch/arm64/kernel/entry-ftrace.S
index 7d02f9966d34..3d32b6d325d7 100644
--- a/arch/arm64/kernel/entry-ftrace.S
+++ b/arch/arm64/kernel/entry-ftrace.S
@@ -91,11 +91,11 @@ ENTRY(ftrace_common)
 	ldr_l	x2, function_trace_op		// op
 	mov	x3, sp				// regs
 
-GLOBAL(ftrace_call)
+SYM_INNER_LABEL(ftrace_call, SYM_L_GLOBAL)
 	bl	ftrace_stub
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
-GLOBAL(ftrace_graph_call)		// ftrace_graph_caller();
+SYM_INNER_LABEL(ftrace_graph_call, SYM_L_GLOBAL) // ftrace_graph_caller();
 	nop				// If enabled, this will be replaced
 					// "b ftrace_graph_caller"
 #endif
@@ -218,7 +218,7 @@ ENDPROC(ftrace_graph_caller)
  *     - tracer function to probe instrumented function's entry,
  *     - ftrace_graph_caller to set up an exit hook
  */
-ENTRY(_mcount)
+SYM_FUNC_START(_mcount)
 	mcount_enter
 
 	ldr_l	x2, ftrace_trace_function
@@ -242,7 +242,7 @@ skip_ftrace_call:			// }
 	b.ne	ftrace_graph_caller	//     ftrace_graph_caller();
 #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
 	mcount_exit
-ENDPROC(_mcount)
+SYM_FUNC_END(_mcount)
 EXPORT_SYMBOL(_mcount)
 NOKPROBE(_mcount)
 
@@ -253,9 +253,9 @@ NOKPROBE(_mcount)
  * and later on, NOP to branch to ftrace_caller() when enabled or branch to
  * NOP when disabled per-function base.
  */
-ENTRY(_mcount)
+SYM_FUNC_START(_mcount)
 	ret
-ENDPROC(_mcount)
+SYM_FUNC_END(_mcount)
 EXPORT_SYMBOL(_mcount)
 NOKPROBE(_mcount)
 
@@ -268,24 +268,24 @@ NOKPROBE(_mcount)
  *     - tracer function to probe instrumented function's entry,
  *     - ftrace_graph_caller to set up an exit hook
  */
-ENTRY(ftrace_caller)
+SYM_FUNC_START(ftrace_caller)
 	mcount_enter
 
 	mcount_get_pc0	x0		//     function's pc
 	mcount_get_lr	x1		//     function's lr
 
-GLOBAL(ftrace_call)			// tracer(pc, lr);
+SYM_INNER_LABEL(ftrace_call, SYM_L_GLOBAL)	// tracer(pc, lr);
 	nop				// This will be replaced with "bl xxx"
 					// where xxx can be any kind of tracer.
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
-GLOBAL(ftrace_graph_call)		// ftrace_graph_caller();
+SYM_INNER_LABEL(ftrace_graph_call)		// ftrace_graph_caller();
 	nop				// If enabled, this will be replaced
 					// "b ftrace_graph_caller"
 #endif
 
 	mcount_exit
-ENDPROC(ftrace_caller)
+SYM_FUNC_END(ftrace_caller)
 #endif /* CONFIG_DYNAMIC_FTRACE */
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
@@ -298,20 +298,20 @@ ENDPROC(ftrace_caller)
  * the call stack in order to intercept instrumented function's return path
  * and run return_to_handler() later on its exit.
  */
-ENTRY(ftrace_graph_caller)
+SYM_FUNC_START(ftrace_graph_caller)
 	mcount_get_pc		  x0	//     function's pc
 	mcount_get_lr_addr	  x1	//     pointer to function's saved lr
 	mcount_get_parent_fp	  x2	//     parent's fp
 	bl	prepare_ftrace_return	// prepare_ftrace_return(pc, &lr, fp)
 
 	mcount_exit
-ENDPROC(ftrace_graph_caller)
+SYM_FUNC_END(ftrace_graph_caller)
 #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
 #endif /* CONFIG_DYNAMIC_FTRACE_WITH_REGS */
 
-ENTRY(ftrace_stub)
+SYM_FUNC_START(ftrace_stub)
 	ret
-ENDPROC(ftrace_stub)
+SYM_FUNC_END(ftrace_stub)
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 /*
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
