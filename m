Return-Path: <SRS0=T00w=A2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0A6FC433EC
	for <kvmarm@archiver.kernel.org>; Wed, 15 Jul 2020 18:45:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AE6FA2076C
	for <kvmarm@archiver.kernel.org>; Wed, 15 Jul 2020 18:45:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="Y/OFIqLn"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AE6FA2076C
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 67C8F4B3D2;
	Wed, 15 Jul 2020 14:45:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 64u1YMHN1Nf0; Wed, 15 Jul 2020 14:45:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B77F4B3CB;
	Wed, 15 Jul 2020 14:45:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 186704B39D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2020 14:45:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lnTyVnDKPMdz for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 Jul 2020 14:45:09 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D6A8B4B1B2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2020 14:45:08 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id k127so3950253ybk.11
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2020 11:45:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=xof8jRg62OoNjrTd83C39ghcCF1VqbHgu0OFCgbZD/w=;
 b=Y/OFIqLnMiW+Z0EdrlsENECBT+MGvfaanJ9aCBk6YC3xBzv730bYKegje57Sczkxza
 M4acDkVPYZQSg62BxSGzVeYdmHllL0zbiIopbQoYJYk1HZzmGy1OE4ARz1AFG3x3SWIL
 2CNNzLeWniyKcXAFxSQtUfkvATV0qjnQ+8VCb6KvjjC6hQ4z4QIGYA1tFOeiYgXd3h7n
 t1XOWUn5f4eBLSbITdb9hb4x2dNfbidQTr3ZYYxIH8v/hAh2/RKylZEEhT5LO3U63GOE
 TCdawTh1AtlJEqqj+ko5NDz2htvXffCyuWMB/IkqTO+IEiRxgGWDGLv6kbZnCVhs6+o8
 i+FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=xof8jRg62OoNjrTd83C39ghcCF1VqbHgu0OFCgbZD/w=;
 b=KDxnPqh+NrglQhuzMr7pRZqVIVK4VdfOGrdPDFEKKc2nraEK6iwy8BIcfes5HjQdmh
 /GY5TfeKfu8tA2m4XVO645CEEGbBr5zWt3S29BkyNMAIsu5SDmpEga1m/ADRdd8aj8Mf
 u3Jw6eJukiOwSMTLG6trNMUGqdPAqw9oDpfMUMsj+1hQyJJO6g/giWzFlT8PKJhShOi8
 ciQecMLb6XSz66gYV1RTEA1PdwQhwqpfZgpr/kySstmzP95r70fd7mCCEjDVGEPK/z/I
 ITzekWugSy+CdEbMp8oSd9yLUIGaaetAFhAfpjFwVYbZchCRnrRnuVoFlnWO+J48AIq7
 l4Bg==
X-Gm-Message-State: AOAM533uqQN2FMoXCFM0WMnfpzTFIWqdXFtR9WvuS8q8HcygLljw43i/
 MwZFkt0SQehyXj6u1h6dI+eItgUgj8U6FR73BPOpnRNu6SwSTuX3Jq3VUkUZbWs3df2RDGbbOCy
 m5P9/lUe3GByBTSG6PST8tCF189J2hKhJj1cQART0j1qvhGEJcNbXauydxv2xaot3K2liNQ==
X-Google-Smtp-Source: ABdhPJymkchS1ojTwTKDnR+mSfimnVBYzt9+kMMoPRjjkiwOQKijtLhgpWnxi6F4rmd279a6zR8/kX8Ch+U=
X-Received: by 2002:a25:abc5:: with SMTP id v63mr591893ybi.148.1594838708307; 
 Wed, 15 Jul 2020 11:45:08 -0700 (PDT)
Date: Wed, 15 Jul 2020 19:44:10 +0100
In-Reply-To: <20200715184438.1390996-1-ascull@google.com>
Message-Id: <20200715184438.1390996-10-ascull@google.com>
Mime-Version: 1.0
References: <20200715184438.1390996-1-ascull@google.com>
X-Mailer: git-send-email 2.27.0.389.gc38d7665816-goog
Subject: [PATCH 09/37] smccc: Cast arguments to unsigned long
From: Andrew Scull <ascull@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: maz@kernel.org, kernel-team@android.com
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

To avoid warning about implicit casting, make the casting explicit. This
allows, for example, pointers to be used as arguments.

Signed-off-by: Andrew Scull <ascull@google.com>
---
 include/linux/arm-smccc.h | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
index efcbde731f03..905d7744058b 100644
--- a/include/linux/arm-smccc.h
+++ b/include/linux/arm-smccc.h
@@ -255,7 +255,7 @@ asmlinkage void __arm_smccc_hvc(unsigned long a0, unsigned long a1,
 	typeof(a1) __a1 = a1;						\
 	struct arm_smccc_res   *___res = res;				\
 	register unsigned long r0 asm("r0") = (u32)a0;			\
-	register unsigned long r1 asm("r1") = __a1;			\
+	register unsigned long r1 asm("r1") = (unsigned long)__a1;	\
 	register unsigned long r2 asm("r2");				\
 	register unsigned long r3 asm("r3")
 
@@ -264,8 +264,8 @@ asmlinkage void __arm_smccc_hvc(unsigned long a0, unsigned long a1,
 	typeof(a2) __a2 = a2;						\
 	struct arm_smccc_res   *___res = res;				\
 	register unsigned long r0 asm("r0") = (u32)a0;			\
-	register unsigned long r1 asm("r1") = __a1;			\
-	register unsigned long r2 asm("r2") = __a2;			\
+	register unsigned long r1 asm("r1") = (unsigned long)__a1;	\
+	register unsigned long r2 asm("r2") = (unsigned long)__a2;	\
 	register unsigned long r3 asm("r3")
 
 #define __declare_arg_3(a0, a1, a2, a3, res)				\
@@ -274,29 +274,29 @@ asmlinkage void __arm_smccc_hvc(unsigned long a0, unsigned long a1,
 	typeof(a3) __a3 = a3;						\
 	struct arm_smccc_res   *___res = res;				\
 	register unsigned long r0 asm("r0") = (u32)a0;			\
-	register unsigned long r1 asm("r1") = __a1;			\
-	register unsigned long r2 asm("r2") = __a2;			\
-	register unsigned long r3 asm("r3") = __a3
+	register unsigned long r1 asm("r1") = (unsigned long)__a1;	\
+	register unsigned long r2 asm("r2") = (unsigned long)__a2;	\
+	register unsigned long r3 asm("r3") = (unsigned long)__a3
 
 #define __declare_arg_4(a0, a1, a2, a3, a4, res)			\
 	typeof(a4) __a4 = a4;						\
 	__declare_arg_3(a0, a1, a2, a3, res);				\
-	register unsigned long r4 asm("r4") = __a4
+	register unsigned long r4 asm("r4") = (unsigned long)__a4
 
 #define __declare_arg_5(a0, a1, a2, a3, a4, a5, res)			\
 	typeof(a5) __a5 = a5;						\
 	__declare_arg_4(a0, a1, a2, a3, a4, res);			\
-	register unsigned long r5 asm("r5") = __a5
+	register unsigned long r5 asm("r5") = (unsigned long)__a5
 
 #define __declare_arg_6(a0, a1, a2, a3, a4, a5, a6, res)		\
 	typeof(a6) __a6 = a6;						\
 	__declare_arg_5(a0, a1, a2, a3, a4, a5, res);			\
-	register unsigned long r6 asm("r6") = __a6
+	register unsigned long r6 asm("r6") = (unsigned long)__a6
 
 #define __declare_arg_7(a0, a1, a2, a3, a4, a5, a6, a7, res)		\
 	typeof(a7) __a7 = a7;						\
 	__declare_arg_6(a0, a1, a2, a3, a4, a5, a6, res);		\
-	register unsigned long r7 asm("r7") = __a7
+	register unsigned long r7 asm("r7") = (unsigned long)__a7
 
 #define ___declare_args(count, ...) __declare_arg_ ## count(__VA_ARGS__)
 #define __declare_args(count, ...)  ___declare_args(count, __VA_ARGS__)
-- 
2.27.0.389.gc38d7665816-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
