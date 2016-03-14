From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [RFC PATCH 09/12] kvm-arm: Switch to kvm pagetable helpers
Date: Mon, 14 Mar 2016 16:53:08 +0000
Message-ID: <1457974391-28456-10-git-send-email-suzuki.poulose@arm.com>
References: <1457974391-28456-1-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E239549B5C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Mar 2016 12:53:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VtHWVhgEGtzW for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Mar 2016 12:53:24 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 23ACE49B58
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Mar 2016 12:53:18 -0400 (EDT)
In-Reply-To: <1457974391-28456-1-git-send-email-suzuki.poulose@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: christoffer.dall@linaro.org, marc.zyngier@arm.com
Cc: kvm@vger.kernel.org, catalin.marinas@arm.com, will.deacon@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Now that we have kvm wrappers for page table walk, switch
to using them everywhere. Also, use the explicit page table
accessor (stage2_ vs hyp), whenever we know we deal only
with a particular table.

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arch/arm/kvm/mmu.c |   64 ++++++++++++++++++++++++++--------------------------
 1 file changed, 32 insertions(+), 32 deletions(-)

diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
index 22b4c99..8568790 100644
--- a/arch/arm/kvm/mmu.c
+++ b/arch/arm/kvm/mmu.c
@@ -155,20 +155,20 @@ static void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc)
 
 static void clear_pgd_entry(struct kvm *kvm, pgd_t *pgd, phys_addr_t addr)
 {
-	pud_t *pud_table __maybe_unused = pud_offset(pgd, 0);
-	pgd_clear(pgd);
+	pud_t *pud_table __maybe_unused = kvm_pud_offset(kvm, pgd, 0);
+	kvm_pgd_clear(kvm, pgd);
 	kvm_tlb_flush_vmid_ipa(kvm, addr);
-	pud_free(NULL, pud_table);
+	kvm_pud_free(kvm, NULL, pud_table);
 	put_page(virt_to_page(pgd));
 }
 
 static void clear_pud_entry(struct kvm *kvm, pud_t *pud, phys_addr_t addr)
 {
-	pmd_t *pmd_table = pmd_offset(pud, 0);
+	pmd_t *pmd_table = kvm_pmd_offset(kvm, pud, 0);
 	VM_BUG_ON(kvm_pud_huge(kvm, *pud));
-	pud_clear(pud);
+	kvm_pud_clear(kvm, pud);
 	kvm_tlb_flush_vmid_ipa(kvm, addr);
-	pmd_free(NULL, pmd_table);
+	kvm_pmd_free(kvm, NULL, pmd_table);
 	put_page(virt_to_page(pud));
 }
 
@@ -234,7 +234,7 @@ static void unmap_pmds(struct kvm *kvm, pud_t *pud,
 	phys_addr_t next, start_addr = addr;
 	pmd_t *pmd, *start_pmd;
 
-	start_pmd = pmd = pmd_offset(pud, addr);
+	start_pmd = pmd = kvm_pmd_offset(kvm, pud, addr);
 	do {
 		next = kvm_pmd_addr_end(kvm, addr, end);
 		if (!pmd_none(*pmd)) {
@@ -263,14 +263,14 @@ static void unmap_puds(struct kvm *kvm, pgd_t *pgd,
 	phys_addr_t next, start_addr = addr;
 	pud_t *pud, *start_pud;
 
-	start_pud = pud = pud_offset(pgd, addr);
+	start_pud = pud = kvm_pud_offset(kvm, pgd, addr);
 	do {
 		next = kvm_pud_addr_end(kvm, addr, end);
-		if (!pud_none(*pud)) {
+		if (!kvm_pud_none(kvm, *pud)) {
 			if (kvm_pud_huge(kvm, *pud)) {
 				pud_t old_pud = *pud;
 
-				pud_clear(pud);
+				kvm_pud_clear(kvm, pud);
 				kvm_tlb_flush_vmid_ipa(kvm, addr);
 
 				kvm_flush_dcache_pud(old_pud);
@@ -297,7 +297,7 @@ static void unmap_range(struct kvm *kvm, pgd_t *pgdp,
 	pgd = pgdp + kvm_pgd_index(kvm, addr);
 	do {
 		next = kvm_pgd_addr_end(kvm, addr, end);
-		if (!pgd_none(*pgd))
+		if (!kvm_pgd_none(kvm, *pgd))
 			unmap_puds(kvm, pgd, addr, next);
 	} while (pgd++, addr = next, addr != end);
 }
@@ -320,9 +320,9 @@ static void stage2_flush_pmds(struct kvm *kvm, pud_t *pud,
 	pmd_t *pmd;
 	phys_addr_t next;
 
-	pmd = pmd_offset(pud, addr);
+	pmd = stage2_pmd_offset(pud, addr);
 	do {
-		next = kvm_pmd_addr_end(kvm, addr, end);
+		next = stage2_pmd_addr_end(addr, end);
 		if (!pmd_none(*pmd)) {
 			if (huge_pmd(*pmd))
 				kvm_flush_dcache_pmd(*pmd);
@@ -338,11 +338,11 @@ static void stage2_flush_puds(struct kvm *kvm, pgd_t *pgd,
 	pud_t *pud;
 	phys_addr_t next;
 
-	pud = pud_offset(pgd, addr);
+	pud = stage2_pud_offset(pgd, addr);
 	do {
-		next = kvm_pud_addr_end(kvm, addr, end);
-		if (!pud_none(*pud)) {
-			if (kvm_pud_huge(kvm, *pud))
+		next = stage2_pud_addr_end(addr, end);
+		if (!stage2_pud_none(*pud)) {
+			if (stage2_pud_huge(*pud))
 				kvm_flush_dcache_pud(*pud);
 			else
 				stage2_flush_pmds(kvm, pud, addr, next);
@@ -358,9 +358,9 @@ static void stage2_flush_memslot(struct kvm *kvm,
 	phys_addr_t next;
 	pgd_t *pgd;
 
-	pgd = kvm->arch.pgd + kvm_pgd_index(kvm, addr);
+	pgd = kvm->arch.pgd + stage2_pgd_index(addr);
 	do {
-		next = kvm_pgd_addr_end(kvm, addr, end);
+		next = stage2_pgd_addr_end(addr, end);
 		stage2_flush_puds(kvm, pgd, addr, next);
 	} while (pgd++, addr = next, addr != end);
 }
@@ -803,15 +803,15 @@ static pud_t *stage2_get_pud(struct kvm *kvm, struct kvm_mmu_memory_cache *cache
 	pud_t *pud;
 
 	pgd = kvm->arch.pgd + kvm_pgd_index(kvm, addr);
-	if (WARN_ON(pgd_none(*pgd))) {
+	if (WARN_ON(stage2_pgd_none(*pgd))) {
 		if (!cache)
 			return NULL;
 		pud = mmu_memory_cache_alloc(cache);
-		pgd_populate(NULL, pgd, pud);
+		stage2_pgd_populate(NULL, pgd, pud);
 		get_page(virt_to_page(pgd));
 	}
 
-	return pud_offset(pgd, addr);
+	return stage2_pud_offset(pgd, addr);
 }
 
 static pmd_t *stage2_get_pmd(struct kvm *kvm, struct kvm_mmu_memory_cache *cache,
@@ -821,15 +821,15 @@ static pmd_t *stage2_get_pmd(struct kvm *kvm, struct kvm_mmu_memory_cache *cache
 	pmd_t *pmd;
 
 	pud = stage2_get_pud(kvm, cache, addr);
-	if (pud_none(*pud)) {
+	if (stage2_pud_none(*pud)) {
 		if (!cache)
 			return NULL;
 		pmd = mmu_memory_cache_alloc(cache);
-		pud_populate(NULL, pud, pmd);
+		stage2_pud_populate(NULL, pud, pmd);
 		get_page(virt_to_page(pud));
 	}
 
-	return pmd_offset(pud, addr);
+	return stage2_pmd_offset(pud, addr);
 }
 
 static int stage2_set_pmd_huge(struct kvm *kvm, struct kvm_mmu_memory_cache
@@ -1037,10 +1037,10 @@ static void stage2_wp_pmds(pud_t *pud, phys_addr_t addr, phys_addr_t end)
 	pmd_t *pmd;
 	phys_addr_t next;
 
-	pmd = pmd_offset(pud, addr);
+	pmd = stage2_pmd_offset(pud, addr);
 
 	do {
-		next = kvm_pmd_addr_end(NULL, addr, end);
+		next = stage2_pmd_addr_end(addr, end);
 		if (!pmd_none(*pmd)) {
 			if (huge_pmd(*pmd)) {
 				if (!kvm_s2pmd_readonly(pmd))
@@ -1065,12 +1065,12 @@ static void  stage2_wp_puds(pgd_t *pgd, phys_addr_t addr, phys_addr_t end)
 	pud_t *pud;
 	phys_addr_t next;
 
-	pud = pud_offset(pgd, addr);
+	pud = stage2_pud_offset(pgd, addr);
 	do {
-		next = kvm_pud_addr_end(NULL, addr, end);
-		if (!pud_none(*pud)) {
+		next = stage2_pud_addr_end(addr, end);
+		if (!stage2_pud_none(*pud)) {
 			/* TODO:PUD not supported, revisit later if supported */
-			BUG_ON(kvm_pud_huge(NULL, *pud));
+			BUG_ON(stage2_pud_huge(*pud));
 			stage2_wp_pmds(pud, addr, next);
 		}
 	} while (pud++, addr = next, addr != end);
@@ -1100,7 +1100,7 @@ static void stage2_wp_range(struct kvm *kvm, phys_addr_t addr, phys_addr_t end)
 			cond_resched_lock(&kvm->mmu_lock);
 
 		next = kvm_pgd_addr_end(kvm, addr, end);
-		if (pgd_present(*pgd))
+		if (stage2_pgd_present(*pgd))
 			stage2_wp_puds(pgd, addr, next);
 	} while (pgd++, addr = next, addr != end);
 }
-- 
1.7.9.5
