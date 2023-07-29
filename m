Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CDDC38E
	for <kvmarm@lists.linux.dev>; Sat, 29 Jul 2023 00:37:18 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-d087ffcc43cso2512917276.3
        for <kvmarm@lists.linux.dev>; Fri, 28 Jul 2023 17:37:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690591037; x=1691195837;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Ngl8lC+/wGQlijkr13PT2tPWtqTwIZBUn/V8pQLJnsI=;
        b=jTQgJijvaSA87s20WcW+DJNYcBr6iycXkShWiPEyn+ZHzYOOnQWRcWv0EDcUck3WSB
         dDF9I/Q1ySsvk1kWojQd9tEW8CDUPb3rTBRDLk/39KSQDC1qIvUaOTYBgFEBQSQG5ATK
         8R4xRcct2Y93O33tOsGnfxwy3mlvnE7TbvOuNpUzxRO2IweGEzpWlv7WtggKrSBIcfG9
         sEllWKhZpl8xKL/qkLMA6jfKxBkcLUU8sa+YBP7gnqHUx9AQjq6pptXGY8yhdC+XrS3V
         Cvu0hwoiZQ5M1a1Zqzfe0E2sT4WnjUBLlClEx7LF5ZDnUPi2DLOSqL0+TuJZZvycUOll
         a2og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690591037; x=1691195837;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ngl8lC+/wGQlijkr13PT2tPWtqTwIZBUn/V8pQLJnsI=;
        b=cRMdHRfFBsx6K7T6SY4vZIas841ORFx9tKkoVma2hXmqU22ZDeB1LSjG5wPeT9TdTx
         VNiQ4CfSr6PzdsRbTT+98MUFlk5dmfNt7o3a7bvooJu+ppNvGHEeiohVRue3I35DUncS
         MekHy03L/4AsJaFDXXXgvp31cnyeIZuiGIC1oJxtATH+9nw2eEZy5LmiMmg6ab2PGh7Q
         K+Osqje0dklJkznPeWL6yBIwWw5wd9/3ul6cGpVNLD6qe2af5b9Ykk4mEeFu3/9ozHma
         YPYYV0FIkOvakk8joPjrQQJYTBvh1UASyhBUv0EcI1rPhwVG7wAY3SQFVqThVehw33Jh
         RHhw==
X-Gm-Message-State: ABy/qLblhhMUNwp2GupgqLD09DzwERJGoJeGhNEjasz/oqRFPQXAmoye
	IaSmI8lRXInAJ8a6ViTHMwIngaZw4TQ=
X-Google-Smtp-Source: APBJJlFyvjHiUTrdRegL0ZLMZ9b9mCjMN4KTPZtSt6e6xxSeT5N2o2AAxi3EjqMwYiXS5k9L3PQ7RQatewc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:20c3:0:b0:d11:b0d5:cd01 with SMTP id
 g186-20020a2520c3000000b00d11b0d5cd01mr17235ybg.8.1690591037120; Fri, 28 Jul
 2023 17:37:17 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 28 Jul 2023 17:36:25 -0700
In-Reply-To: <20230729003643.1053367-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230729003643.1053367-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230729003643.1053367-17-seanjc@google.com>
Subject: [PATCH v4 16/34] KVM: selftests: Convert s390's memop test to printf
 style GUEST_ASSERT
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, Thomas Huth <thuth@redhat.com>, 
	"=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?=" <philmd@linaro.org>, Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Convert s390's memop test to printf-based GUEST_ASSERT, and
opportunistically use GUEST_FAIL() to report invalid sizes.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/s390x/memop.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/s390x/memop.c b/tools/testing/selftests/kvm/s390x/memop.c
index de73dc030905..a49173907cec 100644
--- a/tools/testing/selftests/kvm/s390x/memop.c
+++ b/tools/testing/selftests/kvm/s390x/memop.c
@@ -4,6 +4,7 @@
  *
  * Copyright (C) 2019, Red Hat, Inc.
  */
+#define USE_GUEST_ASSERT_PRINTF 1
 
 #include <stdio.h>
 #include <stdlib.h>
@@ -279,7 +280,7 @@ enum stage {
 	vcpu_run(__vcpu);						\
 	get_ucall(__vcpu, &uc);						\
 	if (uc.cmd == UCALL_ABORT) {					\
-		REPORT_GUEST_ASSERT_2(uc, "hints: %lu, %lu");		\
+		REPORT_GUEST_ASSERT(uc);				\
 	}								\
 	TEST_ASSERT_EQ(uc.cmd, UCALL_SYNC);				\
 	TEST_ASSERT_EQ(uc.args[1], __stage);				\
@@ -469,7 +470,7 @@ static __uint128_t cut_to_size(int size, __uint128_t val)
 	case 16:
 		return val;
 	}
-	GUEST_ASSERT_1(false, "Invalid size");
+	GUEST_FAIL("Invalid size = %u", size);
 	return 0;
 }
 
@@ -598,7 +599,7 @@ static bool _cmpxchg(int size, void *target, __uint128_t *old_addr, __uint128_t
 			return ret;
 		}
 	}
-	GUEST_ASSERT_1(false, "Invalid size");
+	GUEST_FAIL("Invalid size = %u", size);
 	return 0;
 }
 
-- 
2.41.0.487.g6d72f3e995-goog

