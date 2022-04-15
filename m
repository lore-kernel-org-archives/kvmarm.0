Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFA2BC433F5
	for <kvmarm@archiver.kernel.org>; Fri, 15 Apr 2022 21:59:24 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 777A44B0D0;
	Fri, 15 Apr 2022 17:59:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LeDg9X3dMVH7; Fri, 15 Apr 2022 17:59:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E99524B093;
	Fri, 15 Apr 2022 17:59:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 75BF14B08A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Apr 2022 17:59:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3jja+oynD4PU for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Apr 2022 17:59:16 -0400 (EDT)
Received: from mail-io1-f73.google.com (mail-io1-f73.google.com
 [209.85.166.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7050749F46
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Apr 2022 17:59:14 -0400 (EDT)
Received: by mail-io1-f73.google.com with SMTP id
 g16-20020a05660203d000b005f7b3b0642eso5403595iov.16
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Apr 2022 14:59:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=dlVM2Fz2Y7ISzW+T03M67t0iCDhFZowMvNW5W95Ip88=;
 b=Diuw9S7MBxEBgzLHbnnt4GYfzxtBiJUB0zsGMYHDzpDoe3JhqJZWSJDdokUWM0zkha
 i8x/gC5nUrVYUs6hOdPDTL9nf6kIJU6VcYk1l6lDT4D+fYmAlc/RjfiLOv6Lbn4Qc5ix
 72AehN7YLrkzrcdoZHRTEpT+RxysbKRUYxlWnpz0GrQzl8WPj5OUn6ZyuIr66cu77bE9
 U74z9VvwrCW2I1jAaAY869FqA4+HHoDayX/3H+iVX/0ZTb6Hj4TiQ6JkdiuX1fC5i1P3
 41rsk/YPkHQpsi2FPnvR+M5tehzMzixyFXLPJG6fOGRp/S1x48HLPLhSkHQm4o3yOoM5
 DRZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=dlVM2Fz2Y7ISzW+T03M67t0iCDhFZowMvNW5W95Ip88=;
 b=ZCWt6JKVZ5Kt1JQAQJJKKRv+kvk6554qRceBUCDCeYu4QJOHdLdUaqpbFw9ayHTWZZ
 c/B4uKGzJ5WCFbje9UwgtAX/ci2/AIAISDeuh2l8TWP1Pj1CdjuTS1WRhkH0ddYTcppX
 nHrpSVctiZxLfp6rlEy3f+LqfEtbI6bQqCDpXlc4q+OwPaGiF29d5IWNgAZ22nHvO8GV
 VMB9NT+YvEqQQoh7r2lo5IGwObPUm/BNHRqAx32vJjEeOgjp6XhLRbI5BR4w0XNsc7zH
 u3w6divdF6vBGJiMPncy52PfaZcNJznEOrXtjji1oXA7TzIiQVRvagzvjJ/armeSl+oT
 ujdw==
X-Gm-Message-State: AOAM530LzdCxemL4+o8ZG6DeJZWzldo0lG9XHOTyZbVMm6HO4ScHsYs9
 uqARFO10MJz2L1Mjk+QDBnS6/v8+kqI958kIK8skVvAShv6XoHOQmU09u5pEss9Qk7e6fmZnBLY
 LA62ABHdkXHlowN7lbombG0DxB5nmeyTzlL2NiJnjadTSc9RudA6uyo0U+l80A+fbljGgng==
X-Google-Smtp-Source: ABdhPJz3tHc7G5iWdHXhbRBfoyVUj3SKr1PVP3WtCMI3dyoPjw0ifVyDiqazQpsgWctE2YfwQt7/F4KvGHU=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a92:c542:0:b0:2cb:d371:1f3e with
 SMTP id
 a2-20020a92c542000000b002cbd3711f3emr288202ilj.323.1650059953946; Fri, 15 Apr
 2022 14:59:13 -0700 (PDT)
Date: Fri, 15 Apr 2022 21:58:50 +0000
In-Reply-To: <20220415215901.1737897-1-oupton@google.com>
Message-Id: <20220415215901.1737897-7-oupton@google.com>
Mime-Version: 1.0
References: <20220415215901.1737897-1-oupton@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [RFC PATCH 06/17] KVM: arm64: Implement break-before-make sequence
 for parallel walks
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Ben Gardon <bgardon@google.com>, Peter Shier <pshier@google.com>,
 David Matlack <dmatlack@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 linux-arm-kernel@lists.infradead.org
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

The ARM architecture requires that software use the 'break-before-make'
sequence whenever memory is being remapped. An additional requirement of
parallel page walks is a mechanism to ensure exclusive access to a pte,
thereby avoiding two threads changing the pte and invariably stomping on
one another.

Roll the two concepts together into a new helper to implement the
'break' sequence. Use a special invalid pte value to indicate that the
pte is under the exclusive control of a thread. If software walkers are
traversing the tables in parallel, use an atomic compare-exchange to
break the pte. Retry execution on a failed attempt to break the pte, in
the hopes that either the instruction will succeed or the pte lock will
be successfully acquired.

Avoid unnecessary DSBs and TLBIs by only completing the sequence if the
evicted pte was valid. For counted non-table ptes drop the reference
immediately. Otherwise, references on tables are dropped in post-order
traversal as the walker must recurse on the pruned subtree.

All of the new atomics do nothing (for now), as there are a few other
bits of the map walker that need to be addressed before actually walking
in parallel.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/kvm/hyp/pgtable.c | 172 +++++++++++++++++++++++++++++------
 1 file changed, 146 insertions(+), 26 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index bf46d6d24951..059ebb921125 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -49,6 +49,12 @@
 #define KVM_INVALID_PTE_OWNER_MASK	GENMASK(9, 2)
 #define KVM_MAX_OWNER_ID		1
 
+/*
+ * Used to indicate a pte for which a 'make-before-break' sequence is in
+ * progress.
+ */
+#define KVM_INVALID_PTE_LOCKED		BIT(10)
+
 struct kvm_pgtable_walk_data {
 	struct kvm_pgtable		*pgt;
 	struct kvm_pgtable_walker	*walker;
@@ -707,6 +713,122 @@ static bool stage2_pte_is_counted(kvm_pte_t pte)
 	return kvm_pte_valid(pte) || kvm_invalid_pte_owner(pte);
 }
 
+static bool stage2_pte_is_locked(kvm_pte_t pte)
+{
+	return !kvm_pte_valid(pte) && (pte & KVM_INVALID_PTE_LOCKED);
+}
+
+static inline bool kvm_try_set_pte(kvm_pte_t *ptep, kvm_pte_t old, kvm_pte_t new, bool shared)
+{
+	if (!shared) {
+		WRITE_ONCE(*ptep, new);
+		return true;
+	}
+
+	return cmpxchg(ptep, old, new) == old;
+}
+
+/**
+ * stage2_try_break_pte() - Invalidates a pte according to the
+ *			    'break-before-make' sequence.
+ *
+ * @ptep: Pointer to the pte to break
+ * @old: The previously observed value of the pte; used for compare-exchange in
+ *	 a parallel walk
+ * @addr: IPA corresponding to the pte
+ * @level: Table level of the pte
+ * @shared: true if the tables are shared by multiple software walkers
+ * @data: pointer to the map walker data
+ *
+ * Returns: true if the pte was successfully broken.
+ *
+ * If the removed pt was valid, performs the necessary DSB and TLB flush for
+ * the old value. Drops references to the page table if a non-table entry was
+ * removed. Otherwise, the table reference is preserved as the walker must also
+ * recurse through the child tables.
+ *
+ * See ARM DDI0487G.a D5.10.1 "General TLB maintenance requirements" for details
+ * on the 'break-before-make' sequence.
+ */
+static bool stage2_try_break_pte(kvm_pte_t *ptep, kvm_pte_t old, u64 addr, u32 level, bool shared,
+				 struct stage2_map_data *data)
+{
+	/*
+	 * Another thread could have already visited this pte and taken
+	 * ownership.
+	 */
+	if (stage2_pte_is_locked(old)) {
+		/*
+		 * If the table walker has exclusive access to the page tables
+		 * then no other software walkers should have locked the pte.
+		 */
+		WARN_ON(!shared);
+		return false;
+	}
+
+	if (!kvm_try_set_pte(ptep, old, KVM_INVALID_PTE_LOCKED, shared))
+		return false;
+
+	/*
+	 * If we removed a valid pte, break-then-make rules are in effect as a
+	 * translation may have been cached that traversed this entry.
+	 */
+	if (kvm_pte_valid(old)) {
+		dsb(ishst);
+
+		if (kvm_pte_table(old, level))
+			/*
+			 * Invalidate the whole stage-2, as we may have numerous leaf
+			 * entries below us which would otherwise need invalidating
+			 * individually.
+			 */
+			kvm_call_hyp(__kvm_tlb_flush_vmid, data->mmu);
+		else
+			kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, data->mmu, addr, level);
+	}
+
+	/*
+	 * Don't drop the reference on table entries yet, as the walker must
+	 * first recurse on the unlinked subtree to unlink and drop references
+	 * to child tables.
+	 */
+	if (!kvm_pte_table(old, level) && stage2_pte_is_counted(old))
+		data->mm_ops->put_page(ptep);
+
+	return true;
+}
+
+/**
+ * stage2_make_pte() - Installs a new pte according to the 'break-before-make'
+ *		       sequence.
+ *
+ * @ptep: pointer to the pte to make
+ * @new: new pte value to install
+ *
+ * Assumes that the pte addressed by ptep has already been broken and is under
+ * the ownership of the table walker. If the new pte to be installed is a valid
+ * entry, perform a DSB to make the write visible. Raise the reference count on
+ * the table if the new pte requires a reference.
+ *
+ * See ARM DDI0487G.a D5.10.1 "General TLB maintenance requirements" for details
+ * on the 'break-before-make' sequence.
+ */
+static void stage2_make_pte(kvm_pte_t *ptep, kvm_pte_t new, struct kvm_pgtable_mm_ops *mm_ops)
+{
+	/* Yikes! We really shouldn't install to an entry we don't own. */
+	WARN_ON(!stage2_pte_is_locked(*ptep));
+
+	if (stage2_pte_is_counted(new))
+		mm_ops->get_page(ptep);
+
+	if (kvm_pte_valid(new)) {
+		WRITE_ONCE(*ptep, new);
+		dsb(ishst);
+	} else {
+		smp_store_release(ptep, new);
+	}
+}
+
 static void stage2_put_pte(kvm_pte_t *ptep, struct kvm_s2_mmu *mmu, u64 addr,
 			   u32 level, struct kvm_pgtable_mm_ops *mm_ops)
 {
@@ -760,18 +882,17 @@ static int stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
 	else
 		new = kvm_init_invalid_leaf_owner(data->owner_id);
 
-	if (stage2_pte_is_counted(old)) {
-		/*
-		 * Skip updating the PTE if we are trying to recreate the exact
-		 * same mapping or only change the access permissions. Instead,
-		 * the vCPU will exit one more time from guest if still needed
-		 * and then go through the path of relaxing permissions.
-		 */
-		if (!stage2_pte_needs_update(old, new))
-			return -EAGAIN;
+	/*
+	 * Skip updating the PTE if we are trying to recreate the exact same
+	 * mapping or only change the access permissions. Instead, the vCPU will
+	 * exit one more time from the guest if still needed and then go through
+	 * the path of relaxing permissions.
+	 */
+	if (!stage2_pte_needs_update(old, new))
+		return -EAGAIN;
 
-		stage2_put_pte(ptep, data->mmu, addr, level, mm_ops);
-	}
+	if (!stage2_try_break_pte(ptep, old, addr, level, shared, data))
+		return -EAGAIN;
 
 	/* Perform CMOs before installation of the guest stage-2 PTE */
 	if (mm_ops->dcache_clean_inval_poc && stage2_pte_cacheable(pgt, new))
@@ -781,9 +902,7 @@ static int stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
 	if (mm_ops->icache_inval_pou && stage2_pte_executable(new))
 		mm_ops->icache_inval_pou(kvm_pte_follow(new, mm_ops), granule);
 
-	smp_store_release(ptep, new);
-	if (stage2_pte_is_counted(new))
-		mm_ops->get_page(ptep);
+	stage2_make_pte(ptep, new, data->mm_ops);
 	if (kvm_phys_is_valid(phys))
 		data->phys += granule;
 	return 0;
@@ -800,15 +919,10 @@ static int stage2_map_walk_table_pre(u64 addr, u64 end, u32 level,
 	if (!stage2_leaf_mapping_allowed(addr, end, level, data))
 		return 0;
 
-	data->childp = kvm_pte_follow(*old, data->mm_ops);
-	kvm_clear_pte(ptep);
+	if (!stage2_try_break_pte(ptep, *old, addr, level, shared, data))
+		return -EAGAIN;
 
-	/*
-	 * Invalidate the whole stage-2, as we may have numerous leaf
-	 * entries below us which would otherwise need invalidating
-	 * individually.
-	 */
-	kvm_call_hyp(__kvm_tlb_flush_vmid, data->mmu);
+	data->childp = kvm_pte_follow(*old, data->mm_ops);
 	data->anchor = ptep;
 	return 0;
 }
@@ -837,18 +951,24 @@ static int stage2_map_walk_leaf(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 	if (!data->memcache)
 		return -ENOMEM;
 
+	if (!stage2_try_break_pte(ptep, *old, addr, level, shared, data))
+		return -EAGAIN;
+
 	childp = mm_ops->zalloc_page(data->memcache);
-	if (!childp)
+	if (!childp) {
+		/*
+		 * Release the pte if we were unable to install a table to allow
+		 * another thread to make an attempt.
+		 */
+		stage2_make_pte(ptep, 0, data->mm_ops);
 		return -ENOMEM;
+	}
 
 	/*
 	 * If we've run into an existing block mapping then replace it with
 	 * a table. Accesses beyond 'end' that fall within the new table
 	 * will be mapped lazily.
 	 */
-	if (stage2_pte_is_counted(*old))
-		stage2_put_pte(ptep, data->mmu, addr, level, mm_ops);
-
 	kvm_set_table_pte(ptep, childp, mm_ops);
 	mm_ops->get_page(ptep);
 	*old = *ptep;
-- 
2.36.0.rc0.470.gd361397f0d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
