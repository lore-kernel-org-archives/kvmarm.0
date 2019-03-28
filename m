From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 6/8] KVM: arm/arm64: Fix handling of stage2 huge mappings
Date: Thu, 28 Mar 2019 13:36:06 +0000
Message-ID: <20190328133608.110805-7-marc.zyngier@arm.com>
References: <20190328133608.110805-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E7CAD4A437
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Mar 2019 09:36:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id K15-SNPotYZR for <kvmarm@lists.cs.columbia.edu>;
 Thu, 28 Mar 2019 09:36:55 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B82534A422
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Mar 2019 09:36:52 -0400 (EDT)
In-Reply-To: <20190328133608.110805-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: kvm@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>, Julien Grall <julien.grall@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Suzuki K Poulose <suzuki.poulose@arm.com>

We rely on the mmu_notifier call backs to handle the split/merge
of huge pages and thus we are guaranteed that, while creating a
block mapping, either the entire block is unmapped at stage2 or it
is missing permission.

However, we miss a case where the block mapping is split for dirty
logging case and then could later be made block mapping, if we cancel the
dirty logging. This not only creates inconsistent TLB entries for
the pages in the the block, but also leakes the table pages for
PMD level.

Handle this corner case for the huge mappings at stage2 by
unmapping the non-huge mapping for the block. This could potentially
release the upper level table. So we need to restart the table walk
once we unmap the range.

Fixes : ad361f093c1e31d ("KVM: ARM: Support hugetlbfs backed huge pages")
Reported-by: Zheng Xiang <zhengxiang9@huawei.com>
Cc: Zheng Xiang <zhengxiang9@huawei.com>
Cc: Zenghui Yu <yuzenghui@huawei.com>
Cc: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/include/asm/stage2_pgtable.h |  2 +
 virt/kvm/arm/mmu.c                    | 59 +++++++++++++++++++--------
 2 files changed, 45 insertions(+), 16 deletions(-)

diff --git a/arch/arm/include/asm/stage2_pgtable.h b/arch/arm/include/asm/stage2_pgtable.h
index de2089501b8b..9e11dce55e06 100644
--- a/arch/arm/include/asm/stage2_pgtable.h
+++ b/arch/arm/include/asm/stage2_pgtable.h
@@ -75,6 +75,8 @@ static inline bool kvm_stage2_has_pud(struct kvm *kvm)
 
 #define S2_PMD_MASK				PMD_MASK
 #define S2_PMD_SIZE				PMD_SIZE
+#define S2_PUD_MASK				PUD_MASK
+#define S2_PUD_SIZE				PUD_SIZE
 
 static inline bool kvm_stage2_has_pmd(struct kvm *kvm)
 {
diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index bcdf978c0d1d..f9da2fad9bd6 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -1067,25 +1067,43 @@ static int stage2_set_pmd_huge(struct kvm *kvm, struct kvm_mmu_memory_cache
 {
 	pmd_t *pmd, old_pmd;
 
+retry:
 	pmd = stage2_get_pmd(kvm, cache, addr);
 	VM_BUG_ON(!pmd);
 
 	old_pmd = *pmd;
+	/*
+	 * Multiple vcpus faulting on the same PMD entry, can
+	 * lead to them sequentially updating the PMD with the
+	 * same value. Following the break-before-make
+	 * (pmd_clear() followed by tlb_flush()) process can
+	 * hinder forward progress due to refaults generated
+	 * on missing translations.
+	 *
+	 * Skip updating the page table if the entry is
+	 * unchanged.
+	 */
+	if (pmd_val(old_pmd) == pmd_val(*new_pmd))
+		return 0;
+
 	if (pmd_present(old_pmd)) {
 		/*
-		 * Multiple vcpus faulting on the same PMD entry, can
-		 * lead to them sequentially updating the PMD with the
-		 * same value. Following the break-before-make
-		 * (pmd_clear() followed by tlb_flush()) process can
-		 * hinder forward progress due to refaults generated
-		 * on missing translations.
+		 * If we already have PTE level mapping for this block,
+		 * we must unmap it to avoid inconsistent TLB state and
+		 * leaking the table page. We could end up in this situation
+		 * if the memory slot was marked for dirty logging and was
+		 * reverted, leaving PTE level mappings for the pages accessed
+		 * during the period. So, unmap the PTE level mapping for this
+		 * block and retry, as we could have released the upper level
+		 * table in the process.
 		 *
-		 * Skip updating the page table if the entry is
-		 * unchanged.
+		 * Normal THP split/merge follows mmu_notifier callbacks and do
+		 * get handled accordingly.
 		 */
-		if (pmd_val(old_pmd) == pmd_val(*new_pmd))
-			return 0;
-
+		if (!pmd_thp_or_huge(old_pmd)) {
+			unmap_stage2_range(kvm, addr & S2_PMD_MASK, S2_PMD_SIZE);
+			goto retry;
+		}
 		/*
 		 * Mapping in huge pages should only happen through a
 		 * fault.  If a page is merged into a transparent huge
@@ -1097,8 +1115,7 @@ static int stage2_set_pmd_huge(struct kvm *kvm, struct kvm_mmu_memory_cache
 		 * should become splitting first, unmapped, merged,
 		 * and mapped back in on-demand.
 		 */
-		VM_BUG_ON(pmd_pfn(old_pmd) != pmd_pfn(*new_pmd));
-
+		WARN_ON_ONCE(pmd_pfn(old_pmd) != pmd_pfn(*new_pmd));
 		pmd_clear(pmd);
 		kvm_tlb_flush_vmid_ipa(kvm, addr);
 	} else {
@@ -1114,6 +1131,7 @@ static int stage2_set_pud_huge(struct kvm *kvm, struct kvm_mmu_memory_cache *cac
 {
 	pud_t *pudp, old_pud;
 
+retry:
 	pudp = stage2_get_pud(kvm, cache, addr);
 	VM_BUG_ON(!pudp);
 
@@ -1121,14 +1139,23 @@ static int stage2_set_pud_huge(struct kvm *kvm, struct kvm_mmu_memory_cache *cac
 
 	/*
 	 * A large number of vcpus faulting on the same stage 2 entry,
-	 * can lead to a refault due to the
-	 * stage2_pud_clear()/tlb_flush(). Skip updating the page
-	 * tables if there is no change.
+	 * can lead to a refault due to the stage2_pud_clear()/tlb_flush().
+	 * Skip updating the page tables if there is no change.
 	 */
 	if (pud_val(old_pud) == pud_val(*new_pudp))
 		return 0;
 
 	if (stage2_pud_present(kvm, old_pud)) {
+		/*
+		 * If we already have table level mapping for this block, unmap
+		 * the range for this block and retry.
+		 */
+		if (!stage2_pud_huge(kvm, old_pud)) {
+			unmap_stage2_range(kvm, addr & S2_PUD_MASK, S2_PUD_SIZE);
+			goto retry;
+		}
+
+		WARN_ON_ONCE(kvm_pud_pfn(old_pud) != kvm_pud_pfn(*new_pudp));
 		stage2_pud_clear(kvm, pudp);
 		kvm_tlb_flush_vmid_ipa(kvm, addr);
 	} else {
-- 
2.20.1
