Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61630C433EF
	for <kvmarm@archiver.kernel.org>; Fri, 11 Mar 2022 08:49:01 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0AD0649EF5;
	Fri, 11 Mar 2022 03:49:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HNkQ4y0ebSF4; Fri, 11 Mar 2022 03:49:00 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A658D49EFC;
	Fri, 11 Mar 2022 03:48:44 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 45B5A40C1B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 19:26:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PtU0Lv2maTcI for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Mar 2022 19:26:04 -0500 (EST)
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com
 [209.85.216.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 354CD40C31
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 19:26:04 -0500 (EST)
Received: by mail-pj1-f74.google.com with SMTP id
 p8-20020a17090a74c800b001bf257861efso6763096pjl.6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 16:26:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=25+KDsWb88cITvAkDtK/k2hukUBdQk6h1+nWravTP4A=;
 b=K0TPB3uKAzhv2V8uMMeBatFQY8hZWLm9Du6sCL0+SuvLt4cuZsnxgLsdX/S1nOvVtD
 fOJgb/6kxC900RYeJvh122bm8r8COP0dUdAfk7iS0A5hw7OsHXDqi9bwu6Fcka2oVXTA
 wP2mdyJD6Bh+sA7+tTKBHIc8ZtBem1Ya8VZxq5wGKapUL1k9nJoMFuAfBjE8WKCxiWN1
 OlgrdMpnZH9W0FOCWtVCHjw1n/zefXLlVMhEeaAI5THutPCrG55DAjR14Ub0YTKdRBav
 4LhtJZs/D/q8/J1cBMRrkXueu0GUwMdyz890TM3Fupl3hdRaVYavWFTBmZ/OW44pfIAC
 zJdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=25+KDsWb88cITvAkDtK/k2hukUBdQk6h1+nWravTP4A=;
 b=Hj9DnWDWaPG/JhLLbK4A5tYRNz9a/Ewvl6LotXEAtWzCVWRTuOzwkrTVvoIhLnFIRv
 izTpnrmhUlKWVwYr2szytS4tMH91CsOxfZUfRS8RVomtB+7R/q7oIWlAcU1PHNBmIeZl
 sq2kBKH2SGGje1JzuPxrxYlRQu23+Scm49F4R+pPwcNFLvknl4PjZZ6qNjb0FdCaxw4h
 0+I4UDOW4emXshe6wkyIEijPvt0CnECAumrdLRktzYq1kIpQ+P8unvNSwlluHBcQVvim
 2XmBE9pqOs3eJhzp8/Gwp8/+bapPtaynPzMsk8QwiMFHg2B82qLZiyk0xFF/NTCmr17/
 Fn2g==
X-Gm-Message-State: AOAM530Bv/Rg6tJlfFIOUzgxD+a8Si942b5fKlsPdpd2svSAAL31Mg1D
 Xt+W0MT8wygNzc3RAG9gBk2T1rUbytLNDA==
X-Google-Smtp-Source: ABdhPJzQQNzCUZydl9KF0V/z0eslYsBHitU/RkIzZ5f2qOcoErUZJMAOQ9EJr1dof3fsKDR0fIjt+SaohHYUBw==
X-Received: from dmatlack-heavy.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:902:6a86:b0:151:f1c5:2fa3 with SMTP
 id n6-20020a1709026a8600b00151f1c52fa3mr7493244plk.77.1646958363421; Thu, 10
 Mar 2022 16:26:03 -0800 (PST)
Date: Fri, 11 Mar 2022 00:25:21 +0000
In-Reply-To: <20220311002528.2230172-1-dmatlack@google.com>
Message-Id: <20220311002528.2230172-20-dmatlack@google.com>
Mime-Version: 1.0
References: <20220311002528.2230172-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v2 19/26] KVM: x86/mmu: Refactor drop_large_spte()
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

drop_large_spte() drops a large SPTE if it exists and then flushes TLBs.
Its helper function, __drop_large_spte(), does the drop without the
flush.

In preparation for eager page splitting, which will need to sometimes
flush when dropping large SPTEs (and sometimes not), push the flushing
logic down into __drop_large_spte() and add a bool parameter to control
it.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 2032be3edd71..926ddfaa9e1a 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1150,28 +1150,29 @@ static void drop_spte(struct kvm *kvm, u64 *sptep)
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
2.35.1.723.g4982287a31-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
