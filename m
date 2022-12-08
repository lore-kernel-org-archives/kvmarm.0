Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4D5FC4167B
	for <kvmarm@archiver.kernel.org>; Thu,  8 Dec 2022 19:39:38 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A7524BA0E;
	Thu,  8 Dec 2022 14:39:38 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YO0i9nzAJXoU; Thu,  8 Dec 2022 14:39:38 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D835C4BA7C;
	Thu,  8 Dec 2022 14:39:31 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3DD354BA0A
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Dec 2022 14:39:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fVqRQgdxLW22 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  8 Dec 2022 14:39:30 -0500 (EST)
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com
 [209.85.128.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5A2824BA18
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Dec 2022 14:39:27 -0500 (EST)
Received: by mail-yw1-f201.google.com with SMTP id
 00721157ae682-3d0465d32deso25005507b3.20
 for <kvmarm@lists.cs.columbia.edu>; Thu, 08 Dec 2022 11:39:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:from:to:cc:subject:date:message-id:reply-to;
 bh=T0+hU8k+RyCmVBvBo6qJA+pYHpeWz4BnzaTdktBKy2A=;
 b=j2HX3lJ7u8ucEzkeGBQfuBx9Yb7N2Qy9oTH39ulAVDzwqd+G0fIW4WjnRqotxR/RTx
 o/pna9eXTXuMdJmAYL1UVpM36PkT4GZM2h0bpfrNAurm7bBa7yOIol4vLsYL261GeqzA
 3HOdEsZ41tJib1TeC34Adynr+Edi81xeW1SDkV4CdXiQGoTOGOVJ4WxSxzRqIQRX0/iB
 RSZpalWLzZZk3q25mDyKyCcOP/lgTKFRKvpNiWk49MLHspz7m3Pd9fzp8sxVKQa7WFIV
 Cq+v/eIrOgIUSWXVgUqA7VpSfMfnDwSrS/lkhXxrcLWaE6ZViWl/62plvpN2oVhZ91U+
 +4vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=T0+hU8k+RyCmVBvBo6qJA+pYHpeWz4BnzaTdktBKy2A=;
 b=AFUejCpxGCLYw/SpIOucPUl+REnxYqqdCHSHXUgxWn+yhrDgwdQb5Re2s+y+Vq7PFe
 x1Kz5y94zmBEJIegc8vUZGWNf5005Fn0VoZY2AXUdduiWRFvZhP0EpcaRPp8WtzSHPcI
 InB3jvPgfS/UH+Nk1kI7Pq0brX2eWEoSUOWTXwTtCl5GkkY9V/iqBlSKktF5BfJHE+sV
 MNBMqUj/hIJV1bsj+iTs5e+6iHnj1UzyfY7M1e/vrZLIh4MNFeQTIFx4tld4Oirlfhlc
 AMv6xWiohKKcO3z+b9mhQ6KCDdq0ppt8rzPg2pSepgXt/2+BPDbdjfTTNK4Ls1uE/0Ah
 rDlA==
X-Gm-Message-State: ANoB5pkGsQ51+RTQEtJD6UvqrUjRK3KyOqtnzRvDe9OxNgfFr0OgHiyx
 xqYB6IsXL56IL3Nx1sLBYpPKwg76TUpnag==
X-Google-Smtp-Source: AA0mqf4KN0ToQ1wmZzmflZp36b4L5Nl4FpG0VJHdW80YwtBlwu869ju+Ri2dl6OmwZR+dYAtfRM+xdMRlNvXFw==
X-Received: from dmatlack-n2d-128.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a25:6994:0:b0:6f3:c535:4ea3 with SMTP id
 e142-20020a256994000000b006f3c5354ea3mr55731660ybc.498.1670528366862; Thu, 08
 Dec 2022 11:39:26 -0800 (PST)
Date: Thu,  8 Dec 2022 11:38:32 -0800
In-Reply-To: <20221208193857.4090582-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20221208193857.4090582-1-dmatlack@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221208193857.4090582-13-dmatlack@google.com>
Subject: [RFC PATCH 12/37] KVM: x86/mmu: Use PG_LEVEL_{PTE, PMD,
 PUD} in the TDP MMU
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

Use PG_LEVEL_{PTE,PMD,PUD} in the TDP MMU instead of the x86-specific
PG_LEVEL_{4K,2M,1G} aliases. This prepares for moving the TDP MMU to
common code, where not all architectures will have 4K PAGE_SIZE.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/tdp_iter.h |  2 +-
 arch/x86/kvm/mmu/tdp_mmu.c  | 16 ++++++++--------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_iter.h b/arch/x86/kvm/mmu/tdp_iter.h
index f0af385c56e0..892c078aab58 100644
--- a/arch/x86/kvm/mmu/tdp_iter.h
+++ b/arch/x86/kvm/mmu/tdp_iter.h
@@ -106,7 +106,7 @@ struct tdp_iter {
 	     tdp_iter_next(&iter))
 
 #define for_each_tdp_pte(iter, root, start, end) \
-	for_each_tdp_pte_min_level(iter, root, PG_LEVEL_4K, start, end)
+	for_each_tdp_pte_min_level(iter, root, PG_LEVEL_PTE, start, end)
 
 tdp_ptep_t spte_to_child_pt(u64 pte, int level);
 
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 4940413d3767..bce0566f2d94 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -347,7 +347,7 @@ static void handle_changed_spte_dirty_log(struct kvm *kvm, int as_id, gfn_t gfn,
 	bool pfn_changed;
 	struct kvm_memory_slot *slot;
 
-	if (level > PG_LEVEL_4K)
+	if (level > PG_LEVEL_PTE)
 		return;
 
 	pfn_changed = spte_to_pfn(old_spte) != spte_to_pfn(new_spte);
@@ -526,7 +526,7 @@ static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 	bool pfn_changed = spte_to_pfn(old_spte) != spte_to_pfn(new_spte);
 
 	WARN_ON(level > PT64_ROOT_MAX_LEVEL);
-	WARN_ON(level < PG_LEVEL_4K);
+	WARN_ON(level < PG_LEVEL_PTE);
 	WARN_ON(gfn & (KVM_PAGES_PER_HPAGE(level) - 1));
 
 	/*
@@ -897,9 +897,9 @@ static void tdp_mmu_zap_root(struct kvm *kvm, struct kvm_mmu_page *root,
 	 * inducing a stall to allow in-place replacement with a 1gb hugepage.
 	 *
 	 * Because zapping a SP recurses on its children, stepping down to
-	 * PG_LEVEL_4K in the iterator itself is unnecessary.
+	 * PG_LEVEL_PTE in the iterator itself is unnecessary.
 	 */
-	__tdp_mmu_zap_root(kvm, root, shared, PG_LEVEL_1G);
+	__tdp_mmu_zap_root(kvm, root, shared, PG_LEVEL_PUD);
 	__tdp_mmu_zap_root(kvm, root, shared, root->role.level);
 
 	rcu_read_unlock();
@@ -944,7 +944,7 @@ static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
 
 	rcu_read_lock();
 
-	for_each_tdp_pte_min_level(iter, root, PG_LEVEL_4K, start, end) {
+	for_each_tdp_pte_min_level(iter, root, PG_LEVEL_PTE, start, end) {
 		if (can_yield &&
 		    tdp_mmu_iter_cond_resched(kvm, &iter, flush, false)) {
 			flush = false;
@@ -1303,7 +1303,7 @@ static bool set_spte_gfn(struct kvm *kvm, struct tdp_iter *iter,
 	/* Huge pages aren't expected to be modified without first being zapped. */
 	WARN_ON(pte_huge(range->pte) || range->start + 1 != range->end);
 
-	if (iter->level != PG_LEVEL_4K ||
+	if (iter->level != PG_LEVEL_PTE ||
 	    !is_shadow_present_pte(iter->old_spte))
 		return false;
 
@@ -1672,7 +1672,7 @@ static void clear_dirty_pt_masked(struct kvm *kvm, struct kvm_mmu_page *root,
 		if (!mask)
 			break;
 
-		if (iter.level > PG_LEVEL_4K ||
+		if (iter.level > PG_LEVEL_PTE ||
 		    !(mask & (1UL << (iter.gfn - gfn))))
 			continue;
 
@@ -1726,7 +1726,7 @@ static void zap_collapsible_spte_range(struct kvm *kvm,
 
 	rcu_read_lock();
 
-	for_each_tdp_pte_min_level(iter, root, PG_LEVEL_2M, start, end) {
+	for_each_tdp_pte_min_level(iter, root, PG_LEVEL_PMD, start, end) {
 retry:
 		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, true))
 			continue;
-- 
2.39.0.rc1.256.g54fd8350bd-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
