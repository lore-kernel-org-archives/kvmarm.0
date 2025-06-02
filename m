Received: from mail-il1-f201.google.com (mail-il1-f201.google.com [209.85.166.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19D3F227EA7
	for <kvmarm@lists.linux.dev>; Mon,  2 Jun 2025 19:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748892559; cv=none; b=OUEhai81YepvQ9+pMvg+yHS0SOAmYsCthOxtyfS1Hufl+Fr3xO1HKOU3WJ7SN96O3aAJAZQ5qEhxqCbmCdLKEwJ503t9wyEHSGT6JeIcQo/cRtCarDCxgo70yxLHQmotdgezPrYEOUXNYeNX632uWqzC4MPIrSiTviV3SgFzOFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748892559; c=relaxed/simple;
	bh=y3rVKdDcfaZ6JmoNjVIK4+Ctxp2l0yLp74rKxw2AHwI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=d4t7x4BAyzMm2rvjeVcBH970bAjFQW/1ohkcBEamm+rdvMf8G1olTUrgCV5WeT3aYTaebQnqskSSL+3o/WPw8A9E35Aw0SGsG+/2wSIJ2/9iFVIbrzMMQcTHkmjeNW+cBtuy3la520z/HGW7mSSXDvsd7CXyt1792tEJSLudpBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CBEQ+fVc; arc=none smtp.client-ip=209.85.166.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CBEQ+fVc"
Received: by mail-il1-f201.google.com with SMTP id e9e14a558f8ab-3da6fe2a552so92872255ab.1
        for <kvmarm@lists.linux.dev>; Mon, 02 Jun 2025 12:29:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748892552; x=1749497352; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=pIieb9nvj3js/0lbP2t4ZJLM8sYLAoNuXbgaxM7clWY=;
        b=CBEQ+fVcWWjFIHsYf2qrl12pvuJUWI+/BdRTQKqVDly4CxzLEsX7BT9uvs2UwLVZ22
         l7qRPdXbe0NQpXFUNsxtbxPkpabsb+8SwiaH8Tz8EozpZI52XTdyW3iaLJvLV7ac4xYY
         LZwuLcQk616XvVT3EhGdX1gVKD+GZWmazUF+FGwowzAqtGtQk86t3wypyOeGUK+cMzqp
         p93OwBXxoxpshYM8Oi5o64qfdCreIzStv0jmJlMEOEWtOhCQIxMhrsLQF6dq9eIsA/dO
         7JDCIsB8GPLIp06YKp7ifBR/pLcHIfkArgJz2sikw0T8jyt1g8F9Dk7E10zmVBmxgTi5
         lyLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748892552; x=1749497352;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pIieb9nvj3js/0lbP2t4ZJLM8sYLAoNuXbgaxM7clWY=;
        b=MhVjJwNyYHpm0ZoYJeQQ66Q5QFsWOdnTTleMj66dGMyn4c8IxgQPIdF4z5PHeg70Gj
         cfXqgp3lE2NCt8wA3JQv51vJHVFUj1HwFeGU9qw9X6y86lwHfu4qCr2GTGxyf8L0sHpQ
         DUqOnpgh7aNZbgXDlFGm7TLd+Ft9Zdfwr+T/yCxj8Oi6ENuR51juUt1orevmP0Wu3Mmd
         iPdpM8TVTzSjz65a+xgI5I2Rz14To4Gbcf40Yz3fWbDPtNSLcVjDeiTLqSbhYRMKsDmC
         9QX6QeIeXaY2msnzTCSpyliyAnUQmc5nn3ElxmurCvXxR3Pxb36mu6UMlrUy8H7GDNft
         md1w==
X-Forwarded-Encrypted: i=1; AJvYcCXyV/eRZE+SZ3K/U1q1HfpN7j9VvRyH6AMJuZb+/rn2ML9oVjNqMtFiVs18UpPEYD5e+N2yEQg=@lists.linux.dev
X-Gm-Message-State: AOJu0YwC1nrw18zHpY0wsebpUCvLEBLOSeWRFSuBI0rAq4fhR55Vjd+l
	QTBVDQbGMMrq9HFRqnksrQ8meAXc5U4v5ETyXIGdJuJDb3zN3tRfGNSf5EGE9JL1eSP7gX1f1VS
	bpw7B7C6Kivifcnw/4vaOa+coag==
X-Google-Smtp-Source: AGHT+IFqQBQNJHZiX1hBF+LjbTaumbyKnOzaoNP3vPsriCDKKVQYIJ9OZ+1lHyJrYq4J3I7AtifVqQuuEfJTrU+N0g==
X-Received: from ilbdr4.prod.google.com ([2002:a05:6e02:3f04:b0:3dc:8616:ffc6])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6e02:2189:b0:3dc:8b57:b750 with SMTP id e9e14a558f8ab-3dda3387e2cmr94188185ab.17.1748892551894;
 Mon, 02 Jun 2025 12:29:11 -0700 (PDT)
Date: Mon,  2 Jun 2025 19:26:59 +0000
In-Reply-To: <20250602192702.2125115-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250602192702.2125115-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.49.0.1204.g71687c7c1d-goog
Message-ID: <20250602192702.2125115-15-coltonlewis@google.com>
Subject: [PATCH 14/17] perf: pmuv3: Handle IRQs for Partitioned PMU guest counters
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Mark Rutland <mark.rutland@arm.com>, 
	Shuah Khan <shuah@kernel.org>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Guest counters will still trigger interrupts that need to be handled
by the host PMU interrupt handler. Clear the overflow flags in
hardware to handle the interrupt as normal, but record which guest
overflow flags were set in the virtual overflow register for later
injecting the interrupt into the guest.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm/include/asm/arm_pmuv3.h |  6 ++++++
 arch/arm64/include/asm/kvm_pmu.h |  2 ++
 arch/arm64/kvm/pmu-part.c        | 17 +++++++++++++++++
 drivers/perf/arm_pmuv3.c         | 15 +++++++++++----
 4 files changed, 36 insertions(+), 4 deletions(-)

diff --git a/arch/arm/include/asm/arm_pmuv3.h b/arch/arm/include/asm/arm_pmuv3.h
index 1687b4031ec2..26e149bdc8b0 100644
--- a/arch/arm/include/asm/arm_pmuv3.h
+++ b/arch/arm/include/asm/arm_pmuv3.h
@@ -180,6 +180,11 @@ static inline void write_pmintenset(u32 val)
 	write_sysreg(val, PMINTENSET);
 }
 
+static inline u32 read_pmintenset(void)
+{
+	return read_sysreg(PMINTENSET);
+}
+
 static inline void write_pmintenclr(u32 val)
 {
 	write_sysreg(val, PMINTENCLR);
@@ -245,6 +250,7 @@ static inline u64 kvm_pmu_guest_counter_mask(struct arm_pmu *pmu)
 	return ~0;
 }
 
+static inline void kvm_pmu_handle_guest_irq(u64 govf) {}
 
 /* PMU Version in DFR Register */
 #define ARMV8_PMU_DFR_VER_NI        0
diff --git a/arch/arm64/include/asm/kvm_pmu.h b/arch/arm64/include/asm/kvm_pmu.h
index 4098d4ad03d9..4cefd9fcf52b 100644
--- a/arch/arm64/include/asm/kvm_pmu.h
+++ b/arch/arm64/include/asm/kvm_pmu.h
@@ -30,6 +30,7 @@ u64 kvm_pmu_host_counter_mask(struct arm_pmu *pmu);
 u64 kvm_pmu_guest_counter_mask(struct arm_pmu *pmu);
 void kvm_pmu_host_counters_enable(void);
 void kvm_pmu_host_counters_disable(void);
+void kvm_pmu_handle_guest_irq(u64 govf);
 
 #else
 
@@ -74,6 +75,7 @@ static inline u64 kvm_pmu_guest_counter_mask(struct arm_pmu *pmu)
 
 static inline void kvm_pmu_host_counters_enable(void) {}
 static inline void kvm_pmu_host_counters_disable(void) {}
+static inline void kvm_pmu_handle_guest_irq(u64 govf) {}
 
 #endif
 
diff --git a/arch/arm64/kvm/pmu-part.c b/arch/arm64/kvm/pmu-part.c
index 40c72caef34e..0e1a2235e992 100644
--- a/arch/arm64/kvm/pmu-part.c
+++ b/arch/arm64/kvm/pmu-part.c
@@ -319,3 +319,20 @@ void kvm_pmu_put(struct kvm_vcpu *vcpu)
 	val = read_pmintenset();
 	__vcpu_sys_reg(vcpu, PMINTENSET_EL1) = val & mask;
 }
+
+/**
+ * kvm_pmu_handle_guest_irq() - Record IRQs in guest counters
+ * @govf: Bitmask of guest overflowed counters
+ *
+ * Record IRQs from overflows in guest-reserved counters in the VCPU
+ * register for the guest to clear later.
+ */
+void kvm_pmu_handle_guest_irq(u64 govf)
+{
+	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
+
+	if (!vcpu)
+		return;
+
+	__vcpu_sys_reg(vcpu, PMOVSSET_EL0) |= govf;
+}
diff --git a/drivers/perf/arm_pmuv3.c b/drivers/perf/arm_pmuv3.c
index f447a0f10e2b..20d9b35260d9 100644
--- a/drivers/perf/arm_pmuv3.c
+++ b/drivers/perf/arm_pmuv3.c
@@ -739,6 +739,8 @@ static u64 armv8pmu_getreset_flags(void)
 
 	/* Write to clear flags */
 	value &= ARMV8_PMU_CNT_MASK_ALL;
+	/* Only reset interrupt enabled counters. */
+	value &= read_pmintenset();
 	write_pmovsclr(value);
 
 	return value;
@@ -841,6 +843,7 @@ static void armv8pmu_stop(struct arm_pmu *cpu_pmu)
 static irqreturn_t armv8pmu_handle_irq(struct arm_pmu *cpu_pmu)
 {
 	u64 pmovsr;
+	u64 govf;
 	struct perf_sample_data data;
 	struct pmu_hw_events *cpuc = this_cpu_ptr(cpu_pmu->hw_events);
 	struct pt_regs *regs;
@@ -867,19 +870,17 @@ static irqreturn_t armv8pmu_handle_irq(struct arm_pmu *cpu_pmu)
 	 * to prevent skews in group events.
 	 */
 	armv8pmu_stop(cpu_pmu);
+
 	for_each_set_bit(idx, cpu_pmu->cntr_mask, ARMPMU_MAX_HWEVENTS) {
 		struct perf_event *event = cpuc->events[idx];
 		struct hw_perf_event *hwc;
 
 		/* Ignore if we don't have an event. */
-		if (!event)
-			continue;
-
 		/*
 		 * We have a single interrupt for all counters. Check that
 		 * each counter has overflowed before we process it.
 		 */
-		if (!armv8pmu_counter_has_overflowed(pmovsr, idx))
+		if (!event || !armv8pmu_counter_has_overflowed(pmovsr, idx))
 			continue;
 
 		hwc = &event->hw;
@@ -896,6 +897,12 @@ static irqreturn_t armv8pmu_handle_irq(struct arm_pmu *cpu_pmu)
 		if (perf_event_overflow(event, &data, regs))
 			cpu_pmu->disable(event);
 	}
+
+	govf = pmovsr & kvm_pmu_guest_counter_mask(cpu_pmu);
+
+	if (kvm_pmu_is_partitioned(cpu_pmu) && govf)
+		kvm_pmu_handle_guest_irq(govf);
+
 	armv8pmu_start(cpu_pmu);
 
 	return IRQ_HANDLED;
-- 
2.49.0.1204.g71687c7c1d-goog

