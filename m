Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0050C433FE
	for <kvmarm@archiver.kernel.org>; Tue, 17 May 2022 07:02:53 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ABAC64B2A4;
	Tue, 17 May 2022 03:02:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Iz9VNs7aStvb; Tue, 17 May 2022 03:02:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 206714B315;
	Tue, 17 May 2022 03:02:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 613044B1C5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 May 2022 19:22:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rkCMg3xNx5rO for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 May 2022 19:22:12 -0400 (EDT)
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com
 [209.85.216.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3213F49E35
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 May 2022 19:22:12 -0400 (EDT)
Received: by mail-pj1-f73.google.com with SMTP id
 r14-20020a17090a1bce00b001df665a2f8bso374466pjr.4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 May 2022 16:22:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=9KhR9RDv1+HiuWMCW01kkkAtt9xblGLeDY5Rd9GOluE=;
 b=U75UGGKXGg7r+oQ3OVcmu0mq6W+cm3WPmauKSAABW3YrBxgYUVgkP27Q9zzwgSwLbV
 RB+65TyYko8PxRfFPihGm1E1XLsZ1SALREKzaRb7jsyOlzUIshd4X6AbTcRvS2+bsasp
 8crDdLZmh0yEyAnCujwAjBIpMItmDSZeFCBe6NZqCDfHlusZbzSWqHosZJbBR+C/VDBL
 iPcvx4aIj38s6LMSnbzuldDiFQTXS25ZCKu69EjGM0IYswX8h4KgSRS3/FZUVjEb/uYa
 rDP3oGuLcsHj0MuopRisu5wfQLVFB6oDQ3kPK3zS+/00Nekf7LXtCdnZ/uebIRh5MC59
 6T4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=9KhR9RDv1+HiuWMCW01kkkAtt9xblGLeDY5Rd9GOluE=;
 b=FOMRAesKuxkK7nhfwq61F70/+PoAEjq+0fd/QxDioscAKvtRrs161dlfq5M26LdUiB
 mRlo2t3qWThomcyqmG/1vD8kvxu/F+twL87SI0VdvDVcJ0Y5DTQvWoAK+E3HRh4fDY5j
 AuvdAmCyG0hH4oqsPxvS11c+QEhyN0PpMtBHU6iZ1cuHhbQeMsZb/Z6fFhsZnbGDisdC
 2Wv6AbEWOZeQ1TyjwYCbH5mDKiRoNAfoqkJkbW3bPY/7J2c5rYTLIyqMA218NbVkg4nU
 cIAn6MbCVHTyjhwon6VrEwPh74BTjimvvFZ8XVYa0L+Eby9g650hho4cHQLTvWgEftr4
 Kw1w==
X-Gm-Message-State: AOAM532BVr/aH86ng1a4aJIJy7X0RUCFqSOTI6a32Nrs//k5ZIT4rzn6
 XebAan6NK1LTAtXMZ8TmKzj/AHGs3ljCPg==
X-Google-Smtp-Source: ABdhPJxn1Adbrwr0spJT4PBgbyAjVTi3h3KvTvBoOu5lD4Q8uCIbo04/FCFaG2Su7HH2diIb7ajVBHtfJAwHEw==
X-Received: from dmatlack-heavy.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90b:4b01:b0:1dc:6fee:508a with SMTP
 id lx1-20020a17090b4b0100b001dc6fee508amr22257145pjb.127.1652743331750; Mon,
 16 May 2022 16:22:11 -0700 (PDT)
Date: Mon, 16 May 2022 23:21:35 +0000
In-Reply-To: <20220516232138.1783324-1-dmatlack@google.com>
Message-Id: <20220516232138.1783324-20-dmatlack@google.com>
Mime-Version: 1.0
References: <20220516232138.1783324-1-dmatlack@google.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
Subject: [PATCH v6 19/22] KVM: x86/mmu: Zap collapsible SPTEs in shadow MMU at
 all possible levels
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

Currently KVM only zaps collapsible 4KiB SPTEs in the shadow MMU. This
is fine for now since KVM never creates intermediate huge pages during
dirty logging. In other words, KVM always replaces 1GiB pages directly
with 4KiB pages, so there is no reason to look for collapsible 2MiB
pages.

However, this will stop being true once the shadow MMU participates in
eager page splitting. During eager page splitting, each 1GiB is first
split into 2MiB pages and then those are split into 4KiB pages. The
intermediate 2MiB pages may be left behind if an error condition causes
eager page splitting to bail early.

No functional change intended.

Reviewed-by: Peter Xu <peterx@redhat.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index f83de72feeac..a5d96d452f42 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6177,18 +6177,25 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
 	return need_tlb_flush;
 }
 
+static void kvm_rmap_zap_collapsible_sptes(struct kvm *kvm,
+					   const struct kvm_memory_slot *slot)
+{
+	/*
+	 * Note, use KVM_MAX_HUGEPAGE_LEVEL - 1 since there's no need to zap
+	 * pages that are already mapped at the maximum possible level.
+	 */
+	if (slot_handle_level(kvm, slot, kvm_mmu_zap_collapsible_spte,
+			      PG_LEVEL_4K, KVM_MAX_HUGEPAGE_LEVEL - 1,
+			      true))
+		kvm_arch_flush_remote_tlbs_memslot(kvm, slot);
+}
+
 void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
 				   const struct kvm_memory_slot *slot)
 {
 	if (kvm_memslots_have_rmaps(kvm)) {
 		write_lock(&kvm->mmu_lock);
-		/*
-		 * Zap only 4k SPTEs since the legacy MMU only supports dirty
-		 * logging at a 4k granularity and never creates collapsible
-		 * 2m SPTEs during dirty logging.
-		 */
-		if (slot_handle_level_4k(kvm, slot, kvm_mmu_zap_collapsible_spte, true))
-			kvm_arch_flush_remote_tlbs_memslot(kvm, slot);
+		kvm_rmap_zap_collapsible_sptes(kvm, slot);
 		write_unlock(&kvm->mmu_lock);
 	}
 
-- 
2.36.0.550.gb090851708-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
