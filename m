Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23790C433FE
	for <kvmarm@archiver.kernel.org>; Thu,  2 Dec 2021 17:11:03 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B979D4B219;
	Thu,  2 Dec 2021 12:11:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qzk3dgzU-suV; Thu,  2 Dec 2021 12:11:01 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 305B74B224;
	Thu,  2 Dec 2021 12:11:01 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BB5654B130
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Dec 2021 12:10:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TQuQfU++g+PH for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Dec 2021 12:10:57 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E5FBE4B195
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Dec 2021 12:10:57 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 9B51E624DD;
 Thu,  2 Dec 2021 17:10:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D80AC53FCF;
 Thu,  2 Dec 2021 17:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1638465056;
 bh=g1EJWBrySQ+lD+cn+Gm8JLLcRf3oBr2bg8d/dO69wDc=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=nTDXeXkFFKk2Nfaqs6qfZr/PA3tOSNM0Uj5gs06/um9kg5goxsKZn0sFOGGkb6sAe
 5J7EghA9llGtY08nnBh3iKZL/z7AwFmlgujX8HEBsrw2t/pqOHk7rtoy/6GRjWX9Vi
 IxofJvA2VQCexFHv+GVtO9coopAe25VJ9kf+mlV2X1lYP8UXvsBd/Syam2PYuAXNjD
 qZEGlpFq+OpD/Bo/oNCB+c1g8CGlC2H9ta4qBasHIrTdToektouP78pffthiAdjKQH
 e/dDdcCyk5yarG6B6T87BPZRZnwclM73Ix0h6KHIgQKqyshJI+37AxFyhasRmgJnmn
 nuBNGGK3uvhFA==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 1/3] arm64: Add missing include of asm/cpufeature.h to
 asm/mmu.h
Date: Thu,  2 Dec 2021 17:10:46 +0000
Message-Id: <20211202171048.26924-2-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211202171048.26924-1-will@kernel.org>
References: <20211202171048.26924-1-will@kernel.org>
MIME-Version: 1.0
Cc: Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
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

asm/mmu.h refers to cpus_have_const_cap() in the definition of
arm64_kernel_unmapped_at_el0() so include asm/cpufeature.h directly
rather than force all users of the header to do it themselves.

Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/mmu.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/include/asm/mmu.h b/arch/arm64/include/asm/mmu.h
index e9c30859f80c..48f8466a4be9 100644
--- a/arch/arm64/include/asm/mmu.h
+++ b/arch/arm64/include/asm/mmu.h
@@ -15,6 +15,7 @@
 #ifndef __ASSEMBLY__
 
 #include <linux/refcount.h>
+#include <asm/cpufeature.h>
 
 typedef struct {
 	atomic64_t	id;
-- 
2.34.0.rc2.393.gf8c9666880-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
