Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1B7A1A3154
	for <kvmarm@lists.linux.dev>; Sat, 16 May 2026 18:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778956267; cv=none; b=TTz9vWa7st5Ln+M/3A4cqgITgWr2qbLUAzBKM9TLQ/2KpLDpez7TlhpMLZB9f5qCRLC5LRiFd5EOSF71sC3Lexkl5MF3cdPOq/7849t25wwIYyHR/hzBK7hY9C4ZoNPRYXKQrrtsXd3FFp95UDKCKXMQ/FIc79nqciNbTH4c5hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778956267; c=relaxed/simple;
	bh=NjiLBvJulETNmJY6cc2tolrFjLCUJdQFnQKrPk5Q/hg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SZ2y1a4zdVS+MF0OJvNZyk3DN9XwHUF3hlGdvQbCG+DnuQTnplKzU2QP7UsA08fLAIfwgYh46JwV1dWsXy3ZvSTpCYyE4dOy3VGg886BPqwegMyRhOIk0SjSLxUR/IuOxzQQ6LebjCHjrP3i4Rw0vfBl9vf5htHdl8Lfr+3qkD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=V5hbW2sN; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="V5hbW2sN"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7C8DA1BF3;
	Sat, 16 May 2026 11:30:58 -0700 (PDT)
Received: from workstation-e142269.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 121DA3F85F;
	Sat, 16 May 2026 11:31:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778956263; bh=NjiLBvJulETNmJY6cc2tolrFjLCUJdQFnQKrPk5Q/hg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V5hbW2sNxeF4TdF7LOWlkkUOkMt8HpTKd4Fbof8XRzQYpGa+0RqLIAdVpmxwGVc60
	 ApBJjEWmke0KyERqvE6DzRYOE7seT53kLquSC2SKl17otKShgVwD55+IbwH3rwfWVE
	 hikNAFNwJRAXrp/c1pwEnkGLt/ehLgWvst4Qyeb4=
From: Wei-Lin Chang <weilin.chang@arm.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Itaru Kitayama <itaru.kitayama@fujitsu.com>,
	Wei-Lin Chang <weilin.chang@arm.com>
Subject: [PATCH v3 5/9] KVM: arm64: selftests: Add shadow_stage2 test
Date: Sat, 16 May 2026 19:29:59 +0100
Message-ID: <20260516183003.799058-6-weilin.chang@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260516183003.799058-1-weilin.chang@arm.com>
References: <20260516183003.799058-1-weilin.chang@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The shadow_stage2 test is aimed to exercise the shadow page table
management code in KVM. In this first patch a basic test similar to
hello_nested is created. Right now it doesn't turn on stage-2 for the
nested guest (L2) yet, therefore the shadow page table code in KVM will
only be triggered minimally now.

Signed-off-by: Wei-Lin Chang <weilin.chang@arm.com>
---
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../selftests/kvm/arm64/shadow_stage2.c       | 128 ++++++++++++++++++
 2 files changed, 129 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/arm64/shadow_stage2.c

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index e8c108e0c487..c0fac2ba1339 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -176,6 +176,7 @@ TEST_GEN_PROGS_arm64 += arm64/page_fault_test
 TEST_GEN_PROGS_arm64 += arm64/psci_test
 TEST_GEN_PROGS_arm64 += arm64/sea_to_user
 TEST_GEN_PROGS_arm64 += arm64/set_id_regs
+TEST_GEN_PROGS_arm64 += arm64/shadow_stage2
 TEST_GEN_PROGS_arm64 += arm64/smccc_filter
 TEST_GEN_PROGS_arm64 += arm64/vcpu_width_config
 TEST_GEN_PROGS_arm64 += arm64/vgic_init
diff --git a/tools/testing/selftests/kvm/arm64/shadow_stage2.c b/tools/testing/selftests/kvm/arm64/shadow_stage2.c
new file mode 100644
index 000000000000..cf76a2b0582d
--- /dev/null
+++ b/tools/testing/selftests/kvm/arm64/shadow_stage2.c
@@ -0,0 +1,128 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * shadow_stage2 - Test correctness of shadow stage 2
+ */
+
+#include "nested.h"
+#include "processor.h"
+#include "test_util.h"
+#include "ucall.h"
+
+#define XLATE2GPA	(0xABCD)
+#define L2STACKSZ	(0x100)
+
+#define L2SUCCESS	(0x0)
+#define L2FAILED	(0x1)
+#define L2SYNC		(0x2)
+
+/*
+ * TPIDR_EL2 is used to store vcpu id, so save and restore it.
+ */
+static gpa_t ucall_translate_to_gpa(void *gva)
+{
+	gpa_t gpa;
+	u64 vcpu_id = read_sysreg(tpidr_el2);
+
+	GUEST_SYNC2(XLATE2GPA, gva);
+
+	/* get the result from userspace */
+	gpa = read_sysreg(tpidr_el2);
+
+	write_sysreg(vcpu_id, tpidr_el2);
+
+	return gpa;
+}
+
+static void l2_guest_code(void)
+{
+	do_hvc(L2SYNC, 10, 0);
+	do_hvc(L2SYNC, 20, 0);
+	do_hvc(L2SYNC, 30, 0);
+
+	do_hvc(L2SUCCESS, 0, 0);
+}
+
+static void guest_code(void)
+{
+	struct vcpu vcpu;
+	struct hyp_data hyp_data;
+	int ret, i = 0;
+	gpa_t l2_pc, l2_stack_top;
+	/* force 16-byte alignment for the stack pointer */
+	u8 l2_stack[L2STACKSZ] __attribute__((aligned(16)));
+
+	GUEST_ASSERT_EQ(get_current_el(), 2);
+	GUEST_PRINTF("vEL2 entry\n");
+
+	l2_pc = ucall_translate_to_gpa(l2_guest_code);
+	l2_stack_top = ucall_translate_to_gpa(&l2_stack[L2STACKSZ]);
+
+	init_vcpu(&vcpu, l2_pc, l2_stack_top);
+	prepare_hyp();
+
+	while (true) {
+		GUEST_PRINTF("L2 enter\n");
+		ret = run_l2(&vcpu, &hyp_data);
+		GUEST_PRINTF("L2 exit\n");
+		GUEST_ASSERT_EQ(ret, ARM_EXCEPTION_TRAP);
+		GUEST_ASSERT_EQ(ESR_ELx_EC(read_sysreg(esr_el2)), ESR_ELx_EC_HVC64);
+
+		if (vcpu.context.regs.regs[0] == L2SYNC)
+			GUEST_SYNC3(L2SYNC, i++, vcpu.context.regs.regs[1]);
+		else
+			break;
+	}
+
+	if (vcpu.context.regs.regs[0] != L2SUCCESS)
+		GUEST_FAIL("L2 failed\n");
+
+	GUEST_PRINTF("L2 success!\n");
+	GUEST_DONE();
+}
+
+int main(void)
+{
+	struct kvm_vcpu_init init;
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	struct ucall uc;
+	gpa_t gpa;
+
+	TEST_REQUIRE(kvm_check_cap(KVM_CAP_ARM_EL2));
+	vm = vm_create(1);
+
+	kvm_get_default_vcpu_target(vm, &init);
+	init.features[0] |= BIT(KVM_ARM_VCPU_HAS_EL2);
+	vcpu = aarch64_vcpu_add(vm, 0, &init, guest_code);
+	kvm_arch_vm_finalize_vcpus(vm);
+
+	while (true) {
+		vcpu_run(vcpu);
+
+		switch (get_ucall(vcpu, &uc)) {
+		case UCALL_SYNC:
+			if (uc.args[0] == XLATE2GPA) {
+				gpa = addr_gva2gpa(vm, (gva_t)uc.args[1]);
+				vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_TPIDR_EL2), gpa);
+			}
+			if (uc.args[0] == L2SYNC)
+				pr_info("L2SYNC, L1 info: %ld, L2 info: %ld\n", uc.args[1], uc.args[2]);
+			break;
+		case UCALL_PRINTF:
+			pr_info("[L1] %s", uc.buffer);
+			break;
+		case UCALL_DONE:
+			pr_info("DONE!\n");
+			goto end;
+		case UCALL_ABORT:
+			REPORT_GUEST_ASSERT(uc);
+			fallthrough;
+		default:
+			TEST_FAIL("Unhandled ucall: %ld\n", uc.cmd);
+		}
+	}
+
+end:
+	kvm_vm_free(vm);
+	return 0;
+}
-- 
2.43.0

