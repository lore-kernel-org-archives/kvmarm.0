Return-Path: <SRS0=VcQF=EX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDEC7C5519F
	for <kvmarm@archiver.kernel.org>; Tue, 17 Nov 2020 18:16:27 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2236324686
	for <kvmarm@archiver.kernel.org>; Tue, 17 Nov 2020 18:16:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="i29eJtch"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2236324686
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 97F0B4B61D;
	Tue, 17 Nov 2020 13:16:26 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jm-FhCfIb6yf; Tue, 17 Nov 2020 13:16:25 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C2504B79D;
	Tue, 17 Nov 2020 13:16:25 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F3AE84B5E0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Nov 2020 13:16:23 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GJibM-x-1Fsq for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Nov 2020 13:16:23 -0500 (EST)
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com
 [209.85.128.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CD8934B5D6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Nov 2020 13:16:22 -0500 (EST)
Received: by mail-wm1-f74.google.com with SMTP id k128so2126526wme.7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Nov 2020 10:16:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=wfMub1Dq2/zzWvEJdcb9YkOg3Kk4cyIQtTysz5FPZ9k=;
 b=i29eJtch8pt4MddWICqOePgkq/MwJTbTc/hOyGFj3909KVEBPm5n0cRj+EplVnonKY
 WbI373E5+4cYXjRgWXgB7yoEj51rISpjpUCCpNubJ4wb3DMp/jUm/ja856YXPM1roevU
 DCSoS5kmz/1ross0mm9LO5aO5Df0pZvR0PhjdaR8ldJFyvyqiVcNi/BAVeb15byHXn9C
 8IMifCCt418cG8UX7UZpo+rA5552KYu5sl1fjIkWTaOGhboJk+EaVtU77VEJh1fdvKKP
 1csKvBXdENtZrlIOODJUyxJZCWUu3IhGdceC5DZsOslbPK2hFkR/d4psXG8fA7BWlsm1
 lmjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=wfMub1Dq2/zzWvEJdcb9YkOg3Kk4cyIQtTysz5FPZ9k=;
 b=hILXU3SHRcIynePHOsfoUn7BaX+6o1rNW9/6MOkAtc9xPtiDd8u788Hgk9S6HenBFL
 f0L1/ueWxbjpcBaXFXBa4C/jCaSOYaYNUBiO/KUt3YLV9rggDllnVxLd82/6kCDjrSYD
 tAjGZe6t9u6RFW3ZpB2I7GKRFoE5ZiqaBzLjjeCwXj513tYPmPq+ZFEorJ3j4XQpMEMF
 TcW+lmcLTqWYGYbmGJ25SgX5dNXwB0AQaUVbArXsfNc4Hm4wR1clcVj9JmjRTZr74RW3
 G7+W0WTuITAlz/Wd1LuCob9zZfEdEpbvASl70tv2rc8O6bU8QsD+uhHFnrPViMjS7Rku
 aOvQ==
X-Gm-Message-State: AOAM531hwjMGVMdfhWP9D1y/8jwzFp1p1Sl6aSRFiHuuvfJtPsxkpdE/
 CL11cGC2wwmamQ+e5bt8eXtXOiDV6PYA
X-Google-Smtp-Source: ABdhPJwLzQmM3f+/yXxfkHBpPHMIy89xImU6xwZzUPy415BoTaClg6AeXK5YHYslpqgilPliowk09nC1PT5L
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:f693:9fff:fef4:a7ef])
 (user=qperret job=sendgmr) by 2002:a1c:3d54:: with SMTP id
 k81mr389168wma.144.1605636981668; Tue, 17 Nov 2020 10:16:21 -0800 (PST)
Date: Tue, 17 Nov 2020 18:15:41 +0000
In-Reply-To: <20201117181607.1761516-1-qperret@google.com>
Message-Id: <20201117181607.1761516-2-qperret@google.com>
Mime-Version: 1.0
References: <20201117181607.1761516-1-qperret@google.com>
X-Mailer: git-send-email 2.29.2.299.gdc1121823c-goog
Subject: [RFC PATCH 01/27] arm64: lib: Annotate {clear,
 copy}_page() as position-independent
From: Quentin Perret <qperret@google.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Rob Herring <robh+dt@kernel.org>, Frank Rowand <frowand.list@gmail.com>
Cc: "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE"
 <devicetree@vger.kernel.org>, android-kvm@google.com,
 open list <linux-kernel@vger.kernel.org>, kernel-team@android.com,
 "open list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>,
 "moderated list:ARM64 PORT \(AARCH64 ARCHITECTURE\)"
 <linux-arm-kernel@lists.infradead.org>
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
2.29.2.299.gdc1121823c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
