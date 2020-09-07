Return-Path: <SRS0=A5dY=CQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26DCCC433E2
	for <kvmarm@archiver.kernel.org>; Mon,  7 Sep 2020 15:24:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A77B2215A4
	for <kvmarm@archiver.kernel.org>; Mon,  7 Sep 2020 15:24:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="AbMIzmKq"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A77B2215A4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C22D4B3BE;
	Mon,  7 Sep 2020 11:24:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IhfALO2p-F3L; Mon,  7 Sep 2020 11:24:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 892794B3DD;
	Mon,  7 Sep 2020 11:24:07 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F27FA4B291
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Sep 2020 11:24:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 28PEeAgLGq25 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Sep 2020 11:24:04 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 020AF4B4F9
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Sep 2020 11:24:04 -0400 (EDT)
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa
 [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 197A22078E;
 Mon,  7 Sep 2020 15:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1599492243;
 bh=HwpvyUSnocyEuwU76o2HkoaKmtPdkONdnNNQ2/sgOeA=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=AbMIzmKqMee0/m94sPSLfEh/JtrLMOIGFlGwUuIyI3owGC6GYZx+oMz+oDph0XGLU
 oBFvC+LqilO9+Bsb2aAsY9CQ4QEAaEIBoi5FyFLNmHYa1nNQbNNV+qcHAM3uX2ymy/
 mlBiDqBJNE0ZmxkpziKrvc4nq2GlAafEhWZeiFU8=
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v4 04/21] KVM: arm64: Use generic allocator for hyp stage-1
 page-tables
Date: Mon,  7 Sep 2020 16:23:27 +0100
Message-Id: <20200907152344.12978-5-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200907152344.12978-1-will@kernel.org>
References: <20200907152344.12978-1-will@kernel.org>
MIME-Version: 1.0
Cc: kernel-team@android.com, Marc Zyngier <maz@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 linux-arm-kernel@lists.infradead.org
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

Now that we have a shiny new page-table allocator, replace the hyp
page-table code with calls into the new API. This also allows us to
remove the extended idmap code, as we can now simply ensure that the
VA size is large enough to map everything we need.

Cc: Marc Zyngier <maz@kernel.org>
Cc: Quentin Perret <qperret@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/kvm_mmu.h       |  78 +----
 arch/arm64/include/asm/kvm_pgtable.h   |   5 +
 arch/arm64/include/asm/pgtable-hwdef.h |   6 -
 arch/arm64/include/asm/pgtable-prot.h  |   6 -
 arch/arm64/kvm/mmu.c                   | 414 +++----------------------
 5 files changed, 45 insertions(+), 464 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 0f078b1920ff..42fb50cfe0d8 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -43,16 +43,6 @@
  *	HYP_VA_MIN = 1 << (VA_BITS - 1)
  * HYP_VA_MAX = HYP_VA_MIN + (1 << (VA_BITS - 1)) - 1
  *
- * This of course assumes that the trampoline page exists within the
- * VA_BITS range. If it doesn't, then it means we're in the odd case
- * where the kernel idmap (as well as HYP) uses more levels than the
- * kernel runtime page tables (as seen when the kernel is configured
- * for 4k pages, 39bits VA, and yet memory lives just above that
- * limit, forcing the idmap to use 4 levels of page tables while the
- * kernel itself only uses 3). In this particular case, it doesn't
- * matter which side of VA_BITS we use, as we're guaranteed not to
- * conflict with anything.
- *
  * When using VHE, there are no separate hyp mappings and all KVM
  * functionality is already mapped as part of the main kernel
  * mappings, and none of this applies in that case.
@@ -123,9 +113,10 @@ static inline bool kvm_page_empty(void *ptr)
 	return page_count(ptr_page) == 1;
 }
 
+#include <asm/kvm_pgtable.h>
 #include <asm/stage2_pgtable.h>
 
-int create_hyp_mappings(void *from, void *to, pgprot_t prot);
+int create_hyp_mappings(void *from, void *to, enum kvm_pgtable_prot prot);
 int create_hyp_io_mappings(phys_addr_t phys_addr, size_t size,
 			   void __iomem **kaddr,
 			   void __iomem **haddr);
@@ -144,8 +135,6 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu);
 phys_addr_t kvm_mmu_get_httbr(void);
 phys_addr_t kvm_get_idmap_vector(void);
 int kvm_mmu_init(void);
-void kvm_clear_hyp_idmap(void);
-
 #define kvm_mk_pmd(ptep)					\
 	__pmd(__phys_to_pmd_val(__pa(ptep)) | PMD_TYPE_TABLE)
 #define kvm_mk_pud(pmdp)					\
@@ -263,25 +252,6 @@ static inline bool kvm_s2pud_young(pud_t pud)
 	return pud_young(pud);
 }
 
-#define hyp_pte_table_empty(ptep) kvm_page_empty(ptep)
-
-#ifdef __PAGETABLE_PMD_FOLDED
-#define hyp_pmd_table_empty(pmdp) (0)
-#else
-#define hyp_pmd_table_empty(pmdp) kvm_page_empty(pmdp)
-#endif
-
-#ifdef __PAGETABLE_PUD_FOLDED
-#define hyp_pud_table_empty(pudp) (0)
-#else
-#define hyp_pud_table_empty(pudp) kvm_page_empty(pudp)
-#endif
-
-#ifdef __PAGETABLE_P4D_FOLDED
-#define hyp_p4d_table_empty(p4dp) (0)
-#else
-#define hyp_p4d_table_empty(p4dp) kvm_page_empty(p4dp)
-#endif
 
 struct kvm;
 
@@ -350,50 +320,6 @@ static inline void __kvm_flush_dcache_pud(pud_t pud)
 void kvm_set_way_flush(struct kvm_vcpu *vcpu);
 void kvm_toggle_cache(struct kvm_vcpu *vcpu, bool was_enabled);
 
-static inline bool __kvm_cpu_uses_extended_idmap(void)
-{
-	return __cpu_uses_extended_idmap_level();
-}
-
-static inline unsigned long __kvm_idmap_ptrs_per_pgd(void)
-{
-	return idmap_ptrs_per_pgd;
-}
-
-/*
- * Can't use pgd_populate here, because the extended idmap adds an extra level
- * above CONFIG_PGTABLE_LEVELS (which is 2 or 3 if we're using the extended
- * idmap), and pgd_populate is only available if CONFIG_PGTABLE_LEVELS = 4.
- */
-static inline void __kvm_extend_hypmap(pgd_t *boot_hyp_pgd,
-				       pgd_t *hyp_pgd,
-				       pgd_t *merged_hyp_pgd,
-				       unsigned long hyp_idmap_start)
-{
-	int idmap_idx;
-	u64 pgd_addr;
-
-	/*
-	 * Use the first entry to access the HYP mappings. It is
-	 * guaranteed to be free, otherwise we wouldn't use an
-	 * extended idmap.
-	 */
-	VM_BUG_ON(pgd_val(merged_hyp_pgd[0]));
-	pgd_addr = __phys_to_pgd_val(__pa(hyp_pgd));
-	merged_hyp_pgd[0] = __pgd(pgd_addr | PMD_TYPE_TABLE);
-
-	/*
-	 * Create another extended level entry that points to the boot HYP map,
-	 * which contains an ID mapping of the HYP init code. We essentially
-	 * merge the boot and runtime HYP maps by doing so, but they don't
-	 * overlap anyway, so this is fine.
-	 */
-	idmap_idx = hyp_idmap_start >> VA_BITS;
-	VM_BUG_ON(pgd_val(merged_hyp_pgd[idmap_idx]));
-	pgd_addr = __phys_to_pgd_val(__pa(boot_hyp_pgd));
-	merged_hyp_pgd[idmap_idx] = __pgd(pgd_addr | PMD_TYPE_TABLE);
-}
-
 static inline unsigned int kvm_get_vmid_bits(void)
 {
 	int reg = read_sanitised_ftr_reg(SYS_ID_AA64MMFR1_EL1);
diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 91e364804547..3e1dd1b9fd93 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -44,6 +44,11 @@ enum kvm_pgtable_prot {
 	KVM_PGTABLE_PROT_DEVICE			= BIT(3),
 };
 
+#define PAGE_HYP		(KVM_PGTABLE_PROT_R | KVM_PGTABLE_PROT_W)
+#define PAGE_HYP_EXEC		(KVM_PGTABLE_PROT_R | KVM_PGTABLE_PROT_X)
+#define PAGE_HYP_RO		(KVM_PGTABLE_PROT_R)
+#define PAGE_HYP_DEVICE		(PAGE_HYP | KVM_PGTABLE_PROT_DEVICE)
+
 /**
  * enum kvm_pgtable_walk_flags - Flags to control a depth-first page-table walk.
  * @KVM_PGTABLE_WALK_LEAF:		Visit leaf entries, including invalid
diff --git a/arch/arm64/include/asm/pgtable-hwdef.h b/arch/arm64/include/asm/pgtable-hwdef.h
index d400a4d9aee2..1a989353144e 100644
--- a/arch/arm64/include/asm/pgtable-hwdef.h
+++ b/arch/arm64/include/asm/pgtable-hwdef.h
@@ -194,12 +194,6 @@
  */
 #define PTE_S2_MEMATTR(t)	(_AT(pteval_t, (t)) << 2)
 
-/*
- * EL2/HYP PTE/PMD definitions
- */
-#define PMD_HYP			PMD_SECT_USER
-#define PTE_HYP			PTE_USER
-
 /*
  * Highest possible physical address supported.
  */
diff --git a/arch/arm64/include/asm/pgtable-prot.h b/arch/arm64/include/asm/pgtable-prot.h
index 4d867c6446c4..88acd7e1cd05 100644
--- a/arch/arm64/include/asm/pgtable-prot.h
+++ b/arch/arm64/include/asm/pgtable-prot.h
@@ -56,7 +56,6 @@ extern bool arm64_use_ng_mappings;
 #define PROT_SECT_NORMAL_EXEC	(PROT_SECT_DEFAULT | PMD_SECT_UXN | PMD_ATTRINDX(MT_NORMAL))
 
 #define _PAGE_DEFAULT		(_PROT_DEFAULT | PTE_ATTRINDX(MT_NORMAL))
-#define _HYP_PAGE_DEFAULT	_PAGE_DEFAULT
 
 #define PAGE_KERNEL		__pgprot(PROT_NORMAL)
 #define PAGE_KERNEL_RO		__pgprot((PROT_NORMAL & ~PTE_WRITE) | PTE_RDONLY)
@@ -64,11 +63,6 @@ extern bool arm64_use_ng_mappings;
 #define PAGE_KERNEL_EXEC	__pgprot(PROT_NORMAL & ~PTE_PXN)
 #define PAGE_KERNEL_EXEC_CONT	__pgprot((PROT_NORMAL & ~PTE_PXN) | PTE_CONT)
 
-#define PAGE_HYP		__pgprot(_HYP_PAGE_DEFAULT | PTE_HYP | PTE_HYP_XN)
-#define PAGE_HYP_EXEC		__pgprot(_HYP_PAGE_DEFAULT | PTE_HYP | PTE_RDONLY)
-#define PAGE_HYP_RO		__pgprot(_HYP_PAGE_DEFAULT | PTE_HYP | PTE_RDONLY | PTE_HYP_XN)
-#define PAGE_HYP_DEVICE		__pgprot(_PROT_DEFAULT | PTE_ATTRINDX(MT_DEVICE_nGnRE) | PTE_HYP | PTE_HYP_XN)
-
 #define PAGE_S2_MEMATTR(attr)						\
 	({								\
 		u64 __val;						\
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 935f8f689433..fabd72b0c8a4 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -14,6 +14,7 @@
 #include <asm/cacheflush.h>
 #include <asm/kvm_arm.h>
 #include <asm/kvm_mmu.h>
+#include <asm/kvm_pgtable.h>
 #include <asm/kvm_ras.h>
 #include <asm/kvm_asm.h>
 #include <asm/kvm_emulate.h>
@@ -21,9 +22,7 @@
 
 #include "trace.h"
 
-static pgd_t *boot_hyp_pgd;
-static pgd_t *hyp_pgd;
-static pgd_t *merged_hyp_pgd;
+static struct kvm_pgtable *hyp_pgtable;
 static DEFINE_MUTEX(kvm_hyp_pgd_mutex);
 
 static unsigned long hyp_idmap_start;
@@ -32,8 +31,6 @@ static phys_addr_t hyp_idmap_vector;
 
 static unsigned long io_map_base;
 
-#define hyp_pgd_order get_order(PTRS_PER_PGD * sizeof(pgd_t))
-
 #define KVM_S2PTE_FLAG_IS_IOMAP		(1UL << 0)
 #define KVM_S2_FLAG_LOGGING_ACTIVE	(1UL << 1)
 
@@ -489,338 +486,28 @@ static void stage2_flush_vm(struct kvm *kvm)
 	srcu_read_unlock(&kvm->srcu, idx);
 }
 
-static void clear_hyp_pgd_entry(pgd_t *pgd)
-{
-	p4d_t *p4d_table __maybe_unused = p4d_offset(pgd, 0UL);
-	pgd_clear(pgd);
-	p4d_free(NULL, p4d_table);
-	put_page(virt_to_page(pgd));
-}
-
-static void clear_hyp_p4d_entry(p4d_t *p4d)
-{
-	pud_t *pud_table __maybe_unused = pud_offset(p4d, 0UL);
-	VM_BUG_ON(p4d_huge(*p4d));
-	p4d_clear(p4d);
-	pud_free(NULL, pud_table);
-	put_page(virt_to_page(p4d));
-}
-
-static void clear_hyp_pud_entry(pud_t *pud)
-{
-	pmd_t *pmd_table __maybe_unused = pmd_offset(pud, 0);
-	VM_BUG_ON(pud_huge(*pud));
-	pud_clear(pud);
-	pmd_free(NULL, pmd_table);
-	put_page(virt_to_page(pud));
-}
-
-static void clear_hyp_pmd_entry(pmd_t *pmd)
-{
-	pte_t *pte_table = pte_offset_kernel(pmd, 0);
-	VM_BUG_ON(pmd_thp_or_huge(*pmd));
-	pmd_clear(pmd);
-	pte_free_kernel(NULL, pte_table);
-	put_page(virt_to_page(pmd));
-}
-
-static void unmap_hyp_ptes(pmd_t *pmd, phys_addr_t addr, phys_addr_t end)
-{
-	pte_t *pte, *start_pte;
-
-	start_pte = pte = pte_offset_kernel(pmd, addr);
-	do {
-		if (!pte_none(*pte)) {
-			kvm_set_pte(pte, __pte(0));
-			put_page(virt_to_page(pte));
-		}
-	} while (pte++, addr += PAGE_SIZE, addr != end);
-
-	if (hyp_pte_table_empty(start_pte))
-		clear_hyp_pmd_entry(pmd);
-}
-
-static void unmap_hyp_pmds(pud_t *pud, phys_addr_t addr, phys_addr_t end)
-{
-	phys_addr_t next;
-	pmd_t *pmd, *start_pmd;
-
-	start_pmd = pmd = pmd_offset(pud, addr);
-	do {
-		next = pmd_addr_end(addr, end);
-		/* Hyp doesn't use huge pmds */
-		if (!pmd_none(*pmd))
-			unmap_hyp_ptes(pmd, addr, next);
-	} while (pmd++, addr = next, addr != end);
-
-	if (hyp_pmd_table_empty(start_pmd))
-		clear_hyp_pud_entry(pud);
-}
-
-static void unmap_hyp_puds(p4d_t *p4d, phys_addr_t addr, phys_addr_t end)
-{
-	phys_addr_t next;
-	pud_t *pud, *start_pud;
-
-	start_pud = pud = pud_offset(p4d, addr);
-	do {
-		next = pud_addr_end(addr, end);
-		/* Hyp doesn't use huge puds */
-		if (!pud_none(*pud))
-			unmap_hyp_pmds(pud, addr, next);
-	} while (pud++, addr = next, addr != end);
-
-	if (hyp_pud_table_empty(start_pud))
-		clear_hyp_p4d_entry(p4d);
-}
-
-static void unmap_hyp_p4ds(pgd_t *pgd, phys_addr_t addr, phys_addr_t end)
-{
-	phys_addr_t next;
-	p4d_t *p4d, *start_p4d;
-
-	start_p4d = p4d = p4d_offset(pgd, addr);
-	do {
-		next = p4d_addr_end(addr, end);
-		/* Hyp doesn't use huge p4ds */
-		if (!p4d_none(*p4d))
-			unmap_hyp_puds(p4d, addr, next);
-	} while (p4d++, addr = next, addr != end);
-
-	if (hyp_p4d_table_empty(start_p4d))
-		clear_hyp_pgd_entry(pgd);
-}
-
-static unsigned int kvm_pgd_index(unsigned long addr, unsigned int ptrs_per_pgd)
-{
-	return (addr >> PGDIR_SHIFT) & (ptrs_per_pgd - 1);
-}
-
-static void __unmap_hyp_range(pgd_t *pgdp, unsigned long ptrs_per_pgd,
-			      phys_addr_t start, u64 size)
-{
-	pgd_t *pgd;
-	phys_addr_t addr = start, end = start + size;
-	phys_addr_t next;
-
-	/*
-	 * We don't unmap anything from HYP, except at the hyp tear down.
-	 * Hence, we don't have to invalidate the TLBs here.
-	 */
-	pgd = pgdp + kvm_pgd_index(addr, ptrs_per_pgd);
-	do {
-		next = pgd_addr_end(addr, end);
-		if (!pgd_none(*pgd))
-			unmap_hyp_p4ds(pgd, addr, next);
-	} while (pgd++, addr = next, addr != end);
-}
-
-static void unmap_hyp_range(pgd_t *pgdp, phys_addr_t start, u64 size)
-{
-	__unmap_hyp_range(pgdp, PTRS_PER_PGD, start, size);
-}
-
-static void unmap_hyp_idmap_range(pgd_t *pgdp, phys_addr_t start, u64 size)
-{
-	__unmap_hyp_range(pgdp, __kvm_idmap_ptrs_per_pgd(), start, size);
-}
-
 /**
  * free_hyp_pgds - free Hyp-mode page tables
- *
- * Assumes hyp_pgd is a page table used strictly in Hyp-mode and
- * therefore contains either mappings in the kernel memory area (above
- * PAGE_OFFSET), or device mappings in the idmap range.
- *
- * boot_hyp_pgd should only map the idmap range, and is only used in
- * the extended idmap case.
  */
 void free_hyp_pgds(void)
 {
-	pgd_t *id_pgd;
-
 	mutex_lock(&kvm_hyp_pgd_mutex);
-
-	id_pgd = boot_hyp_pgd ? boot_hyp_pgd : hyp_pgd;
-
-	if (id_pgd) {
-		/* In case we never called hyp_mmu_init() */
-		if (!io_map_base)
-			io_map_base = hyp_idmap_start;
-		unmap_hyp_idmap_range(id_pgd, io_map_base,
-				      hyp_idmap_start + PAGE_SIZE - io_map_base);
-	}
-
-	if (boot_hyp_pgd) {
-		free_pages((unsigned long)boot_hyp_pgd, hyp_pgd_order);
-		boot_hyp_pgd = NULL;
-	}
-
-	if (hyp_pgd) {
-		unmap_hyp_range(hyp_pgd, kern_hyp_va(PAGE_OFFSET),
-				(uintptr_t)high_memory - PAGE_OFFSET);
-
-		free_pages((unsigned long)hyp_pgd, hyp_pgd_order);
-		hyp_pgd = NULL;
+	if (hyp_pgtable) {
+		kvm_pgtable_hyp_destroy(hyp_pgtable);
+		kfree(hyp_pgtable);
 	}
-	if (merged_hyp_pgd) {
-		clear_page(merged_hyp_pgd);
-		free_page((unsigned long)merged_hyp_pgd);
-		merged_hyp_pgd = NULL;
-	}
-
 	mutex_unlock(&kvm_hyp_pgd_mutex);
 }
 
-static void create_hyp_pte_mappings(pmd_t *pmd, unsigned long start,
-				    unsigned long end, unsigned long pfn,
-				    pgprot_t prot)
-{
-	pte_t *pte;
-	unsigned long addr;
-
-	addr = start;
-	do {
-		pte = pte_offset_kernel(pmd, addr);
-		kvm_set_pte(pte, kvm_pfn_pte(pfn, prot));
-		get_page(virt_to_page(pte));
-		pfn++;
-	} while (addr += PAGE_SIZE, addr != end);
-}
-
-static int create_hyp_pmd_mappings(pud_t *pud, unsigned long start,
-				   unsigned long end, unsigned long pfn,
-				   pgprot_t prot)
+static int __create_hyp_mappings(unsigned long start, unsigned long size,
+				 unsigned long phys, enum kvm_pgtable_prot prot)
 {
-	pmd_t *pmd;
-	pte_t *pte;
-	unsigned long addr, next;
-
-	addr = start;
-	do {
-		pmd = pmd_offset(pud, addr);
-
-		BUG_ON(pmd_sect(*pmd));
-
-		if (pmd_none(*pmd)) {
-			pte = pte_alloc_one_kernel(NULL);
-			if (!pte) {
-				kvm_err("Cannot allocate Hyp pte\n");
-				return -ENOMEM;
-			}
-			kvm_pmd_populate(pmd, pte);
-			get_page(virt_to_page(pmd));
-		}
-
-		next = pmd_addr_end(addr, end);
-
-		create_hyp_pte_mappings(pmd, addr, next, pfn, prot);
-		pfn += (next - addr) >> PAGE_SHIFT;
-	} while (addr = next, addr != end);
-
-	return 0;
-}
-
-static int create_hyp_pud_mappings(p4d_t *p4d, unsigned long start,
-				   unsigned long end, unsigned long pfn,
-				   pgprot_t prot)
-{
-	pud_t *pud;
-	pmd_t *pmd;
-	unsigned long addr, next;
-	int ret;
-
-	addr = start;
-	do {
-		pud = pud_offset(p4d, addr);
-
-		if (pud_none_or_clear_bad(pud)) {
-			pmd = pmd_alloc_one(NULL, addr);
-			if (!pmd) {
-				kvm_err("Cannot allocate Hyp pmd\n");
-				return -ENOMEM;
-			}
-			kvm_pud_populate(pud, pmd);
-			get_page(virt_to_page(pud));
-		}
-
-		next = pud_addr_end(addr, end);
-		ret = create_hyp_pmd_mappings(pud, addr, next, pfn, prot);
-		if (ret)
-			return ret;
-		pfn += (next - addr) >> PAGE_SHIFT;
-	} while (addr = next, addr != end);
-
-	return 0;
-}
-
-static int create_hyp_p4d_mappings(pgd_t *pgd, unsigned long start,
-				   unsigned long end, unsigned long pfn,
-				   pgprot_t prot)
-{
-	p4d_t *p4d;
-	pud_t *pud;
-	unsigned long addr, next;
-	int ret;
-
-	addr = start;
-	do {
-		p4d = p4d_offset(pgd, addr);
-
-		if (p4d_none(*p4d)) {
-			pud = pud_alloc_one(NULL, addr);
-			if (!pud) {
-				kvm_err("Cannot allocate Hyp pud\n");
-				return -ENOMEM;
-			}
-			kvm_p4d_populate(p4d, pud);
-			get_page(virt_to_page(p4d));
-		}
-
-		next = p4d_addr_end(addr, end);
-		ret = create_hyp_pud_mappings(p4d, addr, next, pfn, prot);
-		if (ret)
-			return ret;
-		pfn += (next - addr) >> PAGE_SHIFT;
-	} while (addr = next, addr != end);
-
-	return 0;
-}
-
-static int __create_hyp_mappings(pgd_t *pgdp, unsigned long ptrs_per_pgd,
-				 unsigned long start, unsigned long end,
-				 unsigned long pfn, pgprot_t prot)
-{
-	pgd_t *pgd;
-	p4d_t *p4d;
-	unsigned long addr, next;
-	int err = 0;
+	int err;
 
 	mutex_lock(&kvm_hyp_pgd_mutex);
-	addr = start & PAGE_MASK;
-	end = PAGE_ALIGN(end);
-	do {
-		pgd = pgdp + kvm_pgd_index(addr, ptrs_per_pgd);
-
-		if (pgd_none(*pgd)) {
-			p4d = p4d_alloc_one(NULL, addr);
-			if (!p4d) {
-				kvm_err("Cannot allocate Hyp p4d\n");
-				err = -ENOMEM;
-				goto out;
-			}
-			kvm_pgd_populate(pgd, p4d);
-			get_page(virt_to_page(pgd));
-		}
-
-		next = pgd_addr_end(addr, end);
-		err = create_hyp_p4d_mappings(pgd, addr, next, pfn, prot);
-		if (err)
-			goto out;
-		pfn += (next - addr) >> PAGE_SHIFT;
-	} while (addr = next, addr != end);
-out:
+	err = kvm_pgtable_hyp_map(hyp_pgtable, start, size, phys, prot);
 	mutex_unlock(&kvm_hyp_pgd_mutex);
+
 	return err;
 }
 
@@ -845,7 +532,7 @@ static phys_addr_t kvm_kaddr_to_phys(void *kaddr)
  * in Hyp-mode mapping (modulo HYP_PAGE_OFFSET) to the same underlying
  * physical pages.
  */
-int create_hyp_mappings(void *from, void *to, pgprot_t prot)
+int create_hyp_mappings(void *from, void *to, enum kvm_pgtable_prot prot)
 {
 	phys_addr_t phys_addr;
 	unsigned long virt_addr;
@@ -862,9 +549,7 @@ int create_hyp_mappings(void *from, void *to, pgprot_t prot)
 		int err;
 
 		phys_addr = kvm_kaddr_to_phys(from + virt_addr - start);
-		err = __create_hyp_mappings(hyp_pgd, PTRS_PER_PGD,
-					    virt_addr, virt_addr + PAGE_SIZE,
-					    __phys_to_pfn(phys_addr),
+		err = __create_hyp_mappings(virt_addr, PAGE_SIZE, phys_addr,
 					    prot);
 		if (err)
 			return err;
@@ -874,9 +559,9 @@ int create_hyp_mappings(void *from, void *to, pgprot_t prot)
 }
 
 static int __create_hyp_private_mapping(phys_addr_t phys_addr, size_t size,
-					unsigned long *haddr, pgprot_t prot)
+					unsigned long *haddr,
+					enum kvm_pgtable_prot prot)
 {
-	pgd_t *pgd = hyp_pgd;
 	unsigned long base;
 	int ret = 0;
 
@@ -908,17 +593,11 @@ static int __create_hyp_private_mapping(phys_addr_t phys_addr, size_t size,
 	if (ret)
 		goto out;
 
-	if (__kvm_cpu_uses_extended_idmap())
-		pgd = boot_hyp_pgd;
-
-	ret = __create_hyp_mappings(pgd, __kvm_idmap_ptrs_per_pgd(),
-				    base, base + size,
-				    __phys_to_pfn(phys_addr), prot);
+	ret = __create_hyp_mappings(base, size, phys_addr, prot);
 	if (ret)
 		goto out;
 
 	*haddr = base + offset_in_page(phys_addr);
-
 out:
 	return ret;
 }
@@ -2326,10 +2005,7 @@ int kvm_test_age_hva(struct kvm *kvm, unsigned long hva)
 
 phys_addr_t kvm_mmu_get_httbr(void)
 {
-	if (__kvm_cpu_uses_extended_idmap())
-		return virt_to_phys(merged_hyp_pgd);
-	else
-		return virt_to_phys(hyp_pgd);
+	return __pa(hyp_pgtable->pgd);
 }
 
 phys_addr_t kvm_get_idmap_vector(void)
@@ -2337,15 +2013,11 @@ phys_addr_t kvm_get_idmap_vector(void)
 	return hyp_idmap_vector;
 }
 
-static int kvm_map_idmap_text(pgd_t *pgd)
+static int kvm_map_idmap_text(void)
 {
-	int err;
-
-	/* Create the idmap in the boot page tables */
-	err = 	__create_hyp_mappings(pgd, __kvm_idmap_ptrs_per_pgd(),
-				      hyp_idmap_start, hyp_idmap_end,
-				      __phys_to_pfn(hyp_idmap_start),
-				      PAGE_HYP_EXEC);
+	unsigned long size = hyp_idmap_end - hyp_idmap_start;
+	int err = __create_hyp_mappings(hyp_idmap_start, size, hyp_idmap_start,
+					PAGE_HYP_EXEC);
 	if (err)
 		kvm_err("Failed to idmap %lx-%lx\n",
 			hyp_idmap_start, hyp_idmap_end);
@@ -2356,6 +2028,7 @@ static int kvm_map_idmap_text(pgd_t *pgd)
 int kvm_mmu_init(void)
 {
 	int err;
+	u32 hyp_va_bits;
 
 	hyp_idmap_start = __pa_symbol(__hyp_idmap_text_start);
 	hyp_idmap_start = ALIGN_DOWN(hyp_idmap_start, PAGE_SIZE);
@@ -2369,6 +2042,8 @@ int kvm_mmu_init(void)
 	 */
 	BUG_ON((hyp_idmap_start ^ (hyp_idmap_end - 1)) & PAGE_MASK);
 
+	hyp_va_bits = 64 - ((idmap_t0sz & TCR_T0SZ_MASK) >> TCR_T0SZ_OFFSET);
+	kvm_debug("Using %u-bit virtual addresses at EL2\n", hyp_va_bits);
 	kvm_debug("IDMAP page: %lx\n", hyp_idmap_start);
 	kvm_debug("HYP VA range: %lx:%lx\n",
 		  kern_hyp_va(PAGE_OFFSET),
@@ -2386,43 +2061,30 @@ int kvm_mmu_init(void)
 		goto out;
 	}
 
-	hyp_pgd = (pgd_t *)__get_free_pages(GFP_KERNEL | __GFP_ZERO, hyp_pgd_order);
-	if (!hyp_pgd) {
-		kvm_err("Hyp mode PGD not allocated\n");
+	hyp_pgtable = kzalloc(sizeof(*hyp_pgtable), GFP_KERNEL);
+	if (!hyp_pgtable) {
+		kvm_err("Hyp mode page-table not allocated\n");
 		err = -ENOMEM;
 		goto out;
 	}
 
-	if (__kvm_cpu_uses_extended_idmap()) {
-		boot_hyp_pgd = (pgd_t *)__get_free_pages(GFP_KERNEL | __GFP_ZERO,
-							 hyp_pgd_order);
-		if (!boot_hyp_pgd) {
-			kvm_err("Hyp boot PGD not allocated\n");
-			err = -ENOMEM;
-			goto out;
-		}
-
-		err = kvm_map_idmap_text(boot_hyp_pgd);
-		if (err)
-			goto out;
+	err = kvm_pgtable_hyp_init(hyp_pgtable, hyp_va_bits);
+	if (err)
+		goto out_free_pgtable;
 
-		merged_hyp_pgd = (pgd_t *)__get_free_page(GFP_KERNEL | __GFP_ZERO);
-		if (!merged_hyp_pgd) {
-			kvm_err("Failed to allocate extra HYP pgd\n");
-			goto out;
-		}
-		__kvm_extend_hypmap(boot_hyp_pgd, hyp_pgd, merged_hyp_pgd,
-				    hyp_idmap_start);
-	} else {
-		err = kvm_map_idmap_text(hyp_pgd);
-		if (err)
-			goto out;
-	}
+	err = kvm_map_idmap_text();
+	if (err)
+		goto out_destroy_pgtable;
 
 	io_map_base = hyp_idmap_start;
 	return 0;
+
+out_destroy_pgtable:
+	kvm_pgtable_hyp_destroy(hyp_pgtable);
+out_free_pgtable:
+	kfree(hyp_pgtable);
+	hyp_pgtable = NULL;
 out:
-	free_hyp_pgds();
 	return err;
 }
 
-- 
2.28.0.526.ge36021eeef-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
