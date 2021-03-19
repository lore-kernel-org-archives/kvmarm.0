Return-Path: <SRS0=QSSN=IR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC7A1C433DB
	for <kvmarm@archiver.kernel.org>; Fri, 19 Mar 2021 10:02:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 99C7964F45
	for <kvmarm@archiver.kernel.org>; Fri, 19 Mar 2021 10:02:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 99C7964F45
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4AD424B6D7;
	Fri, 19 Mar 2021 06:02:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jbNdpAM8JXTn; Fri, 19 Mar 2021 06:02:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7EFE34B611;
	Fri, 19 Mar 2021 06:02:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 621AE4B6AA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Mar 2021 06:02:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GkiR-hF5++-K for <kvmarm@lists.cs.columbia.edu>;
 Fri, 19 Mar 2021 06:02:21 -0400 (EDT)
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com
 [209.85.221.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C673F4B6A9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Mar 2021 06:02:20 -0400 (EDT)
Received: by mail-wr1-f73.google.com with SMTP id b6so6224753wrq.22
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Mar 2021 03:02:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=K4McwqDhxnQfwM3x1riKe9KKt/V2sRmghUw1PVC3tdA=;
 b=OWizihQTxeoK0OkGiJM+DF3rJK1yEnncsb2/J6XoEmbk1W17MDNc6FchxdrVYqtXme
 8/5EQWkGBf685M2ymHAe+kfQu7tM/lrRmWdEN1LeEqKLgxQ7eHGXcKCQ8y6TOE4Uv8NL
 gYhqRGIsHKZdr/3ZhsMUGD/PXClAtSb3KPHMib3NQWgkGh2o3icFSi+rknIptMozyDaB
 r5L5Q+J3gV2g8qqwiCz9538VNBShhhfPG4S98zIzt9n0856wCxdMtl5ax/UTsYeViZ45
 Gpdsba74IfeBCn/co6goQDOvZwLUA8mfgwFmCh50b49voBR9jPtVSBZrIrUWVFZ+WE4H
 Jgbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=K4McwqDhxnQfwM3x1riKe9KKt/V2sRmghUw1PVC3tdA=;
 b=UpTkO/y5T6MV1ErojJTwC2cp9OkaAdqv1ggAGmAJy3ySP8MhSgipb5UPiA/qXcybsC
 0bELlcreqecBjfDouFfV/JlCu+fsiXKXdwLJ/Td4v7RB39wnUHW2gvUfhVlGvtTDt62r
 curg+iA/weJdf1yKtcXCVeyWlE2Wj9m1R5mcPFff5th0pNWesnRygY6fZIVarW0YVDKp
 sLs7UdVxYZpTHXPDTBKXTIgVagsAZqXj1w4t1Y1DMez/y6lKVUnp7OV0wBYBzMPnTOQo
 cdLsig+MV07C5FT+e5KLl/WFxGj7GuQAlbdygDp39JDvNMBnprpWs8ebWXl0qSmOh9gG
 vlvg==
X-Gm-Message-State: AOAM533Bo4ZAdNSd/TWl4U8yivnta5p90EutLv2St27fRC4mS/KeZDUm
 H53M/0W8YYUZ42C1+nC9dVn4HZBulU2g
X-Google-Smtp-Source: ABdhPJy2pjU9chhbWoXKyCKmpezg7yxDnPrC3R6tHeGO7BRlQSoiYjTFgF9dFhbNIN3Oj8+UjcRdEPChZLUy
X-Received: from r2d2-qp.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a1c:6243:: with SMTP id
 w64mr1313174wmb.0.1616148139504; Fri, 19 Mar 2021 03:02:19 -0700 (PDT)
Date: Fri, 19 Mar 2021 10:01:22 +0000
In-Reply-To: <20210319100146.1149909-1-qperret@google.com>
Message-Id: <20210319100146.1149909-15-qperret@google.com>
Mime-Version: 1.0
References: <20210319100146.1149909-1-qperret@google.com>
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
Subject: [PATCH v6 14/38] KVM: arm64: Provide __flush_dcache_area at EL2
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

We will need to do cache maintenance at EL2 soon, so compile a copy of
__flush_dcache_area at EL2, and provide a copy of arm64_ftr_reg_ctrel0
as it is needed by the read_ctr macro.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/include/asm/kvm_cpufeature.h |  2 ++
 arch/arm64/kvm/hyp/nvhe/Makefile        |  3 ++-
 arch/arm64/kvm/hyp/nvhe/cache.S         | 13 +++++++++++++
 arch/arm64/kvm/hyp/nvhe/hyp-smp.c       |  6 ++++++
 arch/arm64/kvm/sys_regs.c               |  1 +
 5 files changed, 24 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm64/kvm/hyp/nvhe/cache.S

diff --git a/arch/arm64/include/asm/kvm_cpufeature.h b/arch/arm64/include/asm/kvm_cpufeature.h
index 3d245f96a9fe..c2e7735f502b 100644
--- a/arch/arm64/include/asm/kvm_cpufeature.h
+++ b/arch/arm64/include/asm/kvm_cpufeature.h
@@ -19,4 +19,6 @@
 #define DEFINE_KVM_HYP_CPU_FTR_REG(name) BUILD_BUG()
 #endif
 
+DECLARE_KVM_HYP_CPU_FTR_REG(arm64_ftr_reg_ctrel0);
+
 #endif
diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index 6894a917f290..42dde4bb80b1 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -13,7 +13,8 @@ lib-objs := clear_page.o copy_page.o memcpy.o memset.o
 lib-objs := $(addprefix ../../../lib/, $(lib-objs))
 
 obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o host.o \
-	 hyp-main.o hyp-smp.o psci-relay.o early_alloc.o stub.o page_alloc.o
+	 hyp-main.o hyp-smp.o psci-relay.o early_alloc.o stub.o page_alloc.o \
+	 cache.o
 obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
 	 ../fpsimd.o ../hyp-entry.o ../exception.o
 obj-y += $(lib-objs)
diff --git a/arch/arm64/kvm/hyp/nvhe/cache.S b/arch/arm64/kvm/hyp/nvhe/cache.S
new file mode 100644
index 000000000000..36cef6915428
--- /dev/null
+++ b/arch/arm64/kvm/hyp/nvhe/cache.S
@@ -0,0 +1,13 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Code copied from arch/arm64/mm/cache.S.
+ */
+
+#include <linux/linkage.h>
+#include <asm/assembler.h>
+#include <asm/alternative.h>
+
+SYM_FUNC_START_PI(__flush_dcache_area)
+	dcache_by_line_op civac, sy, x0, x1, x2, x3
+	ret
+SYM_FUNC_END_PI(__flush_dcache_area)
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-smp.c b/arch/arm64/kvm/hyp/nvhe/hyp-smp.c
index 879559057dee..71f00aca90e7 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-smp.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-smp.c
@@ -5,9 +5,15 @@
  */
 
 #include <asm/kvm_asm.h>
+#include <asm/kvm_cpufeature.h>
 #include <asm/kvm_hyp.h>
 #include <asm/kvm_mmu.h>
 
+/*
+ * Copies of the host's CPU features registers holding sanitized values.
+ */
+DEFINE_KVM_HYP_CPU_FTR_REG(arm64_ftr_reg_ctrel0);
+
 /*
  * nVHE copy of data structures tracking available CPU cores.
  * Only entries for CPUs that were online at KVM init are populated.
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 6c5d133689ae..3ec34c25e877 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2783,6 +2783,7 @@ struct __ftr_reg_copy_entry {
 	u32			sys_id;
 	struct arm64_ftr_reg	*dst;
 } hyp_ftr_regs[] __initdata = {
+	CPU_FTR_REG_HYP_COPY(SYS_CTR_EL0, arm64_ftr_reg_ctrel0),
 };
 
 void __init setup_kvm_el2_caps(void)
-- 
2.31.0.rc2.261.g7f71774620-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
