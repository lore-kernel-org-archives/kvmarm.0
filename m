Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 014A046453
	for <kvmarm@lists.linux.dev>; Fri, 19 Apr 2024 08:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713513643; cv=none; b=J+yMIQXwEWp28WeCZsL0z4X6x/vON73tTzyo/fR8f2VuZRN+Z29RuFsZAhQ6YGCY3UYeNqmwF2DVnDzc5GWVRg6EYmGzVvzi4yE26hS5ytkab8VV4rhkhMgqk1LbmD72rDoIVRwg0LTbIjepZGWaVCp281av14qE6mK6qxU+UAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713513643; c=relaxed/simple;
	bh=hW9A+WhCOqJ0bBwjzVi9ARiTNySoQC/rJskat6VliDE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gL6GkVMLu9Vnkk1SB5e2Ijf9jFq25TTSD0CLneTG6DqN3q2DfTkgtMvAvd2krI+/E4XIpoCytUbuioiOD82HzQDaWpDkUTPMH0wmignfH9O43e4BE7ZS9yUEpOsVjCTytvGeUIOKtMHxdCOMNqVMamSk2PFPCX0NBERwn0vlLwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Q7VdlH+8; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Q7VdlH+8"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-41895b0a62cso14471075e9.2
        for <kvmarm@lists.linux.dev>; Fri, 19 Apr 2024 01:00:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713513640; x=1714118440; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zAfPm4wxB8mr/GKzLEh8KPNmIJR+QM9e3U6iSVP00jM=;
        b=Q7VdlH+87cTYmImBWgXb4C2huBNYu7AHmChLlK8sKXRuueZwUjt4ah833MJyfH6p0e
         3oZTa/6brXUeC2Nv/raXGFhlJo9jIb9KV8JRJY8z2aPWu1RkW7AxqR4x6q24XWEoh3M7
         xYWikzl7Uu143E6qXg5x4+pQX01YuM58YtamEno8CtDhAoZnvOXwz17AN8waWnPGmSm3
         3hGmdHqSnK/ews8/jjhInU41NwFqLaeFtao2PDngVKpc2FrenRamuAvtuIlGbayHWi1W
         Yc+SMsn7NnyLvIofdo9Ir3JcchPAv9bgkiyFdbkg2Bv6Vpf4qxepLFU7CrxD++lx+fIy
         NiFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713513640; x=1714118440;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zAfPm4wxB8mr/GKzLEh8KPNmIJR+QM9e3U6iSVP00jM=;
        b=WaTynETcp2w3j5pqxKRQLAlB6dkLGh6U6xck3NRxtiLOpI1yNXlDk/raE0OTwUg+sQ
         Zy1AQziw1EKFgPA30FNlrnpCDenPJACTNvC/e0GBA9Ur7L9sJaZ1BKmS1Fznblypt6Iy
         il2Eq0A9QhU8KLcUBA5VnPGXbFfunygZ9Uv7HJ2XWuWdfUaAZYpRhZgfhxUq4DibpFJP
         ADKle5K2i1bDlhG7YG1GV3aQnd6kNv46kPNg+c5Yvo7f4Zrm7Q2I0loNybFZYwmpG9TA
         93lpDVIdQ50z8kBKUgBmoXGrKGHQNbwhIfTpQfMbqCtTUdq3/i6hVlyB0sO8hAxZ67Ef
         RokA==
X-Gm-Message-State: AOJu0YzyPine+vOAxmwvh5ZUfztJiiBcrCqB9tgyQ2TSIbS3xL7JTnOy
	toiiNlJC5FJHXqO8kiIgNegdwvrIB5a8uWanPKKElG/ewc0QqtU4m3w8bNcOpLtQ3ssdbMLjcIo
	9g1Y8a+BT+wn0pXBz35VZuVcRYSEgKoJ9haa1izvuKR8/EcfNnUlILQcSPs1Zd12pFkWsrVgri9
	atTP6WAz2LSaKALUd+mI5YZUgqWsM=
X-Google-Smtp-Source: AGHT+IGNTXjVUh/NHTdmUBPWqH/CTi+VxfMZVu7u8MBGMAP8JA/V23vreBMh1pgqfywmP9ifdgzBPz5z7g==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:600c:1c9b:b0:418:d635:9b7e with SMTP id
 k27-20020a05600c1c9b00b00418d6359b7emr7674wms.8.1713513640494; Fri, 19 Apr
 2024 01:00:40 -0700 (PDT)
Date: Fri, 19 Apr 2024 08:59:35 +0100
In-Reply-To: <20240419075941.4085061-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240419075941.4085061-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
Message-ID: <20240419075941.4085061-26-tabba@google.com>
Subject: [PATCH v3 25/31] KVM: arm64: Introduce hyp_rwlock_t
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, smostafa@google.com
Content-Type: text/plain; charset="UTF-8"

From: Will Deacon <will@kernel.org>

Introduce a simple counter-based rwlock for EL2 which can reduce locking
contention on read-mostly data structures when compared to a spinlock.

Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/include/nvhe/rwlock.h | 129 +++++++++++++++++++++++
 1 file changed, 129 insertions(+)
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/rwlock.h

diff --git a/arch/arm64/kvm/hyp/include/nvhe/rwlock.h b/arch/arm64/kvm/hyp/include/nvhe/rwlock.h
new file mode 100644
index 000000000000..365084497e59
--- /dev/null
+++ b/arch/arm64/kvm/hyp/include/nvhe/rwlock.h
@@ -0,0 +1,129 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * A stand-alone rwlock implementation for use by the non-VHE KVM
+ * hypervisor code running at EL2. This is *not* a fair lock and is
+ * likely to scale very badly under contention.
+ *
+ * Copyright (C) 2022 Google LLC
+ * Author: Will Deacon <will@kernel.org>
+ *
+ * Heavily based on the implementation removed by 087133ac9076 which was:
+ * Copyright (C) 2012 ARM Ltd.
+ */
+
+#ifndef __ARM64_KVM_NVHE_RWLOCK_H__
+#define __ARM64_KVM_NVHE_RWLOCK_H__
+
+#include <linux/bits.h>
+
+typedef struct {
+	u32	__val;
+} hyp_rwlock_t;
+
+#define __HYP_RWLOCK_INITIALIZER \
+	{ .__val = 0 }
+
+#define __HYP_RWLOCK_UNLOCKED \
+	((hyp_rwlock_t) __HYP_RWLOCK_INITIALIZER)
+
+#define DEFINE_HYP_RWLOCK(x)	hyp_rwlock_t x = __HYP_RWLOCK_UNLOCKED
+
+#define hyp_rwlock_init(l)						\
+do {									\
+	*(l) = __HYP_RWLOCK_UNLOCKED;					\
+} while (0)
+
+#define __HYP_RWLOCK_WRITER_BIT	31
+
+static inline void hyp_write_lock(hyp_rwlock_t *lock)
+{
+	u32 tmp;
+
+	asm volatile(ARM64_LSE_ATOMIC_INSN(
+	/* LL/SC */
+	"	sevl\n"
+	"1:	wfe\n"
+	"2:	ldaxr	%w0, %1\n"
+	"	cbnz	%w0, 1b\n"
+	"	stxr	%w0, %w2, %1\n"
+	"	cbnz	%w0, 2b\n"
+	__nops(1),
+	/* LSE atomics */
+	"1:	mov	%w0, wzr\n"
+	"2:	casa	%w0, %w2, %1\n"
+	"	cbz	%w0, 3f\n"
+	"	ldxr	%w0, %1\n"
+	"	cbz	%w0, 2b\n"
+	"	wfe\n"
+	"	b	1b\n"
+	"3:")
+	: "=&r" (tmp), "+Q" (lock->__val)
+	: "r" (BIT(__HYP_RWLOCK_WRITER_BIT))
+	: "memory");
+}
+
+static inline void hyp_write_unlock(hyp_rwlock_t *lock)
+{
+	asm volatile(ARM64_LSE_ATOMIC_INSN(
+	"	stlr	wzr, %0",
+	"	swpl	wzr, wzr, %0")
+	: "=Q" (lock->__val) :: "memory");
+}
+
+static inline void hyp_read_lock(hyp_rwlock_t *lock)
+{
+	u32 tmp, tmp2;
+
+	asm volatile(
+	"	sevl\n"
+	ARM64_LSE_ATOMIC_INSN(
+	/* LL/SC */
+	"1:	wfe\n"
+	"2:	ldaxr	%w0, %2\n"
+	"	add	%w0, %w0, #1\n"
+	"	tbnz	%w0, %3, 1b\n"
+	"	stxr	%w1, %w0, %2\n"
+	"	cbnz	%w1, 2b\n"
+	__nops(1),
+	/* LSE atomics */
+	"1:	wfe\n"
+	"2:	ldxr	%w0, %2\n"
+	"	adds	%w1, %w0, #1\n"
+	"	tbnz	%w1, %3, 1b\n"
+	"	casa	%w0, %w1, %2\n"
+	"	sbc	%w0, %w1, %w0\n"
+	"	cbnz	%w0, 2b")
+	: "=&r" (tmp), "=&r" (tmp2), "+Q" (lock->__val)
+	: "i" (__HYP_RWLOCK_WRITER_BIT)
+	: "cc", "memory");
+}
+
+static inline void hyp_read_unlock(hyp_rwlock_t *lock)
+{
+	u32 tmp, tmp2;
+
+	asm volatile(ARM64_LSE_ATOMIC_INSN(
+	/* LL/SC */
+	"1:	ldxr	%w0, %2\n"
+	"	sub	%w0, %w0, #1\n"
+	"	stlxr	%w1, %w0, %2\n"
+	"	cbnz	%w1, 1b",
+	/* LSE atomics */
+	"	movn	%w0, #0\n"
+	"	staddl	%w0, %2\n"
+	__nops(2))
+	: "=&r" (tmp), "=&r" (tmp2), "+Q" (lock->__val)
+	:
+	: "memory");
+}
+
+#ifdef CONFIG_NVHE_EL2_DEBUG
+static inline void hyp_assert_write_lock_held(hyp_rwlock_t *lock)
+{
+	BUG_ON(!(READ_ONCE(lock->__val) & BIT(__HYP_RWLOCK_WRITER_BIT)));
+}
+#else
+static inline void hyp_assert_write_lock_held(hyp_rwlock_t *lock) { }
+#endif
+
+#endif	/* __ARM64_KVM_NVHE_RWLOCK_H__ */
-- 
2.44.0.769.g3c40516874-goog

