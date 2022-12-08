Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 858828F6F
	for <kvmarm@lists.linux.dev>; Thu,  8 Dec 2022 19:39:46 +0000 (UTC)
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-36810cfa61fso24779557b3.6
        for <kvmarm@lists.linux.dev>; Thu, 08 Dec 2022 11:39:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2pwzA4f8rtWUlHUGqnsAy0IX27mj+6SK4MtkmoP+7nc=;
        b=YNpQc6sfSqCzVxX+98b5Qnwj8wuyxxhqDjbjg0/heAwG3DRXzEldN1gIKGBIFpCp7T
         oDiD8aBh93F2gLJVmOT2ym3C645P/yw3/XHnbYeSTumbSBmY7zP00GflN7tkMmxLNmBe
         Eyj0CiSk43Q0LoHiRlqBC5JjuC34iLtd/5dBrLWEX3UnGsxMKEST/caxuMEWJUYebKOs
         nehVMqmtND0ojhbibus4NQMbYsHvqfsKKAwwxf22ZCzh3h0VLEy5xqHZhA2pY9RcqW5/
         lncbITNr2DhMHSX1upupeaJKLUSgu3cZnHc3xOSkN7l8rOc8bBbyrfwrBPoClODvZ2W8
         9Y3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2pwzA4f8rtWUlHUGqnsAy0IX27mj+6SK4MtkmoP+7nc=;
        b=gGpa/fCHnG2i1C+Jb5k1LMbYAgD/lnRh6U2qI1jHXCn+qNCxiUYqxtIRJd8lPhEuxJ
         L099qNP3ZxonujoN4KsSTGfzat4kxdG8oL8gwTTx7cPQdUv5QgI34n81LxsbzluWS10h
         z2UJLiCfGge0IM8qQdXCS9fYt/aykBKiacVy9mQCvziR3Jg3gfiot346MS1V2f8R1+Y8
         bzpzINRouDq3k7u/mCDCJ3LWYuJo5N8eQ88gyNKM+wxufTGWH6aV5FUwQFuprM52egzR
         BMX0Q8YXjzBhXCBfda+buDhFI9cMc6TKbgydg5p2nLW2Pjq0b+aqD2+scPHEA6ELYQ2F
         tUQA==
X-Gm-Message-State: ANoB5plgvVzLYKtKWN1sJ9+DPeUYzUJmhxaH6Ihapvsx9BCy5M53CYZo
	Rg8FugjE4SZCyLwlPBeba/TKgdeTjxm4nA==
X-Google-Smtp-Source: AA0mqf63ChKxDkB73Q9eiHNZK/23L+Sw7TYmaHPIE3+6BorfXLWgR+rJnoRzaO6YbXrC3TqNmiAKa46Ml3GFRw==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a25:ed05:0:b0:6c4:8a9:e4d2 with SMTP id
 k5-20020a25ed05000000b006c408a9e4d2mr92058723ybh.164.1670528385572; Thu, 08
 Dec 2022 11:39:45 -0800 (PST)
Date: Thu,  8 Dec 2022 11:38:43 -0800
In-Reply-To: <20221208193857.4090582-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20221208193857.4090582-1-dmatlack@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221208193857.4090582-24-dmatlack@google.com>
Subject: [RFC PATCH 23/37] KVM: MMU: Move VM-level TDP MMU state to struct kvm
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Huacai Chen <chenhuacai@kernel.org>, 
	Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Sean Christopherson <seanjc@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Matlack <dmatlack@google.com>, Anshuman Khandual <anshuman.khandual@arm.com>, 
	Nadav Amit <namit@vmware.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Vlastimil Babka <vbabka@suse.cz>, 
	"Liam R. Howlett" <Liam.Howlett@Oracle.com>, Suren Baghdasaryan <surenb@google.com>, 
	Peter Xu <peterx@redhat.com>, xu xin <cgel.zte@gmail.com>, Arnd Bergmann <arnd@arndb.de>, 
	Yu Zhao <yuzhao@google.com>, Colin Cross <ccross@google.com>, Hugh Dickins <hughd@google.com>, 
	Ben Gardon <bgardon@google.com>, Mingwei Zhang <mizhang@google.com>, 
	Krish Sadhukhan <krish.sadhukhan@oracle.com>, Ricardo Koller <ricarkol@google.com>, 
	Jing Zhang <jingzhangos@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu, 
	linux-mips@vger.kernel.org, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20221208193843.CnuM-mH7Vn8l3ld1m061ky5KBU7DIIcW0NxHwlaLFsg@z>

Move VM-level TDP MMU state to struct kvm so it can be accessed by
common code in a future commit.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/include/asm/kvm_host.h | 39 --------------------------------
 arch/x86/kvm/mmu/tdp_mmu.c      | 40 ++++++++++++++++-----------------
 arch/x86/kvm/mmu/tdp_pgtable.c  |  8 +++----
 include/kvm/mmu_types.h         | 40 +++++++++++++++++++++++++++++++++
 include/linux/kvm_host.h        |  8 +++++++
 5 files changed, 72 insertions(+), 63 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 9cf8f956bac3..95c731028452 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1272,45 +1272,6 @@ struct kvm_arch {
 	struct kvm_pmu_event_filter __rcu *pmu_event_filter;
 	struct task_struct *nx_huge_page_recovery_thread;
 
-#ifdef CONFIG_X86_64
-	/* The number of TDP MMU pages across all roots. */
-	atomic64_t tdp_mmu_pages;
-
-	/*
-	 * List of struct kvm_mmu_pages being used as roots.
-	 * All struct kvm_mmu_pages in the list should have
-	 * tdp_mmu_page set.
-	 *
-	 * For reads, this list is protected by:
-	 *	the MMU lock in read mode + RCU or
-	 *	the MMU lock in write mode
-	 *
-	 * For writes, this list is protected by:
-	 *	the MMU lock in read mode + the tdp_mmu_pages_lock or
-	 *	the MMU lock in write mode
-	 *
-	 * Roots will remain in the list until their tdp_mmu_root_count
-	 * drops to zero, at which point the thread that decremented the
-	 * count to zero should removed the root from the list and clean
-	 * it up, freeing the root after an RCU grace period.
-	 */
-	struct list_head tdp_mmu_roots;
-
-	/*
-	 * Protects accesses to the following fields when the MMU lock
-	 * is held in read mode:
-	 *  - tdp_mmu_roots (above)
-	 *  - the link field of kvm_mmu_page structs used by the TDP MMU
-	 *  - possible_nx_huge_pages;
-	 *  - the possible_nx_huge_page_link field of kvm_mmu_page structs used
-	 *    by the TDP MMU
-	 * It is acceptable, but not necessary, to acquire this lock when
-	 * the thread holds the MMU lock in write mode.
-	 */
-	spinlock_t tdp_mmu_pages_lock;
-	struct workqueue_struct *tdp_mmu_zap_wq;
-#endif /* CONFIG_X86_64 */
-
 	/*
 	 * If set, at least one shadow root has been allocated. This flag
 	 * is used as one input when determining whether certain memslot
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 24d1dbd0a1ec..b997f84c0ea7 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -21,9 +21,9 @@ int kvm_mmu_init_tdp_mmu(struct kvm *kvm)
 	if (!wq)
 		return -ENOMEM;
 
-	INIT_LIST_HEAD(&kvm->arch.tdp_mmu_roots);
-	spin_lock_init(&kvm->arch.tdp_mmu_pages_lock);
-	kvm->arch.tdp_mmu_zap_wq = wq;
+	INIT_LIST_HEAD(&kvm->tdp_mmu.roots);
+	spin_lock_init(&kvm->tdp_mmu.pages_lock);
+	kvm->tdp_mmu.zap_wq = wq;
 	return 1;
 }
 
@@ -42,10 +42,10 @@ static __always_inline bool kvm_lockdep_assert_mmu_lock_held(struct kvm *kvm,
 void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
 {
 	/* Also waits for any queued work items.  */
-	destroy_workqueue(kvm->arch.tdp_mmu_zap_wq);
+	destroy_workqueue(kvm->tdp_mmu.zap_wq);
 
-	WARN_ON(atomic64_read(&kvm->arch.tdp_mmu_pages));
-	WARN_ON(!list_empty(&kvm->arch.tdp_mmu_roots));
+	WARN_ON(atomic64_read(&kvm->tdp_mmu.pages));
+	WARN_ON(!list_empty(&kvm->tdp_mmu.roots));
 
 	/*
 	 * Ensure that all the outstanding RCU callbacks to free shadow pages
@@ -114,7 +114,7 @@ static void tdp_mmu_schedule_zap_root(struct kvm *kvm, struct kvm_mmu_page *root
 {
 	root->tdp_mmu_async_data = kvm;
 	INIT_WORK(&root->tdp_mmu_async_work, tdp_mmu_zap_root_work);
-	queue_work(kvm->arch.tdp_mmu_zap_wq, &root->tdp_mmu_async_work);
+	queue_work(kvm->tdp_mmu.zap_wq, &root->tdp_mmu_async_work);
 }
 
 static inline bool kvm_tdp_root_mark_invalid(struct kvm_mmu_page *page)
@@ -173,9 +173,9 @@ void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root,
 		return;
 	}
 
-	spin_lock(&kvm->arch.tdp_mmu_pages_lock);
+	spin_lock(&kvm->tdp_mmu.pages_lock);
 	list_del_rcu(&root->link);
-	spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
+	spin_unlock(&kvm->tdp_mmu.pages_lock);
 	call_rcu(&root->rcu_head, tdp_mmu_free_sp_rcu_callback);
 }
 
@@ -198,11 +198,11 @@ static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
 	rcu_read_lock();
 
 	if (prev_root)
-		next_root = list_next_or_null_rcu(&kvm->arch.tdp_mmu_roots,
+		next_root = list_next_or_null_rcu(&kvm->tdp_mmu.roots,
 						  &prev_root->link,
 						  typeof(*prev_root), link);
 	else
-		next_root = list_first_or_null_rcu(&kvm->arch.tdp_mmu_roots,
+		next_root = list_first_or_null_rcu(&kvm->tdp_mmu.roots,
 						   typeof(*next_root), link);
 
 	while (next_root) {
@@ -210,7 +210,7 @@ static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
 		    kvm_tdp_mmu_get_root(next_root))
 			break;
 
-		next_root = list_next_or_null_rcu(&kvm->arch.tdp_mmu_roots,
+		next_root = list_next_or_null_rcu(&kvm->tdp_mmu.roots,
 				&next_root->link, typeof(*next_root), link);
 	}
 
@@ -254,7 +254,7 @@ static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
  * is guaranteed to be stable.
  */
 #define for_each_tdp_mmu_root(_kvm, _root, _as_id)			\
-	list_for_each_entry(_root, &_kvm->arch.tdp_mmu_roots, link)	\
+	list_for_each_entry(_root, &_kvm->tdp_mmu.roots, link)	\
 		if (kvm_lockdep_assert_mmu_lock_held(_kvm, false) &&	\
 		    _root->role.as_id != _as_id) {		\
 		} else
@@ -324,9 +324,9 @@ hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
 
 	refcount_set(&root->root_refcount, 1);
 
-	spin_lock(&kvm->arch.tdp_mmu_pages_lock);
-	list_add_rcu(&root->link, &kvm->arch.tdp_mmu_roots);
-	spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
+	spin_lock(&kvm->tdp_mmu.pages_lock);
+	list_add_rcu(&root->link, &kvm->tdp_mmu.roots);
+	spin_unlock(&kvm->tdp_mmu.pages_lock);
 
 out:
 	return __pa(root->spt);
@@ -368,13 +368,13 @@ static void handle_changed_spte_dirty_log(struct kvm *kvm, int as_id, gfn_t gfn,
 static void tdp_account_mmu_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
 	kvm_account_pgtable_pages((void *)sp->spt, +1);
-	atomic64_inc(&kvm->arch.tdp_mmu_pages);
+	atomic64_inc(&kvm->tdp_mmu.pages);
 }
 
 static void tdp_unaccount_mmu_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
 	kvm_account_pgtable_pages((void *)sp->spt, -1);
-	atomic64_dec(&kvm->arch.tdp_mmu_pages);
+	atomic64_dec(&kvm->tdp_mmu.pages);
 }
 
 __weak void tdp_mmu_arch_unlink_sp(struct kvm *kvm, struct kvm_mmu_page *sp,
@@ -1010,7 +1010,7 @@ void kvm_tdp_mmu_zap_all(struct kvm *kvm)
  */
 void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm)
 {
-	flush_workqueue(kvm->arch.tdp_mmu_zap_wq);
+	flush_workqueue(kvm->tdp_mmu.zap_wq);
 }
 
 /*
@@ -1035,7 +1035,7 @@ void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm)
 	struct kvm_mmu_page *root;
 
 	lockdep_assert_held_write(&kvm->mmu_lock);
-	list_for_each_entry(root, &kvm->arch.tdp_mmu_roots, link) {
+	list_for_each_entry(root, &kvm->tdp_mmu.roots, link) {
 		if (!root->role.invalid &&
 		    !WARN_ON_ONCE(!kvm_tdp_mmu_get_root(root))) {
 			root->role.invalid = true;
diff --git a/arch/x86/kvm/mmu/tdp_pgtable.c b/arch/x86/kvm/mmu/tdp_pgtable.c
index 840d063c45b8..cc7b10f703e1 100644
--- a/arch/x86/kvm/mmu/tdp_pgtable.c
+++ b/arch/x86/kvm/mmu/tdp_pgtable.c
@@ -141,9 +141,9 @@ void tdp_mmu_arch_post_link_sp(struct kvm *kvm,
 	if (fault->req_level < sp->role.level)
 		return;
 
-	spin_lock(&kvm->arch.tdp_mmu_pages_lock);
+	spin_lock(&kvm->tdp_mmu.pages_lock);
 	track_possible_nx_huge_page(kvm, sp);
-	spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
+	spin_unlock(&kvm->tdp_mmu.pages_lock);
 }
 
 void tdp_mmu_arch_unlink_sp(struct kvm *kvm, struct kvm_mmu_page *sp,
@@ -153,7 +153,7 @@ void tdp_mmu_arch_unlink_sp(struct kvm *kvm, struct kvm_mmu_page *sp,
 		return;
 
 	if (shared)
-		spin_lock(&kvm->arch.tdp_mmu_pages_lock);
+		spin_lock(&kvm->tdp_mmu.pages_lock);
 	else
 		lockdep_assert_held_write(&kvm->mmu_lock);
 
@@ -161,7 +161,7 @@ void tdp_mmu_arch_unlink_sp(struct kvm *kvm, struct kvm_mmu_page *sp,
 	untrack_possible_nx_huge_page(kvm, sp);
 
 	if (shared)
-		spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
+		spin_unlock(&kvm->tdp_mmu.pages_lock);
 }
 
 int tdp_mmu_max_mapping_level(struct kvm *kvm,
diff --git a/include/kvm/mmu_types.h b/include/kvm/mmu_types.h
index 07c9962f9aea..8ccc48a1cd4c 100644
--- a/include/kvm/mmu_types.h
+++ b/include/kvm/mmu_types.h
@@ -136,4 +136,44 @@ enum {
 	RET_PF_SPURIOUS,
 };
 
+struct tdp_mmu {
+	/* The number of TDP MMU pages across all roots. */
+	atomic64_t pages;
+
+	/*
+	 * List of kvm_mmu_page structs being used as roots.
+	 * All kvm_mmu_page structs in the list should have
+	 * tdp_mmu_page set.
+	 *
+	 * For reads, this list is protected by:
+	 *	the MMU lock in read mode + RCU or
+	 *	the MMU lock in write mode
+	 *
+	 * For writes, this list is protected by:
+	 *	the MMU lock in read mode + the tdp_mmu_pages_lock or
+	 *	the MMU lock in write mode
+	 *
+	 * Roots will remain in the list until their tdp_mmu_root_count
+	 * drops to zero, at which point the thread that decremented the
+	 * count to zero should removed the root from the list and clean
+	 * it up, freeing the root after an RCU grace period.
+	 */
+	struct list_head roots;
+
+	/*
+	 * Protects accesses to the following fields when the MMU lock
+	 * is held in read mode:
+	 *  - roots (above)
+	 *  - the link field of kvm_mmu_page structs used by the TDP MMU
+	 *  - (x86-only) possible_nx_huge_pages;
+	 *  - (x86-only) the arch.possible_nx_huge_page_link field of
+	 *    kvm_mmu_page structs used by the TDP MMU
+	 * It is acceptable, but not necessary, to acquire this lock when
+	 * the thread holds the MMU lock in write mode.
+	 */
+	spinlock_t pages_lock;
+
+	struct workqueue_struct *zap_wq;
+};
+
 #endif /* !__KVM_MMU_TYPES_H */
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 469ff4202a0d..242eaed55320 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -45,6 +45,10 @@
 #include <asm/kvm_host.h>
 #include <linux/kvm_dirty_ring.h>
 
+#ifdef CONFIG_HAVE_TDP_MMU
+#include <kvm/mmu_types.h>
+#endif
+
 #ifndef KVM_MAX_VCPU_IDS
 #define KVM_MAX_VCPU_IDS KVM_MAX_VCPUS
 #endif
@@ -797,6 +801,10 @@ struct kvm {
 	struct notifier_block pm_notifier;
 #endif
 	char stats_id[KVM_STATS_NAME_SIZE];
+
+#ifdef CONFIG_HAVE_TDP_MMU
+	struct tdp_mmu tdp_mmu;
+#endif
 };
 
 #define kvm_err(fmt, ...) \
-- 
2.39.0.rc1.256.g54fd8350bd-goog

