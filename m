Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFCFA1DE8B2
	for <kvmarm@lists.linux.dev>; Mon,  6 Jan 2025 14:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736173531; cv=none; b=aj5GP22lxiuJrCKyzypofiBHY7eHxXnLPy/L6245yIwDF1nSUZP3CBUmI3sDqq4pnVvSsnwGaxT4HXlVRoK9GI0LeWlhZK0MAZGpPqCcUgz+PduN2q/jgwo3Z37kkKhqLKL6zvmecYzN4ZG2nRDbeYUDgFQ6qNuYPoagofT2yBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736173531; c=relaxed/simple;
	bh=Z3hNXFTWsi2VMNGUTZU3m56uqM9TsOxLaJPjr9uPxTg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NGHBP+65hdnfm6960Z26CBv69X8yWly8tp3jUd/+8CMh3opJjCprJ063pfbDnxAWCiL6OfQPS77uyC9S8qgCgEBYDhFjctg1t/pr2qPMGADrzCgxA5WwYLSn2mOCLyI+7xOe1DY92LD64wuPt7AAzMGjgvY8H1lW6Yn9EtIrOIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=aIoonfIV; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="aIoonfIV"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4364a37a1d7so151311145e9.3
        for <kvmarm@lists.linux.dev>; Mon, 06 Jan 2025 06:25:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1736173527; x=1736778327; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4tKqXX6ltyMKnYMGbEPboArH4aBYnbWTrcwl9D/Fhgk=;
        b=aIoonfIVri9JO5Jmx6JkvOlzFq26PH+LaMSFdNbPvMeJXCrNM9+unC0YDYMF0N3bOM
         ODjSgzcOxFZ8BJz4QVVzlKDHJ0/P4B9ZYHdopirT382ivQASBEVCL1DKnL1wW2D/RIIT
         vEfhPZvl97ZLc1tHtObDCQRXW1fNqyCeAQxlGmG36wg+GoM+tljT2+V3HWZtBz/tHIFo
         5vDZhZaIvZYENF84PWYdO+dvxb+sCH8Ytml0OYuJlQYLHG/f/SBAhpQ5Z++QxX3dG9/Y
         qnuQaks6TRIs+HmzBa3A7B6KsKYf19EvVQvRvEhV3FKDHBOn9p6gQytDPlAxSiVio/kQ
         dqgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736173527; x=1736778327;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4tKqXX6ltyMKnYMGbEPboArH4aBYnbWTrcwl9D/Fhgk=;
        b=Y6C9IJNtKKU51bp+ZmYy5Cc3gh0wSl6N1HJVUYY7Yj2mbmOLS5Be0z3+ysm55Eudcy
         PfYC/9j6dUXTKX81WzOnZP0A6SGct92+/qWbbfM0ctH7dQmmKWFG9PH7ZzHfATa7ugxC
         /5MHgO1Wpxr0M3IfaczvowspSdK0GA9UaX92Sxh24UtZkWKxAym8eKvFc1l7BpDxfXm7
         jGnJC8xjpaU5KUwikVbGbdqlTcj5saSkWDME/M8EXmRSUqWXINBv2y8ozg3/ITtsaXwN
         zYddcZ7bjspDx8TP2eheDO3V3zTK9GLGyRtYGfPq+TZMYeSeib1HDRHoBS55vaY9QSzi
         DgHA==
X-Forwarded-Encrypted: i=1; AJvYcCXZ3LauoHzvlK0GF18ebVlVec9UH6d3YFdH6fH2ssex7IcZ3IT2fYi0xFAg/WY7tv41yfqTePA=@lists.linux.dev
X-Gm-Message-State: AOJu0YzJkUOLdD+UnOQnc+WnGtyrjKtkdQpxS9Eys6T4SSARFLnBiVji
	Ccd/Z1+DPgdaN4Ro9sCjyB14JBjgKsaVAzVW10l2k8bO9aBo3TfpuDjOQJ2g5AY=
X-Gm-Gg: ASbGncscYuTYzwVMsvy+YCAbXk+CQLjSq+gLBpROjnwTF2jOmPTd9WnCHdCH7AjYEGm
	4yJ5+AjxOklP7SmhBGg43BsEsyWi34F3VzIayCPlVisXmyOUl+K6lr+iFkRuDMlRmSrI6u3ImMF
	NDPZGJIlw/Noe6l0r/3MGiW6iykOQByNtkwTz0ezxVzq2oAmZ8nWR8O3aVv/XcFILxuQgznyx1K
	KdggNGiK0Dn388OdqZ+G2hG0hqv9Z5Tm5IqkJBZIg160kdKCyVhiiDD
X-Google-Smtp-Source: AGHT+IHosAoSQ8Y6r5GTgrFTFQzIQO4UbWzlRpVUduo3UPs5moBmKInuymWOSfwWQHVu3cAAbCM3Ag==
X-Received: by 2002:a5d:64ac:0:b0:385:effc:a279 with SMTP id ffacd0b85a97d-38a223ff46cmr42420705f8f.58.1736173526999;
        Mon, 06 Jan 2025 06:25:26 -0800 (PST)
Received: from pop-os.. ([145.224.66.180])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4365d116d8fsm577295045e9.17.2025.01.06.06.25.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jan 2025 06:25:26 -0800 (PST)
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
	"Rob Herring (Arm)" <robh@kernel.org>,
	James Morse <james.morse@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Shiqi Liu <shiqiliu@hust.edu.cn>,
	Raghavendra Rao Ananta <rananta@google.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v9 5/7] KVM: arm64: coresight: Give TRBE enabled state to KVM
Date: Mon,  6 Jan 2025 14:24:40 +0000
Message-Id: <20250106142446.628923-6-james.clark@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250106142446.628923-1-james.clark@linaro.org>
References: <20250106142446.628923-1-james.clark@linaro.org>
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
index 04cd488f6787..8fdc7b6efc79 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -617,6 +617,8 @@ struct kvm_host_data {
 #define KVM_HOST_DATA_FLAG_HAS_TRBE			1
 #define KVM_HOST_DATA_FLAG_HOST_SVE_ENABLED		2
 #define KVM_HOST_DATA_FLAG_HOST_SME_ENABLED		3
+#define KVM_HOST_DATA_FLAG_TRBE_ENABLED			4
+#define KVM_HOST_DATA_FLAG_EL1_TRACING_CONFIGURED	5
 	unsigned long flags;
 
 	struct kvm_cpu_context host_ctxt;
@@ -662,6 +664,9 @@ struct kvm_host_data {
 		u64 mdcr_el2;
 	} host_debug_state;
 
+	/* Guest trace filter value */
+	u64 trfcr_while_in_guest;
+
 	/* Number of programmable event counters (PMCR_EL0.N) for this CPU */
 	unsigned int nr_event_counters;
 
@@ -1389,6 +1394,8 @@ static inline bool kvm_pmu_counter_deferred(struct perf_event_attr *attr)
 void kvm_set_pmu_events(u64 set, struct perf_event_attr *attr);
 void kvm_clr_pmu_events(u64 clr);
 bool kvm_set_pmuserenr(u64 val);
+void kvm_enable_trbe(void);
+void kvm_disable_trbe(void);
 #else
 static inline void kvm_set_pmu_events(u64 set, struct perf_event_attr *attr) {}
 static inline void kvm_clr_pmu_events(u64 clr) {}
@@ -1396,6 +1403,8 @@ static inline bool kvm_set_pmuserenr(u64 val)
 {
 	return false;
 }
+static inline void kvm_enable_trbe(void) {}
+static inline void kvm_disable_trbe(void) {}
 #endif
 
 void kvm_vcpu_load_vhe(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
index d921e7f7bd59..92a24adadb0e 100644
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -81,9 +81,15 @@ void kvm_init_host_debug_data(void)
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
 }
 
 /*
@@ -219,3 +225,23 @@ void kvm_debug_handle_oslar(struct kvm_vcpu *vcpu, u64 val)
 	kvm_arch_vcpu_load(vcpu, smp_processor_id());
 	preempt_enable();
 }
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
+}
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

