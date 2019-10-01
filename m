Return-Path: <SRS0=C9Vx=X2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE9D4C352AA
	for <kvmarm@archiver.kernel.org>; Tue,  1 Oct 2019 10:23:48 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 69F7721D56
	for <kvmarm@archiver.kernel.org>; Tue,  1 Oct 2019 10:23:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 69F7721D56
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1BE0C4A6F6;
	Tue,  1 Oct 2019 06:23:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9d8ZRNyszqlq; Tue,  1 Oct 2019 06:23:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ED24F4A6D5;
	Tue,  1 Oct 2019 06:23:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EACE54A674
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Oct 2019 06:23:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xfXw8cIDqN96 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 Oct 2019 06:23:44 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0A4944A6B5
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Oct 2019 06:23:44 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D19A91000;
 Tue,  1 Oct 2019 03:23:43 -0700 (PDT)
Received: from e123195-lin.cambridge.arm.com (e123195-lin.cambridge.arm.com
 [10.1.196.63])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 8CF943F739;
 Tue,  1 Oct 2019 03:23:42 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.cs.columbia.edu
Subject: [kvm-unit-tests RFC PATCH v2 04/19] lib: arm: Implement flush_tlb_all
Date: Tue,  1 Oct 2019 11:23:08 +0100
Message-Id: <20191001102323.27628-5-alexandru.elisei@arm.com>
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

flush_tlb_all performs a TLBIALL, which affects only the executing PE; fix
that by executing a TLBIALLIS. Note that virtualization extensions imply
the multiprocessing extensions, so we're safe to use that instruction.

While we're at it, let's add a comment to flush_dcache_addr stating what
instruction is uses (unsurprisingly, it's a dcache clean and invalidate to
PoC).

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 lib/arm/asm/mmu.h | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/lib/arm/asm/mmu.h b/lib/arm/asm/mmu.h
index 915c2b07dead..e64a900a45a6 100644
--- a/lib/arm/asm/mmu.h
+++ b/lib/arm/asm/mmu.h
@@ -25,8 +25,10 @@ static inline void local_flush_tlb_all(void)
 
 static inline void flush_tlb_all(void)
 {
-	//TODO
-	local_flush_tlb_all();
+	/* TLBIALLIS */
+	asm volatile("mcr p15, 0, %0, c8, c3, 0" :: "r" (0));
+	dsb();
+	isb();
 }
 
 static inline void flush_tlb_page(unsigned long vaddr)
@@ -39,6 +41,7 @@ static inline void flush_tlb_page(unsigned long vaddr)
 
 static inline void flush_dcache_addr(unsigned long vaddr)
 {
+	/* DCCIMVAC */
 	asm volatile("mcr p15, 0, %0, c7, c14, 1" :: "r" (vaddr));
 }
 
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
