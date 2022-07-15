Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A213CCA47C
	for <kvmarm@archiver.kernel.org>; Fri, 15 Jul 2022 06:11:44 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 145A64BC48;
	Fri, 15 Jul 2022 02:11:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vPoe61SFgpbn; Fri, 15 Jul 2022 02:11:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 278864BDFF;
	Fri, 15 Jul 2022 02:11:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 133454BC46
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jul 2022 02:11:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bBU9UbDpcnvd for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Jul 2022 02:11:32 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DEE224BDE2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jul 2022 02:11:32 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id
 w15-20020a25ac0f000000b0066e50e4a553so3284701ybi.16
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jul 2022 23:11:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=pdXpYKuqyR2DHzDWiSA/Dd/3H8f/+4y3eqxbGuoz/60=;
 b=gp6IjzjWFE3s0WtgA0THeafhzeLINBoTb4eGy+4W8aaFNoxZGpirTqTbF7xS7KhCzj
 OVC8u1Xggk4rJ2ga+Wxi7y0dgfaIeUU+LMQoFu/+H7H+mlWBFwOT27y1BRMRuvtMW5R4
 pVF8Cx6BwHK6zf2mOwZUcifIN8RN7l4IwyBz+61P/BGjzHPmAB9M3XiuGqYcRBXGdbXH
 BElQjhQyhxgPGo68MBibokAEwadcmfzTU1Lj/BdgsDBc+DztJoAWW58GWeJ20WqVMh8O
 rgX5cS9g2fnYvRIvmsWqNAPvhAYBDXXTguTNxYfjxXB/QkGPr3P6VD692wFY19Irjf4t
 4ImA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=pdXpYKuqyR2DHzDWiSA/Dd/3H8f/+4y3eqxbGuoz/60=;
 b=Hz8SX1CMCi2qc6Hb6thFKD8/R5GTYHNV1fYkRJDD69keAisOH49c6d3m4UiHjYKlV9
 lHApH3SWVXiAmF6Q75RX3yEdI4zKEGomKrLSukPpWOqHY/Vsx9c7EDG0dbdYqwr9ywCb
 /gElrsgH/Qq/XBi+CnZ8HiZ6BPFjcTN6wz2QGXqKfb+/0Ee7sYr0Yy0CvayDVlXcWEe4
 7tNkEplvVM/vqVO+UcLUsSUqpRKzGPpxnCqmzd6ogyCmIkb3EL8z06ml8OiDsiPywwLW
 LOifT7Q9r3D9q6wy1h4IuXom9e5Q3T5LW8wEGSt/u8mlbxT+dGb2KOZsdgzjZiZzc4lm
 wuoQ==
X-Gm-Message-State: AJIora8Uen+UGaJWq+63lvyou3R+LjdFmLyp3Ink2KcOW9vdXweeCXSk
 FS3M4AzQpcJS2rDBuMhfZ7MmaMBzOd1yHCq4OA==
X-Google-Smtp-Source: AGRyM1s2qvo/C+AGMgSJ1bzfSnL2AH2SuaK0GUmYhlafsScdZesEOiN19TLlmgYAcKErdGUxpKCqLcIEPcdbEiO29Q==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:f010:455b:62ce:19e])
 (user=kaleshsingh job=sendgmr) by 2002:a25:2303:0:b0:66f:d3d:45a with SMTP id
 j3-20020a252303000000b0066f0d3d045amr11516072ybj.606.1657865492453; Thu, 14
 Jul 2022 23:11:32 -0700 (PDT)
Date: Thu, 14 Jul 2022 23:10:20 -0700
In-Reply-To: <20220715061027.1612149-1-kaleshsingh@google.com>
Message-Id: <20220715061027.1612149-12-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20220715061027.1612149-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
Subject: [PATCH v4 11/18] KVM: arm64: Stub implementation of non-protected
 nVHE HYP stack unwinder
From: Kalesh Singh <kaleshsingh@google.com>
To: maz@kernel.org, mark.rutland@arm.com, broonie@kernel.org, 
 madvenka@linux.microsoft.com
Cc: wangkefeng.wang@huawei.com, elver@google.com, catalin.marinas@arm.com,
 ast@kernel.org, vincenzo.frascino@arm.com, will@kernel.org,
 kvmarm@lists.cs.columbia.edu, android-mm@google.com, andreyknvl@gmail.com,
 kernel-team@android.com, drjones@redhat.com,
 linux-arm-kernel@lists.infradead.org, russell.king@oracle.com,
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
 arch/arm64/include/asm/stacktrace/nvhe.h | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/arch/arm64/include/asm/stacktrace/nvhe.h b/arch/arm64/include/asm/stacktrace/nvhe.h
index 1eac4e57f2ae..36cf7858ddd8 100644
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
@@ -53,5 +59,21 @@ static int notrace unwind_next(struct unwind_state *state)
 NOKPROBE_SYMBOL(unwind_next);
 #endif	/* CONFIG_PROTECTED_NVHE_STACKTRACE */
 
+/*
+ * Non-protected nVHE HYP stack unwinder
+ */
+#else	/* !__KVM_NVHE_HYPERVISOR__ */
+static inline bool on_overflow_stack(unsigned long sp, unsigned long size,
+				     struct stack_info *info)
+{
+	return false;
+}
+
+static int notrace unwind_next(struct unwind_state *state)
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
