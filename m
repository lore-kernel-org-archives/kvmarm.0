Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CE643EF0B6
	for <kvmarm@lists.linux.dev>; Mon,  9 Mar 2026 16:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773073584; cv=none; b=Wbq6yTpJJKLLJ+S3OkCUAjfyLI5IjeFmhM95N3C2ogMWDPgL+1KzdE1uoD2GPVTacX1FHIOeSALj+QsZcUdSM5hTrlVVKLfLaRlXAprhQnQHVxYnvUjfXZWpXdWLFAQC69nRa0vncbVI2qW3fYVzGGog9JYifFGuPOXBhfoCi4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773073584; c=relaxed/simple;
	bh=h2rVCYiv2RErJ8J/DPs4R6liat0vq1OWoPSAfx6DS2s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DD1KmwmCNK2lciOwq43K7Fpir1TQrExpfVGvvGILUTZnT+5Cu42yUmEWgEaPrD7VWHTTLylhU6JGgHxH537AXKzt7yRR1zY6PHcG/+u7T7aXKwWCHRR65KSsqRmIBIvuJEF/luhafZYBaPE/euQLRr8tyt+YJ2hebqghIZ54kww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=haVv2PUz; arc=none smtp.client-ip=209.85.208.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="haVv2PUz"
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-661838c9a33so3570193a12.2
        for <kvmarm@lists.linux.dev>; Mon, 09 Mar 2026 09:26:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773073581; x=1773678381; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xnACahr8ULD6CcAQo9gjmAw66hUMbPmLgQ2wO/RqDz0=;
        b=haVv2PUzUpJrtIXRz/Nc0tjkTrIJIfniju0b8HoJZgrM8TCrQNGtbqfuy0h0Xpqvdp
         Jpf73FMkpqKLWEcwioCdqrm36MCT2TOY4yqrzLdR+BXHHJ70NluW34NRTqgaXjNn5zIa
         3n56ct549ssusQuIoRFR7gEniccWHLztSQpArJAQGAC8GjJ+HZbvrZI5q7vEIGdE6hQS
         MQV57g3iiTpkxJlEAEraknlsA6Kxsl6CVfKz2rTL9FcGzKsv576zysPSOhLgDony5K6A
         oGVNcu/fnH1NOh6ok4BzRE/OsIorjKtHEWbz8vRc/u7mzC3sAAlN11itU3zeqQ+Mp6EZ
         /PZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773073581; x=1773678381;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xnACahr8ULD6CcAQo9gjmAw66hUMbPmLgQ2wO/RqDz0=;
        b=buOJZzpcbPpb0IJPs1W3QWmaEWfCwOYvJmBjK27Dc6R67fThRyJtSekb3SB3THV5pI
         +ZYdh2yeyGDGxxcofJcXkaH7rVV7fvPYlytKFTFW1j3L/xeAi6WLS6A9OhHbXJova+bT
         AH6d46ByF4h6I9+hS+bRgy2TlVbV7JzPNxOrjnVJUj8LthFkiTHOqx/+wBhjZCDc1fGt
         r6ExBdY0oOW6WuWMjKKW4zUiuSnX4PbpZeQK8AvpOmaCk+VzLx8U95pwkpFj1Mfd7LcT
         RonhWKImqK4EHrFZlukH25jGDEW0waPtof9RLXB2z/UOeAi7SS4NPUetkBkCmXMJB7LI
         WtkA==
X-Gm-Message-State: AOJu0Yw6b0yiWrhSwq+dAZ4SNJ5xeRoVDBYd/bJV2epS0DzukO98Hyji
	RjReMeMHxNOeMGFymNTOyUrtl6TeX5y0cumy0vOa4kfV5rQa0yzP1X+9cSvFxLz3ggzCIcfPs1g
	26zeiYtc+kFC/tVsHBZ4Wzw==
X-Received: from edbdm18.prod.google.com ([2002:a05:6402:22d2:b0:662:8221:aa6c])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:3643:b0:662:b884:d1c with SMTP id 4fb4d7f45d1cf-662b8840e10mr161656a12.10.1773073580808;
 Mon, 09 Mar 2026 09:26:20 -0700 (PDT)
Date: Mon,  9 Mar 2026 16:25:06 +0000
In-Reply-To: <20260309162516.2623589-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260309162516.2623589-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260309162516.2623589-21-vdonnefort@google.com>
Subject: [PATCH v14 20/30] KVM: arm64: Add clock support to nVHE/pKVM hyp
From: Vincent Donnefort <vdonnefort@google.com>
To: rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com, 
	linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	jstultz@google.com, qperret@google.com, will@kernel.org, 
	aneesh.kumar@kernel.org, kernel-team@android.com, 
	linux-kernel@vger.kernel.org, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

In preparation for supporting tracing from the nVHE hyp, add support to
generate timestamps with a clock fed by the CNTCVT counter. The clock
can be kept in sync with the kernel's by updating the slope values. This
will be done later.

As current we do only create a trace clock, make the whole support
dependent on the upcoming CONFIG_NVHE_EL2_TRACING.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/kvm/hyp/include/nvhe/clock.h b/arch/arm64/kvm/hyp/include/nvhe/clock.h
new file mode 100644
index 000000000000..9f429f5c0664
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
+#ifdef CONFIG_NVHE_EL2_TRACING
+void trace_clock_update(u32 mult, u32 shift, u64 epoch_ns, u64 epoch_cyc);
+u64 trace_clock(void);
+#else
+static inline void
+trace_clock_update(u32 mult, u32 shift, u64 epoch_ns, u64 epoch_cyc) { }
+static inline u64 trace_clock(void) { return 0; }
+#endif
+#endif
diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index a244ec25f8c5..8dc95257c291 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -17,7 +17,7 @@ ccflags-y += -fno-stack-protector	\
 hostprogs := gen-hyprel
 HOST_EXTRACFLAGS += -I$(objtree)/include
 
-lib-objs := clear_page.o copy_page.o memcpy.o memset.o
+lib-objs := clear_page.o copy_page.o memcpy.o memset.o tishift.o
 lib-objs := $(addprefix ../../../lib/, $(lib-objs))
 
 CFLAGS_switch.nvhe.o += -Wno-override-init
@@ -29,6 +29,7 @@ hyp-obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
 	 ../fpsimd.o ../hyp-entry.o ../exception.o ../pgtable.o
 hyp-obj-y += ../../../kernel/smccc-call.o
 hyp-obj-$(CONFIG_LIST_HARDENED) += list_debug.o
+hyp-obj-$(CONFIG_NVHE_EL2_TRACING) += clock.o
 hyp-obj-y += $(lib-objs)
 
 ##
diff --git a/arch/arm64/kvm/hyp/nvhe/clock.c b/arch/arm64/kvm/hyp/nvhe/clock.c
new file mode 100644
index 000000000000..32fc4313fe43
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
+/* Use untrusted host data */
+u64 trace_clock(void)
+{
+	struct clock_data *clock = &trace_clock_data;
+	u64 bank = smp_load_acquire(&clock->cur);
+	u64 cyc, ns;
+
+	cyc = __arch_counter_get_cntvct() - clock->data[bank].epoch_cyc;
+
+	if (likely(cyc < clock->data[bank].cyc_overflow64)) {
+		ns = cyc * clock->data[bank].mult;
+		ns >>= clock->data[bank].shift;
+	} else {
+		ns = __clock_mult_uint128(cyc, clock->data[bank].mult,
+					  clock->data[bank].shift);
+	}
+
+	return (u64)ns + clock->data[bank].epoch_ns;
+}
-- 
2.53.0.473.g4a7958ca14-goog

