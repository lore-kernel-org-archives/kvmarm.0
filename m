Return-Path: <SRS0=QSSN=IR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89DF0C433DB
	for <kvmarm@archiver.kernel.org>; Fri, 19 Mar 2021 10:01:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2EAD664EF6
	for <kvmarm@archiver.kernel.org>; Fri, 19 Mar 2021 10:01:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2EAD664EF6
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C57F24B60C;
	Fri, 19 Mar 2021 06:01:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8GZTyZyR5rEY; Fri, 19 Mar 2021 06:01:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D17E84B67F;
	Fri, 19 Mar 2021 06:01:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 69C7F4B5CC
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Mar 2021 06:01:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ki12esqBApO3 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 19 Mar 2021 06:01:52 -0400 (EDT)
Received: from mail-qk1-f202.google.com (mail-qk1-f202.google.com
 [209.85.222.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8D1DD4B5CA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Mar 2021 06:01:52 -0400 (EDT)
Received: by mail-qk1-f202.google.com with SMTP id h19so878616qkk.4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Mar 2021 03:01:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=V8Xuh8uPnnLxOiVNiwLjLFxuzBpy6trzUPCuAOE2xx0=;
 b=E47utFiCvPDllFOUvdxw5MOKvubX8x5bac8nRQH/7SYG0fJYbAZBV+9CZ/3/4SbXMZ
 j/uDGzouAkaKWs+7hEm10fD00d/SyVEbDAMqbhYgqNeNjIlmJM0PYnTX2O+aKOARK+Vb
 gbZbhRoVoGb3LNyn4TqH0HkYIwH3lwLBG/2AZz5tZrcGXcmbrkaH3290cEpVtdLR06fD
 DyXwM0GgpUVDslfY8U5L/SyeyQPbEDSvuoBChD14M7n5FhlE1Uy+0aOlFXFmKJQDIkfC
 4vPQ4BwQRHdoYMNoSh3I971jrh4yi5kOOUOv9jiWyNZlueB+yL2JezBSdvDXQltjetQV
 SfhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=V8Xuh8uPnnLxOiVNiwLjLFxuzBpy6trzUPCuAOE2xx0=;
 b=I0tZ9nSXWcS8wYl1Jmoc4Jl9ip5WlJFteYetK8M2/EHFV/gGyL/GFI2Tve0MUhqyEP
 4JEU6DnSK5coLho/xNOEtIfTV5Uu13WsTjmxUcg3oWJD4oUlDxg7BkKAj8eGYRFxmbR2
 wuxa3sqrboqlOkA9neZyyDA7h/C8NH4JiKXBsaZ5I/N5RH+HhWZ9uhkr4kCyu8XNTnQ5
 l90AC4vuKsZshqtm/tdQ++TVPWLLOec8YgsD/NJHl8wfYr9xjTJcMqntj/8VN3a4vyB4
 YUJUDEwsSL3ThHKLo/Nl8RdbrKRRcvMA8YQcExM1LRP4ZIy0jt/0jqfuCoB+cJmN0mG0
 OE2g==
X-Gm-Message-State: AOAM532HoM8G/jyIIe6tBostlOMl1C+Nf58UjuPSy6Vba0mJ810cwpe8
 h/NYVoVutAN9z45rkSCUCzOKUUUv/ndY
X-Google-Smtp-Source: ABdhPJwrKxoMwoQgKcQKrC1l3pkp1V724TOKMdk4pKAw8/iqqYX6l7isxjYsCfysPkn+0D6rQZUe8Z4Ko+sg
X-Received: from r2d2-qp.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:ad4:4aa8:: with SMTP id
 i8mr8745734qvx.22.1616148112063; Fri, 19 Mar 2021 03:01:52 -0700 (PDT)
Date: Fri, 19 Mar 2021 10:01:09 +0000
In-Reply-To: <20210319100146.1149909-1-qperret@google.com>
Message-Id: <20210319100146.1149909-2-qperret@google.com>
Mime-Version: 1.0
References: <20210319100146.1149909-1-qperret@google.com>
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
Subject: [PATCH v6 01/38] arm64: lib: Annotate {clear,
 copy}_page() as position-independent
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
2.31.0.rc2.261.g7f71774620-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
