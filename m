Return-Path: <SRS0=u4Cy=NQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A080C4338F
	for <kvmarm@archiver.kernel.org>; Wed, 25 Aug 2021 16:18:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4CE0E61183
	for <kvmarm@archiver.kernel.org>; Wed, 25 Aug 2021 16:18:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 4CE0E61183
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 03D404B214;
	Wed, 25 Aug 2021 12:18:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XjqpiC4If-dF; Wed, 25 Aug 2021 12:17:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0C49B4B2A0;
	Wed, 25 Aug 2021 12:17:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B342F4B209
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Aug 2021 12:17:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zPCzszrPEs3Q for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 Aug 2021 12:17:40 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4F3364B276
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Aug 2021 12:17:25 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0CEC8D6E;
 Wed, 25 Aug 2021 09:17:25 -0700 (PDT)
Received: from monolith.cable.virginm.net (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B362E3F66F;
 Wed, 25 Aug 2021 09:17:23 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 will@kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH v4 08/39] KVM: arm64: Deny changes to locked memslots
Date: Wed, 25 Aug 2021 17:17:44 +0100
Message-Id: <20210825161815.266051-9-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210825161815.266051-1-alexandru.elisei@arm.com>
References: <20210825161815.266051-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
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

Forbid userspace from making changes to a locked memslot. If userspace
wants to modify a locked memslot, then they will need to unlock it.

One special case is allowed: memslots locked for read, but not for write,
can have dirty page logging turned on.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arch/arm64/kvm/mmu.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 27b7befd4fa9..3ab8eba808ae 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1842,8 +1842,23 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 {
 	hva_t hva = mem->userspace_addr;
 	hva_t reg_end = hva + mem->memory_size;
+	struct kvm_memory_slot *old;
 	int ret = 0;
 
+	/*
+	 * Forbid all changes to locked memslots with the exception of turning
+	 * on dirty page logging for memslots locked only for reads.
+	 */
+	old = id_to_memslot(kvm_memslots(kvm), memslot->id);
+	if (old && memslot_is_locked(old)) {
+		if (change == KVM_MR_FLAGS_ONLY &&
+		    memslot_is_logging(memslot) &&
+		    !(old->arch.flags & KVM_MEMSLOT_LOCK_WRITE))
+			memcpy(&memslot->arch, &old->arch, sizeof(old->arch));
+		else
+			return -EBUSY;
+	}
+
 	if (change != KVM_MR_CREATE && change != KVM_MR_MOVE &&
 			change != KVM_MR_FLAGS_ONLY)
 		return 0;
-- 
2.33.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
