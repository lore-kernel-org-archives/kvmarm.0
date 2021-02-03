Return-Path: <SRS0=xLVY=HF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C809BC433DB
	for <kvmarm@archiver.kernel.org>; Wed,  3 Feb 2021 14:19:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2B51B64F2C
	for <kvmarm@archiver.kernel.org>; Wed,  3 Feb 2021 14:19:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2B51B64F2C
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AA31A4B287;
	Wed,  3 Feb 2021 09:19:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1+86LzlzHIGy; Wed,  3 Feb 2021 09:19:41 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A83694B28A;
	Wed,  3 Feb 2021 09:19:41 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 38F7B4B273
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Feb 2021 09:19:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gcFMWwQZfSdP for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 Feb 2021 09:19:37 -0500 (EST)
Received: from mail-qk1-f201.google.com (mail-qk1-f201.google.com
 [209.85.222.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6C0484B280
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Feb 2021 09:19:37 -0500 (EST)
Received: by mail-qk1-f201.google.com with SMTP id c63so15318957qkd.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 03 Feb 2021 06:19:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=gdNxs8YaM69sWh4jREuvK0RFhtTc9iQ+3CErelD+Kuw=;
 b=mapOjrW3gKFKnloS39F2W/uU3TREbERLKqranHIMK4eMaLBf9/3W3R/SSpftpGEZmX
 v/mRBr3ytvTjl0sEkgsidsX/VDNWn/k1P/l0e3MfQgqHgtMUcTBpqKAKHaBoL7Nq4kHj
 wFL3UWu/k8cMoyiGQwsIIeUMRoKQoSYr2i+qhXKvL/AKFFA8+qszCNQzfHVFjnmVe4jJ
 tzHoSa3TdvGCDOGbg9U2CvbX94ij2yFbQiqLTa2BGRO1XYbWIw+xuAk6P26e9K/gxA4w
 5jWtkfQKy3/4xt+RUgH8l+8yT96jc/AWbu1WzuDjD2o+w1/e8y0E3Ix7JOiOSctW1+yq
 7tZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=gdNxs8YaM69sWh4jREuvK0RFhtTc9iQ+3CErelD+Kuw=;
 b=bqs+CRLpQUuhtD7U63tnNcAbXXoXGRpMD5uvkaWEDhAOIypvl/J6uYq2Zbf9LqiqxF
 53USmuQRERw86jaeM/QdlE0Gb1r+ato4F+5N76fbObLQ4u4f41re5oSVuR/zYH5Oroem
 zw8xetlEH6Z/QIkqYMsoyrnopaOFeetTTtsfZLOzAY1kcLchiXJvQ3iiiyVfO4SyXgFT
 ygzlARdNrur+Hmf+bhL+i5srPrGIT7DTzxvbGNn3GyIJGGQRhoZ5AZ8xHkAroJVeZ1l9
 zVv6u5TWiqkXo5Alh0V3xo9KKTw0ifkprKHeW9jDCUpRqe4vNrKFjofLTwSyPoN1LYF9
 FMUQ==
X-Gm-Message-State: AOAM532L0NSdDLIKlOBIUBuwcaMr0rWstYrtHgCBGY/ShfsbeoKn4hts
 v8O8KgzvS/zN/M4B9luy9MYaUs5UHyYa
X-Google-Smtp-Source: ABdhPJzB8Ow/F/CZOHVjcn9iuSTID9Tc1GsdyyhMrHAiA0JbUl8qtRteULcOWo7SJFI+fo/OhTgbHaHKfLBI
X-Received: from r2d2-qp.c.googlers.com
 ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a0c:83a4:: with SMTP id
 k33mr3010478qva.1.1612361976798; Wed, 03 Feb 2021 06:19:36 -0800 (PST)
Date: Wed,  3 Feb 2021 14:19:30 +0000
In-Reply-To: <20210203141931.615898-1-qperret@google.com>
Message-Id: <20210203141931.615898-2-qperret@google.com>
Mime-Version: 1.0
References: <20210203141931.615898-1-qperret@google.com>
X-Mailer: git-send-email 2.30.0.365.g02bc693789-goog
Subject: [PATCH 1/2] asm-generic: export: Stub EXPORT_SYMBOL with
 __DISABLE_EXPORTS
From: Quentin Perret <qperret@google.com>
To: arnd@arndb.de, maz@kernel.org, catalin.marinas@arm.com, will@kernel.org
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 kernel-team@android.com, ardb@kernel.org
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

It is currently possible to stub EXPORT_SYMBOL() macros in C code using
__DISABLE_EXPORTS, which is necessary to run in constrained environments
such as the EFI stub or the decompressor. But this currently doesn't
apply to exports from assembly, which can lead to somewhat confusing
situations.

Consolidate the __DISABLE_EXPORTS infrastructure by checking it from
asm-generic/export.h as well.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 include/asm-generic/export.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/asm-generic/export.h b/include/asm-generic/export.h
index 365345f9a9e3..07a36a874dca 100644
--- a/include/asm-generic/export.h
+++ b/include/asm-generic/export.h
@@ -33,7 +33,7 @@
  */
 
 .macro ___EXPORT_SYMBOL name,val,sec
-#ifdef CONFIG_MODULES
+#if defined(CONFIG_MODULES) && !defined(__DISABLE_EXPORTS)
 	.section ___ksymtab\sec+\name,"a"
 	.balign KSYM_ALIGN
 __ksymtab_\name:
-- 
2.30.0.365.g02bc693789-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
