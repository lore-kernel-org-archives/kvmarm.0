Return-Path: <SRS0=qFti=EC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF935C4363A
	for <kvmarm@archiver.kernel.org>; Tue, 27 Oct 2020 17:26:32 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 568122224A
	for <kvmarm@archiver.kernel.org>; Tue, 27 Oct 2020 17:26:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 568122224A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ECD9B4B52C;
	Tue, 27 Oct 2020 13:26:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id T5iduDCf4Jyv; Tue, 27 Oct 2020 13:26:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4FC964B50F;
	Tue, 27 Oct 2020 13:26:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E02A84B4DB
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Oct 2020 13:26:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 07MZe8R5uwXT for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Oct 2020 13:26:26 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C1F6C4B49C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Oct 2020 13:26:26 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8A4B2139F;
 Tue, 27 Oct 2020 10:26:26 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7FE1C3F719;
 Tue, 27 Oct 2020 10:26:25 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.cs.columbia.edu
Subject: [RFC PATCH v3 09/16] KVM: arm64: Use separate function for the
 mapping size in user_mem_abort()
Date: Tue, 27 Oct 2020 17:26:58 +0000
Message-Id: <20201027172705.15181-10-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027172705.15181-1-alexandru.elisei@arm.com>
References: <20201027172705.15181-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Cc: maz@kernel.org, will@kernel.org
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

user_mem_abort() is already a long and complex function, let's make it
slightly easier to understand by abstracting the algorithm for choosing the
stage 2 IPA entry size into its own function.

This also makes it possible to reuse the code when guest SPE support will
be added.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arch/arm64/kvm/mmu.c | 55 ++++++++++++++++++++++++++------------------
 1 file changed, 33 insertions(+), 22 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 19aacc7d64de..c3c43555490d 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -738,12 +738,43 @@ transparent_hugepage_adjust(struct kvm_memory_slot *memslot,
 	return PAGE_SIZE;
 }
 
+static short stage2_max_pageshift(struct kvm_memory_slot *memslot,
+				  struct vm_area_struct *vma, hva_t hva,
+				  bool *force_pte)
+{
+	short pageshift;
+
+	*force_pte = false;
+
+	if (is_vm_hugetlb_page(vma))
+		pageshift = huge_page_shift(hstate_vma(vma));
+	else
+		pageshift = PAGE_SHIFT;
+
+	if (memslot_is_logging(memslot) || (vma->vm_flags & VM_PFNMAP)) {
+		*force_pte = true;
+		pageshift = PAGE_SHIFT;
+	}
+
+	if (pageshift == PUD_SHIFT &&
+	    !fault_supports_stage2_huge_mapping(memslot, hva, PUD_SIZE))
+		pageshift = PMD_SHIFT;
+
+	if (pageshift == PMD_SHIFT &&
+	    !fault_supports_stage2_huge_mapping(memslot, hva, PMD_SIZE)) {
+		*force_pte = true;
+		pageshift = PAGE_SHIFT;
+	}
+
+	return pageshift;
+}
+
 static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			  struct kvm_memory_slot *memslot, unsigned long hva,
 			  unsigned long fault_status)
 {
 	int ret = 0;
-	bool write_fault, writable, force_pte = false;
+	bool write_fault, writable, force_pte;
 	bool exec_fault;
 	bool device = false;
 	unsigned long mmu_seq;
@@ -776,27 +807,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		return -EFAULT;
 	}
 
-	if (is_vm_hugetlb_page(vma))
-		vma_shift = huge_page_shift(hstate_vma(vma));
-	else
-		vma_shift = PAGE_SHIFT;
-
-	if (logging_active ||
-	    (vma->vm_flags & VM_PFNMAP)) {
-		force_pte = true;
-		vma_shift = PAGE_SHIFT;
-	}
-
-	if (vma_shift == PUD_SHIFT &&
-	    !fault_supports_stage2_huge_mapping(memslot, hva, PUD_SIZE))
-	       vma_shift = PMD_SHIFT;
-
-	if (vma_shift == PMD_SHIFT &&
-	    !fault_supports_stage2_huge_mapping(memslot, hva, PMD_SIZE)) {
-		force_pte = true;
-		vma_shift = PAGE_SHIFT;
-	}
-
+	vma_shift = stage2_max_pageshift(memslot, vma, hva, &force_pte);
 	vma_pagesize = 1UL << vma_shift;
 	if (vma_pagesize == PMD_SIZE || vma_pagesize == PUD_SIZE)
 		fault_ipa &= ~(vma_pagesize - 1);
-- 
2.29.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
