Return-Path: <SRS0=odEw=I6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CC0CC433B4
	for <kvmarm@archiver.kernel.org>; Thu,  1 Apr 2021 14:08:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8EC1861286
	for <kvmarm@archiver.kernel.org>; Thu,  1 Apr 2021 14:08:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8EC1861286
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0DDD94B6CE;
	Thu,  1 Apr 2021 10:08:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ld+fy0nMSaiX; Thu,  1 Apr 2021 10:08:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E7C5A4B6B2;
	Thu,  1 Apr 2021 10:08:10 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 87CF74B495
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Apr 2021 09:09:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ALxPgKmgsWyj for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Apr 2021 09:08:59 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4CF864B65B
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Apr 2021 09:08:59 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B85DA1570;
 Thu,  1 Apr 2021 06:08:58 -0700 (PDT)
Received: from yoan-MS-7758.Home (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 8E7593F792;
 Thu,  1 Apr 2021 06:08:57 -0700 (PDT)
From: Yoan Picchi <yoan.picchi@arm.com>
To: maz@kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com,
 suzuki.poulose@arm.com, kvmarm@lists.cs.columbia.edu
Subject: [PATCH] KVM: arm64: Fix a typo in the kvm_init_stage2_mmu
 documentation
Date: Thu,  1 Apr 2021 14:08:42 +0100
Message-Id: <20210401130842.18991-1-yoan.picchi@arm.com>
X-Mailer: git-send-email 2.17.1
X-Mailman-Approved-At: Thu, 01 Apr 2021 10:08:09 -0400
Cc: Yoan Picchi <yoan.picchi@arm.com>, trivial@kernel.org
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
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

A single letter : strucrure -> structure

Signed-off-by: Yoan Picchi <yoan.picchi@arm.com>
---
 arch/arm64/kvm/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 77cb2d28f..eed9fed86 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -352,7 +352,7 @@ int create_hyp_exec_mappings(phys_addr_t phys_addr, size_t size,
 }
 
 /**
- * kvm_init_stage2_mmu - Initialise a S2 MMU strucrure
+ * kvm_init_stage2_mmu - Initialise a S2 MMU structure
  * @kvm:	The pointer to the KVM structure
  * @mmu:	The pointer to the s2 MMU structure
  *
-- 
2.17.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
