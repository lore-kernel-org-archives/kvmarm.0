Return-Path: <SRS0=e8ws=CY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F6E5C433E2
	for <kvmarm@archiver.kernel.org>; Tue, 15 Sep 2020 10:47:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0BA7121D1B
	for <kvmarm@archiver.kernel.org>; Tue, 15 Sep 2020 10:47:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="mzUfsmOO"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0BA7121D1B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A09634B326;
	Tue, 15 Sep 2020 06:47:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ugPYTlGr+9kW; Tue, 15 Sep 2020 06:47:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 581344B26B;
	Tue, 15 Sep 2020 06:47:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7C3D44B36B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Sep 2020 06:47:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Rc91aolBgK55 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Sep 2020 06:47:26 -0400 (EDT)
Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com
 [209.85.218.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C78D64B311
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Sep 2020 06:47:25 -0400 (EDT)
Received: by mail-ej1-f74.google.com with SMTP id rs9so1096629ejb.17
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Sep 2020 03:47:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=wRvrs6fwcydRc9QNhv9RPThs32baNM1uIQAOVYlOX8w=;
 b=mzUfsmOOQ9OxnVni1wjl8PKL+MLcClpMNy23Adl2mNKxGhESvDbWkzkpV5QHmToqB1
 fOpj8SJfjr7xG78c5YjXUwur6PG7afFqY1G8lYIeafgEMgQJmtYgyUtefIsjMUWz5Ywn
 Wbg0YNlx/ocySYvpNb2chfGn67QHhuk4eKU51BYQxj10jt45CSMUAs6A/pv7D5uax4dA
 s9fDIueQIC5HOowRHLC+4dyjM2cgOaA0BK2oRi2MQMCU8dpIY8wMpM+6l1njmhfiB2Om
 CLkRBWTBZkB5e/9H54wEUKSx22CHKJ/S8rkLSs1tHLqe/7X0Mz79V44W41IQ1ivPMS+S
 +7pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=wRvrs6fwcydRc9QNhv9RPThs32baNM1uIQAOVYlOX8w=;
 b=YInOXP5Ix5XWPRgSVfhg0QR5hW+IIsPKeXA0TAGlBmy5o0doZ0fKNtHOHdhT7VNYDH
 R5DMuBfmFvbXD29CTPJpV24v3NhlnV9soc75jHIy3ovF28h19JuIRCoODa1tGStXAhSu
 t8biq8V2e7wbjk6AY3z18oB4hbIZyQz+Q4gh6315sCcnCZxemC0EHb5L/ffSUBbskACG
 EgVMvkfqSDxjSylhOZCX1v+ileeb7nj326QnQ5LVGVFuky/EqxP6dk17Y0bFO5PDwVtJ
 xSsyJQ7Ucsrs/B32DgPozurngwftsGocfnx+fdInjOIZmGAFqx+xHuZ7pCyio0ZqR29f
 EbjA==
X-Gm-Message-State: AOAM532XvAA+PsXrk0WOQ5HCpkb4d8Y3jrQVTKV5OxR96r+BgICCsZON
 fcKQWak+jwZxywrvJYpZB63CFZdb0PYnwT75dAUqCvP0kzEG1D5CH/bcilKvLfKAO2JU0e4hj8I
 6fA3ZElUylWeCyhXCPlibvcViwZUoHGWkMfTFrN3+RluYDyWJ8Afka661MGU+ktjEeHf4PQ==
X-Google-Smtp-Source: ABdhPJx2M709kx9dizCAt/PRIu8b78WhnvWZOi8C8MMqypg2G0hWwIgBvzbHBeVkgyFUhF4qEyQmabI2zq0=
X-Received: from ascull.lon.corp.google.com
 ([2a00:79e0:d:109:4a0f:cfff:fe4a:6363])
 (user=ascull job=sendgmr) by 2002:a17:906:2c01:: with SMTP id
 e1mr19740798ejh.128.1600166844783; Tue, 15 Sep 2020 03:47:24 -0700 (PDT)
Date: Tue, 15 Sep 2020 11:46:40 +0100
In-Reply-To: <20200915104643.2543892-1-ascull@google.com>
Message-Id: <20200915104643.2543892-17-ascull@google.com>
Mime-Version: 1.0
References: <20200915104643.2543892-1-ascull@google.com>
X-Mailer: git-send-email 2.28.0.618.gf4bc123cb7-goog
Subject: [PATCH v4 16/19] smccc: Use separate variables for args and results
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

Using the same register-bound variable for both arguments and results
means these values share a type. That type must allow the arguments to
be assigned to it and must also be assignable to the unsigned long
fields of struct arm_smccc_res.

This restriction on types causes compiler warnings when the argument
cannot be implicitly assigned to an unsigned long, for example the
pointers that are used in the KVM hyp interface.

By separating the arguments and results into their own variables, the
type constraint is lifted allowing the arguments to avoid the need for
any type conversion.

Cc: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Andrew Scull <ascull@google.com>
---
 include/linux/arm-smccc.h | 73 ++++++++++++++++-----------------------
 1 file changed, 29 insertions(+), 44 deletions(-)

diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
index ee286f5de239..885c9ffc835c 100644
--- a/include/linux/arm-smccc.h
+++ b/include/linux/arm-smccc.h
@@ -228,87 +228,67 @@ asmlinkage void __arm_smccc_hvc(unsigned long a0, unsigned long a1,
 #define __count_args(...)						\
 	___count_args(__VA_ARGS__, 7, 6, 5, 4, 3, 2, 1, 0)
 
-#define __constraint_write_0						\
-	"+r" (r0), "=&r" (r1), "=&r" (r2), "=&r" (r3)
-#define __constraint_write_1						\
-	"+r" (r0), "+r" (r1), "=&r" (r2), "=&r" (r3)
-#define __constraint_write_2						\
-	"+r" (r0), "+r" (r1), "+r" (r2), "=&r" (r3)
-#define __constraint_write_3						\
-	"+r" (r0), "+r" (r1), "+r" (r2), "+r" (r3)
-#define __constraint_write_4	__constraint_write_3
-#define __constraint_write_5	__constraint_write_4
-#define __constraint_write_6	__constraint_write_5
-#define __constraint_write_7	__constraint_write_6
-
-#define __constraint_read_0
-#define __constraint_read_1
-#define __constraint_read_2
-#define __constraint_read_3
-#define __constraint_read_4	"r" (r4)
-#define __constraint_read_5	__constraint_read_4, "r" (r5)
-#define __constraint_read_6	__constraint_read_5, "r" (r6)
-#define __constraint_read_7	__constraint_read_6, "r" (r7)
+#define __constraint_read_0	"r" (arg0)
+#define __constraint_read_1	__constraint_read_0, "r" (arg1)
+#define __constraint_read_2	__constraint_read_1, "r" (arg2)
+#define __constraint_read_3	__constraint_read_2, "r" (arg3)
+#define __constraint_read_4	__constraint_read_3, "r" (arg4)
+#define __constraint_read_5	__constraint_read_4, "r" (arg5)
+#define __constraint_read_6	__constraint_read_5, "r" (arg6)
+#define __constraint_read_7	__constraint_read_6, "r" (arg7)
 
 #define __declare_arg_0(a0, res)					\
 	struct arm_smccc_res   *___res = res;				\
-	register unsigned long r0 asm("r0") = (u32)a0;			\
-	register unsigned long r1 asm("r1");				\
-	register unsigned long r2 asm("r2");				\
-	register unsigned long r3 asm("r3")
+	register unsigned long arg0 asm("r0") = (u32)a0
 
 #define __declare_arg_1(a0, a1, res)					\
 	typeof(a1) __a1 = a1;						\
 	struct arm_smccc_res   *___res = res;				\
-	register unsigned long r0 asm("r0") = (u32)a0;			\
-	register unsigned long r1 asm("r1") = __a1;			\
-	register unsigned long r2 asm("r2");				\
-	register unsigned long r3 asm("r3")
+	register unsigned long arg0 asm("r0") = (u32)a0;			\
+	register typeof(a1) arg1 asm("r1") = __a1
 
 #define __declare_arg_2(a0, a1, a2, res)				\
 	typeof(a1) __a1 = a1;						\
 	typeof(a2) __a2 = a2;						\
 	struct arm_smccc_res   *___res = res;				\
-	register unsigned long r0 asm("r0") = (u32)a0;			\
-	register unsigned long r1 asm("r1") = __a1;			\
-	register unsigned long r2 asm("r2") = __a2;			\
-	register unsigned long r3 asm("r3")
+	register unsigned long arg0 asm("r0") = (u32)a0;			\
+	register typeof(a1) arg1 asm("r1") = __a1;			\
+	register typeof(a2) arg2 asm("r2") = __a2
 
 #define __declare_arg_3(a0, a1, a2, a3, res)				\
 	typeof(a1) __a1 = a1;						\
 	typeof(a2) __a2 = a2;						\
 	typeof(a3) __a3 = a3;						\
 	struct arm_smccc_res   *___res = res;				\
-	register unsigned long r0 asm("r0") = (u32)a0;			\
-	register unsigned long r1 asm("r1") = __a1;			\
-	register unsigned long r2 asm("r2") = __a2;			\
-	register unsigned long r3 asm("r3") = __a3
+	register unsigned long arg0 asm("r0") = (u32)a0;			\
+	register typeof(a1) arg1 asm("r1") = __a1;			\
+	register typeof(a2) arg2 asm("r2") = __a2;			\
+	register typeof(a3) arg3 asm("r3") = __a3
 
 #define __declare_arg_4(a0, a1, a2, a3, a4, res)			\
 	typeof(a4) __a4 = a4;						\
 	__declare_arg_3(a0, a1, a2, a3, res);				\
-	register unsigned long r4 asm("r4") = __a4
+	register typeof(a4) arg4 asm("r4") = __a4
 
 #define __declare_arg_5(a0, a1, a2, a3, a4, a5, res)			\
 	typeof(a5) __a5 = a5;						\
 	__declare_arg_4(a0, a1, a2, a3, a4, res);			\
-	register unsigned long r5 asm("r5") = __a5
+	register typeof(a5) arg5 asm("r5") = __a5
 
 #define __declare_arg_6(a0, a1, a2, a3, a4, a5, a6, res)		\
 	typeof(a6) __a6 = a6;						\
 	__declare_arg_5(a0, a1, a2, a3, a4, a5, res);			\
-	register unsigned long r6 asm("r6") = __a6
+	register typeof(a6) arg6 asm("r6") = __a6
 
 #define __declare_arg_7(a0, a1, a2, a3, a4, a5, a6, a7, res)		\
 	typeof(a7) __a7 = a7;						\
 	__declare_arg_6(a0, a1, a2, a3, a4, a5, a6, res);		\
-	register unsigned long r7 asm("r7") = __a7
+	register typeof(a7) arg7 asm("r7") = __a7
 
 #define ___declare_args(count, ...) __declare_arg_ ## count(__VA_ARGS__)
 #define __declare_args(count, ...)  ___declare_args(count, __VA_ARGS__)
 
 #define ___constraints(count)						\
-	: __constraint_write_ ## count					\
 	: __constraint_read_ ## count					\
 	: "memory"
 #define __constraints(count)	___constraints(count)
@@ -320,8 +300,13 @@ asmlinkage void __arm_smccc_hvc(unsigned long a0, unsigned long a1,
  */
 #define __arm_smccc_1_1(inst, ...)					\
 	do {								\
+		register unsigned long r0 asm("r0");			\
+		register unsigned long r1 asm("r1");			\
+		register unsigned long r2 asm("r2");			\
+		register unsigned long r3 asm("r3"); 			\
 		__declare_args(__count_args(__VA_ARGS__), __VA_ARGS__);	\
-		asm volatile(inst "\n"					\
+		asm volatile(inst "\n" :				\
+			     "=r" (r0), "=r" (r1), "=r" (r2), "=r" (r3)	\
 			     __constraints(__count_args(__VA_ARGS__)));	\
 		if (___res)						\
 			*___res = (typeof(*___res)){r0, r1, r2, r3};	\
@@ -367,7 +352,7 @@ asmlinkage void __arm_smccc_hvc(unsigned long a0, unsigned long a1,
 #define __fail_smccc_1_1(...)						\
 	do {								\
 		__declare_args(__count_args(__VA_ARGS__), __VA_ARGS__);	\
-		asm ("" __constraints(__count_args(__VA_ARGS__)));	\
+		asm ("" : __constraints(__count_args(__VA_ARGS__)));	\
 		if (___res)						\
 			___res->a0 = SMCCC_RET_NOT_SUPPORTED;		\
 	} while (0)
-- 
2.28.0.618.gf4bc123cb7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
