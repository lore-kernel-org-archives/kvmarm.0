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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55C97C433C1
	for <kvmarm@archiver.kernel.org>; Fri, 26 Mar 2021 13:54:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F1F9061A1D
	for <kvmarm@archiver.kernel.org>; Fri, 26 Mar 2021 13:54:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F1F9061A1D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9D9BE4B4CC;
	Fri, 26 Mar 2021 09:54:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xKyTC3yXHt-r; Fri, 26 Mar 2021 09:54:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D181B4B4B4;
	Fri, 26 Mar 2021 09:54:25 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BD1E94B466
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Mar 2021 22:20:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MU0zXEKnAZXE for <kvmarm@lists.cs.columbia.edu>;
 Thu, 25 Mar 2021 22:20:22 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id ABA744B476
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Mar 2021 22:20:22 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id 6so8367051ybq.7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Mar 2021 19:20:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=reply-to:date:in-reply-to:message-id:mime-version:references
 :subject:from:to:cc;
 bh=wa2HBnHEdugpF8GI82/VnGsbMbCyax7Usmida2hsXks=;
 b=ntRnGtewMrQnJ0ZyoywcfyJoY3VXcJKm1/k0N8vnJz2sS/sLUavVYbXyZjmGfLujWs
 A7OpVuVgrge9g6sIHyA8kKuuxCVJF4LHDfnRC57c3LwcZMFB52xHIkGZYPVRV7LmBtRX
 cWP26TbhKCHtihLdf8ro8Ar6sN9KG09UTt+Nqp+iYYP5QggYHELX9BtW7vC45YuqRmLX
 +1SmkA8iHzw6bh5WdqcLT6PNv0Z6mPgkElc6VIZ568ErC9hQHNFLULnTTb0JHUFeOKYG
 OVxzIBDlPyjxENSnw4f8tOUFmE9kUrLxpEbgsdwoFB2DPFP1sPp9Ubk2TCAp2h46mMxC
 zPNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:reply-to:date:in-reply-to:message-id
 :mime-version:references:subject:from:to:cc;
 bh=wa2HBnHEdugpF8GI82/VnGsbMbCyax7Usmida2hsXks=;
 b=azt3SPwQiVphHOat41Zg4GJc/ut5JdcLWrFkC1G+DUDriU1YGeNR2H3LNXOejCHYH1
 vLrR7KODmjXZonk5MgNspvar89kmvbt/3M2UeuYqtzBEsCn33EGd0Lw8o42XDWGrCqgK
 juWH7SJV5FpiuRH2toJuOtqhC/+COxH+WQ5Yo4EFhal/E2bbvxz4XJ9w+mhkvyFMk7ZQ
 rpao0YqoXMNnpSssWulASPGe24Pbe5wQjXNyaQMA6LHVdiLagMCteU7cf85V0uXagVGe
 xCyW8sK1rRVhXLtBaYpOMD8kNdagdUH9sVfBqE9Ni4MqTbwE1MQS9X5gfW+OyORvwHfp
 PUzg==
X-Gm-Message-State: AOAM532XZohjDqtcW0V6Kfb0C3MfkrNqkGki54/SeUjhI6slc+yv98Lv
 AbaethMMbBnenpFzAJr3Ey3C5ed15AQ=
X-Google-Smtp-Source: ABdhPJzHMxoOuIYzjF4gA1CiN58yUH1BUsmjnfOuZHCxx1/JoBQt3Lta5tuRC1MywTz941gtZrU1EG9DA4g=
X-Received: from seanjc798194.pdx.corp.google.com
 ([2620:15c:f:10:b1bb:fab2:7ef5:fc7d])
 (user=seanjc job=sendgmr) by 2002:a25:6f44:: with SMTP id
 k65mr15773485ybc.218.1616725222218; 
 Thu, 25 Mar 2021 19:20:22 -0700 (PDT)
Date: Thu, 25 Mar 2021 19:19:44 -0700
In-Reply-To: <20210326021957.1424875-1-seanjc@google.com>
Message-Id: <20210326021957.1424875-6-seanjc@google.com>
Mime-Version: 1.0
References: <20210326021957.1424875-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
Subject: [PATCH 05/18] KVM: x86/mmu: Pass address space ID to
 __kvm_tdp_mmu_zap_gfn_range()
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

Pass the address space ID to TDP MMU's primary "zap gfn range" helper to
allow the MMU notifier paths to iterate over memslots exactly once.
Currently, both the legacy MMU and TDP MMU iterate over memslots when
looking for an overlapping hva range, which can be quite costly if there
are a large number of memslots.

Add a "flush" parameter so that iterating over multiple address spaces
in the caller will continue to do the right thing when yielding while a
flush is pending from a previous address space.

Note, this also has a functional change in the form of coalescing TLB
flushes across multiple address spaces in kvm_zap_gfn_range(), and also
optimizes the TDP MMU to utilize range-based flushing when running as L1
with Hyper-V enlightenments.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c          | 10 ++++------
 arch/x86/kvm/mmu/mmu_internal.h |  5 +++++
 arch/x86/kvm/mmu/tdp_mmu.c      | 22 +++++++++++-----------
 arch/x86/kvm/mmu/tdp_mmu.h      | 13 +++++++------
 4 files changed, 27 insertions(+), 23 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index e6e02360ef67..36c231d6bff9 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5508,17 +5508,15 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
 							KVM_MAX_HUGEPAGE_LEVEL,
 							start, end - 1, true, flush);
 		}
+
+		if (is_tdp_mmu_enabled(kvm))
+			flush = kvm_tdp_mmu_zap_gfn_range(kvm, i, gfn_start,
+							  gfn_end, flush);
 	}
 
 	if (flush)
 		kvm_flush_remote_tlbs_with_address(kvm, gfn_start, gfn_end);
 
-	if (is_tdp_mmu_enabled(kvm)) {
-		flush = kvm_tdp_mmu_zap_gfn_range(kvm, gfn_start, gfn_end);
-		if (flush)
-			kvm_flush_remote_tlbs(kvm);
-	}
-
 	write_unlock(&kvm->mmu_lock);
 }
 
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 5fe9123fc932..db2faa806ab7 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -129,6 +129,11 @@ static inline bool kvm_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *sp)
 	return !sp->root_count;
 }
 
+static inline int kvm_mmu_page_as_id(struct kvm_mmu_page *sp)
+{
+	return sp->role.smm ? 1 : 0;
+}
+
 /*
  * Return values of handle_mmio_page_fault, mmu.page_fault, and fast_page_fault().
  *
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index ff2bb0c8012e..bf279fff70ea 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -190,11 +190,6 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 				u64 old_spte, u64 new_spte, int level,
 				bool shared);
 
-static int kvm_mmu_page_as_id(struct kvm_mmu_page *sp)
-{
-	return sp->role.smm ? 1 : 0;
-}
-
 static void handle_changed_spte_acc_track(u64 old_spte, u64 new_spte, int level)
 {
 	if (!is_shadow_present_pte(old_spte) || !is_last_spte(old_spte, level))
@@ -709,14 +704,16 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
  * SPTEs have been cleared and a TLB flush is needed before releasing the
  * MMU lock.
  */
-bool __kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, gfn_t start, gfn_t end,
-				 bool can_yield)
+bool __kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, int as_id, gfn_t start,
+				 gfn_t end, bool can_yield, bool flush)
 {
 	struct kvm_mmu_page *root;
-	bool flush = false;
 
-	for_each_tdp_mmu_root_yield_safe(kvm, root)
+	for_each_tdp_mmu_root_yield_safe(kvm, root) {
+		if (kvm_mmu_page_as_id(root) != as_id)
+			continue;
 		flush = zap_gfn_range(kvm, root, start, end, can_yield, flush);
+	}
 
 	return flush;
 }
@@ -724,9 +721,12 @@ bool __kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, gfn_t start, gfn_t end,
 void kvm_tdp_mmu_zap_all(struct kvm *kvm)
 {
 	gfn_t max_gfn = 1ULL << (shadow_phys_bits - PAGE_SHIFT);
-	bool flush;
+	bool flush = false;
+	int i;
+
+	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++)
+		flush = kvm_tdp_mmu_zap_gfn_range(kvm, i, 0, max_gfn, flush);
 
-	flush = kvm_tdp_mmu_zap_gfn_range(kvm, 0, max_gfn);
 	if (flush)
 		kvm_flush_remote_tlbs(kvm);
 }
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 9ecd8f79f861..f224df334382 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -8,12 +8,12 @@
 hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu);
 void kvm_tdp_mmu_free_root(struct kvm *kvm, struct kvm_mmu_page *root);
 
-bool __kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, gfn_t start, gfn_t end,
-				 bool can_yield);
-static inline bool kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, gfn_t start,
-					     gfn_t end)
+bool __kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, int as_id, gfn_t start,
+				 gfn_t end, bool can_yield, bool flush);
+static inline bool kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, int as_id,
+					     gfn_t start, gfn_t end, bool flush)
 {
-	return __kvm_tdp_mmu_zap_gfn_range(kvm, start, end, true);
+	return __kvm_tdp_mmu_zap_gfn_range(kvm, as_id, start, end, true, flush);
 }
 static inline bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
@@ -28,7 +28,8 @@ static inline bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
 	 * requirement), its "step sideways" will always step beyond the bounds
 	 * of the shadow page's gfn range and stop iterating before yielding.
 	 */
-	return __kvm_tdp_mmu_zap_gfn_range(kvm, sp->gfn, end, false);
+	return __kvm_tdp_mmu_zap_gfn_range(kvm, kvm_mmu_page_as_id(sp),
+					   sp->gfn, end, false, false);
 }
 void kvm_tdp_mmu_zap_all(struct kvm *kvm);
 
-- 
2.31.0.291.g576ba9dcdaf-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
