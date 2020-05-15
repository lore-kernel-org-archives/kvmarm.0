Return-Path: <SRS0=nzcv=65=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EECE7C433DF
	for <kvmarm@archiver.kernel.org>; Fri, 15 May 2020 10:59:11 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9EEA6207C3
	for <kvmarm@archiver.kernel.org>; Fri, 15 May 2020 10:59:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="u2DytUW7"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9EEA6207C3
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 428C24B4DF;
	Fri, 15 May 2020 06:59:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id uE+88auxVWw1; Fri, 15 May 2020 06:59:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9554F4B4E9;
	Fri, 15 May 2020 06:59:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3991C4B46C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 May 2020 06:59:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id psNxT9UH8Gon for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 May 2020 06:58:59 -0400 (EDT)
Received: from mail-wr1-f67.google.com (mail-wr1-f67.google.com
 [209.85.221.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CFAA54B4C8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 May 2020 06:58:58 -0400 (EDT)
Received: by mail-wr1-f67.google.com with SMTP id y3so3063741wrt.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 May 2020 03:58:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=Ai6Fwl8UyJm6B87jvYHBuJcbjLJDaWpZZPVaPcXdfLA=;
 b=u2DytUW7gTaWjKgKY0D29Drbg//IklH60EMwY3UFqgWODthsP3akJrIYzhlnI5FJKv
 RNUVgMc+XbbpJVoDkByhNUhNdw9T7bxR6ZjOn0hrivmRGUWB8qbGL1mfRJ18I/0tACbJ
 xeAuqFwIfPJp8vLLJXuTVyl27cwnBPE91ENGsEqjeMFv1vVmgE5F2C8Wh9+EkaIbSqar
 cYFpZWx5UpuZwEqqAV5GKNOYKQdjT52uS1qNza/RpJ+CZUQEyO6g/W+JJVKg6K4E0vIu
 Ql55gaM8m+fAEIqi1nqzANNnf0liHhnaKFjWRwDrVGkGM6t52MBlqnsp4q+zlQsDI4kQ
 8Tqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=Ai6Fwl8UyJm6B87jvYHBuJcbjLJDaWpZZPVaPcXdfLA=;
 b=Z1ZDXKkA3GgdbD2EVFxPM2jMnCkM7ciqtc0ROku3C9kOGASCWSoVowBQQWZFxcgCNq
 6finz6wuShoCjTlE57i5qmF0T/Ehaazq2JbNKge9HKJRN7HNmGtEh8jRZ2xSOdzps5d2
 vIR7pdrVjg27SJZai+wsVRXD+/Mn103e+Qg0do44f8Of3coOLYTcxuz1dpr2dnTBgQRw
 pSzVoc1c6i0d6xYsBRtRUCGhDKGdpVxuWgtE8u8+xCz2+9yxQayXdmz8Dpp+aCDsEX/k
 hM4E73fj5lriRwL5bCKZKZ0htz0w2CQ87UTPYSGkloUJXFL5MXLcasCbz4oZ4jCpaC+B
 xCRw==
X-Gm-Message-State: AOAM531KfxnIXaQ9wF1LxRZ+Es+330kFLctDOi8T8LahT4nI049L8+uE
 B6rVxUuI4f3Wy6Qfv5DEeoULLA==
X-Google-Smtp-Source: ABdhPJxJSLJpRVMm0dV2T5Dk4zybjMjD8L0/aFOEv7m2OekpRetlA0SYTkbeLI0O0Ger9pleD5J2kA==
X-Received: by 2002:adf:f84c:: with SMTP id d12mr3627382wrq.248.1589540337673; 
 Fri, 15 May 2020 03:58:57 -0700 (PDT)
Received: from localhost ([2a01:4b00:8523:2d03:d11b:f847:8002:7411])
 by smtp.gmail.com with ESMTPSA id t7sm3106188wrq.39.2020.05.15.03.58.56
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 15 May 2020 03:58:56 -0700 (PDT)
From: David Brazdil <dbrazdil@google.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
 James Morse <james.morse@arm.com>,
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Marc Zyngier <maz@kernel.org>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 Will Deacon <will@kernel.org>
Subject: [PATCH v2 02/14] arm64: kvm: Move __smccc_workaround_1_smc to .rodata
Date: Fri, 15 May 2020 11:58:29 +0100
Message-Id: <20200515105841.73532-3-dbrazdil@google.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200515105841.73532-1-dbrazdil@google.com>
References: <20200515105841.73532-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
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
index c2a13ab3c471..65ff99a7e02d 100644
--- a/arch/arm64/kvm/hyp/hyp-entry.S
+++ b/arch/arm64/kvm/hyp/hyp-entry.S
@@ -319,20 +319,4 @@ SYM_CODE_START(__bp_harden_hyp_vecs)
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
2.26.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
