Return-Path: <SRS0=1o63=IY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7030C433DB
	for <kvmarm@archiver.kernel.org>; Fri, 26 Mar 2021 13:54:39 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 471FB61A18
	for <kvmarm@archiver.kernel.org>; Fri, 26 Mar 2021 13:54:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 471FB61A18
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E30A34B4B6;
	Fri, 26 Mar 2021 09:54:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id G15gBlcjy5Lz; Fri, 26 Mar 2021 09:54:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 96F584B47D;
	Fri, 26 Mar 2021 09:54:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ADA464B478
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Mar 2021 22:20:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id itGpeKhMGJar for <kvmarm@lists.cs.columbia.edu>;
 Thu, 25 Mar 2021 22:20:38 -0400 (EDT)
Received: from mail-qt1-f202.google.com (mail-qt1-f202.google.com
 [209.85.160.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BBFED4B1E6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Mar 2021 22:20:38 -0400 (EDT)
Received: by mail-qt1-f202.google.com with SMTP id l11so4458613qtk.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Mar 2021 19:20:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=reply-to:date:in-reply-to:message-id:mime-version:references
 :subject:from:to:cc;
 bh=xpO0R+6AZcVTsryAmfa1csIhFbdIpj6scMCyrGXKA2A=;
 b=uQMp99nW6RHB2f3cTnLRvct0FzbjC1V4VwapmMNa65kI5zh0Epe6k/+qnHl8c3g8XI
 e+074i6mSZD8oxFjqCkK5zLR1cZfynVaB3eyCkzjeytIhfBHuUzJZL1sNBHnGCSHySCb
 gqwIe0mkUcqzZHZbNRRFPQ2+K7MWmTXsScaQdxvetXfBiYptWDMmPvMzOCAlfll1mbAs
 NbHnAtChhSnK32WHWUvzYwrT2Dn+3HYLcIO7c93cikxTnn3anhGE7PKj43vC0iOMSt+t
 4y5TRJe0rxO98n7YswSmBa8pY1cxaoRDJJFukkwjscg/G4XY1gweSfbik6p/N31wcvHF
 FAvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:reply-to:date:in-reply-to:message-id
 :mime-version:references:subject:from:to:cc;
 bh=xpO0R+6AZcVTsryAmfa1csIhFbdIpj6scMCyrGXKA2A=;
 b=XI3AK2Y+12ihbBJcInRUKsnbs/IobDAk8ZmMA1zthwqBHGWXrWSnR4+bTfGnWRpuwz
 MeX4dxzqhaPg8eFYdGKpw7MRTVUuMU17goT0r5GBu++LA6fZRZZfYhwsIEulk3Yv3EJ+
 3JKbYQKPA/5RIozePyEiPuh5PMF43SJXmax3eSPmi/Ms1He4rrUD7/xVJ1i2wA6OUVvv
 g2ictp9tTw1bv3cTxXU7bSswlZNrYWH1TkSEUtfhJ6cy3nNuL22UFJ7hNfVijpNuipGf
 ucdMjgCPgaeeHQkirDR1KpRhgK8oTVegAWK8qUHZNdvx/95BMo2RXhs2RLH5dIKysVms
 grPw==
X-Gm-Message-State: AOAM532HgbJt7bVj+uV0EQeCF4zPt9zgc8RKLf5TnInZsK2iGbng3jtl
 cr9lpIIBSRrJ2kxlQ6ZR0yHDTK3TVQc=
X-Google-Smtp-Source: ABdhPJxBd8XQox7hj6Ay7ePLmzDoNDRNC6Ku6UeU/xYURVhIi+zWH8AcpMshGJmfzY+BzyCGVqg0RjgGsVQ=
X-Received: from seanjc798194.pdx.corp.google.com
 ([2620:15c:f:10:b1bb:fab2:7ef5:fc7d])
 (user=seanjc job=sendgmr) by 2002:a0c:cd8b:: with SMTP id
 v11mr4012312qvm.60.1616725238277; 
 Thu, 25 Mar 2021 19:20:38 -0700 (PDT)
Date: Thu, 25 Mar 2021 19:19:51 -0700
In-Reply-To: <20210326021957.1424875-1-seanjc@google.com>
Message-Id: <20210326021957.1424875-13-seanjc@google.com>
Mime-Version: 1.0
References: <20210326021957.1424875-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
Subject: [PATCH 12/18] KVM: MIPS/MMU: Convert to the gfn-based MMU notifier
 callbacks
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>, 
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Paul Mackerras <paulus@ozlabs.org>, Paolo Bonzini <pbonzini@redhat.com>
X-Mailman-Approved-At: Fri, 26 Mar 2021 09:54:23 -0400
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Sean Christopherson <seanjc@google.com>, Joerg Roedel <joro@8bytes.org>,
 linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Ben Gardon <bgardon@google.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 kvmarm@lists.cs.columbia.edu, Jim Mattson <jmattson@google.com>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: Sean Christopherson <seanjc@google.com>
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

Move MIPS to the gfn-based MMU notifier APIs, which do the hva->gfn
lookup in common code, and whose code is nearly identical to MIPS'
lookup.

No meaningful functional change intended, though the exact order of
operations is slightly different since the memslot lookups occur before
calling into arch code.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/mips/include/asm/kvm_host.h |  1 +
 arch/mips/kvm/mmu.c              | 97 ++++++--------------------------
 2 files changed, 17 insertions(+), 81 deletions(-)

diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm_host.h
index feaa77036b67..374a3c8806e8 100644
--- a/arch/mips/include/asm/kvm_host.h
+++ b/arch/mips/include/asm/kvm_host.h
@@ -967,6 +967,7 @@ enum kvm_mips_fault_result kvm_trap_emul_gva_fault(struct kvm_vcpu *vcpu,
 						   bool write);
 
 #define KVM_ARCH_WANT_MMU_NOTIFIER
+#define KVM_ARCH_WANT_NEW_MMU_NOTIFIER_APIS
 
 /* Emulation */
 int kvm_get_inst(u32 *opc, struct kvm_vcpu *vcpu, u32 *out);
diff --git a/arch/mips/kvm/mmu.c b/arch/mips/kvm/mmu.c
index 3dabeda82458..3dc885df2e32 100644
--- a/arch/mips/kvm/mmu.c
+++ b/arch/mips/kvm/mmu.c
@@ -439,85 +439,36 @@ static int kvm_mips_mkold_gpa_pt(struct kvm *kvm, gfn_t start_gfn,
 				  end_gfn << PAGE_SHIFT);
 }
 
-static int handle_hva_to_gpa(struct kvm *kvm,
-			     unsigned long start,
-			     unsigned long end,
-			     int (*handler)(struct kvm *kvm, gfn_t gfn,
-					    gpa_t gfn_end,
-					    struct kvm_memory_slot *memslot,
-					    void *data),
-			     void *data)
+bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 {
-	struct kvm_memslots *slots;
-	struct kvm_memory_slot *memslot;
-	int ret = 0;
-
-	slots = kvm_memslots(kvm);
-
-	/* we only care about the pages that the guest sees */
-	kvm_for_each_memslot(memslot, slots) {
-		unsigned long hva_start, hva_end;
-		gfn_t gfn, gfn_end;
-
-		hva_start = max(start, memslot->userspace_addr);
-		hva_end = min(end, memslot->userspace_addr +
-					(memslot->npages << PAGE_SHIFT));
-		if (hva_start >= hva_end)
-			continue;
-
-		/*
-		 * {gfn(page) | page intersects with [hva_start, hva_end)} =
-		 * {gfn_start, gfn_start+1, ..., gfn_end-1}.
-		 */
-		gfn = hva_to_gfn_memslot(hva_start, memslot);
-		gfn_end = hva_to_gfn_memslot(hva_end + PAGE_SIZE - 1, memslot);
-
-		ret |= handler(kvm, gfn, gfn_end, memslot, data);
-	}
-
-	return ret;
-}
-
-
-static int kvm_unmap_hva_handler(struct kvm *kvm, gfn_t gfn, gfn_t gfn_end,
-				 struct kvm_memory_slot *memslot, void *data)
-{
-	kvm_mips_flush_gpa_pt(kvm, gfn, gfn_end);
-	return 1;
-}
-
-int kvm_unmap_hva_range(struct kvm *kvm, unsigned long start, unsigned long end,
-			unsigned flags)
-{
-	handle_hva_to_gpa(kvm, start, end, &kvm_unmap_hva_handler, NULL);
+	kvm_mips_flush_gpa_pt(kvm, range->start, range->end);
 
 	kvm_mips_callbacks->flush_shadow_all(kvm);
 	return 0;
 }
 
-static int kvm_set_spte_handler(struct kvm *kvm, gfn_t gfn, gfn_t gfn_end,
-				struct kvm_memory_slot *memslot, void *data)
+static bool __kvm_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
-	gpa_t gpa = gfn << PAGE_SHIFT;
-	pte_t hva_pte = *(pte_t *)data;
+	gpa_t gpa = range->start << PAGE_SHIFT;
+	pte_t hva_pte = range->pte;
 	pte_t *gpa_pte = kvm_mips_pte_for_gpa(kvm, NULL, gpa);
 	pte_t old_pte;
 
 	if (!gpa_pte)
-		return 0;
+		return false;
 
 	/* Mapping may need adjusting depending on memslot flags */
 	old_pte = *gpa_pte;
-	if (memslot->flags & KVM_MEM_LOG_DIRTY_PAGES && !pte_dirty(old_pte))
+	if (range->slot->flags & KVM_MEM_LOG_DIRTY_PAGES && !pte_dirty(old_pte))
 		hva_pte = pte_mkclean(hva_pte);
-	else if (memslot->flags & KVM_MEM_READONLY)
+	else if (range->slot->flags & KVM_MEM_READONLY)
 		hva_pte = pte_wrprotect(hva_pte);
 
 	set_pte(gpa_pte, hva_pte);
 
 	/* Replacing an absent or old page doesn't need flushes */
 	if (!pte_present(old_pte) || !pte_young(old_pte))
-		return 0;
+		return false;
 
 	/* Pages swapped, aged, moved, or cleaned require flushes */
 	return !pte_present(hva_pte) ||
@@ -526,27 +477,21 @@ static int kvm_set_spte_handler(struct kvm *kvm, gfn_t gfn, gfn_t gfn_end,
 	       (pte_dirty(old_pte) && !pte_dirty(hva_pte));
 }
 
-int kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte)
+bool kvm_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
-	unsigned long end = hva + PAGE_SIZE;
-	int ret;
-
-	ret = handle_hva_to_gpa(kvm, hva, end, &kvm_set_spte_handler, &pte);
-	if (ret)
+	if (__kvm_set_spte_gfn(kvm, range))
 		kvm_mips_callbacks->flush_shadow_all(kvm);
-	return 0;
+	return false;
 }
 
-static int kvm_age_hva_handler(struct kvm *kvm, gfn_t gfn, gfn_t gfn_end,
-			       struct kvm_memory_slot *memslot, void *data)
+bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
-	return kvm_mips_mkold_gpa_pt(kvm, gfn, gfn_end);
+	return kvm_mips_mkold_gpa_pt(kvm, range->start, range->end);
 }
 
-static int kvm_test_age_hva_handler(struct kvm *kvm, gfn_t gfn, gfn_t gfn_end,
-				    struct kvm_memory_slot *memslot, void *data)
+bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
-	gpa_t gpa = gfn << PAGE_SHIFT;
+	gpa_t gpa = range->start << PAGE_SHIFT;
 	pte_t *gpa_pte = kvm_mips_pte_for_gpa(kvm, NULL, gpa);
 
 	if (!gpa_pte)
@@ -554,16 +499,6 @@ static int kvm_test_age_hva_handler(struct kvm *kvm, gfn_t gfn, gfn_t gfn_end,
 	return pte_young(*gpa_pte);
 }
 
-int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end)
-{
-	return handle_hva_to_gpa(kvm, start, end, kvm_age_hva_handler, NULL);
-}
-
-int kvm_test_age_hva(struct kvm *kvm, unsigned long hva)
-{
-	return handle_hva_to_gpa(kvm, hva, hva, kvm_test_age_hva_handler, NULL);
-}
-
 /**
  * _kvm_mips_map_page_fast() - Fast path GPA fault handler.
  * @vcpu:		VCPU pointer.
-- 
2.31.0.291.g576ba9dcdaf-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
