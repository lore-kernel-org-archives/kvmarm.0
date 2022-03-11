Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC0E5C4332F
	for <kvmarm@archiver.kernel.org>; Fri, 11 Mar 2022 08:49:00 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6999449F0B;
	Fri, 11 Mar 2022 03:49:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id quKFgGtYtaxY; Fri, 11 Mar 2022 03:48:59 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 839F04A10E;
	Fri, 11 Mar 2022 03:48:44 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9FEAE40C52
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 19:26:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aF7tWsA9uYrp for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Mar 2022 19:26:02 -0500 (EST)
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com
 [209.85.215.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7F23640C1B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 19:26:02 -0500 (EST)
Received: by mail-pg1-f201.google.com with SMTP id
 1-20020a630c41000000b00378d9d6bd91so3776876pgm.17
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 16:26:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=sbKWGus3ebobJm3+FVUoYXRe2tQF3TQMqNwj5vm+oQs=;
 b=rVXfocbRBiQbddq7Mymh8A5+rpjWdaiL9E9VqTuaVfs85neIgNVqmcY2867zAHwnJa
 9TkxrBsa1FXUF6fizdhytevf03ZL9ZGE36n9+/W481j9IRCF6RPrAqCOuCHs8jZNwKIx
 WZ8wZGpBYjcCDJjxR4zZSW6m8K6/KkXuyxJuluinWK57EZ80Yg2P+y55gHFkhA6w9Oa1
 ZjUrekfxltWEIcYp6tKHwVmxG/FoOfIojaUB8GXZiciN0zPQtoYypB9jwqwoqblMNs58
 x+sWxZzzU0AXvB2UhlDpsSCnQfHpWc1MNB/G1fw4SMqXvl1aRl6tolbMQZm49L18DnHb
 iqyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=sbKWGus3ebobJm3+FVUoYXRe2tQF3TQMqNwj5vm+oQs=;
 b=j1Ix1Ilr9l1QJlUOsnEe6AxgtBTYiMUsEo5Dxph4o3M9NS36x1H9C0P6SAL5cOZjS6
 UY7gRw7HGa5WtqhlZTBkuKHIRXlIQAUisPfR+tjvSky1TspXwY0gysAoBlOXrwE1QeJQ
 TxjgE+adSy+bZG1cyNuD0Vd1lkYtxaBBr59731F7C06G/gBewJWYFsZ499iaVrZcI49j
 XmshEGHebLXmklgt8jk6J4Ti9hNk5dGTpMnxvTZDYRI8XHqEN9hNHKu58qh8aQSaQ6Ju
 o7z/1vfhj8VqI3gLER5scobUQbQFxeAPKuLayfWxgW/fZnHTxSdqU231HS6JxE7c9x14
 WPrw==
X-Gm-Message-State: AOAM533xQX+xo46TWBR+JSbBOtOVBpSfEXHm/SrqPDcrdLL7+LzydDBw
 qfngXXLsYfqiT7Y5LySNoY0OQeTCRWw44w==
X-Google-Smtp-Source: ABdhPJzlF0dOeLQBpCrN6EQ/1uv182Ojcd8GXVsCcPw3S8P1mroh+hcuj+7wbKMkJW298Mx+vaz9w72iGDnQxg==
X-Received: from dmatlack-heavy.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a05:6a00:890:b0:4f6:686e:a8a9 with SMTP
 id q16-20020a056a00089000b004f6686ea8a9mr7226414pfj.83.1646958361665; Thu, 10
 Mar 2022 16:26:01 -0800 (PST)
Date: Fri, 11 Mar 2022 00:25:20 +0000
In-Reply-To: <20220311002528.2230172-1-dmatlack@google.com>
Message-Id: <20220311002528.2230172-19-dmatlack@google.com>
Mime-Version: 1.0
References: <20220311002528.2230172-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v2 18/26] KVM: x86/mmu: Zap collapsible SPTEs at all levels in
 the shadow MMU
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
X-Mailman-Approved-At: Fri, 11 Mar 2022 03:48:42 -0500
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

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 89a7a8d7a632..2032be3edd71 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6142,18 +6142,30 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
 	return need_tlb_flush;
 }
 
+static void kvm_rmap_zap_collapsible_sptes(struct kvm *kvm,
+					   const struct kvm_memory_slot *slot)
+{
+	bool flush;
+
+	/*
+	 * Note, use KVM_MAX_HUGEPAGE_LEVEL - 1 since there's no need to zap
+	 * pages that are already mapped at the maximum possible level.
+	 */
+	flush = slot_handle_level(kvm, slot, kvm_mmu_zap_collapsible_spte,
+				  PG_LEVEL_4K, KVM_MAX_HUGEPAGE_LEVEL - 1,
+				  true);
+
+	if (flush)
+		kvm_arch_flush_remote_tlbs_memslot(kvm, slot);
+
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
2.35.1.723.g4982287a31-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
