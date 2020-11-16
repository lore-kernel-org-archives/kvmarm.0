Return-Path: <SRS0=JeL3=EW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BCEAC4742C
	for <kvmarm@archiver.kernel.org>; Mon, 16 Nov 2020 20:43:37 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DDC1822245
	for <kvmarm@archiver.kernel.org>; Mon, 16 Nov 2020 20:43:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="ckOgL/Xc"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DDC1822245
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 863144C226;
	Mon, 16 Nov 2020 15:43:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XN8H3gZam81B; Mon, 16 Nov 2020 15:43:35 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6CD354C24A;
	Mon, 16 Nov 2020 15:43:35 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D31DD4C226
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Nov 2020 15:43:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kV2Mu2ds-fa2 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 Nov 2020 15:43:32 -0500 (EST)
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com
 [209.85.128.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AD8AE4C219
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Nov 2020 15:43:32 -0500 (EST)
Received: by mail-wm1-f54.google.com with SMTP id a3so564130wmb.5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Nov 2020 12:43:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=QlMR2fhUIhxw06ik3ZhMESov9sgfWs+L8rQ6iDwTxeg=;
 b=ckOgL/XcXmzoFPa38YuXoHMeAR9K/h3Lwh32nXroabX2ewUvFUSApQ2xYngzuy+ZSc
 slJjEPf2zDCXUMtZW3STAbZo2SErjL+5tAPI4vKU6teBsW59cgFybiHzxWKeTvqal/UX
 a+wG//8o7z9gjaxhLFN1eDQKj8PID5qY00QlPT+0WwyEWdquQBrXaIRrSNOJHplY6t+1
 SirNyvrEG2cn75Ab/LgNhvsJQxjMDhW3I3OG7S5QA/4dhI0rhTBXZJ2BLARf0VtRNi6b
 H2AdD1gW2lWmZTsH4MVkhMyJVkkcQF2NQNXRh/yKrOQFyovCBRqki3JWm8utq/lUuOOg
 tMCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=QlMR2fhUIhxw06ik3ZhMESov9sgfWs+L8rQ6iDwTxeg=;
 b=gXZB8FgaolBgbnubi4+WylIZGZIzkb3iMX00+9/gJHRfkm0sRhb75L9w65jDzJdwb0
 QpYgB9row+Vk5UWuVeo1RdoWQCPokmy1IvAma4sd5rRh1bDJ0RNk+YJYZOEcPALv/my7
 v9K/Q5v+gi+kquFzB9etDvK2aclu0cvuFCZZfKLkorVVAGS/pmbY7g9vHBIgS/VYqXyN
 qcBy+ZE2eAK1L5EXsGjAFEKWmR6NLR/KVNgmYwhedYL9NkKzjEiC4/bUpAJGmwDCYpFC
 NU/Fv7hWt3Wh9pM/hbQDomBxfRj9M1ZErOdOM5EQoLnk0ieWCxkbaD/1QMe15GrCJBjo
 E2DQ==
X-Gm-Message-State: AOAM530VmRShTa4WQWg0TEZ3y/0A6gi7OmcwAn44YRHKMHA+/usrKcnl
 V4ArDPNmdy/pW4++NbFgXoJPd0DILsHr5jBOS1o=
X-Google-Smtp-Source: ABdhPJzKJ+aizqXge4AnyEaKAmJihT9yZO4enNtb4XFVvxg/gtJ90UcaLqf0W+73Sq4BM5iN5I9xeg==
X-Received: by 2002:a1c:20d0:: with SMTP id g199mr797125wmg.68.1605559411340; 
 Mon, 16 Nov 2020 12:43:31 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:bc40:bd71:373a:1b33])
 by smtp.gmail.com with ESMTPSA id f5sm25099875wrg.32.2020.11.16.12.43.29
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 16 Nov 2020 12:43:30 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2 04/24] arm64: Move MAIR_EL1_SET to asm/memory.h
Date: Mon, 16 Nov 2020 20:42:58 +0000
Message-Id: <20201116204318.63987-5-dbrazdil@google.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201116204318.63987-1-dbrazdil@google.com>
References: <20201116204318.63987-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: kernel-team@android.com, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Andrew Walbran <qwandor@google.com>, Marc Zyngier <maz@kernel.org>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>, Tejun Heo <tj@kernel.org>,
 Dennis Zhou <dennis@kernel.org>, Christoph Lameter <cl@linux.com>,
 Will Deacon <will@kernel.org>
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

KVM currently initializes MAIR_EL2 to the value of MAIR_EL1. In
preparation for initializing MAIR_EL2 before MAIR_EL1, move the constant
into a shared header file. Since it is used for EL1 and EL2, rename to
MAIR_ELx_SET.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/include/asm/memory.h | 29 ++++++++++++++---------------
 arch/arm64/include/asm/sysreg.h | 30 ++++++++++++++++++++++++++++++
 arch/arm64/mm/proc.S            | 15 +--------------
 3 files changed, 45 insertions(+), 29 deletions(-)

diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
index cd61239bae8c..8ae8fd883a0c 100644
--- a/arch/arm64/include/asm/memory.h
+++ b/arch/arm64/include/asm/memory.h
@@ -13,6 +13,7 @@
 #include <linux/const.h>
 #include <linux/sizes.h>
 #include <asm/page-def.h>
+#include <asm/sysreg.h>
 
 /*
  * Size of the PCI I/O space. This must remain a power of two so that
@@ -124,21 +125,6 @@
  */
 #define SEGMENT_ALIGN		SZ_64K
 
-/*
- * Memory types available.
- *
- * IMPORTANT: MT_NORMAL must be index 0 since vm_get_page_prot() may 'or' in
- *	      the MT_NORMAL_TAGGED memory type for PROT_MTE mappings. Note
- *	      that protection_map[] only contains MT_NORMAL attributes.
- */
-#define MT_NORMAL		0
-#define MT_NORMAL_TAGGED	1
-#define MT_NORMAL_NC		2
-#define MT_NORMAL_WT		3
-#define MT_DEVICE_nGnRnE	4
-#define MT_DEVICE_nGnRE		5
-#define MT_DEVICE_GRE		6
-
 /*
  * Memory types for Stage-2 translation
  */
@@ -152,6 +138,19 @@
 #define MT_S2_FWB_NORMAL	6
 #define MT_S2_FWB_DEVICE_nGnRE	1
 
+/*
+ * Default MAIR_EL1. MT_NORMAL_TAGGED is initially mapped as Normal memory and
+ * changed during __cpu_setup to Normal Tagged if the system supports MTE.
+ */
+#define MAIR_ELx_SET							\
+	(MAIR_ATTRIDX(MAIR_ATTR_DEVICE_nGnRnE, MT_DEVICE_nGnRnE) |	\
+	 MAIR_ATTRIDX(MAIR_ATTR_DEVICE_nGnRE, MT_DEVICE_nGnRE) |	\
+	 MAIR_ATTRIDX(MAIR_ATTR_DEVICE_GRE, MT_DEVICE_GRE) |		\
+	 MAIR_ATTRIDX(MAIR_ATTR_NORMAL_NC, MT_NORMAL_NC) |		\
+	 MAIR_ATTRIDX(MAIR_ATTR_NORMAL, MT_NORMAL) |			\
+	 MAIR_ATTRIDX(MAIR_ATTR_NORMAL_WT, MT_NORMAL_WT) |		\
+	 MAIR_ATTRIDX(MAIR_ATTR_NORMAL, MT_NORMAL_TAGGED))
+
 #ifdef CONFIG_ARM64_4K_PAGES
 #define IOREMAP_MAX_ORDER	(PUD_SHIFT)
 #else
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index e2ef4c2edf06..24e773414cb4 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -635,6 +635,34 @@
 /* Position the attr at the correct index */
 #define MAIR_ATTRIDX(attr, idx)		((attr) << ((idx) * 8))
 
+/*
+ * Memory types available.
+ *
+ * IMPORTANT: MT_NORMAL must be index 0 since vm_get_page_prot() may 'or' in
+ *	      the MT_NORMAL_TAGGED memory type for PROT_MTE mappings. Note
+ *	      that protection_map[] only contains MT_NORMAL attributes.
+ */
+#define MT_NORMAL		0
+#define MT_NORMAL_TAGGED	1
+#define MT_NORMAL_NC		2
+#define MT_NORMAL_WT		3
+#define MT_DEVICE_nGnRnE	4
+#define MT_DEVICE_nGnRE		5
+#define MT_DEVICE_GRE		6
+
+/*
+ * Default MAIR_ELx. MT_NORMAL_TAGGED is initially mapped as Normal memory and
+ * changed during __cpu_setup to Normal Tagged if the system supports MTE.
+ */
+#define MAIR_ELx_SET							\
+	(MAIR_ATTRIDX(MAIR_ATTR_DEVICE_nGnRnE, MT_DEVICE_nGnRnE) |	\
+	 MAIR_ATTRIDX(MAIR_ATTR_DEVICE_nGnRE, MT_DEVICE_nGnRE) |	\
+	 MAIR_ATTRIDX(MAIR_ATTR_DEVICE_GRE, MT_DEVICE_GRE) |		\
+	 MAIR_ATTRIDX(MAIR_ATTR_NORMAL_NC, MT_NORMAL_NC) |		\
+	 MAIR_ATTRIDX(MAIR_ATTR_NORMAL, MT_NORMAL) |			\
+	 MAIR_ATTRIDX(MAIR_ATTR_NORMAL_WT, MT_NORMAL_WT) |		\
+	 MAIR_ATTRIDX(MAIR_ATTR_NORMAL, MT_NORMAL_TAGGED))
+
 /* id_aa64isar0 */
 #define ID_AA64ISAR0_RNDR_SHIFT		60
 #define ID_AA64ISAR0_TLB_SHIFT		56
@@ -992,6 +1020,7 @@
 /* Safe value for MPIDR_EL1: Bit31:RES1, Bit30:U:0, Bit24:MT:0 */
 #define SYS_MPIDR_SAFE_VAL	(BIT(31))
 
+#ifndef LINKER_SCRIPT
 #ifdef __ASSEMBLY__
 
 	.irp	num,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30
@@ -1109,5 +1138,6 @@
 })
 
 #endif
+#endif	/* LINKER_SCRIPT */
 
 #endif	/* __ASM_SYSREG_H */
diff --git a/arch/arm64/mm/proc.S b/arch/arm64/mm/proc.S
index 23c326a06b2d..e3b9aa372b96 100644
--- a/arch/arm64/mm/proc.S
+++ b/arch/arm64/mm/proc.S
@@ -45,19 +45,6 @@
 #define TCR_KASAN_FLAGS 0
 #endif
 
-/*
- * Default MAIR_EL1. MT_NORMAL_TAGGED is initially mapped as Normal memory and
- * changed during __cpu_setup to Normal Tagged if the system supports MTE.
- */
-#define MAIR_EL1_SET							\
-	(MAIR_ATTRIDX(MAIR_ATTR_DEVICE_nGnRnE, MT_DEVICE_nGnRnE) |	\
-	 MAIR_ATTRIDX(MAIR_ATTR_DEVICE_nGnRE, MT_DEVICE_nGnRE) |	\
-	 MAIR_ATTRIDX(MAIR_ATTR_DEVICE_GRE, MT_DEVICE_GRE) |		\
-	 MAIR_ATTRIDX(MAIR_ATTR_NORMAL_NC, MT_NORMAL_NC) |		\
-	 MAIR_ATTRIDX(MAIR_ATTR_NORMAL, MT_NORMAL) |			\
-	 MAIR_ATTRIDX(MAIR_ATTR_NORMAL_WT, MT_NORMAL_WT) |		\
-	 MAIR_ATTRIDX(MAIR_ATTR_NORMAL, MT_NORMAL_TAGGED))
-
 #ifdef CONFIG_CPU_PM
 /**
  * cpu_do_suspend - save CPU registers context
@@ -425,7 +412,7 @@ SYM_FUNC_START(__cpu_setup)
 	/*
 	 * Memory region attributes
 	 */
-	mov_q	x5, MAIR_EL1_SET
+	mov_q	x5, MAIR_ELx_SET
 #ifdef CONFIG_ARM64_MTE
 	/*
 	 * Update MAIR_EL1, GCR_EL1 and TFSR*_EL1 if MTE is supported
-- 
2.29.2.299.gdc1121823c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
