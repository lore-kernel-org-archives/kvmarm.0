Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE9B6C433EF
	for <kvmarm@archiver.kernel.org>; Wed,  6 Apr 2022 23:56:28 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9491B4B1BF;
	Wed,  6 Apr 2022 19:56:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2CZ9ToCsEN+A; Wed,  6 Apr 2022 19:56:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8AF4A4B1D5;
	Wed,  6 Apr 2022 19:56:27 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B51554B1F7
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Apr 2022 19:56:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0HE0fLE1CHWD for <kvmarm@lists.cs.columbia.edu>;
 Wed,  6 Apr 2022 19:56:25 -0400 (EDT)
Received: from mail-il1-f201.google.com (mail-il1-f201.google.com
 [209.85.166.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8ACEA4B16F
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Apr 2022 19:56:25 -0400 (EDT)
Received: by mail-il1-f201.google.com with SMTP id
 y19-20020a056e02119300b002c2d3ef05bfso2727741ili.18
 for <kvmarm@lists.cs.columbia.edu>; Wed, 06 Apr 2022 16:56:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=UF2I2mHbDVASrG05DEItZfczKpOZthJZ1m0MB3YjXVY=;
 b=CxQm71obckQx1ot8ttP2ziACqWcKGK4akKG1COLV+bQWzBRg9Azn3q2fUw6u0mZ4La
 mlTSehKe88RUN3Cqari2K1UKweOzh7gRY7rvke0Sxra/LR5yabTeWR3pb6gABgpAiFbh
 3LDUmHjknj3TOpwWLKKUTTr8xa2BRA6ZKHLZWppjCqiXKxKE/+315ZNXsiA0KQ1Himyk
 YBv93Eof/Lgya4aIH5+cvdaqrqFkT48ZnEXupNIiuuliGu6MX1nMotBFktHb532z7a6I
 14qW8I7whAReD61AEBQsI04P7UtTOM97tMAbHs6qs1AgQwe85gA4jCx8P8vj1JGqCJWd
 63PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=UF2I2mHbDVASrG05DEItZfczKpOZthJZ1m0MB3YjXVY=;
 b=RakGZQMToTaAHc6I3+OQeAd1K5jNfrQckKprLVKCB9NXJpnBAvLsjseyTgMsUM0dWI
 n4sTR9D2CHtRcolZXEXfagvYUoXacL6atdU4cKi2DDWplTrVkA8yKBJ1nGZtvFzDyMNO
 HZ7mix3sMH7rK+oTXWFVbl23gwiu6GXIiMlX3xlTKkt+N9haGvOcw/6HQr6P54whfrmB
 t+E77Boz8pFGtXyykh7GV8AIxQBppQbAPz3ctSBeyHjbZNvzIGbBNycMCCSaKILws0q6
 meSSxWOipiePY/HI2vslk8SlwQw//7+/onsOd3KZFDP2Tewd7GRrSkvGSPbn01q/devh
 BnwA==
X-Gm-Message-State: AOAM531006cm3PN9silFzEWOmmHBLFbM+BYWrLTmr0QnfHGSd7U+ymYm
 dtNCq8QN8y3ghi0i7j0BrkVhl5+jotjMmvs7u28zvmGlr7BXeLVf2KtfI00R3L7yCFuXcn2XZtL
 uz0FY9E4VNYK5W78NDchtY5XmiEGKsKBSVk5pcMxQuB/KSzQcYTFvKIv+XxkchdA1cHWEGA==
X-Google-Smtp-Source: ABdhPJxZYhapYayA71PbkdV1563SUH1JsWUENhomJcQekruoJ8CSaLV4CpWvvqb90+EKwQyAk2ignByhlAY=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a92:7513:0:b0:2b9:5b61:e376 with
 SMTP id
 q19-20020a927513000000b002b95b61e376mr5694259ilc.193.1649289384698; Wed, 06
 Apr 2022 16:56:24 -0700 (PDT)
Date: Wed,  6 Apr 2022 23:56:14 +0000
In-Reply-To: <20220406235615.1447180-1-oupton@google.com>
Message-Id: <20220406235615.1447180-3-oupton@google.com>
Mime-Version: 1.0
References: <20220406235615.1447180-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH v3 2/3] selftests: KVM: Don't leak GIC FD across dirty log
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
