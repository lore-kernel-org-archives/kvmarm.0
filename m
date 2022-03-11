Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B450AC4332F
	for <kvmarm@archiver.kernel.org>; Fri, 11 Mar 2022 08:48:57 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 598B649E48;
	Fri, 11 Mar 2022 03:48:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2QPOLvVq-td7; Fri, 11 Mar 2022 03:48:56 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 275994A014;
	Fri, 11 Mar 2022 03:48:44 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 524C440FAA
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 19:25:58 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CZ2HwqPZuOH7 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Mar 2022 19:25:57 -0500 (EST)
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com
 [209.85.214.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3BC7940BBF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 19:25:57 -0500 (EST)
Received: by mail-pl1-f202.google.com with SMTP id
 j1-20020a170903028100b0014b1f9e0068so3553840plr.8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 16:25:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=O7PTjGgVVBCrsjwnVURq9XzsqcZsMncDOf7hGGBSbd0=;
 b=kmeAXlYSaDpRLGcUmN4Sv/xTcYDW6jclnp1q1rJJ4dL2RoKdVl5SeZYJBr8GYWH5m+
 DKD4iQBnIfLFGWX9cwaqDbad8l6EyX7jK4BZPjX14nJp+Wg87hDMUKTEmjaE3Zz6UHm0
 NFQQxbrHmJK9MHiqOLJ7843mXQn7NgLsSzLX/7CnhTcMy0PzlTku645wfWBqEuMBl3yU
 EwRBFkfr3fYm5vTZkWqKJ8rysORKE9UEYN6dw6cLPFscwbhIaxSWiLkf9LiPAIIADKaf
 vypriHQ917TpN7rZX2KwCHN3Tpuv7SMZQiwX93ecC+tARg/gwyRbtujWRsbhB0yYIilw
 sbQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=O7PTjGgVVBCrsjwnVURq9XzsqcZsMncDOf7hGGBSbd0=;
 b=F+9a4e5tml/I/QnoRq2CKXK2J3dIm2NZFD/ijLrw82S/f3SdhcozRVRFIq5v9B0e86
 0j3+zzODmjlSxG9cvgG4QxW5eWNwJJ887JuLtgu7P7gbPRv06Jja4AGwvAqQ6i8iBRPV
 d7tPzb81LxgANaYuy/ivqXRN62AaVVgUP5ciRqTf1jyUYcMPnVYdugW6wUthF8lrNbPH
 fnC9sv/BMACyBNhapFzpV2iQ2u8aH0NX8z348FUsHvcNR063S2mg1zmkGVgk5zEc8yas
 u/cjIXIuMM8rQxRoRK25xTHJsEzsB0ECk7gitz+LrQBezrgdkIdnb2xEKCtOc0H1I8sv
 hTxQ==
X-Gm-Message-State: AOAM530FlisFIlgMFq3lH4n1/rI+eCwqVyrPegYf3sG+rqwLT01Zbx41
 YTRon0QN66zwN/khD/Tjgn3XYVlNe4U5kA==
X-Google-Smtp-Source: ABdhPJyfGZbmtHRGGR2TxbnIQFRzmM6E4in1hGACCBqL+EJ7gFLqMSHgs8hy0AVD/5cl522W64O1wnhoHBbOLQ==
X-Received: from dmatlack-heavy.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a05:6a00:b92:b0:4f6:dfe0:9abb with SMTP
 id g18-20020a056a000b9200b004f6dfe09abbmr7383915pfj.68.1646958356428; Thu, 10
 Mar 2022 16:25:56 -0800 (PST)
Date: Fri, 11 Mar 2022 00:25:17 +0000
In-Reply-To: <20220311002528.2230172-1-dmatlack@google.com>
Message-Id: <20220311002528.2230172-16-dmatlack@google.com>
Mime-Version: 1.0
References: <20220311002528.2230172-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v2 15/26] KVM: x86/mmu: Update page stats in __rmap_add()
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

Update the page stats in __rmap_add() rather than at the call site. This
will avoid having to manually update page stats when splitting huge
pages in a subsequent commit.

No functional change intended.

Reviewed-by: Ben Gardon <bgardon@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index c57070ed157d..73a7077f9991 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1607,6 +1607,8 @@ static void __rmap_add(struct kvm *kvm,
 
 	sp = sptep_to_sp(spte);
 	kvm_mmu_page_set_gfn(sp, spte - sp->spt, gfn);
+	kvm_update_page_stats(kvm, sp->role.level, 1);
+
 	rmap_head = gfn_to_rmap(gfn, sp->role.level, slot);
 	rmap_count = pte_list_add(cache, spte, rmap_head);
 
@@ -2847,7 +2849,6 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
 
 	if (!was_rmapped) {
 		WARN_ON_ONCE(ret == RET_PF_SPURIOUS);
-		kvm_update_page_stats(vcpu->kvm, level, 1);
 		rmap_add(vcpu, slot, sptep, gfn);
 	}
 
-- 
2.35.1.723.g4982287a31-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
