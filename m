Return-Path: <SRS0=CMxQ=CU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AFF4C43461
	for <kvmarm@archiver.kernel.org>; Fri, 11 Sep 2020 13:26:33 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E0328221EB
	for <kvmarm@archiver.kernel.org>; Fri, 11 Sep 2020 13:26:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="ClDM+0rC"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E0328221EB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8154F4B42F;
	Fri, 11 Sep 2020 09:26:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5YSNyI+TsC0c; Fri, 11 Sep 2020 09:26:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9EE3F4B430;
	Fri, 11 Sep 2020 09:26:30 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 58F314B33F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Sep 2020 09:26:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cOyJ0IuaN3ek for <kvmarm@lists.cs.columbia.edu>;
 Fri, 11 Sep 2020 09:26:27 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 62F594B331
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Sep 2020 09:26:27 -0400 (EDT)
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa
 [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 717FB221E7;
 Fri, 11 Sep 2020 13:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1599830786;
 bh=4kJoFlEiYrr4J5zChe/xWBzvR94zA1I63uLAuVTrkW4=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=ClDM+0rCBUr9dZtk8CZX2VGjEiw4aQCyrjlEEzVqhNruavhnbgMoRm+Aafv0vlpYU
 BCOLAgCRZ2n2EUrGBrhHrMgm/ikV1ja7BQtM6Js3Iiid1IxPDFQ800MDKyT0+bvMpP
 ltkoyN4pqNzOE+sLFLWOicS1EA+e/j9DcG1ELufM=
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v5 20/21] KVM: arm64: Remove unused 'pgd' field from 'struct
 kvm_s2_mmu'
Date: Fri, 11 Sep 2020 14:25:28 +0100
Message-Id: <20200911132529.19844-21-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200911132529.19844-1-will@kernel.org>
References: <20200911132529.19844-1-will@kernel.org>
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
Reviewed-by: Gavin Shan <gshan@redhat.com>
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
index dd0ea7d8065a..21b70abf65a7 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -389,7 +389,6 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu)
 	mmu->kvm = kvm;
 	mmu->pgt = pgt;
 	mmu->pgd_phys = __pa(pgt->pgd);
-	mmu->pgd = (void *)pgt->pgd;
 	mmu->vmid.vmid_gen = 0;
 	return 0;
 
@@ -475,7 +474,6 @@ void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
 	spin_lock(&kvm->mmu_lock);
 	pgt = mmu->pgt;
 	if (pgt) {
-		mmu->pgd = NULL;
 		mmu->pgd_phys = 0;
 		mmu->pgt = NULL;
 		free_percpu(mmu->last_vcpu_ran);
-- 
2.28.0.618.gf4bc123cb7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
