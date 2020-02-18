Return-Path: <SRS0=SKU0=4G=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D809C34049
	for <kvmarm@archiver.kernel.org>; Tue, 18 Feb 2020 19:59:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E56B324655
	for <kvmarm@archiver.kernel.org>; Tue, 18 Feb 2020 19:59:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E56B324655
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9FA8E4AF77;
	Tue, 18 Feb 2020 14:59:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sdmY4lY0UpkV; Tue, 18 Feb 2020 14:59:08 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 270844AF64;
	Tue, 18 Feb 2020 14:59:07 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 304514AF3C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Feb 2020 14:59:06 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RIMvRnkTQg7N for <kvmarm@lists.cs.columbia.edu>;
 Tue, 18 Feb 2020 14:59:05 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5A2304AF64
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Feb 2020 14:59:05 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 13FF231B;
 Tue, 18 Feb 2020 11:59:05 -0800 (PST)
Received: from localhost (unknown [10.37.6.21])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 89F933F68F;
 Tue, 18 Feb 2020 11:59:04 -0800 (PST)
From: Mark Brown <broonie@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 05/18] arm64: entry: Additional annotation conversions for
 entry.S
Date: Tue, 18 Feb 2020 19:58:29 +0000
Message-Id: <20200218195842.34156-6-broonie@kernel.org>
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
ENDPROC with separate annotations for standard C callable functions,
data and code with different calling conventions.  Update the
remaining annotations in the entry.S code to the new macros.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/kernel/entry.S | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index d535cb8a7413..fbf69fe94412 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -832,7 +832,7 @@ alternative_else_nop_endif
 	.endm
 
 	.align	11
-ENTRY(tramp_vectors)
+SYM_CODE_START_NOALIGN(tramp_vectors)
 	.space	0x400
 
 	tramp_ventry
@@ -844,15 +844,15 @@ ENTRY(tramp_vectors)
 	tramp_ventry	32
 	tramp_ventry	32
 	tramp_ventry	32
-END(tramp_vectors)
+SYM_CODE_END(tramp_vectors)
 
-ENTRY(tramp_exit_native)
+SYM_CODE_START(tramp_exit_native)
 	tramp_exit
-END(tramp_exit_native)
+SYM_CODE_END(tramp_exit_native)
 
-ENTRY(tramp_exit_compat)
+SYM_CODE_START(tramp_exit_compat)
 	tramp_exit	32
-END(tramp_exit_compat)
+SYM_CODE_END(tramp_exit_compat)
 
 	.ltorg
 	.popsection				// .entry.tramp.text
@@ -874,7 +874,7 @@ __entry_tramp_data_start:
  * Previous and next are guaranteed not to be the same.
  *
  */
-ENTRY(cpu_switch_to)
+SYM_FUNC_START(cpu_switch_to)
 	mov	x10, #THREAD_CPU_CONTEXT
 	add	x8, x0, x10
 	mov	x9, sp
@@ -896,7 +896,7 @@ ENTRY(cpu_switch_to)
 	mov	sp, x9
 	msr	sp_el0, x1
 	ret
-ENDPROC(cpu_switch_to)
+SYM_FUNC_END(cpu_switch_to)
 NOKPROBE(cpu_switch_to)
 
 /*
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
