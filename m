Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F09B8C43217
	for <kvmarm@archiver.kernel.org>; Tue, 17 May 2022 07:02:39 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A92804B2DB;
	Tue, 17 May 2022 03:02:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id uQeZA4mLpYQS; Tue, 17 May 2022 03:02:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EAE824B29F;
	Tue, 17 May 2022 03:02:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CBF1949EBE
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 May 2022 19:21:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yWpX8OQZwe05 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 May 2022 19:21:56 -0400 (EDT)
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com
 [209.85.210.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9C8164B1FA
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 May 2022 19:21:56 -0400 (EDT)
Received: by mail-pf1-f201.google.com with SMTP id
 15-20020aa7920f000000b0050cf449957fso6798768pfo.9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 May 2022 16:21:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=XWhilig2MoNteAc4T6eN7YonYu6WiPDe3XS3DlFt+jY=;
 b=Gn0TUJQ0oAT0sUnrUouOEQhoOdkngm/EQPDfvbvia5LXjKS4924z23mrWOpTdrA/Hr
 Bw8oQYobjaBro2pxwSLg7Fyc94HXzB+5ozfOiafwOz8WfwwQ0NzXhxecfa4kyTI3m2QJ
 99hBZKdhULrDw3t74NLg8XNE1wzCoe9lf4nSUOv1nGOOaU9BsWElxyGN19tCYyEqYBFF
 kPtYaSAu73qvhFt7XYJXU5LrZmtPnpOFV32EWiI7hMWCJ8Ez2KvMTRSoY4bg205rTmiF
 wzgj+9/Cjm495lXdojVTMYd7TaQVu/fzG7qw4s/WRB2kSHkcrk8fwB9Vs0t75EFVkOfe
 VAGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=XWhilig2MoNteAc4T6eN7YonYu6WiPDe3XS3DlFt+jY=;
 b=TYkuajjwvUPUuibsPPVVZ0ckmKJl2YKdeY+g8Y3D81NDN0TZ8Fs0QohDZE7X2Y/ewC
 o+pkdqKIOiZfQA9lqqDFRBvjJKcKcQ0LkXhbPtKN/ezf49/Ol8BQAERDtU/r0v/EFNF0
 eBimkzyYiI6MYXbcL8uRQjM2Jn/VKT8SdIORZiBWdduN2yYT8Ot8CEEPaygLhLIfhUMp
 GNYfCPksGbmlE+xZdnhUmiDKlf7VQHR1u/MRQZEqqYLgW3i65jMkvdc2PqBq5BtUcNKE
 z6Du3LVoGgf8O4o+HHITm0hiUONONPr7+GwRLFEE2h3sYwX/37xS4B2OlFwaO36Yt/FE
 hKhw==
X-Gm-Message-State: AOAM532DY48dE1p+31j5M+AqTsfiX2W6EkfRvfgudyxv5/5n/4RNUEeI
 C1a4jvhuHVK25f2TYZPPgDJClZz5rUCiOw==
X-Google-Smtp-Source: ABdhPJz+mv6KLWlHlnd0tKdGhB1w6C7WkQouE6ZrWpIM1Kdm38KemSHw4qOCxOwa0IH2ZdRnQndGM/F0DRga+A==
X-Received: from dmatlack-heavy.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a62:5ec6:0:b0:50d:a467:3cb7 with SMTP id
 s189-20020a625ec6000000b0050da4673cb7mr19714931pfb.85.1652743315785; Mon, 16
 May 2022 16:21:55 -0700 (PDT)
Date: Mon, 16 May 2022 23:21:25 +0000
In-Reply-To: <20220516232138.1783324-1-dmatlack@google.com>
Message-Id: <20220516232138.1783324-10-dmatlack@google.com>
Mime-Version: 1.0
References: <20220516232138.1783324-1-dmatlack@google.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
Subject: [PATCH v6 09/22] KVM: x86/mmu: Move guest PT write-protection to
 account_shadowed()
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

Move the code that write-protects newly-shadowed guest page tables into
account_shadowed(). This avoids a extra gfn-to-memslot lookup and is a
more logical place for this code to live. But most importantly, this
reduces kvm_mmu_alloc_shadow_page()'s reliance on having a struct
kvm_vcpu pointer, which will be necessary when creating new shadow pages
during VM ioctls for eager page splitting.

Note, it is safe to drop the role.level == PG_LEVEL_4K check since
account_shadowed() returns early if role.level > PG_LEVEL_4K.

No functional change intended.

Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index d342fcc5813d..6a3b1b00f02b 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -792,6 +792,9 @@ static void account_shadowed(struct kvm *kvm, struct kvm_mmu_page *sp)
 						    KVM_PAGE_TRACK_WRITE);
 
 	kvm_mmu_gfn_disallow_lpage(slot, gfn);
+
+	if (kvm_mmu_slot_gfn_write_protect(kvm, slot, gfn, PG_LEVEL_4K))
+		kvm_flush_remote_tlbs_with_address(kvm, gfn, 1);
 }
 
 void account_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp)
@@ -2098,11 +2101,8 @@ static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm_vcpu *vcpu,
 	sp->gfn = gfn;
 	sp->role = role;
 	hlist_add_head(&sp->hash_link, sp_list);
-	if (sp_has_gptes(sp)) {
+	if (sp_has_gptes(sp))
 		account_shadowed(vcpu->kvm, sp);
-		if (role.level == PG_LEVEL_4K && kvm_vcpu_write_protect_gfn(vcpu, gfn))
-			kvm_flush_remote_tlbs_with_address(vcpu->kvm, gfn, 1);
-	}
 
 	return sp;
 }
-- 
2.36.0.550.gb090851708-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
