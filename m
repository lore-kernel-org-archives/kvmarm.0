Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2467E1EBA08
	for <kvmarm@lists.linux.dev>; Tue,  7 Jan 2025 11:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736249724; cv=none; b=own9cP2WvwIAB9NvISUMoKaxtRSYY2WZ1rQbZ6mUEDDPExgv6iLr39DWDO7/iRNxT2gHIuEacwOy7G6itc6fi7MUuwyCsk6YWunNyonLWz5/kyJDHLY7oDNKzjgCDxrFJwzwulOHQPnHnSUpjApAKu+QKCerHdMGyVg6/vLr4+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736249724; c=relaxed/simple;
	bh=9uHyOrrOFup8ywIsXJt/dCpriAmXRhqS6RmKsLTj27A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=SueE1JC1IXvJc0wxKBZYJwVrPVJ3lvh85+qQ/sDMfEZPaLk2t9guBVVmEqbuDIclCacubPzUG9uLcjFyq30Ld2kjOq5YSuq5txi/QI/32Vw2NrVNmi7NMYa5WJmjyosY7YtDLTKeEV0/bNPpDbST4nbzSRllauvjxPd3+eFcfdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ajD1UG1E; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ajD1UG1E"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-43623f0c574so106159395e9.2
        for <kvmarm@lists.linux.dev>; Tue, 07 Jan 2025 03:35:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1736249719; x=1736854519; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tx00l9gj3r75Pyuu5HDGlCD21/i3mIfLGI99rWPrWTA=;
        b=ajD1UG1ESk6MD+VDx0MXBu0b/C3HcfEAp4wgKqU+quW7gDpGh5z2HyjIrw5Ynovlk0
         Ws1kKaM3szzjp84E/9+GIgb7TZA+YFCCpr4Q6bjhkwHbfhw2tO0lwKlvk69IADD4aoBw
         zVVJZL3010JGLvzo/Zhw85Af5gJwdBiyJC1Fkg3SZxPM/VQzjKdmT3gp20Ggn7SWqC1y
         Z3Ym2pYZ3yuyhq3uyZ2T2VGbDTaLKXENsqw/S4ZTC9ASa6Wrq3pVlZFdsfJ3ebLp4KO+
         Xyvi+pvcCnG7coXyvkrTjrIu9v/03V0jxuiB1QohUdkOqrib5OSEF+C+nmWlNl4vhECb
         zL5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736249719; x=1736854519;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tx00l9gj3r75Pyuu5HDGlCD21/i3mIfLGI99rWPrWTA=;
        b=eOKqKY2XizlfalrKjaw12CJRGBqKOvIUbcSlNElDWxP12MIq1+9Zxp9qEw1sWXK1LD
         fVE5o/4RkQ0phW03YbdGfzIhfMMixwLE51kP04kEdG7XT7ze40B68r1FRQxBBgeOmKqM
         BRCT/9RUQOgse6ySRDmSW5UboaeF8nsY+nBH2rAcmVRX0dDCXQ8rON5xx14AHqdu/Qt2
         KDc32wMnisGZ/qglMAh+5pzFrfitbN7DZ/18R+yh+LT0vwXkXgOBq23/1GfOBf3eGQ39
         EiYexmFLJpzV9f+o2fYnqpPlBDKgvYf+iCddT5HPxkpdgJP84RSFhW7MBnLbaA7iWhOG
         /LrA==
X-Forwarded-Encrypted: i=1; AJvYcCXmYRQCm3lJTDy75B8aganY98S0e0GyrOa/cR9IgTtnwEIqnx1aXVoQJFIrKWwsSGc4tNYO/rc=@lists.linux.dev
X-Gm-Message-State: AOJu0YwUWGrldeGc5Aw2JjyaDmm53kxuO99tz0thgxlPOZkX+vnUTJNV
	kXM88C1lGb0M4HccKDWYn8qZ1D98ZaERZFvGOkhA4v2kzVwwCBD8m1RRv5bZaIQ=
X-Gm-Gg: ASbGnctNnShzw5djxuAP4kOSASoSMt5kaui2dUw1WducHkHHOqYWykUEQgBzaUj5PYF
	ENI0ZdYhVFjjy9FKXm+LxmW6BJp+j8bVtuBVyHaMnGKOEOomojNsR/YNh1N0g9VBX/N0FGx/vOC
	idmGQ/uobIgv48AIrwHzU0zCeO1xHENyYW3UJetvbII04xg6WgZKdm3QuqajoCpBbeRAvObj2dT
	Q/PU4pGk0lVCNRNnyYTX3Ouuht+p2KN5yITXlXH5TpUXTl5S9TIbJKU
X-Google-Smtp-Source: AGHT+IG6ssd+zopKDv9p4eYWzeGZXI+rmR402qUYF0KXs7CGMwpDT/5oKkPAsjDCmwrKzLWBArlwFw==
X-Received: by 2002:a5d:47cf:0:b0:385:ee59:44eb with SMTP id ffacd0b85a97d-38a221fa9ffmr50282094f8f.33.1736249719405;
        Tue, 07 Jan 2025 03:35:19 -0800 (PST)
Received: from pop-os.. ([145.224.66.180])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38a1c89e1acsm50299218f8f.68.2025.01.07.03.35.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2025 03:35:19 -0800 (PST)
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
Subject: [PATCH v10 09/10] KVM: arm64: Support trace filtering for guests
Date: Tue,  7 Jan 2025 11:32:46 +0000
Message-Id: <20250107113252.260631-10-james.clark@linaro.org>
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

For nVHE, switch the filter value in and out if the Coresight driver
asks for it. This will support filters for guests when sinks other than
TRBE are used.

For VHE, just write the filter directly to TRFCR_EL1 where trace can be
used even with TRBE sinks.

Signed-off-by: James Clark <james.clark@linaro.org>
---
 arch/arm64/include/asm/kvm_host.h |  2 ++
 arch/arm64/kvm/debug.c            | 18 ++++++++++++++++++
 2 files changed, 20 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index b244ec44bd3a..1284f4c2da27 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1388,6 +1388,7 @@ void kvm_clr_pmu_events(u64 clr);
 bool kvm_set_pmuserenr(u64 val);
 void kvm_enable_trbe(void);
 void kvm_disable_trbe(void);
+void kvm_tracing_set_el1_configuration(u64 trfcr_while_in_guest);
 #else
 static inline void kvm_set_pmu_events(u64 set, struct perf_event_attr *attr) {}
 static inline void kvm_clr_pmu_events(u64 clr) {}
@@ -1397,6 +1398,7 @@ static inline bool kvm_set_pmuserenr(u64 val)
 }
 static inline void kvm_enable_trbe(void) {}
 static inline void kvm_disable_trbe(void) {}
+static inline void kvm_tracing_set_el1_configuration(u64 trfcr_while_in_guest) {}
 #endif
 
 void kvm_vcpu_load_vhe(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
index e1ac3d2a65be..22815a40d2ee 100644
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -339,3 +339,21 @@ void kvm_disable_trbe(void)
 	host_data_clear_flag(TRBE_ENABLED);
 }
 EXPORT_SYMBOL_GPL(kvm_disable_trbe);
+
+void kvm_tracing_set_el1_configuration(u64 trfcr_while_in_guest)
+{
+	if (is_protected_kvm_enabled() || WARN_ON_ONCE(preemptible()))
+		return;
+
+	if (has_vhe()) {
+		write_sysreg_s(trfcr_while_in_guest, SYS_TRFCR_EL12);
+		return;
+	}
+
+	*host_data_ptr(trfcr_while_in_guest) = trfcr_while_in_guest;
+	if (read_sysreg_s(SYS_TRFCR_EL1) != trfcr_while_in_guest)
+		host_data_set_flag(EL1_TRACING_CONFIGURED);
+	else
+		host_data_clear_flag(EL1_TRACING_CONFIGURED);
+}
+EXPORT_SYMBOL_GPL(kvm_tracing_set_el1_configuration);
-- 
2.34.1

