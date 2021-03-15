Return-Path: <SRS0=nsVm=IN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1782C433E6
	for <kvmarm@archiver.kernel.org>; Mon, 15 Mar 2021 14:36:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4B6CE64FB2
	for <kvmarm@archiver.kernel.org>; Mon, 15 Mar 2021 14:36:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4B6CE64FB2
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F0D5C4B645;
	Mon, 15 Mar 2021 10:36:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6lhBb3rdLoqH; Mon, 15 Mar 2021 10:36:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4309F4B638;
	Mon, 15 Mar 2021 10:36:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6138F4B4FC
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 10:36:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id O4asscjibhjE for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Mar 2021 10:36:10 -0400 (EDT)
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com
 [209.85.128.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 56E6A4B5FB
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 10:36:10 -0400 (EDT)
Received: by mail-wm1-f73.google.com with SMTP id a68so2306294wme.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 07:36:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=82gUjSiOy75013Ao/6wOddaZLFu0pa6owwuj1ggeuy4=;
 b=CD9bFfHL7VhMeePH17RF85emad8M7ZhRkOPIKahkEZ7HAAfIyxJpxFRokWpU32rFK1
 CzmaNCf+CCicqi+lk0p6Kvc37kc5L8PrGXpJcG/3oWqxwsDB5902k+kIYrZlNy95lekM
 IzF3use+ujY9UWJXdWi56mWRemJDlG7Xu98WTdWA1GndJDFoMBWOXaNzo8YUBErWGIwp
 CoqIM3BZqmueTp6q1/MpOuU+qpqIOJpDiIHw0PyfeAoZ0zn5Rg0Q9nChCJG0uflFusau
 3eMHJJHLViXpQmyPsZ8hZuLTpesIibwx+AcCBPlYjSON+7OmBlaQApjjCUAD5AfBNss+
 OlNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=82gUjSiOy75013Ao/6wOddaZLFu0pa6owwuj1ggeuy4=;
 b=C7K5Bqea8H7xuQrly1C9j41V0h62Qh+5wWaMbr44Uc5fllu29oQyP7ywhauxhxTsuE
 uf9xi1LPaw57BEHBqsKcFgQhewtKD9dBoYuHvCbFAr8mmcyg37EzeWcgD41Jo+LdCg1e
 SL3L08Kdtne+HRYO+OZToFN4zEGxw9BduYFIPhTZyyAlZjKabaPAJXdqJZT4IO29gM1Z
 DgEcU+jKwnPox37Hwq9kCr8KXhynshQkIu80uU8L7T0EcQaGNvfMj1QMl06ZsDy3DQKm
 FNXZpdAo4ntn8kyMl2MbSaaUCfgnnPH8dGxk0g0b3fCVPVENxjtBKfiagh7rLrHMM/Sn
 J53A==
X-Gm-Message-State: AOAM532igDF8ESsIW5MWovElXJ5G28KlMBu+7fyVWPx+YESaKyfjyZuv
 YXGnrMoHPY0MZNQPhM27xMC2wv6V4oES
X-Google-Smtp-Source: ABdhPJx9xRKDOfRDFlI/TfqGPcgwP0Fg2uHLCHIdGqPsMxwfgsZghPG6ZkVnzBXOgz/h4g5be4yqugrc6gdm
X-Received: from r2d2-qp.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a7b:c188:: with SMTP id
 y8mr33590wmi.76.1615818969596; Mon, 15 Mar 2021 07:36:09 -0700 (PDT)
Date: Mon, 15 Mar 2021 14:35:14 +0000
In-Reply-To: <20210315143536.214621-1-qperret@google.com>
Message-Id: <20210315143536.214621-15-qperret@google.com>
Mime-Version: 1.0
References: <20210315143536.214621-1-qperret@google.com>
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
Subject: [PATCH v5 14/36] KVM: arm64: Provide __flush_dcache_area at EL2
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
 arch/arm64/kvm/sys_regs.c               |  1 +
 4 files changed, 18 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm64/kvm/hyp/nvhe/cache.S

diff --git a/arch/arm64/include/asm/kvm_cpufeature.h b/arch/arm64/include/asm/kvm_cpufeature.h
index 3fd9f60d2180..efba1b89b8a4 100644
--- a/arch/arm64/include/asm/kvm_cpufeature.h
+++ b/arch/arm64/include/asm/kvm_cpufeature.h
@@ -13,3 +13,5 @@
 #define KVM_HYP_CPU_FTR_REG(name) extern struct arm64_ftr_reg kvm_nvhe_sym(name)
 #endif
 #endif
+
+KVM_HYP_CPU_FTR_REG(arm64_ftr_reg_ctrel0);
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
