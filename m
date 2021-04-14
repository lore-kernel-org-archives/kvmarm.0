Return-Path: <SRS0=hZsu=JL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 301A9C43460
	for <kvmarm@archiver.kernel.org>; Wed, 14 Apr 2021 06:52:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7BDBA613C0
	for <kvmarm@archiver.kernel.org>; Wed, 14 Apr 2021 06:52:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7BDBA613C0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CE3114B643;
	Wed, 14 Apr 2021 02:52:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id a0xXZuVa6Ens; Wed, 14 Apr 2021 02:52:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D9BFB4B6AB;
	Wed, 14 Apr 2021 02:52:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 38DF34B6B6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Apr 2021 02:52:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id viY1lhZg13Gq for <kvmarm@lists.cs.columbia.edu>;
 Wed, 14 Apr 2021 02:52:07 -0400 (EDT)
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6F79C4B6A7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Apr 2021 02:52:07 -0400 (EDT)
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
 by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FKtNz4ydKzNw04;
 Wed, 14 Apr 2021 14:49:07 +0800 (CST)
Received: from DESKTOP-5IS4806.china.huawei.com (10.174.187.224) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.498.0; Wed, 14 Apr 2021 14:51:54 +0800
From: Keqian Zhu <zhukeqian1@huawei.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
 <kvm@vger.kernel.org>, <kvmarm@lists.cs.columbia.edu>, Marc Zyngier
 <maz@kernel.org>
Subject: [PATCH v3 1/2] kvm/arm64: Remove the creation time's mapping of MMIO
 regions
Date: Wed, 14 Apr 2021 14:51:08 +0800
Message-ID: <20210414065109.8616-2-zhukeqian1@huawei.com>
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

The MMIO regions may be unmapped for many reasons and can be remapped
by stage2 fault path. Map MMIO regions at creation time becomes a
minor optimization and makes these two mapping path hard to sync.

Remove the mapping code while keep the useful sanity check.

Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
---
 arch/arm64/kvm/mmu.c | 38 +++-----------------------------------
 1 file changed, 3 insertions(+), 35 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 8711894db8c2..c59af5ca01b0 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1301,7 +1301,6 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 {
 	hva_t hva = mem->userspace_addr;
 	hva_t reg_end = hva + mem->memory_size;
-	bool writable = !(mem->flags & KVM_MEM_READONLY);
 	int ret = 0;
 
 	if (change != KVM_MR_CREATE && change != KVM_MR_MOVE &&
@@ -1318,8 +1317,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 	mmap_read_lock(current->mm);
 	/*
 	 * A memory region could potentially cover multiple VMAs, and any holes
-	 * between them, so iterate over all of them to find out if we can map
-	 * any of them right now.
+	 * between them, so iterate over all of them.
 	 *
 	 *     +--------------------------------------------+
 	 * +---------------+----------------+   +----------------+
@@ -1330,50 +1328,20 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 	 */
 	do {
 		struct vm_area_struct *vma = find_vma(current->mm, hva);
-		hva_t vm_start, vm_end;
 
 		if (!vma || vma->vm_start >= reg_end)
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
