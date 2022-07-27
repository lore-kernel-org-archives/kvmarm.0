Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76842C04A68
	for <kvmarm@archiver.kernel.org>; Wed, 27 Jul 2022 14:29:39 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 24FF04C79C;
	Wed, 27 Jul 2022 10:29:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id eT+D58GBma7t; Wed, 27 Jul 2022 10:29:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C23794C7B9;
	Wed, 27 Jul 2022 10:29:32 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7CB2D4C6C4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Jul 2022 10:29:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IzILBvH91HRJ for <kvmarm@lists.cs.columbia.edu>;
 Wed, 27 Jul 2022 10:29:29 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 448084C7A1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Jul 2022 10:29:28 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 48948B82187;
 Wed, 27 Jul 2022 14:29:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD161C433D6;
 Wed, 27 Jul 2022 14:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1658932166;
 bh=ucMNCrws7KhQhf8hTanOu2XwNAuEOvJybE4pmo7FkqE=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=KRVFoWgDA5r5UCORtgyYITfLOPFZaMQZF3Xk/9OoSjY3wnabf/HfXXf9/cblgFm6N
 UCN2PdTn8lG5AQy17JTLY2Dzv85HgvA0QwCBROHwHfeyZcxyzP7S0BbO17Cce/LBtj
 UOIlDBgUsE0F6EPY2xbjz0z5llKTLnsSRwUUiueSXP8MPoCJld3xgg72KQISAMxEMm
 cejTM4GmLc88Tl5Ib/CsBXfUXp8OzPbSB5co/GO7Zs+rlFRpNa6H+XETAjUVlGG0MW
 8RgNVmnK8xzY1NBcLGeS6W3uFN5APSr2rWzPvok0HbR4nnV5uzJEyt4IE0KZcKw+7A
 sDY3toA8vABrw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1oGi2O-00APjL-Uc;
 Wed, 27 Jul 2022 15:29:24 +0100
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
Subject: [PATCH 6/6] arm64: Update 'unwinder howto'
Date: Wed, 27 Jul 2022 15:29:06 +0100
Message-Id: <20220727142906.1856759-7-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220727142906.1856759-1-maz@kernel.org>
References: <20220726073750.3219117-18-kaleshsingh@google.com>
 <20220727142906.1856759-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, mark.rutland@arm.com,
 broonie@kernel.org, madvenka@linux.microsoft.com, tabba@google.com,
 oliver.upton@linux.dev, qperret@google.com, kaleshsingh@google.com,
 james.morse@arm.com, alexandru.elisei@arm.com, suzuki.poulose@arm.com,
 catalin.marinas@arm.com, andreyknvl@gmail.com, vincenzo.frascino@arm.com,
 mhiramat@kernel.org, ast@kernel.org, wangkefeng.wang@huawei.com,
 elver@google.com, keirf@google.com, yuzenghui@huawei.com, ardb@kernel.org,
 oupton@google.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: wangkefeng.wang@huawei.com, catalin.marinas@arm.com, ast@kernel.org,
 vincenzo.frascino@arm.com, madvenka@linux.microsoft.com,
 kernel-team@android.com, elver@google.com, broonie@kernel.org,
 andreyknvl@gmail.com, mhiramat@kernel.org
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

Implementing a new unwinder is a bit more involved than writing
a couple of helpers, so let's not lure the reader into a false
sense of comfort. Instead, let's point out what they should
call into, and what sort of parameter they need to provide.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/stacktrace/common.h | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/include/asm/stacktrace/common.h b/arch/arm64/include/asm/stacktrace/common.h
index 18046a7248a2..f58eb944c46f 100644
--- a/arch/arm64/include/asm/stacktrace/common.h
+++ b/arch/arm64/include/asm/stacktrace/common.h
@@ -5,17 +5,11 @@
  * To implement a new arm64 stack unwinder:
  *     1) Include this header
  *
- *     2) Provide implementations for the following functions:
- *          on_overflow_stack():   Returns true if SP is on the overflow
- *                                 stack.
- *          on_accessible_stack(): Returns true is SP is on any accessible
- *                                 stack.
- *          unwind_next():         Performs validation checks on the frame
- *                                 pointer, and transitions unwind_state
- *                                 to the next frame.
+ *     2) Call into unwind_next_common() from your top level unwind
+ *        function, passing it the validation and translation callbacks
+ *        (though the later can be NULL if no translation is required).
  *
- *         See: arch/arm64/include/asm/stacktrace.h for reference
- *              implementations.
+ * See: arch/arm64/kernel/stacktrace.c for the reference implementation.
  *
  * Copyright (C) 2012 ARM Ltd.
  */
-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
