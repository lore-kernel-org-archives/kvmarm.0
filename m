Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF2288664C
	for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 09:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713261468; cv=none; b=Q8K/3CC9Taqo9ZjPfZCDSu2piSNwsrRGBxeg1Km4OWZyiANBQ7P/gHvULeKrfD+f6F+qIplxbjuU/Gm9FvuXzdBximzn1MCTXH2xfuT5SvkNNNVCuAGgyLUP15cqeIurLDS5s449YMaojAnpP/t/FB3ClEMCv+sXtvPCgLTBGiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713261468; c=relaxed/simple;
	bh=F0xh896CxjOeOOlDBZ++xwi411E3/TzekdgJLwn9soQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=l29eOHNiERhLdaDJof4Y/UiGMNfE5bMFK0BlgErkmwrLV9UxSiGAauIZqb94IW/c3fwoMo5vi8BUdHqTKb0gcXR0i9EKO2eE1x/cndQTvrs9qaNnYzDstTwBYTlC6tU74CvC4UEPrdAA21JmiayMz8XoyHiJg3mL6InHQAAiQ/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Noc4Zu+O; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Noc4Zu+O"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-417df7b0265so16473195e9.3
        for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 02:57:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713261465; x=1713866265; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2bgahv8Cqio5iN11mcqw+CL3uJ3iQCfkCCIkSe/i+dA=;
        b=Noc4Zu+Ok7dPoLYKp7TMqfqWcd0iXhzu9+ATp/SAkyeeo9WFWrQFjUqGuv3e47SGx1
         urAwxVmawRf/H+ikvCKa6p9ndBpGNTerHS8tgSHuntMMdQCDwjtC5Qn221nUuVDN4XBc
         nzQA6RizVA1fFTkZmYgc+xs2odYlHoCGrhSdBB7zmqK1xdIkJuV5P+a7fiRwF78T/Wc3
         Gc0UWrftarQV+gr5FuFYDEtPR3pCAAPX0iAMZ/pSCAtseybhRRteaYCTtm2bxrJ4MdrG
         aMt/Pd8Zgq59mEoT4B8KupiabXqZQscZq2P9GwJmTIzcnzWjY9apGkV2fc+Ea4PcPpq7
         7YHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713261465; x=1713866265;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2bgahv8Cqio5iN11mcqw+CL3uJ3iQCfkCCIkSe/i+dA=;
        b=dxp3hmxAApqKN58cUoOP1l+nQg87wAVLBcG6XZWmWiEDxcLex/euffrAVfGj6bYQ6/
         FYCYGae5t6WL1QDsJOj6GW6/Dn9eeHHmsq5LfB+eipCa14kRb7GbHweKNyMGo3R1RMBN
         pvA8Ln1XnshzkXMn/SVBJWq+HgFCAEvBaf7A/HmaKMrZ9ZSp9ajJrqMda6CxZis6Ssn/
         RgGjtsw25N1nV9gwdatzA+9IbgL/TfGOEdhYMq46yaaSLSwhZHXvcTHl4qGM4R1e69eA
         2WjrU+TZT7HNQHza5wn2dPHruJzklceM6Z4HmKgmgvnyz98/A6EmAHS0nbkXyWe7xmWH
         8MYA==
X-Gm-Message-State: AOJu0YyWKUxpems1XibR2VK5dUgqmQgwRiuCM38XFETub0A/TbhwFpyX
	XfQxESWnOgQpZzEp4PQ7wx8Tld5O4dNpkP+13eCBWouaJX8ih3LPMbPeLuY1MqA78888j8eSPSY
	fkZcYfi+eAVGmQuDq29FLG0CsVSZToZQwkuXob+YQXalU+rW2mtsbjC057/+NobrFcVO2PNUjwB
	qiles17xfKsn0kL94r15jwG/j0clU=
X-Google-Smtp-Source: AGHT+IFBzKcWX2a2pEjyqwRK2OaF6mtBIDLmWD0u/d3PtgKGG94WngWiWzA1aMGeQBzau7nxjXnSdDJ1bw==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:600c:1d07:b0:418:a19f:d5a0 with SMTP id
 l7-20020a05600c1d0700b00418a19fd5a0mr14696wms.5.1713261465027; Tue, 16 Apr
 2024 02:57:45 -0700 (PDT)
Date: Tue, 16 Apr 2024 10:56:19 +0100
In-Reply-To: <20240416095638.3620345-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240416095638.3620345-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.683.g7961c838ac-goog
Message-ID: <20240416095638.3620345-29-tabba@google.com>
Subject: [PATCH v2 28/47] KVM: arm64: Add atomics-based checking refcount
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
2.44.0.683.g7961c838ac-goog

