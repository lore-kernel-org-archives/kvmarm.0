Return-Path: <SRS0=hZsu=JL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11592C43462
	for <kvmarm@archiver.kernel.org>; Wed, 14 Apr 2021 06:52:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6F9A2611F2
	for <kvmarm@archiver.kernel.org>; Wed, 14 Apr 2021 06:52:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6F9A2611F2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 144744B6A2;
	Wed, 14 Apr 2021 02:52:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vOPqG-wcAaz3; Wed, 14 Apr 2021 02:52:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 050664B6DA;
	Wed, 14 Apr 2021 02:52:10 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B8BE4B6BD
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Apr 2021 02:52:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id j97KPEUOFM+e for <kvmarm@lists.cs.columbia.edu>;
 Wed, 14 Apr 2021 02:52:07 -0400 (EDT)
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DD3444B643
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Apr 2021 02:52:06 -0400 (EDT)
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
 by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FKtNz4Np5zNw2V;
 Wed, 14 Apr 2021 14:49:07 +0800 (CST)
Received: from DESKTOP-5IS4806.china.huawei.com (10.174.187.224) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.498.0; Wed, 14 Apr 2021 14:51:55 +0800
From: Keqian Zhu <zhukeqian1@huawei.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
 <kvm@vger.kernel.org>, <kvmarm@lists.cs.columbia.edu>, Marc Zyngier
 <maz@kernel.org>
Subject: [PATCH v3 2/2] kvm/arm64: Try stage2 block mapping for host device
 MMIO
Date: Wed, 14 Apr 2021 14:51:09 +0800
Message-ID: <20210414065109.8616-3-zhukeqian1@huawei.com>
X-Mailer: git-send-email 2.8.4.windows.1
In-Reply-To: <20210414065109.8616-1-zhukeqian1@huawei.com>
References: <20210414065109.8616-1-zhukeqian1@huawei.com>
MIME-Version: 1.0
X-Originating-IP: [10.174.187.224]
X-CFilter-Loop: Reflected
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

The MMIO region of a device maybe huge (GB level), try to use
block mapping in stage2 to speedup both map and unmap.

Compared to normal memory mapping, we should consider two more
points when try block mapping for MMIO region:

1. For normal memory mapping, the PA(host physical address) and
HVA have same alignment within PUD_SIZE or PMD_SIZE when we use
the HVA to request hugepage, so we don't need to consider PA
alignment when verifing block mapping. But for device memory
mapping, the PA and HVA may have different alignment.

2. For normal memory mapping, we are sure hugepage size properly
fit into vma, so we don't check whether the mapping size exceeds
the boundary of vma. But for device memory mapping, we should pay
attention to this.

This adds device_rough_page_shift() to check these two points when
selecting block mapping size.

Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
---
 arch/arm64/kvm/mmu.c | 37 +++++++++++++++++++++++++++++++++----
 1 file changed, 33 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index c59af5ca01b0..1a6d96169d60 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -624,6 +624,31 @@ static void kvm_send_hwpoison_signal(unsigned long address, short lsb)
 	send_sig_mceerr(BUS_MCEERR_AR, (void __user *)address, lsb, current);
 }
 
+/*
+ * Find a max mapping size that properly insides the vma. And hva and pa must
+ * have the same alignment to this mapping size. It's rough as there are still
+ * other restrictions, will be checked by fault_supports_stage2_huge_mapping().
+ */
+static short device_rough_page_shift(struct vm_area_struct *vma,
+				     unsigned long hva)
+{
+	phys_addr_t pa = (vma->vm_pgoff << PAGE_SHIFT) + (hva - vma->vm_start);
+
+#ifndef __PAGETABLE_PMD_FOLDED
+	if ((hva & (PUD_SIZE - 1)) == (pa & (PUD_SIZE - 1)) &&
+	    ALIGN_DOWN(hva, PUD_SIZE) >= vma->vm_start &&
+	    ALIGN(hva, PUD_SIZE) <= vma->vm_end)
+		return PUD_SHIFT;
+#endif
+
+	if ((hva & (PMD_SIZE - 1)) == (pa & (PMD_SIZE - 1)) &&
+	    ALIGN_DOWN(hva, PMD_SIZE) >= vma->vm_start &&
+	    ALIGN(hva, PMD_SIZE) <= vma->vm_end)
+		return PMD_SHIFT;
+
+	return PAGE_SHIFT;
+}
+
 static bool fault_supports_stage2_huge_mapping(struct kvm_memory_slot *memslot,
 					       unsigned long hva,
 					       unsigned long map_size)
@@ -769,7 +794,10 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		return -EFAULT;
 	}
 
-	/* Let's check if we will get back a huge page backed by hugetlbfs */
+	/*
+	 * Let's check if we will get back a huge page backed by hugetlbfs, or
+	 * get block mapping for device MMIO region.
+	 */
 	mmap_read_lock(current->mm);
 	vma = find_vma_intersection(current->mm, hva, hva + 1);
 	if (unlikely(!vma)) {
@@ -780,11 +808,12 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 
 	if (is_vm_hugetlb_page(vma))
 		vma_shift = huge_page_shift(hstate_vma(vma));
+	else if (vma->vm_flags & VM_PFNMAP)
+		vma_shift = device_rough_page_shift(vma, hva);
 	else
 		vma_shift = PAGE_SHIFT;
 
-	if (logging_active ||
-	    (vma->vm_flags & VM_PFNMAP)) {
+	if (logging_active) {
 		force_pte = true;
 		vma_shift = PAGE_SHIFT;
 	}
@@ -855,7 +884,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 
 	if (kvm_is_device_pfn(pfn)) {
 		device = true;
-		force_pte = true;
+		force_pte = (vma_pagesize == PAGE_SIZE);
 	} else if (logging_active && !write_fault) {
 		/*
 		 * Only actually map the page as writable if this was a write
-- 
2.19.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
