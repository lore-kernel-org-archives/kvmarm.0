From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v3 4/6] KVM: arm/arm64: Consolidate page-table accessors
Date: Wed, 27 Jun 2018 13:20:56 +0100
Message-ID: <20180627122058.8210-5-marc.zyngier@arm.com>
References: <20180627122058.8210-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 628AD4A129
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Jun 2018 08:09:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id urSBn4cBdtPn for <kvmarm@lists.cs.columbia.edu>;
 Wed, 27 Jun 2018 08:09:00 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F1BE4A114
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Jun 2018 08:09:00 -0400 (EDT)
In-Reply-To: <20180627122058.8210-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

The arm and arm64 KVM page tables accessors are pointlessly different
between the two architectures, and likely both wrong one way or another:
arm64 lacks a dsb(), and arm doesn't use WRITE_ONCE.

Let's unify them.

Acked-by: Mark Rutland <mark.rutland@arm.com>
Acked-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/include/asm/kvm_mmu.h   | 12 -----------
 arch/arm64/include/asm/kvm_mmu.h |  3 ---
 virt/kvm/arm/mmu.c               | 35 ++++++++++++++++++++++++++++----
 3 files changed, 31 insertions(+), 19 deletions(-)

diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
index 8553d68b7c8a..b2feaea1434c 100644
--- a/arch/arm/include/asm/kvm_mmu.h
+++ b/arch/arm/include/asm/kvm_mmu.h
@@ -75,18 +75,6 @@ phys_addr_t kvm_get_idmap_vector(void);
 int kvm_mmu_init(void);
 void kvm_clear_hyp_idmap(void);
 
-static inline void kvm_set_pmd(pmd_t *pmd, pmd_t new_pmd)
-{
-	*pmd = new_pmd;
-	dsb(ishst);
-}
-
-static inline void kvm_set_pte(pte_t *pte, pte_t new_pte)
-{
-	*pte = new_pte;
-	dsb(ishst);
-}
-
 static inline pte_t kvm_s2pte_mkwrite(pte_t pte)
 {
 	pte_val(pte) |= L_PTE_S2_RDWR;
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 620eb9e06bd8..25c9a91f6a87 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -169,9 +169,6 @@ phys_addr_t kvm_get_idmap_vector(void);
 int kvm_mmu_init(void);
 void kvm_clear_hyp_idmap(void);
 
-#define	kvm_set_pte(ptep, pte)		set_pte(ptep, pte)
-#define	kvm_set_pmd(pmdp, pmd)		set_pmd(pmdp, pmd)
-
 static inline pte_t kvm_s2pte_mkwrite(pte_t pte)
 {
 	pte_val(pte) |= PTE_S2_RDWR;
diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index ea7314296ad1..87d5c91b9b6a 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -177,6 +177,33 @@ static void clear_stage2_pmd_entry(struct kvm *kvm, pmd_t *pmd, phys_addr_t addr
 	put_page(virt_to_page(pmd));
 }
 
+static inline void kvm_set_pte(pte_t *ptep, pte_t new_pte)
+{
+	WRITE_ONCE(*ptep, new_pte);
+	dsb(ishst);
+}
+
+static inline void kvm_set_pmd(pmd_t *pmdp, pmd_t new_pmd)
+{
+	WRITE_ONCE(*pmdp, new_pmd);
+	dsb(ishst);
+}
+
+static inline void kvm_pmd_populate(pmd_t *pmdp, pte_t *ptep)
+{
+	pmd_populate_kernel(NULL, pmdp, ptep);
+}
+
+static inline void kvm_pud_populate(pud_t *pudp, pmd_t *pmdp)
+{
+	pud_populate(NULL, pudp, pmdp);
+}
+
+static inline void kvm_pgd_populate(pgd_t *pgdp, pud_t *pudp)
+{
+	pgd_populate(NULL, pgdp, pudp);
+}
+
 /*
  * Unmapping vs dcache management:
  *
@@ -605,7 +632,7 @@ static int create_hyp_pmd_mappings(pud_t *pud, unsigned long start,
 				kvm_err("Cannot allocate Hyp pte\n");
 				return -ENOMEM;
 			}
-			pmd_populate_kernel(NULL, pmd, pte);
+			kvm_pmd_populate(pmd, pte);
 			get_page(virt_to_page(pmd));
 			kvm_flush_dcache_to_poc(pmd, sizeof(*pmd));
 		}
@@ -638,7 +665,7 @@ static int create_hyp_pud_mappings(pgd_t *pgd, unsigned long start,
 				kvm_err("Cannot allocate Hyp pmd\n");
 				return -ENOMEM;
 			}
-			pud_populate(NULL, pud, pmd);
+			kvm_pud_populate(pud, pmd);
 			get_page(virt_to_page(pud));
 			kvm_flush_dcache_to_poc(pud, sizeof(*pud));
 		}
@@ -675,7 +702,7 @@ static int __create_hyp_mappings(pgd_t *pgdp, unsigned long ptrs_per_pgd,
 				err = -ENOMEM;
 				goto out;
 			}
-			pgd_populate(NULL, pgd, pud);
+			kvm_pgd_populate(pgd, pud);
 			get_page(virt_to_page(pgd));
 			kvm_flush_dcache_to_poc(pgd, sizeof(*pgd));
 		}
@@ -1094,7 +1121,7 @@ static int stage2_set_pte(struct kvm *kvm, struct kvm_mmu_memory_cache *cache,
 		if (!cache)
 			return 0; /* ignore calls from kvm_set_spte_hva */
 		pte = mmu_memory_cache_alloc(cache);
-		pmd_populate_kernel(NULL, pmd, pte);
+		kvm_pmd_populate(pmd, pte);
 		get_page(virt_to_page(pmd));
 	}
 
-- 
2.17.1
