Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11D327C
	for <kvmarm@lists.linux.dev>; Sat, 29 Jul 2023 00:37:12 +0000 (UTC)
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1bba7a32a40so20261635ad.0
        for <kvmarm@lists.linux.dev>; Fri, 28 Jul 2023 17:37:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690591031; x=1691195831;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=KD9spraMrgRbnmBjQZZWWeob8eAugC00F4y37YTJw8E=;
        b=UUiGz//H+qc2VwnDcG3ap61DCiEkgcxxTwTq2PlVRzkYDYvNYeUh70lnLWpXCBXw1y
         ENjvzo412y0u8RsVpXc3xycSaaXoHpRTF5UONPFZsGShWgI3pIRhTRunNJJuTQ1A9uhm
         mnqIecy31B8Hjk0rRk237/9BlpMmLswr75hM4zTSsGCta9eHugEBieSA56LlrpFKmd6W
         Q7Mgfwj67nXcEUg6f552ziM8vdP6tqceVJ6jlczrAq7yuwAswE/dDCGV67Oc/x9uOuhf
         HdMr387q9wwaQ/lM9O6Fz189JQIUM7qwFKdn09iNwVvjAI88wPw698F9vdkbtGf62tCA
         svIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690591031; x=1691195831;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KD9spraMrgRbnmBjQZZWWeob8eAugC00F4y37YTJw8E=;
        b=C4zBeo1tuNTIXDiU/v5zZFcKOw1ir7F72/fXVZkm6b9X68SpnpbM8aUbrxBkPy1ZHq
         Wac/CXF3wscu0GGvv6os1U5wk9iqcffag3FnigAKnXPIlAMlww/JRoaM9Z9Ci+Tgj4Hx
         hgNA02LzFLD7O5K0KB5eTb96KI9YrHj8voGR2CnpsRORj5NxhrtRoVrCR0jWUgUyheJH
         skSEMRGVKib7RIQBFmosIv55nJ44gC2OVptU1z5nx6ZbWY4YzHnkeCZaRm9nA7dhEFWq
         fqr2MQTnqRVyu0yGF1/BRSGmsnaBFf7DARhk2pbq3CoKw9f4qpCI/97iNxU+yNa3zrJm
         O8TA==
X-Gm-Message-State: ABy/qLb05cQIe2jPSk8YC4B3IzbMPZwp6WHs3n2y1AWfbeblQtK6xu2x
	Mpo4SBFbFVtgkg1fu68744+Qw7ggFJQ=
X-Google-Smtp-Source: APBJJlGFWjvsj2ItznxzdDVqa8pRyuCQsd04GIbUfTSMt0KhlWzf3EhqdNhW+0vnUSXgK5Kxd8db4hT3FWo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:e5c1:b0:1b8:8c7:31e6 with SMTP id
 u1-20020a170902e5c100b001b808c731e6mr14017plf.1.1690591030967; Fri, 28 Jul
 2023 17:37:10 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 28 Jul 2023 17:36:22 -0700
In-Reply-To: <20230729003643.1053367-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230729003643.1053367-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230729003643.1053367-14-seanjc@google.com>
Subject: [PATCH v4 13/34] KVM: selftests: Convert ARM's page fault test to
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

Use GUEST_FAIL() in ARM's page fault test to report unexpected faults.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/aarch64/page_fault_test.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/page_fault_test.c b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
index e5bb8767d2cb..0b0dd90feae5 100644
--- a/tools/testing/selftests/kvm/aarch64/page_fault_test.c
+++ b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
@@ -7,6 +7,7 @@
  * hugetlbfs with a hole). It checks that the expected handling method is
  * called (e.g., uffd faults with the right address and write/read flag).
  */
+#define USE_GUEST_ASSERT_PRINTF 1
 
 #define _GNU_SOURCE
 #include <linux/bitmap.h>
@@ -293,12 +294,12 @@ static void guest_code(struct test_desc *test)
 
 static void no_dabt_handler(struct ex_regs *regs)
 {
-	GUEST_ASSERT_1(false, read_sysreg(far_el1));
+	GUEST_FAIL("Unexpected dabt, far_el1 = 0x%llx", read_sysreg(far_el1));
 }
 
 static void no_iabt_handler(struct ex_regs *regs)
 {
-	GUEST_ASSERT_1(false, regs->pc);
+	GUEST_FAIL("Unexpected iabt, pc = 0x%lx", regs->pc);
 }
 
 static struct uffd_args {
@@ -679,7 +680,7 @@ static void vcpu_run_loop(struct kvm_vm *vm, struct kvm_vcpu *vcpu,
 			}
 			break;
 		case UCALL_ABORT:
-			REPORT_GUEST_ASSERT_2(uc, "values: %#lx, %#lx");
+			REPORT_GUEST_ASSERT(uc);
 			break;
 		case UCALL_DONE:
 			goto done;
-- 
2.41.0.487.g6d72f3e995-goog

