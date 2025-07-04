Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F6BB5234
	for <kvmarm@lists.linux.dev>; Fri,  4 Jul 2025 17:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751649520; cv=none; b=Li4bYW8L4okhk49kAd2l1SEAx4CVd7WvCt04xHqVYUsz4htNSkCSDGvUGW8kJDGDCFWhPstHj1PjrC9BxC5JoUeMzYJAATpJWaohbl82DVEKyoOx0lI8p41bMVzsKF13ceuSEhfA8grQN2/B2mgX52MTyx/qyng8q9gvL3vC25A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751649520; c=relaxed/simple;
	bh=UZHJqYOHm18Uamw3XtbJo38uYPi78jkn409gY7Lnw6E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lnAtTsl5pjUjcQ5ZGGd0O/S7SJ30ZN8FGBJy6FVMiVl2374V9LNMYhfVVIaRl4ZdGKcw0vOXCTMlcj6HyLGBIVnA9Hp/H3lZWlJEgqujWiOCaVkPVRXN2ErnWT0iAd6vR+/iVudOzUbGn8WEC8nHwtnUa71YCTQ1yz0w6ADKC7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EFE8B293B;
	Fri,  4 Jul 2025 10:18:22 -0700 (PDT)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1EB693F66E;
	Fri,  4 Jul 2025 10:18:30 -0700 (PDT)
Date: Fri, 4 Jul 2025 18:18:24 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: "Rob Herring (Arm)" <robh@kernel.org>, Will Deacon <will@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	James Clark <james.clark@linaro.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Leo Yan <leo.yan@arm.com>, linux-arm-kernel@lists.infradead.org,
	linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH v23 4/4] perf: arm_pmuv3: Add support for the Branch
 Record Buffer Extension (BRBE)
Message-ID: <aGgM4Pk5dU1LXd2I@J2N7QTR9R3>
References: <20250611-arm-brbe-v19-v23-0-e7775563036e@kernel.org>
 <20250611-arm-brbe-v19-v23-4-e7775563036e@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250611-arm-brbe-v19-v23-4-e7775563036e@kernel.org>

Hi Rob,

Thanks for this; I think this is in good shape now. There's a couple of
thing I think we should fixup, described below and diff provided at the
end of this mail. That aside I reckon we should apply this shortly.

Will, are you happy to apply that diff when picking this up?

On Wed, Jun 11, 2025 at 01:01:14PM -0500, Rob Herring (Arm) wrote:
> +/*
> + * BRBE is assumed to be disabled/paused on entry
> + */
> +void brbe_enable(const struct arm_pmu *arm_pmu)
> +{
> +	struct pmu_hw_events *cpuc = this_cpu_ptr(arm_pmu->hw_events);
> +	u64 brbfcr = 0, brbcr = 0;
> +
> +	/*
> +	 * Merge the permitted branch filters of all events.
> +	 */
> +	for (int i = 0; i < ARMPMU_MAX_HWEVENTS; i++) {
> +		struct perf_event *event = cpuc->events[i];
> +
> +		if (event && has_branch_stack(event)) {
> +			brbfcr |= event->hw.branch_reg.config;
> +			brbcr |= event->hw.extra_reg.config;
> +		}
> +	}

I see that in v20 you moved the brbe_invaliate() form here into 
brbe_read_filtered_entries(), when entries are read upon an event
overflowing. The changelog says:

| Rework BRBE invalidation to avoid invalidating in interrupt handler
| when no handled events capture the branch stack (i.e. when there are
| multiple users).

I don't think that's quite right. Since BRBCR_ELx.FZP causes a freeze
BRBFCR_EL1.PAUSE to be set when *any* event overflows, not discarding
across an overflow or other transient disable/enable can introduce a
discontinuity in the branch records.

The rationale for doing the invalidation here was to avoid the
possiblity of any such discontinuity, and to do so simply, at the cost
of discarding records in some cases where we could theoretically keep
them around.

I would prefer the invalidate to be performed within brbe_enable()
(before the actual enable/unpause), and for armv8pmu_restart() to be
folded back into armv8pmu_start().

I've provided a diff/fixup at the end of this reply.

[...]

> +void brbe_read_filtered_entries(struct perf_branch_stack *branch_stack,
> +				const struct perf_event *event)
> +{
> +	struct arm_pmu *cpu_pmu = to_arm_pmu(event->pmu);
> +	int nr_hw = brbe_num_branch_records(cpu_pmu);
> +	int nr_banks = DIV_ROUND_UP(nr_hw, BRBE_BANK_MAX_ENTRIES);
> +	int nr_filtered = 0;
> +	u64 branch_sample_type = event->attr.branch_sample_type;
> +	DECLARE_BITMAP(event_type_mask, PERF_BR_ARM64_MAX);
> +
> +	prepare_event_branch_type_mask(branch_sample_type, event_type_mask);
> +
> +	for (int bank = 0; bank < nr_banks; bank++) {
> +		int nr_remaining = nr_hw - (bank * BRBE_BANK_MAX_ENTRIES);
> +		int nr_this_bank = min(nr_remaining, BRBE_BANK_MAX_ENTRIES);
> +
> +		select_brbe_bank(bank);
> +
> +		for (int i = 0; i < nr_this_bank; i++) {
> +			struct perf_branch_entry *pbe = &branch_stack->entries[nr_filtered];
> +
> +			if (!perf_entry_from_brbe_regset(i, pbe, event))
> +				goto done;
> +
> +			if (!filter_branch_record(pbe, branch_sample_type, event_type_mask))
> +				continue;
> +
> +			nr_filtered++;
> +		}
> +	}
> +
> +done:
> +	brbe_invalidate();
> +	branch_stack->nr = nr_filtered;
> +}

As above, I don't think the brbe_invalidate() call should be here.

In addition to the problem above, placing the invalidate here means that
when multiple branch stack events overflow, only the first event will
receive branch records, and the other events will not receieve any.

[...]

>  /*
> @@ -806,9 +833,10 @@ static void armv8pmu_disable_event(struct perf_event *event)
>  	armv8pmu_disable_event_irq(event);
>  }
>  
> -static void armv8pmu_start(struct arm_pmu *cpu_pmu)
> +static void armv8pmu_restart(struct arm_pmu *cpu_pmu)
>  {
>  	struct perf_event_context *ctx;
> +	struct pmu_hw_events *hw_events = this_cpu_ptr(cpu_pmu->hw_events);
>  	int nr_user = 0;
>  
>  	ctx = perf_cpu_task_ctx();
> @@ -822,16 +850,44 @@ static void armv8pmu_start(struct arm_pmu *cpu_pmu)
>  
>  	kvm_vcpu_pmu_resync_el0();
>  
> +	if (hw_events->branch_users)
> +		brbe_enable(cpu_pmu);
> +
>  	/* Enable all counters */
>  	armv8pmu_pmcr_write(armv8pmu_pmcr_read() | ARMV8_PMU_PMCR_E);
>  }
>  
> +static void armv8pmu_start(struct arm_pmu *cpu_pmu)
> +{
> +	struct pmu_hw_events *hw_events = this_cpu_ptr(cpu_pmu->hw_events);
> +
> +	if (hw_events->branch_users)
> +		brbe_invalidate();
> +
> +	armv8pmu_restart(cpu_pmu);
> +}

As above, I think these should be folded back together, and the call to
brbe_invalidate() removed, as it'd be implicit in brbe_enable().

[...]

> @@ -882,6 +938,13 @@ static irqreturn_t armv8pmu_handle_irq(struct arm_pmu *cpu_pmu)
>  		if (!armpmu_event_set_period(event))
>  			continue;
>  
> +		/*
> +		 * PMU IRQ should remain asserted until all branch records
> +		 * are captured and processed into struct perf_sample_data.
> +		 */
> +		if (has_branch_stack(event))
> +			read_branch_records(cpuc, event, &data);

I realsie you inherited this, but that comment is both not true and
irrelevant, so we should delete it. I've done so in the fixup below.

Mark

---->8----
diff --git a/drivers/perf/arm_brbe.c b/drivers/perf/arm_brbe.c
index acdde61a85591..4792b3ce7cd00 100644
--- a/drivers/perf/arm_brbe.c
+++ b/drivers/perf/arm_brbe.c
@@ -496,6 +496,12 @@ void brbe_enable(const struct arm_pmu *arm_pmu)
 	struct pmu_hw_events *cpuc = this_cpu_ptr(arm_pmu->hw_events);
 	u64 brbfcr = 0, brbcr = 0;
 
+	/*
+	 * Discard existing records to avoid a discontinuity, e.g. records
+	 * missed during handling an overflow.
+	 */
+	brbe_invalidate();
+
 	/*
 	 * Merge the permitted branch filters of all events.
 	 */
@@ -793,6 +799,5 @@ void brbe_read_filtered_entries(struct perf_branch_stack *branch_stack,
 	}
 
 done:
-	brbe_invalidate();
 	branch_stack->nr = nr_filtered;
 }
diff --git a/drivers/perf/arm_pmuv3.c b/drivers/perf/arm_pmuv3.c
index 256c5ee8709c2..f6d7bab5d555c 100644
--- a/drivers/perf/arm_pmuv3.c
+++ b/drivers/perf/arm_pmuv3.c
@@ -833,7 +833,7 @@ static void armv8pmu_disable_event(struct perf_event *event)
 	armv8pmu_disable_event_irq(event);
 }
 
-static void armv8pmu_restart(struct arm_pmu *cpu_pmu)
+static void armv8pmu_start(struct arm_pmu *cpu_pmu)
 {
 	struct perf_event_context *ctx;
 	struct pmu_hw_events *hw_events = this_cpu_ptr(cpu_pmu->hw_events);
@@ -857,16 +857,6 @@ static void armv8pmu_restart(struct arm_pmu *cpu_pmu)
 	armv8pmu_pmcr_write(armv8pmu_pmcr_read() | ARMV8_PMU_PMCR_E);
 }
 
-static void armv8pmu_start(struct arm_pmu *cpu_pmu)
-{
-	struct pmu_hw_events *hw_events = this_cpu_ptr(cpu_pmu->hw_events);
-
-	if (hw_events->branch_users)
-		brbe_invalidate();
-
-	armv8pmu_restart(cpu_pmu);
-}
-
 static void armv8pmu_stop(struct arm_pmu *cpu_pmu)
 {
 	struct pmu_hw_events *hw_events = this_cpu_ptr(cpu_pmu->hw_events);
@@ -938,10 +928,6 @@ static irqreturn_t armv8pmu_handle_irq(struct arm_pmu *cpu_pmu)
 		if (!armpmu_event_set_period(event))
 			continue;
 
-		/*
-		 * PMU IRQ should remain asserted until all branch records
-		 * are captured and processed into struct perf_sample_data.
-		 */
 		if (has_branch_stack(event))
 			read_branch_records(cpuc, event, &data);
 
@@ -952,7 +938,7 @@ static irqreturn_t armv8pmu_handle_irq(struct arm_pmu *cpu_pmu)
 		 */
 		perf_event_overflow(event, &data, regs);
 	}
-	armv8pmu_restart(cpu_pmu);
+	armv8pmu_start(cpu_pmu);
 
 	return IRQ_HANDLED;
 }
