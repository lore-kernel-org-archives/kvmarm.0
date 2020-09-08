Return-Path: <SRS0=B0kT=CR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FSL_HELO_FAKE,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D268DC433E2
	for <kvmarm@archiver.kernel.org>; Tue,  8 Sep 2020 10:58:39 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4E0A92145D
	for <kvmarm@archiver.kernel.org>; Tue,  8 Sep 2020 10:58:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="sHbw6Nvd"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4E0A92145D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 800EE4B5CA;
	Tue,  8 Sep 2020 06:58:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZKVErIcKVO4x; Tue,  8 Sep 2020 06:58:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1D33F4B552;
	Tue,  8 Sep 2020 06:58:37 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 033324B4AA
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Sep 2020 06:58:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6MGd5vJP7efj for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Sep 2020 06:58:34 -0400 (EDT)
Received: from mail-wm1-f68.google.com (mail-wm1-f68.google.com
 [209.85.128.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8DE7E4B449
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Sep 2020 06:58:34 -0400 (EDT)
Received: by mail-wm1-f68.google.com with SMTP id a65so16808934wme.5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 08 Sep 2020 03:58:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=oiX/oq3sff2FSsOhr/y5XYYfYJ1hXTZbf0oJMFFbL0s=;
 b=sHbw6NvdM10UYQXdsqWvIiBhktnKPjcWySoL+gcnrv7awm0NvQSvTlvhX6VXMo4LcS
 OsD6xNUA/GBcNRs8zmPeWhGNNK3Zb4YHOVGHkUfMxviv9QNgpT4tbDINY7GegIjMpPsT
 XpmtE8SH8cBLkkFjVP+2ReSKKb2Fn13FEt5tjwmVEuyH3nSbGesSjIZhNbBe7DroDDCO
 kYh56eolEUczRWqBM++0fH030nWumdQdohYnFbF8WrnAr+K8VVK7DaZcGNBkIAtCwCX6
 LGWbeFGMDt/tJLijMn2kMTGUTz5XmSYl7eoy/qBiWlT5BtiP9G+ibJSDdr0FfNGZdHpQ
 hR0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=oiX/oq3sff2FSsOhr/y5XYYfYJ1hXTZbf0oJMFFbL0s=;
 b=dtOBBqghmwFmGpZUYtJogjebo6+VNGrtSJLir5KVfxXUFxSIOTmSuSTh9T2dx6HwM+
 zFPajPCgnzl84iaPGzBOceO/d+jSIc6p+6EZrA7OrspaZQRnYs2dKzIaFkOHqsa49QWD
 NqQ39JhgYaC9xjEVs3nV7gYvYe6Q7k1r2Cptj5tsSjYNHvM8lOAYK0dmSJiKkKy9BeTt
 7sE5/xNVns40ubbszdu44kMYFoHZNR2hxPVl5RLMriMPNmbVilXtEopJiDoRJuLbLQPV
 /qtcPXAxQ9bfTznjaleuq0+BxonuHu/R7WhaW1irUDyafOSdZe2kA7uUfdBLC8Zsh6NK
 tNvw==
X-Gm-Message-State: AOAM530LOo2R6hH/yE+LqPalWUEadNL6SKqHLXZV7+DcUhXk9XMV9hNE
 zm5dytDrPgVU5bqywGRXlwTKTA==
X-Google-Smtp-Source: ABdhPJzMyKcrKoHGWz/jIoML5ApLG1Bc896e0XAl1OrlAOAs6ts/S3ZgOxnKlDQ3HpIgxtgIlNe3lw==
X-Received: by 2002:a7b:c92b:: with SMTP id h11mr3777972wml.6.1599562713371;
 Tue, 08 Sep 2020 03:58:33 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:109:4a0f:cfff:fe4a:6363])
 by smtp.gmail.com with ESMTPSA id f1sm32650052wrt.20.2020.09.08.03.58.32
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 08 Sep 2020 03:58:32 -0700 (PDT)
Date: Tue, 8 Sep 2020 11:58:28 +0100
From: Andrew Scull <ascull@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v3 14/18] smccc: Cast arguments to unsigned long
Message-ID: <20200908105828.GE3268721@google.com>
References: <20200903135307.251331-1-ascull@google.com>
 <20200903135307.251331-15-ascull@google.com>
 <87r1rdlnj6.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87r1rdlnj6.wl-maz@kernel.org>
Cc: kernel-team@android.com, catalin.marinas@arm.com,
 linux-arm-kernel@lists.infradead.org, Sudeep Holla <sudeep.holla@arm.com>,
 will@kernel.org, kvmarm@lists.cs.columbia.edu
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

On Mon, Sep 07, 2020 at 02:33:17PM +0100, Marc Zyngier wrote:
> On Thu, 03 Sep 2020 14:53:03 +0100,
> Andrew Scull <ascull@google.com> wrote:
> > 
> > To avoid warning about implicit casting, make the casting explicit. This
> > allows, for example, pointers to be used as arguments as are used in the
> > KVM hyp interface.
> > 
> > Cc: Sudeep Holla <sudeep.holla@arm.com>
> > Signed-off-by: Andrew Scull <ascull@google.com>
> > ---
> >  include/linux/arm-smccc.h | 20 ++++++++++----------
> >  1 file changed, 10 insertions(+), 10 deletions(-)
> > 
> > diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
> > index 15c706fb0a37..3bb109a35554 100644
> > --- a/include/linux/arm-smccc.h
> > +++ b/include/linux/arm-smccc.h
> > @@ -260,7 +260,7 @@ asmlinkage void __arm_smccc_hvc(unsigned long a0, unsigned long a1,
> >  	typeof(a1) __a1 = a1;						\
> >  	struct arm_smccc_res   *___res = res;				\
> >  	register unsigned long r0 asm("r0") = (u32)a0;			\
> > -	register unsigned long r1 asm("r1") = __a1;			\
> > +	register unsigned long r1 asm("r1") = (unsigned long)__a1;	\
> 
> Given the pain we go through to extract the type of each argument, it
> seems odd to end-up with casts everywhere. I'd rather keep the type
> system alive by having:
> 
> 	register typeof(a1) r1 asm("r1") = __a1;
> 
> Is there any reason why this doesn't work?

There is. r1 is used both for the argument and the result so if
typeof(a1) cannot be implicitly assigned to unsigned long you'll get a
warning when populating arm_smccc_res.

The approach in this patch made the removal of types explicit with a
case rather then implicit in the assignment.

I had a go at breaking the link between the inputs and outputs. I've
replaced this patch with the following for the time being.


commit 16fd4f7d3c12e94f96f77c43491fbfe80417f27b
Author: Andrew Scull <ascull@google.com>
Date:   Wed Jun 3 10:28:23 2020 +0100

    smccc: Use separate variables for args and results
    
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

diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
index 15c706fb0a37..4fe089ff2704 100644
--- a/include/linux/arm-smccc.h
+++ b/include/linux/arm-smccc.h
@@ -227,87 +227,67 @@ asmlinkage void __arm_smccc_hvc(unsigned long a0, unsigned long a1,
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
@@ -319,8 +299,13 @@ asmlinkage void __arm_smccc_hvc(unsigned long a0, unsigned long a1,
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
@@ -366,7 +351,7 @@ asmlinkage void __arm_smccc_hvc(unsigned long a0, unsigned long a1,
 #define __fail_smccc_1_1(...)						\
 	do {								\
 		__declare_args(__count_args(__VA_ARGS__), __VA_ARGS__);	\
-		asm ("" __constraints(__count_args(__VA_ARGS__)));	\
+		asm ("" : __constraints(__count_args(__VA_ARGS__)));	\
 		if (___res)						\
 			___res->a0 = SMCCC_RET_NOT_SUPPORTED;		\
 	} while (0)
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
