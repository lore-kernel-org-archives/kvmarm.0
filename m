From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v2 04/17] arm64: Refactor pud_huge for reusability
Date: Tue, 27 Mar 2018 14:15:14 +0100
Message-ID: <1522156531-28348-5-git-send-email-suzuki.poulose@arm.com>
References: <1522156531-28348-1-git-send-email-suzuki.poulose@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1522156531-28348-1-git-send-email-suzuki.poulose@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, cdall@kernel.org, marc.zyngier@arm.com, punit.agrawal@arm.com, will.deacon@arm.com, catalin.marinas@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com, ard.biesheuvel@linaro.org, peter.maydell@linaro.org, kristina.martsenko@arm.com, mark.rutland@arm.com, Suzuki K Poulose <suzuki.poulose@arm.com>, Steve Capper <steve.capper@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Make pud_huge reusable for stage2 tables, independent
of the stage1 levels.

Cc: Steve Capper <steve.capper@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christoffer Dall <cdall@kernel.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arch/arm64/include/asm/pgtable.h | 5 +++++
 arch/arm64/mm/hugetlbpage.c      | 2 +-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 5e22503..4a16c11 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -479,6 +479,11 @@ static inline phys_addr_t pmd_page_paddr(pmd_t pmd)
 #define __raw_pud_bad(pud)	(!(pud_val(pud) & PUD_TABLE_BIT))
 #define __raw_pud_present(pud)	pte_present(pud_pte(pud))
 
+static inline int __raw_pud_huge(pud_t pud)
+{
+	return pud_val(pud) && !(pud_val(pud) & PUD_TABLE_BIT);
+}
+
 static inline void __raw_set_pud(pud_t *pudp, pud_t pud)
 {
 	WRITE_ONCE(*pudp, pud);
diff --git a/arch/arm64/mm/hugetlbpage.c b/arch/arm64/mm/hugetlbpage.c
index ecc6818..3f4bb43 100644
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
2.7.4
