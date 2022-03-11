Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F9DBC433EF
	for <kvmarm@archiver.kernel.org>; Fri, 11 Mar 2022 08:49:06 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D5CC649F0B;
	Fri, 11 Mar 2022 03:49:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WJEzBabJ9Tpf; Fri, 11 Mar 2022 03:49:04 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2CC5E4B08B;
	Fri, 11 Mar 2022 03:48:45 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6BEBE408C1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 19:26:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id joYcN1zQv5FQ for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Mar 2022 19:26:11 -0500 (EST)
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com
 [209.85.215.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E18B440C52
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 19:26:10 -0500 (EST)
Received: by mail-pg1-f202.google.com with SMTP id
 t18-20020a63dd12000000b00342725203b5so3766727pgg.16
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 16:26:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=8sZhoWELpqEc2BsW/puOFOcuzB1aijCrHDgV+XGrT0A=;
 b=ZtJErbNbgiA2+RbqXKqBnxBr2Nq6m57xmo9PXp2yC127qBftR6dEDE/OtgMbXvzCe5
 R3oHIyZtmvDsk5xP3N7/iIB8cGyt7UM8f0gNZlLM8zCj7BaKqgCdxPmM22RnEROZc6Jo
 GCFdagqCDehiE8hlKuTZVkv9tHCzqD3B+rrlOZXtI7E8Hc5in7dOI/qmFbGOIo09ztU1
 V0po6MjiTapLs0qLGGWWVa9CvqbOzj55JzFU3GourgAtoEkN4GItGo5azol+kzBfzXqX
 sGDmznitJy/e3LnDvHMW04qf1JamRU4KvweC4AR38auxJrW7KOXkXENKvW4kGdA5Fyt2
 1HHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=8sZhoWELpqEc2BsW/puOFOcuzB1aijCrHDgV+XGrT0A=;
 b=FfdygV6vzBEfaD0v55SMSbUfQwqHLjRdzwXPgoO3TsXx8n2MI0R6i4pbvZGISr98IX
 9WOUZhykiFlrInzdhvNJsTihJIo4L9IYiCyII/+M6Y/MJS1FPLGOh87NUfQz6Gl+Xjmi
 HM1KioyDuGL77GpXrm5SN3dnh/YUMyFvstxuIXNI0DF9fIQxWQfNJgMQEfUqiZG7f7te
 rh5MiFwxhfhkadIO4yq/vjbnAgkc5Kf9hjssZ9Rcj4KEYofoMVpbzX9cuYjMAOo4Lpsi
 xy8SPlzSl7k6rP25U5gVDv5Q95j1gyL2RFQWIQ89xKmhbsObgm9aVsUTeN64chNhrT1x
 mnOg==
X-Gm-Message-State: AOAM533nT2pmQ4qsLO/Kpqlatm+v58hPpHC1DNjLNxLieZd8mg80RG6X
 2/03lH5P3aYQQ9ud02Oju5SsUgm4w+9NvQ==
X-Google-Smtp-Source: ABdhPJxp6KEAF9MQBj/R4AILw7oMFKjGojv2nE0u8xYk0LZhOg4P/GeokJiuxdu0z4Y/37+7y05xtg0eLGJuXg==
X-Received: from dmatlack-heavy.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:902:9007:b0:14f:3680:66d1 with SMTP
 id a7-20020a170902900700b0014f368066d1mr7904332plp.91.1646958370128; Thu, 10
 Mar 2022 16:26:10 -0800 (PST)
Date: Fri, 11 Mar 2022 00:25:25 +0000
In-Reply-To: <20220311002528.2230172-1-dmatlack@google.com>
Message-Id: <20220311002528.2230172-24-dmatlack@google.com>
Mime-Version: 1.0
References: <20220311002528.2230172-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v2 23/26] KVM: x86/mmu: Fully split huge pages that require
 extra pte_list_desc structs
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
X-Mailman-Approved-At: Fri, 11 Mar 2022 03:48:42 -0500
Cc: Albert Ou <aou@eecs.berkeley.edu>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <kvm@vger.kernel.org>, Marc Zyngier <maz@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <linux-mips@vger.kernel.org>, David Matlack <dmatlack@google.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Palmer Dabbelt <palmer@dabbelt.com>,
 "open list:KERNEL VIRTUAL MACHINE FOR RISC-V \(KVM/riscv\)"
 <kvm-riscv@lists.infradead.org>, Paul Walmsley <paul.walmsley@sifive.com>,
 Ben Gardon <bgardon@google.com>, maciej.szmigiero@oracle.com,
 "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>, Peter Feiner <pfeiner@google.com>
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

When splitting a huge page we need to add all of the lower level SPTEs
to the memslot rmap. The current implementation of eager page splitting
bails if adding an SPTE would require allocating an extra pte_list_desc
struct. Fix this limitation by allocating enough pte_list_desc structs
before splitting the huge page.

This eliminates the need for TLB flushing under the MMU lock because the
huge page is always entirely split (no subregion of the huge page is
unmapped).

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/include/asm/kvm_host.h |  10 +++
 arch/x86/kvm/mmu/mmu.c          | 131 ++++++++++++++++++--------------
 2 files changed, 85 insertions(+), 56 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 544dde11963b..00a5c0bcc2eb 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1240,6 +1240,16 @@ struct kvm_arch {
 	hpa_t	hv_root_tdp;
 	spinlock_t hv_root_tdp_lock;
 #endif
+
+	/*
+	 * Memory cache used to allocate pte_list_desc structs while splitting
+	 * huge pages. In the worst case, to split one huge page we need 512
+	 * pte_list_desc structs to add each new lower level leaf sptep to the
+	 * memslot rmap.
+	 */
+#define HUGE_PAGE_SPLIT_DESC_CACHE_CAPACITY 512
+	__DEFINE_KVM_MMU_MEMORY_CACHE(huge_page_split_desc_cache,
+				      HUGE_PAGE_SPLIT_DESC_CACHE_CAPACITY);
 };
 
 struct kvm_vm_stat {
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 24e7e053e05b..95b8e2ef562f 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1765,6 +1765,16 @@ struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm_vcpu *vcpu, bool direc
 	return sp;
 }
 
+static inline gfp_t gfp_flags_for_split(bool locked)
+{
+	/*
+	 * If under the MMU lock, use GFP_NOWAIT to avoid direct reclaim (which
+	 * is slow) and to avoid making any filesystem callbacks (which can end
+	 * up invoking KVM MMU notifiers, resulting in a deadlock).
+	 */
+	return (locked ? GFP_NOWAIT : GFP_KERNEL) | __GFP_ACCOUNT;
+}
+
 /*
  * Allocate a new shadow page, potentially while holding the MMU lock.
  *
@@ -1772,17 +1782,11 @@ struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm_vcpu *vcpu, bool direc
  * being mapped directly with a lower level page table. Thus there's no need to
  * allocate the shadowed_translation array.
  */
-struct kvm_mmu_page *kvm_mmu_alloc_direct_sp_for_split(bool locked)
+static struct kvm_mmu_page *__kvm_mmu_alloc_direct_sp_for_split(gfp_t gfp)
 {
 	struct kvm_mmu_page *sp;
-	gfp_t gfp;
 
-	/*
-	 * If under the MMU lock, use GFP_NOWAIT to avoid direct reclaim (which
-	 * is slow) and to avoid making any filesystem callbacks (which can end
-	 * up invoking KVM MMU notifiers, resulting in a deadlock).
-	 */
-	gfp = (locked ? GFP_NOWAIT : GFP_KERNEL) | __GFP_ACCOUNT | __GFP_ZERO;
+	gfp |= __GFP_ZERO;
 
 	sp = kmem_cache_alloc(mmu_page_header_cache, gfp);
 	if (!sp)
@@ -1799,6 +1803,13 @@ struct kvm_mmu_page *kvm_mmu_alloc_direct_sp_for_split(bool locked)
 	return sp;
 }
 
+struct kvm_mmu_page *kvm_mmu_alloc_direct_sp_for_split(bool locked)
+{
+	gfp_t gfp = gfp_flags_for_split(locked);
+
+	return __kvm_mmu_alloc_direct_sp_for_split(gfp);
+}
+
 static void mark_unsync(u64 *spte);
 static void kvm_mmu_mark_parents_unsync(struct kvm_mmu_page *sp)
 {
@@ -5989,6 +6000,11 @@ void kvm_mmu_init_vm(struct kvm *kvm)
 	node->track_write = kvm_mmu_pte_write;
 	node->track_flush_slot = kvm_mmu_invalidate_zap_pages_in_memslot;
 	kvm_page_track_register_notifier(kvm, node);
+
+	kvm->arch.huge_page_split_desc_cache.capacity =
+		HUGE_PAGE_SPLIT_DESC_CACHE_CAPACITY;
+	kvm->arch.huge_page_split_desc_cache.kmem_cache = pte_list_desc_cache;
+	kvm->arch.huge_page_split_desc_cache.gfp_zero = __GFP_ZERO;
 }
 
 void kvm_mmu_uninit_vm(struct kvm *kvm)
@@ -6119,11 +6135,43 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
 		kvm_arch_flush_remote_tlbs_memslot(kvm, memslot);
 }
 
+static int topup_huge_page_split_desc_cache(struct kvm *kvm, gfp_t gfp)
+{
+	/*
+	 * We may need up to HUGE_PAGE_SPLIT_DESC_CACHE_CAPACITY descriptors
+	 * to split any given huge page. We could more accurately calculate how
+	 * many we actually need by inspecting all the rmaps and check which
+	 * will need new descriptors, but that's not worth the extra cost or
+	 * code complexity.
+	 */
+	return __kvm_mmu_topup_memory_cache(
+			&kvm->arch.huge_page_split_desc_cache,
+			HUGE_PAGE_SPLIT_DESC_CACHE_CAPACITY,
+			gfp);
+}
+
+static int alloc_memory_for_split(struct kvm *kvm, struct kvm_mmu_page **spp,
+				  bool locked)
+{
+	gfp_t gfp = gfp_flags_for_split(locked);
+	int r;
+
+	r = topup_huge_page_split_desc_cache(kvm, gfp);
+	if (r)
+		return r;
+
+	if (!*spp) {
+		*spp = __kvm_mmu_alloc_direct_sp_for_split(gfp);
+		r = *spp ? 0 : -ENOMEM;
+	}
+
+	return r;
+}
+
 static int prepare_to_split_huge_page(struct kvm *kvm,
 				      const struct kvm_memory_slot *slot,
 				      u64 *huge_sptep,
 				      struct kvm_mmu_page **spp,
-				      bool *flush,
 				      bool *dropped_lock)
 {
 	int r = 0;
@@ -6136,24 +6184,18 @@ static int prepare_to_split_huge_page(struct kvm *kvm,
 	if (need_resched() || rwlock_needbreak(&kvm->mmu_lock))
 		goto drop_lock;
 
-	*spp = kvm_mmu_alloc_direct_sp_for_split(true);
+	r = alloc_memory_for_split(kvm, spp, true);
 	if (r)
 		goto drop_lock;
 
 	return 0;
 
 drop_lock:
-	if (*flush)
-		kvm_arch_flush_remote_tlbs_memslot(kvm, slot);
-
-	*flush = false;
 	*dropped_lock = true;
 
 	write_unlock(&kvm->mmu_lock);
 	cond_resched();
-	*spp = kvm_mmu_alloc_direct_sp_for_split(false);
-	if (!*spp)
-		r = -ENOMEM;
+	r = alloc_memory_for_split(kvm, spp, false);
 	write_lock(&kvm->mmu_lock);
 
 	return r;
@@ -6196,10 +6238,10 @@ static struct kvm_mmu_page *kvm_mmu_get_sp_for_split(struct kvm *kvm,
 
 static int kvm_mmu_split_huge_page(struct kvm *kvm,
 				   const struct kvm_memory_slot *slot,
-				   u64 *huge_sptep, struct kvm_mmu_page **spp,
-				   bool *flush)
+				   u64 *huge_sptep, struct kvm_mmu_page **spp)
 
 {
+	struct kvm_mmu_memory_cache *cache;
 	struct kvm_mmu_page *split_sp;
 	u64 huge_spte, split_spte;
 	int split_level, index;
@@ -6212,9 +6254,9 @@ static int kvm_mmu_split_huge_page(struct kvm *kvm,
 		return -EOPNOTSUPP;
 
 	/*
-	 * Since we did not allocate pte_list_desc_structs for the split, we
-	 * cannot add a new parent SPTE to parent_ptes. This should never happen
-	 * in practice though since this is a fresh SP.
+	 * We did not allocate an extra pte_list_desc struct to add huge_sptep
+	 * to split_sp->parent_ptes. An extra pte_list_desc struct should never
+	 * be necessary in practice though since split_sp is brand new.
 	 *
 	 * Note, this makes it safe to pass NULL to __link_shadow_page() below.
 	 */
@@ -6225,6 +6267,7 @@ static int kvm_mmu_split_huge_page(struct kvm *kvm,
 
 	split_level = split_sp->role.level;
 	access = split_sp->role.access;
+	cache = &kvm->arch.huge_page_split_desc_cache;
 
 	for (index = 0; index < PT64_ENT_PER_PAGE; index++) {
 		split_sptep = &split_sp->spt[index];
@@ -6232,25 +6275,11 @@ static int kvm_mmu_split_huge_page(struct kvm *kvm,
 
 		BUG_ON(is_shadow_present_pte(*split_sptep));
 
-		/*
-		 * Since we did not allocate pte_list_desc structs for the
-		 * split, we can't add a new SPTE that maps this GFN.
-		 * Skipping this SPTE means we're only partially mapping the
-		 * huge page, which means we'll need to flush TLBs before
-		 * dropping the MMU lock.
-		 *
-		 * Note, this make it safe to pass NULL to __rmap_add() below.
-		 */
-		if (gfn_to_rmap(split_gfn, split_level, slot)->val) {
-			*flush = true;
-			continue;
-		}
-
 		split_spte = make_huge_page_split_spte(
 				huge_spte, split_level + 1, index, access);
 
 		mmu_spte_set(split_sptep, split_spte);
-		__rmap_add(kvm, NULL, slot, split_sptep, split_gfn, access);
+		__rmap_add(kvm, cache, slot, split_sptep, split_gfn, access);
 	}
 
 	/*
@@ -6258,9 +6287,7 @@ static int kvm_mmu_split_huge_page(struct kvm *kvm,
 	 * page table. Since we are making this change without a TLB flush vCPUs
 	 * will see a mix of the split mappings and the original huge mapping,
 	 * depending on what's currently in their TLB. This is fine from a
-	 * correctness standpoint since the translation will either be identical
-	 * or non-present. To account for non-present mappings, the TLB will be
-	 * flushed prior to dropping the MMU lock.
+	 * correctness standpoint since the translation will be identical.
 	 */
 	__drop_large_spte(kvm, huge_sptep, false);
 	__link_shadow_page(NULL, huge_sptep, split_sp);
@@ -6297,7 +6324,6 @@ static bool rmap_try_split_huge_pages(struct kvm *kvm,
 	struct kvm_mmu_page *sp = NULL;
 	struct rmap_iterator iter;
 	u64 *huge_sptep, spte;
-	bool flush = false;
 	bool dropped_lock;
 	int level;
 	gfn_t gfn;
@@ -6312,7 +6338,7 @@ static bool rmap_try_split_huge_pages(struct kvm *kvm,
 		level = sptep_to_sp(huge_sptep)->role.level;
 		gfn = sptep_to_gfn(huge_sptep);
 
-		r = prepare_to_split_huge_page(kvm, slot, huge_sptep, &sp, &flush, &dropped_lock);
+		r = prepare_to_split_huge_page(kvm, slot, huge_sptep, &sp, &dropped_lock);
 		if (r) {
 			trace_kvm_mmu_split_huge_page(gfn, spte, level, r);
 			break;
@@ -6321,7 +6347,7 @@ static bool rmap_try_split_huge_pages(struct kvm *kvm,
 		if (dropped_lock)
 			goto restart;
 
-		r = kvm_mmu_split_huge_page(kvm, slot, huge_sptep, &sp, &flush);
+		r = kvm_mmu_split_huge_page(kvm, slot, huge_sptep, &sp);
 
 		trace_kvm_mmu_split_huge_page(gfn, spte, level, r);
 
@@ -6336,7 +6362,7 @@ static bool rmap_try_split_huge_pages(struct kvm *kvm,
 	if (sp)
 		kvm_mmu_free_shadow_page(sp);
 
-	return flush;
+	return false;
 }
 
 static void kvm_rmap_try_split_huge_pages(struct kvm *kvm,
@@ -6344,7 +6370,6 @@ static void kvm_rmap_try_split_huge_pages(struct kvm *kvm,
 					  gfn_t start, gfn_t end,
 					  int target_level)
 {
-	bool flush;
 	int level;
 
 	/*
@@ -6352,21 +6377,15 @@ static void kvm_rmap_try_split_huge_pages(struct kvm *kvm,
 	 * down to the target level. This ensures pages are recursively split
 	 * all the way to the target level. There's no need to split pages
 	 * already at the target level.
-	 *
-	 * Note that TLB flushes must be done before dropping the MMU lock since
-	 * rmap_try_split_huge_pages() may partially split any given huge page,
-	 * i.e. it may effectively unmap (make non-present) a portion of the
-	 * huge page.
 	 */
 	for (level = KVM_MAX_HUGEPAGE_LEVEL; level > target_level; level--) {
-		flush = slot_handle_level_range(kvm, slot,
-						rmap_try_split_huge_pages,
-						level, level, start, end - 1,
-						true, flush);
+		slot_handle_level_range(kvm, slot,
+					rmap_try_split_huge_pages,
+					level, level, start, end - 1,
+					true, false);
 	}
 
-	if (flush)
-		kvm_arch_flush_remote_tlbs_memslot(kvm, slot);
+	kvm_mmu_free_memory_cache(&kvm->arch.huge_page_split_desc_cache);
 }
 
 /* Must be called with the mmu_lock held in write-mode. */
-- 
2.35.1.723.g4982287a31-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
