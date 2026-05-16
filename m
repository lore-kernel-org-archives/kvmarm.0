Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37F35340286
	for <kvmarm@lists.linux.dev>; Sat, 16 May 2026 18:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778956261; cv=none; b=M4uplj5jYlXhJ4lEcfleKFWmoTo7+HouNKq1GWzLiVg3EflZZV8r2U865cAw/UoJ6KXOqN4SmPrsVgC+vsUeHtat+WcL4SptzoOQZjQ2O8QlUxqja4UhLN8sXKU6if9RtBHQm0DLYGyEA81rqY82jjVo/o+5qRMZBTEdWvGUuz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778956261; c=relaxed/simple;
	bh=qd/xGyy1flBlfaXhDHK+Ds4y1aU389ligvtTqKbtVIY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EtgKFX3FjnmjUmCoqBzz30mne5yCh+uKIuXNI98yanii6gaEowwCVIlV5hkEb+UjVY3wrNounKHSvTvc5HyG65xVzyNE0yUv9ctZwoEJS8koyn7pYwTPW+GcMBaB4u7MoW1BSI4Nj7ST2jOonqhfq3q3xqlJUTnFkLLiNSkag/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=qYLFM3NY; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="qYLFM3NY"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 72B521CDD;
	Sat, 16 May 2026 11:30:46 -0700 (PDT)
Received: from workstation-e142269.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0575A3F85F;
	Sat, 16 May 2026 11:30:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778956251; bh=qd/xGyy1flBlfaXhDHK+Ds4y1aU389ligvtTqKbtVIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qYLFM3NYxZOKEcRByQD888YKv9cDtPlQulAsDH4gYouxcbFBLRdhGGhXDB3q3Ks1G
	 Mqy9/mVkoCVv4zHc5cnqAkD/b75zKUcg9YAUrrjuUWJW7zJRnghpbJ0gW9dAbK0wG+
	 DFc6cd0oPWpJ7kJX0BclGN5uH3urGPG+NkUDiThU=
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
Subject: [PATCH v3 1/9] KVM: arm64: selftests: Add GPR save/restore functions for NV
Date: Sat, 16 May 2026 19:29:55 +0100
Message-ID: <20260516183003.799058-2-weilin.chang@arm.com>
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

Adapt entry.S and hyp-entry.S from arch/arm64/kvm/hyp so that guest
hypervisors can save and restore GPRs, and provide exception handlers
to regain control after the nested guest exits. Other system register
save/restore will be added later on demand.

Signed-off-by: Wei-Lin Chang <weilin.chang@arm.com>
---
 tools/testing/selftests/kvm/Makefile.kvm      |   3 +
 .../selftests/kvm/include/arm64/nested.h      |  45 ++++++
 tools/testing/selftests/kvm/lib/arm64/entry.S | 132 ++++++++++++++++++
 .../selftests/kvm/lib/arm64/hyp-entry.S       |  77 ++++++++++
 .../testing/selftests/kvm/lib/arm64/nested.c  |  12 ++
 5 files changed, 269 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/include/arm64/nested.h
 create mode 100644 tools/testing/selftests/kvm/lib/arm64/entry.S
 create mode 100644 tools/testing/selftests/kvm/lib/arm64/hyp-entry.S
 create mode 100644 tools/testing/selftests/kvm/lib/arm64/nested.c

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index 98da9fa4b8b7..3dc3e39f7025 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -30,10 +30,13 @@ LIBKVM_x86 += lib/x86/svm.c
 LIBKVM_x86 += lib/x86/ucall.c
 LIBKVM_x86 += lib/x86/vmx.c
 
+LIBKVM_arm64 += lib/arm64/entry.S
 LIBKVM_arm64 += lib/arm64/gic.c
 LIBKVM_arm64 += lib/arm64/gic_v3.c
 LIBKVM_arm64 += lib/arm64/gic_v3_its.c
 LIBKVM_arm64 += lib/arm64/handlers.S
+LIBKVM_arm64 += lib/arm64/hyp-entry.S
+LIBKVM_arm64 += lib/arm64/nested.c
 LIBKVM_arm64 += lib/arm64/processor.c
 LIBKVM_arm64 += lib/arm64/spinlock.c
 LIBKVM_arm64 += lib/arm64/ucall.c
diff --git a/tools/testing/selftests/kvm/include/arm64/nested.h b/tools/testing/selftests/kvm/include/arm64/nested.h
new file mode 100644
index 000000000000..86d931facacb
--- /dev/null
+++ b/tools/testing/selftests/kvm/include/arm64/nested.h
@@ -0,0 +1,45 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * ARM64 Nested virtualization defines
+ */
+
+#ifndef SELFTEST_KVM_NESTED_H
+#define SELFTEST_KVM_NESTED_H
+
+#define ARM_EXCEPTION_IRQ	  0
+#define ARM_EXCEPTION_EL1_SERROR  1
+#define ARM_EXCEPTION_TRAP	  2
+#define ARM_EXCEPTION_IL	  3
+#define ARM_EXCEPTION_EL2_IRQ	  4
+#define ARM_EXCEPTION_EL2_SERROR  5
+#define ARM_EXCEPTION_EL2_TRAP	  6
+
+#ifndef __ASSEMBLER__
+
+#include <asm/ptrace.h>
+#include "kvm_util.h"
+
+extern char hyp_vectors[];
+
+struct cpu_context {
+	struct user_pt_regs regs;	/* sp = sp_el0 */
+};
+
+struct vcpu {
+	struct cpu_context context;
+};
+
+/*
+ * KVM has host_data and hyp_context, combine them because we're only doing
+ * hyp context.
+ */
+struct hyp_data {
+	struct cpu_context hyp_context;
+};
+
+u64 __guest_enter(struct vcpu *vcpu, struct cpu_context *hyp_context);
+void __hyp_exception(u64 type);
+
+#endif /* !__ASSEMBLER__ */
+
+#endif /* SELFTEST_KVM_NESTED_H */
diff --git a/tools/testing/selftests/kvm/lib/arm64/entry.S b/tools/testing/selftests/kvm/lib/arm64/entry.S
new file mode 100644
index 000000000000..33bedf5e7fb2
--- /dev/null
+++ b/tools/testing/selftests/kvm/lib/arm64/entry.S
@@ -0,0 +1,132 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * adapted from arch/arm64/kvm/hyp/entry.S
+ */
+
+/*
+ * Manually define these for now
+ */
+// offsetof(struct vcpu, context)
+#define CPU_CONTEXT		0
+// offsetof(struct cpu_context, regs)
+#define CPU_USER_PT_REGS	0
+
+#define CPU_XREG_OFFSET(x)	(CPU_USER_PT_REGS + 8*x)
+#define CPU_LR_OFFSET		CPU_XREG_OFFSET(30)
+#define CPU_SP_EL0_OFFSET	(CPU_LR_OFFSET + 8)
+
+.macro save_callee_saved_regs ctxt
+	str	x18,      [\ctxt, #CPU_XREG_OFFSET(18)]
+	stp	x19, x20, [\ctxt, #CPU_XREG_OFFSET(19)]
+	stp	x21, x22, [\ctxt, #CPU_XREG_OFFSET(21)]
+	stp	x23, x24, [\ctxt, #CPU_XREG_OFFSET(23)]
+	stp	x25, x26, [\ctxt, #CPU_XREG_OFFSET(25)]
+	stp	x27, x28, [\ctxt, #CPU_XREG_OFFSET(27)]
+	stp	x29, lr,  [\ctxt, #CPU_XREG_OFFSET(29)]
+.endm
+
+.macro restore_callee_saved_regs ctxt
+	ldr	x18,      [\ctxt, #CPU_XREG_OFFSET(18)]
+	ldp	x19, x20, [\ctxt, #CPU_XREG_OFFSET(19)]
+	ldp	x21, x22, [\ctxt, #CPU_XREG_OFFSET(21)]
+	ldp	x23, x24, [\ctxt, #CPU_XREG_OFFSET(23)]
+	ldp	x25, x26, [\ctxt, #CPU_XREG_OFFSET(25)]
+	ldp	x27, x28, [\ctxt, #CPU_XREG_OFFSET(27)]
+	ldp	x29, lr,  [\ctxt, #CPU_XREG_OFFSET(29)]
+.endm
+
+.macro save_sp_el0 ctxt, tmp
+	mrs	\tmp,	sp_el0
+	str	\tmp,	[\ctxt, #CPU_SP_EL0_OFFSET]
+.endm
+
+.macro restore_sp_el0 ctxt, tmp
+	ldr	\tmp,	  [\ctxt, #CPU_SP_EL0_OFFSET]
+	msr	sp_el0, \tmp
+.endm
+
+/*
+ * u64 __guest_enter(struct vcpu *vcpu, struct cpu_context *hyp_context);
+ */
+.globl __guest_enter
+__guest_enter:
+	// x0: vcpu
+	// x1: hyp context
+
+	// Store vcpu and hyp context pointer on the stack
+	stp	x0, x1, [sp, #-16]!
+
+	// Store the hyp regs
+	save_callee_saved_regs x1
+
+	// Save hyp's sp_el0
+	save_sp_el0	x1, x2
+
+	// x29 = vCPU user pt regs
+	add	x29, x0, #CPU_CONTEXT
+
+	// Restore the guest's sp_el0
+	restore_sp_el0 x29, x0
+
+	// Restore guest regs x0-x17
+	ldp	x0, x1,   [x29, #CPU_XREG_OFFSET(0)]
+	ldp	x2, x3,   [x29, #CPU_XREG_OFFSET(2)]
+	ldp	x4, x5,   [x29, #CPU_XREG_OFFSET(4)]
+	ldp	x6, x7,   [x29, #CPU_XREG_OFFSET(6)]
+	ldp	x8, x9,   [x29, #CPU_XREG_OFFSET(8)]
+	ldp	x10, x11, [x29, #CPU_XREG_OFFSET(10)]
+	ldp	x12, x13, [x29, #CPU_XREG_OFFSET(12)]
+	ldp	x14, x15, [x29, #CPU_XREG_OFFSET(14)]
+	ldp	x16, x17, [x29, #CPU_XREG_OFFSET(16)]
+
+	// Restore guest regs x18-x29, lr
+	restore_callee_saved_regs x29
+
+	// Do not touch any register after this!
+	eret
+
+.globl __guest_exit
+__guest_exit:
+	// x0: return code
+	// x1: vcpu
+	// x2-x29,lr: vcpu regs
+	// vcpu x0-x1 on the stack
+
+	add	x1, x1, #CPU_CONTEXT
+
+	// Store the guest regs x2 and x3
+	stp	x2, x3,   [x1, #CPU_XREG_OFFSET(2)]
+
+	// Retrieve the guest regs x0-x1 from the stack
+	ldp	x2, x3, [sp], #16	// x0, x1
+
+	// Store the guest regs x0-x1 and x4-x17
+	stp	x2, x3,   [x1, #CPU_XREG_OFFSET(0)]
+	stp	x4, x5,   [x1, #CPU_XREG_OFFSET(4)]
+	stp	x6, x7,   [x1, #CPU_XREG_OFFSET(6)]
+	stp	x8, x9,   [x1, #CPU_XREG_OFFSET(8)]
+	stp	x10, x11, [x1, #CPU_XREG_OFFSET(10)]
+	stp	x12, x13, [x1, #CPU_XREG_OFFSET(12)]
+	stp	x14, x15, [x1, #CPU_XREG_OFFSET(14)]
+	stp	x16, x17, [x1, #CPU_XREG_OFFSET(16)]
+
+	// Store the guest regs x18-x29, lr
+	save_callee_saved_regs x1
+
+	// Store the guest's sp_el0
+	save_sp_el0	x1, x2
+
+	// At this point x0 and x1 on the stack is popped, so next is vCPU
+	// pointer, then hyp_context pointer
+	// *sp == vCPU, *(sp + 8) == hyp_context
+	// load x2 = hyp_context, x3 is just for ldp and popping sp
+	ldp	x3, x2, [sp], #16
+
+	// Restore hyp's sp_el0
+	restore_sp_el0 x2, x3
+
+	// Now restore the hyp regs
+	restore_callee_saved_regs x2
+
+	dsb	sy		// Synchronize against in-flight ld/st
+	ret
diff --git a/tools/testing/selftests/kvm/lib/arm64/hyp-entry.S b/tools/testing/selftests/kvm/lib/arm64/hyp-entry.S
new file mode 100644
index 000000000000..6341f6e05c90
--- /dev/null
+++ b/tools/testing/selftests/kvm/lib/arm64/hyp-entry.S
@@ -0,0 +1,77 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * adapted from arch/arm64/kvm/hyp/hyp-entry.S
+ */
+
+#include "nested.h"
+
+// skip over x0, x1 saved on entry, must be used only before the stack is modified
+.macro get_vcpu_ptr vcpu
+	ldr	\vcpu, [sp, #16]
+.endm
+
+	.text
+
+el1_sync:	// Guest trapped into EL2
+
+	get_vcpu_ptr	x1
+	mov	x0, #ARM_EXCEPTION_TRAP
+	b	__guest_exit
+
+el1_irq:
+el1_fiq:
+	get_vcpu_ptr	x1
+	mov	x0, #ARM_EXCEPTION_IRQ
+	b	__guest_exit
+
+el1_error:
+	get_vcpu_ptr	x1
+	mov	x0, #ARM_EXCEPTION_EL1_SERROR
+	b	__guest_exit
+
+el2_sync:
+	mov	x0, #ARM_EXCEPTION_EL2_TRAP
+	b	__hyp_exception
+
+el2_irq:
+el2_fiq:
+	mov	x0, #ARM_EXCEPTION_EL2_IRQ
+	b	__hyp_exception
+
+el2_error:
+	mov	x0, #ARM_EXCEPTION_EL2_SERROR
+	b	__hyp_exception
+
+
+	.ltorg
+
+	.align 11
+
+.globl hyp_vectors
+hyp_vectors:
+
+.macro exception_vector target
+	.align 7
+	stp	x0, x1, [sp, #-16]!
+	b	\target
+.endm
+
+	exception_vector	el2_sync	// Synchronous EL2t
+	exception_vector	el2_irq		// IRQ EL2t
+	exception_vector	el2_fiq		// FIQ EL2t
+	exception_vector	el2_error	// Error EL2t
+
+	exception_vector	el2_sync	// Synchronous EL2h
+	exception_vector	el2_irq		// IRQ EL2h
+	exception_vector	el2_fiq		// FIQ EL2h
+	exception_vector	el2_error	// Error EL2h
+
+	exception_vector	el1_sync	// Synchronous 64-bit EL1
+	exception_vector	el1_irq		// IRQ 64-bit EL1
+	exception_vector	el1_fiq		// FIQ 64-bit EL1
+	exception_vector	el1_error	// Error 64-bit EL1
+
+	exception_vector	el1_sync	// Synchronous 32-bit EL1
+	exception_vector	el1_irq		// IRQ 32-bit EL1
+	exception_vector	el1_fiq		// FIQ 32-bit EL1
+	exception_vector	el1_error	// Error 32-bit EL1
diff --git a/tools/testing/selftests/kvm/lib/arm64/nested.c b/tools/testing/selftests/kvm/lib/arm64/nested.c
new file mode 100644
index 000000000000..06ddaab2436f
--- /dev/null
+++ b/tools/testing/selftests/kvm/lib/arm64/nested.c
@@ -0,0 +1,12 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * ARM64 Nested virtualization helpers
+ */
+
+#include "nested.h"
+#include "test_util.h"
+
+void __hyp_exception(u64 type)
+{
+	GUEST_FAIL("Unexpected hyp exception! type: %lx\n", type);
+}
-- 
2.43.0

