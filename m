Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46ADAC433EF
	for <kvmarm@archiver.kernel.org>; Wed, 15 Jun 2022 19:31:41 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E47D64B330;
	Wed, 15 Jun 2022 15:31:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PmSxYpEqYUT7; Wed, 15 Jun 2022 15:31:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C5CCA4B359;
	Wed, 15 Jun 2022 15:31:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 62ECF4B332
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jun 2022 15:31:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UPuLnPtHPbps for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 Jun 2022 15:31:37 -0400 (EDT)
Received: from mail-il1-f201.google.com (mail-il1-f201.google.com
 [209.85.166.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 100544B1FA
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jun 2022 15:31:37 -0400 (EDT)
Received: by mail-il1-f201.google.com with SMTP id
 a2-20020a923302000000b002d1ad5053feso8986509ilf.17
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jun 2022 12:31:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=OlpkQtFjEA6qewpRBAT14bPQnFjhhsciW1Lv/k5zWG8=;
 b=lqinctO2QCwci3P4aZTFnX0uxxIG+XgQuOKBHKCugg6ujYrJQis8gvN4TxUWJTyM6D
 JaSGqdTHn35GPXcRMXrt19hIl9K+SJE2y7fwCoJf9VYSTIWUBtJUTvOGQgW/HG14trDj
 O6wudR4uE/BmHlxf2dbQAN8gLe8WkWpPA3YqytvB9UM9r9XQSD0ZYXgy1jvf+5eIWFoj
 RYesUWRjy4+ZPeg9KvSg/fLw1I7UW0PbetlrgriWZ3RUPcKDu/+biFfuqYlwstrxKrQi
 lD9GrVXW6CU1fYJlnctxCggkpbVSgII/uRDOrb2mrMwfhi6nSgrwkmy1KeLA2sT+qU7s
 617A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=OlpkQtFjEA6qewpRBAT14bPQnFjhhsciW1Lv/k5zWG8=;
 b=1xjVcZTq1nnTOJx4vL3XM1p5VJoryObHNn9SjI6GVD3ZdjJONdCMvofZQz7dZp3RAU
 i6T9k47vZC7qD1AFejVMtGDAREtAUtXvvqoWMSXlHF8Z6ksbrhmeLE4UdL4a/gbOYTZS
 rDhvOk7dvALzm830QQveERAefQPRntJhgh60YJ8SDD+o06Z65ncJ+1SkQVbmI5Zzzype
 8lSpwCnbI8PK/QAdJFhh94pqopm31sXNekqIpJBL82dG6pffWpBcyTl6Kv9L3JxI9kno
 e/5Qk+OrF2FDuodOu3Q4Ebp6rD86MbNwzVDHSzE1Ow0yQx6vMuxk+bzEFwtQr36lSZs9
 5rWQ==
X-Gm-Message-State: AJIora9zDgL2Jk56AUR8KIJICqp7LU8dS4iIxDyb+7TI0LfqjsRS5fGc
 rogAjDWb86xs902hF26fgNWVZu/HGUcQSmATDA==
X-Google-Smtp-Source: AGRyM1voscU1JxJ/hQMda5mYs4PrEqB3RuwB8jAsoWPnyKEEhH69+E+kp8IXB1gWJlBpEzSd3+uNt3+Qm+tD7uZuAg==
X-Received: from coltonlewis-kvm.c.googlers.com
 ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a5d:9817:0:b0:65a:f20b:db2c with SMTP
 id a23-20020a5d9817000000b0065af20bdb2cmr691990iol.118.1655321496198; Wed, 15
 Jun 2022 12:31:36 -0700 (PDT)
Date: Wed, 15 Jun 2022 19:31:15 +0000
In-Reply-To: <20220615193116.806312-1-coltonlewis@google.com>
Message-Id: <20220615193116.806312-4-coltonlewis@google.com>
Mime-Version: 1.0
References: <20220615193116.806312-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH 3/4] KVM: selftests: Write REPORT_GUEST_ASSERT macros to pair
 with GUEST_ASSERT
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, pbonzini@redhat.com
Cc: thuth@redhat.com, Colton Lewis <coltonlewis@google.com>, maz@kernel.org,
 vkuznets@redhat.com
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

Write REPORT_GUEST_ASSERT macros to pair with GUEST_ASSERT to abstract
and make consistent all guest assertion reporting. Every report
includes an explanatory string, a filename, and a line number.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 .../selftests/kvm/include/ucall_common.h      | 42 +++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/ucall_common.h b/tools/testing/selftests/kvm/include/ucall_common.h
index 568c562f14cd..e8af3b4fef6d 100644
--- a/tools/testing/selftests/kvm/include/ucall_common.h
+++ b/tools/testing/selftests/kvm/include/ucall_common.h
@@ -6,6 +6,7 @@
  */
 #ifndef SELFTEST_KVM_UCALL_COMMON_H
 #define SELFTEST_KVM_UCALL_COMMON_H
+#include "test_util.h"
 
 /* Common ucalls */
 enum {
@@ -64,4 +65,45 @@ enum guest_assert_builtin_args {
 
 #define GUEST_ASSERT_EQ(a, b) __GUEST_ASSERT((a) == (b), #a " == " #b, 2, a, b)
 
+#define __REPORT_GUEST_ASSERT(_ucall, fmt, _args...)			\
+	TEST_FAIL("%s at %s:%ld\n" fmt,					\
+		  (const char *)(_ucall).args[GUEST_ERROR_STRING],	\
+		  (const char *)(_ucall).args[GUEST_FILE],		\
+		  (_ucall).args[GUEST_LINE],				\
+		  ##_args)
+
+#define GUEST_ASSERT_ARG(ucall, i) ((ucall).args[GUEST_ASSERT_BUILTIN_NARGS + i])
+
+#define REPORT_GUEST_ASSERT(ucall)		\
+	__REPORT_GUEST_ASSERT((ucall), "")
+
+#define REPORT_GUEST_ASSERT_1(ucall, fmt)			\
+	__REPORT_GUEST_ASSERT((ucall),				\
+			      fmt,				\
+			      GUEST_ASSERT_ARG((ucall), 0))
+
+#define REPORT_GUEST_ASSERT_2(ucall, fmt)			\
+	__REPORT_GUEST_ASSERT((ucall),				\
+			      fmt,				\
+			      GUEST_ASSERT_ARG((ucall), 0),	\
+			      GUEST_ASSERT_ARG((ucall), 1))
+
+#define REPORT_GUEST_ASSERT_3(ucall, fmt)			\
+	__REPORT_GUEST_ASSERT((ucall),				\
+			      fmt,				\
+			      GUEST_ASSERT_ARG((ucall), 0),	\
+			      GUEST_ASSERT_ARG((ucall), 1),	\
+			      GUEST_ASSERT_ARG((ucall), 2))
+
+#define REPORT_GUEST_ASSERT_4(ucall, fmt)			\
+	__REPORT_GUEST_ASSERT((ucall),				\
+			      fmt,				\
+			      GUEST_ASSERT_ARG((ucall), 0),	\
+			      GUEST_ASSERT_ARG((ucall), 1),	\
+			      GUEST_ASSERT_ARG((ucall), 2),	\
+			      GUEST_ASSERT_ARG((ucall), 3))
+
+#define REPORT_GUEST_ASSERT_N(ucall, fmt, args...)	\
+	__REPORT_GUEST_ASSERT((ucall), fmt, ##args)
+
 #endif /* SELFTEST_KVM_UCALL_COMMON_H */
-- 
2.36.1.476.g0c4daa206d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
