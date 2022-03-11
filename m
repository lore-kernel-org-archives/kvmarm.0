Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 197F8C433F5
	for <kvmarm@archiver.kernel.org>; Fri, 11 Mar 2022 08:48:59 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CEEF149EE9;
	Fri, 11 Mar 2022 03:48:58 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bKcBhEidKo1Y; Fri, 11 Mar 2022 03:48:57 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 448F54A100;
	Fri, 11 Mar 2022 03:48:44 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5A23F40C52
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 19:26:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Xt-bVNZ8K98l for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Mar 2022 19:25:59 -0500 (EST)
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com
 [209.85.214.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EDBA040C31
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 19:25:58 -0500 (EST)
Received: by mail-pl1-f202.google.com with SMTP id
 c10-20020a170902d48a00b00151cf8ca3c7so3584401plg.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 16:25:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=ka577/Q99IMPRmJNwySEEB2HMNKyat5/nl7Ts9gRTDM=;
 b=MmYv+Rj5M/jSA2Ff3Se9bCgVKVRkMDvLGNqA7/gNeGpPE0ht9lEIJgS6sNOVq+Isze
 t/ymOK2sA9B+I6DLxG3QrvMdNOMB/bjitaErkmLNQdjFHfhqwPodK3Fhn1Iy2OHyZ19J
 5pvzZRrcyKDFIzF+9U3G3rHK1TKLHSkn75JCz3/eLj1NRJMZjsJjl7asO8iIxU+bqDR1
 AYieclXsjJ2XD32DoSZzMdRBwub12+YWqqm58qZ5yAEkYAG//8Tbv+dJgpHwu7EWTEsg
 NrL7n22PSbZf8iAQ9yMWfEsxDeZ/uzEubqfKjv2lpliaUMobGoZLYL4e5QsrRZFNOD0Q
 PuoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=ka577/Q99IMPRmJNwySEEB2HMNKyat5/nl7Ts9gRTDM=;
 b=uui8IitXdLR9l39ccGXAHqupPmvBVE+q1yjoBliCRR5VE8YXirgpAq7djmFWujVqCv
 mpC5u6pUpCur5MKR74BlbYUnJ1x9fRq3nbP7TMLEg2uklI1+PQXBfbgjnsYfDI7rQOvK
 tlVyH6n+g+MnRstOaWtOebkPFoZkTTHmdLC/vp7PXsOlLYQzv+SVLfO3XHFbHBj6kBc3
 BeAEqpQI8AiN3uTYyN/6Oc0trkNnIJiErTgrwkTzbKHmESMGRIFLtFKkqKj2/NS3eRnK
 lDauW4asxdQZm5wxcWqyKxihLdeoxjxz3r277xxz1HpaEqycUIoixSar/+979cW+czfb
 NaSQ==
X-Gm-Message-State: AOAM531wHfp7+OF0fk8zPXYGvrigd3tnJT8fKBNs1HaLuKPGlkLGK7qK
 VT6bC/FO2tRmGTcildCHnolkI3Ucv3A4xQ==
X-Google-Smtp-Source: ABdhPJxl1HbbReF9yQU4eyO9gbHYGhz96P3jHX6CHhtVHS6VGFBY3jktqYgtMbP+C8rBBM+D/bObxNupHpMttA==
X-Received: from dmatlack-heavy.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:903:120e:b0:151:71e4:dadf with SMTP
 id l14-20020a170903120e00b0015171e4dadfmr7886863plh.48.1646958358116; Thu, 10
 Mar 2022 16:25:58 -0800 (PST)
Date: Fri, 11 Mar 2022 00:25:18 +0000
In-Reply-To: <20220311002528.2230172-1-dmatlack@google.com>
Message-Id: <20220311002528.2230172-17-dmatlack@google.com>
Mime-Version: 1.0
References: <20220311002528.2230172-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v2 16/26] KVM: x86/mmu: Cache the access bits of shadowed
 translations
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

In order to split a huge page we need to know what access bits to assign
to the role of the new child page table. This can't be easily derived
from the huge page SPTE itself since KVM applies its own access policies
on top, such as for HugePage NX.

We could walk the guest page tables to determine the correct access
bits, but that is difficult to plumb outside of a vCPU fault context.
Instead, we can store the original access bits for each leaf SPTE
alongside the GFN in the gfns array. The access bits only take up 3
bits, which leaves 61 bits left over for gfns, which is more than
enough. So this change does not require any additional memory.

In order to keep the access bit cache in sync with the guest, we have to
extend FNAME(sync_page) to also update the access bits.

Now that the gfns array caches more information than just GFNs, rename
it to shadowed_translation.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/mmu/mmu.c          | 32 +++++++++++++++++++-------------
 arch/x86/kvm/mmu/mmu_internal.h | 15 +++++++++++++--
 arch/x86/kvm/mmu/paging_tmpl.h  |  7 +++++--
 4 files changed, 38 insertions(+), 18 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f72e80178ffc..0f5a36772bdc 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -694,7 +694,7 @@ struct kvm_vcpu_arch {
 
 	struct kvm_mmu_memory_cache mmu_pte_list_desc_cache;
 	struct kvm_mmu_memory_cache mmu_shadow_page_cache;
-	struct kvm_mmu_memory_cache mmu_gfn_array_cache;
+	struct kvm_mmu_memory_cache mmu_shadowed_translation_cache;
 	struct kvm_mmu_memory_cache mmu_page_header_cache;
 
 	/*
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 73a7077f9991..89a7a8d7a632 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -708,7 +708,7 @@ static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_indirect)
 	if (r)
 		return r;
 	if (maybe_indirect) {
-		r = kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_gfn_array_cache,
+		r = kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_shadowed_translation_cache,
 					       PT64_ROOT_MAX_LEVEL);
 		if (r)
 			return r;
@@ -721,7 +721,7 @@ static void mmu_free_memory_caches(struct kvm_vcpu *vcpu)
 {
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_pte_list_desc_cache);
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_shadow_page_cache);
-	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_gfn_array_cache);
+	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_shadowed_translation_cache);
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_header_cache);
 }
 
@@ -738,15 +738,17 @@ static void mmu_free_pte_list_desc(struct pte_list_desc *pte_list_desc)
 static gfn_t kvm_mmu_page_get_gfn(struct kvm_mmu_page *sp, int index)
 {
 	if (!sp->role.direct)
-		return sp->gfns[index];
+		return sp->shadowed_translation[index].gfn;
 
 	return sp->gfn + (index << ((sp->role.level - 1) * PT64_LEVEL_BITS));
 }
 
-static void kvm_mmu_page_set_gfn(struct kvm_mmu_page *sp, int index, gfn_t gfn)
+static void kvm_mmu_page_set_gfn_access(struct kvm_mmu_page *sp, int index,
+					gfn_t gfn, u32 access)
 {
 	if (!sp->role.direct) {
-		sp->gfns[index] = gfn;
+		sp->shadowed_translation[index].gfn = gfn;
+		sp->shadowed_translation[index].access = access;
 		return;
 	}
 
@@ -1599,14 +1601,14 @@ static bool kvm_test_age_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
 static void __rmap_add(struct kvm *kvm,
 		       struct kvm_mmu_memory_cache *cache,
 		       const struct kvm_memory_slot *slot,
-		       u64 *spte, gfn_t gfn)
+		       u64 *spte, gfn_t gfn, u32 access)
 {
 	struct kvm_mmu_page *sp;
 	struct kvm_rmap_head *rmap_head;
 	int rmap_count;
 
 	sp = sptep_to_sp(spte);
-	kvm_mmu_page_set_gfn(sp, spte - sp->spt, gfn);
+	kvm_mmu_page_set_gfn_access(sp, spte - sp->spt, gfn, access);
 	kvm_update_page_stats(kvm, sp->role.level, 1);
 
 	rmap_head = gfn_to_rmap(gfn, sp->role.level, slot);
@@ -1620,9 +1622,9 @@ static void __rmap_add(struct kvm *kvm,
 }
 
 static void rmap_add(struct kvm_vcpu *vcpu, const struct kvm_memory_slot *slot,
-		     u64 *spte, gfn_t gfn)
+		     u64 *spte, gfn_t gfn, u32 access)
 {
-	__rmap_add(vcpu->kvm, &vcpu->arch.mmu_pte_list_desc_cache, slot, spte, gfn);
+	__rmap_add(vcpu->kvm, &vcpu->arch.mmu_pte_list_desc_cache, slot, spte, gfn, access);
 }
 
 bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
@@ -1683,7 +1685,7 @@ void kvm_mmu_free_shadow_page(struct kvm_mmu_page *sp)
 {
 	free_page((unsigned long)sp->spt);
 	if (!sp->role.direct)
-		free_page((unsigned long)sp->gfns);
+		free_page((unsigned long)sp->shadowed_translation);
 	kmem_cache_free(mmu_page_header_cache, sp);
 }
 
@@ -1720,8 +1722,12 @@ struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm_vcpu *vcpu, bool direc
 
 	sp = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_page_header_cache);
 	sp->spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
+
+	BUILD_BUG_ON(sizeof(sp->shadowed_translation[0]) != sizeof(u64));
+
 	if (!direct)
-		sp->gfns = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_gfn_array_cache);
+		sp->shadowed_translation =
+			kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadowed_translation_cache);
 
 	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
 
@@ -1733,7 +1739,7 @@ struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm_vcpu *vcpu, bool direc
  *
  * Huge page splitting always uses direct shadow pages since the huge page is
  * being mapped directly with a lower level page table. Thus there's no need to
- * allocate the gfns array.
+ * allocate the shadowed_translation array.
  */
 struct kvm_mmu_page *kvm_mmu_alloc_direct_sp_for_split(bool locked)
 {
@@ -2849,7 +2855,7 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
 
 	if (!was_rmapped) {
 		WARN_ON_ONCE(ret == RET_PF_SPURIOUS);
-		rmap_add(vcpu, slot, sptep, gfn);
+		rmap_add(vcpu, slot, sptep, gfn, pte_access);
 	}
 
 	return ret;
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index b6e22ba9c654..c5b8ee625df7 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -32,6 +32,11 @@ extern bool dbg;
 
 typedef u64 __rcu *tdp_ptep_t;
 
+struct shadowed_translation_entry {
+	u64 access:3;
+	u64 gfn:56;
+};
+
 struct kvm_mmu_page {
 	/*
 	 * Note, "link" through "spt" fit in a single 64 byte cache line on
@@ -53,8 +58,14 @@ struct kvm_mmu_page {
 	gfn_t gfn;
 
 	u64 *spt;
-	/* hold the gfn of each spte inside spt */
-	gfn_t *gfns;
+	/*
+	 * For indirect shadow pages, caches the result of the intermediate
+	 * guest translation being shadowed by each SPTE.
+	 *
+	 * NULL for direct shadow pages.
+	 */
+	struct shadowed_translation_entry *shadowed_translation;
+
 	/* Currently serving as active root */
 	union {
 		int root_count;
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 55cac59b9c9b..128eccadf1de 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -1014,7 +1014,7 @@ static gpa_t FNAME(gva_to_gpa)(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 }
 
 /*
- * Using the cached information from sp->gfns is safe because:
+ * Using the information in sp->shadowed_translation is safe because:
  * - The spte has a reference to the struct page, so the pfn for a given gfn
  *   can't change unless all sptes pointing to it are nuked first.
  *
@@ -1088,12 +1088,15 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 		if (sync_mmio_spte(vcpu, &sp->spt[i], gfn, pte_access))
 			continue;
 
-		if (gfn != sp->gfns[i]) {
+		if (gfn != sp->shadowed_translation[i].gfn) {
 			drop_spte(vcpu->kvm, &sp->spt[i]);
 			flush = true;
 			continue;
 		}
 
+		if (pte_access != sp->shadowed_translation[i].access)
+			sp->shadowed_translation[i].access = pte_access;
+
 		sptep = &sp->spt[i];
 		spte = *sptep;
 		host_writable = spte & shadow_host_writable_mask;
-- 
2.35.1.723.g4982287a31-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
