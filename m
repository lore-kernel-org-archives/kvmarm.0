From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v4 5/6] KVM: arm/arm64: Stop using the kernel's {pmd, pud,
 pgd}_populate helpers
Date: Mon,  2 Jul 2018 16:02:49 +0100
Message-ID: <20180702150250.16550-6-marc.zyngier@arm.com>
References: <20180702150250.16550-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1FEFC4A0F0
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Jul 2018 10:51:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jSB6vyFWw3Ny for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 Jul 2018 10:50:47 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E0C824A0E1
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Jul 2018 10:50:46 -0400 (EDT)
In-Reply-To: <20180702150250.16550-1-marc.zyngier@arm.com>
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

The {pmd,pud,pgd}_populate accessors usage have always been a bit weird
in KVM. We don't have a struct mm to pass (and neither does the kernel
most of the time, but still...), and the 32bit code has all kind of
cache maintenance that doesn't make sense on ARMv7+ when MP extensions
are mandatory (which is the case when the VEs are present).

Let's bite the bullet and provide our own implementations. The only bit
of architectural code left has to do with building the table entry
itself (arm64 having up to 52bit PA, arm lacking PUD level).

Acked-by: Mark Rutland <mark.rutland@arm.com>
Acked-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/include/asm/kvm_mmu.h   |  4 ++++
 arch/arm64/include/asm/kvm_mmu.h |  7 +++++++
 virt/kvm/arm/mmu.c               | 25 +++++++++++++++++++++----
 3 files changed, 32 insertions(+), 4 deletions(-)

diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
index b2feaea1434c..265ea9cf7df7 100644
--- a/arch/arm/include/asm/kvm_mmu.h
+++ b/arch/arm/include/asm/kvm_mmu.h
@@ -75,6 +75,10 @@ phys_addr_t kvm_get_idmap_vector(void);
 int kvm_mmu_init(void);
 void kvm_clear_hyp_idmap(void);
 
+#define kvm_mk_pmd(ptep)	__pmd(__pa(ptep) | PMD_TYPE_TABLE)
+#define kvm_mk_pud(pmdp)	__pud(__pa(pmdp) | PMD_TYPE_TABLE)
+#define kvm_mk_pgd(pudp)	({ BUILD_BUG(); 0; })
+
 static inline pte_t kvm_s2pte_mkwrite(pte_t pte)
 {
 	pte_val(pte) |= L_PTE_S2_RDWR;
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index ea000fb47ec0..d6fff7de5539 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -169,6 +169,13 @@ phys_addr_t kvm_get_idmap_vector(void);
 int kvm_mmu_init(void);
 void kvm_clear_hyp_idmap(void);
 
+#define kvm_mk_pmd(ptep)					\
+	__pmd(__phys_to_pmd_val(__pa(ptep)) | PMD_TYPE_TABLE)
+#define kvm_mk_pud(pmdp)					\
+	__pud(__phys_to_pud_val(__pa(pmdp)) | PMD_TYPE_TABLE)
+#define kvm_mk_pgd(pudp)					\
+	__pgd(__phys_to_pgd_val(__pa(pudp)) | PUD_TYPE_TABLE)
+
 static inline pte_t kvm_s2pte_mkwrite(pte_t pte)
 {
 	pte_val(pte) |= PTE_S2_RDWR;
diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index a6bdbed1903a..eade30caaa3c 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -189,6 +189,23 @@ static inline void kvm_set_pmd(pmd_t *pmdp, pmd_t new_pmd)
 	dsb(ishst);
 }
 
+static inline void kvm_pmd_populate(pmd_t *pmdp, pte_t *ptep)
+{
+	kvm_set_pmd(pmdp, kvm_mk_pmd(ptep));
+}
+
+static inline void kvm_pud_populate(pud_t *pudp, pmd_t *pmdp)
+{
+	WRITE_ONCE(*pudp, kvm_mk_pud(pmdp));
+	dsb(ishst);
+}
+
+static inline void kvm_pgd_populate(pgd_t *pgdp, pud_t *pudp)
+{
+	WRITE_ONCE(*pgdp, kvm_mk_pgd(pudp));
+	dsb(ishst);
+}
+
 /*
  * Unmapping vs dcache management:
  *
@@ -617,7 +634,7 @@ static int create_hyp_pmd_mappings(pud_t *pud, unsigned long start,
 				kvm_err("Cannot allocate Hyp pte\n");
 				return -ENOMEM;
 			}
-			pmd_populate_kernel(NULL, pmd, pte);
+			kvm_pmd_populate(pmd, pte);
 			get_page(virt_to_page(pmd));
 			kvm_flush_dcache_to_poc(pmd, sizeof(*pmd));
 		}
@@ -650,7 +667,7 @@ static int create_hyp_pud_mappings(pgd_t *pgd, unsigned long start,
 				kvm_err("Cannot allocate Hyp pmd\n");
 				return -ENOMEM;
 			}
-			pud_populate(NULL, pud, pmd);
+			kvm_pud_populate(pud, pmd);
 			get_page(virt_to_page(pud));
 			kvm_flush_dcache_to_poc(pud, sizeof(*pud));
 		}
@@ -687,7 +704,7 @@ static int __create_hyp_mappings(pgd_t *pgdp, unsigned long ptrs_per_pgd,
 				err = -ENOMEM;
 				goto out;
 			}
-			pgd_populate(NULL, pgd, pud);
+			kvm_pgd_populate(pgd, pud);
 			get_page(virt_to_page(pgd));
 			kvm_flush_dcache_to_poc(pgd, sizeof(*pgd));
 		}
@@ -1106,7 +1123,7 @@ static int stage2_set_pte(struct kvm *kvm, struct kvm_mmu_memory_cache *cache,
 		if (!cache)
 			return 0; /* ignore calls from kvm_set_spte_hva */
 		pte = mmu_memory_cache_alloc(cache);
-		pmd_populate_kernel(NULL, pmd, pte);
+		kvm_pmd_populate(pmd, pte);
 		get_page(virt_to_page(pmd));
 	}
 
-- 
2.17.1
