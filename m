Return-Path: <SRS0=C9Vx=X2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FB30ECE589
	for <kvmarm@archiver.kernel.org>; Tue,  1 Oct 2019 10:23:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DEB9B21924
	for <kvmarm@archiver.kernel.org>; Tue,  1 Oct 2019 10:23:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DEB9B21924
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 96BDC4A7AE;
	Tue,  1 Oct 2019 06:23:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mw7J8tCpNG0J; Tue,  1 Oct 2019 06:23:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 983C84A700;
	Tue,  1 Oct 2019 06:23:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 88C2D4A680
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Oct 2019 06:23:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id udLT1pUbXRKN for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 Oct 2019 06:23:51 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 73A644A6E7
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Oct 2019 06:23:51 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3E4591000;
 Tue,  1 Oct 2019 03:23:51 -0700 (PDT)
Received: from e123195-lin.cambridge.arm.com (e123195-lin.cambridge.arm.com
 [10.1.196.63])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id F099F3F739;
 Tue,  1 Oct 2019 03:23:49 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.cs.columbia.edu
Subject: [kvm-unit-tests RFC PATCH v2 09/19] lib: arm/arm64: Refuse to disable
 the MMU with non-identity stack pointer
Date: Tue,  1 Oct 2019 11:23:13 +0100
Message-Id: <20191001102323.27628-10-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191001102323.27628-1-alexandru.elisei@arm.com>
References: <20191001102323.27628-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Cc: maz@kernel.org, andre.przywara@arm.com, pbonzini@redhat.com
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

When the MMU is off, all addresses are physical addresses. If the stack
pointer is not an identity mapped address (the virtual address is not the
same as the physical address), then we end up trying to access an invalid
memory region. This can happen if we call mmu_disable from a secondary CPU,
which has its stack allocated from the vmalloc region.

Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 lib/arm/mmu.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
index 3d38c8397f5a..161f7a8e607c 100644
--- a/lib/arm/mmu.c
+++ b/lib/arm/mmu.c
@@ -66,8 +66,12 @@ void mmu_enable(pgd_t *pgtable)
 extern void asm_mmu_disable(void);
 void mmu_disable(void)
 {
+	unsigned long sp = current_stack_pointer;
 	int cpu = current_thread_info()->cpu;
 
+	assert_msg(__virt_to_phys(sp) == sp,
+			"Attempting to disable MMU with non-identity mapped stack");
+
 	mmu_mark_disabled(cpu);
 
 	asm_mmu_disable();
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
