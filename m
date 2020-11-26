Return-Path: <SRS0=e8LN=FA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9CE1C56202
	for <kvmarm@archiver.kernel.org>; Thu, 26 Nov 2020 15:54:41 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4E3DC221EB
	for <kvmarm@archiver.kernel.org>; Thu, 26 Nov 2020 15:54:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="OchURbw1"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4E3DC221EB
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DDD7E4C070;
	Thu, 26 Nov 2020 10:54:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5riS+arE8I8s; Thu, 26 Nov 2020 10:54:39 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 929074BD3B;
	Thu, 26 Nov 2020 10:54:38 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7B77D4BD3B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Nov 2020 10:54:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QW7Iz1UnrWyE for <kvmarm@lists.cs.columbia.edu>;
 Thu, 26 Nov 2020 10:54:36 -0500 (EST)
Received: from mail-wm1-f67.google.com (mail-wm1-f67.google.com
 [209.85.128.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 74EFB4B5D3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Nov 2020 10:54:36 -0500 (EST)
Received: by mail-wm1-f67.google.com with SMTP id a65so2872773wme.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Nov 2020 07:54:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=HHdsvDKCV+y2T0WHPFGAdN0qhY1OjBTJULnU1VX59iA=;
 b=OchURbw1mLwFNtApGpEjM6AKBpDfQt9A0SnaSO/IvElpZFNXclLui4HRql7+PGhPzu
 w04fOAsLJg76P6WZjX/BoPa8t98z/zCXTtsh3+9RM29/ABXswF3vZehbRj8WIt/AgLtP
 L1k4SXy6vkelZAc1vVbqeOd+r1oeZei7wOPlFer6IGR4IFM5MXaOg8/8g9/rQhagB3ka
 dpXN3Srhy8SuzemOK5jvdLk4cjfBovVom/uweowmjaI38hHlgTpMbjl2MDXmVHPXSN/S
 fbBM51yzh1M2Eluao4XM9cf6bSCqn1yHyxPe1V86PBl5py1rObz13Ko5gXZLpnmXc+U2
 2dpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=HHdsvDKCV+y2T0WHPFGAdN0qhY1OjBTJULnU1VX59iA=;
 b=BNo0F6/hjE/g1LFcGpIynSB6socqCC/njQg4LsxTGQxR3d2Qu1E+Ku6bIeOMyiZ6MY
 t/xy3bYClFn3pSqisMbt++XFlrcgQvIGxvnSpPUjthEuNGsGXORwWrjXUUpwJXr5qXKD
 ZBgocUFBfFomJtp9udGcrtYy8sImnxVgMcKFCSfOju5Uzmqq2IOaq7gw5KdniTXkF8um
 viDAxQ10L95IaSRqsuFaRzjznfQbuYtQW3cytGJ31S0UiMB2vYfoe/uI/bhJktDuE/en
 fjlPlxNErRL9a+p95qF35emSkll6c1KmOA6ozFK7deQuT5V/yL8ybEuoXNfvplRpA+8Z
 tVFg==
X-Gm-Message-State: AOAM530PvRUsu1tEOihtcnrwLRxEs32qDSL2Eu8MdMJ4NxNp8RaZkz+6
 SNVpSum/XXqNu3iKRGjOmMHzfKWgFII46VmZ
X-Google-Smtp-Source: ABdhPJxLdnrPvl0zzUmNu9CSpqRHeZvuF+rg/YRWgtrj7i//XJcOslWwSsG2VuZ6GKRjiQHqNZNJ7A==
X-Received: by 2002:a7b:cb58:: with SMTP id v24mr4021372wmj.23.1606406075145; 
 Thu, 26 Nov 2020 07:54:35 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:f008:704d:8d4b:9951])
 by smtp.gmail.com with ESMTPSA id a144sm9761056wmd.47.2020.11.26.07.54.33
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 26 Nov 2020 07:54:34 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v3 04/23] arm64: Move MAIR_EL1_SET to asm/memory.h
Date: Thu, 26 Nov 2020 15:54:02 +0000
Message-Id: <20201126155421.14901-5-dbrazdil@google.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201126155421.14901-1-dbrazdil@google.com>
References: <20201126155421.14901-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, kernel-team@android.com,
 Jonathan Corbet <corbet@lwn.net>, Catalin Marinas <catalin.marinas@arm.com>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 Sudeep Holla <sudeep.holla@arm.com>, linux-arm-kernel@lists.infradead.org,
 Marc Zyngier <maz@kernel.org>, Tejun Heo <tj@kernel.org>,
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
 arch/arm64/include/asm/memory.h | 13 +++++++++++++
 arch/arm64/mm/proc.S            | 15 +--------------
 2 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
index cd61239bae8c..54a22cb5b17b 100644
--- a/arch/arm64/include/asm/memory.h
+++ b/arch/arm64/include/asm/memory.h
@@ -152,6 +152,19 @@
 #define MT_S2_FWB_NORMAL	6
 #define MT_S2_FWB_DEVICE_nGnRE	1
 
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
 #ifdef CONFIG_ARM64_4K_PAGES
 #define IOREMAP_MAX_ORDER	(PUD_SHIFT)
 #else
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
2.29.2.454.gaff20da3a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
