Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72496F4E2
	for <kvmarm@lists.linux.dev>; Wed, 27 Mar 2024 17:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711560995; cv=none; b=Pc96RF9UM8n0k2SQw0BO0kN3g+rfUE89lZGJaJWJcRFJWqtdW9tuGEL1vs+VOeQwwUCf22+6xF34cydR0qt9gjObl/+fI/UwqjNn4JIYw6JRowAiI413P5bgZrm14nj1OtNIXEzM0eZdO3xG1BWQSBIygwQzWM6eeINmqOjnN9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711560995; c=relaxed/simple;
	bh=txYqIpe+xjqkIIi9KrCQ8EbvesNldBg2s6QDhLiJvPY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PQbTnf3d2NGh2N2vcLitCCQUOtmGA22pAupJtNAekIbUIeX/o0G22oqQZHef/nvpYycIYUX6X7Ws+OZdtBIP0lntUUG2jo8ONBw8I8MLy6s2cJ/ZLPkqfKbhYYU5HxCpDqPvczbX9Ppmye9Kf8GqYW706/rEb9PSPhAXl85scGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Pd48AT74; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Pd48AT74"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-33ed234bcb1so587083f8f.0
        for <kvmarm@lists.linux.dev>; Wed, 27 Mar 2024 10:36:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711560992; x=1712165792; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bU4K1p9xUOoNjPUUGzz0OZdRCG9DRm+TJoM/2iBuq54=;
        b=Pd48AT74OdNMlsDaS7VLN3/LIoR4HwF9Y3sExmETvKOAjvau+sSY3YbT6oQBtVR442
         2UJtxAJIqbYNol0FOT0QNLPUcGwGV2Tr2Q3qbvzMRNMWCkHU+2Mehdn8+b8OzBwbQXyC
         zpSH8dcSRWk95ryjzBtm/faZ5qSVmM7DzX7DmgoUZlug47gpbOwg5+bKH2GOIWvvbWa9
         k3eA8Bm7HrL+LBxi4nTIdGBx1wcVhNP9f0323Exzip1S9cfrJf1v30gGVSHogq3JSd46
         S/pGowmYSj6rKKY4C/3VjI/gMN8jfIC/MN1grFRUsuHNXZ9w+GtK70SbjcZozbC77hFb
         ME8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711560992; x=1712165792;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bU4K1p9xUOoNjPUUGzz0OZdRCG9DRm+TJoM/2iBuq54=;
        b=VWDwkrSb+4bt/2c1SNziQgJBXPR6E0f/Z67DoadtD24CemspVw/fqxCevAiewND9z/
         xaZ2Vxh7BVmmTGmK/HWCBAghfmq36CRF3MxINafOHWnLghsZw3K9dpEQRgdoLWnopRIK
         DNovD5ykXVOAplCFHD4dhEClj838ODJX0r04sz3F1fCmCQ/wosFgbABcwKsjCGevzrot
         YcvwYm5RH1z5fRbr9KIjJF04boGR0tDcKR4lSKhw+9LgIrAZ57QjNdWU3Wp1wYtg/V8a
         CkRF9MPGHB0WpQMO+R1CebDDKxCWlpFd5QfooIlWnbT4Nv1oujnBBMyM7PZeqgVyk2gY
         o+nA==
X-Gm-Message-State: AOJu0YwNFEAz4jrgnfkqAwI7PI8d2G+DwRiNy81Xb74QbhJxFMgfl+Yi
	Y07X1EvQroJZdbx1pYqg10JBwY6MLhMKgshFNTsS1uOMx0m4eEGgNiXV1sjvlHSoTEZj6xg7dIQ
	LgneKXpNRiQLzPw8qipf54xCC2G9Bg15MjH0LOgn6v9EkGcHscSfzJLmJ4yNm1fnxiOm7zIF6eM
	Tu4bya/hVlcjkqrpSaIhEbJe5UT5A=
X-Google-Smtp-Source: AGHT+IHspt94IoyEKVEO8TzMg7kIe+GmYNHczLzeh66L3wSPvZDjS5OoGR+HzzHUZEzRWmhFran2CDY+Xg==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:adf:b1c9:0:b0:341:a63b:64fe with SMTP id
 r9-20020adfb1c9000000b00341a63b64femr621wra.1.1711560991677; Wed, 27 Mar 2024
 10:36:31 -0700 (PDT)
Date: Wed, 27 Mar 2024 17:35:12 +0000
In-Reply-To: <20240327173531.1379685-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240327173531.1379685-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
Message-ID: <20240327173531.1379685-26-tabba@google.com>
Subject: [PATCH v1 25/44] KVM: arm64: Introduce hyp_rwlock_t
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com
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
2.44.0.478.gd926399ef9-goog

