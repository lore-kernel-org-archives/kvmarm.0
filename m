Return-Path: <SRS0=nOLV=77=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BADD9C433E0
	for <kvmarm@archiver.kernel.org>; Thu, 18 Jun 2020 12:25:58 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7134C2080D
	for <kvmarm@archiver.kernel.org>; Thu, 18 Jun 2020 12:25:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="N30CS11r"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7134C2080D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 207294B186;
	Thu, 18 Jun 2020 08:25:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2O18CJSDn+iU; Thu, 18 Jun 2020 08:25:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 266694B1A0;
	Thu, 18 Jun 2020 08:25:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EDAF74B12D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Jun 2020 08:25:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QTAVs8pJvPtI for <kvmarm@lists.cs.columbia.edu>;
 Thu, 18 Jun 2020 08:25:53 -0400 (EDT)
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com
 [209.85.221.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A3AED4B0BF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Jun 2020 08:25:53 -0400 (EDT)
Received: by mail-wr1-f44.google.com with SMTP id x6so5823351wrm.13
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Jun 2020 05:25:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=EI3NYrtwn6qJxPWPwh60aHXJB+vFaqkjVnXPNPOUvlM=;
 b=N30CS11r8sn0rGiPBf7Y+li2ePVY+jY9p3+fPyUt6oXi+Hb8X9cFUGgXLuswEudrWb
 R6lpv7ssWn6pFLjvITdLvoqc8nOphTTAvpILm710A8CgQ6SfXSwMc0ch4EVXyguq4LUj
 e1V29s0KvlvbpnQt+mdxjze4D4q9izalNSzHHXOoel0ZK0U/wkcHr3zLXg3k1JT0WNMf
 ebCEtjNPbgocdWIiK3vxM93imD08qIV19XzPFFVGBrRIUx3JGvYWOLYUNrlW4Pa8qDGT
 /PeUsKnG272Pgn2Ehdx9Qpj8vfpth/Hd2z5bPv219EmkHrvL6DPUSlEQnRrknv78BM1/
 ghwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=EI3NYrtwn6qJxPWPwh60aHXJB+vFaqkjVnXPNPOUvlM=;
 b=BgmaLWm0Kpg2NKVhXpgMIXqjmA5IUP+4mb0G/BO37CSC3XDADrKExBo9Qoz0Z8HJem
 JCIWwNErhNrdcFMiqi2Qys4MhUcaGo3L9D7ZJafUWKplvatUMdwHPm1gUKhj43FFn881
 PCjlyXT50i2PpJ/9255Sj/CZq30gSwOp2SyPOfyZqBnenls5z3ycNzgubXIkemDlOJ0r
 epUGefQ2x/O7n0UHyjOAd/IjZ8TOaO71IZjqEsmXAKYq3AHrHOZCCPYaVMncBf68eSGw
 wlxeUQ1G/VcFmJRvn3jYFNH7t7KLReToE72OGjSS00gTpDQUN1ssGi8h1qb/nkuHp/b2
 deJA==
X-Gm-Message-State: AOAM531u2mkt84GtTC+XNj1tU8Lxf3AICQCVO0hiReBb3vEBncvgCBs7
 mPxqCDK8/7c5qsjbYkkwWoP3LA==
X-Google-Smtp-Source: ABdhPJwa2EW6p36Iawe8UNLmui6v2zHWYcLTdQb2AQWxuuBBIWLUvLId9MfLH1gRIgvgURkn+W35jg==
X-Received: by 2002:adf:f08b:: with SMTP id n11mr4229961wro.312.1592483152531; 
 Thu, 18 Jun 2020 05:25:52 -0700 (PDT)
Received: from localhost ([2a01:4b00:8523:2d03:c1af:c724:158a:e200])
 by smtp.gmail.com with ESMTPSA id n1sm3343936wrp.10.2020.06.18.05.25.51
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 18 Jun 2020 05:25:51 -0700 (PDT)
From: David Brazdil <dbrazdil@google.com>
To: Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 James Morse <james.morse@arm.com>,
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v3 02/15] arm64: kvm: Move __smccc_workaround_1_smc to .rodata
Date: Thu, 18 Jun 2020 13:25:24 +0100
Message-Id: <20200618122537.9625-3-dbrazdil@google.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200618122537.9625-1-dbrazdil@google.com>
References: <20200618122537.9625-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: android-kvm@google.com, linux-kernel@vger.kernel.org,
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

This snippet of assembly is used by cpu_errata.c to overwrite parts of KVM hyp
vector. Move it to its own source file and change its ELF section to .rodata.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/kvm/hyp/Makefile    |  1 +
 arch/arm64/kvm/hyp/hyp-entry.S | 16 ----------------
 arch/arm64/kvm/hyp/smccc_wa.S  | 30 ++++++++++++++++++++++++++++++
 3 files changed, 31 insertions(+), 16 deletions(-)
 create mode 100644 arch/arm64/kvm/hyp/smccc_wa.S

diff --git a/arch/arm64/kvm/hyp/Makefile b/arch/arm64/kvm/hyp/Makefile
index 8c9880783839..5d8357ddc234 100644
--- a/arch/arm64/kvm/hyp/Makefile
+++ b/arch/arm64/kvm/hyp/Makefile
@@ -7,6 +7,7 @@ ccflags-y += -fno-stack-protector -DDISABLE_BRANCH_PROFILING \
 		$(DISABLE_STACKLEAK_PLUGIN)
 
 obj-$(CONFIG_KVM) += hyp.o
+obj-$(CONFIG_KVM_INDIRECT_VECTORS) += smccc_wa.o
 
 hyp-y := vgic-v3-sr.o timer-sr.o aarch32.o vgic-v2-cpuif-proxy.o sysreg-sr.o \
 	 debug-sr.o entry.o switch.o fpsimd.o tlb.o hyp-entry.o
diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
index 9c5cfb04170e..d362fad97cc8 100644
--- a/arch/arm64/kvm/hyp/hyp-entry.S
+++ b/arch/arm64/kvm/hyp/hyp-entry.S
@@ -318,20 +318,4 @@ SYM_CODE_START(__bp_harden_hyp_vecs)
 1:	.org __bp_harden_hyp_vecs + __BP_HARDEN_HYP_VECS_SZ
 	.org 1b
 SYM_CODE_END(__bp_harden_hyp_vecs)
-
-	.popsection
-
-SYM_CODE_START(__smccc_workaround_1_smc)
-	esb
-	sub	sp, sp, #(8 * 4)
-	stp	x2, x3, [sp, #(8 * 0)]
-	stp	x0, x1, [sp, #(8 * 2)]
-	mov	w0, #ARM_SMCCC_ARCH_WORKAROUND_1
-	smc	#0
-	ldp	x2, x3, [sp, #(8 * 0)]
-	ldp	x0, x1, [sp, #(8 * 2)]
-	add	sp, sp, #(8 * 4)
-1:	.org __smccc_workaround_1_smc + __SMCCC_WORKAROUND_1_SMC_SZ
-	.org 1b
-SYM_CODE_END(__smccc_workaround_1_smc)
 #endif
diff --git a/arch/arm64/kvm/hyp/smccc_wa.S b/arch/arm64/kvm/hyp/smccc_wa.S
new file mode 100644
index 000000000000..aa25b5428e77
--- /dev/null
+++ b/arch/arm64/kvm/hyp/smccc_wa.S
@@ -0,0 +1,30 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2015-2018 - ARM Ltd
+ * Author: Marc Zyngier <marc.zyngier@arm.com>
+ */
+
+#include <linux/arm-smccc.h>
+
+#include <asm/kvm_asm.h>
+#include <asm/kvm_mmu.h>
+
+	/*
+	 * This is not executed directly and is instead copied into the vectors
+	 * by install_bp_hardening_cb().
+	 */
+	.data
+	.pushsection	.rodata
+	.global		__smccc_workaround_1_smc
+__smccc_workaround_1_smc:
+	esb
+	sub	sp, sp, #(8 * 4)
+	stp	x2, x3, [sp, #(8 * 0)]
+	stp	x0, x1, [sp, #(8 * 2)]
+	mov	w0, #ARM_SMCCC_ARCH_WORKAROUND_1
+	smc	#0
+	ldp	x2, x3, [sp, #(8 * 0)]
+	ldp	x0, x1, [sp, #(8 * 2)]
+	add	sp, sp, #(8 * 4)
+1:	.org __smccc_workaround_1_smc + __SMCCC_WORKAROUND_1_SMC_SZ
+	.org 1b
-- 
2.27.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
