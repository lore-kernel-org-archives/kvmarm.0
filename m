Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD7B2356A14
	for <kvmarm@lists.linux.dev>; Sat, 31 Jan 2026 13:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769866184; cv=none; b=CwfU+hj23lbBD5ZvXexRgHFblnqzKeSUayI25hvpEqz1K+2BcwOW97kcCsGLMfxwFD561ax4PZXbxiOyrG+jJfmaTAKKy5VgKvdi3KhggoBUMdTNNcwlWFEJwr5tUimD3O0Jh/oqtHRA9TVhHnkHx/Zg8VSE2zSDchpTTIA/xSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769866184; c=relaxed/simple;
	bh=fhPeQWVBSnCBrnALKVurTRUuPiSMZ+f8M8+cUOxcd9o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BpCB1N7J+oDmPVwK6+Ec8UG5YhdrAB+xuwyFp1nJtbEcWJNi5CcUdvWb0XMb432pRpT+Nx8DZCaXkf8aizThL2wfy5UnIo7A/UZt+8IGB0F3CXrGAq2olqS8aYxl9NdEzh5HzkhFeEbS8cZxvy51PIkE099EOxQcIkoypVOSAIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RaTjXHxx; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RaTjXHxx"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4806865a01bso20485865e9.0
        for <kvmarm@lists.linux.dev>; Sat, 31 Jan 2026 05:29:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769866180; x=1770470980; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=goZ+MaQKy7l7B7ncr3K66S9aihGDrIDC3mypa0RPtIo=;
        b=RaTjXHxxkidSTassFECS3e0WHIcCdDHrn5DGvJ2VZaGDUU3lE6vwCxPmmN0pSCk7KV
         koOirvygWuzVmUM0hQvycy+F9qyTDERMD/agUay1xrvvanY1VwQjKSt5LkN5Lj6ihVOj
         rd2nusPLICR9Z3pXDzsXNXBvIO/qabXsdQ8do8Df50WHF95Vbw7gocs1AdbpsG4OBJN5
         w+vULPs1d0/KDLvZ7t6fdOiMu+ubPDxC58JzCzAbD6Pp8zzJwkBua13UcFXh7vVCFJeq
         +Uw+s6ZbSkQNwvcwZ4tu1ETT0VoILSyBtKyvMze0anQbT9IL+P/Ibz1mUvtmxJ/RR//J
         UaoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769866180; x=1770470980;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=goZ+MaQKy7l7B7ncr3K66S9aihGDrIDC3mypa0RPtIo=;
        b=tW+ssU7+kvNOBt6u9jp6i7rp45kLWpPZX/5Uzl33Lhq2Jssv+/HtyyaM7jlg/PWdWV
         AyARLD6fhQV0gGXXpoIgLukCcWdEMf9j++xnhu6SaKEBioqumxEkBiKCiXuOSMHDjWwD
         ufXXZy4lmYiRVai2bwqkrF7mO9eG7kn2uPmA+ZchG9US3z3CLnZ7Drhi3Ys9TYKlHFpv
         EES4O3SbOTuqhlVmFUJInVjSESzJ+8UyJJ0YW7og+kJE8kIVGB6V0E0ZjVCJY1hPKVsa
         gdgwcZsinly6maV5osPLfg/nc2VZ5EBTrmqZCX/xIMiChcyRomQpSVhMOow6Q3irw5VY
         70jQ==
X-Gm-Message-State: AOJu0YwsupcwCjMjrqN25TsLfNagzjCR8kV157XoMCZvPjWy8Grp2/WY
	5BfudvfgkdGeNh4vMP9Ccqh4971rAsRs0coivLsuKQWxCUizGB0B5FSUTBYj+kfUB61iM9F8cl3
	R68gYCVbEbZWhNAO3otSMKQ==
X-Received: from wmz6.prod.google.com ([2002:a05:600c:6b66:b0:480:1b84:b6e])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1da8:b0:480:3a71:92b2 with SMTP id 5b1f17b1804b1-482db498227mr71271215e9.26.1769866180081;
 Sat, 31 Jan 2026 05:29:40 -0800 (PST)
Date: Sat, 31 Jan 2026 13:28:38 +0000
In-Reply-To: <20260131132848.254084-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260131132848.254084-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.53.0.rc1.225.gd81095ad13-goog
Message-ID: <20260131132848.254084-21-vdonnefort@google.com>
Subject: [PATCH v11 20/30] KVM: arm64: Add clock support to nVHE/pKVM hyp
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
2.53.0.rc1.225.gd81095ad13-goog

