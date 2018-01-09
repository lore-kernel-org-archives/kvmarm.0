From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v1 04/16] arm64: Refactor pud_huge for reusability
Date: Tue,  9 Jan 2018 19:03:59 +0000
Message-ID: <20180109190414.4017-5-suzuki.poulose@arm.com>
References: <20180109190414.4017-1-suzuki.poulose@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180109190414.4017-1-suzuki.poulose@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com, linux-kernel@vger.kernel.org, kristina.martsenko@arm.com, peter.maydell@linaro.org, suzuki.poulose@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com, will.deacon@arm.com, ard.biesheuvel@linaro.org, mark.rutland@arm.com, catalin.marinas@arm.com, Steve Capper <steve.capper@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Make pud_huge reusable for stage2 tables, independent
of the stage1 levels.

Cc: Steve Capper <steve.capper@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arch/arm64/include/asm/pgtable.h | 5 +++++
 arch/arm64/mm/hugetlbpage.c      | 2 +-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index a5a5203b603d..a1c6e93a1a11 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -469,6 +469,11 @@ static inline phys_addr_t pmd_page_paddr(pmd_t pmd)
 #define __raw_pud_bad(pud)		(!(pud_val((pud)) & PUD_TABLE_BIT))
 #define __raw_pud_present(pud)	pte_present(pud_pte((pud)))
 
+static inline int __raw_pud_huge(pud_t pud)
+{
+	return pud_val(pud) && !(pud_val(pud) & PUD_TABLE_BIT);
+}
+
 static inline void __raw_set_pud(pud_t *pudp, pud_t pud)
 {
 	*pudp = pud;
diff --git a/arch/arm64/mm/hugetlbpage.c b/arch/arm64/mm/hugetlbpage.c
index 6cb0fa92a651..a6bd5cc3d88b 100644
--- a/arch/arm64/mm/hugetlbpage.c
+++ b/arch/arm64/mm/hugetlbpage.c
@@ -35,7 +35,7 @@ int pmd_huge(pmd_t pmd)
 int pud_huge(pud_t pud)
 {
 #ifndef __PAGETABLE_PMD_FOLDED
-	return pud_val(pud) && !(pud_val(pud) & PUD_TABLE_BIT);
+	return __raw_pud_huge(pud);
 #else
 	return 0;
 #endif
-- 
2.13.6
