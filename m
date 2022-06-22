Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE60BCCA47E
	for <kvmarm@archiver.kernel.org>; Wed, 22 Jun 2022 19:27:26 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6BFDC4B34E;
	Wed, 22 Jun 2022 15:27:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MaxuaqcXKcwq; Wed, 22 Jun 2022 15:27:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E93984B51E;
	Wed, 22 Jun 2022 15:27:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 33C634B285
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Jun 2022 15:27:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KlIP4rDohU6H for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 Jun 2022 15:27:18 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 216C44B32F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Jun 2022 15:27:18 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1655926038;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=CLXhh2jHdU4NArrkTkPf5gXuXh+EDE9oNWeupQnPsQk=;
 b=BiUH7hXXX0n3BaYKxDptBtL1bnEp1AAV5lTPJPdiJBL4UhCiozaRH8HYXvQDPRkEdPky/t
 RMp/ReYF+M7wlny1lEddS0UA/7tYTuAAaWWcu/v0OCNOE5JHhJtUhdtk88Bu2AG+vIlTPz
 netKPtxRy7HrWj7brizMdCQc9faCOxU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-22-4uDFGgT2PiWTMXu_E4ZL6Q-1; Wed, 22 Jun 2022 15:27:14 -0400
X-MC-Unique: 4uDFGgT2PiWTMXu_E4ZL6Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E2430294EDC6;
 Wed, 22 Jun 2022 19:27:13 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com
 (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 8B3AE1121314;
 Wed, 22 Jun 2022 19:27:13 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [PATCH v7 07/23] KVM: x86/mmu: Consolidate shadow page allocation and
 initialization
Date: Wed, 22 Jun 2022 15:26:54 -0400
Message-Id: <20220622192710.2547152-8-pbonzini@redhat.com>
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

From: David Matlack <dmatlack@google.com>

Consolidate kvm_mmu_alloc_page() and kvm_mmu_alloc_shadow_page() under
the latter so that all shadow page allocation and initialization happens
in one place.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
Message-Id: <20220516232138.1783324-8-dmatlack@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c | 39 +++++++++++++++++----------------------
 1 file changed, 17 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index a59fe860da29..8b84cdd8c6cd 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1664,27 +1664,6 @@ static void drop_parent_pte(struct kvm_mmu_page *sp,
 	mmu_spte_clear_no_track(parent_pte);
 }
 
-static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu, bool direct)
-{
-	struct kvm_mmu_page *sp;
-
-	sp = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_page_header_cache);
-	sp->spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
-	if (!direct)
-		sp->gfns = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_gfn_array_cache);
-	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
-
-	/*
-	 * active_mmu_pages must be a FIFO list, as kvm_zap_obsolete_pages()
-	 * depends on valid pages being added to the head of the list.  See
-	 * comments in kvm_zap_obsolete_pages().
-	 */
-	sp->mmu_valid_gen = vcpu->kvm->arch.mmu_valid_gen;
-	list_add(&sp->link, &vcpu->kvm->arch.active_mmu_pages);
-	kvm_mod_used_mmu_pages(vcpu->kvm, +1);
-	return sp;
-}
-
 static void mark_unsync(u64 *spte);
 static void kvm_mmu_mark_parents_unsync(struct kvm_mmu_page *sp)
 {
@@ -2072,7 +2051,23 @@ static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm_vcpu *vcpu,
 						      struct hlist_head *sp_list,
 						      union kvm_mmu_page_role role)
 {
-	struct kvm_mmu_page *sp = kvm_mmu_alloc_page(vcpu, role.direct);
+	struct kvm_mmu_page *sp;
+
+	sp = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_page_header_cache);
+	sp->spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
+	if (!role.direct)
+		sp->gfns = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_gfn_array_cache);
+
+	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
+
+	/*
+	 * active_mmu_pages must be a FIFO list, as kvm_zap_obsolete_pages()
+	 * depends on valid pages being added to the head of the list.  See
+	 * comments in kvm_zap_obsolete_pages().
+	 */
+	sp->mmu_valid_gen = vcpu->kvm->arch.mmu_valid_gen;
+	list_add(&sp->link, &vcpu->kvm->arch.active_mmu_pages);
+	kvm_mod_used_mmu_pages(vcpu->kvm, +1);
 
 	sp->gfn = gfn;
 	sp->role = role;
-- 
2.31.1


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
