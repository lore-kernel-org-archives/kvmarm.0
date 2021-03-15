Return-Path: <SRS0=nsVm=IN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 546EEC433DB
	for <kvmarm@archiver.kernel.org>; Mon, 15 Mar 2021 14:36:20 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E47D464FC0
	for <kvmarm@archiver.kernel.org>; Mon, 15 Mar 2021 14:36:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E47D464FC0
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8AF804B667;
	Mon, 15 Mar 2021 10:36:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8YGizDXpdlBu; Mon, 15 Mar 2021 10:36:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 895644B607;
	Mon, 15 Mar 2021 10:36:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 110314B4FC
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 10:36:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kyqXrKnrqR98 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Mar 2021 10:36:16 -0400 (EDT)
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com
 [209.85.221.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7519F4B203
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 10:36:14 -0400 (EDT)
Received: by mail-wr1-f74.google.com with SMTP id r6so1913915wrt.20
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 07:36:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=4ECUgkoGREkKZOm9t4R+RTCdTGWy+OUrTPPjtPvrKJ0=;
 b=ubKVY94FZBxte3JOLscmnNINlz5Nath/F12j0Cj6ICBvQmZcfxjvhk6cq9NMCBiB8h
 849RZc1HpGcF9S9YCX8dNdvQ0ekSiBbJKhiL6Qp2tDk3YQfK1H5WKrScnbp++ztGk/es
 yo7w9oFa4El4KU8zHQuYK/qoqZWhCN+gCza5SCjh2fR4Cmz8QRIXEHo3meb6rHTxu4hn
 6fc4AIskyZcoV1LAKAGm1UUhFfOEQdFD/fRlfyc9r749cSxliO7lk39yFAOIHx3cRZ23
 ilI4MKg6XcHIcO4MFihwQvA7hwUKHnGgxUEFA/ti9wuelBrWwrTPxSlGppQbg5MlFyH4
 AFLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=4ECUgkoGREkKZOm9t4R+RTCdTGWy+OUrTPPjtPvrKJ0=;
 b=GomHUGd9heqczO6xoP/oNgN7J+uQkanbJEZdXo8MgiT1+ikqRhV7uJah7FEb1/MQK+
 cLYwXR0TJUhMphL232NmOh2sk/sEzwCwYWIuahpw1LGhIrV9CXkyQ2xIHACfQ6xP5nr7
 hUgSQANxx48W2kP9F3H+GD79G64WeCvLL3J4sTKDIQfgcTsm+1QEr2UX/wV9O4A6EyPM
 pngA95Vuckd5Xotu45KGwQ5CIjgNH4plzbbz2Ngmr91aLQ13PnLf50Lk4SVpYQDu7Xvc
 MN63Pde9O7XPmzSlVTK0zlMkntlKJf2f41iEo1I8Fg+6GBG7uBOBRoiMTbNM4MjTJAAU
 1XsQ==
X-Gm-Message-State: AOAM531Qryxny9aWcCL8AxwCm74FEbPnpEJib+vtcHVSMimVscC34+AD
 vNPhgrgcbUL/hOpyYqPxpxVZt7KSLFhM
X-Google-Smtp-Source: ABdhPJzYehOnz8tCTfBHour34wAjOBD226lW09MVR9xTEXwscem/T/fZ6V3Usp4MMihrNAsA/4FgAQyZpAB1
X-Received: from r2d2-qp.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a1c:6a05:: with SMTP id
 f5mr14281wmc.184.1615818973676; Mon, 15 Mar 2021 07:36:13 -0700 (PDT)
Date: Mon, 15 Mar 2021 14:35:16 +0000
In-Reply-To: <20210315143536.214621-1-qperret@google.com>
Message-Id: <20210315143536.214621-17-qperret@google.com>
Mime-Version: 1.0
References: <20210315143536.214621-1-qperret@google.com>
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
Subject: [PATCH v5 16/36] arm64: asm: Provide set_sctlr_el2 macro
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

We will soon need to turn the EL2 stage 1 MMU on and off in nVHE
protected mode, so refactor the set_sctlr_el1 macro to make it usable
for that purpose.

Acked-by: Will Deacon <will@kernel.org>
Suggested-by: Will Deacon <will@kernel.org>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/include/asm/assembler.h | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
index ca31594d3d6c..fb651c1f26e9 100644
--- a/arch/arm64/include/asm/assembler.h
+++ b/arch/arm64/include/asm/assembler.h
@@ -676,11 +676,11 @@ USER(\label, ic	ivau, \tmp2)			// invalidate I line PoU
 	.endm
 
 /*
- * Set SCTLR_EL1 to the passed value, and invalidate the local icache
+ * Set SCTLR_ELx to the @reg value, and invalidate the local icache
  * in the process. This is called when setting the MMU on.
  */
-.macro set_sctlr_el1, reg
-	msr	sctlr_el1, \reg
+.macro set_sctlr, sreg, reg
+	msr	\sreg, \reg
 	isb
 	/*
 	 * Invalidate the local I-cache so that any instructions fetched
@@ -692,6 +692,14 @@ USER(\label, ic	ivau, \tmp2)			// invalidate I line PoU
 	isb
 .endm
 
+.macro set_sctlr_el1, reg
+	set_sctlr sctlr_el1, \reg
+.endm
+
+.macro set_sctlr_el2, reg
+	set_sctlr sctlr_el2, \reg
+.endm
+
 /*
  * Check whether to yield to another runnable task from kernel mode NEON code
  * (which runs with preemption disabled).
-- 
2.31.0.rc2.261.g7f71774620-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
