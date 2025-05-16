Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B6711DED7B
	for <kvmarm@lists.linux.dev>; Fri, 16 May 2025 13:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747402869; cv=none; b=n5zwXdOk8qfiOyYwHDXGdykd9GUOKEaNq8yOFDoQgVS3bS9CaMd/BJrhhOJGqBG3HzpRpRCgwXQvPtAqFIoKz7oYUsyTZ69AuHmowXycHuC/SGB1okXuiZZUp2Awqh0gTdUrGkE5o9V0es6a4sF28yFL+ibNWA6lMz5AZ1hAD8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747402869; c=relaxed/simple;
	bh=iKzHYrZIend0a4Kxd1RwZOKdvopd4K+zlXk5zDcw+Y8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tUrFoE2S9YpdWT6+2huJ6oOM8d2HXgoRFP8NPPjyRIXR4D/rQraYTb6Mj3hMJqb85C1nOkaUBJ809DzKIvVgXy6bR/zScHQdVkqasBIeltdg5tzn3agl/RBrjkMIqf00u77Z+O0zlFO25eoVjaq1cRpTLMsBljKG5kkM/0oy8PQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=j88Sq8BR; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="j88Sq8BR"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-43cfda30a3cso11918325e9.3
        for <kvmarm@lists.linux.dev>; Fri, 16 May 2025 06:41:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747402866; x=1748007666; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=MSKik4ju3TzHedSKnXgz7MVnqHI9tA/RK0BasYybaic=;
        b=j88Sq8BRv5eFLB6h5GbDOp3DWZ6epjkyoZML9uotpbIElkGAzkXoGqBOCz6UxM3Jy4
         /L1Cfr/DgFfo5VTewhR4eQiaxopEDXenXIUyhXGJL/W/lq3pR22LmVXqpY98N3RtZBlX
         ZmUm0y6ayO1tFEQfSz8AEuDFikJWU2Zo6EzeUb6GTQU9o3YOfe6jwxKa2/qalmkFnJ2h
         0Yf4pA1cRTbs2t5/Dtb8D5mpi3IQ7G+Iz2eRl4ulVhCzcrOLHJmEnSRMNJDEt5ClQfHC
         VqQTd+NaTE7uiZ12cHLWD3W4jnHv9ERSQpo7IV6+HAYg2BOSW9sF8bz+UVib6XuOgGb5
         xUNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747402866; x=1748007666;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MSKik4ju3TzHedSKnXgz7MVnqHI9tA/RK0BasYybaic=;
        b=ctYwpzUgLKykbGbUhqbZrI/HBqzBH+i7pbX/Za8uuyY75sCCFjvxG0hv7n1Zh1Zdcg
         oWzSL9HMMRyM9JAAd+hjgbQKvm6k0qMAMKMt0tVbbhR1FQyV1f5CUX5qshhPBwnQr5f3
         WX02SJ6uxni0wiCcdfyZi+f09H5TfZ7vi9AQmC2J4J9XXvn94hcMBFohnu8qbPeQfTOe
         lCsgjdcdP/k5dc1jbx4xvViwHWuRprKQaAgoBknDMSzw7mwls3x3WuSTW4dr8/nNXJbm
         Vjha2KO5ZqmVLPtGaM8E7Ig/JSZYGLKEnerzsf1vPjn1+jyBkUn/b0Sz6CTrOOar5jKL
         cyjQ==
X-Gm-Message-State: AOJu0YxrE7nq9FzAcT2+A8EUsKhAAWQIubHTPhzrz7U094ZoDmYXPjrq
	oLO/Q/Mxr/K/FXHoR6rnaDO3eZqZdfqPTfY4NrdAx3IDr4X3/elMnW8a8s9VbXlDsePa8ulkluR
	1K/2wOKNqg9EkyZAIbNMIDg==
X-Google-Smtp-Source: AGHT+IGUdvsePM2sVc2CyjUSmSfzjwCtYEJq2sZhUx5p8v9YEcdV5sx0/XJqnV/G+IPG9QbJ03Tx2gFJaRXMW16h
X-Received: from wmbay14.prod.google.com ([2002:a05:600c:1e0e:b0:442:ddce:d53c])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:358e:b0:43d:2230:303b with SMTP id 5b1f17b1804b1-442ff029d19mr23108495e9.20.1747402865815;
 Fri, 16 May 2025 06:41:05 -0700 (PDT)
Date: Fri, 16 May 2025 14:40:23 +0100
In-Reply-To: <20250516134031.661124-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250516134031.661124-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.49.0.1101.gccaa498523-goog
Message-ID: <20250516134031.661124-18-vdonnefort@google.com>
Subject: [PATCH v5 17/25] KVM: arm64: Add clock support for the pKVM hyp
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
2.49.0.1101.gccaa498523-goog

