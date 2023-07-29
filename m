Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB8067C
	for <kvmarm@lists.linux.dev>; Sat, 29 Jul 2023 00:37:40 +0000 (UTC)
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1bbf8cb6250so2217995ad.2
        for <kvmarm@lists.linux.dev>; Fri, 28 Jul 2023 17:37:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690591060; x=1691195860;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=MF+bXwxuzawTID7VRrTPOhSciVZgdU/b6cmoH5k6//k=;
        b=3XTnvyalsgYeWNIfRKpoVdZ9znRrqsMtDLiXzSBNXaL9ulyyhk9kCqs4X/p4w5FS6j
         Pnv8yfYZMfdH2C/ay8U7ENPGEFJhc7w/CuemxdRRz8eH86xSNifWP5ZwzANBP9/oB3HR
         3sWZhNhDLBgeMvHiiHeOED7DQdTXZjwa5JfxyvUZpfD5ac2/IpwN7YHxBboIFfGzXvwu
         rcJeMPbFvOsf9vMaE1lIRBQYFMqbPiazr3IJt7WvHcHc9CpIVXngyazah+wdv3GVsiVp
         hpSJlgpGel/1zstInYMbykQhPKknMzf1f8cRcpRQ06xGV39obcipHA+c6rQln+Jb9MQN
         WYZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690591060; x=1691195860;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MF+bXwxuzawTID7VRrTPOhSciVZgdU/b6cmoH5k6//k=;
        b=B9i7LhhlY2EIcoYCm5IzmjlDDOJOJRRbsh5pl4U6DOkd0FacWnUiX+8G7SnhdMgTIj
         l2fQvP5Sy9mTHZLZL/j29M3ZlxKx5bAzfu+Jk6YI9zJVzE/Ezj0RPs7BQpfg2mctSm4O
         dhfThIrQSfKmBT6IMuhYjm7BfxgLYX2agcz7CeXBFt9EU80+U26n+IDa+jr7P1qegM1a
         C2Y98KtTRhQvbqujSe/BFXLr8qlmwvQuSo2IruzEQ2G5Ph2LpKfeoSK1L+8//IPTEYpG
         i9LxMmBQo+xVmw/kd3/eQ+YmJzjqIjkq1yb4qPpBiYvgMC/xbuNZmSVj6cSJGz9pOtvw
         3wtw==
X-Gm-Message-State: ABy/qLbA/m1Um0P1QJCIhSzsES9MX6Xnk7LrcpKZ6L5b2eJhdFB/aUxN
	ZJ7MQAyhZzlGmTKrb907mOhapWU9n7A=
X-Google-Smtp-Source: APBJJlFmabRF0RxzQGT8BcVKXP0SGH0X5me+cEjliMepzv+strLs30XZHxwmIQzJ9Engiax0UKUvH6M/avo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:eccc:b0:1ba:1704:89d1 with SMTP id
 a12-20020a170902eccc00b001ba170489d1mr13265plh.10.1690591060423; Fri, 28 Jul
 2023 17:37:40 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 28 Jul 2023 17:36:37 -0700
In-Reply-To: <20230729003643.1053367-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230729003643.1053367-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230729003643.1053367-29-seanjc@google.com>
Subject: [PATCH v4 28/34] KVM: selftests: Convert x86's TSC MSRs test to use
 printf guest asserts
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, Thomas Huth <thuth@redhat.com>, 
	"=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?=" <philmd@linaro.org>, Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Convert x86's TSC MSRs test, and it's liberal use of GUEST_ASSERT_EQ(), to
use printf-based guest assert reporting.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/x86_64/tsc_msrs_test.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/x86_64/tsc_msrs_test.c b/tools/testing/selftests/kvm/x86_64/tsc_msrs_test.c
index 9265965bd2cd..cf9114f70e1c 100644
--- a/tools/testing/selftests/kvm/x86_64/tsc_msrs_test.c
+++ b/tools/testing/selftests/kvm/x86_64/tsc_msrs_test.c
@@ -4,6 +4,8 @@
  *
  * Copyright (C) 2020, Red Hat, Inc.
  */
+#define USE_GUEST_ASSERT_PRINTF 1
+
 #include <stdio.h>
 #include <string.h>
 #include "kvm_util.h"
@@ -84,7 +86,7 @@ static void run_vcpu(struct kvm_vcpu *vcpu, int stage)
 		ksft_test_result_pass("stage %d passed\n", stage + 1);
 		return;
 	case UCALL_ABORT:
-		REPORT_GUEST_ASSERT_2(uc, "values: %#lx, %#lx");
+		REPORT_GUEST_ASSERT(uc);
 	default:
 		TEST_ASSERT(false, "Unexpected exit: %s",
 			    exit_reason_str(vcpu->run->exit_reason));
-- 
2.41.0.487.g6d72f3e995-goog

