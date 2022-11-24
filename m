Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29288C43217
	for <kvmarm@archiver.kernel.org>; Thu, 24 Nov 2022 15:28:33 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C27D44079D;
	Thu, 24 Nov 2022 10:28:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1Mo1kXTs36AV; Thu, 24 Nov 2022 10:28:31 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7EF8B40834;
	Thu, 24 Nov 2022 10:28:31 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AA9504079D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Nov 2022 10:28:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id itVRL8IBwool for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Nov 2022 10:28:28 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 65BF9403DF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Nov 2022 10:28:27 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 712681516;
 Thu, 24 Nov 2022 07:28:33 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1834D3F73B;
 Thu, 24 Nov 2022 07:28:25 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: andrew.jones@linux.dev, kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 kvmarm@lists.cs.columbia.edu
Subject: [kvm-unit-tests PATCH v2 2/2] arm/arm64: mmu: Rename mmu_get_pte() ->
 follow_pte()
Date: Thu, 24 Nov 2022 15:28:16 +0000
Message-Id: <20221124152816.22305-3-alexandru.elisei@arm.com>
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

The function get_pte() from mmu.c returns a pointer to the PTE
associated with the requested virtual address, mapping the virtual
address in the process if it's not already mapped.

mmu_get_pte() returns a pointer to the PTE if and only if the virtual is
mapped in pgtable, otherwise returns NULL. Rename it to follow_pte() to
avoid any confusion with get_pte(). follow_pte() also matches the name
of Linux kernel function with a similar purpose.

Also remove the mmu_enabled() check from the function, as the purpose of
the function is to get the mapping for the virtual address in the pgtable
supplied as the argument, not to translate the virtual address to a
physical address using the current translation; that's what
virt_to_phys() does.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 lib/arm/asm/mmu-api.h | 2 +-
 lib/arm/mmu.c         | 9 +++------
 2 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/lib/arm/asm/mmu-api.h b/lib/arm/asm/mmu-api.h
index 3d77cbfd8b24..6c1136d957f9 100644
--- a/lib/arm/asm/mmu-api.h
+++ b/lib/arm/asm/mmu-api.h
@@ -17,6 +17,6 @@ extern void mmu_set_range_sect(pgd_t *pgtable, uintptr_t virt_offset,
 extern void mmu_set_range_ptes(pgd_t *pgtable, uintptr_t virt_offset,
 			       phys_addr_t phys_start, phys_addr_t phys_end,
 			       pgprot_t prot);
-extern pteval_t *mmu_get_pte(pgd_t *pgtable, uintptr_t vaddr);
+extern pteval_t *follow_pte(pgd_t *pgtable, uintptr_t vaddr);
 extern void mmu_clear_user(pgd_t *pgtable, unsigned long vaddr);
 #endif
diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
index 6022e356ddd4..18e32b2b8927 100644
--- a/lib/arm/mmu.c
+++ b/lib/arm/mmu.c
@@ -117,16 +117,13 @@ pteval_t *install_page(pgd_t *pgtable, phys_addr_t phys, void *virt)
  * certain conditions are met (see Arm ARM D5-2669 for AArch64 and
  * B3-1378 for AArch32 for more details).
  */
-pteval_t *mmu_get_pte(pgd_t *pgtable, uintptr_t vaddr)
+pteval_t *follow_pte(pgd_t *pgtable, uintptr_t vaddr)
 {
 	pgd_t *pgd;
 	pud_t *pud;
 	pmd_t *pmd;
 	pte_t *pte;
 
-	if (!mmu_enabled())
-		return NULL;
-
 	pgd = pgd_offset(pgtable, vaddr);
 	if (!pgd_valid(*pgd))
 		return NULL;
@@ -153,7 +150,7 @@ phys_addr_t virt_to_pte_phys(pgd_t *pgtable, void *virt)
 	phys_addr_t mask;
 	pteval_t *pteval;
 
-	pteval = mmu_get_pte(pgtable, (uintptr_t)virt);
+	pteval = follow_pte(pgtable, (uintptr_t)virt);
 	if (!pteval) {
 		install_page(pgtable, (phys_addr_t)(unsigned long)virt, virt);
 		return (phys_addr_t)(unsigned long)virt;
@@ -284,7 +281,7 @@ unsigned long __phys_to_virt(phys_addr_t addr)
 
 void mmu_clear_user(pgd_t *pgtable, unsigned long vaddr)
 {
-	pteval_t *p_pte = mmu_get_pte(pgtable, vaddr);
+	pteval_t *p_pte = follow_pte(pgtable, vaddr);
 	if (p_pte) {
 		pteval_t entry = *p_pte & ~PTE_USER;
 		WRITE_ONCE(*p_pte, entry);
-- 
2.37.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
