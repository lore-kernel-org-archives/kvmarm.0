From: Andrew Jones <drjones@redhat.com>
Subject: [PATCH 08/13] kvm: selftests: add vcpu support for aarch64
Date: Tue, 18 Sep 2018 19:54:31 +0200
Message-ID: <20180918175436.19742-9-drjones@redhat.com>
References: <20180918175436.19742-1-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B0AF14A1FE
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Sep 2018 13:55:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id a6W9Edc3vXbW for <kvmarm@lists.cs.columbia.edu>;
 Tue, 18 Sep 2018 13:55:06 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1F9BA4A257
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Sep 2018 13:55:06 -0400 (EDT)
In-Reply-To: <20180918175436.19742-1-drjones@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: marc.zyngier@arm.com, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

This code adds VM and VCPU setup code for the VM_MODE_FLAT48PG mode.
The VM_MODE_FLAT48PG isn't yet fully supportable, as it defines the
guest physical address limit as 52-bits, and KVM currently only
supports guests with up to 40-bit physical addresses (see
KVM_PHYS_SHIFT). VM_MODE_FLAT48PG will work fine, though, as long as
no >= 40-bit physical addresses are used.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 .../selftests/kvm/include/aarch64/processor.h | 55 ++++++++++++
 .../selftests/kvm/lib/aarch64/processor.c     | 83 +++++++++++++++++++
 2 files changed, 138 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/include/aarch64/processor.h

diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
new file mode 100644
index 000000000000..9ef2ab1a0c08
--- /dev/null
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -0,0 +1,55 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * AArch64 processor specific defines
+ *
+ * Copyright (C) 2018, Red Hat, Inc.
+ */
+#ifndef SELFTEST_KVM_PROCESSOR_H
+#define SELFTEST_KVM_PROCESSOR_H
+
+#include "kvm_util.h"
+
+
+#define ARM64_CORE_REG(x) (KVM_REG_ARM64 | KVM_REG_SIZE_U64 | \
+			   KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(x))
+
+#define CPACR_EL1	3, 0,  1, 0, 2
+#define TCR_EL1		3, 0,  2, 0, 2
+#define MAIR_EL1	3, 0, 10, 2, 0
+#define TTBR0_EL1	3, 0,  2, 0, 0
+#define SCTLR_EL1	3, 0,  1, 0, 0
+
+/*
+ * Default MAIR
+ *                  index   attribute
+ * DEVICE_nGnRnE      0     0000:0000
+ * DEVICE_nGnRE       1     0000:0100
+ * DEVICE_GRE         2     0000:1100
+ * NORMAL_NC          3     0100:0100
+ * NORMAL             4     1111:1111
+ * NORMAL_WT          5     1011:1011
+ */
+#define DEFAULT_MAIR_EL1 ((0x00ul << (0 * 8)) | \
+			  (0x04ul << (1 * 8)) | \
+			  (0x0cul << (2 * 8)) | \
+			  (0x44ul << (3 * 8)) | \
+			  (0xfful << (4 * 8)) | \
+			  (0xbbul << (5 * 8)))
+
+static inline void get_reg(struct kvm_vm *vm, uint32_t vcpuid, uint64_t id, uint64_t *addr)
+{
+	struct kvm_one_reg reg;
+	reg.id = id;
+	reg.addr = (uint64_t)addr;
+	vcpu_ioctl(vm, vcpuid, KVM_GET_ONE_REG, &reg);
+}
+
+static inline void set_reg(struct kvm_vm *vm, uint32_t vcpuid, uint64_t id, uint64_t val)
+{
+	struct kvm_one_reg reg;
+	reg.id = id;
+	reg.addr = (uint64_t)&val;
+	vcpu_ioctl(vm, vcpuid, KVM_SET_ONE_REG, &reg);
+}
+
+#endif /* SELFTEST_KVM_PROCESSOR_H */
diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
index 464d4d074249..871fe2173679 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
@@ -5,10 +5,14 @@
  * Copyright (C) 2018, Red Hat, Inc.
  */
 
+#define _GNU_SOURCE /* for program_invocation_name */
+
 #include "kvm_util.h"
 #include "../kvm_util_internal.h"
+#include "processor.h"
 
 #define KVM_GUEST_PAGE_TABLE_MIN_PADDR		0x180000
+#define DEFAULT_ARM64_GUEST_STACK_VADDR_MIN	0xac0000
 
 static uint64_t page_align(struct kvm_vm *vm, uint64_t v)
 {
@@ -214,3 +218,82 @@ void virt_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
 		pte_dump(stream, vm, indent + 1, pte_addr(vm, *ptep), level);
 	}
 }
+
+struct kvm_vm *vm_create_default(uint32_t vcpuid, uint64_t extra_mem_pages,
+				 void *guest_code)
+{
+	uint64_t ptrs_per_4k_pte = 512;
+	uint64_t extra_pg_pages = (extra_mem_pages / ptrs_per_4k_pte) * 2;
+	struct kvm_vm *vm;
+
+	vm = vm_create(VM_MODE_FLAT48PG, DEFAULT_GUEST_PHY_PAGES + extra_pg_pages, O_RDWR);
+
+	kvm_vm_elf_load(vm, program_invocation_name, 0, 0);
+	vm_vcpu_add_default(vm, vcpuid, guest_code);
+
+	return vm;
+}
+
+void vm_vcpu_add_default(struct kvm_vm *vm, uint32_t vcpuid, void *guest_code)
+{
+	size_t stack_size = vm->page_size == 4096 ?
+					DEFAULT_STACK_PGS * vm->page_size :
+					vm->page_size;
+	uint64_t stack_vaddr = vm_vaddr_alloc(vm, stack_size,
+					DEFAULT_ARM64_GUEST_STACK_VADDR_MIN, 0, 0);
+
+	vm_vcpu_add(vm, vcpuid, 0, 0);
+
+	set_reg(vm, vcpuid, ARM64_CORE_REG(sp_el1), stack_vaddr + stack_size);
+	set_reg(vm, vcpuid, ARM64_CORE_REG(regs.pc), (uint64_t)guest_code);
+}
+
+void vcpu_setup(struct kvm_vm *vm, int vcpuid, int pgd_memslot, int gdt_memslot)
+{
+	struct kvm_vcpu_init init;
+	uint64_t sctlr_el1, tcr_el1;
+
+	memset(&init, 0, sizeof(init));
+	init.target = KVM_ARM_TARGET_GENERIC_V8;
+	vcpu_ioctl(vm, vcpuid, KVM_ARM_VCPU_INIT, &init);
+
+	/*
+	 * Enable FP/ASIMD to avoid trapping when accessing Q0-Q15
+	 * registers, which the variable argument list macros do.
+	 */
+	set_reg(vm, vcpuid, ARM64_SYS_REG(CPACR_EL1), 3 << 20);
+
+	get_reg(vm, vcpuid, ARM64_SYS_REG(SCTLR_EL1), &sctlr_el1);
+	get_reg(vm, vcpuid, ARM64_SYS_REG(TCR_EL1), &tcr_el1);
+
+	switch (vm->mode) {
+	case VM_MODE_FLAT48PG:
+		tcr_el1 |= 0ul << 14; /* TG0 = 4KB */
+		tcr_el1 |= 6ul << 32; /* IPS = 52 bits */
+		break;
+	default:
+		TEST_ASSERT(false, "Unknown guest mode, mode: 0x%x", vm->mode);
+	}
+
+	sctlr_el1 |= (1 << 0) | (1 << 2) | (1 << 12) /* M | C | I */;
+	/* TCR_EL1 |= IRGN0:WBWA | ORGN0:WBWA | SH0:Inner-Shareable */;
+	tcr_el1 |= (1 << 8) | (1 << 10) | (3 << 12);
+	tcr_el1 |= (64 - vm->va_bits) /* T0SZ */;
+
+	set_reg(vm, vcpuid, ARM64_SYS_REG(SCTLR_EL1), sctlr_el1);
+	set_reg(vm, vcpuid, ARM64_SYS_REG(TCR_EL1), tcr_el1);
+	set_reg(vm, vcpuid, ARM64_SYS_REG(MAIR_EL1), DEFAULT_MAIR_EL1);
+	set_reg(vm, vcpuid, ARM64_SYS_REG(TTBR0_EL1), vm->pgd);
+}
+
+void vcpu_dump(FILE *stream, struct kvm_vm *vm, uint32_t vcpuid, uint8_t indent)
+{
+	uint64_t pstate, pc;
+
+	get_reg(vm, vcpuid, ARM64_CORE_REG(regs.pstate), &pstate);
+	get_reg(vm, vcpuid, ARM64_CORE_REG(regs.pc), &pc);
+
+        fprintf(stream, "%*spstate: 0x%.16llx pc: 0x%.16llx\n",
+                indent, "", pstate, pc);
+
+}
-- 
2.17.1
