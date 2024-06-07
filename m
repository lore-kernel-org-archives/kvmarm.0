Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FDC514F9E6;
	Fri,  7 Jun 2024 20:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717792330; cv=none; b=bM98k7Rvi0SO+VO7nxIKu/J6Aa6H2UwI49JYnJ70+jmff/YQ9WSybpCMDMiwEunAjAW28NW52HjFABi08mxdBwrqy3DIFsjP16jDEY+NtNhPXIA/XmoyL3pu10QI5HBFH52nYOpv/BTWJgLMnxyrPhfpdaUe9ZLytZH2T8gcgyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717792330; c=relaxed/simple;
	bh=So81qq/+gb60JLTHqTChOcgxxJijDT58nbB4wbQsq8g=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=DaCVuXpwtCN7AObgYCVq6jE9/D9qxrpfUhFAzxN03ZBw6sPRffjtQfbUxivK3ywJkqplm9iRS8aR4xd+SeRPKY2gAwB95/tguEmDwgZe28qoD3+8/XRBGRTQ4ZgOHp14Cawg6gvKxjC74uihcPguB7LXmrzeo2BvTQrAb7qLgRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Os1O+c6P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Os1O+c6P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3F6BC4AF07;
	Fri,  7 Jun 2024 20:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717792330;
	bh=So81qq/+gb60JLTHqTChOcgxxJijDT58nbB4wbQsq8g=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Os1O+c6PV6nohVgamceFCl6xwUO8m7/6KNsOfJUC7H+ty7rcv5l/1uKzz1XeamcXT
	 AFdNjPgF/bihI05aSyIVjWiocVYb00xiRYSeVQPhEZ91XABZF6cscgtuXtGHUeQ2ch
	 wfSDyo4Pp5efW6HOQcoR2uRIMxxT3P7Bd24H7c9+8fEgOHis1OCcMVcC/gipitZRnz
	 ZDQW4KTeHvpZaD1dvVa/WWZzajrFDBx+BUx7is/On+pxCDufrLq5BzfnbnaZ1UZMg5
	 yPl4iJmU/2x/MTvgBXE8+t0KrKuuK1/r03F+GhS6CgdVlep6UD+jUGGtl8SsrfxziH
	 L2OceIbqjZ++Q==
From: "Rob Herring (Arm)" <robh@kernel.org>
Date: Fri, 07 Jun 2024 14:31:30 -0600
Subject: [PATCH 5/9] KVM: arm64: pmu: Use arm_pmuv3.h register accessors
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240607-arm-pmu-3-9-icntr-v1-5-c7bd2dceff3b@kernel.org>
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

Commit df29ddf4f04b ("arm64: perf: Abstract system register accesses
away") split off PMU register accessor functions to a standalone header.
Let's use it for KVM PMU code and get rid one copy of the ugly switch
macro.

Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
---
 arch/arm64/include/asm/arm_pmuv3.h | 13 ++++++++
 arch/arm64/kvm/pmu.c               | 67 +++++---------------------------------
 2 files changed, 22 insertions(+), 58 deletions(-)

diff --git a/arch/arm64/include/asm/arm_pmuv3.h b/arch/arm64/include/asm/arm_pmuv3.h
index e96ce7900fc7..1ed91334fede 100644
--- a/arch/arm64/include/asm/arm_pmuv3.h
+++ b/arch/arm64/include/asm/arm_pmuv3.h
@@ -33,6 +33,14 @@ static inline void write_pmevtypern(int n, unsigned long val)
 	PMEVN_SWITCH(n, WRITE_PMEVTYPERN);
 }
 
+#define RETURN_READ_PMEVTYPERN(n) \
+	return read_sysreg(pmevtyper##n##_el0)
+static inline unsigned long read_pmevtypern(int n)
+{
+	PMEVN_SWITCH(n, RETURN_READ_PMEVTYPERN);
+	return 0;
+}
+
 static inline unsigned long read_pmmir(void)
 {
 	return read_cpuid(PMMIR_EL1);
@@ -96,6 +104,11 @@ static inline void write_pmccfiltr(u64 val)
 	write_sysreg(val, pmccfiltr_el0);
 }
 
+static inline u64 read_pmccfiltr(void)
+{
+	return read_sysreg(pmccfiltr_el0);
+}
+
 static inline void write_pmovsclr(u64 val)
 {
 	write_sysreg(val, pmovsclr_el0);
diff --git a/arch/arm64/kvm/pmu.c b/arch/arm64/kvm/pmu.c
index e633b4434c6a..01c9a9efdd1c 100644
--- a/arch/arm64/kvm/pmu.c
+++ b/arch/arm64/kvm/pmu.c
@@ -6,6 +6,8 @@
 #include <linux/kvm_host.h>
 #include <linux/perf_event.h>
 
+#include <asm/arm_pmuv3.h>
+
 static DEFINE_PER_CPU(struct kvm_pmu_events, kvm_pmu_events);
 
 /*
@@ -62,63 +64,16 @@ void kvm_clr_pmu_events(u64 clr)
 	pmu->events_guest &= ~clr;
 }
 
-#define PMEVTYPER_READ_CASE(idx)				\
-	case idx:						\
-		return read_sysreg(pmevtyper##idx##_el0)
-
-#define PMEVTYPER_WRITE_CASE(idx)				\
-	case idx:						\
-		write_sysreg(val, pmevtyper##idx##_el0);	\
-		break
-
-#define PMEVTYPER_CASES(readwrite)				\
-	PMEVTYPER_##readwrite##_CASE(0);			\
-	PMEVTYPER_##readwrite##_CASE(1);			\
-	PMEVTYPER_##readwrite##_CASE(2);			\
-	PMEVTYPER_##readwrite##_CASE(3);			\
-	PMEVTYPER_##readwrite##_CASE(4);			\
-	PMEVTYPER_##readwrite##_CASE(5);			\
-	PMEVTYPER_##readwrite##_CASE(6);			\
-	PMEVTYPER_##readwrite##_CASE(7);			\
-	PMEVTYPER_##readwrite##_CASE(8);			\
-	PMEVTYPER_##readwrite##_CASE(9);			\
-	PMEVTYPER_##readwrite##_CASE(10);			\
-	PMEVTYPER_##readwrite##_CASE(11);			\
-	PMEVTYPER_##readwrite##_CASE(12);			\
-	PMEVTYPER_##readwrite##_CASE(13);			\
-	PMEVTYPER_##readwrite##_CASE(14);			\
-	PMEVTYPER_##readwrite##_CASE(15);			\
-	PMEVTYPER_##readwrite##_CASE(16);			\
-	PMEVTYPER_##readwrite##_CASE(17);			\
-	PMEVTYPER_##readwrite##_CASE(18);			\
-	PMEVTYPER_##readwrite##_CASE(19);			\
-	PMEVTYPER_##readwrite##_CASE(20);			\
-	PMEVTYPER_##readwrite##_CASE(21);			\
-	PMEVTYPER_##readwrite##_CASE(22);			\
-	PMEVTYPER_##readwrite##_CASE(23);			\
-	PMEVTYPER_##readwrite##_CASE(24);			\
-	PMEVTYPER_##readwrite##_CASE(25);			\
-	PMEVTYPER_##readwrite##_CASE(26);			\
-	PMEVTYPER_##readwrite##_CASE(27);			\
-	PMEVTYPER_##readwrite##_CASE(28);			\
-	PMEVTYPER_##readwrite##_CASE(29);			\
-	PMEVTYPER_##readwrite##_CASE(30)
-
 /*
  * Read a value direct from PMEVTYPER<idx> where idx is 0-30
  * or PMCCFILTR_EL0 where idx is ARMV8_PMU_CYCLE_IDX (31).
  */
 static u64 kvm_vcpu_pmu_read_evtype_direct(int idx)
 {
-	switch (idx) {
-	PMEVTYPER_CASES(READ);
-	case ARMV8_PMU_CYCLE_IDX:
-		return read_sysreg(pmccfiltr_el0);
-	default:
-		WARN_ON(1);
-	}
+	if (idx == ARMV8_PMU_CYCLE_IDX)
+		return read_pmccfiltr();
 
-	return 0;
+	return read_pmevtypern(idx);
 }
 
 /*
@@ -127,14 +82,10 @@ static u64 kvm_vcpu_pmu_read_evtype_direct(int idx)
  */
 static void kvm_vcpu_pmu_write_evtype_direct(int idx, u32 val)
 {
-	switch (idx) {
-	PMEVTYPER_CASES(WRITE);
-	case ARMV8_PMU_CYCLE_IDX:
-		write_sysreg(val, pmccfiltr_el0);
-		break;
-	default:
-		WARN_ON(1);
-	}
+	if (idx == ARMV8_PMU_CYCLE_IDX)
+		write_pmccfiltr(val);
+	else
+		write_pmevtypern(idx, val);
 }
 
 /*

-- 
2.43.0

