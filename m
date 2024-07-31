Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5569A1BD503;
	Wed, 31 Jul 2024 16:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722444705; cv=none; b=shyqNr5l85qoM3a/kZ6LTjrMToX/98ZQkJKWc4yKfiVqYDcfRTMPB30677CA6hYQNHu3WO8xqdPactcz1tL4Yc8CzIYMMxBoVTWKhuH9oaEv0HIkaqr03+vz0Jhm2LjAKcLKrGEsm2yYbb9Sju5woduQwCRwnHIjr6OzmuI7EW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722444705; c=relaxed/simple;
	bh=7omlNIPbStXst6ZdrXlRO+SqyPWRwCBJjPEoqO2LLFk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=WuxJzPfcuTSeu61ecz6AKTJdE9y12A7cqLZOHHtzQh+hP6RUcvBIoL0shs5/KtWv+Q5NVOUU8RgGzeVz7omo9zKqq/+VqIJxQ2bNcqB1YdoBL3xGibcj1Z97b1gGqqDnWhF7vk4DO59YPwLJ2QrrmiKI8xzeXbv78AbCCLmzhwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aSfPkMct; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aSfPkMct"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAC2DC4AF09;
	Wed, 31 Jul 2024 16:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722444705;
	bh=7omlNIPbStXst6ZdrXlRO+SqyPWRwCBJjPEoqO2LLFk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=aSfPkMct/Jh3VSrA6Af0LgmM4Iuk2Kpfz5tB9cdHgrXXdCF2j6utDwI7uCY9y57qP
	 UgkZO4lSm5Zd+Ceu41MLyi7n64dZCJEy+6+knc+U0g+ZORdsjS+tmjTe6fo7cE5+ix
	 5XlLCbos0IY92JPih3rq9dJrCh62nxkCoJ8KNbS4grCR7UpIB7zODR8EAFQk7RLXi9
	 PM1+XOed59OlyFggj6wCz1iQV+u4i7GRbW9kPJqFuKMEMHRutCBVQQZX2nq2G0eadn
	 x3YpJHf84VfWKxGDOQlyGSB+TqxYvPJxcwDjcSV9nm7UquIAG3W1bTsWha7VPMMewY
	 s5yRjbdo50rlA==
From: "Rob Herring (Arm)" <robh@kernel.org>
Date: Wed, 31 Jul 2024 10:51:20 -0600
Subject: [PATCH v3 3/7] KVM: arm64: pmu: Use arm_pmuv3.h register accessors
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240731-arm-pmu-3-9-icntr-v3-3-280a8d7ff465@kernel.org>
References: <20240731-arm-pmu-3-9-icntr-v3-0-280a8d7ff465@kernel.org>
In-Reply-To: <20240731-arm-pmu-3-9-icntr-v3-0-280a8d7ff465@kernel.org>
To: Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Mark Rutland <mark.rutland@arm.com>, James Clark <james.clark@linaro.org>, 
 James Morse <james.morse@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
 Arnaldo Carvalho de Melo <acme@kernel.org>, 
 Namhyung Kim <namhyung@kernel.org>, 
 Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
 Adrian Hunter <adrian.hunter@intel.com>, 
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-perf-users@vger.kernel.org, kvmarm@lists.linux.dev
X-Mailer: b4 0.15-dev

Commit df29ddf4f04b ("arm64: perf: Abstract system register accesses
away") split off PMU register accessor functions to a standalone header.
Let's use it for KVM PMU code and get rid one copy of the ugly switch
macro.

Acked-by: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
---
v2:
 - Use linux/perf/arm_pmuv3.h include instead of asm/
---
 arch/arm64/include/asm/arm_pmuv3.h | 13 ++++++++
 arch/arm64/kvm/pmu.c               | 66 +++++---------------------------------
 2 files changed, 21 insertions(+), 58 deletions(-)

diff --git a/arch/arm64/include/asm/arm_pmuv3.h b/arch/arm64/include/asm/arm_pmuv3.h
index 19b3f9150058..36c3e82b4eec 100644
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
index e633b4434c6a..a47ae311d4a8 100644
--- a/arch/arm64/kvm/pmu.c
+++ b/arch/arm64/kvm/pmu.c
@@ -5,6 +5,7 @@
  */
 #include <linux/kvm_host.h>
 #include <linux/perf_event.h>
+#include <linux/perf/arm_pmuv3.h>
 
 static DEFINE_PER_CPU(struct kvm_pmu_events, kvm_pmu_events);
 
@@ -62,63 +63,16 @@ void kvm_clr_pmu_events(u64 clr)
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
@@ -127,14 +81,10 @@ static u64 kvm_vcpu_pmu_read_evtype_direct(int idx)
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

