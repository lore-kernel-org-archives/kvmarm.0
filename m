From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 11/29] kvm-arm: Use explicit stage2 helper routines
Date: Wed, 11 May 2016 15:30:04 +0200
Message-ID: <1462973422-10021-12-git-send-email-christoffer.dall@linaro.org>
References: <1462973422-10021-1-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A932F49B47
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 May 2016 09:29:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HK6sUUm5Qcri for <kvmarm@lists.cs.columbia.edu>;
 Wed, 11 May 2016 09:29:09 -0400 (EDT)
Received: from mail-wm0-f48.google.com (mail-wm0-f48.google.com [74.125.82.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 77F9249B34
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 May 2016 09:29:03 -0400 (EDT)
Received: by mail-wm0-f48.google.com with SMTP id a17so83059822wme.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 May 2016 06:32:01 -0700 (PDT)
In-Reply-To: <1462973422-10021-1-git-send-email-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Suzuki K Poulose <suzuki.poulose@arm.com>

We have stage2 page table helpers for both arm and arm64. Switch to
the stage2 helpers for routines that only deal with stage2 page table.

Cc: Marc Zyngier <marc.zyngier@arm.com>
Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arch/arm/kvm/mmu.c | 48 ++++++++++++++++++++++++------------------------
 1 file changed, 24 insertions(+), 24 deletions(-)

diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
index d0c0ee9..f93f717 100644
--- a/arch/arm/kvm/mmu.c
+++ b/arch/arm/kvm/mmu.c
@@ -319,9 +319,9 @@ static void stage2_flush_pmds(struct kvm *kvm, pud_t *pud,
 	pmd_t *pmd;
 	phys_addr_t next;
 
-	pmd = pmd_offset(pud, addr);
+	pmd = stage2_pmd_offset(pud, addr);
 	do {
-		next = kvm_pmd_addr_end(addr, end);
+		next = stage2_pmd_addr_end(addr, end);
 		if (!pmd_none(*pmd)) {
 			if (pmd_thp_or_huge(*pmd))
 				kvm_flush_dcache_pmd(*pmd);
@@ -337,11 +337,11 @@ static void stage2_flush_puds(struct kvm *kvm, pgd_t *pgd,
 	pud_t *pud;
 	phys_addr_t next;
 
-	pud = pud_offset(pgd, addr);
+	pud = stage2_pud_offset(pgd, addr);
 	do {
-		next = kvm_pud_addr_end(addr, end);
-		if (!pud_none(*pud)) {
-			if (pud_huge(*pud))
+		next = stage2_pud_addr_end(addr, end);
+		if (!stage2_pud_none(*pud)) {
+			if (stage2_pud_huge(*pud))
 				kvm_flush_dcache_pud(*pud);
 			else
 				stage2_flush_pmds(kvm, pud, addr, next);
@@ -357,9 +357,9 @@ static void stage2_flush_memslot(struct kvm *kvm,
 	phys_addr_t next;
 	pgd_t *pgd;
 
-	pgd = kvm->arch.pgd + kvm_pgd_index(addr);
+	pgd = kvm->arch.pgd + stage2_pgd_index(addr);
 	do {
-		next = kvm_pgd_addr_end(addr, end);
+		next = stage2_pgd_addr_end(addr, end);
 		stage2_flush_puds(kvm, pgd, addr, next);
 	} while (pgd++, addr = next, addr != end);
 }
@@ -807,16 +807,16 @@ static pud_t *stage2_get_pud(struct kvm *kvm, struct kvm_mmu_memory_cache *cache
 	pgd_t *pgd;
 	pud_t *pud;
 
-	pgd = kvm->arch.pgd + kvm_pgd_index(addr);
-	if (WARN_ON(pgd_none(*pgd))) {
+	pgd = kvm->arch.pgd + stage2_pgd_index(addr);
+	if (WARN_ON(stage2_pgd_none(*pgd))) {
 		if (!cache)
 			return NULL;
 		pud = mmu_memory_cache_alloc(cache);
-		pgd_populate(NULL, pgd, pud);
+		stage2_pgd_populate(pgd, pud);
 		get_page(virt_to_page(pgd));
 	}
 
-	return pud_offset(pgd, addr);
+	return stage2_pud_offset(pgd, addr);
 }
 
 static pmd_t *stage2_get_pmd(struct kvm *kvm, struct kvm_mmu_memory_cache *cache,
@@ -826,15 +826,15 @@ static pmd_t *stage2_get_pmd(struct kvm *kvm, struct kvm_mmu_memory_cache *cache
 	pmd_t *pmd;
 
 	pud = stage2_get_pud(kvm, cache, addr);
-	if (pud_none(*pud)) {
+	if (stage2_pud_none(*pud)) {
 		if (!cache)
 			return NULL;
 		pmd = mmu_memory_cache_alloc(cache);
-		pud_populate(NULL, pud, pmd);
+		stage2_pud_populate(pud, pmd);
 		get_page(virt_to_page(pud));
 	}
 
-	return pmd_offset(pud, addr);
+	return stage2_pmd_offset(pud, addr);
 }
 
 static int stage2_set_pmd_huge(struct kvm *kvm, struct kvm_mmu_memory_cache
@@ -1042,10 +1042,10 @@ static void stage2_wp_pmds(pud_t *pud, phys_addr_t addr, phys_addr_t end)
 	pmd_t *pmd;
 	phys_addr_t next;
 
-	pmd = pmd_offset(pud, addr);
+	pmd = stage2_pmd_offset(pud, addr);
 
 	do {
-		next = kvm_pmd_addr_end(addr, end);
+		next = stage2_pmd_addr_end(addr, end);
 		if (!pmd_none(*pmd)) {
 			if (pmd_thp_or_huge(*pmd)) {
 				if (!kvm_s2pmd_readonly(pmd))
@@ -1070,12 +1070,12 @@ static void  stage2_wp_puds(pgd_t *pgd, phys_addr_t addr, phys_addr_t end)
 	pud_t *pud;
 	phys_addr_t next;
 
-	pud = pud_offset(pgd, addr);
+	pud = stage2_pud_offset(pgd, addr);
 	do {
-		next = kvm_pud_addr_end(addr, end);
-		if (!pud_none(*pud)) {
+		next = stage2_pud_addr_end(addr, end);
+		if (!stage2_pud_none(*pud)) {
 			/* TODO:PUD not supported, revisit later if supported */
-			BUG_ON(pud_huge(*pud));
+			BUG_ON(stage2_pud_huge(*pud));
 			stage2_wp_pmds(pud, addr, next);
 		}
 	} while (pud++, addr = next, addr != end);
@@ -1092,7 +1092,7 @@ static void stage2_wp_range(struct kvm *kvm, phys_addr_t addr, phys_addr_t end)
 	pgd_t *pgd;
 	phys_addr_t next;
 
-	pgd = kvm->arch.pgd + kvm_pgd_index(addr);
+	pgd = kvm->arch.pgd + stage2_pgd_index(addr);
 	do {
 		/*
 		 * Release kvm_mmu_lock periodically if the memory region is
@@ -1104,8 +1104,8 @@ static void stage2_wp_range(struct kvm *kvm, phys_addr_t addr, phys_addr_t end)
 		if (need_resched() || spin_needbreak(&kvm->mmu_lock))
 			cond_resched_lock(&kvm->mmu_lock);
 
-		next = kvm_pgd_addr_end(addr, end);
-		if (pgd_present(*pgd))
+		next = stage2_pgd_addr_end(addr, end);
+		if (stage2_pgd_present(*pgd))
 			stage2_wp_puds(pgd, addr, next);
 	} while (pgd++, addr = next, addr != end);
 }
-- 
2.1.2.330.g565301e.dirty
