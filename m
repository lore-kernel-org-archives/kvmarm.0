Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20A932F25
	for <kvmarm@lists.linux.dev>; Thu, 24 Nov 2022 15:28:33 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5287F106F;
	Thu, 24 Nov 2022 07:28:32 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EE6193F73B;
	Thu, 24 Nov 2022 07:28:24 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: andrew.jones@linux.dev,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	kvmarm@lists.cs.columbia.edu
Subject: [kvm-unit-tests PATCH v2 1/2] arm/arm64: mmu: Teach virt_to_pte_phys() about block descriptors
Date: Thu, 24 Nov 2022 15:28:15 +0000
Message-ID: <20221124152816.22305-2-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221124152816.22305-1-alexandru.elisei@arm.com>
References: <20221124152816.22305-1-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Message-ID: <20221124152815.rzVDqSoF_Tcti5wEk0SU04jaow9pWBaavl3au4dm6C8@z>

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

