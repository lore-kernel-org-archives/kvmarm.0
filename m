Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16582C43219
	for <kvmarm@archiver.kernel.org>; Thu, 13 Jan 2022 22:18:47 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ACB204B17B;
	Thu, 13 Jan 2022 17:18:46 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xAg6GWsyZAai; Thu, 13 Jan 2022 17:18:45 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6BDC34B156;
	Thu, 13 Jan 2022 17:18:45 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 91CB649E2B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 Jan 2022 17:18:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dR+DjqH5n1TB for <kvmarm@lists.cs.columbia.edu>;
 Thu, 13 Jan 2022 17:18:43 -0500 (EST)
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com
 [209.85.214.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 88E2D4B10E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 Jan 2022 17:18:43 -0500 (EST)
Received: by mail-pl1-f201.google.com with SMTP id
 v21-20020a17090331d500b0014a5895b639so6872701ple.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 Jan 2022 14:18:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=mvimdalggRqv44+8DxSjpX0UJ7y65xJ7W9TGgiRekLQ=;
 b=fft9JkIaW7xsTLU71vFw/aLtoriiT7J7UJy8sqPLByjufAN+uQyN9czAcyq7ru4MJ2
 XyDtG8fy8Ce6vRZp3Pp6GJIN3SGHQcfVaJH8Fhs9x5mCXaUHfm6nittnC5lR0qEnR5cO
 4dG/zu8RNHu3TX6ghTUpu9qGZtxPzYopmTU2vArQoDkkDDA/Rb5DTGdJabqk/kVP4J+H
 nq2GuwAlwP0T5XaD2C3Yn69oznKkkhcM2cX2AVysyDTXnF43HhzZVkANdQzBufRjxMFV
 PHllAcNDm2BV1skpRUuXZJYtsATDIEi0rHDfdPS+n6qSRUpTE1BzSOBVX0YqdIcS43/J
 477g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=mvimdalggRqv44+8DxSjpX0UJ7y65xJ7W9TGgiRekLQ=;
 b=LWHenVq44Xup4/vQWHT+MQN2/rIy9J6zJ1SILN01VlxTi8U8Tigf3Bv/5wLHIWIf5a
 m2ptB24qBfpZJk2VS6/iJwbAB03dNs+YLaNInpUoqmuTdnjoFvND1Hy2iAmuABeCk4q0
 adQD4zJSYoEbz+kwu1o9s/ltrfk3m5UshbRHKAR2wNz4ucwQv9FB301MgC935YfmX8O2
 1Pgwq61icaO18Znzy6HCRtynQQ53+4pvAbG5aT6suHGsVqnc0lq7mnaRQWnGQzvVByFC
 MfWruKTG+Yp3aQ1A71K8ZN6WZHwG0WrcqGY0HH95TwEZvxVl1f09EtAjnSJAmp4pyhjl
 RoVQ==
X-Gm-Message-State: AOAM530IDWJUPznAMWxvB5qbUC0M5IHKrcy02m0rgwkYfwAaK8OciM0M
 0XU7bztvp+HP0JWESHn7nqCbsINHicYpW0e1rg==
X-Google-Smtp-Source: ABdhPJwbPHsrVTSgeSxfOcMPF5wphsJcDfZTXxLxP4XcJSJkbiS8jQ2Gsj6Ba5PUTFHp4GfFLXvfvXZq5tEe3bhpKQ==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:aa7:9ec7:0:b0:4be:19fa:f0f3
 with SMTP
 id r7-20020aa79ec7000000b004be19faf0f3mr6129109pfq.8.1642112322722; Thu, 13
 Jan 2022 14:18:42 -0800 (PST)
Date: Thu, 13 Jan 2022 22:18:29 +0000
In-Reply-To: <20220113221829.2785604-1-jingzhangos@google.com>
Message-Id: <20220113221829.2785604-4-jingzhangos@google.com>
Mime-Version: 1.0
References: <20220113221829.2785604-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.34.1.703.g22d0c6ccf7-goog
Subject: [PATCH v1 3/3] KVM: selftests: Add vgic initialization for dirty log
 perf test for ARM
From: Jing Zhang <jingzhangos@google.com>
To: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.cs.columbia.edu>, 
 Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, 
 David Matlack <dmatlack@google.com>, Oliver Upton <oupton@google.com>, 
 Reiji Watanabe <reijiw@google.com>, Ricardo Koller <ricarkol@google.com>, 
 Raghavendra Rao Ananta <rananta@google.com>
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

For ARM64, if no vgic is setup before the dirty log perf test, the
userspace irqchip would be used, which would affect the dirty log perf
test result.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 tools/testing/selftests/kvm/dirty_log_perf_test.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
index 1954b964d1cf..b501338d9430 100644
--- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
@@ -18,6 +18,12 @@
 #include "test_util.h"
 #include "perf_test_util.h"
 #include "guest_modes.h"
+#ifdef __aarch64__
+#include "aarch64/vgic.h"
+
+#define GICD_BASE_GPA			0x8000000ULL
+#define GICR_BASE_GPA			0x80A0000ULL
+#endif
 
 /* How many host loops to run by default (one KVM_GET_DIRTY_LOG for each loop)*/
 #define TEST_HOST_LOOP_N		2UL
@@ -200,6 +206,10 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 		vm_enable_cap(vm, &cap);
 	}
 
+#ifdef __aarch64__
+	vgic_v3_setup(vm, nr_vcpus, 64, GICD_BASE_GPA, GICR_BASE_GPA);
+#endif
+
 	/* Start the iterations */
 	iteration = 0;
 	host_quit = false;
-- 
2.34.1.703.g22d0c6ccf7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
