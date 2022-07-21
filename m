Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7B35CCA479
	for <kvmarm@archiver.kernel.org>; Thu, 21 Jul 2022 05:58:04 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7F1AF4DA58;
	Thu, 21 Jul 2022 01:58:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cgfcZQ5S1PhP; Thu, 21 Jul 2022 01:58:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 72C1F4DA5C;
	Thu, 21 Jul 2022 01:58:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 617AC4D971
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2022 01:58:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0x8GSK6ODvZj for <kvmarm@lists.cs.columbia.edu>;
 Thu, 21 Jul 2022 01:58:01 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 45E5D4DA5B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2022 01:58:01 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id
 m5-20020a2598c5000000b0066faab590c5so581389ybo.7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Jul 2022 22:58:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=nCSrSlEZfmkYkOyHMY9qhudKEgt1DEv4mdp7iaevl2w=;
 b=Y/BckGi3KCbT4iTn1vHoKO+iIoWVzxgW89Wp+bOCHdv6z7DbV4KkriSzgVPMZM6mWf
 t3Np8DXW4dxPpv1lZ5ZyzliMfc/WzlVRbViT1axXnESIU//dO2Ysbj6tQOaoZ9haMLzM
 9b/3MYA906Tt2nrxQ7kX5DGCsmAD8wAnpTJjIGSrmH1tdShxTdRcuYbTXYHCmYUuh7fz
 AWiZn7q8TwP9i1Aif5D8zObMsZHYtY96eTqOEQlPJ0Veyv6fV8OH2lqzlNq4raV87REf
 kf/8wbZvR0pUDOd2o2Tzm/0YdmklhPmQ7GhOaf+HJLSF1Xt6QydN+Dsd7+7qD1ZygSMt
 jTLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=nCSrSlEZfmkYkOyHMY9qhudKEgt1DEv4mdp7iaevl2w=;
 b=Zkiq9IPQaQhPcsWpfnr0qVmLW7Q6Lvzz3UXa6f4spV/r0rKyEIEWSQpJcAzj9mPDtr
 LY296OWYXYHMd/ELMjgNj2FIk3YTwE7wiK7VRE8Dbf8kG+jIBucikfd3HH3c722y+8q6
 PUpeHvKv+62VGbRreIIzCbvBb/+GIauFxIpSBcJCmBFNp+zhmv/nQnWynbuunS3nOm3C
 cIxmtWAKMLCTM+UGuLo1RkIgHEiWru0LK8IQqkFczrgvn0lqJuLPxCcuGzDB9l0YqArR
 f24mZzNSE43+DZOkswvyIR56c2a6CxHe08558w7dzF+jZLTfi/HfFs0qO0/bV8eftpu5
 m45A==
X-Gm-Message-State: AJIora+U4rFIdPREs/9NsyOLwcyMqwdUqlyCyG8lc+tFvjQQtTSdx9jl
 zTlmg2zogUJKCyZZ638V7J73kAq+TN9dmCIeSA==
X-Google-Smtp-Source: AGRyM1uVWbefCZQE+IW0YShATcxYbZ1HKKXbblRtksHLoReZ4Hx2UeN/4FbZ98rwLnifcfwg5BzwKCYVTc0NlvD1nQ==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:5a87:b61e:76b5:d1e0])
 (user=kaleshsingh job=sendgmr) by 2002:a0d:c587:0:b0:31e:8bab:394d with SMTP
 id h129-20020a0dc587000000b0031e8bab394dmr182248ywd.107.1658383080824; Wed,
 20 Jul 2022 22:58:00 -0700 (PDT)
Date: Wed, 20 Jul 2022 22:57:22 -0700
In-Reply-To: <20220721055728.718573-1-kaleshsingh@google.com>
Message-Id: <20220721055728.718573-12-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20220721055728.718573-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
Subject: [PATCH v5 11/17] KVM: arm64: Stub implementation of non-protected
 nVHE HYP stack unwinder
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

Add stub implementations of non-protected nVHE stack unwinder, for
building. These are implemented later in this series.

Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
---

Changes in v5:
  - Mark unwind_next() as inline, per Marc
  - Comment !__KVM_NVHE_HYPERVISOR__ unwinder path, per Marc

 arch/arm64/include/asm/stacktrace/nvhe.h | 26 ++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/arch/arm64/include/asm/stacktrace/nvhe.h b/arch/arm64/include/asm/stacktrace/nvhe.h
index 80d71932afff..3078501f8e22 100644
--- a/arch/arm64/include/asm/stacktrace/nvhe.h
+++ b/arch/arm64/include/asm/stacktrace/nvhe.h
@@ -8,6 +8,12 @@
  *      the HYP memory. The stack is unwinded in EL2 and dumped to a shared
  *      buffer where the host can read and print the stacktrace.
  *
+ *   2) Non-protected nVHE mode - the host can directly access the
+ *      HYP stack pages and unwind the HYP stack in EL1. This saves having
+ *      to allocate shared buffers for the host to read the unwinded
+ *      stacktrace.
+ *
+ *
  * Copyright (C) 2022 Google LLC
  */
 #ifndef __ASM_STACKTRACE_NVHE_H
@@ -55,5 +61,25 @@ static inline int notrace unwind_next(struct unwind_state *state)
 NOKPROBE_SYMBOL(unwind_next);
 #endif	/* CONFIG_PROTECTED_NVHE_STACKTRACE */
 
+#else	/* !__KVM_NVHE_HYPERVISOR__ */
+/*
+ * Conventional (non-protected) nVHE HYP stack unwinder
+ *
+ * In non-protected mode, the unwinding is done from kernel proper context
+ * (by the host in EL1).
+ */
+
+static inline bool on_overflow_stack(unsigned long sp, unsigned long size,
+				     struct stack_info *info)
+{
+	return false;
+}
+
+static inline int notrace unwind_next(struct unwind_state *state)
+{
+	return 0;
+}
+NOKPROBE_SYMBOL(unwind_next);
+
 #endif	/* __KVM_NVHE_HYPERVISOR__ */
 #endif	/* __ASM_STACKTRACE_NVHE_H */
-- 
2.37.0.170.g444d1eabd0-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
