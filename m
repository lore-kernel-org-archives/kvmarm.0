Return-Path: <SRS0=CMxQ=CU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78699C43461
	for <kvmarm@archiver.kernel.org>; Fri, 11 Sep 2020 13:26:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 18C7B22224
	for <kvmarm@archiver.kernel.org>; Fri, 11 Sep 2020 13:26:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="I+pNIEIO"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 18C7B22224
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C16B84B412;
	Fri, 11 Sep 2020 09:26:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HSY1iKOJZoT9; Fri, 11 Sep 2020 09:26:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 95E7D4B3F5;
	Fri, 11 Sep 2020 09:26:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CBC714B3A9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Sep 2020 09:26:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ioTL4vq+gIbW for <kvmarm@lists.cs.columbia.edu>;
 Fri, 11 Sep 2020 09:26:09 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AD3DE4B372
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Sep 2020 09:26:09 -0400 (EDT)
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa
 [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id EC48722206;
 Fri, 11 Sep 2020 13:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1599830768;
 bh=AM1AOIu9NXZc2MuXJUIWJu3yrnahIbFnS8vbBJc+UFA=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=I+pNIEIO/U5xxJQU6wac1x6oD3KuLwB+tO/FmfV27z+Batwig6mhfppWl1eKBpNfQ
 NX6t2i9jx0U81FSyFD4aYWNn5yyvXChv2kF9s39uqpPFo4eupQc2/ixqYtwB5i++yo
 wdRWerEBUHjy8acaJsWpMDr/yRiIZkn/rfhocQ8I=
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v5 13/21] KVM: arm64: Convert write-protect operation to
 generic page-table API
Date: Fri, 11 Sep 2020 14:25:21 +0100
Message-Id: <20200911132529.19844-14-will@kernel.org>
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

Convert stage2_wp_range() to call the kvm_pgtable_stage2_wrprotect()
function of the generic page-table code instead of walking the page-table
directly.

Cc: Marc Zyngier <maz@kernel.org>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Signed-off-by: Quentin Perret <qperret@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/mmu.c | 25 ++++---------------------
 1 file changed, 4 insertions(+), 21 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 36407dcdf01e..a37da87eb7eb 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -71,6 +71,9 @@ static int stage2_apply_range(struct kvm *kvm, phys_addr_t addr,
 	return ret;
 }
 
+#define stage2_apply_range_resched(kvm, addr, end, fn)			\
+	stage2_apply_range(kvm, addr, end, fn, true)
+
 static bool memslot_is_logging(struct kvm_memory_slot *memslot)
 {
 	return memslot->dirty_bitmap && !(memslot->flags & KVM_MEM_READONLY);
@@ -1302,27 +1305,7 @@ static void  stage2_wp_p4ds(struct kvm_s2_mmu *mmu, pgd_t *pgd,
 static void stage2_wp_range(struct kvm_s2_mmu *mmu, phys_addr_t addr, phys_addr_t end)
 {
 	struct kvm *kvm = mmu->kvm;
-	pgd_t *pgd;
-	phys_addr_t next;
-
-	pgd = mmu->pgd + stage2_pgd_index(kvm, addr);
-	do {
-		/*
-		 * Release kvm_mmu_lock periodically if the memory region is
-		 * large. Otherwise, we may see kernel panics with
-		 * CONFIG_DETECT_HUNG_TASK, CONFIG_LOCKUP_DETECTOR,
-		 * CONFIG_LOCKDEP. Additionally, holding the lock too long
-		 * will also starve other vCPUs. We have to also make sure
-		 * that the page tables are not freed while we released
-		 * the lock.
-		 */
-		cond_resched_lock(&kvm->mmu_lock);
-		if (!READ_ONCE(mmu->pgd))
-			break;
-		next = stage2_pgd_addr_end(kvm, addr, end);
-		if (stage2_pgd_present(kvm, *pgd))
-			stage2_wp_p4ds(mmu, pgd, addr, next);
-	} while (pgd++, addr = next, addr != end);
+	stage2_apply_range_resched(kvm, addr, end, kvm_pgtable_stage2_wrprotect);
 }
 
 /**
-- 
2.28.0.618.gf4bc123cb7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
