Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 142AC3D47B1
	for <kvmarm@lists.linux.dev>; Mon, 20 Apr 2026 21:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776720048; cv=none; b=hsg/RzBbkyywRVkj5HONdsjdEppJnfdCLcxKeI6LGdhifxw/8sPchS2dMcwBCcyQUvck3MbMiZB279A71beV1BGS+qmAFJV4Sl0pfij7lBAdnNIsR9ZWLlB3RW0C/wyMJCBQB2v/cTF4ZwcsdMi5DRY7ZsdjxYLD+sbBYnAhsqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776720048; c=relaxed/simple;
	bh=VqWo+jjO8TKH0MhO2Oc+XZ5Pnj2knUhwJRP63dlwQ8s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fOW+y84+emDFC+FNyhByaf3hSnvflxLNkSbjIYgcEeDYuye5d26QnA22JlTQBYGZYHl0Ld+Y+pOAgePRf3rS0W5WfMrSSSCz26wyF1Fxt0XZ07lACaa+yq7pTD+D/nHWulLI54pYKJTcVWfGp50qPqyId1siteQS722sC03+rHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GNcYvDFj; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GNcYvDFj"
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c7973e22399so1191843a12.0
        for <kvmarm@lists.linux.dev>; Mon, 20 Apr 2026 14:20:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776720044; x=1777324844; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=LVQ/LQLhE4omx5BYLMqaubz6HBWDiRbU4QU9/ukTiik=;
        b=GNcYvDFjv3fDu8owd4Gd2DpBVSS+ZehmxYngDJT3SQyYqO70oC8a4hqacunVOn5K83
         bph1rCc1WVFgJqvbd1OnTEt3iLVYNSgT9xjcMx8duXwHY4rnpT0RZpLEOtbj6QgTP5xJ
         olXkBFBiPtRrsfrXiFlid/P+InTwAU8B0ByZs5fX7oWvfI8DpPLtl4PGPeJNs2tTJq2a
         RX+LWTcp1zAZoKU7KOGV0bqLynCY4tSxA4/H0SQ/xNTVOwo1PlXU5o7JyWQrtnyXC/X1
         Mdmi1sDjhbaRpTINx0EYAS+ucHWdO32rcNCiHEA0pYEQye3po/gCtakXbxhxBM/c2f4c
         r7aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776720044; x=1777324844;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LVQ/LQLhE4omx5BYLMqaubz6HBWDiRbU4QU9/ukTiik=;
        b=pnccJC1UzC4LGTKjfoR0Vl6LxTn1D9TtFlpi/rlj81h6B550iyba/95I76zjg3eiY/
         cO+BvTXeG4ujwrgyDWxFiqtgDukjyoZeQWE8IH3lyc/gCWV/jLxOUe9TNhc7Ig1Mq7kA
         swF9IQb/p6KIqM5nrQIH/7vjUUDh3nA58uqyp53ljrVb3fpR8DFi1Sx3BFDCcIla2z4U
         x7o7ZqB2AVbTBEmNxLQtk6eCUg5JUlBD4ePHoW64Pz9lU1OE0Rh6X/E/KegfvY0D76L+
         eYUKyKyl4NZsTU/DJFYju9paaFTdmYPswSR10CIAZOMQAwCr7MqPFVYJbvSr/b9etJIl
         VM5w==
X-Forwarded-Encrypted: i=1; AFNElJ+s63ECsT672dWz6kZoPmdafltjJvaaQ72uWU4RcysH+ElKS0QtndBGaW0UZRAlJrm4j6ioJoE=@lists.linux.dev
X-Gm-Message-State: AOJu0YynzbjlB7TjikcG2aGydikxFT4K4XdpY147/JcPuwnsmp8F9zLI
	RijqQJJ+uF3GtHhU6CUU6IAAS7xrYzmx+OaLVBywSK9PqRQb2ths1UP9IVRgrBoHmZu6rEqISTb
	gHHIaUw==
X-Received: from pgbcs14.prod.google.com ([2002:a05:6a02:418e:b0:c76:478c:813f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:3288:b0:398:6461:688c
 with SMTP id adf61e73a8af0-3a08d687640mr17010739637.2.1776720044306; Mon, 20
 Apr 2026 14:20:44 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 20 Apr 2026 14:20:04 -0700
In-Reply-To: <20260420212004.3938325-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260420212004.3938325-1-seanjc@google.com>
X-Mailer: git-send-email 2.54.0.rc1.555.g9c883467ad-goog
Message-ID: <20260420212004.3938325-20-seanjc@google.com>
Subject: [PATCH v3 19/19] KVM: selftests: Replace "paddr" with "gpa" throughout
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

Replace all variations of "paddr" variables in KVM selftests with "gpa",
with the exception of the ELF structures, as those fields are not specific
to guest virtual addresses, to complete the conversion from vm_paddr_t to
gpa_t.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../testing/selftests/kvm/arm64/sea_to_user.c |  2 +-
 .../testing/selftests/kvm/include/kvm_util.h  | 23 ++++----
 .../selftests/kvm/include/x86/processor.h     |  6 +--
 .../selftests/kvm/lib/arm64/processor.c       | 22 ++++----
 tools/testing/selftests/kvm/lib/kvm_util.c    | 53 +++++++++----------
 .../selftests/kvm/lib/loongarch/processor.c   | 14 ++---
 .../selftests/kvm/lib/riscv/processor.c       | 16 +++---
 .../selftests/kvm/lib/s390/processor.c        | 12 ++---
 .../testing/selftests/kvm/lib/x86/processor.c | 50 ++++++++---------
 9 files changed, 98 insertions(+), 100 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/sea_to_user.c b/tools/testing/selftests/kvm/arm64/sea_to_user.c
index e16034852470..e96d8982c28b 100644
--- a/tools/testing/selftests/kvm/arm64/sea_to_user.c
+++ b/tools/testing/selftests/kvm/arm64/sea_to_user.c
@@ -275,7 +275,7 @@ static struct kvm_vm *vm_create_with_sea_handler(struct kvm_vcpu **vcpu)
 	vm_userspace_mem_region_add(
 		/*vm=*/vm,
 		/*src_type=*/src_type,
-		/*guest_paddr=*/start_gpa,
+		/*gpa=*/start_gpa,
 		/*slot=*/1,
 		/*npages=*/num_guest_pages,
 		/*flags=*/0);
diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 0d9f11be9806..2ecaaa0e9965 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -725,7 +725,7 @@ gva_t vm_alloc_pages(struct kvm_vm *vm, int nr_pages);
 gva_t __vm_alloc_page(struct kvm_vm *vm, enum kvm_mem_region_type type);
 gva_t vm_alloc_page(struct kvm_vm *vm);
 
-void virt_map(struct kvm_vm *vm, gva_t gva, u64 paddr,
+void virt_map(struct kvm_vm *vm, gva_t gva, gpa_t gpa,
 	      unsigned int npages);
 void *addr_gpa2hva(struct kvm_vm *vm, gpa_t gpa);
 void *addr_gva2hva(struct kvm_vm *vm, gva_t gva);
@@ -990,21 +990,20 @@ void kvm_gsi_routing_write(struct kvm_vm *vm, struct kvm_irq_routing *routing);
 
 const char *exit_reason_str(unsigned int exit_reason);
 
-gpa_t vm_phy_page_alloc(struct kvm_vm *vm, gpa_t paddr_min, u32 memslot);
-gpa_t __vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
-			   gpa_t paddr_min, u32 memslot,
-			   bool protected);
+gpa_t vm_phy_page_alloc(struct kvm_vm *vm, gpa_t min_gpa, u32 memslot);
+gpa_t __vm_phy_pages_alloc(struct kvm_vm *vm, size_t num, gpa_t min_gpa,
+			   u32 memslot, bool protected);
 gpa_t vm_alloc_page_table(struct kvm_vm *vm);
 
 static inline gpa_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
-				       gpa_t paddr_min, u32 memslot)
+				       gpa_t min_gpa, u32 memslot)
 {
 	/*
 	 * By default, allocate memory as protected for VMs that support
 	 * protected memory, as the majority of memory for such VMs is
 	 * protected, i.e. using shared memory is effectively opt-in.
 	 */
-	return __vm_phy_pages_alloc(vm, num, paddr_min, memslot,
+	return __vm_phy_pages_alloc(vm, num, min_gpa, memslot,
 				    vm_arch_has_protected_memory(vm));
 }
 
@@ -1203,13 +1202,13 @@ static inline void virt_pgd_alloc(struct kvm_vm *vm)
 
 /*
  * Within @vm, creates a virtual translation for the page starting
- * at @gva to the page starting at @paddr.
+ * at @gva to the page starting at @gpa.
  */
-void virt_arch_pg_map(struct kvm_vm *vm, gva_t gva, u64 paddr);
+void virt_arch_pg_map(struct kvm_vm *vm, gva_t gva, gpa_t gpa);
 
-static inline void virt_pg_map(struct kvm_vm *vm, gva_t gva, u64 paddr)
+static inline void virt_pg_map(struct kvm_vm *vm, gva_t gva, gpa_t gpa)
 {
-	virt_arch_pg_map(vm, gva, paddr);
+	virt_arch_pg_map(vm, gva, gpa);
 	sparsebit_set(vm->vpages_mapped, gva >> vm->page_shift);
 }
 
@@ -1280,7 +1279,7 @@ void kvm_arch_vm_post_create(struct kvm_vm *vm, unsigned int nr_vcpus);
 void kvm_arch_vm_finalize_vcpus(struct kvm_vm *vm);
 void kvm_arch_vm_release(struct kvm_vm *vm);
 
-bool vm_is_gpa_protected(struct kvm_vm *vm, gpa_t paddr);
+bool vm_is_gpa_protected(struct kvm_vm *vm, gpa_t gpa);
 
 u32 guest_get_vcpuid(void);
 
diff --git a/tools/testing/selftests/kvm/include/x86/processor.h b/tools/testing/selftests/kvm/include/x86/processor.h
index 97dc887658c3..77f576ee7789 100644
--- a/tools/testing/selftests/kvm/include/x86/processor.h
+++ b/tools/testing/selftests/kvm/include/x86/processor.h
@@ -1508,13 +1508,13 @@ void tdp_mmu_init(struct kvm_vm *vm, int pgtable_levels,
 		  struct pte_masks *pte_masks);
 
 void __virt_pg_map(struct kvm_vm *vm, struct kvm_mmu *mmu, gva_t gva,
-		   u64 paddr,  int level);
-void virt_map_level(struct kvm_vm *vm, gva_t gva, u64 paddr,
+		   gpa_t gpa,  int level);
+void virt_map_level(struct kvm_vm *vm, gva_t gva, gpa_t gpa,
 		    u64 nr_bytes, int level);
 
 void vm_enable_tdp(struct kvm_vm *vm);
 bool kvm_cpu_has_tdp(void);
-void tdp_map(struct kvm_vm *vm, gpa_t l2_gpa, u64 paddr, u64 size);
+void tdp_map(struct kvm_vm *vm, gpa_t l2_gpa, gpa_t gpa, u64 size);
 void tdp_identity_map_default_memslots(struct kvm_vm *vm);
 void tdp_identity_map_1g(struct kvm_vm *vm,  u64 addr, u64 size);
 u64 *tdp_get_pte(struct kvm_vm *vm, u64 l2_gpa);
diff --git a/tools/testing/selftests/kvm/lib/arm64/processor.c b/tools/testing/selftests/kvm/lib/arm64/processor.c
index 0f693d8891d2..01325bf4d36f 100644
--- a/tools/testing/selftests/kvm/lib/arm64/processor.c
+++ b/tools/testing/selftests/kvm/lib/arm64/processor.c
@@ -121,7 +121,7 @@ void virt_arch_pgd_alloc(struct kvm_vm *vm)
 	vm->mmu.pgd_created = true;
 }
 
-static void _virt_pg_map(struct kvm_vm *vm, gva_t gva, u64 paddr,
+static void _virt_pg_map(struct kvm_vm *vm, gva_t gva, gpa_t gpa,
 			 u64 flags)
 {
 	u8 attr_idx = flags & (PTE_ATTRINDX_MASK >> PTE_ATTRINDX_SHIFT);
@@ -133,13 +133,13 @@ static void _virt_pg_map(struct kvm_vm *vm, gva_t gva, u64 paddr,
 		"  gva: 0x%lx vm->page_size: 0x%x", gva, vm->page_size);
 	TEST_ASSERT(sparsebit_is_set(vm->vpages_valid, (gva >> vm->page_shift)),
 		    "Invalid virtual address, gva: 0x%lx", gva);
-	TEST_ASSERT((paddr % vm->page_size) == 0,
-		"Physical address not on page boundary,\n"
-		"  paddr: 0x%lx vm->page_size: 0x%x", paddr, vm->page_size);
-	TEST_ASSERT((paddr >> vm->page_shift) <= vm->max_gfn,
-		"Physical address beyond beyond maximum supported,\n"
-		"  paddr: 0x%lx vm->max_gfn: 0x%lx vm->page_size: 0x%x",
-		paddr, vm->max_gfn, vm->page_size);
+	TEST_ASSERT((gpa % vm->page_size) == 0,
+		    "Physical address not on page boundary,\n"
+		    "  gpa: 0x%lx vm->page_size: 0x%x", gpa, vm->page_size);
+	TEST_ASSERT((gpa >> vm->page_shift) <= vm->max_gfn,
+		    "Physical address beyond beyond maximum supported,\n"
+		    "  gpa: 0x%lx vm->max_gfn: 0x%lx vm->page_size: 0x%x",
+		    gpa, vm->max_gfn, vm->page_size);
 
 	ptep = addr_gpa2hva(vm, vm->mmu.pgd) + pgd_index(vm, gva) * 8;
 	if (!*ptep)
@@ -170,14 +170,14 @@ static void _virt_pg_map(struct kvm_vm *vm, gva_t gva, u64 paddr,
 	if (!use_lpa2_pte_format(vm))
 		pg_attr |= PTE_SHARED;
 
-	*ptep = addr_pte(vm, paddr, pg_attr);
+	*ptep = addr_pte(vm, gpa, pg_attr);
 }
 
-void virt_arch_pg_map(struct kvm_vm *vm, gva_t gva, u64 paddr)
+void virt_arch_pg_map(struct kvm_vm *vm, gva_t gva, gpa_t gpa)
 {
 	u64 attr_idx = MT_NORMAL;
 
-	_virt_pg_map(vm, gva, paddr, attr_idx);
+	_virt_pg_map(vm, gva, gpa, attr_idx);
 }
 
 u64 *virt_get_pte_hva_at_level(struct kvm_vm *vm, gva_t gva, int level)
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 905fa214099d..2a76eca7029d 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1027,8 +1027,8 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
 
 		TEST_FAIL("A mem region with the requested slot "
 			"already exists.\n"
-			"  requested slot: %u paddr: 0x%lx npages: 0x%lx\n"
-			"  existing slot: %u paddr: 0x%lx size: 0x%lx",
+			"  requested slot: %u gpa: 0x%lx npages: 0x%lx\n"
+			"  existing slot: %u gpa: 0x%lx size: 0x%lx",
 			slot, gpa, npages, region->region.slot,
 			(u64)region->region.guest_phys_addr,
 			(u64)region->region.memory_size);
@@ -1442,7 +1442,7 @@ static gva_t ____vm_alloc(struct kvm_vm *vm, size_t sz, gva_t min_gva,
 	u64 pages = (sz >> vm->page_shift) + ((sz % vm->page_size) != 0);
 
 	virt_pgd_alloc(vm);
-	gpa_t paddr = __vm_phy_pages_alloc(vm, pages,
+	gpa_t gpa = __vm_phy_pages_alloc(vm, pages,
 					   KVM_UTIL_MIN_PFN * vm->page_size,
 					   vm->memslots[type], protected);
 
@@ -1454,9 +1454,9 @@ static gva_t ____vm_alloc(struct kvm_vm *vm, size_t sz, gva_t min_gva,
 
 	/* Map the virtual pages. */
 	for (gva_t gva = gva_start; pages > 0;
-		pages--, gva += vm->page_size, paddr += vm->page_size) {
+		pages--, gva += vm->page_size, gpa += vm->page_size) {
 
-		virt_pg_map(vm, gva, paddr);
+		virt_pg_map(vm, gva, gpa);
 	}
 
 	return gva_start;
@@ -1506,22 +1506,21 @@ gva_t vm_alloc_page(struct kvm_vm *vm)
  * Map a range of VM virtual address to the VM's physical address.
  *
  * Within the VM given by @vm, creates a virtual translation for @npages
- * starting at @gva to the page range starting at @paddr.
+ * starting at @gva to the page range starting at @gpa.
  */
-void virt_map(struct kvm_vm *vm, gva_t gva, u64 paddr,
-	      unsigned int npages)
+void virt_map(struct kvm_vm *vm, gva_t gva, gpa_t gpa, unsigned int npages)
 {
 	size_t page_size = vm->page_size;
 	size_t size = npages * page_size;
 
 	TEST_ASSERT(gva + size > gva, "Vaddr overflow");
-	TEST_ASSERT(paddr + size > paddr, "Paddr overflow");
+	TEST_ASSERT(gpa + size > gpa, "Paddr overflow");
 
 	while (npages--) {
-		virt_pg_map(vm, gva, paddr);
+		virt_pg_map(vm, gva, gpa);
 
 		gva += page_size;
-		paddr += page_size;
+		gpa += page_size;
 	}
 }
 
@@ -2008,7 +2007,7 @@ const char *exit_reason_str(unsigned int exit_reason)
  * Input Args:
  *   vm - Virtual Machine
  *   num - number of pages
- *   paddr_min - Physical address minimum
+ *   min_gpa - Physical address minimum
  *   memslot - Memory region to allocate page from
  *   protected - True if the pages will be used as protected/private memory
  *
@@ -2018,12 +2017,12 @@ const char *exit_reason_str(unsigned int exit_reason)
  *   Starting physical address
  *
  * Within the VM specified by vm, locates a range of available physical
- * pages at or above paddr_min. If found, the pages are marked as in use
+ * pages at or above min_gpa. If found, the pages are marked as in use
  * and their base address is returned. A TEST_ASSERT failure occurs if
- * not enough pages are available at or above paddr_min.
+ * not enough pages are available at or above min_gpa.
  */
 gpa_t __vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
-			   gpa_t paddr_min, u32 memslot,
+			   gpa_t min_gpa, u32 memslot,
 			   bool protected)
 {
 	struct userspace_mem_region *region;
@@ -2031,16 +2030,16 @@ gpa_t __vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
 
 	TEST_ASSERT(num > 0, "Must allocate at least one page");
 
-	TEST_ASSERT((paddr_min % vm->page_size) == 0, "Min physical address "
+	TEST_ASSERT((min_gpa % vm->page_size) == 0, "Min physical address "
 		"not divisible by page size.\n"
-		"  paddr_min: 0x%lx page_size: 0x%x",
-		paddr_min, vm->page_size);
+		"  min_gpa: 0x%lx page_size: 0x%x",
+		min_gpa, vm->page_size);
 
 	region = memslot2region(vm, memslot);
 	TEST_ASSERT(!protected || region->protected_phy_pages,
 		    "Region doesn't support protected memory");
 
-	base = pg = paddr_min >> vm->page_shift;
+	base = pg = min_gpa >> vm->page_shift;
 	do {
 		for (; pg < base + num; ++pg) {
 			if (!sparsebit_is_set(region->unused_phy_pages, pg)) {
@@ -2052,8 +2051,8 @@ gpa_t __vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
 
 	if (pg == 0) {
 		fprintf(stderr, "No guest physical page available, "
-			"paddr_min: 0x%lx page_size: 0x%x memslot: %u\n",
-			paddr_min, vm->page_size, memslot);
+			"min_gpa: 0x%lx page_size: 0x%x memslot: %u\n",
+			min_gpa, vm->page_size, memslot);
 		fputs("---- vm dump ----\n", stderr);
 		vm_dump(stderr, vm, 2);
 		abort();
@@ -2068,9 +2067,9 @@ gpa_t __vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
 	return base * vm->page_size;
 }
 
-gpa_t vm_phy_page_alloc(struct kvm_vm *vm, gpa_t paddr_min, u32 memslot)
+gpa_t vm_phy_page_alloc(struct kvm_vm *vm, gpa_t min_gpa, u32 memslot)
 {
-	return vm_phy_pages_alloc(vm, 1, paddr_min, memslot);
+	return vm_phy_pages_alloc(vm, 1, min_gpa, memslot);
 }
 
 gpa_t vm_alloc_page_table(struct kvm_vm *vm)
@@ -2287,7 +2286,7 @@ void __attribute((constructor)) kvm_selftest_init(void)
 	kvm_selftest_arch_init();
 }
 
-bool vm_is_gpa_protected(struct kvm_vm *vm, gpa_t paddr)
+bool vm_is_gpa_protected(struct kvm_vm *vm, gpa_t gpa)
 {
 	sparsebit_idx_t pg = 0;
 	struct userspace_mem_region *region;
@@ -2295,10 +2294,10 @@ bool vm_is_gpa_protected(struct kvm_vm *vm, gpa_t paddr)
 	if (!vm_arch_has_protected_memory(vm))
 		return false;
 
-	region = userspace_mem_region_find(vm, paddr, paddr);
-	TEST_ASSERT(region, "No vm physical memory at 0x%lx", paddr);
+	region = userspace_mem_region_find(vm, gpa, gpa);
+	TEST_ASSERT(region, "No vm physical memory at 0x%lx", gpa);
 
-	pg = paddr >> vm->page_shift;
+	pg = gpa >> vm->page_shift;
 	return sparsebit_is_set(region->protected_phy_pages, pg);
 }
 
diff --git a/tools/testing/selftests/kvm/lib/loongarch/processor.c b/tools/testing/selftests/kvm/lib/loongarch/processor.c
index 47e782056196..64d91fb76522 100644
--- a/tools/testing/selftests/kvm/lib/loongarch/processor.c
+++ b/tools/testing/selftests/kvm/lib/loongarch/processor.c
@@ -116,7 +116,7 @@ gpa_t addr_arch_gva2gpa(struct kvm_vm *vm, gva_t gva)
 	return pte_addr(vm, *ptep) + (gva & (vm->page_size - 1));
 }
 
-void virt_arch_pg_map(struct kvm_vm *vm, gva_t gva, u64 paddr)
+void virt_arch_pg_map(struct kvm_vm *vm, gva_t gva, gpa_t gpa)
 {
 	u32 prot_bits;
 	u64 *ptep;
@@ -126,17 +126,17 @@ void virt_arch_pg_map(struct kvm_vm *vm, gva_t gva, u64 paddr)
 			"gva: 0x%lx vm->page_size: 0x%x", gva, vm->page_size);
 	TEST_ASSERT(sparsebit_is_set(vm->vpages_valid, (gva >> vm->page_shift)),
 			"Invalid virtual address, gva: 0x%lx", gva);
-	TEST_ASSERT((paddr % vm->page_size) == 0,
+	TEST_ASSERT((gpa % vm->page_size) == 0,
 			"Physical address not on page boundary,\n"
-			"paddr: 0x%lx vm->page_size: 0x%x", paddr, vm->page_size);
-	TEST_ASSERT((paddr >> vm->page_shift) <= vm->max_gfn,
+			"gpa: 0x%lx vm->page_size: 0x%x", gpa, vm->page_size);
+	TEST_ASSERT((gpa >> vm->page_shift) <= vm->max_gfn,
 			"Physical address beyond maximum supported,\n"
-			"paddr: 0x%lx vm->max_gfn: 0x%lx vm->page_size: 0x%x",
-			paddr, vm->max_gfn, vm->page_size);
+			"gpa: 0x%lx vm->max_gfn: 0x%lx vm->page_size: 0x%x",
+			gpa, vm->max_gfn, vm->page_size);
 
 	ptep = virt_populate_pte(vm, gva, 1);
 	prot_bits = _PAGE_PRESENT | __READABLE | __WRITEABLE | _CACHE_CC | _PAGE_USER;
-	WRITE_ONCE(*ptep, paddr | prot_bits);
+	WRITE_ONCE(*ptep, gpa | prot_bits);
 }
 
 static void pte_dump(FILE *stream, struct kvm_vm *vm, u8 indent, u64 page, int level)
diff --git a/tools/testing/selftests/kvm/lib/riscv/processor.c b/tools/testing/selftests/kvm/lib/riscv/processor.c
index 108144fb858b..ded5429f3448 100644
--- a/tools/testing/selftests/kvm/lib/riscv/processor.c
+++ b/tools/testing/selftests/kvm/lib/riscv/processor.c
@@ -75,7 +75,7 @@ void virt_arch_pgd_alloc(struct kvm_vm *vm)
 	vm->mmu.pgd_created = true;
 }
 
-void virt_arch_pg_map(struct kvm_vm *vm, gva_t gva, u64 paddr)
+void virt_arch_pg_map(struct kvm_vm *vm, gva_t gva, gpa_t gpa)
 {
 	u64 *ptep, next_ppn;
 	int level = vm->mmu.pgtable_levels - 1;
@@ -85,13 +85,13 @@ void virt_arch_pg_map(struct kvm_vm *vm, gva_t gva, u64 paddr)
 		"  gva: 0x%lx vm->page_size: 0x%x", gva, vm->page_size);
 	TEST_ASSERT(sparsebit_is_set(vm->vpages_valid, (gva >> vm->page_shift)),
 		    "Invalid virtual address, gva: 0x%lx", gva);
-	TEST_ASSERT((paddr % vm->page_size) == 0,
+	TEST_ASSERT((gpa % vm->page_size) == 0,
 		"Physical address not on page boundary,\n"
-		"  paddr: 0x%lx vm->page_size: 0x%x", paddr, vm->page_size);
-	TEST_ASSERT((paddr >> vm->page_shift) <= vm->max_gfn,
+		"  gpa: 0x%lx vm->page_size: 0x%x", gpa, vm->page_size);
+	TEST_ASSERT((gpa >> vm->page_shift) <= vm->max_gfn,
 		"Physical address beyond maximum supported,\n"
-		"  paddr: 0x%lx vm->max_gfn: 0x%lx vm->page_size: 0x%x",
-		paddr, vm->max_gfn, vm->page_size);
+		"  gpa: 0x%lx vm->max_gfn: 0x%lx vm->page_size: 0x%x",
+		gpa, vm->max_gfn, vm->page_size);
 
 	ptep = addr_gpa2hva(vm, vm->mmu.pgd) + pte_index(vm, gva, level) * 8;
 	if (!*ptep) {
@@ -113,8 +113,8 @@ void virt_arch_pg_map(struct kvm_vm *vm, gva_t gva, u64 paddr)
 		level--;
 	}
 
-	paddr = paddr >> PGTBL_PAGE_SIZE_SHIFT;
-	*ptep = (paddr << PGTBL_PTE_ADDR_SHIFT) |
+	gpa = gpa >> PGTBL_PAGE_SIZE_SHIFT;
+	*ptep = (gpa << PGTBL_PTE_ADDR_SHIFT) |
 		PGTBL_PTE_PERM_MASK | PGTBL_PTE_VALID_MASK;
 }
 
diff --git a/tools/testing/selftests/kvm/lib/s390/processor.c b/tools/testing/selftests/kvm/lib/s390/processor.c
index 77a7b6965812..a9adb3782b35 100644
--- a/tools/testing/selftests/kvm/lib/s390/processor.c
+++ b/tools/testing/selftests/kvm/lib/s390/processor.c
@@ -12,7 +12,7 @@
 
 void virt_arch_pgd_alloc(struct kvm_vm *vm)
 {
-	gpa_t paddr;
+	gpa_t gpa;
 
 	TEST_ASSERT(vm->page_size == PAGE_SIZE, "Unsupported page size: 0x%x",
 		    vm->page_size);
@@ -20,12 +20,12 @@ void virt_arch_pgd_alloc(struct kvm_vm *vm)
 	if (vm->mmu.pgd_created)
 		return;
 
-	paddr = vm_phy_pages_alloc(vm, PAGES_PER_REGION,
+	gpa = vm_phy_pages_alloc(vm, PAGES_PER_REGION,
 				   KVM_GUEST_PAGE_TABLE_MIN_PADDR,
 				   vm->memslots[MEM_REGION_PT]);
-	memset(addr_gpa2hva(vm, paddr), 0xff, PAGES_PER_REGION * vm->page_size);
+	memset(addr_gpa2hva(vm, gpa), 0xff, PAGES_PER_REGION * vm->page_size);
 
-	vm->mmu.pgd = paddr;
+	vm->mmu.pgd = gpa;
 	vm->mmu.pgd_created = true;
 }
 
@@ -60,11 +60,11 @@ void virt_arch_pg_map(struct kvm_vm *vm, gva_t gva, gpa_t gpa)
 		    "Invalid virtual address, gva: 0x%lx", gva);
 	TEST_ASSERT((gpa % vm->page_size) == 0,
 		"Physical address not on page boundary,\n"
-		"  paddr: 0x%lx vm->page_size: 0x%x",
+		"  gpa: 0x%lx vm->page_size: 0x%x",
 		gva, vm->page_size);
 	TEST_ASSERT((gpa >> vm->page_shift) <= vm->max_gfn,
 		"Physical address beyond beyond maximum supported,\n"
-		"  paddr: 0x%lx vm->max_gfn: 0x%lx vm->page_size: 0x%x",
+		"  gpa: 0x%lx vm->max_gfn: 0x%lx vm->page_size: 0x%x",
 		gva, vm->max_gfn, vm->page_size);
 
 	/* Walk through region and segment tables */
diff --git a/tools/testing/selftests/kvm/lib/x86/processor.c b/tools/testing/selftests/kvm/lib/x86/processor.c
index 892cc517d9f1..b51467d70f6e 100644
--- a/tools/testing/selftests/kvm/lib/x86/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86/processor.c
@@ -224,20 +224,20 @@ static u64 *virt_create_upper_pte(struct kvm_vm *vm,
 				  struct kvm_mmu *mmu,
 				  u64 *parent_pte,
 				  gva_t gva,
-				  u64 paddr,
+				  gpa_t gpa,
 				  int current_level,
 				  int target_level)
 {
 	u64 *pte = virt_get_pte(vm, mmu, parent_pte, gva, current_level);
 
-	paddr = vm_untag_gpa(vm, paddr);
+	gpa = vm_untag_gpa(vm, gpa);
 
 	if (!is_present_pte(mmu, pte)) {
 		*pte = PTE_PRESENT_MASK(mmu) | PTE_READABLE_MASK(mmu) |
 		       PTE_WRITABLE_MASK(mmu) | PTE_EXECUTABLE_MASK(mmu) |
 		       PTE_ALWAYS_SET_MASK(mmu);
 		if (current_level == target_level)
-			*pte |= PTE_HUGE_MASK(mmu) | (paddr & PHYSICAL_PAGE_MASK);
+			*pte |= PTE_HUGE_MASK(mmu) | (gpa & PHYSICAL_PAGE_MASK);
 		else
 			*pte |= vm_alloc_page_table(vm) & PHYSICAL_PAGE_MASK;
 	} else {
@@ -257,7 +257,7 @@ static u64 *virt_create_upper_pte(struct kvm_vm *vm,
 }
 
 void __virt_pg_map(struct kvm_vm *vm, struct kvm_mmu *mmu, gva_t gva,
-		   u64 paddr, int level)
+		   gpa_t gpa, int level)
 {
 	const u64 pg_size = PG_LEVEL_SIZE(level);
 	u64 *pte = &mmu->pgd;
@@ -271,15 +271,15 @@ void __virt_pg_map(struct kvm_vm *vm, struct kvm_mmu *mmu, gva_t gva,
 		    "gva: 0x%lx page size: 0x%lx", gva, pg_size);
 	TEST_ASSERT(sparsebit_is_set(vm->vpages_valid, (gva >> vm->page_shift)),
 		    "Invalid virtual address, gva: 0x%lx", gva);
-	TEST_ASSERT((paddr % pg_size) == 0,
+	TEST_ASSERT((gpa % pg_size) == 0,
 		    "Physical address not aligned,\n"
-		    "  paddr: 0x%lx page size: 0x%lx", paddr, pg_size);
-	TEST_ASSERT((paddr >> vm->page_shift) <= vm->max_gfn,
+		    "  gpa: 0x%lx page size: 0x%lx", gpa, pg_size);
+	TEST_ASSERT((gpa >> vm->page_shift) <= vm->max_gfn,
 		    "Physical address beyond maximum supported,\n"
-		    "  paddr: 0x%lx vm->max_gfn: 0x%lx vm->page_size: 0x%x",
-		    paddr, vm->max_gfn, vm->page_size);
-	TEST_ASSERT(vm_untag_gpa(vm, paddr) == paddr,
-		    "Unexpected bits in paddr: %lx", paddr);
+		    "  gpa: 0x%lx vm->max_gfn: 0x%lx vm->page_size: 0x%x",
+		    gpa, vm->max_gfn, vm->page_size);
+	TEST_ASSERT(vm_untag_gpa(vm, gpa) == gpa,
+		    "Unexpected bits in gpa: %lx", gpa);
 
 	TEST_ASSERT(!PTE_EXECUTABLE_MASK(mmu) || !PTE_NX_MASK(mmu),
 		    "X and NX bit masks cannot be used simultaneously");
@@ -291,7 +291,7 @@ void __virt_pg_map(struct kvm_vm *vm, struct kvm_mmu *mmu, gva_t gva,
 	for (current_level = mmu->pgtable_levels;
 	     current_level > PG_LEVEL_4K;
 	     current_level--) {
-		pte = virt_create_upper_pte(vm, mmu, pte, gva, paddr,
+		pte = virt_create_upper_pte(vm, mmu, pte, gva, gpa,
 					    current_level, level);
 		if (is_huge_pte(mmu, pte))
 			return;
@@ -303,24 +303,24 @@ void __virt_pg_map(struct kvm_vm *vm, struct kvm_mmu *mmu, gva_t gva,
 		    "PTE already present for 4k page at gva: 0x%lx", gva);
 	*pte = PTE_PRESENT_MASK(mmu) | PTE_READABLE_MASK(mmu) |
 	       PTE_WRITABLE_MASK(mmu) | PTE_EXECUTABLE_MASK(mmu) |
-	       PTE_ALWAYS_SET_MASK(mmu) | (paddr & PHYSICAL_PAGE_MASK);
+	       PTE_ALWAYS_SET_MASK(mmu) | (gpa & PHYSICAL_PAGE_MASK);
 
 	/*
 	 * Neither SEV nor TDX supports shared page tables, so only the final
 	 * leaf PTE needs manually set the C/S-bit.
 	 */
-	if (vm_is_gpa_protected(vm, paddr))
+	if (vm_is_gpa_protected(vm, gpa))
 		*pte |= PTE_C_BIT_MASK(mmu);
 	else
 		*pte |= PTE_S_BIT_MASK(mmu);
 }
 
-void virt_arch_pg_map(struct kvm_vm *vm, gva_t gva, u64 paddr)
+void virt_arch_pg_map(struct kvm_vm *vm, gva_t gva, gpa_t gpa)
 {
-	__virt_pg_map(vm, &vm->mmu, gva, paddr, PG_LEVEL_4K);
+	__virt_pg_map(vm, &vm->mmu, gva, gpa, PG_LEVEL_4K);
 }
 
-void virt_map_level(struct kvm_vm *vm, gva_t gva, u64 paddr,
+void virt_map_level(struct kvm_vm *vm, gva_t gva, gpa_t gpa,
 		    u64 nr_bytes, int level)
 {
 	u64 pg_size = PG_LEVEL_SIZE(level);
@@ -332,12 +332,12 @@ void virt_map_level(struct kvm_vm *vm, gva_t gva, u64 paddr,
 		    nr_bytes, pg_size);
 
 	for (i = 0; i < nr_pages; i++) {
-		__virt_pg_map(vm, &vm->mmu, gva, paddr, level);
+		__virt_pg_map(vm, &vm->mmu, gva, gpa, level);
 		sparsebit_set_num(vm->vpages_mapped, gva >> vm->page_shift,
 				  nr_bytes / PAGE_SIZE);
 
 		gva += pg_size;
-		paddr += pg_size;
+		gpa += pg_size;
 	}
 }
 
@@ -495,24 +495,24 @@ bool kvm_cpu_has_tdp(void)
 	return kvm_cpu_has_ept() || kvm_cpu_has_npt();
 }
 
-void __tdp_map(struct kvm_vm *vm, gpa_t l2_gpa, u64 paddr, u64 size, int level)
+void __tdp_map(struct kvm_vm *vm, gpa_t l2_gpa, gpa_t gpa, u64 size, int level)
 {
 	size_t page_size = PG_LEVEL_SIZE(level);
 	size_t npages = size / page_size;
 
 	TEST_ASSERT(l2_gpa + size > l2_gpa, "L2 GPA overflow");
-	TEST_ASSERT(paddr + size > paddr, "Paddr overflow");
+	TEST_ASSERT(gpa + size > gpa, "GPA overflow");
 
 	while (npages--) {
-		__virt_pg_map(vm, &vm->stage2_mmu, l2_gpa, paddr, level);
+		__virt_pg_map(vm, &vm->stage2_mmu, l2_gpa, gpa, level);
 		l2_gpa += page_size;
-		paddr += page_size;
+		gpa += page_size;
 	}
 }
 
-void tdp_map(struct kvm_vm *vm, gpa_t l2_gpa, u64 paddr, u64 size)
+void tdp_map(struct kvm_vm *vm, gpa_t l2_gpa, gpa_t gpa, u64 size)
 {
-	__tdp_map(vm, l2_gpa, paddr, size, PG_LEVEL_4K);
+	__tdp_map(vm, l2_gpa, gpa, size, PG_LEVEL_4K);
 }
 
 /* Prepare an identity extended page table that maps all the
-- 
2.54.0.rc1.555.g9c883467ad-goog

