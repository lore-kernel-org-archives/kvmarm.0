Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58935195809;
	Wed, 26 Jun 2024 22:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719441176; cv=none; b=IeBju64NNAR8MUla7xgisM0jOpo7oV4dVyY0N+sMFC2hWMyi4DO1VBRLqIoGtyhcwr7Mepsbc5XXzCEtUndpKoJBU3nDsSNAqyRBxI8s/R8JQBzswoqNOUXxq2assSQ6Lk4FC/MKE/pGfDbjNWviUao9A5K8ep6PRIqCK+LZK60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719441176; c=relaxed/simple;
	bh=gN/MFXnj2qBEeK1dho+d+UPANs8ipN08MmniFdK2cTg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=mNRQQmHB6bivhy/mQRqKfzD1/A/Z++3Bv1ZFb7M+KSPNa1rqCrCA95we9Z7mLDw9WOGlLZ7kVZJLHRGhDY442UZog95ew4z0KcHnIhPkp8DC+k0nLDNzCxrESs79DvPgfdcImFk6kmkaGsbW+c9e4Ddjt4RClZpcZvcN8+ZwKZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ebikUM8M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ebikUM8M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8759C2BD10;
	Wed, 26 Jun 2024 22:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719441175;
	bh=gN/MFXnj2qBEeK1dho+d+UPANs8ipN08MmniFdK2cTg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=ebikUM8M0WB+VeIrlPrZZ+N+l6y3sOowegAs5Lox6aLnRRpQtW85j2ENmlud+suji
	 8kRI8eJY2Ydtb96+gi2ig8DwzKTEMBpZ7sdyI+iKFpX3lWu9EbBzedYDOCF5hZ0Orv
	 9als6qjbCxECw5YHsyfaFH8xW8ri4klC88Zx1IYHVFcaHUMt9Cj4SDemgCliNbXFW3
	 /dqlOAWnSaYLJ0tP8WdADvcVi7svYy6J5x+NI+Z2PwUtPuE3tWDzCDMeomKBo5S027
	 8qS3/bSg9nimpjkAbt62IHzCkY0vUWlaW+nDk1Nwt2a0IaclNF1/p2+eJvwcEq9wyk
	 K2s3NMjDQh00A==
From: "Rob Herring (Arm)" <robh@kernel.org>
Date: Wed, 26 Jun 2024 16:32:35 -0600
Subject: [PATCH v2 11/12] KVM: arm64: Refine PMU defines for number of
 counters
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240626-arm-pmu-3-9-icntr-v2-11-c9784b4f4065@kernel.org>
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
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
---
 arch/arm64/kvm/pmu-emul.c      | 8 ++++----
 arch/arm64/kvm/pmu.c           | 5 +++--
 include/kvm/arm_pmu.h          | 3 ++-
 include/linux/perf/arm_pmuv3.h | 2 --
 4 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 69be070a9378..566a0e120306 100644
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

