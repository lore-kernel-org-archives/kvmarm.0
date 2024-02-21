Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9EA43E46D
	for <kvmarm@lists.linux.dev>; Wed, 21 Feb 2024 07:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708500395; cv=none; b=kBIAhQ2T6f1ZS1yW8v1EWrhwGOfN/lL7X4TGourhK5Sz7L7OSFj+xav1Bo8NAWEKXxz3k8FQmqwTfkSC0LipYGWmkhAf0+qk2lQni+8MfDTgYODqUGnJl51mJI/XYoMv7hHcRowr9Yf53k/2194Uxj3pk0N0Y35HDapndLEUIrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708500395; c=relaxed/simple;
	bh=AYMUk1nvkZ0pOB+n2DH+4BB79ShWznzgSUYd6B9JA90=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VVYcLpY9ytQOM3go8kz04Bc7WFKufeIaajtLrxzfTXQAAT1j3NFUYm02nMG8SKaAsar93Bw2YlTkMtoTwdlyRN+r1gtDV+rbMNuIXzitdBEfXVZdjkqUaEfILSUCZ6mBNID9mo2zWa3z3TMeXByXjRECej/JPrDF8qwFKrMHgG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=M8XvDeZt; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="M8XvDeZt"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-6e46e07ff07so1812283b3a.3
        for <kvmarm@lists.linux.dev>; Tue, 20 Feb 2024 23:26:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1708500393; x=1709105193; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xgeyG0UvxcnYtwi28aLl5IuMoT6toXx2G8RTHGphwOY=;
        b=M8XvDeZtMpnJSfFF2o9HS4JFhW0hOTuM+IceLXXE8ihC84r1hireevZJ5iinanwB7M
         aDlPAOIG09Uwe8mmbPXr5PGkLgw8RJtrXzXxfUQrMfrtS1PLd6yfaGYnjqCqfJ8vj79c
         3jqKlqoCWdRRkTe99ru9W2JoSiR7RhbaoODLc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708500393; x=1709105193;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xgeyG0UvxcnYtwi28aLl5IuMoT6toXx2G8RTHGphwOY=;
        b=ctPuOGazS/SgeniJ7j9wa7OWd1wowFUs2zgqPlXhlOTOUMHUWauefwl0Ra7P2txR30
         TpR8chZXag3ACRRYnjIbs4fS3keuiw6gopTgfes5OlP53PK+6Zq68id1iGEg1BL1OGSV
         RqFaltEVbD829fsMB2sDm7BVyFqEyJiU+NNG3RrYq8P2YYZfWAG4uJ95xKOwnrw5WqXJ
         iwzMMHnCBwmi+UJ8nn2K3+B1un5Z5PjunFufbV+4L5BeFkYhYA5EY8u0V7KS5h+tv4VE
         XWuzHWC68j/nu+4U/FyIjdpVf+jA5BCxxAVsrBB3mGj3vC2oJkCMn/TRwbJnbqn1haPx
         ke6w==
X-Forwarded-Encrypted: i=1; AJvYcCWR4Ngg+CStJzLXxfi+FzxM9hgn24VddqbiZeVLxxhw7Oy1WNVL79AOimf69GDlVQQMPRbZ0OrCgNCgIaHkTlpMjZ3XL5sW
X-Gm-Message-State: AOJu0YyZUrDWZfIXA4gT7o1U9EGTTjwL3aq5eH2ZRffhblgkLEk6LVmG
	bxYiRMGo3+hQU1lPRSPkOffn5r+/WWMNV0hO8zTErr96++eanjStHwZiZwcFjgFEKDoLdSyhAyk
	=
X-Google-Smtp-Source: AGHT+IGuCxXShC3TFTeo1X9CXGBptbturF8sPZMd5jwJbvXk6SCalhFEJjwEJN/EjoqrumaAkEOtBA==
X-Received: by 2002:a05:6a00:1c8a:b0:6e4:69ac:4c94 with SMTP id y10-20020a056a001c8a00b006e469ac4c94mr7174801pfw.34.1708500393070;
        Tue, 20 Feb 2024 23:26:33 -0800 (PST)
Received: from localhost ([2401:fa00:8f:203:b417:5d09:c226:a19c])
        by smtp.gmail.com with UTF8SMTPSA id v13-20020a62a50d000000b006e45a0feffasm6019256pfm.71.2024.02.20.23.26.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Feb 2024 23:26:32 -0800 (PST)
From: David Stevens <stevensd@chromium.org>
X-Google-Original-From: David Stevens <stevensd@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Yu Zhang <yu.c.zhang@linux.intel.com>,
	Isaku Yamahata <isaku.yamahata@gmail.com>,
	Zhi Wang <zhi.wang.linux@gmail.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	David Stevens <stevensd@chromium.org>
Subject: [PATCH v10 7/8] KVM: x86/mmu: Track if sptes refer to refcounted pages
Date: Wed, 21 Feb 2024 16:25:27 +0900
Message-ID: <20240221072528.2702048-10-stevensd@google.com>
X-Mailer: git-send-email 2.44.0.rc0.258.g7320e95886-goog
In-Reply-To: <20240221072528.2702048-1-stevensd@google.com>
References: <20240221072528.2702048-1-stevensd@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Stevens <stevensd@chromium.org>

Use one of the unused bits in EPT sptes to track whether or not an spte
refers to a struct page that has a valid refcount, in preparation for
adding support for mapping such pages into guests. The new bit is used
to avoid triggering a page_count() == 0 warning and to avoid touching
A/D bits of unknown usage.

Non-EPT sptes don't have any free bits to use, so this tracking is not
possible when TDP is disabled or on 32-bit x86.

Signed-off-by: David Stevens <stevensd@chromium.org>
---
 arch/x86/kvm/mmu/mmu.c         | 43 +++++++++++++++++++---------------
 arch/x86/kvm/mmu/paging_tmpl.h |  5 ++--
 arch/x86/kvm/mmu/spte.c        |  4 +++-
 arch/x86/kvm/mmu/spte.h        | 22 ++++++++++++++++-
 arch/x86/kvm/mmu/tdp_mmu.c     | 21 ++++++++++-------
 include/linux/kvm_host.h       |  3 +++
 virt/kvm/kvm_main.c            |  6 +++--
 7 files changed, 70 insertions(+), 34 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index bbeb0f6783d7..7c059b23ae16 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -541,12 +541,14 @@ static bool mmu_spte_update(u64 *sptep, u64 new_spte)
 
 	if (is_accessed_spte(old_spte) && !is_accessed_spte(new_spte)) {
 		flush = true;
-		kvm_set_pfn_accessed(spte_to_pfn(old_spte));
+		if (is_refcounted_page_spte(old_spte))
+			kvm_set_page_accessed(pfn_to_page(spte_to_pfn(old_spte)));
 	}
 
 	if (is_dirty_spte(old_spte) && !is_dirty_spte(new_spte)) {
 		flush = true;
-		kvm_set_pfn_dirty(spte_to_pfn(old_spte));
+		if (is_refcounted_page_spte(old_spte))
+			kvm_set_page_dirty(pfn_to_page(spte_to_pfn(old_spte)));
 	}
 
 	return flush;
@@ -578,20 +580,23 @@ static u64 mmu_spte_clear_track_bits(struct kvm *kvm, u64 *sptep)
 
 	pfn = spte_to_pfn(old_spte);
 
-	/*
-	 * KVM doesn't hold a reference to any pages mapped into the guest, and
-	 * instead uses the mmu_notifier to ensure that KVM unmaps any pages
-	 * before they are reclaimed.  Sanity check that, if the pfn is backed
-	 * by a refcounted page, the refcount is elevated.
-	 */
-	page = kvm_pfn_to_refcounted_page(pfn);
-	WARN_ON_ONCE(page && !page_count(page));
+	if (is_refcounted_page_spte(old_spte)) {
+		/*
+		 * KVM doesn't hold a reference to any pages mapped into the
+		 * guest, and instead uses the mmu_notifier to ensure that KVM
+		 * unmaps any pages before they are reclaimed. Sanity check
+		 * that, if the pfn is backed by a refcounted page, the
+		 * refcount is elevated.
+		 */
+		page = kvm_pfn_to_refcounted_page(pfn);
+		WARN_ON_ONCE(!page || !page_count(page));
 
-	if (is_accessed_spte(old_spte))
-		kvm_set_pfn_accessed(pfn);
+		if (is_accessed_spte(old_spte))
+			kvm_set_page_accessed(pfn_to_page(pfn));
 
-	if (is_dirty_spte(old_spte))
-		kvm_set_pfn_dirty(pfn);
+		if (is_dirty_spte(old_spte))
+			kvm_set_page_dirty(pfn_to_page(pfn));
+	}
 
 	return old_spte;
 }
@@ -627,8 +632,8 @@ static bool mmu_spte_age(u64 *sptep)
 		 * Capture the dirty status of the page, so that it doesn't get
 		 * lost when the SPTE is marked for access tracking.
 		 */
-		if (is_writable_pte(spte))
-			kvm_set_pfn_dirty(spte_to_pfn(spte));
+		if (is_writable_pte(spte) && is_refcounted_page_spte(spte))
+			kvm_set_page_dirty(pfn_to_page(spte_to_pfn(spte)));
 
 		spte = mark_spte_for_access_track(spte);
 		mmu_spte_update_no_track(sptep, spte);
@@ -1267,8 +1272,8 @@ static bool spte_wrprot_for_clear_dirty(u64 *sptep)
 {
 	bool was_writable = test_and_clear_bit(PT_WRITABLE_SHIFT,
 					       (unsigned long *)sptep);
-	if (was_writable && !spte_ad_enabled(*sptep))
-		kvm_set_pfn_dirty(spte_to_pfn(*sptep));
+	if (was_writable && !spte_ad_enabled(*sptep) && is_refcounted_page_spte(*sptep))
+		kvm_set_page_dirty(pfn_to_page(spte_to_pfn(*sptep)));
 
 	return was_writable;
 }
@@ -2946,7 +2951,7 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
 	}
 
 	wrprot = make_spte(vcpu, sp, slot, pte_access, gfn, pfn, *sptep, prefetch,
-			   true, host_writable, &spte);
+			   true, host_writable, true, &spte);
 
 	if (*sptep == spte) {
 		ret = RET_PF_SPURIOUS;
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 4d4e98fe4f35..c965f77ac4d5 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -902,7 +902,7 @@ static gpa_t FNAME(gva_to_gpa)(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
  */
 static int FNAME(sync_spte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp, int i)
 {
-	bool host_writable;
+	bool host_writable, is_refcounted;
 	gpa_t first_pte_gpa;
 	u64 *sptep, spte;
 	struct kvm_memory_slot *slot;
@@ -959,10 +959,11 @@ static int FNAME(sync_spte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp, int
 	sptep = &sp->spt[i];
 	spte = *sptep;
 	host_writable = spte & shadow_host_writable_mask;
+	is_refcounted = is_refcounted_page_spte(spte);
 	slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
 	make_spte(vcpu, sp, slot, pte_access, gfn,
 		  spte_to_pfn(spte), spte, true, false,
-		  host_writable, &spte);
+		  host_writable, is_refcounted, &spte);
 
 	return mmu_spte_update(sptep, spte);
 }
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 4a599130e9c9..efba85df6518 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -138,7 +138,7 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	       const struct kvm_memory_slot *slot,
 	       unsigned int pte_access, gfn_t gfn, kvm_pfn_t pfn,
 	       u64 old_spte, bool prefetch, bool can_unsync,
-	       bool host_writable, u64 *new_spte)
+	       bool host_writable, bool is_refcounted, u64 *new_spte)
 {
 	int level = sp->role.level;
 	u64 spte = SPTE_MMU_PRESENT_MASK;
@@ -188,6 +188,8 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 
 	if (level > PG_LEVEL_4K)
 		spte |= PT_PAGE_SIZE_MASK;
+	if (spte_has_refcount_bit() && is_refcounted)
+		spte |= SPTE_MMU_PAGE_REFCOUNTED;
 
 	if (shadow_memtype_mask)
 		spte |= static_call(kvm_x86_get_mt_mask)(vcpu, gfn,
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index a129951c9a88..4101cc9ef52f 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -96,6 +96,11 @@ static_assert(!(EPT_SPTE_MMU_WRITABLE & SHADOW_ACC_TRACK_SAVED_MASK));
 /* Defined only to keep the above static asserts readable. */
 #undef SHADOW_ACC_TRACK_SAVED_MASK
 
+/*
+ * Indicates that the SPTE refers to a page with a valid refcount.
+ */
+#define SPTE_MMU_PAGE_REFCOUNTED        BIT_ULL(59)
+
 /*
  * Due to limited space in PTEs, the MMIO generation is a 19 bit subset of
  * the memslots generation and is derived as follows:
@@ -345,6 +350,21 @@ static inline bool is_dirty_spte(u64 spte)
 	return dirty_mask ? spte & dirty_mask : spte & PT_WRITABLE_MASK;
 }
 
+/*
+ * Extra bits are only available for TDP SPTEs, since bits 62:52 are reserved
+ * for PAE paging, including NPT PAE. When a tracking bit isn't available, we
+ * will reject mapping non-refcounted struct pages.
+ */
+static inline bool spte_has_refcount_bit(void)
+{
+	return tdp_enabled && IS_ENABLED(CONFIG_X86_64);
+}
+
+static inline bool is_refcounted_page_spte(u64 spte)
+{
+	return !spte_has_refcount_bit() || (spte & SPTE_MMU_PAGE_REFCOUNTED);
+}
+
 static inline u64 get_rsvd_bits(struct rsvd_bits_validate *rsvd_check, u64 pte,
 				int level)
 {
@@ -475,7 +495,7 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	       const struct kvm_memory_slot *slot,
 	       unsigned int pte_access, gfn_t gfn, kvm_pfn_t pfn,
 	       u64 old_spte, bool prefetch, bool can_unsync,
-	       bool host_writable, u64 *new_spte);
+	       bool host_writable, bool is_refcounted, u64 *new_spte);
 u64 make_huge_page_split_spte(struct kvm *kvm, u64 huge_spte,
 		      	      union kvm_mmu_page_role role, int index);
 u64 make_nonleaf_spte(u64 *child_pt, bool ad_disabled);
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 6ae19b4ee5b1..ee497fb78d90 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -414,6 +414,7 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 	bool was_leaf = was_present && is_last_spte(old_spte, level);
 	bool is_leaf = is_present && is_last_spte(new_spte, level);
 	bool pfn_changed = spte_to_pfn(old_spte) != spte_to_pfn(new_spte);
+	bool is_refcounted = is_refcounted_page_spte(old_spte);
 
 	WARN_ON_ONCE(level > PT64_ROOT_MAX_LEVEL);
 	WARN_ON_ONCE(level < PG_LEVEL_4K);
@@ -478,9 +479,9 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 	if (is_leaf != was_leaf)
 		kvm_update_page_stats(kvm, level, is_leaf ? 1 : -1);
 
-	if (was_leaf && is_dirty_spte(old_spte) &&
+	if (was_leaf && is_dirty_spte(old_spte) && is_refcounted &&
 	    (!is_present || !is_dirty_spte(new_spte) || pfn_changed))
-		kvm_set_pfn_dirty(spte_to_pfn(old_spte));
+		kvm_set_page_dirty(pfn_to_page(spte_to_pfn(old_spte)));
 
 	/*
 	 * Recursively handle child PTs if the change removed a subtree from
@@ -492,9 +493,9 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 	    (is_leaf || !is_present || WARN_ON_ONCE(pfn_changed)))
 		handle_removed_pt(kvm, spte_to_child_pt(old_spte, level), shared);
 
-	if (was_leaf && is_accessed_spte(old_spte) &&
+	if (was_leaf && is_accessed_spte(old_spte) && is_refcounted &&
 	    (!is_present || !is_accessed_spte(new_spte) || pfn_changed))
-		kvm_set_pfn_accessed(spte_to_pfn(old_spte));
+		kvm_set_page_accessed(pfn_to_page(spte_to_pfn(old_spte)));
 }
 
 /*
@@ -956,8 +957,8 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
 		new_spte = make_mmio_spte(vcpu, iter->gfn, ACC_ALL);
 	else
 		wrprot = make_spte(vcpu, sp, fault->slot, ACC_ALL, iter->gfn,
-					 fault->pfn, iter->old_spte, fault->prefetch, true,
-					 fault->map_writable, &new_spte);
+				   fault->pfn, iter->old_spte, fault->prefetch, true,
+				   fault->map_writable, true, &new_spte);
 
 	if (new_spte == iter->old_spte)
 		ret = RET_PF_SPURIOUS;
@@ -1178,8 +1179,9 @@ static bool age_gfn_range(struct kvm *kvm, struct tdp_iter *iter,
 		 * Capture the dirty status of the page, so that it doesn't get
 		 * lost when the SPTE is marked for access tracking.
 		 */
-		if (is_writable_pte(iter->old_spte))
-			kvm_set_pfn_dirty(spte_to_pfn(iter->old_spte));
+		if (is_writable_pte(iter->old_spte) &&
+		    is_refcounted_page_spte(iter->old_spte))
+			kvm_set_page_dirty(pfn_to_page(spte_to_pfn(iter->old_spte)));
 
 		new_spte = mark_spte_for_access_track(iter->old_spte);
 		iter->old_spte = kvm_tdp_mmu_write_spte(iter->sptep,
@@ -1602,7 +1604,8 @@ static void clear_dirty_pt_masked(struct kvm *kvm, struct kvm_mmu_page *root,
 		trace_kvm_tdp_mmu_spte_changed(iter.as_id, iter.gfn, iter.level,
 					       iter.old_spte,
 					       iter.old_spte & ~dbit);
-		kvm_set_pfn_dirty(spte_to_pfn(iter.old_spte));
+		if (is_refcounted_page_spte(iter.old_spte))
+			kvm_set_page_dirty(pfn_to_page(spte_to_pfn(iter.old_spte)));
 	}
 
 	rcu_read_unlock();
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index f72c79f159a2..cff5df6b0c52 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1211,6 +1211,9 @@ unsigned long gfn_to_hva_memslot_prot(struct kvm_memory_slot *slot, gfn_t gfn,
 void kvm_release_page_clean(struct page *page);
 void kvm_release_page_dirty(struct page *page);
 
+void kvm_set_page_accessed(struct page *page);
+void kvm_set_page_dirty(struct page *page);
+
 struct kvm_follow_pfn {
 	const struct kvm_memory_slot *slot;
 	gfn_t gfn;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 5d66d841e775..e53a14adf149 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3281,17 +3281,19 @@ static bool kvm_is_ad_tracked_page(struct page *page)
 	return !PageReserved(page);
 }
 
-static void kvm_set_page_dirty(struct page *page)
+void kvm_set_page_dirty(struct page *page)
 {
 	if (kvm_is_ad_tracked_page(page))
 		SetPageDirty(page);
 }
+EXPORT_SYMBOL_GPL(kvm_set_page_dirty);
 
-static void kvm_set_page_accessed(struct page *page)
+void kvm_set_page_accessed(struct page *page)
 {
 	if (kvm_is_ad_tracked_page(page))
 		mark_page_accessed(page);
 }
+EXPORT_SYMBOL_GPL(kvm_set_page_accessed);
 
 void kvm_release_page_clean(struct page *page)
 {
-- 
2.44.0.rc0.258.g7320e95886-goog

