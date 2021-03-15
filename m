Return-Path: <SRS0=nsVm=IN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DF1EC433E0
	for <kvmarm@archiver.kernel.org>; Mon, 15 Mar 2021 14:35:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DC14964F5C
	for <kvmarm@archiver.kernel.org>; Mon, 15 Mar 2021 14:35:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DC14964F5C
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 798DE4B59F;
	Mon, 15 Mar 2021 10:35:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VT9X+m6QTsW7; Mon, 15 Mar 2021 10:35:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7A7FF4B5A6;
	Mon, 15 Mar 2021 10:35:47 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 78A414B4F3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 10:35:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bNyQI3bWc1Dl for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Mar 2021 10:35:43 -0400 (EDT)
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com
 [209.85.221.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0410A4B48E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 10:35:42 -0400 (EDT)
Received: by mail-wr1-f74.google.com with SMTP id r12so15210481wro.15
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 07:35:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=V8Xuh8uPnnLxOiVNiwLjLFxuzBpy6trzUPCuAOE2xx0=;
 b=Nz2UlNJsd1OuTRMmwb29WE3c6in8/OlAyj62Nd/wk6kQylS1Nph4kVvwEncfOMYoc/
 v2jBBn0+f1Sqad3Fr+XGYtzAoR5if9jPVr9ZlG2JqUGI2kjUyp9tHOIOeO2EVvbWDMjV
 5SR+Xr67g035zmB0zfXCIPMaxI2qHem0Fr8K+b2ujs5IX6F5cxq79OOwSvbjeqrbHzOF
 5A11xNQKXiDEOBGrO3GMCQYVJQ+C6HKNP+eLxSRYndYG+lB74ZJ0uAF7H44HgzogN4W0
 1CtMR4wAYEtAKuGn4XzGCOrVpERvEm54sciDEgPjaM1RommkB6DCMy/ngLl/KaKQNCBl
 zSVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=V8Xuh8uPnnLxOiVNiwLjLFxuzBpy6trzUPCuAOE2xx0=;
 b=Y8ycRBG2VL5OmgN4zNsBrwz6jOJLmpZc925CNJLjT+iFrNXCe0pwLCtscugLgu/NcZ
 eT5Wh1yYv14yJZ29lnUuRicNvwn4vRyaAmBQDr7TJvRX02AJKvL3Qk9NFBCh35eBK66W
 JFLXfPCidVjK65IfsMzqYPGsJKzEUiFRz2r5T7Y7Lwep8wcdwpji63O1Z7+OZhsP9vFx
 qiE760/iNanXB7WbumLn9T8Y1Rne+0+YqrtCxdL6hJHyFu+4Leq52RJebQ8RscqXaEVu
 hZ2lHb9xbHqLU/9vDfNuTKGA58spiD1qQ8QiHvYsMxejC9nt4R0P9IKRfMtTu6STh8Qa
 jZzg==
X-Gm-Message-State: AOAM533VAVTPvX1AwXZJhROo5cDwlHw6ZbI5tuYUioPIIag5U9n/qJQf
 1tU4jCIqNIABdU7ji+UihFRTkFNGujdX
X-Google-Smtp-Source: ABdhPJzR1b4aR6QaQ60ISv7IHqOCyLzBmRTfzqmQXTTEq7n/TXFLvP84XEuBt+n493T0JhKm+QtbDMICVRWV
X-Received: from r2d2-qp.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a7b:c750:: with SMTP id
 w16mr9005wmk.184.1615818942004; Mon, 15 Mar 2021 07:35:42 -0700 (PDT)
Date: Mon, 15 Mar 2021 14:35:01 +0000
In-Reply-To: <20210315143536.214621-1-qperret@google.com>
Message-Id: <20210315143536.214621-2-qperret@google.com>
Mime-Version: 1.0
References: <20210315143536.214621-1-qperret@google.com>
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
Subject: [PATCH v5 01/36] arm64: lib: Annotate {clear,
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
