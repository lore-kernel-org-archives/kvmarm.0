Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C89CCC4332F
	for <kvmarm@archiver.kernel.org>; Sat, 14 May 2022 10:09:10 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7E8594B1BA;
	Sat, 14 May 2022 06:09:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LpmANhBECUvC; Sat, 14 May 2022 06:09:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0412A4B24E;
	Sat, 14 May 2022 06:08:57 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A185408B3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 May 2022 16:28:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HSAjrbpAGQkt for <kvmarm@lists.cs.columbia.edu>;
 Fri, 13 May 2022 16:28:49 -0400 (EDT)
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com
 [209.85.216.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 84F5649F07
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 May 2022 16:28:49 -0400 (EDT)
Received: by mail-pj1-f73.google.com with SMTP id
 t15-20020a17090a3b4f00b001d67e27715dso6713387pjf.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 May 2022 13:28:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=CwrcgeCnZaI9Kb99PpD8if7FCspqnLoqOT2kQ5Xs/+4=;
 b=nl0oBe0q5H9KBq184P1+NocGitZ1+UG63V+ABA1KS0jlqspMxpp2m/2LNkaib25Qv3
 eB4OIPIYG/G7QdE2pLrRij6GHtqqaFJCSiE74IeKzA68oJf7Xcd5zlNyPOLHNIUOOOVa
 7snmpA1PtYy/LJjQVUQlFypuw0GI0PXCObO75p8W+ZygU7Jm4DOgR8XlF5q+AktB2ykx
 cui8KqO+TSFtGaYuQJ+xugrFueSbdqXBWmCmfcMwgTK3cYlx00Yk7+jtiV4wi0Rxr+ao
 RGUK2X+PJP4r7DTRRVsg9XYumQkdkroMx5rfObOsHbA9LikUDBqHJnSrrhKTfLxC96RJ
 F9GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=CwrcgeCnZaI9Kb99PpD8if7FCspqnLoqOT2kQ5Xs/+4=;
 b=AFPlFsBWc+uXrXg4CRUBKu22bwMr4+JwIPVBEgMyPmdx/Le0SfBhLgcjDFrMkY6dsA
 fvjPBUhXy5RzKbjeWf4cVntRLalgQ12ztTxfAxab56Rg9/2XiOB5qgzvx5R2TuB2Ht6b
 /hZWBiPzdI/I87Awyg7pkgjuZ4Bjhf5h9kgLiBkP2BTFr9pZ6e5etG2GH9ErMQNzQF0x
 mt/F0Bp1vyYjv0uJMj8S0gAdgXmw4W8Yh+w7plRjP55j+spKHARjh1CeZyDAmWbQBbyL
 +0P7U49uUiQhNY3ePf3kVVY2fEcM5Qt1On29t32kovO6M6+czveZA2ONTUZxwl7k08QQ
 aeWw==
X-Gm-Message-State: AOAM531w82jwOv9B2/pljulv+exzjng48ITSQPno8lih18xI5Zt97zUY
 2HaYkk7cZ9xiIhRTLSVq4NoK0+lTptnJAQ==
X-Google-Smtp-Source: ABdhPJxMTXDF5w4ikRkcssEqC/dmQGiMJc+viHbpMOvq3rp+5KUSJr/bsT7WG99GXpeSz+Vwo7UGSaIWMHgNJA==
X-Received: from dmatlack-heavy.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90a:e510:b0:1d9:ee23:9fa1 with SMTP
 id t16-20020a17090ae51000b001d9ee239fa1mr250711pjy.0.1652473727619; Fri, 13
 May 2022 13:28:47 -0700 (PDT)
Date: Fri, 13 May 2022 20:28:08 +0000
In-Reply-To: <20220513202819.829591-1-dmatlack@google.com>
Message-Id: <20220513202819.829591-11-dmatlack@google.com>
Mime-Version: 1.0
References: <20220513202819.829591-1-dmatlack@google.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
Subject: [PATCH v5 10/21] KVM: x86/mmu: Replace vcpu with kvm in
 kvm_mmu_alloc_shadow_page()
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
X-Mailman-Approved-At: Sat, 14 May 2022 06:08:54 -0400
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
index 44431c0b797f..9cc73c3453c3 100644
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
