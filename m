Return-Path: <SRS0=3/sM=BJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EC6CC433E0
	for <kvmarm@archiver.kernel.org>; Thu, 30 Jul 2020 15:35:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0A3C220829
	for <kvmarm@archiver.kernel.org>; Thu, 30 Jul 2020 15:35:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="htnuPvKk"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0A3C220829
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B72B94B3F7;
	Thu, 30 Jul 2020 11:35:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id kPN1Gq6JLDAj; Thu, 30 Jul 2020 11:35:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B88004B484;
	Thu, 30 Jul 2020 11:35:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B55B04B3AB
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jul 2020 11:34:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DxjZ9zmYo6fk for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Jul 2020 11:34:58 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id ABEA34B4F0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jul 2020 11:34:58 -0400 (EDT)
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa
 [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 74A5722B49;
 Thu, 30 Jul 2020 15:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1596123298;
 bh=vCaNRWqwfgl6pffqz/R6cv3xROa61YkUyi1FE8SOKog=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=htnuPvKkbpgu3bnbNERhB3yHNX1QyUs958gDig7gd/V55zvT46JBGAoloXBhXh99g
 HWK9xGt4w3fHrXgYsTTy3mTYPT0pnCa7QnI3WZGlrZXqa1/OfmqGrRklyL7uN77c48
 xgFJE+zajfH/5IMO9u2R94hPTRH2GXxL8Y8ergIs=
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 19/20] KVM: arm64: Remove unused 'pgd' field from 'struct
 kvm_s2_mmu'
Date: Thu, 30 Jul 2020 16:34:05 +0100
Message-Id: <20200730153406.25136-20-will@kernel.org>
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

The stage-2 page-tables are entirely encapsulated by the 'pgt_cookie'
field of 'struct kvm_s2_mmu', so remove the unused 'pgd' field.

Cc: Marc Zyngier <maz@kernel.org>
Cc: Quentin Perret <qperret@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h | 1 -
 arch/arm64/kvm/mmu.c              | 2 --
 2 files changed, 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 072ab1fac98a..3763880dd47b 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -79,7 +79,6 @@ struct kvm_s2_mmu {
 	 * for vEL1/EL0 with vHCR_EL2.VM == 0.  In that case, we use the
 	 * canonical stage-2 page tables.
 	 */
-	pgd_t		*pgd;
 	phys_addr_t	pgd_phys;
 	void		*pgt_cookie;
 
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 66af9c00b9ad..6351c2dfb63e 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -397,7 +397,6 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu)
 	mmu->kvm = kvm;
 	mmu->pgt_cookie = cookie;
 	mmu->pgd_phys = kvm_pgtable_get_pgd_phys(cookie);
-	mmu->pgd = __va(mmu->pgd_phys);
 	mmu->vmid.vmid_gen = 0;
 
 	return 0;
@@ -478,7 +477,6 @@ void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
 	spin_lock(&kvm->mmu_lock);
 	cookie = mmu->pgt_cookie;
 	if (cookie) {
-		mmu->pgd = NULL;
 		mmu->pgd_phys = 0;
 		mmu->pgt_cookie = NULL;
 		free_percpu(mmu->last_vcpu_ran);
-- 
2.28.0.rc0.142.g3c755180ce-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
