Return-Path: <SRS0=JLBt=LF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F0B6C48BE0
	for <kvmarm@archiver.kernel.org>; Fri, 11 Jun 2021 01:10:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E4C6D613B3
	for <kvmarm@archiver.kernel.org>; Fri, 11 Jun 2021 01:10:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E4C6D613B3
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 981AB4A319;
	Thu, 10 Jun 2021 21:10:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LcEQj13x6oOT; Thu, 10 Jun 2021 21:10:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B5B0A4B0A0;
	Thu, 10 Jun 2021 21:10:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1A5244B0A1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Jun 2021 21:10:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id l4T2-5MWQb5Q for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Jun 2021 21:10:31 -0400 (EDT)
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com
 [209.85.214.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 053464B08B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Jun 2021 21:10:31 -0400 (EDT)
Received: by mail-pl1-f201.google.com with SMTP id
 d18-20020a170902b712b029010f71d164c6so1920574pls.19
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Jun 2021 18:10:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=4aDyFvrxlFwPOgnkxkIlU3KeNadi1hrIbCCSRD9xSSc=;
 b=YGy5QJg9Hws1yT/Ru5qLO1HC2J/F0QhvK4R9XpwC06AK9L4lg19fWiwepuXsuVtVgo
 UW/xvDPVAiQC4duDkeaCNCkx0HsWVYsjYUr7wRtCUIVrJU8gyKEsNkf0BLz2XVmzdyYd
 DxL1XbdIohcgKHLbdBX6m9Pq8KBwIFCLXI8DL+P66L4zyvsml5oJv1wWwyWs+KyieP/C
 tLCB38gdAK4PIl2/q3S+ebNmUvwtzd5Gk6THaod+3iPu7FE8x1UlcIXePjSliI3oOJ9z
 xB2XKiuhX6kbbImNW81Onzot1LCNQ3P5k9MO/kShNWfsRtWg2ZodEQdfWmklcKkqt354
 SxJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=4aDyFvrxlFwPOgnkxkIlU3KeNadi1hrIbCCSRD9xSSc=;
 b=jKfE+ihiMIFEcTCxxLjg7fivFz8e8K7LPhj0UKHQYRZSsA+TEysWU/jXgNsydMb9Zk
 Nyjc20+xiztB8cfRVzm/rBedRfCtyJMo61RZQQAJUN333IMVd4zf3I+gMW/QQfDuLg/Y
 uWHpRrBd0OjfNQNmB4TG0LYprxMtvJ6noSgFZRSIwpEugsXWiKnxtxjUgAQQUxBHn0Yy
 GJ7pSAgXvcvjlbt/7qYIxrqp7Ffh7wxqkbWJSWg4qxQHqi/4IslUtm1f/c3EPMcU8q8X
 oudI7xVc4rAYIDsW6ed/JnRy2qGuFnaTz/SgRGNCQkmsTpapb5y6jV571OSRVuhgrNLm
 tOUA==
X-Gm-Message-State: AOAM530tfJWgny/ILsojKetMyc3spABzSVf1rU7gV4udo56W4T2IwQz0
 /UjoxxjFIoSJR9f5yb2hrug9qNcpD2LK0g==
X-Google-Smtp-Source: ABdhPJwmhURii809YCjVm28/KNSwi4P3CmWOGzFj0fBc202yAjKSbR3hkxDL3AqrZOdTdClXsq/E8FCFh6Qdlg==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:10:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:903:1042:b029:112:6ce1:667 with SMTP
 id f2-20020a1709031042b02901126ce10667mr1449831plc.44.1623373830056; Thu, 10
 Jun 2021 18:10:30 -0700 (PDT)
Date: Thu, 10 Jun 2021 18:10:18 -0700
In-Reply-To: <20210611011020.3420067-1-ricarkol@google.com>
Message-Id: <20210611011020.3420067-5-ricarkol@google.com>
Mime-Version: 1.0
References: <20210611011020.3420067-1-ricarkol@google.com>
X-Mailer: git-send-email 2.32.0.272.g935e593368-goog
Subject: [PATCH v4 4/6] KVM: selftests: Move GUEST_ASSERT_EQ to utils header
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: maz@kernel.org, pbonzini@redhat.com, vkuznets@redhat.com
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
index beb76d6deaa9..ce49e22843d8 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -368,26 +368,28 @@ uint64_t get_ucall(struct kvm_vm *vm, uint32_t vcpu_id, struct ucall *uc);
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
2.32.0.272.g935e593368-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
