Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D510D2F2910
	for <kvmarm@lists.linux.dev>; Tue, 30 Dec 2025 23:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767135728; cv=none; b=MbJeXDA+RaxgkYHfcv5PDSRGrOVkoRwyrdBiVKqIn51IulHCwumzioXNAq6Q1awQuM08WDYbnlZGx2bF6C9+R+JSCD3mXiwJZACJEf4UjWDgC8P1DotWc28IT/z+BOCoZn0S/7tzqH5ixHt67YipjT2oE4lk5i+YkpnBrOcFQkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767135728; c=relaxed/simple;
	bh=ZU8xlAMH6mZxvqsPzFpIFF9VcGo1De1VYXH4GsE/Stk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Oa6WT6CgTN2bV1a2lvBrSbLl6SmKPki356SdNBcFdnyiicXBuepiU3kKebK1oGiRf9l+smUJ7Wn2RZorRCJvTWefzgCSAwf9bxDWsSm+ebe2YZplTB695+DomVVtRezNNaW33Mqj04hGudS1OBOVWQZuYrj1NhsOge4MpJil+qY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QPkhmkSI; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QPkhmkSI"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34c37b8dc4fso21900510a91.2
        for <kvmarm@lists.linux.dev>; Tue, 30 Dec 2025 15:02:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767135725; x=1767740525; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=5Cc6wkm6hIGFSfttAC+mfZ95Ec3DVPFhFOuj3x7H3nk=;
        b=QPkhmkSIH6COE77TMgdvjrF2ofeva44UZcnaC45E/BEsWYNEPaUPqWSWDZS6SNpCm8
         8tCIL3yzeyw40/Kg9Ugb5CPDymRgVPU6+3YY/SJDkSEDG++MlyUQLYCQ00H2pxxnc9Qx
         2nvfuVzSELtXP9FSelUKrwOAM4fgXbTa6o/CixOw7jhqbrXeuZn4e3hOLiDh9+JgcTFo
         j4wCF5G3EWLYImxNn1/zQ7yNBLePiGNXggYmb0KUU9CgOuxobZdv2o1Ct1VrRnWtKVMk
         /jgiHD8O8dO3ghcKy0IICy4kYvC8uPz83wAfp1l8X1dmTUclI8a/k8QzjWxdj0vp7/qd
         PWTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767135725; x=1767740525;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5Cc6wkm6hIGFSfttAC+mfZ95Ec3DVPFhFOuj3x7H3nk=;
        b=Mdu3CZGApsU992MRUvnOxzorHPTvAhNnUN4NN/PoZTtN0DbMmLyrL03QBFz1/LOIOF
         /a/FqW1cypeunRxHaPh9SZ3BepfwW+Ld30G86DKCzAmmtq3Z8DZ5DKV/w7T7R8tbqQ3+
         zHoGLhmSRqjArpfRJxJ5aHLeiAVULj4/AT2kCy1pvCbtI+sCaaM07xFKnK247Nb3FyiW
         22+BfVQHbinyZABFXTmDLId8k01w5oLqbHFK8rFkpVzGZeJ7T20o3KKqxDWgf4ve/6XU
         V2SiDxmts3vQLrRSMtjQIQR3UBupfbt888MEQdVl0S6qfXjKfF2a+2UQAorLEF+Q9uOn
         0l+w==
X-Forwarded-Encrypted: i=1; AJvYcCXSUqxkYpvSN/XLHzw/Z6QdS42aat8Z4An3e1NABUeDmd7n4B4lK8AgTdFqMQM1G9Wk1j2301s=@lists.linux.dev
X-Gm-Message-State: AOJu0YxurbZcEHmWI7CxBlkaAW6Moltv/8b3cTd8HN+bCP+VlfXo0rKr
	UEvIsu675VMdCK4yQy0ajFccXxAvB/MjIxDzoaKeKaSM2lqZ9+EPfsC1BbHT5VeCt9vzB+DOTkz
	8cw8iAA==
X-Google-Smtp-Source: AGHT+IEOOU/PO2opx5uUUNTa4NR3nkLk9xuANEwk4g6N1XvLso6TqSi1gOEvbsBH7aLFxJKOwgJ+kV8p0Fg=
X-Received: from pjnz3.prod.google.com ([2002:a17:90a:8b83:b0:34a:bee9:ef2])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2e08:b0:340:ad5e:ca
 with SMTP id 98e67ed59e1d1-34e92139e3amr31373229a91.12.1767135724924; Tue, 30
 Dec 2025 15:02:04 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 30 Dec 2025 15:01:36 -0800
In-Reply-To: <20251230230150.4150236-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251230230150.4150236-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.351.gbe84eed79e-goog
Message-ID: <20251230230150.4150236-8-seanjc@google.com>
Subject: [PATCH v4 07/21] KVM: selftests: Plumb "struct kvm_mmu" into x86's
 MMU APIs
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
	linux-kernel@vger.kernel.org, Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"

In preparation for generalizing the x86 virt mapping APIs to work with
TDP (stage-2) page tables, plumb "struct kvm_mmu" into all of the helper
functions instead of operating on vm->mmu directly.

Opportunistically swap the order of the check in virt_get_pte() to first
assert that the parent is the PGD, and then check that the PTE is present,
as it makes more sense to check if the parent PTE is the PGD/root (i.e.
not a PTE) before checking that the PTE is PRESENT.

No functional change intended.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
[sean: rebase on common kvm_mmu structure, rewrite changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/x86/processor.h     |  3 +-
 .../testing/selftests/kvm/lib/x86/processor.c | 68 +++++++++++--------
 2 files changed, 41 insertions(+), 30 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86/processor.h b/tools/testing/selftests/kvm/include/x86/processor.h
index c00c0fbe62cd..cbac9de29074 100644
--- a/tools/testing/selftests/kvm/include/x86/processor.h
+++ b/tools/testing/selftests/kvm/include/x86/processor.h
@@ -1449,7 +1449,8 @@ enum pg_level {
 #define PG_SIZE_2M PG_LEVEL_SIZE(PG_LEVEL_2M)
 #define PG_SIZE_1G PG_LEVEL_SIZE(PG_LEVEL_1G)
 
-void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr, int level);
+void __virt_pg_map(struct kvm_vm *vm, struct kvm_mmu *mmu, uint64_t vaddr,
+		   uint64_t paddr,  int level);
 void virt_map_level(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 		    uint64_t nr_bytes, int level);
 
diff --git a/tools/testing/selftests/kvm/lib/x86/processor.c b/tools/testing/selftests/kvm/lib/x86/processor.c
index f027f86d1535..f25742a804b0 100644
--- a/tools/testing/selftests/kvm/lib/x86/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86/processor.c
@@ -156,26 +156,31 @@ bool kvm_is_tdp_enabled(void)
 		return get_kvm_amd_param_bool("npt");
 }
 
-void virt_arch_pgd_alloc(struct kvm_vm *vm)
+static void virt_mmu_init(struct kvm_vm *vm, struct kvm_mmu *mmu)
 {
-	TEST_ASSERT(vm->mode == VM_MODE_PXXVYY_4K,
-		    "Unknown or unsupported guest mode: 0x%x", vm->mode);
-
 	/* If needed, create the top-level page table. */
-	if (!vm->mmu.pgd_created) {
-		vm->mmu.pgd = vm_alloc_page_table(vm);
-		vm->mmu.pgd_created = true;
+	if (!mmu->pgd_created) {
+		mmu->pgd = vm_alloc_page_table(vm);
+		mmu->pgd_created = true;
 	}
 }
 
-static void *virt_get_pte(struct kvm_vm *vm, uint64_t *parent_pte,
-			  uint64_t vaddr, int level)
+void virt_arch_pgd_alloc(struct kvm_vm *vm)
+{
+	TEST_ASSERT(vm->mode == VM_MODE_PXXVYY_4K,
+		    "Unknown or unsupported guest mode: 0x%x", vm->mode);
+
+	virt_mmu_init(vm, &vm->mmu);
+}
+
+static void *virt_get_pte(struct kvm_vm *vm, struct kvm_mmu *mmu,
+			  uint64_t *parent_pte, uint64_t vaddr, int level)
 {
 	uint64_t pt_gpa = PTE_GET_PA(*parent_pte);
 	uint64_t *page_table = addr_gpa2hva(vm, pt_gpa);
 	int index = (vaddr >> PG_LEVEL_SHIFT(level)) & 0x1ffu;
 
-	TEST_ASSERT((*parent_pte & PTE_PRESENT_MASK) || parent_pte == &vm->mmu.pgd,
+	TEST_ASSERT((*parent_pte == mmu->pgd) || (*parent_pte & PTE_PRESENT_MASK),
 		    "Parent PTE (level %d) not PRESENT for gva: 0x%08lx",
 		    level + 1, vaddr);
 
@@ -183,13 +188,14 @@ static void *virt_get_pte(struct kvm_vm *vm, uint64_t *parent_pte,
 }
 
 static uint64_t *virt_create_upper_pte(struct kvm_vm *vm,
+				       struct kvm_mmu *mmu,
 				       uint64_t *parent_pte,
 				       uint64_t vaddr,
 				       uint64_t paddr,
 				       int current_level,
 				       int target_level)
 {
-	uint64_t *pte = virt_get_pte(vm, parent_pte, vaddr, current_level);
+	uint64_t *pte = virt_get_pte(vm, mmu, parent_pte, vaddr, current_level);
 
 	paddr = vm_untag_gpa(vm, paddr);
 
@@ -215,10 +221,11 @@ static uint64_t *virt_create_upper_pte(struct kvm_vm *vm,
 	return pte;
 }
 
-void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr, int level)
+void __virt_pg_map(struct kvm_vm *vm, struct kvm_mmu *mmu, uint64_t vaddr,
+		   uint64_t paddr, int level)
 {
 	const uint64_t pg_size = PG_LEVEL_SIZE(level);
-	uint64_t *pte = &vm->mmu.pgd;
+	uint64_t *pte = &mmu->pgd;
 	int current_level;
 
 	TEST_ASSERT(vm->mode == VM_MODE_PXXVYY_4K,
@@ -243,17 +250,17 @@ void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr, int level)
 	 * Allocate upper level page tables, if not already present.  Return
 	 * early if a hugepage was created.
 	 */
-	for (current_level = vm->mmu.pgtable_levels;
+	for (current_level = mmu->pgtable_levels;
 	     current_level > PG_LEVEL_4K;
 	     current_level--) {
-		pte = virt_create_upper_pte(vm, pte, vaddr, paddr,
+		pte = virt_create_upper_pte(vm, mmu, pte, vaddr, paddr,
 					    current_level, level);
 		if (*pte & PTE_LARGE_MASK)
 			return;
 	}
 
 	/* Fill in page table entry. */
-	pte = virt_get_pte(vm, pte, vaddr, PG_LEVEL_4K);
+	pte = virt_get_pte(vm, mmu, pte, vaddr, PG_LEVEL_4K);
 	TEST_ASSERT(!(*pte & PTE_PRESENT_MASK),
 		    "PTE already present for 4k page at vaddr: 0x%lx", vaddr);
 	*pte = PTE_PRESENT_MASK | PTE_WRITABLE_MASK | (paddr & PHYSICAL_PAGE_MASK);
@@ -270,7 +277,7 @@ void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr, int level)
 
 void virt_arch_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
 {
-	__virt_pg_map(vm, vaddr, paddr, PG_LEVEL_4K);
+	__virt_pg_map(vm, &vm->mmu, vaddr, paddr, PG_LEVEL_4K);
 }
 
 void virt_map_level(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
@@ -285,7 +292,7 @@ void virt_map_level(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 		    nr_bytes, pg_size);
 
 	for (i = 0; i < nr_pages; i++) {
-		__virt_pg_map(vm, vaddr, paddr, level);
+		__virt_pg_map(vm, &vm->mmu, vaddr, paddr, level);
 		sparsebit_set_num(vm->vpages_mapped, vaddr >> vm->page_shift,
 				  nr_bytes / PAGE_SIZE);
 
@@ -294,7 +301,8 @@ void virt_map_level(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 	}
 }
 
-static bool vm_is_target_pte(uint64_t *pte, int *level, int current_level)
+static bool vm_is_target_pte(struct kvm_mmu *mmu, uint64_t *pte,
+			     int *level, int current_level)
 {
 	if (*pte & PTE_LARGE_MASK) {
 		TEST_ASSERT(*level == PG_LEVEL_NONE ||
@@ -306,17 +314,19 @@ static bool vm_is_target_pte(uint64_t *pte, int *level, int current_level)
 	return *level == current_level;
 }
 
-static uint64_t *__vm_get_page_table_entry(struct kvm_vm *vm, uint64_t vaddr,
+static uint64_t *__vm_get_page_table_entry(struct kvm_vm *vm,
+					   struct kvm_mmu *mmu,
+					   uint64_t vaddr,
 					   int *level)
 {
-	int va_width = 12 + (vm->mmu.pgtable_levels) * 9;
-	uint64_t *pte = &vm->mmu.pgd;
+	int va_width = 12 + (mmu->pgtable_levels) * 9;
+	uint64_t *pte = &mmu->pgd;
 	int current_level;
 
 	TEST_ASSERT(!vm->arch.is_pt_protected,
 		    "Walking page tables of protected guests is impossible");
 
-	TEST_ASSERT(*level >= PG_LEVEL_NONE && *level <= vm->mmu.pgtable_levels,
+	TEST_ASSERT(*level >= PG_LEVEL_NONE && *level <= mmu->pgtable_levels,
 		    "Invalid PG_LEVEL_* '%d'", *level);
 
 	TEST_ASSERT(vm->mode == VM_MODE_PXXVYY_4K,
@@ -332,22 +342,22 @@ static uint64_t *__vm_get_page_table_entry(struct kvm_vm *vm, uint64_t vaddr,
 		    (((int64_t)vaddr << (64 - va_width) >> (64 - va_width))),
 		    "Canonical check failed.  The virtual address is invalid.");
 
-	for (current_level = vm->mmu.pgtable_levels;
+	for (current_level = mmu->pgtable_levels;
 	     current_level > PG_LEVEL_4K;
 	     current_level--) {
-		pte = virt_get_pte(vm, pte, vaddr, current_level);
-		if (vm_is_target_pte(pte, level, current_level))
+		pte = virt_get_pte(vm, mmu, pte, vaddr, current_level);
+		if (vm_is_target_pte(mmu, pte, level, current_level))
 			return pte;
 	}
 
-	return virt_get_pte(vm, pte, vaddr, PG_LEVEL_4K);
+	return virt_get_pte(vm, mmu, pte, vaddr, PG_LEVEL_4K);
 }
 
 uint64_t *vm_get_page_table_entry(struct kvm_vm *vm, uint64_t vaddr)
 {
 	int level = PG_LEVEL_4K;
 
-	return __vm_get_page_table_entry(vm, vaddr, &level);
+	return __vm_get_page_table_entry(vm, &vm->mmu, vaddr, &level);
 }
 
 void virt_arch_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
@@ -497,7 +507,7 @@ static void kvm_seg_set_kernel_data_64bit(struct kvm_segment *segp)
 vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
 {
 	int level = PG_LEVEL_NONE;
-	uint64_t *pte = __vm_get_page_table_entry(vm, gva, &level);
+	uint64_t *pte = __vm_get_page_table_entry(vm, &vm->mmu, gva, &level);
 
 	TEST_ASSERT(*pte & PTE_PRESENT_MASK,
 		    "Leaf PTE not PRESENT for gva: 0x%08lx", gva);
-- 
2.52.0.351.gbe84eed79e-goog

