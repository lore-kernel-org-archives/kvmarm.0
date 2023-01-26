Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC77E538D
	for <kvmarm@lists.linux.dev>; Thu, 26 Jan 2023 20:45:04 +0000 (UTC)
Received: by mail-pl1-f201.google.com with SMTP id i16-20020a17090332d000b00194a7b146b2so1649162plr.20
        for <kvmarm@lists.linux.dev>; Thu, 26 Jan 2023 12:45:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=h0+HVCa26PQR5V+QVEO9ErT8s0x7hBjtiJiZX/bIpFU=;
        b=SZ27gsyIbqEC/xq9We0yn+yun+d81a68o0jB1EPaV8KZQRTGcevayAYZHpzv7iNttz
         OvzFQqRyeaWomvOpfHlHRYrqBX32sMn3be5x9NXvtfwqHqrmYRBHjLsLY02iZL+y1BYR
         kKX/f+ctish4hyJ6s814poGDujkwPcmfrb24M+FooXf9/O/WaA1mtf5RTsj+Jle+4dKi
         ooTNBPnMmfuBe0KvSAXWITkWVz0vf5tLp5exzkxTluX8S2OguwyMqsd1eO5H8k3APhVX
         y8i9HCLNnpAVfNVradYL2npT/lALuNwgoFa8fIOwDdrk1vCTGmK6H2+IfhWNRaUFUI6Y
         1lsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=h0+HVCa26PQR5V+QVEO9ErT8s0x7hBjtiJiZX/bIpFU=;
        b=nJVqFEktxcvFfY2/kT52OtQBMVQs0DAybdO2P9+9NPg9MLbQaXIh2B7EPbQ8jqZLd7
         R2K08QMmRoSxJj6/a3dLygzLnFl2FJJ0ega7kKzB9ekHuj6ci/djCrY6R4hHkUDuXbtV
         PZsAnjlsQHwZkxn3X8bpw35qNlzm8WtLWvXwu95mKgV1TJsOxlsRn0QVDMfj+D4eVFTJ
         ia68/MBu1+tWxlzLF8wO+rzHy+9TCYfrKTOa6s3uJwSSuUandVMYBOZess8HDXNBGrQ/
         k8MH4zWEgjHqs/4tzlVYhnWRS/E2lVXBcaA8BCFipfAgi0NH4fNvvvhljk8F2WKF4qTg
         PzJQ==
X-Gm-Message-State: AFqh2kocgYu4ZjsnnwoDx6S083kRARIW35G0AoeLO6AQVC0rj7gszify
	wm6aIqZ3j+WTGZ+YRSLDw/+1Sq9vwAbBYxU=
X-Google-Smtp-Source: AMrXdXssAYdAN1x5w3IoeV/jxtcJD+hgVzgTobEu+0jY7aK8Qk8BXN/kfGV6llGqa7V5n1pF6vHZAmH/o8ieO1E=
X-Received: from zaidcloud.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5325])
 (user=zalbassam job=sendgmr) by 2002:a05:6a00:4286:b0:58d:a288:aef6 with SMTP
 id bx6-20020a056a00428600b0058da288aef6mr4117974pfb.19.1674765904373; Thu, 26
 Jan 2023 12:45:04 -0800 (PST)
Date: Thu, 26 Jan 2023 15:44:43 -0500
In-Reply-To: <20230126204444.2204061-1-zalbassam@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230126204444.2204061-1-zalbassam@google.com>
X-Mailer: git-send-email 2.39.1.456.gfc5497dd1b-goog
Message-ID: <20230126204444.2204061-8-zalbassam@google.com>
Subject: [PATCH 7/8] ARM: perf: Allow the use of the PMUv3 driver on 32bit ARM
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
is the lack of defined system registers names. This is easily
solved by providing the sysreg accessors and updating the Kconfig entry.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Co-developed-by: Zaid Al-Bassam <zalbassam@google.com>
Signed-off-by: Zaid Al-Bassam <zalbassam@google.com>
---
 arch/arm/include/asm/arm_pmuv3.h | 238 +++++++++++++++++++++++++++++++
 drivers/perf/Kconfig             |   5 +-
 2 files changed, 240 insertions(+), 3 deletions(-)
 create mode 100644 arch/arm/include/asm/arm_pmuv3.h

diff --git a/arch/arm/include/asm/arm_pmuv3.h b/arch/arm/include/asm/arm_pmuv3.h
new file mode 100644
index 000000000000..816873c74eda
--- /dev/null
+++ b/arch/arm/include/asm/arm_pmuv3.h
@@ -0,0 +1,238 @@
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
+#define PMEVCNTR0(n)	__ACCESS_CP15(c14, 0, c8, n)
+#define PMEVCNTR1(n)	__ACCESS_CP15(c14, 0, c9, n)
+#define PMEVCNTR2(n)	__ACCESS_CP15(c14, 0, c10, n)
+#define PMEVCNTR3(n)	__ACCESS_CP15(c14, 0, c11, n)
+#define PMEVTYPER0(n)	__ACCESS_CP15(c14, 0, c12, n)
+#define PMEVTYPER1(n)	__ACCESS_CP15(c14, 0, c13, n)
+#define PMEVTYPER2(n)	__ACCESS_CP15(c14, 0, c14, n)
+#define PMEVTYPER3(n)	__ACCESS_CP15(c14, 0, c15, n)
+
+#define PMEV_EVENTS_PER_REG		8
+#define PMEV_REGISTER(n)		(n / PMEV_EVENTS_PER_REG)
+#define PMEV_EVENT(n)			(n % PMEV_EVENTS_PER_REG)
+
+#define PMEV_CASE(reg, ev, case_macro)	\
+	case ev:							\
+		case_macro(reg, ev);			\
+		break
+
+#define PMEV_EV_SWITCH(reg, ev, case_macro)	\
+	do {									\
+		switch (ev) {						\
+		PMEV_CASE(reg, 0, case_macro);		\
+		PMEV_CASE(reg, 1, case_macro);		\
+		PMEV_CASE(reg, 2, case_macro);		\
+		PMEV_CASE(reg, 3, case_macro);		\
+		PMEV_CASE(reg, 4, case_macro);		\
+		PMEV_CASE(reg, 5, case_macro);		\
+		PMEV_CASE(reg, 6, case_macro);		\
+		PMEV_CASE(reg, 7, case_macro);		\
+		default:	\
+			WARN(1, "Invalid PMEV* event index\n");	\
+		}									\
+	} while (0)
+
+#define PMEV_REG_SWITCH(reg, ev, case_macro)	\
+	do {										\
+		switch (reg) {							\
+		case 0:									\
+			PMEV_EV_SWITCH(0, ev, case_macro);	\
+			break;								\
+		case 1:									\
+			PMEV_EV_SWITCH(1, ev, case_macro);	\
+			break;								\
+		case 2:									\
+			PMEV_EV_SWITCH(2, ev, case_macro);	\
+			break;								\
+		case 3:									\
+			PMEV_EV_SWITCH(3, ev, case_macro);	\
+			break;								\
+		default:								\
+			WARN(1, "Invalid PMEV* register index\n");	\
+		}										\
+	} while (0)
+
+#define RETURN_READ_PMEVCNTR(reg, ev) \
+	return read_sysreg(PMEVCNTR##reg(ev))
+static unsigned long read_pmevcntrn(int n)
+{
+	const int reg = PMEV_REGISTER(n);
+	const int event = PMEV_EVENT(n);
+
+	PMEV_REG_SWITCH(reg, event, RETURN_READ_PMEVCNTR);
+	return 0;
+}
+
+#define WRITE_PMEVCNTR(reg, ev) \
+	write_sysreg(val, PMEVCNTR##reg(ev))
+static void write_pmevcntrn(int n, unsigned long val)
+{
+	const int reg = PMEV_REGISTER(n);
+	const int event = PMEV_EVENT(n);
+
+	PMEV_REG_SWITCH(reg, event, WRITE_PMEVCNTR);
+}
+
+#define WRITE_PMEVTYPER(reg, ev) \
+	write_sysreg(val, PMEVTYPER##reg(ev))
+static void write_pmevtypern(int n, unsigned long val)
+{
+	const int reg = PMEV_REGISTER(n);
+	const int event = PMEV_EVENT(n);
+
+	PMEV_REG_SWITCH(reg, event, WRITE_PMEVTYPER);
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
+static inline void
+armv8pmu_kvm_set_events(u32 set, struct perf_event_attr *attr) {}
+
+static inline void armv8pmu_kvm_clr_events(u32 clr) {}
+
+static inline bool armv8pmu_kvm_counter_deferred(struct perf_event_attr *attr)
+{
+	return false;
+}
+
+#endif
diff --git a/drivers/perf/Kconfig b/drivers/perf/Kconfig
index defe6b47854b..711f82400086 100644
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
-- 
2.39.0.246.g2a6d74b583-goog

