Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C274C4332F
	for <kvmarm@archiver.kernel.org>; Fri,  4 Nov 2022 01:11:11 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C175249F38;
	Thu,  3 Nov 2022 21:11:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pLUlJSA11wiP; Thu,  3 Nov 2022 21:11:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9598E43479;
	Thu,  3 Nov 2022 21:11:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AC70741070
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Nov 2022 21:11:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0WI3l9eLvmNp for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Nov 2022 21:11:07 -0400 (EDT)
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com
 [209.85.128.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6580243399
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Nov 2022 21:11:07 -0400 (EDT)
Received: by mail-yw1-f201.google.com with SMTP id
 00721157ae682-360b9418f64so33434527b3.7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 03 Nov 2022 18:11:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
 :date:from:to:cc:subject:date:message-id:reply-to;
 bh=8wvPVNBIGqPordV4VqCP60h9NBW3OrQ+oktJeQ7thTw=;
 b=A+A0tEpthLB+uuGmFa5yS0IHcK7j38Tj0ebvhxSMPg5emU5TZZt2mYe9MZh7RAtr0y
 Ps00sS0Er2FbYA2csEblRJ1UfNxH9upYvLoLCdEkMyFMXQBFOhNaC2MCVmmTypPwANaO
 vJUmDW5hpXkvRUy2dJnOSd+c2zABMrXNOESfwAiNk9IO2oZPq1WieXohqRV2p1kj+aO3
 w11BWq3t4PIQVWPI1rpRlsVI+HWzbrfNvVm/toq/WiprZlRhhvXKwv1BkHKFv0oDtHxC
 SsTRY97Q6pnqX6cUoNLCT9g9pBtiOytIELUkyKORJXfQh5+ohRzxLE7H8/lfP8qosxxz
 oojg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
 :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=8wvPVNBIGqPordV4VqCP60h9NBW3OrQ+oktJeQ7thTw=;
 b=uBNe9tgeXOVbsEQQq9Qt4TtIusNy7bhhxYV+X+7sQrmeHQDLjMMbCFn9geUnYuGwIi
 87y6nLgjsctXQMwv83WYZ8zVWBnMtaTmvX/8I+Z0OCUco1tYIXvmGO7ygTqV65/8+wir
 buVW9ZIuesitsHNyHTahUUOso1HO2rHH3879booeDiln1r7KbH0mVYnZAyFEH2mHA7Uq
 mXYifotOHHtnRhbvrOefxTGP7EU50kO71ZYAZuTJ6EqBM+z0HZviMYPP64ZjNQY5ZR8P
 pXuBkvdgJxyr7alnWcAeWg7KYAvJdbFyXnwolUcAvM7YnTWs1o/qUaTrp9hl1N2gieRB
 qrUQ==
X-Gm-Message-State: ANoB5pk7846WmgujStI9qDrolB+z37K06oEwNKjcBFkkGAIM6dFvi/IV
 eFlNZuzS7wKSmuEJ+CF294R/OF4=
X-Google-Smtp-Source: AA0mqf6aCG6H1JcdeUQvIHj3QDAK9Uph6TKu2Ix1eLoqmjpSVgiU9fa0kE/LaoMn+PfmE2uXJxHiEHw=
X-Received: from pcc-desktop.svl.corp.google.com
 ([2620:15c:2ce:200:2844:b0ec:e556:30d8])
 (user=pcc job=sendgmr) by 2002:a25:234f:0:b0:6d2:f2e8:c131 with SMTP id
 j76-20020a25234f000000b006d2f2e8c131mr31156ybj.418.1667524266424; Thu, 03 Nov
 2022 18:11:06 -0700 (PDT)
Date: Thu,  3 Nov 2022 18:10:36 -0700
In-Reply-To: <20221104011041.290951-1-pcc@google.com>
Message-Id: <20221104011041.290951-4-pcc@google.com>
Mime-Version: 1.0
References: <20221104011041.290951-1-pcc@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Subject: [PATCH v5 3/8] KVM: arm64: Simplify the sanitise_mte_tags() logic
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
[pcc@google.com: fix the page initializer]
Signed-off-by: Peter Collingbourne <pcc@google.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Peter Collingbourne <pcc@google.com>
---
 arch/arm64/kvm/mmu.c | 40 +++++++++++++++-------------------------
 1 file changed, 15 insertions(+), 25 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 2c3759f1f2c5..e81bfb730629 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1091,23 +1091,14 @@ static int get_vma_page_shift(struct vm_area_struct *vma, unsigned long hva)
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
@@ -1115,8 +1106,6 @@ static int sanitise_mte_tags(struct kvm *kvm, kvm_pfn_t pfn,
 			set_page_mte_tagged(page);
 		}
 	}
-
-	return 0;
 }
 
 static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
@@ -1127,7 +1116,6 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	bool write_fault, writable, force_pte = false;
 	bool exec_fault;
 	bool device = false;
-	bool shared;
 	unsigned long mmu_seq;
 	struct kvm *kvm = vcpu->kvm;
 	struct kvm_mmu_memory_cache *memcache = &vcpu->arch.mmu_page_cache;
@@ -1177,8 +1165,6 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		vma_shift = get_vma_page_shift(vma, hva);
 	}
 
-	shared = (vma->vm_flags & VM_SHARED);
-
 	switch (vma_shift) {
 #ifndef __PAGETABLE_PMD_FOLDED
 	case PUD_SHIFT:
@@ -1299,12 +1285,13 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 
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
@@ -1526,15 +1513,18 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
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
2.38.1.431.g37b22c650d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
