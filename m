Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE55624C077
	for <kvmarm@lists.linux.dev>; Fri,  3 Oct 2025 13:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759498761; cv=none; b=iV8ZM/eqS3C1H7DFSgmrCvrdZf7uiPNCDsR18GPQKBubmSxEtPK6z45WZMC1sDpkA7BJXmutUN4VBn30ctvlbJGn4bWV1Zau0z+104MQdeAfIdlJ86fPkoBSTMyco3JsQhVpqJoSxVpj9XSXAv9h1MS3wifBLJtmkT3xayvef2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759498761; c=relaxed/simple;
	bh=g+NA4zSfwGxqsI4IC/ZtvkJUw3mWlopfHq/pqvBkNBQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=apsIH4w5lgWCsde41Ts5kZWdOS5PTfcr0fv3oep7XuK+k0Duh2NtVanWW9bUWpwoMzouB+ILnWpEEdUN68WiI/LW2UK0bM04nDV5exzxRGi0ZIvjbi0JHtVBVV3ir4OAvjTA7e2YX2VSypRkACchDpfKZ2MaNCFo559Jog29YaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KN5dt75U; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KN5dt75U"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-46e47d14dceso8887025e9.2
        for <kvmarm@lists.linux.dev>; Fri, 03 Oct 2025 06:39:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759498756; x=1760103556; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ylDyk9s+5460dWO0uwqzLTOwTHPUFfBCKGnbJPl3EJ0=;
        b=KN5dt75UbbPresDwjSIDhiXpd98W3Ec5k7bFCXsFrTs4b6d0OGyoWyHA1zGy9gKa+d
         vS1a3Jky5UGyMl8BhD91ztPiH8nK5NWJ/uxxwo7g3Jm0uVbZj9bNZprZEizvrtsOYarL
         m7mNGG2KNrsFh8lewYonmcw7u+Epy2PCMIgKgrnR73OZ/fxIktqupxe5yrYgGy6Li8U/
         Q8QRdc91jTL/4YIq+e5k2mu7fVXeXVMSDLVF8jPTPxDHejtn4sobYJGmoIDQ48TQv/l9
         6TRrmtWF+PNcKt+bodH/ul3ABMe5LbCgPcML9viUwJKJwPvKm+XfFydyaJpguq1g5DYl
         NeiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759498756; x=1760103556;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ylDyk9s+5460dWO0uwqzLTOwTHPUFfBCKGnbJPl3EJ0=;
        b=CJGpkZwTdRZ7QCYlm/4XA3/9PNHIjrI/YrABMUwFVfnlj4zcdNpQafL6OAgJVVmLj/
         Mp4o+RzocCkaI5KDM0Wq1HnEANWrDUDU13cn9ml7Eku9zDAkUFl8jqtmV1eOBG5W9Lze
         8y2TCANTR97JEAtQRhw/lPFuFLahIlBO5KxR52w6Tf1ZopnVZrJrEL1/Hro588GBbuOW
         D2K3gbo8Ylu3+/Phf+TaJwMHgn2T07pOYp0hVxqDKZxILBVai0YG8F8slzRX+KtK5I0Q
         hYfi3gv6bAQhQxr82jeuQ1lv0ftWsZ+ojul8MOxmc7Zy6Duaa1TJmEhnuh9O5cuMUj9P
         hLpg==
X-Gm-Message-State: AOJu0YzTZhbJ7kneOGfmpxgV56WhG0q3ruI99XyaRqBrJIDSSIifcn4W
	eG6zmgDI31N9qkHoSwg9Y3MJlMUoesdTR/wzXYLGRMbCWWsyeEiin0e3Mx9PazlDvqHfel0Ic6f
	/Y4oXS5Gv/Lo/rzGriGC6ZA==
X-Google-Smtp-Source: AGHT+IFhcfElMZQqoCh3Cq6hmENi8kEnMvrnlOccnmd1TZhS72DJCQ0YPYUh2/TUKvb4CJDArB7pSvRYLVze8uJU
X-Received: from wmjf9.prod.google.com ([2002:a7b:cd09:0:b0:46b:7c6d:220])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:468e:b0:43c:ec4c:25b4 with SMTP id 5b1f17b1804b1-46e71102467mr22982065e9.10.1759498755769;
 Fri, 03 Oct 2025 06:39:15 -0700 (PDT)
Date: Fri,  3 Oct 2025 14:38:17 +0100
In-Reply-To: <20251003133825.2068970-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251003133825.2068970-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.51.0.618.g983fd99d29-goog
Message-ID: <20251003133825.2068970-21-vdonnefort@google.com>
Subject: [PATCH v7 20/28] KVM: arm64: Add clock support for the pKVM hyp
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
2.51.0.618.g983fd99d29-goog

