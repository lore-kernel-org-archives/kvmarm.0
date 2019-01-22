From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH 2/4] KVM: arm/arm64: re-create event when setting counter
 value
Date: Tue, 22 Jan 2019 14:18:17 +0000
Message-ID: <46fc9476-cff2-fd93-f5bb-237e26a2adc6@arm.com>
References: <1548154197-5470-1-git-send-email-andrew.murray@arm.com>
 <1548154197-5470-3-git-send-email-andrew.murray@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 015C34A39E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Jan 2019 09:16:31 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Zc0YzyqmgtTX for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Jan 2019 09:16:29 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A73194A382
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Jan 2019 09:16:29 -0500 (EST)
In-Reply-To: <1548154197-5470-3-git-send-email-andrew.murray@arm.com>
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
To: andrew.murray@arm.com, christoffer.dall@arm.com, marc.zyngier@arm.com
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Andrew

On 01/22/2019 10:49 AM, Andrew Murray wrote:
> The perf event sample_period is currently set based upon the current
> counter value, when PMXEVTYPER is written to and the perf event is created.
> However the user may choose to write the type before the counter value in
> which case sample_period will be set incorrectly. Let's instead decouple
> event creation from PMXEVTYPER and (re)create the event in either
> suitation.
> 
> Signed-off-by: Andrew Murray <andrew.murray@arm.com>

The approach looks fine to me. However this patch seems to introduce a
memory leak, see below, which you may be addressing in a later patch in 
the series. But this will affect bisecting issues.

> ---
>   virt/kvm/arm/pmu.c | 39 ++++++++++++++++++++++++++++++---------
>   1 file changed, 30 insertions(+), 9 deletions(-)
> 
> diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
> index 531d27f..4464899 100644
> --- a/virt/kvm/arm/pmu.c
> +++ b/virt/kvm/arm/pmu.c
> @@ -24,6 +24,8 @@
>   #include <kvm/arm_pmu.h>
>   #include <kvm/arm_vgic.h>
>   
> +static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 data,
> +				      u64 select_idx);

Could we just pass the counter index (i.e, select_idx) after updating
the event_type/counter value in the respective functions.

nit: If we decide not to do that, please rename "data" to something more
obvious, event_type.

>   /**
>    * kvm_pmu_get_counter_value - get PMU counter value
>    * @vcpu: The vcpu pointer
> @@ -57,11 +59,18 @@ u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx)
>    */
>   void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu, u64 select_idx, u64 val)
>   {
> -	u64 reg;
> +	u64 reg, data;

nit: Same here, data is too generic.

>   
>   	reg = (select_idx == ARMV8_PMU_CYCLE_IDX)
>   	      ? PMCCNTR_EL0 : PMEVCNTR0_EL0 + select_idx;
>   	__vcpu_sys_reg(vcpu, reg) += (s64)val - kvm_pmu_get_counter_value(vcpu, select_idx);
> +
> +	reg = (select_idx == ARMV8_PMU_CYCLE_IDX)
> +	      ? PMCCFILTR_EL0 : PMEVTYPER0_EL0 + select_idx;
> +	data = __vcpu_sys_reg(vcpu, reg + select_idx);
> +
> +	/* Recreate the perf event to reflect the updated sample_period */
> +	kvm_pmu_create_perf_event(vcpu, data, select_idx);
>   }
>   
>   /**
> @@ -380,17 +389,13 @@ static bool kvm_pmu_counter_is_enabled(struct kvm_vcpu *vcpu, u64 select_idx)
>   }
>   
>   /**
> - * kvm_pmu_set_counter_event_type - set selected counter to monitor some event
> + * kvm_pmu_create_perf_event - create a perf event for a counter
>    * @vcpu: The vcpu pointer
> - * @data: The data guest writes to PMXEVTYPER_EL0
> + * @data: Type of event as per PMXEVTYPER_EL0 format
>    * @select_idx: The number of selected counter
> - *
> - * When OS accesses PMXEVTYPER_EL0, that means it wants to set a PMC to count an
> - * event with given hardware event number. Here we call perf_event API to
> - * emulate this action and create a kernel perf event for it.
>    */
> -void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
> -				    u64 select_idx)
> +static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 data,
> +				      u64 select_idx)
>   {
>   	struct kvm_pmu *pmu = &vcpu->arch.pmu;
>   	struct kvm_pmc *pmc = &pmu->pmc[select_idx];
> @@ -433,6 +438,22 @@ void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
>   	pmc->perf_event = event;

We should release the existing perf_event to prevent a memory leak and
also a corruption in the data via the overflow handler for the existing
event. Am I missing something here ?

>   }
>   
> +/**
> + * kvm_pmu_set_counter_event_type - set selected counter to monitor some event
> + * @vcpu: The vcpu pointer
> + * @data: The data guest writes to PMXEVTYPER_EL0
> + * @select_idx: The number of selected counter
> + *
> + * When OS accesses PMXEVTYPER_EL0, that means it wants to set a PMC to count an
> + * event with given hardware event number. Here we call perf_event API to
> + * emulate this action and create a kernel perf event for it.
> + */
> +void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
> +				    u64 select_idx)
> +{
> +	kvm_pmu_create_perf_event(vcpu, data, select_idx);
> +}
> +
>   bool kvm_arm_support_pmu_v3(void)
>   {
>   	/*
> 


Cheers
Suzuki
