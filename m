Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 043463A874F
	for <kvmarm@lists.linux.dev>; Fri,  6 Mar 2026 14:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772807232; cv=none; b=XEI+iX85JEbOrU50iktF/hk1RseqtQr0w2/Mq7355SVNplKBmCQebXRJrLezLo5zv/BzoFY9qMvQrmJmcV3Evd57VPnR7NYtAOI6YGxGn29WyBetDeer8bNs2Ax7WVFqNV6bLQHIcG3zD9jxfcMgA0tUzW3LAwgV2r810TgAdlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772807232; c=relaxed/simple;
	bh=s9cFRLun5hJ71k9jYqka5jgAk7rrrT+0wgY5WDcC0w8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DHlaa8IFc20lw8wAGv+JHkyg7zpRGci5aDJWjJY/iy7JGbzkD8iEq8XXFRZTW4ZRhkE/8QTdMUYl7OW2UgH93BfSJZSh0L9gvOBSdrSk8gOtwmUT/qdFg1/taPVgy+W57RHwmIuiqBY8cPgYpaGnrCU5uZnWfo8sibxjFeHUHsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7B8E41684;
	Fri,  6 Mar 2026 06:27:03 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DB5283F73B;
	Fri,  6 Mar 2026 06:27:08 -0800 (PST)
From: Joey Gouly <joey.gouly@arm.com>
To: kvmarm@lists.linux.dev
Cc: joey.gouly@arm.com,
	andrew.jones@linux.dev,
	alexandru.elisei@arm.com,
	Marc Zyngier <maz@kernel.org>
Subject: [kvm-unit-tests PATCH v1 4/5] arm64: add EL0/EL1 guest functionality
Date: Fri,  6 Mar 2026 14:26:55 +0000
Message-Id: <20260306142656.2775185-5-joey.gouly@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260306142656.2775185-1-joey.gouly@arm.com>
References: <20260306142656.2775185-1-joey.gouly@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add functions run_in_el1() and run_in_el0(), these take a function pointer
argument to run in EL1/EL0 respectively.

For EL1 the TTBRs are copied from EL2 to EL1, so they share the same address
space. This could be extended in the future to support more complicated cases
where a separate address space / Stage-2 is needed.

Signed-off-by: Joey Gouly <joey.gouly@arm.com>
---
 arm/Makefile.arm64     |  1 +
 arm/cstart64.S         | 38 ++++++++++++++++++++++++
 lib/arm64/asm/esr.h    |  2 ++
 lib/arm64/asm/guest.h  | 14 +++++++++
 lib/arm64/asm/sysreg.h |  6 ++++
 lib/arm64/guest.c      | 67 ++++++++++++++++++++++++++++++++++++++++++
 lib/arm64/processor.c  |  2 ++
 7 files changed, 130 insertions(+)
 create mode 100644 lib/arm64/asm/guest.h
 create mode 100644 lib/arm64/guest.c

diff --git a/arm/Makefile.arm64 b/arm/Makefile.arm64
index a40c830d..c7a39945 100644
--- a/arm/Makefile.arm64
+++ b/arm/Makefile.arm64
@@ -36,6 +36,7 @@ define arch_elf_check =
 endef
 
 cstart.o = $(TEST_DIR)/cstart64.o
+cflatobjs += lib/arm64/guest.o
 cflatobjs += lib/arm64/stack.o
 cflatobjs += lib/arm64/processor.o
 cflatobjs += lib/arm64/spinlock.o
diff --git a/arm/cstart64.S b/arm/cstart64.S
index d95a8245..05303149 100644
--- a/arm/cstart64.S
+++ b/arm/cstart64.S
@@ -370,6 +370,44 @@ asm_mmu_disable:
 
 	ret
 
+.globl __run_in_el1
+__run_in_el1:
+	stp	x29, x30, [sp, #-16]!
+	mov	x5, PSR_MODE_EL1h
+	msr	spsr_el2, x5
+	adrp	x5, el1_mode
+	add	x5, x5, :lo12:el1_mode
+	msr	elr_el2, x5
+	msr	sp_el1, x1
+	isb
+	eret
+el1_mode:
+	blr x0
+	/* This HVC is executed from EL1, and returns back to EL2 */
+	hvc #0
+	ldp	x29, x30, [sp], #16
+	ret
+
+.globl __run_in_el0
+__run_in_el0:
+	stp	x29, x30, [sp, #-16]!
+	mov	x5, PSR_MODE_EL0t
+	msr	spsr_el1, x5
+	adrp	x5, el0_mode
+	add	x5, x5, :lo12:el0_mode
+	msr	elr_el1, x5
+	msr	sp_el0, x1
+	isb
+	eret
+el0_mode:
+	blr x0
+	/* This SVC is executed from EL0, and returns back to EL1, or EL2 for
+	 * EL2&0 regime */
+	svc #0
+	ldp	x29, x30, [sp], #16
+	ret
+
+
 /*
  * Vectors
  */
diff --git a/lib/arm64/asm/esr.h b/lib/arm64/asm/esr.h
index 335343c5..12bb0efe 100644
--- a/lib/arm64/asm/esr.h
+++ b/lib/arm64/asm/esr.h
@@ -25,6 +25,8 @@
 #define ESR_EL1_EC_ILL_ISS	(0x0E)
 #define ESR_EL1_EC_SVC32	(0x11)
 #define ESR_EL1_EC_SVC64	(0x15)
+#define ESR_EL2_EC_HVC64       (0x16)
+#define ESR_EL2_EC_SMC64       (0x17)
 #define ESR_EL1_EC_SYS64	(0x18)
 #define ESR_EL1_EC_SVE		(0x19)
 #define ESR_EL1_EC_IABT_EL0	(0x20)
diff --git a/lib/arm64/asm/guest.h b/lib/arm64/asm/guest.h
new file mode 100644
index 00000000..82d1f2ae
--- /dev/null
+++ b/lib/arm64/asm/guest.h
@@ -0,0 +1,14 @@
+#ifndef GUEST_H
+#define GUEST_H
+
+#include <asm/ptrace.h>
+
+u64 run_in_el1(int (*func)(void));
+u64 run_in_el0(int (*func)(void));
+
+static inline void step_trapped_instruction(struct pt_regs *regs)
+{
+     regs->pc += 4;
+}
+
+#endif
diff --git a/lib/arm64/asm/sysreg.h b/lib/arm64/asm/sysreg.h
index ba33fcd9..498eef4e 100644
--- a/lib/arm64/asm/sysreg.h
+++ b/lib/arm64/asm/sysreg.h
@@ -132,6 +132,12 @@ asm(
 #define SYS_HFGWTR2_EL2		sys_reg(3, 4, 3, 1, 3)
 #define SYS_HFGITR2_EL2		sys_reg(3, 4, 3, 1, 7)
 
+#define SYS_SCTLR_EL12		sys_reg(3, 5, 1, 0, 0)
+#define SYS_TCR_EL12		sys_reg(3, 5, 2, 0, 2)
+#define SYS_TTBR0_EL12		sys_reg(3, 5, 2, 0, 0)
+#define SYS_TTBR1_EL12		sys_reg(3, 5, 2, 0, 1)
+#define SYS_VBAR_EL12		sys_reg(3, 5, 12, 0, 0)
+
 #define SPSR_EL2_M	0xf
 
 #define INIT_SCTLR_EL1_MMU_OFF	\
diff --git a/lib/arm64/guest.c b/lib/arm64/guest.c
new file mode 100644
index 00000000..410c6bb0
--- /dev/null
+++ b/lib/arm64/guest.c
@@ -0,0 +1,67 @@
+#include <asm/guest.h>
+#include <asm/processor.h>
+#include <asm/thread_info.h>
+
+u64 __run_in_el1(int (*func)(void), void*);
+u64 __run_in_el0(int (*func)(void), void*);
+
+static void ret_to_el1(struct pt_regs *regs, unsigned int esr)
+{
+	regs->pstate = PSR_MODE_EL1h | PSR_D_BIT | PSR_A_BIT | PSR_I_BIT | PSR_F_BIT;
+}
+
+static void ret_to_el2(struct pt_regs *regs, unsigned int esr)
+{
+	regs->pstate = PSR_MODE_EL2h | PSR_D_BIT | PSR_A_BIT | PSR_I_BIT | PSR_F_BIT;
+}
+
+static void copy_el2_sysregs_to_el1(void) {
+	write_sysreg_s(read_sysreg(VBAR_EL1), SYS_VBAR_EL12);
+	write_sysreg_s(read_sysreg(TTBR1_EL1), SYS_TTBR1_EL12);
+	write_sysreg_s(read_sysreg(TTBR0_EL1), SYS_TTBR0_EL12);
+	write_sysreg_s(read_sysreg(TCR_EL1), SYS_TCR_EL12);
+	write_sysreg_s(read_sysreg(SCTLR_EL1), SYS_SCTLR_EL12);
+}
+
+static struct thread_info* new_thread(void) {
+	u64 stack_start = (uint64_t) thread_stack_alloc();
+
+	struct thread_info* ti = thread_info_sp(stack_start);
+
+	thread_info_init(ti, TIF_USER_MODE);
+	ti->pgtable = current_thread_info()->pgtable;
+
+	return ti;
+}
+
+u64 run_in_el1(int (*func)(void)) {
+	u64 ret;
+	struct thread_info* ti;
+
+	copy_el2_sysregs_to_el1();
+
+	// HVC is used to exit EL1 guests.
+	install_exception_handler(EL0_SYNC_64, ESR_EL2_EC_HVC64, ret_to_el2);
+	ti = new_thread();
+	ret = __run_in_el1(func, thread_info_stack_start(ti));
+	install_exception_handler(EL0_SYNC_64, ESR_EL2_EC_HVC64, NULL);
+	thread_info_free(ti);
+
+	return ret;
+}
+
+u64 run_in_el0(int (*func)(void)) {
+	u64 ret;
+	struct thread_info* ti;
+
+	// SVC is used to exit EL0 guests.
+	// For the EL1&0 regime it returns to EL1, for EL2&0 it returns to EL2.
+	install_exception_handler(EL0_SYNC_64, ESR_EL1_EC_SVC64,
+		current_level() == CurrentEL_EL1 ? ret_to_el1 : ret_to_el2);
+	ti = new_thread();
+	ret = __run_in_el0(func, thread_info_stack_start(ti));
+	install_exception_handler(EL0_SYNC_64, ESR_EL1_EC_SVC64, NULL);
+	thread_info_free(ti);
+
+	return ret;
+}
diff --git a/lib/arm64/processor.c b/lib/arm64/processor.c
index 7d3d93bf..e074ba96 100644
--- a/lib/arm64/processor.c
+++ b/lib/arm64/processor.c
@@ -43,6 +43,8 @@ static const char *ec_names[EC_MAX] = {
 	[ESR_EL1_EC_ILL_ISS]		= "ILL_ISS",
 	[ESR_EL1_EC_SVC32]		= "SVC32",
 	[ESR_EL1_EC_SVC64]		= "SVC64",
+	[ESR_EL2_EC_HVC64]              = "HVC64",
+	[ESR_EL2_EC_SMC64]		= "SMC64",
 	[ESR_EL1_EC_SYS64]		= "SYS64",
 	[ESR_EL1_EC_SVE]		= "SVE",
 	[ESR_EL1_EC_IABT_EL0]		= "IABT_EL0",
-- 
2.25.1

