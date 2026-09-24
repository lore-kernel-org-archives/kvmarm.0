Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com [209.85.210.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 566754AA402
	for <kvmarm@lists.linux.dev>; Thu, 24 Sep 2026 17:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790270983; cv=none; b=kVf0dP6h/JEMNqtetjw+rDLXkbtkQOMPEjQhouvO+W13d+S9S+HXordRnlR9bAqIIdnPiRymttxbVr4u4cN60SIXGu8pR3vsfFqhFXJ4/z8NQWX003/z/CcEg7tpZS6Dugb51jBOFrwrdF3KfGJhvFsTkebFkm3rdQCok8H44Lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790270983; c=relaxed/simple;
	bh=ndX2bTgj05lDJBkO6BnV6pnilV2lxQA087PxTzOpATY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DT0JQ9PhmTYTQqZ1V0rx7EFOYcgSiA7V+j7qTHXTbB2qxESm2kGiFO1WtcjnJpUtJEFPDv6przYyCONnW/mUYHu4ltkGk4QsVl1Q5jy30cVbhTEFwSIW4PZtYQ9oHTRL86lJA6P/fukYbHuViNvobk+BnMxRFmux37QBvsyNrZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fPJ4VuQd; arc=none smtp.client-ip=209.85.210.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fPJ4VuQd"
Received: by mail-ot1-f71.google.com with SMTP id 46e09a7af769-809f1af7992so32130a34.3
        for <kvmarm@lists.linux.dev>; Thu, 24 Sep 2026 10:29:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790270978; x=1790875778; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5fTfJXevIcVMaStjHA01fBz3QdlqN/MDUGn0cPjroCY=;
        b=fPJ4VuQd5F/rlTIYJUwJykn0aRQTBZG/bhLH/nQfnJw5M5c+0WLyg+RF73voySBQj0
         mrBUKrMWK1dmanr+4Qi74tr8Nj/oTRYfzileOCdHD4ZWMoqfV77nodJ8pp2+RxvSrEi0
         uhOsmfexwn38EOdHXEsId130rbmDfZ+ITYcIQUXxKGPzSPvxWPLOVUlXfLF/Lo8eDpNJ
         UJ8YVQJz5PPdNrTLQEcE/+y1CPHAQoHA4iZk7c5HrTGlKpilKC2qa1gTOOWCJlWLNdlS
         2Gi83amxmlidW6z+zQtHBt+WtjtAvv6CSrtiT5qopP11Z7q5wy4z4UcaoQVddHMZAFC/
         62ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790270978; x=1790875778;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5fTfJXevIcVMaStjHA01fBz3QdlqN/MDUGn0cPjroCY=;
        b=smhuDkb4qtS4tsagRsIkapkZGPzes13zd22RX1QXWg62+qsQVeSCF1fSloliL5Z3LD
         C02WG/lDdKAW0d8U6EWX2an+OaWKMDpR6K5Y6YLyOa1fXoxXDGWY0yl1Iu5NgijGPb1U
         OWARto+sPMFoGcwWrbGGFo+o4a6kKKIb08mPRcJvFCeHtwOyv/Z3eiPloWAuNXy3hENn
         /K/TJtIPgojGow3Pz0eOkpeuj/UxgYk2mdv7YlT8nHT1kot+/CJtHKzajrDd+Y0InvIl
         bRZa5lRJNTPPk6Lz7WL8NNZvynMMGJBvxCM00oQegiJPTojSX/r4AXOyLGqw0+QO8y43
         EYsA==
X-Forwarded-Encrypted: i=1; AKwUvBzMZrbF/020xMmB4OSSvr1wecywZvGYTkMDRJaEib1nlCxm18kUfRQx3AcC3TMgxWjmRQA7tqs=@lists.linux.dev
X-Gm-Message-State: AFuF++nBqiDFsm0qyB9ebakmPKaYQpXM5wtHIp5T4DQhw7LgL749xVHL
	UxiRw1JPMugBXMAg/COVp5dyfvuYkTEv3GR/+FQLrLy+pf567YVTavMsuTOnhJDaJsp/b4Jx9jq
	l7qZbf/2SAmEd20EyKwLAp46AQQ==
X-Received: from iljw19.prod.google.com ([2002:a05:6e02:13f3:b0:509:7f67:8545])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:1927:b0:4d3:3e3e:8216 with SMTP id 5614622812f47-4d72c740173mr3310428b6e.25.1790270977551;
 Thu, 24 Sep 2026 10:29:37 -0700 (PDT)
Date: Thu, 24 Sep 2026 17:29:11 +0000
In-Reply-To: <20260924172928.2110956-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260924172928.2110956-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20260924172928.2110956-6-coltonlewis@google.com>
Subject: [PATCH v9 05/22] perf: arm_pmuv3: Move counter allocation mask to
 per-CPU struct pmu_hw_events
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Fuad Tabba <fuad.tabba@linux.dev>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	James Clark <james.clark@linaro.org>, Robin Murphy <robin.murphy@arm.com>, 
	Zide Chen <zide.chen@intel.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, Mingwei Zhang <mizhang@google.com>, 
	Jonathan Corbet <corbet@lwn.net>, Russell King <linux@armlinux.org.uk>, Shuah Khan <shuah@kernel.org>, 
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

In preparation for dynamic per-CPU PMU counter reservations when running
KVM guests with a partitioned PMU, move the counter allocation mask from
the global struct arm_pmu to per-CPU struct pmu_hw_events.

Initialize cpuc->cntr_mask from the static cpu_pmu->cntr_mask during PMU
probe and CPU hotplug startup, and update event counter allocation
helpers (armv8pmu_get_single_idx(), armv8pmu_get_chain_idx(), and
armv8pmu_get_event_idx()) to query the per-CPU mask.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 drivers/perf/arm_pmu.c       |  7 ++++++-
 drivers/perf/arm_pmuv3.c     | 18 +++++++++++++-----
 include/linux/perf/arm_pmu.h |  1 +
 3 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/drivers/perf/arm_pmu.c b/drivers/perf/arm_pmu.c
index 1150695653892..344adcd3521d0 100644
--- a/drivers/perf/arm_pmu.c
+++ b/drivers/perf/arm_pmu.c
@@ -408,9 +408,11 @@ validate_group(struct perf_event *event)
 
 	/*
 	 * Initialise the fake PMU. We only need to populate the
-	 * used_mask for the purposes of validation.
+	 * used_mask and cntr_mask for the purposes of validation.
 	 */
 	memset(&fake_pmu.used_mask, 0, sizeof(fake_pmu.used_mask));
+	bitmap_copy(fake_pmu.cntr_mask, to_arm_pmu(event->pmu)->cntr_mask,
+		    ARMPMU_MAX_HWEVENTS);
 
 	if (!validate_event(event->pmu, &fake_pmu, leader))
 		return -EINVAL;
@@ -717,6 +719,7 @@ bool arm_pmu_irq_is_nmi(void)
 static int arm_perf_starting_cpu(unsigned int cpu, struct hlist_node *node)
 {
 	struct arm_pmu *pmu = hlist_entry_safe(node, struct arm_pmu, node);
+	struct pmu_hw_events *cpuc = per_cpu_ptr(pmu->hw_events, cpu);
 	int irq;
 
 	if (!cpumask_test_cpu(cpu, &pmu->supported_cpus))
@@ -724,6 +727,8 @@ static int arm_perf_starting_cpu(unsigned int cpu, struct hlist_node *node)
 	if (pmu->reset)
 		pmu->reset(pmu);
 
+	bitmap_copy(cpuc->cntr_mask, pmu->cntr_mask, ARMPMU_MAX_HWEVENTS);
+
 	irq = armpmu_get_cpu_irq(pmu, cpu);
 	if (irq)
 		per_cpu(cpu_irq_ops, cpu)->enable_pmuirq(irq);
diff --git a/drivers/perf/arm_pmuv3.c b/drivers/perf/arm_pmuv3.c
index 4a6c1f3bcea1f..49289e5993dd7 100644
--- a/drivers/perf/arm_pmuv3.c
+++ b/drivers/perf/arm_pmuv3.c
@@ -813,7 +813,7 @@ static void armv8pmu_enable_user_access(struct arm_pmu *cpu_pmu)
 		write_pmuacr(mask);
 	} else {
 		/* Clear any unused counters to avoid leaking their contents */
-		for_each_andnot_bit(i, cpu_pmu->cntr_mask, cpuc->used_mask,
+		for_each_andnot_bit(i, cpuc->cntr_mask, cpuc->used_mask,
 				    ARMPMU_MAX_HWEVENTS) {
 			if (i == ARMV8_PMU_CYCLE_IDX)
 				write_pmccntr(0);
@@ -917,7 +917,7 @@ static irqreturn_t armv8pmu_handle_irq(struct arm_pmu *cpu_pmu)
 	 * to prevent skews in group events.
 	 */
 	armv8pmu_stop(cpu_pmu);
-	for_each_set_bit(idx, cpu_pmu->cntr_mask, ARMPMU_MAX_HWEVENTS) {
+	for_each_set_bit(idx, cpuc->cntr_mask, ARMPMU_MAX_HWEVENTS) {
 		struct perf_event *event = cpuc->events[idx];
 		struct hw_perf_event *hwc;
 
@@ -958,7 +958,7 @@ static int armv8pmu_get_single_idx(struct pmu_hw_events *cpuc,
 {
 	int idx;
 
-	for_each_set_bit(idx, cpu_pmu->cntr_mask, ARMV8_PMU_MAX_GENERAL_COUNTERS) {
+	for_each_set_bit(idx, cpuc->cntr_mask, ARMV8_PMU_MAX_GENERAL_COUNTERS) {
 		if (!test_and_set_bit(idx, cpuc->used_mask))
 			return idx;
 	}
@@ -974,7 +974,7 @@ static int armv8pmu_get_chain_idx(struct pmu_hw_events *cpuc,
 	 * Chaining requires two consecutive event counters, where
 	 * the lower idx must be even.
 	 */
-	for_each_set_bit(idx, cpu_pmu->cntr_mask, ARMV8_PMU_MAX_GENERAL_COUNTERS) {
+	for_each_set_bit(idx, cpuc->cntr_mask, ARMV8_PMU_MAX_GENERAL_COUNTERS) {
 		if (!(idx & 0x1))
 			continue;
 		if (!test_and_set_bit(idx, cpuc->used_mask)) {
@@ -1042,7 +1042,7 @@ static int armv8pmu_get_event_idx(struct pmu_hw_events *cpuc,
 	 */
 	if ((evtype == ARMV8_PMUV3_PERFCTR_INST_RETIRED) &&
 	    !armv8pmu_event_get_threshold(&event->attr) &&
-	    test_bit(ARMV8_PMU_INSTR_IDX, cpu_pmu->cntr_mask) &&
+	    test_bit(ARMV8_PMU_INSTR_IDX, cpuc->cntr_mask) &&
 	    !armv8pmu_event_want_user_access(event)) {
 		if (!test_and_set_bit(ARMV8_PMU_INSTR_IDX, cpuc->used_mask))
 			return ARMV8_PMU_INSTR_IDX;
@@ -1426,6 +1426,7 @@ static int armv8pmu_probe_pmu(struct arm_pmu *cpu_pmu)
 		.present = false,
 	};
 	int ret;
+	int cpu;
 
 	ret = smp_call_function_any(&cpu_pmu->supported_cpus,
 				    __armv8pmu_probe_pmu,
@@ -1441,6 +1442,13 @@ static int armv8pmu_probe_pmu(struct arm_pmu *cpu_pmu)
 		if (ret)
 			return ret;
 	}
+
+	for_each_possible_cpu(cpu) {
+		struct pmu_hw_events *cpuc = per_cpu_ptr(cpu_pmu->hw_events, cpu);
+
+		bitmap_copy(cpuc->cntr_mask, cpu_pmu->cntr_mask, ARMPMU_MAX_HWEVENTS);
+	}
+
 	return 0;
 }
 
diff --git a/include/linux/perf/arm_pmu.h b/include/linux/perf/arm_pmu.h
index 02d2c7f45b527..be1e345e99a77 100644
--- a/include/linux/perf/arm_pmu.h
+++ b/include/linux/perf/arm_pmu.h
@@ -62,6 +62,7 @@ struct pmu_hw_events {
 	 * an event. A 0 means that the counter can be used.
 	 */
 	DECLARE_BITMAP(used_mask, ARMPMU_MAX_HWEVENTS);
+	DECLARE_BITMAP(cntr_mask, ARMPMU_MAX_HWEVENTS);
 
 	/*
 	 * When using percpu IRQs, we need a percpu dev_id. Place it here as we
-- 
2.56.0.rc1.310.g51773c2048-goog

