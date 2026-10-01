Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C3613A5E64
	for <kvmarm@lists.linux.dev>; Thu,  1 Oct 2026 15:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790867829; cv=none; b=eaQTyvhd/D3okHr/GgRx8I0SMZdcxzMfiKYxyHykvlyorYPsvU/9ek60QkrvqIGTeOXjJQ8NLnoC6xiEOY2vj/7DzsEa60iYeMf955P3urHF2u5peJRzKnnRGLeHXQX4yDHoqicns9IsWUH2B+fc65oYqIS1ZafXILdGNSdaLDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790867829; c=relaxed/simple;
	bh=N+YsEW11ATcjtq3jrkUCY8JpWm0ht3VDeEcGukenrsA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PxXTyqORErcjJJ7Li1DINg6iyrR1vkC/2cccz4xnee70efBXQiAs8p7/+WPYEXF56meg429welGcxtBljOXh6quX5YwC50iK35BN9PUBOR00kRRu0YD1ePJ6LYwo59oIUjR9vvlLMUXkWVa8haIvMS+3Osu/6SN9UcxW9VUaLnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Zg/lyyE1; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Zg/lyyE1"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6C3761476;
	Thu,  1 Oct 2026 08:17:04 -0700 (PDT)
Received: from e143914.cambridge.arm.com (e143914.arm.com [10.2.213.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 842843F86F;
	Thu,  1 Oct 2026 08:17:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790867827; bh=N+YsEW11ATcjtq3jrkUCY8JpWm0ht3VDeEcGukenrsA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zg/lyyE1CNMCMxv/Ml0k1nE1dvGZ7lQHWkWBGC/xVEYWPuTyx6eriG6Rqb+X2SvyI
	 HIZo7VstRMUlTgEC4IWlZvu4FTadj1lOtA6Qk/33zLr7n1zxHPiSjzJMbsyP4JIiZM
	 3WKehhNIZPlBM6Q0G4hTKnKU4ut5zc6kyUQLEeQo=
From: Joey Gouly <joey.gouly@arm.com>
To: kvmarm@lists.linux.dev
Cc: Jing Zhang <jingzhangos@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Mark Brown <broonie@kernel.org>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	andrew.jones@linux.dev,
	Joey Gouly <joey.gouly@arm.com>
Subject: [PATCH v3 7/8] arm64: Add Stage-2 MMU demand paging test
Date: Thu,  1 Oct 2026 16:16:44 +0100
Message-ID: <20261001151645.2427065-8-joey.gouly@arm.com>
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

From: Jing Zhang <jingzhangos@google.com>

Introduce a new test case to validate Stage-2 MMU fault handling. The
test verifies that the hypervisor correctly identifies and handles
Stage-2 data aborts triggered by a guest accessing unmapped memory.

The test performs the following:
- Sets up a guest with Stage-1 disabled, using identity-mapped host
   code and shared data in the Stage-2 page tables.
- Triggers a Stage-2 data abort by accessing a specific unmapped IPA.
- Catches the exception in the host, verifies the fault address,
   and dynamically maps a new page to resolve the fault.
- Resumes the guest to confirm the memory access completes successfully
   and the fault handler functioned as expected.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
Signed-off-by: Joey Gouly <joey.gouly@arm.com>
---
 arm/Makefile.arm64    |   1 +
 arm/stage2-mmu-test.c | 113 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 114 insertions(+)
 create mode 100644 arm/stage2-mmu-test.c

diff --git a/arm/Makefile.arm64 b/arm/Makefile.arm64
index 9026fd71..e547f92d 100644
--- a/arm/Makefile.arm64
+++ b/arm/Makefile.arm64
@@ -67,6 +67,7 @@ tests += $(TEST_DIR)/cache.$(exe)
 tests += $(TEST_DIR)/debug.$(exe)
 tests += $(TEST_DIR)/fpu.$(exe)
 tests += $(TEST_DIR)/mte.$(exe)
+tests += $(TEST_DIR)/stage2-mmu-test.$(exe)
 
 include $(SRCDIR)/$(TEST_DIR)/Makefile.common
 
diff --git a/arm/stage2-mmu-test.c b/arm/stage2-mmu-test.c
new file mode 100644
index 00000000..91d3de7e
--- /dev/null
+++ b/arm/stage2-mmu-test.c
@@ -0,0 +1,113 @@
+/*
+ * ARM64 Stage-2 MMU Demand Paging Test
+ *
+ * This test validates stage-2 data abort handling by purposefully
+ * accessing unmapped memory in the guest and verifying that the
+ * host correctly handles the fault by mapping the page.
+ *
+ * Copyright (C) 2026 Google LLC.
+ * Author: Jing Zhang <jingzhangos@google.com>
+ *
+ * SPDX-License-Identifier: LGPL-2.0-or-later
+ */
+#include <libcflat.h>
+#include <alloc_page.h>
+#include <asm/io.h>
+#include <asm/smp.h>
+#include <asm/guest.h>
+#include <asm/stage2_mmu.h>
+
+#define TEST_PAGE_IPA		0x50000000UL
+#define FAULT_ADDR_IPA		0x60000000UL
+#define TEST_DATA		0xBEEFCAFEUL
+
+static volatile bool handled = false;
+
+static void guest_code(void)
+{
+	volatile unsigned long *test_va = (void *)TEST_PAGE_IPA;
+	volatile unsigned long *fault_va = (void *)FAULT_ADDR_IPA;
+
+	*fault_va = *test_va;
+
+	if (*fault_va == *test_va && *fault_va == TEST_DATA)
+		handled = true;
+
+	asm("hvc #0");
+}
+
+static enum guest_handler_result guest_exception_handler(struct guest *guest)
+{
+	unsigned long far, ec;
+	unsigned long *fixup_page;
+
+	ec = guest->esr_el2 >> ESR_ELx_EC_SHIFT;
+
+	if (ec == ESR_ELx_EC_HVC64) {
+		report_info("CPU%d: Guest exited via HVC.", smp_processor_id());
+		return GUEST_ACTION_EXIT;
+	}
+
+	if (ec == ESR_ELx_EC_DABT_LOW) {
+		far = guest->far_el2;
+		if (far == FAULT_ADDR_IPA) {
+			fixup_page = alloc_page();
+			s2mmu_map(guest->s2mmu, FAULT_ADDR_IPA,
+				  virt_to_phys(fixup_page), PAGE_SIZE, S2_MAP_RW);
+			report(true, "Caught stage-2 fault at 0x%lx", far);
+		} else {
+			report(false, "Unexpected fault address: 0x%lx", far);
+		}
+	} else {
+		report(false, "Unexpected exception class: 0x%lx", ec);
+	}
+
+	return GUEST_ACTION_RESUME;
+}
+
+int main(int argc, char **argv)
+{
+	struct guest *guest;
+	unsigned long *test_page;
+	unsigned long code_va_base, code_pa_base, data_base;
+
+	report_prefix_push("stage2-mmu");
+
+	if (current_level() != CurrentEL_EL2) {
+		report_skip("EL2 is required");
+		return report_summary();
+	}
+
+	guest = guest_create_identity(smp_processor_id(), guest_code,
+				      S2_PAGE_4K);
+
+	/* Map host code: IPA(VA) -> PA */
+	/* We use the host VA as the Guest IPA because guest stage 1 is disabled. */
+	code_va_base = (unsigned long)guest_code;
+	code_pa_base = virt_to_phys((void *)guest_code);
+
+	/* Align to 2MB to use block descriptors where possible */
+	code_va_base = code_va_base & ~(SZ_2M - 1);
+	code_pa_base = code_pa_base & ~(SZ_2M - 1);
+	s2mmu_map(guest->s2mmu, code_va_base, code_pa_base, SZ_2M, S2_MAP_RW);
+
+	/* Identity map the shared variable */
+	data_base = virt_to_phys((void *)&handled) & PAGE_MASK;
+	s2mmu_map(guest->s2mmu, data_base, data_base, PAGE_SIZE, S2_MAP_RW);
+
+	/* Map test data page */
+	test_page = alloc_page();
+	*test_page = TEST_DATA;
+	s2mmu_map(guest->s2mmu, TEST_PAGE_IPA, virt_to_phys(test_page), PAGE_SIZE, S2_MAP_RW);
+
+	guest_install_handler(guest, ELx_LOW_SYNC_64, guest_exception_handler);
+
+	report_info("CPU%d: entering guest...", smp_processor_id());
+
+	guest_run(guest);
+
+	report(handled, "Stage-2 fault handling test completed");
+	guest_destroy(guest);
+
+	return report_summary();
+}
-- 
2.43.0

