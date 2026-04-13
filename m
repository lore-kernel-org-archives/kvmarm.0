Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ECCB3822B4
	for <kvmarm@lists.linux.dev>; Mon, 13 Apr 2026 20:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776113209; cv=none; b=LdZfkE8bfKj1V+HeuHJhPyNJhqHmdGEoqzVShHUrz8P0wQthrFRKjUy4R7OZZ51ftFA0MpTxUa8mnYlJI0XQu1nCbhOTpfv4rowoDFyWwJVwq4YWv1ayMnrhhIG7vzofSIm0F3DsFMv36m+tlDkddk0WKaOoWqkhRMLTcXZ8dOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776113209; c=relaxed/simple;
	bh=1JhpdHjs4nhsKu12NN8RJ/F7gAo6s0Kly6krui3KfCU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=o/8GQvKS2Cc8O1FGQeTSH+3Hbqj/oSxwplH4Io/nb5cSpMa9OO7rv8EfuunqppcjSzZH1DvVw04Dqa/XUTYZfN5w/emnV2Fe/1E8clhPZZUdHh6WPZNmDbE8gPL9wdBR2uAEXKcuRpvcrFhZSXQTk1lB+hTvWBSV07pf2vW+KJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jingzhangos.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TId4v60l; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jingzhangos.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TId4v60l"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2b242062308so89182515ad.2
        for <kvmarm@lists.linux.dev>; Mon, 13 Apr 2026 13:46:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776113208; x=1776718008; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7sl1KtXC/+tuHHiZ0wl9PU8IScEDOzQEqTGCZa1m8Xg=;
        b=TId4v60lc4PNWUsKP1rDOZvT/9lXZoPxLQXcvh+AUHY5IV5sgmYE9c5VKQ/vMcg+Jc
         SAlEABExG3kg1J92Qa+oAbka+sJvQOe7Qtt3hKMAL980y0LVW6O1nAaLl+XokNYHGUgF
         7poVtJvkABI1geQ4NkpSnZVrlMC7J6Af/VCSPBwWtf69C2FSag5QSXwY1j+y60M4Gkn0
         cuoBHYJObS0I4GnuRqi+P7p5NJrUuVtO4pMsTa82fjBVKK3SR9YuY8daIq2cBSoz/E+H
         q7p6BF1B1l2Ke3hS1vmawU8n4DbBbO8HFaRPsxl/K5W1Q/kPf1zDt3fNygZtpFyRLO/k
         R3yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776113208; x=1776718008;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7sl1KtXC/+tuHHiZ0wl9PU8IScEDOzQEqTGCZa1m8Xg=;
        b=KnzPgzHOy/Mz5zUrv51S5OrpPmq6AqGAgsO2L9uddaGxu5K17mN/L1guV8c3R9VB9Z
         LUHJD0I2f88VacAzLthDCXWMvW9pEDTA4pdN3Qz1NgiIIQGm7oLQXvyBWuzVZPUoCRo7
         7TUT3TpzJMvkUvsRm5R5MsN7c4gA90RkqQl9JagAqK+CShLDb7avdy8J0eb5d02g+Wlq
         n79ZyAV0a6Izcy2IQPHPAcil9aN+AiEfSYKi4dY/AfUCUHMVV81jGRNwWJGu/qUdiw22
         vT7/5xyHT4XNa7GcH7FwavX8Y6Xy6h0LjxvCNX4cR8YZmBNuMjrJuaRN+FHLDFngurIK
         1oLg==
X-Forwarded-Encrypted: i=1; AFNElJ/XXZvk4p9GWoCDHtkyNBku69rdft6u0Ap3tuknSGIUqiUE1ujfcEEUHbTRJrkSdWwQoSUaDb8=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw18CBg/3UT9lQwvf90JaR+cytBiyNCWaQWgsKZhVUz5I57vqTY
	IOnG3my/jQvuUo/johFgKBe5ufsVZIO6QMcrknwlSmVspTcHOuvas69LY0BsCpL8HzmFJ7q1ZAK
	+WUzjFH3CaRMfcX4HnF6pnUT71w==
X-Received: from plv10.prod.google.com ([2002:a17:903:bca:b0:2b2:a715:a848])
 (user=jingzhangos job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:aa4a:b0:2b0:c451:ae8a with SMTP id d9443c01a7336-2b2d597d32dmr109567715ad.13.1776113207637;
 Mon, 13 Apr 2026 13:46:47 -0700 (PDT)
Date: Mon, 13 Apr 2026 13:46:30 -0700
In-Reply-To: <20260413204630.1149038-1-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260413204630.1149038-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.54.0.rc0.605.g598a273b03-goog
Message-ID: <20260413204630.1149038-8-jingzhangos@google.com>
Subject: [kvm-unit-tests PATCH v2 7/7] arm64: Add Stage-2 MMU demand paging test
From: Jing Zhang <jingzhangos@google.com>
To: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Wei-Lin Chang <weilin.chang@arm.com>, Yao Yuan <yaoyuan@linux.alibaba.com>
Cc: Oliver Upton <oliver.upton@linux.dev>, Andrew Jones <andrew.jones@linux.dev>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Mingwei Zhang <mizhang@google.com>, 
	Raghavendra Rao Ananta <rananta@google.com>, Colton Lewis <coltonlewis@google.com>, 
	Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"

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
---
 arm/Makefile.arm64    |   1 +
 arm/stage2-mmu-test.c | 107 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 108 insertions(+)
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
index 00000000..0df4704b
--- /dev/null
+++ b/arm/stage2-mmu-test.c
@@ -0,0 +1,107 @@
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
+#define TEST_PAGE_IPA		0x40000000UL
+#define FAULT_ADDR_IPA		0x50000000UL
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
+	if (*fault_va == *test_va)
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
+	guest = guest_create(smp_processor_id(), guest_code, S2_PAGE_4K);
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
2.53.0.1213.gd9a14994de-goog

