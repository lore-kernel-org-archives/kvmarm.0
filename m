Return-Path: <SRS0=e8ws=CY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4ADFBC433E2
	for <kvmarm@archiver.kernel.org>; Tue, 15 Sep 2020 17:03:54 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9D14F21D43
	for <kvmarm@archiver.kernel.org>; Tue, 15 Sep 2020 17:03:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9D14F21D43
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F0B294B2AE;
	Tue, 15 Sep 2020 13:03:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sJuP0P1CcPIr; Tue, 15 Sep 2020 13:03:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DCDF94B2B3;
	Tue, 15 Sep 2020 13:03:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4A2A54B22C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Sep 2020 13:03:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kNv54o4KVAi4 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Sep 2020 13:03:49 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 172C64B220
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Sep 2020 13:03:49 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AD59A1FB;
 Tue, 15 Sep 2020 10:03:48 -0700 (PDT)
Received: from monolith.localdoman (unknown [10.37.8.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 161673F68F;
 Tue, 15 Sep 2020 10:03:46 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.cs.columbia.edu
Subject: [PATCH] KVM: arm64: Do not flush memslot if FWB is supported
Date: Tue, 15 Sep 2020 18:04:42 +0100
Message-Id: <20200915170442.131635-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Cc: maz@kernel.org
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

As a result of a KVM_SET_USER_MEMORY_REGION ioctl, KVM flushes the
dcache for the memslot being changed to ensure a consistent view of memory
between the host and the guest: the host runs with caches enabled, and
it is possible for the data written by the hypervisor to still be in the
caches, but the guest is running with stage 1 disabled, meaning data
accesses are to Device-nGnRnE memory, bypassing the caches entirely.

Flushing the dcache is not necessary when KVM enables FWB, because it
forces the guest to uses cacheable memory accesses.

The current behaviour does not change, as the dcache flush helpers execute
the cache operation only if FWB is not enabled, but walking the stage 2
table is avoided.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arch/arm64/kvm/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 9a636b8064f1..c29105c6e975 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -2537,7 +2537,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 	spin_lock(&kvm->mmu_lock);
 	if (ret)
 		unmap_stage2_range(&kvm->arch.mmu, mem->guest_phys_addr, mem->memory_size);
-	else
+	else if (!cpus_have_final_cap(ARM64_HAS_STAGE2_FWB))
 		stage2_flush_memslot(kvm, memslot);
 	spin_unlock(&kvm->mmu_lock);
 out:
-- 
2.28.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
