From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 12/17] kvm-arm: Add explicit hyp page table modifiers
Date: Mon,  4 Apr 2016 17:26:12 +0100
Message-ID: <1459787177-12767-13-git-send-email-suzuki.poulose@arm.com>
References: <1459787177-12767-1-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C8BC2407A0
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Apr 2016 12:25:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LNaJ3aftiORE for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Apr 2016 12:25:50 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 797474113E
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Apr 2016 12:25:50 -0400 (EDT)
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
 arch/arm/kvm/mmu.c |  123 +++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 118 insertions(+), 5 deletions(-)

diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
index b46a337..2b491e5 100644
--- a/arch/arm/kvm/mmu.c
+++ b/arch/arm/kvm/mmu.c
@@ -388,6 +388,119 @@ static void stage2_flush_vm(struct kvm *kvm)
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
+			pte_t old_pte = *pte;
+
+			kvm_set_pte(pte, __pte(0));
+
+			/* XXX: Do we need to invalidate the cache for device mappings ? */
+			if (!kvm_is_device_pfn(pte_pfn(old_pte)))
+				kvm_flush_dcache_pte(old_pte);
+
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
+		if (!pmd_none(*pmd)) {
+			if (pmd_thp_or_huge(*pmd)) {
+				pmd_t old_pmd = *pmd;
+
+				pmd_clear(pmd);
+				kvm_flush_dcache_pmd(old_pmd);
+				put_page(virt_to_page(pmd));
+			} else {
+				unmap_hyp_ptes(pmd, addr, next);
+			}
+		}
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
+		if (!pud_none(*pud)) {
+			if (pud_huge(*pud)) {
+				pud_t old_pud = *pud;
+
+				pud_clear(pud);
+				kvm_flush_dcache_pud(old_pud);
+				put_page(virt_to_page(pud));
+			} else {
+				unmap_hyp_pmds(pud, addr, next);
+			}
+		}
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
@@ -398,14 +511,14 @@ void free_boot_hyp_pgd(void)
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
@@ -430,9 +543,9 @@ void free_hyp_pgds(void)
 
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
