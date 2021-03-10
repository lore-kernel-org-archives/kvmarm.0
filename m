Return-Path: <SRS0=f6Gw=II=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2E32C433DB
	for <kvmarm@archiver.kernel.org>; Wed, 10 Mar 2021 17:58:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 79A5664FB1
	for <kvmarm@archiver.kernel.org>; Wed, 10 Mar 2021 17:58:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 79A5664FB1
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 178954B2AE;
	Wed, 10 Mar 2021 12:58:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XGSoZQ1QHMDO; Wed, 10 Mar 2021 12:58:00 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1986F4B617;
	Wed, 10 Mar 2021 12:58:00 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ED5204B60D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Mar 2021 12:57:58 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3uIwxVX2+WLO for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Mar 2021 12:57:57 -0500 (EST)
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com
 [209.85.221.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C65DE4B2AE
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Mar 2021 12:57:57 -0500 (EST)
Received: by mail-wr1-f74.google.com with SMTP id m23so3318095wrh.7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Mar 2021 09:57:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=AbQOhTo5qTBDcGKT4ROquEtU01mLpiQKpICJ+GOnoG0=;
 b=JzpUXZ4hpdoBvUyEsWDm2q1s1QRxAl2wx4lPyxgUQpUIJ7F0aVV92HnT2t7d2+gB78
 bUz/2TCUabh7EGBtNVRZShXzUflsBTbBP8+TtuPJERTGtDDbxvky8XAhZfj+cyxBTIOr
 VWwXSeTf22kfUPlEI+Gwhr+nqoB0tAKIffsGWkZdhNwdwyheRpKO2ypsVssGnl+iZBcG
 DoFVBZxFu50SG2HHLuRMrZtkXo9vsu4OjCirEILdzOmzM58CyNEo/DRyzmIvNtEoaf8R
 gisXQSUy9RC42Ahgk3HJDSsgTcaFEJri7l2kjGdD/YjK4DU4vgnl3B/RH4W0CV1cQkKX
 HAAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=AbQOhTo5qTBDcGKT4ROquEtU01mLpiQKpICJ+GOnoG0=;
 b=VkiGcEerX07b/U8oQu8o/nDMf7poOhDHRIfXo0klmlbMo3dj0mBIISywGF3wWb1VZB
 weUgRPAEtuAEhYoNy+TLPV6tWyqve/WS5UaRTE8rlfbMPtXM600mdILb5M/rEoOPziOZ
 H2frMeqVcQOe+F724Y3iuFQy8Z8A1og/r2zp4VdLLd+Of4ZJcy4ugt3H+Jt7jKJ2td/I
 bbmgyw6WpbOgjW7CzFKbTRfQVGrYuq6ve7/RF11b3kAiLOh0bGwtp2SPdRtxubBzMirr
 5IcglYQnwQEiNu6DFYv5I2gVNOWKAGE3mtAXTcwa6qx44erUZJ5IE3IGDEC8zxKjtRPd
 0H+Q==
X-Gm-Message-State: AOAM530t/YrxYvpiFrMUn+Ivt5cDTw8HCh6jRM1UNS0xoh0z6ztt/FQg
 8wDXTdJo5kGEHqB1Wk/bSF+AcaM7Rbyd
X-Google-Smtp-Source: ABdhPJyoHV7k5VKRC4cMLOuiadpNjmOubi8A8GxCIf77avXZ6hUq1pIFK8fqsdVSlzJaLhL/5cbha4JM2YHV
X-Received: from r2d2-qp.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a1c:7210:: with SMTP id
 n16mr4388170wmc.13.1615399076669; Wed, 10 Mar 2021 09:57:56 -0800 (PST)
Date: Wed, 10 Mar 2021 17:57:18 +0000
In-Reply-To: <20210310175751.3320106-1-qperret@google.com>
Message-Id: <20210310175751.3320106-2-qperret@google.com>
Mime-Version: 1.0
References: <20210310175751.3320106-1-qperret@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH v4 01/34] arm64: lib: Annotate {clear,
 copy}_page() as position-independent
From: Quentin Perret <qperret@google.com>
To: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
Cc: android-kvm@google.com, seanjc@google.com, mate.toth-pal@arm.com,
 linux-kernel@vger.kernel.org, robh+dt@kernel.org,
 linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu, tabba@google.com
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

From: Will Deacon <will@kernel.org>

clear_page() and copy_page() are suitable for use outside of the kernel
address space, so annotate them as position-independent code.

Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/lib/clear_page.S | 4 ++--
 arch/arm64/lib/copy_page.S  | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/lib/clear_page.S b/arch/arm64/lib/clear_page.S
index 073acbf02a7c..b84b179edba3 100644
--- a/arch/arm64/lib/clear_page.S
+++ b/arch/arm64/lib/clear_page.S
@@ -14,7 +14,7 @@
  * Parameters:
  *	x0 - dest
  */
-SYM_FUNC_START(clear_page)
+SYM_FUNC_START_PI(clear_page)
 	mrs	x1, dczid_el0
 	and	w1, w1, #0xf
 	mov	x2, #4
@@ -25,5 +25,5 @@ SYM_FUNC_START(clear_page)
 	tst	x0, #(PAGE_SIZE - 1)
 	b.ne	1b
 	ret
-SYM_FUNC_END(clear_page)
+SYM_FUNC_END_PI(clear_page)
 EXPORT_SYMBOL(clear_page)
diff --git a/arch/arm64/lib/copy_page.S b/arch/arm64/lib/copy_page.S
index e7a793961408..29144f4cd449 100644
--- a/arch/arm64/lib/copy_page.S
+++ b/arch/arm64/lib/copy_page.S
@@ -17,7 +17,7 @@
  *	x0 - dest
  *	x1 - src
  */
-SYM_FUNC_START(copy_page)
+SYM_FUNC_START_PI(copy_page)
 alternative_if ARM64_HAS_NO_HW_PREFETCH
 	// Prefetch three cache lines ahead.
 	prfm	pldl1strm, [x1, #128]
@@ -75,5 +75,5 @@ alternative_else_nop_endif
 	stnp	x16, x17, [x0, #112 - 256]
 
 	ret
-SYM_FUNC_END(copy_page)
+SYM_FUNC_END_PI(copy_page)
 EXPORT_SYMBOL(copy_page)
-- 
2.30.1.766.gb4fecdf3b7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
