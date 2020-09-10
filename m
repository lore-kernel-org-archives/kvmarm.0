Return-Path: <SRS0=WCH4=CT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C478C433E2
	for <kvmarm@archiver.kernel.org>; Thu, 10 Sep 2020 13:33:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D6B162087C
	for <kvmarm@archiver.kernel.org>; Thu, 10 Sep 2020 13:33:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D6B162087C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 25DF34B2AB;
	Thu, 10 Sep 2020 09:33:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id oSIVQRmP90W9; Thu, 10 Sep 2020 09:33:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EE04C4B28E;
	Thu, 10 Sep 2020 09:33:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6B3BC4B289
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Sep 2020 09:33:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id J-wH7xnUNRdV for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Sep 2020 09:33:15 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 157B54B280
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Sep 2020 09:33:15 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B06EA106F;
 Thu, 10 Sep 2020 06:33:14 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A21663F66E;
 Thu, 10 Sep 2020 06:33:13 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2] KVM: arm64: Try PMD block mappings if PUD mappings are not
 supported
Date: Thu, 10 Sep 2020 14:33:51 +0100
Message-Id: <20200910133351.118191-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Cc: maz@kernel.org, punit1.agrawal@toshiba.co.jp
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

When userspace uses hugetlbfs for the VM memory, user_mem_abort() tries to
use the same block size to map the faulting IPA in stage 2. If stage 2
cannot the same block mapping because the block size doesn't fit in the
memslot or the memslot is not properly aligned, user_mem_abort() will fall
back to a page mapping, regardless of the block size. We can do better for
PUD backed hugetlbfs by checking if a PMD block mapping is supported before
deciding to use a page.

vma_pagesize is an unsigned long, use 1UL instead of 1ULL when assigning
its value.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
Tested on a rockpro64 with 4K pages and hugetlbfs hugepagesz=1G (PUD sized
block mappings).  First test, guest RAM starts at 0x8100 0000
(memslot->base_gfn not aligned to 1GB); second test, guest RAM starts at
0x8000 0000, but is only 512 MB.  In both cases using PUD mappings is not
possible because either the memslot base address is not aligned, or the
mapping would extend beyond the memslot.

Without the changes, user_mem_abort() uses 4K pages to map the guest IPA.
With the patches, user_mem_abort() uses PMD block mappings (2MB) to map the
guest RAM, which means less TLB pressure and fewer stage 2 aborts.

Changes since v1 [1]:
- Rebased on top of Will's stage 2 page table handling rewrite, version 4
  of the series [2]. His series is missing the patch "KVM: arm64: Update
  page shift if stage 2 block mapping not supported" and there might be a
  conflict (it's straightforward to fix).

[1] https://www.spinics.net/lists/arm-kernel/msg834015.html
[2] https://www.spinics.net/lists/arm-kernel/msg835806.html

 arch/arm64/kvm/mmu.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 1041be1fafe4..39c539d4d4cb 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -776,16 +776,25 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	else
 		vma_shift = PAGE_SHIFT;
 
-	vma_pagesize = 1ULL << vma_shift;
 	if (logging_active ||
-	    (vma->vm_flags & VM_PFNMAP) ||
-	    !fault_supports_stage2_huge_mapping(memslot, hva, vma_pagesize)) {
+	    (vma->vm_flags & VM_PFNMAP)) {
 		force_pte = true;
-		vma_pagesize = PAGE_SIZE;
+		vma_shift = PAGE_SHIFT;
+	}
+
+	if (vma_shift == PUD_SHIFT &&
+	    !fault_supports_stage2_huge_mapping(memslot, hva, PUD_SIZE))
+	       vma_shift = PMD_SHIFT;
+
+	if (vma_shift == PMD_SHIFT &&
+	    !fault_supports_stage2_huge_mapping(memslot, hva, PMD_SIZE)) {
+		force_pte = true;
+		vma_shift = PAGE_SHIFT;
 	}
 
+	vma_pagesize = 1UL << vma_shift;
 	if (vma_pagesize == PMD_SIZE || vma_pagesize == PUD_SIZE)
-		fault_ipa &= huge_page_mask(hstate_vma(vma));
+		fault_ipa &= ~(vma_pagesize - 1);
 
 	gfn = fault_ipa >> PAGE_SHIFT;
 	mmap_read_unlock(current->mm);
-- 
2.28.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
