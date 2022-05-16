Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC3A7C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 17 May 2022 07:02:44 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 968F64B2FB;
	Tue, 17 May 2022 03:02:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3qTeNMsmNdUD; Tue, 17 May 2022 03:02:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6099A4B301;
	Tue, 17 May 2022 03:02:27 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9597849EBB
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 May 2022 19:22:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iODRiM4OaWVr for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 May 2022 19:22:00 -0400 (EDT)
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com
 [209.85.210.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EFF5E4B1F2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 May 2022 19:21:59 -0400 (EDT)
Received: by mail-pf1-f201.google.com with SMTP id
 p18-20020aa78612000000b0050d1c170018so6783634pfn.15
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 May 2022 16:21:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=3LhrUUJfnPbZnXXceqMM0IPZa+RwfuesldMIFcGLHNI=;
 b=ViTD7LnMDy5dnyUjNjzjAzqyb5r7Ia8iZfJbijiy5JlVtsN5M4FlGlZn/DhNRVcEct
 Wn2i6z/nvuNrHO0Hg71L+gNAVVe1s2LYdlUwWI1Lg1uPplXHab665aGapujzXCIdpUpp
 cSv2dJXa3KQznE9gBnDTzYbsCcxKtqf3smx/54to4bYnEolSEr2ebh9KROgR4ay55x7K
 fYqjJbEqHuuZeUCO56iDPe2XU9E4ql3qFeP6Yu8RPzKwAe2FdGIfuiKdH0uGLUpyKcbz
 otzC4k8XerJIPHClmHOqBkXXfWrGweo4h77tsTOqAtfWxOzrRAbTXAitnEtHO8ncI8c7
 6HjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=3LhrUUJfnPbZnXXceqMM0IPZa+RwfuesldMIFcGLHNI=;
 b=n3smo1WMIG30slMMPd0v4ZjScS36Xz6Fj0Yx2lfWmkuSQLifjdkrBOEL/uM4GIzIby
 0Jy32IwjKRr79NLuH4qU1ZjQ3LWiF1Jgiz7KW2C7rOHc6RE3wJaOatTZhl6QhUbhwp10
 wfRVbUDFoytnS/MLbRkHMw9JT5nlsbSkshatiJup8LolUA+MQGRBcqu8B0t8F+/i2Tw5
 2FNx54xSbudB+aPvoftf3WeSdZNuh8PdHABV/xy8khSIiIxGXo0GKTcYHTgJz6mA/rVY
 sQrlm6Dpv0QBdKbju6TrBKwg80ph7wQ++W7AUW+edrxBkUT+JUSpDY/UyJDah9veXyRD
 jK+Q==
X-Gm-Message-State: AOAM5302KQC2X26WAwy9DAtXt/RcdLSMhATuUGbhn5A7lfCxgCNzUA93
 DdxnUQN0BYSy90vOjVIt7HirbOB4lbfaCA==
X-Google-Smtp-Source: ABdhPJws0x4xZT8MEY8uaMsjDnhKVFClVcDUeHFaRwxuLoikzMxk54YWO7hpW8lqLUiOk0lnC4lFMP7mYrmHTQ==
X-Received: from dmatlack-heavy.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90b:4c06:b0:1dc:861c:1cfb with SMTP
 id na6-20020a17090b4c0600b001dc861c1cfbmr32974410pjb.85.1652743319050; Mon,
 16 May 2022 16:21:59 -0700 (PDT)
Date: Mon, 16 May 2022 23:21:27 +0000
In-Reply-To: <20220516232138.1783324-1-dmatlack@google.com>
Message-Id: <20220516232138.1783324-12-dmatlack@google.com>
Mime-Version: 1.0
References: <20220516232138.1783324-1-dmatlack@google.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
Subject: [PATCH v6 11/22] KVM: x86/mmu: Replace vcpu with kvm in
 kvm_mmu_alloc_shadow_page()
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
X-Mailman-Approved-At: Tue, 17 May 2022 03:02:25 -0400
Cc: Albert Ou <aou@eecs.berkeley.edu>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <kvm@vger.kernel.org>, Marc Zyngier <maz@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>,
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

The vcpu pointer in kvm_mmu_alloc_shadow_page() is only used to get the
kvm pointer. So drop the vcpu pointer and just pass in the kvm pointer.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index bad4dd5aa051..8031b799ca77 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2082,7 +2082,7 @@ struct shadow_page_caches {
 	struct kvm_mmu_memory_cache *gfn_array_cache;
 };
 
-static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm_vcpu *vcpu,
+static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm *kvm,
 						      struct shadow_page_caches *caches,
 						      gfn_t gfn,
 						      struct hlist_head *sp_list,
@@ -2102,15 +2102,15 @@ static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm_vcpu *vcpu,
 	 * depends on valid pages being added to the head of the list.  See
 	 * comments in kvm_zap_obsolete_pages().
 	 */
-	sp->mmu_valid_gen = vcpu->kvm->arch.mmu_valid_gen;
-	list_add(&sp->link, &vcpu->kvm->arch.active_mmu_pages);
-	kvm_mod_used_mmu_pages(vcpu->kvm, +1);
+	sp->mmu_valid_gen = kvm->arch.mmu_valid_gen;
+	list_add(&sp->link, &kvm->arch.active_mmu_pages);
+	kvm_mod_used_mmu_pages(kvm, +1);
 
 	sp->gfn = gfn;
 	sp->role = role;
 	hlist_add_head(&sp->hash_link, sp_list);
 	if (sp_has_gptes(sp))
-		account_shadowed(vcpu->kvm, sp);
+		account_shadowed(kvm, sp);
 
 	return sp;
 }
@@ -2129,7 +2129,7 @@ static struct kvm_mmu_page *__kvm_mmu_get_shadow_page(struct kvm_vcpu *vcpu,
 	sp = kvm_mmu_find_shadow_page(vcpu, gfn, sp_list, role);
 	if (!sp) {
 		created = true;
-		sp = kvm_mmu_alloc_shadow_page(vcpu, caches, gfn, sp_list, role);
+		sp = kvm_mmu_alloc_shadow_page(vcpu->kvm, caches, gfn, sp_list, role);
 	}
 
 	trace_kvm_mmu_get_page(sp, created);
-- 
2.36.0.550.gb090851708-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
