Return-Path: <SRS0=c5RA=B6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19038C433E4
	for <kvmarm@archiver.kernel.org>; Thu, 20 Aug 2020 10:35:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C0062208DB
	for <kvmarm@archiver.kernel.org>; Thu, 20 Aug 2020 10:35:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="IgyZYEzu"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C0062208DB
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 794794B87F;
	Thu, 20 Aug 2020 06:35:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id y86IbO-zAkHc; Thu, 20 Aug 2020 06:35:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E53A4B8AC;
	Thu, 20 Aug 2020 06:35:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8DCAC4B86C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Aug 2020 06:35:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NlDQZhFJDcux for <kvmarm@lists.cs.columbia.edu>;
 Thu, 20 Aug 2020 06:35:53 -0400 (EDT)
Received: from mail-qt1-f202.google.com (mail-qt1-f202.google.com
 [209.85.160.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9D2D54B846
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Aug 2020 06:35:53 -0400 (EDT)
Received: by mail-qt1-f202.google.com with SMTP id k1so1204168qtp.20
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Aug 2020 03:35:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=De2u0bV2GogYbtm1LXjkVrsgQ3fRStNYWnnD7ykdEO8=;
 b=IgyZYEzu6m5N5E/s+L0cBVWU8T9z1/S+18rqxb3KcMHdRIy/T4HVCQnwl4fQYwAMLN
 TNpuALWS3HPzvd0VXr+noXvLjGQyGgGw9nTQSvqzLpvxCnpbtdBiJgxpaKnJtSun4Vy5
 C6v/gWp8ZB9OSw1VmROMtpISLb59IQdtnuAKflAKmi50ZQQRpB8k3G4qsvXq/3JWWz/Q
 H/lteN5i7mMAxCk5bHcIcd8eMleGgWWfZvj8zRax2p1XkQMBmM1bnBGCC4xiiu0nMvoZ
 NwUcEblagPkGd9lSTRjXL47wXxuIfeAzW2BV2fy3BfQ+mgdXanBOtIOM7SuEYOJJlnYH
 lgwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=De2u0bV2GogYbtm1LXjkVrsgQ3fRStNYWnnD7ykdEO8=;
 b=U+p9o73Mn3f1lp4x2AeAgp6zaDX3AmsE96OE/gnkhqm/SkpMkKs9786rWIW3jwIbX2
 d0mQg48U5nO7G4SzBd7X6qUWNzzOatNF7Jv+/AZ4Q9LrjaLYOLDWrkhXUXAVSSO9pWsa
 Vvgn33ClHzKNJCA/b841M8DA8e1ryXOk+VVO3q0l9YISkcfwhU2qHQgMVqzD1Y0nAjPk
 OjQ8U4iyCO6+oaAqrzf0x9lw/YW4H5hYZlSQEpRiv7Q97H56eI2mkzSikEc6tjscTzTI
 JnpuRGViA9bbepEzIRxp9yAP4JW5UTxo5DDl8EOYI3bW/WvaLPTfGprPiYCajAyky8t5
 TLdg==
X-Gm-Message-State: AOAM5328U+n6R4PK9p1qdC7xrHNpKDo3RcO8jaG2iUaAgc7uA4qHS8SS
 MANd6E9YiwJMOfZubGkMQPfyGpJEk+3zAYAdh14REkgvvXn6et6nzYUmWCEw0KncsACcxCgaqP3
 mZ0mAU/8Ls75IsW+QjqinZNy8dVoFgKgJ6CYD4dK2ziQbcjBOUPZ+KBV9nzLQ403IPO/m2A==
X-Google-Smtp-Source: ABdhPJw95GGCqhcbH4OcN4yC26A4qp01f24vi1RX/WBqJzH0ZmbWMifY5bHCqOD+Bnrya9RHbCkHZ+I4wF0=
X-Received: from ascull.lon.corp.google.com
 ([2a00:79e0:d:109:4a0f:cfff:fe4a:6363])
 (user=ascull job=sendgmr) by 2002:a0c:ea8e:: with SMTP id
 d14mr2229441qvp.37.1597919753110; 
 Thu, 20 Aug 2020 03:35:53 -0700 (PDT)
Date: Thu, 20 Aug 2020 11:34:41 +0100
In-Reply-To: <20200820103446.959000-1-ascull@google.com>
Message-Id: <20200820103446.959000-16-ascull@google.com>
Mime-Version: 1.0
References: <20200820103446.959000-1-ascull@google.com>
X-Mailer: git-send-email 2.28.0.220.ged08abb693-goog
Subject: [PATCH v2 15/20] smccc: Cast arguments to unsigned long
From: Andrew Scull <ascull@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
 maz@kernel.org, Sudeep Holla <sudeep.holla@arm.com>, catalin.marinas@arm.com,
 will@kernel.org
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
allows, for example, pointers to be used as arguments as are used in the
KVM hyp interface.

Cc: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Andrew Scull <ascull@google.com>
---
 include/linux/arm-smccc.h | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
index 15c706fb0a37..3bb109a35554 100644
--- a/include/linux/arm-smccc.h
+++ b/include/linux/arm-smccc.h
@@ -260,7 +260,7 @@ asmlinkage void __arm_smccc_hvc(unsigned long a0, unsigned long a1,
 	typeof(a1) __a1 = a1;						\
 	struct arm_smccc_res   *___res = res;				\
 	register unsigned long r0 asm("r0") = (u32)a0;			\
-	register unsigned long r1 asm("r1") = __a1;			\
+	register unsigned long r1 asm("r1") = (unsigned long)__a1;	\
 	register unsigned long r2 asm("r2");				\
 	register unsigned long r3 asm("r3")
 
@@ -269,8 +269,8 @@ asmlinkage void __arm_smccc_hvc(unsigned long a0, unsigned long a1,
 	typeof(a2) __a2 = a2;						\
 	struct arm_smccc_res   *___res = res;				\
 	register unsigned long r0 asm("r0") = (u32)a0;			\
-	register unsigned long r1 asm("r1") = __a1;			\
-	register unsigned long r2 asm("r2") = __a2;			\
+	register unsigned long r1 asm("r1") = (unsigned long)__a1;	\
+	register unsigned long r2 asm("r2") = (unsigned long)__a2;	\
 	register unsigned long r3 asm("r3")
 
 #define __declare_arg_3(a0, a1, a2, a3, res)				\
@@ -279,29 +279,29 @@ asmlinkage void __arm_smccc_hvc(unsigned long a0, unsigned long a1,
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
2.28.0.220.ged08abb693-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
