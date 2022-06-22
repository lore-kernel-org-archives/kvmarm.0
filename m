Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC06CC43334
	for <kvmarm@archiver.kernel.org>; Wed, 22 Jun 2022 19:27:49 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 739204B357;
	Wed, 22 Jun 2022 15:27:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7adTXPHjwRwb; Wed, 22 Jun 2022 15:27:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 048184B509;
	Wed, 22 Jun 2022 15:27:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 13D334B501
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Jun 2022 15:27:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id L7tf+Z9TFh74 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 Jun 2022 15:27:34 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7E0854B4C2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Jun 2022 15:27:26 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1655926046;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=PtZNTZPWfsMWYTlAEBsLU5lpYkmjIuplCyLvnN6roN8=;
 b=J/DxGHI6IwmKiPc2dyAI/DooD+/sPl54IdqwUnp5iySMkPyRuPaZYKjbmEtebh5wk51OO1
 sWt/WKx+vZyuamUA0kWnlj3zWjcMg+wMeXfArP1A+e1lnmN5hQS+79aKzHRjLfOGgN8sq8
 OOTsReB0uurxpGRlGZeoHVDUSbruA0A=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-153-p9sVOKGTNd-Hjl1hFwF5Jw-1; Wed, 22 Jun 2022 15:27:21 -0400
X-MC-Unique: p9sVOKGTNd-Hjl1hFwF5Jw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 589571C0518C;
 Wed, 22 Jun 2022 19:27:20 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com
 (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 01FD61121314;
 Wed, 22 Jun 2022 19:27:19 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [PATCH v7 23/23] KVM: x86/mmu: Avoid unnecessary flush on eager page
 split
Date: Wed, 22 Jun 2022 15:27:10 -0400
Message-Id: <20220622192710.2547152-24-pbonzini@redhat.com>
In-Reply-To: <20220622192710.2547152-1-pbonzini@redhat.com>
References: <20220622192710.2547152-1-pbonzini@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Cc: maz@kernel.org, jiangshanlai@gmail.com, linux-mips@vger.kernel.org,
 kvm-riscv@lists.infradead.org, bgardon@google.com, dmatlack@google.com,
 maciej.szmigiero@oracle.com, kvmarm@lists.cs.columbia.edu, pfeiner@google.com
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

The TLB flush before installing the newly-populated lower level
page table is unnecessary if the lower-level page table maps
the huge page identically.  KVM knows it is if it did not reuse
an existing shadow page table, tell drop_large_spte() to skip
the flush in that case.

Extracted from a patch by David Matlack.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c | 32 ++++++++++++++++++++------------
 1 file changed, 20 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 22681931921f..79c6a821ea0d 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1135,7 +1135,7 @@ static void drop_spte(struct kvm *kvm, u64 *sptep)
 		rmap_remove(kvm, sptep);
 }
 
-static void drop_large_spte(struct kvm *kvm, u64 *sptep)
+static void drop_large_spte(struct kvm *kvm, u64 *sptep, bool flush)
 {
 	struct kvm_mmu_page *sp;
 
@@ -1143,7 +1143,9 @@ static void drop_large_spte(struct kvm *kvm, u64 *sptep)
 	WARN_ON(sp->role.level == PG_LEVEL_4K);
 
 	drop_spte(kvm, sptep);
-	kvm_flush_remote_tlbs_with_address(kvm, sp->gfn,
+
+	if (flush)
+		kvm_flush_remote_tlbs_with_address(kvm, sp->gfn,
 			KVM_PAGES_PER_HPAGE(sp->role.level));
 }
 
@@ -2283,7 +2285,7 @@ static void shadow_walk_next(struct kvm_shadow_walk_iterator *iterator)
 
 static void __link_shadow_page(struct kvm *kvm,
 			       struct kvm_mmu_memory_cache *cache, u64 *sptep,
-			       struct kvm_mmu_page *sp)
+			       struct kvm_mmu_page *sp, bool flush)
 {
 	u64 spte;
 
@@ -2291,10 +2293,11 @@ static void __link_shadow_page(struct kvm *kvm,
 
 	/*
 	 * If an SPTE is present already, it must be a leaf and therefore
-	 * a large one.  Drop it and flush the TLB before installing sp.
+	 * a large one.  Drop it, and flush the TLB if needed, before
+	 * installing sp.
 	 */
 	if (is_shadow_present_pte(*sptep))
-		drop_large_spte(kvm, sptep);
+		drop_large_spte(kvm, sptep, flush);
 
 	spte = make_nonleaf_spte(sp->spt, sp_ad_disabled(sp));
 
@@ -2309,7 +2312,7 @@ static void __link_shadow_page(struct kvm *kvm,
 static void link_shadow_page(struct kvm_vcpu *vcpu, u64 *sptep,
 			     struct kvm_mmu_page *sp)
 {
-	__link_shadow_page(vcpu->kvm, &vcpu->arch.mmu_pte_list_desc_cache, sptep, sp);
+	__link_shadow_page(vcpu->kvm, &vcpu->arch.mmu_pte_list_desc_cache, sptep, sp, true);
 }
 
 static void validate_direct_spte(struct kvm_vcpu *vcpu, u64 *sptep,
@@ -6172,6 +6175,7 @@ static void shadow_mmu_split_huge_page(struct kvm *kvm,
 	struct kvm_mmu_memory_cache *cache = &kvm->arch.split_desc_cache;
 	u64 huge_spte = READ_ONCE(*huge_sptep);
 	struct kvm_mmu_page *sp;
+	bool flush = false;
 	u64 *sptep, spte;
 	gfn_t gfn;
 	int index;
@@ -6189,20 +6193,24 @@ static void shadow_mmu_split_huge_page(struct kvm *kvm,
 		 * gfn-to-pfn translation since the SP is direct, so no need to
 		 * modify them.
 		 *
-		 * If a given SPTE points to a lower level page table, installing
-		 * such SPTEs would effectively unmap a potion of the huge page.
-		 * This is not an issue because __link_shadow_page() flushes the TLB
-		 * when the passed sp replaces a large SPTE.
+		 * However, if a given SPTE points to a lower level page table,
+		 * that lower level page table may only be partially populated.
+		 * Installing such SPTEs would effectively unmap a potion of the
+		 * huge page. Unmapping guest memory always requires a TLB flush
+		 * since a subsequent operation on the unmapped regions would
+		 * fail to detect the need to flush.
 		 */
-		if (is_shadow_present_pte(*sptep))
+		if (is_shadow_present_pte(*sptep)) {
+			flush |= !is_last_spte(*sptep, sp->role.level);
 			continue;
+		}
 
 		spte = make_huge_page_split_spte(kvm, huge_spte, sp->role, index);
 		mmu_spte_set(sptep, spte);
 		__rmap_add(kvm, cache, slot, sptep, gfn, sp->role.access);
 	}
 
-	__link_shadow_page(kvm, cache, huge_sptep, sp);
+	__link_shadow_page(kvm, cache, huge_sptep, sp, flush);
 }
 
 static int shadow_mmu_try_split_huge_page(struct kvm *kvm,
-- 
2.31.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
