Return-Path: <SRS0=KDMR=AR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40ECCC433DF
	for <kvmarm@archiver.kernel.org>; Mon,  6 Jul 2020 12:55:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EC7C420771
	for <kvmarm@archiver.kernel.org>; Mon,  6 Jul 2020 12:55:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="fPkMvkad"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EC7C420771
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A6DBD4B38C;
	Mon,  6 Jul 2020 08:55:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KuQLZx0obEM8; Mon,  6 Jul 2020 08:55:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B76A04B424;
	Mon,  6 Jul 2020 08:55:02 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5E80B4B3BC
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Jul 2020 08:55:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CFhJ86vSbj5Q for <kvmarm@lists.cs.columbia.edu>;
 Mon,  6 Jul 2020 08:54:59 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3EBC24B3B0
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Jul 2020 08:54:58 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 71AA620722;
 Mon,  6 Jul 2020 12:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1594040097;
 bh=JcLJaEEiWez7DCAJb7n1JbXq071q3mQKlzCmv4HPFh0=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=fPkMvkadQqowknm+pMdzyjEvMSoU/eudxJ/1LVu3BxF7YqDuBJBsbBFCxZDRnB4kz
 eqyjyL397p/iL4tD+JhmRWAlePYuORB8VFg/R8/1OyC6ghWh8XDKcA+qa2ZUFO3ENP
 AG1nG3JYsGW+uJphBYUHLer/EXWxcZnYRIhY8Duk=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jsQe7-009SCo-U0; Mon, 06 Jul 2020 13:54:56 +0100
From: Marc Zyngier <maz@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
Subject: [PATCH v3 05/17] KVM: arm64: Use TTL hint in when invalidating
 stage-2 translations
Date: Mon,  6 Jul 2020 13:54:13 +0100
Message-Id: <20200706125425.1671020-6-maz@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200706125425.1671020-1-maz@kernel.org>
References: <20200706125425.1671020-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: catalin.marinas@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, andre.przywara@arm.com, christoffer.dall@arm.com,
 Dave.Martin@arm.com, jintack@cs.columbia.edu, alexandru.elisei@arm.com,
 gcherian@marvell.com, prime.zeng@hisilicon.com, ascull@google.com,
 will@kernel.org, mark.rutland@arm.com, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Will Deacon <will@kernel.org>,
 Andre Przywara <andre.przywara@arm.com>, Dave Martin <Dave.Martin@arm.com>,
 George Cherian <gcherian@marvell.com>,
 "Zengtao \(B\)" <prime.zeng@hisilicon.com>
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

Since we often have a precise idea of the level we're dealing with
when invalidating TLBs, we can provide it to as a hint to our
invalidation helper.

Reviewed-by: James Morse <james.morse@arm.com>
Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_asm.h |  3 ++-
 arch/arm64/kvm/hyp/nvhe/tlb.c    |  5 +++--
 arch/arm64/kvm/hyp/vhe/tlb.c     |  5 +++--
 arch/arm64/kvm/mmu.c             | 29 +++++++++++++++--------------
 4 files changed, 23 insertions(+), 19 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 18d39b30d9c9..61f654a4ae00 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -91,7 +91,8 @@ DECLARE_KVM_HYP_SYM(__bp_harden_hyp_vecs);
 #endif
 
 extern void __kvm_flush_vm_context(void);
-extern void __kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu, phys_addr_t ipa);
+extern void __kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu, phys_addr_t ipa,
+				     int level);
 extern void __kvm_tlb_flush_vmid(struct kvm_s2_mmu *mmu);
 extern void __kvm_tlb_flush_local_vmid(struct kvm_s2_mmu *mmu);
 
diff --git a/arch/arm64/kvm/hyp/nvhe/tlb.c b/arch/arm64/kvm/hyp/nvhe/tlb.c
index 11dbe031f0ba..69eae608d670 100644
--- a/arch/arm64/kvm/hyp/nvhe/tlb.c
+++ b/arch/arm64/kvm/hyp/nvhe/tlb.c
@@ -46,7 +46,8 @@ static void __tlb_switch_to_host(struct tlb_inv_context *cxt)
 	}
 }
 
-void __kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu, phys_addr_t ipa)
+void __kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu,
+			      phys_addr_t ipa, int level)
 {
 	struct tlb_inv_context cxt;
 
@@ -62,7 +63,7 @@ void __kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu, phys_addr_t ipa)
 	 * whole of Stage-1. Weep...
 	 */
 	ipa >>= 12;
-	__tlbi(ipas2e1is, ipa);
+	__tlbi_level(ipas2e1is, ipa, level);
 
 	/*
 	 * We have to ensure completion of the invalidation at Stage-2,
diff --git a/arch/arm64/kvm/hyp/vhe/tlb.c b/arch/arm64/kvm/hyp/vhe/tlb.c
index ada1d56f0709..fd7895945bbc 100644
--- a/arch/arm64/kvm/hyp/vhe/tlb.c
+++ b/arch/arm64/kvm/hyp/vhe/tlb.c
@@ -79,7 +79,8 @@ static void __tlb_switch_to_host(struct tlb_inv_context *cxt)
 	local_irq_restore(cxt->flags);
 }
 
-void __kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu, phys_addr_t ipa)
+void __kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu,
+			      phys_addr_t ipa, int level)
 {
 	struct tlb_inv_context cxt;
 
@@ -94,7 +95,7 @@ void __kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu, phys_addr_t ipa)
 	 * whole of Stage-1. Weep...
 	 */
 	ipa >>= 12;
-	__tlbi(ipas2e1is, ipa);
+	__tlbi_level(ipas2e1is, ipa, level);
 
 	/*
 	 * We have to ensure completion of the invalidation at Stage-2,
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 2c6d59b509a5..41eedbfd961e 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -58,9 +58,10 @@ void kvm_flush_remote_tlbs(struct kvm *kvm)
 	kvm_call_hyp(__kvm_tlb_flush_vmid, &kvm->arch.mmu);
 }
 
-static void kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu, phys_addr_t ipa)
+static void kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu, phys_addr_t ipa,
+				   int level)
 {
-	kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu, ipa);
+	kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu, ipa, level);
 }
 
 /*
@@ -102,7 +103,7 @@ static void stage2_dissolve_pmd(struct kvm_s2_mmu *mmu, phys_addr_t addr, pmd_t
 		return;
 
 	pmd_clear(pmd);
-	kvm_tlb_flush_vmid_ipa(mmu, addr);
+	kvm_tlb_flush_vmid_ipa(mmu, addr, S2_PMD_LEVEL);
 	put_page(virt_to_page(pmd));
 }
 
@@ -122,7 +123,7 @@ static void stage2_dissolve_pud(struct kvm_s2_mmu *mmu, phys_addr_t addr, pud_t
 		return;
 
 	stage2_pud_clear(kvm, pudp);
-	kvm_tlb_flush_vmid_ipa(mmu, addr);
+	kvm_tlb_flush_vmid_ipa(mmu, addr, S2_PUD_LEVEL);
 	put_page(virt_to_page(pudp));
 }
 
@@ -163,7 +164,7 @@ static void clear_stage2_pgd_entry(struct kvm_s2_mmu *mmu, pgd_t *pgd, phys_addr
 	struct kvm *kvm = mmu->kvm;
 	p4d_t *p4d_table __maybe_unused = stage2_p4d_offset(kvm, pgd, 0UL);
 	stage2_pgd_clear(kvm, pgd);
-	kvm_tlb_flush_vmid_ipa(mmu, addr);
+	kvm_tlb_flush_vmid_ipa(mmu, addr, S2_NO_LEVEL_HINT);
 	stage2_p4d_free(kvm, p4d_table);
 	put_page(virt_to_page(pgd));
 }
@@ -173,7 +174,7 @@ static void clear_stage2_p4d_entry(struct kvm_s2_mmu *mmu, p4d_t *p4d, phys_addr
 	struct kvm *kvm = mmu->kvm;
 	pud_t *pud_table __maybe_unused = stage2_pud_offset(kvm, p4d, 0);
 	stage2_p4d_clear(kvm, p4d);
-	kvm_tlb_flush_vmid_ipa(mmu, addr);
+	kvm_tlb_flush_vmid_ipa(mmu, addr, S2_NO_LEVEL_HINT);
 	stage2_pud_free(kvm, pud_table);
 	put_page(virt_to_page(p4d));
 }
@@ -185,7 +186,7 @@ static void clear_stage2_pud_entry(struct kvm_s2_mmu *mmu, pud_t *pud, phys_addr
 
 	VM_BUG_ON(stage2_pud_huge(kvm, *pud));
 	stage2_pud_clear(kvm, pud);
-	kvm_tlb_flush_vmid_ipa(mmu, addr);
+	kvm_tlb_flush_vmid_ipa(mmu, addr, S2_NO_LEVEL_HINT);
 	stage2_pmd_free(kvm, pmd_table);
 	put_page(virt_to_page(pud));
 }
@@ -195,7 +196,7 @@ static void clear_stage2_pmd_entry(struct kvm_s2_mmu *mmu, pmd_t *pmd, phys_addr
 	pte_t *pte_table = pte_offset_kernel(pmd, 0);
 	VM_BUG_ON(pmd_thp_or_huge(*pmd));
 	pmd_clear(pmd);
-	kvm_tlb_flush_vmid_ipa(mmu, addr);
+	kvm_tlb_flush_vmid_ipa(mmu, addr, S2_NO_LEVEL_HINT);
 	free_page((unsigned long)pte_table);
 	put_page(virt_to_page(pmd));
 }
@@ -273,7 +274,7 @@ static void unmap_stage2_ptes(struct kvm_s2_mmu *mmu, pmd_t *pmd,
 			pte_t old_pte = *pte;
 
 			kvm_set_pte(pte, __pte(0));
-			kvm_tlb_flush_vmid_ipa(mmu, addr);
+			kvm_tlb_flush_vmid_ipa(mmu, addr, S2_PTE_LEVEL);
 
 			/* No need to invalidate the cache for device mappings */
 			if (!kvm_is_device_pfn(pte_pfn(old_pte)))
@@ -302,7 +303,7 @@ static void unmap_stage2_pmds(struct kvm_s2_mmu *mmu, pud_t *pud,
 				pmd_t old_pmd = *pmd;
 
 				pmd_clear(pmd);
-				kvm_tlb_flush_vmid_ipa(mmu, addr);
+				kvm_tlb_flush_vmid_ipa(mmu, addr, S2_PMD_LEVEL);
 
 				kvm_flush_dcache_pmd(old_pmd);
 
@@ -332,7 +333,7 @@ static void unmap_stage2_puds(struct kvm_s2_mmu *mmu, p4d_t *p4d,
 				pud_t old_pud = *pud;
 
 				stage2_pud_clear(kvm, pud);
-				kvm_tlb_flush_vmid_ipa(mmu, addr);
+				kvm_tlb_flush_vmid_ipa(mmu, addr, S2_PUD_LEVEL);
 				kvm_flush_dcache_pud(old_pud);
 				put_page(virt_to_page(pud));
 			} else {
@@ -1260,7 +1261,7 @@ static int stage2_set_pmd_huge(struct kvm_s2_mmu *mmu,
 		 */
 		WARN_ON_ONCE(pmd_pfn(old_pmd) != pmd_pfn(*new_pmd));
 		pmd_clear(pmd);
-		kvm_tlb_flush_vmid_ipa(mmu, addr);
+		kvm_tlb_flush_vmid_ipa(mmu, addr, S2_PMD_LEVEL);
 	} else {
 		get_page(virt_to_page(pmd));
 	}
@@ -1302,7 +1303,7 @@ static int stage2_set_pud_huge(struct kvm_s2_mmu *mmu,
 
 		WARN_ON_ONCE(kvm_pud_pfn(old_pud) != kvm_pud_pfn(*new_pudp));
 		stage2_pud_clear(kvm, pudp);
-		kvm_tlb_flush_vmid_ipa(mmu, addr);
+		kvm_tlb_flush_vmid_ipa(mmu, addr, S2_PUD_LEVEL);
 	} else {
 		get_page(virt_to_page(pudp));
 	}
@@ -1451,7 +1452,7 @@ static int stage2_set_pte(struct kvm_s2_mmu *mmu,
 			return 0;
 
 		kvm_set_pte(pte, __pte(0));
-		kvm_tlb_flush_vmid_ipa(mmu, addr);
+		kvm_tlb_flush_vmid_ipa(mmu, addr, S2_PTE_LEVEL);
 	} else {
 		get_page(virt_to_page(pte));
 	}
-- 
2.27.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
