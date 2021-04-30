Return-Path: <SRS0=QphI=J3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2F61C43461
	for <kvmarm@archiver.kernel.org>; Fri, 30 Apr 2021 23:24:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3C8CF61420
	for <kvmarm@archiver.kernel.org>; Fri, 30 Apr 2021 23:24:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3C8CF61420
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D2F194B470;
	Fri, 30 Apr 2021 19:24:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GwuyYSt2Udif; Fri, 30 Apr 2021 19:24:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9D04F4B45B;
	Fri, 30 Apr 2021 19:24:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AD7EE4B4A5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Apr 2021 19:24:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 29bIar0USkpo for <kvmarm@lists.cs.columbia.edu>;
 Fri, 30 Apr 2021 19:24:16 -0400 (EDT)
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com
 [209.85.210.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6C08F4B4A6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Apr 2021 19:24:16 -0400 (EDT)
Received: by mail-pf1-f201.google.com with SMTP id
 a4-20020a056a000c84b029025d788a548fso127444pfv.8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Apr 2021 16:24:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=+DSPnKtKLaCWYruB9RUFpApCJLw7ci5vJYpmKsxCMpY=;
 b=GHmtm/HM2OsR4qjLE/kzZOFZvHz4TWk6oZ3ISonugQE6amsbiSELaSSMwNq1EmIKhD
 dlftmhUu0LrDTzlEUbYbo7zrpSF89uaN24YRWR4BBjiUaG44gV9W5Akqw+fPwnSngtUV
 vvrLatZTJP5fXD8VrPgRQFP1Zml58ooiVF7NdK0+e4dCErXUfJjk4IC1v5q2H4PQjjNd
 nztXvIOclQ/qwp6OkK+R35UH+ZXmMTdf36MXFViViWfnIYPrpFBncFkkcaGUptG7WPL+
 KJK0kR5vRn7Fpz9JKPs9IqiTc6AW727iV7E4+zFBAxPc70hIB4Kcpge+JFoEDo2Z7m6g
 L+TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=+DSPnKtKLaCWYruB9RUFpApCJLw7ci5vJYpmKsxCMpY=;
 b=PZAM0XmEnTQffvR4piB71QCVsRRMMM4ap83dta8NTlZ2d16i/WR0EuGPtAaPIgcztB
 vkbNAqYX5sDIq7Z8X8jjbMbHdA5aMgM/ABlg83E08Qx4dvGTiOtJIQSZmdt84YWWjOU5
 kS7Hz61IRgUYP3cfBgoPbnEbKBIYQf7sId2wtT2DYknBf2p0Sv1KXHhYiQPfAZ/5hJ+H
 +DgZDPTGPw9xQfOX6jMM1BGlJxooqADdXGIM1nsKn3Jvifcj6dLLFmFAJBspymuUCRvq
 xrgQB7Q/CZ5wo9FuB9gpnmUcF1UYrcrPJA5QFJw9jUe4tOwQSaEMcZES2qKM/0YD9x3O
 rqgQ==
X-Gm-Message-State: AOAM532ooncWvzySNNB3pNmuMPsBr1KNsiGDrRul4H31L7mH50uvga5c
 crQE5KTiNSwcYWQRU43OsBbcMw2gPm2f6w==
X-Google-Smtp-Source: ABdhPJwC5V/hbECRi8QXjzfu3qwYiwVszsZ2QtYnlFZCKfIcZmSzuCJ4ZAqv7NpufKqwn6hZrHJb7GOdJFz6fQ==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:10:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:902:b905:b029:ed:2235:ad2c with SMTP
 id bf5-20020a170902b905b02900ed2235ad2cmr7763186plb.28.1619825055219; Fri, 30
 Apr 2021 16:24:15 -0700 (PDT)
Date: Fri, 30 Apr 2021 16:24:05 -0700
In-Reply-To: <20210430232408.2707420-1-ricarkol@google.com>
Message-Id: <20210430232408.2707420-4-ricarkol@google.com>
Mime-Version: 1.0
References: <20210430232408.2707420-1-ricarkol@google.com>
X-Mailer: git-send-email 2.31.1.527.g47e6f16901-goog
Subject: [PATCH v2 3/5] KVM: selftests: Move GUEST_ASSERT_EQ to utils header
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
architectures and tests to use.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 tools/testing/selftests/kvm/include/kvm_util.h     | 9 +++++++++
 tools/testing/selftests/kvm/x86_64/tsc_msrs_test.c | 9 ---------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 7880929ea548..bd26dd93ab56 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -388,4 +388,13 @@ uint64_t get_ucall(struct kvm_vm *vm, uint32_t vcpu_id, struct ucall *uc);
 #define GUEST_ASSERT_4(_condition, arg1, arg2, arg3, arg4) \
 	__GUEST_ASSERT((_condition), 4, (arg1), (arg2), (arg3), (arg4))
 
+#define GUEST_ASSERT_EQ(a, b) do {				\
+	__typeof(a) _a = (a);					\
+	__typeof(b) _b = (b);					\
+	if (_a != _b)						\
+		ucall(UCALL_ABORT, 4,				\
+			"Failed guest assert: "			\
+			#a " == " #b, __LINE__, _a, _b);	\
+} while(0)
+
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
2.31.1.527.g47e6f16901-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
