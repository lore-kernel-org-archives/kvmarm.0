Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C384D312819
	for <kvmarm@lists.linux.dev>; Tue,  2 Dec 2025 09:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764668215; cv=none; b=imDEkmFSXxZ1xyVaDW1ID0qybr5cVSdDDGCOMe9QAe/LDbUafs6bdYjYO2XG2fJvMwxar08sr8rENZoe446z3mOS6RgMcvyBR99ZGwZ5geMh/wceRNzTSQXjPQP0aitOtXqlUDeQfW6lrQ+Ykzvl73sAt25h8+YQ90qO8RwZYT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764668215; c=relaxed/simple;
	bh=A78S6v7BQPnmpLsH0ngbIfRTLjDC1AwOsWlasqsBA5g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XvcguUi73DnTQ49dOo9jIRrHSk/xoGx7IHaEcYZDRAkbNnuy3GJPghFDzE+kNF3Zfto9C3kqpKN3hnu3KE+WiA2UN5IDvCj2pgBI+uc2Hp14xWW/kWOqCHknO5NVCiGolRzI7UNt5R2Uswd/axHfVosxBI2xACeC/4GKgzLvk+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=x/3KGM4O; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="x/3KGM4O"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4779b3749a8so44695685e9.1
        for <kvmarm@lists.linux.dev>; Tue, 02 Dec 2025 01:36:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764668211; x=1765273011; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NElJUUivXewr9qr1zG4n3pnbZgrgkOxER+Z6nnzxCU0=;
        b=x/3KGM4OWikh914JFVGPwcEww9YC8l+3TMCIritpDzhEmdbq6UGKMix34kSytDqCMw
         j3sO3IMC3JeXZb0hX29cfbUKr1/fw1HFEwqplCNitY+ElO2UsXKr33fa5mbVsUCtTGKC
         i9YxW4tptErUY0TB/gVYp4ppIX5NWHr58DyiStluQ78SC5T6q32saDcq8an4xIwFok1H
         bJusfACIPhX+QLDstYPgjUCX34REXSNcZrVTvvpHrVjvzqLvo7N3tclvxNorIe2BL28p
         zNOMwz2K+evvJ67TZCNJOnwWghag1Z82bE5TxKy7ZKOen8e5fODLxdv23I/HmYmHTMfS
         eyNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764668211; x=1765273011;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NElJUUivXewr9qr1zG4n3pnbZgrgkOxER+Z6nnzxCU0=;
        b=CIOd5/b2VlNjNdgOrw9lIJYGvQrbEv44P1050XbqQ+JydOR/N1FSweisnj+NNYqC5v
         ApU6Gl+zqEjSaZwUmDTk2NJASCctGUGrJJmAnLzw4DHpLP3+ZQwdaJABn2cEiZZy49Rm
         BnIkAp5/y6aP/OpfN+fyQSAjsHo1lMPN0G+I00F+vHigR74YmINr5pEM4yLyG2OKhtZ+
         /Rk4ogYfwKqj+jXIsVgZE4Iug73Xq55MtiOqk3V4BIP4y/UYIbUjDkLlPo++TUY1Dxyt
         kIvWoRcdHY5RiE8pJ+pbj5PAZLzB8LX9Gxox5pMhFGakTCMonKiYZCpwyhvc6a2c57TS
         IxDQ==
X-Gm-Message-State: AOJu0YyfmlAQO3JZthRvvSXyKlvrLin2BE4mxxv+96pBV0yEkBTfTUmh
	KUz/9mFViqqsN00rN1D0L4XaC9v/OUDCZgO4gKXdQ3rwc95Pf3lOutF3bbJ1Mhi1DfcGk+m3RME
	jJ7D5LCoUz4lkcS+o4fMJvg==
X-Google-Smtp-Source: AGHT+IGBBJ9ZKyVEXt6XGTNMrn5BtibPGIAljJk4FuV2zHz3VorRA+b/HT0CYv4OlfvdksSWqdGiSdjCCrfe5NcS
X-Received: from wmdd21.prod.google.com ([2002:a05:600c:a215:b0:477:14b8:19f6])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:45cf:b0:477:8ba7:fe0a with SMTP id 5b1f17b1804b1-477c01c001bmr470590905e9.24.1764668210877;
 Tue, 02 Dec 2025 01:36:50 -0800 (PST)
Date: Tue,  2 Dec 2025 09:36:13 +0000
In-Reply-To: <20251202093623.2337860-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251202093623.2337860-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.52.0.107.ga0afd4fd5b-goog
Message-ID: <20251202093623.2337860-21-vdonnefort@google.com>
Subject: [PATCH v9 20/30] KVM: arm64: Add clock support to nVHE/pKVM hyp
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
dependant on the upcoming CONFIG_NVHE_EL2_TRACING.

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
2.52.0.107.ga0afd4fd5b-goog

