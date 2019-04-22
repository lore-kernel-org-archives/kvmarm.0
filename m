Return-Path: <SRS0=1O2p=SY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36210C10F11
	for <kvmarm@archiver.kernel.org>; Mon, 22 Apr 2019 19:42:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D9FAE21738
	for <kvmarm@archiver.kernel.org>; Mon, 22 Apr 2019 19:42:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="gi9iIL6D"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D9FAE21738
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 963714A4D7;
	Mon, 22 Apr 2019 15:42:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7VnzlVsnYYkO; Mon, 22 Apr 2019 15:42:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 28DCE4A4DA;
	Mon, 22 Apr 2019 15:42:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7B0094A460
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Apr 2019 15:42:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id x82ik2Bp01xn for <kvmarm@lists.cs.columbia.edu>;
 Mon, 22 Apr 2019 15:42:52 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 376124A4C5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Apr 2019 15:42:52 -0400 (EDT)
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net
 [73.47.72.35])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 915D021738;
 Mon, 22 Apr 2019 19:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1555962171;
 bh=ecGIazeDWL2MqxytT8tCGjYl5Rs0qaq/kqXtuaFnTbE=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=gi9iIL6DZSfXLgeshb2FdJ9XWTuSv+zZktnM1z6kLcIflqmF9rIswD7EfUyddOdQG
 KHzI/V6wCfRJFX0ljoXHCXRQv9vHyslKh3iOOLIZ9YmDrbxpEsZlSOlhM/Ccj/ZkZ/
 IJ32XKDRK8HTIEuAEIQGp53taVSliXhpPdjzXpOQ=
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH AUTOSEL 5.0 29/98] KVM: arm/arm64: Enforce PTE mappings at
 stage2 when needed
Date: Mon, 22 Apr 2019 15:40:56 -0400
Message-Id: <20190422194205.10404-29-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190422194205.10404-1-sashal@kernel.org>
References: <20190422194205.10404-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Cc: Sasha Levin <sashal@kernel.org>, Marc Zyngier <marc.zyngier@arm.com>,
 kvmarm@lists.cs.columbia.edu
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
Message-ID: <20190422194056.mxoJIzXJu0YjlWVoY_aHOAYBtdlkUppbBtpT-bU7BSA@z>

From: Suzuki K Poulose <suzuki.poulose@arm.com>

[ Upstream commit a80868f398554842b14d07060012c06efb57c456 ]

commit 6794ad5443a2118 ("KVM: arm/arm64: Fix unintended stage 2 PMD mappings")
made the checks to skip huge mappings, stricter. However it introduced
a bug where we still use huge mappings, ignoring the flag to
use PTE mappings, by not reseting the vma_pagesize to PAGE_SIZE.

Also, the checks do not cover the PUD huge pages, that was
under review during the same period. This patch fixes both
the issues.

Fixes : 6794ad5443a2118 ("KVM: arm/arm64: Fix unintended stage 2 PMD mappings")
Reported-by: Zenghui Yu <yuzenghui@huawei.com>
Cc: Zenghui Yu <yuzenghui@huawei.com>
Cc: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 virt/kvm/arm/mmu.c | 43 +++++++++++++++++++++----------------------
 1 file changed, 21 insertions(+), 22 deletions(-)

diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index 5cc22cdaa5ba..6dccb36465e6 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -1595,8 +1595,9 @@ static void kvm_send_hwpoison_signal(unsigned long address,
 	send_sig_mceerr(BUS_MCEERR_AR, (void __user *)address, lsb, current);
 }
 
-static bool fault_supports_stage2_pmd_mappings(struct kvm_memory_slot *memslot,
-					       unsigned long hva)
+static bool fault_supports_stage2_huge_mapping(struct kvm_memory_slot *memslot,
+					       unsigned long hva,
+					       unsigned long map_size)
 {
 	gpa_t gpa_start, gpa_end;
 	hva_t uaddr_start, uaddr_end;
@@ -1612,34 +1613,34 @@ static bool fault_supports_stage2_pmd_mappings(struct kvm_memory_slot *memslot,
 
 	/*
 	 * Pages belonging to memslots that don't have the same alignment
-	 * within a PMD for userspace and IPA cannot be mapped with stage-2
-	 * PMD entries, because we'll end up mapping the wrong pages.
+	 * within a PMD/PUD for userspace and IPA cannot be mapped with stage-2
+	 * PMD/PUD entries, because we'll end up mapping the wrong pages.
 	 *
 	 * Consider a layout like the following:
 	 *
 	 *    memslot->userspace_addr:
 	 *    +-----+--------------------+--------------------+---+
-	 *    |abcde|fgh  Stage-1 PMD    |    Stage-1 PMD   tv|xyz|
+	 *    |abcde|fgh  Stage-1 block  |    Stage-1 block tv|xyz|
 	 *    +-----+--------------------+--------------------+---+
 	 *
 	 *    memslot->base_gfn << PAGE_SIZE:
 	 *      +---+--------------------+--------------------+-----+
-	 *      |abc|def  Stage-2 PMD    |    Stage-2 PMD     |tvxyz|
+	 *      |abc|def  Stage-2 block  |    Stage-2 block   |tvxyz|
 	 *      +---+--------------------+--------------------+-----+
 	 *
-	 * If we create those stage-2 PMDs, we'll end up with this incorrect
+	 * If we create those stage-2 blocks, we'll end up with this incorrect
 	 * mapping:
 	 *   d -> f
 	 *   e -> g
 	 *   f -> h
 	 */
-	if ((gpa_start & ~S2_PMD_MASK) != (uaddr_start & ~S2_PMD_MASK))
+	if ((gpa_start & (map_size - 1)) != (uaddr_start & (map_size - 1)))
 		return false;
 
 	/*
 	 * Next, let's make sure we're not trying to map anything not covered
-	 * by the memslot. This means we have to prohibit PMD size mappings
-	 * for the beginning and end of a non-PMD aligned and non-PMD sized
+	 * by the memslot. This means we have to prohibit block size mappings
+	 * for the beginning and end of a non-block aligned and non-block sized
 	 * memory slot (illustrated by the head and tail parts of the
 	 * userspace view above containing pages 'abcde' and 'xyz',
 	 * respectively).
@@ -1648,8 +1649,8 @@ static bool fault_supports_stage2_pmd_mappings(struct kvm_memory_slot *memslot,
 	 * userspace_addr or the base_gfn, as both are equally aligned (per
 	 * the check above) and equally sized.
 	 */
-	return (hva & S2_PMD_MASK) >= uaddr_start &&
-	       (hva & S2_PMD_MASK) + S2_PMD_SIZE <= uaddr_end;
+	return (hva & ~(map_size - 1)) >= uaddr_start &&
+	       (hva & ~(map_size - 1)) + map_size <= uaddr_end;
 }
 
 static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
@@ -1678,12 +1679,6 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		return -EFAULT;
 	}
 
-	if (!fault_supports_stage2_pmd_mappings(memslot, hva))
-		force_pte = true;
-
-	if (logging_active)
-		force_pte = true;
-
 	/* Let's check if we will get back a huge page backed by hugetlbfs */
 	down_read(&current->mm->mmap_sem);
 	vma = find_vma_intersection(current->mm, hva, hva + 1);
@@ -1694,6 +1689,12 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	}
 
 	vma_pagesize = vma_kernel_pagesize(vma);
+	if (logging_active ||
+	    !fault_supports_stage2_huge_mapping(memslot, hva, vma_pagesize)) {
+		force_pte = true;
+		vma_pagesize = PAGE_SIZE;
+	}
+
 	/*
 	 * The stage2 has a minimum of 2 level table (For arm64 see
 	 * kvm_arm_setup_stage2()). Hence, we are guaranteed that we can
@@ -1701,11 +1702,9 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	 * As for PUD huge maps, we must make sure that we have at least
 	 * 3 levels, i.e, PMD is not folded.
 	 */
-	if ((vma_pagesize == PMD_SIZE ||
-	     (vma_pagesize == PUD_SIZE && kvm_stage2_has_pmd(kvm))) &&
-	    !force_pte) {
+	if (vma_pagesize == PMD_SIZE ||
+	    (vma_pagesize == PUD_SIZE && kvm_stage2_has_pmd(kvm)))
 		gfn = (fault_ipa & huge_page_mask(hstate_vma(vma))) >> PAGE_SHIFT;
-	}
 	up_read(&current->mm->mmap_sem);
 
 	/* We need minimum second+third level pages */
-- 
2.19.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
