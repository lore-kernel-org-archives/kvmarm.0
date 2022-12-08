Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CC6EC001B2
	for <kvmarm@archiver.kernel.org>; Thu,  8 Dec 2022 19:40:09 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EEFF34BA8C;
	Thu,  8 Dec 2022 14:40:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ITCUxpnxzTMf; Thu,  8 Dec 2022 14:40:07 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 48FAD4BA59;
	Thu,  8 Dec 2022 14:40:06 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 777744B800
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Dec 2022 14:40:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id My-6Ol0lX+cV for <kvmarm@lists.cs.columbia.edu>;
 Thu,  8 Dec 2022 14:40:02 -0500 (EST)
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com
 [209.85.214.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B6C974BA7E
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Dec 2022 14:39:58 -0500 (EST)
Received: by mail-pl1-f201.google.com with SMTP id
 u10-20020a17090341ca00b001897a151311so2188609ple.8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 08 Dec 2022 11:39:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:from:to:cc:subject:date:message-id:reply-to;
 bh=5KBqh+vKODV/WoeMK21JvgHm4EN7AAHrFHprSoZAMHM=;
 b=dgxL00zUKdsqPZ5BwEzchIDS0YimfPZdMBfaW+t1GD3oqv+/EkBpDPWncV98t5WdnV
 TBle0pbiXgVb8ZuL21bA0THizQHKychb2xBY5k3lsL418ll3MgYAwawojTcq9RnFZ3VC
 gp0JVFFhtOwaUQAjwCHxFRcjwkCDGdko0D8NkwhLAgADuuA/YgCHZFY/7eyI5fPHiQQh
 P3D22hbfX6yT3l3DPX4jYLR3Wh/wUR/jzAQOf03iuz6zdbNZOzxX9Oq4tp6kuycxWq7u
 Cl84n0bCDSkrJAp+5vHhyXqu5cM1FpccTofAXSy7fllgJw53/hy7Sw7ooPaKn/gbjJTT
 tssg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=5KBqh+vKODV/WoeMK21JvgHm4EN7AAHrFHprSoZAMHM=;
 b=b/FBcWV4aYyf+sAZqVxCibgHSzBWZDGE688QUCciAJOc5ISnA59eg+3pUOH2T7mjNc
 xsL76ikJtELk+/BFZzD+Nk1Ufk4guQQ4sZmpiJOL05n3V0QhjZOaWfe4uuBqOEeAopOh
 3Ud75zqqHZJ7+hjgAd6GBdidwwwKPiZNE/YWhEUzENqyxDhy/eZUdhkSAH0954jwBKTw
 tGhW0DxqCjt9YgX/8y7GaVh9OKMSoVe2fsGi33HhYtMfCDTsJylXqZNIgvLrYE1F9wRx
 zd0I3f7Ul1LRhkcK0MRXJOUIbwXLLRmCBv/pt/eVca+nmITFsgslJUCPwVvAVwVf7BCi
 s+iA==
X-Gm-Message-State: ANoB5pkciVXV1Ey1cKGCQAJ2q7/ernfFyg7WX+TozTw3ksVU1AK6v/LH
 GLvcA1aJZ8WDFOyH9rh0aMzKgkHpWJ33Pg==
X-Google-Smtp-Source: AA0mqf54N4YTuY6bG4NbJkmo6GnKEgVcMOgySXZon5g0EbgRxJrycPbdzp1seojBkwcXkg4lld4eR/cLN9ZrOw==
X-Received: from dmatlack-n2d-128.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a17:90b:f89:b0:219:5b3b:2b9f with SMTP id
 ft9-20020a17090b0f8900b002195b3b2b9fmr4096869pjb.2.1670528397168; Thu, 08 Dec
 2022 11:39:57 -0800 (PST)
Date: Thu,  8 Dec 2022 11:38:50 -0800
In-Reply-To: <20221208193857.4090582-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20221208193857.4090582-1-dmatlack@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221208193857.4090582-31-dmatlack@google.com>
Subject: [RFC PATCH 30/37] KVM: x86/mmu: Rename
 kvm_flush_remote_tlbs_with_address()
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
 Hugh Dickins <hughd@google.com>, Paul Walmsley <paul.walmsley@sifive.com>,
 kvmarm@lists.linux.dev, Nadav Amit <namit@vmware.com>,
 Colin Cross <ccross@google.com>, Ben Gardon <bgardon@google.com>,
 linux-riscv@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 Yu Zhao <yuzhao@google.com>, Marc Zyngier <maz@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 "Matthew Wilcox \(Oracle\)" <willy@infradead.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Krish Sadhukhan <krish.sadhukhan@oracle.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Mingwei Zhang <mizhang@google.com>,
 Albert Ou <aou@eecs.berkeley.edu>, xu xin <cgel.zte@gmail.com>,
 Arnd Bergmann <arnd@arndb.de>, "Liam R. Howlett" <Liam.Howlett@Oracle.com>,
 kvm@vger.kernel.org, Atish Patra <atishp@atishpatra.org>,
 David Matlack <dmatlack@google.com>, Suren Baghdasaryan <surenb@google.com>,
 Vlastimil Babka <vbabka@suse.cz>, linux-arm-kernel@lists.infradead.org,
 linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org,
 Andrew Morton <akpm@linux-foundation.org>
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

Rename kvm_flush_remote_tlbs_with_address() to
kvm_flush_remote_tlbs_range(). This name is shorter, which reduces the
number of callsites that need to be broken up across multiple lines, and
more readable since it conveys a range of memory is being flushed rather
than a single address.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c          | 32 ++++++++++++++------------------
 arch/x86/kvm/mmu/mmu_internal.h |  3 +--
 arch/x86/kvm/mmu/paging_tmpl.h  |  4 ++--
 arch/x86/kvm/mmu/tdp_mmu.c      |  7 +++----
 4 files changed, 20 insertions(+), 26 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index b7bbabac9127..4a28adaa92b4 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -244,8 +244,7 @@ static inline bool kvm_available_flush_tlb_with_range(void)
 	return kvm_x86_ops.tlb_remote_flush_with_range;
 }
 
-void kvm_flush_remote_tlbs_with_address(struct kvm *kvm,
-		u64 start_gfn, u64 pages)
+void kvm_flush_remote_tlbs_range(struct kvm *kvm, u64 start_gfn, u64 pages)
 {
 	struct kvm_tlb_range range;
 	int ret = -EOPNOTSUPP;
@@ -804,7 +803,7 @@ static void account_shadowed(struct kvm *kvm, struct kvm_mmu_page *sp)
 	kvm_mmu_gfn_disallow_lpage(slot, gfn);
 
 	if (kvm_mmu_slot_gfn_write_protect(kvm, slot, gfn, PG_LEVEL_4K))
-		kvm_flush_remote_tlbs_with_address(kvm, gfn, 1);
+		kvm_flush_remote_tlbs_range(kvm, gfn, 1);
 }
 
 void track_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp)
@@ -1178,7 +1177,7 @@ static void drop_large_spte(struct kvm *kvm, u64 *sptep, bool flush)
 	drop_spte(kvm, sptep);
 
 	if (flush)
-		kvm_flush_remote_tlbs_with_address(kvm, sp->gfn,
+		kvm_flush_remote_tlbs_range(kvm, sp->gfn,
 			KVM_PAGES_PER_HPAGE(sp->role.level));
 }
 
@@ -1460,7 +1459,7 @@ static bool kvm_set_pte_rmap(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
 	}
 
 	if (need_flush && kvm_available_flush_tlb_with_range()) {
-		kvm_flush_remote_tlbs_with_address(kvm, gfn, 1);
+		kvm_flush_remote_tlbs_range(kvm, gfn, 1);
 		return false;
 	}
 
@@ -1630,8 +1629,8 @@ static void __rmap_add(struct kvm *kvm,
 		kvm->stat.max_mmu_rmap_size = rmap_count;
 	if (rmap_count > RMAP_RECYCLE_THRESHOLD) {
 		kvm_zap_all_rmap_sptes(kvm, rmap_head);
-		kvm_flush_remote_tlbs_with_address(
-				kvm, sp->gfn, KVM_PAGES_PER_HPAGE(sp->role.level));
+		kvm_flush_remote_tlbs_range(kvm, sp->gfn,
+					    KVM_PAGES_PER_HPAGE(sp->role.level));
 	}
 }
 
@@ -2389,7 +2388,7 @@ static void validate_direct_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 			return;
 
 		drop_parent_pte(child, sptep);
-		kvm_flush_remote_tlbs_with_address(vcpu->kvm, child->gfn, 1);
+		kvm_flush_remote_tlbs_range(vcpu->kvm, child->gfn, 1);
 	}
 }
 
@@ -2873,8 +2872,8 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
 	}
 
 	if (flush)
-		kvm_flush_remote_tlbs_with_address(vcpu->kvm, gfn,
-				KVM_PAGES_PER_HPAGE(level));
+		kvm_flush_remote_tlbs_range(vcpu->kvm, gfn,
+					    KVM_PAGES_PER_HPAGE(level));
 
 	pgprintk("%s: setting spte %llx\n", __func__, *sptep);
 
@@ -5809,9 +5808,8 @@ slot_handle_level_range(struct kvm *kvm, const struct kvm_memory_slot *memslot,
 
 		if (need_resched() || rwlock_needbreak(&kvm->mmu_lock)) {
 			if (flush && flush_on_yield) {
-				kvm_flush_remote_tlbs_with_address(kvm,
-						start_gfn,
-						iterator.gfn - start_gfn + 1);
+				kvm_flush_remote_tlbs_range(kvm, start_gfn,
+							    iterator.gfn - start_gfn + 1);
 				flush = false;
 			}
 			cond_resched_rwlock_write(&kvm->mmu_lock);
@@ -6166,8 +6164,7 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
 	}
 
 	if (flush)
-		kvm_flush_remote_tlbs_with_address(kvm, gfn_start,
-						   gfn_end - gfn_start);
+		kvm_flush_remote_tlbs_range(kvm, gfn_start, gfn_end - gfn_start);
 
 	kvm_mmu_invalidate_end(kvm, gfn_start, gfn_end);
 
@@ -6506,7 +6503,7 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
 			kvm_zap_one_rmap_spte(kvm, rmap_head, sptep);
 
 			if (kvm_available_flush_tlb_with_range())
-				kvm_flush_remote_tlbs_with_address(kvm, sp->gfn,
+				kvm_flush_remote_tlbs_range(kvm, sp->gfn,
 					KVM_PAGES_PER_HPAGE(sp->role.level));
 			else
 				need_tlb_flush = 1;
@@ -6557,8 +6554,7 @@ void kvm_arch_flush_remote_tlbs_memslot(struct kvm *kvm,
 	 * is observed by any other operation on the same memslot.
 	 */
 	lockdep_assert_held(&kvm->slots_lock);
-	kvm_flush_remote_tlbs_with_address(kvm, memslot->base_gfn,
-					   memslot->npages);
+	kvm_flush_remote_tlbs_range(kvm, memslot->base_gfn, memslot->npages);
 }
 
 void kvm_mmu_slot_leaf_clear_dirty(struct kvm *kvm,
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 4aa60d5d87b0..d35a5b408b98 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -65,8 +65,7 @@ void kvm_mmu_gfn_allow_lpage(const struct kvm_memory_slot *slot, gfn_t gfn);
 bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
 				    struct kvm_memory_slot *slot, u64 gfn,
 				    int min_level);
-void kvm_flush_remote_tlbs_with_address(struct kvm *kvm,
-					u64 start_gfn, u64 pages);
+void kvm_flush_remote_tlbs_range(struct kvm *kvm, u64 start_gfn, u64 pages);
 unsigned int pte_list_count(struct kvm_rmap_head *rmap_head);
 
 extern int nx_huge_pages;
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index daf9c7731edc..bfee5e0d1ee1 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -929,8 +929,8 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva, hpa_t root_hpa)
 
 			mmu_page_zap_pte(vcpu->kvm, sp, sptep, NULL);
 			if (is_shadow_present_pte(old_spte))
-				kvm_flush_remote_tlbs_with_address(vcpu->kvm,
-					sp->gfn, KVM_PAGES_PER_HPAGE(sp->role.level));
+				kvm_flush_remote_tlbs_range(vcpu->kvm, sp->gfn,
+							    KVM_PAGES_PER_HPAGE(sp->role.level));
 
 			if (!rmap_can_add(vcpu))
 				break;
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 72746b645e99..1f1f511cd1a0 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -676,8 +676,7 @@ static inline int tdp_mmu_zap_spte_atomic(struct kvm *kvm,
 	if (ret)
 		return ret;
 
-	kvm_flush_remote_tlbs_with_address(kvm, iter->gfn,
-					   TDP_PAGES_PER_LEVEL(iter->level));
+	kvm_flush_remote_tlbs_range(kvm, iter->gfn, TDP_PAGES_PER_LEVEL(iter->level));
 
 	/*
 	 * No other thread can overwrite the removed SPTE as they must either
@@ -1067,8 +1066,8 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
 		return RET_PF_RETRY;
 	else if (tdp_pte_is_present(iter->old_spte) &&
 		 !tdp_pte_is_leaf(iter->old_spte, iter->level))
-		kvm_flush_remote_tlbs_with_address(vcpu->kvm, sp->gfn,
-						   TDP_PAGES_PER_LEVEL(iter->level + 1));
+		kvm_flush_remote_tlbs_range(vcpu->kvm, sp->gfn,
+					    TDP_PAGES_PER_LEVEL(iter->level + 1));
 
 	/*
 	 * If the page fault was caused by a write but the page is write
-- 
2.39.0.rc1.256.g54fd8350bd-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
