Return-Path: <SRS0=3/sM=BJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADF8CC433DF
	for <kvmarm@archiver.kernel.org>; Thu, 30 Jul 2020 15:34:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 66CE322B42
	for <kvmarm@archiver.kernel.org>; Thu, 30 Jul 2020 15:34:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="hy1tJ1a4"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 66CE322B42
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 200524B4C0;
	Thu, 30 Jul 2020 11:34:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QRftfHvGkABG; Thu, 30 Jul 2020 11:34:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C4B164B480;
	Thu, 30 Jul 2020 11:34:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1BF2E4B4F5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jul 2020 11:34:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XykZdXGrFKpP for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Jul 2020 11:34:41 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9627E4B480
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jul 2020 11:34:40 -0400 (EDT)
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa
 [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 5F54720829;
 Thu, 30 Jul 2020 15:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1596123279;
 bh=095TtEij6Kgu/5qxf6YeC7EVQOAneNK5p8IrqCt+MTk=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=hy1tJ1a4mwpxfPEEulr8Nr9Ab0uaoWYa3ji7wrb2grmPFmWWK/nPOT+6fuyIPCWSF
 G4KKNzzuiu8C62/5zlbqIGShMQ7CVUTLSIHGjKtoemrvV87FiNg4LZyBFoWz9rNdJA
 s7WGr1K4qSam9QTnmdoIPVkjeyoGxLkL9KNmkWGc=
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 10/20] KVM: arm64: Convert page-aging and access faults to
 generic page-table API
Date: Thu, 30 Jul 2020 16:33:56 +0100
Message-Id: <20200730153406.25136-11-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200730153406.25136-1-will@kernel.org>
References: <20200730153406.25136-1-will@kernel.org>
MIME-Version: 1.0
Cc: kernel-team@android.com, Marc Zyngier <maz@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
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

Convert the page-aging functions and access fault handler to use the
generic page-table code instead of walking the page-table directly.

Cc: Marc Zyngier <maz@kernel.org>
Cc: Quentin Perret <qperret@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/mmu.c | 74 ++++++++++----------------------------------
 1 file changed, 16 insertions(+), 58 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index d2ce44183b98..6b4479057df6 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1714,46 +1714,23 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	return ret;
 }
 
-/*
- * Resolve the access fault by making the page young again.
- * Note that because the faulting entry is guaranteed not to be
- * cached in the TLB, we don't need to invalidate anything.
- * Only the HW Access Flag updates are supported for Stage 2 (no DBM),
- * so there is no need for atomic (pte|pmd)_mkyoung operations.
- */
+/* Resolve the access fault by making the page young again. */
 static void handle_access_fault(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
 {
-	pud_t *pud;
-	pmd_t *pmd;
-	pte_t *pte;
-	kvm_pfn_t pfn;
-	bool pfn_valid = false;
+	pte_t pte;
+	kvm_pte_t kpte;
+	struct kvm_s2_mmu *mmu;
 
 	trace_kvm_access_fault(fault_ipa);
 
 	spin_lock(&vcpu->kvm->mmu_lock);
-
-	if (!stage2_get_leaf_entry(vcpu->arch.hw_mmu, fault_ipa, &pud, &pmd, &pte))
-		goto out;
-
-	if (pud) {		/* HugeTLB */
-		*pud = kvm_s2pud_mkyoung(*pud);
-		pfn = kvm_pud_pfn(*pud);
-		pfn_valid = true;
-	} else	if (pmd) {	/* THP, HugeTLB */
-		*pmd = pmd_mkyoung(*pmd);
-		pfn = pmd_pfn(*pmd);
-		pfn_valid = true;
-	} else {
-		*pte = pte_mkyoung(*pte);	/* Just a page... */
-		pfn = pte_pfn(*pte);
-		pfn_valid = true;
-	}
-
-out:
+	mmu = vcpu->arch.hw_mmu;
+	kpte = kvm_pgtable_stage2_mkyoung(mmu->pgt_cookie, fault_ipa);
 	spin_unlock(&vcpu->kvm->mmu_lock);
-	if (pfn_valid)
-		kvm_set_pfn_accessed(pfn);
+
+	pte = __pte(kpte);
+	if (pte_valid(pte))
+		kvm_set_pfn_accessed(pte_pfn(pte));
 }
 
 /**
@@ -1968,38 +1945,19 @@ int kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte)
 
 static int kvm_age_hva_handler(struct kvm *kvm, gpa_t gpa, u64 size, void *data)
 {
-	pud_t *pud;
-	pmd_t *pmd;
-	pte_t *pte;
+	pte_t pte;
+	kvm_pte_t kpte;
 
 	WARN_ON(size != PAGE_SIZE && size != PMD_SIZE && size != PUD_SIZE);
-	if (!stage2_get_leaf_entry(&kvm->arch.mmu, gpa, &pud, &pmd, &pte))
-		return 0;
-
-	if (pud)
-		return stage2_pudp_test_and_clear_young(pud);
-	else if (pmd)
-		return stage2_pmdp_test_and_clear_young(pmd);
-	else
-		return stage2_ptep_test_and_clear_young(pte);
+	kpte = kvm_pgtable_stage2_mkold(kvm->arch.mmu.pgt_cookie, gpa);
+	pte = __pte(kpte);
+	return pte_valid(pte) && pte_young(pte);
 }
 
 static int kvm_test_age_hva_handler(struct kvm *kvm, gpa_t gpa, u64 size, void *data)
 {
-	pud_t *pud;
-	pmd_t *pmd;
-	pte_t *pte;
-
 	WARN_ON(size != PAGE_SIZE && size != PMD_SIZE && size != PUD_SIZE);
-	if (!stage2_get_leaf_entry(&kvm->arch.mmu, gpa, &pud, &pmd, &pte))
-		return 0;
-
-	if (pud)
-		return kvm_s2pud_young(*pud);
-	else if (pmd)
-		return pmd_young(*pmd);
-	else
-		return pte_young(*pte);
+	return kvm_pgtable_stage2_is_young(kvm->arch.mmu.pgt_cookie, gpa);
 }
 
 int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end)
-- 
2.28.0.rc0.142.g3c755180ce-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
