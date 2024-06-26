Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFC36194AE5;
	Wed, 26 Jun 2024 22:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719441168; cv=none; b=Fm5QTy9VCElhrlwQ1dBRASHetrvYg3r0IsA5DlNAzumVlrCTQvPhdaKLLpWIpU2YVA3AdxoSug0+WETed9QtZRWpZv75S52NKgMgX8Rl8tjiQnwZnY5Z5qhvGrVnvZfPsxlenRv3Z4cNVpE5qEybqObOh6z177YgwjoROlaZ23s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719441168; c=relaxed/simple;
	bh=Zjd4i6Kd9/M9jUaP9oDeEY5I4chVO95W/ptFu9sOFWo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=t6EHdJamIG1OH+Vs/z8S0JC3/JtkosKx/mrCNbNlwBbVUBl0lnIjSBoOFfMGrV4dtzxa00eWPLASB9qymGf1mEBi+NuPxh+b11l+H9ZuHHbncoE+jguyY1RbwXLLJodu+EbYyk/3Gdt6T6r/8YhwuasMt/caS0MfKUrlIk7rg24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RXr06H/N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RXr06H/N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68B77C116B1;
	Wed, 26 Jun 2024 22:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719441168;
	bh=Zjd4i6Kd9/M9jUaP9oDeEY5I4chVO95W/ptFu9sOFWo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=RXr06H/N5ldjgVezJWWf2J5eqob/9q7nX1ykqlwJoOrz66EMlUzqnkxsCYMAnC8sX
	 sLEVu9AGHxAvLN6cn1xPQTLuUFFgxwaoqhAJvPkSPhM/1qz/FbSe/VMstP4jsNzJAA
	 h9boShOIOwNdGBEb4W1BGHSF4PfCt5Jeqi3X1YVWxOfQc51CxOJLwix/gz8MPecVu8
	 F2Iy3n047uIngwDQM5DKDa/WWyfuL/gjNGgehJTWexh6T/ivDHk4Qc7wKSJ24NsXWA
	 OjQ11HytKLV7oUfzkC50Id77KByWTQubzPPrK03byaTeTm589NJczLVFrKIcF/0mo3
	 Fmnk3X7MP2yKw==
From: "Rob Herring (Arm)" <robh@kernel.org>
Date: Wed, 26 Jun 2024 16:32:31 -0600
Subject: [PATCH v2 07/12] perf: arm_pmuv3: Prepare for more than 32
 counters
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240626-arm-pmu-3-9-icntr-v2-7-c9784b4f4065@kernel.org>
References: <20240626-arm-pmu-3-9-icntr-v2-0-c9784b4f4065@kernel.org>
In-Reply-To: <20240626-arm-pmu-3-9-icntr-v2-0-c9784b4f4065@kernel.org>
To: Russell King <linux@armlinux.org.uk>, 
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
 Arnaldo Carvalho de Melo <acme@kernel.org>, 
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
 Adrian Hunter <adrian.hunter@intel.com>, Will Deacon <will@kernel.org>, 
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 James Morse <james.morse@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 James Clark <james.clark@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-perf-users@vger.kernel.org, kvmarm@lists.linux.dev
X-Mailer: b4 0.14-dev

Various PMUv3 registers which are a mask of counters are 64-bit
registers, but the accessor functions take a u32. This has been fine as
the upper 32-bits have been RES0 as there has been a maximum of 32
counters prior to Armv9.4/8.9. With Armv9.4/8.9, a 33rd counter is
added. Update the accessor functions to use a u64 instead.

Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
---
 arch/arm64/include/asm/arm_pmuv3.h | 12 ++++++------
 arch/arm64/include/asm/kvm_host.h  |  8 ++++----
 arch/arm64/kvm/pmu.c               |  8 ++++----
 drivers/perf/arm_pmuv3.c           | 40 ++++++++++++++++++++------------------
 include/kvm/arm_pmu.h              |  4 ++--
 5 files changed, 37 insertions(+), 35 deletions(-)

diff --git a/arch/arm64/include/asm/arm_pmuv3.h b/arch/arm64/include/asm/arm_pmuv3.h
index a4697a0b6835..19b3f9150058 100644
--- a/arch/arm64/include/asm/arm_pmuv3.h
+++ b/arch/arm64/include/asm/arm_pmuv3.h
@@ -71,22 +71,22 @@ static inline u64 read_pmccntr(void)
 	return read_sysreg(pmccntr_el0);
 }
 
-static inline void write_pmcntenset(u32 val)
+static inline void write_pmcntenset(u64 val)
 {
 	write_sysreg(val, pmcntenset_el0);
 }
 
-static inline void write_pmcntenclr(u32 val)
+static inline void write_pmcntenclr(u64 val)
 {
 	write_sysreg(val, pmcntenclr_el0);
 }
 
-static inline void write_pmintenset(u32 val)
+static inline void write_pmintenset(u64 val)
 {
 	write_sysreg(val, pmintenset_el1);
 }
 
-static inline void write_pmintenclr(u32 val)
+static inline void write_pmintenclr(u64 val)
 {
 	write_sysreg(val, pmintenclr_el1);
 }
@@ -96,12 +96,12 @@ static inline void write_pmccfiltr(u64 val)
 	write_sysreg(val, pmccfiltr_el0);
 }
 
-static inline void write_pmovsclr(u32 val)
+static inline void write_pmovsclr(u64 val)
 {
 	write_sysreg(val, pmovsclr_el0);
 }
 
-static inline u32 read_pmovsclr(void)
+static inline u64 read_pmovsclr(void)
 {
 	return read_sysreg(pmovsclr_el0);
 }
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 8170c04fde91..6243a01d9d26 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1267,12 +1267,12 @@ void kvm_arch_vcpu_load_debug_state_flags(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_put_debug_state_flags(struct kvm_vcpu *vcpu);
 
 #ifdef CONFIG_KVM
-void kvm_set_pmu_events(u32 set, struct perf_event_attr *attr);
-void kvm_clr_pmu_events(u32 clr);
+void kvm_set_pmu_events(u64 set, struct perf_event_attr *attr);
+void kvm_clr_pmu_events(u64 clr);
 bool kvm_set_pmuserenr(u64 val);
 #else
-static inline void kvm_set_pmu_events(u32 set, struct perf_event_attr *attr) {}
-static inline void kvm_clr_pmu_events(u32 clr) {}
+static inline void kvm_set_pmu_events(u64 set, struct perf_event_attr *attr) {}
+static inline void kvm_clr_pmu_events(u64 clr) {}
 static inline bool kvm_set_pmuserenr(u64 val)
 {
 	return false;
diff --git a/arch/arm64/kvm/pmu.c b/arch/arm64/kvm/pmu.c
index 329819806096..e633b4434c6a 100644
--- a/arch/arm64/kvm/pmu.c
+++ b/arch/arm64/kvm/pmu.c
@@ -35,7 +35,7 @@ struct kvm_pmu_events *kvm_get_pmu_events(void)
  * Add events to track that we may want to switch at guest entry/exit
  * time.
  */
-void kvm_set_pmu_events(u32 set, struct perf_event_attr *attr)
+void kvm_set_pmu_events(u64 set, struct perf_event_attr *attr)
 {
 	struct kvm_pmu_events *pmu = kvm_get_pmu_events();
 
@@ -51,7 +51,7 @@ void kvm_set_pmu_events(u32 set, struct perf_event_attr *attr)
 /*
  * Stop tracking events
  */
-void kvm_clr_pmu_events(u32 clr)
+void kvm_clr_pmu_events(u64 clr)
 {
 	struct kvm_pmu_events *pmu = kvm_get_pmu_events();
 
@@ -176,7 +176,7 @@ static void kvm_vcpu_pmu_disable_el0(unsigned long events)
 void kvm_vcpu_pmu_restore_guest(struct kvm_vcpu *vcpu)
 {
 	struct kvm_pmu_events *pmu;
-	u32 events_guest, events_host;
+	u64 events_guest, events_host;
 
 	if (!kvm_arm_support_pmu_v3() || !has_vhe())
 		return;
@@ -197,7 +197,7 @@ void kvm_vcpu_pmu_restore_guest(struct kvm_vcpu *vcpu)
 void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu)
 {
 	struct kvm_pmu_events *pmu;
-	u32 events_guest, events_host;
+	u64 events_guest, events_host;
 
 	if (!kvm_arm_support_pmu_v3() || !has_vhe())
 		return;
diff --git a/drivers/perf/arm_pmuv3.c b/drivers/perf/arm_pmuv3.c
index 53ad674bf009..f771242168f1 100644
--- a/drivers/perf/arm_pmuv3.c
+++ b/drivers/perf/arm_pmuv3.c
@@ -505,14 +505,14 @@ static void armv8pmu_pmcr_write(u64 val)
 	write_pmcr(val);
 }
 
-static int armv8pmu_has_overflowed(u32 pmovsr)
+static int armv8pmu_has_overflowed(u64 pmovsr)
 {
-	return pmovsr & ARMV8_PMU_OVERFLOWED_MASK;
+	return !!(pmovsr & ARMV8_PMU_OVERFLOWED_MASK);
 }
 
-static int armv8pmu_counter_has_overflowed(u32 pmnc, int idx)
+static int armv8pmu_counter_has_overflowed(u64 pmnc, int idx)
 {
-	return pmnc & BIT(idx);
+	return !!(pmnc & BIT(idx));
 }
 
 static u64 armv8pmu_read_evcntr(int idx)
@@ -651,17 +651,17 @@ static void armv8pmu_write_event_type(struct perf_event *event)
 	}
 }
 
-static u32 armv8pmu_event_cnten_mask(struct perf_event *event)
+static u64 armv8pmu_event_cnten_mask(struct perf_event *event)
 {
 	int counter = event->hw.idx;
-	u32 mask = BIT(counter);
+	u64 mask = BIT(counter);
 
 	if (armv8pmu_event_is_chained(event))
 		mask |= BIT(counter - 1);
 	return mask;
 }
 
-static void armv8pmu_enable_counter(u32 mask)
+static void armv8pmu_enable_counter(u64 mask)
 {
 	/*
 	 * Make sure event configuration register writes are visible before we
@@ -674,7 +674,7 @@ static void armv8pmu_enable_counter(u32 mask)
 static void armv8pmu_enable_event_counter(struct perf_event *event)
 {
 	struct perf_event_attr *attr = &event->attr;
-	u32 mask = armv8pmu_event_cnten_mask(event);
+	u64 mask = armv8pmu_event_cnten_mask(event);
 
 	kvm_set_pmu_events(mask, attr);
 
@@ -683,7 +683,7 @@ static void armv8pmu_enable_event_counter(struct perf_event *event)
 		armv8pmu_enable_counter(mask);
 }
 
-static void armv8pmu_disable_counter(u32 mask)
+static void armv8pmu_disable_counter(u64 mask)
 {
 	write_pmcntenclr(mask);
 	/*
@@ -696,7 +696,7 @@ static void armv8pmu_disable_counter(u32 mask)
 static void armv8pmu_disable_event_counter(struct perf_event *event)
 {
 	struct perf_event_attr *attr = &event->attr;
-	u32 mask = armv8pmu_event_cnten_mask(event);
+	u64 mask = armv8pmu_event_cnten_mask(event);
 
 	kvm_clr_pmu_events(mask);
 
@@ -705,7 +705,7 @@ static void armv8pmu_disable_event_counter(struct perf_event *event)
 		armv8pmu_disable_counter(mask);
 }
 
-static void armv8pmu_enable_intens(u32 mask)
+static void armv8pmu_enable_intens(u64 mask)
 {
 	write_pmintenset(mask);
 }
@@ -715,7 +715,7 @@ static void armv8pmu_enable_event_irq(struct perf_event *event)
 	armv8pmu_enable_intens(BIT(event->hw.idx));
 }
 
-static void armv8pmu_disable_intens(u32 mask)
+static void armv8pmu_disable_intens(u64 mask)
 {
 	write_pmintenclr(mask);
 	isb();
@@ -729,9 +729,9 @@ static void armv8pmu_disable_event_irq(struct perf_event *event)
 	armv8pmu_disable_intens(BIT(event->hw.idx));
 }
 
-static u32 armv8pmu_getreset_flags(void)
+static u64 armv8pmu_getreset_flags(void)
 {
-	u32 value;
+	u64 value;
 
 	/* Read */
 	value = read_pmovsclr();
@@ -827,7 +827,7 @@ static void armv8pmu_stop(struct arm_pmu *cpu_pmu)
 
 static irqreturn_t armv8pmu_handle_irq(struct arm_pmu *cpu_pmu)
 {
-	u32 pmovsr;
+	u64 pmovsr;
 	struct perf_sample_data data;
 	struct pmu_hw_events *cpuc = this_cpu_ptr(cpu_pmu->hw_events);
 	struct pt_regs *regs;
@@ -1040,14 +1040,16 @@ static int armv8pmu_set_event_filter(struct hw_perf_event *event,
 static void armv8pmu_reset(void *info)
 {
 	struct arm_pmu *cpu_pmu = (struct arm_pmu *)info;
-	u64 pmcr;
+	u64 pmcr, mask;
+
+	bitmap_to_arr64(&mask, cpu_pmu->cntr_mask, ARMPMU_MAX_HWEVENTS);
 
 	/* The counter and interrupt enable registers are unknown at reset. */
-	armv8pmu_disable_counter(U32_MAX);
-	armv8pmu_disable_intens(U32_MAX);
+	armv8pmu_disable_counter(mask);
+	armv8pmu_disable_intens(mask);
 
 	/* Clear the counters we flip at guest entry/exit */
-	kvm_clr_pmu_events(U32_MAX);
+	kvm_clr_pmu_events(mask);
 
 	/*
 	 * Initialize & Reset PMNC. Request overflow interrupt for
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 35d4ca4f6122..334d7c5503cf 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -19,8 +19,8 @@ struct kvm_pmc {
 };
 
 struct kvm_pmu_events {
-	u32 events_host;
-	u32 events_guest;
+	u64 events_host;
+	u64 events_guest;
 };
 
 struct kvm_pmu {

-- 
2.43.0

