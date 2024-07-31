Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48FA11BE857;
	Wed, 31 Jul 2024 16:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722444710; cv=none; b=CcvKBKtnqXZAMJEoH07zkjT0YWJElmxeFvrLC3FvF6upS2jtpiBJdg/RLSNsy78JYV4X3ZlEumsiUh6vLLlpXsUI6D88v1KAyX35gX1HM8Cqfia+D+Zzg9VXuuZCgHyYxzV/BEEzTSA1OpyBcsHHya6QFrozcC1UOJcjZ5MqsTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722444710; c=relaxed/simple;
	bh=sN+E69Sud6EeT1BhEmoWX2EU0ff+4hzJ09gHXyXFt58=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=WjZAwJPz2Ch7r3WJzRpu21RVVMfPnDxgiRhJxmANdGjegimqkZsrmsGTWcCK77y5aRWWf1PYHC9VKX4pxDqh51Iwlz2A60jK6a5u0W9eyxAqI19pD9YJwqHgeo404L0qDSPaL/st0DkyYTrB/KmkCHli0im0GXM0exl/m3PiTCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IOcC4WMK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IOcC4WMK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9EC9C116B1;
	Wed, 31 Jul 2024 16:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722444709;
	bh=sN+E69Sud6EeT1BhEmoWX2EU0ff+4hzJ09gHXyXFt58=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=IOcC4WMKJ9gqOpJ/tIThyy4DZM3vEp9pQ7+SWXYvv4fgioYi+Sm0pOdDsSPBDXZUl
	 DZCzNHsrb2lPb5LrzV2M2DgUUdEaWnTFGOzesuwObfjL/yLwMAKTP/H1lwkT23ttch
	 HiVLU7d/yD/aflWyMOHfrCtmiAloQnZqVvPGUT811/gXn5TTIsqjCAqaGZZZCjAtjt
	 AFLg7VAhpCd0oH+vRkG99hRje2SfdvnkOErRgOK58myBenyNQtzppmxrKE1wVjNuNP
	 aErX3C3zYjBXLFqKBh+Ilch3P/Vl1DuhZOO5e7m+OMTC9F4ughtOfVxRG1jpPOoUpC
	 pipK77bqp3TAQ==
From: "Rob Herring (Arm)" <robh@kernel.org>
Date: Wed, 31 Jul 2024 10:51:23 -0600
Subject: [PATCH v3 6/7] KVM: arm64: Refine PMU defines for number of
 counters
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240731-arm-pmu-3-9-icntr-v3-6-280a8d7ff465@kernel.org>
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

There are 2 defines for the number of PMU counters:
ARMV8_PMU_MAX_COUNTERS and ARMPMU_MAX_HWEVENTS. Both are the same
currently, but Armv9.4/8.9 increases the number of possible counters
from 32 to 33. With this change, the maximum number of counters will
differ for KVM's PMU emulation which is PMUv3.4. Give KVM PMU emulation
its own define to decouple it from the rest of the kernel's number PMU
counters.

The VHE PMU code needs to match the PMU driver, so switch it to use
ARMPMU_MAX_HWEVENTS instead.

Acked-by: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
---
 arch/arm64/kvm/pmu-emul.c      | 8 ++++----
 arch/arm64/kvm/pmu.c           | 5 +++--
 include/kvm/arm_pmu.h          | 3 ++-
 include/linux/perf/arm_pmuv3.h | 2 --
 4 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 0e598f6c42c0..ac36c438b8c1 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -233,7 +233,7 @@ void kvm_pmu_vcpu_init(struct kvm_vcpu *vcpu)
 	int i;
 	struct kvm_pmu *pmu = &vcpu->arch.pmu;
 
-	for (i = 0; i < ARMV8_PMU_MAX_COUNTERS; i++)
+	for (i = 0; i < KVM_ARMV8_PMU_MAX_COUNTERS; i++)
 		pmu->pmc[i].idx = i;
 }
 
@@ -260,7 +260,7 @@ void kvm_pmu_vcpu_destroy(struct kvm_vcpu *vcpu)
 {
 	int i;
 
-	for (i = 0; i < ARMV8_PMU_MAX_COUNTERS; i++)
+	for (i = 0; i < KVM_ARMV8_PMU_MAX_COUNTERS; i++)
 		kvm_pmu_release_perf_event(kvm_vcpu_idx_to_pmc(vcpu, i));
 	irq_work_sync(&vcpu->arch.pmu.overflow_work);
 }
@@ -291,7 +291,7 @@ void kvm_pmu_enable_counter_mask(struct kvm_vcpu *vcpu, u64 val)
 	if (!(kvm_vcpu_read_pmcr(vcpu) & ARMV8_PMU_PMCR_E) || !val)
 		return;
 
-	for (i = 0; i < ARMV8_PMU_MAX_COUNTERS; i++) {
+	for (i = 0; i < KVM_ARMV8_PMU_MAX_COUNTERS; i++) {
 		struct kvm_pmc *pmc;
 
 		if (!(val & BIT(i)))
@@ -323,7 +323,7 @@ void kvm_pmu_disable_counter_mask(struct kvm_vcpu *vcpu, u64 val)
 	if (!kvm_vcpu_has_pmu(vcpu) || !val)
 		return;
 
-	for (i = 0; i < ARMV8_PMU_MAX_COUNTERS; i++) {
+	for (i = 0; i < KVM_ARMV8_PMU_MAX_COUNTERS; i++) {
 		struct kvm_pmc *pmc;
 
 		if (!(val & BIT(i)))
diff --git a/arch/arm64/kvm/pmu.c b/arch/arm64/kvm/pmu.c
index a47ae311d4a8..215b74875815 100644
--- a/arch/arm64/kvm/pmu.c
+++ b/arch/arm64/kvm/pmu.c
@@ -5,6 +5,7 @@
  */
 #include <linux/kvm_host.h>
 #include <linux/perf_event.h>
+#include <linux/perf/arm_pmu.h>
 #include <linux/perf/arm_pmuv3.h>
 
 static DEFINE_PER_CPU(struct kvm_pmu_events, kvm_pmu_events);
@@ -95,7 +96,7 @@ static void kvm_vcpu_pmu_enable_el0(unsigned long events)
 	u64 typer;
 	u32 counter;
 
-	for_each_set_bit(counter, &events, 32) {
+	for_each_set_bit(counter, &events, ARMPMU_MAX_HWEVENTS) {
 		typer = kvm_vcpu_pmu_read_evtype_direct(counter);
 		typer &= ~ARMV8_PMU_EXCLUDE_EL0;
 		kvm_vcpu_pmu_write_evtype_direct(counter, typer);
@@ -110,7 +111,7 @@ static void kvm_vcpu_pmu_disable_el0(unsigned long events)
 	u64 typer;
 	u32 counter;
 
-	for_each_set_bit(counter, &events, 32) {
+	for_each_set_bit(counter, &events, ARMPMU_MAX_HWEVENTS) {
 		typer = kvm_vcpu_pmu_read_evtype_direct(counter);
 		typer |= ARMV8_PMU_EXCLUDE_EL0;
 		kvm_vcpu_pmu_write_evtype_direct(counter, typer);
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 871067fb2616..e08aeec5d936 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -10,6 +10,7 @@
 #include <linux/perf_event.h>
 #include <linux/perf/arm_pmuv3.h>
 
+#define KVM_ARMV8_PMU_MAX_COUNTERS	32
 
 #if IS_ENABLED(CONFIG_HW_PERF_EVENTS) && IS_ENABLED(CONFIG_KVM)
 struct kvm_pmc {
@@ -25,7 +26,7 @@ struct kvm_pmu_events {
 struct kvm_pmu {
 	struct irq_work overflow_work;
 	struct kvm_pmu_events events;
-	struct kvm_pmc pmc[ARMV8_PMU_MAX_COUNTERS];
+	struct kvm_pmc pmc[KVM_ARMV8_PMU_MAX_COUNTERS];
 	int irq_num;
 	bool created;
 	bool irq_level;
diff --git a/include/linux/perf/arm_pmuv3.h b/include/linux/perf/arm_pmuv3.h
index f4ec76f725a3..4f7a7f2222e5 100644
--- a/include/linux/perf/arm_pmuv3.h
+++ b/include/linux/perf/arm_pmuv3.h
@@ -7,8 +7,6 @@
 #define __PERF_ARM_PMUV3_H
 
 #define ARMV8_PMU_MAX_GENERAL_COUNTERS	31
-#define ARMV8_PMU_MAX_COUNTERS	32
-
 #define ARMV8_PMU_CYCLE_IDX		31
 
 

-- 
2.43.0

