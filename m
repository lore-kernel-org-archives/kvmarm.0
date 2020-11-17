Return-Path: <SRS0=VcQF=EX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4F64C2D0E4
	for <kvmarm@archiver.kernel.org>; Tue, 17 Nov 2020 18:16:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4F03C2100A
	for <kvmarm@archiver.kernel.org>; Tue, 17 Nov 2020 18:16:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="m4MI8sDp"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4F03C2100A
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DFD0F4B5D6;
	Tue, 17 Nov 2020 13:16:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fxHKtbKeGevU; Tue, 17 Nov 2020 13:16:29 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 992D44B861;
	Tue, 17 Nov 2020 13:16:29 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5AA974B5F8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Nov 2020 13:16:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fIFNrj8mrrRF for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Nov 2020 13:16:27 -0500 (EST)
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com
 [209.85.128.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 178974B851
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Nov 2020 13:16:27 -0500 (EST)
Received: by mail-wm1-f73.google.com with SMTP id d2so24668wmd.8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Nov 2020 10:16:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=NKT870NUlC/fR/KT4iQDh391rPBCM0t1P6CT6nmxduk=;
 b=m4MI8sDpmwsqB62UcR7cNmGEWAr1ts32ZyLwXA1tnB9t+yJAMMGil4BHA5iGFJ7isM
 umGqL0u0iLk+qAebFVa2/UT/SQWeeh7tni7O556SIB6aDKkpJxCYHRGUoUB/25AJyogM
 m0GtNJ9pve1RrMyvX1nGKvXZMC5UI2L2akL8ld7Q4/y+8HqxmmV9yUUCBjG3B1alizqu
 8zjAts8U7BaAYdyVNKihGgQdLMb6oQFGE2FpINJY51qA6o8yP59LmhW7Ib9PbyrhYwXD
 MkzMfv1BcHdsGpSFaKYYevM+SLgZoP9bPFgKtRVWF2iuGJDAmZDeIv19lHS+uvxwOZfN
 +4Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=NKT870NUlC/fR/KT4iQDh391rPBCM0t1P6CT6nmxduk=;
 b=mR0Mj7KxlkYi3fS5YlnETDPvVLp8JGdh3V9eb11sgHkXQZo27kmn0LwGFWRNX4ORdF
 F30Q6cug6qfSkiHVijALjseUQ9ow777/ug8QPfVVbTYPkuR1x8i25idJP2mEPM+AT4EM
 FW5Kcy8BVD4aQdno2xLlyapfEpYEy79bVKKG63xcxmIkRUe3LA/YFLQamTObAenVg0+1
 K3YZBHEFmtEtu1Wutq9e6dOIadDpVEdYYkdECPyFIhFUkYabvAynetcLgPdRyY7MBM91
 VxtXJRNN6KeUabGPqfq93bfEZSG8pCF+p6M0FN1vUN3rC+mx3ZNuhLdU2r0JMsCdMWuv
 NINg==
X-Gm-Message-State: AOAM530PLPYh6svUnLodg9ciCUS2hdK5Zx0E82fbwpDCoNoz0KhtRgqZ
 oHMqdgYZ0GKEqhbjanRTw/Vkez7IrrfP
X-Google-Smtp-Source: ABdhPJwaipw8Yg+hF0IOY//Mk8QfB1T5Et/1Qnq5qCttJhd99HX+QQmEaSPNLhuQ7z/N6ynjdi4lLhEzca6o
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:f693:9fff:fef4:a7ef])
 (user=qperret job=sendgmr) by 2002:a1c:bc08:: with SMTP id
 m8mr360694wmf.137.1605636986141; Tue, 17 Nov 2020 10:16:26 -0800 (PST)
Date: Tue, 17 Nov 2020 18:15:43 +0000
In-Reply-To: <20201117181607.1761516-1-qperret@google.com>
Message-Id: <20201117181607.1761516-4-qperret@google.com>
Mime-Version: 1.0
References: <20201117181607.1761516-1-qperret@google.com>
X-Mailer: git-send-email 2.29.2.299.gdc1121823c-goog
Subject: [RFC PATCH 03/27] KVM: arm64: Add standalone ticket spinlock
 implementation for use at hyp
From: Quentin Perret <qperret@google.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Rob Herring <robh+dt@kernel.org>, Frank Rowand <frowand.list@gmail.com>
Cc: "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE"
 <devicetree@vger.kernel.org>, android-kvm@google.com,
 open list <linux-kernel@vger.kernel.org>, kernel-team@android.com,
 "open list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>,
 "moderated list:ARM64 PORT \(AARCH64 ARCHITECTURE\)"
 <linux-arm-kernel@lists.infradead.org>
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

From: Will Deacon <will@kernel.org>

We will soon need to synchronise multiple CPUs in the hyp text at EL2.
The qspinlock-based locking used by the host is overkill for this purpose
and requires a working "percpu" implementation for the MCS nodes.

Implement a simple ticket locking scheme based heavily on the code removed
by c11090474d70 ("arm64: locking: Replace ticket lock implementation with
qspinlock").

[ qperret: removed the __KVM_NVHE_HYPERVISOR__ build-time check from
  spinlock.h ]

Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/include/nvhe/spinlock.h | 95 ++++++++++++++++++++++
 arch/arm64/kvm/hyp/include/nvhe/util.h     | 25 ++++++
 2 files changed, 120 insertions(+)
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/spinlock.h
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/util.h

diff --git a/arch/arm64/kvm/hyp/include/nvhe/spinlock.h b/arch/arm64/kvm/hyp/include/nvhe/spinlock.h
new file mode 100644
index 000000000000..bbfe2cbd9f62
--- /dev/null
+++ b/arch/arm64/kvm/hyp/include/nvhe/spinlock.h
@@ -0,0 +1,95 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * A stand-alone ticket spinlock implementation, primarily for use by the
+ * non-VHE hypervisor code running at EL2.
+ *
+ * Copyright (C) 2020 Google LLC
+ * Author: Will Deacon <will@kernel.org>
+ *
+ * Heavily based on the implementation removed by c11090474d70 which was:
+ * Copyright (C) 2012 ARM Ltd.
+ */
+
+#ifndef __ARM64_KVM_HYP_SPINLOCK_H__
+#define __ARM64_KVM_HYP_SPINLOCK_H__
+
+#include <asm/alternative.h>
+
+typedef union hyp_spinlock {
+	u32	__val;
+	struct {
+#ifdef __AARCH64EB__
+		u16 next, owner;
+#else
+		u16 owner, next;
+#endif
+	};
+} hyp_spinlock_t;
+
+#define hyp_spin_lock_init(l)						\
+do {									\
+	*(l) = (hyp_spinlock_t){ .__val = 0 };				\
+} while (0)
+
+static inline void hyp_spin_lock(hyp_spinlock_t *lock)
+{
+	u32 tmp;
+	hyp_spinlock_t lockval, newval;
+
+	asm volatile(
+	/* Atomically increment the next ticket. */
+	ALTERNATIVE(
+	/* LL/SC */
+"	prfm	pstl1strm, %3\n"
+"1:	ldaxr	%w0, %3\n"
+"	add	%w1, %w0, #(1 << 16)\n"
+"	stxr	%w2, %w1, %3\n"
+"	cbnz	%w2, 1b\n",
+	/* LSE atomics */
+"	.arch_extension lse\n"
+"	mov	%w2, #(1 << 16)\n"
+"	ldadda	%w2, %w0, %3\n"
+	__nops(3),
+	ARM64_HAS_LSE_ATOMICS)
+
+	/* Did we get the lock? */
+"	eor	%w1, %w0, %w0, ror #16\n"
+"	cbz	%w1, 3f\n"
+	/*
+	 * No: spin on the owner. Send a local event to avoid missing an
+	 * unlock before the exclusive load.
+	 */
+"	sevl\n"
+"2:	wfe\n"
+"	ldaxrh	%w2, %4\n"
+"	eor	%w1, %w2, %w0, lsr #16\n"
+"	cbnz	%w1, 2b\n"
+	/* We got the lock. Critical section starts here. */
+"3:"
+	: "=&r" (lockval), "=&r" (newval), "=&r" (tmp), "+Q" (*lock)
+	: "Q" (lock->owner)
+	: "memory");
+}
+
+static inline void hyp_spin_unlock(hyp_spinlock_t *lock)
+{
+	u64 tmp;
+
+	asm volatile(
+	ALTERNATIVE(
+	/* LL/SC */
+	"	ldrh	%w1, %0\n"
+	"	add	%w1, %w1, #1\n"
+	"	stlrh	%w1, %0",
+	/* LSE atomics */
+	"	.arch_extension lse\n"
+	"	mov	%w1, #1\n"
+	"	staddlh	%w1, %0\n"
+	__nops(1),
+	ARM64_HAS_LSE_ATOMICS)
+	: "=Q" (lock->owner), "=&r" (tmp)
+	:
+	: "memory");
+}
+
+#endif /* __ARM64_KVM_HYP_SPINLOCK_H__ */
diff --git a/arch/arm64/kvm/hyp/include/nvhe/util.h b/arch/arm64/kvm/hyp/include/nvhe/util.h
new file mode 100644
index 000000000000..9c58cc436a83
--- /dev/null
+++ b/arch/arm64/kvm/hyp/include/nvhe/util.h
@@ -0,0 +1,25 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Standalone re-implementations of kernel interfaces for use at EL2.
+ * Copyright (C) 2020 Google LLC
+ * Author: Will Deacon <will@kernel.org>
+ */
+
+#ifndef __KVM_NVHE_HYPERVISOR__
+#error "Attempt to include nVHE code outside of EL2 object"
+#endif
+
+#ifndef __ARM64_KVM_NVHE_UTIL_H__
+#define __ARM64_KVM_NVHE_UTIL_H__
+
+/* Locking (hyp_spinlock_t) */
+#include <nvhe/spinlock.h>
+
+#undef spin_lock_init
+#define spin_lock_init				hyp_spin_lock_init
+#undef spin_lock
+#define spin_lock				hyp_spin_lock
+#undef spin_unlock
+#define	spin_unlock				hyp_spin_unlock
+
+#endif	/* __ARM64_KVM_NVHE_UTIL_H__ */
-- 
2.29.2.299.gdc1121823c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
