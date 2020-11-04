Return-Path: <SRS0=PxFR=EK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25AF5C63697
	for <kvmarm@archiver.kernel.org>; Wed,  4 Nov 2020 18:37:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 939F020BED
	for <kvmarm@archiver.kernel.org>; Wed,  4 Nov 2020 18:37:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="Hkql7qgZ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 939F020BED
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3605A4B78E;
	Wed,  4 Nov 2020 13:37:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id juXpfx51EkEn; Wed,  4 Nov 2020 13:37:17 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0CB254B7B9;
	Wed,  4 Nov 2020 13:37:17 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9CFB94B6A3
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Nov 2020 13:37:15 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6BmMXUVdndiy for <kvmarm@lists.cs.columbia.edu>;
 Wed,  4 Nov 2020 13:37:14 -0500 (EST)
Received: from mail-wm1-f66.google.com (mail-wm1-f66.google.com
 [209.85.128.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8884A4B780
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Nov 2020 13:37:14 -0500 (EST)
Received: by mail-wm1-f66.google.com with SMTP id v5so3365253wmh.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 04 Nov 2020 10:37:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=IMhhhU6UDnCZic4U0v9mlSCvJc9/cDfep6l/EJNs2R8=;
 b=Hkql7qgZIh094H5VuYpSIVjy6kzgeDA8ZQgltyGOpECDIh8BxbtQ1vC2IP76Y8D/SW
 26fZ8diz3rjUlyZpgj+lmnh+rbYfjbMuzRqgpNGGA9X3yiyb6w6ST9GX+8zgdximBtLq
 LPzGXkiCl821fIRBlBt/yFj2EEHQXAkFtg4HenFUa6IyY7c/084XL0mVBsEwNoTqcnMv
 eiLz/WnUFvb4/K1mS6CckAIwJqhddN3kU7pWeQR9kXwxCmAz6AK4aPP6iJG6VFR61m9v
 bk4NZXV6Qkoh7xR9BqCaqTfXmbEwRJirP5X7z2dnIfwK5n74woEhG7QE9IG/BCgsaWn/
 p3Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=IMhhhU6UDnCZic4U0v9mlSCvJc9/cDfep6l/EJNs2R8=;
 b=hrLicDZpuzukslRGQipcf67+a1BQo0q+CgDHPVlGgiRe6naMIe1RpegZB6FH5PwrMw
 OQH2xvG0BoiZYmsmYhbBWuvTr3V7A60nAM69RZ6grC3JPxbNn+q9ZXEKXbsJkdzIqSQl
 odi9zE/rJjcCucuTdYpQR3I32Y9o0ESbyWAXHeQqkdmU14It8q0JxcDdr0NSG/3+Ofsz
 SDpWhfDSxGs5F+5O748DOaB1QWtpi1RdFOYWMMw3Z9yeD29OmHFljMqybH6+824ibcA2
 Qrs6KVaE5SvB9pVonxNpHaM7WNqcmY+J0j2QsXrc7JGzYcTYAoxZc1dnwg8F4x0qylgy
 Zo7w==
X-Gm-Message-State: AOAM533whXw5DOVBoSd5Mrzfe8zXvP17HPwcJFm1+azAxFXZTBTPPXdP
 mz6I8uQgCKrxszUGZiYWsw8QChYkDjD9Arfk
X-Google-Smtp-Source: ABdhPJxt0mB9KgegrPj+SMz071z9EVqKZNk74keSqXTEW6yH2qJ021T+2wo2kFQ+H/1RCbQ7PtqAxA==
X-Received: by 2002:a7b:cc0e:: with SMTP id f14mr5978436wmh.92.1604515030088; 
 Wed, 04 Nov 2020 10:37:10 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:c8d2:30f2:53c6:bc2])
 by smtp.gmail.com with ESMTPSA id w186sm3078822wmb.26.2020.11.04.10.37.08
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 04 Nov 2020 10:37:09 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [RFC PATCH 15/26] arm64: kvm: Add standalone ticket spinlock
 implementation for use at hyp
Date: Wed,  4 Nov 2020 18:36:19 +0000
Message-Id: <20201104183630.27513-16-dbrazdil@google.com>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201104183630.27513-1-dbrazdil@google.com>
References: <20201104183630.27513-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, kernel-team@android.com,
 Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>, Tejun Heo <tj@kernel.org>,
 Dennis Zhou <dennis@kernel.org>, Christoph Lameter <cl@linux.com>,
 Will Deacon <will@kernel.org>
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
and relies on the kernel's "percpu" implementation for the MCS nodes.

Implement a simple ticket locking scheme based heavily on the code removed
by commit c11090474d70 ("arm64: locking: Replace ticket lock implementation
with qspinlock").

Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/kvm/hyp/include/nvhe/spinlock.h | 96 ++++++++++++++++++++++
 1 file changed, 96 insertions(+)
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/spinlock.h

diff --git a/arch/arm64/kvm/hyp/include/nvhe/spinlock.h b/arch/arm64/kvm/hyp/include/nvhe/spinlock.h
new file mode 100644
index 000000000000..dc0397e5b5f2
--- /dev/null
+++ b/arch/arm64/kvm/hyp/include/nvhe/spinlock.h
@@ -0,0 +1,96 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * A stand-alone ticket spinlock implementation for use by the non-VHE
+ * KVM hypervisor code running at EL2.
+ *
+ * Copyright (C) 2020 Google LLC
+ * Author: Will Deacon <will@kernel.org>
+ *
+ * Heavily based on the implementation removed by c11090474d70 which was:
+ * Copyright (C) 2012 ARM Ltd.
+ */
+
+#ifndef __KVM_NVHE_HYPERVISOR__
+#error "Attempt to include nVHE code outside of EL2 object"
+#endif
+
+#ifndef __ARM64_KVM_NVHE_SPINLOCK_H__
+#define __ARM64_KVM_NVHE_SPINLOCK_H__
+
+#include <asm/alternative.h>
+#include <asm/lse.h>
+
+typedef union hyp_spinlock {
+	u32	__val;
+	struct {
+#ifdef __AARCH64EB__
+		u16 next, owner;
+#else
+		u16 owner, next;
+	};
+#endif
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
+	ARM64_LSE_ATOMIC_INSN(
+	/* LL/SC */
+"	prfm	pstl1strm, %3\n"
+"1:	ldaxr	%w0, %3\n"
+"	add	%w1, %w0, #(1 << 16)\n"
+"	stxr	%w2, %w1, %3\n"
+"	cbnz	%w2, 1b\n",
+	/* LSE atomics */
+"	mov	%w2, #(1 << 16)\n"
+"	ldadda	%w2, %w0, %3\n"
+	__nops(3))
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
+	ARM64_LSE_ATOMIC_INSN(
+	/* LL/SC */
+	"	ldrh	%w1, %0\n"
+	"	add	%w1, %w1, #1\n"
+	"	stlrh	%w1, %0",
+	/* LSE atomics */
+	"	mov	%w1, #1\n"
+	"	staddlh	%w1, %0\n"
+	__nops(1))
+	: "=Q" (lock->owner), "=&r" (tmp)
+	:
+	: "memory");
+}
+
+#endif /* __ARM64_KVM_NVHE_SPINLOCK_H__ */
-- 
2.29.1.341.ge80a0c044ae-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
