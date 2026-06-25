Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 815993A75B8
	for <kvmarm@lists.linux.dev>; Thu, 25 Jun 2026 14:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782398902; cv=none; b=nEDZ9hAJ4kirhpytW82xJhGaLzlxVqh2VXxDQnY55rrgkkwVj3MI0xU/I06WebyLkK/pddXD3Of0kWJi3UrGDicrVrzDUUdPHSZTHCNhWn799hlD46USO3ja2Dmqe8ps+nnL25LX6gZFtdDLr28y+SW4AzTyJ6vH8ylV0rnLLNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782398902; c=relaxed/simple;
	bh=lvX9FflBNTiBjdUhkkpAhMb4Ul1InAuzvOgo3XWTDZQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LHcaA1jpH2g0Fgj/+M2wvVwjTQD2EbgTytK9LoUQo56CuFW9BOPJKP0zh0p2wu41CYVqwutyDs7D48GD7N9bLpdsnKCLh3qmtRhSBqEKSGK5daZIXjqA2O0sJSTkGijsyat6lgWHy8Exu9pipgH1abQKFJKazOHojSxLi+jCzw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=dlaPYe1F; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="dlaPYe1F"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782398898;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=734qaU1tQelPPkEQYjTXfKoHnBuUcIAlHaI48ASBazw=;
	b=dlaPYe1FdAaYc4wBXwtTQkFrP0HCeWAENGQDLbVugIASPMUiGKwttzM6cBF/7IiQfcXuVj
	Qb4sQAy76Du/hSX6/s/n7BqKFQFOf2AREOxInWCnftv7SOlMXBUL2d55q1WmRQZMup7aUr
	x0ZOX+JJkSvIZKICHTprpkmjQiJTHq4=
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Christoffer Dall <christoffer.dall@linaro.org>,
	Victor Kamensky <victor.kamensky@linaro.org>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] KVM: arm64: selftests: Add MMIO sign-extending load test
Date: Thu, 25 Jun 2026 15:48:07 +0100
Message-Id: <20260625144807.2603272-3-fuad.tabba@linux.dev>
In-Reply-To: <20260625144807.2603272-1-fuad.tabba@linux.dev>
References: <20260625144807.2603272-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Add a test for sign-extending MMIO loads (LDRSB, LDRSH, LDRSW) into Xt
and Wt destinations, with and without the sign bit set. The host supplies
the MMIO data and checks the guest register holds the sign-extended value.

Repeat the loads big-endian on a mixed-endian implementation. Issue those
at EL0: SCTLR_EL1.EE would make an EL1 load big-endian but also walk the
little-endian page tables big-endian, whereas SCTLR_EL1.E0E selects only
EL0 data endianness and leaves the walk little-endian.

Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../selftests/kvm/arm64/mmio_sign_ext.c       | 259 ++++++++++++++++++
 2 files changed, 260 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/arm64/mmio_sign_ext.c

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index 9118a5a51b89f..0f5803a1092e1 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -171,6 +171,7 @@ TEST_GEN_PROGS_arm64 += arm64/hello_el2
 TEST_GEN_PROGS_arm64 += arm64/host_sve
 TEST_GEN_PROGS_arm64 += arm64/hypercalls
 TEST_GEN_PROGS_arm64 += arm64/external_aborts
+TEST_GEN_PROGS_arm64 += arm64/mmio_sign_ext
 TEST_GEN_PROGS_arm64 += arm64/page_fault_test
 TEST_GEN_PROGS_arm64 += arm64/psci_test
 TEST_GEN_PROGS_arm64 += arm64/sea_to_user
diff --git a/tools/testing/selftests/kvm/arm64/mmio_sign_ext.c b/tools/testing/selftests/kvm/arm64/mmio_sign_ext.c
new file mode 100644
index 0000000000000..06708ab6db8c0
--- /dev/null
+++ b/tools/testing/selftests/kvm/arm64/mmio_sign_ext.c
@@ -0,0 +1,259 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * mmio_sign_ext - Test sign-extending MMIO load emulation (LDRSB/LDRSH/LDRSW)
+ *
+ * Copyright (c) 2026 Google LLC
+ */
+
+#include <asm/ptrace.h>
+
+#include "processor.h"
+#include "test_util.h"
+
+#define MMIO_ADDR	0x8000000ULL
+
+/* AP[1]: allow unprivileged (EL0) access to a mapping. */
+#define PTE_USER	BIT(6)
+
+/* SPSR for ERET to EL0t with DAIF masked. */
+#define SPSR_EL0	(PSR_MODE_EL0t | PSR_D_BIT | PSR_A_BIT | PSR_I_BIT | PSR_F_BIT)
+
+struct mmio_test {
+	const char *name;
+	uint64_t data;		/* access-width value, host byte order */
+	uint8_t len;
+	uint64_t expected;	/* sign-extended result; same for LE and BE */
+};
+
+/* Paired 1:1, in order, with the loads in guest_loads_le() and el0_be_loads. */
+static const struct mmio_test tests[] = {
+	/* LDRSB Xt: byte sign-extended to 64 bits */
+	{ "LDRSB Xt 0xFF",	0xFF,		1, 0xFFFFFFFFFFFFFFFFULL },
+	{ "LDRSB Xt 0x7F",	0x7F,		1, 0x7FULL },
+
+	/* LDRSB Wt: byte sign-extended to 32 bits, upper 32 bits zeroed */
+	{ "LDRSB Wt 0xFF",	0xFF,		1, 0xFFFFFFFFULL },
+	{ "LDRSB Wt 0x7F",	0x7F,		1, 0x7FULL },
+
+	/* LDRSH Xt: halfword sign-extended to 64 bits */
+	{ "LDRSH Xt 0x8001",	0x8001,		2, 0xFFFFFFFFFFFF8001ULL },
+	{ "LDRSH Xt 0x7FFF",	0x7FFF,		2, 0x7FFFULL },
+
+	/* LDRSH Wt: halfword sign-extended to 32 bits, upper 32 bits zeroed */
+	{ "LDRSH Wt 0x8001",	0x8001,		2, 0xFFFF8001ULL },
+	{ "LDRSH Wt 0x7FFF",	0x7FFF,		2, 0x7FFFULL },
+
+	/* LDRSW Xt: word sign-extended to 64 bits (no Wt form) */
+	{ "LDRSW Xt 0x80000001", 0x80000001,	4, 0xFFFFFFFF80000001ULL },
+	{ "LDRSW Xt 0x7FFFFFFF", 0x7FFFFFFF,	4, 0x7FFFFFFFULL },
+};
+
+/* Issue one sign-extending load from MMIO and report the result. */
+#define GUEST_LDRS(load) do {						\
+	uint64_t val;							\
+									\
+	asm volatile(load : "=r"(val) : "r"(MMIO_ADDR) : "memory");	\
+	GUEST_SYNC(val);						\
+} while (0)
+
+/* Little-endian pass: loads issued at EL1. */
+static void guest_loads_le(void)
+{
+	GUEST_LDRS("ldrsb %0, [%1]");
+	GUEST_LDRS("ldrsb %0, [%1]");
+	GUEST_LDRS("ldrsb %w0, [%1]");
+	GUEST_LDRS("ldrsb %w0, [%1]");
+	GUEST_LDRS("ldrsh %0, [%1]");
+	GUEST_LDRS("ldrsh %0, [%1]");
+	GUEST_LDRS("ldrsh %w0, [%1]");
+	GUEST_LDRS("ldrsh %w0, [%1]");
+	GUEST_LDRS("ldrsw %0, [%1]");
+	GUEST_LDRS("ldrsw %0, [%1]");
+}
+
+/*
+ * Run the big-endian loads at EL0, where SCTLR_EL1.E0E flips only the data
+ * endianness; at EL1, SCTLR_EL1.EE would also flip the page-table walk and
+ * fault on the little-endian tables. x0 holds MMIO_ADDR; results return in
+ * x19..x28 (tests[] order) via a single SVC.
+ */
+extern char el0_be_loads[], el0_be_loads_end[];
+asm(
+"	.pushsection .text, \"ax\"\n"
+"	.global el0_be_loads\n"
+"el0_be_loads:\n"
+"	ldrsb	x19, [x0]\n"
+"	ldrsb	x20, [x0]\n"
+"	ldrsb	w21, [x0]\n"
+"	ldrsb	w22, [x0]\n"
+"	ldrsh	x23, [x0]\n"
+"	ldrsh	x24, [x0]\n"
+"	ldrsh	w25, [x0]\n"
+"	ldrsh	w26, [x0]\n"
+"	ldrsw	x27, [x0]\n"
+"	ldrsw	x28, [x0]\n"
+"	svc	#0\n"
+"	.global el0_be_loads_end\n"
+"el0_be_loads_end:\n"
+"	.popsection\n"
+);
+
+/* EL1 handler for the EL0 SVC: report the results, then finish. */
+static void el0_svc_handler(struct ex_regs *regs)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(tests); i++)
+		GUEST_SYNC(regs->regs[19 + i]);
+
+	GUEST_DONE();
+}
+
+static bool guest_mixed_endian_el0(void)
+{
+	uint64_t mmfr0 = read_sysreg(id_aa64mmfr0_el1);
+
+	return SYS_FIELD_GET(ID_AA64MMFR0_EL1, BIGEND, mmfr0) ||
+	       SYS_FIELD_GET(ID_AA64MMFR0_EL1, BIGENDEL0, mmfr0);
+}
+
+static void guest_code(void)
+{
+	guest_loads_le();
+
+	if (guest_mixed_endian_el0()) {
+		write_sysreg(read_sysreg(sctlr_el1) | SCTLR_EL1_E0E, sctlr_el1);
+		isb();
+
+		asm volatile(
+		"	msr	elr_el1, %[pc]\n"
+		"	msr	spsr_el1, %[spsr]\n"
+		"	mov	x0, %[mmio]\n"
+		"	isb\n"
+		"	eret\n"
+		:
+		: [pc] "r"(el0_be_loads),
+		  [spsr] "r"((uint64_t)SPSR_EL0),
+		  [mmio] "r"(MMIO_ADDR)
+		: "x0", "memory");
+		__builtin_unreachable();	/* el0_svc_handler ends the test */
+	}
+
+	GUEST_DONE();
+}
+
+static void handle_mmio(struct kvm_run *run, const struct mmio_test *t, bool be)
+{
+	int i;
+
+	TEST_ASSERT_EQ(run->mmio.phys_addr, MMIO_ADDR);
+	TEST_ASSERT(!run->mmio.is_write, "Expected MMIO read for %s", t->name);
+	TEST_ASSERT_EQ(run->mmio.len, t->len);
+
+	memset(run->mmio.data, 0, sizeof(run->mmio.data));
+	if (be) {
+		/* The guest reads the device bytes most-significant first. */
+		for (i = 0; i < t->len; i++)
+			run->mmio.data[i] = t->data >> (8 * (t->len - 1 - i));
+	} else {
+		/* Works because arm64 KVM hosts are always little-endian. */
+		memcpy(run->mmio.data, &t->data, t->len);
+	}
+}
+
+static void expect_sync(struct kvm_vcpu *vcpu, struct ucall *uc,
+			const struct mmio_test *t)
+{
+	switch (get_ucall(vcpu, uc)) {
+	case UCALL_SYNC:
+		TEST_ASSERT(uc->args[1] == t->expected,
+			    "%s: got %#lx, want %#lx", t->name,
+			    (unsigned long)uc->args[1], (unsigned long)t->expected);
+		break;
+	case UCALL_ABORT:
+		REPORT_GUEST_ASSERT(*uc);
+		break;
+	default:
+		TEST_FAIL("Unexpected ucall for %s", t->name);
+	}
+}
+
+/* OR PTE_USER into the leaf descriptors covering [gva, gva + len). */
+static void make_el0_accessible(struct kvm_vm *vm, uint64_t gva, uint64_t len)
+{
+	uint64_t addr;
+
+	for (addr = gva & ~((uint64_t)vm->page_size - 1); addr < gva + len;
+	     addr += vm->page_size)
+		*virt_get_pte_hva(vm, addr) |= PTE_USER;
+}
+
+static bool vcpu_mixed_endian_el0(struct kvm_vcpu *vcpu)
+{
+	uint64_t mmfr0 = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64MMFR0_EL1));
+
+	return SYS_FIELD_GET(ID_AA64MMFR0_EL1, BIGEND, mmfr0) ||
+	       SYS_FIELD_GET(ID_AA64MMFR0_EL1, BIGENDEL0, mmfr0);
+}
+
+int main(void)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	struct ucall uc;
+	unsigned int i;
+	bool be;
+
+	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
+	virt_map(vm, MMIO_ADDR, MMIO_ADDR, 1);
+
+	vm_init_descriptor_tables(vm);
+	vcpu_init_descriptor_tables(vcpu);
+	vm_install_sync_handler(vm, VECTOR_SYNC_LOWER_64, ESR_ELx_EC_SVC64,
+				el0_svc_handler);
+
+	be = vcpu_mixed_endian_el0(vcpu);
+	if (be) {
+		make_el0_accessible(vm, MMIO_ADDR, vm->page_size);
+		make_el0_accessible(vm, (uint64_t)el0_be_loads,
+				    el0_be_loads_end - el0_be_loads);
+	}
+
+	ksft_print_header();
+	ksft_set_plan(ARRAY_SIZE(tests) * (be ? 2 : 1));
+
+	/* Little-endian pass: one load and one result per iteration. */
+	for (i = 0; i < ARRAY_SIZE(tests); i++) {
+		const struct mmio_test *t = &tests[i];
+
+		vcpu_run(vcpu);
+		TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_MMIO);
+		handle_mmio(vcpu->run, t, false);
+
+		vcpu_run(vcpu);
+		expect_sync(vcpu, &uc, t);
+
+		ksft_test_result_pass("%s\n", t->name);
+	}
+
+	if (be) {
+		/* The EL0 stub issues all the loads, then reports the results. */
+		for (i = 0; i < ARRAY_SIZE(tests); i++) {
+			vcpu_run(vcpu);
+			TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_MMIO);
+			handle_mmio(vcpu->run, &tests[i], true);
+		}
+		for (i = 0; i < ARRAY_SIZE(tests); i++) {
+			vcpu_run(vcpu);
+			expect_sync(vcpu, &uc, &tests[i]);
+			ksft_test_result_pass("BE %s\n", tests[i].name);
+		}
+	}
+
+	vcpu_run(vcpu);
+	TEST_ASSERT(get_ucall(vcpu, &uc) == UCALL_DONE, "Expected UCALL_DONE");
+
+	kvm_vm_free(vm);
+
+	ksft_finished();
+}
-- 
2.39.5

