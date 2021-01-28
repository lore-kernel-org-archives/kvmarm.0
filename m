Return-Path: <SRS0=rJEk=G7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D85DC4332B
	for <kvmarm@archiver.kernel.org>; Thu, 28 Jan 2021 10:47:34 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E35C064DDB
	for <kvmarm@archiver.kernel.org>; Thu, 28 Jan 2021 10:47:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E35C064DDB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F6FB4B10E;
	Thu, 28 Jan 2021 05:47:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@chromium.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vEZ4XijrF8M5; Thu, 28 Jan 2021 05:47:31 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CC25B4B1D2;
	Thu, 28 Jan 2021 05:47:30 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9EF564B1DB
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Jan 2021 01:05:45 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id W8hJIQbB-3by for <kvmarm@lists.cs.columbia.edu>;
 Thu, 28 Jan 2021 01:05:44 -0500 (EST)
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com
 [209.85.210.171])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 155494B09F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Jan 2021 01:05:44 -0500 (EST)
Received: by mail-pf1-f171.google.com with SMTP id q131so3307351pfq.10
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Jan 2021 22:05:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chromium.org; s=google;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=h5YEggt5lA84c1PH2zTZBT+07Nd+Wthjn+k8lDWe2pw=;
 b=TX0TeeZfpe1/zoRbFjt0GeaYz6U/SkGhuQPCQ9lupMcqhh6H0ByI9rmuNa/4/4WXDt
 pRUCdzBBvaAglHOBC6tncbMTAGeQ39Ll6P/O0ohR64kP+uIDp2qvXGm2BG8OnUYqbGkw
 SPWbXkHJjySFdiBqeWptzGg4um5govcDmHDKQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=h5YEggt5lA84c1PH2zTZBT+07Nd+Wthjn+k8lDWe2pw=;
 b=tqflSilTYB3PNA9BW54++uDi0Tu8fyRqfkgyOnST6RuxEACjyIdsVritAtu1wKSYNc
 EsBd4v32Z8Q9ZwsFHEMD0vSDZck40to3fx0FKgjGBtbNG0wMriPt6iNhKhGb3V0wEdlm
 htbjNeWGRNQ5JLWQ4GRU9NCUN6PDZ3ReL+548iQLzLRFLTkQzDsTswCvbKr4es9uuKHv
 vsbi8t7pPCkVNlpNM3KXg+IG2bwSvHcX9q0fUTKkIxQO0YaBULbrlBp+aIiRDvF44Bt7
 8oLolCfLrbNYBMa2IlYHocAY8LkJnlzLsfnHzrUeZlz6lDWlZw0rPrBLkA7lujk30ctf
 dCww==
X-Gm-Message-State: AOAM532fBMdTxF9QWm1qhFMLUeEvRm/Qu++SzJ+cB0nyCPTrnKOCB49d
 Fviom7qcGgUsCQ4d1QMWUhtqqg==
X-Google-Smtp-Source: ABdhPJxg3nC8VDtCsn50hQJjaz2+OFHCKOA5bt6e3zGP6X4yWlqdsqOTPPM50S70dDvVIkRWQDSnZw==
X-Received: by 2002:a63:1f21:: with SMTP id f33mr15214301pgf.31.1611813943264; 
 Wed, 27 Jan 2021 22:05:43 -0800 (PST)
Received: from localhost ([2401:fa00:8f:203:919f:d6:7815:52bc])
 by smtp.gmail.com with ESMTPSA id h3sm4136154pgm.67.2021.01.27.22.05.38
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 27 Jan 2021 22:05:42 -0800 (PST)
From: David Stevens <stevensd@chromium.org>
X-Google-Original-From: David Stevens <stevensd@google.com>
To: Sean Christopherson <seanjc@google.com>
Subject: [PATCH v3 2/2] KVM: x86/mmu: Consider the hva in mmu_notifier retry
Date: Thu, 28 Jan 2021 15:05:15 +0900
Message-Id: <20210128060515.1732758-3-stevensd@google.com>
X-Mailer: git-send-email 2.30.0.280.ga3ce27912f-goog
In-Reply-To: <20210128060515.1732758-1-stevensd@google.com>
References: <20210128060515.1732758-1-stevensd@google.com>
MIME-Version: 1.0
X-Mailman-Approved-At: Thu, 28 Jan 2021 05:47:29 -0500
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, linux-mips@vger.kernel.org,
 Paul Mackerras <paulus@ozlabs.org>, Claudio Imbrenda <imbrenda@linux.ibm.com>,
 kvmarm@lists.cs.columbia.edu, Janosch Frank <frankja@linux.ibm.com>,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>, kvm-ppc@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 Cornelia Huck <cohuck@redhat.com>, linux-kernel@vger.kernel.org,
 David Stevens <stevensd@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>
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

From: David Stevens <stevensd@chromium.org>

Track the range being invalidated by mmu_notifier and skip page fault
retries if the fault address is not affected by the in-progress
invalidation. Handle concurrent invalidations by finding the minimal
range which includes all ranges being invalidated. Although the combined
range may include unrelated addresses and cannot be shrunk as individual
invalidation operations complete, it is unlikely the marginal gains of
proper range tracking are worth the additional complexity.

The primary benefit of this change is the reduction in the likelihood of
extreme latency when handing a page fault due to another thread having
been preempted while modifying host virtual addresses.

Signed-off-by: David Stevens <stevensd@chromium.org>
---
v2 -> v3:
 - Removed unnecessary ifdef
 - Style changes

v1 -> v2: 
 - Improve handling of concurrent invalidation requests by unioning
   ranges, instead of just giving up and using [0, ULONG_MAX).
 - Add lockdep check
 - Code comments and formatting

 arch/powerpc/kvm/book3s_64_mmu_hv.c    |  2 +-
 arch/powerpc/kvm/book3s_64_mmu_radix.c |  2 +-
 arch/x86/kvm/mmu/mmu.c                 | 16 ++++++++------
 arch/x86/kvm/mmu/paging_tmpl.h         |  7 ++++---
 include/linux/kvm_host.h               | 25 +++++++++++++++++++++-
 virt/kvm/kvm_main.c                    | 29 ++++++++++++++++++++++----
 6 files changed, 65 insertions(+), 16 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_64_mmu_hv.c b/arch/powerpc/kvm/book3s_64_mmu_hv.c
index 38ea396a23d6..8e06cd3f759c 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_hv.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_hv.c
@@ -590,7 +590,7 @@ int kvmppc_book3s_hv_page_fault(struct kvm_vcpu *vcpu,
 	} else {
 		/* Call KVM generic code to do the slow-path check */
 		pfn = __gfn_to_pfn_memslot(memslot, gfn, false, NULL,
-					   writing, &write_ok);
+					   writing, &write_ok, NULL);
 		if (is_error_noslot_pfn(pfn))
 			return -EFAULT;
 		page = NULL;
diff --git a/arch/powerpc/kvm/book3s_64_mmu_radix.c b/arch/powerpc/kvm/book3s_64_mmu_radix.c
index bb35490400e9..e603de7ade52 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_radix.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_radix.c
@@ -822,7 +822,7 @@ int kvmppc_book3s_instantiate_page(struct kvm_vcpu *vcpu,
 
 		/* Call KVM generic code to do the slow-path check */
 		pfn = __gfn_to_pfn_memslot(memslot, gfn, false, NULL,
-					   writing, upgrade_p);
+					   writing, upgrade_p, NULL);
 		if (is_error_noslot_pfn(pfn))
 			return -EFAULT;
 		page = NULL;
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 9ac0a727015d..8d08e97b2487 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3658,8 +3658,8 @@ static bool kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 }
 
 static bool try_async_pf(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
-			 gpa_t cr2_or_gpa, kvm_pfn_t *pfn, bool write,
-			 bool *writable)
+			 gpa_t cr2_or_gpa, kvm_pfn_t *pfn, hva_t *hva,
+			 bool write, bool *writable)
 {
 	struct kvm_memory_slot *slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
 	bool async;
@@ -3672,7 +3672,8 @@ static bool try_async_pf(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
 	}
 
 	async = false;
-	*pfn = __gfn_to_pfn_memslot(slot, gfn, false, &async, write, writable);
+	*pfn = __gfn_to_pfn_memslot(slot, gfn, false, &async,
+				    write, writable, hva);
 	if (!async)
 		return false; /* *pfn has correct page already */
 
@@ -3686,7 +3687,8 @@ static bool try_async_pf(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
 			return true;
 	}
 
-	*pfn = __gfn_to_pfn_memslot(slot, gfn, false, NULL, write, writable);
+	*pfn = __gfn_to_pfn_memslot(slot, gfn, false, NULL,
+				    write, writable, hva);
 	return false;
 }
 
@@ -3699,6 +3701,7 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 	gfn_t gfn = gpa >> PAGE_SHIFT;
 	unsigned long mmu_seq;
 	kvm_pfn_t pfn;
+	hva_t hva;
 	int r;
 
 	if (page_fault_handle_page_track(vcpu, error_code, gfn))
@@ -3717,7 +3720,8 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 	mmu_seq = vcpu->kvm->mmu_notifier_seq;
 	smp_rmb();
 
-	if (try_async_pf(vcpu, prefault, gfn, gpa, &pfn, write, &map_writable))
+	if (try_async_pf(vcpu, prefault, gfn, gpa, &pfn, &hva,
+			 write, &map_writable))
 		return RET_PF_RETRY;
 
 	if (handle_abnormal_pfn(vcpu, is_tdp ? 0 : gpa, gfn, pfn, ACC_ALL, &r))
@@ -3725,7 +3729,7 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 
 	r = RET_PF_RETRY;
 	spin_lock(&vcpu->kvm->mmu_lock);
-	if (!is_noslot_pfn(pfn) && mmu_notifier_retry(vcpu->kvm, mmu_seq))
+	if (!is_noslot_pfn(pfn) && mmu_notifier_retry_hva(vcpu->kvm, mmu_seq, hva))
 		goto out_unlock;
 	r = make_mmu_pages_available(vcpu);
 	if (r)
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index ab54263d857c..5f12f7b24d68 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -790,6 +790,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gpa_t addr, u32 error_code,
 	struct guest_walker walker;
 	int r;
 	kvm_pfn_t pfn;
+	hva_t hva;
 	unsigned long mmu_seq;
 	bool map_writable, is_self_change_mapping;
 	int max_level;
@@ -840,8 +841,8 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gpa_t addr, u32 error_code,
 	mmu_seq = vcpu->kvm->mmu_notifier_seq;
 	smp_rmb();
 
-	if (try_async_pf(vcpu, prefault, walker.gfn, addr, &pfn, write_fault,
-			 &map_writable))
+	if (try_async_pf(vcpu, prefault, walker.gfn, addr, &pfn, &hva,
+			 write_fault, &map_writable))
 		return RET_PF_RETRY;
 
 	if (handle_abnormal_pfn(vcpu, addr, walker.gfn, pfn, walker.pte_access, &r))
@@ -869,7 +870,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gpa_t addr, u32 error_code,
 
 	r = RET_PF_RETRY;
 	spin_lock(&vcpu->kvm->mmu_lock);
-	if (!is_noslot_pfn(pfn) && mmu_notifier_retry(vcpu->kvm, mmu_seq))
+	if (!is_noslot_pfn(pfn) && mmu_notifier_retry_hva(vcpu->kvm, mmu_seq, hva))
 		goto out_unlock;
 
 	kvm_mmu_audit(vcpu, AUDIT_PRE_PAGE_FAULT);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index f3b1013fb22c..850ff351583d 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -11,6 +11,7 @@
 #include <linux/signal.h>
 #include <linux/sched.h>
 #include <linux/bug.h>
+#include <linux/minmax.h>
 #include <linux/mm.h>
 #include <linux/mmu_notifier.h>
 #include <linux/preempt.h>
@@ -502,6 +503,8 @@ struct kvm {
 	struct mmu_notifier mmu_notifier;
 	unsigned long mmu_notifier_seq;
 	long mmu_notifier_count;
+	unsigned long mmu_notifier_range_start;
+	unsigned long mmu_notifier_range_end;
 #endif
 	long tlbs_dirty;
 	struct list_head devices;
@@ -729,7 +732,7 @@ kvm_pfn_t gfn_to_pfn_memslot(struct kvm_memory_slot *slot, gfn_t gfn);
 kvm_pfn_t gfn_to_pfn_memslot_atomic(struct kvm_memory_slot *slot, gfn_t gfn);
 kvm_pfn_t __gfn_to_pfn_memslot(struct kvm_memory_slot *slot, gfn_t gfn,
 			       bool atomic, bool *async, bool write_fault,
-			       bool *writable);
+			       bool *writable, hva_t *hva);
 
 void kvm_release_pfn_clean(kvm_pfn_t pfn);
 void kvm_release_pfn_dirty(kvm_pfn_t pfn);
@@ -1203,6 +1206,26 @@ static inline int mmu_notifier_retry(struct kvm *kvm, unsigned long mmu_seq)
 		return 1;
 	return 0;
 }
+
+static inline int mmu_notifier_retry_hva(struct kvm *kvm,
+					 unsigned long mmu_seq,
+					 unsigned long hva)
+{
+	lockdep_assert_held(&kvm->mmu_lock);
+	/*
+	 * If mmu_notifier_count is non-zero, then the range maintained by
+	 * kvm_mmu_notifier_invalidate_range_start contains all addresses that
+	 * might be being invalidated. Note that it may include some false
+	 * positives, due to shortcuts when handing concurrent invalidations.
+	 */
+	if (unlikely(kvm->mmu_notifier_count) &&
+	    hva >= kvm->mmu_notifier_range_start &&
+	    hva < kvm->mmu_notifier_range_end)
+		return 1;
+	if (kvm->mmu_notifier_seq != mmu_seq)
+		return 1;
+	return 0;
+}
 #endif
 
 #ifdef CONFIG_HAVE_KVM_IRQ_ROUTING
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index fa9e3614d30e..b4b0a1eeb4c5 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -483,6 +483,24 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
 	 * count is also read inside the mmu_lock critical section.
 	 */
 	kvm->mmu_notifier_count++;
+	if (likely(kvm->mmu_notifier_count == 1)) {
+		kvm->mmu_notifier_range_start = range->start;
+		kvm->mmu_notifier_range_end = range->end;
+	} else {
+		/*
+		 * Fully tracking multiple concurrent ranges has dimishing
+		 * returns. Keep things simple and just find the minimal range
+		 * which includes the current and new ranges. As there won't be
+		 * enough information to subtract a range after its invalidate
+		 * completes, any ranges invalidated concurrently will
+		 * accumulate and persist until all outstanding invalidates
+		 * complete.
+		 */
+		kvm->mmu_notifier_range_start =
+			min(kvm->mmu_notifier_range_start, range->start);
+		kvm->mmu_notifier_range_end =
+			max(kvm->mmu_notifier_range_end, range->end);
+	}
 	need_tlb_flush = kvm_unmap_hva_range(kvm, range->start, range->end,
 					     range->flags);
 	/* we've to flush the tlb before the pages can be freed */
@@ -2010,10 +2028,13 @@ static kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool *async,
 
 kvm_pfn_t __gfn_to_pfn_memslot(struct kvm_memory_slot *slot, gfn_t gfn,
 			       bool atomic, bool *async, bool write_fault,
-			       bool *writable)
+			       bool *writable, hva_t *hva)
 {
 	unsigned long addr = __gfn_to_hva_many(slot, gfn, NULL, write_fault);
 
+	if (hva)
+		*hva = addr;
+
 	if (addr == KVM_HVA_ERR_RO_BAD) {
 		if (writable)
 			*writable = false;
@@ -2041,19 +2062,19 @@ kvm_pfn_t gfn_to_pfn_prot(struct kvm *kvm, gfn_t gfn, bool write_fault,
 		      bool *writable)
 {
 	return __gfn_to_pfn_memslot(gfn_to_memslot(kvm, gfn), gfn, false, NULL,
-				    write_fault, writable);
+				    write_fault, writable, NULL);
 }
 EXPORT_SYMBOL_GPL(gfn_to_pfn_prot);
 
 kvm_pfn_t gfn_to_pfn_memslot(struct kvm_memory_slot *slot, gfn_t gfn)
 {
-	return __gfn_to_pfn_memslot(slot, gfn, false, NULL, true, NULL);
+	return __gfn_to_pfn_memslot(slot, gfn, false, NULL, true, NULL, NULL);
 }
 EXPORT_SYMBOL_GPL(gfn_to_pfn_memslot);
 
 kvm_pfn_t gfn_to_pfn_memslot_atomic(struct kvm_memory_slot *slot, gfn_t gfn)
 {
-	return __gfn_to_pfn_memslot(slot, gfn, true, NULL, true, NULL);
+	return __gfn_to_pfn_memslot(slot, gfn, true, NULL, true, NULL, NULL);
 }
 EXPORT_SYMBOL_GPL(gfn_to_pfn_memslot_atomic);
 
-- 
2.30.0.280.ga3ce27912f-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
