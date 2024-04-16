Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCC198625F
	for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 09:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713261465; cv=none; b=dmhm5Tn7M8v13T0Tik8TFg7wjCFu6g1MLxduw++whykdpK3oAiQ7p/FrgXf9NCIPCnGeuAPjGcZHcorX8KKZ4WZZu0gu+52Kgu74hfsKk+w/64AUpCSPU49/OyWfVD7mQTgJE2O/GkqqRfXOcAmWbsIAlWDXFYWtwKI5QwX2Miw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713261465; c=relaxed/simple;
	bh=CDIOqQvxZfVsB8lY3YrnLG4OYzfx5K6DfDPwZrsq644=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ds1f39ydH10jYFFchof23WAUrjUL6cqMsBadyPJ4GQhv0lB+iedtYTp/IuM/986FlEYmqyqTkgoiV3XC25L4aV/VWZy1suyJEn/dqAhgqMEisodpY9ZUJnHF5PxFuba7U/eYoRGpCTpKt0litMVkvijskv7IwTk9NCoOYM7Seus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=es1Hw4wE; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="es1Hw4wE"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-61ae9ff0322so16706647b3.3
        for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 02:57:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713261463; x=1713866263; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=eeiP8p7/gPhnJJHleewMI0poHbTfPtT+lXnvVt8QzgA=;
        b=es1Hw4wEWdiI3k6PVjedWHL54dzyvgLMsdj7x51ld3Cme8IHjmlVOHQk203bs7twZj
         gFg0tohxHqO29pO8nRdbLnBxVqsOzho+0vir3x8fYPeh0dYlcl/Kzeu6uGM+i4mJcBSC
         8yqyywDDIiEtw8ztgeyEo+hUWI5vIGuISi5edKe9WdSG7uXBBE5+eeaII+P4RfyhMYh8
         4hsTMSGKrADqYnxdBQPy1omIc/mYeeQH2ly2XImyeSeFLENZjXNkOpEEFtw/pEKI/W+O
         D9JoUbWXMq2eUd6Hxd5kRl94fFyEFh360KmuKsx+DlS8bUjkYxLw+6aZSf9mTON5AZKF
         GMrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713261463; x=1713866263;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eeiP8p7/gPhnJJHleewMI0poHbTfPtT+lXnvVt8QzgA=;
        b=VofX2/eetMNWDTtLN2DfwGWP13n51CTco9y1tmPhYhfIpbY0L4C8YI5saFbHOTfXPG
         fCmXGj/z3EnaiQVh/42+HrDEKG19zrY6ZmzKPOJOXn6vc18UxHoqugWZfw8VU37a9iGP
         xatl2fuwpsndct3NOHnFJ9n0ZfVq0bTJP5gKm+N4OFD4zQmA9P5xxYmxcT7evK2mVT8k
         eQ4eNjT5GizIbOxnrVwxdtrS3KtGXqnlOu43BQ1fatiSQH3oMP619MQ5+rqBoSJoWypN
         dIiFeEFOzh7pDM04+o1VGIDrSJ3OY0oLiZIU5SjkFu54/pZ+QZDNwywDf8fmNopn9sG9
         2g7w==
X-Gm-Message-State: AOJu0YxI1YTlZ/436C4NgvVhM45SO46TAapD0tM424n7tXLImQbBpkve
	A3dVGXpTM4R0c1/j85hD+FpCwotzyY9SDFmsMVBXOz4J0GfSBP310//gwdrIQNkkekQcjK7dvAA
	wO0/5nggIta3AD9yRrwwX3RTnDRFO1TOzzO1vAuZpBqTyi7uZapa99SNylQUmo5w6aWTs75v3pt
	SgI2ETjhTsaS9x/l5gtjTu+hnw7l0=
X-Google-Smtp-Source: AGHT+IE+53gUBnvXAJX++6tHvnm7xAnWQwOtQoOfc/HQLmnSym1wlJ+Reph5BNfq+lWxA9Xzo/xP4lWxZw==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a25:aac1:0:b0:de1:d50:ad47 with SMTP id
 t59-20020a25aac1000000b00de10d50ad47mr3655742ybi.13.1713261462611; Tue, 16
 Apr 2024 02:57:42 -0700 (PDT)
Date: Tue, 16 Apr 2024 10:56:18 +0100
In-Reply-To: <20240416095638.3620345-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240416095638.3620345-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.683.g7961c838ac-goog
Message-ID: <20240416095638.3620345-28-tabba@google.com>
Subject: [PATCH v2 27/47] KVM: arm64: Introduce hyp_rwlock_t
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
2.44.0.683.g7961c838ac-goog

