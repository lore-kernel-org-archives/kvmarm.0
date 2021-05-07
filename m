Return-Path: <SRS0=bjrO=KC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2C15C43462
	for <kvmarm@archiver.kernel.org>; Fri,  7 May 2021 11:04:54 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 395E661466
	for <kvmarm@archiver.kernel.org>; Fri,  7 May 2021 11:04:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 395E661466
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CAF8A4B58E;
	Fri,  7 May 2021 07:04:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id f9vOVUpVpGtn; Fri,  7 May 2021 07:04:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8A3294B5B0;
	Fri,  7 May 2021 07:04:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BD1344B584
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 May 2021 07:04:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FlwW0haueQ9K for <kvmarm@lists.cs.columbia.edu>;
 Fri,  7 May 2021 07:04:49 -0400 (EDT)
Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 197524B581
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 May 2021 07:04:49 -0400 (EDT)
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.58])
 by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4Fc6wJ68SJzCr09;
 Fri,  7 May 2021 19:02:08 +0800 (CST)
Received: from DESKTOP-5IS4806.china.huawei.com (10.174.187.224) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.498.0; Fri, 7 May 2021 19:04:39 +0800
From: Keqian Zhu <zhukeqian1@huawei.com>
To: <linux-arm-kernel@lists.infradead.org>, <kvm@vger.kernel.org>,
 <kvmarm@lists.cs.columbia.edu>, Marc Zyngier <maz@kernel.org>
Subject: [PATCH v5 2/2] kvm/arm64: Try stage2 block mapping for host device
 MMIO
Date: Fri, 7 May 2021 19:03:22 +0800
Message-ID: <20210507110322.23348-3-zhukeqian1@huawei.com>
X-Mailer: git-send-email 2.8.4.windows.1
In-Reply-To: <20210507110322.23348-1-zhukeqian1@huawei.com>
References: <20210507110322.23348-1-zhukeqian1@huawei.com>
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

This adds get_vma_page_shift() to get page shift for both normal
memory and device MMIO region, and check these two points when
selecting block mapping size for MMIO region.

Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
---
 arch/arm64/kvm/mmu.c | 61 ++++++++++++++++++++++++++++++++++++--------
 1 file changed, 51 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 16efd47439a6..2a3d3b760550 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -822,6 +822,35 @@ transparent_hugepage_adjust(struct kvm_memory_slot *memslot,
 	return PAGE_SIZE;
 }
 
+static int get_vma_page_shift(struct vm_area_struct *vma, unsigned long hva)
+{
+	unsigned long pa;
+
+	if (is_vm_hugetlb_page(vma) && !(vma->vm_flags & VM_PFNMAP))
+		return huge_page_shift(hstate_vma(vma));
+
+	if (!(vma->vm_flags & VM_PFNMAP))
+		return PAGE_SHIFT;
+
+	VM_BUG_ON(is_vm_hugetlb_page(vma));
+
+	pa = (vma->vm_pgoff << PAGE_SHIFT) + (hva - vma->vm_start);
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
 static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			  struct kvm_memory_slot *memslot, unsigned long hva,
 			  unsigned long fault_status)
@@ -853,7 +882,10 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
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
@@ -862,15 +894,15 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		return -EFAULT;
 	}
 
-	if (is_vm_hugetlb_page(vma))
-		vma_shift = huge_page_shift(hstate_vma(vma));
-	else
-		vma_shift = PAGE_SHIFT;
-
-	if (logging_active ||
-	    (vma->vm_flags & VM_PFNMAP)) {
+	/*
+	 * logging_active is guaranteed to never be true for VM_PFNMAP
+	 * memslots.
+	 */
+	if (logging_active) {
 		force_pte = true;
 		vma_shift = PAGE_SHIFT;
+	} else {
+		vma_shift = get_vma_page_shift(vma, hva);
 	}
 
 	switch (vma_shift) {
@@ -943,8 +975,17 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		return -EFAULT;
 
 	if (kvm_is_device_pfn(pfn)) {
+		/*
+		 * If the page was identified as device early by looking at
+		 * the VMA flags, vma_pagesize is already representing the
+		 * largest quantity we can map.  If instead it was mapped
+		 * via gfn_to_pfn_prot(), vma_pagesize is set to PAGE_SIZE
+		 * and must not be upgraded.
+		 *
+		 * In both cases, we don't let transparent_hugepage_adjust()
+		 * change things at the last minute.
+		 */
 		device = true;
-		force_pte = true;
 	} else if (logging_active && !write_fault) {
 		/*
 		 * Only actually map the page as writable if this was a write
@@ -965,7 +1006,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	 * If we are not forced to use page mapping, check if we are
 	 * backed by a THP and thus use block mapping if possible.
 	 */
-	if (vma_pagesize == PAGE_SIZE && !force_pte)
+	if (vma_pagesize == PAGE_SIZE && !(force_pte || device))
 		vma_pagesize = transparent_hugepage_adjust(memslot, hva,
 							   &pfn, &fault_ipa);
 	if (writable)
-- 
2.19.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
