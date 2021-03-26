Return-Path: <SRS0=1o63=IY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6ACDC433E0
	for <kvmarm@archiver.kernel.org>; Fri, 26 Mar 2021 03:17:44 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5F2DB61A3F
	for <kvmarm@archiver.kernel.org>; Fri, 26 Mar 2021 03:17:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5F2DB61A3F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F08F54B351;
	Thu, 25 Mar 2021 23:17:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id quCrZ5WMCzI6; Thu, 25 Mar 2021 23:17:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A09644B47D;
	Thu, 25 Mar 2021 23:17:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D5194B459
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Mar 2021 23:17:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SkDUQ6czqfO9 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 25 Mar 2021 23:17:40 -0400 (EDT)
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2F5924B0E4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Mar 2021 23:17:40 -0400 (EDT)
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
 by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4F66YP5pkqzyNyM;
 Fri, 26 Mar 2021 11:15:37 +0800 (CST)
Received: from DESKTOP-TMVL5KK.china.huawei.com (10.174.187.128) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.498.0; Fri, 26 Mar 2021 11:17:28 +0800
From: Yanan Wang <wangyanan55@huawei.com>
To: Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, "Alexandru
 Elisei" <alexandru.elisei@arm.com>, Catalin Marinas
 <catalin.marinas@arm.com>, <kvmarm@lists.cs.columbia.edu>,
 <linux-arm-kernel@lists.infradead.org>, <kvm@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH v3 2/2] KVM: arm64: Distinguish cases of memcache
 allocations completely
Date: Fri, 26 Mar 2021 11:16:54 +0800
Message-ID: <20210326031654.3716-3-wangyanan55@huawei.com>
X-Mailer: git-send-email 2.8.4.windows.1
In-Reply-To: <20210326031654.3716-1-wangyanan55@huawei.com>
References: <20210326031654.3716-1-wangyanan55@huawei.com>
MIME-Version: 1.0
X-Originating-IP: [10.174.187.128]
X-CFilter-Loop: Reflected
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

With a guest translation fault, the memcache pages are not needed if KVM
is only about to install a new leaf entry into the existing page table.
And with a guest permission fault, the memcache pages are also not needed
for a write_fault in dirty-logging time if KVM is only about to update
the existing leaf entry instead of collapsing a block entry into a table.

By comparing fault_granule and vma_pagesize, cases that require allocations
from memcache and cases that don't can be distinguished completely.

Signed-off-by: Yanan Wang <wangyanan55@huawei.com>
---
 arch/arm64/kvm/mmu.c | 25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 1eec9f63bc6f..05af40dc60c1 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -810,19 +810,6 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	gfn = fault_ipa >> PAGE_SHIFT;
 	mmap_read_unlock(current->mm);
 
-	/*
-	 * Permission faults just need to update the existing leaf entry,
-	 * and so normally don't require allocations from the memcache. The
-	 * only exception to this is when dirty logging is enabled at runtime
-	 * and a write fault needs to collapse a block entry into a table.
-	 */
-	if (fault_status != FSC_PERM || (logging_active && write_fault)) {
-		ret = kvm_mmu_topup_memory_cache(memcache,
-						 kvm_mmu_cache_min_pages(kvm));
-		if (ret)
-			return ret;
-	}
-
 	mmu_seq = vcpu->kvm->mmu_notifier_seq;
 	/*
 	 * Ensure the read of mmu_notifier_seq happens before we call
@@ -880,6 +867,18 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	else if (cpus_have_const_cap(ARM64_HAS_CACHE_DIC))
 		prot |= KVM_PGTABLE_PROT_X;
 
+	/*
+	 * Allocations from the memcache are required only when granule of the
+	 * lookup level where the guest fault happened exceeds vma_pagesize,
+	 * which means new page tables will be created in the fault handlers.
+	 */
+	if (fault_granule > vma_pagesize) {
+		ret = kvm_mmu_topup_memory_cache(memcache,
+						 kvm_mmu_cache_min_pages(kvm));
+		if (ret)
+			return ret;
+	}
+
 	/*
 	 * Under the premise of getting a FSC_PERM fault, we just need to relax
 	 * permissions only if vma_pagesize equals fault_granule. Otherwise,
-- 
2.19.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
