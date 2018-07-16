From: Punit Agrawal <punit.agrawal@arm.com>
Subject: [PATCH v6 2/8] KVM: arm/arm64: Re-factor setting the Stage 2 entry to exec on fault
Date: Mon, 16 Jul 2018 12:08:51 +0100
Message-ID: <20180716110857.19310-3-punit.agrawal@arm.com>
References: <20180716110857.19310-1-punit.agrawal@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180716110857.19310-1-punit.agrawal@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu
Cc: Punit Agrawal <punit.agrawal@arm.com>, linux-arm-kernel@lists.infradead.org, marc.zyngier@arm.com, christoffer.dall@arm.com, linux-kernel@vger.kernel.org, suzuki.poulose@arm.com, will.deacon@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

Stage 2 fault handler marks a page as executable if it is handling an
execution fault or if it was a permission fault in which case the
executable bit needs to be preserved.

The logic to decide if the page should be marked executable is
duplicated for PMD and PTE entries. To avoid creating another copy
when support for PUD hugepages is introduced refactor the code to
share the checks needed to mark a page table entry as executable.

Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
Cc: Christoffer Dall <christoffer.dall@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/mmu.c | 28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index 1c8d407a92ce..ea3d992e4fb7 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -1422,7 +1422,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			  unsigned long fault_status)
 {
 	int ret;
-	bool write_fault, exec_fault, writable, hugetlb = false, force_pte = false;
+	bool write_fault, writable, hugetlb = false, force_pte = false;
+	bool exec_fault, needs_exec;
 	unsigned long mmu_seq;
 	gfn_t gfn = fault_ipa >> PAGE_SHIFT;
 	struct kvm *kvm = vcpu->kvm;
@@ -1541,19 +1542,25 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	if (exec_fault)
 		invalidate_icache_guest_page(pfn, vma_pagesize);
 
+	/*
+	 * If we took an execution fault we have made the
+	 * icache/dcache coherent above and should now let the s2
+	 * mapping be executable.
+	 *
+	 * Write faults (!exec_fault && FSC_PERM) are orthogonal to
+	 * execute permissions, and we preserve whatever we have.
+	 */
+	needs_exec = exec_fault ||
+		(fault_status == FSC_PERM && stage2_is_exec(kvm, fault_ipa));
+
 	if (hugetlb && vma_pagesize == PMD_SIZE) {
 		pmd_t new_pmd = pfn_pmd(pfn, mem_type);
 		new_pmd = pmd_mkhuge(new_pmd);
 		if (writable)
 			new_pmd = kvm_s2pmd_mkwrite(new_pmd);
 
-		if (exec_fault) {
+		if (needs_exec)
 			new_pmd = kvm_s2pmd_mkexec(new_pmd);
-		} else if (fault_status == FSC_PERM) {
-			/* Preserve execute if XN was already cleared */
-			if (stage2_is_exec(kvm, fault_ipa))
-				new_pmd = kvm_s2pmd_mkexec(new_pmd);
-		}
 
 		ret = stage2_set_pmd_huge(kvm, memcache, fault_ipa, &new_pmd);
 	} else {
@@ -1564,13 +1571,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			mark_page_dirty(kvm, gfn);
 		}
 
-		if (exec_fault) {
+		if (needs_exec)
 			new_pte = kvm_s2pte_mkexec(new_pte);
-		} else if (fault_status == FSC_PERM) {
-			/* Preserve execute if XN was already cleared */
-			if (stage2_is_exec(kvm, fault_ipa))
-				new_pte = kvm_s2pte_mkexec(new_pte);
-		}
 
 		ret = stage2_set_pte(kvm, memcache, fault_ipa, &new_pte, flags);
 	}
-- 
2.17.1
