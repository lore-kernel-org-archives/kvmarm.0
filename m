Return-Path: <SRS0=Sq8/=CS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24FF7C43461
	for <kvmarm@archiver.kernel.org>; Wed,  9 Sep 2020 23:13:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1CF1821D95
	for <kvmarm@archiver.kernel.org>; Wed,  9 Sep 2020 23:13:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1CF1821D95
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C3BB04B38A;
	Wed,  9 Sep 2020 19:13:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HI2s+w2ooTZk; Wed,  9 Sep 2020 19:13:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D06B24B36A;
	Wed,  9 Sep 2020 19:13:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A062D4B353
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Sep 2020 19:13:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kXaApxZTXSRu for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Sep 2020 19:13:12 -0400 (EDT)
Received: from mail-il1-f194.google.com (mail-il1-f194.google.com
 [209.85.166.194])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A8ADC4B352
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Sep 2020 19:13:12 -0400 (EDT)
Received: by mail-il1-f194.google.com with SMTP id a8so3998042ilk.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 09 Sep 2020 16:13:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=3WaX3GB+RjtdnSP+LhD8IcmydPpakTj1sPjuGaJHhUk=;
 b=qCTJaa2JS2uy8eE/YgOsA1P2StuUOHX7QsRx8RIoln/StWpaMeHdt+sQzO9h3bM+9m
 3ZP60U3DL9Aw7UJFSNw3TdK8mw+O8DND/1qiOWGHAj8wRGuB6x4lbxeHfw1h4T1dZkyC
 P2S9/Y/h3VtWNv2T2MSJthorVzV0YyJHSbb1V/OSaafGoqDDY5SDV0wSlWqkX+doRC/Z
 t3ZhzMvr/DubRzkw+3F6VLgK7L1cqhz/iHFLgsZ9XJ6hPNzdaZD0w2FzzKF+shhQnj4M
 gzgSPPLmBO/cuz7MxybzgST6uBNfa7wdH3zqyIVj3jknXV3kTcWbtrDD2RMYCR+Vj87K
 WXQQ==
X-Gm-Message-State: AOAM533fIwSW0eSmxWndRx4gnOWdchz+89vVUdlE3lUVmvXDxT8nY15z
 tW+XDWZWSaiLe3oCfMAQyQ==
X-Google-Smtp-Source: ABdhPJzOjFftUH82u7wQ9cyIF3VGiorwJJCnXg3QF+YV85FAMkyaKUcq17FjNde95WsnhGzA1o5TOQ==
X-Received: by 2002:a05:6e02:489:: with SMTP id
 b9mr5777485ils.161.1599693192153; 
 Wed, 09 Sep 2020 16:13:12 -0700 (PDT)
Received: from xps15.herring.priv ([64.188.179.251])
 by smtp.googlemail.com with ESMTPSA id p65sm2243285ill.23.2020.09.09.16.13.11
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 09 Sep 2020 16:13:11 -0700 (PDT)
From: Rob Herring <robh@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>
Subject: [PATCH v5 1/2] arm64: Add part number for Arm Cortex-A77
Date: Wed,  9 Sep 2020 17:13:09 -0600
Message-Id: <20200909231310.3297400-1-robh@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

Add the MIDR part number info for the Arm Cortex-A77.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Rob Herring <robh@kernel.org>
---
 arch/arm64/include/asm/cputype.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/include/asm/cputype.h b/arch/arm64/include/asm/cputype.h
index 7219cddeba66..9e2e9a63c7b6 100644
--- a/arch/arm64/include/asm/cputype.h
+++ b/arch/arm64/include/asm/cputype.h
@@ -71,6 +71,7 @@
 #define ARM_CPU_PART_CORTEX_A55		0xD05
 #define ARM_CPU_PART_CORTEX_A76		0xD0B
 #define ARM_CPU_PART_NEOVERSE_N1	0xD0C
+#define ARM_CPU_PART_CORTEX_A77		0xD0D
 
 #define APM_CPU_PART_POTENZA		0x000
 
@@ -105,6 +106,7 @@
 #define MIDR_CORTEX_A55 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A55)
 #define MIDR_CORTEX_A76	MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A76)
 #define MIDR_NEOVERSE_N1 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_NEOVERSE_N1)
+#define MIDR_CORTEX_A77	MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A77)
 #define MIDR_THUNDERX	MIDR_CPU_MODEL(ARM_CPU_IMP_CAVIUM, CAVIUM_CPU_PART_THUNDERX)
 #define MIDR_THUNDERX_81XX MIDR_CPU_MODEL(ARM_CPU_IMP_CAVIUM, CAVIUM_CPU_PART_THUNDERX_81XX)
 #define MIDR_THUNDERX_83XX MIDR_CPU_MODEL(ARM_CPU_IMP_CAVIUM, CAVIUM_CPU_PART_THUNDERX_83XX)
-- 
2.25.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
