Return-Path: <SRS0=Vsle=TB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A92EAC43219
	for <kvmarm@archiver.kernel.org>; Wed,  1 May 2019 09:48:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 671F52177B
	for <kvmarm@archiver.kernel.org>; Wed,  1 May 2019 09:48:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 671F52177B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0FB874A4FA;
	Wed,  1 May 2019 05:48:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4sJYjlY0VC-Z; Wed,  1 May 2019 05:48:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8AB294A502;
	Wed,  1 May 2019 05:48:27 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7D21A4A4F2
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 May 2019 05:48:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Xo0sxAMSAjK4 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  1 May 2019 05:48:25 -0400 (EDT)
Received: from huawei.com (szxga06-in.huawei.com [45.249.212.32])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E9DC24A4F7
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 May 2019 05:48:24 -0400 (EDT)
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.58])
 by Forcepoint Email with ESMTP id CEDEF9F163E2777B5360;
 Wed,  1 May 2019 17:48:19 +0800 (CST)
Received: from HGHY2Y004646261.china.huawei.com (10.184.12.158) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.439.0; Wed, 1 May 2019 17:48:09 +0800
From: Zenghui Yu <yuzenghui@huawei.com>
To: <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.cs.columbia.edu>,
 <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
Subject: [PATCH 3/5] KVM: arm/arm64: Support dirty page tracking for
 contiguous hugepages
Date: Wed, 1 May 2019 09:44:25 +0000
Message-ID: <1556703867-22396-4-git-send-email-yuzenghui@huawei.com>
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
Message-ID: <20190501094425.jJi4-2nTDpwSPTYxaoPRgYPj7zs4aHFHOJDYAdczK7Q@z>

When logging is enabled, we should keep tracking of normal size pages.
If the memslot is backed by contiguous hugepages, we should dissolve
the contiguous hugepages - clear the whole contiguous range and flush
corresponding TLB entry.

Move kvm_set_{pte,pmd} to the front of stage2_dissolve_cont_{pte,pmd}s
to avoid one more declaration.

Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
---
 arch/arm/include/asm/pgtable-hwdef.h |  8 ++++
 virt/kvm/arm/mmu.c                   | 76 ++++++++++++++++++++++++++++++------
 2 files changed, 72 insertions(+), 12 deletions(-)

diff --git a/arch/arm/include/asm/pgtable-hwdef.h b/arch/arm/include/asm/pgtable-hwdef.h
index 8426229..41f4633 100644
--- a/arch/arm/include/asm/pgtable-hwdef.h
+++ b/arch/arm/include/asm/pgtable-hwdef.h
@@ -16,4 +16,12 @@
 #include <asm/pgtable-2level-hwdef.h>
 #endif
 
+/* dummy definition */
+#define CONT_PTES		(0)
+#define CONT_PTE_SIZE		(0)
+#define CONT_PTE_MASK		(0)
+#define CONT_PMDS		(0)
+#define CONT_PMD_SIZE		(0)
+#define CONT_PMD_MASK		(0)
+
 #endif
diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index cf8b035..36c863f 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -96,6 +96,58 @@ static bool kvm_is_device_pfn(unsigned long pfn)
 	return !pfn_valid(pfn);
 }
 
+static inline void kvm_set_pte(pte_t *ptep, pte_t new_pte)
+{
+	WRITE_ONCE(*ptep, new_pte);
+	dsb(ishst);
+}
+
+static inline void kvm_set_pmd(pmd_t *pmdp, pmd_t new_pmd)
+{
+	WRITE_ONCE(*pmdp, new_pmd);
+	dsb(ishst);
+}
+
+static void stage2_dissolve_cont_ptes(struct kvm *kvm, phys_addr_t addr,
+				      pte_t *pte)
+{
+	phys_addr_t addrp;
+	pte_t *ptep;
+	int i;
+
+	if (!kvm_s2pte_cont(*pte))
+		return;
+
+	/* Start with the first pte */
+	addrp = addr & CONT_PTE_MASK;
+	ptep = pte - (addr - addrp) / PAGE_SIZE;
+
+	for (i = 0; i < CONT_PTES; i++, ptep++, addrp += PAGE_SIZE) {
+		kvm_set_pte(ptep, __pte(0));
+		kvm_tlb_flush_vmid_ipa(kvm, addrp);
+		put_page(virt_to_page(ptep));
+	}
+}
+
+static void stage2_dissolve_cont_pmds(struct kvm *kvm, phys_addr_t addr,
+				      pmd_t *pmd)
+{
+	phys_addr_t addrp;
+	pmd_t *pmdp;
+	int i;
+
+	/* Start with the first pmd */
+	addr &= PMD_MASK;
+	addrp = addr & CONT_PMD_MASK;
+	pmdp = pmd - (addr - addrp) / PMD_SIZE;
+
+	for (i = 0; i < CONT_PMDS; i++, pmdp++, addrp += PMD_SIZE) {
+		pmd_clear(pmdp);
+		kvm_tlb_flush_vmid_ipa(kvm, addrp);
+		put_page(virt_to_page(pmdp));
+	}
+}
+
 /**
  * stage2_dissolve_pmd() - clear and flush huge PMD entry
  * @kvm:	pointer to kvm structure.
@@ -109,6 +161,11 @@ static void stage2_dissolve_pmd(struct kvm *kvm, phys_addr_t addr, pmd_t *pmd)
 	if (!pmd_thp_or_huge(*pmd))
 		return;
 
+	if (kvm_s2pmd_cont(*pmd)) {
+		stage2_dissolve_cont_pmds(kvm, addr, pmd);
+		return;
+	}
+
 	pmd_clear(pmd);
 	kvm_tlb_flush_vmid_ipa(kvm, addr);
 	put_page(virt_to_page(pmd));
@@ -193,18 +250,6 @@ static void clear_stage2_pmd_entry(struct kvm *kvm, pmd_t *pmd, phys_addr_t addr
 	put_page(virt_to_page(pmd));
 }
 
-static inline void kvm_set_pte(pte_t *ptep, pte_t new_pte)
-{
-	WRITE_ONCE(*ptep, new_pte);
-	dsb(ishst);
-}
-
-static inline void kvm_set_pmd(pmd_t *pmdp, pmd_t new_pmd)
-{
-	WRITE_ONCE(*pmdp, new_pmd);
-	dsb(ishst);
-}
-
 static inline void kvm_pmd_populate(pmd_t *pmdp, pte_t *ptep)
 {
 	kvm_set_pmd(pmdp, kvm_mk_pmd(ptep));
@@ -1289,6 +1334,13 @@ static int stage2_set_pte(struct kvm *kvm, struct kvm_mmu_memory_cache *cache,
 
 	pte = pte_offset_kernel(pmd, addr);
 
+	/*
+	 * While dirty page logging - dissolve contiguous PTE pages, then
+	 * continue on to allocate page.
+	 */
+	if (logging_active)
+		stage2_dissolve_cont_ptes(kvm, addr, pte);
+
 	if (iomap && pte_present(*pte))
 		return -EFAULT;
 
-- 
1.8.3.1


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
