Return-Path: <SRS0=PxFR=EK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E12DC5517A
	for <kvmarm@archiver.kernel.org>; Wed,  4 Nov 2020 18:36:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C40E12083B
	for <kvmarm@archiver.kernel.org>; Wed,  4 Nov 2020 18:36:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="h5c/xuFD"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C40E12083B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 614FD4B6DE;
	Wed,  4 Nov 2020 13:36:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3zi79orS-vVj; Wed,  4 Nov 2020 13:36:50 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 54C514B7B4;
	Wed,  4 Nov 2020 13:36:50 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E4124B55A
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Nov 2020 13:36:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MbvDo8s337My for <kvmarm@lists.cs.columbia.edu>;
 Wed,  4 Nov 2020 13:36:48 -0500 (EST)
Received: from mail-wr1-f68.google.com (mail-wr1-f68.google.com
 [209.85.221.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3398F4B7B4
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Nov 2020 13:36:48 -0500 (EST)
Received: by mail-wr1-f68.google.com with SMTP id s9so23139612wro.8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 04 Nov 2020 10:36:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=selpDVExPrV+IgPEKGIlRfie/i9lgMV2qEZhs31ItAo=;
 b=h5c/xuFDGxhQNOOJxFYmZXPnLJyC4mt4eevQqa2BS/KDBE+R4+ZWYl3fiVp6+6GKml
 rdXluqt6BqUFOHQomC+HPz2nWSen/qcJZ0oTOtl2BKcUfsVXlAZy5wrHtufxBkAIWslB
 HCw8iLlb8kPY1W0YDvNIq7lH1izzFXSlNt9V7Ci06lt/x6qUvsjzXw6RN2ieTU+6G5qV
 /cCFrPXpeltx/hzuo9u7iu6TM54yUhX2W4sCEQjs+fR0UKJfMcmM+WiVu0qBnhnPuGND
 9WjCSGx4PewL3YT53jbPkiQxHS63x1gGFZWbB7kh0Qe68aFM4yJTGc8g1TYn/PldTPi0
 9YWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=selpDVExPrV+IgPEKGIlRfie/i9lgMV2qEZhs31ItAo=;
 b=CdsXL5hiarcFTgAR19ZWBEhyb7XSvxw1KjWP0R8A/ppAEmpafKGbr0C++Ehir8j++O
 A0B5hZKpgEAfkYTagfygv0L5tT+Wpv9YBx/zvwNcdVc1V/79O6eH3ohr2tcmt1gltjEG
 QxmFOZMD2nD48yBAA3xI73/LjbGMGWa3wwhoCHzK9mDbsrhs2Mlh787K5Qlu0EHN6vmO
 3M1ApHflWHIWTYQqE2welttrDUyJWxdNrS7MWWEq8nXn4eKc1erFgUd3hJH4E1tZdBH/
 6ZboNNtwCv24IdgGolQjWEuIsh69oqwftzeCBTUkOLqYAvrg5o6YqkXB5jOKzofV/J2c
 OOMg==
X-Gm-Message-State: AOAM533A4heu3eC+Puywmn5AH5NtJPGUYhuWZvyKF1KgCMOmmk5i88Il
 1QsZWmSbefAhkG0wUSRdyIfbJwAj3I/Ghp9M
X-Google-Smtp-Source: ABdhPJyfkHHLx4wrmP7Kl9DrEZuORHnz2YFNiH75/raVrsXNU+mtkObCRVRsUfShJ+nawpNDAnF/uA==
X-Received: by 2002:adf:edcf:: with SMTP id v15mr31926989wro.291.1604515006429; 
 Wed, 04 Nov 2020 10:36:46 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:c8d2:30f2:53c6:bc2])
 by smtp.gmail.com with ESMTPSA id u15sm3719292wrm.77.2020.11.04.10.36.45
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 04 Nov 2020 10:36:45 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [RFC PATCH 04/26] arm64: Move MAIR_EL1_SET to asm/memory.h
Date: Wed,  4 Nov 2020 18:36:08 +0000
Message-Id: <20201104183630.27513-5-dbrazdil@google.com>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201104183630.27513-1-dbrazdil@google.com>
References: <20201104183630.27513-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, kernel-team@android.com,
 Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org,
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
into a shared header file.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/include/asm/memory.h | 13 +++++++++++++
 arch/arm64/mm/proc.S            | 13 -------------
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
index cd61239bae8c..aca00737e771 100644
--- a/arch/arm64/include/asm/memory.h
+++ b/arch/arm64/include/asm/memory.h
@@ -152,6 +152,19 @@
 #define MT_S2_FWB_NORMAL	6
 #define MT_S2_FWB_DEVICE_nGnRE	1
 
+/*
+ * Default MAIR_EL1. MT_NORMAL_TAGGED is initially mapped as Normal memory and
+ * changed during __cpu_setup to Normal Tagged if the system supports MTE.
+ */
+#define MAIR_EL1_SET							\
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
diff --git a/arch/arm64/mm/proc.S b/arch/arm64/mm/proc.S
index 23c326a06b2d..25ff21b3a1c6 100644
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
-- 
2.29.1.341.ge80a0c044ae-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
