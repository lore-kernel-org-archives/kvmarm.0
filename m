Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 608BE7C
	for <kvmarm@lists.linux.dev>; Sat, 29 Jul 2023 00:37:10 +0000 (UTC)
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-583f048985bso29006967b3.2
        for <kvmarm@lists.linux.dev>; Fri, 28 Jul 2023 17:37:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690591029; x=1691195829;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=wu4FIC3h9waVlshrR9u15d0CHMaQIDGVSbYx3EG04CA=;
        b=Q04Mf0el0lj42W5CyQit+deYtJ8QhAiSTuhlHtHpss5X9mHsFREv9pAjkA8Umzzpec
         z2MZTBlNwMlYWVVc7jlHkM0CgDBhYSqKk80RWVzksAIdRWMzevbW1mKyru4oBtXSj5H4
         m6Y/c47W8GxbL3qevPjkSSP7Fvl4k1vbdy6jI1X6Mu6B/+sTNRMI9LsAHW+sZ3/Cjtna
         KYEmzp1hmEEjPQVxCmUas0BEGE4lj8arVq+7r3PN0H6HoRmfvsyDiXkfqpnkvZEIMNS8
         xc0Ohhn24LAbCMmrkVsDurMlVKgVNxcSVlsTO0MATuz98mHcaBk17CNAUEHGB1MtfxGX
         D+BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690591029; x=1691195829;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wu4FIC3h9waVlshrR9u15d0CHMaQIDGVSbYx3EG04CA=;
        b=IqkQWi+O5Qdh2pUbiZp7DDmqNCbaOKonpCHyQ+sCfmTXagAX3Ex6mgCVwayoKbpGrN
         aELKv3oqsmE620Zm7+HUccFW9ZxKken7RlA/o5KaKgqBOyy7WcNAsb7LiioUIfPOwqyK
         5ZWtAEJ6W84ksmdpEAqRtfDaik2Cwm5qtLqV+6QxqEbh0+NUEKLiG2Hh9NnD6ZrVFMmI
         +BpKF6qYmRRuEre5Wbq5SDaLZC/kA2Iv1gWFRgtkOskG9igZ/3VjFk5Xz33vhPjztIst
         1oGX8jO0s6zExFaswRo610J5m+53JVEQqEAHRoJbVKTO+0ildZsiTf8M7VdKYoGL6Kxf
         Ov/g==
X-Gm-Message-State: ABy/qLYqRRIJnCw2DTglFPAJQ7JLDmEHU2yrOjtqeC/2X0cew/88MKzq
	QGycjC4nDgBN/4ouIdVhTTYgHBds05I=
X-Google-Smtp-Source: APBJJlGzWzIiwoRLp4Z8GC3Y2NOo6GBZ+PY3Wo7QtnMh9LciT0gmn3cUuXWNKJuT0Aj+FA3/xsDneSWd6xU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:b645:0:b0:577:4540:905a with SMTP id
 h5-20020a81b645000000b005774540905amr24915ywk.7.1690591029333; Fri, 28 Jul
 2023 17:37:09 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 28 Jul 2023 17:36:21 -0700
In-Reply-To: <20230729003643.1053367-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230729003643.1053367-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230729003643.1053367-13-seanjc@google.com>
Subject: [PATCH v4 12/34] KVM: selftests: Convert ARM's hypercalls test to
 printf style GUEST_ASSERT
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, Thomas Huth <thuth@redhat.com>, 
	"=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?=" <philmd@linaro.org>, Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Convert ARM's hypercalls test to use printf-based GUEST_ASSERT().
Opportunistically use GUEST_FAIL() to complain about an unexpected stage.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/aarch64/hypercalls.c        | 20 +++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/hypercalls.c b/tools/testing/selftests/kvm/aarch64/hypercalls.c
index bef1499fb465..94555a7d3c7e 100644
--- a/tools/testing/selftests/kvm/aarch64/hypercalls.c
+++ b/tools/testing/selftests/kvm/aarch64/hypercalls.c
@@ -8,6 +8,7 @@
  * hypercalls are properly masked or unmasked to the guest when disabled or
  * enabled from the KVM userspace, respectively.
  */
+#define USE_GUEST_ASSERT_PRINTF 1
 
 #include <errno.h>
 #include <linux/arm-smccc.h>
@@ -105,15 +106,17 @@ static void guest_test_hvc(const struct test_hvc_info *hc_info)
 		switch (stage) {
 		case TEST_STAGE_HVC_IFACE_FEAT_DISABLED:
 		case TEST_STAGE_HVC_IFACE_FALSE_INFO:
-			GUEST_ASSERT_3(res.a0 == SMCCC_RET_NOT_SUPPORTED,
-					res.a0, hc_info->func_id, hc_info->arg1);
+			__GUEST_ASSERT(res.a0 == SMCCC_RET_NOT_SUPPORTED,
+				       "a0 = 0x%lx, func_id = 0x%x, arg1 = 0x%llx, stage = %u",
+					res.a0, hc_info->func_id, hc_info->arg1, stage);
 			break;
 		case TEST_STAGE_HVC_IFACE_FEAT_ENABLED:
-			GUEST_ASSERT_3(res.a0 != SMCCC_RET_NOT_SUPPORTED,
-					res.a0, hc_info->func_id, hc_info->arg1);
+			__GUEST_ASSERT(res.a0 != SMCCC_RET_NOT_SUPPORTED,
+				       "a0 = 0x%lx, func_id = 0x%x, arg1 = 0x%llx, stage = %u",
+					res.a0, hc_info->func_id, hc_info->arg1, stage);
 			break;
 		default:
-			GUEST_ASSERT_1(0, stage);
+			GUEST_FAIL("Unexpected stage = %u", stage);
 		}
 	}
 }
@@ -132,7 +135,7 @@ static void guest_code(void)
 			guest_test_hvc(false_hvc_info);
 			break;
 		default:
-			GUEST_ASSERT_1(0, stage);
+			GUEST_FAIL("Unexpected stage = %u", stage);
 		}
 
 		GUEST_SYNC(stage);
@@ -290,10 +293,7 @@ static void test_run(void)
 			guest_done = true;
 			break;
 		case UCALL_ABORT:
-			REPORT_GUEST_ASSERT_N(uc, "values: 0x%lx, 0x%lx; 0x%lx, stage: %u",
-					      GUEST_ASSERT_ARG(uc, 0),
-					      GUEST_ASSERT_ARG(uc, 1),
-					      GUEST_ASSERT_ARG(uc, 2), stage);
+			REPORT_GUEST_ASSERT(uc);
 			break;
 		default:
 			TEST_FAIL("Unexpected guest exit\n");
-- 
2.41.0.487.g6d72f3e995-goog

