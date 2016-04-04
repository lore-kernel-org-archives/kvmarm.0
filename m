From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 03/17] kvm arm: Move fake PGD handling to arch specific files
Date: Mon,  4 Apr 2016 17:26:03 +0100
Message-ID: <1459787177-12767-4-git-send-email-suzuki.poulose@arm.com>
References: <1459787177-12767-1-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 530F740B58
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Apr 2016 12:25:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nwB0HVfpzCPG for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Apr 2016 12:25:35 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A09B540BDA
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Apr 2016 12:25:33 -0400 (EDT)
In-Reply-To: <1459787177-12767-1-git-send-email-suzuki.poulose@arm.com>
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

Rearrange the code for fake pgd handling, which is applicable
only for arm64. This will later be removed once we introduce
the stage2 page table walker macros.

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arch/arm/include/asm/kvm_mmu.h   |   11 +++++++--
 arch/arm/kvm/mmu.c               |   47 ++++++--------------------------------
 arch/arm64/include/asm/kvm_mmu.h |   43 ++++++++++++++++++++++++++++++++++
 3 files changed, 59 insertions(+), 42 deletions(-)

diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
index da44be9..c2b2b27 100644
--- a/arch/arm/include/asm/kvm_mmu.h
+++ b/arch/arm/include/asm/kvm_mmu.h
@@ -161,8 +161,6 @@ static inline bool kvm_page_empty(void *ptr)
 #define kvm_pmd_table_empty(kvm, pmdp) kvm_page_empty(pmdp)
 #define kvm_pud_table_empty(kvm, pudp) (0)
 
-#define KVM_PREALLOC_LEVEL	0
-
 static inline void *kvm_get_hwpgd(struct kvm *kvm)
 {
 	return kvm->arch.pgd;
@@ -173,6 +171,15 @@ static inline unsigned int kvm_get_hwpgd_size(void)
 	return PTRS_PER_S2_PGD * sizeof(pgd_t);
 }
 
+static inline pgd_t *kvm_setup_fake_pgd(pgd_t *hwpgd)
+{
+	return hwpgd;
+}
+
+static inline void kvm_free_fake_pgd(pgd_t *pgd)
+{
+}
+
 struct kvm;
 
 #define kvm_flush_dcache_to_poc(a,l)	__cpuc_flush_dcache_area((a), (l))
diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
index 58dbd5c..774d00b 100644
--- a/arch/arm/kvm/mmu.c
+++ b/arch/arm/kvm/mmu.c
@@ -684,47 +684,16 @@ int kvm_alloc_stage2_pgd(struct kvm *kvm)
 	if (!hwpgd)
 		return -ENOMEM;
 
-	/* When the kernel uses more levels of page tables than the
+	/*
+	 * When the kernel uses more levels of page tables than the
 	 * guest, we allocate a fake PGD and pre-populate it to point
 	 * to the next-level page table, which will be the real
 	 * initial page table pointed to by the VTTBR.
-	 *
-	 * When KVM_PREALLOC_LEVEL==2, we allocate a single page for
-	 * the PMD and the kernel will use folded pud.
-	 * When KVM_PREALLOC_LEVEL==1, we allocate 2 consecutive PUD
-	 * pages.
 	 */
-	if (KVM_PREALLOC_LEVEL > 0) {
-		int i;
-
-		/*
-		 * Allocate fake pgd for the page table manipulation macros to
-		 * work.  This is not used by the hardware and we have no
-		 * alignment requirement for this allocation.
-		 */
-		pgd = kmalloc(PTRS_PER_S2_PGD * sizeof(pgd_t),
-				GFP_KERNEL | __GFP_ZERO);
-
-		if (!pgd) {
-			kvm_free_hwpgd(hwpgd);
-			return -ENOMEM;
-		}
-
-		/* Plug the HW PGD into the fake one. */
-		for (i = 0; i < PTRS_PER_S2_PGD; i++) {
-			if (KVM_PREALLOC_LEVEL == 1)
-				pgd_populate(NULL, pgd + i,
-					     (pud_t *)hwpgd + i * PTRS_PER_PUD);
-			else if (KVM_PREALLOC_LEVEL == 2)
-				pud_populate(NULL, pud_offset(pgd, 0) + i,
-					     (pmd_t *)hwpgd + i * PTRS_PER_PMD);
-		}
-	} else {
-		/*
-		 * Allocate actual first-level Stage-2 page table used by the
-		 * hardware for Stage-2 page table walks.
-		 */
-		pgd = (pgd_t *)hwpgd;
+	pgd = kvm_setup_fake_pgd(hwpgd);
+	if (IS_ERR(pgd)) {
+		kvm_free_hwpgd(hwpgd);
+		return PTR_ERR(pgd);
 	}
 
 	kvm_clean_pgd(pgd);
@@ -831,9 +800,7 @@ void kvm_free_stage2_pgd(struct kvm *kvm)
 
 	unmap_stage2_range(kvm, 0, KVM_PHYS_SIZE);
 	kvm_free_hwpgd(kvm_get_hwpgd(kvm));
-	if (KVM_PREALLOC_LEVEL > 0)
-		kfree(kvm->arch.pgd);
-
+	kvm_free_fake_pgd(kvm->arch.pgd);
 	kvm->arch.pgd = NULL;
 }
 
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 22732a5..9a3409f 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -208,6 +208,49 @@ static inline unsigned int kvm_get_hwpgd_size(void)
 	return PTRS_PER_S2_PGD * sizeof(pgd_t);
 }
 
+/*
+ * Allocate fake pgd for the host kernel page table macros to work.
+ * This is not used by the hardware and we have no alignment
+ * requirement for this allocation.
+ */
+static inline pgd_t *kvm_setup_fake_pgd(pgd_t *hwpgd)
+{
+	int i;
+	pgd_t *pgd;
+
+	if (!KVM_PREALLOC_LEVEL)
+		return hwpgd;
+
+	/*
+	 * When KVM_PREALLOC_LEVEL==2, we allocate a single page for
+	 * the PMD and the kernel will use folded pud.
+	 * When KVM_PREALLOC_LEVEL==1, we allocate 2 consecutive PUD
+	 * pages.
+	 */
+
+	pgd = kmalloc(PTRS_PER_S2_PGD * sizeof(pgd_t),
+			GFP_KERNEL | __GFP_ZERO);
+	if (!pgd)
+		return ERR_PTR(-ENOMEM);
+
+	/* Plug the HW PGD into the fake one. */
+	for (i = 0; i < PTRS_PER_S2_PGD; i++) {
+		if (KVM_PREALLOC_LEVEL == 1)
+			pgd_populate(NULL, pgd + i,
+				     (pud_t *)hwpgd + i * PTRS_PER_PUD);
+		else if (KVM_PREALLOC_LEVEL == 2)
+			pud_populate(NULL, pud_offset(pgd, 0) + i,
+				     (pmd_t *)hwpgd + i * PTRS_PER_PMD);
+	}
+
+	return pgd;
+}
+
+static inline void kvm_free_fake_pgd(pgd_t *pgd)
+{
+	if (KVM_PREALLOC_LEVEL > 0)
+		kfree(pgd);
+}
 static inline bool kvm_page_empty(void *ptr)
 {
 	struct page *ptr_page = virt_to_page(ptr);
-- 
1.7.9.5
