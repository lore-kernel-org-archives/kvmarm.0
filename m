From: Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH 1/2] arm/kvm: excise redundant cache maintenance
Date: Tue, 30 Aug 2016 17:05:55 +0100
Message-ID: <1472573156-30414-2-git-send-email-mark.rutland@arm.com>
References: <1472573156-30414-1-git-send-email-mark.rutland@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8DE6E41267
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Aug 2016 11:58:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cgnW7n9eeVTi for <kvmarm@lists.cs.columbia.edu>;
 Tue, 30 Aug 2016 11:58:08 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4AEBA411E3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Aug 2016 11:58:08 -0400 (EDT)
In-Reply-To: <1472573156-30414-1-git-send-email-mark.rutland@arm.com>
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
Cc: marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

When modifying Stage-2 page tables, we perform cache maintenance to
account for non-coherent page table walks. However, this is unnecessary,
as page table walks are guaranteed to be coherent in the presence of the
virtualization extensions.

Per ARM DDI 0406C.c, section B1.7 ("The Virtualization Extensions"), the
virtualization extensions mandate the multiprocessing extensions.

Per ARM DDI 0406C.c, section B3.10.1 ("General TLB maintenance
requirements"), as described in the sub-section titled "TLB maintenance
operations and the memory order model", this maintenance is not required
in the presence of the multiprocessing extensions.

Hence, we need not perform this cache maintenance when modifying Stage-2
entries.

This patch removes the logic for performing the redundant maintenance.
To ensure visibility and ordering of updates, a dsb(ishst) that was
otherwise implicit in the maintenance is folded into kvm_set_pmd() and
kvm_set_pte().

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvmarm@lists.cs.columbia.edu
---
 arch/arm/include/asm/kvm_mmu.h | 28 ++--------------------------
 arch/arm/kvm/mmu.c             |  2 --
 2 files changed, 2 insertions(+), 28 deletions(-)

diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
index 3bb803d..74a44727 100644
--- a/arch/arm/include/asm/kvm_mmu.h
+++ b/arch/arm/include/asm/kvm_mmu.h
@@ -63,37 +63,13 @@ void kvm_clear_hyp_idmap(void);
 static inline void kvm_set_pmd(pmd_t *pmd, pmd_t new_pmd)
 {
 	*pmd = new_pmd;
-	flush_pmd_entry(pmd);
+	dsb(ishst);
 }
 
 static inline void kvm_set_pte(pte_t *pte, pte_t new_pte)
 {
 	*pte = new_pte;
-	/*
-	 * flush_pmd_entry just takes a void pointer and cleans the necessary
-	 * cache entries, so we can reuse the function for ptes.
-	 */
-	flush_pmd_entry(pte);
-}
-
-static inline void kvm_clean_pgd(pgd_t *pgd)
-{
-	clean_dcache_area(pgd, PTRS_PER_S2_PGD * sizeof(pgd_t));
-}
-
-static inline void kvm_clean_pmd(pmd_t *pmd)
-{
-	clean_dcache_area(pmd, PTRS_PER_PMD * sizeof(pmd_t));
-}
-
-static inline void kvm_clean_pmd_entry(pmd_t *pmd)
-{
-	clean_pmd_entry(pmd);
-}
-
-static inline void kvm_clean_pte(pte_t *pte)
-{
-	clean_pte_table(pte);
+	dsb(ishst);
 }
 
 static inline pte_t kvm_s2pte_mkwrite(pte_t pte)
diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
index 29d0b23..344755d 100644
--- a/arch/arm/kvm/mmu.c
+++ b/arch/arm/kvm/mmu.c
@@ -744,7 +744,6 @@ int kvm_alloc_stage2_pgd(struct kvm *kvm)
 	if (!pgd)
 		return -ENOMEM;
 
-	kvm_clean_pgd(pgd);
 	kvm->arch.pgd = pgd;
 	return 0;
 }
@@ -936,7 +935,6 @@ static int stage2_set_pte(struct kvm *kvm, struct kvm_mmu_memory_cache *cache,
 		if (!cache)
 			return 0; /* ignore calls from kvm_set_spte_hva */
 		pte = mmu_memory_cache_alloc(cache);
-		kvm_clean_pte(pte);
 		pmd_populate_kernel(NULL, pmd, pte);
 		get_page(virt_to_page(pmd));
 	}
-- 
1.9.1
