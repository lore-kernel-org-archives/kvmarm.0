Return-Path: <SRS0=gWTa=IU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F6AEC433DB
	for <kvmarm@archiver.kernel.org>; Mon, 22 Mar 2021 16:48:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8BF3A61990
	for <kvmarm@archiver.kernel.org>; Mon, 22 Mar 2021 16:48:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8BF3A61990
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1D14A4B35B;
	Mon, 22 Mar 2021 12:48:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3ZlY3Kdqlz+O; Mon, 22 Mar 2021 12:48:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 86A6A4B37D;
	Mon, 22 Mar 2021 12:48:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D22AD4B378
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Mar 2021 12:48:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gaiSkgAUaLP6 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 22 Mar 2021 12:48:38 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E11314B2DD
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Mar 2021 12:48:37 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id EB2136157F;
 Mon, 22 Mar 2021 16:48:35 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1lONjG-0037Ov-5x; Mon, 22 Mar 2021 16:48:34 +0000
From: Marc Zyngier <maz@kernel.org>
To: Quentin Perret <qperret@google.com>
Subject: [PATCH 1/3] KVM: arm64: Constraint KVM's own __flush_dcache_area to
 protectected mode
Date: Mon, 22 Mar 2021 16:48:26 +0000
Message-Id: <20210322164828.800662-2-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210322164828.800662-1-maz@kernel.org>
References: <20210322164828.800662-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: qperret@google.com, catalin.marinas@arm.com,
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 android-kvm@google.com, seanjc@google.com, mate.toth-pal@arm.com,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu, tabba@google.com,
 ardb@kernel.org, mark.rutland@arm.com, dbrazdil@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: android-kvm@google.com, catalin.marinas@arm.com, mate.toth-pal@arm.com,
 tabba@google.com, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, seanjc@google.com,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu
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

As we are about to specialise KVM's version of __flush_dcache_area
via a hack opn the read_ctr macro, make sure that we won't ever
use KVM's copy of __flush_dcache_area(), as things would otherwise
break for late arriving CPUs.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/cache.S | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/cache.S b/arch/arm64/kvm/hyp/nvhe/cache.S
index 36cef6915428..1c177d3ec5c6 100644
--- a/arch/arm64/kvm/hyp/nvhe/cache.S
+++ b/arch/arm64/kvm/hyp/nvhe/cache.S
@@ -6,8 +6,12 @@
 #include <linux/linkage.h>
 #include <asm/assembler.h>
 #include <asm/alternative.h>
+#include <asm/asm-bug.h>
 
 SYM_FUNC_START_PI(__flush_dcache_area)
+alternative_if_not ARM64_KVM_PROTECTED_MODE
+	ASM_BUG()
+alternative_else_nop_endif
 	dcache_by_line_op civac, sy, x0, x1, x2, x3
 	ret
 SYM_FUNC_END_PI(__flush_dcache_area)
-- 
2.29.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
