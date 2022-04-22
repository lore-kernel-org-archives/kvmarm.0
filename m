Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26C7BC433FE
	for <kvmarm@archiver.kernel.org>; Sat, 23 Apr 2022 08:57:20 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CC2F74B29B;
	Sat, 23 Apr 2022 04:57:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0iyL9BhESVGS; Sat, 23 Apr 2022 04:57:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7236D4B2B2;
	Sat, 23 Apr 2022 04:57:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 89F3340C31
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Apr 2022 17:06:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id twBGBeb+4vYD for <kvmarm@lists.cs.columbia.edu>;
 Fri, 22 Apr 2022 17:06:12 -0400 (EDT)
Received: from mail-oi1-f202.google.com (mail-oi1-f202.google.com
 [209.85.167.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6538F49F10
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Apr 2022 17:06:12 -0400 (EDT)
Received: by mail-oi1-f202.google.com with SMTP id
 c10-20020aca350a000000b003224bef8f56so4046360oia.13
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Apr 2022 14:06:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=1Ma2mq2tqg3XF3cItnkEgAe0AbxTi5US5d6CkbxLyzY=;
 b=S9ojBi7tDpDCaCxycspq3eDg4sEc0jn081aq6nEMyQfLnL7gAjoNKktXvPrXiS+n/u
 CWyt8oiu1mTkCxx7K4/m1IB8VJich1zJPODqXFhJtBj0uOiamEJAvlSkX//xN3hF7JEq
 yQOYAB4Me8+Lyz9BWM86FfwQ0m8+ln7/I1xYK5r8GUiB04ZYrZXw4BvfshlpFRk9Pk+h
 0/Fu66hOYjoVMUBRCB3iQY0QnmRhvJSA1eKyu7nJ6kuHd5hHR6U7PAqOv9e1f4YylWzf
 aXTP4IdMiJa/WFK5npwCXMJw83etTBNT+q21glnPVqLQurDK4Rc2f5VtGRgEB1O0mszs
 i9tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=1Ma2mq2tqg3XF3cItnkEgAe0AbxTi5US5d6CkbxLyzY=;
 b=FZu6sCMrcritoBCbxPXHOT285J7MU4cOVaOVCDwuzSNwWWLmgu5zTcuoDY0qoyNexK
 vG7RAdhyh+pDB4o6kBccbZdyAD7fau/N7PZZmZXXWCi3o67IJGNwUfQc139W1irPskgb
 exwofVUsYB5Pp2DyMJp3tAZikKH88OuQIHt1aUdZJNPDC3MVRlwZdyJpla8rAi/CkMLy
 gjWG4fxjulTIT2KdD9Um7O5fbt8/gr3w/XHKLxHfUolKi/0+5ixA4lXrtkJbF9/5Dobo
 7DFlayKfLxD++WaX1660asBiGWrVEx4wrDhgcHw4b33jpUkWG0XsOcmEHHAK4eYgKsqN
 LEwA==
X-Gm-Message-State: AOAM530R0qBiqtAmvDyY29+7vCxps9ruybWWwdRl9PPdNYKHIYcFY3OH
 eF+97gfAgrb+06OQhmI0SooinLMItPyKiw==
X-Google-Smtp-Source: ABdhPJwDDjoIaawjtg4ZDhMJO2ZlhsA18/U9VjgwlgPxS2OgCNgVlFFPSW6zH30w8J4mMULUnwBK45IzNNn2HQ==
X-Received: from dmatlack-heavy.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a05:6870:430a:b0:e2:776b:bf05 with SMTP
 id w10-20020a056870430a00b000e2776bbf05mr2836930oah.269.1650661571558; Fri,
 22 Apr 2022 14:06:11 -0700 (PDT)
Date: Fri, 22 Apr 2022 21:05:40 +0000
In-Reply-To: <20220422210546.458943-1-dmatlack@google.com>
Message-Id: <20220422210546.458943-15-dmatlack@google.com>
Mime-Version: 1.0
References: <20220422210546.458943-1-dmatlack@google.com>
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
Subject: [PATCH v4 14/20] KVM: x86/mmu: Update page stats in __rmap_add()
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
X-Mailman-Approved-At: Sat, 23 Apr 2022 04:57:06 -0400
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

Update the page stats in __rmap_add() rather than at the call site. This
will avoid having to manually update page stats when splitting huge
pages in a subsequent commit.

No functional change intended.

Reviewed-by: Ben Gardon <bgardon@google.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index ed23782eef8a..6a190fe6c9dc 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1601,6 +1601,8 @@ static void __rmap_add(struct kvm *kvm,
 
 	sp = sptep_to_sp(spte);
 	kvm_mmu_page_set_gfn(sp, spte - sp->spt, gfn);
+	kvm_update_page_stats(kvm, sp->role.level, 1);
+
 	rmap_head = gfn_to_rmap(gfn, sp->role.level, slot);
 	rmap_count = pte_list_add(cache, spte, rmap_head);
 
@@ -2818,7 +2820,6 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
 
 	if (!was_rmapped) {
 		WARN_ON_ONCE(ret == RET_PF_SPURIOUS);
-		kvm_update_page_stats(vcpu->kvm, level, 1);
 		rmap_add(vcpu, slot, sptep, gfn);
 	}
 
-- 
2.36.0.rc2.479.g8af0fa9b8e-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
