From: Julien Thierry <julien.thierry@arm.com>
Subject: Re: [PATCH 3/4] KVM: arm/arm64: lazily create perf events on enable
Date: Tue, 22 Jan 2019 13:41:49 +0000
Message-ID: <a092da72-a1d3-2176-64e8-0316f2aeb299@arm.com>
References: <1548154197-5470-1-git-send-email-andrew.murray@arm.com>
 <1548154197-5470-4-git-send-email-andrew.murray@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C44A4A382
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Jan 2019 08:41:54 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TPY7HESt9ej4 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Jan 2019 08:41:53 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0AA6D4A32D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Jan 2019 08:41:52 -0500 (EST)
In-Reply-To: <1548154197-5470-4-git-send-email-andrew.murray@arm.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Murray <andrew.murray@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, Marc Zyngier <marc.zyngier@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Andrew,

On 22/01/2019 10:49, Andrew Murray wrote:
> To prevent re-creating perf events everytime the counter registers
> are changed, let's instead lazily create the event when the event
> is first enabled and destroy it when it changes.
> 
> Signed-off-by: Andrew Murray <andrew.murray@arm.com>
> ---
>  virt/kvm/arm/pmu.c | 114 ++++++++++++++++++++++++++++++++++++-----------------
>  1 file changed, 78 insertions(+), 36 deletions(-)
> 
> diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
> index 4464899..1921ca9 100644
> --- a/virt/kvm/arm/pmu.c
> +++ b/virt/kvm/arm/pmu.c
> @@ -24,8 +24,11 @@
>  #include <kvm/arm_pmu.h>
>  #include <kvm/arm_vgic.h>
>  
> -static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 data,
> -				      u64 select_idx);
> +static void kvm_pmu_reenable_enabled_single(struct kvm_vcpu *vcpu, u64 pair);
> +static void kvm_pmu_counter_create_enabled_perf_event(struct kvm_vcpu *vcpu,
> +						      u64 select_idx);
> +static void kvm_pmu_stop_counter(struct kvm_vcpu *vcpu, struct kvm_pmc *pmc);
> +
>  /**
>   * kvm_pmu_get_counter_value - get PMU counter value
>   * @vcpu: The vcpu pointer
> @@ -59,18 +62,16 @@ u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx)
>   */
>  void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu, u64 select_idx, u64 val)
>  {
> -	u64 reg, data;
> +	u64 reg;
> +	struct kvm_pmu *pmu = &vcpu->arch.pmu;
> +	struct kvm_pmc *pmc = &pmu->pmc[select_idx];
>  
>  	reg = (select_idx == ARMV8_PMU_CYCLE_IDX)
>  	      ? PMCCNTR_EL0 : PMEVCNTR0_EL0 + select_idx;
>  	__vcpu_sys_reg(vcpu, reg) += (s64)val - kvm_pmu_get_counter_value(vcpu, select_idx);
>  
> -	reg = (select_idx == ARMV8_PMU_CYCLE_IDX)
> -	      ? PMCCFILTR_EL0 : PMEVTYPER0_EL0 + select_idx;
> -	data = __vcpu_sys_reg(vcpu, reg + select_idx);
> -
> -	/* Recreate the perf event to reflect the updated sample_period */
> -	kvm_pmu_create_perf_event(vcpu, data, select_idx);
> +	kvm_pmu_stop_counter(vcpu, pmc);

Shouldn't this be before we do the write to __vcpu_sys_reg()?

> +	kvm_pmu_reenable_enabled_single(vcpu, select_idx);
>  }
>  
>  /**
> @@ -88,6 +89,7 @@ static void kvm_pmu_release_perf_event(struct kvm_pmc *pmc)
>  
>  /**
>   * kvm_pmu_stop_counter - stop PMU counter
> + * @vcpu: The vcpu pointer
>   * @pmc: The PMU counter pointer
>   *
>   * If this counter has been configured to monitor some event, release it here.
> @@ -150,6 +152,25 @@ u64 kvm_pmu_valid_counter_mask(struct kvm_vcpu *vcpu)
>  }
>  
>  /**
> + * kvm_pmu_enable_counter_single - create/enable a unpaired counter
> + * @vcpu: The vcpu pointer
> + * @select_idx: The counter index
> + */
> +static void kvm_pmu_enable_counter_single(struct kvm_vcpu *vcpu, u64 select_idx)
> +{
> +	struct kvm_pmu *pmu = &vcpu->arch.pmu;
> +	struct kvm_pmc *pmc = &pmu->pmc[select_idx];
> +
> +	if (!pmc->perf_event) {
> +		kvm_pmu_counter_create_enabled_perf_event(vcpu, select_idx);
> +	} else if (pmc->perf_event) {

"else" is enough here, no need for "else if" :) .


Actually, after we call kvm_pmu_counter_create_enabled_perf_event() we
know that pmc->perf_event != NULL.

Shouldn't we execute the code below unconditionally?

> +		perf_event_enable(pmc->perf_event);
> +		if (pmc->perf_event->state != PERF_EVENT_STATE_ACTIVE)
> +			kvm_debug("fail to enable perf event\n");
> +	}
> +}
> +
> +/**
>   * kvm_pmu_enable_counter - enable selected PMU counter
>   * @vcpu: The vcpu pointer
>   * @val: the value guest writes to PMCNTENSET register
> @@ -159,8 +180,6 @@ u64 kvm_pmu_valid_counter_mask(struct kvm_vcpu *vcpu)
>  void kvm_pmu_enable_counter(struct kvm_vcpu *vcpu, u64 val)
>  {
>  	int i;
> -	struct kvm_pmu *pmu = &vcpu->arch.pmu;
> -	struct kvm_pmc *pmc;
>  
>  	if (!(__vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMU_PMCR_E) || !val)
>  		return;
> @@ -169,16 +188,44 @@ void kvm_pmu_enable_counter(struct kvm_vcpu *vcpu, u64 val)
>  		if (!(val & BIT(i)))
>  			continue;
>  
> -		pmc = &pmu->pmc[i];
> -		if (pmc->perf_event) {
> -			perf_event_enable(pmc->perf_event);
> -			if (pmc->perf_event->state != PERF_EVENT_STATE_ACTIVE)
> -				kvm_debug("fail to enable perf event\n");
> -		}
> +		kvm_pmu_enable_counter_single(vcpu, i);
>  	}
>  }
>  
>  /**
> + * kvm_pmu_reenable_enabled_single - reenable a counter if it should be enabled
> + * @vcpu: The vcpu pointer
> + * @select_idx: The counter index
> + */
> +static void kvm_pmu_reenable_enabled_single(struct kvm_vcpu *vcpu,
> +					    u64 select_idx)

Not completely convinced by the name. kvm_pmu_sync_counter_status() ?

Or maybe have the callers check whether they actually need to
disable/enable and not have this function.

> +{
> +	u64 mask = kvm_pmu_valid_counter_mask(vcpu);
> +	u64 set = __vcpu_sys_reg(vcpu, PMCNTENSET_EL0) & mask;
> +
> +	if (!(__vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMU_PMCR_E))
> +		return;
> +
> +	if (set & BIT(select_idx))
> +		kvm_pmu_enable_counter_single(vcpu, select_idx);
> +}
> +
> +/**
> + * kvm_pmu_disable_counter - disable selected PMU counter
> + * @vcpu: The vcpu pointer
> + * @pmc: The counter to dissable
> + */
> +static void kvm_pmu_disable_counter_single(struct kvm_vcpu *vcpu,
> +					   u64 select_idx)
> +{
> +	struct kvm_pmu *pmu = &vcpu->arch.pmu;
> +	struct kvm_pmc *pmc = &pmu->pmc[select_idx];
> +
> +	if (pmc->perf_event)
> +		perf_event_disable(pmc->perf_event);
> +}
> +
> +/**
>   * kvm_pmu_disable_counter - disable selected PMU counter
>   * @vcpu: The vcpu pointer
>   * @val: the value guest writes to PMCNTENCLR register
> @@ -188,8 +235,6 @@ void kvm_pmu_enable_counter(struct kvm_vcpu *vcpu, u64 val)
>  void kvm_pmu_disable_counter(struct kvm_vcpu *vcpu, u64 val)
>  {
>  	int i;
> -	struct kvm_pmu *pmu = &vcpu->arch.pmu;
> -	struct kvm_pmc *pmc;
>  
>  	if (!val)
>  		return;
> @@ -198,9 +243,7 @@ void kvm_pmu_disable_counter(struct kvm_vcpu *vcpu, u64 val)
>  		if (!(val & BIT(i)))
>  			continue;
>  
> -		pmc = &pmu->pmc[i];
> -		if (pmc->perf_event)
> -			perf_event_disable(pmc->perf_event);
> +		kvm_pmu_disable_counter_single(vcpu, i);
>  	}
>  }
>  
> @@ -382,28 +425,22 @@ void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val)
>  	}
>  }
>  
> -static bool kvm_pmu_counter_is_enabled(struct kvm_vcpu *vcpu, u64 select_idx)
> -{
> -	return (__vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMU_PMCR_E) &&
> -	       (__vcpu_sys_reg(vcpu, PMCNTENSET_EL0) & BIT(select_idx));
> -}
> -
>  /**
> - * kvm_pmu_create_perf_event - create a perf event for a counter
> + * kvm_pmu_counter_create_enabled_perf_event - create a perf event for a counter
>   * @vcpu: The vcpu pointer
> - * @data: Type of event as per PMXEVTYPER_EL0 format
>   * @select_idx: The number of selected counter
>   */
> -static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 data,
> -				      u64 select_idx)
> +static void kvm_pmu_counter_create_enabled_perf_event(struct kvm_vcpu *vcpu,
> +						u64 select_idx)
>  {
>  	struct kvm_pmu *pmu = &vcpu->arch.pmu;
>  	struct kvm_pmc *pmc = &pmu->pmc[select_idx];
>  	struct perf_event *event;
>  	struct perf_event_attr attr;
> -	u64 eventsel, counter;
> +	u64 eventsel, counter, data;
> +
> +	data = __vcpu_sys_reg(vcpu, PMEVTYPER0_EL0 + select_idx);

Should we worry about the case select_idx == ARMV8_PMU_CYCLE_IDX?

>  
> -	kvm_pmu_stop_counter(vcpu, pmc);
>  	eventsel = data & ARMV8_PMU_EVTYPE_EVENT;
>  
>  	/* Software increment event does't need to be backed by a perf event */
> @@ -415,7 +452,6 @@ static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 data,
>  	attr.type = PERF_TYPE_RAW;
>  	attr.size = sizeof(attr);
>  	attr.pinned = 1;
> -	attr.disabled = !kvm_pmu_counter_is_enabled(vcpu, select_idx);
>  	attr.exclude_user = data & ARMV8_PMU_EXCLUDE_EL0 ? 1 : 0;
>  	attr.exclude_kernel = data & ARMV8_PMU_EXCLUDE_EL1 ? 1 : 0;
>  	attr.exclude_hv = 1; /* Don't count EL2 events */
> @@ -451,7 +487,13 @@ static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 data,
>  void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
>  				    u64 select_idx)
>  {
> -	kvm_pmu_create_perf_event(vcpu, data, select_idx);
> +	struct kvm_pmu *pmu = &vcpu->arch.pmu;
> +	struct kvm_pmc *pmc = &pmu->pmc[select_idx];
> +	u64 event_type = data & ARMV8_PMU_EVTYPE_MASK;
> +
> +	kvm_pmu_stop_counter(vcpu, pmc);
> +	__vcpu_sys_reg(vcpu, PMEVTYPER0_EL0 + select_idx) = event_type;

Why don't we take into account the select_idx == ARMV8_PMU_CYCLE_IDX
case into account anymore?

> +	kvm_pmu_reenable_enabled_single(vcpu, select_idx);
>  }
>  
>  bool kvm_arm_support_pmu_v3(void)
> 

Cheers,

-- 
Julien Thierry
