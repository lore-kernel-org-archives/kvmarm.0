From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v10 2/8] KVM: arm/arm64: Re-factor setting the Stage 2 entry
 to exec on fault
Date: Tue, 11 Dec 2018 17:10:35 +0000
Message-ID: <1544548241-6417-3-git-send-email-suzuki.poulose@arm.com>
References: <1544548241-6417-1-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 255FE4A329
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Dec 2018 12:12:12 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id djcqRNocl2bb for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 Dec 2018 12:12:11 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 987884A2BB
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Dec 2018 12:12:10 -0500 (EST)
In-Reply-To: <1544548241-6417-1-git-send-email-suzuki.poulose@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, catalin.marinas@arm.com, anshuman.khandual@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

From: Punit Agrawal <punit.agrawal@arm.com>

Stage 2 fault handler marks a page as executable if it is handling an
execution fault or if it was a permission fault in which case the
executable bit needs to be preserved.

The logic to decide if the page should be marked executable is
duplicated for PMD and PTE entries. To avoid creating another copy
when support for PUD hugepages is introduced refactor the code to
share the checks needed to mark a page table entry as executable.

Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Christoffer Dall <christoffer.dall@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 virt/kvm/arm/mmu.c | 28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index 5959520..6912529 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -1475,7 +1475,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			  unsigned long fault_status)
 {
 	int ret;
-	bool write_fault, exec_fault, writable, force_pte = false;
+	bool write_fault, writable, force_pte = false;
+	bool exec_fault, needs_exec;
 	unsigned long mmu_seq;
 	gfn_t gfn = fault_ipa >> PAGE_SHIFT;
 	struct kvm *kvm = vcpu->kvm;
@@ -1598,19 +1599,25 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
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
 	if (vma_pagesize == PMD_SIZE) {
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
@@ -1621,13 +1628,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
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
2.7.4
