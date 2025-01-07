Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 030EE1EE7C4
	for <kvmarm@lists.linux.dev>; Tue,  7 Jan 2025 11:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736249717; cv=none; b=fco6GXjCkK/iA3snu0fus+XKLIS88ftIe0Sb5Kdu6fyD3cbCznc4ZM5ldpFnBtZMLr+ddUfVOpyhL7X1JHaaxCdJ0JKbrWJHHbYLRSsHyEYWu6xCmLDXvUOehHp0oOV7UZPxiJFXYJASksT2aEkNuYSDxSKm2VvOJjahtUGO/Fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736249717; c=relaxed/simple;
	bh=Wv4PolvkKnvL9Mo1h5WACyK9WDdQldUJdXUIl/u8MeM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=U/DWaPouSVmGUC+QiUU6lLS4xEXkm8xIEjBM0FNgd4iaH8y8AtP9C/1P3fHxJFg+JHfo2WGrXcVSPaPR43KS6y3sTjOgd98EB/tk+O84nSJkz+dl6Zwi4wSwLPr/RsM+WTwndmMPqw/UC/0YAu+ufbc8f2C7zHhfnLFFZosTdEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=S4anoAJ8; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="S4anoAJ8"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-436202dd7f6so174771125e9.0
        for <kvmarm@lists.linux.dev>; Tue, 07 Jan 2025 03:35:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1736249712; x=1736854512; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=361dVHxyYbzfXGnUF4Ia+mPKpgg8pWQWoFNDsGCUa2w=;
        b=S4anoAJ8JGSUnwzHVefw9u9arHosjj3a4BncWZcFFyBN9cjnay8Zl+dQIr+s40qBWu
         gl0ARfs8+TZGom6W9K+uBpzjJpSy6FMFRfZoq/nG7gBJw37fGYp/5rksJhLlawFJt5Sm
         Y1TocnUZqM5iRhEBgBZbGokhU6DON8YkdLGZR2oh0wXrzHKx8xnLV8a6ZzLvYyfqtgYW
         cMQcL/9YSoalrEnQDyz0dxCjKSSdr1xntCT9/gqGD11aAqNd/LsMrCuCTkpQNk4Tj3NI
         yIDqPSe0hPmiNhlHZP/loJHbHkLwtLUzHwixCBtdYmqC1X8ipQhBoCRpXzlSTnPj8Y7F
         b+RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736249712; x=1736854512;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=361dVHxyYbzfXGnUF4Ia+mPKpgg8pWQWoFNDsGCUa2w=;
        b=k3Zs4UnUmMPhUxxk3LqbOkxmIxGFaEEeF5feN+ocQImObt5j7nK/EB61uns/cAaBJu
         uY61cnkWKPFToImPJTh1XnNhRy2DkhyONq6mECmxtG5eu0PkXRNP59Gw/4j8/Jyjdp8B
         B+1yrAi5QHByXG29NMb/7qzcJSy4EdGj4xyu5uESsOH3LDkaC9yThROQTWlXI7qkA3Zt
         TH3FGjnzmhZOYQ0CWkFDwIbhb+M594IXqVI1SXR/Vr6kMvnxstn5eK769iqjajIq1XIz
         v7Bia/dWeDdMbjkNKWPuLkoP7J9PfyhqerB36eeqsWQL6r/lX/8xb2ExnlnK7PgEWiU6
         yLqw==
X-Forwarded-Encrypted: i=1; AJvYcCUEd4Irdl2Qb8GJRB67QymxIPyB/cp952XcEKmHrZHOTkd1v1g2nPLq+WTBLuzCxBbrmtS/CVA=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywku4ht9NwrrSP+enA7LgX+M8Lag3U10hOxa/vLtjG63Bp1hRC3
	Pe8FnK1wR+5Yah4iEtcMXaS6NsDNK4IoisgDlO9aegmXVYNuJaeQg+vErBjCyjI=
X-Gm-Gg: ASbGnctExUFR6ViOK9GhTJ3SG9LFtCIv410okRtXmkRdATjEiQsqfQ26eS/qujL5iZi
	Ab1hXuU7eWBOmcaqh81YeyXwO2HEGwmGKOTchAQtHIK1s2Fh830mBg2U4jaQeVdiHG2u7jVX6Gw
	XO/IPLzAzAJriK0MV0KJuHlVUGOb7fwe6n879aRWwJSeJrL6pDoRkrVE2prp1VA+fC3uD6wKB25
	b/owdlUTcnk3tGcfP50L34CLFnIJmg4FEwvcXvO8qQlnfgrO0pZAPVo
X-Google-Smtp-Source: AGHT+IEPIBkpUbKZmzd11xA9RlSbKwTWjgAlK2hoOybk1pgXH7+fgfg4ZL8FPrxTRRNcipcPh+zn8w==
X-Received: by 2002:a5d:6da4:0:b0:386:3864:5cf2 with SMTP id ffacd0b85a97d-38a221f0e37mr49281056f8f.19.1736249712387;
        Tue, 07 Jan 2025 03:35:12 -0800 (PST)
Received: from pop-os.. ([145.224.66.180])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38a1c89e1acsm50299218f8f.68.2025.01.07.03.35.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2025 03:35:12 -0800 (PST)
From: James Clark <james.clark@linaro.org>
To: maz@kernel.org,
	kvmarm@lists.linux.dev,
	oliver.upton@linux.dev,
	suzuki.poulose@arm.com,
	coresight@lists.linaro.org
Cc: James Clark <james.clark@linaro.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mike Leach <mike.leach@linaro.org>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Mark Brown <broonie@kernel.org>,
	James Morse <james.morse@arm.com>,
	Shiqi Liu <shiqiliu@hust.edu.cn>,
	Fuad Tabba <tabba@google.com>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Raghavendra Rao Ananta <rananta@google.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v10 08/10] KVM: arm64: coresight: Give TRBE enabled state to KVM
Date: Tue,  7 Jan 2025 11:32:45 +0000
Message-Id: <20250107113252.260631-9-james.clark@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250107113252.260631-1-james.clark@linaro.org>
References: <20250107113252.260631-1-james.clark@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently in nVHE, KVM has to check if TRBE is enabled on every guest
switch even if it was never used. Because it's a debug feature and is
more likely to not be used than used, give KVM the TRBE buffer status to
allow a much simpler and faster do-nothing path in the hyp.

Protected mode now disables trace regardless of TRBE (because
trfcr_while_in_guest is always 0), which was not previously done.
However, it continues to flush whenever the buffer is enabled
regardless of the filter status. This avoids the hypothetical case of a
host that had disabled the filter but not flushed which would arise if
only doing the flush when the filter was enabled.

Signed-off-by: James Clark <james.clark@linaro.org>
---
 arch/arm64/include/asm/kvm_host.h            |  9 +++
 arch/arm64/kvm/debug.c                       | 32 +++++++++-
 arch/arm64/kvm/hyp/nvhe/debug-sr.c           | 63 ++++++++++++--------
 drivers/hwtracing/coresight/coresight-trbe.c |  3 +
 4 files changed, 79 insertions(+), 28 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index fb252d540850..b244ec44bd3a 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -612,6 +612,8 @@ struct cpu_sve_state {
 struct kvm_host_data {
 #define KVM_HOST_DATA_FLAG_HAS_SPE	0
 #define KVM_HOST_DATA_FLAG_HAS_TRBE	1
+#define KVM_HOST_DATA_FLAG_TRBE_ENABLED			2
+#define KVM_HOST_DATA_FLAG_EL1_TRACING_CONFIGURED	3
 	unsigned long flags;
 
 	struct kvm_cpu_context host_ctxt;
@@ -657,6 +659,9 @@ struct kvm_host_data {
 		u64 mdcr_el2;
 	} host_debug_state;
 
+	/* Guest trace filter value */
+	u64 trfcr_while_in_guest;
+
 	/* Number of programmable event counters (PMCR_EL0.N) for this CPU */
 	unsigned int nr_event_counters;
 };
@@ -1381,6 +1386,8 @@ static inline bool kvm_pmu_counter_deferred(struct perf_event_attr *attr)
 void kvm_set_pmu_events(u64 set, struct perf_event_attr *attr);
 void kvm_clr_pmu_events(u64 clr);
 bool kvm_set_pmuserenr(u64 val);
+void kvm_enable_trbe(void);
+void kvm_disable_trbe(void);
 #else
 static inline void kvm_set_pmu_events(u64 set, struct perf_event_attr *attr) {}
 static inline void kvm_clr_pmu_events(u64 clr) {}
@@ -1388,6 +1395,8 @@ static inline bool kvm_set_pmuserenr(u64 val)
 {
 	return false;
 }
+static inline void kvm_enable_trbe(void) {}
+static inline void kvm_disable_trbe(void) {}
 #endif
 
 void kvm_vcpu_load_vhe(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
index 1ee2fd765b62..e1ac3d2a65be 100644
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -309,7 +309,33 @@ void kvm_init_host_debug_data(void)
 	    !(read_sysreg_s(SYS_PMBIDR_EL1) & PMBIDR_EL1_P))
 		host_data_set_flag(HAS_SPE);
 
-	if (cpuid_feature_extract_unsigned_field(dfr0, ID_AA64DFR0_EL1_TraceBuffer_SHIFT) &&
-	    !(read_sysreg_s(SYS_TRBIDR_EL1) & TRBIDR_EL1_P))
-		host_data_set_flag(HAS_TRBE);
+	if (cpuid_feature_extract_unsigned_field(dfr0, ID_AA64DFR0_EL1_TraceFilt_SHIFT)) {
+		/* Force disable trace in protected mode in case of no TRBE */
+		if (is_protected_kvm_enabled())
+			host_data_set_flag(EL1_TRACING_CONFIGURED);
+
+		if (cpuid_feature_extract_unsigned_field(dfr0, ID_AA64DFR0_EL1_TraceBuffer_SHIFT) &&
+		    !(read_sysreg_s(SYS_TRBIDR_EL1) & TRBIDR_EL1_P))
+			host_data_set_flag(HAS_TRBE);
+	}
+}
+
+void kvm_enable_trbe(void)
+{
+	if (has_vhe() || is_protected_kvm_enabled() ||
+	    WARN_ON_ONCE(preemptible()))
+		return;
+
+	host_data_set_flag(TRBE_ENABLED);
+}
+EXPORT_SYMBOL_GPL(kvm_enable_trbe);
+
+void kvm_disable_trbe(void)
+{
+	if (has_vhe() || is_protected_kvm_enabled() ||
+	    WARN_ON_ONCE(preemptible()))
+		return;
+
+	host_data_clear_flag(TRBE_ENABLED);
 }
+EXPORT_SYMBOL_GPL(kvm_disable_trbe);
diff --git a/arch/arm64/kvm/hyp/nvhe/debug-sr.c b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
index 858bb38e273f..2f4a4f5036bb 100644
--- a/arch/arm64/kvm/hyp/nvhe/debug-sr.c
+++ b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
@@ -51,32 +51,45 @@ static void __debug_restore_spe(u64 pmscr_el1)
 	write_sysreg_el1(pmscr_el1, SYS_PMSCR);
 }
 
-static void __debug_save_trace(u64 *trfcr_el1)
+static void __trace_do_switch(u64 *saved_trfcr, u64 new_trfcr)
 {
-	*trfcr_el1 = 0;
+	*saved_trfcr = read_sysreg_el1(SYS_TRFCR);
+	write_sysreg_el1(new_trfcr, SYS_TRFCR);
+}
 
-	/* Check if the TRBE is enabled */
-	if (!(read_sysreg_s(SYS_TRBLIMITR_EL1) & TRBLIMITR_EL1_E))
-		return;
-	/*
-	 * Prohibit trace generation while we are in guest.
-	 * Since access to TRFCR_EL1 is trapped, the guest can't
-	 * modify the filtering set by the host.
-	 */
-	*trfcr_el1 = read_sysreg_el1(SYS_TRFCR);
-	write_sysreg_el1(0, SYS_TRFCR);
-	isb();
-	/* Drain the trace buffer to memory */
-	tsb_csync();
+static bool __trace_needs_drain(void)
+{
+	if (is_protected_kvm_enabled() && host_data_test_flag(HAS_TRBE))
+		return read_sysreg_s(SYS_TRBLIMITR_EL1) & TRBLIMITR_EL1_E;
+
+	return host_data_test_flag(TRBE_ENABLED);
 }
 
-static void __debug_restore_trace(u64 trfcr_el1)
+static bool __trace_needs_switch(void)
 {
-	if (!trfcr_el1)
-		return;
+	return host_data_test_flag(TRBE_ENABLED) ||
+	       host_data_test_flag(EL1_TRACING_CONFIGURED);
+}
+
+static void __trace_switch_to_guest(void)
+{
+	/* Unsupported with TRBE so disable */
+	if (host_data_test_flag(TRBE_ENABLED))
+		*host_data_ptr(trfcr_while_in_guest) = 0;
+
+	__trace_do_switch(host_data_ptr(host_debug_state.trfcr_el1),
+			  *host_data_ptr(trfcr_while_in_guest));
 
-	/* Restore trace filter controls */
-	write_sysreg_el1(trfcr_el1, SYS_TRFCR);
+	if (__trace_needs_drain()) {
+		isb();
+		tsb_csync();
+	}
+}
+
+static void __trace_switch_to_host(void)
+{
+	__trace_do_switch(host_data_ptr(trfcr_while_in_guest),
+			  *host_data_ptr(host_debug_state.trfcr_el1));
 }
 
 void __debug_save_host_buffers_nvhe(struct kvm_vcpu *vcpu)
@@ -84,9 +97,9 @@ void __debug_save_host_buffers_nvhe(struct kvm_vcpu *vcpu)
 	/* Disable and flush SPE data generation */
 	if (host_data_test_flag(HAS_SPE))
 		__debug_save_spe(host_data_ptr(host_debug_state.pmscr_el1));
-	/* Disable and flush Self-Hosted Trace generation */
-	if (host_data_test_flag(HAS_TRBE))
-		__debug_save_trace(host_data_ptr(host_debug_state.trfcr_el1));
+
+	if (__trace_needs_switch())
+		__trace_switch_to_guest();
 }
 
 void __debug_switch_to_guest(struct kvm_vcpu *vcpu)
@@ -98,8 +111,8 @@ void __debug_restore_host_buffers_nvhe(struct kvm_vcpu *vcpu)
 {
 	if (host_data_test_flag(HAS_SPE))
 		__debug_restore_spe(*host_data_ptr(host_debug_state.pmscr_el1));
-	if (host_data_test_flag(HAS_TRBE))
-		__debug_restore_trace(*host_data_ptr(host_debug_state.trfcr_el1));
+	if (__trace_needs_switch())
+		__trace_switch_to_host();
 }
 
 void __debug_switch_to_host(struct kvm_vcpu *vcpu)
diff --git a/drivers/hwtracing/coresight/coresight-trbe.c b/drivers/hwtracing/coresight/coresight-trbe.c
index 03d3695ba5aa..a728802d2206 100644
--- a/drivers/hwtracing/coresight/coresight-trbe.c
+++ b/drivers/hwtracing/coresight/coresight-trbe.c
@@ -17,6 +17,7 @@
 
 #include <asm/barrier.h>
 #include <asm/cpufeature.h>
+#include <linux/kvm_host.h>
 #include <linux/vmalloc.h>
 
 #include "coresight-self-hosted-trace.h"
@@ -221,6 +222,7 @@ static inline void set_trbe_enabled(struct trbe_cpudata *cpudata, u64 trblimitr)
 	 */
 	trblimitr |= TRBLIMITR_EL1_E;
 	write_sysreg_s(trblimitr, SYS_TRBLIMITR_EL1);
+	kvm_enable_trbe();
 
 	/* Synchronize the TRBE enable event */
 	isb();
@@ -239,6 +241,7 @@ static inline void set_trbe_disabled(struct trbe_cpudata *cpudata)
 	 */
 	trblimitr &= ~TRBLIMITR_EL1_E;
 	write_sysreg_s(trblimitr, SYS_TRBLIMITR_EL1);
+	kvm_disable_trbe();
 
 	if (trbe_needs_drain_after_disable(cpudata))
 		trbe_drain_buffer();
-- 
2.34.1

