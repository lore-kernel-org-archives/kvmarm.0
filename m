Return-Path: <SRS0=bjrO=KC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7ADFC433ED
	for <kvmarm@archiver.kernel.org>; Fri,  7 May 2021 11:04:53 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 474976145E
	for <kvmarm@archiver.kernel.org>; Fri,  7 May 2021 11:04:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 474976145E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 935514B589;
	Fri,  7 May 2021 07:04:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 31oAq37qTAkm; Fri,  7 May 2021 07:04:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 564FF4B592;
	Fri,  7 May 2021 07:04:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9E3BA4B58E
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 May 2021 07:04:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nkqxeqHPR8mT for <kvmarm@lists.cs.columbia.edu>;
 Fri,  7 May 2021 07:04:49 -0400 (EDT)
Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2762E4B587
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 May 2021 07:04:49 -0400 (EDT)
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.58])
 by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4Fc6wJ5cqlzCqry;
 Fri,  7 May 2021 19:02:08 +0800 (CST)
Received: from DESKTOP-5IS4806.china.huawei.com (10.174.187.224) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.498.0; Fri, 7 May 2021 19:04:38 +0800
From: Keqian Zhu <zhukeqian1@huawei.com>
To: <linux-arm-kernel@lists.infradead.org>, <kvm@vger.kernel.org>,
 <kvmarm@lists.cs.columbia.edu>, Marc Zyngier <maz@kernel.org>
Subject: [PATCH v5 1/2] kvm/arm64: Remove the creation time's mapping of MMIO
 regions
Date: Fri, 7 May 2021 19:03:21 +0800
Message-ID: <20210507110322.23348-2-zhukeqian1@huawei.com>
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

The MMIO regions may be unmapped for many reasons and can be remapped
by stage2 fault path. Map MMIO regions at creation time becomes a
minor optimization and makes these two mapping path hard to sync.

Remove the mapping code while keep the useful sanity check.

Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
---
 arch/arm64/kvm/mmu.c | 38 +++-----------------------------------
 1 file changed, 3 insertions(+), 35 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index c5d1f3c87dbd..16efd47439a6 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1346,7 +1346,6 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 {
 	hva_t hva = mem->userspace_addr;
 	hva_t reg_end = hva + mem->memory_size;
-	bool writable = !(mem->flags & KVM_MEM_READONLY);
 	int ret = 0;
 
 	if (change != KVM_MR_CREATE && change != KVM_MR_MOVE &&
@@ -1363,8 +1362,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 	mmap_read_lock(current->mm);
 	/*
 	 * A memory region could potentially cover multiple VMAs, and any holes
-	 * between them, so iterate over all of them to find out if we can map
-	 * any of them right now.
+	 * between them, so iterate over all of them.
 	 *
 	 *     +--------------------------------------------+
 	 * +---------------+----------------+   +----------------+
@@ -1375,51 +1373,21 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 	 */
 	do {
 		struct vm_area_struct *vma;
-		hva_t vm_start, vm_end;
 
 		vma = find_vma_intersection(current->mm, hva, reg_end);
 		if (!vma)
 			break;
 
-		/*
-		 * Take the intersection of this VMA with the memory region
-		 */
-		vm_start = max(hva, vma->vm_start);
-		vm_end = min(reg_end, vma->vm_end);
-
 		if (vma->vm_flags & VM_PFNMAP) {
-			gpa_t gpa = mem->guest_phys_addr +
-				    (vm_start - mem->userspace_addr);
-			phys_addr_t pa;
-
-			pa = (phys_addr_t)vma->vm_pgoff << PAGE_SHIFT;
-			pa += vm_start - vma->vm_start;
-
 			/* IO region dirty page logging not allowed */
 			if (memslot->flags & KVM_MEM_LOG_DIRTY_PAGES) {
 				ret = -EINVAL;
-				goto out;
-			}
-
-			ret = kvm_phys_addr_ioremap(kvm, gpa, pa,
-						    vm_end - vm_start,
-						    writable);
-			if (ret)
 				break;
+			}
 		}
-		hva = vm_end;
+		hva = min(reg_end, vma->vm_end);
 	} while (hva < reg_end);
 
-	if (change == KVM_MR_FLAGS_ONLY)
-		goto out;
-
-	spin_lock(&kvm->mmu_lock);
-	if (ret)
-		unmap_stage2_range(&kvm->arch.mmu, mem->guest_phys_addr, mem->memory_size);
-	else if (!cpus_have_final_cap(ARM64_HAS_STAGE2_FWB))
-		stage2_flush_memslot(kvm, memslot);
-	spin_unlock(&kvm->mmu_lock);
-out:
 	mmap_read_unlock(current->mm);
 	return ret;
 }
-- 
2.19.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
