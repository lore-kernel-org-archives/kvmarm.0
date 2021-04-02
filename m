Return-Path: <SRS0=9BEn=I7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2316BC43462
	for <kvmarm@archiver.kernel.org>; Fri,  2 Apr 2021 09:20:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 808B460FF3
	for <kvmarm@archiver.kernel.org>; Fri,  2 Apr 2021 09:20:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 808B460FF3
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 29F4A4B294;
	Fri,  2 Apr 2021 05:20:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bRfgdAXvoQyQ; Fri,  2 Apr 2021 05:20:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 811294B2E9;
	Fri,  2 Apr 2021 05:20:37 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1F76B4B6D6
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Apr 2021 20:57:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2DbO22rqWG7I for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Apr 2021 20:57:08 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id ED4784B758
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Apr 2021 20:57:07 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id n13so7634407ybp.14
 for <kvmarm@lists.cs.columbia.edu>; Thu, 01 Apr 2021 17:57:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=reply-to:date:in-reply-to:message-id:mime-version:references
 :subject:from:to:cc;
 bh=tDfPmXbzjuXYEj7QinrksosPu+0bJFiZwViEuyBfiPM=;
 b=lb+qs0QKm/vKplDLvVTszodx9+lPNY1WATK8sX84CSZq8tI076ayThzvRmFWIC9ppR
 d8t9FSZnygTkkAg2cJC4qgr46yFW8WrEbI1c93uYTd4Tq+C40f7GmYGNn76no2eydFJm
 ELg1MV/l2E2VRXKBw+OxLEfDEUoMG2hdu1QZaxqsLn0ey5+2k2aTKxqSaN8KYwbGGpJZ
 LU2s/Dk7xnQsZ63ZuMGE1MCLqdVTzwBfjQTtDty7A1SwD1F+T3rYvXnjE6NGc0WaI/Wh
 rjmoa/1Y5xAuK8JFh3YXhP45SEhEa+DdFoZy2vyAMj8oY/jTXPmptXAWwzLudr/mz6DL
 n6Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:reply-to:date:in-reply-to:message-id
 :mime-version:references:subject:from:to:cc;
 bh=tDfPmXbzjuXYEj7QinrksosPu+0bJFiZwViEuyBfiPM=;
 b=L2c/sSIfiBTTtVL9Yf2VvFWR8gtfzQOMpt61ujWviwEox+ZopAmMJ2npGYKO7nx4gU
 xKqdMLs4qoyT1jVjE3IpRmSavkvfI/AjKX+v1P7l0rTPr4J0eEl/8Ou9LaWm8GNprnwg
 vRs8MvrAVL3fXkE/2n70oYmXPmX+kXgXsSDvY6Vx/mYmWQvsUPrENy1mhbszX//2NY01
 0NaIYVGd20A8nTFLeH7c2VxN+jdS3gRHqmm4qFfj8JYsAmb5B8QFfT1VSLcBgqRA3VSO
 qVj24Q5E00WKtjQlp/KV6q6ufMzEpc0Lk/N4g6liiqNhn11rvmQeHH/cIx9bXQxgg5bT
 IHCg==
X-Gm-Message-State: AOAM531McC2iFlPE2hvk8NGE8qhveVSK6EbuFrP9XerXd5iexg0ABngk
 yr5auqFKuZ8MxJExetxZYqMcBFetNsI=
X-Google-Smtp-Source: ABdhPJxbKr645X0CcfRDIWTDLNH8a38GjXA6vUJ3jECMSWadG+jHX2J4YQiJuT8sNhsO5srQAIOw4KIsjrs=
X-Received: from seanjc798194.pdx.corp.google.com
 ([2620:15c:f:10:c0b4:8b8:bb34:6a56])
 (user=seanjc job=sendgmr) by 2002:a25:f608:: with SMTP id
 t8mr16151942ybd.496.1617325027509; 
 Thu, 01 Apr 2021 17:57:07 -0700 (PDT)
Date: Thu,  1 Apr 2021 17:56:51 -0700
In-Reply-To: <20210402005658.3024832-1-seanjc@google.com>
Message-Id: <20210402005658.3024832-4-seanjc@google.com>
Mime-Version: 1.0
References: <20210402005658.3024832-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.0.208.g409f899ff0-goog
Subject: [PATCH v2 03/10] KVM: arm64: Convert to the gfn-based MMU notifier
 callbacks
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>, 
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Paul Mackerras <paulus@ozlabs.org>, Paolo Bonzini <pbonzini@redhat.com>
X-Mailman-Approved-At: Fri, 02 Apr 2021 05:20:36 -0400
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Sean Christopherson <seanjc@google.com>, Joerg Roedel <joro@8bytes.org>,
 linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Ben Gardon <bgardon@google.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 kvmarm@lists.cs.columbia.edu, Jim Mattson <jmattson@google.com>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: Sean Christopherson <seanjc@google.com>
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

Move arm64 to the gfn-base MMU notifier APIs, which do the hva->gfn
lookup in common code.

No meaningful functional change intended, though the exact order of
operations is slightly different since the memslot lookups occur before
calling into arch code.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/include/asm/kvm_host.h |   1 +
 arch/arm64/kvm/mmu.c              | 117 ++++++++----------------------
 2 files changed, 33 insertions(+), 85 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 72e6b4600264..1ad729cf7b0d 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -582,6 +582,7 @@ int __kvm_arm_vcpu_set_events(struct kvm_vcpu *vcpu,
 			      struct kvm_vcpu_events *events);
 
 #define KVM_ARCH_WANT_MMU_NOTIFIER
+#define KVM_ARCH_WANT_NEW_MMU_NOTIFIER_APIS
 
 void kvm_arm_halt_guest(struct kvm *kvm);
 void kvm_arm_resume_guest(struct kvm *kvm);
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 4b7e1e327337..35728231e9a0 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -839,7 +839,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	 * gfn_to_pfn_prot (which calls get_user_pages), so that we don't risk
 	 * the page we just got a reference to gets unmapped before we have a
 	 * chance to grab the mmu_lock, which ensure that if the page gets
-	 * unmapped afterwards, the call to kvm_unmap_hva will take it away
+	 * unmapped afterwards, the call to kvm_unmap_gfn will take it away
 	 * from us again properly. This smp_rmb() interacts with the smp_wmb()
 	 * in kvm_mmu_notifier_invalidate_<page|range_end>.
 	 */
@@ -1064,123 +1064,70 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 	return ret;
 }
 
-static int handle_hva_to_gpa(struct kvm *kvm,
-			     unsigned long start,
-			     unsigned long end,
-			     int (*handler)(struct kvm *kvm,
-					    gpa_t gpa, u64 size,
-					    void *data),
-			     void *data)
-{
-	struct kvm_memslots *slots;
-	struct kvm_memory_slot *memslot;
-	int ret = 0;
-
-	slots = kvm_memslots(kvm);
-
-	/* we only care about the pages that the guest sees */
-	kvm_for_each_memslot(memslot, slots) {
-		unsigned long hva_start, hva_end;
-		gfn_t gpa;
-
-		hva_start = max(start, memslot->userspace_addr);
-		hva_end = min(end, memslot->userspace_addr +
-					(memslot->npages << PAGE_SHIFT));
-		if (hva_start >= hva_end)
-			continue;
-
-		gpa = hva_to_gfn_memslot(hva_start, memslot) << PAGE_SHIFT;
-		ret |= handler(kvm, gpa, (u64)(hva_end - hva_start), data);
-	}
-
-	return ret;
-}
-
-static int kvm_unmap_hva_handler(struct kvm *kvm, gpa_t gpa, u64 size, void *data)
-{
-	unsigned flags = *(unsigned *)data;
-	bool may_block = flags & MMU_NOTIFIER_RANGE_BLOCKABLE;
-
-	__unmap_stage2_range(&kvm->arch.mmu, gpa, size, may_block);
-	return 0;
-}
-
-int kvm_unmap_hva_range(struct kvm *kvm,
-			unsigned long start, unsigned long end, unsigned flags)
+bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	if (!kvm->arch.mmu.pgt)
 		return 0;
 
-	handle_hva_to_gpa(kvm, start, end, &kvm_unmap_hva_handler, &flags);
-	return 0;
-}
+	__unmap_stage2_range(&kvm->arch.mmu, range->start << PAGE_SHIFT,
+			     (range->end - range->start) << PAGE_SHIFT,
+			     range->may_block);
 
-static int kvm_set_spte_handler(struct kvm *kvm, gpa_t gpa, u64 size, void *data)
-{
-	kvm_pfn_t *pfn = (kvm_pfn_t *)data;
-
-	WARN_ON(size != PAGE_SIZE);
-
-	/*
-	 * The MMU notifiers will have unmapped a huge PMD before calling
-	 * ->change_pte() (which in turn calls kvm_set_spte_hva()) and
-	 * therefore we never need to clear out a huge PMD through this
-	 * calling path and a memcache is not required.
-	 */
-	kvm_pgtable_stage2_map(kvm->arch.mmu.pgt, gpa, PAGE_SIZE,
-			       __pfn_to_phys(*pfn), KVM_PGTABLE_PROT_R, NULL);
 	return 0;
 }
 
-int kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte)
+bool kvm_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
-	unsigned long end = hva + PAGE_SIZE;
-	kvm_pfn_t pfn = pte_pfn(pte);
+	kvm_pfn_t pfn = pte_pfn(range->pte);
 
 	if (!kvm->arch.mmu.pgt)
 		return 0;
 
+	WARN_ON(range->end - range->start != 1);
+
 	/*
 	 * We've moved a page around, probably through CoW, so let's treat it
 	 * just like a translation fault and clean the cache to the PoC.
 	 */
 	clean_dcache_guest_page(pfn, PAGE_SIZE);
-	handle_hva_to_gpa(kvm, hva, end, &kvm_set_spte_handler, &pfn);
+
+	/*
+	 * The MMU notifiers will have unmapped a huge PMD before calling
+	 * ->change_pte() (which in turn calls kvm_set_spte_gfn()) and
+	 * therefore we never need to clear out a huge PMD through this
+	 * calling path and a memcache is not required.
+	 */
+	kvm_pgtable_stage2_map(kvm->arch.mmu.pgt, range->start << PAGE_SHIFT,
+			       PAGE_SIZE, __pfn_to_phys(pfn),
+			       KVM_PGTABLE_PROT_R, NULL);
+
 	return 0;
 }
 
-static int kvm_age_hva_handler(struct kvm *kvm, gpa_t gpa, u64 size, void *data)
+bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
-	pte_t pte;
+	u64 size = (range->end - range->start) << PAGE_SHIFT;
 	kvm_pte_t kpte;
+	pte_t pte;
+
+	if (!kvm->arch.mmu.pgt)
+		return 0;
 
 	WARN_ON(size != PAGE_SIZE && size != PMD_SIZE && size != PUD_SIZE);
-	kpte = kvm_pgtable_stage2_mkold(kvm->arch.mmu.pgt, gpa);
+
+	kpte = kvm_pgtable_stage2_mkold(kvm->arch.mmu.pgt,
+					range->start << PAGE_SHIFT);
 	pte = __pte(kpte);
 	return pte_valid(pte) && pte_young(pte);
 }
 
-static int kvm_test_age_hva_handler(struct kvm *kvm, gpa_t gpa, u64 size, void *data)
-{
-	WARN_ON(size != PAGE_SIZE && size != PMD_SIZE && size != PUD_SIZE);
-	return kvm_pgtable_stage2_is_young(kvm->arch.mmu.pgt, gpa);
-}
-
-int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end)
-{
-	if (!kvm->arch.mmu.pgt)
-		return 0;
-
-	return handle_hva_to_gpa(kvm, start, end, kvm_age_hva_handler, NULL);
-}
-
-int kvm_test_age_hva(struct kvm *kvm, unsigned long hva)
+bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	if (!kvm->arch.mmu.pgt)
 		return 0;
 
-	return handle_hva_to_gpa(kvm, hva, hva + PAGE_SIZE,
-				 kvm_test_age_hva_handler, NULL);
+	return kvm_pgtable_stage2_is_young(kvm->arch.mmu.pgt,
+					   range->start << PAGE_SHIFT);
 }
 
 phys_addr_t kvm_mmu_get_httbr(void)
-- 
2.31.0.208.g409f899ff0-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
