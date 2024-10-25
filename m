Received: from out-187.mta0.migadu.com (out-187.mta0.migadu.com [91.218.175.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 719A217DFEC
	for <kvmarm@lists.linux.dev>; Fri, 25 Oct 2024 20:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729888288; cv=none; b=Q2+JUDx76t3MAn6cMDzzfolC3XL0UvXnnnmfJypIQBwp2f+8qvuTFS6biHeB9oik/BcA9DZc6vnKY+dlNyWSv+MuTGV/WjYYfFYGMong8ogEWhmU7cNMAKuHd0gKYZZQ6b4ZReAGdnQ2I4kL+Nxo1z7VyK6ndqA5fygZjvGTdi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729888288; c=relaxed/simple;
	bh=MbiGJ0ujJwGcnP9PmS5KJJnlBCbM+3qKJf5Gw0KB7cg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g7YLjDrQ1Ce+WdEcuJ/mF5O9JIUsTIXFv9hHMyekdfefkvUKcwdba83N9Bl7ypUBu2p8gFoUpoUgrSP8i3MsAPzIkBS6uKkzOtE589BfwU85mkhl4xNKC4LXHeicCVHmjga/TFGH+1IVCBwp55jIABPHm+gSKI+UubuC6WBm9eY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Fjg830mk; arc=none smtp.client-ip=91.218.175.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Fjg830mk"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729888283;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DLX9HduVMdOUKtiLy3PdgYWO26sFAp3kbOX0y77xaq0=;
	b=Fjg830mkPiYmfzGX7TA/ho2SRF1YTUNaA193p2bd4QqFGKMjfqDSh31+YQmMIFz6Xj+pfi
	UBFogfTrqOB6BuRQV5YP+lxd1I0qtkG4pJanagNvtMXl/4nkgIsNxg19qXP8znBRuByFRy
	wvZsnBVlZdenBJ5PTo4aGG5NvkD0tcs=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 4/4] KVM: arm64: selftests: Add tests for MMIO external abort injection
Date: Fri, 25 Oct 2024 20:31:06 +0000
Message-ID: <20241025203106.3529261-5-oliver.upton@linux.dev>
In-Reply-To: <20241025203106.3529261-1-oliver.upton@linux.dev>
References: <20241025203106.3529261-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Test that the plumbing exposed to userspace for injecting aborts in
response to unexpected MMIO works as intended in two different flavors:

 - A 'normal' MMIO instruction (i.e. ESR_ELx.ISV=1)

 - An ISV=0 MMIO instruction with/without KVM_CAP_ARM_NISV_TO_USER
   enabled

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/aarch64/mmio_abort.c        | 159 ++++++++++++++++++
 2 files changed, 160 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/aarch64/mmio_abort.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 960cf6a77198..98957a99ead6 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -156,6 +156,7 @@ TEST_GEN_PROGS_aarch64 += aarch64/aarch32_id_regs
 TEST_GEN_PROGS_aarch64 += aarch64/arch_timer_edge_cases
 TEST_GEN_PROGS_aarch64 += aarch64/debug-exceptions
 TEST_GEN_PROGS_aarch64 += aarch64/hypercalls
+TEST_GEN_PROGS_aarch64 += aarch64/mmio_abort
 TEST_GEN_PROGS_aarch64 += aarch64/page_fault_test
 TEST_GEN_PROGS_aarch64 += aarch64/psci_test
 TEST_GEN_PROGS_aarch64 += aarch64/set_id_regs
diff --git a/tools/testing/selftests/kvm/aarch64/mmio_abort.c b/tools/testing/selftests/kvm/aarch64/mmio_abort.c
new file mode 100644
index 000000000000..8b7a80a51b1c
--- /dev/null
+++ b/tools/testing/selftests/kvm/aarch64/mmio_abort.c
@@ -0,0 +1,159 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * mmio_abort - Tests for userspace MMIO abort injection
+ *
+ * Copyright (c) 2024 Google LLC
+ */
+#include "processor.h"
+#include "test_util.h"
+
+#define MMIO_ADDR	0x8000000ULL
+
+static u64 expected_abort_pc;
+
+static void expect_sea_handler(struct ex_regs *regs)
+{
+	u64 esr = read_sysreg(esr_el1);
+
+	GUEST_ASSERT_EQ(regs->pc, expected_abort_pc);
+	GUEST_ASSERT_EQ(ESR_ELx_EC(esr), ESR_ELx_EC_DABT_CUR);
+	GUEST_ASSERT_EQ(esr & ESR_ELx_FSC_TYPE, ESR_ELx_FSC_EXTABT);
+
+	GUEST_DONE();
+}
+
+static void unexpected_dabt_handler(struct ex_regs *regs)
+{
+	GUEST_FAIL("Unexpected data abort at PC: %lx\n", regs->pc);
+}
+
+static struct kvm_vm *vm_create_with_dabt_handler(struct kvm_vcpu **vcpu, void *guest_code,
+						  handler_fn dabt_handler)
+{
+	struct kvm_vm *vm = vm_create_with_one_vcpu(vcpu, guest_code);
+
+	vm_init_descriptor_tables(vm);
+	vcpu_init_descriptor_tables(*vcpu);
+	vm_install_sync_handler(vm, VECTOR_SYNC_CURRENT, ESR_ELx_EC_DABT_CUR, dabt_handler);
+
+	virt_map(vm, MMIO_ADDR, MMIO_ADDR, 1);
+
+	return vm;
+}
+
+static void vcpu_inject_extabt(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vcpu_events events = {};
+
+	events.exception.ext_dabt_pending = true;
+	vcpu_events_set(vcpu, &events);
+}
+
+static void vcpu_run_expect_done(struct kvm_vcpu *vcpu)
+{
+	struct ucall uc;
+
+	vcpu_run(vcpu);
+	switch (get_ucall(vcpu, &uc)) {
+	case UCALL_ABORT:
+		REPORT_GUEST_ASSERT(uc);
+		break;
+	case UCALL_DONE:
+		break;
+	default:
+		TEST_FAIL("Unexpected ucall: %lu", uc.cmd);
+	}
+}
+
+extern char test_mmio_abort_insn;
+
+static void test_mmio_abort_guest(void)
+{
+	WRITE_ONCE(expected_abort_pc, (u64)&test_mmio_abort_insn);
+
+	asm volatile("test_mmio_abort_insn:\n\t"
+		     "ldr x0, [%0]\n\t"
+		     : : "r" (MMIO_ADDR) : "x0", "memory");
+
+	GUEST_FAIL("MMIO instruction should not retire");
+}
+
+/*
+ * Test that KVM doesn't complete MMIO emulation when userspace has made an
+ * external abort pending for the instruction.
+ */
+static void test_mmio_abort(void)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm = vm_create_with_dabt_handler(&vcpu, test_mmio_abort_guest,
+							expect_sea_handler);
+	struct kvm_run *run = vcpu->run;
+
+	vcpu_run(vcpu);
+	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_MMIO);
+	TEST_ASSERT_EQ(run->mmio.phys_addr, MMIO_ADDR);
+	TEST_ASSERT_EQ(run->mmio.len, sizeof(unsigned long));
+	TEST_ASSERT(!run->mmio.is_write, "Expected MMIO read");
+
+	vcpu_inject_extabt(vcpu);
+	vcpu_run_expect_done(vcpu);
+	kvm_vm_free(vm);
+}
+
+extern char test_mmio_nisv_insn;
+
+static void test_mmio_nisv_guest(void)
+{
+	WRITE_ONCE(expected_abort_pc, (u64)&test_mmio_nisv_insn);
+
+	asm volatile("test_mmio_nisv_insn:\n\t"
+		     "ldr x0, [%0], #8\n\t"
+		     : : "r" (MMIO_ADDR) : "x0", "memory");
+
+	GUEST_FAIL("MMIO instruction should not retire");
+}
+
+/*
+ * Test that the KVM_RUN ioctl fails for ESR_EL2.ISV=0 MMIO aborts if userspace
+ * hasn't enabled KVM_CAP_ARM_NISV_TO_USER.
+ */
+static void test_mmio_nisv(void)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm = vm_create_with_dabt_handler(&vcpu, test_mmio_nisv_guest,
+							unexpected_dabt_handler);
+
+	TEST_ASSERT(_vcpu_run(vcpu), "Expected nonzero return code from KVM_RUN");
+	TEST_ASSERT_EQ(errno, ENOSYS);
+
+	kvm_vm_free(vm);
+}
+
+/*
+ * Test that ESR_EL2.ISV=0 MMIO aborts reach userspace and that an injected SEA
+ * reaches the guest.
+ */
+static void test_mmio_nisv_abort(void)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm = vm_create_with_dabt_handler(&vcpu, test_mmio_nisv_guest,
+							expect_sea_handler);
+	struct kvm_run *run = vcpu->run;
+
+	vm_enable_cap(vm, KVM_CAP_ARM_NISV_TO_USER, 1);
+
+	vcpu_run(vcpu);
+	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_ARM_NISV);
+	TEST_ASSERT_EQ(run->arm_nisv.fault_ipa, MMIO_ADDR);
+
+	vcpu_inject_extabt(vcpu);
+	vcpu_run_expect_done(vcpu);
+	kvm_vm_free(vm);
+}
+
+int main(void)
+{
+	test_mmio_abort();
+	test_mmio_nisv();
+	test_mmio_nisv_abort();
+}
-- 
2.47.0.163.g1226f6d8fa-goog

