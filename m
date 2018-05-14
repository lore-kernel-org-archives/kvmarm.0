From: Punit Agrawal <punit.agrawal@arm.com>
Subject: [PATCH v3 1/4] KVM: arm/arm64: Share common code in user_mem_abort()
Date: Mon, 14 May 2018 15:43:01 +0100
Message-ID: <20180514144304.10484-2-punit.agrawal@arm.com>
References: <20180514144304.10484-1-punit.agrawal@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180514144304.10484-1-punit.agrawal@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu
Cc: Punit Agrawal <punit.agrawal@arm.com>, linux-arm-kernel@lists.infradead.org, marc.zyngier@arm.com, christoffer.dall@arm.com, linux-kernel@vger.kernel.org, suzuki.poulose@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

The code for operations such as marking the pfn as dirty, and
dcache/icache maintenance during stage 2 fault handling is duplicated
between normal pages and PMD hugepages.

Instead of creating another copy of the operations when we introduce
PUD hugepages, let's share them across the different pagesizes.

Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
Reviewed-by: Christoffer Dall <christoffer.dall@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/mmu.c | 69 +++++++++++++++++++++++++++-------------------
 1 file changed, 40 insertions(+), 29 deletions(-)

diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index 7f6a944db23d..07ae1e003762 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -1396,6 +1396,21 @@ static void invalidate_icache_guest_page(kvm_pfn_t pfn, unsigned long size)
 	__invalidate_icache_guest_page(pfn, size);
 }
 
+static bool stage2_should_exec(struct kvm *kvm, phys_addr_t addr,
+			       bool exec_fault, unsigned long fault_status)
+{
+	/*
+	 * If we took an execution fault we will have made the
+	 * icache/dcache coherent and should now let the s2 mapping be
+	 * executable.
+	 *
+	 * Write faults (!exec_fault && FSC_PERM) are orthogonal to
+	 * execute permissions, and we preserve whatever we have.
+	 */
+	return exec_fault ||
+		(fault_status == FSC_PERM && stage2_is_exec(kvm, addr));
+}
+
 static void kvm_send_hwpoison_signal(unsigned long address,
 				     struct vm_area_struct *vma)
 {
@@ -1428,7 +1443,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	kvm_pfn_t pfn;
 	pgprot_t mem_type = PAGE_S2;
 	bool logging_active = memslot_is_logging(memslot);
-	unsigned long flags = 0;
+	unsigned long vma_pagesize, flags = 0;
 
 	write_fault = kvm_is_write_fault(vcpu);
 	exec_fault = kvm_vcpu_trap_is_iabt(vcpu);
@@ -1448,7 +1463,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		return -EFAULT;
 	}
 
-	if (vma_kernel_pagesize(vma) == PMD_SIZE && !logging_active) {
+	vma_pagesize = vma_kernel_pagesize(vma);
+	if (vma_pagesize == PMD_SIZE && !logging_active) {
 		hugetlb = true;
 		gfn = (fault_ipa & PMD_MASK) >> PAGE_SHIFT;
 	} else {
@@ -1517,28 +1533,33 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	if (mmu_notifier_retry(kvm, mmu_seq))
 		goto out_unlock;
 
-	if (!hugetlb && !force_pte)
-		hugetlb = transparent_hugepage_adjust(&pfn, &fault_ipa);
+	if (!hugetlb && !force_pte) {
+		/*
+		 * Only PMD_SIZE transparent hugepages(THP) are
+		 * currently supported. This code will need to be
+		 * updated to support other THP sizes.
+		 */
+		if (transparent_hugepage_adjust(&pfn, &fault_ipa))
+			vma_pagesize = PMD_SIZE;
+	}
+
+	if (writable)
+		kvm_set_pfn_dirty(pfn);
 
-	if (hugetlb) {
+	if (fault_status != FSC_PERM)
+		clean_dcache_guest_page(pfn, vma_pagesize);
+
+	if (exec_fault)
+		invalidate_icache_guest_page(pfn, vma_pagesize);
+
+	if (vma_pagesize == PMD_SIZE) {
 		pmd_t new_pmd = pfn_pmd(pfn, mem_type);
 		new_pmd = pmd_mkhuge(new_pmd);
-		if (writable) {
+		if (writable)
 			new_pmd = kvm_s2pmd_mkwrite(new_pmd);
-			kvm_set_pfn_dirty(pfn);
-		}
 
-		if (fault_status != FSC_PERM)
-			clean_dcache_guest_page(pfn, PMD_SIZE);
-
-		if (exec_fault) {
+		if (stage2_should_exec(kvm, fault_ipa, exec_fault, fault_status))
 			new_pmd = kvm_s2pmd_mkexec(new_pmd);
-			invalidate_icache_guest_page(pfn, PMD_SIZE);
-		} else if (fault_status == FSC_PERM) {
-			/* Preserve execute if XN was already cleared */
-			if (stage2_is_exec(kvm, fault_ipa))
-				new_pmd = kvm_s2pmd_mkexec(new_pmd);
-		}
 
 		ret = stage2_set_pmd_huge(kvm, memcache, fault_ipa, &new_pmd);
 	} else {
@@ -1546,21 +1567,11 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 
 		if (writable) {
 			new_pte = kvm_s2pte_mkwrite(new_pte);
-			kvm_set_pfn_dirty(pfn);
 			mark_page_dirty(kvm, gfn);
 		}
 
-		if (fault_status != FSC_PERM)
-			clean_dcache_guest_page(pfn, PAGE_SIZE);
-
-		if (exec_fault) {
+		if (stage2_should_exec(kvm, fault_ipa, exec_fault, fault_status))
 			new_pte = kvm_s2pte_mkexec(new_pte);
-			invalidate_icache_guest_page(pfn, PAGE_SIZE);
-		} else if (fault_status == FSC_PERM) {
-			/* Preserve execute if XN was already cleared */
-			if (stage2_is_exec(kvm, fault_ipa))
-				new_pte = kvm_s2pte_mkexec(new_pte);
-		}
 
 		ret = stage2_set_pte(kvm, memcache, fault_ipa, &new_pte, flags);
 	}
-- 
2.17.0
