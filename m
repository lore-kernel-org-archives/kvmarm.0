Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 402C120A5F3
	for <kvmarm@lists.linux.dev>; Wed, 25 Mar 2026 00:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774399065; cv=none; b=WdddlUVUUfThsO+I7jilCv6r0D6y5LlCKHNPVI1UHIMFAU13mIg5aduthbrLjRQ/F1n/nDTfCWjuFwpAhfT7a1vWMOPUUTJwj1GaafZ4prswtBPMPZNNcltR1i4PrTDxDUgsxQ9IN7QtMNbNipbdkOk52luVHvIFB2qZTzy1X6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774399065; c=relaxed/simple;
	bh=bB650cgvjeM+wlJ2Nx+MaWC6oDU8Qj0aTouMzw+P4tQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O92IVpR0mKiHJqZNZ+C+9DyejQHu3GeYk0hsKAmfL/ViV5c9jE/TKgGzp/5O38LfURE9MNgwPNjePd4rg8lSKqyR97HS6LSolI2C7BwsjuaDJTRUU/BbCBKNRkirq96ByvGiSPqaYEAoyJeQl4XWKhOytdmiB3bPjkQjdUKHKEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=vEfRwCmX; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="vEfRwCmX"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9E7F61A9A;
	Tue, 24 Mar 2026 17:37:32 -0700 (PDT)
Received: from workstation-e142269.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 72CC63FB90;
	Tue, 24 Mar 2026 17:37:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1774399058; bh=bB650cgvjeM+wlJ2Nx+MaWC6oDU8Qj0aTouMzw+P4tQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vEfRwCmXPUZlpCpmQMhGyTi8e39TTxWC+HYua+L960bBmaH2mEQ80m8Zp+JAeMeY8
	 NOoCMZFqXmGwWSq2oLwPAiaJu8v/ODcYoZjsqurEcBudI17Gbp1aelKyK6a82IrTeW
	 XxcqOQ0tXOyS7PTMBF0+/da0hXGPJET0Kww/gVAs=
From: Wei-Lin Chang <weilin.chang@arm.com>
To: kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 1/3] KVM: arm64: selftests: Add library functions for NV
Date: Wed, 25 Mar 2026 00:36:18 +0000
Message-ID: <20260325003620.2214766-2-weilin.chang@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260325003620.2214766-1-weilin.chang@arm.com>
References: <20260325003620.2214766-1-weilin.chang@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The API is designed for userspace to first call prepare_{l2_stack,
hyp_state, eret_destination, nested_sync_handler}, with a function
supplied to prepare_eret_destination() to be run in L2. Then run_l2()
can be called in L1 to run the given function in L2.

Signed-off-by: Wei-Lin Chang <weilin.chang@arm.com>
---
 tools/testing/selftests/kvm/Makefile.kvm      |  2 +
 .../selftests/kvm/include/arm64/nested.h      | 18 ++++++
 .../testing/selftests/kvm/lib/arm64/nested.c  | 61 +++++++++++++++++++
 .../selftests/kvm/lib/arm64/nested_asm.S      | 35 +++++++++++
 4 files changed, 116 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/include/arm64/nested.h
 create mode 100644 tools/testing/selftests/kvm/lib/arm64/nested.c
 create mode 100644 tools/testing/selftests/kvm/lib/arm64/nested_asm.S

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index 98da9fa4b8b7..5e681e8e0cd7 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -34,6 +34,8 @@ LIBKVM_arm64 += lib/arm64/gic.c
 LIBKVM_arm64 += lib/arm64/gic_v3.c
 LIBKVM_arm64 += lib/arm64/gic_v3_its.c
 LIBKVM_arm64 += lib/arm64/handlers.S
+LIBKVM_arm64 += lib/arm64/nested.c
+LIBKVM_arm64 += lib/arm64/nested_asm.S
 LIBKVM_arm64 += lib/arm64/processor.c
 LIBKVM_arm64 += lib/arm64/spinlock.c
 LIBKVM_arm64 += lib/arm64/ucall.c
diff --git a/tools/testing/selftests/kvm/include/arm64/nested.h b/tools/testing/selftests/kvm/include/arm64/nested.h
new file mode 100644
index 000000000000..739ff2ee0161
--- /dev/null
+++ b/tools/testing/selftests/kvm/include/arm64/nested.h
@@ -0,0 +1,18 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * ARM64 Nested virtualization defines
+ */
+
+#ifndef SELFTEST_KVM_NESTED_H
+#define SELFTEST_KVM_NESTED_H
+
+void prepare_l2_stack(struct kvm_vm *vm, struct kvm_vcpu *vcpu);
+void prepare_hyp_state(struct kvm_vm *vm, struct kvm_vcpu *vcpu);
+void prepare_eret_destination(struct kvm_vm *vm, struct kvm_vcpu *vcpu, void *l2_pc);
+void prepare_nested_sync_handler(struct kvm_vm *vm, struct kvm_vcpu *vcpu);
+
+void run_l2(void);
+void after_hvc(void);
+void do_hvc(void);
+
+#endif /* SELFTEST_KVM_NESTED_H */
diff --git a/tools/testing/selftests/kvm/lib/arm64/nested.c b/tools/testing/selftests/kvm/lib/arm64/nested.c
new file mode 100644
index 000000000000..111d02f44cfe
--- /dev/null
+++ b/tools/testing/selftests/kvm/lib/arm64/nested.c
@@ -0,0 +1,61 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * ARM64 Nested virtualization helpers
+ */
+
+#include "kvm_util.h"
+#include "nested.h"
+#include "processor.h"
+#include "test_util.h"
+
+#include <asm/sysreg.h>
+
+static void hvc_handler(struct ex_regs *regs)
+{
+	GUEST_ASSERT_EQ(get_current_el(), 2);
+	GUEST_PRINTF("hvc handler\n");
+	regs->pstate = PSR_MODE_EL2h | PSR_D_BIT | PSR_A_BIT | PSR_I_BIT | PSR_F_BIT;
+	regs->pc = (u64)after_hvc;
+}
+
+void prepare_l2_stack(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
+{
+	size_t l2_stack_size;
+	uint64_t l2_stack_paddr;
+
+	l2_stack_size = vm->page_size == 4096 ? DEFAULT_STACK_PGS * vm->page_size :
+					 vm->page_size;
+	l2_stack_paddr = __vm_phy_pages_alloc(vm, l2_stack_size / vm->page_size,
+					      0, 0, false);
+	vcpu_set_reg(vcpu, ARM64_CORE_REG(sp_el1), l2_stack_paddr + l2_stack_size);
+}
+
+void prepare_hyp_state(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
+{
+	vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_HCR_EL2), HCR_EL2_RW);
+}
+
+void prepare_eret_destination(struct kvm_vm *vm, struct kvm_vcpu *vcpu, void *l2_pc)
+{
+	vm_paddr_t do_hvc_paddr = addr_gva2gpa(vm, (vm_vaddr_t)do_hvc);
+	vm_paddr_t l2_pc_paddr = addr_gva2gpa(vm, (vm_vaddr_t)l2_pc);
+
+	vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_SPSR_EL2), PSR_MODE_EL1h |
+							    PSR_D_BIT     |
+							    PSR_A_BIT     |
+							    PSR_I_BIT     |
+							    PSR_F_BIT);
+	vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ELR_EL2), l2_pc_paddr);
+	/* HACK: use TPIDR_EL2 to pass address, see run_l2() in nested_asm.S */
+	vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_TPIDR_EL2), do_hvc_paddr);
+}
+
+void prepare_nested_sync_handler(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
+{
+	if (!vm->handlers) {
+		vm_init_descriptor_tables(vm);
+		vcpu_init_descriptor_tables(vcpu);
+	}
+	vm_install_sync_handler(vm, VECTOR_SYNC_LOWER_64,
+				ESR_ELx_EC_HVC64, hvc_handler);
+}
diff --git a/tools/testing/selftests/kvm/lib/arm64/nested_asm.S b/tools/testing/selftests/kvm/lib/arm64/nested_asm.S
new file mode 100644
index 000000000000..4ecf2d510a6f
--- /dev/null
+++ b/tools/testing/selftests/kvm/lib/arm64/nested_asm.S
@@ -0,0 +1,35 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * ARM64 Nested virtualization assembly helpers
+ */
+
+.globl run_l2
+.globl after_hvc
+.globl do_hvc
+run_l2:
+	/*
+	 * At this point TPIDR_EL2 will contain the gpa of do_hvc from
+	 * prepare_eret_destination(). gpa of do_hvc have to be passed in
+	 * because we want L2 to issue an hvc after it returns from the user
+	 * passed function. In order for that to happen the lr must be
+	 * controlled, which at this point holds the value of the address of
+	 * the next instruction after this run_l2() call, which is not useful
+	 * for L2. Additionally, L1 can't translate gva into gpa, so we can't
+	 * calculate it here.
+	 *
+	 * So first save lr, then move TPIDR_EL2 to lr so when the user supplied
+	 * L2 function returns, L2 jumps to do_hvc and let the L1 hvc handler
+	 * take control. This implies we expect the L2 code to preserve lr and
+	 * calls a regular ret in the end, which is true for normal C functions.
+	 * The hvc handler will jump back to after_hvc when finished, and lr
+	 * will be restored and we can return run_l2().
+	 */
+	stp	x29, lr, [sp, #-16]!
+	mrs	x0, tpidr_el2
+	mov	lr, x0
+	eret
+after_hvc:
+	ldp	x29, lr, [sp], #16
+	ret
+do_hvc:
+	hvc #0
-- 
2.43.0

