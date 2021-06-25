Return-Path: <SRS0=mXZs=LT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 692ACC49EB9
	for <kvmarm@archiver.kernel.org>; Fri, 25 Jun 2021 10:11:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1C56561437
	for <kvmarm@archiver.kernel.org>; Fri, 25 Jun 2021 10:11:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1C56561437
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7DD2A4B144;
	Fri, 25 Jun 2021 06:11:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@chromium.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rn5uRrUqcvp8; Fri, 25 Jun 2021 06:11:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 699414B1AB;
	Fri, 25 Jun 2021 06:11:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 915B64B162
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Jun 2021 03:37:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 10Jr7+y7n0A9 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 25 Jun 2021 03:37:38 -0400 (EDT)
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com
 [209.85.214.174])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 148E74B14D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Jun 2021 03:37:38 -0400 (EDT)
Received: by mail-pl1-f174.google.com with SMTP id h1so4304868plt.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Jun 2021 00:37:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chromium.org; s=google;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=QKJBsVMhO/c8x/QJ2YicFcm13QERHw4iNUX2fp9JB6U=;
 b=V3TR8715BNVqtFn4F1WGtuVoW01H4ri7xKq71i8t4rFpfyZ8dDJtHt1HeMri6IlxnK
 J1uSTODyFoTeoNMweDwu4Jyqs4UnmGiGQLR8tkZQ/10/nQurbFovfK3CMuo1+ETzm+oO
 f6x4DiftQXOJv1yYbahTM6GkVF3OGel/sjA9w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=QKJBsVMhO/c8x/QJ2YicFcm13QERHw4iNUX2fp9JB6U=;
 b=nN5lFzmyjW9k6F4ySYZ+NOCg7de2L5PnfLaApZmm6GcMO+Icm+zi/KS3IIdrwHn3mI
 iZWQd+pa5qKFx/e8NM81e5Yt1ywDCHAfTJfGFmYbdQeGZ89Y7gyYToZr9DCNysSzHym3
 QaEXuqPvP+rveceari1Hw928jPUgu4kTuJ4GJwyGvMBmwLZ2rLk1SseaPI2Iwd0gltlo
 zFkC6RFe3Z6MTMWqtBVwjbhVFuIDl1ecx+PKp8fRiW88nIsBAzyI7ER2fnrgBW/iVNDt
 VDzynW8WXP3Wgl2ggJgl9q8R7IOfj/L/BZ2CdNCQTlcxvLaaaGrzVEBJBC9HcnIrKKOt
 XuXw==
X-Gm-Message-State: AOAM531xAgPcJlbj4h3LLZ8JmYnqM5LAKSoG5gRh71TwxqVznbD0ylJc
 FpWonIDm9lkTD1K0jF6ZS/BvSw==
X-Google-Smtp-Source: ABdhPJwPyhoQmRD69YemrujRsqthuRR7FEcPQlV7KWoQXinWfASl9bYRd9sm8JFk9b6+Z2BOsrDrIg==
X-Received: by 2002:a17:90b:46c3:: with SMTP id
 jx3mr9718656pjb.206.1624606657339; 
 Fri, 25 Jun 2021 00:37:37 -0700 (PDT)
Received: from localhost ([2401:fa00:8f:203:1492:9d4f:19fa:df61])
 by smtp.gmail.com with UTF8SMTPSA id c20sm4941588pfp.203.2021.06.25.00.37.32
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 25 Jun 2021 00:37:37 -0700 (PDT)
From: David Stevens <stevensd@chromium.org>
X-Google-Original-From: David Stevens <stevensd@google.com>
To: Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Paul Mackerras <paulus@ozlabs.org>, Paolo Bonzini <pbonzini@redhat.com>,
 Nick Piggin <npiggin@gmail.com>
Subject: [PATCH v2 3/5] KVM: x86/mmu: use gfn_to_pfn_page
Date: Fri, 25 Jun 2021 16:36:14 +0900
Message-Id: <20210625073616.2184426-4-stevensd@google.com>
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
In-Reply-To: <20210625073616.2184426-1-stevensd@google.com>
References: <20210625073616.2184426-1-stevensd@google.com>
MIME-Version: 1.0
X-Mailman-Approved-At: Fri, 25 Jun 2021 06:11:50 -0400
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linux-mips@vger.kernel.org,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 Joerg Roedel <joro@8bytes.org>, Zhi Wang <zhi.a.wang@intel.com>,
 intel-gfx@lists.freedesktop.org, kvm-ppc@vger.kernel.org,
 Zhenyu Wang <zhenyuw@linux.intel.com>, intel-gvt-dev@lists.freedesktop.org,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 Sean Christopherson <seanjc@google.com>, linux-kernel@vger.kernel.org,
 David Stevens <stevensd@chromium.org>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 linuxppc-dev@lists.ozlabs.org
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

Covert usages of the deprecated gfn_to_pfn functions to the new
gfn_to_pfn_page functions.

Signed-off-by: David Stevens <stevensd@chromium.org>
---
 arch/x86/kvm/mmu/mmu.c          | 43 ++++++++++++++++++++-------------
 arch/x86/kvm/mmu/mmu_internal.h |  3 ++-
 arch/x86/kvm/mmu/paging_tmpl.h  | 23 +++++++++++-------
 arch/x86/kvm/mmu/tdp_mmu.c      |  6 ++---
 arch/x86/kvm/mmu/tdp_mmu.h      |  4 +--
 arch/x86/kvm/x86.c              |  6 +++--
 6 files changed, 51 insertions(+), 34 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 00732757cc60..dd5cb6e33591 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2702,8 +2702,9 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 	return ret;
 }
 
-static kvm_pfn_t pte_prefetch_gfn_to_pfn(struct kvm_vcpu *vcpu, gfn_t gfn,
-				     bool no_dirty_log)
+static kvm_pfn_t pte_prefetch_gfn_to_pfn_page(struct kvm_vcpu *vcpu,
+					      gfn_t gfn, bool no_dirty_log,
+					      struct page **page)
 {
 	struct kvm_memory_slot *slot;
 
@@ -2711,7 +2712,7 @@ static kvm_pfn_t pte_prefetch_gfn_to_pfn(struct kvm_vcpu *vcpu, gfn_t gfn,
 	if (!slot)
 		return KVM_PFN_ERR_FAULT;
 
-	return gfn_to_pfn_memslot_atomic(slot, gfn);
+	return gfn_to_pfn_page_memslot_atomic(slot, gfn, page);
 }
 
 static int direct_pte_prefetch_many(struct kvm_vcpu *vcpu,
@@ -2840,7 +2841,8 @@ int kvm_mmu_max_mapping_level(struct kvm *kvm,
 
 int kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, gfn_t gfn,
 			    int max_level, kvm_pfn_t *pfnp,
-			    bool huge_page_disallowed, int *req_level)
+			    struct page *page, bool huge_page_disallowed,
+			    int *req_level)
 {
 	struct kvm_memory_slot *slot;
 	kvm_pfn_t pfn = *pfnp;
@@ -2852,6 +2854,9 @@ int kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, gfn_t gfn,
 	if (unlikely(max_level == PG_LEVEL_4K))
 		return PG_LEVEL_4K;
 
+	if (!page)
+		return PG_LEVEL_4K;
+
 	if (is_error_noslot_pfn(pfn) || kvm_is_reserved_pfn(pfn))
 		return PG_LEVEL_4K;
 
@@ -2906,7 +2911,8 @@ void disallowed_hugepage_adjust(u64 spte, gfn_t gfn, int cur_level,
 }
 
 static int __direct_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
-			int map_writable, int max_level, kvm_pfn_t pfn,
+			int map_writable, int max_level,
+			kvm_pfn_t pfn, struct page *page,
 			bool prefault, bool is_tdp)
 {
 	bool nx_huge_page_workaround_enabled = is_nx_huge_page_enabled();
@@ -2919,7 +2925,7 @@ static int __direct_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 	gfn_t gfn = gpa >> PAGE_SHIFT;
 	gfn_t base_gfn = gfn;
 
-	level = kvm_mmu_hugepage_adjust(vcpu, gfn, max_level, &pfn,
+	level = kvm_mmu_hugepage_adjust(vcpu, gfn, max_level, &pfn, page,
 					huge_page_disallowed, &req_level);
 
 	trace_kvm_mmu_spte_requested(gpa, level, pfn);
@@ -3768,8 +3774,9 @@ static bool kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 }
 
 static bool try_async_pf(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
-			 gpa_t cr2_or_gpa, kvm_pfn_t *pfn, hva_t *hva,
-			 bool write, bool *writable)
+			 gpa_t cr2_or_gpa, kvm_pfn_t *pfn,
+			 hva_t *hva, bool write, bool *writable,
+			 struct page **page)
 {
 	struct kvm_memory_slot *slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
 	bool async;
@@ -3790,8 +3797,8 @@ static bool try_async_pf(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
 	}
 
 	async = false;
-	*pfn = __gfn_to_pfn_memslot(slot, gfn, false, &async,
-				    write, writable, hva);
+	*pfn = __gfn_to_pfn_page_memslot(slot, gfn, false, &async,
+					 write, writable, hva, page);
 	if (!async)
 		return false; /* *pfn has correct page already */
 
@@ -3805,8 +3812,8 @@ static bool try_async_pf(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
 			return true;
 	}
 
-	*pfn = __gfn_to_pfn_memslot(slot, gfn, false, NULL,
-				    write, writable, hva);
+	*pfn = __gfn_to_pfn_page_memslot(slot, gfn, false, NULL,
+					 write, writable, hva, page);
 	return false;
 }
 
@@ -3820,6 +3827,7 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 	gfn_t gfn = gpa >> PAGE_SHIFT;
 	unsigned long mmu_seq;
 	kvm_pfn_t pfn;
+	struct page *page;
 	hva_t hva;
 	int r;
 
@@ -3840,7 +3848,7 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 	smp_rmb();
 
 	if (try_async_pf(vcpu, prefault, gfn, gpa, &pfn, &hva,
-			 write, &map_writable))
+			 write, &map_writable, &page))
 		return RET_PF_RETRY;
 
 	if (handle_abnormal_pfn(vcpu, is_tdp ? 0 : gpa, gfn, pfn, ACC_ALL, &r))
@@ -3861,17 +3869,18 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 
 	if (is_tdp_mmu_fault)
 		r = kvm_tdp_mmu_map(vcpu, gpa, error_code, map_writable, max_level,
-				    pfn, prefault);
+				    pfn, page, prefault);
 	else
-		r = __direct_map(vcpu, gpa, error_code, map_writable, max_level, pfn,
-				 prefault, is_tdp);
+		r = __direct_map(vcpu, gpa, error_code, map_writable, max_level,
+				 pfn, page, prefault, is_tdp);
 
 out_unlock:
 	if (is_tdp_mmu_fault)
 		read_unlock(&vcpu->kvm->mmu_lock);
 	else
 		write_unlock(&vcpu->kvm->mmu_lock);
-	kvm_release_pfn_clean(pfn);
+	if (page)
+		put_page(page);
 	return r;
 }
 
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 35567293c1fd..cc02fe22b450 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -159,7 +159,8 @@ int kvm_mmu_max_mapping_level(struct kvm *kvm,
 			      kvm_pfn_t pfn, int max_level);
 int kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, gfn_t gfn,
 			    int max_level, kvm_pfn_t *pfnp,
-			    bool huge_page_disallowed, int *req_level);
+			    struct page *page, bool huge_page_disallowed,
+			    int *req_level);
 void disallowed_hugepage_adjust(u64 spte, gfn_t gfn, int cur_level,
 				kvm_pfn_t *pfnp, int *goal_levelp);
 
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 490a028ddabe..f1ebb1ee7f0f 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -564,6 +564,7 @@ FNAME(prefetch_gpte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	unsigned pte_access;
 	gfn_t gfn;
 	kvm_pfn_t pfn;
+	struct page *page;
 
 	if (FNAME(prefetch_invalid_gpte)(vcpu, sp, spte, gpte))
 		return false;
@@ -573,8 +574,8 @@ FNAME(prefetch_gpte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	gfn = gpte_to_gfn(gpte);
 	pte_access = sp->role.access & FNAME(gpte_access)(gpte);
 	FNAME(protect_clean_gpte)(vcpu->arch.mmu, &pte_access, gpte);
-	pfn = pte_prefetch_gfn_to_pfn(vcpu, gfn,
-			no_dirty_log && (pte_access & ACC_WRITE_MASK));
+	pfn = pte_prefetch_gfn_to_pfn_page(vcpu, gfn,
+			no_dirty_log && (pte_access & ACC_WRITE_MASK), &page);
 	if (is_error_pfn(pfn))
 		return false;
 
@@ -585,7 +586,8 @@ FNAME(prefetch_gpte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	mmu_set_spte(vcpu, spte, pte_access, false, PG_LEVEL_4K, gfn, pfn,
 		     true, true);
 
-	kvm_release_pfn_clean(pfn);
+	if (page)
+		put_page(page);
 	return true;
 }
 
@@ -665,8 +667,8 @@ static void FNAME(pte_prefetch)(struct kvm_vcpu *vcpu, struct guest_walker *gw,
  */
 static int FNAME(fetch)(struct kvm_vcpu *vcpu, gpa_t addr,
 			 struct guest_walker *gw, u32 error_code,
-			 int max_level, kvm_pfn_t pfn, bool map_writable,
-			 bool prefault)
+			 int max_level, kvm_pfn_t pfn, struct page *page,
+			 bool map_writable, bool prefault)
 {
 	bool nx_huge_page_workaround_enabled = is_nx_huge_page_enabled();
 	bool write_fault = error_code & PFERR_WRITE_MASK;
@@ -723,7 +725,8 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, gpa_t addr,
 	}
 
 	level = kvm_mmu_hugepage_adjust(vcpu, gw->gfn, max_level, &pfn,
-					huge_page_disallowed, &req_level);
+					page, huge_page_disallowed,
+					&req_level);
 
 	trace_kvm_mmu_spte_requested(addr, gw->level, pfn);
 
@@ -830,6 +833,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gpa_t addr, u32 error_code,
 	struct guest_walker walker;
 	int r;
 	kvm_pfn_t pfn;
+	struct page *page;
 	hva_t hva;
 	unsigned long mmu_seq;
 	bool map_writable, is_self_change_mapping;
@@ -882,7 +886,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gpa_t addr, u32 error_code,
 	smp_rmb();
 
 	if (try_async_pf(vcpu, prefault, walker.gfn, addr, &pfn, &hva,
-			 write_fault, &map_writable))
+			 write_fault, &map_writable, &page))
 		return RET_PF_RETRY;
 
 	if (handle_abnormal_pfn(vcpu, addr, walker.gfn, pfn, walker.pte_access, &r))
@@ -916,13 +920,14 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gpa_t addr, u32 error_code,
 	r = make_mmu_pages_available(vcpu);
 	if (r)
 		goto out_unlock;
-	r = FNAME(fetch)(vcpu, addr, &walker, error_code, max_level, pfn,
+	r = FNAME(fetch)(vcpu, addr, &walker, error_code, max_level, pfn, page,
 			 map_writable, prefault);
 	kvm_mmu_audit(vcpu, AUDIT_POST_PAGE_FAULT);
 
 out_unlock:
 	write_unlock(&vcpu->kvm->mmu_lock);
-	kvm_release_pfn_clean(pfn);
+	if (page)
+		put_page(page);
 	return r;
 }
 
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index caac4ddb46df..10572af6fe91 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -966,8 +966,8 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu, int write,
  * page tables and SPTEs to translate the faulting guest physical address.
  */
 int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
-		    int map_writable, int max_level, kvm_pfn_t pfn,
-		    bool prefault)
+		    int map_writable, int max_level,
+		    kvm_pfn_t pfn, struct page *page, bool prefault)
 {
 	bool nx_huge_page_workaround_enabled = is_nx_huge_page_enabled();
 	bool write = error_code & PFERR_WRITE_MASK;
@@ -983,7 +983,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 	int level;
 	int req_level;
 
-	level = kvm_mmu_hugepage_adjust(vcpu, gfn, max_level, &pfn,
+	level = kvm_mmu_hugepage_adjust(vcpu, gfn, max_level, &pfn, page,
 					huge_page_disallowed, &req_level);
 
 	trace_kvm_mmu_spte_requested(gpa, level, pfn);
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 1cae4485b3bc..3afaf73adfe7 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -52,8 +52,8 @@ void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm);
 void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm);
 
 int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
-		    int map_writable, int max_level, kvm_pfn_t pfn,
-		    bool prefault);
+		    int map_writable, int max_level,
+		    kvm_pfn_t pfn, struct page *page, bool prefault);
 
 bool kvm_tdp_mmu_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range,
 				 bool flush);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 17468d983fbd..1a21b6702de5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7511,6 +7511,7 @@ static bool reexecute_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 {
 	gpa_t gpa = cr2_or_gpa;
 	kvm_pfn_t pfn;
+	struct page *page;
 
 	if (!(emulation_type & EMULTYPE_ALLOW_RETRY_PF))
 		return false;
@@ -7540,7 +7541,7 @@ static bool reexecute_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	 * retry instruction -> write #PF -> emulation fail -> retry
 	 * instruction -> ...
 	 */
-	pfn = gfn_to_pfn(vcpu->kvm, gpa_to_gfn(gpa));
+	pfn = gfn_to_pfn_page(vcpu->kvm, gpa_to_gfn(gpa), &page);
 
 	/*
 	 * If the instruction failed on the error pfn, it can not be fixed,
@@ -7549,7 +7550,8 @@ static bool reexecute_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	if (is_error_noslot_pfn(pfn))
 		return false;
 
-	kvm_release_pfn_clean(pfn);
+	if (page)
+		put_page(page);
 
 	/* The instructions are well-emulated on direct mmu. */
 	if (vcpu->arch.mmu->direct_map) {
-- 
2.32.0.93.g670b81a890-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
