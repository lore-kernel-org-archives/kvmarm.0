Return-Path: <SRS0=SKU0=4G=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94230C3404C
	for <kvmarm@archiver.kernel.org>; Tue, 18 Feb 2020 19:59:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 573282465A
	for <kvmarm@archiver.kernel.org>; Tue, 18 Feb 2020 19:59:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 573282465A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 112DC4AF48;
	Tue, 18 Feb 2020 14:59:22 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GQSQ-iw81Y8z; Tue, 18 Feb 2020 14:59:20 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E74544AF70;
	Tue, 18 Feb 2020 14:59:20 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A1D84AF32
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Feb 2020 14:59:19 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id L2ZEA5OHeU-A for <kvmarm@lists.cs.columbia.edu>;
 Tue, 18 Feb 2020 14:59:18 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AF56A4AF54
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Feb 2020 14:59:18 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 76C7C31B;
 Tue, 18 Feb 2020 11:59:18 -0800 (PST)
Received: from localhost (unknown [10.37.6.21])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id ED71F3F68F;
 Tue, 18 Feb 2020 11:59:17 -0800 (PST)
From: Mark Brown <broonie@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 11/18] arm64: kernel: Convert to modern annotations for
 assembly data
Date: Tue, 18 Feb 2020 19:58:35 +0000
Message-Id: <20200218195842.34156-12-broonie@kernel.org>
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
in the kernel new macros have been introduced. These include specific
annotations for the start and end of data, update symbols for data to use
these.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/kernel/entry.S | 7 ++++---
 arch/arm64/kernel/head.S  | 9 ++++++---
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index fbf69fe94412..7439f29946fb 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -859,9 +859,9 @@ SYM_CODE_END(tramp_exit_compat)
 #ifdef CONFIG_RANDOMIZE_BASE
 	.pushsection ".rodata", "a"
 	.align PAGE_SHIFT
-	.globl	__entry_tramp_data_start
-__entry_tramp_data_start:
+SYM_DATA_START(__entry_tramp_data_start)
 	.quad	vectors
+SYM_DATA_END(__entry_tramp_data_start)
 	.popsection				// .rodata
 #endif /* CONFIG_RANDOMIZE_BASE */
 #endif /* CONFIG_UNMAP_KERNEL_AT_EL0 */
@@ -983,8 +983,9 @@ NOKPROBE(__sdei_asm_exit_trampoline)
 .popsection		// .entry.tramp.text
 #ifdef CONFIG_RANDOMIZE_BASE
 .pushsection ".rodata", "a"
-__sdei_asm_trampoline_next_handler:
+SYM_DATA_START(__sdei_asm_trampoline_next_handler)
 	.quad	__sdei_asm_handler
+SYM_DATA_END(__sdei_asm_trampoline_next_handler)
 .popsection		// .rodata
 #endif /* CONFIG_RANDOMIZE_BASE */
 #endif /* CONFIG_UNMAP_KERNEL_AT_EL0 */
diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index c334863991e7..a06727354fad 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -464,8 +464,9 @@ SYM_FUNC_END(__primary_switched)
  */
 	.section ".idmap.text","awx"
 
-ENTRY(kimage_vaddr)
+SYM_DATA_START(kimage_vaddr)
 	.quad		_text - TEXT_OFFSET
+SYM_DATA_END(kimage_vaddr)
 EXPORT_SYMBOL(kimage_vaddr)
 
 /*
@@ -667,15 +668,17 @@ SYM_FUNC_END(set_cpu_boot_mode_flag)
  * This is not in .bss, because we set it sufficiently early that the boot-time
  * zeroing of .bss would clobber it.
  */
-ENTRY(__boot_cpu_mode)
+SYM_DATA_START(__boot_cpu_mode)
 	.long	BOOT_CPU_MODE_EL2
 	.long	BOOT_CPU_MODE_EL1
+SYM_DATA_END(__boot_cpu_mode)
 /*
  * The booting CPU updates the failed status @__early_cpu_boot_status,
  * with MMU turned off.
  */
-ENTRY(__early_cpu_boot_status)
+SYM_DATA_START(__early_cpu_boot_status)
 	.quad 	0
+SYM_DATA_END(__early_cpu_boot_status)
 
 	.popsection
 
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
