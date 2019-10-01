Return-Path: <SRS0=C9Vx=X2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0DCCECE58B
	for <kvmarm@archiver.kernel.org>; Tue,  1 Oct 2019 10:23:49 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A9D5221920
	for <kvmarm@archiver.kernel.org>; Tue,  1 Oct 2019 10:23:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A9D5221920
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 62B6B4A695;
	Tue,  1 Oct 2019 06:23:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YARw+5Eecudr; Tue,  1 Oct 2019 06:23:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1A74F4A6F5;
	Tue,  1 Oct 2019 06:23:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 55FA94A609
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Oct 2019 06:23:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2R5pZY-QpMhF for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 Oct 2019 06:23:46 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8BB354A6DF
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Oct 2019 06:23:45 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4CFE81570;
 Tue,  1 Oct 2019 03:23:45 -0700 (PDT)
Received: from e123195-lin.cambridge.arm.com (e123195-lin.cambridge.arm.com
 [10.1.196.63])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 1282C3F739;
 Tue,  1 Oct 2019 03:23:43 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.cs.columbia.edu
Subject: [kvm-unit-tests RFC PATCH v2 05/19] arm/arm64: selftest: Add prefetch
 abort test
Date: Tue,  1 Oct 2019 11:23:09 +0100
Message-Id: <20191001102323.27628-6-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191001102323.27628-1-alexandru.elisei@arm.com>
References: <20191001102323.27628-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Cc: maz@kernel.org, andre.przywara@arm.com, pbonzini@redhat.com
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

When a guest tries to execute code from MMIO memory, KVM injects an
external abort into that guest. We have now fixed the psci test to not
fetch instructions from the I/O region, and it's not that often that a
guest misbehaves in such a way. Let's expand our coverage by adding a
proper test targetting this corner case.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
Changes:
* Folded prep_io_exec into check_pabt because the code paths for arm and
  arm64 had nothing in common anymore.
* Took a closer look at the ARM ARM (for both architectures) and it turns
  out that a full TLB invalidation is required when changing SCTLR.WXN. And
  user writable pages implies PXN only on arm64.
* Kept the flush_dcache_addr after changing the tables in check_pabt
  because removing the dcache maintenance when updating the tables is a bit
  more involved; working on a patch series to fix that and other things,
  will update this once it gets merged.

 lib/arm64/asm/esr.h |   3 ++
 arm/selftest.c      | 102 ++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 102 insertions(+), 3 deletions(-)

diff --git a/lib/arm64/asm/esr.h b/lib/arm64/asm/esr.h
index 8e5af4d90767..8c351631b0a0 100644
--- a/lib/arm64/asm/esr.h
+++ b/lib/arm64/asm/esr.h
@@ -44,4 +44,7 @@
 #define ESR_EL1_EC_BKPT32	(0x38)
 #define ESR_EL1_EC_BRK64	(0x3C)
 
+#define ESR_EL1_FSC_MASK	(0x3F)
+#define ESR_EL1_FSC_EXTABT	(0x10)
+
 #endif /* _ASMARM64_ESR_H_ */
diff --git a/arm/selftest.c b/arm/selftest.c
index 28a17f7a7531..cdf2d1f2badb 100644
--- a/arm/selftest.c
+++ b/arm/selftest.c
@@ -16,6 +16,8 @@
 #include <asm/psci.h>
 #include <asm/smp.h>
 #include <asm/barrier.h>
+#include <asm/mmu.h>
+#include <asm/pgtable.h>
 
 static void __user_psci_system_off(void)
 {
@@ -60,9 +62,11 @@ static void check_setup(int argc, char **argv)
 		report_abort("missing input");
 }
 
+
 static struct pt_regs expected_regs;
 static bool und_works;
 static bool svc_works;
+static bool pabt_works;
 #if defined(__arm__)
 /*
  * Capture the current register state and execute an instruction
@@ -86,7 +90,7 @@ static bool svc_works;
 		"str	r1, [r0, #" xstr(S_PC) "]\n"		\
 		excptn_insn "\n"				\
 		post_insns "\n"					\
-	:: "r" (&expected_regs) : "r0", "r1")
+	:: "r" (&expected_regs) : "r0", "r1", "r2")
 
 static bool check_regs(struct pt_regs *regs)
 {
@@ -166,6 +170,45 @@ static void user_psci_system_off(struct pt_regs *regs)
 {
 	__user_psci_system_off();
 }
+
+static void check_pabt_exit(void)
+{
+	install_exception_handler(EXCPTN_PABT, NULL);
+
+	report("pabt", pabt_works);
+	exit(report_summary());
+}
+
+static void pabt_handler(struct pt_regs *regs)
+{
+	expected_regs.ARM_pc = 0;
+	pabt_works = check_regs(regs);
+
+	regs->ARM_pc = (unsigned long)&check_pabt_exit;
+}
+
+static void check_pabt(void)
+{
+	unsigned long sctlr;
+
+	/* Make sure we can actually execute from a writable region */
+	asm volatile("mrc p15, 0, %0, c1, c0, 0": "=r" (sctlr));
+	if (sctlr & CR_ST) {
+		sctlr &= ~CR_ST;
+		asm volatile("mcr p15, 0, %0, c1, c0, 0" :: "r" (sctlr));
+		isb();
+		/*
+		 * Required according to the sequence in ARM DDI 0406C.d, page
+		 * B3-1358.
+		 */
+		flush_tlb_all();
+	}
+
+	install_exception_handler(EXCPTN_PABT, pabt_handler);
+
+	test_exception("mov r2, #0x0", "bx r2", "");
+	__builtin_unreachable();
+}
 #elif defined(__aarch64__)
 
 /*
@@ -207,7 +250,7 @@ static void user_psci_system_off(struct pt_regs *regs)
 		"stp	 x0,  x1, [x1]\n"			\
 	"1:"	excptn_insn "\n"				\
 		post_insns "\n"					\
-	:: "r" (&expected_regs) : "x0", "x1")
+	:: "r" (&expected_regs) : "x0", "x1", "x2")
 
 static bool check_regs(struct pt_regs *regs)
 {
@@ -283,6 +326,57 @@ static bool check_svc(void)
 	return svc_works;
 }
 
+static void check_pabt_exit(void)
+{
+	install_exception_handler(EL1H_SYNC, ESR_EL1_EC_IABT_EL1, NULL);
+
+	report("pabt", pabt_works);
+	exit(report_summary());
+}
+
+static void pabt_handler(struct pt_regs *regs, unsigned int esr)
+{
+	bool is_extabt;
+
+	expected_regs.pc = 0;
+	is_extabt = (esr & ESR_EL1_FSC_MASK) == ESR_EL1_FSC_EXTABT;
+	pabt_works = check_regs(regs) && is_extabt;
+
+	regs->pc = (u64)&check_pabt_exit;
+}
+
+extern pgd_t *mmu_idmap;
+static void check_pabt(void)
+{
+	pgd_t *pgd = pgd_offset(mmu_idmap, 0);
+	enum vector v = check_vector_prep();
+	unsigned long sctlr;
+
+	/*
+	 * According to ARM DDI 0487E.a, table D5-33, footnote c, all regions
+	 * writable at EL0 are treated as PXN. Clear the user bit so we can
+	 * execute code from the bottom I/O space (0G-1G) to simulate a
+	 * misbehaved guest.
+	 */
+	pgd_val(*pgd) &= ~PMD_SECT_USER;
+	flush_dcache_addr(0);
+	flush_tlb_page(0);
+
+	/* Make sure we can actually execute from a writable region */
+	sctlr = read_sysreg(sctlr_el1);
+	if (sctlr & SCTLR_EL1_WXN) {
+		write_sysreg(sctlr & ~SCTLR_EL1_WXN, sctlr_el1);
+		isb();
+		/* SCTLR_EL1.WXN is permitted to be cached in a TLB. */
+		flush_tlb_all();
+	}
+
+	install_exception_handler(v, ESR_EL1_EC_IABT_EL1, pabt_handler);
+
+	test_exception("mov x2, xzr", "br x2", "");
+	__builtin_unreachable();
+}
+
 static void user_psci_system_off(struct pt_regs *regs, unsigned int esr)
 {
 	__user_psci_system_off();
@@ -293,7 +387,9 @@ static void check_vectors(void *arg __unused)
 {
 	report("und", check_und());
 	report("svc", check_svc());
-	if (is_user()) {
+	if (!is_user()) {
+		check_pabt();
+	} else {
 #ifdef __arm__
 		install_exception_handler(EXCPTN_UND, user_psci_system_off);
 #else
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
