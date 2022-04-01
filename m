Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E78CAC43219
	for <kvmarm@archiver.kernel.org>; Fri,  1 Apr 2022 18:21:09 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A13824B288;
	Fri,  1 Apr 2022 14:21:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id EHYqC9Ke1k4m; Fri,  1 Apr 2022 14:21:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 261EB4B2F7;
	Fri,  1 Apr 2022 14:20:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A3AAF4B266
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Apr 2022 13:56:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jmWYpF9RCrLb for <kvmarm@lists.cs.columbia.edu>;
 Fri,  1 Apr 2022 13:56:27 -0400 (EDT)
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com
 [209.85.216.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 772334B20F
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Apr 2022 13:56:27 -0400 (EDT)
Received: by mail-pj1-f74.google.com with SMTP id
 q38-20020a17090a17a900b001ca487e6ad6so354484pja.8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 01 Apr 2022 10:56:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=ZZYIO/jnGHmZ4rH+JBLCnJUupr7XJywfFhnFxY1c2JA=;
 b=NyoJT0MjlL1XQEPPb1nlvLG7YLfoBZnsrKii89D0PDAULAX/Nnp+BmbYVneYVm7HID
 2k3LGwu0EimGxpzxMMLgLenU4gJ0JRiWPIbIoZfMcIiXs9TbUAws/A0cdsH2+iRm0w/k
 hMSsl5Cbi9ejl3Uu9ksAzZhnc+on97UnujdE/a80/r/wyhkUQUcpSmNN8vnh8YfL0aqX
 EtUOdH3Lq4dPt4LfWkbYTrPaezu1yKO7xpvpJFP/pSk6/nGGPGYpbxPBqCdphCro//4W
 sAcXABrzIYiCnu6GCQw5jWZbmtz2UP/DLewJphPuOZXKcxoDSR3/3RTuS0DjaYSqyQY2
 FZTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=ZZYIO/jnGHmZ4rH+JBLCnJUupr7XJywfFhnFxY1c2JA=;
 b=8MzazvxNSyynkqJnzDdMeIhPTkC18/qV4RaDavdTQYJ8R+ueijI1Fxs4az3U1DEHtq
 Il3Opx2qVY7W8tIKd4rwtyOC17vUhj4Jx9wLpbbioNS+ohE0kmYJdZcWu/mOiTbQMSpB
 3paGoinmwcxpPOx7IV1jKVc7CaFgmC+N0/RlIqF8Kb8uFYdMI8s+AFzYlBw2g4iNArQ/
 8jTII1d/d4We4taTu9PlyCdW99w+NEAqmEPOyB/Hz6apHBf1L/+Jr9fKU0QbxwunleuP
 iBABOHWpIr6PMqfao2k0bKgkgGG82Zi/9ikVFfSlgn5qCCyJElS+ks6pMnPVL4YdxHmU
 Nj6w==
X-Gm-Message-State: AOAM530QooATAdW1bcAT5Kf2HrOx4klDEWXfPGz9MLgwvPOYg+HdVT2X
 CfUT0UqPhgvoze285RCy2LbjL5wH1KdvvQ==
X-Google-Smtp-Source: ABdhPJz2hCYi6E81nF9CFy0u7qVJk/su8KMqwFLzykWKFkpDTKc8tN/+7J8eexUEDHOBAfrJM0iixp6dQ5bHWw==
X-Received: from dmatlack-heavy.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:902:bcca:b0:153:88c7:a02 with SMTP id
 o10-20020a170902bcca00b0015388c70a02mr11424516pls.112.1648835786683; Fri, 01
 Apr 2022 10:56:26 -0700 (PDT)
Date: Fri,  1 Apr 2022 17:55:47 +0000
In-Reply-To: <20220401175554.1931568-1-dmatlack@google.com>
Message-Id: <20220401175554.1931568-17-dmatlack@google.com>
Mime-Version: 1.0
References: <20220401175554.1931568-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH v3 16/23] KVM: x86/mmu: Cache the access bits of shadowed
 translations
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
X-Mailman-Approved-At: Fri, 01 Apr 2022 14:20:42 -0400
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
 arch/x86/kvm/mmu/mmu.c          | 71 ++++++++++++++++++++++++++++-----
 arch/x86/kvm/mmu/mmu_internal.h | 20 +++++++++-
 arch/x86/kvm/mmu/paging_tmpl.h  |  8 +++-
 4 files changed, 85 insertions(+), 16 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 9694dd5e6ccc..be4349c9ffea 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -696,7 +696,7 @@ struct kvm_vcpu_arch {
 
 	struct kvm_mmu_memory_cache mmu_pte_list_desc_cache;
 	struct kvm_mmu_memory_cache mmu_shadow_page_cache;
-	struct kvm_mmu_memory_cache mmu_gfn_array_cache;
+	struct kvm_mmu_memory_cache mmu_shadowed_info_cache;
 	struct kvm_mmu_memory_cache mmu_page_header_cache;
 
 	/*
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 5e1002d57689..3a425ed80e23 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -708,7 +708,7 @@ static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_indirect)
 	if (r)
 		return r;
 	if (maybe_indirect) {
-		r = kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_gfn_array_cache,
+		r = kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_shadowed_info_cache,
 					       PT64_ROOT_MAX_LEVEL);
 		if (r)
 			return r;
@@ -721,7 +721,7 @@ static void mmu_free_memory_caches(struct kvm_vcpu *vcpu)
 {
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_pte_list_desc_cache);
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_shadow_page_cache);
-	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_gfn_array_cache);
+	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_shadowed_info_cache);
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_header_cache);
 }
 
@@ -733,7 +733,7 @@ static void mmu_free_pte_list_desc(struct pte_list_desc *pte_list_desc)
 static gfn_t kvm_mmu_page_get_gfn(struct kvm_mmu_page *sp, int index)
 {
 	if (!sp->role.direct)
-		return sp->gfns[index];
+		return sp->shadowed_translation[index].gfn;
 
 	return sp->gfn + (index << ((sp->role.level - 1) * PT64_LEVEL_BITS));
 }
@@ -741,7 +741,7 @@ static gfn_t kvm_mmu_page_get_gfn(struct kvm_mmu_page *sp, int index)
 static void kvm_mmu_page_set_gfn(struct kvm_mmu_page *sp, int index, gfn_t gfn)
 {
 	if (!sp->role.direct) {
-		sp->gfns[index] = gfn;
+		sp->shadowed_translation[index].gfn = gfn;
 		return;
 	}
 
@@ -752,6 +752,47 @@ static void kvm_mmu_page_set_gfn(struct kvm_mmu_page *sp, int index, gfn_t gfn)
 				   kvm_mmu_page_get_gfn(sp, index), gfn);
 }
 
+static void kvm_mmu_page_set_access(struct kvm_mmu_page *sp, int index, u32 access)
+{
+	if (!sp->role.direct) {
+		sp->shadowed_translation[index].access = access;
+		return;
+	}
+
+	if (WARN_ON(access != sp->role.access))
+		pr_err_ratelimited("access mismatch under direct page %llx "
+				   "(expected %llx, got %llx)\n",
+				   kvm_mmu_page_get_gfn(sp, index),
+				   sp->role.access, access);
+}
+
+/*
+ * For leaf SPTEs, fetch the *guest* access permissions being shadowed. Note
+ * that the SPTE itself may have a more constrained access permissions that
+ * what the guest enforces. For example, a guest may create an executable
+ * huge PTE but KVM may disallow execution to mitigate iTLB multihit.
+ */
+static u32 kvm_mmu_page_get_access(struct kvm_mmu_page *sp, int index)
+{
+	if (!sp->role.direct)
+		return sp->shadowed_translation[index].access;
+
+	/*
+	 * For direct MMUs (e.g. TDP or non-paging guests) there are no *guest*
+	 * access permissions being shadowed. So we can just return ACC_ALL
+	 * here.
+	 *
+	 * For indirect MMUs (shadow paging), direct shadow pages exist when KVM
+	 * is shadowing a guest huge page with smaller pages, since the guest
+	 * huge page is being directly mapped. In this case the guest access
+	 * permissions being shadowed are the access permissions of the huge
+	 * page.
+	 *
+	 * In both cases, sp->role.access contains exactly what we want.
+	 */
+	return sp->role.access;
+}
+
 /*
  * Return the pointer to the large page information for a given gfn,
  * handling slots that are not large page aligned.
@@ -1594,7 +1635,7 @@ static bool kvm_test_age_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
 static void __rmap_add(struct kvm *kvm,
 		       struct kvm_mmu_memory_cache *cache,
 		       const struct kvm_memory_slot *slot,
-		       u64 *spte, gfn_t gfn)
+		       u64 *spte, gfn_t gfn, u32 access)
 {
 	struct kvm_mmu_page *sp;
 	struct kvm_rmap_head *rmap_head;
@@ -1602,6 +1643,7 @@ static void __rmap_add(struct kvm *kvm,
 
 	sp = sptep_to_sp(spte);
 	kvm_mmu_page_set_gfn(sp, spte - sp->spt, gfn);
+	kvm_mmu_page_set_access(sp, spte - sp->spt, access);
 	kvm_update_page_stats(kvm, sp->role.level, 1);
 
 	rmap_head = gfn_to_rmap(gfn, sp->role.level, slot);
@@ -1615,9 +1657,9 @@ static void __rmap_add(struct kvm *kvm,
 }
 
 static void rmap_add(struct kvm_vcpu *vcpu, const struct kvm_memory_slot *slot,
-		     u64 *spte, gfn_t gfn)
+		     u64 *spte, gfn_t gfn, u32 access)
 {
-	__rmap_add(vcpu->kvm, &vcpu->arch.mmu_pte_list_desc_cache, slot, spte, gfn);
+	__rmap_add(vcpu->kvm, &vcpu->arch.mmu_pte_list_desc_cache, slot, spte, gfn, access);
 }
 
 bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
@@ -1678,7 +1720,7 @@ void kvm_mmu_free_shadow_page(struct kvm_mmu_page *sp)
 {
 	free_page((unsigned long)sp->spt);
 	if (!sp->role.direct)
-		free_page((unsigned long)sp->gfns);
+		free_page((unsigned long)sp->shadowed_translation);
 	kmem_cache_free(mmu_page_header_cache, sp);
 }
 
@@ -1715,8 +1757,12 @@ struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm_vcpu *vcpu, bool direc
 
 	sp = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_page_header_cache);
 	sp->spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
+
+	BUILD_BUG_ON(sizeof(sp->shadowed_translation[0]) != sizeof(u64));
+
 	if (!direct)
-		sp->gfns = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_gfn_array_cache);
+		sp->shadowed_translation =
+			kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadowed_info_cache);
 
 	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
 
@@ -1738,7 +1784,7 @@ static inline gfp_t gfp_flags_for_split(bool locked)
  *
  * Huge page splitting always uses direct shadow pages since the huge page is
  * being mapped directly with a lower level page table. Thus there's no need to
- * allocate the gfns array.
+ * allocate the shadowed_translation array.
  */
 struct kvm_mmu_page *kvm_mmu_alloc_direct_sp_for_split(bool locked)
 {
@@ -2841,7 +2887,10 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
 
 	if (!was_rmapped) {
 		WARN_ON_ONCE(ret == RET_PF_SPURIOUS);
-		rmap_add(vcpu, slot, sptep, gfn);
+		rmap_add(vcpu, slot, sptep, gfn, pte_access);
+	} else {
+		/* Already rmapped but the pte_access bits may have changed. */
+		kvm_mmu_page_set_access(sp, sptep - sp->spt, pte_access);
 	}
 
 	return ret;
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index b6e22ba9c654..3f76f4c1ae59 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -32,6 +32,18 @@ extern bool dbg;
 
 typedef u64 __rcu *tdp_ptep_t;
 
+/*
+ * Stores the result of the guest translation being shadowed by an SPTE. KVM
+ * shadows two types of guest translations: nGPA -> GPA (shadow EPT/NPT) and
+ * GVA -> GPA (traditional shadow paging). In both cases the result of the
+ * translation is a GPA and a set of access constraints.
+ */
+struct shadowed_translation_entry {
+	/* Note, GFNs can have at most 64 - PAGE_SHIFT = 52 bits. */
+	u64 gfn:52;
+	u64 access:3;
+};
+
 struct kvm_mmu_page {
 	/*
 	 * Note, "link" through "spt" fit in a single 64 byte cache line on
@@ -53,8 +65,12 @@ struct kvm_mmu_page {
 	gfn_t gfn;
 
 	u64 *spt;
-	/* hold the gfn of each spte inside spt */
-	gfn_t *gfns;
+	/*
+	 * Caches the result of the intermediate guest translation being
+	 * shadowed by each SPTE. NULL for direct shadow pages.
+	 */
+	struct shadowed_translation_entry *shadowed_translation;
+
 	/* Currently serving as active root */
 	union {
 		int root_count;
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index db63b5377465..91c2088464ce 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -1014,7 +1014,8 @@ static gpa_t FNAME(gva_to_gpa)(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 }
 
 /*
- * Using the cached information from sp->gfns is safe because:
+ * Using the information in sp->shadowed_translation (kvm_mmu_page_get_gfn()
+ * and kvm_mmu_page_get_access()) is safe because:
  * - The spte has a reference to the struct page, so the pfn for a given gfn
  *   can't change unless all sptes pointing to it are nuked first.
  *
@@ -1088,12 +1089,15 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 		if (sync_mmio_spte(vcpu, &sp->spt[i], gfn, pte_access))
 			continue;
 
-		if (gfn != sp->gfns[i]) {
+		if (gfn != kvm_mmu_page_get_gfn(sp, i)) {
 			drop_spte(vcpu->kvm, &sp->spt[i]);
 			flush = true;
 			continue;
 		}
 
+		if (pte_access != kvm_mmu_page_get_access(sp, i))
+			kvm_mmu_page_set_access(sp, i, pte_access);
+
 		sptep = &sp->spt[i];
 		spte = *sptep;
 		host_writable = spte & shadow_host_writable_mask;
-- 
2.35.1.1094.g7c7d902a7c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
