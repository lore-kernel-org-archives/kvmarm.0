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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4E2FC433E0
	for <kvmarm@archiver.kernel.org>; Fri, 26 Mar 2021 13:54:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5030D61A1E
	for <kvmarm@archiver.kernel.org>; Fri, 26 Mar 2021 13:54:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5030D61A1E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DFAC64B491;
	Fri, 26 Mar 2021 09:54:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id CSaygCNz8IdE; Fri, 26 Mar 2021 09:54:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7A0154B49A;
	Fri, 26 Mar 2021 09:54:25 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A549B4B466
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Mar 2021 22:20:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Fl7McN1IUJ-7 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 25 Mar 2021 22:20:15 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9799F4B470
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Mar 2021 22:20:15 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id u128so8268373ybf.12
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Mar 2021 19:20:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=reply-to:date:in-reply-to:message-id:mime-version:references
 :subject:from:to:cc;
 bh=8Eo/ejufJftePnvgXQFd5kbV9TMjCK+DUzEIWSLNHic=;
 b=J4NBszqz0qYCjVKsOP65Ukhsxf/vaS7LS6yFdbgFAh2sUgBQG0ogA/cQxk794uXzjP
 RY9KWD9YNpzjGBLdWOTPyshz2TFnTG+tnYPlCC99vnayJJ8x/1vz0RyuxQBRKNswIoqx
 u7caOX3ZY3ljHIlIuV5UDQD7orO9CacchKaW4wZWVQ1KulpoGRsgS3HncjI2rDTBW85e
 0LzSSCSzQyzj0qFJEDJj1/5vO/M+e6fGvrqJcu73hE+6xaV3PGahPlecwL8l+6KqIgxm
 +0hE0fM1McrNq/V5ahNrq1hMd2o01ghMEWLbLn93kMCLrtd6e1hGFJmudhcDtPpnJwkT
 0OzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:reply-to:date:in-reply-to:message-id
 :mime-version:references:subject:from:to:cc;
 bh=8Eo/ejufJftePnvgXQFd5kbV9TMjCK+DUzEIWSLNHic=;
 b=QwykTwiJkmAqBIfvM48WOJFJFev/KUsMmRIaiQ2U9TVJOsHZ9UXgXiG63GYLJ/A417
 RszmRm9nKgrlEBppx7X9bXZSXQtCYUa/JexIdWA9RvLlxrhwtMVMmqPE0DXqAoa2L9pZ
 XY6WN6J4phBChcKxA9Br9uyAaKFi+nAXZfRn+ExcO0MevNJx4yzw7K1xKwMBYknFHFbA
 RzqK8yuu4QQmrAUVULRxeRTjlCZlWDiB1yXTPk86ChSMNSAvO4hjBn0+xJZl7cgrssZ6
 Ve59o8tB6Odpn50VKuqqgjsbdGg0msnxJFC9GJFoLGwniK3jk5XQH23k5QDDARUcW8GB
 rAmQ==
X-Gm-Message-State: AOAM530lJ8o1w8WTaw/gzbtbg6GliK1RP0xK6M37yEWU0gd9guxrPSjT
 PUAA00q/jOi9hpLo7FuCDQM5zzY2sb0=
X-Google-Smtp-Source: ABdhPJwV8LHyLDP6hqXuH/hYE4HksnD0YFc19NvHc8Jf2O8EQ8BbTBUtjDn7cvQ5x0SPUFyfrReRDGiHTIk=
X-Received: from seanjc798194.pdx.corp.google.com
 ([2620:15c:f:10:b1bb:fab2:7ef5:fc7d])
 (user=seanjc job=sendgmr) by 2002:a25:9982:: with SMTP id
 p2mr17272898ybo.457.1616725215166; 
 Thu, 25 Mar 2021 19:20:15 -0700 (PDT)
Date: Thu, 25 Mar 2021 19:19:41 -0700
In-Reply-To: <20210326021957.1424875-1-seanjc@google.com>
Message-Id: <20210326021957.1424875-3-seanjc@google.com>
Mime-Version: 1.0
References: <20210326021957.1424875-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
Subject: [PATCH 02/18] KVM: x86/mmu: Move flushing for "slot" handlers to
 caller for legacy MMU
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

Place the onus on the caller of slot_handle_*() to flush the TLB, rather
than handling the flush in the helper, and rename parameters accordingly.
This will allow future patches to coalesce flushes between address spaces
and between the legacy and TDP MMUs.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 37 +++++++++++++++++++------------------
 1 file changed, 19 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 7a99e59c8c1c..d5c9fb34971a 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5227,7 +5227,7 @@ typedef bool (*slot_level_handler) (struct kvm *kvm, struct kvm_rmap_head *rmap_
 static __always_inline bool
 slot_handle_level_range(struct kvm *kvm, struct kvm_memory_slot *memslot,
 			slot_level_handler fn, int start_level, int end_level,
-			gfn_t start_gfn, gfn_t end_gfn, bool lock_flush_tlb)
+			gfn_t start_gfn, gfn_t end_gfn, bool flush_on_yield)
 {
 	struct slot_rmap_walk_iterator iterator;
 	bool flush = false;
@@ -5238,7 +5238,7 @@ slot_handle_level_range(struct kvm *kvm, struct kvm_memory_slot *memslot,
 			flush |= fn(kvm, iterator.rmap, memslot);
 
 		if (need_resched() || rwlock_needbreak(&kvm->mmu_lock)) {
-			if (flush && lock_flush_tlb) {
+			if (flush && flush_on_yield) {
 				kvm_flush_remote_tlbs_with_address(kvm,
 						start_gfn,
 						iterator.gfn - start_gfn + 1);
@@ -5248,32 +5248,26 @@ slot_handle_level_range(struct kvm *kvm, struct kvm_memory_slot *memslot,
 		}
 	}
 
-	if (flush && lock_flush_tlb) {
-		kvm_flush_remote_tlbs_with_address(kvm, start_gfn,
-						   end_gfn - start_gfn + 1);
-		flush = false;
-	}
-
 	return flush;
 }
 
 static __always_inline bool
 slot_handle_level(struct kvm *kvm, struct kvm_memory_slot *memslot,
 		  slot_level_handler fn, int start_level, int end_level,
-		  bool lock_flush_tlb)
+		  bool flush_on_yield)
 {
 	return slot_handle_level_range(kvm, memslot, fn, start_level,
 			end_level, memslot->base_gfn,
 			memslot->base_gfn + memslot->npages - 1,
-			lock_flush_tlb);
+			flush_on_yield);
 }
 
 static __always_inline bool
 slot_handle_leaf(struct kvm *kvm, struct kvm_memory_slot *memslot,
-		 slot_level_handler fn, bool lock_flush_tlb)
+		 slot_level_handler fn, bool flush_on_yield)
 {
 	return slot_handle_level(kvm, memslot, fn, PG_LEVEL_4K,
-				 PG_LEVEL_4K, lock_flush_tlb);
+				 PG_LEVEL_4K, flush_on_yield);
 }
 
 static void free_mmu_pages(struct kvm_mmu *mmu)
@@ -5509,10 +5503,14 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
 			if (start >= end)
 				continue;
 
-			slot_handle_level_range(kvm, memslot, kvm_zap_rmapp,
-						PG_LEVEL_4K,
-						KVM_MAX_HUGEPAGE_LEVEL,
-						start, end - 1, true);
+			flush = slot_handle_level_range(kvm, memslot, kvm_zap_rmapp,
+							PG_LEVEL_4K,
+							KVM_MAX_HUGEPAGE_LEVEL,
+							start, end - 1, true);
+
+			if (flush)
+				kvm_flush_remote_tlbs_with_address(kvm, gfn_start,
+								   gfn_end);
 		}
 	}
 
@@ -5605,9 +5603,12 @@ void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
 {
 	/* FIXME: const-ify all uses of struct kvm_memory_slot.  */
 	struct kvm_memory_slot *slot = (struct kvm_memory_slot *)memslot;
+	bool flush;
 
 	write_lock(&kvm->mmu_lock);
-	slot_handle_leaf(kvm, slot, kvm_mmu_zap_collapsible_spte, true);
+	flush = slot_handle_leaf(kvm, slot, kvm_mmu_zap_collapsible_spte, true);
+	if (flush)
+		kvm_arch_flush_remote_tlbs_memslot(kvm, slot);
 
 	if (is_tdp_mmu_enabled(kvm))
 		kvm_tdp_mmu_zap_collapsible_sptes(kvm, slot);
@@ -5619,7 +5620,7 @@ void kvm_arch_flush_remote_tlbs_memslot(struct kvm *kvm,
 {
 	/*
 	 * All current use cases for flushing the TLBs for a specific memslot
-	 * are related to dirty logging, and do the TLB flush out of mmu_lock.
+	 * related to dirty logging, and many do the TLB flush out of mmu_lock.
 	 * The interaction between the various operations on memslot must be
 	 * serialized by slots_locks to ensure the TLB flush from one operation
 	 * is observed by any other operation on the same memslot.
-- 
2.31.0.291.g576ba9dcdaf-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
