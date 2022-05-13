Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F618C433FE
	for <kvmarm@archiver.kernel.org>; Sat, 14 May 2022 10:09:18 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 206DD4B187;
	Sat, 14 May 2022 06:09:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4a0ecUpvaQlt; Sat, 14 May 2022 06:09:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E15D54B287;
	Sat, 14 May 2022 06:08:57 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D16EA49EF6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 May 2022 16:29:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DhJRhNLlORJZ for <kvmarm@lists.cs.columbia.edu>;
 Fri, 13 May 2022 16:29:02 -0400 (EDT)
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com
 [209.85.216.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C46A4408B3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 May 2022 16:29:02 -0400 (EDT)
Received: by mail-pj1-f74.google.com with SMTP id
 h23-20020a17090a051700b001dc9132f2e6so4467595pjh.6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 May 2022 13:29:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=MjdBhjTMyWiNYLQ92OvnchEQMwpl50s0BF9gErhk/qw=;
 b=ivS4hX8UQGxzHHP4LGtA3lv7pXm+WFIaL4yzXYfj4TN74wHiqJ2mnN/xSg/tyeFBfV
 gw6yODIe00oPLxwtSIzDxMOPHk8YygDCpppBsrWabQDW886T+X9KcHQx6P0wqAWLi6G6
 Oq12jL1pT3oZoXZZbm2VEdHN2ZRk0UNEGj5nfc3CIfeQT6QYBGpPolu+7bNOWopmuCtu
 2wU77snDk3sBFq8Mh0rlGpYpbXb7PBrlPdwOogsensPwJk6PImgFi+DiZosYx+nQBCVl
 7TCDsOi/AVq3x+KDqTwvMT1M7KYS2ruDjGiO4C4MZBCTtaluVQbUZrw6gcAsHUcWyVaB
 G1Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=MjdBhjTMyWiNYLQ92OvnchEQMwpl50s0BF9gErhk/qw=;
 b=2y8eTNKnFc0yxnWlBzItJ+XP+Oc55HlZ/CgBYEM6aNoefc2LDic955zY4cF9689leV
 A5gAOFyCrko8EOzbaRawNhw+WgqOaKi5E8pVoJxs9Yfwy9f2GSqFyDkcHtxMgGedaWuz
 1zSjDwUjS0LPkWf/Avfzp/vd0NKRWQ7pI7MgoYHJAdZT9I3KSkLd5CIcbxs/H8hKVsDr
 ZI7GjP8nUfQy568kIQo+tKqtjQ/Fhka6pEYJ8b7o7cqtmLXNOjL3wh5kQMDF5hFhFFUA
 zaiRaCkSvGKa1n3dqyJDyZS/IO2jtSLOGgPmVc9+robTcgih/NPdIJlsrCHrFXBJsUzs
 bWnw==
X-Gm-Message-State: AOAM530EWl7LmJJT2+D9rpGAZex6lRLUKV6DGWoW++HUETgyFv2V7Bmn
 luyOswgaaHV+HTbdSYW3L+hZ+QxSsxnVCQ==
X-Google-Smtp-Source: ABdhPJyVZi3NnOzXfmV774jkoebBCz9dvnFdL0cIiVAAWsfTHuZ9dvhZ/4bXdyVUsznBu4jmJrxZnADAlXLVNQ==
X-Received: from dmatlack-heavy.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:902:c952:b0:15e:9e3d:8e16 with SMTP
 id i18-20020a170902c95200b0015e9e3d8e16mr6532910pla.51.1652473741946; Fri, 13
 May 2022 13:29:01 -0700 (PDT)
Date: Fri, 13 May 2022 20:28:16 +0000
In-Reply-To: <20220513202819.829591-1-dmatlack@google.com>
Message-Id: <20220513202819.829591-19-dmatlack@google.com>
Mime-Version: 1.0
References: <20220513202819.829591-1-dmatlack@google.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
Subject: [PATCH v5 18/21] KVM: x86/mmu: Zap collapsible SPTEs in shadow MMU at
 all possible levels
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
index b411b0d202c8..ef190dd77ccc 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6183,18 +6183,25 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
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
