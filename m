Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EADAB15622F;
	Fri,  7 Jun 2024 20:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717792335; cv=none; b=IEdWtp5QoDQAR6jcPor0mthbxMip7t3WF4KI2snUALfUGHlqYvWCOEoruL8Mh/r6Lnay0xFIWs9miIO+7icGRBImrSNgeKKIbsYwpWNV3WAoUZUb8y7z7UaMMOMmmZTETy3GsM5gkXrUyJd+3FMZcvTnMmTD/eSUNcxe8eOfJf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717792335; c=relaxed/simple;
	bh=J5oFR+H4wsl5jwtJxa1F6XIK60SO7/dL0k4zTxfNnJU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ltnKHjhldY6/Qh2gfMTSxYelB7wE7JV740dxpWgsBZAnodwV67UeGa6HuyaztLsTEhdj5Q79n+w1aY3RG98wETHWIZhDElRy9eq7MARvLBWPkJe2ItJeXgaJu0YlWAhLoT9Bj8U0LZvZVFbr5tV4+jACplSPbrjpGG70XPDwcEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VZkQ9mCP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VZkQ9mCP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 068B7C4AF19;
	Fri,  7 Jun 2024 20:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717792334;
	bh=J5oFR+H4wsl5jwtJxa1F6XIK60SO7/dL0k4zTxfNnJU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=VZkQ9mCPELqch99bhj9fGm3AHA9lhMvD5G2GMqborXIHRQOSnKOohBKeQe3nnNCGk
	 hbBgxpgW1YZD/vPsJsYzRf3acBai3oJXjp/EXzlK+0jMyjKw8wxRjI4QisbCMgGACr
	 v63rYBo1pUbiWQkoUVGbc+mCKn6MzOiAJXNTv6W/Aywq4tvbzzyxKxnBqdNL/xr1zi
	 GT3Pk0cv7fGrbbL1Zm126O3YiwEqNWcX9WQk8vEqZ5KAZvOvRlg/fdlRrbJBA4wY6p
	 V7HZ0ysUBp53srbB+TDLHX40mNjcwnVwCQpRJKEpUvKoNXdRFhKDBYTYDeE5c6HX52
	 pRGOYADtk7f4A==
From: "Rob Herring (Arm)" <robh@kernel.org>
Date: Fri, 07 Jun 2024 14:31:33 -0600
Subject: [PATCH 8/9] KVM: arm64: Refine PMU defines for number of counters
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240607-arm-pmu-3-9-icntr-v1-8-c7bd2dceff3b@kernel.org>
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

There are 2 defines for the number of PMU counters:
ARMV8_PMU_MAX_COUNTERS and ARMPMU_MAX_HWEVENTS. Both are the same
currently, but Armv9.4/8.9 increases the number of possible counters
from 32 to 33. With this change, the maximum number of counters will
differ for KVM's PMU emulation which is PMUv3.4. Give KVM PMU emulation
its own define to decouple it from the rest of the kernel's number PMU
counters.

The VHE PMU code needs to match the PMU driver, so switch it to use
ARMPMU_MAX_HWEVENTS instead.

Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
---
 arch/arm64/kvm/pmu-emul.c      | 8 ++++----
 arch/arm64/kvm/pmu.c           | 5 +++--
 include/kvm/arm_pmu.h          | 3 ++-
 include/linux/perf/arm_pmuv3.h | 2 --
 4 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index da5ba9d061e8..77fe79b2ba04 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -234,7 +234,7 @@ void kvm_pmu_vcpu_init(struct kvm_vcpu *vcpu)
 	int i;
 	struct kvm_pmu *pmu = &vcpu->arch.pmu;
 
-	for (i = 0; i < ARMV8_PMU_MAX_COUNTERS; i++)
+	for (i = 0; i < KVM_ARMV8_PMU_MAX_COUNTERS; i++)
 		pmu->pmc[i].idx = i;
 }
 
@@ -261,7 +261,7 @@ void kvm_pmu_vcpu_destroy(struct kvm_vcpu *vcpu)
 {
 	int i;
 
-	for (i = 0; i < ARMV8_PMU_MAX_COUNTERS; i++)
+	for (i = 0; i < KVM_ARMV8_PMU_MAX_COUNTERS; i++)
 		kvm_pmu_release_perf_event(kvm_vcpu_idx_to_pmc(vcpu, i));
 	irq_work_sync(&vcpu->arch.pmu.overflow_work);
 }
@@ -292,7 +292,7 @@ void kvm_pmu_enable_counter_mask(struct kvm_vcpu *vcpu, u64 val)
 	if (!(kvm_vcpu_read_pmcr(vcpu) & ARMV8_PMU_PMCR_E) || !val)
 		return;
 
-	for (i = 0; i < ARMV8_PMU_MAX_COUNTERS; i++) {
+	for (i = 0; i < KVM_ARMV8_PMU_MAX_COUNTERS; i++) {
 		struct kvm_pmc *pmc;
 
 		if (!(val & BIT(i)))
@@ -324,7 +324,7 @@ void kvm_pmu_disable_counter_mask(struct kvm_vcpu *vcpu, u64 val)
 	if (!kvm_vcpu_has_pmu(vcpu) || !val)
 		return;
 
-	for (i = 0; i < ARMV8_PMU_MAX_COUNTERS; i++) {
+	for (i = 0; i < KVM_ARMV8_PMU_MAX_COUNTERS; i++) {
 		struct kvm_pmc *pmc;
 
 		if (!(val & BIT(i)))
diff --git a/arch/arm64/kvm/pmu.c b/arch/arm64/kvm/pmu.c
index 01c9a9efdd1c..7eaf5f7aeae9 100644
--- a/arch/arm64/kvm/pmu.c
+++ b/arch/arm64/kvm/pmu.c
@@ -5,6 +5,7 @@
  */
 #include <linux/kvm_host.h>
 #include <linux/perf_event.h>
+#include <linux/perf/arm_pmu.h>
 
 #include <asm/arm_pmuv3.h>
 
@@ -96,7 +97,7 @@ static void kvm_vcpu_pmu_enable_el0(unsigned long events)
 	u64 typer;
 	u32 counter;
 
-	for_each_set_bit(counter, &events, 32) {
+	for_each_set_bit(counter, &events, ARMPMU_MAX_HWEVENTS) {
 		typer = kvm_vcpu_pmu_read_evtype_direct(counter);
 		typer &= ~ARMV8_PMU_EXCLUDE_EL0;
 		kvm_vcpu_pmu_write_evtype_direct(counter, typer);
@@ -111,7 +112,7 @@ static void kvm_vcpu_pmu_disable_el0(unsigned long events)
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
index caa09241ad4f..c902fe64f070 100644
--- a/include/linux/perf/arm_pmuv3.h
+++ b/include/linux/perf/arm_pmuv3.h
@@ -6,8 +6,6 @@
 #ifndef __PERF_ARM_PMUV3_H
 #define __PERF_ARM_PMUV3_H
 
-#define ARMV8_PMU_MAX_COUNTERS	32
-
 /*
  * Common architectural and microarchitectural event numbers.
  */

-- 
2.43.0

