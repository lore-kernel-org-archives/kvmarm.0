Return-Path: <SRS0=4nKG=KI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85CFCC433B4
	for <kvmarm@archiver.kernel.org>; Thu, 13 May 2021 00:28:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CE32961406
	for <kvmarm@archiver.kernel.org>; Thu, 13 May 2021 00:28:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CE32961406
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6148C4B474;
	Wed, 12 May 2021 20:28:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id n5MSPEDIojsP; Wed, 12 May 2021 20:28:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 52C024B544;
	Wed, 12 May 2021 20:28:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4B9D84B84C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 May 2021 20:28:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tlkgarREHe-1 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 12 May 2021 20:28:11 -0400 (EDT)
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com
 [209.85.210.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A59034B378
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 May 2021 20:28:10 -0400 (EDT)
Received: by mail-pf1-f202.google.com with SMTP id
 76-20020a62164f0000b029027f27f50e56so16079333pfw.16
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 May 2021 17:28:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=zxsHwg8ACVNG0gj0HNIoWiAKTaI+aSlQScKBGdMUvH4=;
 b=Unpjke8IQLXkNhIYkxb+SPawwcggozVP0BB7RB6uACCF+nrypeohw8OfYSJSNtlkQU
 JAXsB+ex5idQoDtTDvElLM6Ld1LCY6KmYH78OKz6/UCkNFb3r7xNmiIlHdH7TZWOyFLf
 mnoblhbaqCH9aekNRo+kF0/nFsS8cp/1jafEd6sTbm+shshgc6M/lUubgF7kwzmxg3BV
 Wa7i7w01FM1wPf1doS2Y53EFmSO8Q5kJ8ROKHMjVuVf+iH7tRoP9dYzjC8sogy+YW1s9
 LmwJm0KGZQn0YO8xB2GTlYKHzLN6vCVKLy/GlGj66aokbRSvYYRrIfR5bpTR0YcmbCYO
 RwVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=zxsHwg8ACVNG0gj0HNIoWiAKTaI+aSlQScKBGdMUvH4=;
 b=jOt8IDSwoW19INOI0Trqv7qAbaf3c6Hgo5AwtvZPuFM8TPMTo9qBtD0QU/XFPef+wU
 V3FpnDV3J1XoiCZdOro8no+FswGblzOsOlpMuThCvmn1i7+fkNgk4yjcq1r8Wk1CUyId
 JBmUmrR97LgCCuG3eT/z11CorHRZJtAZUKlvJcTLfr+R9xyrH2BFCebt9dKu26B+g0MB
 Zhdq7EeDdF+DP/OzUPHJW4Nai1MkF1zcE8BQ1/4DXTkXiseqCsuOxSb3ouDxe3SKv6yb
 GgQ0lLLzvLNYp6CxuwVr4UfRWGnKoEvMVp2RUzU+sL/b4H+wcY6XKEAzCBbVWd4GqGUd
 R1Mw==
X-Gm-Message-State: AOAM530GQtyBVF9b5A8W5oPtQCEnC4TmqbU86C0ijmj+Bn4ECpdpbs8I
 rb9bJH3KXKCA4uBY89Q6dhgQv69bRh9CrQ==
X-Google-Smtp-Source: ABdhPJzFm4lOfQYwC9X/y1at01TOWZJErvamhpunfM0O+KbGLvK9yj0IacinPrLxCSbfLxWTUd9LxBKe7NshAQ==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:10:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:90a:bf0c:: with SMTP id
 c12mr40963575pjs.206.1620865689672; Wed, 12 May 2021 17:28:09 -0700 (PDT)
Date: Wed, 12 May 2021 17:28:00 -0700
In-Reply-To: <20210513002802.3671838-1-ricarkol@google.com>
Message-Id: <20210513002802.3671838-4-ricarkol@google.com>
Mime-Version: 1.0
References: <20210513002802.3671838-1-ricarkol@google.com>
X-Mailer: git-send-email 2.31.1.607.g51e8a6a459-goog
Subject: [PATCH v3 3/5] KVM: selftests: Move GUEST_ASSERT_EQ to utils header
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: maz@kernel.org, pbonzini@redhat.com
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

Move GUEST_ASSERT_EQ to a common header, kvm_util.h, for other
architectures and tests to use. Also modify __GUEST_ASSERT so it can be
reused to implement GUEST_ASSERT_EQ.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../testing/selftests/kvm/include/kvm_util.h  | 22 ++++++++++---------
 .../selftests/kvm/x86_64/tsc_msrs_test.c      |  9 --------
 2 files changed, 12 insertions(+), 19 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 7880929ea548..fb2b8964f2ca 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -366,26 +366,28 @@ uint64_t get_ucall(struct kvm_vm *vm, uint32_t vcpu_id, struct ucall *uc);
 				ucall(UCALL_SYNC, 6, "hello", stage, arg1, arg2, arg3, arg4)
 #define GUEST_SYNC(stage)	ucall(UCALL_SYNC, 2, "hello", stage)
 #define GUEST_DONE()		ucall(UCALL_DONE, 0)
-#define __GUEST_ASSERT(_condition, _nargs, _args...) do {	\
-	if (!(_condition))					\
-		ucall(UCALL_ABORT, 2 + _nargs,			\
-			"Failed guest assert: "			\
-			#_condition, __LINE__, _args);		\
+#define __GUEST_ASSERT(_condition, _condstr, _nargs, _args...) do {    \
+	if (!(_condition))                                              \
+		ucall(UCALL_ABORT, 2 + _nargs,                          \
+			"Failed guest assert: "                         \
+			_condstr, __LINE__, _args);                     \
 } while (0)
 
 #define GUEST_ASSERT(_condition) \
-	__GUEST_ASSERT((_condition), 0, 0)
+	__GUEST_ASSERT(_condition, #_condition, 0, 0)
 
 #define GUEST_ASSERT_1(_condition, arg1) \
-	__GUEST_ASSERT((_condition), 1, (arg1))
+	__GUEST_ASSERT(_condition, #_condition, 1, (arg1))
 
 #define GUEST_ASSERT_2(_condition, arg1, arg2) \
-	__GUEST_ASSERT((_condition), 2, (arg1), (arg2))
+	__GUEST_ASSERT(_condition, #_condition, 2, (arg1), (arg2))
 
 #define GUEST_ASSERT_3(_condition, arg1, arg2, arg3) \
-	__GUEST_ASSERT((_condition), 3, (arg1), (arg2), (arg3))
+	__GUEST_ASSERT(_condition, #_condition, 3, (arg1), (arg2), (arg3))
 
 #define GUEST_ASSERT_4(_condition, arg1, arg2, arg3, arg4) \
-	__GUEST_ASSERT((_condition), 4, (arg1), (arg2), (arg3), (arg4))
+	__GUEST_ASSERT(_condition, #_condition, 4, (arg1), (arg2), (arg3), (arg4))
+
+#define GUEST_ASSERT_EQ(a, b) __GUEST_ASSERT((a) == (b), #a " == " #b, 2, a, b)
 
 #endif /* SELFTEST_KVM_UTIL_H */
diff --git a/tools/testing/selftests/kvm/x86_64/tsc_msrs_test.c b/tools/testing/selftests/kvm/x86_64/tsc_msrs_test.c
index e357d8e222d4..5a6a662f2e59 100644
--- a/tools/testing/selftests/kvm/x86_64/tsc_msrs_test.c
+++ b/tools/testing/selftests/kvm/x86_64/tsc_msrs_test.c
@@ -18,15 +18,6 @@
 #define rounded_rdmsr(x)       ROUND(rdmsr(x))
 #define rounded_host_rdmsr(x)  ROUND(vcpu_get_msr(vm, 0, x))
 
-#define GUEST_ASSERT_EQ(a, b) do {				\
-	__typeof(a) _a = (a);					\
-	__typeof(b) _b = (b);					\
-	if (_a != _b)						\
-                ucall(UCALL_ABORT, 4,				\
-                        "Failed guest assert: "			\
-                        #a " == " #b, __LINE__, _a, _b);	\
-  } while(0)
-
 static void guest_code(void)
 {
 	u64 val = 0;
-- 
2.31.1.607.g51e8a6a459-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
