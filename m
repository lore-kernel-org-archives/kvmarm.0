Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33E54376BCD
	for <kvmarm@lists.linux.dev>; Sun, 12 Apr 2026 14:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776003774; cv=none; b=Ak+2k8fC5w+VkKg4muQta3g/RLU12obybA8uuZGSU8y88KlM22ePFsV0I2Pxn2aRyw3ndJi4M+o38czeNARYDbkC0mdzytXGLdO3SZDjcXCrGGqv+fpa/hR7h1mzO7/2qgWen7QHDNMKbCQv/odc0cu7maPDWSfioKI3n1gRdi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776003774; c=relaxed/simple;
	bh=0EDfWpsdxsjcAtIRZvKranYR1gx5ZSTX9J79iq1ThbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h2xWefd4TlD0X8L7WsAd6f90iFwcz89l27ug/J+x01NDfFt08HVPGoAcJM5M6yEno9c7ax7k568jIfKsnWbIAnoRIiNd8OzohEZ95ksllzoJcXcPdpOyY5HlATS0V/1vdqAtB+czSKYV6gg+9eo2mxHyl1Bi5ztG4Q/oDRdHhj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=vgOJEwq1; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="vgOJEwq1"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0F0114CE3;
	Sun, 12 Apr 2026 07:22:47 -0700 (PDT)
Received: from workstation-e142269.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 909CD3F641;
	Sun, 12 Apr 2026 07:22:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1776003772; bh=0EDfWpsdxsjcAtIRZvKranYR1gx5ZSTX9J79iq1ThbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vgOJEwq15vuopE2NISS68i27oULnGZI5qAuOmpX6QefCKW2e1lnw98pbJrfFLRPPl
	 HzYviLaS6/XWRXPLCfeL9Yw9TfOqDCbMI2m+q9aMDeLnkcFJdvzKIsHBja6EWMp0yL
	 /qrlxa4RE5LPcAY0QElLGMAQSOLB3ZDtQBGdukQE=
From: Wei-Lin Chang <weilin.chang@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	Wei-Lin Chang <weilin.chang@arm.com>
Subject: [PATCH v2 3/4] KVM: arm64: sefltests: Add basic NV selftest
Date: Sun, 12 Apr 2026 15:22:15 +0100
Message-ID: <20260412142216.3806482-4-weilin.chang@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260412142216.3806482-1-weilin.chang@arm.com>
References: <20260412142216.3806482-1-weilin.chang@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This selftest simply starts an L1, which starts its own guest (L2). L2
runs without stage-1 and 2 translations, it calls an HVC to jump back
to L1.

Signed-off-by: Wei-Lin Chang <weilin.chang@arm.com>
---
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../selftests/kvm/arm64/hello_nested.c        | 103 ++++++++++++++++++
 2 files changed, 104 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/arm64/hello_nested.c

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index 3dc3e39f7025..e8c108e0c487 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -168,6 +168,7 @@ TEST_GEN_PROGS_arm64 += arm64/arch_timer_edge_cases
 TEST_GEN_PROGS_arm64 += arm64/at
 TEST_GEN_PROGS_arm64 += arm64/debug-exceptions
 TEST_GEN_PROGS_arm64 += arm64/hello_el2
+TEST_GEN_PROGS_arm64 += arm64/hello_nested
 TEST_GEN_PROGS_arm64 += arm64/host_sve
 TEST_GEN_PROGS_arm64 += arm64/hypercalls
 TEST_GEN_PROGS_arm64 += arm64/external_aborts
diff --git a/tools/testing/selftests/kvm/arm64/hello_nested.c b/tools/testing/selftests/kvm/arm64/hello_nested.c
new file mode 100644
index 000000000000..97387e4697b3
--- /dev/null
+++ b/tools/testing/selftests/kvm/arm64/hello_nested.c
@@ -0,0 +1,103 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * hello_nested - Go from vEL2 to EL1 then back
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
+/*
+ * TPIDR_EL2 is used to store vcpu id, so save and restore it.
+ */
+static vm_paddr_t ucall_translate_to_gpa(void *gva)
+{
+	vm_paddr_t gpa;
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
+	do_hvc();
+}
+
+static void guest_code(void)
+{
+	struct vcpu vcpu;
+	struct hyp_data hyp_data;
+	int ret;
+	vm_paddr_t l2_pc, l2_stack_top;
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
+	ret = run_l2(&vcpu, &hyp_data);
+	GUEST_ASSERT_EQ(ret, ARM_EXCEPTION_TRAP);
+	GUEST_DONE();
+}
+
+int main(void)
+{
+	struct kvm_vcpu_init init;
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	struct ucall uc;
+	vm_paddr_t gpa;
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
+				gpa = addr_gva2gpa(vm, (vm_vaddr_t)uc.args[1]);
+				vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_TPIDR_EL2), gpa);
+			}
+			break;
+		case UCALL_PRINTF:
+			pr_info("%s", uc.buffer);
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

