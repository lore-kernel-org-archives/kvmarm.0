Return-Path: <SRS0=1o63=IY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8703C433E2
	for <kvmarm@archiver.kernel.org>; Fri, 26 Mar 2021 13:54:29 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4DDBD61A1E
	for <kvmarm@archiver.kernel.org>; Fri, 26 Mar 2021 13:54:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4DDBD61A1E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DC24E4B44C;
	Fri, 26 Mar 2021 09:54:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id TVC-6oJuRHCs; Fri, 26 Mar 2021 09:54:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9B7C44B4A3;
	Fri, 26 Mar 2021 09:54:25 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 13F444B470
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Mar 2021 22:20:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id g0-FZR2pLq6l for <kvmarm@lists.cs.columbia.edu>;
 Thu, 25 Mar 2021 22:20:18 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1154A4B46C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Mar 2021 22:20:18 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id f124so6578463ybc.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Mar 2021 19:20:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=reply-to:date:in-reply-to:message-id:mime-version:references
 :subject:from:to:cc;
 bh=ekrm2c/tqxhNwDvhLUIyqs8YOIeJgqbSqOnwbax18+4=;
 b=YdcQ98I9Yi31BYfbI5mofNqLu0s7zazK9SXYPeQVW3A0CsE8n8uwBsqfbrz+hNJeQf
 hKlw9Bs18EPix8GTbqdkIeGm9sfXQfWIqb6TGvA147qbGXU1fsBMhocy59Uzn9A3GAyv
 gB5hL59tW49+9qOGxMcoW/9yOyKalk5S1kT135YJHHpScFacGdPRu7tr3SYyNe1mKpiy
 06NU9OU3xpk0kp3BsWshhi6KqV/dH9Rc1GySZ3ZPI1WIwvn5gqlGmaFU8630EnxnDHBt
 KRksC6VkE64tKcsQx0/LKny3LDeHzk+PJJGthXI+fWDcixqCyJZHU6DQXz1ZGjHfs3Zg
 LQtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:reply-to:date:in-reply-to:message-id
 :mime-version:references:subject:from:to:cc;
 bh=ekrm2c/tqxhNwDvhLUIyqs8YOIeJgqbSqOnwbax18+4=;
 b=BqcFVA9Kkfsg0hhq2V5XqLs1rI3NP5wFQu+pWOX51j5n6FIi1M8aPdBQxZQeTeLZMZ
 erhCUgjJltwu0dPU7cFUk7ZmJ6xLR7lWoAHrKpEbrnY4SFyAUW7xehwjONxVe48LoI2S
 yPXttyKbPVTq2z0msbTwYz43g9xm5mZpSNv9vUzfqalt5ATZB669nnwaFBTfOGdIri1o
 xV738yGe06DOaeuzPweuhyIlVVmSAaVOo0Cd40uvFIE24+ov0G25xQ2ERYszU9pApC+d
 yNkM+HFMth64W+j52NYHNLDqjxc/ZZRTXMdbDtyM2z7CnFgFlSt7E8/OEAeMr6qkuQaI
 huyw==
X-Gm-Message-State: AOAM532hYeiHhZTUpg2oiCvlpZWGzTGL90qxRls3l3mT1XMkYJcGhOHA
 JBP/lkX+uYgpVWt1JbQTIqwqdoWupFg=
X-Google-Smtp-Source: ABdhPJy4BNfi8kFTaWHGl2NnTrrMeNaxLwOf/RoltlD+YFEkS/eJEmRMjOGw4TqA/0qE4SiqmN8Awa2q6w0=
X-Received: from seanjc798194.pdx.corp.google.com
 ([2620:15c:f:10:b1bb:fab2:7ef5:fc7d])
 (user=seanjc job=sendgmr) by 2002:a25:bb41:: with SMTP id
 b1mr16191964ybk.249.1616725217602; 
 Thu, 25 Mar 2021 19:20:17 -0700 (PDT)
Date: Thu, 25 Mar 2021 19:19:42 -0700
In-Reply-To: <20210326021957.1424875-1-seanjc@google.com>
Message-Id: <20210326021957.1424875-4-seanjc@google.com>
Mime-Version: 1.0
References: <20210326021957.1424875-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
Subject: [PATCH 03/18] KVM: x86/mmu: Coalesce TLB flushes when zapping
 collapsible SPTEs
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>, 
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Paul Mackerras <paulus@ozlabs.org>, Paolo Bonzini <pbonzini@redhat.com>
X-Mailman-Approved-At: Fri, 26 Mar 2021 09:54:23 -0400
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Sean Christopherson <seanjc@google.com>, Joerg Roedel <joro@8bytes.org>,
 linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Ben Gardon <bgardon@google.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 kvmarm@lists.cs.columbia.edu, Jim Mattson <jmattson@google.com>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: Sean Christopherson <seanjc@google.com>
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

Gather pending TLB flushes across both the legacy and TDP MMUs when
zapping collapsible SPTEs to avoid multiple flushes if both the legacy
MMU (for nested guests) and TDP MMU have mappings for the memslot.

Note, this also optimizes the TDP MMU to flush only the relevant range
when running as L1 with Hyper-V enlightenments.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c     | 6 ++++--
 arch/x86/kvm/mmu/tdp_mmu.c | 8 +++-----
 arch/x86/kvm/mmu/tdp_mmu.h | 4 ++--
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index d5c9fb34971a..37e2432c78ca 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5607,11 +5607,13 @@ void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
 
 	write_lock(&kvm->mmu_lock);
 	flush = slot_handle_leaf(kvm, slot, kvm_mmu_zap_collapsible_spte, true);
+
+	if (is_tdp_mmu_enabled(kvm))
+		flush = kvm_tdp_mmu_zap_collapsible_sptes(kvm, slot, flush);
+
 	if (flush)
 		kvm_arch_flush_remote_tlbs_memslot(kvm, slot);
 
-	if (is_tdp_mmu_enabled(kvm))
-		kvm_tdp_mmu_zap_collapsible_sptes(kvm, slot);
 	write_unlock(&kvm->mmu_lock);
 }
 
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 463f1be6ff0d..ff2bb0c8012e 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1320,11 +1320,10 @@ static bool zap_collapsible_spte_range(struct kvm *kvm,
  * Clear non-leaf entries (and free associated page tables) which could
  * be replaced by large mappings, for GFNs within the slot.
  */
-void kvm_tdp_mmu_zap_collapsible_sptes(struct kvm *kvm,
-				       struct kvm_memory_slot *slot)
+bool kvm_tdp_mmu_zap_collapsible_sptes(struct kvm *kvm,
+				       struct kvm_memory_slot *slot, bool flush)
 {
 	struct kvm_mmu_page *root;
-	bool flush = false;
 	int root_as_id;
 
 	for_each_tdp_mmu_root_yield_safe(kvm, root) {
@@ -1335,8 +1334,7 @@ void kvm_tdp_mmu_zap_collapsible_sptes(struct kvm *kvm,
 		flush = zap_collapsible_spte_range(kvm, root, slot, flush);
 	}
 
-	if (flush)
-		kvm_flush_remote_tlbs(kvm);
+	return flush;
 }
 
 /*
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 715aa4e0196d..9ecd8f79f861 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -54,8 +54,8 @@ void kvm_tdp_mmu_clear_dirty_pt_masked(struct kvm *kvm,
 				       struct kvm_memory_slot *slot,
 				       gfn_t gfn, unsigned long mask,
 				       bool wrprot);
-void kvm_tdp_mmu_zap_collapsible_sptes(struct kvm *kvm,
-				       struct kvm_memory_slot *slot);
+bool kvm_tdp_mmu_zap_collapsible_sptes(struct kvm *kvm,
+				       struct kvm_memory_slot *slot, bool flush);
 
 bool kvm_tdp_mmu_write_protect_gfn(struct kvm *kvm,
 				   struct kvm_memory_slot *slot, gfn_t gfn);
-- 
2.31.0.291.g576ba9dcdaf-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
