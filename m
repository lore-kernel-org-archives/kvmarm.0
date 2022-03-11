Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 104ADC433F5
	for <kvmarm@archiver.kernel.org>; Fri, 11 Mar 2022 08:48:57 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BEDC049EEA;
	Fri, 11 Mar 2022 03:48:56 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KeEjDX4PVSu7; Fri, 11 Mar 2022 03:48:55 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0414449F5A;
	Fri, 11 Mar 2022 03:48:44 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D6D5540CF5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 19:25:56 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KHewJo42ruaM for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Mar 2022 19:25:55 -0500 (EST)
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com
 [209.85.215.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9317D40C31
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 19:25:55 -0500 (EST)
Received: by mail-pg1-f202.google.com with SMTP id
 b18-20020a63d812000000b0037e1aa59c0bso3774989pgh.12
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 16:25:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=trCyse6kc5VaWQEWZpkBTeyDB9juUOFht/HeyrHGEd0=;
 b=ITUQYvDkX2h3RQafxt+nm82/5781iHDiISy4DhTqmrro4/iNkPMsCBDlg8t8eB6+vW
 WoKsbJ7zeDrbOuwfTkcWOWIHcZkJGUw2d4r+98Smj6dBLngOlw908mgtDChj3UyeFl76
 FyOJizpm4NSOQnGdgQxrZIN82+kY5NHA6X6TJmku0dL5yKt8RAtw/MBwBf3lvsO9ufHQ
 Dqd5AKP8PlHMHCKEXNTDH4MaONsDnd2Q9BRw9Kd7sIUZhnRm7oa9dS0kBigX9ayD9ejf
 EqqRiqfDXYoPw8fi+Fl3DZk+QJK6k5SwEwYznvLftMTTXWKnvbsNNkitPFK/djwTdGSR
 vCjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=trCyse6kc5VaWQEWZpkBTeyDB9juUOFht/HeyrHGEd0=;
 b=Gr2LA6/PBZdbkUy7xFTtwtto2UicXXLMwzFv0FJ1DE/Gw8IY+cqPL25QfkrGrmncOg
 SB+fZL1lM9Aq4Q6bowKG1LZwq6xHy25GKnxujMyaHsS+KEL+DP7PmtpTf/Zfo2BthSnG
 eprxlFlDpVXkWJqj0GybcNsWEq93FINUfyiqYbKwZW8v5w4PjRfHEm68GBBu/DNQo82k
 dvT/jizAuN7fq7dUfPrCoHdEqpbSyNwf74wg2GinL1KGwuKRQrBXl8gQGlsWwQeY04gP
 fWNdsRLuqzjoMUu2aMzn9ZXr/rZja5khAySxkc3OWRv8rm8Uc1Hr2Jwcpsj/Qnis9feI
 lH2g==
X-Gm-Message-State: AOAM530RKebYQP6RgirtgqaV3P+qbnnRPrNAcU8KNFT7qYzA+6aARBm2
 sIf9wR6b3ldrwYe0SwLORzv632WDGFR1pA==
X-Google-Smtp-Source: ABdhPJzvAwzKoOAunNI85/tiPMvRTJXBrV2pzYGx34nWHsviDIj876IlOqB4GDjd2lcrh2rYpRjUo90RjQTUhw==
X-Received: from dmatlack-heavy.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90b:1941:b0:1bf:5440:d716 with SMTP
 id nk1-20020a17090b194100b001bf5440d716mr7787622pjb.147.1646958354821; Thu,
 10 Mar 2022 16:25:54 -0800 (PST)
Date: Fri, 11 Mar 2022 00:25:16 +0000
In-Reply-To: <20220311002528.2230172-1-dmatlack@google.com>
Message-Id: <20220311002528.2230172-15-dmatlack@google.com>
Mime-Version: 1.0
References: <20220311002528.2230172-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v2 14/26] KVM: x86/mmu: Decouple rmap_add() and
 link_shadow_page() from kvm_vcpu
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

Allow adding new entries to the rmap and linking shadow pages without a
struct kvm_vcpu pointer by moving the implementation of rmap_add() and
link_shadow_page() into inner helper functions.

No functional change intended.

Reviewed-by: Ben Gardon <bgardon@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 43 +++++++++++++++++++++++++++---------------
 1 file changed, 28 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index d7ad71be6c52..c57070ed157d 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -725,9 +725,9 @@ static void mmu_free_memory_caches(struct kvm_vcpu *vcpu)
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_header_cache);
 }
 
-static struct pte_list_desc *mmu_alloc_pte_list_desc(struct kvm_vcpu *vcpu)
+static struct pte_list_desc *mmu_alloc_pte_list_desc(struct kvm_mmu_memory_cache *cache)
 {
-	return kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_pte_list_desc_cache);
+	return kvm_mmu_memory_cache_alloc(cache);
 }
 
 static void mmu_free_pte_list_desc(struct pte_list_desc *pte_list_desc)
@@ -874,7 +874,7 @@ gfn_to_memslot_dirty_bitmap(struct kvm_vcpu *vcpu, gfn_t gfn,
 /*
  * Returns the number of pointers in the rmap chain, not counting the new one.
  */
-static int pte_list_add(struct kvm_vcpu *vcpu, u64 *spte,
+static int pte_list_add(struct kvm_mmu_memory_cache *cache, u64 *spte,
 			struct kvm_rmap_head *rmap_head)
 {
 	struct pte_list_desc *desc;
@@ -885,7 +885,7 @@ static int pte_list_add(struct kvm_vcpu *vcpu, u64 *spte,
 		rmap_head->val = (unsigned long)spte;
 	} else if (!(rmap_head->val & 1)) {
 		rmap_printk("%p %llx 1->many\n", spte, *spte);
-		desc = mmu_alloc_pte_list_desc(vcpu);
+		desc = mmu_alloc_pte_list_desc(cache);
 		desc->sptes[0] = (u64 *)rmap_head->val;
 		desc->sptes[1] = spte;
 		desc->spte_count = 2;
@@ -897,7 +897,7 @@ static int pte_list_add(struct kvm_vcpu *vcpu, u64 *spte,
 		while (desc->spte_count == PTE_LIST_EXT) {
 			count += PTE_LIST_EXT;
 			if (!desc->more) {
-				desc->more = mmu_alloc_pte_list_desc(vcpu);
+				desc->more = mmu_alloc_pte_list_desc(cache);
 				desc = desc->more;
 				desc->spte_count = 0;
 				break;
@@ -1596,8 +1596,10 @@ static bool kvm_test_age_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
 
 #define RMAP_RECYCLE_THRESHOLD 1000
 
-static void rmap_add(struct kvm_vcpu *vcpu, const struct kvm_memory_slot *slot,
-		     u64 *spte, gfn_t gfn)
+static void __rmap_add(struct kvm *kvm,
+		       struct kvm_mmu_memory_cache *cache,
+		       const struct kvm_memory_slot *slot,
+		       u64 *spte, gfn_t gfn)
 {
 	struct kvm_mmu_page *sp;
 	struct kvm_rmap_head *rmap_head;
@@ -1606,15 +1608,21 @@ static void rmap_add(struct kvm_vcpu *vcpu, const struct kvm_memory_slot *slot,
 	sp = sptep_to_sp(spte);
 	kvm_mmu_page_set_gfn(sp, spte - sp->spt, gfn);
 	rmap_head = gfn_to_rmap(gfn, sp->role.level, slot);
-	rmap_count = pte_list_add(vcpu, spte, rmap_head);
+	rmap_count = pte_list_add(cache, spte, rmap_head);
 
 	if (rmap_count > RMAP_RECYCLE_THRESHOLD) {
-		kvm_unmap_rmapp(vcpu->kvm, rmap_head, NULL, gfn, sp->role.level, __pte(0));
+		kvm_unmap_rmapp(kvm, rmap_head, NULL, gfn, sp->role.level, __pte(0));
 		kvm_flush_remote_tlbs_with_address(
-				vcpu->kvm, sp->gfn, KVM_PAGES_PER_HPAGE(sp->role.level));
+				kvm, sp->gfn, KVM_PAGES_PER_HPAGE(sp->role.level));
 	}
 }
 
+static void rmap_add(struct kvm_vcpu *vcpu, const struct kvm_memory_slot *slot,
+		     u64 *spte, gfn_t gfn)
+{
+	__rmap_add(vcpu->kvm, &vcpu->arch.mmu_pte_list_desc_cache, slot, spte, gfn);
+}
+
 bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	bool young = false;
@@ -1682,13 +1690,13 @@ static unsigned kvm_page_table_hashfn(gfn_t gfn)
 	return hash_64(gfn, KVM_MMU_HASH_SHIFT);
 }
 
-static void mmu_page_add_parent_pte(struct kvm_vcpu *vcpu,
+static void mmu_page_add_parent_pte(struct kvm_mmu_memory_cache *cache,
 				    struct kvm_mmu_page *sp, u64 *parent_pte)
 {
 	if (!parent_pte)
 		return;
 
-	pte_list_add(vcpu, parent_pte, &sp->parent_ptes);
+	pte_list_add(cache, parent_pte, &sp->parent_ptes);
 }
 
 static void mmu_page_remove_parent_pte(struct kvm_mmu_page *sp,
@@ -2307,8 +2315,8 @@ static void shadow_walk_next(struct kvm_shadow_walk_iterator *iterator)
 	__shadow_walk_next(iterator, *iterator->sptep);
 }
 
-static void link_shadow_page(struct kvm_vcpu *vcpu, u64 *sptep,
-			     struct kvm_mmu_page *sp)
+static void __link_shadow_page(struct kvm_mmu_memory_cache *cache, u64 *sptep,
+			       struct kvm_mmu_page *sp)
 {
 	u64 spte;
 
@@ -2318,12 +2326,17 @@ static void link_shadow_page(struct kvm_vcpu *vcpu, u64 *sptep,
 
 	mmu_spte_set(sptep, spte);
 
-	mmu_page_add_parent_pte(vcpu, sp, sptep);
+	mmu_page_add_parent_pte(cache, sp, sptep);
 
 	if (sp->unsync_children || sp->unsync)
 		mark_unsync(sptep);
 }
 
+static void link_shadow_page(struct kvm_vcpu *vcpu, u64 *sptep, struct kvm_mmu_page *sp)
+{
+	__link_shadow_page(&vcpu->arch.mmu_pte_list_desc_cache, sptep, sp);
+}
+
 static void validate_direct_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 				   unsigned direct_access)
 {
-- 
2.35.1.723.g4982287a31-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
