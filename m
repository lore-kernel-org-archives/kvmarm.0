Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82AED28A414
	for <kvmarm@lists.linux.dev>; Tue,  6 May 2025 16:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746550152; cv=none; b=k5QpHBQLjZ8Ns9J3YVKQxW5vRdoILj28aGodSQoWs3rNdnSw+MCVI0Aj1sTNWmvjEwj1UsRX12G/oYfJfw1KRCS3FXbhHUUTI4+kl48DB53U8Vh6TG44EshrmVXES2/gNp6ekgWVdaCP3JMimS66aFHyIMW7VZdyhLDL0NnZNsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746550152; c=relaxed/simple;
	bh=uK5a0ct2ICnUqn9DjzHC3LReJzEGHdu5Q2c70Mx74pA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mdDDZsfZu/u0sO1yHjI5bxLoKQRikFCv3kndDXbrdg0oCcyRVtDzJGFHZSqArbAyV0Dk1fHEaitvuoyyOHdZ3WERxv9tnxu/iyvp7gQrCX7fvQ/6uSkKZ2QC1ZiXmAYJkdGolhh4vef9GDyuiz4lHe0UFI8cGhQ1OR6LFaJV5Fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=k6CfVgHJ; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="k6CfVgHJ"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-43d6c65dc52so42231195e9.1
        for <kvmarm@lists.linux.dev>; Tue, 06 May 2025 09:49:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746550149; x=1747154949; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PTKmizrXds5p9DE6J3WP7/kKkm1zSi2V0hVoZxXRS+Y=;
        b=k6CfVgHJzuEO7Ry6kYOLGWxcE1L985eZtw8rp5TsRHG3kTwVV50b+3lnAKU42GtMIJ
         4qdGyR+OYUlxhYcFZZi+fsZhMNVcOTy4oW1fd/RPYrbvsLJzRvig2laJ71RBLR9eMRJV
         nyGSU8bmy75YSpeMKppJm3uI6j/7UBx7uNSxegZmduvTGn3b03HiRFCTwnWWZoWYM4A2
         pW5TQOsKJQ5EnIrf8505dVSjmzAI7IXmueJCtDDb5r+MRjspBvIwcTnKeFbPJeWLjHWV
         SgtS7JZ+OQuK2vRu2F8ofTQFRt9BJiUI4vpp4gu286NKyrixgJq7Joh2Ty4ldQSrAHyE
         wWvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746550149; x=1747154949;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PTKmizrXds5p9DE6J3WP7/kKkm1zSi2V0hVoZxXRS+Y=;
        b=NrDK5WwO9XFNP/g1gqNvG4UsajAlHiuLrn70FMt6V/74Wgtyu0wbfFVi13aplqrzEM
         uTZ0OgPD4JCmvWh7JiovXHqS/T9E/sOhExFY9vTkOKIwVZ8miWpm07yuS9HtYE37wS0o
         Dd/jdVbfTtlHi5KbUXCBD6Vdy4vXVLhPA33lc/Mh0hDgRX8QwRHKWE03+w8AMwYoYm7E
         hoGvxrFYEigdBQt+0+GQB1IL960sdGJeWYvmtcMjHCiKesxAjfyVTm3/8e0WxPDN10m4
         wEyq1I8Pd1oLHSEWWfkWUjWHtKpH31ozIOMjaRqLtbx7knCq/Ii5RNpkFvu9FjgmeyhW
         2DXg==
X-Gm-Message-State: AOJu0YyOS5UOvTDQWURAM+1WgvRuRq8axQu6df8ZrR9ww5f1xn2P36+r
	FxMkUUwBRBEhZHYEYdiLAYWi4zQce6ormhRAGY0oC+nUoLxOgkkBUUajrMgkHLpp6FC2XBv1NPQ
	qN1sxjEFomRzOkMMMbw==
X-Google-Smtp-Source: AGHT+IE2t1cIjH9YYJy8Ayf9wJ/0y3Ak3eh6UWYMS00LUPr9De3lPaQ9ChoJojhjdULWg+br9k0N5dgvgMI3890q
X-Received: from wmben3.prod.google.com ([2002:a05:600c:8283:b0:43e:9aac:5a49])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3552:b0:43c:fc04:6d35 with SMTP id 5b1f17b1804b1-441d0fbd626mr38701485e9.4.1746550148999;
 Tue, 06 May 2025 09:49:08 -0700 (PDT)
Date: Tue,  6 May 2025 17:48:12 +0100
In-Reply-To: <20250506164820.515876-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250506164820.515876-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.49.0.967.g6a0df3ecc3-goog
Message-ID: <20250506164820.515876-17-vdonnefort@google.com>
Subject: [PATCH v4 16/24] KVM: arm64: Add clock support for the pKVM hyp
From: Vincent Donnefort <vdonnefort@google.com>
To: rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com, 
	linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	jstultz@google.com, qperret@google.com, will@kernel.org, 
	kernel-team@android.com, linux-kernel@vger.kernel.org, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

By default, the arm64 host kernel is using the arch timer as a source
for sched_clock. Conveniently, EL2 has access to that same counter,
allowing to generate clock values that are synchronized.

The clock needs nonetheless to be setup with the same slope values as
the kernel. Introducing at the same time trace_clock() which is expected
to be later configured by the hypervisor tracing.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index e6be1f5d0967..d46621d936e3 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -146,5 +146,4 @@ extern u64 kvm_nvhe_sym(id_aa64smfr0_el1_sys_val);
 extern unsigned long kvm_nvhe_sym(__icache_flags);
 extern unsigned int kvm_nvhe_sym(kvm_arm_vmid_bits);
 extern unsigned int kvm_nvhe_sym(kvm_host_sve_max_vl);
-
 #endif /* __ARM64_KVM_HYP_H__ */
diff --git a/arch/arm64/kvm/hyp/include/nvhe/clock.h b/arch/arm64/kvm/hyp/include/nvhe/clock.h
new file mode 100644
index 000000000000..9e152521f345
--- /dev/null
+++ b/arch/arm64/kvm/hyp/include/nvhe/clock.h
@@ -0,0 +1,16 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __ARM64_KVM_HYP_NVHE_CLOCK_H
+#define __ARM64_KVM_HYP_NVHE_CLOCK_H
+#include <linux/types.h>
+
+#include <asm/kvm_hyp.h>
+
+#ifdef CONFIG_PKVM_TRACING
+void trace_clock_update(u32 mult, u32 shift, u64 epoch_ns, u64 epoch_cyc);
+u64 trace_clock(void);
+#else
+static inline void
+trace_clock_update(u32 mult, u32 shift, u64 epoch_ns, u64 epoch_cyc) { }
+static inline u64 trace_clock(void) { return 0; }
+#endif
+#endif
diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index b43426a493df..68d14258165c 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -28,6 +28,7 @@ hyp-obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o host.o
 hyp-obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
 	 ../fpsimd.o ../hyp-entry.o ../exception.o ../pgtable.o
 hyp-obj-$(CONFIG_LIST_HARDENED) += list_debug.o
+hyp-obj-$(CONFIG_PKVM_TRACING) += clock.o
 hyp-obj-y += $(lib-objs)
 
 ##
diff --git a/arch/arm64/kvm/hyp/nvhe/clock.c b/arch/arm64/kvm/hyp/nvhe/clock.c
new file mode 100644
index 000000000000..879c6b09d9ca
--- /dev/null
+++ b/arch/arm64/kvm/hyp/nvhe/clock.c
@@ -0,0 +1,65 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2025 Google LLC
+ * Author: Vincent Donnefort <vdonnefort@google.com>
+ */
+
+#include <nvhe/clock.h>
+
+#include <asm/arch_timer.h>
+#include <asm/div64.h>
+
+static struct clock_data {
+	struct {
+		u32 mult;
+		u32 shift;
+		u64 epoch_ns;
+		u64 epoch_cyc;
+		u64 cyc_overflow64;
+	} data[2];
+	u64 cur;
+} trace_clock_data;
+
+static u64 __clock_mult_uint128(u64 cyc, u32 mult, u32 shift)
+{
+	__uint128_t ns = (__uint128_t)cyc * mult;
+
+	ns >>= shift;
+
+	return (u64)ns;
+}
+
+/* Does not guarantee no reader on the modified bank. */
+void trace_clock_update(u32 mult, u32 shift, u64 epoch_ns, u64 epoch_cyc)
+{
+	struct clock_data *clock = &trace_clock_data;
+	u64 bank = clock->cur ^ 1;
+
+	clock->data[bank].mult			= mult;
+	clock->data[bank].shift			= shift;
+	clock->data[bank].epoch_ns		= epoch_ns;
+	clock->data[bank].epoch_cyc		= epoch_cyc;
+	clock->data[bank].cyc_overflow64	= ULONG_MAX / mult;
+
+	smp_store_release(&clock->cur, bank);
+}
+
+/* Using host provided data. Do not use for anything else than debugging. */
+u64 trace_clock(void)
+{
+	struct clock_data *clock = &trace_clock_data;
+	u64 bank = smp_load_acquire(&clock->cur);
+	u64 cyc, ns;
+
+	cyc = __arch_counter_get_cntpct() - clock->data[bank].epoch_cyc;
+
+	if (likely(cyc < clock->data[bank].cyc_overflow64)) {
+		ns = cyc * clock->data[bank].mult;
+		ns >>= clock->data[bank].shift;
+	} else {
+		ns = __clock_mult_uint128(cyc, clock->data[bank].mult,
+					   clock->data[bank].shift);
+	}
+
+	return (u64)ns + clock->data[bank].epoch_ns;
+}
-- 
2.49.0.967.g6a0df3ecc3-goog

