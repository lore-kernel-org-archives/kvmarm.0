Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D373FC4332F
	for <kvmarm@archiver.kernel.org>; Tue, 17 May 2022 07:02:45 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8AB2D4B353;
	Tue, 17 May 2022 03:02:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bGGlCfTAlKpy; Tue, 17 May 2022 03:02:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C74484B30B;
	Tue, 17 May 2022 03:02:27 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4780149EBE
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 May 2022 19:22:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OG8HW-9Ji5HF for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 May 2022 19:22:08 -0400 (EDT)
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com
 [209.85.216.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2BD1E49E3A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 May 2022 19:22:08 -0400 (EDT)
Received: by mail-pj1-f74.google.com with SMTP id
 lb8-20020a17090b4a4800b001df6e0cee58so435067pjb.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 May 2022 16:22:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=lm/bHTT/Nz8oe32Uk0HDnsFMBQkCUXnMmKcicUoGXfs=;
 b=AiqFginchKqcmSIXeGtxPSBqb5MV1TnDVoarAOH7O4D7Zlwlhc8wdW1cAOq5/xNi5J
 R4cHtwg9tW5UB/VNcissYapZvSpM9wSgWWr3dToUQG8YTIe6NchLfycinkA78fiQCN76
 vlpsSJF0DyEhWxOFdrKCBjBG2kcCiPwCmp0TcOPcuPjD8prOEZ83AEv3sAVWPFmN/but
 c2b0w9QbsvQbdE/Jehn+mo7pVEoU1Pd54G1MAmuCbm+7injGhfmnBG+Heq87ygFDb1h4
 f++8OV2Cf3dOPV2B3RVqKJxop7CsrC4FHzXRm4eYeqU9LvpzZz3DxK29IAgBtoTTm5XP
 JUEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=lm/bHTT/Nz8oe32Uk0HDnsFMBQkCUXnMmKcicUoGXfs=;
 b=Tp1Xp/c7d8V92L2OvGXLwgFqV1vKgHPgQ1znAS9gGa38lCwzIOAX2DQ88WkT+tEqsI
 1UOc7JzmqEpzswA3N6GQLwCItgAea0pMMCYdhO1LxawOi3mI5oPTcmE3wEYN6G12lO1Z
 9L43wUjPAniXTil0AlNjIFSBkpDGJJQzgK+k9qy1+k381gao0aAj4RKXH1+BQh6xvVAw
 z3INcE/9sgkYpm1dAb3k+oAglgnYr6+WreqkRvoUEcdyS72mJvYNJF0PGc54MM+E+FnN
 bnufepaG0TnZqSJkD4KojfzaAa+ouc9tx5GkrMti64FOhtcqCEwhsL2qzxg8taAmcjJG
 SyNg==
X-Gm-Message-State: AOAM530XDNr0Q+zkXhjFsTslYYykhejKROkHoSVYF2O6zT7sWeLPyMyg
 zlDcHUydfPOWuZShnpHa7o3l2tggjcDThw==
X-Google-Smtp-Source: ABdhPJwB+FxzZW/zPu8VVr2QPbr7iRVb68cU3Dq9pd0u3oH6GpNdggozRZ5n4LJYaNZrt+GtEc+lvCKMYAzKJQ==
X-Received: from dmatlack-heavy.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a63:235c:0:b0:3c5:f761:12fd with SMTP id
 u28-20020a63235c000000b003c5f76112fdmr16850570pgm.416.1652743327301; Mon, 16
 May 2022 16:22:07 -0700 (PDT)
Date: Mon, 16 May 2022 23:21:32 +0000
In-Reply-To: <20220516232138.1783324-1-dmatlack@google.com>
Message-Id: <20220516232138.1783324-17-dmatlack@google.com>
Mime-Version: 1.0
References: <20220516232138.1783324-1-dmatlack@google.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
Subject: [PATCH v6 16/22] KVM: x86/mmu: Update page stats in __rmap_add()
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
index 15c0f03848d3..6aef85dac1e2 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1588,6 +1588,8 @@ static void __rmap_add(struct kvm *kvm,
 
 	sp = sptep_to_sp(spte);
 	kvm_mmu_page_set_gfn(sp, spte - sp->spt, gfn);
+	kvm_update_page_stats(kvm, sp->role.level, 1);
+
 	rmap_head = gfn_to_rmap(gfn, sp->role.level, slot);
 	rmap_count = pte_list_add(cache, spte, rmap_head);
 
@@ -2810,7 +2812,6 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
 
 	if (!was_rmapped) {
 		WARN_ON_ONCE(ret == RET_PF_SPURIOUS);
-		kvm_update_page_stats(vcpu->kvm, level, 1);
 		rmap_add(vcpu, slot, sptep, gfn);
 	}
 
-- 
2.36.0.550.gb090851708-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
