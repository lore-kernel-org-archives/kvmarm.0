Return-Path: <SRS0=T00w=A2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABB1DC433E6
	for <kvmarm@archiver.kernel.org>; Wed, 15 Jul 2020 18:44:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6C0E620672
	for <kvmarm@archiver.kernel.org>; Wed, 15 Jul 2020 18:44:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="kEJUXUd4"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6C0E620672
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 253A84B3C6;
	Wed, 15 Jul 2020 14:44:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HPjN5AuVLfY9; Wed, 15 Jul 2020 14:44:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2D5A14B3AC;
	Wed, 15 Jul 2020 14:44:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E42B4B3B2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2020 14:44:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BA8tRhWMXngz for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 Jul 2020 14:44:51 -0400 (EDT)
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com
 [209.85.221.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 39CAE4B318
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2020 14:44:51 -0400 (EDT)
Received: by mail-wr1-f74.google.com with SMTP id d11so1958601wrw.12
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2020 11:44:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=CxbJHBcHZru0xFqw3l0boR0IICd3yNXkAPCLVGR4CDQ=;
 b=kEJUXUd45JplO4wfvQsZ4cF5Q8SFdepEeLIJ353u5JpKcpud/Blhb3wEwbkbqT3WhL
 R25Sy0AX7mBD42azFk5d9HCcN7Ysfpig8wMKsEwnENsErxqia0cVpOUzKN9yQJ/zj0Vg
 9TDlKBqPs/FZeEDglFuKMYPjhpteXkgAVkseGUgxC0FA7gTn7bOEzu5n5VaAwlH5oWCF
 aSpRglZZ9epbxQzE/OT5wL4+XuND35ONnz9NHVfxDq5uNY85aXVBK+QgrpPpj1+tCu14
 I6tbcb0J+Fyd3iJZKikZEgLQTj53prsxdPI/tyVLq0Dll+0Ij4diKbVqnQmKrheuViT3
 1wvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=CxbJHBcHZru0xFqw3l0boR0IICd3yNXkAPCLVGR4CDQ=;
 b=rAMb3mT7e28+ysgLSH5ciFRno2+K+CJW1HRyjssMcrMS0NQ6s6rNXRsXzn7yVApsfh
 z9boQDDCvhSZA/er3gdJq4gGIRWijHrwC3tIkDUk9pnwfSJ2wciU47qxVPDa5qhVN+hq
 4ySCFbg7U/KdttS142vfpnMRmre35xIisl72UTF8uCFlYSZoLYkn/f5uCnTeqIiaPfB1
 4Rc6Ml32giSrME2/Jb5Te/mw1mJToa8cN4rccR12h2pDkwMsXQMFdng9eM6EUn9z+rQZ
 VsR5Vx45pn5cXDXEYncmihAlLixC77so0JPcXaXmptMrI1x6mOIFF51tLfz6Zx6/aGbs
 EsMw==
X-Gm-Message-State: AOAM530/hctRhVtjPL7SOHZwikz6GMuhVzrcn3CK8NzBm4ki9dYmAKZ/
 Zty6sx9lewXVx3pvDsDxpeQYNKWbEpb9YOCZegV9PSPJhN+V9QS7va2qnBvMy6FP1tT4lZhL7B3
 rVyOflE0LCCtZ1nfN3db1W24c9Zn9PrcJyRQBsrIfgI0mQIziZTD7jfB9WsJr/K3chxoo7w==
X-Google-Smtp-Source: ABdhPJz1hHVZZeLjlkQlwLOQoWgRvtKcaOmXop9RnXWR0L3GEqMYXCou8dx3a34+rftgEMURKrvWLVQDtNs=
X-Received: by 2002:a1c:408b:: with SMTP id n133mr768108wma.88.1594838690385; 
 Wed, 15 Jul 2020 11:44:50 -0700 (PDT)
Date: Wed, 15 Jul 2020 19:44:02 +0100
In-Reply-To: <20200715184438.1390996-1-ascull@google.com>
Message-Id: <20200715184438.1390996-2-ascull@google.com>
Mime-Version: 1.0
References: <20200715184438.1390996-1-ascull@google.com>
X-Mailer: git-send-email 2.27.0.389.gc38d7665816-goog
Subject: [PATCH 01/37] smccc: Make constants available to assembly
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

These do no need to be restricted only to C code so move them out next
to the other constants in the file.

Signed-off-by: Andrew Scull <ascull@google.com>
---
 include/linux/arm-smccc.h | 44 +++++++++++++++++++--------------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
index 56d6a5c6e353..efcbde731f03 100644
--- a/include/linux/arm-smccc.h
+++ b/include/linux/arm-smccc.h
@@ -81,6 +81,28 @@
 			   ARM_SMCCC_SMC_32,				\
 			   0, 0x7fff)
 
+/* Paravirtualised time calls (defined by ARM DEN0057A) */
+#define ARM_SMCCC_HV_PV_TIME_FEATURES				\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,			\
+			   ARM_SMCCC_SMC_64,			\
+			   ARM_SMCCC_OWNER_STANDARD_HYP,	\
+			   0x20)
+
+#define ARM_SMCCC_HV_PV_TIME_ST					\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,			\
+			   ARM_SMCCC_SMC_64,			\
+			   ARM_SMCCC_OWNER_STANDARD_HYP,	\
+			   0x21)
+
+/*
+ * Return codes defined in ARM DEN 0070A
+ * ARM DEN 0070A is now merged/consolidated into ARM DEN 0028 C
+ */
+#define SMCCC_RET_SUCCESS			0
+#define SMCCC_RET_NOT_SUPPORTED			-1
+#define SMCCC_RET_NOT_REQUIRED			-2
+#define SMCCC_RET_INVALID_PARAMETER		-3
+
 #ifndef __ASSEMBLY__
 
 #include <linux/linkage.h>
@@ -331,15 +353,6 @@ asmlinkage void __arm_smccc_hvc(unsigned long a0, unsigned long a1,
  */
 #define arm_smccc_1_1_hvc(...)	__arm_smccc_1_1(SMCCC_HVC_INST, __VA_ARGS__)
 
-/*
- * Return codes defined in ARM DEN 0070A
- * ARM DEN 0070A is now merged/consolidated into ARM DEN 0028 C
- */
-#define SMCCC_RET_SUCCESS			0
-#define SMCCC_RET_NOT_SUPPORTED			-1
-#define SMCCC_RET_NOT_REQUIRED			-2
-#define SMCCC_RET_INVALID_PARAMETER		-3
-
 /*
  * Like arm_smccc_1_1* but always returns SMCCC_RET_NOT_SUPPORTED.
  * Used when the SMCCC conduit is not defined. The empty asm statement
@@ -385,18 +398,5 @@ asmlinkage void __arm_smccc_hvc(unsigned long a0, unsigned long a1,
 		method;							\
 	})
 
-/* Paravirtualised time calls (defined by ARM DEN0057A) */
-#define ARM_SMCCC_HV_PV_TIME_FEATURES				\
-	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,			\
-			   ARM_SMCCC_SMC_64,			\
-			   ARM_SMCCC_OWNER_STANDARD_HYP,	\
-			   0x20)
-
-#define ARM_SMCCC_HV_PV_TIME_ST					\
-	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,			\
-			   ARM_SMCCC_SMC_64,			\
-			   ARM_SMCCC_OWNER_STANDARD_HYP,	\
-			   0x21)
-
 #endif /*__ASSEMBLY__*/
 #endif /*__LINUX_ARM_SMCCC_H*/
-- 
2.27.0.389.gc38d7665816-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
