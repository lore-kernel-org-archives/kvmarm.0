Return-Path: <SRS0=nsVm=IN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CA59C433E0
	for <kvmarm@archiver.kernel.org>; Mon, 15 Mar 2021 14:36:09 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AAFCE64F4A
	for <kvmarm@archiver.kernel.org>; Mon, 15 Mar 2021 14:36:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AAFCE64F4A
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5EDD84B223;
	Mon, 15 Mar 2021 10:36:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id AWzhYYWxJLWe; Mon, 15 Mar 2021 10:36:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D9FB54B621;
	Mon, 15 Mar 2021 10:36:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3DEFD4B57B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 10:36:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XbaVAXEEYJHd for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Mar 2021 10:36:04 -0400 (EDT)
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com
 [209.85.221.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2010A4B5A0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 10:36:04 -0400 (EDT)
Received: by mail-wr1-f73.google.com with SMTP id z6so15155605wrh.11
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 07:36:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=42VsnebBx6wd/dLld12y5OO2eqBs86RA5vT5YbLHhII=;
 b=ZLkYfjm0TXm1ycQgXusiruwe/qzqQv7drq5zuviqWh0MJ49BBdJLzCMYL8k+RqizaO
 felSNSPfOwwR8i7fkvRvH4HC7raWlb92gVEnl++0y9cWRocbAQVOOOcRYjLLVi91qmVC
 JbDKCnnGwlgjwle1NZdASDpI7ow3L0jtIFQCToUWMGT0tWP48BRBGY9e5I9sYEFKWHIf
 fGYBQMoqCVkfNuqCp5fnUwLNrerEb8cQ1AqKhDY2eqO9ZxiIXd+AcZWjfNV/qNGi4Ph1
 Z+hk5NHSQ9BlZDSAVEnwoKHYl6s3wlBucYOKhkj4D01+DSXsJBjQvwqmh/6NCzhiUvRj
 nDXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=42VsnebBx6wd/dLld12y5OO2eqBs86RA5vT5YbLHhII=;
 b=coAk2I/RxOrcrf/DpaYjwr1MK6751O0ccBiyfqnXCD0u/m9vZPJMB90Xe4XZz4o87T
 83zXbBN8VBpA3pb/Qyy6mklZUJq3obnIHv3ni9lsGFmorM9vw2tkCdWkntgLqBII8Mo/
 0swvixbplWG/M2Dyu+HLbAKRpmsuuwqyd8uPa2HjRZEa/FANGmUulaCeNoKZXz5p8OvT
 EhMXrNYkQj88kJA9+JCN52dvZR9kPEA0YJ9kt1D2AZLfmKtYOEhFGkzT1rByXSc6phDI
 FnVYMkql1C/KimTAcvLyQ1K/5yrTMFFZo2KpnGoLCnfqjaCbzIAVWyz3QE1gE4Kfx866
 wcMA==
X-Gm-Message-State: AOAM531mUx8682gKjy0wqlTXr1+CjnI9xt/b+qDKc/vdk+x1JqvfznV3
 r9uHctaNcplP7d5LVhNrsQzDxpRu1Tab
X-Google-Smtp-Source: ABdhPJwxOO9bMvt/n8Ii/ALjBQmkLixKjjgqfBbs1ZB0IOc7PGzPOYN5ZKmmLjqMm5uOvJj8JP0r4i91tWDl
X-Received: from r2d2-qp.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a7b:c4c9:: with SMTP id
 g9mr31442wmk.82.1615818963391; Mon, 15 Mar 2021 07:36:03 -0700 (PDT)
Date: Mon, 15 Mar 2021 14:35:11 +0000
In-Reply-To: <20210315143536.214621-1-qperret@google.com>
Message-Id: <20210315143536.214621-12-qperret@google.com>
Mime-Version: 1.0
References: <20210315143536.214621-1-qperret@google.com>
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
Subject: [PATCH v5 11/36] KVM: arm64: Stub CONFIG_DEBUG_LIST at Hyp
From: Quentin Perret <qperret@google.com>
To: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
Cc: android-kvm@google.com, seanjc@google.com, mate.toth-pal@arm.com,
 linux-kernel@vger.kernel.org, robh+dt@kernel.org, tabba@google.com,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
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

In order to use the kernel list library at EL2, introduce stubs for the
CONFIG_DEBUG_LIST out-of-lines calls.

Acked-by: Will Deacon <will@kernel.org>
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
2.31.0.rc2.261.g7f71774620-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
