Return-Path: <SRS0=3/sM=BJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16731C433E0
	for <kvmarm@archiver.kernel.org>; Thu, 30 Jul 2020 15:34:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C4CFE2082E
	for <kvmarm@archiver.kernel.org>; Thu, 30 Jul 2020 15:34:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="hE9/CItu"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C4CFE2082E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7DA7A4B4D7;
	Thu, 30 Jul 2020 11:34:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id f78WUpdMq9mv; Thu, 30 Jul 2020 11:34:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6622C4B4EA;
	Thu, 30 Jul 2020 11:34:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A98694B4B2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jul 2020 11:34:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id huI8tKiLD1uI for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Jul 2020 11:34:34 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AAED14B4CE
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jul 2020 11:34:34 -0400 (EDT)
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa
 [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 6E45921744;
 Thu, 30 Jul 2020 15:34:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1596123274;
 bh=0AYdhwlQ/HngOLkjxnzAWxMj4nffGa4GqyCHEGM8djg=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=hE9/CItuxSm8ghKMW2/HT5udgTOde7kDiApNbo9yHIX+Cno4sfRlpUN/pQZVNWA53
 knhCpiSqoDVgYjXGP5xpuYu+c5acn7hXd9pcFxDJNUlFnF1M+j/LJYTlI5kTIx6Mo+
 cUaUEcd3FUAYb06UGdQ7j5ufffuKqLP/UEMu/3y0=
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 07/20] KVM: arm64: Convert kvm_set_spte_hva() to generic
 page-table API
Date: Thu, 30 Jul 2020 16:33:53 +0100
Message-Id: <20200730153406.25136-8-will@kernel.org>
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

Convert kvm_set_spte_hva() to use kvm_pgtable_stage2_map() instead
of stage2_set_pte().

Cc: Marc Zyngier <maz@kernel.org>
Cc: Quentin Perret <qperret@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/mmu.c | 23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 90310fd16d85..f6b7220412af 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1924,28 +1924,27 @@ int kvm_unmap_hva_range(struct kvm *kvm,
 
 static int kvm_set_spte_handler(struct kvm *kvm, gpa_t gpa, u64 size, void *data)
 {
-	pte_t *pte = (pte_t *)data;
+	kvm_pfn_t *pfn = (kvm_pfn_t *)data;
 
 	WARN_ON(size != PAGE_SIZE);
+
 	/*
-	 * We can always call stage2_set_pte with KVM_S2PTE_FLAG_LOGGING_ACTIVE
-	 * flag clear because MMU notifiers will have unmapped a huge PMD before
-	 * calling ->change_pte() (which in turn calls kvm_set_spte_hva()) and
-	 * therefore stage2_set_pte() never needs to clear out a huge PMD
-	 * through this calling path.
+	 * The MMU notifiers will have unmapped a huge PMD before calling
+	 * ->change_pte() (which in turn calls kvm_set_spte_hva()) and
+	 * therefore we never need to clear out a huge PMD through this
+	 * calling path and a memcache is not required.
 	 */
-	stage2_set_pte(&kvm->arch.mmu, NULL, gpa, pte, 0);
+	WARN_ON(kvm_pgtable_stage2_map(kvm, gpa, PAGE_SIZE, __pfn_to_phys(*pfn),
+				       KVM_PGTABLE_PROT_R, NULL));
 	return 0;
 }
 
-
 int kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte)
 {
 	unsigned long end = hva + PAGE_SIZE;
 	kvm_pfn_t pfn = pte_pfn(pte);
-	pte_t stage2_pte;
 
-	if (!kvm->arch.mmu.pgd)
+	if (!kvm->arch.mmu.pgt_cookie)
 		return 0;
 
 	trace_kvm_set_spte_hva(hva);
@@ -1955,9 +1954,7 @@ int kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte)
 	 * just like a translation fault and clean the cache to the PoC.
 	 */
 	clean_dcache_guest_page(pfn, PAGE_SIZE);
-	stage2_pte = kvm_pfn_pte(pfn, PAGE_S2);
-	handle_hva_to_gpa(kvm, hva, end, &kvm_set_spte_handler, &stage2_pte);
-
+	handle_hva_to_gpa(kvm, hva, end, &kvm_set_spte_handler, &pfn);
 	return 0;
 }
 
-- 
2.28.0.rc0.142.g3c755180ce-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
