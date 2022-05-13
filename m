Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 233AFC433F5
	for <kvmarm@archiver.kernel.org>; Sat, 14 May 2022 10:09:07 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C028A4B1C6;
	Sat, 14 May 2022 06:09:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bhG-QPGZOVYd; Sat, 14 May 2022 06:09:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 738A44B219;
	Sat, 14 May 2022 06:08:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7B8EF4B14C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 May 2022 16:28:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xfdxNWeuVZHy for <kvmarm@lists.cs.columbia.edu>;
 Fri, 13 May 2022 16:28:42 -0400 (EDT)
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com
 [209.85.216.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 639EC49F07
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 May 2022 16:28:42 -0400 (EDT)
Received: by mail-pj1-f73.google.com with SMTP id
 t15-20020a17090a3b4f00b001d67e27715dso6713387pjf.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 May 2022 13:28:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=fScK4lvuJyuU42NFoLm0OON5ITyyiDkyHzjcV83EFqI=;
 b=aL+4n5FgxmVKFh7F5Bt67HqG+J2qQUhuBh3wos9f+VD7hGVD81zzElxq/koyhZFgDZ
 C0tKwovEEPxpqfsZ61X3Eb/sGvbI+f+L0faf+zfVZ+HqpY2CIEtgtr1tIz7WeO1FJk1p
 I+NO4ghx3JpILB8E/TcsTvWw5Jyx9Xt92B5NPZw5NLQlU/UT+J0zuDWPIVfAvVwjUD2p
 nomsi78cdRnFpAHBpLmhFmy+0eY23fyI9MB5B4cbBoNa1zgmT8DLuQs/gsgEhnPLrlTB
 DtqCfD04UG7dmBzDDwFFmG+s0ZJi+Bm9XPs35xhQEsXQh9bjWuZE7sV4YIyj0/aVQyDe
 hKmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=fScK4lvuJyuU42NFoLm0OON5ITyyiDkyHzjcV83EFqI=;
 b=7C3tbbC7LGQWAvbVPQkbtwh4P75KejlTlVvK5jzqQEJkVX0gSGun2zzxP1dwFFd0kK
 kyD+B0nh9HtLN37hsLo7PtvnxftTZFq7GdIlF4MLOPH514DN49tJjlbZGAgqDgfFbf6q
 44vvVInFB64mL0gtqi1VvPA2l4caZMPXPNDW6ciYLpNSyqOCfAR3zCIwGZotjWHkBWWN
 WAB2L12E0aFMDzXelivUIjFLBS75bjrNErhHFcjAd99Ni1KIABSuWc+k+aiUAkHyVvoJ
 jfrZ/fd/KbD5Hq/q3D3Ulb/bGvtICuYIDmSl6M73DlnloS4VfH3PAVCDedRFOlANjYZ3
 HV0g==
X-Gm-Message-State: AOAM532F8u4TobQ/cbTG6k3Ro03OT8avRsClacanO7Lt6w1bUAKZHfUW
 jpWsEKDbgxXvSOSk7lNPwso+BWmbp5aJNg==
X-Google-Smtp-Source: ABdhPJxTk2/Hk3H67iJ+ptMF1GJpY+MWXmC2trsgpmoBpCRkxirXB3r44DMKvAFZqafXEXOdnnbKUl0VcVfvLQ==
X-Received: from dmatlack-heavy.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90a:8d83:b0:1dd:258c:7c55 with SMTP
 id d3-20020a17090a8d8300b001dd258c7c55mr250785pjo.1.1652473720072; Fri, 13
 May 2022 13:28:40 -0700 (PDT)
Date: Fri, 13 May 2022 20:28:04 +0000
In-Reply-To: <20220513202819.829591-1-dmatlack@google.com>
Message-Id: <20220513202819.829591-7-dmatlack@google.com>
Mime-Version: 1.0
References: <20220513202819.829591-1-dmatlack@google.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
Subject: [PATCH v5 06/21] KVM: x86/mmu: Consolidate shadow page allocation and
 initialization
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

Consolidate kvm_mmu_alloc_page() and kvm_mmu_alloc_shadow_page() under
the latter so that all shadow page allocation and initialization happens
in one place.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 39 +++++++++++++++++----------------------
 1 file changed, 17 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index ce334eaeef22..fd749748b280 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1690,27 +1690,6 @@ static void drop_parent_pte(struct kvm_mmu_page *sp,
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
@@ -2098,7 +2077,23 @@ static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm_vcpu *vcpu,
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
2.36.0.550.gb090851708-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
