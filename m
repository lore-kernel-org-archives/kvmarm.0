Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AE31221F22
	for <kvmarm@lists.linux.dev>; Mon, 24 Feb 2025 12:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740399335; cv=none; b=lV3fVnqUPw0xyUQcuBXX5YzrNJT8ckpZcJNgCqNo/YbPLDPsSStsA02XVUBTRR+a6VhDWbxNdBZPsKnwcdCcUDUi1r+2eeCiYApcjyq3+Z2o48wpU/6z9DyWZiy5Hz3Ptr5bocEXuXcTDr/qWwcC7wDQgpbQe22D7+2kD4xOFz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740399335; c=relaxed/simple;
	bh=SZOmX+GBdQV5i7lchQoN/uuPmQGSo/TEMUUu60Qhdeg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RLJKeE9a4jLobc1cNhQCMsDSi3JW0/GysJ0aCZ/o8KvqVr1JN0QMvOeZ8v2GLpKLd5HPyAnZT0BheHbc3IEGF3yJ8QlEg2YRP9BqBPRejLDtZ9I1UFKTPGPrXprxZ2ygrljLpm9SoQjT6X5gyEV2OPM27aS5gcV0DlVKP//juMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=f96Q166f; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="f96Q166f"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-438e180821aso22004895e9.1
        for <kvmarm@lists.linux.dev>; Mon, 24 Feb 2025 04:15:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740399332; x=1741004132; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8ejK/8C7FFyT3tSgpfGWkSSasOGDMcKAf9YWEPj8A/I=;
        b=f96Q166fKcDbjGtPRJElI9qSMkDIOKSK7lNeTcW3xOoTC9t4giaqxyGuVXmFTQVBJz
         Z9j0yFxYt8WzgTuv4dglIir93zu2LT/AaK1EqGb+sBpz6D6ZEC9Fg0Nj5/7ngBARNQlK
         8lNCW+IP2LvBRapXosFqu8d8Aib4kSnrFazQZLSI2s4+Lr0R+nb0YSyu9Hl9Fd7BrRvi
         bN/6f6KXcpkMPtUHmMx6wh+MEUyZuciApHA43+utoLcaKENLlycllOVcKM28dtQcOIfa
         epVOYjjDIACLk8kJK6hH0HU+F8ZbIxtKuGVcU6dNR2nv7JN5eXLyrjKAmgO1KrTdfdbX
         ICzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740399332; x=1741004132;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8ejK/8C7FFyT3tSgpfGWkSSasOGDMcKAf9YWEPj8A/I=;
        b=FB4l3s9mP9FfrIl5CMCYrAGsi37FCEdwLs/0JNUT8+G7JyovKKWbHAhfly/02ZQm8l
         xRHr2ncYdbFwH1Y78yFId1XdhtdoPfbQXPMXdI+lcOEoyJXHt3Du/52jFrGIwDa2+jLP
         0hW6eI909UIuCx/5LO0zLPxbeOXY6gYXg9612qqAmWBrdVpMqNHvgKUSQEzMathSyQNZ
         100NlVKldmx+IrmPaq1l3/qszA3pifQG/uFJdb1JOfu78X9WCz4+HvhvnLr7hKAQyQWd
         Re17CYpVu1yqisW6AEk0tpUtVDCBcjrpxPs0gNsYGy3o1CtE0n0BPJun9XnrwsQlJ/7s
         woXQ==
X-Gm-Message-State: AOJu0YwpHI2zxNujmBlXebX6bqwoY6tQxmSCNOsBuF3vTlT8kkPHZHGU
	aqx0VHeAtynrMzNirs6Yqzi1PaXxKPyXc4hyh7NBDCLM4uTRAYsSQXRaPu/FDRkaiHrDNTGM6Ml
	kf+GnvGbpql7uuO8xDQ==
X-Google-Smtp-Source: AGHT+IGeFNtDkwoWNu5EnPAqlAhToiw57l/wri43FL+yg/iv8i7KY5/rJKLalMmMg9RRoQsj6qXyYOVqroYVfbye
X-Received: from wmqa20.prod.google.com ([2002:a05:600c:3494:b0:439:8b09:7257])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:674e:b0:439:9a5a:d3c4 with SMTP id 5b1f17b1804b1-439af7f97a4mr100497985e9.2.1740399332141;
 Mon, 24 Feb 2025 04:15:32 -0800 (PST)
Date: Mon, 24 Feb 2025 12:13:46 +0000
In-Reply-To: <20250224121353.98697-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250224121353.98697-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <20250224121353.98697-5-vdonnefort@google.com>
Subject: [PATCH 04/11] KVM: arm64: Add clock support in the nVHE hyp
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
index c838309e4ec4..355bae0056f0 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -144,5 +144,4 @@ extern u64 kvm_nvhe_sym(id_aa64smfr0_el1_sys_val);
 extern unsigned long kvm_nvhe_sym(__icache_flags);
 extern unsigned int kvm_nvhe_sym(kvm_arm_vmid_bits);
 extern unsigned int kvm_nvhe_sym(kvm_host_sve_max_vl);
-
 #endif /* __ARM64_KVM_HYP_H__ */
diff --git a/arch/arm64/kvm/hyp/include/nvhe/clock.h b/arch/arm64/kvm/hyp/include/nvhe/clock.h
new file mode 100644
index 000000000000..2bd05b3b89f9
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
+#ifdef CONFIG_TRACING
+void trace_clock_update(u32 mult, u32 shift, u64 epoch_ns, u64 epoch_cyc);
+u64 trace_clock(void);
+#else
+static inline void
+trace_clock_update(u32 mult, u32 shift, u64 epoch_ns, u64 epoch_cyc) { }
+static inline u64 trace_clock(void) { return 0; }
+#endif
+#endif
diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index b43426a493df..323e992089bd 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -28,6 +28,7 @@ hyp-obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o host.o
 hyp-obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
 	 ../fpsimd.o ../hyp-entry.o ../exception.o ../pgtable.o
 hyp-obj-$(CONFIG_LIST_HARDENED) += list_debug.o
+hyp-obj-$(CONFIG_TRACING) += clock.o
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
2.48.1.601.g30ceb7b040-goog

