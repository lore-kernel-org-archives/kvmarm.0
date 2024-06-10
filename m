Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DE5180C15
	for <kvmarm@lists.linux.dev>; Mon, 10 Jun 2024 11:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718018836; cv=none; b=FaF+sDjq61LQnsWMfB1KY3tv1qjAXxUoK5FhS45zf/rJwWJBsYIRXyucqY03cl32SZE49bAuVqcGaWP3/zhikhWXJ9XWeWG41KHT9J/sopvnnaRqDNkK3wWquCjw4tPGuKkEpOrby0x/0SJNhJGtvi95ykAxsV9KViSELtpBaAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718018836; c=relaxed/simple;
	bh=03MGQVx6wqU2Johg8pU7ba0ssXDA3nSKTmKKEJaCTmQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tUnGTEhNS5azk3uRqOUQatYFNlrLs4CKk+zyfG5d0ojfUyU2guuTvM2No/HFy0VWxbheBKJbrWFjh5fe7XYps1VPYNi4mFVB+JR2OAYL6JH7qo5ocPAu0N5tjC+1qNDFnL5IA+ZAAYfggaV8dh2UUB6uhZhWJpz/nN8u9s1SJ4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3BFAE12FC;
	Mon, 10 Jun 2024 04:27:38 -0700 (PDT)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 61BC63F73B;
	Mon, 10 Jun 2024 04:27:10 -0700 (PDT)
Date: Mon, 10 Jun 2024 12:27:07 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: "Rob Herring (Arm)" <robh@kernel.org>
Cc: Russell King <linux@armlinux.org.uk>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH 8/9] KVM: arm64: Refine PMU defines for number of counters
Message-ID: <ZmbjC9ILkHBIuCNI@J2N7QTR9R3>
References: <20240607-arm-pmu-3-9-icntr-v1-0-c7bd2dceff3b@kernel.org>
 <20240607-arm-pmu-3-9-icntr-v1-8-c7bd2dceff3b@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240607-arm-pmu-3-9-icntr-v1-8-c7bd2dceff3b@kernel.org>

On Fri, Jun 07, 2024 at 02:31:33PM -0600, Rob Herring (Arm) wrote:
> There are 2 defines for the number of PMU counters:
> ARMV8_PMU_MAX_COUNTERS and ARMPMU_MAX_HWEVENTS. Both are the same
> currently, but Armv9.4/8.9 increases the number of possible counters
> from 32 to 33. With this change, the maximum number of counters will
> differ for KVM's PMU emulation which is PMUv3.4. Give KVM PMU emulation
> its own define to decouple it from the rest of the kernel's number PMU
> counters.
> 
> The VHE PMU code needs to match the PMU driver, so switch it to use
> ARMPMU_MAX_HWEVENTS instead.
> 
> Signed-off-by: Rob Herring (Arm) <robh@kernel.org>

Acked-by: Mark Rutland <mark.rutland@arm.com>

Mark.

> ---
>  arch/arm64/kvm/pmu-emul.c      | 8 ++++----
>  arch/arm64/kvm/pmu.c           | 5 +++--
>  include/kvm/arm_pmu.h          | 3 ++-
>  include/linux/perf/arm_pmuv3.h | 2 --
>  4 files changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> index da5ba9d061e8..77fe79b2ba04 100644
> --- a/arch/arm64/kvm/pmu-emul.c
> +++ b/arch/arm64/kvm/pmu-emul.c
> @@ -234,7 +234,7 @@ void kvm_pmu_vcpu_init(struct kvm_vcpu *vcpu)
>  	int i;
>  	struct kvm_pmu *pmu = &vcpu->arch.pmu;
>  
> -	for (i = 0; i < ARMV8_PMU_MAX_COUNTERS; i++)
> +	for (i = 0; i < KVM_ARMV8_PMU_MAX_COUNTERS; i++)
>  		pmu->pmc[i].idx = i;
>  }
>  
> @@ -261,7 +261,7 @@ void kvm_pmu_vcpu_destroy(struct kvm_vcpu *vcpu)
>  {
>  	int i;
>  
> -	for (i = 0; i < ARMV8_PMU_MAX_COUNTERS; i++)
> +	for (i = 0; i < KVM_ARMV8_PMU_MAX_COUNTERS; i++)
>  		kvm_pmu_release_perf_event(kvm_vcpu_idx_to_pmc(vcpu, i));
>  	irq_work_sync(&vcpu->arch.pmu.overflow_work);
>  }
> @@ -292,7 +292,7 @@ void kvm_pmu_enable_counter_mask(struct kvm_vcpu *vcpu, u64 val)
>  	if (!(kvm_vcpu_read_pmcr(vcpu) & ARMV8_PMU_PMCR_E) || !val)
>  		return;
>  
> -	for (i = 0; i < ARMV8_PMU_MAX_COUNTERS; i++) {
> +	for (i = 0; i < KVM_ARMV8_PMU_MAX_COUNTERS; i++) {
>  		struct kvm_pmc *pmc;
>  
>  		if (!(val & BIT(i)))
> @@ -324,7 +324,7 @@ void kvm_pmu_disable_counter_mask(struct kvm_vcpu *vcpu, u64 val)
>  	if (!kvm_vcpu_has_pmu(vcpu) || !val)
>  		return;
>  
> -	for (i = 0; i < ARMV8_PMU_MAX_COUNTERS; i++) {
> +	for (i = 0; i < KVM_ARMV8_PMU_MAX_COUNTERS; i++) {
>  		struct kvm_pmc *pmc;
>  
>  		if (!(val & BIT(i)))
> diff --git a/arch/arm64/kvm/pmu.c b/arch/arm64/kvm/pmu.c
> index 01c9a9efdd1c..7eaf5f7aeae9 100644
> --- a/arch/arm64/kvm/pmu.c
> +++ b/arch/arm64/kvm/pmu.c
> @@ -5,6 +5,7 @@
>   */
>  #include <linux/kvm_host.h>
>  #include <linux/perf_event.h>
> +#include <linux/perf/arm_pmu.h>
>  
>  #include <asm/arm_pmuv3.h>
>  
> @@ -96,7 +97,7 @@ static void kvm_vcpu_pmu_enable_el0(unsigned long events)
>  	u64 typer;
>  	u32 counter;
>  
> -	for_each_set_bit(counter, &events, 32) {
> +	for_each_set_bit(counter, &events, ARMPMU_MAX_HWEVENTS) {
>  		typer = kvm_vcpu_pmu_read_evtype_direct(counter);
>  		typer &= ~ARMV8_PMU_EXCLUDE_EL0;
>  		kvm_vcpu_pmu_write_evtype_direct(counter, typer);
> @@ -111,7 +112,7 @@ static void kvm_vcpu_pmu_disable_el0(unsigned long events)
>  	u64 typer;
>  	u32 counter;
>  
> -	for_each_set_bit(counter, &events, 32) {
> +	for_each_set_bit(counter, &events, ARMPMU_MAX_HWEVENTS) {
>  		typer = kvm_vcpu_pmu_read_evtype_direct(counter);
>  		typer |= ARMV8_PMU_EXCLUDE_EL0;
>  		kvm_vcpu_pmu_write_evtype_direct(counter, typer);
> diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
> index 871067fb2616..e08aeec5d936 100644
> --- a/include/kvm/arm_pmu.h
> +++ b/include/kvm/arm_pmu.h
> @@ -10,6 +10,7 @@
>  #include <linux/perf_event.h>
>  #include <linux/perf/arm_pmuv3.h>
>  
> +#define KVM_ARMV8_PMU_MAX_COUNTERS	32
>  
>  #if IS_ENABLED(CONFIG_HW_PERF_EVENTS) && IS_ENABLED(CONFIG_KVM)
>  struct kvm_pmc {
> @@ -25,7 +26,7 @@ struct kvm_pmu_events {
>  struct kvm_pmu {
>  	struct irq_work overflow_work;
>  	struct kvm_pmu_events events;
> -	struct kvm_pmc pmc[ARMV8_PMU_MAX_COUNTERS];
> +	struct kvm_pmc pmc[KVM_ARMV8_PMU_MAX_COUNTERS];
>  	int irq_num;
>  	bool created;
>  	bool irq_level;
> diff --git a/include/linux/perf/arm_pmuv3.h b/include/linux/perf/arm_pmuv3.h
> index caa09241ad4f..c902fe64f070 100644
> --- a/include/linux/perf/arm_pmuv3.h
> +++ b/include/linux/perf/arm_pmuv3.h
> @@ -6,8 +6,6 @@
>  #ifndef __PERF_ARM_PMUV3_H
>  #define __PERF_ARM_PMUV3_H
>  
> -#define ARMV8_PMU_MAX_COUNTERS	32
> -
>  /*
>   * Common architectural and microarchitectural event numbers.
>   */
> 
> -- 
> 2.43.0
> 
