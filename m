Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BABC21C36
	for <kvmarm@lists.linux.dev>; Tue, 11 Jun 2024 00:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718065324; cv=none; b=DPcwOQUMFIS7NXU1Emz+Eeh3nvcoXOo5uUS/zQwUEBT6B/3Vt0g4WPyBNnJW69X2ZPsGtqAoTmEkhddvWtT71kEW1GI0R3ulDG2cScK3wJbn4hCS93ia87SH3yKqcJ8Uz8e0GVdYmeetEbXKBblsEN3Fem5h4uhDYNGMB34rxlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718065324; c=relaxed/simple;
	bh=Ayvle2sdQvoL4hmelnLJbR7QE38GWTbavKP0eLaJ6rg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hMq877Ub1zi8kQ2mHR6WVWHhaxYE1Ztf6FQNwRuDAB38e1T/uKoNvoUTbch8ICtUCieL7vuCrqPsUs3IoqrcnmjFUaixkS9z5yLb1dsc2mjI9GzPzaKz8Q9f7LUwZBLgBC+l+okhtvy6KzcqsI/5oCfi/GhC8PZ+IlLS0tp35tY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FR/e1GjD; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FR/e1GjD"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-62c7a4f8cd6so98370237b3.0
        for <kvmarm@lists.linux.dev>; Mon, 10 Jun 2024 17:22:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718065321; x=1718670121; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QTXlFX0eqK0OJ7LxxCPmXUgKAb6UuiUwA2XsTgSjq+I=;
        b=FR/e1GjDKvEzB3dbb4R0bctAxIhHU0kidJIWHei2O/wmb887VblbaYLCKIGrW3Dpo/
         9tMBAc79rFDXLhKk7nE1L13axuU/GhuYHdd8QaKaYqyVk/u3UNEdLTCOn0uyCSDTdCbr
         h2p8LQJMGqc0sUy2MT2RVrn4xO9VdPSp5h4oNubRmZ5IDh9qscm82/g8LrXemAf93RHS
         xBwAi2oX5u399uwQq96FUNDldPGa88rOtuYgxGui7LdFOphfkcCHveSPpFW6yqL+7Pu8
         k+7ApafVJjMBzwytGaun1crt5k7tvnOg+1sid5OZ4n5WJHldb+Wg8uE+BPZKll0zpxAc
         1n0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718065321; x=1718670121;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QTXlFX0eqK0OJ7LxxCPmXUgKAb6UuiUwA2XsTgSjq+I=;
        b=WCyN6m+lD9eM/4P9+cpvVo/r+a5caPrw2kZHrG9IPD6ODkkpmqjyUTktmjnjk35fAW
         X0aRaKPv5IpLAU6/mUEcw+sZTtKKsw/WPrqVfN0lbzaTFzLCmgUUfHSbDeNuWfdOVO8P
         wxkSv+tgt3kjHebq8eQoY/dI6V4LKc6FIU9rXUaIHKuRxLbboMD7yGynOAH6WTgASlW0
         bm79W5UJasKxulXlQeM825d/K5okSEc4l2mBWDzKxVZUTMr6EFU4wmncom1bBxAPX3v8
         LhgLGVhdOFu06awrC14FUJiM5pYj7Ea5xYiD1IhfgDA9xbBGkd6qbf0yhr6PUOOXDO18
         765w==
X-Forwarded-Encrypted: i=1; AJvYcCVF33aocw32vwMbI3AiHFKv//8QLssw3/rkXPBDpI5VKE/60uWniiDlw5CL/64c65tric+GfkSO2B6pFnYBQsW0MUvzfHjS
X-Gm-Message-State: AOJu0YxF8mHh53CrqqZSgKKe2Jp171U7mHeTwVczNdpNKhIKX8shV34o
	/GfwLoZlkNAshrrL6kWVHyYpa9vg/IAeb/8culFCmMddXUcnwjNg3YHV6AW/dli6oR5//IWW7IN
	qcc+VZaQW/ciMhrjj/g==
X-Google-Smtp-Source: AGHT+IH/lTyMKkfYBTfkyMLpzJLgvdaQf1eZ0iJ8gYjDqr0mKX19Ny4cIhX4/ZVJH2rhH9pB2RhhAEM9xGJV6D5s
X-Received: from jthoughton.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:2a4f])
 (user=jthoughton job=sendgmr) by 2002:a05:690c:f12:b0:62c:ea0b:a44e with SMTP
 id 00721157ae682-62cea0ba712mr29004557b3.2.1718065320553; Mon, 10 Jun 2024
 17:22:00 -0700 (PDT)
Date: Tue, 11 Jun 2024 00:21:38 +0000
In-Reply-To: <20240611002145.2078921-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240611002145.2078921-1-jthoughton@google.com>
X-Mailer: git-send-email 2.45.2.505.gda0bf45e8d-goog
Message-ID: <20240611002145.2078921-3-jthoughton@google.com>
Subject: [PATCH v5 2/9] KVM: x86: Relax locking for kvm_test_age_gfn and kvm_age_gfn
From: James Houghton <jthoughton@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Ankit Agrawal <ankita@nvidia.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, David Matlack <dmatlack@google.com>, 
	David Rientjes <rientjes@google.com>, James Houghton <jthoughton@google.com>, 
	James Morse <james.morse@arm.com>, Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Raghavendra Rao Ananta <rananta@google.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Sean Christopherson <seanjc@google.com>, 
	Shaoqin Huang <shahuang@redhat.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Wei Xu <weixugc@google.com>, Will Deacon <will@kernel.org>, Yu Zhao <yuzhao@google.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"

Walk the TDP MMU in an RCU read-side critical section. This requires a
way to do RCU-safe walking of the tdp_mmu_roots; do this with a new
macro. The PTE modifications are now done atomically, and
kvm_tdp_mmu_spte_need_atomic_write() has been updated to account for the
fact that kvm_age_gfn can now lockless update the accessed bit and the
R/X bits).

If the cmpxchg for marking the spte for access tracking fails, we simply
retry if the spte is still a leaf PTE. If it isn't, we return false
to continue the walk.

Harvesting age information from the shadow MMU is still done while
holding the MMU write lock.

Suggested-by: Yu Zhao <yuzhao@google.com>
Signed-off-by: James Houghton <jthoughton@google.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/Kconfig            |  1 +
 arch/x86/kvm/mmu/mmu.c          | 10 ++++-
 arch/x86/kvm/mmu/tdp_iter.h     | 27 +++++++------
 arch/x86/kvm/mmu/tdp_mmu.c      | 67 +++++++++++++++++++++++++--------
 5 files changed, 77 insertions(+), 29 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f8ca74e7678f..011c8eb7c8d3 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1438,6 +1438,7 @@ struct kvm_arch {
 	 * tdp_mmu_page set.
 	 *
 	 * For reads, this list is protected by:
+	 *	RCU alone or
 	 *	the MMU lock in read mode + RCU or
 	 *	the MMU lock in write mode
 	 *
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index fec95a770270..9dda7f8c72ed 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -23,6 +23,7 @@ config KVM
 	depends on X86_LOCAL_APIC
 	select KVM_COMMON
 	select KVM_GENERIC_MMU_NOTIFIER
+	select KVM_MMU_NOTIFIER_YOUNG_LOCKLESS
 	select HAVE_KVM_IRQCHIP
 	select HAVE_KVM_PFNCACHE
 	select HAVE_KVM_DIRTY_RING_TSO
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 8d74bdef68c1..51061f1fb3d1 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1633,8 +1633,11 @@ bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	bool young = false;
 
-	if (kvm_memslots_have_rmaps(kvm))
+	if (kvm_memslots_have_rmaps(kvm)) {
+		write_lock(&kvm->mmu_lock);
 		young = kvm_handle_gfn_range(kvm, range, kvm_age_rmap);
+		write_unlock(&kvm->mmu_lock);
+	}
 
 	if (tdp_mmu_enabled)
 		young |= kvm_tdp_mmu_age_gfn_range(kvm, range);
@@ -1646,8 +1649,11 @@ bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	bool young = false;
 
-	if (kvm_memslots_have_rmaps(kvm))
+	if (kvm_memslots_have_rmaps(kvm)) {
+		write_lock(&kvm->mmu_lock);
 		young = kvm_handle_gfn_range(kvm, range, kvm_test_age_rmap);
+		write_unlock(&kvm->mmu_lock);
+	}
 
 	if (tdp_mmu_enabled)
 		young |= kvm_tdp_mmu_test_age_gfn(kvm, range);
diff --git a/arch/x86/kvm/mmu/tdp_iter.h b/arch/x86/kvm/mmu/tdp_iter.h
index 2880fd392e0c..510936a8455a 100644
--- a/arch/x86/kvm/mmu/tdp_iter.h
+++ b/arch/x86/kvm/mmu/tdp_iter.h
@@ -25,6 +25,13 @@ static inline u64 kvm_tdp_mmu_write_spte_atomic(tdp_ptep_t sptep, u64 new_spte)
 	return xchg(rcu_dereference(sptep), new_spte);
 }
 
+static inline u64 tdp_mmu_clear_spte_bits_atomic(tdp_ptep_t sptep, u64 mask)
+{
+	atomic64_t *sptep_atomic = (atomic64_t *)rcu_dereference(sptep);
+
+	return (u64)atomic64_fetch_and(~mask, sptep_atomic);
+}
+
 static inline void __kvm_tdp_mmu_write_spte(tdp_ptep_t sptep, u64 new_spte)
 {
 	KVM_MMU_WARN_ON(is_ept_ve_possible(new_spte));
@@ -32,10 +39,11 @@ static inline void __kvm_tdp_mmu_write_spte(tdp_ptep_t sptep, u64 new_spte)
 }
 
 /*
- * SPTEs must be modified atomically if they are shadow-present, leaf
- * SPTEs, and have volatile bits, i.e. has bits that can be set outside
- * of mmu_lock.  The Writable bit can be set by KVM's fast page fault
- * handler, and Accessed and Dirty bits can be set by the CPU.
+ * SPTEs must be modified atomically if they have bits that can be set outside
+ * of the mmu_lock. This can happen for any shadow-present leaf SPTEs, as the
+ * Writable bit can be set by KVM's fast page fault handler, the Accessed and
+ * Dirty bits can be set by the CPU, and the Accessed and R/X bits can be
+ * cleared by age_gfn_range.
  *
  * Note, non-leaf SPTEs do have Accessed bits and those bits are
  * technically volatile, but KVM doesn't consume the Accessed bit of
@@ -46,8 +54,7 @@ static inline void __kvm_tdp_mmu_write_spte(tdp_ptep_t sptep, u64 new_spte)
 static inline bool kvm_tdp_mmu_spte_need_atomic_write(u64 old_spte, int level)
 {
 	return is_shadow_present_pte(old_spte) &&
-	       is_last_spte(old_spte, level) &&
-	       spte_has_volatile_bits(old_spte);
+	       is_last_spte(old_spte, level);
 }
 
 static inline u64 kvm_tdp_mmu_write_spte(tdp_ptep_t sptep, u64 old_spte,
@@ -63,12 +70,8 @@ static inline u64 kvm_tdp_mmu_write_spte(tdp_ptep_t sptep, u64 old_spte,
 static inline u64 tdp_mmu_clear_spte_bits(tdp_ptep_t sptep, u64 old_spte,
 					  u64 mask, int level)
 {
-	atomic64_t *sptep_atomic;
-
-	if (kvm_tdp_mmu_spte_need_atomic_write(old_spte, level)) {
-		sptep_atomic = (atomic64_t *)rcu_dereference(sptep);
-		return (u64)atomic64_fetch_and(~mask, sptep_atomic);
-	}
+	if (kvm_tdp_mmu_spte_need_atomic_write(old_spte, level))
+		return tdp_mmu_clear_spte_bits_atomic(sptep, mask);
 
 	__kvm_tdp_mmu_write_spte(sptep, old_spte & ~mask);
 	return old_spte;
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 36539c1b36cd..46abd04914c2 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -29,6 +29,11 @@ static __always_inline bool kvm_lockdep_assert_mmu_lock_held(struct kvm *kvm,
 
 	return true;
 }
+static __always_inline bool kvm_lockdep_assert_rcu_read_lock_held(void)
+{
+	WARN_ON_ONCE(!rcu_read_lock_held());
+	return true;
+}
 
 void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
 {
@@ -178,6 +183,15 @@ static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
 		     ((_only_valid) && (_root)->role.invalid))) {		\
 		} else
 
+/*
+ * Iterate over all TDP MMU roots in an RCU read-side critical section.
+ */
+#define for_each_tdp_mmu_root_rcu(_kvm, _root, _as_id)				\
+	list_for_each_entry_rcu(_root, &_kvm->arch.tdp_mmu_roots, link)		\
+		if (kvm_lockdep_assert_rcu_read_lock_held() &&			\
+		    (_as_id >= 0 && kvm_mmu_page_as_id(_root) != _as_id)) {	\
+		} else
+
 #define for_each_tdp_mmu_root(_kvm, _root, _as_id)			\
 	__for_each_tdp_mmu_root(_kvm, _root, _as_id, false)
 
@@ -1223,6 +1237,27 @@ static __always_inline bool kvm_tdp_mmu_handle_gfn(struct kvm *kvm,
 	return ret;
 }
 
+static __always_inline bool kvm_tdp_mmu_handle_gfn_lockless(
+		struct kvm *kvm,
+		struct kvm_gfn_range *range,
+		tdp_handler_t handler)
+{
+	struct kvm_mmu_page *root;
+	struct tdp_iter iter;
+	bool ret = false;
+
+	rcu_read_lock();
+
+	for_each_tdp_mmu_root_rcu(kvm, root, range->slot->as_id) {
+		tdp_root_for_each_leaf_pte(iter, root, range->start, range->end)
+			ret |= handler(kvm, &iter, range);
+	}
+
+	rcu_read_unlock();
+
+	return ret;
+}
+
 /*
  * Mark the SPTEs range of GFNs [start, end) unaccessed and return non-zero
  * if any of the GFNs in the range have been accessed.
@@ -1236,28 +1271,30 @@ static bool age_gfn_range(struct kvm *kvm, struct tdp_iter *iter,
 {
 	u64 new_spte;
 
+retry:
 	/* If we have a non-accessed entry we don't need to change the pte. */
 	if (!is_accessed_spte(iter->old_spte))
 		return false;
 
 	if (spte_ad_enabled(iter->old_spte)) {
-		iter->old_spte = tdp_mmu_clear_spte_bits(iter->sptep,
-							 iter->old_spte,
-							 shadow_accessed_mask,
-							 iter->level);
+		iter->old_spte = tdp_mmu_clear_spte_bits_atomic(iter->sptep,
+						shadow_accessed_mask);
 		new_spte = iter->old_spte & ~shadow_accessed_mask;
 	} else {
-		/*
-		 * Capture the dirty status of the page, so that it doesn't get
-		 * lost when the SPTE is marked for access tracking.
-		 */
+		new_spte = mark_spte_for_access_track(iter->old_spte);
+		if (__tdp_mmu_set_spte_atomic(iter, new_spte)) {
+			/*
+			 * The cmpxchg failed. If the spte is still a
+			 * last-level spte, we can safely retry.
+			 */
+			if (is_shadow_present_pte(iter->old_spte) &&
+			    is_last_spte(iter->old_spte, iter->level))
+				goto retry;
+			/* Otherwise, continue walking. */
+			return false;
+		}
 		if (is_writable_pte(iter->old_spte))
 			kvm_set_pfn_dirty(spte_to_pfn(iter->old_spte));
-
-		new_spte = mark_spte_for_access_track(iter->old_spte);
-		iter->old_spte = kvm_tdp_mmu_write_spte(iter->sptep,
-							iter->old_spte, new_spte,
-							iter->level);
 	}
 
 	trace_kvm_tdp_mmu_spte_changed(iter->as_id, iter->gfn, iter->level,
@@ -1267,7 +1304,7 @@ static bool age_gfn_range(struct kvm *kvm, struct tdp_iter *iter,
 
 bool kvm_tdp_mmu_age_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 {
-	return kvm_tdp_mmu_handle_gfn(kvm, range, age_gfn_range);
+	return kvm_tdp_mmu_handle_gfn_lockless(kvm, range, age_gfn_range);
 }
 
 static bool test_age_gfn(struct kvm *kvm, struct tdp_iter *iter,
@@ -1278,7 +1315,7 @@ static bool test_age_gfn(struct kvm *kvm, struct tdp_iter *iter,
 
 bool kvm_tdp_mmu_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
-	return kvm_tdp_mmu_handle_gfn(kvm, range, test_age_gfn);
+	return kvm_tdp_mmu_handle_gfn_lockless(kvm, range, test_age_gfn);
 }
 
 /*
-- 
2.45.2.505.gda0bf45e8d-goog

