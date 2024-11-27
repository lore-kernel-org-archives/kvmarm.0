Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D5F2197A77
	for <kvmarm@lists.linux.dev>; Wed, 27 Nov 2024 10:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732701750; cv=none; b=aEMo2wtapvWB9oMvifvdQ1MR4zLaRZ8KwxjCMdatloMIRv3r3lIkl7TNsEEEH6oqVGTdvSqqWFlWpqRtQbnY7bHN5vYnOZ2BTsFw516cHh0MSl31jRoVMjUiazJhaY6f+3WVdTMwmiWA30JqSDMDI8PjBsb/W8tDY2iD9k1MUyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732701750; c=relaxed/simple;
	bh=vc0awtuYj4gpm1ylT6GyEHwvqg9nnyRyhpDtEgtPFoM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=akw1iEzGVGtDlGMINXQCEfInQrS0OmjonmJ3Rb3yAFwSqOy+QihDQoxjt1ghPHu0T3d7y8UGVCKVbBtp/WtGXySbebdLFEhTvy2e6wZJuUx5aV7DFgTyUMQsPzWv6O18OK+4IrbV3Tm0HzzJSVmoBu2wA609LiO5yOUObzAZlrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=MT1et4fw; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="MT1et4fw"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-aa539d2b4b2so118001866b.1
        for <kvmarm@lists.linux.dev>; Wed, 27 Nov 2024 02:02:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1732701745; x=1733306545; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5p6Wgx2tYZ5aTq5BxdyoLsG0jsORpAAv/YzU7vtNK5k=;
        b=MT1et4fw/g5kL74NKE67XrJoX8OCA4eFURhldaStNPwM7V+TGeo9k/yNYRWze3KW8W
         ThhhnPudmKxw33ib2pfezZSbo6l3gtJk3hAGma3EXBfgPZOiXZG2wiQoiZHXRNhcyVSb
         ISXU3CvBkV+RpaoEsZhbUbSHNOojIukT3QbS3On2dLLphMe9petOf3Q09VD8zjl+GqNV
         CAi7PaNYrbtScojFs5TzuzyKm2c/TKCbi2f1hrstaoZkW1vuvfQPjJMw14jf+xNXIFde
         aBHwzoBDntj3ZgnPtwXOlZEabscH0Bz6sUNemN3lxK9niPndsR7wmICKP4LIUtoN9wUx
         uTWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732701745; x=1733306545;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5p6Wgx2tYZ5aTq5BxdyoLsG0jsORpAAv/YzU7vtNK5k=;
        b=uFdrRDyYJgrqEqa6pUXYzYnF4t/k4ZZqrjBc4/JibHbJCzcK47PvmPR8utdn3neIa/
         xuS7NnpNMM0FSVEcx/aEAhpdF1Cq2JqZQbHTE6lsCb2jz9Q/EqNFwfJqomyD9zGIOIXm
         JkaJ7LMVKiZTVX/GVqNP4QShVGgrVQiYyZ3gbG7LvuZjKvxrJxhdDVaNseKTZvRsrt8g
         xxJHMttYYoIulTaOWaks7+eNGUJ10aDjyQahJzbJpMKwAKQWsTJSSMwh44Vj6g8W3XFg
         OZr9fS+uDD8N0jtF7e9aysLCRfUdt+xgLq/zfXndtWd5PoGVAKJRlqWoZAOObrsfMxtO
         geFg==
X-Forwarded-Encrypted: i=1; AJvYcCUER8M1xfZUcpntMXfY8194RZG02xnrCNpix+L+xsIhRSzVxJHwHIfPDDYmZaRmIO7uSUn37pU=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy8NhYhOGorur4iedBwVgZdR0d9SXM0h/KYUAjamIFsFNuoHdC/
	9Sa3Ye7znO5yP1mVYnqUfkjmT6mzNw29DriRWaa/coBbhh6ayykoOehw1RR9i2g=
X-Gm-Gg: ASbGnctYDIhlB68ooQoYc4CCIq4B1z7ws79ZkdqK4pgSSYhXaQdXsLKeaU8dMaUQD6b
	GvKHzR3jcL+TUPcZ6TVaLNmxuN+XFeE79iUMms8YkLbHXb05aRrM4Hr6RJst/W+rZnCfYzytERO
	hk4xO5IsCQ9y6IKxmd37tpOgmmJHo7D1oXrx44x8mtS2DG8AMxu8rbFgvnk7EzoAgHOnDCk0kxg
	osl64XwaeEIz9jG8+h8GATcvVyBIpWdT5iFSKyThPOr5Y5JpQ==
X-Google-Smtp-Source: AGHT+IHt0xwmSWhoNnbZ6H/EShpkPoxPSy9FHxQ79ly5gIzLBxBvqiqHzT7AVqzo3vG5vTM4UDNh0A==
X-Received: by 2002:a17:907:9409:b0:aa5:2e71:3727 with SMTP id a640c23a62f3a-aa564970687mr642246566b.21.1732701745268;
        Wed, 27 Nov 2024 02:02:25 -0800 (PST)
Received: from pop-os.. ([145.224.90.200])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa547ffb152sm421887466b.62.2024.11.27.02.02.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Nov 2024 02:02:24 -0800 (PST)
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
	Mark Brown <broonie@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Shiqi Liu <shiqiliu@hust.edu.cn>,
	Fuad Tabba <tabba@google.com>,
	James Morse <james.morse@arm.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v8 6/8] KVM: arm64: coresight: Give TRBE enabled state to KVM
Date: Wed, 27 Nov 2024 10:01:23 +0000
Message-Id: <20241127100130.1162639-7-james.clark@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241127100130.1162639-1-james.clark@linaro.org>
References: <20241127100130.1162639-1-james.clark@linaro.org>
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

This is always called with preemption disabled except for probe/hotplug
which gets wrapped with preempt_disable().

Protected mode disables trace regardless of TRBE (because
guest_trfcr_el1 is always 0), which was not previously done. HAS_TRBE
becomes redundant, but HAS_TRF is now required for this.

Signed-off-by: James Clark <james.clark@linaro.org>
---
 arch/arm64/include/asm/kvm_host.h            | 10 +++-
 arch/arm64/kvm/debug.c                       | 25 ++++++++--
 arch/arm64/kvm/hyp/nvhe/debug-sr.c           | 51 +++++++++++---------
 drivers/hwtracing/coresight/coresight-trbe.c |  5 ++
 4 files changed, 65 insertions(+), 26 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 7e3478386351..ba251caa593b 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -611,7 +611,8 @@ struct cpu_sve_state {
  */
 struct kvm_host_data {
 #define KVM_HOST_DATA_FLAG_HAS_SPE	0
-#define KVM_HOST_DATA_FLAG_HAS_TRBE	1
+#define KVM_HOST_DATA_FLAG_HAS_TRF	1
+#define KVM_HOST_DATA_FLAG_TRBE_ENABLED	2
 	unsigned long flags;
 
 	struct kvm_cpu_context host_ctxt;
@@ -657,6 +658,9 @@ struct kvm_host_data {
 		u64 mdcr_el2;
 	} host_debug_state;
 
+	/* Guest trace filter value */
+	u64 guest_trfcr_el1;
+
 	/* Number of programmable event counters (PMCR_EL0.N) for this CPU */
 	unsigned int nr_event_counters;
 };
@@ -1381,6 +1385,8 @@ static inline bool kvm_pmu_counter_deferred(struct perf_event_attr *attr)
 void kvm_set_pmu_events(u64 set, struct perf_event_attr *attr);
 void kvm_clr_pmu_events(u64 clr);
 bool kvm_set_pmuserenr(u64 val);
+void kvm_enable_trbe(void);
+void kvm_disable_trbe(void);
 #else
 static inline void kvm_set_pmu_events(u64 set, struct perf_event_attr *attr) {}
 static inline void kvm_clr_pmu_events(u64 clr) {}
@@ -1388,6 +1394,8 @@ static inline bool kvm_set_pmuserenr(u64 val)
 {
 	return false;
 }
+static inline void kvm_enable_trbe(void) {}
+static inline void kvm_disable_trbe(void) {}
 #endif
 
 void kvm_vcpu_load_vhe(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
index dd9e139dfd13..0c340ae7b5d1 100644
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -314,7 +314,26 @@ void kvm_init_host_debug_data(void)
 	    !(read_sysreg_s(SYS_PMBIDR_EL1) & PMBIDR_EL1_P))
 		host_data_set_flag(HAS_SPE);
 
-	if (cpuid_feature_extract_unsigned_field(dfr0, ID_AA64DFR0_EL1_TraceBuffer_SHIFT) &&
-	    !(read_sysreg_s(SYS_TRBIDR_EL1) & TRBIDR_EL1_P))
-		host_data_set_flag(HAS_TRBE);
+	if (cpuid_feature_extract_unsigned_field(dfr0, ID_AA64DFR0_EL1_TraceFilt_SHIFT))
+		host_data_set_flag(HAS_TRF);
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
index 858bb38e273f..9479bee41801 100644
--- a/arch/arm64/kvm/hyp/nvhe/debug-sr.c
+++ b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
@@ -51,32 +51,39 @@ static void __debug_restore_spe(u64 pmscr_el1)
 	write_sysreg_el1(pmscr_el1, SYS_PMSCR);
 }
 
-static void __debug_save_trace(u64 *trfcr_el1)
+static void __trace_do_switch(u64 *saved_trfcr, u64 new_trfcr)
 {
-	*trfcr_el1 = 0;
+	*saved_trfcr = read_sysreg_el1(SYS_TRFCR);
+	write_sysreg_el1(new_trfcr, SYS_TRFCR);
 
-	/* Check if the TRBE is enabled */
-	if (!(read_sysreg_s(SYS_TRBLIMITR_EL1) & TRBLIMITR_EL1_E))
+	/* No need to drain if going to an enabled state or from disabled state */
+	if (new_trfcr || !*saved_trfcr)
 		return;
-	/*
-	 * Prohibit trace generation while we are in guest.
-	 * Since access to TRFCR_EL1 is trapped, the guest can't
-	 * modify the filtering set by the host.
-	 */
-	*trfcr_el1 = read_sysreg_el1(SYS_TRFCR);
-	write_sysreg_el1(0, SYS_TRFCR);
+
 	isb();
-	/* Drain the trace buffer to memory */
 	tsb_csync();
 }
 
-static void __debug_restore_trace(u64 trfcr_el1)
+static bool __trace_needs_switch(void)
 {
-	if (!trfcr_el1)
-		return;
+	return host_data_test_flag(TRBE_ENABLED) ||
+	       (is_protected_kvm_enabled() && host_data_test_flag(HAS_TRF));
+}
 
-	/* Restore trace filter controls */
-	write_sysreg_el1(trfcr_el1, SYS_TRFCR);
+static void __trace_switch_to_guest(void)
+{
+	/* Unsupported with TRBE so disable */
+	if (host_data_test_flag(TRBE_ENABLED))
+		*host_data_ptr(guest_trfcr_el1) = 0;
+
+	__trace_do_switch(host_data_ptr(host_debug_state.trfcr_el1),
+			  *host_data_ptr(guest_trfcr_el1));
+}
+
+static void __trace_switch_to_host(void)
+{
+	__trace_do_switch(host_data_ptr(guest_trfcr_el1),
+			  *host_data_ptr(host_debug_state.trfcr_el1));
 }
 
 void __debug_save_host_buffers_nvhe(struct kvm_vcpu *vcpu)
@@ -84,9 +91,9 @@ void __debug_save_host_buffers_nvhe(struct kvm_vcpu *vcpu)
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
@@ -98,8 +105,8 @@ void __debug_restore_host_buffers_nvhe(struct kvm_vcpu *vcpu)
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
index 96a32b213669..9c0f8c43e6fe 100644
--- a/drivers/hwtracing/coresight/coresight-trbe.c
+++ b/drivers/hwtracing/coresight/coresight-trbe.c
@@ -18,6 +18,7 @@
 #include <asm/barrier.h>
 #include <asm/cpufeature.h>
 #include <linux/vmalloc.h>
+#include <linux/kvm_host.h>
 
 #include "coresight-self-hosted-trace.h"
 #include "coresight-trbe.h"
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
@@ -253,8 +256,10 @@ static void trbe_drain_and_disable_local(struct trbe_cpudata *cpudata)
 
 static void trbe_reset_local(struct trbe_cpudata *cpudata)
 {
+	preempt_disable();
 	trbe_drain_and_disable_local(cpudata);
 	write_sysreg_s(0, SYS_TRBLIMITR_EL1);
+	preempt_enable();
 	write_sysreg_s(0, SYS_TRBPTR_EL1);
 	write_sysreg_s(0, SYS_TRBBASER_EL1);
 	write_sysreg_s(0, SYS_TRBSR_EL1);
-- 
2.34.1

