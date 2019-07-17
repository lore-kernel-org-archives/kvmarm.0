Return-Path: <SRS0=U5fj=VO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E7DEC76192
	for <kvmarm@archiver.kernel.org>; Wed, 17 Jul 2019 10:32:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3552221849
	for <kvmarm@archiver.kernel.org>; Wed, 17 Jul 2019 10:32:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3552221849
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9D3EC4A52C;
	Wed, 17 Jul 2019 06:32:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pB5BCh8fqMbA; Wed, 17 Jul 2019 06:32:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B9A34A561;
	Wed, 17 Jul 2019 06:32:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CA3E84A52C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Jul 2019 06:32:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id U2iXNvtkv3BQ for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Jul 2019 06:32:34 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6DCAF4A528
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Jul 2019 06:32:34 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B648628;
 Wed, 17 Jul 2019 03:32:33 -0700 (PDT)
Received: from e112298-lin.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com
 [10.121.207.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 3B0EF3F71A;
 Wed, 17 Jul 2019 03:32:32 -0700 (PDT)
From: Julien Thierry <julien.thierry@arm.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu
Subject: [PATCH] MAINTAINERS: Update my email address
Date: Wed, 17 Jul 2019 11:32:15 +0100
Message-Id: <1563359535-2762-1-git-send-email-julien.thierry@arm.com>
X-Mailer: git-send-email 1.9.1
Cc: maz@kernel.org, catalin.marinas@arm.com, will@kernel.org
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

My @arm.com address will stop working in a couple of weeks. Update
MAINTAINERS and .mailmap files with an address I'll have access to.

Signed-off-by: Julien Thierry <julien.thierry@arm.com>
---
 .mailmap    | 1 +
 MAINTAINERS | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/.mailmap b/.mailmap
index 0fef932..468bced8 100644
--- a/.mailmap
+++ b/.mailmap
@@ -116,6 +116,7 @@ John Stultz <johnstul@us.ibm.com>
 Juha Yrjola <at solidboot.com>
 Juha Yrjola <juha.yrjola@nokia.com>
 Juha Yrjola <juha.yrjola@solidboot.com>
+Julien Thierry <julien.thierry.kdev@gmail.com> <julien.thierry@arm.com>
 Kay Sievers <kay.sievers@vrfy.org>
 Kenneth W Chen <kenneth.w.chen@intel.com>
 Konstantin Khlebnikov <koct9i@gmail.com> <k.khlebnikov@samsung.com>
diff --git a/MAINTAINERS b/MAINTAINERS
index 91d8700..9525601 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8808,7 +8808,7 @@ F:	arch/x86/kvm/svm.c
 KERNEL VIRTUAL MACHINE FOR ARM/ARM64 (KVM/arm, KVM/arm64)
 M:	Marc Zyngier <marc.zyngier@arm.com>
 R:	James Morse <james.morse@arm.com>
-R:	Julien Thierry <julien.thierry@arm.com>
+R:	Julien Thierry <julien.thierry.kdev@gmail.com>
 R:	Suzuki K Pouloze <suzuki.poulose@arm.com>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 L:	kvmarm@lists.cs.columbia.edu
-- 
1.9.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
