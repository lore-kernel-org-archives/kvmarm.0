Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ACF263B6
	for <kvmarm@lists.linux.dev>; Fri, 10 Feb 2023 16:55:29 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id x15-20020a25accf000000b008efe9505b2eso2076117ybd.22
        for <kvmarm@lists.linux.dev>; Fri, 10 Feb 2023 08:55:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=W9YwpbnJHraSd3OQC8k62eIRYPXo4ZkJrZ6HqS7mB+k=;
        b=F/LLoF54vrDjEx29QG08Py9qpQXud5WU5+lmceRz0Wx24vQ2soh4KSYyL6SgvLf/ZG
         A+MGNWB4w4fs2MnPZDZ2nP7ATWUhyZifAgK9+F98NjKZ8qnztBNvCJIjLkE6MBxsvtSZ
         /4GMbrQGsGof4pVyOxxgCJIFRsPCHBNvB7Rv3xbHKf4N6mfhEaNb/YdEF2HbXQmcxM9V
         iLbhKl5aHvqqqdPg0lXzbT/UzTMZjgQho/mDS5R2nJm2zDq4zkjO0uCtnuags3SuCP9Q
         +JTXmMiyT3zxBRHFjZmDtq/QW8Vu5tI57p1mDs07RZbk0bXrbRU2Modle7TOT8oy6s/D
         /ioA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=W9YwpbnJHraSd3OQC8k62eIRYPXo4ZkJrZ6HqS7mB+k=;
        b=5mK7hlff9uKFGMWTANrCPKbjU5MJI/meiQ6ST8R5fUtkXP0VsxCkKwN6prPLMXyBtd
         ElampQjl9eT5r/EPzQ51N6tZ7+h1ZLOLT0sk8CAiPH1xzj6LIFDjphtfDQC0N5tUQQFK
         kg4V2Ao9Jg3SCeCgfWZJb27+fi5Dczit1APi6ecPr36qPho4sXGU+GMuyq2gsyTVCWkc
         taiqFQVTKKi7U9rUPDdKOYWN75r/pmEzxRgPlH/tbM7aScb+82mQ/DlyZfPT0TNrR/Kc
         zfZ786jEhWrJWZBNJ2CvgKP7FSeWet7porBRZuuK28EaeTFreSMTkevy2n/9/HDnHk+F
         hjZw==
X-Gm-Message-State: AO0yUKVYPq5x1plqXO9/qMlSpqbWv68bax8muApe+zuIf42Hd5q/gaAa
	NfOTU93Jm5jfAGH+5CKxkUNj9Ze1Jm9RucA=
X-Google-Smtp-Source: AK7set+qGIUaLCLzUkBV/KZBE/5GrKEBJntwzrMG2b9DR0xaxOYWMzW939aK4Wcm9rsjEZRe4NoqurB0wQDWST8=
X-Received: from zaidcloud.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5325])
 (user=zalbassam job=sendgmr) by 2002:a05:6902:1104:b0:8d7:f27e:a6e0 with SMTP
 id o4-20020a056902110400b008d7f27ea6e0mr82ybu.12.1676048127890; Fri, 10 Feb
 2023 08:55:27 -0800 (PST)
Date: Fri, 10 Feb 2023 11:54:59 -0500
In-Reply-To: <20230210165500.2292608-1-zalbassam@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230210165500.2292608-1-zalbassam@google.com>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230210165500.2292608-8-zalbassam@google.com>
Subject: [PATCH v2 7/8] ARM: perf: Allow the use of the PMUv3 driver on 32bit ARM
From: Zaid Al-Bassam <zalbassam@google.com>
To: Jesus Sanchez-Palencia <jesussanp@google.com>, Russell King <linux@armlinux.org.uk>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, 
	Namhyung Kim <namhyung@kernel.org>, Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Zenghui Yu <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu
Cc: Marc Zyngier <marc.zyngier@arm.com>, Zaid Al-Bassam <zalbassam@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Marc Zyngier <marc.zyngier@arm.com>

The only thing stopping the PMUv3 driver from compiling on 32bit
is the lack of defined system registers names and the handful of
required helpers.

This is easily solved by providing the sysreg accessors and updating
the Kconfig entry.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Co-developed-by: Zaid Al-Bassam <zalbassam@google.com>
Signed-off-by: Zaid Al-Bassam <zalbassam@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20230126204444.2204061-8-zalbassam@google.com
---
 arch/arm/include/asm/arm_pmuv3.h | 259 +++++++++++++++++++++++++++++++
 drivers/perf/Kconfig             |   5 +-
 drivers/perf/arm_pmuv3.c         |   5 +-
 3 files changed, 265 insertions(+), 4 deletions(-)
 create mode 100644 arch/arm/include/asm/arm_pmuv3.h

diff --git a/arch/arm/include/asm/arm_pmuv3.h b/arch/arm/include/asm/arm_pmuv3.h
new file mode 100644
index 0000000000000..b2d9dc9dedbac
--- /dev/null
+++ b/arch/arm/include/asm/arm_pmuv3.h
@@ -0,0 +1,259 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2012 ARM Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef __ASM_PMUV3_H
+#define __ASM_PMUV3_H
+
+#include <asm/cp15.h>
+#include <asm/cputype.h>
+
+#define PMCCNTR			__ACCESS_CP15_64(0, c9)
+
+#define PMCR			__ACCESS_CP15(c9,  0, c12, 0)
+#define PMCNTENSET		__ACCESS_CP15(c9,  0, c12, 1)
+#define PMCNTENCLR		__ACCESS_CP15(c9,  0, c12, 2)
+#define PMOVSR			__ACCESS_CP15(c9,  0, c12, 3)
+#define PMSELR			__ACCESS_CP15(c9,  0, c12, 5)
+#define PMCEID0			__ACCESS_CP15(c9,  0, c12, 6)
+#define PMCEID1			__ACCESS_CP15(c9,  0, c12, 7)
+#define PMXEVTYPER		__ACCESS_CP15(c9,  0, c13, 1)
+#define PMXEVCNTR		__ACCESS_CP15(c9,  0, c13, 2)
+#define PMUSERENR		__ACCESS_CP15(c9,  0, c14, 0)
+#define PMINTENSET		__ACCESS_CP15(c9,  0, c14, 1)
+#define PMINTENCLR		__ACCESS_CP15(c9,  0, c14, 2)
+#define PMMIR			__ACCESS_CP15(c9,  0, c14, 6)
+#define PMCCFILTR		__ACCESS_CP15(c14, 0, c15, 7)
+
+#define PMEVCNTR0		__ACCESS_CP15(c14, 0, c8, 0)
+#define PMEVCNTR1		__ACCESS_CP15(c14, 0, c8, 1)
+#define PMEVCNTR2		__ACCESS_CP15(c14, 0, c8, 2)
+#define PMEVCNTR3		__ACCESS_CP15(c14, 0, c8, 3)
+#define PMEVCNTR4		__ACCESS_CP15(c14, 0, c8, 4)
+#define PMEVCNTR5		__ACCESS_CP15(c14, 0, c8, 5)
+#define PMEVCNTR6		__ACCESS_CP15(c14, 0, c8, 6)
+#define PMEVCNTR7		__ACCESS_CP15(c14, 0, c8, 7)
+#define PMEVCNTR8		__ACCESS_CP15(c14, 0, c9, 0)
+#define PMEVCNTR9		__ACCESS_CP15(c14, 0, c9, 1)
+#define PMEVCNTR10		__ACCESS_CP15(c14, 0, c9, 2)
+#define PMEVCNTR11		__ACCESS_CP15(c14, 0, c9, 3)
+#define PMEVCNTR12		__ACCESS_CP15(c14, 0, c9, 4)
+#define PMEVCNTR13		__ACCESS_CP15(c14, 0, c9, 5)
+#define PMEVCNTR14		__ACCESS_CP15(c14, 0, c9, 6)
+#define PMEVCNTR15		__ACCESS_CP15(c14, 0, c9, 7)
+#define PMEVCNTR16		__ACCESS_CP15(c14, 0, c10, 0)
+#define PMEVCNTR17		__ACCESS_CP15(c14, 0, c10, 1)
+#define PMEVCNTR18		__ACCESS_CP15(c14, 0, c10, 2)
+#define PMEVCNTR19		__ACCESS_CP15(c14, 0, c10, 3)
+#define PMEVCNTR20		__ACCESS_CP15(c14, 0, c10, 4)
+#define PMEVCNTR21		__ACCESS_CP15(c14, 0, c10, 5)
+#define PMEVCNTR22		__ACCESS_CP15(c14, 0, c10, 6)
+#define PMEVCNTR23		__ACCESS_CP15(c14, 0, c10, 7)
+#define PMEVCNTR24		__ACCESS_CP15(c14, 0, c11, 0)
+#define PMEVCNTR25		__ACCESS_CP15(c14, 0, c11, 1)
+#define PMEVCNTR26		__ACCESS_CP15(c14, 0, c11, 2)
+#define PMEVCNTR27		__ACCESS_CP15(c14, 0, c11, 3)
+#define PMEVCNTR28		__ACCESS_CP15(c14, 0, c11, 4)
+#define PMEVCNTR29		__ACCESS_CP15(c14, 0, c11, 5)
+#define PMEVCNTR30		__ACCESS_CP15(c14, 0, c11, 6)
+
+#define PMEVTYPER0		__ACCESS_CP15(c14, 0, c12, 0)
+#define PMEVTYPER1		__ACCESS_CP15(c14, 0, c12, 1)
+#define PMEVTYPER2		__ACCESS_CP15(c14, 0, c12, 2)
+#define PMEVTYPER3		__ACCESS_CP15(c14, 0, c12, 3)
+#define PMEVTYPER4		__ACCESS_CP15(c14, 0, c12, 4)
+#define PMEVTYPER5		__ACCESS_CP15(c14, 0, c12, 5)
+#define PMEVTYPER6		__ACCESS_CP15(c14, 0, c12, 6)
+#define PMEVTYPER7		__ACCESS_CP15(c14, 0, c12, 7)
+#define PMEVTYPER8		__ACCESS_CP15(c14, 0, c13, 0)
+#define PMEVTYPER9		__ACCESS_CP15(c14, 0, c13, 1)
+#define PMEVTYPER10		__ACCESS_CP15(c14, 0, c13, 2)
+#define PMEVTYPER11		__ACCESS_CP15(c14, 0, c13, 3)
+#define PMEVTYPER12		__ACCESS_CP15(c14, 0, c13, 4)
+#define PMEVTYPER13		__ACCESS_CP15(c14, 0, c13, 5)
+#define PMEVTYPER14		__ACCESS_CP15(c14, 0, c13, 6)
+#define PMEVTYPER15		__ACCESS_CP15(c14, 0, c13, 7)
+#define PMEVTYPER16		__ACCESS_CP15(c14, 0, c14, 0)
+#define PMEVTYPER17		__ACCESS_CP15(c14, 0, c14, 1)
+#define PMEVTYPER18		__ACCESS_CP15(c14, 0, c14, 2)
+#define PMEVTYPER19		__ACCESS_CP15(c14, 0, c14, 3)
+#define PMEVTYPER20		__ACCESS_CP15(c14, 0, c14, 4)
+#define PMEVTYPER21		__ACCESS_CP15(c14, 0, c14, 5)
+#define PMEVTYPER22		__ACCESS_CP15(c14, 0, c14, 6)
+#define PMEVTYPER23		__ACCESS_CP15(c14, 0, c14, 7)
+#define PMEVTYPER24		__ACCESS_CP15(c14, 0, c15, 0)
+#define PMEVTYPER25		__ACCESS_CP15(c14, 0, c15, 1)
+#define PMEVTYPER26		__ACCESS_CP15(c14, 0, c15, 2)
+#define PMEVTYPER27		__ACCESS_CP15(c14, 0, c15, 3)
+#define PMEVTYPER28		__ACCESS_CP15(c14, 0, c15, 4)
+#define PMEVTYPER29		__ACCESS_CP15(c14, 0, c15, 5)
+#define PMEVTYPER30		__ACCESS_CP15(c14, 0, c15, 6)
+
+#define RETURN_READ_PMEVCNTRN(n) \
+	return read_sysreg(PMEVCNTR##n)
+static unsigned long read_pmevcntrn(int n)
+{
+	PMEVN_SWITCH(n, RETURN_READ_PMEVCNTRN);
+	return 0;
+}
+
+#define WRITE_PMEVCNTRN(n) \
+	write_sysreg(val, PMEVCNTR##n)
+static void write_pmevcntrn(int n, unsigned long val)
+{
+	PMEVN_SWITCH(n, WRITE_PMEVCNTRN);
+}
+
+#define WRITE_PMEVTYPERN(n) \
+	write_sysreg(val, PMEVTYPER##n)
+static void write_pmevtypern(int n, unsigned long val)
+{
+	PMEVN_SWITCH(n, WRITE_PMEVTYPERN);
+}
+
+static inline unsigned long read_pmmir(void)
+{
+	return read_sysreg(PMMIR);
+}
+
+static inline u32 read_pmuver(void)
+{
+	/* PMUVers is not a signed field */
+	u32 dfr0 = read_cpuid_ext(CPUID_EXT_DFR0);
+
+	return (dfr0 >> 24) & 0xf;
+}
+
+static inline void write_pmcr(u32 val)
+{
+	write_sysreg(val, PMCR);
+}
+
+static inline u32 read_pmcr(void)
+{
+	return read_sysreg(PMCR);
+}
+
+static inline void write_pmselr(u32 val)
+{
+	write_sysreg(val, PMSELR);
+}
+
+static inline void write_pmccntr(u64 val)
+{
+	write_sysreg(val, PMCCNTR);
+}
+
+static inline u64 read_pmccntr(void)
+{
+	return read_sysreg(PMCCNTR);
+}
+
+static inline void write_pmxevcntr(u32 val)
+{
+	write_sysreg(val, PMXEVCNTR);
+}
+
+static inline u32 read_pmxevcntr(void)
+{
+	return read_sysreg(PMXEVCNTR);
+}
+
+static inline void write_pmxevtyper(u32 val)
+{
+	write_sysreg(val, PMXEVTYPER);
+}
+
+static inline void write_pmcntenset(u32 val)
+{
+	write_sysreg(val, PMCNTENSET);
+}
+
+static inline void write_pmcntenclr(u32 val)
+{
+	write_sysreg(val, PMCNTENCLR);
+}
+
+static inline void write_pmintenset(u32 val)
+{
+	write_sysreg(val, PMINTENSET);
+}
+
+static inline void write_pmintenclr(u32 val)
+{
+	write_sysreg(val, PMINTENCLR);
+}
+
+static inline void write_pmccfiltr(u32 val)
+{
+	write_sysreg(val, PMCCFILTR);
+}
+
+static inline void write_pmovsclr(u32 val)
+{
+	write_sysreg(val, PMOVSR);
+}
+
+static inline u32 read_pmovsclr(void)
+{
+	return read_sysreg(PMOVSR);
+}
+
+static inline void write_pmuserenr(u32 val)
+{
+	write_sysreg(val, PMUSERENR);
+}
+
+static inline u32 read_pmceid0(void)
+{
+	return read_sysreg(PMCEID0);
+}
+
+static inline u32 read_pmceid1(void)
+{
+	return read_sysreg(PMCEID1);
+}
+
+static inline void kvm_set_pmu_events(u32 set, struct perf_event_attr *attr) {}
+static inline void kvm_clr_pmu_events(u32 clr) {}
+static inline bool kvm_pmu_counter_deferred(struct perf_event_attr *attr)
+{
+	return false;
+}
+
+/* PMU Version in DFR Register */
+#define ARMV8_PMU_DFR_VER_NI        0
+#define ARMV8_PMU_DFR_VER_V3P4      0x5
+#define ARMV8_PMU_DFR_VER_V3P5      0x6
+#define ARMV8_PMU_DFR_VER_IMP_DEF   0xF
+
+static inline bool pmuv3_implemented(int pmuver)
+{
+	return !(pmuver == ARMV8_PMU_DFR_VER_IMP_DEF ||
+		 pmuver == ARMV8_PMU_DFR_VER_NI);
+}
+
+static inline bool is_pmuv3p4(int pmuver)
+{
+	return pmuver >= ARMV8_PMU_DFR_VER_V3P4;
+}
+
+static inline bool is_pmuv3p5(int pmuver)
+{
+	return pmuver >= ARMV8_PMU_DFR_VER_V3P5;
+}
+
+#endif
diff --git a/drivers/perf/Kconfig b/drivers/perf/Kconfig
index defe6b47854b0..711f824000864 100644
--- a/drivers/perf/Kconfig
+++ b/drivers/perf/Kconfig
@@ -101,15 +101,14 @@ config ARM_SMMU_V3_PMU
 	   based on the Stream ID of the corresponding master.
 
 config ARM_PMUV3
-	depends on HW_PERF_EVENTS && ARM64
+	depends on HW_PERF_EVENTS && ((ARM && CPU_V7) || ARM64)
 	bool "ARM PMUv3 support" if !ARM64
-	default y
+	default ARM64
 	  help
 	  Say y if you want to use the ARM performance monitor unit (PMU)
 	  version 3. The PMUv3 is the CPU performance monitors on ARMv8
 	  (aarch32 and aarch64) systems that implement the PMUv3
 	  architecture.
-	  Currently, PMUv3 is only supported on aarch64 (arm64)
 
 config ARM_DSU_PMU
 	tristate "ARM DynamIQ Shared Unit (DSU) PMU"
diff --git a/drivers/perf/arm_pmuv3.c b/drivers/perf/arm_pmuv3.c
index dc8b8c8f1b3ed..c01eca23163fd 100644
--- a/drivers/perf/arm_pmuv3.c
+++ b/drivers/perf/arm_pmuv3.c
@@ -388,10 +388,13 @@ static const struct attribute_group armv8_pmuv3_caps_attr_group = {
  * We unconditionally enable ARMv8.5-PMU long event counter support
  * (64-bit events) where supported. Indicate if this arm_pmu has long
  * event counter support.
+ *
+ * On AArch32, long counters make no sense (you can't access the top
+ * bits), so we only enable this on AArch64.
  */
 static bool armv8pmu_has_long_event(struct arm_pmu *cpu_pmu)
 {
-	return (is_pmuv3p5(cpu_pmu->pmuver));
+	return (IS_ENABLED(CONFIG_ARM64) && is_pmuv3p5(cpu_pmu->pmuver));
 }
 
 static inline bool armv8pmu_event_has_user_read(struct perf_event *event)
-- 
2.39.1.581.gbfd45094c4-goog

