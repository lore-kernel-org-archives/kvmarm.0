Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B80C1FA832
	for <kvmarm@lists.linux.dev>; Tue, 12 Nov 2024 10:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407927; cv=none; b=Ox8tOlEc247yQ0p8vbbl2dHHUhdtKZKBha1foucOq1JbBmawD2lIkVGnJKt0mL+HgmL51XsMBR3thojFPl7pbZTo+0QKJGqN1TJwDZhEzF4lC1PQMg8bbbZkCZxT+jK+UJ15b3Maas5BWwjAR9eptgpIb4sIKfVZzYZvnX1uxmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407927; c=relaxed/simple;
	bh=ASxUvQ1pU95JcK+RGcyCQYZuNH+qYYln30lVCV2AqJc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nQPVh0+UF9vacQiIvbVir4B9mMzE5r6PtktZNDG1LYmZ2nvai3mqhpahZGzstBtVl+oohZTGKaiZdVUVmU3zfvepJFjgNm3r8LLEvFi993WywtV57lmQb2m3d61AmNQOVxEdXMU79P0M/d9svhFXSur0grL8ySipP+kd1saKgBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=qCoIvy/6; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="qCoIvy/6"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-431688d5127so43359145e9.0
        for <kvmarm@lists.linux.dev>; Tue, 12 Nov 2024 02:38:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1731407924; x=1732012724; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sA/W0+Ap46dgMFolE2VZt7mXSZE4H0GHR4Td8I21hdI=;
        b=qCoIvy/6hopkv9Y0ioQZi4Gb7+Gp8rYDSFThO+RgM0IvZBwl2wkM6Oy8zRWLuYCvEW
         I9O7ryytFTGE/rQoTSbmuf80mXqNl1/3egzJmiG0sG/AYetRuGH9G1PqlR2VV9Sdz+av
         H/NR/GW81f2M6CdN5Xwbg8F9QETvdn+IBmSrTIPqw1TBzZo9Hxkn1PR7+mfi01X/+nka
         CB9Wt7dsJuHgRi1Agu6IYFS8H7d+UN7YvxYpgwU+JBRPEiO2ZzIDJEv91Q0FvkggE+s4
         wqVex1sY3RydOGjwv7RObwOMQS5wlMeLT6ZZyo1L3ijFbg0husr1H6v3kNs/1zaFnrAS
         CZPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731407924; x=1732012724;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sA/W0+Ap46dgMFolE2VZt7mXSZE4H0GHR4Td8I21hdI=;
        b=vjUi2BeDpQ3rw4NLplIOwwWwDlQPoQv5doHqrVLDjxNTMB1dz0EfvyoAaZ8k1ZPHxd
         QXqQ+S8iaKR/7v/E9xYQtT3IXojXlWmHmyfhEG3bMG8CqLqSeBgtxMrkQIxi69f1QFs/
         G6mq/aXVAkB4VGNmyPSMZn23thnI6Z/IAA6pvppgbGsp5yZ39ZdQBe4F/D8GXf3cPTRZ
         MCg5PQnkDLPaN1ZvfkDXZ6bJrsy3D6OJC4ruJw4piDQ3fmxO2yuku5JkySCc1LDzzR+B
         Wu597/N47fYLbwLWWFKLdHNWa10Hy3x1/Pvx4Eo83knh3wNpTmVh9KJTb9gAAn+gJ9ov
         4H4w==
X-Forwarded-Encrypted: i=1; AJvYcCVuMZaGl8S3QEf1dGKr/I6zHS5DW2pfKV97aU8iDs/0pi+9FgUYJEf/RG1UO3SMigmVZTbT8to=@lists.linux.dev
X-Gm-Message-State: AOJu0YzfhdKSQjRNC5doNGCEv3Os1sMEc/xInz5qiNtnN04JXl9e2CjD
	QRhA9WxugvtGdUTPCB1FkEBA5nJ3ZnSkY6CDhaV90F5iYtGNBo82OdwNpxqtOHA=
X-Google-Smtp-Source: AGHT+IGTCpYEG2uHYkmh8Yj6DuYaWz+qEgTFVaZXTljNTeTGXpI0pqO9pJabhlxETKSZqiOHdB14Pg==
X-Received: by 2002:a05:600c:190f:b0:42f:7e87:3438 with SMTP id 5b1f17b1804b1-432b749ee57mr144547575e9.0.1731407923685;
        Tue, 12 Nov 2024 02:38:43 -0800 (PST)
Received: from pop-os.. ([145.224.90.214])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432bbf436ffsm142270955e9.44.2024.11.12.02.38.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Nov 2024 02:38:43 -0800 (PST)
From: James Clark <james.clark@linaro.org>
To: suzuki.poulose@arm.com,
	oliver.upton@linux.dev,
	coresight@lists.linaro.org,
	kvmarm@lists.linux.dev
Cc: James Clark <james.clark@linaro.org>,
	Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mike Leach <mike.leach@linaro.org>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	James Morse <james.morse@arm.com>,
	Shiqi Liu <shiqiliu@hust.edu.cn>,
	Fuad Tabba <tabba@google.com>,
	Mark Brown <broonie@kernel.org>,
	Raghavendra Rao Ananta <rananta@google.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v7 09/12] KVM: arm64: coresight: Give TRBE enabled state to KVM
Date: Tue, 12 Nov 2024 10:37:08 +0000
Message-Id: <20241112103717.589952-10-james.clark@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241112103717.589952-1-james.clark@linaro.org>
References: <20241112103717.589952-1-james.clark@linaro.org>
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

Signed-off-by: James Clark <james.clark@linaro.org>
---
 arch/arm64/include/asm/kvm_host.h            |  4 ++++
 arch/arm64/kvm/debug.c                       | 16 ++++++++++++++++
 drivers/hwtracing/coresight/coresight-trbe.c | 15 ++++++++++++---
 3 files changed, 32 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 7f1e32d40f0c..b1dccac996a6 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -945,6 +945,8 @@ struct kvm_vcpu_arch {
 #define HOST_FEAT_HAS_TRF	__kvm_single_flag(feats, BIT(2))
 /* PMBLIMITR_EL1_E is set (SPE profiling buffer enabled) */
 #define HOST_STATE_SPE_EN	__kvm_single_flag(state, BIT(0))
+/* TRBLIMITR_EL1_E is set (TRBE trace buffer enabled) */
+#define HOST_STATE_TRBE_EN	__kvm_single_flag(state, BIT(1))
 
 /* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
 #define vcpu_sve_pffr(vcpu) (kern_hyp_va((vcpu)->arch.sve_state) +	\
@@ -1387,6 +1389,7 @@ void kvm_set_pmu_events(u64 set, struct perf_event_attr *attr);
 void kvm_clr_pmu_events(u64 clr);
 bool kvm_set_pmuserenr(u64 val);
 void kvm_set_pmblimitr(u64 pmblimitr);
+void kvm_set_trblimitr(u64 trblimitr);
 #else
 static inline void kvm_set_pmu_events(u64 set, struct perf_event_attr *attr) {}
 static inline void kvm_clr_pmu_events(u64 clr) {}
@@ -1395,6 +1398,7 @@ static inline bool kvm_set_pmuserenr(u64 val)
 	return false;
 }
 static inline void kvm_set_pmblimitr(u64 pmblimitr) {}
+static inline void kvm_set_trblimitr(u64 trblimitr) {}
 #endif
 
 void kvm_vcpu_load_vhe(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
index ed3b4d057c52..e99df2c3f62a 100644
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -364,3 +364,19 @@ void kvm_set_pmblimitr(u64 pmblimitr)
 		host_data_clear_flag(HOST_STATE_SPE_EN);
 }
 EXPORT_SYMBOL_GPL(kvm_set_pmblimitr);
+
+void kvm_set_trblimitr(u64 trblimitr)
+{
+	/* Only read in nVHE */
+	if (has_vhe())
+		return;
+
+	if (kvm_arm_skip_trace_state())
+		return;
+
+	if (trblimitr & TRBLIMITR_EL1_E)
+		host_data_set_flag(HOST_STATE_TRBE_EN);
+	else
+		host_data_clear_flag(HOST_STATE_TRBE_EN);
+}
+EXPORT_SYMBOL_GPL(kvm_set_trblimitr);
diff --git a/drivers/hwtracing/coresight/coresight-trbe.c b/drivers/hwtracing/coresight/coresight-trbe.c
index 96a32b213669..ff281b445682 100644
--- a/drivers/hwtracing/coresight/coresight-trbe.c
+++ b/drivers/hwtracing/coresight/coresight-trbe.c
@@ -18,6 +18,7 @@
 #include <asm/barrier.h>
 #include <asm/cpufeature.h>
 #include <linux/vmalloc.h>
+#include <linux/kvm_host.h>
 
 #include "coresight-self-hosted-trace.h"
 #include "coresight-trbe.h"
@@ -213,6 +214,12 @@ static inline void trbe_drain_buffer(void)
 	dsb(nsh);
 }
 
+static void trbe_write_trblimitr(u64 val)
+{
+	write_sysreg_s(val, SYS_TRBLIMITR_EL1);
+	kvm_set_trblimitr(val);
+}
+
 static inline void set_trbe_enabled(struct trbe_cpudata *cpudata, u64 trblimitr)
 {
 	/*
@@ -220,7 +227,7 @@ static inline void set_trbe_enabled(struct trbe_cpudata *cpudata, u64 trblimitr)
 	 * might be required for fetching the buffer limits.
 	 */
 	trblimitr |= TRBLIMITR_EL1_E;
-	write_sysreg_s(trblimitr, SYS_TRBLIMITR_EL1);
+	trbe_write_trblimitr(trblimitr);
 
 	/* Synchronize the TRBE enable event */
 	isb();
@@ -238,7 +245,7 @@ static inline void set_trbe_disabled(struct trbe_cpudata *cpudata)
 	 * might be required for fetching the buffer limits.
 	 */
 	trblimitr &= ~TRBLIMITR_EL1_E;
-	write_sysreg_s(trblimitr, SYS_TRBLIMITR_EL1);
+	trbe_write_trblimitr(trblimitr);
 
 	if (trbe_needs_drain_after_disable(cpudata))
 		trbe_drain_buffer();
@@ -253,8 +260,10 @@ static void trbe_drain_and_disable_local(struct trbe_cpudata *cpudata)
 
 static void trbe_reset_local(struct trbe_cpudata *cpudata)
 {
+	preempt_disable();
 	trbe_drain_and_disable_local(cpudata);
-	write_sysreg_s(0, SYS_TRBLIMITR_EL1);
+	trbe_write_trblimitr(0);
+	preempt_enable();
 	write_sysreg_s(0, SYS_TRBPTR_EL1);
 	write_sysreg_s(0, SYS_TRBBASER_EL1);
 	write_sysreg_s(0, SYS_TRBSR_EL1);
-- 
2.34.1

