Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E2BB38E
	for <kvmarm@lists.linux.dev>; Sat, 29 Jul 2023 00:37:27 +0000 (UTC)
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1bba9a0da10so18216315ad.2
        for <kvmarm@lists.linux.dev>; Fri, 28 Jul 2023 17:37:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690591046; x=1691195846;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=BLQZx+pdtuh57o1wL4zXWuuQZRskZOiKVGsasrVHJ/k=;
        b=nnPTjTg5f/WzRDY0G2F5g9I/MpwEw80DlkwGP2Q2BChxakWYZQ2XnR8JayKvBVdnKQ
         CKM3viDb8jPmE5GbrYha5aGJnTTlWFTmcIwmJivT3eDJTxFD2URsQENK6Eh81rE2xWMX
         RZ6ITjibLuUEHo6PcwrfwHDxR4zT0ua5AfnmwXcHoZWyfmSg6BKa2ZB33/ML8XAQvrii
         QVgpwwc2XmC0hCNaWSi8QIWcL1JJXowfEhL7mHg+gIk9DRqso5bgtfBwOHN/w13q7zh2
         P+wiqOsuQFN2OQWzT2ZZ47jXKsfPKtt9IpQyAyPKY3qGjr0jtZBF7Ch+Qk2dIeOH50IR
         vSMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690591046; x=1691195846;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BLQZx+pdtuh57o1wL4zXWuuQZRskZOiKVGsasrVHJ/k=;
        b=dEDd+qH2Wd2NcSiW68ybhmq0mjyr4k87ixR3g4oTZhIcIugp5GDHfhAaTpLsRtjoeA
         7rRtze8XTb+1SWiXrLS7qBseR6JYdJ5dIX1ZvyMXBA/9yA2uIz/qnJgcGNwm3bfwxvHO
         9Of3WjKkoKbGMZkB9L1qqG5N3RnkOUWIQKq/kZfyETQOTMfEcpPz1paoDW5mNAwSavW2
         3P6SUspzWYNbXt07EzSQwRBI99eQ26n5WTmtft0co1M0qQO0x2Wq8mYdLMhLNbpyg9Wi
         FBVeXAFl/q4RzrCu1G/MymzyfLefPPIGhdLpNdTv1ELuww0ACBPnhuCHll1qRqcVRuTT
         Qlpg==
X-Gm-Message-State: ABy/qLZ+bcMvy3BevW/UiRuiVFQ+kI7te26XWOjqFmzkiC56H9xTBrO6
	GnrxrtdQK/NSH341d+GlSILLcqBnV50=
X-Google-Smtp-Source: APBJJlFlrrUE1tksLhPAq+kwjI0L4IaBgwLyAp0oEOf6o8ykeMtkOh9QkcD45fcBdHtiq3t7HikG7TyuqI0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:da83:b0:1b3:c62d:71b5 with SMTP id
 j3-20020a170902da8300b001b3c62d71b5mr12053plx.0.1690591046611; Fri, 28 Jul
 2023 17:37:26 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 28 Jul 2023 17:36:30 -0700
In-Reply-To: <20230729003643.1053367-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230729003643.1053367-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230729003643.1053367-22-seanjc@google.com>
Subject: [PATCH v4 21/34] KVM: selftests: Convert the Hyper-V extended
 hypercalls test to printf asserts
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, Thomas Huth <thuth@redhat.com>, 
	"=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?=" <philmd@linaro.org>, Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Convert x86's Hyper-V extended hypercalls test to use printf-based
GUEST_ASSERT_EQ().

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../testing/selftests/kvm/x86_64/hyperv_extended_hypercalls.c  | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_extended_hypercalls.c b/tools/testing/selftests/kvm/x86_64/hyperv_extended_hypercalls.c
index 73af44d2167f..0107d54a1a08 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_extended_hypercalls.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_extended_hypercalls.c
@@ -8,6 +8,7 @@
  * Copyright 2022 Google LLC
  * Author: Vipin Sharma <vipinsh@google.com>
  */
+#define USE_GUEST_ASSERT_PRINTF 1
 
 #include "kvm_util.h"
 #include "processor.h"
@@ -84,7 +85,7 @@ int main(void)
 
 	switch (get_ucall(vcpu, &uc)) {
 	case UCALL_ABORT:
-		REPORT_GUEST_ASSERT_2(uc, "arg1 = %ld, arg2 = %ld");
+		REPORT_GUEST_ASSERT(uc);
 		break;
 	case UCALL_DONE:
 		break;
-- 
2.41.0.487.g6d72f3e995-goog

