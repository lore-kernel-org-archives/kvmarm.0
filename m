Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 077F8C10F1E
	for <kvmarm@archiver.kernel.org>; Thu,  8 Dec 2022 19:39:43 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A95594BA0F;
	Thu,  8 Dec 2022 14:39:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id N8M8yj+jgFff; Thu,  8 Dec 2022 14:39:41 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A6B14BA21;
	Thu,  8 Dec 2022 14:39:40 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 60A434BA2D
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Dec 2022 14:39:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id V1r7eX1sWguP for <kvmarm@lists.cs.columbia.edu>;
 Thu,  8 Dec 2022 14:39:37 -0500 (EST)
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com
 [209.85.215.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 80F624BA60
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Dec 2022 14:39:31 -0500 (EST)
Received: by mail-pg1-f201.google.com with SMTP id
 q63-20020a632a42000000b0045724b1dfb9so1631333pgq.3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 08 Dec 2022 11:39:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:from:to:cc:subject:date:message-id:reply-to;
 bh=R9LB1ZVMz4QUxz5pvo7qXgMqL6aaiH3Zx5L4jHC3TiM=;
 b=mywUMpb92Kk62g8KyYHaPYWn30FT7swKwMFkNaLBEhkNuRveiOM0s+d7nPhqWh1i20
 qKWH28ZXa9H3ErjccI7/elONDf6HMJv/1AWg+60kRtXloHd5SH/aA/RqLJiocTnzRK+4
 qa/jQ2r9oK1kv9p/wzDB5zVKYlUOpnBkrFdQIT+lXyBj2bLc+7ULy763Z3Fv68nr72wU
 wZ0+1kqAvAm4uefKGOueZXZxwCZCF0d3A8tP6aktlY+sm7wFxKszgnOuav6ixDC1wwUf
 feaUTdtfA74RTkZlBDWknWQ9H1jBlPUp4tvzao/YHBU2Be6WzqIB8r4Ypw1t0aArCdTf
 AMaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=R9LB1ZVMz4QUxz5pvo7qXgMqL6aaiH3Zx5L4jHC3TiM=;
 b=oJ2ZSxse9QFA5tVEG0t4lEV8vY0mWr/MdTsnFM5tPbjgWBWAqOsLy0jDTVuRrLa6KA
 n/CzJbmdilcWygk6Yeq8CjdCjTaX2GwlXOL2Qt7Qdv3eNfeD/9QqFhaKErspDQj3r6EM
 8mmAafSxQqeOQx41q0jUif0h6d7c1bDvwvIISvb615dGzSGavahZZ6mjC1z3t77lZ7eu
 tO1kLy01FrnKMu57QeUbYCGHPYVfJj2Hc36yWJ+j7VWk670UXLrObWZ3ET+nY81kIJGg
 iWGVPcuJEWqXAjy8N4Qdy9C+VrnEhjhuKbcvP2KoluAsqY73fYJviudYu53idRFT04MR
 Jwyw==
X-Gm-Message-State: ANoB5pmsW5hBRVJhaLpBNNCv5YnisJujL5BhYMuwsk0ecmXEuEOBojms
 34qGMRxv7FdemhGyiY3QFq9h2tkyz8lMew==
X-Google-Smtp-Source: AA0mqf5n9lF4ktHiWZ6/n7J28Yg81SXih514CU7QAEeCqTrDG0HULq/c0zXQphuQ/kH7ZrnkeE/ikcBwHWzRug==
X-Received: from dmatlack-n2d-128.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a17:90a:43a4:b0:219:1d0a:34a6 with SMTP
 id r33-20020a17090a43a400b002191d0a34a6mr5768991pjg.1.1670528369971; Thu, 08
 Dec 2022 11:39:29 -0800 (PST)
Date: Thu,  8 Dec 2022 11:38:34 -0800
In-Reply-To: <20221208193857.4090582-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20221208193857.4090582-1-dmatlack@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221208193857.4090582-15-dmatlack@google.com>
Subject: [RFC PATCH 14/37] KVM: MMU: Introduce common macros for TDP page
 tables
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

Introduce macros in common KVM code for dealing with TDP page tables.
TDP page tables are assumed to be PAGE_SIZE with 64-bit PTEs. ARM will
have some nuance, e.g. for root page table concatenation, but that will
be handled separately when the time comes. Furthermore, we can add
arch-specific overrides for any of these macros in the future on a case
by case basis.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/tdp_iter.c | 14 +++++++-------
 arch/x86/kvm/mmu/tdp_iter.h |  3 ++-
 arch/x86/kvm/mmu/tdp_mmu.c  | 24 +++++++++++++-----------
 include/kvm/tdp_pgtable.h   | 21 +++++++++++++++++++++
 4 files changed, 43 insertions(+), 19 deletions(-)
 create mode 100644 include/kvm/tdp_pgtable.h

diff --git a/arch/x86/kvm/mmu/tdp_iter.c b/arch/x86/kvm/mmu/tdp_iter.c
index 4a7d58bf81c4..d6328dac9cd3 100644
--- a/arch/x86/kvm/mmu/tdp_iter.c
+++ b/arch/x86/kvm/mmu/tdp_iter.c
@@ -10,14 +10,15 @@
  */
 static void tdp_iter_refresh_sptep(struct tdp_iter *iter)
 {
-	iter->sptep = iter->pt_path[iter->level - 1] +
-		SPTE_INDEX(iter->gfn << PAGE_SHIFT, iter->level);
+	int pte_index = TDP_PTE_INDEX(iter->gfn, iter->level);
+
+	iter->sptep = iter->pt_path[iter->level - 1] + pte_index;
 	iter->old_spte = kvm_tdp_mmu_read_spte(iter->sptep);
 }
 
 static gfn_t round_gfn_for_level(gfn_t gfn, int level)
 {
-	return gfn & -KVM_PAGES_PER_HPAGE(level);
+	return gfn & -TDP_PAGES_PER_LEVEL(level);
 }
 
 /*
@@ -46,7 +47,7 @@ void tdp_iter_start(struct tdp_iter *iter, struct kvm_mmu_page *root,
 	int root_level = root->role.level;
 
 	WARN_ON(root_level < 1);
-	WARN_ON(root_level > PT64_ROOT_MAX_LEVEL);
+	WARN_ON(root_level > TDP_ROOT_MAX_LEVEL);
 
 	iter->next_last_level_gfn = next_last_level_gfn;
 	iter->root_level = root_level;
@@ -116,11 +117,10 @@ static bool try_step_side(struct tdp_iter *iter)
 	 * Check if the iterator is already at the end of the current page
 	 * table.
 	 */
-	if (SPTE_INDEX(iter->gfn << PAGE_SHIFT, iter->level) ==
-	    (SPTE_ENT_PER_PAGE - 1))
+	if (TDP_PTE_INDEX(iter->gfn, iter->level) == (TDP_PTES_PER_PAGE - 1))
 		return false;
 
-	iter->gfn += KVM_PAGES_PER_HPAGE(iter->level);
+	iter->gfn += TDP_PAGES_PER_LEVEL(iter->level);
 	iter->next_last_level_gfn = iter->gfn;
 	iter->sptep++;
 	iter->old_spte = kvm_tdp_mmu_read_spte(iter->sptep);
diff --git a/arch/x86/kvm/mmu/tdp_iter.h b/arch/x86/kvm/mmu/tdp_iter.h
index 892c078aab58..bfac83ab52db 100644
--- a/arch/x86/kvm/mmu/tdp_iter.h
+++ b/arch/x86/kvm/mmu/tdp_iter.h
@@ -4,6 +4,7 @@
 #define __KVM_X86_MMU_TDP_ITER_H
 
 #include <linux/kvm_host.h>
+#include <kvm/tdp_pgtable.h>
 
 #include "mmu.h"
 #include "spte.h"
@@ -68,7 +69,7 @@ struct tdp_iter {
 	 */
 	gfn_t yielded_gfn;
 	/* Pointers to the page tables traversed to reach the current SPTE */
-	tdp_ptep_t pt_path[PT64_ROOT_MAX_LEVEL];
+	tdp_ptep_t pt_path[TDP_ROOT_MAX_LEVEL];
 	/* A pointer to the current SPTE */
 	tdp_ptep_t sptep;
 	/* The lowest GFN mapped by the current SPTE */
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index bce0566f2d94..a6d6e393c009 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -7,6 +7,8 @@
 #include "tdp_mmu.h"
 #include "spte.h"
 
+#include <kvm/tdp_pgtable.h>
+
 #include <asm/cmpxchg.h>
 #include <trace/events/kvm.h>
 
@@ -428,9 +430,9 @@ static void handle_removed_pt(struct kvm *kvm, tdp_ptep_t pt, bool shared)
 
 	tdp_mmu_unlink_sp(kvm, sp, shared);
 
-	for (i = 0; i < SPTE_ENT_PER_PAGE; i++) {
+	for (i = 0; i < TDP_PTES_PER_PAGE; i++) {
 		tdp_ptep_t sptep = pt + i;
-		gfn_t gfn = base_gfn + i * KVM_PAGES_PER_HPAGE(level);
+		gfn_t gfn = base_gfn + i * TDP_PAGES_PER_LEVEL(level);
 		u64 old_spte;
 
 		if (shared) {
@@ -525,9 +527,9 @@ static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 	bool is_leaf = is_present && is_last_spte(new_spte, level);
 	bool pfn_changed = spte_to_pfn(old_spte) != spte_to_pfn(new_spte);
 
-	WARN_ON(level > PT64_ROOT_MAX_LEVEL);
+	WARN_ON(level > TDP_ROOT_MAX_LEVEL);
 	WARN_ON(level < PG_LEVEL_PTE);
-	WARN_ON(gfn & (KVM_PAGES_PER_HPAGE(level) - 1));
+	WARN_ON(gfn & (TDP_PAGES_PER_LEVEL(level) - 1));
 
 	/*
 	 * If this warning were to trigger it would indicate that there was a
@@ -677,7 +679,7 @@ static inline int tdp_mmu_zap_spte_atomic(struct kvm *kvm,
 		return ret;
 
 	kvm_flush_remote_tlbs_with_address(kvm, iter->gfn,
-					   KVM_PAGES_PER_HPAGE(iter->level));
+					   TDP_PAGES_PER_LEVEL(iter->level));
 
 	/*
 	 * No other thread can overwrite the removed SPTE as they must either
@@ -1075,7 +1077,7 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
 	else if (is_shadow_present_pte(iter->old_spte) &&
 		 !is_last_spte(iter->old_spte, iter->level))
 		kvm_flush_remote_tlbs_with_address(vcpu->kvm, sp->gfn,
-						   KVM_PAGES_PER_HPAGE(iter->level + 1));
+						   TDP_PAGES_PER_LEVEL(iter->level + 1));
 
 	/*
 	 * If the page fault was caused by a write but the page is write
@@ -1355,7 +1357,7 @@ static bool wrprot_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 
 	rcu_read_lock();
 
-	BUG_ON(min_level > KVM_MAX_HUGEPAGE_LEVEL);
+	BUG_ON(min_level > TDP_MAX_HUGEPAGE_LEVEL);
 
 	for_each_tdp_pte_min_level(iter, root, min_level, start, end) {
 retry:
@@ -1469,7 +1471,7 @@ static int tdp_mmu_split_huge_page(struct kvm *kvm, struct tdp_iter *iter,
 	 * No need for atomics when writing to sp->spt since the page table has
 	 * not been linked in yet and thus is not reachable from any other CPU.
 	 */
-	for (i = 0; i < SPTE_ENT_PER_PAGE; i++)
+	for (i = 0; i < TDP_PTES_PER_PAGE; i++)
 		sp->spt[i] = make_huge_page_split_spte(kvm, huge_spte, sp->role, i);
 
 	/*
@@ -1489,7 +1491,7 @@ static int tdp_mmu_split_huge_page(struct kvm *kvm, struct tdp_iter *iter,
 	 * are overwriting from the page stats. But we have to manually update
 	 * the page stats with the new present child pages.
 	 */
-	kvm_update_page_stats(kvm, level - 1, SPTE_ENT_PER_PAGE);
+	kvm_update_page_stats(kvm, level - 1, TDP_PTES_PER_PAGE);
 
 out:
 	trace_kvm_mmu_split_huge_page(iter->gfn, huge_spte, level, ret);
@@ -1731,7 +1733,7 @@ static void zap_collapsible_spte_range(struct kvm *kvm,
 		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, true))
 			continue;
 
-		if (iter.level > KVM_MAX_HUGEPAGE_LEVEL ||
+		if (iter.level > TDP_MAX_HUGEPAGE_LEVEL ||
 		    !is_shadow_present_pte(iter.old_spte))
 			continue;
 
@@ -1793,7 +1795,7 @@ static bool write_protect_gfn(struct kvm *kvm, struct kvm_mmu_page *root,
 	u64 new_spte;
 	bool spte_set = false;
 
-	BUG_ON(min_level > KVM_MAX_HUGEPAGE_LEVEL);
+	BUG_ON(min_level > TDP_MAX_HUGEPAGE_LEVEL);
 
 	rcu_read_lock();
 
diff --git a/include/kvm/tdp_pgtable.h b/include/kvm/tdp_pgtable.h
new file mode 100644
index 000000000000..968be8d92350
--- /dev/null
+++ b/include/kvm/tdp_pgtable.h
@@ -0,0 +1,21 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __KVM_TDP_PGTABLE_H
+#define __KVM_TDP_PGTABLE_H
+
+#include <linux/log2.h>
+#include <linux/mm_types.h>
+
+#define TDP_ROOT_MAX_LEVEL	5
+#define TDP_MAX_HUGEPAGE_LEVEL	PG_LEVEL_PUD
+#define TDP_PTES_PER_PAGE	(PAGE_SIZE / sizeof(u64))
+#define TDP_LEVEL_BITS		ilog2(TDP_PTES_PER_PAGE)
+#define TDP_LEVEL_MASK		((1UL << TDP_LEVEL_BITS) - 1)
+
+#define TDP_LEVEL_SHIFT(level) (((level) - 1) * TDP_LEVEL_BITS)
+
+#define TDP_PAGES_PER_LEVEL(level) (1UL << TDP_LEVEL_SHIFT(level))
+
+#define TDP_PTE_INDEX(gfn, level) \
+	(((gfn) >> TDP_LEVEL_SHIFT(level)) & TDP_LEVEL_MASK)
+
+#endif /* !__KVM_TDP_PGTABLE_H */
-- 
2.39.0.rc1.256.g54fd8350bd-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
