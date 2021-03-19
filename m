Return-Path: <SRS0=QSSN=IR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06E02C433E6
	for <kvmarm@archiver.kernel.org>; Fri, 19 Mar 2021 10:02:02 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8B7AD64F6C
	for <kvmarm@archiver.kernel.org>; Fri, 19 Mar 2021 10:02:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8B7AD64F6C
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2B5444B673;
	Fri, 19 Mar 2021 06:02:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gu+bFc1qPn5E; Fri, 19 Mar 2021 06:02:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1798C4B611;
	Fri, 19 Mar 2021 06:02:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2F1624B660
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Mar 2021 06:01:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 74v12K0xdpCW for <kvmarm@lists.cs.columbia.edu>;
 Fri, 19 Mar 2021 06:01:57 -0400 (EDT)
Received: from mail-qt1-f201.google.com (mail-qt1-f201.google.com
 [209.85.160.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D58C04B666
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Mar 2021 06:01:56 -0400 (EDT)
Received: by mail-qt1-f201.google.com with SMTP id l63so25430725qtd.23
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Mar 2021 03:01:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=L8AAIWNPQ1dDcNSKWQN4i2g9ce1CACsE0X8GRkSHj90=;
 b=Pcm6wU40nGG0YhjEol37j/ewblPwYvFhlLgWN91mTyD0kxTOBsq2a59qIxLHbYVy6G
 B5zS167jRT9oi0j2bp/x41+NrBkyHy86UU9pc6G+oANJZRyVzvlshJVeIl5l5TkevLD0
 sbEu3TjHOIE55q7qxkgo+UKMOn959rWeI5xcWwZA6c1ttJD4tn+nSP7cwtKkEsO38SY5
 n8c8Brt/uDvVt6+Ff+M35Q6fob9GMGj4Az+1Ri0hWLJWagZiq9pcPr4VDzYT3QkGwT+j
 0yVyXH8ScOcsxF4/zeAalRj93GZonUpB37oUmmwGa8KWY3dqA6Xt8jb4RksP7LcGrTE0
 uzxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=L8AAIWNPQ1dDcNSKWQN4i2g9ce1CACsE0X8GRkSHj90=;
 b=dQy3tfj/fYznCHxWWg5Rd5SEljv9rMczsbDPFY7j1lT/+U6K6P4d9IjuWAugnxw5Hn
 7X7RLEISmnEcsLx31sCN4zetNNFGxOh+hAv89TJYxMGsAjGn4e75fQb3wVIHFuQm6YP6
 HOcLTAKYsfSfQpu59I1BidmhmGtV1D/Cha/FyYe4DKGTVIDsKtAvBbZYQD79SmdMSsJP
 HNinZaScuHsGbcSzvLAnDDagIdgEZWaODyhUSfOweUnUkkIY+re6TLsDOFdwU5z6pNZ8
 78uUcNlKByPAUvv4rWjSnupFzqJk0fxmg+WIh1hdmMURlnZ6igrjyauS1hXGnhinUueP
 idvQ==
X-Gm-Message-State: AOAM532cOM2ybHZbSju67Z2MYG686QEmABAs9idvlkHngOlaoxMjOH5R
 z656rU/NB9eCke72AioY6aSIGhNTywEX
X-Google-Smtp-Source: ABdhPJylTBpllrzbNU1hsJ94TpGfGbuEg2eHq9YgD2GjQ6sGtuJuBOTMUzeDJ995BgRllOopErKmECSQYOT2
X-Received: from r2d2-qp.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:ad4:4ab0:: with SMTP id
 i16mr8495782qvx.1.1616148116390; Fri, 19 Mar 2021 03:01:56 -0700 (PDT)
Date: Fri, 19 Mar 2021 10:01:11 +0000
In-Reply-To: <20210319100146.1149909-1-qperret@google.com>
Message-Id: <20210319100146.1149909-4-qperret@google.com>
Mime-Version: 1.0
References: <20210319100146.1149909-1-qperret@google.com>
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
Subject: [PATCH v6 03/38] arm64: kvm: Add standalone ticket spinlock
 implementation for use at hyp
From: Quentin Perret <qperret@google.com>
To: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
Cc: android-kvm@google.com, seanjc@google.com, mate.toth-pal@arm.com,
 linux-kernel@vger.kernel.org, robh+dt@kernel.org, tabba@google.com,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
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

From: Will Deacon <will@kernel.org>

We will soon need to synchronise multiple CPUs in the hyp text at EL2.
The qspinlock-based locking used by the host is overkill for this purpose
and relies on the kernel's "percpu" implementation for the MCS nodes.

Implement a simple ticket locking scheme based heavily on the code removed
by commit c11090474d70 ("arm64: locking: Replace ticket lock implementation
with qspinlock").

Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/include/nvhe/spinlock.h | 92 ++++++++++++++++++++++
 1 file changed, 92 insertions(+)
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/spinlock.h

diff --git a/arch/arm64/kvm/hyp/include/nvhe/spinlock.h b/arch/arm64/kvm/hyp/include/nvhe/spinlock.h
new file mode 100644
index 000000000000..76b537f8d1c6
--- /dev/null
+++ b/arch/arm64/kvm/hyp/include/nvhe/spinlock.h
@@ -0,0 +1,92 @@
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
2.31.0.rc2.261.g7f71774620-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
