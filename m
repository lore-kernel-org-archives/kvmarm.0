Return-Path: <SRS0=1ake=EP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5537C2D0A3
	for <kvmarm@archiver.kernel.org>; Mon,  9 Nov 2020 11:32:51 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 387A2206A4
	for <kvmarm@archiver.kernel.org>; Mon,  9 Nov 2020 11:32:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="KiIaN07L"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 387A2206A4
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B7AF74B60F;
	Mon,  9 Nov 2020 06:32:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id enb9z1vFxonA; Mon,  9 Nov 2020 06:32:50 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 54F3B4B761;
	Mon,  9 Nov 2020 06:32:49 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5016F4B74F
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Nov 2020 06:32:48 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id amhqg5h+PdOw for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Nov 2020 06:32:47 -0500 (EST)
Received: from mail-wr1-f68.google.com (mail-wr1-f68.google.com
 [209.85.221.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3EB6A4B772
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Nov 2020 06:32:47 -0500 (EST)
Received: by mail-wr1-f68.google.com with SMTP id l1so3906270wrb.9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 Nov 2020 03:32:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=9OHqVwmdHbsEbVYkhzfrXC3pmS5HWpDM4H+UgWkOTQ0=;
 b=KiIaN07Lql/jsar+Pt0YQtblLh2tpYdnoBcMlX29cx4cFAvQMzXKXI+pjxYH3unmqQ
 B+zG3cP1r+fCsNjx8DeGaHDo8SboteYbmIYfeUizmQMZYo3cUYcCibjZvKN/CLLT+zDq
 aKmyD15Ykq4sM0Shfe+MpPiQuhryzEAul/E++NLOoq2+NdMg1H5kTt1jdgL5Iw2CCCl5
 3wAxMjWaTyo1od7ojAO3Q599m4BH9FRsMUHGtqQza1xEDXjT4Un/SuuyGuroklXuacGI
 gXj7WBqwBRoBphWrGfXGFX1zCd7zDb/0rhYJ+C2fuz932FB5h14Dh/1Vxl+/opRVXRqN
 +hKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=9OHqVwmdHbsEbVYkhzfrXC3pmS5HWpDM4H+UgWkOTQ0=;
 b=M1x1n0AUH3FgWkG04nk5gH8bCmyF9/OolM5EHzLjwSTYvE1+2VH7vK8G7mqrn2Zsyk
 Svj3BWLPsjXvnZhVXJn5S5GZDk1q4jUvANW0KpA8TC1pok36UiE9ZDnjJG7kycRnkJ85
 aGE9my+gvkIGk6m9yZFxAEtqLNIeT1DcOxbTWdEVCG+8KBbA9Uvrb8+PRvjtTmlaaafm
 DCZJdHQLxj7Rz6xgMKrsKhBoQXxJmzvAfkW3JAok9fIi4c/u7OUX8+68csDA9dkNjb6N
 u3LxezXgpBwmLtx6WsDc77VZmikxmud9H4Vcm9Y1z2otTDUEW8kOb+Mzqz7+9XgmBDnN
 AA/w==
X-Gm-Message-State: AOAM531i00FU0bIsUauBvRpEjCJhrVIbSMSe7TvCotckUuCDZuOZoyS+
 OikOd4e0Hd3zvTTzNJj1MA+7G1JLR9Iaof/Y
X-Google-Smtp-Source: ABdhPJy9YbQLl6FOlXdSqqJeLuvcE3K3eiWcMuLImPT2P8noAXyO9kqewE+UUaL2JJaCpFto5lJFdQ==
X-Received: by 2002:adf:804b:: with SMTP id 69mr17407493wrk.274.1604921565923; 
 Mon, 09 Nov 2020 03:32:45 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:209d:10b7:c480:3e1f])
 by smtp.gmail.com with ESMTPSA id v6sm14976826wrb.53.2020.11.09.03.32.44
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 09 Nov 2020 03:32:45 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v1 03/24] arm64: Move MAIR_EL1_SET to asm/memory.h
Date: Mon,  9 Nov 2020 11:32:12 +0000
Message-Id: <20201109113233.9012-4-dbrazdil@google.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109113233.9012-1-dbrazdil@google.com>
References: <20201109113233.9012-1-dbrazdil@google.com>
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
2.29.2.222.g5d2a92d10f8-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
