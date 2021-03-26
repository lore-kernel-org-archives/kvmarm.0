Return-Path: <SRS0=1o63=IY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0116FC433E0
	for <kvmarm@archiver.kernel.org>; Fri, 26 Mar 2021 13:54:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A1D7F61A1E
	for <kvmarm@archiver.kernel.org>; Fri, 26 Mar 2021 13:54:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A1D7F61A1E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 540764B41C;
	Fri, 26 Mar 2021 09:54:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id m03a+El4rHjF; Fri, 26 Mar 2021 09:54:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 752684B48E;
	Fri, 26 Mar 2021 09:54:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ABD0D4B266
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Mar 2021 22:20:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ztkoGS17hTOT for <kvmarm@lists.cs.columbia.edu>;
 Thu, 25 Mar 2021 22:20:36 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 82A614B1E6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Mar 2021 22:20:36 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id x8so8409377ybo.6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Mar 2021 19:20:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=reply-to:date:in-reply-to:message-id:mime-version:references
 :subject:from:to:cc;
 bh=ToXMoL2Kd2/SJp5pLlSeXZUeldhyd8WTEWaSFPITIQY=;
 b=vYbzZt6VuoT8/2gGGWgm9PSqd3t+FSwTciToxgXXhjE1y1MU3KJy6WkEJlNfLXLkie
 xxjVqRA8DnUzeGhmNepWRZgzCCLRKgZfM3tzRBzdMvH3AWYBsGv5yrxAG+SBFJukd0hd
 YqDCDfmPyTv539NQ8Eoac3EKcUNCn+s1nxvUy/gUtRUV6xCYJOzHX+nzP140CEy8tBSX
 jRQoy57NNEizpyKOft/OFh9r4JweTh++5JzyP6or14BiU622LYfnszXiecStaeCwN7Nc
 pXPJ3mVCknAxAAGQ9Dej38P4WhmWVmCo0W/vHWm91ZJPQGCwtrHKID5jq7bvw40c7SFt
 eU4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:reply-to:date:in-reply-to:message-id
 :mime-version:references:subject:from:to:cc;
 bh=ToXMoL2Kd2/SJp5pLlSeXZUeldhyd8WTEWaSFPITIQY=;
 b=e151ukg/lbYofClEpP+AJAVkF6pivcRMKcmJvV8KkdnRaIiFqOjTrYIaxe7GQ9PPrX
 HCDeOGG9v1pNiwsHR1eyxV2kgmX83ey76ByqivslKM9SzSVlxNYORqj9RKSDWAsIw2h1
 pa7UParVP9CKRZ78aE/7tg+3CkwtWx2BBW3GzRUoRrrzJhC6+Dy++5ViWePi3V00eAjC
 C3HDkYwr0Ho19RUq51hu/NGoV3nej8r+rMYaK1l2IODiYoYrrOA9W7UhyRx4fzeRG2CJ
 LiKzIMYsmx49RoqbuKwcqTNg8W2tVVsMYkkDg2zs0DjJGmikiO8IqxdRUBPJiiI38WUp
 x0CA==
X-Gm-Message-State: AOAM530QJPTlpTl76xUQbs+dem4jkYJOJ48jWKzYCPrJdgGfPqOCG9TC
 c1XiiGgT6CFtGZsfvEFhzEFb39FrhbM=
X-Google-Smtp-Source: ABdhPJzRVG48z8ZzycjiKCLwPZNN1glmgxA8blrqx2t14Bkqo8S2FlN8ubmdHUNXp/9csQMMt5MyDjtbz7k=
X-Received: from seanjc798194.pdx.corp.google.com
 ([2620:15c:f:10:b1bb:fab2:7ef5:fc7d])
 (user=seanjc job=sendgmr) by 2002:a25:aa63:: with SMTP id
 s90mr13063680ybi.393.1616725236043; 
 Thu, 25 Mar 2021 19:20:36 -0700 (PDT)
Date: Thu, 25 Mar 2021 19:19:50 -0700
In-Reply-To: <20210326021957.1424875-1-seanjc@google.com>
Message-Id: <20210326021957.1424875-12-seanjc@google.com>
Mime-Version: 1.0
References: <20210326021957.1424875-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
Subject: [PATCH 11/18] KVM: arm64: Convert to the gfn-based MMU notifier
 callbacks
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>, 
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Paul Mackerras <paulus@ozlabs.org>, Paolo Bonzini <pbonzini@redhat.com>
X-Mailman-Approved-At: Fri, 26 Mar 2021 09:54:23 -0400
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

Note, due to arch code being called if and only if a memslot is found,
the clean_dcache_guest_page() call in kvm_set_spte_*() is will no longer
be called for addresses that are not found in the guest memslots.

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
2.31.0.291.g576ba9dcdaf-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
