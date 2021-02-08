Return-Path: <SRS0=ArS2=HK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7461C433E0
	for <kvmarm@archiver.kernel.org>; Mon,  8 Feb 2021 10:04:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6DC2564EAC
	for <kvmarm@archiver.kernel.org>; Mon,  8 Feb 2021 10:04:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6DC2564EAC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0C4AF4B5CA;
	Mon,  8 Feb 2021 05:04:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lkxi5sGjBXCB; Mon,  8 Feb 2021 05:04:53 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 156DA4B637;
	Mon,  8 Feb 2021 05:04:48 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BA4064B3A3
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Feb 2021 05:04:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8CoZj40tUveG for <kvmarm@lists.cs.columbia.edu>;
 Mon,  8 Feb 2021 05:04:43 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2E1DC4B66B
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Feb 2021 05:04:41 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 4BD3264EA7;
 Mon,  8 Feb 2021 10:04:40 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1l93It-00Ck14-Ne; Mon, 08 Feb 2021 09:57:59 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 linux-kernel@vger.kernel.org
Subject: [PATCH v7 12/23] arm64: Extract early FDT mapping from
 kaslr_early_init()
Date: Mon,  8 Feb 2021 09:57:21 +0000
Message-Id: <20210208095732.3267263-13-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210208095732.3267263-1-maz@kernel.org>
References: <20210208095732.3267263-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
 catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com,
 dbrazdil@google.com, alexandru.elisei@arm.com, ardb@kernel.org,
 jingzhangos@google.com, pajay@qti.qualcomm.com, psodagud@codeaurora.org,
 sramana@codeaurora.org, marcan@marcan.st, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Prasad Sodagudi <psodagud@codeaurora.org>,
 Srinivas Ramana <sramana@codeaurora.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Hector Martin <marcan@marcan.st>,
 Ajay Patil <pajay@qti.qualcomm.com>, kernel-team@android.com,
 Will Deacon <will@kernel.org>, Ard Biesheuvel <ardb@kernel.org>
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

As we want to parse more options very early in the kernel lifetime,
let's always map the FDT early. This is achieved by moving that
code out of kaslr_early_init().

No functionnal change expected.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/include/asm/setup.h | 11 +++++++++++
 arch/arm64/kernel/head.S       |  3 ++-
 arch/arm64/kernel/kaslr.c      |  7 +++----
 arch/arm64/kernel/setup.c      | 15 +++++++++++++++
 4 files changed, 31 insertions(+), 5 deletions(-)
 create mode 100644 arch/arm64/include/asm/setup.h

diff --git a/arch/arm64/include/asm/setup.h b/arch/arm64/include/asm/setup.h
new file mode 100644
index 000000000000..d3320618ed14
--- /dev/null
+++ b/arch/arm64/include/asm/setup.h
@@ -0,0 +1,11 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#ifndef __ARM64_ASM_SETUP_H
+#define __ARM64_ASM_SETUP_H
+
+#include <uapi/asm/setup.h>
+
+void *get_early_fdt_ptr(void);
+void early_fdt_map(u64 dt_phys);
+
+#endif
diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index b425d2587cdb..d74e5f84042e 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -433,6 +433,8 @@ SYM_FUNC_START_LOCAL(__primary_switched)
 	bl	__pi_memset
 	dsb	ishst				// Make zero page visible to PTW
 
+	mov	x0, x21				// pass FDT address in x0
+	bl	early_fdt_map			// Try mapping the FDT early
 	bl	switch_to_vhe
 #if defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS)
 	bl	kasan_early_init
@@ -440,7 +442,6 @@ SYM_FUNC_START_LOCAL(__primary_switched)
 #ifdef CONFIG_RANDOMIZE_BASE
 	tst	x23, ~(MIN_KIMG_ALIGN - 1)	// already running randomized?
 	b.ne	0f
-	mov	x0, x21				// pass FDT address in x0
 	bl	kaslr_early_init		// parse FDT for KASLR options
 	cbz	x0, 0f				// KASLR disabled? just proceed
 	orr	x23, x23, x0			// record KASLR offset
diff --git a/arch/arm64/kernel/kaslr.c b/arch/arm64/kernel/kaslr.c
index 1c74c45b9494..5fc86e7d01a1 100644
--- a/arch/arm64/kernel/kaslr.c
+++ b/arch/arm64/kernel/kaslr.c
@@ -19,6 +19,7 @@
 #include <asm/memory.h>
 #include <asm/mmu.h>
 #include <asm/sections.h>
+#include <asm/setup.h>
 
 enum kaslr_status {
 	KASLR_ENABLED,
@@ -92,12 +93,11 @@ static __init bool is_kaslr_disabled_cmdline(void *fdt)
  * containing function pointers) to be reinitialized, and zero-initialized
  * .bss variables will be reset to 0.
  */
-u64 __init kaslr_early_init(u64 dt_phys)
+u64 __init kaslr_early_init(void)
 {
 	void *fdt;
 	u64 seed, offset, mask, module_range;
 	unsigned long raw;
-	int size;
 
 	/*
 	 * Set a reasonable default for module_alloc_base in case
@@ -111,8 +111,7 @@ u64 __init kaslr_early_init(u64 dt_phys)
 	 * and proceed with KASLR disabled. We will make another
 	 * attempt at mapping the FDT in setup_machine()
 	 */
-	early_fixmap_init();
-	fdt = fixmap_remap_fdt(dt_phys, &size, PAGE_KERNEL);
+	fdt = get_early_fdt_ptr();
 	if (!fdt) {
 		kaslr_status = KASLR_DISABLED_FDT_REMAP;
 		return 0;
diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
index c18aacde8bb0..61845c0821d9 100644
--- a/arch/arm64/kernel/setup.c
+++ b/arch/arm64/kernel/setup.c
@@ -168,6 +168,21 @@ static void __init smp_build_mpidr_hash(void)
 		pr_warn("Large number of MPIDR hash buckets detected\n");
 }
 
+static void *early_fdt_ptr __initdata;
+
+void __init *get_early_fdt_ptr(void)
+{
+	return early_fdt_ptr;
+}
+
+asmlinkage void __init early_fdt_map(u64 dt_phys)
+{
+	int fdt_size;
+
+	early_fixmap_init();
+	early_fdt_ptr = fixmap_remap_fdt(dt_phys, &fdt_size, PAGE_KERNEL);
+}
+
 static void __init setup_machine_fdt(phys_addr_t dt_phys)
 {
 	int size;
-- 
2.29.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
