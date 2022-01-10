Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C36EFC433F5
	for <kvmarm@archiver.kernel.org>; Mon, 10 Jan 2022 21:05:09 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F68C4B0B4;
	Mon, 10 Jan 2022 16:05:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Z4xKJFEzADg8; Mon, 10 Jan 2022 16:05:09 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B63294B11B;
	Mon, 10 Jan 2022 16:05:07 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CBEB54B134
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Jan 2022 16:05:06 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZbCndVOEbfcp for <kvmarm@lists.cs.columbia.edu>;
 Mon, 10 Jan 2022 16:05:05 -0500 (EST)
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com
 [209.85.214.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C97EF4B0FB
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Jan 2022 16:05:04 -0500 (EST)
Received: by mail-pl1-f202.google.com with SMTP id
 p16-20020a170902a41000b0014992c5d56bso3108079plq.19
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Jan 2022 13:05:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=SblhaXcWijIzk0Mapv3cGqzGg1Y0/XESvuNWuvJevdk=;
 b=tJhw8ZATrv3Sjy9QhepZUWpfX9dTE8Ja4a0R/EZCvyfUQj/+OWsQL94ONBjWVMpaez
 b2bNJQTqp6okRMwCqrN5Tt4UOCN2V+ptEfZEk3C3g/c8Y//NHMFgSJRgtIdayXr0LemP
 UYcHoRiyjMfoQJC5LpxjbMcsa+oSbLKuBbaungcF3668+S7YF9EKmn4bGkYxiQEmQlke
 wBmpEIHWalDlZEJLoE+Zgt3IZ9NyHxeGMLCwYNIdPApvX/MtGJGslz6BjO464WpeSKwZ
 VEuOU2T24qaEojHNtI8BfU84V+5HoQzHehfcEfTff+Wvb5WL8jlpl/iyJK9Y6IbsYFvY
 w+mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=SblhaXcWijIzk0Mapv3cGqzGg1Y0/XESvuNWuvJevdk=;
 b=e9DL9Ixi1p8tqhPy2YEueZN+rMUMVtf9SRoGRUl79rPtaY5onDypXf7XL44xZupRSQ
 H+wtL9KfwC1iAOaiKx/JyrKkYf32M/j6gpTahz2FJ69NliweOrdx3a9mFTNN9hxdwNx7
 q3wa78rV9HWBL7+T8Ni4HbOSkFwZx+DuqkzqKpyoAde9lqCyoEnE0t2cXzGfukjiVaoF
 ap94PNUSJzX1rMkHTib3cl/MDDcCdX251viWjA5JaVSWsHqSQuWCiimYAQ1X4EhGkqu/
 VSgytoy1sEr7uNpoNJ6DSRMaBaupheWWn1MZkFxYvrmiC0puYefqCmwVnpDIgdq9WSY5
 DWyQ==
X-Gm-Message-State: AOAM530PjEjrXXhCSDnQiEd1reDyOyCxCXvhdp3njW61Nw5G2cSArROO
 r6gNFhS5YmZJRwq44B51UtExjB1Z1zhqogAqQg==
X-Google-Smtp-Source: ABdhPJyZXewBlKNnGyc7EiD71gjJFzijvf+twsuG6PIplDMkIgqq41GFwCDp+OOvS5LS/4e8YnTET8+Nw0N7jOmrdQ==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by
 2002:a17:902:c407:b0:149:2ef4:b6b2 with
 SMTP id k7-20020a170902c40700b001492ef4b6b2mr1490383plk.112.1641848703948;
 Mon, 10 Jan 2022 13:05:03 -0800 (PST)
Date: Mon, 10 Jan 2022 21:04:40 +0000
In-Reply-To: <20220110210441.2074798-1-jingzhangos@google.com>
Message-Id: <20220110210441.2074798-3-jingzhangos@google.com>
Mime-Version: 1.0
References: <20220110210441.2074798-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.34.1.575.g55b058a8bb-goog
Subject: [RFC PATCH 2/3] KVM: arm64: Add fast path to handle permission
 relaxation during dirty logging
From: Jing Zhang <jingzhangos@google.com>
To: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.cs.columbia.edu>, 
 Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, 
 David Matlack <dmatlack@google.com>, Oliver Upton <oupton@google.com>, 
 Reiji Watanabe <reijiw@google.com>
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

To reduce MMU lock contention during dirty logging, all permission
relaxation operations would be performed under read lock.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/kvm/mmu.c | 50 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index cafd5813c949..dd1f43fba4b0 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1063,6 +1063,54 @@ static int sanitise_mte_tags(struct kvm *kvm, kvm_pfn_t pfn,
 	return 0;
 }
 
+static bool fast_mark_writable(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
+		struct kvm_memory_slot *memslot, unsigned long fault_status)
+{
+	int ret;
+	bool writable;
+	bool write_fault = kvm_is_write_fault(vcpu);
+	gfn_t gfn = fault_ipa >> PAGE_SHIFT;
+	kvm_pfn_t pfn;
+	struct kvm *kvm = vcpu->kvm;
+	bool logging_active = memslot_is_logging(memslot);
+	unsigned long fault_level = kvm_vcpu_trap_get_fault_level(vcpu);
+	unsigned long fault_granule;
+
+	fault_granule = 1UL << ARM64_HW_PGTABLE_LEVEL_SHIFT(fault_level);
+
+	/* Make sure the fault can be handled in the fast path.
+	 * Only handle write permission fault on non-hugepage during dirty
+	 * logging period.
+	 */
+	if (fault_status != FSC_PERM || fault_granule != PAGE_SIZE
+			|| !logging_active || !write_fault)
+		return false;
+
+
+	/* Pin the pfn to make sure it couldn't be freed and be resued for
+	 * another gfn.
+	 */
+	pfn = __gfn_to_pfn_memslot(memslot, gfn, true, NULL,
+				   write_fault, &writable, NULL);
+	if (is_error_pfn(pfn) || !writable)
+		return false;
+
+	read_lock(&kvm->mmu_lock);
+	ret = kvm_pgtable_stage2_relax_perms(
+			vcpu->arch.hw_mmu->pgt, fault_ipa, PAGE_HYP);
+
+	if (!ret) {
+		kvm_set_pfn_dirty(pfn);
+		mark_page_dirty_in_slot(kvm, memslot, gfn);
+	}
+	read_unlock(&kvm->mmu_lock);
+
+	kvm_set_pfn_accessed(pfn);
+	kvm_release_pfn_clean(pfn);
+
+	return true;
+}
+
 static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			  struct kvm_memory_slot *memslot, unsigned long hva,
 			  unsigned long fault_status)
@@ -1085,6 +1133,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
 	struct kvm_pgtable *pgt;
 
+	if (fast_mark_writable(vcpu, fault_ipa, memslot, fault_status))
+		return 0;
 	fault_granule = 1UL << ARM64_HW_PGTABLE_LEVEL_SHIFT(fault_level);
 	write_fault = kvm_is_write_fault(vcpu);
 	exec_fault = kvm_vcpu_trap_is_exec_fault(vcpu);
-- 
2.34.1.575.g55b058a8bb-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
