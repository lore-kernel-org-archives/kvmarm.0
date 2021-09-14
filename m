Return-Path: <SRS0=7Ft5=OE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBC09C433EF
	for <kvmarm@archiver.kernel.org>; Tue, 14 Sep 2021 22:31:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7D7F461178
	for <kvmarm@archiver.kernel.org>; Tue, 14 Sep 2021 22:31:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 7D7F461178
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 31CBB4B0E7;
	Tue, 14 Sep 2021 18:31:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KUbExkYxO1Nl; Tue, 14 Sep 2021 18:31:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E31564B12E;
	Tue, 14 Sep 2021 18:31:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D0984B161
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Sep 2021 18:31:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id h+i5wtiVesh1 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 14 Sep 2021 18:31:47 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 37E154B1B0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Sep 2021 18:31:47 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id
 j9-20020a2581490000b02905897d81c63fso933000ybm.8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Sep 2021 15:31:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=ap1ftYDLPyFEEpyKZVnsUXcIKPkxVpyeCr5WbufecSE=;
 b=CjFqjry3wo3EQPMz5M99dDU9C/SJybGkzsqWG/YDHqzkvfrMClsP6/tYCnkQ6mabGN
 ciRWxPdsotKE2bFCar/MqFTkNSNrjzafeoEsbrVqtUP1YHsQ5oA7EzkCrWaS3DUV8edz
 /wQ2KKAXSnINeEpXioFtHmJs2fA6eGzFjENcKZjm8/kYZUTvinu8Zf5CYFKRn1bW+iwW
 /yuPsTBbs6j43kZgKAReV/AbVhWd/mZC09YjNPzfAi5zRCsUYVQmqdi7wyvLj5Hm+sEO
 1+iFZ9J9NQurs9j2BCPUcxJdDOC/ao0/6qc1mJBn4hWI5TvP5xxL2glsMvmkZuY8U+uJ
 fKYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=ap1ftYDLPyFEEpyKZVnsUXcIKPkxVpyeCr5WbufecSE=;
 b=yzoWZ/jbA+heDv+QjidTJx5eO2334gzfTOPboS1bJmxE2ykVUvdF0q1BaDSVxgEKrj
 7ZWU3ZPY1yQSBy3wb271rESNjrgzqToMDrzqbLKNlOuJGcS50QzPOywHdwdq5zNwRpjG
 H5TQ44bADSzQfgMLtDje5uzWWrb/0KV73sk8tJ2cnB9X0+wUiq+P29hREIgPYU1Oj8KX
 pMfoDNfv/QNjN4lJNrrrSqVajpiEv4xOh6qFSQN/At1g/xpzI31si+iLl+B4+GWH0bBV
 yvwNz+nyr1x128NafslZtV5ZSafkl7j3mRdLItVHS51zyri0xgVKyhvUilMbXnb75mMa
 9TgA==
X-Gm-Message-State: AOAM533DLuJcGyglmTpgUZ1IfVatQJPHmWzBj6Whghh+XUbiwjm6Kde3
 bBRt4bFLhJrMj28DqMwW0+dGKJLSFJbH
X-Google-Smtp-Source: ABdhPJxBaFLFKMu3q6qk1EwMRDGG2Dza3QEyOnAPZV3kJ7MvX3zS4aMl29r5sI9FcTr45XcEBNh5JCxPXY7Z
X-Received: from rananta-virt.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a25:16c6:: with SMTP id
 189mr1901322ybw.27.1631658706802; Tue, 14 Sep 2021 15:31:46 -0700 (PDT)
Date: Tue, 14 Sep 2021 22:31:10 +0000
In-Reply-To: <20210914223114.435273-1-rananta@google.com>
Message-Id: <20210914223114.435273-12-rananta@google.com>
Mime-Version: 1.0
References: <20210914223114.435273-1-rananta@google.com>
X-Mailer: git-send-email 2.33.0.309.g3052b89438-goog
Subject: [PATCH v7 11/15] KVM: arm64: selftests: Add light-weight spinlock
 support
From: Raghavendra Rao Ananta <rananta@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
 Andrew Jones <drjones@redhat.com>, James Morse <james.morse@arm.com>, 
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
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

Add a simpler version of spinlock support for ARM64 for
the guests to use.

The implementation is loosely based on the spinlock
implementation in kvm-unit-tests.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
Reviewed-by: Oliver Upton <oupton@google.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
---
 tools/testing/selftests/kvm/Makefile          |  2 +-
 .../selftests/kvm/include/aarch64/spinlock.h  | 13 +++++++++
 .../selftests/kvm/lib/aarch64/spinlock.c      | 27 +++++++++++++++++++
 3 files changed, 41 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/kvm/include/aarch64/spinlock.h
 create mode 100644 tools/testing/selftests/kvm/lib/aarch64/spinlock.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 5d05801ab816..61f0d376af99 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -35,7 +35,7 @@ endif
 
 LIBKVM = lib/assert.c lib/elf.c lib/io.c lib/kvm_util.c lib/rbtree.c lib/sparsebit.c lib/test_util.c lib/guest_modes.c lib/perf_test_util.c
 LIBKVM_x86_64 = lib/x86_64/apic.c lib/x86_64/processor.c lib/x86_64/vmx.c lib/x86_64/svm.c lib/x86_64/ucall.c lib/x86_64/handlers.S
-LIBKVM_aarch64 = lib/aarch64/processor.c lib/aarch64/ucall.c lib/aarch64/handlers.S
+LIBKVM_aarch64 = lib/aarch64/processor.c lib/aarch64/ucall.c lib/aarch64/handlers.S lib/aarch64/spinlock.c
 LIBKVM_s390x = lib/s390x/processor.c lib/s390x/ucall.c lib/s390x/diag318_test_handler.c
 
 TEST_GEN_PROGS_x86_64 = x86_64/cr4_cpuid_sync_test
diff --git a/tools/testing/selftests/kvm/include/aarch64/spinlock.h b/tools/testing/selftests/kvm/include/aarch64/spinlock.h
new file mode 100644
index 000000000000..cf0984106d14
--- /dev/null
+++ b/tools/testing/selftests/kvm/include/aarch64/spinlock.h
@@ -0,0 +1,13 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef SELFTEST_KVM_ARM64_SPINLOCK_H
+#define SELFTEST_KVM_ARM64_SPINLOCK_H
+
+struct spinlock {
+	int v;
+};
+
+extern void spin_lock(struct spinlock *lock);
+extern void spin_unlock(struct spinlock *lock);
+
+#endif /* SELFTEST_KVM_ARM64_SPINLOCK_H */
diff --git a/tools/testing/selftests/kvm/lib/aarch64/spinlock.c b/tools/testing/selftests/kvm/lib/aarch64/spinlock.c
new file mode 100644
index 000000000000..a076e780be5d
--- /dev/null
+++ b/tools/testing/selftests/kvm/lib/aarch64/spinlock.c
@@ -0,0 +1,27 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * ARM64 Spinlock support
+ */
+#include <stdint.h>
+
+#include "spinlock.h"
+
+void spin_lock(struct spinlock *lock)
+{
+	int val, res;
+
+	asm volatile(
+	"1:	ldaxr	%w0, [%2]\n"
+	"	cbnz	%w0, 1b\n"
+	"	mov	%w0, #1\n"
+	"	stxr	%w1, %w0, [%2]\n"
+	"	cbnz	%w1, 1b\n"
+	: "=&r" (val), "=&r" (res)
+	: "r" (&lock->v)
+	: "memory");
+}
+
+void spin_unlock(struct spinlock *lock)
+{
+	asm volatile("stlr wzr, [%0]\n"	: : "r" (&lock->v) : "memory");
+}
-- 
2.33.0.309.g3052b89438-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
