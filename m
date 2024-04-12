Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8C7020310;
	Fri, 12 Apr 2024 10:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712918101; cv=none; b=O+5toXEaL2UgO1wMpEvDCgCx96s6XM53xsxVyrm09L6xJXwt0jXeCH1JY9Uhgb/iKYXLefAU6Iad4WAJ6qvu4+RwAjQOh2zACZtGoJzKCiAUlZgVoYrkpbZFOm6wIDHDj8R2UkSRx4UjhxnpHvefN89f4yAdsJCJv8ckwzxkBZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712918101; c=relaxed/simple;
	bh=TeQy6V1QFnUmoIy+5MXf1Osr2I4RIgtvFReT46+9iMI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Q9FjkBouFe/3PZCZ61QX1xs5InQ8v5QG2i6RqU7H82b7lVNZX5sSDLoCbBJLFiZHH34Z7UPZTjhwM+Es3uuSoXVgouaa+kPH+xareesMmwrEb/dZhLw/TTzatX3N83Elx3Fn2Fj3bXY+Esk8b5NNcFSFpgTQ9bSxjjG8kszGHoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 96F5415A1;
	Fri, 12 Apr 2024 03:35:28 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 863193F64C;
	Fri, 12 Apr 2024 03:34:57 -0700 (PDT)
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	linux-coco@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	maz@kernel.org,
	alexandru.elisei@arm.com,
	joey.gouly@arm.com,
	steven.price@arm.com,
	james.morse@arm.com,
	oliver.upton@linux.dev,
	yuzenghui@huawei.com,
	andrew.jones@linux.dev,
	eric.auger@redhat.com,
	Djordje Kovacevic <djordje.kovacevic@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [kvm-unit-tests PATCH 20/33] arm: realm: Add tests for in realm SEA
Date: Fri, 12 Apr 2024 11:33:55 +0100
Message-Id: <20240412103408.2706058-21-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240412103408.2706058-1-suzuki.poulose@arm.com>
References: <20240412103408.2706058-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Djordje Kovacevic <djordje.kovacevic@arm.com>

The RMM/Host could inject Synchronous External Aborts in to the Realm
for various reasons.

RMM injects the SEA for :
  * Instruction/Data fetch from an IPA that is in RIPAS_EMPTY state
  * Instruction fetch from an Unprotected IPA.

Trigger these conditions from within the Realm and verify that the
SEAs are received.

Signed-off-by: Djordje Kovacevic <djordje.kovacevic@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arm/Makefile.arm64 |   1 +
 arm/realm-sea.c    | 143 +++++++++++++++++++++++++++++++++++++++++++++
 arm/unittests.cfg  |   6 ++
 3 files changed, 150 insertions(+)
 create mode 100644 arm/realm-sea.c

diff --git a/arm/Makefile.arm64 b/arm/Makefile.arm64
index 5a9943c8..b3e085d3 100644
--- a/arm/Makefile.arm64
+++ b/arm/Makefile.arm64
@@ -59,6 +59,7 @@ tests += $(TEST_DIR)/cache.$(exe)
 tests += $(TEST_DIR)/debug.$(exe)
 tests += $(TEST_DIR)/fpu.$(exe)
 tests += $(TEST_DIR)/realm-rsi.$(exe)
+tests += $(TEST_DIR)/realm-sea.$(exe)
 
 include $(SRCDIR)/$(TEST_DIR)/Makefile.common
 
diff --git a/arm/realm-sea.c b/arm/realm-sea.c
new file mode 100644
index 00000000..5ef3e2a4
--- /dev/null
+++ b/arm/realm-sea.c
@@ -0,0 +1,143 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2022 Arm Limited.
+ * All rights reserved.
+ */
+#include <libcflat.h>
+#include <vmalloc.h>
+#include <asm/ptrace.h>
+#include <asm/thread_info.h>
+#include <asm/mmu.h>
+#include <asm/rsi.h>
+#include <linux/compiler.h>
+#include <alloc_page.h>
+#include <asm/pgtable.h>
+
+typedef void (*empty_fn)(void);
+
+static bool test_passed;
+
+/*
+ * The virtual address of the page that the test has made the access to
+ * in order to cause the I/DAbort with I/DFSC = Synchronous External Abort.
+ */
+static void* target_page_va;
+
+/*
+ * Ensure that the @va is the executable location from EL1:
+ * - SCTLR_EL1.WXN must be off.
+ * - Disable the access from EL0 (controlled by AP[1] in PTE).
+ */
+static void enable_instruction_fetch(void* va)
+{
+	unsigned long sctlr = read_sysreg(sctlr_el1);
+	if (sctlr & SCTLR_EL1_WXN) {
+		sctlr &= ~SCTLR_EL1_WXN;
+		write_sysreg(sctlr, sctlr_el1);
+		isb();
+		flush_tlb_all();
+	}
+
+	mmu_clear_user(current_thread_info()->pgtable, (u64)va);
+}
+
+static void data_abort_handler(struct pt_regs *regs, unsigned int esr)
+{
+	if ((esr & ESR_EL1_FSC_MASK) == ESR_EL1_FSC_EXTABT)
+		test_passed = true;
+
+	report_info("esr = %x", esr);
+	/*
+	 * Advance the PC to complete the test.
+	 */
+	regs->pc += 4;
+}
+
+static void data_access_to_empty(void)
+{
+	test_passed = false;
+	target_page_va = alloc_page();
+	phys_addr_t empty_ipa = virt_to_phys(target_page_va);
+
+	arm_set_memory_shared(empty_ipa, SZ_4K);
+
+	install_exception_handler(EL1H_SYNC, ESR_EL1_EC_DABT_EL1, data_abort_handler);
+	READ_ONCE(((char*)target_page_va)[0x55]);
+	install_exception_handler(EL1H_SYNC, ESR_EL1_EC_DABT_EL1, NULL);
+
+	report(test_passed, " ");
+}
+
+static void instruction_abort_handler(struct pt_regs *regs, unsigned int esr)
+{
+	if (((esr & ESR_EL1_FSC_MASK) == ESR_EL1_FSC_EXTABT) &&
+	     (regs->pc == (u64)target_page_va))
+		test_passed = true;
+
+	report_info("esr = %x", esr);
+	/*
+	 * Simulate the RET instruction to complete the test.
+	 */
+	regs->pc = regs->regs[30];
+}
+
+static void instr_fetch_from_empty(void)
+{
+	phys_addr_t empty_ipa;
+
+	test_passed = false;
+	target_page_va = alloc_page();
+	enable_instruction_fetch(target_page_va);
+
+	empty_ipa = virt_to_phys((void*)target_page_va);
+
+	arm_set_memory_shared(empty_ipa, SZ_4K);
+
+	install_exception_handler(EL1H_SYNC, ESR_EL1_EC_IABT_EL1, instruction_abort_handler);
+	/*
+	 * This should cause the IAbort with IFSC = SEA
+	 */
+	((empty_fn)target_page_va)();
+	install_exception_handler(EL1H_SYNC, ESR_EL1_EC_IABT_EL1, NULL);
+
+	report(test_passed, " ");
+}
+
+static void instr_fetch_from_unprotected(void)
+{
+	test_passed = false;
+	/*
+	 * The test will attempt to execute an instruction from the start of
+	 * the unprotected IPA space.
+	 */
+	target_page_va = vmap(PTE_NS_SHARED, SZ_4K);
+	enable_instruction_fetch(target_page_va);
+
+	install_exception_handler(EL1H_SYNC, ESR_EL1_EC_IABT_EL1, instruction_abort_handler);
+	/*
+	 * This should cause the IAbort with IFSC = SEA
+	 */
+	((empty_fn)target_page_va)();
+	install_exception_handler(EL1H_SYNC, ESR_EL1_EC_IABT_EL1, NULL);
+
+	report(test_passed, " ");
+}
+
+int main(int argc, char **argv)
+{
+	report_prefix_push("in_realm_sea");
+
+	report_prefix_push("data_access_to_empty");
+	data_access_to_empty();
+	report_prefix_pop();
+
+	report_prefix_push("instr_fetch_from_empty");
+	instr_fetch_from_empty();
+	report_prefix_pop();
+
+	report_prefix_push("instr_fetch_from_unprotected");
+	instr_fetch_from_unprotected();
+	report_prefix_pop();
+
+	return report_summary();
+}
diff --git a/arm/unittests.cfg b/arm/unittests.cfg
index 3cf6b719..e2821c26 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -311,3 +311,9 @@ smp = 2
 groups = nodefault realms
 accel = kvm
 arch = arm64
+
+[realm-sea]
+file = realm-sea.flat
+groups = nodefault realms
+accel = kvm
+arch = arm64
-- 
2.34.1

