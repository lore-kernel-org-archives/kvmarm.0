Return-Path: <SRS0=Vsle=TB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A26EC04AA8
	for <kvmarm@archiver.kernel.org>; Wed,  1 May 2019 09:48:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DB3F52177B
	for <kvmarm@archiver.kernel.org>; Wed,  1 May 2019 09:48:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DB3F52177B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 856D64A518;
	Wed,  1 May 2019 05:48:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id onnoD56bVela; Wed,  1 May 2019 05:48:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 49DE34A508;
	Wed,  1 May 2019 05:48:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B92B4A4F2
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 May 2019 05:48:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wb8Vh-k3PAi3 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  1 May 2019 05:48:23 -0400 (EDT)
Received: from huawei.com (szxga06-in.huawei.com [45.249.212.32])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8FDE74A4E4
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 May 2019 05:48:22 -0400 (EDT)
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.58])
 by Forcepoint Email with ESMTP id C6025F73C997A760BED0;
 Wed,  1 May 2019 17:48:19 +0800 (CST)
Received: from HGHY2Y004646261.china.huawei.com (10.184.12.158) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.439.0; Wed, 1 May 2019 17:48:10 +0800
From: Zenghui Yu <yuzenghui@huawei.com>
To: <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.cs.columbia.edu>,
 <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
Subject: [PATCH 5/5] KVM: arm/arm64: Add support for creating PMD contiguous
 hugepages at stage2
Date: Wed, 1 May 2019 09:44:27 +0000
Message-ID: <1556703867-22396-6-git-send-email-yuzenghui@huawei.com>
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
Message-ID: <20190501094427.Ee1mOIfSZSk-dghVh73tkOKP3lNeSr6LWsz7jzfRDdo@z>

With this patch, we now support PMD contiguous hugepages at stage2, with
following additional page size at stage2:

                CONT PMD
                --------
 4K granule:      32M
16K granule:       1G
64K granule:      16G

Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
---
 virt/kvm/arm/mmu.c | 66 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 66 insertions(+)

diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index fdd6314..7173589 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -1125,6 +1125,66 @@ static pte_t *stage2_get_pte(struct kvm *kvm, struct kvm_mmu_memory_cache *cache
 	return pte_offset_kernel(pmd, addr);
 }
 
+static inline pgprot_t pmd_pgprot(pmd_t pmd)
+{
+	unsigned long pfn = pmd_pfn(pmd);
+
+	return __pgprot(pmd_val(pfn_pmd(pfn, __pgprot(0))) ^ pmd_val(pmd));
+}
+
+static int stage2_set_cont_pmds(struct kvm *kvm, struct kvm_mmu_memory_cache
+				*cache, phys_addr_t addr, const pmd_t *new_pmd)
+{
+	pmd_t *pmd, old_pmd;
+	unsigned long pfn, dpfn;
+	int i;
+	pgprot_t hugeprot;
+	phys_addr_t baddr;
+
+	/* Start with the first pmd. */
+	addr &= CONT_PMD_MASK;
+	pfn = pmd_pfn(*new_pmd);
+	dpfn = PMD_SIZE >> PAGE_SHIFT;
+	hugeprot = pmd_pgprot(*new_pmd);
+
+retry:
+	pmd = stage2_get_pmd(kvm, cache, addr);
+	VM_BUG_ON(!pmd);
+
+	old_pmd = *pmd;
+
+	/* Skip page table update if there is no change */
+	if (pmd_val(old_pmd) == pmd_val(*new_pmd))
+		return 0;
+
+	/*
+	 * baddr and the following loop is for only one scenario:
+	 * logging cancel ... Can we do it better?
+	 */
+	baddr = addr;
+	for (i = 0; i < CONT_PMDS; i++, pmd++, baddr += PMD_SIZE) {
+		if (pmd_present(*pmd) && !pmd_thp_or_huge(*pmd)) {
+			unmap_stage2_range(kvm, baddr, S2_PMD_SIZE);
+			goto retry;
+		}
+	}
+
+	pmd = stage2_get_pmd(kvm, cache, addr);
+
+	for (i = 0; i < CONT_PMDS; i++, pmd++, addr += PMD_SIZE, pfn += dpfn) {
+		if (pmd_present(old_pmd)) {
+			pmd_clear(pmd);
+			kvm_tlb_flush_vmid_ipa(kvm, addr);
+		} else {
+			get_page(virt_to_page(pmd));
+		}
+
+		kvm_set_pmd(pmd, pfn_pmd(pfn, hugeprot));
+	}
+
+	return 0;
+}
+
 static int stage2_set_pmd_huge(struct kvm *kvm, struct kvm_mmu_memory_cache
 			       *cache, phys_addr_t addr, const pmd_t *new_pmd)
 {
@@ -1894,6 +1954,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	 * 3 levels, i.e, PMD is not folded.
 	 */
 	if (vma_pagesize == CONT_PTE_SIZE || vma_pagesize == PMD_SIZE ||
+	    vma_pagesize == CONT_PMD_SIZE ||
 	    (vma_pagesize == PUD_SIZE && kvm_stage2_has_pmd(kvm)))
 		gfn = (fault_ipa & huge_page_mask(hstate_vma(vma))) >> PAGE_SHIFT;
 	up_read(&current->mm->mmap_sem);
@@ -1982,6 +2043,11 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 						 needs_exec);
 
 		ret = stage2_set_pud_huge(kvm, memcache, fault_ipa, &new_pud);
+	} else if (vma_pagesize == CONT_PMD_SIZE) {
+		pmd_t new_pmd = stage2_build_pmd(pfn, mem_type, writable,
+						 needs_exec, true);
+
+		ret = stage2_set_cont_pmds(kvm, memcache, fault_ipa, &new_pmd);
 	} else if (vma_pagesize == PMD_SIZE) {
 		pmd_t new_pmd = stage2_build_pmd(pfn, mem_type, writable,
 						 needs_exec, false);
-- 
1.8.3.1


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
