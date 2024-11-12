Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE41D213EEE
	for <kvmarm@lists.linux.dev>; Tue, 12 Nov 2024 10:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407945; cv=none; b=a4trl6VtCwEhnVl8amkDNyvvdump7J6QcIHjxgF/tZsh3F9dSUeNd/hIT6Nf1bA+CIqh1aV0w6d3z+DO+tPadqB5Q0jvOVl/oWtBHnaTa6mESqq001Hpi9+OL7cQnPEwoIAnv+cyDJoCgmot98yJ9lgYw1rgh6QIVJZRfWDQPFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407945; c=relaxed/simple;
	bh=p+rbt1X5lUuVjWAL59a43sfuObjYuDVvNvvFXOlyuiw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LrLUwHbdii7WGWU4iRmS//0sKXe8b9xopgff3LTTY4nQ1AlzydkR5pj8pwBhicJrjFUG0cfs7vOTNb9JbaDDoxajnuf7i0UCEZIthhO4Gto2iybJz4bROWJI1G9xyuRg5zwVUFZNftqqhz47MpuBRz9k7jxCZTNudBS+k+TRXtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=P+cKbq7/; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="P+cKbq7/"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-37d43a9bc03so3784516f8f.2
        for <kvmarm@lists.linux.dev>; Tue, 12 Nov 2024 02:39:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1731407942; x=1732012742; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hTXqo//8eCQsBk4kbAKUkYayo6ux0h+eu3YzsPig2os=;
        b=P+cKbq7/Bu+v/yeS7V9cajoIjn+o+s0PUQdxy4ncYExVlSp6NFcwAQbm78lZ1gdsHg
         0dg6ztvFPmB8uvtAg4tB3q+7NlGDL4u/ezbiiRSsMr4crMIziGO5sZxFUZfz9eGYinmN
         NQFwoX71r9SVGWqugvjTI4nfyUqlnIiiS+C5KF2Y4nrG79UAcPnN/AVTOiDLXgSp76as
         IjdJ2fZVJo15hC8cjzAjlNMdW9GlI+qZtcSBmq3dIveSF7ApbsqiqzLQUqKYHyee5WSc
         OEjEizAELcSOtTXJkMGd5cQU74WZYSARC5UnsdBug9qzC1v9M4hrR4Jp6vf3Uca17Bqz
         mFzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731407942; x=1732012742;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hTXqo//8eCQsBk4kbAKUkYayo6ux0h+eu3YzsPig2os=;
        b=cxyH2MgaFc93bvoeJJhXQkxIXuY3DRjUYjvGuUA1hCn/olz6oE9WAD38Pg2jyW0UJ6
         AcZOhIKT+d6+sbztxiqM3o4kXVxpnDnFr7ujSq+jDmi3NW7/5aiI3bZmIClJx9iUE6oR
         9voDM5J/1Lim12I5q09iuHDeT98wcrzcRKF0e+euY0MoPvv8R0w+GbohHHXWLq3uDqxA
         LSjcxgdMHFOZSMeYqUF4WdKmf/eMctDSTyPkh1A1Qh0iQ9+9OhUk0SCfd/l7DZZHeAXk
         6vv9jH/ab+SehSuuxz+MvgDUdkgz9iCDPs4ty2SmdJfNlmMLdWHNXtDRFyGBbZuo6IhY
         vKPA==
X-Forwarded-Encrypted: i=1; AJvYcCVTZpfYfHo6lPn558fYpHKGwVgfLwde/C962UqeN/p55U7z5D+SGk7clVD+U0KU5fXLvP/Kfe8=@lists.linux.dev
X-Gm-Message-State: AOJu0YxH7oSZMRw/tuvf7EcvzaQQenvOpdWNtfSaY0Th3JZGgmbgluZV
	DiQmf2l+ysJOrL4Cb19ozrVOVN1SCS/a9MxurRpMf5OV7lisUAtKLKtzPyDBNac=
X-Google-Smtp-Source: AGHT+IFyMdF9zAJjuyhAjQDTA00d8BetxuafJaMqAy1S8MkOFS5uQVVLGbU/acSR5z7cyBVpLtP1iA==
X-Received: by 2002:a5d:5f42:0:b0:37d:4436:4505 with SMTP id ffacd0b85a97d-381f186ccdemr13405089f8f.32.1731407942122;
        Tue, 12 Nov 2024 02:39:02 -0800 (PST)
Received: from pop-os.. ([145.224.90.214])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432bbf436ffsm142270955e9.44.2024.11.12.02.39.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Nov 2024 02:39:01 -0800 (PST)
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
	"Rob Herring (Arm)" <robh@kernel.org>,
	Shiqi Liu <shiqiliu@hust.edu.cn>,
	Fuad Tabba <tabba@google.com>,
	James Morse <james.morse@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Raghavendra Rao Ananta <rananta@google.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v7 11/12] KVM: arm64: Swap TRFCR on guest switch
Date: Tue, 12 Nov 2024 10:37:10 +0000
Message-Id: <20241112103717.589952-12-james.clark@linaro.org>
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

This implements exclude/include guest rules of the active tracing
session. Only do it if a different value is required for the guest,
otherwise the filters remain untouched.

In VHE we can just directly write the value.

Signed-off-by: James Clark <james.clark@linaro.org>
---
 arch/arm64/include/asm/kvm_host.h  |  4 ++++
 arch/arm64/kvm/debug.c             | 16 ++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/debug-sr.c | 17 +++++++++++++++--
 3 files changed, 35 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index a8846689512b..9109d10c656e 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -949,6 +949,8 @@ struct kvm_vcpu_arch {
 #define HOST_STATE_TRBE_EN	__kvm_single_flag(state, BIT(1))
 /* Hyp modified TRFCR */
 #define HOST_STATE_RESTORE_TRFCR __kvm_single_flag(state, BIT(2))
+/* Host wants a different trace filters for the guest */
+#define HOST_STATE_SWAP_TRFCR	__kvm_single_flag(state, BIT(3))
 
 /* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
 #define vcpu_sve_pffr(vcpu) (kern_hyp_va((vcpu)->arch.sve_state) +	\
@@ -1392,6 +1394,7 @@ void kvm_clr_pmu_events(u64 clr);
 bool kvm_set_pmuserenr(u64 val);
 void kvm_set_pmblimitr(u64 pmblimitr);
 void kvm_set_trblimitr(u64 trblimitr);
+void kvm_set_trfcr(u64 host_trfcr, u64 guest_trfcr);
 #else
 static inline void kvm_set_pmu_events(u64 set, struct perf_event_attr *attr) {}
 static inline void kvm_clr_pmu_events(u64 clr) {}
@@ -1401,6 +1404,7 @@ static inline bool kvm_set_pmuserenr(u64 val)
 }
 static inline void kvm_set_pmblimitr(u64 pmblimitr) {}
 static inline void kvm_set_trblimitr(u64 trblimitr) {}
+static inline void kvm_set_trfcr(u64 host_trfcr, u64 guest_trfcr) {}
 #endif
 
 void kvm_vcpu_load_vhe(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
index e99df2c3f62a..9acec1b67d5f 100644
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -380,3 +380,19 @@ void kvm_set_trblimitr(u64 trblimitr)
 		host_data_clear_flag(HOST_STATE_TRBE_EN);
 }
 EXPORT_SYMBOL_GPL(kvm_set_trblimitr);
+
+void kvm_set_trfcr(u64 host_trfcr, u64 guest_trfcr)
+{
+	if (kvm_arm_skip_trace_state())
+		return;
+
+	if (has_vhe())
+		write_sysreg_s(guest_trfcr, SYS_TRFCR_EL12);
+	else
+		if (host_trfcr != guest_trfcr) {
+			*host_data_ptr(host_debug_state.trfcr_el1) = guest_trfcr;
+			host_data_set_flag(HOST_STATE_SWAP_TRFCR);
+		} else
+			host_data_clear_flag(HOST_STATE_SWAP_TRFCR);
+}
+EXPORT_SYMBOL_GPL(kvm_set_trfcr);
diff --git a/arch/arm64/kvm/hyp/nvhe/debug-sr.c b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
index 17c23e52f5f4..47602c4d160a 100644
--- a/arch/arm64/kvm/hyp/nvhe/debug-sr.c
+++ b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
@@ -100,6 +100,15 @@ static void __debug_save_trace(void)
 	host_data_set_flag(HOST_STATE_RESTORE_TRFCR);
 }
 
+static void __debug_swap_trace(void)
+{
+	u64 trfcr = read_sysreg_el1(SYS_TRFCR);
+
+	write_sysreg_el1(*host_data_ptr(host_debug_state.trfcr_el1), SYS_TRFCR);
+	*host_data_ptr(host_debug_state.trfcr_el1) = trfcr;
+	host_data_set_flag(HOST_STATE_RESTORE_TRFCR);
+}
+
 static void __debug_restore_trace(void)
 {
 	u64 trfcr_el1;
@@ -124,10 +133,14 @@ void __debug_save_host_buffers_nvhe(void)
 	if (!host_data_get_flag(HOST_FEAT_HAS_TRF))
 		return;
 
-	/* Disable and flush Self-Hosted Trace generation */
+	/*
+	 * Disable and flush Self-Hosted Trace generation for pKVM and TRBE,
+	 * or swap if host requires different guest filters.
+	 */
 	if (__debug_should_save_trace())
 		__debug_save_trace();
-
+	else if (host_data_get_flag(HOST_STATE_SWAP_TRFCR))
+		__debug_swap_trace();
 }
 
 void __debug_switch_to_guest(struct kvm_vcpu *vcpu)
-- 
2.34.1

