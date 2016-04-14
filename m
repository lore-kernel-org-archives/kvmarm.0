From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v2 12/17] kvm-arm: Add explicit hyp page table modifiers
Date: Thu, 14 Apr 2016 14:21:00 +0100
Message-ID: <1460640065-27658-13-git-send-email-suzuki.poulose@arm.com>
References: <1460640065-27658-1-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ECFB549BA0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Apr 2016 09:20:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YaBjr4ukYSIn for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 Apr 2016 09:20:13 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BE43E49B87
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Apr 2016 09:20:11 -0400 (EDT)
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

We have common routines to modify hyp and stage2 page tables
based on the 'kvm' parameter. For a smoother transition to
using separate routines for each, duplicate the routines
and modify the copy to work on hyp.

Marks the forked routines with _hyp_ and gets rid of the
kvm parameter which is no longer needed and is NULL for hyp.
Also, gets rid of calls to kvm_tlb_flush_by_vmid_ipa() calls
from the hyp versions. Uses explicit host page table accessors
instead of the kvm_* page table helpers.

Suggested-by: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
Changes since V1:
 - Remove flush_dcache for !device_pfns in unmap_hyp_ptes()
 - Remove huge pmd/pud checks in unmap_hyp_p.ds, since we don't
   use huge mappings
 - Add a comment in unmap_hyp_range() on why we don't invalidate
   TLBs.
---
 arch/arm/kvm/mmu.c |  104 +++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 99 insertions(+), 5 deletions(-)

diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
index f93f717..af526f6 100644
--- a/arch/arm/kvm/mmu.c
+++ b/arch/arm/kvm/mmu.c
@@ -388,6 +388,100 @@ static void stage2_flush_vm(struct kvm *kvm)
 	srcu_read_unlock(&kvm->srcu, idx);
 }
 
+static void clear_hyp_pgd_entry(pgd_t *pgd)
+{
+	pud_t *pud_table __maybe_unused = pud_offset(pgd, 0UL);
+	pgd_clear(pgd);
+	pud_free(NULL, pud_table);
+	put_page(virt_to_page(pgd));
+}
+
+static void clear_hyp_pud_entry(pud_t *pud)
+{
+	pmd_t *pmd_table __maybe_unused = pmd_offset(pud, 0);
+	VM_BUG_ON(pud_huge(*pud));
+	pud_clear(pud);
+	pmd_free(NULL, pmd_table);
+	put_page(virt_to_page(pud));
+}
+
+static void clear_hyp_pmd_entry(pmd_t *pmd)
+{
+	pte_t *pte_table = pte_offset_kernel(pmd, 0);
+	VM_BUG_ON(pmd_thp_or_huge(*pmd));
+	pmd_clear(pmd);
+	pte_free_kernel(NULL, pte_table);
+	put_page(virt_to_page(pmd));
+}
+
+static void unmap_hyp_ptes(pmd_t *pmd, phys_addr_t addr, phys_addr_t end)
+{
+	pte_t *pte, *start_pte;
+
+	start_pte = pte = pte_offset_kernel(pmd, addr);
+	do {
+		if (!pte_none(*pte)) {
+			kvm_set_pte(pte, __pte(0));
+			put_page(virt_to_page(pte));
+		}
+	} while (pte++, addr += PAGE_SIZE, addr != end);
+
+	if (hyp_pte_table_empty(start_pte))
+		clear_hyp_pmd_entry(pmd);
+}
+
+static void unmap_hyp_pmds(pud_t *pud, phys_addr_t addr, phys_addr_t end)
+{
+	phys_addr_t next;
+	pmd_t *pmd, *start_pmd;
+
+	start_pmd = pmd = pmd_offset(pud, addr);
+	do {
+		next = pmd_addr_end(addr, end);
+		/* Hyp doesn't use huge pmds */
+		if (!pmd_none(*pmd))
+			unmap_hyp_ptes(pmd, addr, next);
+	} while (pmd++, addr = next, addr != end);
+
+	if (hyp_pmd_table_empty(start_pmd))
+		clear_hyp_pud_entry(pud);
+}
+
+static void unmap_hyp_puds(pgd_t *pgd, phys_addr_t addr, phys_addr_t end)
+{
+	phys_addr_t next;
+	pud_t *pud, *start_pud;
+
+	start_pud = pud = pud_offset(pgd, addr);
+	do {
+		next = pud_addr_end(addr, end);
+		/* Hyp doesn't use huge puds */
+		if (!pud_none(*pud))
+			unmap_hyp_pmds(pud, addr, next);
+	} while (pud++, addr = next, addr != end);
+
+	if (hyp_pud_table_empty(start_pud))
+		clear_hyp_pgd_entry(pgd);
+}
+
+static void unmap_hyp_range(pgd_t *pgdp, phys_addr_t start, u64 size)
+{
+	pgd_t *pgd;
+	phys_addr_t addr = start, end = start + size;
+	phys_addr_t next;
+
+	/*
+	 * We don't unmap anything from HYP, except at the hyp tear down.
+	 * Hence, we don't have to invalidate the TLBs here.
+	 */
+	pgd = pgdp + pgd_index(addr);
+	do {
+		next = pgd_addr_end(addr, end);
+		if (!pgd_none(*pgd))
+			unmap_hyp_puds(pgd, addr, next);
+	} while (pgd++, addr = next, addr != end);
+}
+
 /**
  * free_boot_hyp_pgd - free HYP boot page tables
  *
@@ -398,14 +492,14 @@ void free_boot_hyp_pgd(void)
 	mutex_lock(&kvm_hyp_pgd_mutex);
 
 	if (boot_hyp_pgd) {
-		unmap_range(NULL, boot_hyp_pgd, hyp_idmap_start, PAGE_SIZE);
-		unmap_range(NULL, boot_hyp_pgd, TRAMPOLINE_VA, PAGE_SIZE);
+		unmap_hyp_range(boot_hyp_pgd, hyp_idmap_start, PAGE_SIZE);
+		unmap_hyp_range(boot_hyp_pgd, TRAMPOLINE_VA, PAGE_SIZE);
 		free_pages((unsigned long)boot_hyp_pgd, hyp_pgd_order);
 		boot_hyp_pgd = NULL;
 	}
 
 	if (hyp_pgd)
-		unmap_range(NULL, hyp_pgd, TRAMPOLINE_VA, PAGE_SIZE);
+		unmap_hyp_range(hyp_pgd, TRAMPOLINE_VA, PAGE_SIZE);
 
 	mutex_unlock(&kvm_hyp_pgd_mutex);
 }
@@ -430,9 +524,9 @@ void free_hyp_pgds(void)
 
 	if (hyp_pgd) {
 		for (addr = PAGE_OFFSET; virt_addr_valid(addr); addr += PGDIR_SIZE)
-			unmap_range(NULL, hyp_pgd, KERN_TO_HYP(addr), PGDIR_SIZE);
+			unmap_hyp_range(hyp_pgd, KERN_TO_HYP(addr), PGDIR_SIZE);
 		for (addr = VMALLOC_START; is_vmalloc_addr((void*)addr); addr += PGDIR_SIZE)
-			unmap_range(NULL, hyp_pgd, KERN_TO_HYP(addr), PGDIR_SIZE);
+			unmap_hyp_range(hyp_pgd, KERN_TO_HYP(addr), PGDIR_SIZE);
 
 		free_pages((unsigned long)hyp_pgd, hyp_pgd_order);
 		hyp_pgd = NULL;
-- 
1.7.9.5
