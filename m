Return-Path: <SRS0=CSPl=AN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58610C433E1
	for <kvmarm@archiver.kernel.org>; Thu,  2 Jul 2020 13:57:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1A6762088E
	for <kvmarm@archiver.kernel.org>; Thu,  2 Jul 2020 13:57:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1A6762088E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C8B874B475;
	Thu,  2 Jul 2020 09:57:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PKVVoL6Cy6dr; Thu,  2 Jul 2020 09:57:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A89DC4B561;
	Thu,  2 Jul 2020 09:57:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C5E94B475
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jul 2020 09:57:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TS1YLF0ghC-K for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Jul 2020 09:57:09 -0400 (EDT)
Received: from huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 671554B589
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jul 2020 09:57:09 -0400 (EDT)
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.60])
 by Forcepoint Email with ESMTP id C489A4599281558D6B9C;
 Thu,  2 Jul 2020 21:56:15 +0800 (CST)
Received: from DESKTOP-5IS4806.china.huawei.com (10.174.187.22) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.487.0; Thu, 2 Jul 2020 21:56:05 +0800
From: Keqian Zhu <zhukeqian1@huawei.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
 <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>
Subject: [PATCH v2 4/8] KVM: arm64: Save stage2 PTE dirty status if it is
 covered
Date: Thu, 2 Jul 2020 21:55:52 +0800
Message-ID: <20200702135556.36896-5-zhukeqian1@huawei.com>
X-Mailer: git-send-email 2.8.4.windows.1
In-Reply-To: <20200702135556.36896-1-zhukeqian1@huawei.com>
References: <20200702135556.36896-1-zhukeqian1@huawei.com>
MIME-Version: 1.0
X-Originating-IP: [10.174.187.22]
X-CFilter-Loop: Reflected
Cc: Catalin Marinas <catalin.marinas@arm.com>,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 Steven Price <steven.price@arm.com>, liangpeng10@huawei.com,
 Alexios Zavras <alexios.zavras@intel.com>, Mark Brown <broonie@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Thomas
 Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
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

kvm_set_pte is called to replace a target PTE with a desired one.
We always do this without changing the desired one, but if dirty
status set by hardware is covered, let caller know it.

There are two types of operations will change PTE and may cover
dirty status set by hardware.

1. Stage2 PTE unmapping: Page table merging (revert of huge page
table dissolving), kvm_unmap_hva_range() and so on.

2. Stage2 PTE changing: including user_mem_abort(), kvm_mmu_notifier
_change_pte() and so on.

All operations above will invoke kvm_set_pte() finally. We should
save the dirty status into memslot bitmap.

Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
Signed-off-by: Peng Liang <liangpeng10@huawei.com>
---
 arch/arm64/include/asm/kvm_mmu.h |  5 ++++
 arch/arm64/kvm/mmu.c             | 42 ++++++++++++++++++++++++++++----
 2 files changed, 42 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index a1b6131d980c..adb5c8edb29e 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -295,6 +295,11 @@ static inline bool kvm_mmu_hw_dbm_enabled(struct kvm *kvm)
 	return arm_mmu_hw_dbm_supported() && !!(kvm->arch.vtcr & VTCR_EL2_HD);
 }
 
+static inline bool kvm_s2pte_dbm(pte_t *ptep)
+{
+	return !!(READ_ONCE(pte_val(*ptep)) & PTE_DBM);
+}
+
 #define hyp_pte_table_empty(ptep) kvm_page_empty(ptep)
 
 #ifdef __PAGETABLE_PMD_FOLDED
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index ab8a6ceecbd8..d0c34549ef3b 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -194,10 +194,26 @@ static void clear_stage2_pmd_entry(struct kvm *kvm, pmd_t *pmd, phys_addr_t addr
 	put_page(virt_to_page(pmd));
 }
 
-static inline void kvm_set_pte(pte_t *ptep, pte_t new_pte)
+/**
+ * @ret: true if dirty status set by hardware is covered.
+ */
+static inline bool kvm_set_pte(pte_t *ptep, pte_t new_pte)
 {
-	WRITE_ONCE(*ptep, new_pte);
-	dsb(ishst);
+	pteval_t old_pteval;
+	bool old_logging, new_no_write;
+
+	old_logging = IS_ENABLED(CONFIG_ARM64_HW_AFDBM) &&
+		arm_mmu_hw_dbm_supported() && kvm_s2pte_dbm(ptep);
+	new_no_write = pte_none(new_pte) || kvm_s2pte_readonly(&new_pte);
+
+	if (!old_logging || !new_no_write) {
+		WRITE_ONCE(*ptep, new_pte);
+		dsb(ishst);
+		return false;
+	}
+
+	old_pteval = xchg(&pte_val(*ptep), pte_val(new_pte));
+	return !kvm_s2pte_readonly(&__pte(old_pteval));
 }
 
 static inline void kvm_set_pmd(pmd_t *pmdp, pmd_t new_pmd)
@@ -260,15 +276,23 @@ static void unmap_stage2_ptes(struct kvm *kvm, pmd_t *pmd,
 {
 	phys_addr_t start_addr = addr;
 	pte_t *pte, *start_pte;
+	bool dirty_covered;
+	int idx;
 
 	start_pte = pte = pte_offset_kernel(pmd, addr);
 	do {
 		if (!pte_none(*pte)) {
 			pte_t old_pte = *pte;
 
-			kvm_set_pte(pte, __pte(0));
+			dirty_covered = kvm_set_pte(pte, __pte(0));
 			kvm_tlb_flush_vmid_ipa(kvm, addr);
 
+			if (dirty_covered) {
+				idx = srcu_read_lock(&kvm->srcu);
+				mark_page_dirty(kvm, addr >> PAGE_SHIFT);
+				srcu_read_unlock(&kvm->srcu, idx);
+			}
+
 			/* No need to invalidate the cache for device mappings */
 			if (!kvm_is_device_pfn(pte_pfn(old_pte)))
 				kvm_flush_dcache_pte(old_pte);
@@ -1354,6 +1378,8 @@ static int stage2_set_pte(struct kvm *kvm, struct kvm_mmu_memory_cache *cache,
 	pte_t *pte, old_pte;
 	bool iomap = flags & KVM_S2PTE_FLAG_IS_IOMAP;
 	bool logging_active = flags & KVM_S2_FLAG_LOGGING_ACTIVE;
+	bool dirty_covered;
+	int idx;
 
 	VM_BUG_ON(logging_active && !cache);
 
@@ -1419,8 +1445,14 @@ static int stage2_set_pte(struct kvm *kvm, struct kvm_mmu_memory_cache *cache,
 		if (pte_val(old_pte) == pte_val(*new_pte))
 			return 0;
 
-		kvm_set_pte(pte, __pte(0));
+		dirty_covered = kvm_set_pte(pte, __pte(0));
 		kvm_tlb_flush_vmid_ipa(kvm, addr);
+
+		if (dirty_covered) {
+			idx = srcu_read_lock(&kvm->srcu);
+			mark_page_dirty(kvm, addr >> PAGE_SHIFT);
+			srcu_read_unlock(&kvm->srcu, idx);
+		}
 	} else {
 		get_page(virt_to_page(pte));
 	}
-- 
2.19.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
