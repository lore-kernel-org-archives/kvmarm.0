Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1847E3D170D
	for <kvmarm@lists.linux.dev>; Wed, 22 Apr 2026 13:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776863332; cv=none; b=kpkwErFxz0hOAbW98kBftXjWEo3xd+wNzqySn4FhBcb4g76lt0+0mHt82jE4WBschlaKmPb8qmAeNjyqo3Drp8zQSolPdbO1i6Szn9EvniDanVWFEJeqLK9J6BA9sTgrohjXypyCll48+8fyHolJ777mXjVlPe6h3GoZ5MG1lJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776863332; c=relaxed/simple;
	bh=ORY/jwxr6I27+WNlj9qRYkj46DlAvOJZnjcRKLzaVOw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=dZh20huv3v1DYEZtrNLJs/hC0WaMIyyfaKLpoO59Ujm6Qg2Say5vZThtQiAUpZC7M3Amw+bUm+otqFPChOg1SHiPnxX+FTXhY67LKYJeB3zyVJhCoBBEohZMXuVAiA4MAjcADlEotKnhjdVQjj/wheevETHCx704SyJd5bARInw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=rHavycQl; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="rHavycQl"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6E48322D9;
	Wed, 22 Apr 2026 06:08:36 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C7A793FD46;
	Wed, 22 Apr 2026 06:08:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1776863322; bh=ORY/jwxr6I27+WNlj9qRYkj46DlAvOJZnjcRKLzaVOw=;
	h=From:To:Cc:Subject:Date:From;
	b=rHavycQlR4JBPh+bcq6j3dQ2pKEMadVKhYWExMLrOaPgLQamw0E+0v2eNBwzCFupL
	 o081SqGn38A6WuRFZCtX+YHvktWDi417EKvf6ksV/hBnjX9+774nn5ks+wsEhzU9s7
	 WOK8qt5zwSzNp9s2ATxK6X1nM2iF0jwA2BbU8ajM=
From: Joey Gouly <joey.gouly@arm.com>
To: kvmarm@lists.linux.dev
Cc: jingzhangos@google.com,
	joey.gouly@arm.com,
	andrew.jones@linux.dev,
	alexandru.elisei@arm.com,
	Marc Zyngier <maz@kernel.org>
Subject: [kvm-unit-tests PATCH v1] arm64: update ESR_ELx definitions to match Linux kernel
Date: Wed, 22 Apr 2026 14:08:20 +0100
Message-Id: <20260422130820.4023122-1-joey.gouly@arm.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

kvm-unit-test supports EL2, so replace the ESR_EL1* names with ESR_ELx.

This section was copied from arch/arm64/include/asm/esr.h, as was the previous
contents of the file.

Signed-off-by: Joey Gouly <joey.gouly@arm.com>
Cc: Jing Zhang <jingzhangos@google.com>
---

Hi,

This is a patch to help with the EL2 stage2 mmu series, replacing patch
1 [1].

Thanks,
Joey

[1] https://lore.kernel.org/kvmarm/20260413204630.1149038-2-jingzhangos@google.com/

 arm/mte.c             |   6 +--
 arm/psci.c            |   2 +-
 arm/selftest.c        |  16 +++----
 arm/timer.c           |   4 +-
 lib/arm64/asm/esr.h   | 100 ++++++++++++++++++++++++++----------------
 lib/arm64/processor.c |  82 +++++++++++++++++-----------------
 6 files changed, 117 insertions(+), 93 deletions(-)

diff --git a/arm/mte.c b/arm/mte.c
index a1bed8a7..35707fc6 100644
--- a/arm/mte.c
+++ b/arm/mte.c
@@ -192,7 +192,7 @@ static void mte_sync_test(void)
 
 	mte_exception = false;
 
-	install_exception_handler(EL1H_SYNC, ESR_EL1_EC_DABT_EL1, mte_fault_handler);
+	install_exception_handler(EL1H_SYNC, ESR_ELx_EC_DABT_CUR, mte_fault_handler);
 
 	mem_read(tagged(mem, 2), &val);
 
@@ -218,12 +218,12 @@ static void mte_asymm_test(void)
 	mte_set_tcf(MTE_TCF_ASYMM);
 	mte_exception = false;
 
-	install_exception_handler(EL1H_SYNC, ESR_EL1_EC_DABT_EL1, mte_fault_handler);
+	install_exception_handler(EL1H_SYNC, ESR_ELx_EC_DABT_CUR, mte_fault_handler);
 
 	mem_read(tagged(mem, 3), &val);
 	report((val == 0) && mte_exception && (get_clear_tfsr() == 0), "read");
 
-	install_exception_handler(EL1H_SYNC, ESR_EL1_EC_DABT_EL1, NULL);
+	install_exception_handler(EL1H_SYNC, ESR_ELx_EC_DABT_CUR, NULL);
 
 	mem_write(tagged(mem, 4), 0xaaaaaaaa);
 	report((*mem == 0xaaaaaaaa) && (get_clear_tfsr() == TFSR_EL1_TF0), "write");
diff --git a/arm/psci.c b/arm/psci.c
index 55308c8f..5800c0ac 100644
--- a/arm/psci.c
+++ b/arm/psci.c
@@ -36,7 +36,7 @@ static void install_invalid_function_handler(exception_fn handler)
 #ifdef __arm__
 	install_exception_handler(EXCPTN_UND, handler);
 #else
-	install_exception_handler(EL1H_SYNC, ESR_EL1_EC_UNKNOWN, handler);
+	install_exception_handler(EL1H_SYNC, ESR_ELx_EC_UNKNOWN, handler);
 #endif
 }
 
diff --git a/arm/selftest.c b/arm/selftest.c
index 33f4cf42..0604e530 100644
--- a/arm/selftest.c
+++ b/arm/selftest.c
@@ -326,12 +326,12 @@ static bool check_und(void)
 {
 	enum vector v = check_vector_prep();
 
-	install_exception_handler(v, ESR_EL1_EC_UNKNOWN, unknown_handler);
+	install_exception_handler(v, ESR_ELx_EC_UNKNOWN, unknown_handler);
 
 	/* try to read an el3 sysreg from el0/1/2 */
 	test_exception("", "mrs x0, sctlr_el3", "", "x0");
 
-	install_exception_handler(v, ESR_EL1_EC_UNKNOWN, NULL);
+	install_exception_handler(v, ESR_ELx_EC_UNKNOWN, NULL);
 
 	return und_works;
 }
@@ -348,18 +348,18 @@ static bool check_svc(void)
 {
 	enum vector v = check_vector_prep();
 
-	install_exception_handler(v, ESR_EL1_EC_SVC64, svc_handler);
+	install_exception_handler(v, ESR_ELx_EC_SVC64, svc_handler);
 
 	test_exception("", "svc #123", "");
 
-	install_exception_handler(v, ESR_EL1_EC_SVC64, NULL);
+	install_exception_handler(v, ESR_ELx_EC_SVC64, NULL);
 
 	return svc_works;
 }
 
 static void pabt_handler(struct pt_regs *regs, unsigned int esr)
 {
-	bool is_extabt = (esr & ESR_EL1_FSC_MASK) == ESR_EL1_FSC_EXTABT;
+	bool is_extabt = (esr & ESR_ELx_FSC_MASK) == ESR_ELx_FSC_EXTABT;
 
 	expected_regs.regs[30] = expected_regs.pc + 4;
 	expected_regs.pc = expected_regs.regs[9];
@@ -373,7 +373,7 @@ static bool check_pabt(void)
 {
 	enum vector v = check_vector_prep();
 
-	install_exception_handler(v, ESR_EL1_EC_IABT_EL1, pabt_handler);
+	install_exception_handler(v, ESR_ELx_EC_IABT_CUR, pabt_handler);
 
 	test_exception("adrp	x9, check_pabt_invalid_paddr\n"
 		       "add	x9, x9, :lo12:check_pabt_invalid_paddr\n"
@@ -381,7 +381,7 @@ static bool check_pabt(void)
 		       "blr	x9\n",
 		       "", "x9", "x30");
 
-	install_exception_handler(v, ESR_EL1_EC_IABT_EL1, NULL);
+	install_exception_handler(v, ESR_ELx_EC_IABT_CUR, NULL);
 
 	return pabt_works;
 }
@@ -400,7 +400,7 @@ static void check_vectors(void *arg __unused)
 #ifdef __arm__
 		install_exception_handler(EXCPTN_UND, user_psci_system_off);
 #else
-		install_exception_handler(EL0_SYNC_64, ESR_EL1_EC_UNKNOWN,
+		install_exception_handler(EL0_SYNC_64, ESR_ELx_EC_UNKNOWN,
 					  user_psci_system_off);
 #endif
 	} else {
diff --git a/arm/timer.c b/arm/timer.c
index 43fb6d88..898043f0 100644
--- a/arm/timer.c
+++ b/arm/timer.c
@@ -356,9 +356,9 @@ static void test_init(void)
 		vtimer_info.irq = TIMER_HVTIMER_IRQ;
 	}
 
-	install_exception_handler(EL1H_SYNC, ESR_EL1_EC_UNKNOWN, ptimer_unsupported_handler);
+	install_exception_handler(EL1H_SYNC, ESR_ELx_EC_UNKNOWN, ptimer_unsupported_handler);
 	ptimer_info.read_ctl();
-	install_exception_handler(EL1H_SYNC, ESR_EL1_EC_UNKNOWN, NULL);
+	install_exception_handler(EL1H_SYNC, ESR_ELx_EC_UNKNOWN, NULL);
 
 	if (ptimer_unsupported && !ERRATA(7b6b46311a85)) {
 		report_skip("Skipping ptimer tests. Set ERRATA_7b6b46311a85=y to enable.");
diff --git a/lib/arm64/asm/esr.h b/lib/arm64/asm/esr.h
index 335343c5..629e2e3c 100644
--- a/lib/arm64/asm/esr.h
+++ b/lib/arm64/asm/esr.h
@@ -8,44 +8,68 @@
 #ifndef _ASMARM64_ESR_H_
 #define _ASMARM64_ESR_H_
 
-#define ESR_EL1_WRITE		(1 << 6)
-#define ESR_EL1_CM		(1 << 8)
-#define ESR_EL1_IL		(1 << 25)
+#define ESR_ELx_EC_SHIFT	(26)
+#define ESR_ELx_EC_UNKNOWN      UL(0x00)
+#define ESR_ELx_EC_WFx          UL(0x01)
+/* Unallocated EC: 0x02 */
+#define ESR_ELx_EC_CP15_32      UL(0x03)
+#define ESR_ELx_EC_CP15_64      UL(0x04)
+#define ESR_ELx_EC_CP14_MR      UL(0x05)
+#define ESR_ELx_EC_CP14_LS      UL(0x06)
+#define ESR_ELx_EC_FP_ASIMD     UL(0x07)
+#define ESR_ELx_EC_CP10_ID      UL(0x08)        /* EL2 only */
+#define ESR_ELx_EC_PAC          UL(0x09)        /* EL2 and above */
+#define ESR_ELx_EC_OTHER        UL(0x0A)
+/* Unallocated EC: 0x0B */
+#define ESR_ELx_EC_CP14_64      UL(0x0C)
+#define ESR_ELx_EC_BTI          UL(0x0D)
+#define ESR_ELx_EC_ILL          UL(0x0E)
+/* Unallocated EC: 0x0F - 0x10 */
+#define ESR_ELx_EC_SVC32        UL(0x11)
+#define ESR_ELx_EC_HVC32        UL(0x12)        /* EL2 only */
+#define ESR_ELx_EC_SMC32        UL(0x13)        /* EL2 and above */
+/* Unallocated EC: 0x14 */
+#define ESR_ELx_EC_SVC64        UL(0x15)
+#define ESR_ELx_EC_HVC64        UL(0x16)        /* EL2 and above */
+#define ESR_ELx_EC_SMC64        UL(0x17)        /* EL2 and above */
+#define ESR_ELx_EC_SYS64        UL(0x18)
+#define ESR_ELx_EC_SVE          UL(0x19)
+#define ESR_ELx_EC_ERET         UL(0x1a)        /* EL2 only */
+/* Unallocated EC: 0x1B */
+#define ESR_ELx_EC_FPAC         UL(0x1C)        /* EL1 and above */
+#define ESR_ELx_EC_SME          UL(0x1D)
+/* Unallocated EC: 0x1E */
+#define ESR_ELx_EC_IMP_DEF      UL(0x1f)        /* EL3 only */
+#define ESR_ELx_EC_IABT_LOW     UL(0x20)
+#define ESR_ELx_EC_IABT_CUR     UL(0x21)
+#define ESR_ELx_EC_PC_ALIGN     UL(0x22)
+/* Unallocated EC: 0x23 */
+#define ESR_ELx_EC_DABT_LOW     UL(0x24)
+#define ESR_ELx_EC_DABT_CUR     UL(0x25)
+#define ESR_ELx_EC_SP_ALIGN     UL(0x26)
+#define ESR_ELx_EC_MOPS         UL(0x27)
+#define ESR_ELx_EC_FP_EXC32     UL(0x28)
+/* Unallocated EC: 0x29 - 0x2B */
+#define ESR_ELx_EC_FP_EXC64     UL(0x2C)
+#define ESR_ELx_EC_GCS          UL(0x2D)
+/* Unallocated EC:  0x2E */
+#define ESR_ELx_EC_SERROR       UL(0x2F)
+#define ESR_ELx_EC_BREAKPT_LOW  UL(0x30)
+#define ESR_ELx_EC_BREAKPT_CUR  UL(0x31)
+#define ESR_ELx_EC_SOFTSTP_LOW  UL(0x32)
+#define ESR_ELx_EC_SOFTSTP_CUR  UL(0x33)
+#define ESR_ELx_EC_WATCHPT_LOW  UL(0x34)
+#define ESR_ELx_EC_WATCHPT_CUR  UL(0x35)
+/* Unallocated EC: 0x36 - 0x37 */
+#define ESR_ELx_EC_BKPT32       UL(0x38)
+/* Unallocated EC: 0x39 */
+#define ESR_ELx_EC_VECTOR32     UL(0x3A)        /* EL2 only */
+/* Unallocated EC: 0x3B */
+#define ESR_ELx_EC_BRK64        UL(0x3C)
+/* Unallocated EC: 0x3D - 0x3F */
+#define ESR_ELx_EC_MAX          UL(0x3F)
 
-#define ESR_EL1_EC_SHIFT	(26)
-#define ESR_EL1_EC_UNKNOWN	(0x00)
-#define ESR_EL1_EC_WFI		(0x01)
-#define ESR_EL1_EC_CP15_32	(0x03)
-#define ESR_EL1_EC_CP15_64	(0x04)
-#define ESR_EL1_EC_CP14_MR	(0x05)
-#define ESR_EL1_EC_CP14_LS	(0x06)
-#define ESR_EL1_EC_FP_ASIMD	(0x07)
-#define ESR_EL1_EC_CP10_ID	(0x08)
-#define ESR_EL1_EC_CP14_64	(0x0C)
-#define ESR_EL1_EC_ILL_ISS	(0x0E)
-#define ESR_EL1_EC_SVC32	(0x11)
-#define ESR_EL1_EC_SVC64	(0x15)
-#define ESR_EL1_EC_SYS64	(0x18)
-#define ESR_EL1_EC_SVE		(0x19)
-#define ESR_EL1_EC_IABT_EL0	(0x20)
-#define ESR_EL1_EC_IABT_EL1	(0x21)
-#define ESR_EL1_EC_PC_ALIGN	(0x22)
-#define ESR_EL1_EC_DABT_EL0	(0x24)
-#define ESR_EL1_EC_DABT_EL1	(0x25)
-#define ESR_EL1_EC_SP_ALIGN	(0x26)
-#define ESR_EL1_EC_FP_EXC32	(0x28)
-#define ESR_EL1_EC_FP_EXC64	(0x2C)
-#define ESR_EL1_EC_SERROR	(0x2F)
-#define ESR_EL1_EC_BREAKPT_EL0	(0x30)
-#define ESR_EL1_EC_BREAKPT_EL1	(0x31)
-#define ESR_EL1_EC_SOFTSTP_EL0	(0x32)
-#define ESR_EL1_EC_SOFTSTP_EL1	(0x33)
-#define ESR_EL1_EC_WATCHPT_EL0	(0x34)
-#define ESR_EL1_EC_WATCHPT_EL1	(0x35)
-#define ESR_EL1_EC_BKPT32	(0x38)
-#define ESR_EL1_EC_BRK64	(0x3C)
-
-#define ESR_EL1_FSC_MASK	(0x3F)
-#define ESR_EL1_FSC_EXTABT	(0x10)
+#define ESR_ELx_FSC_MASK	(0x3F)
+#define ESR_ELx_FSC_EXTABT	(0x10)
 
 #endif /* _ASMARM64_ESR_H_ */
diff --git a/lib/arm64/processor.c b/lib/arm64/processor.c
index f9fea519..86328c01 100644
--- a/lib/arm64/processor.c
+++ b/lib/arm64/processor.c
@@ -31,37 +31,37 @@ static const char *vector_names[] = {
 };
 
 static const char *ec_names[EC_MAX] = {
-	[ESR_EL1_EC_UNKNOWN]		= "UNKNOWN",
-	[ESR_EL1_EC_WFI]		= "WFI",
-	[ESR_EL1_EC_CP15_32]		= "CP15_32",
-	[ESR_EL1_EC_CP15_64]		= "CP15_64",
-	[ESR_EL1_EC_CP14_MR]		= "CP14_MR",
-	[ESR_EL1_EC_CP14_LS]		= "CP14_LS",
-	[ESR_EL1_EC_FP_ASIMD]		= "FP_ASMID",
-	[ESR_EL1_EC_CP10_ID]		= "CP10_ID",
-	[ESR_EL1_EC_CP14_64]		= "CP14_64",
-	[ESR_EL1_EC_ILL_ISS]		= "ILL_ISS",
-	[ESR_EL1_EC_SVC32]		= "SVC32",
-	[ESR_EL1_EC_SVC64]		= "SVC64",
-	[ESR_EL1_EC_SYS64]		= "SYS64",
-	[ESR_EL1_EC_SVE]		= "SVE",
-	[ESR_EL1_EC_IABT_EL0]		= "IABT_EL0",
-	[ESR_EL1_EC_IABT_EL1]		= "IABT_EL1",
-	[ESR_EL1_EC_PC_ALIGN]		= "PC_ALIGN",
-	[ESR_EL1_EC_DABT_EL0]		= "DABT_EL0",
-	[ESR_EL1_EC_DABT_EL1]		= "DABT_EL1",
-	[ESR_EL1_EC_SP_ALIGN]		= "SP_ALIGN",
-	[ESR_EL1_EC_FP_EXC32]		= "FP_EXC32",
-	[ESR_EL1_EC_FP_EXC64]		= "FP_EXC64",
-	[ESR_EL1_EC_SERROR]		= "SERROR",
-	[ESR_EL1_EC_BREAKPT_EL0]	= "BREAKPT_EL0",
-	[ESR_EL1_EC_BREAKPT_EL1]	= "BREAKPT_EL1",
-	[ESR_EL1_EC_SOFTSTP_EL0]	= "SOFTSTP_EL0",
-	[ESR_EL1_EC_SOFTSTP_EL1]	= "SOFTSTP_EL1",
-	[ESR_EL1_EC_WATCHPT_EL0]	= "WATCHPT_EL0",
-	[ESR_EL1_EC_WATCHPT_EL1]	= "WATCHPT_EL1",
-	[ESR_EL1_EC_BKPT32]		= "BKPT32",
-	[ESR_EL1_EC_BRK64]		= "BRK64",
+	[ESR_ELx_EC_UNKNOWN]		= "UNKNOWN",
+	[ESR_ELx_EC_WFx]		= "WFx",
+	[ESR_ELx_EC_CP15_32]		= "CP15_32",
+	[ESR_ELx_EC_CP15_64]		= "CP15_64",
+	[ESR_ELx_EC_CP14_MR]		= "CP14_MR",
+	[ESR_ELx_EC_CP14_LS]		= "CP14_LS",
+	[ESR_ELx_EC_FP_ASIMD]		= "FP_ASMID",
+	[ESR_ELx_EC_CP10_ID]		= "CP10_ID",
+	[ESR_ELx_EC_CP14_64]		= "CP14_64",
+	[ESR_ELx_EC_ILL]		= "ILL",
+	[ESR_ELx_EC_SVC32]		= "SVC32",
+	[ESR_ELx_EC_SVC64]		= "SVC64",
+	[ESR_ELx_EC_SYS64]		= "SYS64",
+	[ESR_ELx_EC_SVE]		= "SVE",
+	[ESR_ELx_EC_IABT_LOW]		= "IABT_LOW",
+	[ESR_ELx_EC_IABT_CUR]		= "IABT_CUR",
+	[ESR_ELx_EC_PC_ALIGN]		= "PC_ALIGN",
+	[ESR_ELx_EC_DABT_LOW]		= "DABT_LOW",
+	[ESR_ELx_EC_DABT_CUR]		= "DABT_CUR",
+	[ESR_ELx_EC_SP_ALIGN]		= "SP_ALIGN",
+	[ESR_ELx_EC_FP_EXC32]		= "FP_EXC32",
+	[ESR_ELx_EC_FP_EXC64]		= "FP_EXC64",
+	[ESR_ELx_EC_SERROR]		= "SERROR",
+	[ESR_ELx_EC_BREAKPT_LOW]	= "BREAKPT_LOW",
+	[ESR_ELx_EC_BREAKPT_CUR]	= "BREAKPT_CUR",
+	[ESR_ELx_EC_SOFTSTP_LOW]	= "SOFTSTP_LOW",
+	[ESR_ELx_EC_SOFTSTP_CUR]	= "SOFTSTP_CUR",
+	[ESR_ELx_EC_WATCHPT_LOW]	= "WATCHPT_LOW",
+	[ESR_ELx_EC_WATCHPT_CUR]	= "WATCHPT_CUR",
+	[ESR_ELx_EC_BKPT32]		= "BKPT32",
+	[ESR_ELx_EC_BRK64]		= "BRK64",
 };
 
 void show_regs(struct pt_regs *regs)
@@ -82,18 +82,18 @@ void show_regs(struct pt_regs *regs)
 
 bool get_far(unsigned int esr, unsigned long *far)
 {
-	unsigned int ec = esr >> ESR_EL1_EC_SHIFT;
+	unsigned int ec = esr >> ESR_ELx_EC_SHIFT;
 
 	asm volatile("mrs %0, far_el1": "=r" (*far));
 
 	switch (ec) {
-	case ESR_EL1_EC_IABT_EL0:
-	case ESR_EL1_EC_IABT_EL1:
-	case ESR_EL1_EC_PC_ALIGN:
-	case ESR_EL1_EC_DABT_EL0:
-	case ESR_EL1_EC_DABT_EL1:
-	case ESR_EL1_EC_WATCHPT_EL0:
-	case ESR_EL1_EC_WATCHPT_EL1:
+	case ESR_ELx_EC_IABT_LOW:
+	case ESR_ELx_EC_IABT_CUR:
+	case ESR_ELx_EC_PC_ALIGN:
+	case ESR_ELx_EC_DABT_LOW:
+	case ESR_ELx_EC_DABT_CUR:
+	case ESR_ELx_EC_WATCHPT_LOW:
+	case ESR_ELx_EC_WATCHPT_CUR:
 		if ((esr & 0x3f /* DFSC */) != 0x10
 				|| !(esr & 0x400 /* FnV */))
 			return true;
@@ -108,7 +108,7 @@ static void bad_exception(enum vector v, struct pt_regs *regs,
 {
 	unsigned long far;
 	bool far_valid = get_far(esr, &far);
-	unsigned int ec = esr >> ESR_EL1_EC_SHIFT;
+	unsigned int ec = esr >> ESR_ELx_EC_SHIFT;
 	uintptr_t text = (uintptr_t)&_text;
 
 	printf("Load address: %" PRIxPTR "\n", text);
@@ -158,7 +158,7 @@ void default_vector_sync_handler(enum vector v, struct pt_regs *regs,
 				 unsigned int esr)
 {
 	struct thread_info *ti = thread_info_sp(regs->sp);
-	unsigned int ec = esr >> ESR_EL1_EC_SHIFT;
+	unsigned int ec = esr >> ESR_ELx_EC_SHIFT;
 
 	if (ti->flags & TIF_USER_MODE) {
 		if (ec < EC_MAX && ti->exception_handlers[v][ec]) {
-- 
2.25.1

