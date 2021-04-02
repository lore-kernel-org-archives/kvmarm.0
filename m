Return-Path: <SRS0=9BEn=I7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1252FC433B4
	for <kvmarm@archiver.kernel.org>; Fri,  2 Apr 2021 09:20:47 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 815F961107
	for <kvmarm@archiver.kernel.org>; Fri,  2 Apr 2021 09:20:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 815F961107
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A0B74B2C2;
	Fri,  2 Apr 2021 05:20:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5VDhLYEWSCin; Fri,  2 Apr 2021 05:20:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 051DE4B2F7;
	Fri,  2 Apr 2021 05:20:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EF6FD4B744
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Apr 2021 20:57:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ePlOeMinAx4r for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Apr 2021 20:57:16 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DD8EA4B6D6
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Apr 2021 20:57:16 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id 10so7678495ybx.11
 for <kvmarm@lists.cs.columbia.edu>; Thu, 01 Apr 2021 17:57:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=reply-to:date:in-reply-to:message-id:mime-version:references
 :subject:from:to:cc;
 bh=y/zVj+e4eh+grd7JhvH5qtp7OcgDLrdJbmGHERKxrC4=;
 b=PrHz1XlM0Hr7dj/3k+U6DFcxjEzY8eyRBNbENuiKfougxaC5m5hKN5hYidhk0YwqdT
 1LEDnDhb/EBVy/LOAZAarZgzg7AH365xy5vZG1To6JtHcs5VoUrCierjI5vawTWHHZaI
 S3XJrNV82DxrEwSC+E9EFd6HQDUfpciTkbU/weWRx5LhLPdoxmeW914MN5/QzqtXY4YB
 EGen6yDxmxresT7lL0GH8/iVOR4NyDpNgSg+dJZSEStAy1itt5EUClsyWwtGjaKrokJ+
 a/9d/Dr1ASfLg0C1b3mfphnteKHbNcGgzAklp33uDved6rN1h/vUnL6shLD7FYWQwAdY
 mIAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:reply-to:date:in-reply-to:message-id
 :mime-version:references:subject:from:to:cc;
 bh=y/zVj+e4eh+grd7JhvH5qtp7OcgDLrdJbmGHERKxrC4=;
 b=e8WDw94MFGuaQ6bqUHsAVVWssgBdGd2JneC37pftpBFIRz9K2t5LDIBoCNywBjc6A4
 q58wiNMLAPkZ/GHjvYEjJn3isHLBb5nWn3Xcz6skzrdB8GEKeundxvDWdK+A8WVQLGLO
 RBGPbUXqjELjGd4bHFd3cYusb8r1r9kud6LWo7wQgTvXhY1sW2CgVSI7F2iaGTL193IA
 rYJJ60phnyMXVSO6R7zxMHG1JvrggeoG1qgjjFEEoBYf/RJiUbmOFN2STmNJLzoSCHD9
 ECcV5dmmWBmWv2ewitxdPs3+k58FakKcBzPPTIaohRehkdSbtpbE5UrLUbjac6mwpQah
 chEQ==
X-Gm-Message-State: AOAM533paEpQc85z6gKJ7lmkE+7PfSwa261w4CbDcUX/NXqnyFmtVWmX
 fwjiG73ksweghvmKlVSCW0VkGHHUNMM=
X-Google-Smtp-Source: ABdhPJxN7BC0gdMs77a2cNfqqIS58kJ1lGVFM4Q/Y24srpStDulvaRiUUdymISmdyQpNglBO93VbQ9/q4KM=
X-Received: from seanjc798194.pdx.corp.google.com
 ([2620:15c:f:10:c0b4:8b8:bb34:6a56])
 (user=seanjc job=sendgmr) by 2002:a25:2b08:: with SMTP id
 r8mr15849707ybr.194.1617325036437; 
 Thu, 01 Apr 2021 17:57:16 -0700 (PDT)
Date: Thu,  1 Apr 2021 17:56:55 -0700
In-Reply-To: <20210402005658.3024832-1-seanjc@google.com>
Message-Id: <20210402005658.3024832-8-seanjc@google.com>
Mime-Version: 1.0
References: <20210402005658.3024832-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.0.208.g409f899ff0-goog
Subject: [PATCH v2 07/10] KVM: Move MMU notifier's mmu_lock acquisition into
 common helper
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

Acquire and release mmu_lock in the __kvm_handle_hva_range() helper
instead of requiring the caller to do the same.  This paves the way for
future patches to take mmu_lock if and only if an overlapping memslot is
found, without also having to introduce the on_lock() shenanigans used
to manipulate the notifier count and sequence.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---

Note, the WARN_ON_ONCE that asserts on_lock and handler aren't both null
is optimized out of all functions on recent gcc (for x86).  I wanted to
make it a BUILD_BUG_ON, but older versions of gcc aren't agressive/smart
enough to optimize it out, and using __builtin_constant_p() to get it to
build on older compilers prevents the assertion from firing on newer
compilers when given bad input.

I'm also a-ok dropping the check altogether, it just felt wrong having
the semi-funky on_lock -> !handler combo without documenting that handler
isn't allowed to be null in the common case.

 virt/kvm/kvm_main.c | 125 +++++++++++++++++++++++++++++---------------
 1 file changed, 82 insertions(+), 43 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 2e809d73c7f1..25ecb5235e17 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -453,28 +453,57 @@ static void kvm_mmu_notifier_invalidate_range(struct mmu_notifier *mn,
 
 typedef bool (*hva_handler_t)(struct kvm *kvm, struct kvm_gfn_range *range);
 
+typedef void (*on_lock_fn_t)(struct kvm *kvm, unsigned long start,
+			     unsigned long end);
+
 struct kvm_hva_range {
 	unsigned long start;
 	unsigned long end;
 	pte_t pte;
 	hva_handler_t handler;
+	on_lock_fn_t on_lock;
 	bool flush_on_ret;
 	bool may_block;
 };
 
+/*
+ * Use a dedicated stub instead of NULL to indicate that there is no callback
+ * function/handler.  The compiler technically can't guarantee that a real
+ * function will have a non-zero address, and so it will generate code to
+ * check for !NULL, whereas comparing against a stub will be elided at compile
+ * time (unless the compiler is getting long in the tooth, e.g. gcc 4.9).
+ */
+static void kvm_null_fn(void)
+{
+
+}
+#define IS_KVM_NULL_FN(fn) ((fn) == (void *)kvm_null_fn)
+
 static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
 						  const struct kvm_hva_range *range)
 {
-	struct kvm_memory_slot *slot;
-	struct kvm_memslots *slots;
 	struct kvm_gfn_range gfn_range;
+	struct kvm_memory_slot *slot;
+	struct kvm_memslots *slots;
 	bool ret = false;
 	int i, idx;
 
-	lockdep_assert_held_write(&kvm->mmu_lock);
+	/* A null handler is allowed if and only if on_lock() is provided. */
+	if (WARN_ON_ONCE(IS_KVM_NULL_FN(range->on_lock) &&
+			 IS_KVM_NULL_FN(range->handler)))
+		return 0;
+
+	KVM_MMU_LOCK(kvm);
 
 	idx = srcu_read_lock(&kvm->srcu);
 
+	if (!IS_KVM_NULL_FN(range->on_lock)) {
+		range->on_lock(kvm, range->start, range->end);
+
+		if (IS_KVM_NULL_FN(range->handler))
+			goto out_unlock;
+	}
+
 	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
 		slots = __kvm_memslots(kvm, i);
 		kvm_for_each_memslot(slot, slots) {
@@ -510,6 +539,9 @@ static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
 	if (range->flush_on_ret && (ret || kvm->tlbs_dirty))
 		kvm_flush_remote_tlbs(kvm);
 
+out_unlock:
+	KVM_MMU_UNLOCK(kvm);
+
 	srcu_read_unlock(&kvm->srcu, idx);
 
 	/* The notifiers are averse to booleans. :-( */
@@ -528,16 +560,12 @@ static __always_inline int kvm_handle_hva_range(struct mmu_notifier *mn,
 		.end		= end,
 		.pte		= pte,
 		.handler	= handler,
+		.on_lock	= (void *)kvm_null_fn,
 		.flush_on_ret	= true,
 		.may_block	= false,
 	};
-	int ret;
 
-	KVM_MMU_LOCK(kvm);
-	ret = __kvm_handle_hva_range(kvm, &range);
-	KVM_MMU_UNLOCK(kvm);
-
-	return ret;
+	return __kvm_handle_hva_range(kvm, &range);
 }
 
 static __always_inline int kvm_handle_hva_range_no_flush(struct mmu_notifier *mn,
@@ -551,16 +579,12 @@ static __always_inline int kvm_handle_hva_range_no_flush(struct mmu_notifier *mn
 		.end		= end,
 		.pte		= __pte(0),
 		.handler	= handler,
+		.on_lock	= (void *)kvm_null_fn,
 		.flush_on_ret	= false,
 		.may_block	= false,
 	};
-	int ret;
 
-	KVM_MMU_LOCK(kvm);
-	ret = __kvm_handle_hva_range(kvm, &range);
-	KVM_MMU_UNLOCK(kvm);
-
-	return ret;
+	return __kvm_handle_hva_range(kvm, &range);
 }
 static void kvm_mmu_notifier_change_pte(struct mmu_notifier *mn,
 					struct mm_struct *mm,
@@ -581,22 +605,9 @@ static void kvm_mmu_notifier_change_pte(struct mmu_notifier *mn,
 	kvm_handle_hva_range(mn, address, address + 1, pte, kvm_set_spte_gfn);
 }
 
-static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
-					const struct mmu_notifier_range *range)
+static void kvm_inc_notifier_count(struct kvm *kvm, unsigned long start,
+				   unsigned long end)
 {
-	struct kvm *kvm = mmu_notifier_to_kvm(mn);
-	const struct kvm_hva_range hva_range = {
-		.start		= range->start,
-		.end		= range->end,
-		.pte		= __pte(0),
-		.handler	= kvm_unmap_gfn_range,
-		.flush_on_ret	= true,
-		.may_block	= mmu_notifier_range_blockable(range),
-	};
-
-	trace_kvm_unmap_hva_range(range->start, range->end);
-
-	KVM_MMU_LOCK(kvm);
 	/*
 	 * The count increase must become visible at unlock time as no
 	 * spte can be established without taking the mmu_lock and
@@ -604,8 +615,8 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
 	 */
 	kvm->mmu_notifier_count++;
 	if (likely(kvm->mmu_notifier_count == 1)) {
-		kvm->mmu_notifier_range_start = range->start;
-		kvm->mmu_notifier_range_end = range->end;
+		kvm->mmu_notifier_range_start = start;
+		kvm->mmu_notifier_range_end = end;
 	} else {
 		/*
 		 * Fully tracking multiple concurrent ranges has dimishing
@@ -617,24 +628,36 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
 		 * complete.
 		 */
 		kvm->mmu_notifier_range_start =
-			min(kvm->mmu_notifier_range_start, range->start);
+			min(kvm->mmu_notifier_range_start, start);
 		kvm->mmu_notifier_range_end =
-			max(kvm->mmu_notifier_range_end, range->end);
+			max(kvm->mmu_notifier_range_end, end);
 	}
-
-	__kvm_handle_hva_range(kvm, &hva_range);
-
-	KVM_MMU_UNLOCK(kvm);
-
-	return 0;
 }
 
-static void kvm_mmu_notifier_invalidate_range_end(struct mmu_notifier *mn,
+static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
 					const struct mmu_notifier_range *range)
 {
 	struct kvm *kvm = mmu_notifier_to_kvm(mn);
+	const struct kvm_hva_range hva_range = {
+		.start		= range->start,
+		.end		= range->end,
+		.pte		= __pte(0),
+		.handler	= kvm_unmap_gfn_range,
+		.on_lock	= kvm_inc_notifier_count,
+		.flush_on_ret	= true,
+		.may_block	= mmu_notifier_range_blockable(range),
+	};
 
-	KVM_MMU_LOCK(kvm);
+	trace_kvm_unmap_hva_range(range->start, range->end);
+
+	__kvm_handle_hva_range(kvm, &hva_range);
+
+	return 0;
+}
+
+static void kvm_dec_notifier_count(struct kvm *kvm, unsigned long start,
+				   unsigned long end)
+{
 	/*
 	 * This sequence increase will notify the kvm page fault that
 	 * the page that is going to be mapped in the spte could have
@@ -648,7 +671,23 @@ static void kvm_mmu_notifier_invalidate_range_end(struct mmu_notifier *mn,
 	 * in conjunction with the smp_rmb in mmu_notifier_retry().
 	 */
 	kvm->mmu_notifier_count--;
-	KVM_MMU_UNLOCK(kvm);
+}
+
+static void kvm_mmu_notifier_invalidate_range_end(struct mmu_notifier *mn,
+					const struct mmu_notifier_range *range)
+{
+	struct kvm *kvm = mmu_notifier_to_kvm(mn);
+	const struct kvm_hva_range hva_range = {
+		.start		= range->start,
+		.end		= range->end,
+		.pte		= __pte(0),
+		.handler	= (void *)kvm_null_fn,
+		.on_lock	= kvm_dec_notifier_count,
+		.flush_on_ret	= true,
+		.may_block	= mmu_notifier_range_blockable(range),
+	};
+
+	__kvm_handle_hva_range(kvm, &hva_range);
 
 	BUG_ON(kvm->mmu_notifier_count < 0);
 }
-- 
2.31.0.208.g409f899ff0-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
