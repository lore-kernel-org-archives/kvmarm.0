Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 119E9C4332F
	for <kvmarm@archiver.kernel.org>; Fri,  1 Apr 2022 18:21:11 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C246F4B291;
	Fri,  1 Apr 2022 14:21:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BVvzS5U7UkFq; Fri,  1 Apr 2022 14:21:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 455474B2FC;
	Fri,  1 Apr 2022 14:20:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B32514B265
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Apr 2022 13:56:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id O71uYgjPTtyl for <kvmarm@lists.cs.columbia.edu>;
 Fri,  1 Apr 2022 13:56:30 -0400 (EDT)
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com
 [209.85.214.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8FEB44B216
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Apr 2022 13:56:30 -0400 (EDT)
Received: by mail-pl1-f202.google.com with SMTP id
 z8-20020a170903018800b001566875e0f5so1229755plg.21
 for <kvmarm@lists.cs.columbia.edu>; Fri, 01 Apr 2022 10:56:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=bPjRdwbrgeaGoRO6D9pIVUv9XL1QVrE/jZ7frr9Y9sk=;
 b=HKXVYj5bLgLQDNl0Yp3f3Cxk0xEfw/WwCidCusFgYIXZPgwnivI6+Ih1CXvlNY8wv+
 0SB7IO2lfWqyxHZXsqnHLnT0QBt4/Kn5lk5EW8K9iW1NthwnnpRVMkumhd4k1OQE77wT
 S2O1Z7AitpIGEox5Qh5FKe0zYHXrRWVT9NJBODMGEgo+t6A06dO9q/xdIDofE1nFLYnl
 tWGum6qGeGVSd65XaJizCavBESlaKNmwmbP75qcI6R+2txzDbk0mbonxSd1y21Sie2vy
 W5UgLGjdxmVDqUWGtPF5QIJMbd5Gcb1De7NMCzJgjAuAzu6A7T0xAsFyXc5SNRC5Sf5R
 j+lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=bPjRdwbrgeaGoRO6D9pIVUv9XL1QVrE/jZ7frr9Y9sk=;
 b=eG9UHftadKq2QUJLP5yaNti0F+YNoWeMpgfujh4caawJ4O8KV4a6z/JFjkgdPnckDG
 dLbf09ch4BBy27Y7nHIuQWpqthZ3U3OL1v9u6CQI9B9O5oqN1hY/vn82+EGPYB/F/enx
 XpjwKP3mhI2VDi8LH+XFIe4WDn+6jCFTYTyPLsnSyrfM5UQXLy7eyzCEUhmLwTD7KJIy
 hDOI1yG3zjhRyHNaWip1gErnWr3m5Xmv7ogCYufqS52XqVXU2SnEZwUTr1n/L2LjencS
 BQOmvR21zxGiAEyQtDOfwhbEwi91JmM4EWo00KIYY7OAMVv2xPiou8YQIQO7wmHL/N80
 8IFQ==
X-Gm-Message-State: AOAM531vC/sDFLcqUaio6gIlDcR9/ZR/Sq+TTF9cSZeY3f7CX+K7MPr8
 Ps7Ekk4bxY0A282dmhCqKQHw5H5jEayYQA==
X-Google-Smtp-Source: ABdhPJwAwneAua3CK3hqlxT6AVdmOtu9SNJP0PRrgeiWzgw657lKsS+2gpSEl29HSjZknUEHAGP38CQTV81Y8Q==
X-Received: from dmatlack-heavy.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:902:d888:b0:151:6fe8:6e68 with SMTP
 id b8-20020a170902d88800b001516fe86e68mr11236930plz.158.1648835789747; Fri,
 01 Apr 2022 10:56:29 -0700 (PDT)
Date: Fri,  1 Apr 2022 17:55:49 +0000
In-Reply-To: <20220401175554.1931568-1-dmatlack@google.com>
Message-Id: <20220401175554.1931568-19-dmatlack@google.com>
Mime-Version: 1.0
References: <20220401175554.1931568-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH v3 18/23] KVM: x86/mmu: Zap collapsible SPTEs at all levels in
 the shadow MMU
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
X-Mailman-Approved-At: Fri, 01 Apr 2022 14:20:42 -0400
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
index 3a425ed80e23..6390b23d286a 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6172,18 +6172,25 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
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
2.35.1.1094.g7c7d902a7c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
