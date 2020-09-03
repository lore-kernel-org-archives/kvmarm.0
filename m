Return-Path: <SRS0=ROvZ=CM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2134BC43461
	for <kvmarm@archiver.kernel.org>; Thu,  3 Sep 2020 13:53:48 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B8E912098B
	for <kvmarm@archiver.kernel.org>; Thu,  3 Sep 2020 13:53:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="dw6VWu9e"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B8E912098B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 647F64B31D;
	Thu,  3 Sep 2020 09:53:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xjg5lLFRpmmx; Thu,  3 Sep 2020 09:53:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 793524B2FC;
	Thu,  3 Sep 2020 09:53:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D74084B2FB
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Sep 2020 09:53:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EuVgIKGi8bAK for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Sep 2020 09:53:43 -0400 (EDT)
Received: from mail-qv1-f73.google.com (mail-qv1-f73.google.com
 [209.85.219.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DE8294B2AF
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Sep 2020 09:53:43 -0400 (EDT)
Received: by mail-qv1-f73.google.com with SMTP id y32so1881931qve.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 03 Sep 2020 06:53:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=8tun+mNUouTN1gi05pQv0+5fko5re9VKERyIyBMpl10=;
 b=dw6VWu9ebKXKWqq3fPYyUjJFAFbdkjKJ8Ytc9InKLnLfvALeugKsL/vlecuCO3XeHE
 wRZCKv+oSOAMdAGo+W6RvjY/FS7zXbywxPnblTM2qIiR4cZNyGkl0D5NhOQ2SkxGVoFn
 2i0Q8u1u9b5tuzYWK6UpLg/eWkDOm8WkR/uIYmqoqwtq4jXJbzqeWtbUJTyr4W1l1QGU
 SkXFKbAh16zKLBfEuqaScgXBnW/2U0Ma91wPiu/w0ZbNw/jy0Y9NeQLAlxMzwqJINpXk
 jirT3TyG7j04UbIWaTQY4zIHndgXrCT5N9hvIdKo0zk8ZIzpPef8C5VkUew77bpAY4hg
 MhBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=8tun+mNUouTN1gi05pQv0+5fko5re9VKERyIyBMpl10=;
 b=C0sFCRy8bGANlRBhPVtrRPQka/SI9UMi1HMr+2Iq0g8NlE8OWfzWQgRQCeyma0VySs
 dUQhOD9bIU76GZH56F1N6qS5YEkLEDCXZ7j6262ovjtn7Rm6r2RPN6Pu2B3Ct0d1jF4Y
 x7agb+D9tmkDPuAimEVsi9NgZ7QXytRBFCg+tGQ5DTmW3p97HOTImdBUXUJ7Cy8rKk3r
 MQGAZiiz6gqhMOtphQNXLHaHay/+219kFY/grtzIkB0nthCc4rl+RGbc2FXx+kCWyzK0
 qJcJfyw+dbPl0zelbDDtXqVDLy+uzjDsXz4ffD5IQBDdT7wlLikiPf0NYCw4SnNbpUvO
 CWmg==
X-Gm-Message-State: AOAM532tNlhjiMaWyM6mcp08T6a/u8nX+DZEImpdO18eBRBe6lAVb5gf
 FinbWMr/eGZ+At4sJXC6KVnCyj7pgeLgEMS0bUmzF52yrZq4DgVLmsej54qq1YG4Wrs3oZKQCo7
 /uDeOCBuJAXygzBvJT8/Xs0X4radtwnRfXLcGNbrzZqgqSJca/+sj17b1lLrajO5qW99/ww==
X-Google-Smtp-Source: ABdhPJx+4w9R7rTpAdHDa+2P8yo/me/0lKUZwjHaFi6O27rkEcpudYYqEBfyZiyTwHgX6y8wNl/xEi8FyvI=
X-Received: from ascull.lon.corp.google.com
 ([2a00:79e0:d:109:4a0f:cfff:fe4a:6363])
 (user=ascull job=sendgmr) by 2002:a0c:f48e:: with SMTP id
 i14mr1950105qvm.5.1599141223418; 
 Thu, 03 Sep 2020 06:53:43 -0700 (PDT)
Date: Thu,  3 Sep 2020 14:53:03 +0100
In-Reply-To: <20200903135307.251331-1-ascull@google.com>
Message-Id: <20200903135307.251331-15-ascull@google.com>
Mime-Version: 1.0
References: <20200903135307.251331-1-ascull@google.com>
X-Mailer: git-send-email 2.28.0.402.g5ffc5be6b7-goog
Subject: [PATCH v3 14/18] smccc: Cast arguments to unsigned long
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
2.28.0.402.g5ffc5be6b7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
