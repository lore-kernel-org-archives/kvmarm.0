Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28731C433F5
	for <kvmarm@archiver.kernel.org>; Sat, 23 Apr 2022 08:57:24 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D3CA84B0F4;
	Sat, 23 Apr 2022 04:57:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KNTQb7fIiaVg; Sat, 23 Apr 2022 04:57:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F05324B2C4;
	Sat, 23 Apr 2022 04:57:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B683C40C31
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Apr 2022 17:06:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XdHuIzhCTbEU for <kvmarm@lists.cs.columbia.edu>;
 Fri, 22 Apr 2022 17:06:18 -0400 (EDT)
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com
 [209.85.215.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6050A4A104
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Apr 2022 17:06:18 -0400 (EDT)
Received: by mail-pg1-f201.google.com with SMTP id
 q13-20020a638c4d000000b003821725ad66so5625683pgn.23
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Apr 2022 14:06:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=csGYTTgLO7JTG/MJ5ZHEQ2SmxGLM+rnUmtz6vs2mn6s=;
 b=l6jEQB9U0csYEWcZJhqMEDMGTLs5di/EI5F8Zl27LVUFQVVbi0H8o/zOFCcleLtiY+
 DloYUdzhQnpql77qPuxt/n7StWTAaWm6cLKHG8wRlJyx6oTE2RRQMC0Yno3+3qbu/tSs
 0lUXlo2suXJfMDuaOLenwPemb5XB88+bVHvMZL/08yLuT21GdYaE5z2agCUHVTlHs8mr
 8b+WLywouaTvocy1dbYHvhiHpRAFotAB6zRcoBC1Uidlucu3YR5/JJT3PjudfZp+ZzGy
 RXiOMXICz8LY6gLoV4fXLR77uTv0/nY8mThs4Fi/vx3UcL3wZfMcEOrAqbbJbMLUxsUD
 Grcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=csGYTTgLO7JTG/MJ5ZHEQ2SmxGLM+rnUmtz6vs2mn6s=;
 b=fb83WVqK7sc5wM4mJqyebk4CMQipFsH3ZR+RBhrbrY0jiXbM22NfPlbXKO4Cxvky7o
 lfJ0NomUmrFUZhK312oozUpOIK8kor3MfxHdPJdejrx6A2aKKq3sHzjCdQ/wUQzhqdbA
 VVdkSiLs8vKTAVsC+L0ofpfhEiuKv3X/y+QqoHN2srDphBkzWd62ZTMAmhvToHeBVmgT
 Y3aixnq6Y/Gc+Iy09NONuDqIs5Ek2601FX1UTiFJf3TBXG5zT2H4Ir2jKFPM8/0M+nJf
 IMm1w6vfY0boccFGinK3DZR88nj8iUeLuypfvSShZcN7sG82z1I05oj6g3gs6VM/yrRH
 7srA==
X-Gm-Message-State: AOAM533s6AZuUmdLi/0tJYx0mMCPLr9AnumSsIdX9tVVlxW6uoec4JU3
 VHMsDm7H6oJnJrFQFbc+9lD3wPSKSeLZJg==
X-Google-Smtp-Source: ABdhPJxwGKSMoT7a6vuDBG/9QPLNL6WSI7Wg6RWBF/U9+Ei6+zMEnYYjdJzGj5E995zo4cGyM9VmfiTBeQH5gw==
X-Received: from dmatlack-heavy.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90a:6d96:b0:1c9:c1de:ef2f with SMTP
 id a22-20020a17090a6d9600b001c9c1deef2fmr18212154pjk.210.1650661577643; Fri,
 22 Apr 2022 14:06:17 -0700 (PDT)
Date: Fri, 22 Apr 2022 21:05:44 +0000
In-Reply-To: <20220422210546.458943-1-dmatlack@google.com>
Message-Id: <20220422210546.458943-19-dmatlack@google.com>
Mime-Version: 1.0
References: <20220422210546.458943-1-dmatlack@google.com>
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
Subject: [PATCH v4 18/20] KVM: x86/mmu: Refactor drop_large_spte()
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

drop_large_spte() drops a large SPTE if it exists and then flushes TLBs.
Its helper function, __drop_large_spte(), does the drop without the
flush.

In preparation for eager page splitting, which will need to sometimes
flush when dropping large SPTEs (and sometimes not), push the flushing
logic down into __drop_large_spte() and add a bool parameter to control
it.

No functional change intended.

Reviewed-by: Peter Xu <peterx@redhat.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 479c581e8a96..a5961c17eb36 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1183,28 +1183,29 @@ static void drop_spte(struct kvm *kvm, u64 *sptep)
 		rmap_remove(kvm, sptep);
 }
 
-
-static bool __drop_large_spte(struct kvm *kvm, u64 *sptep)
+static void __drop_large_spte(struct kvm *kvm, u64 *sptep, bool flush)
 {
-	if (is_large_pte(*sptep)) {
-		WARN_ON(sptep_to_sp(sptep)->role.level == PG_LEVEL_4K);
-		drop_spte(kvm, sptep);
-		return true;
-	}
+	struct kvm_mmu_page *sp;
 
-	return false;
-}
+	if (!is_large_pte(*sptep))
+		return;
 
-static void drop_large_spte(struct kvm_vcpu *vcpu, u64 *sptep)
-{
-	if (__drop_large_spte(vcpu->kvm, sptep)) {
-		struct kvm_mmu_page *sp = sptep_to_sp(sptep);
+	sp = sptep_to_sp(sptep);
+	WARN_ON(sp->role.level == PG_LEVEL_4K);
 
-		kvm_flush_remote_tlbs_with_address(vcpu->kvm, sp->gfn,
+	drop_spte(kvm, sptep);
+
+	if (flush) {
+		kvm_flush_remote_tlbs_with_address(kvm, sp->gfn,
 			KVM_PAGES_PER_HPAGE(sp->role.level));
 	}
 }
 
+static void drop_large_spte(struct kvm_vcpu *vcpu, u64 *sptep)
+{
+	return __drop_large_spte(vcpu->kvm, sptep, true);
+}
+
 /*
  * Write-protect on the specified @sptep, @pt_protect indicates whether
  * spte write-protection is caused by protecting shadow page table.
-- 
2.36.0.rc2.479.g8af0fa9b8e-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
