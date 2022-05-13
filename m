Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CB6EC433F5
	for <kvmarm@archiver.kernel.org>; Sat, 14 May 2022 10:09:09 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E9164B120;
	Sat, 14 May 2022 06:09:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id oXTRkSd2xmDK; Sat, 14 May 2022 06:09:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B7B534B214;
	Sat, 14 May 2022 06:08:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 79960408B3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 May 2022 16:28:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qRT+BIevp7Di for <kvmarm@lists.cs.columbia.edu>;
 Fri, 13 May 2022 16:28:45 -0400 (EDT)
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com
 [209.85.216.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 57F7849EF6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 May 2022 16:28:45 -0400 (EDT)
Received: by mail-pj1-f73.google.com with SMTP id
 z14-20020a17090a66ce00b001dd05e92bb8so4469802pjl.4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 May 2022 13:28:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=YwNKalyIZ3UJYnYeqEZ2vPBjdq/oTIfQFtRpNbYKlF4=;
 b=scRiEVtR5ODO/Z6xBJxacmworrew2ZSkJBpk7W3tLsvvLPXlxlVHw5GeEUWXc19lsm
 1teXsz1UfKXmv7zfBX/A4/HJTtOdMFf6MOPP0cQYGlQ9R4TDpcnnCiUax8XqRdrDu3gZ
 HBRGK3oBSLwUnT2JtCQG+Ti2R+VXK9UlSd60oUY4tPEdZuDw8WdBUYH8RNzqhKh0YKAC
 cPOafm+wxhOceLV24DBXVhdA6wm1zbxdlDaUXHWIPf+NBy1bCECvQZeroO/vEaPKmmZQ
 o+cpH/SHvA9Non6PQpq86GLd+GwZUDomlGo/F/2OI7Lxjcw+sdqG2kN2TrMAYGnoQN6W
 lQDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=YwNKalyIZ3UJYnYeqEZ2vPBjdq/oTIfQFtRpNbYKlF4=;
 b=F75tz2S1tUxdezXzMAdDC1JNDzGq+zVFfVsLY6ksBcsb2AyzbYUTBbIsD6lHLZFFIN
 0j1UlXpU5I3s0hh3rs3PYv0J5KIIP9gzz0NUcBFLRmz/W6qXcLzrJo1YL1Q3HUDfd2+D
 AOrB4ObabydX+EWqGFa3L8EK2px43+KaXNAY3gZYzUQkv3SumyVmlWTyKplgQgBUI/Nt
 QqzE6QlBS2rVbadfYHBC/m6pOQvTX0pZOBm7KlFVANzegQLk71TpDifImPmn43z2PoB7
 Ik+YMQZEdDcB5nZ3ct4legX90VE0pt7l+YW3bflTDUi4ZoqT6No7YFboLikTy8JgyHQ9
 IybA==
X-Gm-Message-State: AOAM533NuzgTPRFs0XZr9KrWu85ASPlizLgRhKf5rWt7vS2OkLQ6q7QF
 gQwqcPev66LXyAKBi95d4f7dcQJ9/UFQ4g==
X-Google-Smtp-Source: ABdhPJyUotFl8ncaxi3GXHFFHrMGIH0MPMn/whwj/bexKyA2/QSgH6f4JKNjLvZuTaGisFxW3CGn+MkRF/s3sg==
X-Received: from dmatlack-heavy.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:902:e94e:b0:15b:22a7:f593 with SMTP
 id b14-20020a170902e94e00b0015b22a7f593mr6098879pll.148.1652473724471; Fri,
 13 May 2022 13:28:44 -0700 (PDT)
Date: Fri, 13 May 2022 20:28:06 +0000
In-Reply-To: <20220513202819.829591-1-dmatlack@google.com>
Message-Id: <20220513202819.829591-9-dmatlack@google.com>
Mime-Version: 1.0
References: <20220513202819.829591-1-dmatlack@google.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
Subject: [PATCH v5 08/21] KVM: x86/mmu: Move guest PT write-protection to
 account_shadowed()
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
index 4bbb6821f861..16001b019e1a 100644
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
