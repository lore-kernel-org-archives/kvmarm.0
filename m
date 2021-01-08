Return-Path: <SRS0=HOrx=GL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2ACBBC433DB
	for <kvmarm@archiver.kernel.org>; Fri,  8 Jan 2021 12:15:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AA8FB2399A
	for <kvmarm@archiver.kernel.org>; Fri,  8 Jan 2021 12:15:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AA8FB2399A
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 21F1E4B3E6;
	Fri,  8 Jan 2021 07:15:35 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id td6imsrYqW3R; Fri,  8 Jan 2021 07:15:34 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C2174B3F0;
	Fri,  8 Jan 2021 07:15:34 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B5E5F4B3E1
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Jan 2021 07:15:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id H8MJBRkRQVrF for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Jan 2021 07:15:30 -0500 (EST)
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com
 [209.85.221.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E9C2F4B3D8
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Jan 2021 07:15:29 -0500 (EST)
Received: by mail-wr1-f73.google.com with SMTP id o17so4080344wra.8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 08 Jan 2021 04:15:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=2AvxqWsiNZiBgTFedPJYPTYC/iX22/lJxd+Fe6flKw0=;
 b=XIyewR3btdhcaLpqgHHf31EmI/fdUcLfY2l8kYP4b62kKxx9iTpjV2a87Z2iqPdVdh
 3YXXLs/Ky8cj/4mgJkr2p7eSWVX+S+lIe4YQMowwmloU1LTRFbPQeCWsn7ja28FPpFxg
 PwX+aTx1oHZub2LCC/ssQtz+EkVTbbxzq0Eep7agFz+EkOn0+/LZFQHu6yoviR1jsOr2
 MgFkYUmjkq+qlR91UBaqCSn/hp+eCjs3Wah+TaXvMZOZq8x5mZ4WEfPjCwP3SRodjLET
 8G+W+2AnHQygsHUYleRZs3XIMWfRKcaN0SIjbYx3+NFR4g+Nhx4GGr7jVp9LAnWmo/lK
 i6Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=2AvxqWsiNZiBgTFedPJYPTYC/iX22/lJxd+Fe6flKw0=;
 b=ujEQDzE7+Tfg1nsgFwvQBemDVxZtQKQmrKyM0GGuChIDQ+3pSR1kl98XhdvaFIX2FA
 1eeoK/ER9CxP1vtfnDhoCcBNtkjOuXAeHAG6kgEC070GCtEYqdb0MwmQKI847m24XTE0
 91+ebevVixQXFdmDcwAGSUf9a3g99YBFepV1HV8ocSoa2Xvfc3MflOBo/QckOU5EZkPr
 aUB2tthrGWJIAkedD26MDk7EwoVft4CTAj9lZZWM+Ht/MJf6Sl5ge1rnre1WvlnPmgvt
 ouh6kXkQ543Asi2NrQDhlzIS91KC8Ui3O1OHOk0YTxbFpqf07ZfPgDsLN9Z+FBy5uA+3
 A6iw==
X-Gm-Message-State: AOAM530ULOM34v1084qL8mTQU1ONmYSk40DFcWQ5HzKlj3fwsaHWodUD
 yTXT+WouJexrU2MbuETm0ed2EQD/sMgO
X-Google-Smtp-Source: ABdhPJyf1ctEy51fuFCix0vOeWng0452zHo1A6Dfvf1j1eurJXucg7DaQIxlCVhea+1iolch1bleRN20EdPf
X-Received: from r2d2-qp.c.googlers.com
 ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a1c:2c89:: with SMTP id
 s131mr1783892wms.0.1610108128579; Fri, 08 Jan 2021 04:15:28 -0800 (PST)
Date: Fri,  8 Jan 2021 12:14:59 +0000
In-Reply-To: <20210108121524.656872-1-qperret@google.com>
Message-Id: <20210108121524.656872-2-qperret@google.com>
Mime-Version: 1.0
References: <20210108121524.656872-1-qperret@google.com>
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
Subject: [RFC PATCH v2 01/26] arm64: lib: Annotate {clear,
 copy}_page() as position-independent
From: Quentin Perret <qperret@google.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Rob Herring <robh+dt@kernel.org>, Frank Rowand <frowand.list@gmail.com>
Cc: devicetree@vger.kernel.org, android-kvm@google.com,
 linux-kernel@vger.kernel.org, Fuad Tabba <tabba@google.com>,
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
2.30.0.284.gd98b1dd5eaa7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
