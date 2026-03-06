Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 734723BED23
	for <kvmarm@lists.linux.dev>; Fri,  6 Mar 2026 14:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772807776; cv=none; b=JPM5gNPCt3PPjn6vp8LyyCSYKDjW841l1t8BbrP9cFKQ447LiM/WC9nidEhbaGWVuQTFvHo2kf7QseqHpe7bJvWQLHvlcZ74Np9NQOMYInN89haYHcUKn47WzN3+rxocKs50KBEUPm+rtxwuslvjMjVyjvIlARCrIfv/US86GCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772807776; c=relaxed/simple;
	bh=h2rVCYiv2RErJ8J/DPs4R6liat0vq1OWoPSAfx6DS2s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Ec3ms5IkSvjrjUuF+u0pdqXBcuJkHOhmt9n9tz5mDMAxL9pBionX3qVXSjitme+ydy0R/pE37p6vP3UrgECm0Ak3fOIGSw9n6D/MFpg2z8FwZfC0nCDZsTGmcNxj3EAxv3RXWgJbs8Nv0iw8dd7Y4to9kzUCAgWrp+J6fRJ22kM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IvQkgtuF; arc=none smtp.client-ip=209.85.208.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IvQkgtuF"
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-661aae3a881so1356213a12.1
        for <kvmarm@lists.linux.dev>; Fri, 06 Mar 2026 06:36:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772807773; x=1773412573; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xnACahr8ULD6CcAQo9gjmAw66hUMbPmLgQ2wO/RqDz0=;
        b=IvQkgtuFQA/jZXRAsp0+0kaNglhLx95JW7tlfWtMf1NN0iHspjhRFDEdgahQtd7hid
         hlaeo/IcuCeiWJJjRyN/pN5xTXQdSGZ04TNlTsTvoA7FWWWGmaeKNEidNPAM6ZaG6nsQ
         wiH1DZXim6e0wg4kmxNHr06G1IbdHrGFLyV1ZPQ/rBMD2Q0yoVo+TMLy05Yb/R3ktocQ
         sraeanyPU4+YB/ea7mGBieVEVi1VPKOnS04wc/6EihpVL+/B+QRFlhfMnCtlgrF9R3JY
         Y/XR2GrgOIQo0qrHPm7g7mkVkP5TpDy0PbUSTXqulGDp5/X4bO3nMhmJqQWYUMymB1/A
         s3qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772807773; x=1773412573;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xnACahr8ULD6CcAQo9gjmAw66hUMbPmLgQ2wO/RqDz0=;
        b=n9Qs6SFSWzVhVysAHvPBLkznZKXjhpdMdHT7+VG35NUtfJ/CCfK6XbL5RlEiqR0Yby
         zLV0pDjJ888hTsMXD1FrMYfdFTzUrpRB38HUn584FxvIcXVN7Gx3im8yHV3WCymDPGlP
         4LnAs1FjdmIApCkEo4UWszSAA03FG5bOemQPCF8rC2Qta69BjmUmZi7jcE9xOIfN/D2W
         +pNhXkE/PebipTCrfzagUONntoBXlxq2993BaYXO57twP9tmMXlwzmb7XUIFXgctdB8B
         uleL7VGDcf2kT61mHIG9edmKUn3sk1ZCh/2KBpyrc9/XDnV8oRwkns4nI6WhexFVv37S
         b9/A==
X-Gm-Message-State: AOJu0YxoeLHVXSWWIvD9M0px/6QKFzlxEsGfmcVKkMkEZQG0fYXgt8iP
	/esMqbeQnNe/HcdWQjNEdi6MkLucojKZfpc89AWGYiYNbr5SCmGyah+C/+t8k8VirBtFLWeq5eg
	7FcvidNJgQA4c+EWM8yVAlQ==
X-Received: from edrs15.prod.google.com ([2002:aa7:c54f:0:b0:660:a4e3:2ed2])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:430c:b0:65a:2ec5:99c0 with SMTP id 4fb4d7f45d1cf-6619d4565b4mr1408474a12.3.1772807772463;
 Fri, 06 Mar 2026 06:36:12 -0800 (PST)
Date: Fri,  6 Mar 2026 14:35:24 +0000
In-Reply-To: <20260306143536.339777-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260306143536.339777-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260306143536.339777-21-vdonnefort@google.com>
Subject: [PATCH v13 20/32] KVM: arm64: Add clock support to nVHE/pKVM hyp
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

