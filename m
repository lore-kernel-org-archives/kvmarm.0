From: Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 4/5] KVM: arm/arm64: Add support for creating PTE contiguous
 hugepages at stage2
Date: Wed, 1 May 2019 09:44:26 +0000
Message-ID: <1556703867-22396-5-git-send-email-yuzenghui@huawei.com>
References: <1556703867-22396-1-git-send-email-yuzenghui@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 740894A500
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 May 2019 05:48:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UbEoOIb-LzuB for <kvmarm@lists.cs.columbia.edu>;
 Wed,  1 May 2019 05:48:23 -0400 (EDT)
Received: from huawei.com (szxga06-in.huawei.com [45.249.212.32])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C4AAA4A4F7
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 May 2019 05:48:22 -0400 (EDT)
In-Reply-To: <1556703867-22396-1-git-send-email-yuzenghui@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, linux@armlinux.org.uk
List-Id: kvmarm@lists.cs.columbia.edu

Extend the stage2 fault handling to map in PTE contiguous hugepages first.
With this patch, we now support additional following page size at stage2:

                CONT PTE
                --------
 4K granule:      64K
16K granule:       2M
64K granule:       2M

The PMD contiguous huge mapping is still not supported yet and will be
simply fall back to a PTE mapping.

Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
---
 virt/kvm/arm/mmu.c | 76 +++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 75 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index 36c863f..fdd6314 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -1104,6 +1104,27 @@ static pmd_t *stage2_get_pmd(struct kvm *kvm, struct kvm_mmu_memory_cache *cache
 	return stage2_pmd_offset(kvm, pud, addr);
 }
 
+static pte_t *stage2_get_pte(struct kvm *kvm, struct kvm_mmu_memory_cache *cache,
+			     phys_addr_t addr)
+{
+	pmd_t *pmd;
+	pte_t *pte;
+
+	pmd = stage2_get_pmd(kvm, cache, addr);
+	if (!pmd || pmd_thp_or_huge(*pmd))
+		return NULL;
+
+	if (pmd_none(*pmd)) {
+		if (!cache)
+			return NULL;
+		pte = mmu_memory_cache_alloc(cache);
+		kvm_pmd_populate(pmd, pte);
+		get_page(virt_to_page(pmd));
+	}
+
+	return pte_offset_kernel(pmd, addr);
+}
+
 static int stage2_set_pmd_huge(struct kvm *kvm, struct kvm_mmu_memory_cache
 			       *cache, phys_addr_t addr, const pmd_t *new_pmd)
 {
@@ -1270,6 +1291,54 @@ static bool stage2_is_exec(struct kvm *kvm, phys_addr_t addr)
 		return kvm_s2pte_exec(ptep);
 }
 
+/* This code is borrowed from arch/arm64/mm/hugetlbpage.c */
+static inline pgprot_t pte_pgprot(pte_t pte)
+{
+	unsigned long pfn = pte_pfn(pte);
+
+	return __pgprot(pte_val(pfn_pte(pfn, __pgprot(0))) ^ pte_val(pte));
+}
+
+static int stage2_set_cont_ptes(struct kvm *kvm, struct kvm_mmu_memory_cache
+				*cache, phys_addr_t addr, const pte_t *new_pte)
+{
+	pte_t *pte, old_pte;
+	unsigned long pfn, dpfn;
+	int i;
+	pgprot_t hugeprot;
+
+	/*
+	 * Make sure we start manipulating the first pte
+	 * within CONT_PTES ptes.
+	 */
+	addr &= CONT_PTE_MASK;
+	pfn = pte_pfn(*new_pte);
+	dpfn = PAGE_SIZE >> PAGE_SHIFT;
+	hugeprot = pte_pgprot(*new_pte);
+
+	pte = stage2_get_pte(kvm, cache, addr);
+	VM_BUG_ON(!pte);
+
+	old_pte = *pte;
+
+	/* Skip page table update if there is no change */
+	if (pte_val(old_pte) == pte_val(*new_pte))
+		return 0;
+
+	for (i = 0; i < CONT_PTES; i++, pte++, addr += PAGE_SIZE, pfn += dpfn) {
+		if (pte_present(old_pte)) {
+			kvm_set_pte(pte, __pte(0));
+			kvm_tlb_flush_vmid_ipa(kvm, addr);
+		} else {
+			get_page(virt_to_page(pte));
+		}
+
+		kvm_set_pte(pte, kvm_pfn_pte(pfn, hugeprot));
+	}
+
+	return 0;
+}
+
 static int stage2_set_pte(struct kvm *kvm, struct kvm_mmu_memory_cache *cache,
 			  phys_addr_t addr, const pte_t *new_pte,
 			  unsigned long flags)
@@ -1824,7 +1893,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	 * As for PUD huge maps, we must make sure that we have at least
 	 * 3 levels, i.e, PMD is not folded.
 	 */
-	if (vma_pagesize == PMD_SIZE ||
+	if (vma_pagesize == CONT_PTE_SIZE || vma_pagesize == PMD_SIZE ||
 	    (vma_pagesize == PUD_SIZE && kvm_stage2_has_pmd(kvm)))
 		gfn = (fault_ipa & huge_page_mask(hstate_vma(vma))) >> PAGE_SHIFT;
 	up_read(&current->mm->mmap_sem);
@@ -1918,6 +1987,11 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 						 needs_exec, false);
 
 		ret = stage2_set_pmd_huge(kvm, memcache, fault_ipa, &new_pmd);
+	} else if (vma_pagesize == CONT_PTE_SIZE) {
+		pte_t new_pte = stage2_build_pte(pfn, mem_type, writable,
+						 needs_exec, true);
+
+		ret = stage2_set_cont_ptes(kvm, memcache, fault_ipa, &new_pte);
 	} else {
 		pte_t new_pte = stage2_build_pte(pfn, mem_type, writable,
 						 needs_exec, false);
-- 
1.8.3.1
