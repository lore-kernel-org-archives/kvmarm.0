Return-Path: <SRS0=MRip=75=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77DFAC433E1
	for <kvmarm@archiver.kernel.org>; Tue, 16 Jun 2020 09:36:32 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 390622074D
	for <kvmarm@archiver.kernel.org>; Tue, 16 Jun 2020 09:36:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 390622074D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E546D4B0F1;
	Tue, 16 Jun 2020 05:36:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SvyvYQaCA4LC; Tue, 16 Jun 2020 05:36:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 957C64B147;
	Tue, 16 Jun 2020 05:36:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 19C7C4B128
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Jun 2020 05:36:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mbBiL0lKh3tI for <kvmarm@lists.cs.columbia.edu>;
 Tue, 16 Jun 2020 05:36:24 -0400 (EDT)
Received: from huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EDB4C4B10D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Jun 2020 05:36:20 -0400 (EDT)
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
 by Forcepoint Email with ESMTP id D41EBD40471D8FD3AFBD;
 Tue, 16 Jun 2020 17:36:18 +0800 (CST)
Received: from DESKTOP-5IS4806.china.huawei.com (10.173.221.230) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.487.0; Tue, 16 Jun 2020 17:36:12 +0800
From: Keqian Zhu <zhukeqian1@huawei.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
 <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>
Subject: [PATCH 10/12] KVM: arm64: Save stage2 PTE dirty status if it is
 coverred
Date: Tue, 16 Jun 2020 17:35:51 +0800
Message-ID: <20200616093553.27512-11-zhukeqian1@huawei.com>
X-Mailer: git-send-email 2.8.4.windows.1
In-Reply-To: <20200616093553.27512-1-zhukeqian1@huawei.com>
References: <20200616093553.27512-1-zhukeqian1@huawei.com>
MIME-Version: 1.0
X-Originating-IP: [10.173.221.230]
X-CFilter-Loop: Reflected
Cc: Catalin Marinas <catalin.marinas@arm.com>,
 Sean Christopherson <sean.j.christopherson@intel.com>, liangpeng10@huawei.com,
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

There are two types of operations will change PTE and may cover
dirty status set by hardware.

1. Stage2 PTE unmapping: Page table merging (revert of huge page
table dissolving), kvm_unmap_hva_range() and so on.

2. Stage2 PTE changing: including user_mem_abort(), kvm_mmu_notifier
_change_pte() and so on.

All operations above will invoke kvm_set_pte() finally. We should
save the dirty status into memslot bitmap.

Question: Should we acquire kvm_slots_lock when invoke mark_page_dirty?
It seems that user_mem_abort does not acquire this lock when invoke it.

Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
---
 arch/arm64/kvm/mmu.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 898e272a2c07..a230fbcf3889 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -294,15 +294,23 @@ static void unmap_stage2_ptes(struct kvm *kvm, pmd_t *pmd,
 {
 	phys_addr_t start_addr = addr;
 	pte_t *pte, *start_pte;
+	bool dirty_coverred;
+	int idx;
 
 	start_pte = pte = pte_offset_kernel(pmd, addr);
 	do {
 		if (!pte_none(*pte)) {
 			pte_t old_pte = *pte;
 
-			kvm_set_pte(pte, __pte(0));
+			dirty_coverred = kvm_set_pte(pte, __pte(0));
 			kvm_tlb_flush_vmid_ipa(kvm, addr);
 
+			if (dirty_coverred) {
+				idx = srcu_read_lock(&kvm->srcu);
+				mark_page_dirty(kvm, addr >> PAGE_SHIFT);
+				srcu_read_unlock(&kvm->srcu, idx);
+			}
+
 			/* No need to invalidate the cache for device mappings */
 			if (!kvm_is_device_pfn(pte_pfn(old_pte)))
 				kvm_flush_dcache_pte(old_pte);
@@ -1388,6 +1396,8 @@ static int stage2_set_pte(struct kvm *kvm, struct kvm_mmu_memory_cache *cache,
 	pte_t *pte, old_pte;
 	bool iomap = flags & KVM_S2PTE_FLAG_IS_IOMAP;
 	bool logging_active = flags & KVM_S2_FLAG_LOGGING_ACTIVE;
+	bool dirty_coverred;
+	int idx;
 
 	VM_BUG_ON(logging_active && !cache);
 
@@ -1453,8 +1463,14 @@ static int stage2_set_pte(struct kvm *kvm, struct kvm_mmu_memory_cache *cache,
 		if (pte_val(old_pte) == pte_val(*new_pte))
 			return 0;
 
-		kvm_set_pte(pte, __pte(0));
+		dirty_coverred = kvm_set_pte(pte, __pte(0));
 		kvm_tlb_flush_vmid_ipa(kvm, addr);
+
+		if (dirty_coverred) {
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
