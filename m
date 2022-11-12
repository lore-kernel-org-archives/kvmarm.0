Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44717C4332F
	for <kvmarm@archiver.kernel.org>; Sat, 12 Nov 2022 08:17:42 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E5DF94B84B;
	Sat, 12 Nov 2022 03:17:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vzvblrRD6Hnr; Sat, 12 Nov 2022 03:17:40 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A0A5A4B82E;
	Sat, 12 Nov 2022 03:17:40 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C3F34B82B
 for <kvmarm@lists.cs.columbia.edu>; Sat, 12 Nov 2022 03:17:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FTKGrwM94f7B for <kvmarm@lists.cs.columbia.edu>;
 Sat, 12 Nov 2022 03:17:38 -0500 (EST)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1B1EB4B78C
 for <kvmarm@lists.cs.columbia.edu>; Sat, 12 Nov 2022 03:17:37 -0500 (EST)
Received: by mail-yb1-f201.google.com with SMTP id
 m4-20020a258004000000b006cbf32f7ed8so6273362ybk.9
 for <kvmarm@lists.cs.columbia.edu>; Sat, 12 Nov 2022 00:17:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:from:to:cc:subject:date:message-id:reply-to;
 bh=3ei5KTNcwhvdEV4DEpNFWL2FLBtddGkRWDZ/PZs/pyI=;
 b=a19I5M6QD8ehxktbvDkxtPw0UrpG81hnIry+JL2VyC+pmJlCLjUTQU9D3tS4gRNcCU
 qdp/5z/jxiSnVMaqHsIyg8amm+Nl2PQ+GVBxqPMbV7Y+4Qel7yqwPcuWWOFzFhQZIN0R
 GYroxUY6ffo0v/rEOhQml+75jUUl6lAOZiTa2QnBE68tXsAFz0+PBWKHa+BOGDaZ5IER
 a11qT3xsYQfdwNbi3qNoxzKIkwtdV1D+8O1INKn/UsojFZXoTVb7znNF/s0uoMPeg2o6
 XqTzxzckjG64tlCy9itEM7wEL74IrzNod9jraA/KC4u6PP+bao/Vj3O8nlguA7aDZaUT
 2FZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=3ei5KTNcwhvdEV4DEpNFWL2FLBtddGkRWDZ/PZs/pyI=;
 b=RqGGUS4k7HxFCzR/0+DQJCf9MY2YupI2pSQJoSFZVTTaM/zpbbC+icZrs2KmVfQVYA
 Ugp7EYqzIXz+LlOILQ14r5iTaURPLGCNYRmI4dFKOLJT5Z3JLyXcwfMVppT9Nia3ZDho
 y9VNKau0yHQ6Xa9qwBepQHsU94uw4axF/Vy5ESOPKFNoBkEevz6fN3FmMjxliwVoLYig
 TF49IVZgVH0ctgLu2kKj08PKK9bWwpFoNqKblKJtglT1dOEf9LTMyl/NSY7G8L/Tjxt1
 Uv1W9LdQrbIjIxAv2ab4idiSivsWGdB7FZNRKq2+P08F5iMoZCSinDkFjAUu9ENVi5WE
 al2w==
X-Gm-Message-State: ANoB5pnj/Ol0uMtl4pbk6Mkc6rMR85riVaXLe5fjvVUKatI9YrMv2wEM
 B9F8CghPf/No/HQ5BO1c9kJrec4dGmelxw==
X-Google-Smtp-Source: AA0mqf76MOJIlJMgyK8SACjurwBgdmgD8UMbYjNn4NyBxOTE9EDQqi80GPLESjM3J7HUUAm7YnPRl075qddTHg==
X-Received: from ricarkol4.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a25:50e:0:b0:6dd:657d:ffc8 with SMTP id
 14-20020a25050e000000b006dd657dffc8mr3797725ybf.269.1668241056148; Sat, 12
 Nov 2022 00:17:36 -0800 (PST)
Date: Sat, 12 Nov 2022 08:17:13 +0000
In-Reply-To: <20221112081714.2169495-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20221112081714.2169495-1-ricarkol@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221112081714.2169495-12-ricarkol@google.com>
Subject: [RFC PATCH 11/12] KVM: arm64: Split huge pages during
 KVM_CLEAR_DIRTY_LOG
From: Ricardo Koller <ricarkol@google.com>
To: pbonzini@redhat.com, maz@kernel.org, oupton@google.com, 
 dmatlack@google.com, qperret@google.com, catalin.marinas@arm.com, 
 andrew.jones@linux.dev, seanjc@google.com, alexandru.elisei@arm.com, 
 suzuki.poulose@arm.com, eric.auger@redhat.com, gshan@redhat.com, 
 reijiw@google.com, rananta@google.com, bgardon@google.com
Cc: kvmarm@lists.linux.dev, ricarkol@gmail.com, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
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

This is the arm64 counterpart of commit cb00a70bd4b7 ("KVM: x86/mmu:
Split huge pages mapped by the TDP MMU during KVM_CLEAR_DIRTY_LOG"),
which has the benefit of splitting the cost of splitting a memslot
across multiple ioctls.

Split huge pages on the range specified using KVM_CLEAR_DIRTY_LOG.  And
do not split when enabling dirty logging if KVM_DIRTY_LOG_INITIALLY_SET
is set.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arch/arm64/kvm/mmu.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 7881df411643..b8211d833cc1 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1076,8 +1076,8 @@ static void kvm_mmu_split_memory_region(struct kvm *kvm, int slot)
  * @mask:	The mask of pages at offset 'gfn_offset' in this memory
  *		slot to enable dirty logging on
  *
- * Writes protect selected pages to enable dirty logging for them. Caller must
- * acquire kvm->mmu_lock.
+ * Splits selected pages to PAGE_SIZE and then writes protect them to enable
+ * dirty logging for them. Caller must acquire kvm->mmu_lock.
  */
 void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 		struct kvm_memory_slot *slot,
@@ -1090,6 +1090,14 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 	lockdep_assert_held_write(&kvm->mmu_lock);
 
 	stage2_wp_range(&kvm->arch.mmu, start, end);
+
+	/*
+	 * If initially-all-set mode is not set, then huge-pages were already
+	 * split when enabling dirty logging: no need to do it again.
+	 */
+	if (kvm_dirty_log_manual_protect_and_init_set(kvm) &&
+	    READ_ONCE(eager_page_split))
+		kvm_mmu_split_huge_pages(kvm, start, end);
 }
 
 static void kvm_send_hwpoison_signal(unsigned long address, short lsb)
@@ -1474,10 +1482,11 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	 */
 	if (fault_status == FSC_PERM && vma_pagesize == fault_granule)
 		ret = kvm_pgtable_stage2_relax_perms(pgt, fault_ipa, prot);
-	else
+	else {
 		ret = kvm_pgtable_stage2_map(pgt, fault_ipa, vma_pagesize,
 					     __pfn_to_phys(pfn), prot,
 					     memcache, KVM_PGTABLE_WALK_SHARED);
+	}
 
 	/* Mark the page dirty only if the fault is handled successfully */
 	if (writable && !ret) {
@@ -1887,7 +1896,9 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 		 * this when deleting, moving, disabling dirty logging, or
 		 * creating the memslot (a nop). Doing it for deletes makes
 		 * sure we don't leak memory, and there's no need to keep the
-		 * cache around for any of the other cases.
+		 * cache around for any of the other cases. Keeping the cache
+		 * is useful for succesive KVM_CLEAR_DIRTY_LOG calls, which is
+		 * not handled in this function.
 		 */
 		kvm_mmu_free_memory_cache(&kvm->arch.mmu.split_page_cache);
 	}
-- 
2.38.1.431.g37b22c650d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
