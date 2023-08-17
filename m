Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47DAE14002
	for <kvmarm@lists.linux.dev>; Thu, 17 Aug 2023 00:30:45 +0000 (UTC)
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-57320c10635so93326647b3.3
        for <kvmarm@lists.linux.dev>; Wed, 16 Aug 2023 17:30:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692232244; x=1692837044;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QY9Bi196f8rMXJoUWr+B9aBhr8w9IYaI6gEf0CO+e/A=;
        b=IQgDRbEzWHIPChvCM0AwZ4SGraCZw/DbzeOQ7qllSuV/cQHre1m8cduXNC4m9mqGSF
         tR7dxOHf7S+wQCiAMBMmEfru4WSt94hgZK+AcSBrnA4f4sRg0MJd8O24JJTlMZPs2XhG
         a3PdgGm4r/fTRkP42UUzBNP2HCrZKjkaTsG5Ww6IvqRM+g4KJPbZqrhTUcLWgzv9P9pa
         wRU7arp0g8jc0+5Q8jeLePoHEbwwzdVxsFpZhPzL6Fiq6o6eFK7WByFdJcG9z+o6xLNW
         B0oommZ211QyDjmiFAn64hm1Cezz2xpD7plRgprOOXBaulC7qz8jVu/m30bkPlq+ccbA
         YQbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692232244; x=1692837044;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QY9Bi196f8rMXJoUWr+B9aBhr8w9IYaI6gEf0CO+e/A=;
        b=A0rd4qoPYEVNAFkc85cDpkCjX2s9cdagaZ8z2MYRvGKvGVs5J8k+JbFuqoG87h6nfp
         HjdwUSkm4+IKxink5EbrTld5j/1pUFueGzDqzk9rWF/fidScJw4ibnPTSbrKH79gPc0J
         zzQ1bMihL5QyBX0EBiwzvtLMuGSXBc3KBAoO77iH/j1psCuoGoEYeUfvTWiG8jq7lBoB
         VZCNnkJui30cnUcC2s9zIh8YC4+8epandVheJQoIEwiP42S9RpLKj2u0aPgCh+TzAGp4
         M2UGZ3MSsiJQRXBf5W6JL5x+uB9LIOiqxa2itrbwUlmRb5WapZFn1DtQOFw8HQ+LNQ9O
         3k/Q==
X-Gm-Message-State: AOJu0YxD9rDZVwD1xTIHQh+vG9MeIm2SN4dyg+bn4hiNNPfyIYfp+2NO
	jjEGt7okoO83ucTb7dbVq0Z9TpzoS1YT
X-Google-Smtp-Source: AGHT+IF6V4OIDSZvsYaTAcm3yv36Sv9/5uoBOEeQ1huPqUtwwmALoCxFYIisr2fI6KFHOzLEnHE8U83a/Hgu
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a05:690c:731:b0:586:4eae:b943 with SMTP id
 bt17-20020a05690c073100b005864eaeb943mr47700ywb.8.1692232244398; Wed, 16 Aug
 2023 17:30:44 -0700 (PDT)
Date: Thu, 17 Aug 2023 00:30:28 +0000
In-Reply-To: <20230817003029.3073210-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230817003029.3073210-1-rananta@google.com>
X-Mailer: git-send-email 2.41.0.694.ge786442a9b-goog
Message-ID: <20230817003029.3073210-12-rananta@google.com>
Subject: [PATCH v5 11/12] KVM: selftests: aarch64: vPMU register test for
 implemented counters
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

Add a new test case to the vpmu_counter_access test to check if PMU
registers or their bits for implemented counters on the vCPU are
readable/writable as expected, and can be programmed to count events.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 .../kvm/aarch64/vpmu_counter_access.c         | 264 +++++++++++++++++-
 1 file changed, 261 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c b/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
index d0afec07948ef..3a2cf38bb415d 100644
--- a/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
+++ b/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
@@ -5,7 +5,8 @@
  * Copyright (c) 2022 Google LLC.
  *
  * This test checks if the guest can see the same number of the PMU event
- * counters (PMCR_EL0.N) that userspace sets.
+ * counters (PMCR_EL0.N) that userspace sets, and if the guest can access
+ * those counters.
  * This test runs only when KVM_CAP_ARM_PMU_V3 is supported on the host.
  */
 #include <kvm_util.h>
@@ -24,6 +25,251 @@ struct vpmu_vm {
 	int gic_fd;
 };
 
+/* Read PMEVTCNTR<n>_EL0 through PMXEVCNTR_EL0 */
+static inline unsigned long read_sel_evcntr(int sel)
+{
+	write_sysreg(sel, pmselr_el0);
+	isb();
+	return read_sysreg(pmxevcntr_el0);
+}
+
+/* Write PMEVTCNTR<n>_EL0 through PMXEVCNTR_EL0 */
+static inline void write_sel_evcntr(int sel, unsigned long val)
+{
+	write_sysreg(sel, pmselr_el0);
+	isb();
+	write_sysreg(val, pmxevcntr_el0);
+	isb();
+}
+
+/* Read PMEVTYPER<n>_EL0 through PMXEVTYPER_EL0 */
+static inline unsigned long read_sel_evtyper(int sel)
+{
+	write_sysreg(sel, pmselr_el0);
+	isb();
+	return read_sysreg(pmxevtyper_el0);
+}
+
+/* Write PMEVTYPER<n>_EL0 through PMXEVTYPER_EL0 */
+static inline void write_sel_evtyper(int sel, unsigned long val)
+{
+	write_sysreg(sel, pmselr_el0);
+	isb();
+	write_sysreg(val, pmxevtyper_el0);
+	isb();
+}
+
+static inline void enable_counter(int idx)
+{
+	uint64_t v = read_sysreg(pmcntenset_el0);
+
+	write_sysreg(BIT(idx) | v, pmcntenset_el0);
+	isb();
+}
+
+static inline void disable_counter(int idx)
+{
+	uint64_t v = read_sysreg(pmcntenset_el0);
+
+	write_sysreg(BIT(idx) | v, pmcntenclr_el0);
+	isb();
+}
+
+static void pmu_disable_reset(void)
+{
+	uint64_t pmcr = read_sysreg(pmcr_el0);
+
+	/* Reset all counters, disabling them */
+	pmcr &= ~ARMV8_PMU_PMCR_E;
+	write_sysreg(pmcr | ARMV8_PMU_PMCR_P, pmcr_el0);
+	isb();
+}
+
+#define RETURN_READ_PMEVCNTRN(n) \
+	return read_sysreg(pmevcntr##n##_el0)
+static unsigned long read_pmevcntrn(int n)
+{
+	PMEVN_SWITCH(n, RETURN_READ_PMEVCNTRN);
+	return 0;
+}
+
+#define WRITE_PMEVCNTRN(n) \
+	write_sysreg(val, pmevcntr##n##_el0)
+static void write_pmevcntrn(int n, unsigned long val)
+{
+	PMEVN_SWITCH(n, WRITE_PMEVCNTRN);
+	isb();
+}
+
+#define READ_PMEVTYPERN(n) \
+	return read_sysreg(pmevtyper##n##_el0)
+static unsigned long read_pmevtypern(int n)
+{
+	PMEVN_SWITCH(n, READ_PMEVTYPERN);
+	return 0;
+}
+
+#define WRITE_PMEVTYPERN(n) \
+	write_sysreg(val, pmevtyper##n##_el0)
+static void write_pmevtypern(int n, unsigned long val)
+{
+	PMEVN_SWITCH(n, WRITE_PMEVTYPERN);
+	isb();
+}
+
+/*
+ * The pmc_accessor structure has pointers to PMEVT{CNTR,TYPER}<n>_EL0
+ * accessors that test cases will use. Each of the accessors will
+ * either directly reads/writes PMEVT{CNTR,TYPER}<n>_EL0
+ * (i.e. {read,write}_pmev{cnt,type}rn()), or reads/writes them through
+ * PMXEV{CNTR,TYPER}_EL0 (i.e. {read,write}_sel_ev{cnt,type}r()).
+ *
+ * This is used to test that combinations of those accessors provide
+ * the consistent behavior.
+ */
+struct pmc_accessor {
+	/* A function to be used to read PMEVTCNTR<n>_EL0 */
+	unsigned long	(*read_cntr)(int idx);
+	/* A function to be used to write PMEVTCNTR<n>_EL0 */
+	void		(*write_cntr)(int idx, unsigned long val);
+	/* A function to be used to read PMEVTYPER<n>_EL0 */
+	unsigned long	(*read_typer)(int idx);
+	/* A function to be used to write PMEVTYPER<n>_EL0 */
+	void		(*write_typer)(int idx, unsigned long val);
+};
+
+struct pmc_accessor pmc_accessors[] = {
+	/* test with all direct accesses */
+	{ read_pmevcntrn, write_pmevcntrn, read_pmevtypern, write_pmevtypern },
+	/* test with all indirect accesses */
+	{ read_sel_evcntr, write_sel_evcntr, read_sel_evtyper, write_sel_evtyper },
+	/* read with direct accesses, and write with indirect accesses */
+	{ read_pmevcntrn, write_sel_evcntr, read_pmevtypern, write_sel_evtyper },
+	/* read with indirect accesses, and write with direct accesses */
+	{ read_sel_evcntr, write_pmevcntrn, read_sel_evtyper, write_pmevtypern },
+};
+
+/*
+ * Convert a pointer of pmc_accessor to an index in pmc_accessors[],
+ * assuming that the pointer is one of the entries in pmc_accessors[].
+ */
+#define PMC_ACC_TO_IDX(acc)	(acc - &pmc_accessors[0])
+
+#define GUEST_ASSERT_BITMAP_REG(regname, mask, set_expected)		\
+{									\
+	uint64_t _tval = read_sysreg(regname);				\
+									\
+	if (set_expected)						\
+		GUEST_ASSERT_3((_tval & mask), _tval, mask, set_expected); \
+	else								   \
+		GUEST_ASSERT_3(!(_tval & mask), _tval, mask, set_expected);\
+}
+
+/*
+ * Check if @mask bits in {PMCNTEN,PMINTEN,PMOVS}{SET,CLR} registers
+ * are set or cleared as specified in @set_expected.
+ */
+static void check_bitmap_pmu_regs(uint64_t mask, bool set_expected)
+{
+	GUEST_ASSERT_BITMAP_REG(pmcntenset_el0, mask, set_expected);
+	GUEST_ASSERT_BITMAP_REG(pmcntenclr_el0, mask, set_expected);
+	GUEST_ASSERT_BITMAP_REG(pmintenset_el1, mask, set_expected);
+	GUEST_ASSERT_BITMAP_REG(pmintenclr_el1, mask, set_expected);
+	GUEST_ASSERT_BITMAP_REG(pmovsset_el0, mask, set_expected);
+	GUEST_ASSERT_BITMAP_REG(pmovsclr_el0, mask, set_expected);
+}
+
+/*
+ * Check if the bit in {PMCNTEN,PMINTEN,PMOVS}{SET,CLR} registers corresponding
+ * to the specified counter (@pmc_idx) can be read/written as expected.
+ * When @set_op is true, it tries to set the bit for the counter in
+ * those registers by writing the SET registers (the bit won't be set
+ * if the counter is not implemented though).
+ * Otherwise, it tries to clear the bits in the registers by writing
+ * the CLR registers.
+ * Then, it checks if the values indicated in the registers are as expected.
+ */
+static void test_bitmap_pmu_regs(int pmc_idx, bool set_op)
+{
+	uint64_t pmcr_n, test_bit = BIT(pmc_idx);
+	bool set_expected = false;
+
+	if (set_op) {
+		write_sysreg(test_bit, pmcntenset_el0);
+		write_sysreg(test_bit, pmintenset_el1);
+		write_sysreg(test_bit, pmovsset_el0);
+
+		/* The bit will be set only if the counter is implemented */
+		pmcr_n = FIELD_GET(ARMV8_PMU_PMCR_N, read_sysreg(pmcr_el0));
+		set_expected = (pmc_idx < pmcr_n) ? true : false;
+	} else {
+		write_sysreg(test_bit, pmcntenclr_el0);
+		write_sysreg(test_bit, pmintenclr_el1);
+		write_sysreg(test_bit, pmovsclr_el0);
+	}
+	check_bitmap_pmu_regs(test_bit, set_expected);
+}
+
+/*
+ * Tests for reading/writing registers for the (implemented) event counter
+ * specified by @pmc_idx.
+ */
+static void test_access_pmc_regs(struct pmc_accessor *acc, int pmc_idx)
+{
+	uint64_t write_data, read_data;
+
+	/* Disable all PMCs and reset all PMCs to zero. */
+	pmu_disable_reset();
+
+
+	/*
+	 * Tests for reading/writing {PMCNTEN,PMINTEN,PMOVS}{SET,CLR}_EL1.
+	 */
+
+	/* Make sure that the bit in those registers are set to 0 */
+	test_bitmap_pmu_regs(pmc_idx, false);
+	/* Test if setting the bit in those registers works */
+	test_bitmap_pmu_regs(pmc_idx, true);
+	/* Test if clearing the bit in those registers works */
+	test_bitmap_pmu_regs(pmc_idx, false);
+
+
+	/*
+	 * Tests for reading/writing the event type register.
+	 */
+
+	read_data = acc->read_typer(pmc_idx);
+	/*
+	 * Set the event type register to an arbitrary value just for testing
+	 * of reading/writing the register.
+	 * ArmARM says that for the event from 0x0000 to 0x003F,
+	 * the value indicated in the PMEVTYPER<n>_EL0.evtCount field is
+	 * the value written to the field even when the specified event
+	 * is not supported.
+	 */
+	write_data = (ARMV8_PMU_EXCLUDE_EL1 | ARMV8_PMUV3_PERFCTR_INST_RETIRED);
+	acc->write_typer(pmc_idx, write_data);
+	read_data = acc->read_typer(pmc_idx);
+	GUEST_ASSERT_4(read_data == write_data,
+		       pmc_idx, PMC_ACC_TO_IDX(acc), read_data, write_data);
+
+
+	/*
+	 * Tests for reading/writing the event count register.
+	 */
+
+	read_data = acc->read_cntr(pmc_idx);
+
+	/* The count value must be 0, as it is not used after the reset */
+	GUEST_ASSERT_3(read_data == 0, pmc_idx, acc, read_data);
+
+	write_data = read_data + pmc_idx + 0x12345;
+	acc->write_cntr(pmc_idx, write_data);
+	read_data = acc->read_cntr(pmc_idx);
+	GUEST_ASSERT_4(read_data == write_data,
+		       pmc_idx, PMC_ACC_TO_IDX(acc), read_data, write_data);
+}
+
 static void guest_sync_handler(struct ex_regs *regs)
 {
 	uint64_t esr, ec;
@@ -36,11 +282,14 @@ static void guest_sync_handler(struct ex_regs *regs)
 /*
  * The guest is configured with PMUv3 with @expected_pmcr_n number of
  * event counters.
- * Check if @expected_pmcr_n is consistent with PMCR_EL0.N.
+ * Check if @expected_pmcr_n is consistent with PMCR_EL0.N, and
+ * if reading/writing PMU registers for implemented counters can work
+ * as expected.
  */
 static void guest_code(uint64_t expected_pmcr_n)
 {
 	uint64_t pmcr, pmcr_n;
+	int i, pmc;
 
 	GUEST_ASSERT(expected_pmcr_n <= ARMV8_PMU_MAX_GENERAL_COUNTERS);
 
@@ -50,6 +299,15 @@ static void guest_code(uint64_t expected_pmcr_n)
 	/* Make sure that PMCR_EL0.N indicates the value userspace set */
 	GUEST_ASSERT_2(pmcr_n == expected_pmcr_n, pmcr_n, expected_pmcr_n);
 
+	/*
+	 * Tests for reading/writing PMU registers for implemented counters.
+	 * Use each combination of PMEVT{CNTR,TYPER}<n>_EL0 accessor functions.
+	 */
+	for (i = 0; i < ARRAY_SIZE(pmc_accessors); i++) {
+		for (pmc = 0; pmc < pmcr_n; pmc++)
+			test_access_pmc_regs(&pmc_accessors[i], pmc);
+	}
+
 	GUEST_DONE();
 }
 
@@ -121,7 +379,7 @@ static void run_vcpu(struct kvm_vcpu *vcpu, uint64_t pmcr_n)
 	vcpu_run(vcpu);
 	switch (get_ucall(vcpu, &uc)) {
 	case UCALL_ABORT:
-		REPORT_GUEST_ASSERT_2(uc, "values:%#lx %#lx");
+		REPORT_GUEST_ASSERT_4(uc, "values:%#lx %#lx %#lx %#lx");
 		break;
 	case UCALL_DONE:
 		break;
-- 
2.41.0.694.ge786442a9b-goog

