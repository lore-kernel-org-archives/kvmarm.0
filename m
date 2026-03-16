Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 383383783A1
	for <kvmarm@lists.linux.dev>; Mon, 16 Mar 2026 22:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773701053; cv=none; b=ROwNYeORfrwCgjrkAUZlM5g3RodVm2iC7+izaoYyaTz3z2iPGJMQu+i4CR04PWyITUDK6Hd9C4OHz10Ha/1LK7t++thjMaadHFB7No+clKEo1LRPddRx81T3ls7o7ddqPY74CgBsqyk0bp0coWZ2gPfzzNsHxlVFS4af3e4Ifss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773701053; c=relaxed/simple;
	bh=CRZaBcVT4Nccd9wr2yksdpHezTrKvIKkYwQqtZlwzaU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QhuCFP1S2DSNqADlE/6UUNPFy/YUI95anRFMeNOeWaB+fg1zJO8LdgwyVfao4Soot35CzdwTbN9RcpZFFPqar4/xSTX3YQTLfeg2+iudxBNFieFhAbjkqqpEyBnFY5Qdqwj+08UPdyvFktNHUWvr3Jx5CNXHOv/+c1xcGw61UdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jingzhangos.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=X+qH/WQr; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jingzhangos.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="X+qH/WQr"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-829a535ad7fso19307165b3a.1
        for <kvmarm@lists.linux.dev>; Mon, 16 Mar 2026 15:44:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773701051; x=1774305851; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ft9HYj5yB7NMR4Js2O0wNzazbO+Nfd7jWsn5KEAvFFc=;
        b=X+qH/WQrymH/d4lszERmoGInefDvib/dcBI2gPa6RS8b0RfwXhG1YZQozDjgzAB6Ya
         TzI02+zz9LBw74u4ZfjGZC6UrEHmd2oz1vAxfh+yghPIuDvljluyqkbwgZCfh57f/I3z
         0z7iVgnzCZKjNhlLrxsPQrYaZKGZZOQ/EYOyXgP+M7dmhjNY3ALEGt6YHC0fOVMStlqR
         0C1RCUXGwcl4TNDwzQsinByhJxafqN9RU9khIA0F3vcI+FtHO75PnvcMn+26HJ1g6/bV
         FhXaFHNVCNrkyNmDNr1sWO6ZLWGbU6DRECzIUkZnv0kJ3JcJFZTxTOB6pmTes5AdjIP+
         l84g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773701051; x=1774305851;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ft9HYj5yB7NMR4Js2O0wNzazbO+Nfd7jWsn5KEAvFFc=;
        b=q7ClaMIrbvG8YWV7x5fSZx0s8pBg4UWo+sOL/hDeb5dPvhyQKQoXh3TiqdmqvOy36f
         FmVKMVV4R14ToMznJzzaQgRIcwniLWjR/yeqSotl03UEpf77+QmfRA+uRSDyaw/gulIR
         mWY7t3vdJzg1A9evk3ZDt3u4hvqpunf3NH2D+lRfSQ1+2aYXauJmkuDb2jLs3Q7jqz0z
         8HYIvF6UvQC0x1p/STMogJGtiaJ3qS6H1t3ABseNV0KG54zCwtyMR5Z0OVKhm1uDmxE1
         vVe9Uon5oMWG2d/sBCycPbooXBh3qJf0djJHabUDdGZWAwxgNof/4RLXiADC0XIvWG46
         l1qQ==
X-Forwarded-Encrypted: i=1; AJvYcCV0d0yQKfEF1mxZqJlvEnxfkUHt9XC79rB4fbfA9RYX1MrSGscyXNA6TdY8sKbX0GjLDO0/sv4=@lists.linux.dev
X-Gm-Message-State: AOJu0Yycn7M8L5yX7e4CwOZ7fSqICiQjiFhD2sOCuZyCMwYOAdqqXMSH
	KZGijXN1LY003FxFKF9tQU/NIH30zzhD0+iol9C65yHWWRkELuSKmhmkyICHQ4NqSnD7AC30E9T
	A2yW5UxDpaYhi5WlVpHrkEouu0w==
X-Received: from pfbho21.prod.google.com ([2002:a05:6a00:8815:b0:824:b235:888c])
 (user=jingzhangos job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:130f:b0:824:a182:1dd4 with SMTP id d2e1a72fcca58-82a19928c35mr13559051b3a.54.1773701051395;
 Mon, 16 Mar 2026 15:44:11 -0700 (PDT)
Date: Mon, 16 Mar 2026 15:43:49 -0700
In-Reply-To: <20260316224349.2360482-1-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260316224349.2360482-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.53.0.851.ga537e3e6e9-goog
Message-ID: <20260316224349.2360482-4-jingzhangos@google.com>
Subject: [kvm-unit-tests PATCH v1 3/3] arm64: Add Stage-2 MMU demand paging test
From: Jing Zhang <jingzhangos@google.com>
To: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Andrew Jones <andrew.jones@linux.dev>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Jing Zhang <jingzhangos@google.com>
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
 arm/stage2-mmu-test.c | 100 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 101 insertions(+)
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
index 00000000..391c28f0
--- /dev/null
+++ b/arm/stage2-mmu-test.c
@@ -0,0 +1,100 @@
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
+int main(int argc, char **argv)
+{
+	struct guest *guest;
+	unsigned long *test_page, *fixup_page;
+	unsigned long code_va_base, code_pa_base, data_base, far, ec;
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
+	report_info("CPU%d: entering guest...", smp_processor_id());
+
+	while (1) {
+		guest_run(guest);
+
+		if (guest->exit_code == GUEST_VECTOR_SYNC) {
+			ec = guest->esr_el2 >> ESR_ELx_EC_SHIFT;
+			if (ec == ESR_ELx_EC_HVC64) {
+				report_info("CPU%d: Guest exited via HVC.", smp_processor_id());
+				break;
+			} else if (ec == ESR_ELx_EC_DABT_LOW) {
+				far = guest->far_el2;
+				if (far == FAULT_ADDR_IPA) {
+					fixup_page = alloc_page();
+					s2mmu_map(guest->s2mmu, FAULT_ADDR_IPA,
+						  virt_to_phys(fixup_page), PAGE_SIZE, S2_MAP_RW);
+					report(true, "Caught stage-2 fault at 0x%lx", far);
+				} else {
+					report(false, "Unexpected fault address: 0x%lx", far);
+					break;
+				}
+			} else {
+				report(false, "Unexpected exception class: 0x%lx", ec);
+				break;
+			}
+		}
+	}
+
+	report(handled, "Stage-2 fault handling test completed");
+	guest_destroy(guest);
+
+	return report_summary();
+}
-- 
2.53.0.851.ga537e3e6e9-goog

