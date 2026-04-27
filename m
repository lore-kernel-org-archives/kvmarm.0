Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDDBC3BFE4D
	for <kvmarm@lists.linux.dev>; Mon, 27 Apr 2026 13:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777294857; cv=none; b=BAPQAsHC+gHHFjYBBtnOmCUNntkvbYvMrJCfCc7Mvq42Ko1XGcMH/ZKcFKg8nkbLhK1ysRFjfSfyCDh4ACXXx0VGmF+yJEB6nezr3GdFQNePs5kedL9S2yWizXFas+nSr7IrBQG/Jo924EjjKNc8dmzhu+vIx1dfiDh1Hhexsjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777294857; c=relaxed/simple;
	bh=F2Xp1+J0t/YjwriVvl8Pbc8Dl2/SEtYsRRibhtSqsno=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ML/3+tn0QB+krPlczLu4edbcpCkXcLzUdAStRmWHfKOlbVkXWeQsVbUk9EUyHLJ76ELc56Kmc2ozQSqqUnRHiOwULcuil8eqAZ1pfJqfKkpj2SMnspv14a5texO4rVIyoWYHR2RT+XUoTopA5xYgMi08WeoLLljjDj8xrY/TxF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=K373oEbj; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="K373oEbj"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-488af9fdaa7so60661045e9.1
        for <kvmarm@lists.linux.dev>; Mon, 27 Apr 2026 06:00:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1777294852; x=1777899652; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=e+5B0T5BZcM8PN6hrBB/cl4KNtkNonj2W3WbwM9F740=;
        b=K373oEbjw3uKz0c1TQa875CWuztezhZ8B6fuuDdD2iM7IA2OAj3y4DsYYbqFCTaX2Q
         mNbuysBzDLWQJADOM3pEPCzHPwJ8k3Al6Zn5Uoz9srrsVmsJBuw9zGeulmI2la54plY3
         w3aqOLE2CuzXLDeY1EdiNCYucyQXwy/GvqcK0TuU1rhMbMBTYSWezDIL9ndaixUb7IEF
         mWf3gfcN96Q5hfcgjXNS7l/3JoTfH9d/ldgdQ7owA4aTsa3YK6jLeyO1KW+fS7VR2kUr
         DrrTrCsAlu+qxcOA8FbeqKspaa5v7A8vtJ5tsyhQShE9Z/mVrgYVqIoJIP1MDKkLKOKC
         tJ3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777294852; x=1777899652;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e+5B0T5BZcM8PN6hrBB/cl4KNtkNonj2W3WbwM9F740=;
        b=U1BMVV9hxmNkPicXDZkc0a9v1DsEPqgQKSqmYIfaSDp9nn34FMcafkay9lnryv1Qbc
         EZSCC8HYQvcaaHGFrcnrhTQNx/+zzGsgm5J9Lt6zZKDr4DjEiYjjy/MkOFpZYqJiMEtG
         WgONoyFjqLnvZKkXCeEkgNyFYmrWF6qs8f7cvrxCzpWBBzmbfJcyrngTRPeGmqpp0ySl
         GPtMnCaGXMIo3qbPtAapkcLPIS9CQ92JuPxgdk+AZoIbn6IhWm1TfafPT4uopWiWUj1f
         PbSTg331hWLniho1c+qF6Q6m/L/3+NLRye4ydFhe0CV2kGKc3VBnaRhBuHqPvUJN6r1o
         douQ==
X-Forwarded-Encrypted: i=1; AFNElJ+UhusspFK/kQ1LcxH8KGRIPxNJjdAJLUYn4vWmoAw0/uvPbOmF7wiPnWr266Iu2rmV++0RvCI=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx7aRDvglk8G1d5cugnSzjFAenl9Vuda2nQEGAU3VcJB9tErrRX
	bDTb2xOrAcs0acYuTCYBQ+8iaOsLEgpCCQeW1qsXQ+NoNMuml859PJvXIgV0b3oBEUM=
X-Gm-Gg: AeBDievZdZ2V4UG8vSfE227R464Mk7xECFTT8dtJsP0CZ/aiyPmE0+S/dLXhwBR3mqv
	FaXMy/C/pNQC5CKM9hvuGGU6a+dGyQ3/0IuaHpZI4/SvC0eXE/cINPYaMOUUkrro4rJKJGGF/IC
	t6MUdP/lRSLXbF5sgZz/LvHbUqASWVYOx1nkaa+B2wRpuDUOUDGlOvk95JF7LnFkyCXT+UH0Qej
	kBnV8lUGYbNyD1Erlgd6EBlP9iDkll6rRsU6bFBmpWYVRQcoS31Jn+nvnl5e9nsoo9guNTBI31m
	W+cAkjWfRKHclRt7Z6pgry/HwfI8S5eI1Dyqm/Jtlc9ABEcxqdHpA3tCEjpBHBwsqngduJaa5HK
	Mg/hUEztPLrtNoWXDjvXyYKdujpPs7gO1NVOmWPirtkMSu5RAimlibbV0fChI4M8qrSCQ6aZjaa
	DtOcdJ7Lcv3VJoWQpDmBjhc25FYD+HFLzljQ==
X-Received: by 2002:a05:600d:8451:b0:48a:599a:36fe with SMTP id 5b1f17b1804b1-48a599a4413mr263744425e9.24.1777294851986;
        Mon, 27 Apr 2026 06:00:51 -0700 (PDT)
Received: from draig.lan ([185.124.0.195])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488ffc558f2sm622865905e9.1.2026.04.27.06.00.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2026 06:00:51 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 06B075F877;
	Mon, 27 Apr 2026 14:00:50 +0100 (BST)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Andrew Jones <andrew.jones@linux.dev>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	kvmarm@lists.linux.dev (open list:ARM),
	kvm@vger.kernel.org (open list:Default mailing list)
Subject: [kvm-unit-tests PATCH] arm: add wfx test case
Date: Mon, 27 Apr 2026 14:00:45 +0100
Message-ID: <20260427130045.3669851-1-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is based on a similar test case I wrote for QEMU's tcg tests although
obviously able to take advantage of kvm-unit-tests additional plumbing for
dealing with the GIC and IRQs.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 arm/Makefile.arm64        |   1 +
 lib/arm64/asm/processor.h |   7 ++
 lib/arm64/asm/sysreg.h    |   3 +
 arm/wfx.c                 | 137 ++++++++++++++++++++++++++++++++++++++
 arm/unittests.cfg         |   5 ++
 5 files changed, 153 insertions(+)
 create mode 100644 arm/wfx.c

diff --git a/arm/Makefile.arm64 b/arm/Makefile.arm64
index a40c830d..52b3f35d 100644
--- a/arm/Makefile.arm64
+++ b/arm/Makefile.arm64
@@ -64,6 +64,7 @@ tests += $(TEST_DIR)/cache.$(exe)
 tests += $(TEST_DIR)/debug.$(exe)
 tests += $(TEST_DIR)/fpu.$(exe)
 tests += $(TEST_DIR)/mte.$(exe)
+tests += $(TEST_DIR)/wfx.$(exe)
 
 include $(SRCDIR)/$(TEST_DIR)/Makefile.common
 
diff --git a/lib/arm64/asm/processor.h b/lib/arm64/asm/processor.h
index 32ddc1b3..2104036d 100644
--- a/lib/arm64/asm/processor.h
+++ b/lib/arm64/asm/processor.h
@@ -173,5 +173,12 @@ static inline bool system_supports_rndr(void)
 	return ((id_aa64isar0_el1 >> ID_AA64ISAR0_EL1_RNDR_SHIFT) & 0xf) != 0;
 }
 
+static inline bool system_supports_wfxt(void)
+{
+	u64 id_aa64isar2_el1 = read_sysreg_s(ID_AA64ISAR2_EL1);
+
+	return ((id_aa64isar2_el1 >> ID_AA64ISAR2_EL1_WFxT_SHIFT) & 0xf) != 0;
+}
+
 #endif /* !__ASSEMBLER__ */
 #endif /* _ASMARM64_PROCESSOR_H_ */
diff --git a/lib/arm64/asm/sysreg.h b/lib/arm64/asm/sysreg.h
index f2d05018..cb96a649 100644
--- a/lib/arm64/asm/sysreg.h
+++ b/lib/arm64/asm/sysreg.h
@@ -77,6 +77,9 @@ asm(
 #define ID_AA64ISAR0_EL1_RNDR_SHIFT	60
 #define ID_AA64PFR1_EL1_MTE_SHIFT	8
 
+#define ID_AA64ISAR2_EL1		sys_reg(3, 0, 0, 6, 2)
+#define ID_AA64ISAR2_EL1_WFxT_SHIFT	0
+
 #define ID_AA64MMFR0_EL1_FGT_SHIFT	56
 #define ID_AA64MMFR0_EL1_FGT_FGT2	0x2
 
diff --git a/arm/wfx.c b/arm/wfx.c
new file mode 100644
index 00000000..912e50e6
--- /dev/null
+++ b/arm/wfx.c
@@ -0,0 +1,137 @@
+/*
+ * WFX Instructions Test (WFI, WFE, WFIT, WFET)
+ *
+ * Copyright (c) 2026 Linaro Ltd
+ *
+ * SPDX-License-Identifier: GPL-2.0-or-later
+ */
+
+#include <libcflat.h>
+#include <asm/processor.h>
+#include <asm/gic.h>
+#include <asm/timer.h>
+#include <asm/io.h>
+
+#define TIMEOUT 200000
+
+#define sev() asm volatile("sev" : : : "memory")
+#define sevl() asm volatile("sevl" : : : "memory")
+#define wfi() asm volatile("wfi" : : : "memory")
+#define wfe() asm volatile("wfe" : : : "memory")
+
+#define wfit(reg) \
+	asm volatile(".arch armv8.7-a\n\twfit %0" : : "r" (reg) : "memory")
+#define wfet(reg) \
+	asm volatile(".arch armv8.7-a\n\twfet %0" : : "r" (reg) : "memory")
+
+static void timer_handler(struct pt_regs *regs)
+{
+	/* Disable timer to stop IRQ from re-firing */
+	write_sysreg(0, cntv_ctl_el0);
+}
+
+static bool check_elapsed(uint64_t start, uint64_t threshold, const char *test, bool more)
+{
+	uint64_t end = read_sysreg(cntvct_el0);
+	uint64_t elapsed = end - start;
+	bool pass = more ? elapsed >= threshold : elapsed <= threshold;
+
+	report(pass, "%s (%ld ticks)", test, elapsed);
+
+	if (!pass) {
+		report_info("%s %s", test, more ? "woke too early" : "slept despite SEV");
+	}
+	return pass;
+}
+
+static void test_wfi(void)
+{
+	uint64_t start;
+
+	report_info("Testing WFI...");
+
+	start = read_sysreg(cntvct_el0);
+	write_sysreg(TIMEOUT, cntv_tval_el0);
+	write_sysreg(1, cntv_ctl_el0); /* Enable timer, no mask */
+	isb();
+
+	local_irq_enable();
+	wfi();
+	local_irq_disable();
+
+	check_elapsed(start, TIMEOUT, "WFI", true);
+}
+
+static void test_wfe(void)
+{
+	uint64_t start;
+
+	report_info("Testing WFE/SEV...");
+	sev();
+	start = read_sysreg(cntvct_el0);
+	wfe();
+	check_elapsed(start, TIMEOUT, "WFE/SEV", false);
+
+	report_info("Testing WFE/SEVL...");
+	sevl();
+	start = read_sysreg(cntvct_el0);
+	wfe();
+	check_elapsed(start, TIMEOUT, "WFE/SEVL", false);
+}
+
+static void test_wfit(void)
+{
+	uint64_t start, timeout;
+
+	report_info("Testing WFIT...");
+	start = read_sysreg(cntvct_el0);
+	timeout = start + TIMEOUT;
+	wfit(timeout);
+	check_elapsed(start, TIMEOUT, "WFIT", true);
+}
+
+static void test_wfet(void)
+{
+	uint64_t start, timeout;
+
+	report_info("Testing WFET...");
+	/* Ensure no pending events */
+	sev();
+	wfe();
+
+	start = read_sysreg(cntvct_el0);
+	timeout = start + TIMEOUT;
+	wfet(timeout);
+	check_elapsed(start, TIMEOUT, "WFET", true);
+}
+
+int main(void)
+{
+
+	if (gic_init() < 0) {
+		report_abort("GIC init failed");
+		return 1;
+	}
+
+	/* Install timer handler for WFI wake-up */
+	install_irq_handler(EL1H_IRQ, timer_handler);
+	gic_enable_defaults();
+
+	/* Enable Virtual Timer PPI */
+	gic_irq_set_clr_enable(27, true);
+
+	report_prefix_push("WFx");
+	test_wfi();
+	test_wfe();
+	report_prefix_pop();
+
+	if (system_supports_wfxt()) {
+		report_prefix_push("WFxT");
+		test_wfit();
+		test_wfet();
+	} else {
+		report_skip("WFxT instructions not supported");
+	}
+
+	return report_summary();
+}
diff --git a/arm/unittests.cfg b/arm/unittests.cfg
index 12fc4468..7adf96f2 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -339,3 +339,8 @@ groups = mte
 test_args = asymm
 qemu_params = -machine mte=on
 arch = arm64
+
+[wfx]
+file = wfx.flat
+groups = wfx
+arch = arm64
-- 
2.47.3

