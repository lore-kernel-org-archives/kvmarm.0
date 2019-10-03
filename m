Return-Path: <SRS0=Brgg=X4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99ED1ECE589
	for <kvmarm@archiver.kernel.org>; Thu,  3 Oct 2019 11:32:39 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5A52C21D81
	for <kvmarm@archiver.kernel.org>; Thu,  3 Oct 2019 11:32:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5A52C21D81
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 071F84A78D;
	Thu,  3 Oct 2019 07:32:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NufcJhg55y3D; Thu,  3 Oct 2019 07:32:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 03C934A796;
	Thu,  3 Oct 2019 07:32:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B6A44A789
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Oct 2019 07:32:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 22aR08NBDccX for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Oct 2019 07:32:36 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 25ABB4A775
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Oct 2019 07:32:36 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B65281597;
 Thu,  3 Oct 2019 04:32:35 -0700 (PDT)
Received: from e123195-lin.cambridge.arm.com (e123195-lin.cambridge.arm.com
 [10.1.196.63])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id A88243F706;
 Thu,  3 Oct 2019 04:32:34 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.cs.columbia.edu
Subject: [kvm-unit-tests PATCH v2 1/3] lib: arm64: Add missing ISB in
 flush_tlb_page
Date: Thu,  3 Oct 2019 12:32:15 +0100
Message-Id: <20191003113217.25464-2-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191003113217.25464-1-alexandru.elisei@arm.com>
References: <20191003113217.25464-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Cc: pbonzini@redhat.com, andre.przywara@arm.com, maz@kernel.org
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

Linux commit d0b7a302d58a made it abundantly clear that certain CPU
implementations require an ISB after a DSB. Add the missing ISB to
flush_tlb_page. No changes are required for flush_tlb_all, as the function
already had the ISB.

Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 lib/arm64/asm/mmu.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/arm64/asm/mmu.h b/lib/arm64/asm/mmu.h
index fa554b0c20ae..72d75eafc882 100644
--- a/lib/arm64/asm/mmu.h
+++ b/lib/arm64/asm/mmu.h
@@ -24,6 +24,7 @@ static inline void flush_tlb_page(unsigned long vaddr)
 	dsb(ishst);
 	asm("tlbi	vaae1is, %0" :: "r" (page));
 	dsb(ish);
+	isb();
 }
 
 static inline void flush_dcache_addr(unsigned long vaddr)
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
