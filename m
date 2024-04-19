Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD27747F6C
	for <kvmarm@lists.linux.dev>; Fri, 19 Apr 2024 08:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713513645; cv=none; b=FgSe1sa+U7FXOtOKtYWPJbTxCFRfcX4iAuLpavjlPdqmXhBn1V6oJtHSGGJ9p3JzxVF8flBo4N3JC75v1cs6oaT9IOHYfjEkOvTNMBSmfZ4zk9dmlsfu0KSYiDYAlE86TZt8ejkhzIwM948GU8gDALfeHf++wNQ9edEFZB4pXK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713513645; c=relaxed/simple;
	bh=ykmB3QXzlon/HDDPejA0cbLlag4oE07+pdZcXp6ZgdI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ku8fuML8AmKGjUN6ZBgKMPf5rkj0iA2A8K1K2djUlDwI8enyEiPAAFV4oL2b1d4Pw+TZxkpTxvUNaFKbsmO5PQKqL9cL6ncJL/9RY398R/KFXm78Ft0yXN/maa0nf9jalu2xDVAcah8JSLt7SSeGzpQd81UjC5u2KX8/zym01Fk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fswTBEcz; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fswTBEcz"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-de45d0b7ffaso3505818276.2
        for <kvmarm@lists.linux.dev>; Fri, 19 Apr 2024 01:00:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713513643; x=1714118443; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KXiV06eUdCopMOCs6eKCvPx+iGp2PhsF/4lwt1YHESY=;
        b=fswTBEczn4DdX+n5+YISixYAv9+n6IoQxrZMsfFVlKNLtJoD3jOTQWjAKEW6ZmLhRf
         LOSrjpyggtAeBrWtrAq1NAZ3PBPiDik8dSRwd1W4LQOx5zNLsioKTzcvJqexHQoxi22e
         tOOcY59ileWESB3KXEeuiaM6nrd/hndxlZ7FYzfGRNoTBCFAKrZJjcFQwawDrkHu6u+T
         8vFAlF6h8JG3kL4PXodUMcEqGEaJJxCjn/WIHzh20JQHn+3O2QrlDQBFMxAWPXovjpe3
         6FonERMOJFzssfylnTIyL2P1eY/5Q2XreFp+J6FZN4TCJR4i7Hw3Dtxez4vmdQIuY3Ea
         LaGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713513643; x=1714118443;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KXiV06eUdCopMOCs6eKCvPx+iGp2PhsF/4lwt1YHESY=;
        b=avWrsiTSlmFWh4KkMB8zIBG9pUDTiFunx9W1DPE6JOP1EI3vexrjAZ1YEznp3d9Ti1
         eqIiBH6MBIcI08cJbC1KMScaH2f3iwYnkBmw6BDTY+/kAavOwO2v7dz0yZVO+WlTRfFc
         zZpuOeokSnpPe4VstOexznkigmV74tffV23ou41rgURz4stVNkIXDBYZ2RzexmfbEEno
         rCWBszWnoKzV41Kcm5pDFCHELEa0oLXlzJaV+5B7ahqaPuiLbCN9zZZRxfMLV1ikUomR
         lzYBpPNc5B1RHvJTtaL+Ud9bDNFJZraBzbEyAQwTpLfxZ8CA84WDxIDaNlZo/sMRIcYB
         ySQw==
X-Gm-Message-State: AOJu0Yxn7GUV5YYIBJFRtEcvFiKsIos2WlpWT8ShdJUpS9bzAShrRadb
	aJWkRTlYrCFUtljxq4NzHLIp1J4mkosUxo0RzUj+TEWWWrk/GMkNRpfdT1ENcoIRK4SehZeDgjN
	dyL+p9c4emkzBM2Rhv4ce0T1/gAiIhAbNMDGAuF3YICoR4ZI8Gk3rmpkkyV8c2pA6YQtKWqpKhE
	RG1k5u9HTgNC62qIqJvvNLGeD62WU=
X-Google-Smtp-Source: AGHT+IG6ED5XdA1iKnz24sy77v+j2I1M/DQGxXolEO/FghUOrz1VbMqyQtUbf2bxbvbqUBOmHTGrlgymwQ==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6902:2991:b0:de4:7037:69a2 with SMTP id
 ew17-20020a056902299100b00de4703769a2mr86944ybb.5.1713513642737; Fri, 19 Apr
 2024 01:00:42 -0700 (PDT)
Date: Fri, 19 Apr 2024 08:59:36 +0100
In-Reply-To: <20240419075941.4085061-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240419075941.4085061-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
Message-ID: <20240419075941.4085061-27-tabba@google.com>
Subject: [PATCH v3 26/31] KVM: arm64: Add atomics-based checking refcount
 implementation at EL2
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, smostafa@google.com
Content-Type: text/plain; charset="UTF-8"

From: Will Deacon <will@kernel.org>

The current nVHE refcount implementation at EL2 uses a simple spinlock
to serialise accesses. Although this works, it forces serialisation in
places where it is not necessary, so introduce a simple atomics-based
refcount implementation instead.

Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/include/nvhe/refcount.h | 76 ++++++++++++++++++++++
 1 file changed, 76 insertions(+)
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/refcount.h

diff --git a/arch/arm64/kvm/hyp/include/nvhe/refcount.h b/arch/arm64/kvm/hyp/include/nvhe/refcount.h
new file mode 100644
index 000000000000..bf6bd4ef89bf
--- /dev/null
+++ b/arch/arm64/kvm/hyp/include/nvhe/refcount.h
@@ -0,0 +1,76 @@
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
+#ifdef CONFIG_ARM64_LSE_ATOMICS
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
+#endif /* CONFIG_ARM64_LSE_ATOMICS */
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
2.44.0.769.g3c40516874-goog

