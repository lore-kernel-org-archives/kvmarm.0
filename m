Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A907C43334
	for <kvmarm@archiver.kernel.org>; Fri, 22 Jul 2022 01:51:06 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 55CC14C7AF;
	Thu, 21 Jul 2022 21:51:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fdH5uu1n6iyv; Thu, 21 Jul 2022 21:51:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EF7C74C872;
	Thu, 21 Jul 2022 21:51:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CC5C34C697
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2022 21:51:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nqpaWXRl8ibD for <kvmarm@lists.cs.columbia.edu>;
 Thu, 21 Jul 2022 21:51:00 -0400 (EDT)
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com
 [209.85.216.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 85FF44C6EF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2022 21:51:00 -0400 (EDT)
Received: by mail-pj1-f73.google.com with SMTP id
 k7-20020a17090a62c700b001ef9c16ba10so3593998pjs.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2022 18:51:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=4BZROGdIJ6ey3ykeGXKKMyG5fxGLOs9dtND9v0m18DI=;
 b=MwDh0r7e9Z50plp25nl4fU2XJ0ebh5++1X9yJJYV97pjuLK0ahyEY3Y8MqgsKA30wo
 rDCddGIzUUQ2BQH+lTn83Rja5L3SCm6AZpaWt5SXKfXP8DCl4YIJKMCTCFvVTq2vvadH
 PuySAk39zirowz3Gyd8+qtVDsZXRxjmr6MpDmamAqsuZex6XJHHbyOA48OK2baHJCwEn
 83i97+hNJ7QVpTrzc3m5GFh2VtOAQbiLIxElelsydLR0K+KYHRweZq3CPpJI1rDgH0cV
 kh6oM05Ggd5zJVKnTVDWLz6qVwtNJZY96QC2Cf+7mEoOOYjlbzYJP+Z2lxv1xHyYq7Ol
 t5jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=4BZROGdIJ6ey3ykeGXKKMyG5fxGLOs9dtND9v0m18DI=;
 b=3MdAhwN6afj4Pe4tbHJCVbmHQCTO/bUo5icAbaMKMd8ti3nLnrtlj/cdH0wnUqdmDh
 aUC+PTD7KeyRr8knB2agdFwG6a0X6axuzUBxocaz1c+TpVwMt0IBGaoxEzn8kypSuVXx
 EFBDAXzYZBFvzEMjS3RrLGYz+O55Z5TZDfy+HvLbMrzHq+623/HXNLQM4Vzv/Bq2y0vQ
 ry12YC+t6IrbhZ12HpwPn8HKejP0PB7NqIlfkYs6qsWkd1jeIeNYSIOnwVGcvGOH3cNw
 hJf7y9wmpb2bD9ZgpkQxzP63Pn1ZCJYLBqb8fW8OBhHyTkM663BtTGSidOfg2aPWuHxv
 pBKQ==
X-Gm-Message-State: AJIora+b3K25twetGvjwE44/8TmP/ZOfDAiqkjHBVP3P98nlW3OC2Tyl
 WGZsS9R9FdbIZtXY7D1Ce7vSMjU=
X-Google-Smtp-Source: AGRyM1vbtFVBRffsajgh0wYnjlyqGlcLkaXaKkTOQVsukeXgRgms6r3xxeGo4tZIWhNUOJdgZJEPUcI=
X-Received: from pcc-desktop.svl.corp.google.com
 ([2620:15c:2ce:200:7ed4:5864:d5e1:ffe1])
 (user=pcc job=sendgmr) by 2002:a17:90a:69e1:b0:1f2:2c0a:c30f with SMTP id
 s88-20020a17090a69e100b001f22c0ac30fmr7330979pjj.8.1658454659739; Thu, 21 Jul
 2022 18:50:59 -0700 (PDT)
Date: Thu, 21 Jul 2022 18:50:28 -0700
In-Reply-To: <20220722015034.809663-1-pcc@google.com>
Message-Id: <20220722015034.809663-3-pcc@google.com>
Mime-Version: 1.0
References: <20220722015034.809663-1-pcc@google.com>
X-Mailer: git-send-email 2.37.1.359.gd136c6c3e2-goog
Subject: [PATCH v2 2/7] KVM: arm64: Simplify the sanitise_mte_tags() logic
From: Peter Collingbourne <pcc@google.com>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Peter Collingbourne <pcc@google.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Cornelia Huck <cohuck@redhat.com>,
 Steven Price <steven.price@arm.com>, Marc Zyngier <maz@kernel.org>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>, Will Deacon <will@kernel.org>,
 Evgenii Stepanov <eugenis@google.com>
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

From: Catalin Marinas <catalin.marinas@arm.com>

Currently sanitise_mte_tags() checks if it's an online page before
attempting to sanitise the tags. Such detection should be done in the
caller via the VM_MTE_ALLOWED vma flag. Since kvm_set_spte_gfn() does
not have the vma, leave the page unmapped if not already tagged. Tag
initialisation will be done on a subsequent access fault in
user_mem_abort().

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Steven Price <steven.price@arm.com>
Cc: Peter Collingbourne <pcc@google.com>
---
 arch/arm64/kvm/mmu.c | 40 +++++++++++++++-------------------------
 1 file changed, 15 insertions(+), 25 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index c9012707f69c..1a3707aeb41f 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1056,23 +1056,14 @@ static int get_vma_page_shift(struct vm_area_struct *vma, unsigned long hva)
  * - mmap_lock protects between a VM faulting a page in and the VMM performing
  *   an mprotect() to add VM_MTE
  */
-static int sanitise_mte_tags(struct kvm *kvm, kvm_pfn_t pfn,
-			     unsigned long size)
+static void sanitise_mte_tags(struct kvm *kvm, kvm_pfn_t pfn,
+			      unsigned long size)
 {
 	unsigned long i, nr_pages = size >> PAGE_SHIFT;
-	struct page *page;
+	struct page *page = pfn_to_page(pfn);
 
 	if (!kvm_has_mte(kvm))
-		return 0;
-
-	/*
-	 * pfn_to_online_page() is used to reject ZONE_DEVICE pages
-	 * that may not support tags.
-	 */
-	page = pfn_to_online_page(pfn);
-
-	if (!page)
-		return -EFAULT;
+		return;
 
 	for (i = 0; i < nr_pages; i++, page++) {
 		if (!page_mte_tagged(page)) {
@@ -1080,8 +1071,6 @@ static int sanitise_mte_tags(struct kvm *kvm, kvm_pfn_t pfn,
 			set_page_mte_tagged(page);
 		}
 	}
-
-	return 0;
 }
 
 static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
@@ -1092,7 +1081,6 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	bool write_fault, writable, force_pte = false;
 	bool exec_fault;
 	bool device = false;
-	bool shared;
 	unsigned long mmu_seq;
 	struct kvm *kvm = vcpu->kvm;
 	struct kvm_mmu_memory_cache *memcache = &vcpu->arch.mmu_page_cache;
@@ -1142,8 +1130,6 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		vma_shift = get_vma_page_shift(vma, hva);
 	}
 
-	shared = (vma->vm_flags & VM_SHARED);
-
 	switch (vma_shift) {
 #ifndef __PAGETABLE_PMD_FOLDED
 	case PUD_SHIFT:
@@ -1264,12 +1250,13 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 
 	if (fault_status != FSC_PERM && !device && kvm_has_mte(kvm)) {
 		/* Check the VMM hasn't introduced a new VM_SHARED VMA */
-		if (!shared)
-			ret = sanitise_mte_tags(kvm, pfn, vma_pagesize);
-		else
+		if ((vma->vm_flags & VM_MTE_ALLOWED) &&
+		    !(vma->vm_flags & VM_SHARED)) {
+			sanitise_mte_tags(kvm, pfn, vma_pagesize);
+		} else {
 			ret = -EFAULT;
-		if (ret)
 			goto out_unlock;
+		}
 	}
 
 	if (writable)
@@ -1491,15 +1478,18 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 bool kvm_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	kvm_pfn_t pfn = pte_pfn(range->pte);
-	int ret;
 
 	if (!kvm->arch.mmu.pgt)
 		return false;
 
 	WARN_ON(range->end - range->start != 1);
 
-	ret = sanitise_mte_tags(kvm, pfn, PAGE_SIZE);
-	if (ret)
+	/*
+	 * If the page isn't tagged, defer to user_mem_abort() for sanitising
+	 * the MTE tags. The S2 pte should have been unmapped by
+	 * mmu_notifier_invalidate_range_end().
+	 */
+	if (kvm_has_mte(kvm) && !page_mte_tagged(pfn_to_page(pfn)))
 		return false;
 
 	/*
-- 
2.37.1.359.gd136c6c3e2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
