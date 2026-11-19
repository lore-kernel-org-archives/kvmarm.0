Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.69
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795114361;
	b=qbXsYLCH+ur70g3JJ++ZHASRW13sjZAoczZo68ISJb97rgBhPM3r5wDwISbIxImj2yrp
	 fb8FbckQawwgJLbGfx8yKrYX4Qt76GSnAQzRucq80bmgSEjrNb4zidllkLgArPcV3nhFX
	 eu8KipQjga/jWGcUlD/eA6nRLmI4PF+XNgGMVDfLWIwEdBBoyEEGgT2WmiUObgQWJ6mEh
	 /0oM+rRL98QFyWF5aEejnWocv+4eQybQWUi5MDS/nviMqZc3a6qNl7KV9YjEPi94HUfJ0
	 MnmNaGVNRjuFlSFil6bz1ARh0EOpCrgiAhJiTIWCoUd4FUubtkp5uOpoM5xSjDXsT0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795114361;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=Vf5cuVhzqNxbLoI4CPxDBEoH18FVa00DCFt8jqQWCmY=;
	b=Z/NujJlX2SZ9W3+SqopCtsvbSUGXxoAWMPU5y7WmhDc2OlrbVziWcuhwuaW1wszRcVwB
	 GfHhTwbM+tHaxNkZvGWlCYY+a7E6QCPd8T2q4sni6/vdaAXAP59tZY2iwycx+l/34XqdN
	 6vjIPW5y+mhFe8oeskiTagYjLlNIJQpF8aPH2DfkkQ4bKemjmA3y2U+ulKyr8wrwuJqyO
	 wiKhyyBKaPcOkuccqf1tBF8Eu+AjCH5UXOKKsYNmKJTwlLO1PJpVuTNgiDK8GG1g7sauq
	 oRgyaRnWpnb8iTEBhzDOSCYuWMRunugDTr67kVv5V6m+odcbz6K0f4/u0Vxt4WYv2pQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=HztU2H3C;
	arc=none smtp.remote-ip=209.85.160.69
Received: from mail-oa1-f69.google.com (mail-oa1-f69.google.com [209.85.160.69])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A79C1606F41E
	for <kvmarm@lists.linux.dev>; Thu, 19 Nov 2026 18:52:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A79C1606F41E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=HztU2H3C
Received: by mail-oa1-f69.google.com with SMTP id 586e51a60fabf-4ba0e4ca606so108959fac.2
        for <kvmarm@lists.linux.dev>; Thu, 19 Nov 2026 10:52:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795114360; x=1795719160; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Vf5cuVhzqNxbLoI4CPxDBEoH18FVa00DCFt8jqQWCmY=;
        b=HztU2H3CA6quy7fq64SpA5JqQwa7IHlnHkm1/lITNpoWVnk/ZvFFczMOadik5+PQc0
         Eb0zeqjF/6E5rzzThg0oA7cmxhh/BuzKICbDpEJtcudxdoJX8L/dP4oo0WdmAEQvHaMq
         zFnsBy1q6IFu+OICOP6FWnlUgDyZrNvJeTJZqxiHOYuFe2Qu+yprAXFi7RuVUltVjR80
         oHPivEX7UUAWbD0eGuVaJTRixTtnVx1CR2DUz2lpBUulr/72ty+chhkKh4nT+99vju1f
         ChnxqIAZbdUrYmXQrbGqGq+B7T7ikgVW6+fCtMhKfcr+fPxi1ua/Teh80OuOSpLNvC1M
         TdXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795114360; x=1795719160;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Vf5cuVhzqNxbLoI4CPxDBEoH18FVa00DCFt8jqQWCmY=;
        b=kVBpk0wdDGKYLG9h7fWR2EgrJl7yGrXMvtbmaGGAYzkJUeytVW4+LH36hn0Y6RGfbk
         kG1X323kGNvzG6jbizpuEWvuvxKDNmoHQQOG5bPdbBvY0CmURU3y28dc5k3JXgwAO/qU
         HzvzRanRVPmhI6p/3sFJffiOWTdsEQZTcL8Z7fAa+bFYoRURhtUM9FuiMjk+zv8R+SgN
         GSfnReH7sv+ikgGDOMScSxmIkKRBx9kUU8MAcp0rRIEa+Eymddrb4iUwG1Ld4kcBz0RN
         JeX009BKfFdmHsd4XrGizCD77bXO06dJgLwhTrs4cHlSIFCZVNvUvx5vAAyxRWzwSP1q
         +kdg==
X-Forwarded-Encrypted: i=1; AL+hErEn7rNAEZ2EFDWbT37d07XbV2gH6cCj351hvMgqBpMmPQCXhYqYx33w7uD9n4KdEouIpjzAy7I=@lists.linux.dev
X-Gm-Message-State: APuU4Z+DnBBLjZ7PQwRX24YW4yAB7krtz48zZqj100E4g/QDO62mTdYg
	9P71nqirjt1yzwBijorquzPVUjMs/0a2pF5zfxMNauyYgXvpIuIIaFKH+5xhdt6NnWpyO4v85V9
	A2gwj6yrO18J0WLMePPDpR8HKjw==
X-Received: from iobi29-n2.prod.google.com ([2002:a05:6602:c69d:20b0:9c7:67b2:21c8])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:4f4f:b0:56a:dc07:f218 with SMTP id 5614622812f47-57a0a10c801mr992845b6e.20.1795114359282;
 Thu, 19 Nov 2026 10:52:39 -0800 (PST)
Date: Thu, 19 Nov 2026 18:52:06 +0000
In-Reply-To: <20261119185215.632334-1-coltonlewis@google.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261119185215.632334-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.56.1.809.ga0b61035b5-goog
Message-ID: <20261119185215.632334-25-coltonlewis@google.com>
Subject: [PATCH v10 24/33] perf: arm_pmuv3: Handle IRQs for Partitioned PMU
 guest counters
From: Colton Lewis <coltonlewis@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Peter Zijlstra <peterz@infradead.org>, 
	Ingo Molnar <mingo@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Russell King <linux@armlinux.org.uk>, Jonathan Corbet <corbet@lwn.net>, 
	Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, James Clark <james.clark@linaro.org>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Mingwei Zhang <mizhang@google.com>, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Because ARM hardware does not directly inject PMU PPIs into guests,
overflows on partitioned guest counters raise physical PMU interrupts
that enter the host's armv8pmu_handle_irq() handler.

Update armv8pmu_handle_irq() to read PMOVSCLR_EL0 without blindly
clearing guest overflow bits:
- Pass pmovsr to kvm_pmu_handle_guest_irq(), which clears guest-reserved
  overflow bits in hardware and latches them into the running vCPU's
  shadow PMOVSSET_EL0 register.
- Mask out guest-reserved counter bits before clearing and processing
  host perf overflows, returning IRQ_HANDLED early when only guest
  counters overflowed or no host events are active.

Also add kvm_pmu_host_start() and kvm_pmu_host_stop() so
armv8pmu_start() and armv8pmu_stop() toggle MDCR_EL2.HPME rather than
PMCR_EL0.E while a partitioned guest's PMU state is loaded on the CPU
(leaving guest counters 0..HPMN-1 and PMCCNTR_EL0 under guest PMCR_EL0.E
control), guarding local_daif_save() with !in_nmi() for GICv3 pseudo-NMI
interrupt handlers.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm/include/asm/arm_pmuv3.h   |   8 +++
 arch/arm64/include/asm/arm_pmuv3.h |   5 ++
 arch/arm64/kvm/pmu-direct.c        | 102 +++++++++++++++++++++++++++++
 drivers/perf/arm_pmuv3.c           |  34 +++++-----
 include/kvm/arm_pmu.h              |   7 ++
 5 files changed, 141 insertions(+), 15 deletions(-)

diff --git a/arch/arm/include/asm/arm_pmuv3.h b/arch/arm/include/asm/arm_pmuv3.h
index 71cf03ab58cbb..d8051ea261481 100644
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
@@ -231,6 +236,9 @@ static inline u64 kvm_pmu_guest_counter_mask(void)
 {
 	return 0;
 }
+static inline void kvm_pmu_handle_guest_irq(u64 pmovsr) {}
+static inline bool kvm_pmu_host_start(void) { return false; }
+static inline bool kvm_pmu_host_stop(void) { return false; }
 
 /* PMU Version in DFR Register */
 #define ARMV8_PMU_DFR_VER_NI        0
diff --git a/arch/arm64/include/asm/arm_pmuv3.h b/arch/arm64/include/asm/arm_pmuv3.h
index cf2b2212e00a2..9037a28365951 100644
--- a/arch/arm64/include/asm/arm_pmuv3.h
+++ b/arch/arm64/include/asm/arm_pmuv3.h
@@ -110,6 +110,11 @@ static inline void write_pmintenset(u64 val)
 	write_sysreg(val, pmintenset_el1);
 }
 
+static inline u64 read_pmintenset(void)
+{
+	return read_sysreg(pmintenset_el1);
+}
+
 static inline void write_pmintenclr(u64 val)
 {
 	write_sysreg(val, pmintenclr_el1);
diff --git a/arch/arm64/kvm/pmu-direct.c b/arch/arm64/kvm/pmu-direct.c
index c2ea1ce5efe74..21357decce214 100644
--- a/arch/arm64/kvm/pmu-direct.c
+++ b/arch/arm64/kvm/pmu-direct.c
@@ -800,3 +800,105 @@ static void kvm_pmu_set_guest_owned(struct kvm_vcpu *vcpu)
 		__kvm_pmu_load(vcpu, true);
 	}
 }
+
+/**
+ * kvm_pmu_handle_guest_irq() - Record IRQs in guest counters
+ * @pmovsr: Overflow flags reported by driver
+ *
+ * Set overflow flags in guest-reserved counters in the VCPU register
+ * for the guest to clear later.
+ */
+void kvm_pmu_handle_guest_irq(u64 pmovsr)
+{
+	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
+	u64 mask = kvm_pmu_guest_counter_mask();
+	u64 govf = pmovsr & mask;
+
+	if (!govf)
+		return;
+
+	write_pmovsclr(govf);
+
+	if (!vcpu || !vcpu->arch.pmu.loaded_on_cpu)
+		return;
+
+	__vcpu_rmw_sys_reg(vcpu, PMOVSSET_EL0, |=, govf);
+}
+
+/**
+ * kvm_pmu_host_start() - Enable host PMU counters while guest owns PMU
+ *
+ * When a partitioned guest owns the PMU, host counters (HPMN..N-1) are
+ * gated by MDCR_EL2.HPME rather than PMCR_EL0.E.
+ *
+ * Return: True if handled via MDCR_EL2.HPME, false if caller should use PMCR_EL0.E
+ */
+bool kvm_pmu_host_start(void)
+{
+	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
+	unsigned long daif = 0;
+	bool nmi;
+	u64 mdcr;
+
+	if (!vcpu || !kvm_pmu_is_partitioned(vcpu->kvm) ||
+	    !vcpu->arch.pmu.loaded_on_cpu)
+		return false;
+
+	nmi = in_nmi();
+	if (!nmi)
+		daif = local_daif_save();
+
+	if (!vcpu->arch.pmu.loaded_on_cpu) {
+		if (!nmi)
+			local_daif_restore(daif);
+		return false;
+	}
+
+	mdcr = READ_ONCE(vcpu->arch.mdcr_el2) | MDCR_EL2_HPME;
+	WRITE_ONCE(vcpu->arch.mdcr_el2, mdcr);
+	if (has_vhe())
+		write_sysreg(mdcr, mdcr_el2);
+	isb();
+	if (!nmi)
+		local_daif_restore(daif);
+	return true;
+}
+
+/**
+ * kvm_pmu_host_stop() - Disable host PMU counters while guest owns PMU
+ *
+ * When a partitioned guest owns the PMU, host counters (HPMN..N-1) are
+ * gated by MDCR_EL2.HPME rather than PMCR_EL0.E.
+ *
+ * Return: True if handled via MDCR_EL2.HPME, false if caller should use PMCR_EL0.E
+ */
+bool kvm_pmu_host_stop(void)
+{
+	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
+	unsigned long daif = 0;
+	bool nmi;
+	u64 mdcr;
+
+	if (!vcpu || !kvm_pmu_is_partitioned(vcpu->kvm) ||
+	    !vcpu->arch.pmu.loaded_on_cpu)
+		return false;
+
+	nmi = in_nmi();
+	if (!nmi)
+		daif = local_daif_save();
+
+	if (!vcpu->arch.pmu.loaded_on_cpu) {
+		if (!nmi)
+			local_daif_restore(daif);
+		return false;
+	}
+
+	mdcr = READ_ONCE(vcpu->arch.mdcr_el2) & ~MDCR_EL2_HPME;
+	WRITE_ONCE(vcpu->arch.mdcr_el2, mdcr);
+	if (has_vhe())
+		write_sysreg(mdcr, mdcr_el2);
+	isb();
+	if (!nmi)
+		local_daif_restore(daif);
+	return true;
+}
diff --git a/drivers/perf/arm_pmuv3.c b/drivers/perf/arm_pmuv3.c
index 1676f13cc7c38..440f77cf0a2fc 100644
--- a/drivers/perf/arm_pmuv3.c
+++ b/drivers/perf/arm_pmuv3.c
@@ -777,18 +777,9 @@ static void armv8pmu_disable_event_irq(struct perf_event *event)
 	armv8pmu_disable_intens(BIT(event->hw.idx));
 }
 
-static u64 armv8pmu_getreset_flags(void)
+static u64 armv8pmu_getovf_flags(void)
 {
-	u64 value;
-
-	/* Read */
-	value = read_pmovsclr();
-
-	/* Write to clear flags */
-	value &= ARMV8_PMU_CNT_MASK_ALL;
-	write_pmovsclr(value);
-
-	return value;
+	return read_pmovsclr() & ARMV8_PMU_CNT_MASK_ALL;
 }
 
 static void update_pmuserenr(u64 val)
@@ -878,7 +869,8 @@ static void armv8pmu_start(struct arm_pmu *cpu_pmu)
 		brbe_enable(cpu_pmu);
 
 	/* Enable all counters */
-	armv8pmu_pmcr_write(armv8pmu_pmcr_read() | ARMV8_PMU_PMCR_E);
+	if (!kvm_pmu_host_start())
+		armv8pmu_pmcr_write(armv8pmu_pmcr_read() | ARMV8_PMU_PMCR_E);
 }
 
 static void armv8pmu_stop(struct arm_pmu *cpu_pmu)
@@ -889,7 +881,8 @@ static void armv8pmu_stop(struct arm_pmu *cpu_pmu)
 		brbe_disable();
 
 	/* Disable all counters */
-	armv8pmu_pmcr_write(armv8pmu_pmcr_read() & ~ARMV8_PMU_PMCR_E);
+	if (!kvm_pmu_host_stop())
+		armv8pmu_pmcr_write(armv8pmu_pmcr_read() & ~ARMV8_PMU_PMCR_E);
 }
 
 static void read_branch_records(struct pmu_hw_events *cpuc,
@@ -911,9 +904,9 @@ static irqreturn_t armv8pmu_handle_irq(struct arm_pmu *cpu_pmu)
 	int idx;
 
 	/*
-	 * Get and reset the IRQ flags
+	 * Get the IRQ flags
 	 */
-	pmovsr = armv8pmu_getreset_flags();
+	pmovsr = armv8pmu_getovf_flags();
 
 	/*
 	 * Did an overflow occur?
@@ -921,6 +914,17 @@ static irqreturn_t armv8pmu_handle_irq(struct arm_pmu *cpu_pmu)
 	if (!armv8pmu_has_overflowed(pmovsr))
 		return IRQ_NONE;
 
+	kvm_pmu_handle_guest_irq(pmovsr);
+
+	pmovsr &= ~kvm_pmu_guest_counter_mask();
+	if (!pmovsr)
+		return IRQ_HANDLED;
+
+	write_pmovsclr(pmovsr);
+
+	if (bitmap_empty(cpuc->used_mask, ARMPMU_MAX_HWEVENTS))
+		return IRQ_HANDLED;
+
 	/*
 	 * Handle the counter(s) overflow(s)
 	 */
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index e3f5b9a1a4817..9800514019630 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -108,6 +108,9 @@ void kvm_pmu_reload_part(struct kvm_vcpu *vcpu);
 u64 kvm_pmu_guest_counter_mask(void);
 void kvm_pmu_load(struct kvm_vcpu *vcpu);
 void kvm_pmu_put(struct kvm_vcpu *vcpu);
+void kvm_pmu_handle_guest_irq(u64 pmovsr);
+bool kvm_pmu_host_start(void);
+bool kvm_pmu_host_stop(void);
 
 #define kvm_pmu_get_access(vcpu)	((vcpu)->arch.pmu.access)
 #define kvm_pmu_reset_access(vcpu)	((vcpu)->arch.pmu.access = VCPU_PMU_ACCESS_FREE)
@@ -277,6 +280,10 @@ static inline u64 kvm_pmu_guest_counter_mask(void)
 	return 0;
 }
 
+static inline void kvm_pmu_handle_guest_irq(u64 pmovsr) {}
+static inline bool kvm_pmu_host_start(void) { return false; }
+static inline bool kvm_pmu_host_stop(void) { return false; }
+
 static inline bool has_kvm_pmu_partition_support(void)
 {
 	return false;
-- 
2.56.1.708.g77570a6a1d-goog

