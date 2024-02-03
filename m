Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 587B210A31
	for <kvmarm@lists.linux.dev>; Sat,  3 Feb 2024 00:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706918978; cv=none; b=LBUp6Dyl/WBn7W07Y2mR9HDl90tsbdIfzc4puW4rBTfQdb4gcYxIA2ZNmg+1LmJNV9JCy77GCxUOcw7Ui5NOHKr0tbK4yf7Sx7TSRjNqLiyrPSVjQsPW9pldy336OQm3fV/oq2aHQma0kx6KfGuFdHZhJRXp8Xux3w21uNPP4H0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706918978; c=relaxed/simple;
	bh=qQqc0EiIYxFI/LhKRBkJ7kQPJAVfHL4+1rGyNOlKFGs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ejtVwk0ooY5v5gmvtFFou+rGGCNbyOTGU/YYfTyox36c6HbQKBjNSdCC3n08fuztkaEIJJbmQaLqM+CaEBDTWX6EwwupicbmCgatHse9LYdhiib04fAptLga5Lv3m+rowwlXwn2Pde6aCu7fHdTorUwGX0t47pX69oASX1Rat1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ULEmhhTQ; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ULEmhhTQ"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dc6c24a4ce1so4031708276.2
        for <kvmarm@lists.linux.dev>; Fri, 02 Feb 2024 16:09:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706918974; x=1707523774; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=kcNwe0n4y+fi75yl+T1k9chorTvmU12VF8T08tNTnrE=;
        b=ULEmhhTQTeLalCJFJfK+y6L7T+ZWf22tZIWGwTb9SxkliSbEMYv2BE13AbxqN0fSy5
         xFWEMU63HdNqatmDtrNkF9Vm4iht9nPSmlXg56fUy/6jGOUDZkcgriSTrqD6VfL/d8rM
         0bu0x+ZJkgn8/Vn/gTBvparjSdmEA0W/VOiA2TOs1qSKqwxS3PluJ3ZzkIbnX66ix+EU
         w8rUikAnx/vk+PSngCJrbxjVPCs81Bx72ZawbFmRl/g20lEh5a+wjm+7+WFWrsg3GcRB
         mhrVUXa3tLURGkTcRb+EBJDyH9S9pVfSi0NKYlFvfv3Bix9MTXMoyXmI6ookTVGjHcei
         /y9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706918974; x=1707523774;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kcNwe0n4y+fi75yl+T1k9chorTvmU12VF8T08tNTnrE=;
        b=Tt7WWCwpaClo03Xw7gtOUx5tTizh4Ra+lZY4gf3Y3d/96g1kvPHkVTTN8F2+qQCxip
         D1Mvm3rbZQyFQXPvdrOJDqVDMd7Pi2KaU8D8cK3gFRzaD2W97Ngj7fGs9qX7fzdoGzjS
         BHLawuxXhgXlZ47+uXXPrWfPXrkBvR9wOnXnqzPbWr0EfFQCLQw0kDj/omMI1euVG0j1
         kaMxjltCuWbhXXyWNjCspMaOV3cY4ooMCTBWiDyUJnhircjOUDxHHDNItZ2xMObw1PrJ
         JSybY8nrV6h/qDeMwYWidOZT5TWzNToOY92l7htSo1vP44PhlSKMXzoe6WjcPlG7n3JE
         svBA==
X-Gm-Message-State: AOJu0YyHRKp3As0YDsh6soB3T3gEQxLDi+dzU3dEGTg4Pzk8O7wqD6Zn
	eBhFXz8L/qgpBXC1K39XqkznD++EtexRnWWul6q+hsluYBXoG7u6XMDGjlUcV1NrITZR5tR4uBB
	rag==
X-Google-Smtp-Source: AGHT+IFSBiC4pwy/1GMY0akKl2+vCiGBbqGUglBQSMkSfm9h5k59LZ0biXvwcd8bPkR+6OYthWg2LoBZS3g=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:920:b0:dc6:55ac:d08d with SMTP id
 bu32-20020a056902092000b00dc655acd08dmr2378837ybb.5.1706918974538; Fri, 02
 Feb 2024 16:09:34 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  2 Feb 2024 16:09:13 -0800
In-Reply-To: <20240203000917.376631-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240203000917.376631-1-seanjc@google.com>
X-Mailer: git-send-email 2.43.0.594.gd9cf4e227d-goog
Message-ID: <20240203000917.376631-8-seanjc@google.com>
Subject: [PATCH v8 07/10] KVM: selftests: Allow tagging protected memory in
 guest page tables
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Vishal Annapurve <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Andrew Jones <andrew.jones@linux.dev>, Tom Lendacky <thomas.lendacky@amd.com>, 
	Michael Roth <michael.roth@amd.com>, Peter Gonda <pgonda@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Peter Gonda <pgonda@google.com>

Add support for tagging and untagging guest physical address, e.g. to
allow x86's SEV and TDX guests to embed shared vs. private information in
the GPA.  SEV (encryption, a.k.a. C-bit) and TDX (shared, a.k.a. S-bit)
steal bits from the guest's physical address space that is consumed by the
CPU metadata, i.e. effectively aliases the "real" GPA.

Implement generic "tagging" so that the shared vs. private metadata can be
managed by x86 without bleeding too many details into common code.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Vishal Annapurve <vannapurve@google.com>
Cc: Ackerly Tng <ackerleytng@google.com>
cc: Andrew Jones <andrew.jones@linux.dev>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Michael Roth <michael.roth@amd.com>
Originally-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Peter Gonda <pgonda@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../kvm/include/aarch64/kvm_util_arch.h       |  7 +++++++
 .../selftests/kvm/include/kvm_util_base.h     | 13 ++++++++++++
 .../kvm/include/riscv/kvm_util_arch.h         |  7 +++++++
 .../kvm/include/s390x/kvm_util_arch.h         |  7 +++++++
 .../kvm/include/x86_64/kvm_util_arch.h        | 21 +++++++++++++++++++
 tools/testing/selftests/kvm/lib/kvm_util.c    | 17 +++++++++++++++
 .../selftests/kvm/lib/x86_64/processor.c      | 15 ++++++++++++-
 7 files changed, 86 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/kvm/include/aarch64/kvm_util_arch.h
 create mode 100644 tools/testing/selftests/kvm/include/riscv/kvm_util_arch.h
 create mode 100644 tools/testing/selftests/kvm/include/s390x/kvm_util_arch.h
 create mode 100644 tools/testing/selftests/kvm/include/x86_64/kvm_util_arch.h

diff --git a/tools/testing/selftests/kvm/include/aarch64/kvm_util_arch.h b/tools/testing/selftests/kvm/include/aarch64/kvm_util_arch.h
new file mode 100644
index 000000000000..218f5cdf0d86
--- /dev/null
+++ b/tools/testing/selftests/kvm/include/aarch64/kvm_util_arch.h
@@ -0,0 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _TOOLS_LINUX_ASM_ARM64_KVM_HOST_H
+#define _TOOLS_LINUX_ASM_ARM64_KVM_HOST_H
+
+struct kvm_vm_arch {};
+
+#endif  // _TOOLS_LINUX_ASM_ARM64_KVM_HOST_H
diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index cb3159af6db3..4b266dc0c9bd 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -18,9 +18,11 @@
 #include <linux/types.h>
 
 #include <asm/atomic.h>
+#include <asm/kvm.h>
 
 #include <sys/ioctl.h>
 
+#include "kvm_util_arch.h"
 #include "sparsebit.h"
 
 /*
@@ -113,6 +115,9 @@ struct kvm_vm {
 	vm_vaddr_t idt;
 	vm_vaddr_t handlers;
 	uint32_t dirty_ring_size;
+	uint64_t gpa_tag_mask;
+
+	struct kvm_vm_arch arch;
 
 	/* Cache of information for binary stats interface */
 	int stats_fd;
@@ -605,6 +610,12 @@ void *addr_gva2hva(struct kvm_vm *vm, vm_vaddr_t gva);
 vm_paddr_t addr_hva2gpa(struct kvm_vm *vm, void *hva);
 void *addr_gpa2alias(struct kvm_vm *vm, vm_paddr_t gpa);
 
+
+static inline vm_paddr_t vm_untag_gpa(struct kvm_vm *vm, vm_paddr_t gpa)
+{
+	return gpa & ~vm->gpa_tag_mask;
+}
+
 void vcpu_run(struct kvm_vcpu *vcpu);
 int _vcpu_run(struct kvm_vcpu *vcpu);
 
@@ -1114,4 +1125,6 @@ void kvm_selftest_arch_init(void);
 
 void kvm_arch_vm_post_create(struct kvm_vm *vm);
 
+bool vm_is_gpa_protected(struct kvm_vm *vm, vm_paddr_t paddr);
+
 #endif /* SELFTEST_KVM_UTIL_BASE_H */
diff --git a/tools/testing/selftests/kvm/include/riscv/kvm_util_arch.h b/tools/testing/selftests/kvm/include/riscv/kvm_util_arch.h
new file mode 100644
index 000000000000..c8280d5659ce
--- /dev/null
+++ b/tools/testing/selftests/kvm/include/riscv/kvm_util_arch.h
@@ -0,0 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _TOOLS_LINUX_ASM_RISCV_KVM_HOST_H
+#define _TOOLS_LINUX_ASM_RISCV_KVM_HOST_H
+
+struct kvm_vm_arch {};
+
+#endif  // _TOOLS_LINUX_ASM_RISCV_KVM_HOST_H
diff --git a/tools/testing/selftests/kvm/include/s390x/kvm_util_arch.h b/tools/testing/selftests/kvm/include/s390x/kvm_util_arch.h
new file mode 100644
index 000000000000..4c4c1c1e4bf8
--- /dev/null
+++ b/tools/testing/selftests/kvm/include/s390x/kvm_util_arch.h
@@ -0,0 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _TOOLS_LINUX_ASM_S390_KVM_HOST_H
+#define _TOOLS_LINUX_ASM_S390_KVM_HOST_H
+
+struct kvm_vm_arch {};
+
+#endif  // _TOOLS_LINUX_ASM_S390_KVM_HOST_H
diff --git a/tools/testing/selftests/kvm/include/x86_64/kvm_util_arch.h b/tools/testing/selftests/kvm/include/x86_64/kvm_util_arch.h
new file mode 100644
index 000000000000..17bb38236d97
--- /dev/null
+++ b/tools/testing/selftests/kvm/include/x86_64/kvm_util_arch.h
@@ -0,0 +1,21 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _TOOLS_LINUX_ASM_X86_KVM_HOST_H
+#define _TOOLS_LINUX_ASM_X86_KVM_HOST_H
+
+#include <stdbool.h>
+#include <stdint.h>
+
+struct kvm_vm_arch {
+	uint64_t c_bit;
+	uint64_t s_bit;
+};
+
+static inline bool __vm_arch_has_protected_memory(struct kvm_vm_arch *arch)
+{
+	return arch->c_bit || arch->s_bit;
+}
+
+#define vm_arch_has_protected_memory(vm) \
+	__vm_arch_has_protected_memory(&(vm)->arch)
+
+#endif  // _TOOLS_LINUX_ASM_X86_KVM_HOST_H
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index e7f4f84f2e68..19511137d1ae 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1597,6 +1597,8 @@ void *addr_gpa2hva(struct kvm_vm *vm, vm_paddr_t gpa)
 {
 	struct userspace_mem_region *region;
 
+	gpa = vm_untag_gpa(vm, gpa);
+
 	region = userspace_mem_region_find(vm, gpa, gpa);
 	if (!region) {
 		TEST_FAIL("No vm physical memory at 0x%lx", gpa);
@@ -2305,3 +2307,18 @@ void __attribute((constructor)) kvm_selftest_init(void)
 
 	kvm_selftest_arch_init();
 }
+
+bool vm_is_gpa_protected(struct kvm_vm *vm, vm_paddr_t paddr)
+{
+	sparsebit_idx_t pg = 0;
+	struct userspace_mem_region *region;
+
+	if (!vm_arch_has_protected_memory(vm))
+		return false;
+
+	region = userspace_mem_region_find(vm, paddr, paddr);
+	TEST_ASSERT(region, "No vm physical memory at 0x%lx", paddr);
+
+	pg = paddr >> vm->page_shift;
+	return sparsebit_is_set(region->protected_phy_pages, pg);
+}
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 615d05247470..6c1d2c0ec584 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -157,6 +157,8 @@ static uint64_t *virt_create_upper_pte(struct kvm_vm *vm,
 {
 	uint64_t *pte = virt_get_pte(vm, parent_pte, vaddr, current_level);
 
+	paddr = vm_untag_gpa(vm, paddr);
+
 	if (!(*pte & PTE_PRESENT_MASK)) {
 		*pte = PTE_PRESENT_MASK | PTE_WRITABLE_MASK;
 		if (current_level == target_level)
@@ -200,6 +202,8 @@ void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr, int level)
 		    "Physical address beyond maximum supported,\n"
 		    "  paddr: 0x%lx vm->max_gfn: 0x%lx vm->page_size: 0x%x",
 		    paddr, vm->max_gfn, vm->page_size);
+	TEST_ASSERT(vm_untag_gpa(vm, paddr) == paddr,
+		    "Unexpected bits in paddr: %lx", paddr);
 
 	/*
 	 * Allocate upper level page tables, if not already present.  Return
@@ -222,6 +226,15 @@ void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr, int level)
 	TEST_ASSERT(!(*pte & PTE_PRESENT_MASK),
 		    "PTE already present for 4k page at vaddr: 0x%lx", vaddr);
 	*pte = PTE_PRESENT_MASK | PTE_WRITABLE_MASK | (paddr & PHYSICAL_PAGE_MASK);
+
+	/*
+	 * Neither SEV nor TDX supports shared page tables, so only the final
+	 * leaf PTE needs manually set the C/S-bit.
+	 */
+	if (vm_is_gpa_protected(vm, paddr))
+		*pte |= vm->arch.c_bit;
+	else
+		*pte |= vm->arch.s_bit;
 }
 
 void virt_arch_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
@@ -496,7 +509,7 @@ vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
 	 * No need for a hugepage mask on the PTE, x86-64 requires the "unused"
 	 * address bits to be zero.
 	 */
-	return PTE_GET_PA(*pte) | (gva & ~HUGEPAGE_MASK(level));
+	return vm_untag_gpa(vm, PTE_GET_PA(*pte)) | (gva & ~HUGEPAGE_MASK(level));
 }
 
 static void kvm_setup_gdt(struct kvm_vm *vm, struct kvm_dtable *dt)
-- 
2.43.0.594.gd9cf4e227d-goog

