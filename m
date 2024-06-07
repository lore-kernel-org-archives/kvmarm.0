Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A2FC15667D;
	Fri,  7 Jun 2024 20:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717792336; cv=none; b=gOLIXooCsUgT7nZ+cst0QRCxi/KtSMimq/rc4VObyU/ToKJvH2crcdmuH+GQgG2oUmk4VXzMTqqSncUc0R6TEh+5g2tzM3eqQ1BHZNbjYs9uV83F79YJoUBMbJZ6TW7OnWd+PByV78wLm6N6tLK205tIiuExQMk8fxSdL71NN4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717792336; c=relaxed/simple;
	bh=KgRp/liFFW85v8ZYPjrAlhpw4VYmeoKaJTUjzgMXSH8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=PQG4qWI+DoAwjQDlzIWfwFM5g3K9nfbkxdRqnKDXm3AaqTzumZFJkerst1M+XH8x9zQt+8tJpC8hfYQeGTvkh9MUKUcwgTVKQAxTLZTl9CBWxz1eWOvs87HiYpYyNurqa5kvew0UU71wWRTKhKqqIcoRyE1XtzlgfVJ+LyNvrMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SfEFfAJa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SfEFfAJa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63D92C4AF08;
	Fri,  7 Jun 2024 20:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717792335;
	bh=KgRp/liFFW85v8ZYPjrAlhpw4VYmeoKaJTUjzgMXSH8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=SfEFfAJakAM6y716aMbuLsXQ7hiXrXoRRlhuEJzKbSlZ+h/7iR0bxUl85iriTPTVf
	 x34WZPWhQsUVyIylyXWZCIOTLTBsao46V3fJkG2vuoqgF/XAcpvduTqdaRgbyVpGfm
	 kgziXenKnVLm0dX1XvZPR+jcJ69/G+/GdhTCycADrMxldsTSB5juejkkcsuoqFX1YR
	 jI44DspO9vyxgizA1pfpmem3MgeRFS2G2+r1dItJ/qGNTmXbIeTEmuSkBtV/1Cv8xL
	 IKIA3jXWvxjYA7pRLDQtU+N6HC3p/2PFljYLJ8qDFs6VTR/MfUePvaCJgHf81pSTPV
	 pNHZJWU3pW/oA==
From: "Rob Herring (Arm)" <robh@kernel.org>
Date: Fri, 07 Jun 2024 14:31:34 -0600
Subject: [PATCH 9/9] perf: arm_pmuv3: Add support for Armv9.4 PMU
 instruction counter
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240607-arm-pmu-3-9-icntr-v1-9-c7bd2dceff3b@kernel.org>
References: <20240607-arm-pmu-3-9-icntr-v1-0-c7bd2dceff3b@kernel.org>
In-Reply-To: <20240607-arm-pmu-3-9-icntr-v1-0-c7bd2dceff3b@kernel.org>
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
 Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-perf-users@vger.kernel.org, kvmarm@lists.linux.dev
X-Mailer: b4 0.14-dev

Armv9.4/8.9 PMU adds optional support for a fixed instruction counter
similar to the fixed cycle counter. Support for the feature is indicated
in the ID_AA64DFR1_EL1 register PMICNTR field. The counter is not
accessible in AArch32.

Existing userspace using direct counter access won't know how to handle
the fixed instruction counter, so we have to avoid using the counter
when user access is requested.

Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
---
 arch/arm/include/asm/arm_pmuv3.h   | 21 +++++++++++++++++++++
 arch/arm64/include/asm/arm_pmuv3.h | 29 +++++++++++++++++++++++++++++
 arch/arm64/kvm/pmu.c               |  8 ++++++--
 arch/arm64/tools/sysreg            | 25 +++++++++++++++++++++++++
 drivers/perf/arm_pmuv3.c           | 28 ++++++++++++++++++++++++++--
 include/linux/perf/arm_pmu.h       |  8 ++++++--
 include/linux/perf/arm_pmuv3.h     |  4 +++-
 7 files changed, 116 insertions(+), 7 deletions(-)

diff --git a/arch/arm/include/asm/arm_pmuv3.h b/arch/arm/include/asm/arm_pmuv3.h
index ac2cf37b57e3..b836537ddfbf 100644
--- a/arch/arm/include/asm/arm_pmuv3.h
+++ b/arch/arm/include/asm/arm_pmuv3.h
@@ -10,6 +10,7 @@
 #include <asm/cputype.h>
 
 #define ARMV8_PMU_CYCLE_IDX		31
+#define ARMV8_PMU_INSTR_IDX		32 /* Not accessible from AArch32 */
 
 #define PMCCNTR			__ACCESS_CP15_64(0, c9)
 
@@ -129,6 +130,12 @@ static inline u32 read_pmuver(void)
 	return (dfr0 >> 24) & 0xf;
 }
 
+static inline bool pmuv3_has_icntr(void)
+{
+	/* FEAT_PMUv3_ICNTR not accessible for 32-bit */
+	return false;
+}
+
 static inline void write_pmcr(u32 val)
 {
 	write_sysreg(val, PMCR);
@@ -154,6 +161,13 @@ static inline u64 read_pmccntr(void)
 	return read_sysreg(PMCCNTR);
 }
 
+static inline void write_pmicntr(u64 val) {}
+
+static inline u64 read_pmicntr(void)
+{
+	return 0;
+}
+
 static inline void write_pmcntenset(u32 val)
 {
 	write_sysreg(val, PMCNTENSET);
@@ -179,6 +193,13 @@ static inline void write_pmccfiltr(u32 val)
 	write_sysreg(val, PMCCFILTR);
 }
 
+static inline void write_pmicfiltr(u64 val) {}
+
+static inline u64 read_pmicfiltr(void)
+{
+	return 0;
+}
+
 static inline void write_pmovsclr(u32 val)
 {
 	write_sysreg(val, PMOVSR);
diff --git a/arch/arm64/include/asm/arm_pmuv3.h b/arch/arm64/include/asm/arm_pmuv3.h
index 46930729fb3f..a13a10e97c01 100644
--- a/arch/arm64/include/asm/arm_pmuv3.h
+++ b/arch/arm64/include/asm/arm_pmuv3.h
@@ -12,6 +12,7 @@
 #include <asm/sysreg.h>
 
 #define ARMV8_PMU_CYCLE_IDX		31
+#define ARMV8_PMU_INSTR_IDX		32
 
 #define RETURN_READ_PMEVCNTRN(n) \
 	return read_sysreg(pmevcntr##n##_el0)
@@ -56,6 +57,14 @@ static inline u32 read_pmuver(void)
 			ID_AA64DFR0_EL1_PMUVer_SHIFT);
 }
 
+static inline bool pmuv3_has_icntr(void)
+{
+	u64 dfr1 = read_sysreg(id_aa64dfr1_el1);
+
+	return !!cpuid_feature_extract_unsigned_field(dfr1,
+			ID_AA64DFR1_EL1_PMICNTR_SHIFT);
+}
+
 static inline void write_pmcr(u64 val)
 {
 	write_sysreg(val, pmcr_el0);
@@ -81,6 +90,16 @@ static inline u64 read_pmccntr(void)
 	return read_sysreg(pmccntr_el0);
 }
 
+static inline void write_pmicntr(u64 val)
+{
+	write_sysreg_s(val, SYS_PMICNTR_EL0);
+}
+
+static inline u64 read_pmicntr(void)
+{
+	return read_sysreg_s(SYS_PMICNTR_EL0);
+}
+
 static inline void write_pmcntenset(u64 val)
 {
 	write_sysreg(val, pmcntenset_el0);
@@ -111,6 +130,16 @@ static inline u64 read_pmccfiltr(void)
 	return read_sysreg(pmccfiltr_el0);
 }
 
+static inline void write_pmicfiltr(u64 val)
+{
+	write_sysreg_s(val, SYS_PMICFILTR_EL0);
+}
+
+static inline u64 read_pmicfiltr(void)
+{
+	return read_sysreg_s(SYS_PMICFILTR_EL0);
+}
+
 static inline void write_pmovsclr(u64 val)
 {
 	write_sysreg(val, pmovsclr_el0);
diff --git a/arch/arm64/kvm/pmu.c b/arch/arm64/kvm/pmu.c
index 7eaf5f7aeae9..9420835cce91 100644
--- a/arch/arm64/kvm/pmu.c
+++ b/arch/arm64/kvm/pmu.c
@@ -67,24 +67,28 @@ void kvm_clr_pmu_events(u64 clr)
 
 /*
  * Read a value direct from PMEVTYPER<idx> where idx is 0-30
- * or PMCCFILTR_EL0 where idx is ARMV8_PMU_CYCLE_IDX (31).
+ * or PMxCFILTR_EL0 where idx is 31-32.
  */
 static u64 kvm_vcpu_pmu_read_evtype_direct(int idx)
 {
 	if (idx == ARMV8_PMU_CYCLE_IDX)
 		return read_pmccfiltr();
+	else if (idx == ARMV8_PMU_INSTR_IDX)
+		return read_pmicfiltr();
 
 	return read_pmevtypern(idx);
 }
 
 /*
  * Write a value direct to PMEVTYPER<idx> where idx is 0-30
- * or PMCCFILTR_EL0 where idx is ARMV8_PMU_CYCLE_IDX (31).
+ * or PMxCFILTR_EL0 where idx is 31-32.
  */
 static void kvm_vcpu_pmu_write_evtype_direct(int idx, u32 val)
 {
 	if (idx == ARMV8_PMU_CYCLE_IDX)
 		write_pmccfiltr(val);
+	else if (idx == ARMV8_PMU_INSTR_IDX)
+		write_pmicfiltr(val);
 	else
 		write_pmevtypern(idx, val);
 }
diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 231817a379b5..8ab6e09871de 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -2029,6 +2029,31 @@ Sysreg	FAR_EL1	3	0	6	0	0
 Field	63:0	ADDR
 EndSysreg
 
+Sysreg	PMICNTR_EL0	3	3	9	4	0
+Field	63:0	ICNT
+EndSysreg
+
+Sysreg	PMICFILTR_EL0	3	3	9	6	0
+Res0	63:59
+Field	58	SYNC
+Field	57:56	VS
+Res0	55:32
+Field	31	P
+Field	30	U
+Field	29	NSK
+Field	28	NSU
+Field	27	NSH
+Field	26	M
+Res0	25
+Field	24	SH
+Field	23	T
+Field	22	RLK
+Field	21	RLU
+Field	20	RLH
+Res0	19:16
+Field	15:0	evtCount
+EndSysreg
+
 Sysreg	PMSCR_EL1	3	0	9	9	0
 Res0	63:8
 Field	7:6	PCT
diff --git a/drivers/perf/arm_pmuv3.c b/drivers/perf/arm_pmuv3.c
index 468a0a3bbd5a..890efc686e11 100644
--- a/drivers/perf/arm_pmuv3.c
+++ b/drivers/perf/arm_pmuv3.c
@@ -479,7 +479,7 @@ static bool armv8pmu_event_is_chained(struct perf_event *event)
 	return !armv8pmu_event_has_user_read(event) &&
 	       armv8pmu_event_is_64bit(event) &&
 	       !armv8pmu_has_long_event(cpu_pmu) &&
-	       (idx != ARMV8_PMU_CYCLE_IDX);
+	       (idx < ARMV8_PMU_CYCLE_IDX);
 }
 
 /*
@@ -538,7 +538,7 @@ static bool armv8pmu_event_needs_bias(struct perf_event *event)
 		return false;
 
 	if (armv8pmu_has_long_event(cpu_pmu) ||
-	    idx == ARMV8_PMU_CYCLE_IDX)
+	    idx >= ARMV8_PMU_CYCLE_IDX)
 		return true;
 
 	return false;
@@ -568,6 +568,8 @@ static u64 armv8pmu_read_counter(struct perf_event *event)
 
 	if (idx == ARMV8_PMU_CYCLE_IDX)
 		value = read_pmccntr();
+	else if (idx == ARMV8_PMU_INSTR_IDX)
+		value = read_pmicntr();
 	else
 		value = armv8pmu_read_hw_counter(event);
 
@@ -601,6 +603,8 @@ static void armv8pmu_write_counter(struct perf_event *event, u64 value)
 
 	if (idx == ARMV8_PMU_CYCLE_IDX)
 		write_pmccntr(value);
+	else if (idx == ARMV8_PMU_INSTR_IDX)
+		write_pmicntr(value);
 	else
 		armv8pmu_write_hw_counter(event, value);
 }
@@ -638,6 +642,8 @@ static void armv8pmu_write_event_type(struct perf_event *event)
 	} else {
 		if (idx == ARMV8_PMU_CYCLE_IDX)
 			write_pmccfiltr(hwc->config_base);
+		else if (idx == ARMV8_PMU_INSTR_IDX)
+			write_pmicfiltr(hwc->config_base);
 		else
 			armv8pmu_write_evtype(idx, hwc->config_base);
 	}
@@ -765,6 +771,8 @@ static void armv8pmu_enable_user_access(struct arm_pmu *cpu_pmu)
 	for_each_clear_bit(i, cpuc->used_mask, ARMPMU_MAX_HWEVENTS) {
 		if (i == ARMV8_PMU_CYCLE_IDX)
 			write_pmccntr(0);
+		else if (i == ARMV8_PMU_INSTR_IDX)
+			write_pmicntr(0);
 		else
 			armv8pmu_write_evcntr(i, 0);
 	}
@@ -931,6 +939,18 @@ static int armv8pmu_get_event_idx(struct pmu_hw_events *cpuc,
 				return -EAGAIN;
 	}
 
+	/*
+	 * Always prefer to place a instruction counter into the instruction counter,
+	 * but don't expose the instruction counter to userspace access as userspace
+	 * may not know how to handle it.
+	 */
+	if (test_bit(ARMV8_PMU_INSTR_IDX, cpu_pmu->cntr_mask) &&
+	    (evtype == ARMV8_PMUV3_PERFCTR_INST_RETIRED) &&
+	    !armv8pmu_event_want_user_access(event)) {
+		if (!test_and_set_bit(ARMV8_PMU_INSTR_IDX, cpuc->used_mask))
+			return ARMV8_PMU_INSTR_IDX;
+	}
+
 	/*
 	 * Otherwise use events counters
 	 */
@@ -1188,6 +1208,10 @@ static void __armv8pmu_probe_pmu(void *info)
 	/* Add the CPU cycles counter */
 	bitmap_set(cpu_pmu->cntr_mask, ARMV8_PMU_CYCLE_IDX, 1);
 
+	/* Add the CPU instructions counter */
+	if (pmuv3_has_icntr())
+		bitmap_set(cpu_pmu->cntr_mask, ARMV8_PMU_INSTR_IDX, 1);
+
 	pmceid[0] = pmceid_raw[0] = read_pmceid0();
 	pmceid[1] = pmceid_raw[1] = read_pmceid1();
 
diff --git a/include/linux/perf/arm_pmu.h b/include/linux/perf/arm_pmu.h
index e5d6d204beab..4b5b83677e3f 100644
--- a/include/linux/perf/arm_pmu.h
+++ b/include/linux/perf/arm_pmu.h
@@ -17,10 +17,14 @@
 #ifdef CONFIG_ARM_PMU
 
 /*
- * The ARMv7 CPU PMU supports up to 32 event counters.
+ * The Armv7 and Armv8.8 or less CPU PMU supports up to 32 event counters.
+ * The Armv8.9/9.4 CPU PMU supports up to 33 event counters.
  */
+#ifdef CONFIG_ARM
 #define ARMPMU_MAX_HWEVENTS		32
-
+#else
+#define ARMPMU_MAX_HWEVENTS		33
+#endif
 /*
  * ARM PMU hw_event flags
  */
diff --git a/include/linux/perf/arm_pmuv3.h b/include/linux/perf/arm_pmuv3.h
index c902fe64f070..0472c4270d66 100644
--- a/include/linux/perf/arm_pmuv3.h
+++ b/include/linux/perf/arm_pmuv3.h
@@ -224,8 +224,10 @@
  */
 #define ARMV8_PMU_OVSR_P		GENMASK(30, 0)
 #define ARMV8_PMU_OVSR_C		BIT(31)
+#define ARMV8_PMU_OVSR_F		BIT_ULL(32) /* arm64 only */
 /* Mask for writable bits is both P and C fields */
-#define ARMV8_PMU_OVERFLOWED_MASK	(ARMV8_PMU_OVSR_P | ARMV8_PMU_OVSR_C)
+#define ARMV8_PMU_OVERFLOWED_MASK	(ARMV8_PMU_OVSR_P | ARMV8_PMU_OVSR_C | \
+					ARMV8_PMU_OVSR_F)
 
 /*
  * PMXEVTYPER: Event selection reg

-- 
2.43.0

