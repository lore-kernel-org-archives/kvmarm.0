Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ADD914E2E8
	for <kvmarm@lists.linux.dev>; Wed, 27 Mar 2024 17:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711560996; cv=none; b=fpoVN8GGbxgUYXLH+gdC/Rez7wkH0FVzHWxR+8MxTWzEsNo1DnbBKgXJ6mKHR/BnyCoN0xfh264H1FDGvB/fq+k4IjITFLedZXl+fWb6ejPXSv2qK2gZXoqHDNw7WXnlv/3yICLjPMjNVFduFx7yl3td6vhnOWU0vk+H0dpgLAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711560996; c=relaxed/simple;
	bh=V6YuyV80I+iJeKU85iGYjH12LNaggCM4jIVhbfsrhEM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SkDukXjlvoa9B5B6xdi6OiyTrM1FLvjQyQmVnhiICREzwTfm9BaWm0+N7iCKu8E/GVAyjnGWkf1uQBj6CRTlKDwmuF35XBKJwLGhghRF7+NpbzPpK9wJG7kP7Kz22JUvfxb5iFMZbhaXIrN2h7da3FiaGrFtHqHpwbkZrsFh9XY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=enqQJ+27; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="enqQJ+27"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6134cfcacdcso1283497b3.2
        for <kvmarm@lists.linux.dev>; Wed, 27 Mar 2024 10:36:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711560994; x=1712165794; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9YlqdowC5WfDRBB4tumS2Dd6qlfb7/bdL3pgWh7xR6g=;
        b=enqQJ+2755GEjahZ18wqp5Y6dyWalOJSA0oAVtoQQ/FzMq3yaE0RWrHq3MZ7xfW+s0
         5lCbNFwKAecm5BsEbJylogw02K+taf9upWeGmrnv3H9jdP7l8dKBSZit1/Y5BomRXAyC
         wFd7X03M87/ehQsZtVviLSj7q3K6lsePQiuV8IIUaRGI8ufC5K6AQif2B7IL5xzH9LO0
         08LQilNKxOqzYj7VlxerjOYkWj1DwikrI0pcw2xnUnzXAn/S6BLT2/2lbE1B7jLvQ46L
         sDC+xAbUkAi76ZqVY01F7hb6jdJ7gJRKAIShKGIZejXcGRTtp+pTxeu5iYUiCQTFL1oO
         re3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711560994; x=1712165794;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9YlqdowC5WfDRBB4tumS2Dd6qlfb7/bdL3pgWh7xR6g=;
        b=UH1PZKVO5KLca653KShhZUIiN/sX52vspfVIsbQAx0XK/uhwgMucIq9iLMI/jU1Uzw
         OJyKxgi1ATQSlT8VgwhscClPPyMJeF6QtOv75FezhRHSG25rwJgDfPAKHU6/0X+HAZRQ
         2aVhQLlCo1TFcIdAUMovrVKMn4oIBLvB+9EmIJnKQ9uNhFgK+FdlV3EWCFLDZgujGkLM
         g3aQct8pk0k/AFT2+wFCW5WIpeFLpOIOvMeHNueUVq+zfCrsnYeh7kqAWaa5etI8LJvf
         PpxSLKpvo3Gp7SbK6LX4olqn2kxi9A/X8kgoROutB5Vf18GfwaIs9uFhYK3kOdq9HfZg
         X7BA==
X-Gm-Message-State: AOJu0Yx0LOTeH3zXqxjcT1xlcrGCYBQegDz28gN5fqZK1pwEjERi+2FN
	CIHM3KiE18EDN6OQZqi2cH7Vm7spB/0aNefdxJWBrft2stUx1o0Gevic6IceG0hQNj+S+HLEhSf
	ZsuzcAQs0YDqcK0xutNvfgHlwIDuHy5C6pGH825a9AKCKtZhjSbGcBSDVcUx/qv31RIbPp9Bqbf
	/SvJEJdMxD31O7+j51UWOaBH4FEdc=
X-Google-Smtp-Source: AGHT+IGawFVwe7JHd3XtZAXVmTpRqMO7ZybXPh/0BrZLuYf7sMITUwoVY47ET3TWKElTqCupBH1Gh50Zog==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6902:2202:b0:dc6:e8a7:fdba with SMTP id
 dm2-20020a056902220200b00dc6e8a7fdbamr128294ybb.4.1711560994074; Wed, 27 Mar
 2024 10:36:34 -0700 (PDT)
Date: Wed, 27 Mar 2024 17:35:13 +0000
In-Reply-To: <20240327173531.1379685-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240327173531.1379685-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
Message-ID: <20240327173531.1379685-27-tabba@google.com>
Subject: [PATCH v1 26/44] KVM: arm64: Add atomics-based checking refcount
 implementation at EL2
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com
Content-Type: text/plain; charset="UTF-8"

From: Will Deacon <will@kernel.org>

The current nVHE refcount implementation at EL2 uses a simple spinlock
to serialise accesses. Although this works, it forces serialisation in
places where it is not necessary, so introduce a simple atomics-based
refcount implementation instead.

Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/include/nvhe/refcount.h | 72 ++++++++++++++++++++++
 1 file changed, 72 insertions(+)
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/refcount.h

diff --git a/arch/arm64/kvm/hyp/include/nvhe/refcount.h b/arch/arm64/kvm/hyp/include/nvhe/refcount.h
new file mode 100644
index 000000000000..e90e66f49651
--- /dev/null
+++ b/arch/arm64/kvm/hyp/include/nvhe/refcount.h
@@ -0,0 +1,72 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Atomics-based checking refcount implementation.
+ * Copyright (C) 2023 Google LLC
+ * Author: Will Deacon <will@kernel.org>
+ */
+#ifndef __ARM64_KVM_NVHE_REFCOUNT_H__
+#define __ARM64_KVM_NVHE_REFCOUNT_H__
+
+#include <asm/lse.h>
+
+static inline s16 __ll_sc_refcount_fetch_add_16(u16 *refcount, s16 addend)
+{
+	u16 new;
+	u32 flag;
+
+	asm volatile(
+	"	prfm	pstl1strm, %[refcount]\n"
+	"1:	ldxrh	%w[new], %[refcount]\n"
+	"	add	%w[new], %w[new], %w[addend]\n"
+	"	stxrh	%w[flag], %w[new], %[refcount]\n"
+	"	cbnz	%w[flag], 1b"
+	: [refcount] "+Q" (*refcount),
+	  [new] "=&r" (new),
+	  [flag] "=&r" (flag)
+	: [addend] "Ir" (addend));
+
+	return new;
+}
+
+static inline s16 __lse_refcount_fetch_add_16(u16 *refcount, s16 addend)
+{
+	s16 old;
+
+	asm volatile(__LSE_PREAMBLE
+	"	ldaddh	%w[addend], %w[old], %[refcount]"
+	: [refcount] "+Q" (*refcount),
+	  [old] "=r" (old)
+	: [addend] "r" (addend));
+
+	return old + addend;
+}
+
+static inline u64 __hyp_refcount_fetch_add(void *refcount, const size_t size,
+					   const s64 addend)
+{
+	s64 new;
+
+	switch (size) {
+	case 2:
+		new = __lse_ll_sc_body(refcount_fetch_add_16, refcount, addend);
+		break;
+	default:
+		BUILD_BUG_ON_MSG(1, "Unsupported refcount size");
+		unreachable();
+	}
+
+	BUG_ON(new < 0);
+	return new;
+}
+
+
+#define hyp_refcount_inc(r)	__hyp_refcount_fetch_add(&(r), sizeof(r), 1)
+#define hyp_refcount_dec(r)	__hyp_refcount_fetch_add(&(r), sizeof(r), -1)
+#define hyp_refcount_get(r)	READ_ONCE(r)
+#define hyp_refcount_set(r, v)	do {			\
+	typeof(r) *__rp = &(r);				\
+	WARN_ON(hyp_refcount_get(*__rp));		\
+	WRITE_ONCE(*__rp, v);				\
+} while (0)
+
+#endif /* __ARM64_KVM_NVHE_REFCOUNT_H__ */
-- 
2.44.0.478.gd926399ef9-goog

