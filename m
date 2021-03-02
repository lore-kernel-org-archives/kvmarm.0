Return-Path: <SRS0=a/wb=IA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7279C433E6
	for <kvmarm@archiver.kernel.org>; Tue,  2 Mar 2021 15:00:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5BB6764F37
	for <kvmarm@archiver.kernel.org>; Tue,  2 Mar 2021 15:00:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5BB6764F37
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0EB214B678;
	Tue,  2 Mar 2021 10:00:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id B6S4pE7+MPLm; Tue,  2 Mar 2021 10:00:35 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 174684B670;
	Tue,  2 Mar 2021 10:00:35 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 399FC4B60F
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Mar 2021 10:00:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7LUCk7Hyc7K0 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  2 Mar 2021 10:00:32 -0500 (EST)
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com
 [209.85.128.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 27BF44B60A
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Mar 2021 10:00:32 -0500 (EST)
Received: by mail-wm1-f73.google.com with SMTP id q24so1320223wmc.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 02 Mar 2021 07:00:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=twje/T88dKdujyu/Ipi7uGGbAfwKvVyGbqSSEkcY7iA=;
 b=h3Auuv0gx9w0uL2JejVSJYcj+FN0Xhi6lI9t1VRPl88R9mO9oGEu3dwGf1lxzcNigU
 pb7GHhkBl5+LSyCDcns3NnUnbBEzGjihkEgB3NuB1WUfpkovjjgoD1wLlCyaw7a2FAzM
 29nnxhE3yIYM9mfy3/brP5+xqxG78O0uvZzH9spB/5Xaqhy0K9l6oIN3dAkt8HS9unYe
 cJSuE1ohG6VZw+l7HWUPmoEy3/b1EPuCPG4Lon8j/wC/fVSMwrEdkqkEVg5Mcc/wWAU0
 Q9ZGG7OBUqJ+sWmtLWqyWoMOkrOIwWF+xvd311ON5vNOd3iU6HnxXKcyf3xcKnxcGhGr
 s9ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=twje/T88dKdujyu/Ipi7uGGbAfwKvVyGbqSSEkcY7iA=;
 b=jLkF6sT9XkcEUsMHm9NOwHpFtFIEv20LjfLNs2Te1tCxMCrjMtXe84USewTezykrH+
 RPAdMFMpjYzStEMQ1iR0XsDMDzCs647tQyyhCiT2Et0DbpYUMFLSV5k+OBPPQHHVDwcI
 PgVzZWsNxs5wyVIkhPtzDleomE9L/zzTYFSZWjHtQ8/MLFuaaYDCfRkwCGSMHORBLINO
 bXidceRTE8D0ZO15VIlQAn4T1lA0Yzf/tyMsDJraR/UYaU4rQyaPGk4PG3pWqtAiVsaA
 HYpglNCJtg8b2z0T1EDstnNIfd5Z8cQ0QhyXBotc7+QDw/AKfs5sxxzFrR2z2O1yvNQA
 h0CA==
X-Gm-Message-State: AOAM532OGPGDCMkyrkgFjHOFzBAMa1cjXxZ1z3v8gMv4D5h7/1seoJeA
 s06ccJ39tSOiY2jGjBKy0WUm79TU4q2d
X-Google-Smtp-Source: ABdhPJwQwv/y/Y1CqtU5mX7QFPielulT4k9vdUFWl45cr8FFafLXMgEO9ymMubzKsO1L14g5Q1NqlrmfyD6Z
X-Received: from r2d2-qp.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a1c:de05:: with SMTP id
 v5mr744456wmg.25.1614697231398; Tue, 02 Mar 2021 07:00:31 -0800 (PST)
Date: Tue,  2 Mar 2021 14:59:41 +0000
In-Reply-To: <20210302150002.3685113-1-qperret@google.com>
Message-Id: <20210302150002.3685113-12-qperret@google.com>
Mime-Version: 1.0
References: <20210302150002.3685113-1-qperret@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH v3 11/32] KVM: arm64: Stub CONFIG_DEBUG_LIST at Hyp
From: Quentin Perret <qperret@google.com>
To: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
Cc: android-kvm@google.com, seanjc@google.com, mate.toth-pal@arm.com,
 linux-kernel@vger.kernel.org, robh+dt@kernel.org,
 linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu, tabba@google.com
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

In order to use the kernel list library at EL2, introduce stubs for the
CONFIG_DEBUG_LIST out-of-lines calls.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/nvhe/Makefile |  2 +-
 arch/arm64/kvm/hyp/nvhe/stub.c   | 22 ++++++++++++++++++++++
 2 files changed, 23 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm64/kvm/hyp/nvhe/stub.c

diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index 24ff99e2eac5..144da72ad510 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -13,7 +13,7 @@ lib-objs := clear_page.o copy_page.o memcpy.o memset.o
 lib-objs := $(addprefix ../../../lib/, $(lib-objs))
 
 obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o host.o \
-	 hyp-main.o hyp-smp.o psci-relay.o early_alloc.o
+	 hyp-main.o hyp-smp.o psci-relay.o early_alloc.o stub.o
 obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
 	 ../fpsimd.o ../hyp-entry.o ../exception.o
 obj-y += $(lib-objs)
diff --git a/arch/arm64/kvm/hyp/nvhe/stub.c b/arch/arm64/kvm/hyp/nvhe/stub.c
new file mode 100644
index 000000000000..c0aa6bbfd79d
--- /dev/null
+++ b/arch/arm64/kvm/hyp/nvhe/stub.c
@@ -0,0 +1,22 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Stubs for out-of-line function calls caused by re-using kernel
+ * infrastructure at EL2.
+ *
+ * Copyright (C) 2020 - Google LLC
+ */
+
+#include <linux/list.h>
+
+#ifdef CONFIG_DEBUG_LIST
+bool __list_add_valid(struct list_head *new, struct list_head *prev,
+		      struct list_head *next)
+{
+		return true;
+}
+
+bool __list_del_entry_valid(struct list_head *entry)
+{
+		return true;
+}
+#endif
-- 
2.30.1.766.gb4fecdf3b7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
