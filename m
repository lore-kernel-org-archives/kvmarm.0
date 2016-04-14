From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v2 16/17] kvm-arm: Cleanup stage2 pgd handling
Date: Thu, 14 Apr 2016 14:21:04 +0100
Message-ID: <1460640065-27658-17-git-send-email-suzuki.poulose@arm.com>
References: <1460640065-27658-1-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E88A49BA0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Apr 2016 09:20:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rBXE85wsFwFs for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 Apr 2016 09:20:20 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7247749B8C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Apr 2016 09:20:19 -0400 (EDT)
In-Reply-To: <1460640065-27658-1-git-send-email-suzuki.poulose@arm.com>
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
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Now that we don't have any fake page table levels for arm64,
cleanup the common code to get rid of the dead code.

Cc: Marc Zyngier <marc.zyngier@arm.com>
Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>

---
Changes since V1:
 - Un-inline kvm_alloc_hwpgd(), kvm_get_hwpgd_size()
---
 arch/arm/include/asm/kvm_mmu.h   |   19 -------------------
 arch/arm/kvm/arm.c               |    2 +-
 arch/arm/kvm/mmu.c               |   37 ++++++-------------------------------
 arch/arm64/include/asm/kvm_mmu.h |   18 ------------------
 4 files changed, 7 insertions(+), 69 deletions(-)

diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
index 50aa901..f8b7920 100644
--- a/arch/arm/include/asm/kvm_mmu.h
+++ b/arch/arm/include/asm/kvm_mmu.h
@@ -146,25 +146,6 @@ static inline bool kvm_page_empty(void *ptr)
 #define hyp_pmd_table_empty(pmdp) kvm_page_empty(pmdp)
 #define hyp_pud_table_empty(pudp) (0)
 
-static inline void *kvm_get_hwpgd(struct kvm *kvm)
-{
-	return kvm->arch.pgd;
-}
-
-static inline unsigned int kvm_get_hwpgd_size(void)
-{
-	return PTRS_PER_S2_PGD * sizeof(pgd_t);
-}
-
-static inline pgd_t *kvm_setup_fake_pgd(pgd_t *hwpgd)
-{
-	return hwpgd;
-}
-
-static inline void kvm_free_fake_pgd(pgd_t *pgd)
-{
-}
-
 struct kvm;
 
 #define kvm_flush_dcache_to_poc(a,l)	__cpuc_flush_dcache_area((a), (l))
diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index dded1b7..be4b639 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -448,7 +448,7 @@ static void update_vttbr(struct kvm *kvm)
 	kvm_next_vmid &= (1 << kvm_vmid_bits) - 1;
 
 	/* update vttbr to be used with the new vmid */
-	pgd_phys = virt_to_phys(kvm_get_hwpgd(kvm));
+	pgd_phys = virt_to_phys(kvm->arch.pgd);
 	BUG_ON(pgd_phys & ~VTTBR_BADDR_MASK);
 	vmid = ((u64)(kvm->arch.vmid) << VTTBR_VMID_SHIFT) & VTTBR_VMID_MASK(kvm_vmid_bits);
 	kvm->arch.vttbr = pgd_phys | vmid;
diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
index d3fa96e..42eefab 100644
--- a/arch/arm/kvm/mmu.c
+++ b/arch/arm/kvm/mmu.c
@@ -43,6 +43,7 @@ static unsigned long hyp_idmap_start;
 static unsigned long hyp_idmap_end;
 static phys_addr_t hyp_idmap_vector;
 
+#define S2_PGD_SIZE	(PTRS_PER_S2_PGD * sizeof(pgd_t))
 #define hyp_pgd_order get_order(PTRS_PER_PGD * sizeof(pgd_t))
 
 #define KVM_S2PTE_FLAG_IS_IOMAP		(1UL << 0)
@@ -736,20 +737,6 @@ int create_hyp_io_mappings(void *from, void *to, phys_addr_t phys_addr)
 				     __phys_to_pfn(phys_addr), PAGE_HYP_DEVICE);
 }
 
-/* Free the HW pgd, one page at a time */
-static void kvm_free_hwpgd(void *hwpgd)
-{
-	free_pages_exact(hwpgd, kvm_get_hwpgd_size());
-}
-
-/* Allocate the HW PGD, making sure that each page gets its own refcount */
-static void *kvm_alloc_hwpgd(void)
-{
-	unsigned int size = kvm_get_hwpgd_size();
-
-	return alloc_pages_exact(size, GFP_KERNEL | __GFP_ZERO);
-}
-
 /**
  * kvm_alloc_stage2_pgd - allocate level-1 table for stage-2 translation.
  * @kvm:	The KVM struct pointer for the VM.
@@ -764,29 +751,17 @@ static void *kvm_alloc_hwpgd(void)
 int kvm_alloc_stage2_pgd(struct kvm *kvm)
 {
 	pgd_t *pgd;
-	void *hwpgd;
 
 	if (kvm->arch.pgd != NULL) {
 		kvm_err("kvm_arch already initialized?\n");
 		return -EINVAL;
 	}
 
-	hwpgd = kvm_alloc_hwpgd();
-	if (!hwpgd)
+	/* Allocate the HW PGD, making sure that each page gets its own refcount */
+	pgd = alloc_pages_exact(S2_PGD_SIZE, GFP_KERNEL | __GFP_ZERO);
+	if (!pgd)
 		return -ENOMEM;
 
-	/*
-	 * When the kernel uses more levels of page tables than the
-	 * guest, we allocate a fake PGD and pre-populate it to point
-	 * to the next-level page table, which will be the real
-	 * initial page table pointed to by the VTTBR.
-	 */
-	pgd = kvm_setup_fake_pgd(hwpgd);
-	if (IS_ERR(pgd)) {
-		kvm_free_hwpgd(hwpgd);
-		return PTR_ERR(pgd);
-	}
-
 	kvm_clean_pgd(pgd);
 	kvm->arch.pgd = pgd;
 	return 0;
@@ -874,8 +849,8 @@ void kvm_free_stage2_pgd(struct kvm *kvm)
 		return;
 
 	unmap_stage2_range(kvm, 0, KVM_PHYS_SIZE);
-	kvm_free_hwpgd(kvm_get_hwpgd(kvm));
-	kvm_free_fake_pgd(kvm->arch.pgd);
+	/* Free the HW pgd, one page at a time */
+	free_pages_exact(kvm->arch.pgd, S2_PGD_SIZE);
 	kvm->arch.pgd = NULL;
 }
 
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index e3fee0a..249c4fc 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -141,24 +141,6 @@ static inline bool kvm_s2pmd_readonly(pmd_t *pmd)
 	return (pmd_val(*pmd) & PMD_S2_RDWR) == PMD_S2_RDONLY;
 }
 
-static inline void *kvm_get_hwpgd(struct kvm *kvm)
-{
-	return kvm->arch.pgd;
-}
-
-static inline unsigned int kvm_get_hwpgd_size(void)
-{
-	return PTRS_PER_S2_PGD * sizeof(pgd_t);
-}
-
-static inline pgd_t *kvm_setup_fake_pgd(pgd_t *hwpgd)
-{
-	return hwpgd;
-}
-
-static inline void kvm_free_fake_pgd(pgd_t *pgd)
-{
-}
 static inline bool kvm_page_empty(void *ptr)
 {
 	struct page *ptr_page = virt_to_page(ptr);
-- 
1.7.9.5
