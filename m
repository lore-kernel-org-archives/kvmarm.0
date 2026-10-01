Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEE583A5E64
	for <kvmarm@lists.linux.dev>; Thu,  1 Oct 2026 15:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790867831; cv=none; b=W+aeM4iMLE8idD81O/0vtznjujUanvJubu9z3crI2pfPj1PeHVme28fMvtyqKUFfpa0+vKSCZPL0UVedVLO1d8iVG1t/ncpodCkasvZ+Szp0c+HbglKYISomAeJUHd77jIzrAzaD87utNROVA3j+25mjX5G7SGYE3CXlR8X0L48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790867831; c=relaxed/simple;
	bh=vxfPWEUWaXRC7zvHf1jN9oSEcj82yToOKDaG5szzfI0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=btsxeKGAVXbNazyhR4vz6HZ6p3qi8KHxxnC5B0KpMJxIo4l0gfEVFCV0StR825ZieAehyJGBzJltm/ZbfDafsDI+YmwpE5veuZzyzTzXUjtx77BnQpZ+YC6fShjrIpt2t9yAWTT6Hoygmseo+HHFJywtEqp2YyAOIcfEthwmmqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=s+nc6wxZ; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="s+nc6wxZ"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 10642497;
	Thu,  1 Oct 2026 08:17:06 -0700 (PDT)
Received: from e143914.cambridge.arm.com (e143914.arm.com [10.2.213.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2A5FE3F86F;
	Thu,  1 Oct 2026 08:17:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790867829; bh=vxfPWEUWaXRC7zvHf1jN9oSEcj82yToOKDaG5szzfI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s+nc6wxZnlBnq6r7gLOq2KZbTN9zcM3fj0OibekUFehZX8ve8EUBfoNysIbwxqXHa
	 0ddt1G82giG8FCRyhEyQm6Rs7NqcBlew8oAmfMYJpjSwhzeiiXugw9nl/4p4szk4d3
	 KqyM4VRbGOahhNKjVa7w6t9qKc1p+C938Y7w55I0=
From: Joey Gouly <joey.gouly@arm.com>
To: kvmarm@lists.linux.dev
Cc: Jing Zhang <jingzhangos@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Mark Brown <broonie@kernel.org>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	andrew.jones@linux.dev,
	Joey Gouly <joey.gouly@arm.com>
Subject: [PATCH v3 8/8] arm64: Add basic guest execution tests
Date: Thu,  1 Oct 2026 16:16:45 +0100
Message-ID: <20261001151645.2427065-9-joey.gouly@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261001151645.2427065-1-joey.gouly@arm.com>
References: <20261001151645.2427065-1-joey.gouly@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add tests that verify that EL2 and EL1 exits can inspect and modify
guest registers.

Assisted-by: LLM
Signed-off-by: Joey Gouly <joey.gouly@arm.com>
---
 arm/Makefile.arm64  |   1 +
 arm/guest-test.c    | 157 ++++++++++++++++++++++++++++++++++++++++++++
 lib/arm64/asm/esr.h |   3 +
 3 files changed, 161 insertions(+)
 create mode 100644 arm/guest-test.c

diff --git a/arm/Makefile.arm64 b/arm/Makefile.arm64
index e547f92d..5c329588 100644
--- a/arm/Makefile.arm64
+++ b/arm/Makefile.arm64
@@ -68,6 +68,7 @@ tests += $(TEST_DIR)/debug.$(exe)
 tests += $(TEST_DIR)/fpu.$(exe)
 tests += $(TEST_DIR)/mte.$(exe)
 tests += $(TEST_DIR)/stage2-mmu-test.$(exe)
+tests += $(TEST_DIR)/guest-test.$(exe)
 
 include $(SRCDIR)/$(TEST_DIR)/Makefile.common
 
diff --git a/arm/guest-test.c b/arm/guest-test.c
new file mode 100644
index 00000000..90676bdf
--- /dev/null
+++ b/arm/guest-test.c
@@ -0,0 +1,157 @@
+/*
+ * SPDX-License-Identifier: LGPL-2.0-or-later
+ *
+ * Copyright (C) 2026 Arm Ltd.
+ */
+#include <libcflat.h>
+#include <asm/guest.h>
+#include <asm/io.h>
+#include <asm/smp.h>
+#include <asm/sysreg.h>
+
+#define HVC_FIRST_EXIT		0x101
+#define HVC_SECOND_EXIT		0x102
+#define HVC_EL1_DONE		0x103
+#define HVC_BAD_EXIT		0x104
+#define EL1_BRK_IMM		0x321
+#define INITIAL_VALUE		0x123
+#define RESUME_VALUE		0x456
+#define EL1_RESUME_VALUE	0x789
+#define TPIDR_EL2_VALUE		0x12345678
+
+static void guest_resume_entry(void)
+{
+	unsigned long value;
+
+	/* Place a specific value in x0, and re-read x0 after the HVC */
+	asm volatile(
+		"mov x0, %1\n"
+		"hvc %2\n"
+		"mov %0, x0"
+		: "=r" (value)
+		: "r" (INITIAL_VALUE), "i" (HVC_FIRST_EXIT)
+		: "x0", "memory");
+
+	if (value == RESUME_VALUE)
+		asm volatile("hvc %0" :: "i" (HVC_SECOND_EXIT));
+	else
+		asm volatile("hvc %0" :: "i" (HVC_BAD_EXIT));
+}
+
+static void guest_el1_exception_entry(void)
+{
+	unsigned long value;
+
+	// BRK, and check that the exception handler modified x0
+	asm volatile(
+		"brk %1\n"
+		"mov %0, x0"
+		: "=r" (value)
+		: "i" (EL1_BRK_IMM)
+		: "x0", "memory");
+
+	if (value == EL1_RESUME_VALUE) {
+		asm volatile(
+			"mov x0, %0\n"
+			"hvc %1"
+			:
+			: "r" (value), "i" (HVC_EL1_DONE)
+			: "x0", "memory");
+	} else {
+		asm volatile("hvc %0" :: "i" (HVC_BAD_EXIT));
+	}
+}
+
+static bool guest_exited_with_hvc(const struct guest *guest,
+				  unsigned long expected_imm)
+{
+	unsigned long ec = guest->esr_el2 >> ESR_ELx_EC_SHIFT;
+	unsigned long imm = guest->esr_el2 & ESR_ELx_ISS_IMM_MASK;
+
+	return ec == ESR_ELx_EC_HVC64 && imm == expected_imm;
+}
+
+static enum guest_handler_result guest_sync_handler(struct guest *guest)
+{
+	if (guest_exited_with_hvc(guest, HVC_FIRST_EXIT) &&
+	    guest->x[0] == INITIAL_VALUE)
+		guest->x[0] = RESUME_VALUE;
+
+	return GUEST_ACTION_EXIT;
+}
+
+static void guest_el1_sync_handler(struct guest_el1_regs *regs,
+				   unsigned int esr)
+{
+	unsigned long ec = esr >> ESR_ELx_EC_SHIFT;
+	unsigned long imm = esr & ESR_ELx_ISS_IMM_MASK;
+
+	if (ec == ESR_ELx_EC_BRK64 && imm == EL1_BRK_IMM)
+		regs->regs[0] = EL1_RESUME_VALUE;
+	else
+		regs->regs[0] = 0;
+
+	regs->elr += 4;
+}
+
+static void test_guest_resume(void)
+{
+	unsigned long old_tpidr_el2 = read_sysreg(tpidr_el2);
+	struct guest *guest;
+	bool tpidr_restored;
+
+	guest = guest_create_identity(smp_processor_id(), guest_resume_entry,
+				      S2_PAGE_4K);
+	assert(guest);
+	guest_install_handler(guest, ELx_LOW_SYNC_64, guest_sync_handler);
+
+	guest_run(guest);
+	report(guest_exited_with_hvc(guest, HVC_FIRST_EXIT) &&
+	       guest->x[0] == RESUME_VALUE,
+	       "exit handler changes guest register state");
+
+	write_sysreg(0, elr_el2);
+	write_sysreg(TPIDR_EL2_VALUE, tpidr_el2);
+	guest_run(guest);
+	tpidr_restored = read_sysreg(tpidr_el2) == TPIDR_EL2_VALUE;
+	write_sysreg(old_tpidr_el2, tpidr_el2);
+
+	report(guest_exited_with_hvc(guest, HVC_SECOND_EXIT),
+	       "guest resumes with its saved PC and register state");
+	report(tpidr_restored, "guest run restores host TPIDR_EL2");
+
+	guest_destroy(guest);
+}
+
+static void test_guest_el1_exception(void)
+{
+	struct guest *guest;
+
+	guest = guest_create_identity(smp_processor_id(),
+				      guest_el1_exception_entry, S2_PAGE_4K);
+	assert(guest);
+	guest_install_handler(guest, ELx_LOW_SYNC_64, guest_sync_handler);
+	guest_install_el1_handler(guest, ELxH_SYNC, guest_el1_sync_handler);
+
+	guest_run(guest);
+	report(guest_exited_with_hvc(guest, HVC_EL1_DONE) &&
+	       guest->x[0] == EL1_RESUME_VALUE,
+	       "guest handles an EL1 synchronous exception");
+
+	guest_destroy(guest);
+}
+
+int main(int argc, char **argv)
+{
+	report_prefix_push("guest");
+
+	if (current_level() != CurrentEL_EL2) {
+		report_skip("EL2 is required");
+		return report_summary();
+	}
+
+	test_guest_resume();
+	test_guest_el1_exception();
+
+	return report_summary();
+}
diff --git a/lib/arm64/asm/esr.h b/lib/arm64/asm/esr.h
index 3860eb9d..02a27c24 100644
--- a/lib/arm64/asm/esr.h
+++ b/lib/arm64/asm/esr.h
@@ -72,4 +72,7 @@
 #define ESR_ELx_FSC		(0x3F)
 #define ESR_ELx_FSC_EXTABT	(0x10)
 
+/* Immediate field for HVC, SVC, and BRK instructions. */
+#define ESR_ELx_ISS_IMM_MASK	GENMASK(15, 0)
+
 #endif /* _ASMARM64_ESR_H_ */
-- 
2.43.0

