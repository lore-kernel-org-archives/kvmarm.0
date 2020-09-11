Return-Path: <SRS0=CMxQ=CU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E40A8C43461
	for <kvmarm@archiver.kernel.org>; Fri, 11 Sep 2020 13:26:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7AECB22229
	for <kvmarm@archiver.kernel.org>; Fri, 11 Sep 2020 13:26:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="qDLQQPza"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7AECB22229
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 296334B408;
	Fri, 11 Sep 2020 09:26:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jdtj9EnBMYNy; Fri, 11 Sep 2020 09:26:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E5A9F4B3F6;
	Fri, 11 Sep 2020 09:26:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7C86D4B3E9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Sep 2020 09:26:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XQWCrOT3sdRQ for <kvmarm@lists.cs.columbia.edu>;
 Fri, 11 Sep 2020 09:26:14 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 75FAC4B2D5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Sep 2020 09:26:14 -0400 (EDT)
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa
 [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id C4A8822227;
 Fri, 11 Sep 2020 13:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1599830773;
 bh=7IYY9uULuVe/MjylAj8GoTc47x5DxIsC9D0HqIcZNHI=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=qDLQQPza9rtYqYfFwkV/ORd7jKHkGxN1GtBwvlPEMhnns4rz4U3B1xZxXFAq3ceSR
 SnYwI7pxfjt93c0RMACf0rbmCLidkk3u7Nd9kccHuVZhqM7KDjwqlzRV00VgMkwoMv
 lejp2a8SpjKDflSJdTSRBJcVBjB8+2kksLKkhUqw=
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v5 15/21] KVM: arm64: Convert memslot cache-flushing code to
 generic page-table API
Date: Fri, 11 Sep 2020 14:25:23 +0100
Message-Id: <20200911132529.19844-16-will@kernel.org>
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

From: Quentin Perret <qperret@google.com>

Convert stage2_flush_memslot() to call the kvm_pgtable_stage2_flush()
function of the generic page-table code instead of walking the page-table
directly.

Cc: Marc Zyngier <maz@kernel.org>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Signed-off-by: Quentin Perret <qperret@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/mmu.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index a37da87eb7eb..d5813996c0e4 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -460,21 +460,10 @@ static void stage2_flush_p4ds(struct kvm_s2_mmu *mmu, pgd_t *pgd,
 static void stage2_flush_memslot(struct kvm *kvm,
 				 struct kvm_memory_slot *memslot)
 {
-	struct kvm_s2_mmu *mmu = &kvm->arch.mmu;
 	phys_addr_t addr = memslot->base_gfn << PAGE_SHIFT;
 	phys_addr_t end = addr + PAGE_SIZE * memslot->npages;
-	phys_addr_t next;
-	pgd_t *pgd;
 
-	pgd = mmu->pgd + stage2_pgd_index(kvm, addr);
-	do {
-		next = stage2_pgd_addr_end(kvm, addr, end);
-		if (!stage2_pgd_none(kvm, *pgd))
-			stage2_flush_p4ds(mmu, pgd, addr, next);
-
-		if (next != end)
-			cond_resched_lock(&kvm->mmu_lock);
-	} while (pgd++, addr = next, addr != end);
+	stage2_apply_range_resched(kvm, addr, end, kvm_pgtable_stage2_flush);
 }
 
 /**
-- 
2.28.0.618.gf4bc123cb7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
