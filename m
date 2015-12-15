From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v7 16/19] KVM: ARM64: Add PMU overflow interrupt routing
Date: Tue, 15 Dec 2015 15:19:53 +0000
Message-ID: <56702F99.8000905@arm.com>
References: <1450169379-12336-1-git-send-email-zhaoshenglong@huawei.com> <1450169379-12336-17-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1450169379-12336-17-git-send-email-zhaoshenglong@huawei.com>
Sender: kvm-owner@vger.kernel.org
To: Shannon Zhao <zhaoshenglong@huawei.com>, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, will.deacon@arm.com, alex.bennee@linaro.org, wei@redhat.com, cov@codeaurora.org, shannon.zhao@linaro.org, peter.huangpeng@huawei.com, hangaohuai@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

On 15/12/15 08:49, Shannon Zhao wrote:
> From: Shannon Zhao <shannon.zhao@linaro.org>
> 
> When calling perf_event_create_kernel_counter to create perf_event,
> assign a overflow handler. Then when the perf event overflows, set the
> corresponding bit of guest PMOVSSET register. If this counter is enabled
> and its interrupt is enabled as well, kick the vcpu to sync the
> interrupt.
> 
> On VM entry, if there is counter overflowed, inject the interrupt with
> the level set to 1. Otherwise, inject the interrupt with the level set
> to 0.
> 
> Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
> ---
>  arch/arm/kvm/arm.c    |  2 ++
>  include/kvm/arm_pmu.h |  2 ++
>  virt/kvm/arm/pmu.c    | 54 ++++++++++++++++++++++++++++++++++++++++++++++++++-
>  3 files changed, 57 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
> index e06fd29..cd696ef 100644
> --- a/arch/arm/kvm/arm.c
> +++ b/arch/arm/kvm/arm.c
> @@ -28,6 +28,7 @@
>  #include <linux/sched.h>
>  #include <linux/kvm.h>
>  #include <trace/events/kvm.h>
> +#include <kvm/arm_pmu.h>
>  
>  #define CREATE_TRACE_POINTS
>  #include "trace.h"
> @@ -569,6 +570,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  		 * non-preemptible context.
>  		 */
>  		preempt_disable();
> +		kvm_pmu_flush_hwstate(vcpu);
>  		kvm_timer_flush_hwstate(vcpu);
>  		kvm_vgic_flush_hwstate(vcpu);
>  
> diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
> index 25b5f98..732ccaf 100644
> --- a/include/kvm/arm_pmu.h
> +++ b/include/kvm/arm_pmu.h
> @@ -35,6 +35,7 @@ struct kvm_pmu {
>  	struct kvm_pmc pmc[ARMV8_MAX_COUNTERS];
>  };
>  
> +void kvm_pmu_flush_hwstate(struct kvm_vcpu *vcpu);
>  u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx);
>  void kvm_pmu_disable_counter(struct kvm_vcpu *vcpu, u64 val);
>  void kvm_pmu_enable_counter(struct kvm_vcpu *vcpu, u64 val);
> @@ -47,6 +48,7 @@ void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val);
>  struct kvm_pmu {
>  };
>  
> +void kvm_pmu_flush_hwstate(struct kvm_vcpu *vcpu) {}
>  u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx)
>  {
>  	return 0;
> diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
> index e664721..eff5b19 100644
> --- a/virt/kvm/arm/pmu.c
> +++ b/virt/kvm/arm/pmu.c
> @@ -21,6 +21,7 @@
>  #include <linux/perf_event.h>
>  #include <asm/kvm_emulate.h>
>  #include <kvm/arm_pmu.h>
> +#include <kvm/arm_vgic.h>
>  
>  /**
>   * kvm_pmu_get_counter_value - get PMU counter value
> @@ -75,6 +76,56 @@ static void kvm_pmu_stop_counter(struct kvm_vcpu *vcpu, struct kvm_pmc *pmc)
>  }
>  
>  /**
> + * kvm_pmu_flush_hwstate - flush pmu state to cpu
> + * @vcpu: The vcpu pointer
> + *
> + * Inject virtual PMU IRQ if IRQ is pending for this cpu.
> + */
> +void kvm_pmu_flush_hwstate(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_pmu *pmu = &vcpu->arch.pmu;
> +	u64 overflow;
> +
> +	if (pmu->irq_num == -1)
> +		return;
> +
> +	if (!(vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMCR_E))
> +		return;
> +
> +	overflow = vcpu_sys_reg(vcpu, PMCNTENSET_EL0)
> +		   & vcpu_sys_reg(vcpu, PMINTENSET_EL1)
> +		   & vcpu_sys_reg(vcpu, PMOVSSET_EL0);

You already have something similar to deal with enabling the overflow
interrupt. You may want to have a common helper.

> +
> +	kvm_vgic_inject_irq(vcpu->kvm, vcpu->vcpu_id, pmu->irq_num,
> +			    overflow ? 1 : 0);

nit: can also be written as !!overflow.

> +}
> +
> +static inline struct kvm_vcpu *kvm_pmc_to_vcpu(struct kvm_pmc *pmc)
> +{
> +	struct kvm_pmu *pmu;
> +	struct kvm_vcpu_arch *vcpu_arch;
> +
> +	pmc -= pmc->idx;
> +	pmu = container_of(pmc, struct kvm_pmu, pmc[0]);
> +	vcpu_arch = container_of(pmu, struct kvm_vcpu_arch, pmu);
> +	return container_of(vcpu_arch, struct kvm_vcpu, arch);
> +}
> +
> +/**
> + * When perf event overflows, call kvm_pmu_overflow_set to set overflow status.
> + */
> +static void kvm_pmu_perf_overflow(struct perf_event *perf_event,
> +				  struct perf_sample_data *data,
> +				  struct pt_regs *regs)
> +{
> +	struct kvm_pmc *pmc = perf_event->overflow_handler_context;
> +	struct kvm_vcpu *vcpu = kvm_pmc_to_vcpu(pmc);
> +	int idx = pmc->idx;
> +
> +	kvm_pmu_overflow_set(vcpu, BIT(idx));
> +}
> +
> +/**
>   * kvm_pmu_enable_counter - enable selected PMU counter
>   * @vcpu: The vcpu pointer
>   * @val: the value guest writes to PMCNTENSET register
> @@ -258,7 +309,8 @@ void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
>  	/* The initial sample period (overflow count) of an event. */
>  	attr.sample_period = (-counter) & pmc->bitmask;
>  
> -	event = perf_event_create_kernel_counter(&attr, -1, current, NULL, pmc);
> +	event = perf_event_create_kernel_counter(&attr, -1, current,
> +						 kvm_pmu_perf_overflow, pmc);
>  	if (IS_ERR(event)) {
>  		printk_once("kvm: pmu event creation failed %ld\n",
>  			    PTR_ERR(event));
> 

Thanks,
	
	M.
-- 
Jazz is not dead. It just smells funny...
