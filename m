Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5883E198840
	for <kvmarm@lists.linux.dev>; Wed, 27 Nov 2024 10:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732701756; cv=none; b=sLDJpbmyhakXQvW4crmnoNNrjOPo7y+8MFsz4XOgYVH1bZSh3cMg8phv633kpj64QozFTxRNKTnxxdGf+DBz05InNE39XKR81iSM40dha1bgTH08O+lmQA+Pvhmz5UN+GVNt6Klbc5cGez97VLQbAMqv43WSwsD0FM/xwMYaIYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732701756; c=relaxed/simple;
	bh=OBclv0kx0D1prxi+rdV81bxT1otCeQV4dy6Asymp6U8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rvJMWpVIDTsDdN4xG5L5n2MQhl250s/Btz9xB7e1yturld6zjUAGMGpfYtN+2YaC0M0FyMO/Qn5jpGeqx1fSiJfKKSSQ55ba5Qxwf/K6ksNDvB8XTzSPcDJrkRA6KVUzrDSKdIrc3C3uuSqPP0WUJ2LQKyX6FhxFZATo1UVH93w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=jSlDsc/N; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="jSlDsc/N"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-aa539d2b4b2so118029666b.1
        for <kvmarm@lists.linux.dev>; Wed, 27 Nov 2024 02:02:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1732701752; x=1733306552; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AQO33bk7JaoB2YQnA4dTR0HBdRzks1jGUji/o+mr5GU=;
        b=jSlDsc/NVDOM3EV7cXGS2vu9Jw/7m/rs1MdX6I0zxgfI3KxgKNHAIT0z6BLzApUbIl
         3fU8r41zMEss8HRw4Lhge09Wavbd3sHsHS2Mjx4PP6r6WlEZ9err6f+sJ+iPRi0zm6S1
         i0lN+vr8g/4gjdQ6Vui/o49jnAFk/1EOIhjG7fxB6Oo0eIgakE/ayWBu8EnaYuP/rRYz
         VoCZ/mzm98D3aa+08+hQEUQy4cyTVp5rZcibTCfiVRDcF22LDAJxNFvN0bxmgvFFAXjz
         YLgWnwHMMk58SSbFLv0H89IwxAnNDAgwrQgIneR1LnavxOnmcM/O68/VxIdNymWKGpJa
         iRaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732701752; x=1733306552;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AQO33bk7JaoB2YQnA4dTR0HBdRzks1jGUji/o+mr5GU=;
        b=Lna98GYArBVxUKDADsAp1Gg+ayLhyqGMBcZap09IMzXgi8AEMwGfd3GvdwBmMiANEi
         kPicTAZfRePqYcfSUU4NaM36bBrK1Sj1FymOEun2H9BDJjJxTHh4ktaVWb+V3+hfsxw3
         V6lmxMoY75fZpn1iEExW0E4yON100qVf5owBmljVmwBT8PCtQbODkKKiDyd20Jnpw9b9
         ymWaJOd34xU3eiCnXF/aJQndjBFpyp55DKEmUmA0fcNZv8DLTnQvE0xnDs7bmUICBQBI
         1ZfbSc00KpOuTmyitTiqTBwpaKeYlIYg1/1sWEETCYPffvYvdE51WSjxOihS9qBWFW6r
         2+4Q==
X-Forwarded-Encrypted: i=1; AJvYcCUNRggkLGUFyI9M7kJK6roah+pk++3O2/fLepKGc4wga6ik32n5WLw+FSZ1kHAL4XtJEjrtRoc=@lists.linux.dev
X-Gm-Message-State: AOJu0YwWXw9J7SNK9ZXC7UbX+Z3OXZReJkwnr1Ad+4GB4WFK3W9vUEBN
	TiST5we0gdjeK+bvhd5h9AJ6hkRwgO6vXVCmyLs5iTOow5A+uvyUfiASv7QZguQ=
X-Gm-Gg: ASbGncsae4uxBggtFY7tfSG7oOrErP+OQatz3L63EFxQdKqcEF4lFzMvmgwn3ouX6MJ
	9cad4ITBVQ/GfTTHIykVI8vOSaLhcbYU/W7LhjyH9e6cWSm6p0ACdQyBODyU+XvIqRHE2QNQ80Y
	aTldk+E/LF/Bs+vC8N/DGMC2wSOmunX+dEBvjj+NW9HO4b4A5n8i9J09zZMZAaGGVMojcq/CHVf
	RL4V/uvUV09R+uaYP4VI8HHeewv/2CZKSRJNOuRlSv52M65yQ==
X-Google-Smtp-Source: AGHT+IFOprwWyU0EZiK3CjnWXpdoY6pqFDChObj/uIZutCL8jO6QK+gWZSMBFJTM121i68Qn0kESKQ==
X-Received: by 2002:a17:907:775a:b0:aa5:2a63:e93 with SMTP id a640c23a62f3a-aa57fac4512mr248698066b.12.1732701752519;
        Wed, 27 Nov 2024 02:02:32 -0800 (PST)
Received: from pop-os.. ([145.224.90.200])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa547ffb152sm421887466b.62.2024.11.27.02.02.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Nov 2024 02:02:32 -0800 (PST)
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
	James Morse <james.morse@arm.com>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Shiqi Liu <shiqiliu@hust.edu.cn>,
	Fuad Tabba <tabba@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v8 7/8] KVM: arm64: Support trace filtering for guests
Date: Wed, 27 Nov 2024 10:01:24 +0000
Message-Id: <20241127100130.1162639-8-james.clark@linaro.org>
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

For nVHE, switch the filter value in and out if the Coresight driver
asks for it. This will support filters for guests when sinks other than
TRBE are used.

For VHE, just write the filter directly to TRFCR_EL1 where trace can be
used even with TRBE sinks.

Signed-off-by: James Clark <james.clark@linaro.org>
---
 arch/arm64/include/asm/kvm_host.h  |  5 +++++
 arch/arm64/kvm/debug.c             | 28 ++++++++++++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/debug-sr.c |  1 +
 3 files changed, 34 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index ba251caa593b..cce07887551b 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -613,6 +613,7 @@ struct kvm_host_data {
 #define KVM_HOST_DATA_FLAG_HAS_SPE	0
 #define KVM_HOST_DATA_FLAG_HAS_TRF	1
 #define KVM_HOST_DATA_FLAG_TRBE_ENABLED	2
+#define KVM_HOST_DATA_FLAG_GUEST_FILTER	3
 	unsigned long flags;
 
 	struct kvm_cpu_context host_ctxt;
@@ -1387,6 +1388,8 @@ void kvm_clr_pmu_events(u64 clr);
 bool kvm_set_pmuserenr(u64 val);
 void kvm_enable_trbe(void);
 void kvm_disable_trbe(void);
+void kvm_set_trfcr(u64 guest_trfcr);
+void kvm_clear_trfcr(void);
 #else
 static inline void kvm_set_pmu_events(u64 set, struct perf_event_attr *attr) {}
 static inline void kvm_clr_pmu_events(u64 clr) {}
@@ -1396,6 +1399,8 @@ static inline bool kvm_set_pmuserenr(u64 val)
 }
 static inline void kvm_enable_trbe(void) {}
 static inline void kvm_disable_trbe(void) {}
+static inline void kvm_set_trfcr(u64 guest_trfcr) {}
+static inline void kvm_clear_trfcr(void) {}
 #endif
 
 void kvm_vcpu_load_vhe(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
index 0c340ae7b5d1..9266f2776991 100644
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -337,3 +337,31 @@ void kvm_disable_trbe(void)
 	host_data_clear_flag(TRBE_ENABLED);
 }
 EXPORT_SYMBOL_GPL(kvm_disable_trbe);
+
+void kvm_set_trfcr(u64 guest_trfcr)
+{
+	if (is_protected_kvm_enabled() || WARN_ON_ONCE(preemptible()))
+		return;
+
+	if (has_vhe())
+		write_sysreg_s(guest_trfcr, SYS_TRFCR_EL12);
+	else {
+		*host_data_ptr(guest_trfcr_el1) = guest_trfcr;
+		host_data_set_flag(GUEST_FILTER);
+	}
+}
+EXPORT_SYMBOL_GPL(kvm_set_trfcr);
+
+void kvm_clear_trfcr(void)
+{
+	if (is_protected_kvm_enabled() || WARN_ON_ONCE(preemptible()))
+		return;
+
+	if (has_vhe())
+		write_sysreg_s(0, SYS_TRFCR_EL12);
+	else {
+		*host_data_ptr(guest_trfcr_el1) = 0;
+		host_data_clear_flag(GUEST_FILTER);
+	}
+}
+EXPORT_SYMBOL_GPL(kvm_clear_trfcr);
diff --git a/arch/arm64/kvm/hyp/nvhe/debug-sr.c b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
index 9479bee41801..7edee7ace433 100644
--- a/arch/arm64/kvm/hyp/nvhe/debug-sr.c
+++ b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
@@ -67,6 +67,7 @@ static void __trace_do_switch(u64 *saved_trfcr, u64 new_trfcr)
 static bool __trace_needs_switch(void)
 {
 	return host_data_test_flag(TRBE_ENABLED) ||
+	       host_data_test_flag(GUEST_FILTER) ||
 	       (is_protected_kvm_enabled() && host_data_test_flag(HAS_TRF));
 }
 
-- 
2.34.1

