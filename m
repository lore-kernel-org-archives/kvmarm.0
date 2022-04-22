Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C3E8C433EF
	for <kvmarm@archiver.kernel.org>; Sat, 23 Apr 2022 08:57:23 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 160DE4B222;
	Sat, 23 Apr 2022 04:57:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IVi0AK7e8CiC; Sat, 23 Apr 2022 04:57:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CF7724B2C2;
	Sat, 23 Apr 2022 04:57:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D46E49F10
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Apr 2022 17:06:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YffnHkuZTWiQ for <kvmarm@lists.cs.columbia.edu>;
 Fri, 22 Apr 2022 17:06:17 -0400 (EDT)
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com
 [209.85.210.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1CA7940C31
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Apr 2022 17:06:17 -0400 (EDT)
Received: by mail-pf1-f201.google.com with SMTP id
 z19-20020a62d113000000b0050d183adf6fso144706pfg.19
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Apr 2022 14:06:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=YRFXEHEQ0F/L+OIhMiFnoup0hMtFO1aikfS1l340O28=;
 b=LHO6hoSehDzcaxSmuBNa69LqsXqu0X0QCiplTSjHBpc1i+UDmeX5+dmuJ10h+RNVw6
 A770B5ZPMS/iNMSiAp/9LoSs1vNvRBSjsSW/Lrt5QwGLrVMmD9DC54Yp46TY1I85yfN7
 +5cRK6EAaeGNXeoiAXhq0ErhfRwjotp9q1eafRcLhwfpWucB/5uKVZestkC02mfRfbNP
 Y1CcdI84uzdZcL3Qu/jYFxG7Y1M/hNgq6k2jJJLJT+xpkhyj0bLC+KwC2mvCA6ZwCTks
 zL03Iu7Z7aNo0NEmzTqXPy0v+ueNYazP83L7mOzrRlcQLtjImcMEq37GsxA0zV8Av3uD
 x4Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=YRFXEHEQ0F/L+OIhMiFnoup0hMtFO1aikfS1l340O28=;
 b=EVCCMfimGZsf9Dvv96rEPiMDmdG5lCfVGeg/4Ly3IMRfhYWNC147MMJ+uHcyAL/jHV
 WoFoTvgvABXkVaZ9vIrcARkBq2qpeQgcnMAAQ7mtKkMTkA5jxO0AtAO2ZsqMgxM8rigw
 wQCA7UKjeUswngBgxLV9pvQ55DzBNv3npvVSnqtIUBU7tDNuxgG6O7o2qhEsao4pFD1a
 bJE76nSCKezeO0namhyVosoo+CRusSRc4u3TytLafBwsZgRdZKWCiDcT9k7dVMlaa421
 RSvxSmtaeQxZC4AoWgsjZz1w85pwBOGGeOx1TDVmkeZmchBhl9yWQkKFOVEzZvDfa76k
 vBHw==
X-Gm-Message-State: AOAM530YrWXrNnhZIX6O0m7ED57AXKlvgP1N+PkA4D8Mcg+VlMhgSsvM
 HzAEn/adhMVwmMGn1E/6xzG/wFrtrLYBpg==
X-Google-Smtp-Source: ABdhPJw/oNy0+kaJBwCxf5EoazVKoHTTI1UYGMDmSr5beP3OKAGQj/xL5RIUegS6CG2XgI5IG997Vq/y6udlcw==
X-Received: from dmatlack-heavy.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a62:3083:0:b0:505:f7ac:c4a6 with SMTP id
 w125-20020a623083000000b00505f7acc4a6mr6919416pfw.66.1650661576253; Fri, 22
 Apr 2022 14:06:16 -0700 (PDT)
Date: Fri, 22 Apr 2022 21:05:43 +0000
In-Reply-To: <20220422210546.458943-1-dmatlack@google.com>
Message-Id: <20220422210546.458943-18-dmatlack@google.com>
Mime-Version: 1.0
References: <20220422210546.458943-1-dmatlack@google.com>
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
Subject: [PATCH v4 17/20] KVM: x86/mmu: Zap collapsible SPTEs at all levels in
 the shadow MMU
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

Currently KVM only zaps collapsible 4KiB SPTEs in the shadow MMU (i.e.
in the rmap). This is fine for now KVM never creates intermediate huge
pages during dirty logging, i.e. a 1GiB page is never partially split to
a 2MiB page.

However, this will stop being true once the shadow MMU participates in
eager page splitting, which can in fact leave behind partially split
huge pages. In preparation for that change, change the shadow MMU to
iterate over all necessary levels when zapping collapsible SPTEs.

No functional change intended.

Reviewed-by: Peter Xu <peterx@redhat.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index ed65899d15a2..479c581e8a96 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6098,18 +6098,25 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
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
2.36.0.rc2.479.g8af0fa9b8e-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
