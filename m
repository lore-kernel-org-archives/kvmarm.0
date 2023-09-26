Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10DCB4B234
	for <kvmarm@lists.linux.dev>; Tue, 26 Sep 2023 23:40:23 +0000 (UTC)
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-5a1eb48d346so39760087b3.3
        for <kvmarm@lists.linux.dev>; Tue, 26 Sep 2023 16:40:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695771623; x=1696376423; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=sw0qG5ysAcyhaSLN7xylZoxJWjUlvfByxdFEVcL/A4I=;
        b=jaNctWtAtEbqQUC/cl9Rq7L+6Oe4ESIkyL5dbKuK4bMdRaXEwQxW0cbKwk66rRE7bp
         /wyfBnROYsDJhLqg1VAPyoqjVlOa/kGAMED1Y9BIBjg5YqRPcM3GAbmid8nbwMVg2o/m
         PJCvtoYkQTEtS4+u3gMjuBWFUxsRV4nzvYdVrduXeKdkCJ8nOv4gabzRPlKWpXgh5nOc
         AifUacvWtpDanhA7ZYXjL5V1KlcZNoVW/SKW7uo1/VcLOW6czFoIlv1BRwGTcrwjN+VT
         OxNzmcX1EJ0uMEuJ9+opuAMQnVGzURlplDXqVo0vRogDirW2cA/OLxsL2TAn5zKnNAXD
         wlDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695771623; x=1696376423;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sw0qG5ysAcyhaSLN7xylZoxJWjUlvfByxdFEVcL/A4I=;
        b=fVFylhIiypYXqdTPpsiBlb5wqwf1fleuvpSOJH3oZluWCH+vo9dbdLU5exBmSKOCmO
         ocE5vTWnMCR3rwbOvtdznZ06fii3jgdnnZvlsiUBIXFXdCZo/fwFjfJeuTDdQpz4+Lai
         vANiP7hLaCRaNlxp94Cuoo3LIUEHC4G00sgIlXluGx8F7P3UdWF6uOxjY/yTCdWNVYU6
         9CaG5pjJP6xJX5VSVw71Bf4xNAyJOa7qYaNbS7wBVE54I2yG9sMXKMd20Kxcydtu4Uri
         jvzlgEtOTT20y33EObyOPHAPuy2PoGUiR+VankbU+8qLDJxIlhZdJLxPmmoC2YP4HRb5
         WjVA==
X-Gm-Message-State: AOJu0Ywgfgx6mY98TADDuPsi/Uussp5xiottj0J5ZMDvFiqBkeS08xnI
	boMYZ2cFmn/nlN38rL5kt3V1Z53P58gL
X-Google-Smtp-Source: AGHT+IGD8zkX1a5Qv1yL3yQkh4svBsOPdiOn/BmtO97XpkpNGxnrRcPyeMYFFXdQkzsyKw+aTIHXp3rpYquH
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:20a1])
 (user=rananta job=sendgmr) by 2002:a25:c50e:0:b0:d89:4247:4191 with SMTP id
 v14-20020a25c50e000000b00d8942474191mr4108ybe.3.1695771623108; Tue, 26 Sep
 2023 16:40:23 -0700 (PDT)
Date: Tue, 26 Sep 2023 23:40:08 +0000
In-Reply-To: <20230926234008.2348607-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230926234008.2348607-1-rananta@google.com>
X-Mailer: git-send-email 2.42.0.582.g8ccd20d70d-goog
Message-ID: <20230926234008.2348607-12-rananta@google.com>
Subject: [PATCH v6 11/11] KVM: selftests: aarch64: vPMU register test for
 unimplemented counters
From: Raghavendra Rao Ananta <rananta@google.com>
To: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Shaoqin Huang <shahuang@redhat.com>, 
	Jing Zhang <jingzhangos@google.com>, Reiji Watanabe <reijiw@google.com>, 
	Colton Lewis <coltonlewis@google.com>, Raghavendra Rao Anata <rananta@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

From: Reiji Watanabe <reijiw@google.com>

Add a new test case to the vpmu_counter_access test to check
if PMU registers or their bits for unimplemented counters are not
accessible or are RAZ, as expected.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 .../kvm/aarch64/vpmu_counter_access.c         | 95 +++++++++++++++++--
 .../selftests/kvm/include/aarch64/processor.h |  1 +
 2 files changed, 87 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c b/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
index e92af3c0db039..788386ac08940 100644
--- a/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
+++ b/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
@@ -5,8 +5,8 @@
  * Copyright (c) 2022 Google LLC.
  *
  * This test checks if the guest can see the same number of the PMU event
- * counters (PMCR_EL0.N) that userspace sets, and if the guest can access
- * those counters.
+ * counters (PMCR_EL0.N) that userspace sets, if the guest can access
+ * those counters, and if the guest cannot access any other counters.
  * This test runs only when KVM_CAP_ARM_PMU_V3 is supported on the host.
  */
 #include <kvm_util.h>
@@ -131,9 +131,9 @@ static void write_pmevtypern(int n, unsigned long val)
 }
 
 /*
- * The pmc_accessor structure has pointers to PMEVT{CNTR,TYPER}<n>_EL0
+ * The pmc_accessor structure has pointers to PMEV{CNTR,TYPER}<n>_EL0
  * accessors that test cases will use. Each of the accessors will
- * either directly reads/writes PMEVT{CNTR,TYPER}<n>_EL0
+ * either directly reads/writes PMEV{CNTR,TYPER}<n>_EL0
  * (i.e. {read,write}_pmev{cnt,type}rn()), or reads/writes them through
  * PMXEV{CNTR,TYPER}_EL0 (i.e. {read,write}_sel_ev{cnt,type}r()).
  *
@@ -291,25 +291,85 @@ static void test_access_pmc_regs(struct pmc_accessor *acc, int pmc_idx)
 		       pmc_idx, PMC_ACC_TO_IDX(acc), read_data, write_data);
 }
 
+#define INVALID_EC	(-1ul)
+uint64_t expected_ec = INVALID_EC;
+uint64_t op_end_addr;
+
 static void guest_sync_handler(struct ex_regs *regs)
 {
 	uint64_t esr, ec;
 
 	esr = read_sysreg(esr_el1);
 	ec = (esr >> ESR_EC_SHIFT) & ESR_EC_MASK;
-	__GUEST_ASSERT(0, "PC: 0x%lx; ESR: 0x%lx; EC: 0x%lx", regs->pc, esr, ec);
+
+	__GUEST_ASSERT(op_end_addr && (expected_ec == ec),
+			"PC: 0x%lx; ESR: 0x%lx; EC: 0x%lx; EC expected: 0x%lx",
+			regs->pc, esr, ec, expected_ec);
+
+	/* Will go back to op_end_addr after the handler exits */
+	regs->pc = op_end_addr;
+
+	/*
+	 * Clear op_end_addr, and setting expected_ec to INVALID_EC
+	 * as a sign that an exception has occurred.
+	 */
+	op_end_addr = 0;
+	expected_ec = INVALID_EC;
+}
+
+/*
+ * Run the given operation that should trigger an exception with the
+ * given exception class. The exception handler (guest_sync_handler)
+ * will reset op_end_addr to 0, and expected_ec to INVALID_EC, and
+ * will come back to the instruction at the @done_label.
+ * The @done_label must be a unique label in this test program.
+ */
+#define TEST_EXCEPTION(ec, ops, done_label)		\
+{							\
+	extern int done_label;				\
+							\
+	WRITE_ONCE(op_end_addr, (uint64_t)&done_label);	\
+	GUEST_ASSERT(ec != INVALID_EC);			\
+	WRITE_ONCE(expected_ec, ec);			\
+	dsb(ish);					\
+	ops;						\
+	asm volatile(#done_label":");			\
+	GUEST_ASSERT(!op_end_addr);			\
+	GUEST_ASSERT(expected_ec == INVALID_EC);	\
+}
+
+/*
+ * Tests for reading/writing registers for the unimplemented event counter
+ * specified by @pmc_idx (>= PMCR_EL0.N).
+ */
+static void test_access_invalid_pmc_regs(struct pmc_accessor *acc, int pmc_idx)
+{
+	/*
+	 * Reading/writing the event count/type registers should cause
+	 * an UNDEFINED exception.
+	 */
+	TEST_EXCEPTION(ESR_EC_UNKNOWN, acc->read_cntr(pmc_idx), inv_rd_cntr);
+	TEST_EXCEPTION(ESR_EC_UNKNOWN, acc->write_cntr(pmc_idx, 0), inv_wr_cntr);
+	TEST_EXCEPTION(ESR_EC_UNKNOWN, acc->read_typer(pmc_idx), inv_rd_typer);
+	TEST_EXCEPTION(ESR_EC_UNKNOWN, acc->write_typer(pmc_idx, 0), inv_wr_typer);
+	/*
+	 * The bit corresponding to the (unimplemented) counter in
+	 * {PMCNTEN,PMOVS}{SET,CLR}_EL1 registers should be RAZ.
+	 */
+	test_bitmap_pmu_regs(pmc_idx, 1);
+	test_bitmap_pmu_regs(pmc_idx, 0);
 }
 
 /*
  * The guest is configured with PMUv3 with @expected_pmcr_n number of
  * event counters.
  * Check if @expected_pmcr_n is consistent with PMCR_EL0.N, and
- * if reading/writing PMU registers for implemented counters can work
- * as expected.
+ * if reading/writing PMU registers for implemented or unimplemented
+ * counters can work as expected.
  */
 static void guest_code(uint64_t expected_pmcr_n)
 {
-	uint64_t pmcr, pmcr_n;
+	uint64_t pmcr, pmcr_n, unimp_mask;
 	int i, pmc;
 
 	__GUEST_ASSERT(expected_pmcr_n <= ARMV8_PMU_MAX_GENERAL_COUNTERS,
@@ -324,15 +384,32 @@ static void guest_code(uint64_t expected_pmcr_n)
 			"Expected PMCR.N: 0x%lx, PMCR.N: 0x%lx",
 			pmcr_n, expected_pmcr_n);
 
+	/*
+	 * Make sure that (RAZ) bits corresponding to unimplemented event
+	 * counters in {PMCNTEN,PMOVS}{SET,CLR}_EL1 registers are reset to zero.
+	 * (NOTE: bits for implemented event counters are reset to UNKNOWN)
+	 */
+	unimp_mask = GENMASK_ULL(ARMV8_PMU_MAX_GENERAL_COUNTERS - 1, pmcr_n);
+	check_bitmap_pmu_regs(unimp_mask, false);
+
 	/*
 	 * Tests for reading/writing PMU registers for implemented counters.
-	 * Use each combination of PMEVT{CNTR,TYPER}<n>_EL0 accessor functions.
+	 * Use each combination of PMEV{CNTR,TYPER}<n>_EL0 accessor functions.
 	 */
 	for (i = 0; i < ARRAY_SIZE(pmc_accessors); i++) {
 		for (pmc = 0; pmc < pmcr_n; pmc++)
 			test_access_pmc_regs(&pmc_accessors[i], pmc);
 	}
 
+	/*
+	 * Tests for reading/writing PMU registers for unimplemented counters.
+	 * Use each combination of PMEV{CNTR,TYPER}<n>_EL0 accessor functions.
+	 */
+	for (i = 0; i < ARRAY_SIZE(pmc_accessors); i++) {
+		for (pmc = pmcr_n; pmc < ARMV8_PMU_MAX_GENERAL_COUNTERS; pmc++)
+			test_access_invalid_pmc_regs(&pmc_accessors[i], pmc);
+	}
+
 	GUEST_DONE();
 }
 
diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
index cb537253a6b9c..c42d683102c7a 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -104,6 +104,7 @@ enum {
 #define ESR_EC_SHIFT		26
 #define ESR_EC_MASK		(ESR_EC_NUM - 1)
 
+#define ESR_EC_UNKNOWN		0x0
 #define ESR_EC_SVC64		0x15
 #define ESR_EC_IABT		0x21
 #define ESR_EC_DABT		0x25
-- 
2.42.0.582.g8ccd20d70d-goog

