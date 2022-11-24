Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19B98C433FE
	for <kvmarm@archiver.kernel.org>; Thu, 24 Nov 2022 15:28:31 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A9E99407D9;
	Thu, 24 Nov 2022 10:28:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zeJjnO2uS7tF; Thu, 24 Nov 2022 10:28:29 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 65A7B407D6;
	Thu, 24 Nov 2022 10:28:29 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B979C40801
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Nov 2022 10:28:27 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id t1riii9knEb5 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Nov 2022 10:28:26 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 38CE14018F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Nov 2022 10:28:26 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5287F106F;
 Thu, 24 Nov 2022 07:28:32 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EE6193F73B;
 Thu, 24 Nov 2022 07:28:24 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: andrew.jones@linux.dev, kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 kvmarm@lists.cs.columbia.edu
Subject: [kvm-unit-tests PATCH v2 1/2] arm/arm64: mmu: Teach
 virt_to_pte_phys() about block descriptors
Date: Thu, 24 Nov 2022 15:28:15 +0000
Message-Id: <20221124152816.22305-2-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221124152816.22305-1-alexandru.elisei@arm.com>
References: <20221124152816.22305-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

The arm and arm64 architectures allow a virtual address to be mapped using
a block descriptor (or huge page, as Linux calls it), and the function
mmu_set_ranges_sect() is made available for a test to do just that. But
virt_to_pte_phys() assumes that all virtual addresses are mapped with page
granularity, which can lead to erroneous addresses being returned in the
case of block mappings.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 lib/arm/mmu.c | 89 +++++++++++++++++++++++++++++++--------------------
 1 file changed, 54 insertions(+), 35 deletions(-)

diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
index e1a72fe4941f..6022e356ddd4 100644
--- a/lib/arm/mmu.c
+++ b/lib/arm/mmu.c
@@ -111,10 +111,61 @@ pteval_t *install_page(pgd_t *pgtable, phys_addr_t phys, void *virt)
 				 __pgprot(PTE_WBWA | PTE_USER));
 }
 
-phys_addr_t virt_to_pte_phys(pgd_t *pgtable, void *mem)
+/*
+ * NOTE: The Arm architecture might require the use of a
+ * break-before-make sequence before making changes to a PTE and
+ * certain conditions are met (see Arm ARM D5-2669 for AArch64 and
+ * B3-1378 for AArch32 for more details).
+ */
+pteval_t *mmu_get_pte(pgd_t *pgtable, uintptr_t vaddr)
 {
-	return (*get_pte(pgtable, (uintptr_t)mem) & PHYS_MASK & -PAGE_SIZE)
-		+ ((ulong)mem & (PAGE_SIZE - 1));
+	pgd_t *pgd;
+	pud_t *pud;
+	pmd_t *pmd;
+	pte_t *pte;
+
+	if (!mmu_enabled())
+		return NULL;
+
+	pgd = pgd_offset(pgtable, vaddr);
+	if (!pgd_valid(*pgd))
+		return NULL;
+
+	pud = pud_offset(pgd, vaddr);
+	if (!pud_valid(*pud))
+		return NULL;
+
+	pmd = pmd_offset(pud, vaddr);
+	if (!pmd_valid(*pmd))
+		return NULL;
+	if (pmd_huge(*pmd))
+		return &pmd_val(*pmd);
+
+	pte = pte_offset(pmd, vaddr);
+	if (!pte_valid(*pte))
+		return NULL;
+
+        return &pte_val(*pte);
+}
+
+phys_addr_t virt_to_pte_phys(pgd_t *pgtable, void *virt)
+{
+	phys_addr_t mask;
+	pteval_t *pteval;
+
+	pteval = mmu_get_pte(pgtable, (uintptr_t)virt);
+	if (!pteval) {
+		install_page(pgtable, (phys_addr_t)(unsigned long)virt, virt);
+		return (phys_addr_t)(unsigned long)virt;
+	}
+
+	if (pmd_huge(__pmd(*pteval)))
+		mask = PMD_MASK;
+	else
+		mask = PAGE_MASK;
+
+	return (*pteval & PHYS_MASK & mask) |
+		((phys_addr_t)(unsigned long)virt & ~mask);
 }
 
 void mmu_set_range_ptes(pgd_t *pgtable, uintptr_t virt_offset,
@@ -231,38 +282,6 @@ unsigned long __phys_to_virt(phys_addr_t addr)
 	return addr;
 }
 
-/*
- * NOTE: The Arm architecture might require the use of a
- * break-before-make sequence before making changes to a PTE and
- * certain conditions are met (see Arm ARM D5-2669 for AArch64 and
- * B3-1378 for AArch32 for more details).
- */
-pteval_t *mmu_get_pte(pgd_t *pgtable, uintptr_t vaddr)
-{
-	pgd_t *pgd;
-	pud_t *pud;
-	pmd_t *pmd;
-	pte_t *pte;
-
-	if (!mmu_enabled())
-		return NULL;
-
-	pgd = pgd_offset(pgtable, vaddr);
-	assert(pgd_valid(*pgd));
-	pud = pud_offset(pgd, vaddr);
-	assert(pud_valid(*pud));
-	pmd = pmd_offset(pud, vaddr);
-	assert(pmd_valid(*pmd));
-
-	if (pmd_huge(*pmd))
-		return &pmd_val(*pmd);
-
-	pte = pte_offset(pmd, vaddr);
-	assert(pte_valid(*pte));
-
-        return &pte_val(*pte);
-}
-
 void mmu_clear_user(pgd_t *pgtable, unsigned long vaddr)
 {
 	pteval_t *p_pte = mmu_get_pte(pgtable, vaddr);
-- 
2.37.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
