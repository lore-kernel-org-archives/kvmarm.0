Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36FF8C433F5
	for <kvmarm@archiver.kernel.org>; Mon,  4 Apr 2022 18:21:35 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E27284B2DD;
	Mon,  4 Apr 2022 14:21:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1dAqmi+J5E9q; Mon,  4 Apr 2022 14:21:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E3AD54B2BC;
	Mon,  4 Apr 2022 14:21:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B3DC14B2BC
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Apr 2022 14:21:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id M2UFKD82p4zk for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Apr 2022 14:21:31 -0400 (EDT)
Received: from mail-io1-f73.google.com (mail-io1-f73.google.com
 [209.85.166.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A72794B1B4
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Apr 2022 14:21:30 -0400 (EDT)
Received: by mail-io1-f73.google.com with SMTP id
 k20-20020a5e9314000000b00649d55ffa67so6819854iom.20
 for <kvmarm@lists.cs.columbia.edu>; Mon, 04 Apr 2022 11:21:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=UF2I2mHbDVASrG05DEItZfczKpOZthJZ1m0MB3YjXVY=;
 b=tcxC71n8qRIQtoplY54rvL/t1PM0vquhFBE/lAZhF7XYLojblaLlklu7pRZ9UPnz2y
 1DCwD3eahwdyYR2x+Ew8gFONkQgrmXFyMrYjaAedHmdyKQpBNUDi7wvucA2nf0RRP4yj
 8OjE3G6p/9MKRMB/fxfL3GKqq53KeK6h/oL30r8siKj45GroFMnBACt2kw/jhcfQdX1P
 974RrKtOT0HPojjuNUxVR1SbbTgex41Y1OzCalE1p4ke0cTnIXpM+TDnXprsmKu77tq2
 TagfXw6GPklrVI7x9HWxjeG8KMzXtBHH0KsZRB90fzH0AifnWI5EC/CBe2S2gKzQjerQ
 GO9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=UF2I2mHbDVASrG05DEItZfczKpOZthJZ1m0MB3YjXVY=;
 b=v/fudUaS0b3uyQx4O41hSLSbolAum7I0uTAMVBK152ywMcWs7yTccwkHi+mhAsbO0V
 3Z5RBO8ODQ9AbxZqM3CERkAuNyEEt5u3HqzZIQBNoPfChk8XMqh8F+k3U5pVqc5oQpz8
 7wn0oE7cwqPN//T8thBzC1LPbbrjpzQ9R0J1+cOQssdJlFyapUysCsF67uwVWMatWf2p
 zwlPx/aKb6A6IsrpBUtehjqIqnNwn+FHtD6c69E8uUGnriGePIw2WZeunYVjozbD8/XR
 pTH8xPTPDm7Ji9SxQf7EBua/LPGJBjJ5uNMTBmH2saTUDIqDpWrMURwoq3O4775BVw4C
 m7kw==
X-Gm-Message-State: AOAM533MSqVSuJhHO5IjWuJ9yqKNL+hAtiz9AOvWbtErxY1sl6ZnwBBb
 kJr7/7O+hySs0oCRVVhhvf1PGL+RsXqztrU4yE7LZRXk5CBM5rTRRZTDf1W/0zhYcM8B6qNE2eB
 +58aZ0QQyXu50Zeg7uTUktLb6qVwENkiI82dr2Ln8fII7zUbUmlVN1wXSVR+eSXuZwilHhA==
X-Google-Smtp-Source: ABdhPJxMtg0K6INoCkIU+22+KIhOsbvZj/wp5fDFQBYNYjykIapUx1/xqAWiebo8OINm+4A3zMI6PtlF6Z0=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a5d:81d4:0:b0:649:ac07:27b with
 SMTP id
 t20-20020a5d81d4000000b00649ac07027bmr688893iol.216.1649096490046; Mon, 04
 Apr 2022 11:21:30 -0700 (PDT)
Date: Mon,  4 Apr 2022 18:21:18 +0000
In-Reply-To: <20220404182119.3561025-1-oupton@google.com>
Message-Id: <20220404182119.3561025-3-oupton@google.com>
Mime-Version: 1.0
References: <20220404182119.3561025-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH v2 2/3] selftests: KVM: Don't leak GIC FD across dirty log
 test iterations
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
Reviewed-by: Jing Zhang <jingzhangos@google.com>
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
