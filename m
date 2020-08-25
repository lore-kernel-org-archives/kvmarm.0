Return-Path: <SRS0=snoh=CD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B71ABC433E1
	for <kvmarm@archiver.kernel.org>; Tue, 25 Aug 2020 09:40:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 70C4F20706
	for <kvmarm@archiver.kernel.org>; Tue, 25 Aug 2020 09:40:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="cWTqJdbg"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 70C4F20706
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2750C4C0DE;
	Tue, 25 Aug 2020 05:40:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KajtPiaUKZAO; Tue, 25 Aug 2020 05:40:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2BCFC4C117;
	Tue, 25 Aug 2020 05:40:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C3234C042
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Aug 2020 05:40:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id C4-P7eGcUsVM for <kvmarm@lists.cs.columbia.edu>;
 Tue, 25 Aug 2020 05:40:46 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B896D4C08A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Aug 2020 05:40:46 -0400 (EDT)
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa
 [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 41B152075B;
 Tue, 25 Aug 2020 09:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1598348446;
 bh=MfFO9Dzbbbv5rbZaGAyLGGI9xZoBrqu6sFc/sASz1Vs=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=cWTqJdbg7WHvg6J7YIoL7yAiDWzx+gh/9dHMqjplX26LeZfYdV3TkOQfOuh5pGpf0
 njymQNYd6MqyK9bwC1U48MuDxn7lF/kXzaJ4TLuwI1eYinU/U4LDtSBplOA6OD/jBn
 oJuL6f666IKFHxGLK8yuikGsFKCNzsbZKGAlQqkg=
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v3 20/21] KVM: arm64: Remove unused 'pgd' field from 'struct
 kvm_s2_mmu'
Date: Tue, 25 Aug 2020 10:39:52 +0100
Message-Id: <20200825093953.26493-21-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200825093953.26493-1-will@kernel.org>
References: <20200825093953.26493-1-will@kernel.org>
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

The stage-2 page-tables are entirely encapsulated by the 'pgt' field of
'struct kvm_s2_mmu', so remove the unused 'pgd' field.

Cc: Marc Zyngier <maz@kernel.org>
Cc: Quentin Perret <qperret@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h | 1 -
 arch/arm64/kvm/mmu.c              | 2 --
 2 files changed, 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 0b7c702b2151..41caf29bd93c 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -79,7 +79,6 @@ struct kvm_s2_mmu {
 	 * for vEL1/EL0 with vHCR_EL2.VM == 0.  In that case, we use the
 	 * canonical stage-2 page tables.
 	 */
-	pgd_t		*pgd;
 	phys_addr_t	pgd_phys;
 	struct kvm_pgtable *pgt;
 
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index ddeec0b03666..f28e03dcb897 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -384,7 +384,6 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu)
 	mmu->kvm = kvm;
 	mmu->pgt = pgt;
 	mmu->pgd_phys = __pa(pgt->pgd);
-	mmu->pgd = (void *)pgt->pgd;
 	mmu->vmid.vmid_gen = 0;
 	return 0;
 
@@ -470,7 +469,6 @@ void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
 	spin_lock(&kvm->mmu_lock);
 	pgt = mmu->pgt;
 	if (pgt) {
-		mmu->pgd = NULL;
 		mmu->pgd_phys = 0;
 		mmu->pgt = NULL;
 		free_percpu(mmu->last_vcpu_ran);
-- 
2.28.0.297.g1956fa8f8d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
