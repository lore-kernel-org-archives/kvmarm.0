Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CC932EF67F
	for <kvmarm@lists.linux.dev>; Thu, 21 Aug 2025 08:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755764087; cv=none; b=Ha03oSyL+0+pFUba3uFmgcexIdLv/cL4UQXdvHMDn4RAj2TVCymPyQ2LACT1ZqL9GanUgNrB6VnCDcbRb1EQjmToTCVYSGis3m4s+SCpA5Q/Yb1GFqN6jVOV/+1CWxv8MCUTtNB39Lxy/6rO6+StCjNw5oh6SjYKr7TytvMiOFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755764087; c=relaxed/simple;
	bh=ssX6pnv/BMHDiEMq3MmpaclSzI29qITuu1YF5wLH5RY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SpO4fqwAJNe/7RXedHLGIBqa0o7d7OY5xtXhWjyIZVyr/pP1ZEGPbGPbcvkl+tcEeK1EeApjqBW7TfGMh3jHxWR+RdLjSHIKpNHk+p5YftwjQxfCZGLy6oox6VJ0Qxp8rWY3DtDjqkuj073bzEYdhgIyrtuPCGSFUzQYbbwzuws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZxLu7AZn; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZxLu7AZn"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-3b9d41bd50aso508811f8f.0
        for <kvmarm@lists.linux.dev>; Thu, 21 Aug 2025 01:14:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755764084; x=1756368884; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=J6PqHQ+VSrJuXFil8vRzl3n00OmPsRbJiS1vDm4o6lA=;
        b=ZxLu7AZnzjOs24UUP/c3dQymc7znNONxzHNMfJgH52MNqtvRpMDIPIjQzG892pN8H9
         0rdON2JBjFEMdxzKc9ny3ealSMG0tU6ua4A4OP0nUZPeNyHCDX108/5nrywA7QY6h8V3
         9NzpbwKBdNkLCHuE+DI3gKA/+j2aD77atK642rUGPGYn5kuHhl+dQoNUYIGsLLvMHzYN
         6p/dwC3rnkBV7ufo0W94cWrN2o0NUR+HABBlc8n48PVEPCma1/vuEa/eJFQVE8pJpowT
         7V2q+9/Izc9+J8BiEjL9nxc/6zG5tAcn6vQNl8zIrFAwSWJIfzc+aCG9jrmYdAJobxI5
         37ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755764084; x=1756368884;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=J6PqHQ+VSrJuXFil8vRzl3n00OmPsRbJiS1vDm4o6lA=;
        b=uBYjcpP59mtuvaf0XSP2tG+8g1lnlOrqYmF0JwfIXncXkXf3ZntHutwDFyyfb9cUzO
         ucjffn+XIOmxMcShNnwA2Z2Yx2BL6fCwaCpgtEwnwfJGdsCfnHXz1mdjSzg3UlZ8OHwS
         2SoJtwex6SrsE1EMOnNsnTHNVN0tDIM47qsmvtjwKG/OMlvLtehbUtRLoN2HZItxJ4/0
         05dOaMiBxsiBZ6Jz1Smj2FkCN6R0FBvlsXV8ws3lPs/R/b5Xlp637B/vD9W9EkzTLMBa
         eJvI2TPXDcAEfRRqKHTC94tZJcOBGbJgfes5ColTTVvZDMZ/8SnhXrXWuzXx+53N5dca
         SQTQ==
X-Gm-Message-State: AOJu0Yz42mosUavPMtsE/J6TdBgtygZSWS2STs+VmGcUtfYTgh+MLChm
	URRVeiZbAbNkzTuUu2Ra2OYD+mcjUq2XKYlqI9+qnPDt7QTYCB3TFWzcbwm41GP2k3q1J7EJmvv
	T59hEO1icxql74nK4nVUdXw==
X-Google-Smtp-Source: AGHT+IHjSHmggKyPUo9IkQhNfhc+5LXvr/ll1IavLoHjTMFXBwqe1Lx+YS0W/l095EMX48jc3sXU+Ed9/HB+3KTX
X-Received: from wrar28.prod.google.com ([2002:adf:b1dc:0:b0:3b8:fa02:c0b5])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:2d82:b0:3c4:edc0:2895 with SMTP id ffacd0b85a97d-3c4edc02d24mr532633f8f.62.1755764084544;
 Thu, 21 Aug 2025 01:14:44 -0700 (PDT)
Date: Thu, 21 Aug 2025 09:14:04 +0100
In-Reply-To: <20250821081412.1008261-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250821081412.1008261-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.51.0.rc2.233.g662b1ed5c5-goog
Message-ID: <20250821081412.1008261-17-vdonnefort@google.com>
Subject: [PATCH v6 16/24] KVM: arm64: Add clock support for the pKVM hyp
From: Vincent Donnefort <vdonnefort@google.com>
To: rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com, 
	linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	jstultz@google.com, qperret@google.com, will@kernel.org, 
	aneesh.kumar@kernel.org, kernel-team@android.com, 
	linux-kernel@vger.kernel.org, Vincent Donnefort <vdonnefort@google.com>
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
index 0b0a68b663d4..607357e36026 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -17,7 +17,7 @@ ccflags-y += -fno-stack-protector	\
 hostprogs := gen-hyprel
 HOST_EXTRACFLAGS += -I$(objtree)/include
 
-lib-objs := clear_page.o copy_page.o memcpy.o memset.o
+lib-objs := clear_page.o copy_page.o memcpy.o memset.o tishift.o
 lib-objs := $(addprefix ../../../lib/, $(lib-objs))
 
 CFLAGS_switch.nvhe.o += -Wno-override-init
@@ -28,6 +28,7 @@ hyp-obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o host.o
 hyp-obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
 	 ../fpsimd.o ../hyp-entry.o ../exception.o ../pgtable.o
 hyp-obj-$(CONFIG_LIST_HARDENED) += list_debug.o
+hyp-obj-$(CONFIG_PKVM_TRACING) += clock.o
 hyp-obj-y += $(lib-objs)
 
 ##
diff --git a/arch/arm64/kvm/hyp/nvhe/clock.c b/arch/arm64/kvm/hyp/nvhe/clock.c
new file mode 100644
index 000000000000..600a300bece7
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
+					  clock->data[bank].shift);
+	}
+
+	return (u64)ns + clock->data[bank].epoch_ns;
+}
-- 
2.51.0.rc2.233.g662b1ed5c5-goog

