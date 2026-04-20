Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 684D93D34A0
	for <kvmarm@lists.linux.dev>; Mon, 20 Apr 2026 21:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776720043; cv=none; b=bF5XhOdG+JIfxhrmb3NBoS4LyvLmN6g5GMdWsoQIeVbkqIM0e4v/bPgVHpUAibiJgkt04PZHxvFsdsQudIH1pbNJB+8Lap+DdkhExxXW6xyADkQtEtajVLNLA4taJWR4ObhKP3Qh3/phLjoGM117J5p2lVtZtieSe4TDDclbvoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776720043; c=relaxed/simple;
	bh=iRHWvQzRWl2qYBVoIaDA2miibqLlqjQXoa8pfp7Li28=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=eTJo+uzw5lSqm6+ln8aYGbdtVDge8Oeu1vHem5gfUjlvPt6i6JzI93FZ75sjx5MQVjX6uxwAH3xP5lLSAHmI/ffJNEIGXRqaQCvPWdOSARsNnmjF4LCVHq4lXC637wNuosisNTtesn3sT0xNZQUTAIxGjOYn3WMsDNKOphHGCCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JGshYYeL; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JGshYYeL"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-35dacc40f92so3382705a91.2
        for <kvmarm@lists.linux.dev>; Mon, 20 Apr 2026 14:20:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776720039; x=1777324839; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=1qrsMvN9UBRlhRa6qBAPaSl5i4QKt8DJvZtIZe1SKO4=;
        b=JGshYYeLsPWpdNYQbs9SS26OUs3cEJHwQ/5rHxZ4PzpB7DrwO7kW3p3uIvX+W5m6q9
         v0c/sSQ5KqUxQ3PQmWakaMIljckmGPvEaGyb4Vc1Zng4oj/w7qZtluRE2YV4TxH7W0GQ
         r8bmhWnmkh5ARJQoFre2Gwu08zY7n+d6DxGXwPQfMuX7bWN3WcqeyWYTfWE+miIbpIPm
         oBObhJ94Esi4hKIHWWUb1lHXOmo5Pi9yIlqYItMeDYTo9Vezh44/d8xkKpoEcPeGV7+R
         i8zSrlNTE37qINa92f+kxuncNYZDc5MZuwCZjR5UUYUxzAralGkcPibX4XGDII6r4Cob
         yUyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776720039; x=1777324839;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1qrsMvN9UBRlhRa6qBAPaSl5i4QKt8DJvZtIZe1SKO4=;
        b=U6GeKz2lEKRRvppdXkrTzsJSSQgyV9cpY7+NegwVOqApPU+PuVLRfQsdfxLlGbv7oi
         b5o5oPdcIZz0MGFuV7I9r70u4AOaz3vqs3eM0un0NSRYcwLGYHphsqGPlaq67z0QxmGe
         /Ufoihc7DGiZHkuzPo6JOkK0JYj80zXrGExhjS0PQPu+XddtGv249oZxksZO31/5+ZpU
         VuuIoCjnaQVrkT2JIlkUpSMFClPGT8Gtfj7K9KIdkAWUVF6rQjfXxFQNHy/dcIuVE+P5
         plJADP67qn1nteUr2yyDqh96xoNRCBuByiETvciTJ3ORRX0HAkQhcdYpfpKUyAGfoEvP
         Jkww==
X-Forwarded-Encrypted: i=1; AFNElJ9XhB467/ca4kaSagq7INeHZADDrTBQyoYI8O5WXEW8WipJbHTklBKoNlViHffdL0KiMKVlTuA=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw755n6f3tvh9abVJnnd5M99Mr3Hc7r05+tLVhxQjKrUt8UtRRr
	/vgtxaroTnQ+e/cD93R+QYdqGTxlJ3SnEjAdeV+Iqx87JOTGUsPmE58113MvhKht+1UL+JTV7KJ
	1lMyKbg==
X-Received: from pjbbt3.prod.google.com ([2002:a17:90a:f003:b0:35c:1c70:fcd9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:f16:b0:361:4521:d311
 with SMTP id 98e67ed59e1d1-36145221bbfmr9636140a91.18.1776720038540; Mon, 20
 Apr 2026 14:20:38 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 20 Apr 2026 14:20:01 -0700
In-Reply-To: <20260420212004.3938325-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260420212004.3938325-1-seanjc@google.com>
X-Mailer: git-send-email 2.54.0.rc1.555.g9c883467ad-goog
Message-ID: <20260420212004.3938325-17-seanjc@google.com>
Subject: [PATCH v3 16/19] KVM: selftests: Replace "vaddr" with "gva" throughout
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, loongarch@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Replace all variations of "vaddr" variables in KVM selftests with "gva",
with the exception of the ELF structures, as those fields are not specific
to guest virtual addresses, to complete the conversion from vm_vaddr_t to
gva_t.

Opportunistically use gva_t instead of u64 for relevant variables, and
fixup indentation as appropriate.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/access_tracking_perf_test.c |  6 +-
 .../selftests/kvm/arm64/page_fault_test.c     |  4 +-
 .../testing/selftests/kvm/include/kvm_util.h  | 32 +++-----
 .../testing/selftests/kvm/include/memstress.h |  2 +-
 .../selftests/kvm/include/x86/processor.h     |  6 +-
 .../selftests/kvm/lib/arm64/processor.c       | 33 ++++----
 tools/testing/selftests/kvm/lib/elf.c         | 10 +--
 tools/testing/selftests/kvm/lib/kvm_util.c    | 60 ++++++--------
 .../selftests/kvm/lib/loongarch/processor.c   | 25 +++---
 tools/testing/selftests/kvm/lib/memstress.c   |  2 +-
 .../selftests/kvm/lib/riscv/processor.c       | 25 +++---
 .../selftests/kvm/lib/s390/processor.c        | 23 +++---
 .../testing/selftests/kvm/lib/ucall_common.c  |  8 +-
 .../testing/selftests/kvm/lib/x86/processor.c | 82 +++++++++----------
 .../selftests/kvm/s390/ucontrol_test.c        |  4 +-
 .../selftests/kvm/x86/xapic_ipi_test.c        | 10 +--
 16 files changed, 150 insertions(+), 182 deletions(-)

diff --git a/tools/testing/selftests/kvm/access_tracking_perf_test.c b/tools/testing/selftests/kvm/access_tracking_perf_test.c
index 4479aed94625..e5bbdb5bbdc3 100644
--- a/tools/testing/selftests/kvm/access_tracking_perf_test.c
+++ b/tools/testing/selftests/kvm/access_tracking_perf_test.c
@@ -123,7 +123,7 @@ static u64 pread_u64(int fd, const char *filename, u64 index)
 #define PAGEMAP_PRESENT (1ULL << 63)
 #define PAGEMAP_PFN_MASK ((1ULL << 55) - 1)
 
-static u64 lookup_pfn(int pagemap_fd, struct kvm_vm *vm, u64 gva)
+static u64 lookup_pfn(int pagemap_fd, struct kvm_vm *vm, gva_t gva)
 {
 	u64 hva = (u64)addr_gva2hva(vm, gva);
 	u64 entry;
@@ -174,7 +174,7 @@ static void pageidle_mark_vcpu_memory_idle(struct kvm_vm *vm,
 					   struct memstress_vcpu_args *vcpu_args)
 {
 	int vcpu_idx = vcpu_args->vcpu_idx;
-	u64 base_gva = vcpu_args->gva;
+	gva_t base_gva = vcpu_args->gva;
 	u64 pages = vcpu_args->pages;
 	u64 page;
 	u64 still_idle = 0;
@@ -193,7 +193,7 @@ static void pageidle_mark_vcpu_memory_idle(struct kvm_vm *vm,
 	TEST_ASSERT(pagemap_fd > 0, "Failed to open pagemap.");
 
 	for (page = 0; page < pages; page++) {
-		u64 gva = base_gva + page * memstress_args.guest_page_size;
+		gva_t gva = base_gva + page * memstress_args.guest_page_size;
 		u64 pfn = lookup_pfn(pagemap_fd, vm, gva);
 
 		if (!pfn) {
diff --git a/tools/testing/selftests/kvm/arm64/page_fault_test.c b/tools/testing/selftests/kvm/arm64/page_fault_test.c
index b92a9614d7d2..6bb3d82906b2 100644
--- a/tools/testing/selftests/kvm/arm64/page_fault_test.c
+++ b/tools/testing/selftests/kvm/arm64/page_fault_test.c
@@ -70,9 +70,9 @@ struct test_params {
 	struct test_desc *test_desc;
 };
 
-static inline void flush_tlb_page(u64 vaddr)
+static inline void flush_tlb_page(gva_t gva)
 {
-	u64 page = vaddr >> 12;
+	gva_t page = gva >> 12;
 
 	dsb(ishst);
 	asm volatile("tlbi vaae1is, %0" :: "r" (page));
diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 0fbfb2a28767..0dcfad728edd 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -715,17 +715,17 @@ void vm_mem_region_move(struct kvm_vm *vm, u32 slot, u64 new_gpa);
 void vm_mem_region_delete(struct kvm_vm *vm, u32 slot);
 struct kvm_vcpu *__vm_vcpu_add(struct kvm_vm *vm, u32 vcpu_id);
 void vm_populate_gva_bitmap(struct kvm_vm *vm);
-gva_t vm_unused_gva_gap(struct kvm_vm *vm, size_t sz, gva_t vaddr_min);
-gva_t vm_alloc(struct kvm_vm *vm, size_t sz, gva_t vaddr_min);
-gva_t __vm_alloc(struct kvm_vm *vm, size_t sz, gva_t vaddr_min,
+gva_t vm_unused_gva_gap(struct kvm_vm *vm, size_t sz, gva_t min_gva);
+gva_t vm_alloc(struct kvm_vm *vm, size_t sz, gva_t min_gva);
+gva_t __vm_alloc(struct kvm_vm *vm, size_t sz, gva_t min_gva,
 		 enum kvm_mem_region_type type);
-gva_t vm_alloc_shared(struct kvm_vm *vm, size_t sz, gva_t vaddr_min,
+gva_t vm_alloc_shared(struct kvm_vm *vm, size_t sz, gva_t min_gva,
 		      enum kvm_mem_region_type type);
 gva_t vm_alloc_pages(struct kvm_vm *vm, int nr_pages);
 gva_t __vm_alloc_page(struct kvm_vm *vm, enum kvm_mem_region_type type);
 gva_t vm_alloc_page(struct kvm_vm *vm);
 
-void virt_map(struct kvm_vm *vm, u64 vaddr, u64 paddr,
+void virt_map(struct kvm_vm *vm, gva_t gva, u64 paddr,
 	      unsigned int npages);
 void *addr_gpa2hva(struct kvm_vm *vm, gpa_t gpa);
 void *addr_gva2hva(struct kvm_vm *vm, gva_t gva);
@@ -1202,27 +1202,15 @@ static inline void virt_pgd_alloc(struct kvm_vm *vm)
 }
 
 /*
- * VM Virtual Page Map
- *
- * Input Args:
- *   vm - Virtual Machine
- *   vaddr - VM Virtual Address
- *   paddr - VM Physical Address
- *   memslot - Memory region slot for new virtual translation tables
- *
- * Output Args: None
- *
- * Return: None
- *
  * Within @vm, creates a virtual translation for the page starting
- * at @vaddr to the page starting at @paddr.
+ * at @gva to the page starting at @paddr.
  */
-void virt_arch_pg_map(struct kvm_vm *vm, u64 vaddr, u64 paddr);
+void virt_arch_pg_map(struct kvm_vm *vm, gva_t gva, u64 paddr);
 
-static inline void virt_pg_map(struct kvm_vm *vm, u64 vaddr, u64 paddr)
+static inline void virt_pg_map(struct kvm_vm *vm, gva_t gva, u64 paddr)
 {
-	virt_arch_pg_map(vm, vaddr, paddr);
-	sparsebit_set(vm->vpages_mapped, vaddr >> vm->page_shift);
+	virt_arch_pg_map(vm, gva, paddr);
+	sparsebit_set(vm->vpages_mapped, gva >> vm->page_shift);
 }
 
 
diff --git a/tools/testing/selftests/kvm/include/memstress.h b/tools/testing/selftests/kvm/include/memstress.h
index e3e4b4d6a27a..abd0dca10283 100644
--- a/tools/testing/selftests/kvm/include/memstress.h
+++ b/tools/testing/selftests/kvm/include/memstress.h
@@ -21,7 +21,7 @@
 
 struct memstress_vcpu_args {
 	u64 gpa;
-	u64 gva;
+	gva_t gva;
 	u64 pages;
 
 	/* Only used by the host userspace part of the vCPU thread */
diff --git a/tools/testing/selftests/kvm/include/x86/processor.h b/tools/testing/selftests/kvm/include/x86/processor.h
index 4efa6c942192..15252e75aaf1 100644
--- a/tools/testing/selftests/kvm/include/x86/processor.h
+++ b/tools/testing/selftests/kvm/include/x86/processor.h
@@ -1394,7 +1394,7 @@ static inline bool kvm_is_lbrv_enabled(void)
 	return !!get_kvm_amd_param_integer("lbrv");
 }
 
-u64 *vm_get_pte(struct kvm_vm *vm, u64 vaddr);
+u64 *vm_get_pte(struct kvm_vm *vm, gva_t gva);
 
 u64 kvm_hypercall(u64 nr, u64 a0, u64 a1, u64 a2, u64 a3);
 u64 __xen_hypercall(u64 nr, u64 a0, void *a1);
@@ -1507,9 +1507,9 @@ enum pg_level {
 void tdp_mmu_init(struct kvm_vm *vm, int pgtable_levels,
 		  struct pte_masks *pte_masks);
 
-void __virt_pg_map(struct kvm_vm *vm, struct kvm_mmu *mmu, u64 vaddr,
+void __virt_pg_map(struct kvm_vm *vm, struct kvm_mmu *mmu, gva_t gva,
 		   u64 paddr,  int level);
-void virt_map_level(struct kvm_vm *vm, u64 vaddr, u64 paddr,
+void virt_map_level(struct kvm_vm *vm, gva_t gva, u64 paddr,
 		    u64 nr_bytes, int level);
 
 void vm_enable_tdp(struct kvm_vm *vm);
diff --git a/tools/testing/selftests/kvm/lib/arm64/processor.c b/tools/testing/selftests/kvm/lib/arm64/processor.c
index 384b6c80b1e7..0f693d8891d2 100644
--- a/tools/testing/selftests/kvm/lib/arm64/processor.c
+++ b/tools/testing/selftests/kvm/lib/arm64/processor.c
@@ -121,19 +121,18 @@ void virt_arch_pgd_alloc(struct kvm_vm *vm)
 	vm->mmu.pgd_created = true;
 }
 
-static void _virt_pg_map(struct kvm_vm *vm, u64 vaddr, u64 paddr,
+static void _virt_pg_map(struct kvm_vm *vm, gva_t gva, u64 paddr,
 			 u64 flags)
 {
 	u8 attr_idx = flags & (PTE_ATTRINDX_MASK >> PTE_ATTRINDX_SHIFT);
 	u64 pg_attr;
 	u64 *ptep;
 
-	TEST_ASSERT((vaddr % vm->page_size) == 0,
+	TEST_ASSERT((gva % vm->page_size) == 0,
 		"Virtual address not on page boundary,\n"
-		"  vaddr: 0x%lx vm->page_size: 0x%x", vaddr, vm->page_size);
-	TEST_ASSERT(sparsebit_is_set(vm->vpages_valid,
-		(vaddr >> vm->page_shift)),
-		"Invalid virtual address, vaddr: 0x%lx", vaddr);
+		"  gva: 0x%lx vm->page_size: 0x%x", gva, vm->page_size);
+	TEST_ASSERT(sparsebit_is_set(vm->vpages_valid, (gva >> vm->page_shift)),
+		    "Invalid virtual address, gva: 0x%lx", gva);
 	TEST_ASSERT((paddr % vm->page_size) == 0,
 		"Physical address not on page boundary,\n"
 		"  paddr: 0x%lx vm->page_size: 0x%x", paddr, vm->page_size);
@@ -142,26 +141,26 @@ static void _virt_pg_map(struct kvm_vm *vm, u64 vaddr, u64 paddr,
 		"  paddr: 0x%lx vm->max_gfn: 0x%lx vm->page_size: 0x%x",
 		paddr, vm->max_gfn, vm->page_size);
 
-	ptep = addr_gpa2hva(vm, vm->mmu.pgd) + pgd_index(vm, vaddr) * 8;
+	ptep = addr_gpa2hva(vm, vm->mmu.pgd) + pgd_index(vm, gva) * 8;
 	if (!*ptep)
 		*ptep = addr_pte(vm, vm_alloc_page_table(vm),
 				 PGD_TYPE_TABLE | PTE_VALID);
 
 	switch (vm->mmu.pgtable_levels) {
 	case 4:
-		ptep = addr_gpa2hva(vm, pte_addr(vm, *ptep)) + pud_index(vm, vaddr) * 8;
+		ptep = addr_gpa2hva(vm, pte_addr(vm, *ptep)) + pud_index(vm, gva) * 8;
 		if (!*ptep)
 			*ptep = addr_pte(vm, vm_alloc_page_table(vm),
 					 PUD_TYPE_TABLE | PTE_VALID);
 		/* fall through */
 	case 3:
-		ptep = addr_gpa2hva(vm, pte_addr(vm, *ptep)) + pmd_index(vm, vaddr) * 8;
+		ptep = addr_gpa2hva(vm, pte_addr(vm, *ptep)) + pmd_index(vm, gva) * 8;
 		if (!*ptep)
 			*ptep = addr_pte(vm, vm_alloc_page_table(vm),
 					 PMD_TYPE_TABLE | PTE_VALID);
 		/* fall through */
 	case 2:
-		ptep = addr_gpa2hva(vm, pte_addr(vm, *ptep)) + pte_index(vm, vaddr) * 8;
+		ptep = addr_gpa2hva(vm, pte_addr(vm, *ptep)) + pte_index(vm, gva) * 8;
 		break;
 	default:
 		TEST_FAIL("Page table levels must be 2, 3, or 4");
@@ -174,11 +173,11 @@ static void _virt_pg_map(struct kvm_vm *vm, u64 vaddr, u64 paddr,
 	*ptep = addr_pte(vm, paddr, pg_attr);
 }
 
-void virt_arch_pg_map(struct kvm_vm *vm, u64 vaddr, u64 paddr)
+void virt_arch_pg_map(struct kvm_vm *vm, gva_t gva, u64 paddr)
 {
 	u64 attr_idx = MT_NORMAL;
 
-	_virt_pg_map(vm, vaddr, paddr, attr_idx);
+	_virt_pg_map(vm, gva, paddr, attr_idx);
 }
 
 u64 *virt_get_pte_hva_at_level(struct kvm_vm *vm, gva_t gva, int level)
@@ -417,18 +416,18 @@ static struct kvm_vcpu *__aarch64_vcpu_add(struct kvm_vm *vm, u32 vcpu_id,
 					   struct kvm_vcpu_init *init)
 {
 	size_t stack_size;
-	u64 stack_vaddr;
+	gva_t stack_gva;
 	struct kvm_vcpu *vcpu = __vm_vcpu_add(vm, vcpu_id);
 
 	stack_size = vm->page_size == 4096 ? DEFAULT_STACK_PGS * vm->page_size :
 					     vm->page_size;
-	stack_vaddr = __vm_alloc(vm, stack_size,
-				 DEFAULT_ARM64_GUEST_STACK_VADDR_MIN,
-				 MEM_REGION_DATA);
+	stack_gva = __vm_alloc(vm, stack_size,
+			       DEFAULT_ARM64_GUEST_STACK_VADDR_MIN,
+			       MEM_REGION_DATA);
 
 	aarch64_vcpu_setup(vcpu, init);
 
-	vcpu_set_reg(vcpu, ctxt_reg_alias(vcpu, SYS_SP_EL1), stack_vaddr + stack_size);
+	vcpu_set_reg(vcpu, ctxt_reg_alias(vcpu, SYS_SP_EL1), stack_gva + stack_size);
 	return vcpu;
 }
 
diff --git a/tools/testing/selftests/kvm/lib/elf.c b/tools/testing/selftests/kvm/lib/elf.c
index 2288480f4e1e..b689c4df4a01 100644
--- a/tools/testing/selftests/kvm/lib/elf.c
+++ b/tools/testing/selftests/kvm/lib/elf.c
@@ -162,14 +162,14 @@ void kvm_vm_elf_load(struct kvm_vm *vm, const char *filename)
 		seg_vend |= vm->page_size - 1;
 		size_t seg_size = seg_vend - seg_vstart + 1;
 
-		gva_t vaddr = __vm_alloc(vm, seg_size, seg_vstart, MEM_REGION_CODE);
-		TEST_ASSERT(vaddr == seg_vstart, "Unable to allocate "
+		gva_t gva = __vm_alloc(vm, seg_size, seg_vstart, MEM_REGION_CODE);
+		TEST_ASSERT(gva == seg_vstart, "Unable to allocate "
 			"virtual memory for segment at requested min addr,\n"
 			"  segment idx: %u\n"
 			"  seg_vstart: 0x%lx\n"
-			"  vaddr: 0x%lx",
-			n1, seg_vstart, vaddr);
-		memset(addr_gva2hva(vm, vaddr), 0, seg_size);
+			"  gva: 0x%lx",
+			n1, seg_vstart, gva);
+		memset(addr_gva2hva(vm, gva), 0, seg_size);
 		/* TODO(lhuemill): Set permissions of each memory segment
 		 * based on the least-significant 3 bits of phdr.p_flags.
 		 */
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 1a1b41021cc7..e282f9abd4c7 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1367,17 +1367,17 @@ struct kvm_vcpu *__vm_vcpu_add(struct kvm_vm *vm, u32 vcpu_id)
 
 /*
  * Within the VM specified by @vm, locates the lowest starting guest virtual
- * address >= @vaddr_min, that has at least @sz unallocated bytes.  A
+ * address >= @min_gva, that has at least @sz unallocated bytes.  A
  * TEST_ASSERT failure occurs for invalid input or no area of at least
  * @sz unallocated bytes >= @min_gva is available.
  */
-gva_t vm_unused_gva_gap(struct kvm_vm *vm, size_t sz, gva_t vaddr_min)
+gva_t vm_unused_gva_gap(struct kvm_vm *vm, size_t sz, gva_t min_gva)
 {
 	u64 pages = (sz + vm->page_size - 1) >> vm->page_shift;
 
 	/* Determine lowest permitted virtual page index. */
-	u64 pgidx_start = (vaddr_min + vm->page_size - 1) >> vm->page_shift;
-	if ((pgidx_start * vm->page_size) < vaddr_min)
+	u64 pgidx_start = (min_gva + vm->page_size - 1) >> vm->page_shift;
+	if ((pgidx_start * vm->page_size) < min_gva)
 		goto no_va_found;
 
 	/* Loop over section with enough valid virtual page indexes. */
@@ -1414,7 +1414,7 @@ gva_t vm_unused_gva_gap(struct kvm_vm *vm, size_t sz, gva_t vaddr_min)
 	} while (pgidx_start != 0);
 
 no_va_found:
-	TEST_FAIL("No vaddr of specified pages available, pages: 0x%lx", pages);
+	TEST_FAIL("No gva of specified pages available, pages: 0x%lx", pages);
 
 	/* NOT REACHED */
 	return -1;
@@ -1436,7 +1436,7 @@ gva_t vm_unused_gva_gap(struct kvm_vm *vm, size_t sz, gva_t vaddr_min)
 	return pgidx_start * vm->page_size;
 }
 
-static gva_t ____vm_alloc(struct kvm_vm *vm, size_t sz, gva_t vaddr_min,
+static gva_t ____vm_alloc(struct kvm_vm *vm, size_t sz, gva_t min_gva,
 			  enum kvm_mem_region_type type, bool protected)
 {
 	u64 pages = (sz >> vm->page_shift) + ((sz % vm->page_size) != 0);
@@ -1450,41 +1450,41 @@ static gva_t ____vm_alloc(struct kvm_vm *vm, size_t sz, gva_t vaddr_min,
 	 * Find an unused range of virtual page addresses of at least
 	 * pages in length.
 	 */
-	gva_t vaddr_start = vm_unused_gva_gap(vm, sz, vaddr_min);
+	gva_t gva_start = vm_unused_gva_gap(vm, sz, min_gva);
 
 	/* Map the virtual pages. */
-	for (gva_t vaddr = vaddr_start; pages > 0;
-		pages--, vaddr += vm->page_size, paddr += vm->page_size) {
+	for (gva_t gva = gva_start; pages > 0;
+		pages--, gva += vm->page_size, paddr += vm->page_size) {
 
-		virt_pg_map(vm, vaddr, paddr);
+		virt_pg_map(vm, gva, paddr);
 	}
 
-	return vaddr_start;
+	return gva_start;
 }
 
-gva_t __vm_alloc(struct kvm_vm *vm, size_t sz, gva_t vaddr_min,
+gva_t __vm_alloc(struct kvm_vm *vm, size_t sz, gva_t min_gva,
 		 enum kvm_mem_region_type type)
 {
-	return ____vm_alloc(vm, sz, vaddr_min, type,
+	return ____vm_alloc(vm, sz, min_gva, type,
 			    vm_arch_has_protected_memory(vm));
 }
 
-gva_t vm_alloc_shared(struct kvm_vm *vm, size_t sz, gva_t vaddr_min,
+gva_t vm_alloc_shared(struct kvm_vm *vm, size_t sz, gva_t min_gva,
 		      enum kvm_mem_region_type type)
 {
-	return ____vm_alloc(vm, sz, vaddr_min, type, false);
+	return ____vm_alloc(vm, sz, min_gva, type, false);
 }
 
 /*
  * Allocates at least sz bytes within the virtual address space of the VM
  * given by @vm.  The allocated bytes are mapped to a virtual address >= the
- * address given by @vaddr_min.  Note that each allocation uses a a unique set
+ * address given by @min_gva.  Note that each allocation uses a a unique set
  * of pages, with the minimum real allocation being at least a page. The
  * allocated physical space comes from the TEST_DATA memory region.
  */
-gva_t vm_alloc(struct kvm_vm *vm, size_t sz, gva_t vaddr_min)
+gva_t vm_alloc(struct kvm_vm *vm, size_t sz, gva_t min_gva)
 {
-	return __vm_alloc(vm, sz, vaddr_min, MEM_REGION_TEST_DATA);
+	return __vm_alloc(vm, sz, min_gva, MEM_REGION_TEST_DATA);
 }
 
 gva_t vm_alloc_pages(struct kvm_vm *vm, int nr_pages)
@@ -1503,34 +1503,24 @@ gva_t vm_alloc_page(struct kvm_vm *vm)
 }
 
 /*
- * Map a range of VM virtual address to the VM's physical address
+ * Map a range of VM virtual address to the VM's physical address.
  *
- * Input Args:
- *   vm - Virtual Machine
- *   vaddr - Virtuall address to map
- *   paddr - VM Physical Address
- *   npages - The number of pages to map
- *
- * Output Args: None
- *
- * Return: None
- *
- * Within the VM given by @vm, creates a virtual translation for
- * @npages starting at @vaddr to the page range starting at @paddr.
+ * Within the VM given by @vm, creates a virtual translation for @npages
+ * starting at @gva to the page range starting at @paddr.
  */
-void virt_map(struct kvm_vm *vm, u64 vaddr, u64 paddr,
+void virt_map(struct kvm_vm *vm, gva_t gva, u64 paddr,
 	      unsigned int npages)
 {
 	size_t page_size = vm->page_size;
 	size_t size = npages * page_size;
 
-	TEST_ASSERT(vaddr + size > vaddr, "Vaddr overflow");
+	TEST_ASSERT(gva + size > gva, "Vaddr overflow");
 	TEST_ASSERT(paddr + size > paddr, "Paddr overflow");
 
 	while (npages--) {
-		virt_pg_map(vm, vaddr, paddr);
+		virt_pg_map(vm, gva, paddr);
 
-		vaddr += page_size;
+		gva += page_size;
 		paddr += page_size;
 	}
 }
diff --git a/tools/testing/selftests/kvm/lib/loongarch/processor.c b/tools/testing/selftests/kvm/lib/loongarch/processor.c
index 318520f1f1b9..47e782056196 100644
--- a/tools/testing/selftests/kvm/lib/loongarch/processor.c
+++ b/tools/testing/selftests/kvm/lib/loongarch/processor.c
@@ -111,22 +111,21 @@ gpa_t addr_arch_gva2gpa(struct kvm_vm *vm, gva_t gva)
 	u64 *ptep;
 
 	ptep = virt_populate_pte(vm, gva, 0);
-	TEST_ASSERT(*ptep != 0, "Virtual address vaddr: 0x%lx not mapped\n", gva);
+	TEST_ASSERT(*ptep != 0, "Virtual address gva: 0x%lx not mapped\n", gva);
 
 	return pte_addr(vm, *ptep) + (gva & (vm->page_size - 1));
 }
 
-void virt_arch_pg_map(struct kvm_vm *vm, u64 vaddr, u64 paddr)
+void virt_arch_pg_map(struct kvm_vm *vm, gva_t gva, u64 paddr)
 {
 	u32 prot_bits;
 	u64 *ptep;
 
-	TEST_ASSERT((vaddr % vm->page_size) == 0,
+	TEST_ASSERT((gva % vm->page_size) == 0,
 			"Virtual address not on page boundary,\n"
-			"vaddr: 0x%lx vm->page_size: 0x%x", vaddr, vm->page_size);
-	TEST_ASSERT(sparsebit_is_set(vm->vpages_valid,
-			(vaddr >> vm->page_shift)),
-			"Invalid virtual address, vaddr: 0x%lx", vaddr);
+			"gva: 0x%lx vm->page_size: 0x%x", gva, vm->page_size);
+	TEST_ASSERT(sparsebit_is_set(vm->vpages_valid, (gva >> vm->page_shift)),
+			"Invalid virtual address, gva: 0x%lx", gva);
 	TEST_ASSERT((paddr % vm->page_size) == 0,
 			"Physical address not on page boundary,\n"
 			"paddr: 0x%lx vm->page_size: 0x%x", paddr, vm->page_size);
@@ -135,7 +134,7 @@ void virt_arch_pg_map(struct kvm_vm *vm, u64 vaddr, u64 paddr)
 			"paddr: 0x%lx vm->max_gfn: 0x%lx vm->page_size: 0x%x",
 			paddr, vm->max_gfn, vm->page_size);
 
-	ptep = virt_populate_pte(vm, vaddr, 1);
+	ptep = virt_populate_pte(vm, gva, 1);
 	prot_bits = _PAGE_PRESENT | __READABLE | __WRITEABLE | _CACHE_CC | _PAGE_USER;
 	WRITE_ONCE(*ptep, paddr | prot_bits);
 }
@@ -373,20 +372,20 @@ void loongarch_vcpu_setup(struct kvm_vcpu *vcpu)
 struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, u32 vcpu_id)
 {
 	size_t stack_size;
-	u64 stack_vaddr;
+	u64 stack_gva;
 	struct kvm_regs regs;
 	struct kvm_vcpu *vcpu;
 
 	vcpu = __vm_vcpu_add(vm, vcpu_id);
 	stack_size = vm->page_size;
-	stack_vaddr = __vm_alloc(vm, stack_size,
-				 LOONGARCH_GUEST_STACK_VADDR_MIN, MEM_REGION_DATA);
-	TEST_ASSERT(stack_vaddr != 0,  "No memory for vm stack");
+	stack_gva = __vm_alloc(vm, stack_size,
+			       LOONGARCH_GUEST_STACK_VADDR_MIN, MEM_REGION_DATA);
+	TEST_ASSERT(stack_gva != 0,  "No memory for vm stack");
 
 	loongarch_vcpu_setup(vcpu);
 	/* Setup guest general purpose registers */
 	vcpu_regs_get(vcpu, &regs);
-	regs.gpr[3] = stack_vaddr + stack_size;
+	regs.gpr[3] = stack_gva + stack_size;
 	vcpu_regs_set(vcpu, &regs);
 
 	return vcpu;
diff --git a/tools/testing/selftests/kvm/lib/memstress.c b/tools/testing/selftests/kvm/lib/memstress.c
index b59dc3344ff3..6dcd15910a06 100644
--- a/tools/testing/selftests/kvm/lib/memstress.c
+++ b/tools/testing/selftests/kvm/lib/memstress.c
@@ -49,7 +49,7 @@ void memstress_guest_code(u32 vcpu_idx)
 	struct memstress_args *args = &memstress_args;
 	struct memstress_vcpu_args *vcpu_args = &args->vcpu_args[vcpu_idx];
 	struct guest_random_state rand_state;
-	u64 gva;
+	gva_t gva;
 	u64 pages;
 	u64 addr;
 	u64 page;
diff --git a/tools/testing/selftests/kvm/lib/riscv/processor.c b/tools/testing/selftests/kvm/lib/riscv/processor.c
index 38eb8302922a..108144fb858b 100644
--- a/tools/testing/selftests/kvm/lib/riscv/processor.c
+++ b/tools/testing/selftests/kvm/lib/riscv/processor.c
@@ -75,17 +75,16 @@ void virt_arch_pgd_alloc(struct kvm_vm *vm)
 	vm->mmu.pgd_created = true;
 }
 
-void virt_arch_pg_map(struct kvm_vm *vm, u64 vaddr, u64 paddr)
+void virt_arch_pg_map(struct kvm_vm *vm, gva_t gva, u64 paddr)
 {
 	u64 *ptep, next_ppn;
 	int level = vm->mmu.pgtable_levels - 1;
 
-	TEST_ASSERT((vaddr % vm->page_size) == 0,
+	TEST_ASSERT((gva % vm->page_size) == 0,
 		"Virtual address not on page boundary,\n"
-		"  vaddr: 0x%lx vm->page_size: 0x%x", vaddr, vm->page_size);
-	TEST_ASSERT(sparsebit_is_set(vm->vpages_valid,
-		(vaddr >> vm->page_shift)),
-		"Invalid virtual address, vaddr: 0x%lx", vaddr);
+		"  gva: 0x%lx vm->page_size: 0x%x", gva, vm->page_size);
+	TEST_ASSERT(sparsebit_is_set(vm->vpages_valid, (gva >> vm->page_shift)),
+		    "Invalid virtual address, gva: 0x%lx", gva);
 	TEST_ASSERT((paddr % vm->page_size) == 0,
 		"Physical address not on page boundary,\n"
 		"  paddr: 0x%lx vm->page_size: 0x%x", paddr, vm->page_size);
@@ -94,7 +93,7 @@ void virt_arch_pg_map(struct kvm_vm *vm, u64 vaddr, u64 paddr)
 		"  paddr: 0x%lx vm->max_gfn: 0x%lx vm->page_size: 0x%x",
 		paddr, vm->max_gfn, vm->page_size);
 
-	ptep = addr_gpa2hva(vm, vm->mmu.pgd) + pte_index(vm, vaddr, level) * 8;
+	ptep = addr_gpa2hva(vm, vm->mmu.pgd) + pte_index(vm, gva, level) * 8;
 	if (!*ptep) {
 		next_ppn = vm_alloc_page_table(vm) >> PGTBL_PAGE_SIZE_SHIFT;
 		*ptep = (next_ppn << PGTBL_PTE_ADDR_SHIFT) |
@@ -104,7 +103,7 @@ void virt_arch_pg_map(struct kvm_vm *vm, u64 vaddr, u64 paddr)
 
 	while (level > -1) {
 		ptep = addr_gpa2hva(vm, pte_addr(vm, *ptep)) +
-		       pte_index(vm, vaddr, level) * 8;
+		       pte_index(vm, gva, level) * 8;
 		if (!*ptep && level > 0) {
 			next_ppn = vm_alloc_page_table(vm) >>
 				   PGTBL_PAGE_SIZE_SHIFT;
@@ -315,16 +314,16 @@ struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, u32 vcpu_id)
 {
 	int r;
 	size_t stack_size;
-	unsigned long stack_vaddr;
+	unsigned long stack_gva;
 	unsigned long current_gp = 0;
 	struct kvm_mp_state mps;
 	struct kvm_vcpu *vcpu;
 
 	stack_size = vm->page_size == 4096 ? DEFAULT_STACK_PGS * vm->page_size :
 					     vm->page_size;
-	stack_vaddr = __vm_alloc(vm, stack_size,
-				       DEFAULT_RISCV_GUEST_STACK_VADDR_MIN,
-				       MEM_REGION_DATA);
+	stack_gva = __vm_alloc(vm, stack_size,
+			       DEFAULT_RISCV_GUEST_STACK_VADDR_MIN,
+			       MEM_REGION_DATA);
 
 	vcpu = __vm_vcpu_add(vm, vcpu_id);
 	riscv_vcpu_mmu_setup(vcpu);
@@ -344,7 +343,7 @@ struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, u32 vcpu_id)
 	vcpu_set_reg(vcpu, RISCV_CORE_REG(regs.gp), current_gp);
 
 	/* Setup stack pointer and program counter of guest */
-	vcpu_set_reg(vcpu, RISCV_CORE_REG(regs.sp), stack_vaddr + stack_size);
+	vcpu_set_reg(vcpu, RISCV_CORE_REG(regs.sp), stack_gva + stack_size);
 
 	/* Setup sscratch for guest_get_vcpuid() */
 	vcpu_set_reg(vcpu, RISCV_GENERAL_CSR_REG(sscratch), vcpu_id);
diff --git a/tools/testing/selftests/kvm/lib/s390/processor.c b/tools/testing/selftests/kvm/lib/s390/processor.c
index 4ae0a39f426f..643e583c804c 100644
--- a/tools/testing/selftests/kvm/lib/s390/processor.c
+++ b/tools/testing/selftests/kvm/lib/s390/processor.c
@@ -47,19 +47,17 @@ static u64 virt_alloc_region(struct kvm_vm *vm, int ri)
 		| ((ri < 4 ? (PAGES_PER_REGION - 1) : 0) & REGION_ENTRY_LENGTH);
 }
 
-void virt_arch_pg_map(struct kvm_vm *vm, u64 gva, u64 gpa)
+void virt_arch_pg_map(struct kvm_vm *vm, gva_t gva, u64 gpa)
 {
 	int ri, idx;
 	u64 *entry;
 
 	TEST_ASSERT((gva % vm->page_size) == 0,
-		"Virtual address not on page boundary,\n"
-		"  vaddr: 0x%lx vm->page_size: 0x%x",
-		gva, vm->page_size);
-	TEST_ASSERT(sparsebit_is_set(vm->vpages_valid,
-		(gva >> vm->page_shift)),
-		"Invalid virtual address, vaddr: 0x%lx",
-		gva);
+		    "Virtual address not on page boundary,\n"
+		    "  gva: 0x%lx vm->page_size: 0x%x",
+		    gva, vm->page_size);
+	TEST_ASSERT(sparsebit_is_set(vm->vpages_valid, (gva >> vm->page_shift)),
+		    "Invalid virtual address, gva: 0x%lx", gva);
 	TEST_ASSERT((gpa % vm->page_size) == 0,
 		"Physical address not on page boundary,\n"
 		"  paddr: 0x%lx vm->page_size: 0x%x",
@@ -163,7 +161,7 @@ void vcpu_arch_set_entry_point(struct kvm_vcpu *vcpu, void *guest_code)
 struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, u32 vcpu_id)
 {
 	size_t stack_size =  DEFAULT_STACK_PGS * getpagesize();
-	u64 stack_vaddr;
+	u64 stack_gva;
 	struct kvm_regs regs;
 	struct kvm_sregs sregs;
 	struct kvm_vcpu *vcpu;
@@ -171,15 +169,14 @@ struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, u32 vcpu_id)
 	TEST_ASSERT(vm->page_size == PAGE_SIZE, "Unsupported page size: 0x%x",
 		    vm->page_size);
 
-	stack_vaddr = __vm_alloc(vm, stack_size,
-				       DEFAULT_GUEST_STACK_VADDR_MIN,
-				       MEM_REGION_DATA);
+	stack_gva = __vm_alloc(vm, stack_size, DEFAULT_GUEST_STACK_VADDR_MIN,
+			       MEM_REGION_DATA);
 
 	vcpu = __vm_vcpu_add(vm, vcpu_id);
 
 	/* Setup guest registers */
 	vcpu_regs_get(vcpu, &regs);
-	regs.gprs[15] = stack_vaddr + (DEFAULT_STACK_PGS * getpagesize()) - 160;
+	regs.gprs[15] = stack_gva + (DEFAULT_STACK_PGS * getpagesize()) - 160;
 	vcpu_regs_set(vcpu, &regs);
 
 	vcpu_sregs_get(vcpu, &sregs);
diff --git a/tools/testing/selftests/kvm/lib/ucall_common.c b/tools/testing/selftests/kvm/lib/ucall_common.c
index 4a8a5bc40a45..029ce21f9f2f 100644
--- a/tools/testing/selftests/kvm/lib/ucall_common.c
+++ b/tools/testing/selftests/kvm/lib/ucall_common.c
@@ -29,12 +29,12 @@ void ucall_init(struct kvm_vm *vm, gpa_t mmio_gpa)
 {
 	struct ucall_header *hdr;
 	struct ucall *uc;
-	gva_t vaddr;
+	gva_t gva;
 	int i;
 
-	vaddr = vm_alloc_shared(vm, sizeof(*hdr), KVM_UTIL_MIN_VADDR,
+	gva = vm_alloc_shared(vm, sizeof(*hdr), KVM_UTIL_MIN_VADDR,
 				MEM_REGION_DATA);
-	hdr = (struct ucall_header *)addr_gva2hva(vm, vaddr);
+	hdr = (struct ucall_header *)addr_gva2hva(vm, gva);
 	memset(hdr, 0, sizeof(*hdr));
 
 	for (i = 0; i < KVM_MAX_VCPUS; ++i) {
@@ -42,7 +42,7 @@ void ucall_init(struct kvm_vm *vm, gpa_t mmio_gpa)
 		uc->hva = uc;
 	}
 
-	write_guest_global(vm, ucall_pool, (struct ucall_header *)vaddr);
+	write_guest_global(vm, ucall_pool, (struct ucall_header *)gva);
 
 	ucall_arch_init(vm, mmio_gpa);
 }
diff --git a/tools/testing/selftests/kvm/lib/x86/processor.c b/tools/testing/selftests/kvm/lib/x86/processor.c
index 50848112932c..3c55980c81b2 100644
--- a/tools/testing/selftests/kvm/lib/x86/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86/processor.c
@@ -207,15 +207,15 @@ void tdp_mmu_init(struct kvm_vm *vm, int pgtable_levels,
 }
 
 static void *virt_get_pte(struct kvm_vm *vm, struct kvm_mmu *mmu,
-			  u64 *parent_pte, u64 vaddr, int level)
+			  u64 *parent_pte, gva_t gva, int level)
 {
 	u64 pt_gpa = PTE_GET_PA(*parent_pte);
 	u64 *page_table = addr_gpa2hva(vm, pt_gpa);
-	int index = (vaddr >> PG_LEVEL_SHIFT(level)) & 0x1ffu;
+	int index = (gva >> PG_LEVEL_SHIFT(level)) & 0x1ffu;
 
 	TEST_ASSERT((*parent_pte == mmu->pgd) || is_present_pte(mmu, parent_pte),
 		    "Parent PTE (level %d) not PRESENT for gva: 0x%08lx",
-		    level + 1, vaddr);
+		    level + 1, gva);
 
 	return &page_table[index];
 }
@@ -223,12 +223,12 @@ static void *virt_get_pte(struct kvm_vm *vm, struct kvm_mmu *mmu,
 static u64 *virt_create_upper_pte(struct kvm_vm *vm,
 				  struct kvm_mmu *mmu,
 				  u64 *parent_pte,
-				  u64 vaddr,
+				  gva_t gva,
 				  u64 paddr,
 				  int current_level,
 				  int target_level)
 {
-	u64 *pte = virt_get_pte(vm, mmu, parent_pte, vaddr, current_level);
+	u64 *pte = virt_get_pte(vm, mmu, parent_pte, gva, current_level);
 
 	paddr = vm_untag_gpa(vm, paddr);
 
@@ -247,16 +247,16 @@ static u64 *virt_create_upper_pte(struct kvm_vm *vm,
 		 * this level.
 		 */
 		TEST_ASSERT(current_level != target_level,
-			    "Cannot create hugepage at level: %u, vaddr: 0x%lx",
-			    current_level, vaddr);
+			    "Cannot create hugepage at level: %u, gva: 0x%lx",
+			    current_level, gva);
 		TEST_ASSERT(!is_huge_pte(mmu, pte),
-			    "Cannot create page table at level: %u, vaddr: 0x%lx",
-			    current_level, vaddr);
+			    "Cannot create page table at level: %u, gva: 0x%lx",
+			    current_level, gva);
 	}
 	return pte;
 }
 
-void __virt_pg_map(struct kvm_vm *vm, struct kvm_mmu *mmu, u64 vaddr,
+void __virt_pg_map(struct kvm_vm *vm, struct kvm_mmu *mmu, gva_t gva,
 		   u64 paddr, int level)
 {
 	const u64 pg_size = PG_LEVEL_SIZE(level);
@@ -266,11 +266,11 @@ void __virt_pg_map(struct kvm_vm *vm, struct kvm_mmu *mmu, u64 vaddr,
 	TEST_ASSERT(vm->mode == VM_MODE_PXXVYY_4K,
 		    "Unknown or unsupported guest mode: 0x%x", vm->mode);
 
-	TEST_ASSERT((vaddr % pg_size) == 0,
+	TEST_ASSERT((gva % pg_size) == 0,
 		    "Virtual address not aligned,\n"
-		    "vaddr: 0x%lx page size: 0x%lx", vaddr, pg_size);
-	TEST_ASSERT(sparsebit_is_set(vm->vpages_valid, (vaddr >> vm->page_shift)),
-		    "Invalid virtual address, vaddr: 0x%lx", vaddr);
+		    "gva: 0x%lx page size: 0x%lx", gva, pg_size);
+	TEST_ASSERT(sparsebit_is_set(vm->vpages_valid, (gva >> vm->page_shift)),
+		    "Invalid virtual address, gva: 0x%lx", gva);
 	TEST_ASSERT((paddr % pg_size) == 0,
 		    "Physical address not aligned,\n"
 		    "  paddr: 0x%lx page size: 0x%lx", paddr, pg_size);
@@ -291,16 +291,16 @@ void __virt_pg_map(struct kvm_vm *vm, struct kvm_mmu *mmu, u64 vaddr,
 	for (current_level = mmu->pgtable_levels;
 	     current_level > PG_LEVEL_4K;
 	     current_level--) {
-		pte = virt_create_upper_pte(vm, mmu, pte, vaddr, paddr,
+		pte = virt_create_upper_pte(vm, mmu, pte, gva, paddr,
 					    current_level, level);
 		if (is_huge_pte(mmu, pte))
 			return;
 	}
 
 	/* Fill in page table entry. */
-	pte = virt_get_pte(vm, mmu, pte, vaddr, PG_LEVEL_4K);
+	pte = virt_get_pte(vm, mmu, pte, gva, PG_LEVEL_4K);
 	TEST_ASSERT(!is_present_pte(mmu, pte),
-		    "PTE already present for 4k page at vaddr: 0x%lx", vaddr);
+		    "PTE already present for 4k page at gva: 0x%lx", gva);
 	*pte = PTE_PRESENT_MASK(mmu) | PTE_READABLE_MASK(mmu) |
 	       PTE_WRITABLE_MASK(mmu) | PTE_EXECUTABLE_MASK(mmu) |
 	       PTE_ALWAYS_SET_MASK(mmu) | (paddr & PHYSICAL_PAGE_MASK);
@@ -315,12 +315,12 @@ void __virt_pg_map(struct kvm_vm *vm, struct kvm_mmu *mmu, u64 vaddr,
 		*pte |= PTE_S_BIT_MASK(mmu);
 }
 
-void virt_arch_pg_map(struct kvm_vm *vm, u64 vaddr, u64 paddr)
+void virt_arch_pg_map(struct kvm_vm *vm, gva_t gva, u64 paddr)
 {
-	__virt_pg_map(vm, &vm->mmu, vaddr, paddr, PG_LEVEL_4K);
+	__virt_pg_map(vm, &vm->mmu, gva, paddr, PG_LEVEL_4K);
 }
 
-void virt_map_level(struct kvm_vm *vm, u64 vaddr, u64 paddr,
+void virt_map_level(struct kvm_vm *vm, gva_t gva, u64 paddr,
 		    u64 nr_bytes, int level)
 {
 	u64 pg_size = PG_LEVEL_SIZE(level);
@@ -332,11 +332,11 @@ void virt_map_level(struct kvm_vm *vm, u64 vaddr, u64 paddr,
 		    nr_bytes, pg_size);
 
 	for (i = 0; i < nr_pages; i++) {
-		__virt_pg_map(vm, &vm->mmu, vaddr, paddr, level);
-		sparsebit_set_num(vm->vpages_mapped, vaddr >> vm->page_shift,
+		__virt_pg_map(vm, &vm->mmu, gva, paddr, level);
+		sparsebit_set_num(vm->vpages_mapped, gva >> vm->page_shift,
 				  nr_bytes / PAGE_SIZE);
 
-		vaddr += pg_size;
+		gva += pg_size;
 		paddr += pg_size;
 	}
 }
@@ -356,7 +356,7 @@ static bool vm_is_target_pte(struct kvm_mmu *mmu, u64 *pte,
 
 static u64 *__vm_get_page_table_entry(struct kvm_vm *vm,
 				      struct kvm_mmu *mmu,
-				      u64 vaddr,
+				      gva_t gva,
 				      int *level)
 {
 	int va_width = 12 + (mmu->pgtable_levels) * 9;
@@ -371,26 +371,23 @@ static u64 *__vm_get_page_table_entry(struct kvm_vm *vm,
 
 	TEST_ASSERT(vm->mode == VM_MODE_PXXVYY_4K,
 		    "Unknown or unsupported guest mode: 0x%x", vm->mode);
-	TEST_ASSERT(sparsebit_is_set(vm->vpages_valid,
-		(vaddr >> vm->page_shift)),
-		"Invalid virtual address, vaddr: 0x%lx",
-		vaddr);
+	TEST_ASSERT(sparsebit_is_set(vm->vpages_valid, (gva >> vm->page_shift)),
+		    "Invalid virtual address, gva: 0x%lx", gva);
 	/*
-	 * Check that the vaddr is a sign-extended va_width value.
+	 * Check that the gva is a sign-extended va_width value.
 	 */
-	TEST_ASSERT(vaddr ==
-		    (((s64)vaddr << (64 - va_width) >> (64 - va_width))),
+	TEST_ASSERT(gva == (((s64)gva << (64 - va_width) >> (64 - va_width))),
 		    "Canonical check failed.  The virtual address is invalid.");
 
 	for (current_level = mmu->pgtable_levels;
 	     current_level > PG_LEVEL_4K;
 	     current_level--) {
-		pte = virt_get_pte(vm, mmu, pte, vaddr, current_level);
+		pte = virt_get_pte(vm, mmu, pte, gva, current_level);
 		if (vm_is_target_pte(mmu, pte, level, current_level))
 			return pte;
 	}
 
-	return virt_get_pte(vm, mmu, pte, vaddr, PG_LEVEL_4K);
+	return virt_get_pte(vm, mmu, pte, gva, PG_LEVEL_4K);
 }
 
 u64 *tdp_get_pte(struct kvm_vm *vm, u64 l2_gpa)
@@ -400,11 +397,11 @@ u64 *tdp_get_pte(struct kvm_vm *vm, u64 l2_gpa)
 	return __vm_get_page_table_entry(vm, &vm->stage2_mmu, l2_gpa, &level);
 }
 
-u64 *vm_get_pte(struct kvm_vm *vm, u64 vaddr)
+u64 *vm_get_pte(struct kvm_vm *vm, gva_t gva)
 {
 	int level = PG_LEVEL_4K;
 
-	return __vm_get_page_table_entry(vm, &vm->mmu, vaddr, &level);
+	return __vm_get_page_table_entry(vm, &vm->mmu, gva, &level);
 }
 
 void virt_arch_dump(FILE *stream, struct kvm_vm *vm, u8 indent)
@@ -825,14 +822,13 @@ struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, u32 vcpu_id)
 {
 	struct kvm_mp_state mp_state;
 	struct kvm_regs regs;
-	gva_t stack_vaddr;
+	gva_t stack_gva;
 	struct kvm_vcpu *vcpu;
 
-	stack_vaddr = __vm_alloc(vm, DEFAULT_STACK_PGS * getpagesize(),
-				       DEFAULT_GUEST_STACK_VADDR_MIN,
-				       MEM_REGION_DATA);
+	stack_gva = __vm_alloc(vm, DEFAULT_STACK_PGS * getpagesize(),
+			       DEFAULT_GUEST_STACK_VADDR_MIN, MEM_REGION_DATA);
 
-	stack_vaddr += DEFAULT_STACK_PGS * getpagesize();
+	stack_gva += DEFAULT_STACK_PGS * getpagesize();
 
 	/*
 	 * Align stack to match calling sequence requirements in section "The
@@ -843,9 +839,9 @@ struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, u32 vcpu_id)
 	 * If this code is ever used to launch a vCPU with 32-bit entry point it
 	 * may need to subtract 4 bytes instead of 8 bytes.
 	 */
-	TEST_ASSERT(IS_ALIGNED(stack_vaddr, PAGE_SIZE),
+	TEST_ASSERT(IS_ALIGNED(stack_gva, PAGE_SIZE),
 		    "__vm_alloc() did not provide a page-aligned address");
-	stack_vaddr -= 8;
+	stack_gva -= 8;
 
 	vcpu = __vm_vcpu_add(vm, vcpu_id);
 	vcpu_init_cpuid(vcpu, kvm_get_supported_cpuid());
@@ -855,7 +851,7 @@ struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, u32 vcpu_id)
 	/* Setup guest general purpose registers */
 	vcpu_regs_get(vcpu, &regs);
 	regs.rflags = regs.rflags | 0x2;
-	regs.rsp = stack_vaddr;
+	regs.rsp = stack_gva;
 	vcpu_regs_set(vcpu, &regs);
 
 	/* Setup the MP state */
diff --git a/tools/testing/selftests/kvm/s390/ucontrol_test.c b/tools/testing/selftests/kvm/s390/ucontrol_test.c
index f773ba0f4641..dbdee4c39d47 100644
--- a/tools/testing/selftests/kvm/s390/ucontrol_test.c
+++ b/tools/testing/selftests/kvm/s390/ucontrol_test.c
@@ -571,7 +571,7 @@ TEST_F(uc_kvm, uc_skey)
 {
 	struct kvm_s390_sie_block *sie_block = self->sie_block;
 	struct kvm_sync_regs *sync_regs = &self->run->s.regs;
-	u64 test_vaddr = VM_MEM_SIZE - (SZ_1M / 2);
+	u64 test_gva = VM_MEM_SIZE - (SZ_1M / 2);
 	struct kvm_run *run = self->run;
 	const u8 skeyvalue = 0x34;
 
@@ -583,7 +583,7 @@ TEST_F(uc_kvm, uc_skey)
 	/* set register content for test_skey_asm to access not mapped memory */
 	sync_regs->gprs[1] = skeyvalue;
 	sync_regs->gprs[5] = self->base_gpa;
-	sync_regs->gprs[6] = test_vaddr;
+	sync_regs->gprs[6] = test_gva;
 	run->kvm_dirty_regs |= KVM_SYNC_GPRS;
 
 	/* DAT disabled + 64 bit mode */
diff --git a/tools/testing/selftests/kvm/x86/xapic_ipi_test.c b/tools/testing/selftests/kvm/x86/xapic_ipi_test.c
index d2e2410f748b..39ce9a9369f5 100644
--- a/tools/testing/selftests/kvm/x86/xapic_ipi_test.c
+++ b/tools/testing/selftests/kvm/x86/xapic_ipi_test.c
@@ -393,7 +393,7 @@ int main(int argc, char *argv[])
 	int run_secs = 0;
 	int delay_usecs = 0;
 	struct test_data_page *data;
-	gva_t test_data_page_vaddr;
+	gva_t test_data_page_gva;
 	bool migrate = false;
 	pthread_t threads[2];
 	struct thread_params params[2];
@@ -414,14 +414,14 @@ int main(int argc, char *argv[])
 
 	params[1].vcpu = vm_vcpu_add(vm, 1, sender_guest_code);
 
-	test_data_page_vaddr = vm_alloc_page(vm);
-	data = addr_gva2hva(vm, test_data_page_vaddr);
+	test_data_page_gva = vm_alloc_page(vm);
+	data = addr_gva2hva(vm, test_data_page_gva);
 	memset(data, 0, sizeof(*data));
 	params[0].data = data;
 	params[1].data = data;
 
-	vcpu_args_set(params[0].vcpu, 1, test_data_page_vaddr);
-	vcpu_args_set(params[1].vcpu, 1, test_data_page_vaddr);
+	vcpu_args_set(params[0].vcpu, 1, test_data_page_gva);
+	vcpu_args_set(params[1].vcpu, 1, test_data_page_gva);
 
 	pipis_rcvd = (u64 *)addr_gva2hva(vm, (u64)&ipis_rcvd);
 	params[0].pipis_rcvd = pipis_rcvd;
-- 
2.54.0.rc1.555.g9c883467ad-goog

