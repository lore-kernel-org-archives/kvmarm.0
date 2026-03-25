Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 598D82066DE
	for <kvmarm@lists.linux.dev>; Wed, 25 Mar 2026 00:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774399071; cv=none; b=euafo1pvocL6IrpOKjAvVpfWoaYPjvJC3i7j82frSpASOUj3AcIAPfO0emGeRRXbjO94/O58K2447gv74vuVB5NOpxj+VPe1K/uKP6FLlr/B2UcQZ9oEP8FnQwGyMaLxObUOKH6bVx7FV2X8doj6e5WspKyvAPpIrbTdun56QnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774399071; c=relaxed/simple;
	bh=Ia+vilw3zsqeIzVE3dF4KM+CNyzCGCU+jhvm1P5T5B8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U43UuqysOhDEn+V6C89VYDx/HPaAMAc3mp6w1tjsR6n+EWcXD/SP/dcY13EeR5IY9AdhLlyjcC3j8YYgy3eUB6ocJIcb2fYMRHdkMUZrhwy/uTDjy24XIzErriyHjwjz8dLccO7wiB3Bqwx5bg6KEguOZ7WbrdxJRXsouckLiEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=txQiWite; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="txQiWite"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D55991C14;
	Tue, 24 Mar 2026 17:37:43 -0700 (PDT)
Received: from workstation-e142269.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A06123FE53;
	Tue, 24 Mar 2026 17:37:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1774399069; bh=Ia+vilw3zsqeIzVE3dF4KM+CNyzCGCU+jhvm1P5T5B8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=txQiWiter+YQWq+0d+dLUs3Ut9UQP5DnpuSantdQEso5kSTyrcU3ZGUtb7/qQNTDt
	 xM0HIdfGUI0F6wcMwho7heLm2gW0zKWpIZ9c/FL632wHWG2xfymBxiYUL4LydUZBus
	 YuNN67lZ9og1GYkvFu+EU05KvMY+UJ0ZfLyXxH+k=
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
Subject: [PATCH 3/3] KVM: arm64: selftests: Enable stage-2 in NV preparation functions
Date: Wed, 25 Mar 2026 00:36:20 +0000
Message-ID: <20260325003620.2214766-4-weilin.chang@arm.com>
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

Introduce library functions for setting up guest stage-2 page tables,
then use that to give L2 an identity mapped stage-2 and enable it.

The translation and stage-2 page table built is simple, start level 0,
4 levels, 4KB granules, normal cachable, 48-bit IA, 40-bit OA.

The nested page table code is adapted from lib/x86/vmx.c.

Signed-off-by: Wei-Lin Chang <weilin.chang@arm.com>
---
 .../selftests/kvm/include/arm64/nested.h      |  7 ++
 .../selftests/kvm/include/arm64/processor.h   |  9 ++
 .../testing/selftests/kvm/lib/arm64/nested.c  | 97 ++++++++++++++++++-
 3 files changed, 111 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/arm64/nested.h b/tools/testing/selftests/kvm/include/arm64/nested.h
index 739ff2ee0161..0be10a775e48 100644
--- a/tools/testing/selftests/kvm/include/arm64/nested.h
+++ b/tools/testing/selftests/kvm/include/arm64/nested.h
@@ -6,6 +6,13 @@
 #ifndef SELFTEST_KVM_NESTED_H
 #define SELFTEST_KVM_NESTED_H
 
+uint64_t get_l1_vtcr(void);
+
+void nested_map(struct kvm_vm *vm, vm_paddr_t guest_pgd,
+		uint64_t nested_paddr, uint64_t paddr, uint64_t size);
+void nested_map_memslot(struct kvm_vm *vm, vm_paddr_t guest_pgd,
+			uint32_t memslot);
+
 void prepare_l2_stack(struct kvm_vm *vm, struct kvm_vcpu *vcpu);
 void prepare_hyp_state(struct kvm_vm *vm, struct kvm_vcpu *vcpu);
 void prepare_eret_destination(struct kvm_vm *vm, struct kvm_vcpu *vcpu, void *l2_pc);
diff --git a/tools/testing/selftests/kvm/include/arm64/processor.h b/tools/testing/selftests/kvm/include/arm64/processor.h
index ac97a1c436fc..5de2e932d95a 100644
--- a/tools/testing/selftests/kvm/include/arm64/processor.h
+++ b/tools/testing/selftests/kvm/include/arm64/processor.h
@@ -104,6 +104,15 @@
 #define TCR_HA			(UL(1) << 39)
 #define TCR_DS			(UL(1) << 59)
 
+/* VTCR_EL2 specific flags */
+#define VTCR_EL2_T0SZ_BITS(x)	((UL(64) - (x)) << VTCR_EL2_T0SZ_SHIFT)
+
+#define VTCR_EL2_SL0_LV0_4K	(UL(2) << VTCR_EL2_SL0_SHIFT)
+#define VTCR_EL2_SL0_LV1_4K	(UL(1) << VTCR_EL2_SL0_SHIFT)
+#define VTCR_EL2_SL0_LV2_4K	(UL(0) << VTCR_EL2_SL0_SHIFT)
+
+#define VTCR_EL2_PS_40_BITS	(UL(2) << VTCR_EL2_PS_SHIFT)
+
 /*
  * AttrIndx[2:0] encoding (mapping attributes defined in the MAIR* registers).
  */
diff --git a/tools/testing/selftests/kvm/lib/arm64/nested.c b/tools/testing/selftests/kvm/lib/arm64/nested.c
index 111d02f44cfe..910f8cd30f96 100644
--- a/tools/testing/selftests/kvm/lib/arm64/nested.c
+++ b/tools/testing/selftests/kvm/lib/arm64/nested.c
@@ -1,8 +1,11 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- * ARM64 Nested virtualization helpers
+ * ARM64 Nested virtualization helpers, nested page table code adapted from
+ * ../x86/vmx.c.
  */
 
+#include <linux/sizes.h>
+
 #include "kvm_util.h"
 #include "nested.h"
 #include "processor.h"
@@ -18,6 +21,87 @@ static void hvc_handler(struct ex_regs *regs)
 	regs->pc = (u64)after_hvc;
 }
 
+uint64_t get_l1_vtcr(void)
+{
+	return VTCR_EL2_PS_40_BITS | VTCR_EL2_TG0_4K | VTCR_EL2_ORGN0_WBWA |
+	       VTCR_EL2_IRGN0_WBWA | VTCR_EL2_SL0_LV0_4K | VTCR_EL2_T0SZ_BITS(48);
+}
+
+static void __nested_pg_map(struct kvm_vm *vm, uint64_t guest_pgd,
+		     uint64_t nested_paddr, uint64_t paddr, uint64_t flags)
+{
+	uint8_t attr_idx = flags & (PTE_ATTRINDX_MASK >> PTE_ATTRINDX_SHIFT);
+	uint64_t pg_attr;
+	uint64_t *ptep;
+
+	TEST_ASSERT((nested_paddr % vm->page_size) == 0,
+		"L2 IPA not on page boundary,\n"
+		"  nested_paddr: 0x%lx vm->page_size: 0x%x", nested_paddr, vm->page_size);
+	TEST_ASSERT((paddr % vm->page_size) == 0,
+		"Guest physical address not on page boundary,\n"
+		"  paddr: 0x%lx vm->page_size: 0x%x", paddr, vm->page_size);
+	TEST_ASSERT((paddr >> vm->page_shift) <= vm->max_gfn,
+		"Physical address beyond maximum supported,\n"
+		"  paddr: 0x%lx vm->max_gfn: 0x%lx vm->page_size: 0x%x",
+		paddr, vm->max_gfn, vm->page_size);
+
+	ptep = addr_gpa2hva(vm, guest_pgd) + ((nested_paddr >> 39) & 0x1ffu) * 8;
+	if (!*ptep)
+		*ptep = (vm_alloc_page_table(vm) & GENMASK(47, 12)) | PGD_TYPE_TABLE | PTE_VALID;
+	ptep = addr_gpa2hva(vm, *ptep & GENMASK(47, 12)) + ((nested_paddr >> 30) & 0x1ffu) * 8;
+	if (!*ptep)
+		*ptep = (vm_alloc_page_table(vm) & GENMASK(47, 12)) | PUD_TYPE_TABLE | PTE_VALID;
+	ptep = addr_gpa2hva(vm, *ptep & GENMASK(47, 12)) + ((nested_paddr >> 21) & 0x1ffu) * 8;
+	if (!*ptep)
+		*ptep = (vm_alloc_page_table(vm) & GENMASK(47, 12)) | PMD_TYPE_TABLE | PTE_VALID;
+	ptep = addr_gpa2hva(vm, *ptep & GENMASK(47, 12)) + ((nested_paddr >> 12) & 0x1ffu) * 8;
+
+	pg_attr = PTE_AF | PTE_ATTRINDX(attr_idx) | PTE_TYPE_PAGE | PTE_VALID;
+	pg_attr |= PTE_SHARED;
+
+	*ptep = (paddr & GENMASK(47, 12)) | pg_attr;
+}
+
+void nested_map(struct kvm_vm *vm, vm_paddr_t guest_pgd,
+		uint64_t nested_paddr, uint64_t paddr, uint64_t size)
+{
+	size_t npages = size / SZ_4K;
+
+	TEST_ASSERT(nested_paddr + size > nested_paddr, "Vaddr overflow");
+	TEST_ASSERT(paddr + size > paddr, "Paddr overflow");
+
+	while (npages--) {
+		__nested_pg_map(vm, guest_pgd, nested_paddr, paddr, MT_NORMAL);
+		nested_paddr += SZ_4K;
+		paddr += SZ_4K;
+	}
+}
+
+/*
+ * Prepare an identity shadow page table that maps all the
+ * physical pages in VM.
+ */
+void nested_map_memslot(struct kvm_vm *vm, vm_paddr_t guest_pgd,
+			uint32_t memslot)
+{
+	sparsebit_idx_t i, last;
+	struct userspace_mem_region *region =
+		memslot2region(vm, memslot);
+
+	i = (region->region.guest_phys_addr >> vm->page_shift) - 1;
+	last = i + (region->region.memory_size >> vm->page_shift);
+	for (;;) {
+		i = sparsebit_next_clear(region->unused_phy_pages, i);
+		if (i > last)
+			break;
+
+		nested_map(vm, guest_pgd,
+			   (uint64_t)i << vm->page_shift,
+			   (uint64_t)i << vm->page_shift,
+			   1 << vm->page_shift);
+	}
+}
+
 void prepare_l2_stack(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
 {
 	size_t l2_stack_size;
@@ -32,7 +116,16 @@ void prepare_l2_stack(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
 
 void prepare_hyp_state(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
 {
-	vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_HCR_EL2), HCR_EL2_RW);
+	vm_paddr_t guest_pgd;
+
+	guest_pgd = vm_phy_pages_alloc(vm, 1,
+				       KVM_GUEST_PAGE_TABLE_MIN_PADDR,
+				       vm->memslots[MEM_REGION_PT]);
+	nested_map_memslot(vm, guest_pgd, 0);
+
+	vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_HCR_EL2), HCR_EL2_RW | HCR_EL2_VM);
+	vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_VTTBR_EL2), guest_pgd);
+	vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_VTCR_EL2), get_l1_vtcr());
 }
 
 void prepare_eret_destination(struct kvm_vm *vm, struct kvm_vcpu *vcpu, void *l2_pc)
-- 
2.43.0

