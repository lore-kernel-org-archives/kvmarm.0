Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BEC0C4332F
	for <kvmarm@archiver.kernel.org>; Sat, 30 Apr 2022 15:48:27 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 11F804B091;
	Sat, 30 Apr 2022 11:48:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Eg8hYiseI4vF; Sat, 30 Apr 2022 11:48:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 579CC4B29A;
	Sat, 30 Apr 2022 11:48:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8320840C1F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 Apr 2022 16:11:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Ykx9ETSTubqO for <kvmarm@lists.cs.columbia.edu>;
 Fri, 29 Apr 2022 16:11:50 -0400 (EDT)
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com
 [209.85.216.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 229E340BE7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 Apr 2022 16:11:50 -0400 (EDT)
Received: by mail-pj1-f74.google.com with SMTP id
 mm2-20020a17090b358200b001bf529127dfso4507067pjb.6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 Apr 2022 13:11:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=WJSDpsc2WvoBFv9mTA61a5Umprsh/icO78ayN0cr9Bs=;
 b=XK8m1lEPYyGBc9UNev+UIJgN/P7IC1BvuvVMJTbn/r6py0F3Lw6Fv3q8ILFyBYMVLZ
 MnvcTtwLPs9qLTOzDrfbzBbzcFsKgFcIpkP1iDnH3nigu5jcxcjT3SQG6HmSeBeeWNXh
 nWqMIpSxa67WhLX5qrBEPIdWZClzZXZCQmTuCwlOQ52XSMIiZurYcyKlAE100i/H4G+X
 p0yV6mz7huTMa+l9U35w3XcRl/r9Xa8/Qmqq531nkOdpeqQgz1iv9qqZRPytgVAUNefO
 TLvub9at+LkqfyoK37ZiP+2KwOj6XQdMrsV1bz+J2e5sV3w4mKrIKmrOwHFLFZvOJ7UN
 qxsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=WJSDpsc2WvoBFv9mTA61a5Umprsh/icO78ayN0cr9Bs=;
 b=uMOoP/SwQ7o0Jv77IVEMCpFsHPuWKcvGlVidd0UJRL3U/JZuZFk67Lzlccs11FmMNi
 HaNEjLtO9BiOog2w82XzWwLGFxY4BK4N45Is1aYMqzWKViwy0Esp7TmWPCPB9It6/rQ2
 d+nfj/ts6G/fmerJVBwluinkfrBWa/JuPJUpyOrbFJeNbNAPffj+P6f3uM/hfL85+V/F
 RactjHzmcTLtt0Ov0jUEhfi1GSf2EEPhjH2sv0MnlbjA+PV8InSkkmxGFNOPkcElbdXe
 5Od6icHauib112U+bKz2xQDEmBplnft8dmY0EBTaAuQTLDfee2NPOITRWrw+KQL7JKBs
 KfWg==
X-Gm-Message-State: AOAM530WvVjZgLWHJMZcRgR/JNrTHasu6gsisy6weAq9ElCUzqRibYMG
 27Td8mlS7DBEiux5r2lRduHNiZCPc8S6MAwo
X-Google-Smtp-Source: ABdhPJy8M95IzubrsL7x95NvP2WiBYnG038db0b/2iw0dRRfI3FAVtvV34XGoZ0NsslM2ywf/tGMkw5/l/vSYvKs
X-Received: from yosry.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2327])
 (user=yosryahmed job=sendgmr) by 2002:a63:5154:0:b0:39d:5e18:9d98
 with SMTP
 id r20-20020a635154000000b0039d5e189d98mr761530pgl.145.1651263109293; Fri, 29
 Apr 2022 13:11:49 -0700 (PDT)
Date: Fri, 29 Apr 2022 20:11:30 +0000
In-Reply-To: <20220429201131.3397875-1-yosryahmed@google.com>
Message-Id: <20220429201131.3397875-4-yosryahmed@google.com>
Mime-Version: 1.0
References: <20220429201131.3397875-1-yosryahmed@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH v4 3/4] KVM: x86/mmu: count KVM mmu usage in secondary
 pagetable stats.
From: Yosry Ahmed <yosryahmed@google.com>
To: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
 Zefan Li <lizefan.x@bytedance.com>, Marc Zyngier <maz@kernel.org>, 
 James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Sean Christopherson <seanjc@google.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 Wanpeng Li <wanpengli@tencent.com>, Jim Mattson <jmattson@google.com>, 
 Joerg Roedel <joro@8bytes.org>, Andrew Morton <akpm@linux-foundation.org>, 
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeelb@google.com>, Oliver Upton <oupton@google.com>
X-Mailman-Approved-At: Sat, 30 Apr 2022 11:48:22 -0400
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Yosry Ahmed <yosryahmed@google.com>, linux-mm@kvack.org,
 cgroups@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

Count the pages used by KVM mmu on x86 for in secondary pagetable stats.

For the legacy mmu, accounting pagetable stats is combined KVM's
existing for mmu pages in newly introduced kvm_[un]account_mmu_page()
helpers.

For tdp mmu, introduce new tdp_[un]account_mmu_page() helpers. That
combines accounting pagetable stats with the tdp_mmu_pages counter
accounting.

tdp_mmu_pages counter introduced in this series [1]. This patch was
rebased on top of the first two patches in that series.

[1]https://lore.kernel.org/lkml/20220401063636.2414200-1-mizhang@google.com/

Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
---
 arch/x86/kvm/mmu/mmu.c     | 16 ++++++++++++++--
 arch/x86/kvm/mmu/tdp_mmu.c | 16 ++++++++++++++--
 2 files changed, 28 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 78d8e1d8fb99..e5b0e826445d 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1679,6 +1679,18 @@ static inline void kvm_mod_used_mmu_pages(struct kvm *kvm, long nr)
 	percpu_counter_add(&kvm_total_used_mmu_pages, nr);
 }
 
+static void kvm_account_mmu_page(struct kvm *kvm, struct kvm_mmu_page *sp)
+{
+	kvm_mod_used_mmu_pages(kvm, +1);
+	kvm_account_pgtable_pages((void *)sp->spt, +1);
+}
+
+static void kvm_unaccount_mmu_page(struct kvm *kvm, struct kvm_mmu_page *sp)
+{
+	kvm_mod_used_mmu_pages(kvm, -1);
+	kvm_account_pgtable_pages((void *)sp->spt, -1);
+}
+
 static void kvm_mmu_free_page(struct kvm_mmu_page *sp)
 {
 	MMU_WARN_ON(!is_empty_shadow_page(sp->spt));
@@ -1734,7 +1746,7 @@ static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu, int direct
 	 */
 	sp->mmu_valid_gen = vcpu->kvm->arch.mmu_valid_gen;
 	list_add(&sp->link, &vcpu->kvm->arch.active_mmu_pages);
-	kvm_mod_used_mmu_pages(vcpu->kvm, +1);
+	kvm_account_mmu_page(vcpu->kvm, sp);
 	return sp;
 }
 
@@ -2363,7 +2375,7 @@ static bool __kvm_mmu_prepare_zap_page(struct kvm *kvm,
 			list_add(&sp->link, invalid_list);
 		else
 			list_move(&sp->link, invalid_list);
-		kvm_mod_used_mmu_pages(kvm, -1);
+		kvm_unaccount_mmu_page(kvm, sp);
 	} else {
 		/*
 		 * Remove the active root from the active page list, the root
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 3456277ade18..6295c4da5dee 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -371,6 +371,18 @@ static void handle_changed_spte_dirty_log(struct kvm *kvm, int as_id, gfn_t gfn,
 	}
 }
 
+static void tdp_account_mmu_page(struct kvm *kvm, struct kvm_mmu_page *sp)
+{
+	atomic64_inc(&kvm->arch.tdp_mmu_pages);
+	kvm_account_pgtable_pages((void *)sp->spt, +1);
+}
+
+static void tdp_unaccount_mmu_page(struct kvm *kvm, struct kvm_mmu_page *sp)
+{
+	atomic64_dec(&kvm->arch.tdp_mmu_pages);
+	kvm_account_pgtable_pages((void *)sp->spt, -1);
+}
+
 /**
  * tdp_mmu_unlink_sp() - Remove a shadow page from the list of used pages
  *
@@ -383,7 +395,7 @@ static void handle_changed_spte_dirty_log(struct kvm *kvm, int as_id, gfn_t gfn,
 static void tdp_mmu_unlink_sp(struct kvm *kvm, struct kvm_mmu_page *sp,
 			      bool shared)
 {
-	atomic64_dec(&kvm->arch.tdp_mmu_pages);
+	tdp_unaccount_mmu_page(kvm, sp);
 
 	if (!sp->lpage_disallowed)
 		return;
@@ -1121,7 +1133,7 @@ static int tdp_mmu_link_sp(struct kvm *kvm, struct tdp_iter *iter,
 		tdp_mmu_set_spte(kvm, iter, spte);
 	}
 
-	atomic64_inc(&kvm->arch.tdp_mmu_pages);
+	tdp_account_mmu_page(kvm, sp);
 
 	return 0;
 }
-- 
2.36.0.464.gb9c8b46e94-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
