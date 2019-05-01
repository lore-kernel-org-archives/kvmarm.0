Return-Path: <SRS0=Vsle=TB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54AC6C004C9
	for <kvmarm@archiver.kernel.org>; Wed,  1 May 2019 09:48:29 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 107862177B
	for <kvmarm@archiver.kernel.org>; Wed,  1 May 2019 09:48:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 107862177B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BD45A4A507;
	Wed,  1 May 2019 05:48:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LVxGv9kPFiVb; Wed,  1 May 2019 05:48:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 64B7E4A50F;
	Wed,  1 May 2019 05:48:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 740894A500
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 May 2019 05:48:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UbEoOIb-LzuB for <kvmarm@lists.cs.columbia.edu>;
 Wed,  1 May 2019 05:48:23 -0400 (EDT)
Received: from huawei.com (szxga06-in.huawei.com [45.249.212.32])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C4AAA4A4F7
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 May 2019 05:48:22 -0400 (EDT)
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.58])
 by Forcepoint Email with ESMTP id D711E68B5D98E459F02A;
 Wed,  1 May 2019 17:48:19 +0800 (CST)
Received: from HGHY2Y004646261.china.huawei.com (10.184.12.158) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.439.0; Wed, 1 May 2019 17:48:10 +0800
From: Zenghui Yu <yuzenghui@huawei.com>
To: <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.cs.columbia.edu>,
 <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
Subject: [PATCH 4/5] KVM: arm/arm64: Add support for creating PTE contiguous
 hugepages at stage2
Date: Wed, 1 May 2019 09:44:26 +0000
Message-ID: <1556703867-22396-5-git-send-email-yuzenghui@huawei.com>
X-Mailer: git-send-email 2.6.4.windows.1
In-Reply-To: <1556703867-22396-1-git-send-email-yuzenghui@huawei.com>
References: <1556703867-22396-1-git-send-email-yuzenghui@huawei.com>
MIME-Version: 1.0
X-Originating-IP: [10.184.12.158]
X-CFilter-Loop: Reflected
Cc: marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com,
 linux@armlinux.org.uk
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
Message-ID: <20190501094426.8eePQskG96PvsbifwJfthMLRLy9QCpMsaNTqmw4Zsj4@z>

Extend the stage2 fault handling to map in PTE contiguous hugepages first.
With this patch, we now support additional following page size at stage2:

                CONT PTE
                --------
 4K granule:      64K
16K granule:       2M
64K granule:       2M

The PMD contiguous huge mapping is still not supported yet and will be
simply fall back to a PTE mapping.

Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
---
 virt/kvm/arm/mmu.c | 76 +++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 75 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index 36c863f..fdd6314 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -1104,6 +1104,27 @@ static pmd_t *stage2_get_pmd(struct kvm *kvm, struct kvm_mmu_memory_cache *cache
 	return stage2_pmd_offset(kvm, pud, addr);
 }
 
+static pte_t *stage2_get_pte(struct kvm *kvm, struct kvm_mmu_memory_cache *cache,
+			     phys_addr_t addr)
+{
+	pmd_t *pmd;
+	pte_t *pte;
+
+	pmd = stage2_get_pmd(kvm, cache, addr);
+	if (!pmd || pmd_thp_or_huge(*pmd))
+		return NULL;
+
+	if (pmd_none(*pmd)) {
+		if (!cache)
+			return NULL;
+		pte = mmu_memory_cache_alloc(cache);
+		kvm_pmd_populate(pmd, pte);
+		get_page(virt_to_page(pmd));
+	}
+
+	return pte_offset_kernel(pmd, addr);
+}
+
 static int stage2_set_pmd_huge(struct kvm *kvm, struct kvm_mmu_memory_cache
 			       *cache, phys_addr_t addr, const pmd_t *new_pmd)
 {
@@ -1270,6 +1291,54 @@ static bool stage2_is_exec(struct kvm *kvm, phys_addr_t addr)
 		return kvm_s2pte_exec(ptep);
 }
 
+/* This code is borrowed from arch/arm64/mm/hugetlbpage.c */
+static inline pgprot_t pte_pgprot(pte_t pte)
+{
+	unsigned long pfn = pte_pfn(pte);
+
+	return __pgprot(pte_val(pfn_pte(pfn, __pgprot(0))) ^ pte_val(pte));
+}
+
+static int stage2_set_cont_ptes(struct kvm *kvm, struct kvm_mmu_memory_cache
+				*cache, phys_addr_t addr, const pte_t *new_pte)
+{
+	pte_t *pte, old_pte;
+	unsigned long pfn, dpfn;
+	int i;
+	pgprot_t hugeprot;
+
+	/*
+	 * Make sure we start manipulating the first pte
+	 * within CONT_PTES ptes.
+	 */
+	addr &= CONT_PTE_MASK;
+	pfn = pte_pfn(*new_pte);
+	dpfn = PAGE_SIZE >> PAGE_SHIFT;
+	hugeprot = pte_pgprot(*new_pte);
+
+	pte = stage2_get_pte(kvm, cache, addr);
+	VM_BUG_ON(!pte);
+
+	old_pte = *pte;
+
+	/* Skip page table update if there is no change */
+	if (pte_val(old_pte) == pte_val(*new_pte))
+		return 0;
+
+	for (i = 0; i < CONT_PTES; i++, pte++, addr += PAGE_SIZE, pfn += dpfn) {
+		if (pte_present(old_pte)) {
+			kvm_set_pte(pte, __pte(0));
+			kvm_tlb_flush_vmid_ipa(kvm, addr);
+		} else {
+			get_page(virt_to_page(pte));
+		}
+
+		kvm_set_pte(pte, kvm_pfn_pte(pfn, hugeprot));
+	}
+
+	return 0;
+}
+
 static int stage2_set_pte(struct kvm *kvm, struct kvm_mmu_memory_cache *cache,
 			  phys_addr_t addr, const pte_t *new_pte,
 			  unsigned long flags)
@@ -1824,7 +1893,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	 * As for PUD huge maps, we must make sure that we have at least
 	 * 3 levels, i.e, PMD is not folded.
 	 */
-	if (vma_pagesize == PMD_SIZE ||
+	if (vma_pagesize == CONT_PTE_SIZE || vma_pagesize == PMD_SIZE ||
 	    (vma_pagesize == PUD_SIZE && kvm_stage2_has_pmd(kvm)))
 		gfn = (fault_ipa & huge_page_mask(hstate_vma(vma))) >> PAGE_SHIFT;
 	up_read(&current->mm->mmap_sem);
@@ -1918,6 +1987,11 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 						 needs_exec, false);
 
 		ret = stage2_set_pmd_huge(kvm, memcache, fault_ipa, &new_pmd);
+	} else if (vma_pagesize == CONT_PTE_SIZE) {
+		pte_t new_pte = stage2_build_pte(pfn, mem_type, writable,
+						 needs_exec, true);
+
+		ret = stage2_set_cont_ptes(kvm, memcache, fault_ipa, &new_pte);
 	} else {
 		pte_t new_pte = stage2_build_pte(pfn, mem_type, writable,
 						 needs_exec, false);
-- 
1.8.3.1


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
