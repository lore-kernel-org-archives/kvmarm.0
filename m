Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EB5ECCA479
	for <kvmarm@archiver.kernel.org>; Thu, 21 Jul 2022 05:57:52 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 465964D95B;
	Thu, 21 Jul 2022 01:57:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ukE82hahEbKB; Thu, 21 Jul 2022 01:57:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AC2434DA53;
	Thu, 21 Jul 2022 01:57:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C96494D821
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2022 01:57:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zqXlkNTw3lwd for <kvmarm@lists.cs.columbia.edu>;
 Thu, 21 Jul 2022 01:57:48 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B073E4D2C3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2022 01:57:48 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id
 m11-20020a5b040b000000b0066fcc60d1a0so571552ybp.19
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Jul 2022 22:57:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=iLoEKCBMnlFKYYYcN0OANFAEglV5FtD84V5LcwTvHwg=;
 b=iOS+USjx9NgCbUY4yL44SP1DEiSpvV4mn2X29qjPNJNxKeAXL+qsxjnw4XKuHrWeBy
 QD0Wm6fBKb8nu9zx4zo5TptOXWfccSlTjHBGDDSGFcaD8PPGK+TGhkHKPtLrzs/KbRJb
 H1SNm2km8Suv1iEJCtBPfDgjv+umAyAcBIe7aADByBmfws/QIkHBnZGLBs2FyCKyknys
 Gtc+j9+p2a6y9rCrUFts1wK/l0PmmdJjS5v5wA2EQwS66QfFDOyrTjSXddAEmXiHYdcB
 AeG3gM/Zw1g5oLlyQyCa7GCwb20o7b95xy2/Spd817zI5klqXWnSZI3hO3OG78CFY969
 RoKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=iLoEKCBMnlFKYYYcN0OANFAEglV5FtD84V5LcwTvHwg=;
 b=lgTwCDXQZU8w7Bz/ZmtyZ9OdcRMnjW5+s5EDCH/jDl+5kiZ72PTOCyVWyLDGMNPAAM
 194SlVZkPsodwEuqn7GTerfr3RoiKRlOlasJNKH4l1DZXPswFWCIahcdJLCDzc1ak8TY
 UtbgFRTpZPMvHRUMfj+VwWEuINNnD6lZuje2EDKzbc5wcSN4BAygL5HTyVbBtZ8/qtRu
 1xkGsgwrGA1eBuhHSvsEA+/o36eI/enbAePGw1rDykpEQZd+c1fLq7PRHutnyDhTndLk
 sle44Q/vYtokdpDU1YwCiDFEL+JTUmdpK6RtEp8SlqxoMcjPWD7Nwgr+YMWilLCv5lY/
 F0ag==
X-Gm-Message-State: AJIora/HgZXEgsoCWQCXDfAjpSLx9J8JHYuKriFegvsKymsahhxpgljH
 9NfZJLDQsQ/kFOV+jx7ObRcoxfBweassEyzgDg==
X-Google-Smtp-Source: AGRyM1vQM1i7bebcbDD5BeZRxIvCI5qJDGD+svsXThCao0+6CLL/xgSSD/QNovAdrA91Ct+RzSbDrGrdlDrjB3F5wA==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:5a87:b61e:76b5:d1e0])
 (user=kaleshsingh job=sendgmr) by 2002:a81:57c3:0:b0:31d:e2dd:116 with SMTP
 id l186-20020a8157c3000000b0031de2dd0116mr34878043ywb.5.1658383068317; Wed,
 20 Jul 2022 22:57:48 -0700 (PDT)
Date: Wed, 20 Jul 2022 22:57:17 -0700
In-Reply-To: <20220721055728.718573-1-kaleshsingh@google.com>
Message-Id: <20220721055728.718573-7-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20220721055728.718573-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
Subject: [PATCH v5 06/17] arm64: stacktrace: Add description of
 stacktrace/common.h
From: Kalesh Singh <kaleshsingh@google.com>
To: maz@kernel.org, mark.rutland@arm.com, broonie@kernel.org, 
 madvenka@linux.microsoft.com, tabba@google.com
Cc: wangkefeng.wang@huawei.com, catalin.marinas@arm.com, elver@google.com,
 vincenzo.frascino@arm.com, will@kernel.org, kvmarm@lists.cs.columbia.edu,
 android-mm@google.com, kernel-team@android.com, drjones@redhat.com,
 ast@kernel.org, linux-arm-kernel@lists.infradead.org, andreyknvl@gmail.com,
 linux-kernel@vger.kernel.org, mhiramat@kernel.org
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

Add brief description on how to use stacktrace/common.h to implement
a stack unwinder.

Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
---

Changes in v5:
  - Add short description of each required function, per Fuad and Marc
  - Add Reviewed-by tag from Fuad

 arch/arm64/include/asm/stacktrace/common.h | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/arm64/include/asm/stacktrace/common.h b/arch/arm64/include/asm/stacktrace/common.h
index 7807752aaab1..be7920ba70b0 100644
--- a/arch/arm64/include/asm/stacktrace/common.h
+++ b/arch/arm64/include/asm/stacktrace/common.h
@@ -2,6 +2,21 @@
 /*
  * Common arm64 stack unwinder code.
  *
+ * To implement a new arm64 stack unwinder:
+ *     1) Include this header
+ *
+ *     2) Provide implementations for the following functions:
+ *          on_overflow_stack():   Returns true if SP is on the overflow
+ *                                 stack.
+ *          on_accessible_stack(): Returns true is SP is on any accessible
+ *                                 stack.
+ *          unwind_next():         Performs validation checks on the frame
+ *                                 pointer, and transitions unwind_state
+ *                                 to the next frame.
+ *
+ *         See: arch/arm64/include/asm/stacktrace.h for reference
+ *              implementations.
+ *
  * Copyright (C) 2012 ARM Ltd.
  */
 #ifndef __ASM_STACKTRACE_COMMON_H
-- 
2.37.0.170.g444d1eabd0-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
