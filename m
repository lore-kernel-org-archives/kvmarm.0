Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A377C43217
	for <kvmarm@archiver.kernel.org>; Sat,  2 Apr 2022 17:40:56 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D544C4B29D;
	Sat,  2 Apr 2022 13:40:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3hZllKKTjvO3; Sat,  2 Apr 2022 13:40:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D39ED4B2C7;
	Sat,  2 Apr 2022 13:40:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8F9A04B28B
 for <kvmarm@lists.cs.columbia.edu>; Sat,  2 Apr 2022 13:40:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YD4Bc1GJialE for <kvmarm@lists.cs.columbia.edu>;
 Sat,  2 Apr 2022 13:40:52 -0400 (EDT)
Received: from mail-il1-f202.google.com (mail-il1-f202.google.com
 [209.85.166.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1CFE04B270
 for <kvmarm@lists.cs.columbia.edu>; Sat,  2 Apr 2022 13:40:52 -0400 (EDT)
Received: by mail-il1-f202.google.com with SMTP id
 s14-20020a056e021a0e00b002c7c03a5d81so3736192ild.9
 for <kvmarm@lists.cs.columbia.edu>; Sat, 02 Apr 2022 10:40:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=LigwUYYC4VhhxtS09KVFjs0sG5saYpBwvbWZHNyydng=;
 b=NKUIbjH0SKkdci4xkrqxucxb4e10J6YzgfEfrWlPOqo3uYmRUoKeqDouP/VcaTUvyo
 IBtov8VN/WlMjY1AwlrTF/UlDsXZZhQIup+60SHoXNF+IBnrEq80Jm/xGAPE6FtblLO8
 S7FspLtgNxHx0//bc+A+whljvxEEpt6UgvRU4fLs4jyX+w5O1S1NuhIVpg2TKj6f0vB2
 vSN32ViMyY0L3YTcACI6hYyldUmccE3BfHkJJoXNav/9Q6QCb7WI7RCLQ1wiPhvL36TZ
 fM4kSaF2LZOqxDIoXOO1LhhCS324eDYXPaixU4V3ueEMIRLgJBAfcTEA6elYTHEqMW23
 f95g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=LigwUYYC4VhhxtS09KVFjs0sG5saYpBwvbWZHNyydng=;
 b=iu4J3RROaxCLHGHitu01dVsaUxA41uAd+/0GoOCF5jXvlTYJTQdSRA7XbYNg+CBOKE
 85BY0h52VTWeeiNyfm4MX+4CK0CehJ2f1IMsML7SImLZ1nDLC/PUzKW//I1i7y5Ib40v
 VyTgpaHmL/aP82t99Znj9gIIfpxhc1lfdLbTaNwfbecFZKGeV0UcobRboB1pUQ+FGEkP
 LVjQsSY6wBCjPo5FQ0hmN7ChQFKmZ6Ay3y1ki+4pV9dGfb8Ja4DuXBO3kLem1pY4BOfm
 vBQuL9QVZSMKbUCQrPdu8cntQYajYBHPs2JPzDFOjHoP07bKIQ1DAJUOaNKrj0z8VaVF
 r+kA==
X-Gm-Message-State: AOAM531UUQiszycmJ3oHb5aGp6J4bivx3DxaA/xOcispHRlkBips0hXn
 u0kpSLRbDE9pFyM11z99VdLr1fxaxJSLvLU9CT2ASnyQ1FBMwGD741Tamlo5hM97HqBO/NBxQ6t
 S9XiKq2oweq7lcCqP/I4DF2V0Pq/r5KV9lWWs8zz49Yoe6nfO+1u0BKdSMq5WRPlgXJnTbA==
X-Google-Smtp-Source: ABdhPJzrUyhT2WOyKdGPJLj7xi4+5aFDvMGMKgqgDavuwSTfoHM1dfGkKHZDJs1ky+LEGuWCsDpRGcVe1NE=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6e02:d88:b0:2c8:713f:dcff
 with SMTP id
 i8-20020a056e020d8800b002c8713fdcffmr2189656ilj.289.1648921251615; Sat, 02
 Apr 2022 10:40:51 -0700 (PDT)
Date: Sat,  2 Apr 2022 17:40:43 +0000
In-Reply-To: <20220402174044.2263418-1-oupton@google.com>
Message-Id: <20220402174044.2263418-4-oupton@google.com>
Mime-Version: 1.0
References: <20220402174044.2263418-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH 3/4] selftests: KVM: Don't leak GIC FD across dirty log test
 iterations
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 linux-arm-kernel@lists.infradead.org
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

dirty_log_perf_test instantiates a VGICv3 for the guest (if supported by
hardware) to reduce the overhead of guest exits. However, the test does
not actually close the GIC fd when cleaning up the VM between test
iterations, meaning that the VM is never actually destroyed in the
kernel.

While this is generally a bad idea, the bug was detected from the kernel
spewing about duplicate debugfs entries as subsequent VMs happen to
reuse the same FD even though the debugfs directory is still present.

Abstract away the notion of setup/cleanup of the GIC FD from the test
by creating arch-specific helpers for test setup/cleanup. Close the GIC
FD on VM cleanup and do nothing for the other architectures.

Fixes: c340f7899af6 ("KVM: selftests: Add vgic initialization for dirty log perf test for ARM")
Cc: Jing Zhang <jingzhangos@google.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 .../selftests/kvm/dirty_log_perf_test.c       | 34 +++++++++++++++++--
 1 file changed, 31 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
index c9d9e513ca04..7b47ae4f952e 100644
--- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
@@ -18,11 +18,40 @@
 #include "test_util.h"
 #include "perf_test_util.h"
 #include "guest_modes.h"
+
 #ifdef __aarch64__
 #include "aarch64/vgic.h"
 
 #define GICD_BASE_GPA			0x8000000ULL
 #define GICR_BASE_GPA			0x80A0000ULL
+
+static int gic_fd;
+
+static void arch_setup_vm(struct kvm_vm *vm, unsigned int nr_vcpus)
+{
+	/*
+	 * The test can still run even if hardware does not support GICv3, as it
+	 * is only an optimization to reduce guest exits.
+	 */
+	gic_fd = vgic_v3_setup(vm, nr_vcpus, 64, GICD_BASE_GPA, GICR_BASE_GPA);
+}
+
+static void arch_cleanup_vm(struct kvm_vm *vm)
+{
+	if (gic_fd > 0)
+		close(gic_fd);
+}
+
+#else /* __aarch64__ */
+
+static void arch_setup_vm(struct kvm_vm *vm, unsigned int nr_vcpus)
+{
+}
+
+static void arch_cleanup_vm(struct kvm_vm *vm)
+{
+}
+
 #endif
 
 /* How many host loops to run by default (one KVM_GET_DIRTY_LOG for each loop)*/
@@ -206,9 +235,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 		vm_enable_cap(vm, &cap);
 	}
 
-#ifdef __aarch64__
-	vgic_v3_setup(vm, nr_vcpus, 64, GICD_BASE_GPA, GICR_BASE_GPA);
-#endif
+	arch_setup_vm(vm, nr_vcpus);
 
 	/* Start the iterations */
 	iteration = 0;
@@ -302,6 +329,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	}
 
 	free_bitmaps(bitmaps, p->slots);
+	arch_cleanup_vm(vm);
 	perf_test_destroy_vm(vm);
 }
 
-- 
2.35.1.1094.g7c7d902a7c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
