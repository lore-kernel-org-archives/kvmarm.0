From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 17/18] KVM: ARM64: Add PMU overflow interrupt routing
Date: Fri, 17 Jul 2015 17:28:42 +0200
Message-ID: <20150717152842.GB14024@cbox>
References: <1436149068-3784-1-git-send-email-shannon.zhao@linaro.org>
 <1436149068-3784-18-git-send-email-shannon.zhao@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1436149068-3784-18-git-send-email-shannon.zhao@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: shannon.zhao@linaro.org
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, will.deacon@arm.com, marc.zyngier@arm.com, alex.bennee@linaro.org, zhaoshenglong@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jul 06, 2015 at 10:17:47AM +0800, shannon.zhao@linaro.org wrote:
> From: Shannon Zhao <shannon.zhao@linaro.org>
> 
> When calling perf_event_create_kernel_counter to create perf_event,
> assign a overflow handler. Then when perf event overflows, if vcpu
> doesn't run, call irq_work_queue to wake up vcpu. Otherwise call
> kvm_vgic_inject_irq to inject the interrupt.
> 
> Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
> ---
>  arch/arm/kvm/arm.c    |  2 ++
>  include/kvm/arm_pmu.h |  2 ++
>  virt/kvm/arm/pmu.c    | 53 ++++++++++++++++++++++++++++++++++++++++++++++++++-
>  3 files changed, 56 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
> index 4e82625..41eb063 100644
> --- a/arch/arm/kvm/arm.c
> +++ b/arch/arm/kvm/arm.c
> @@ -551,6 +551,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  			preempt_enable();
>  			kvm_timer_sync_hwstate(vcpu);
>  			kvm_vgic_sync_hwstate(vcpu);
> +			kvm_pmu_sync_hwstate(vcpu);
>  			continue;
>  		}
>  
> @@ -595,6 +596,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  
>  		kvm_timer_sync_hwstate(vcpu);
>  		kvm_vgic_sync_hwstate(vcpu);
> +		kvm_pmu_sync_hwstate(vcpu);
>  
>  		ret = handle_exit(vcpu, run, ret);
>  	}
> diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
> index 6985809..5bcf27b 100644
> --- a/include/kvm/arm_pmu.h
> +++ b/include/kvm/arm_pmu.h
> @@ -45,6 +45,7 @@ struct kvm_pmu {
>  };
>  
>  #ifdef CONFIG_KVM_ARM_PMU
> +void kvm_pmu_sync_hwstate(struct kvm_vcpu *vcpu);
>  void kvm_pmu_vcpu_reset(struct kvm_vcpu *vcpu);
>  void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu, unsigned long select_idx,
>  			       unsigned long val);
> @@ -59,6 +60,7 @@ void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, unsigned long data,
>  				    unsigned long select_idx);
>  void kvm_pmu_init(struct kvm_vcpu *vcpu);
>  #else
> +void kvm_pmu_sync_hwstate(struct kvm_vcpu *vcpu) {}
>  static inline void kvm_pmu_vcpu_reset(struct kvm_vcpu *vcpu) {}
>  void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu, unsigned long select_idx,
>  			       unsigned long val) {}
> diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
> index e655426..f957b85 100644
> --- a/virt/kvm/arm/pmu.c
> +++ b/virt/kvm/arm/pmu.c
> @@ -20,6 +20,7 @@
>  #include <linux/kvm_host.h>
>  #include <linux/perf_event.h>
>  #include <kvm/arm_pmu.h>
> +#include <kvm/arm_vgic.h>
>  
>  /* PMU HW events mapping. */
>  static struct kvm_pmu_hw_event_map {
> @@ -81,6 +82,23 @@ static void kvm_pmu_stop_counter(struct kvm_vcpu *vcpu,
>  }
>  
>  /**
> + * kvm_pmu_sync_hwstate - sync pmu state for cpu
> + * @vcpu: The vcpu pointer
> + *
> + * Inject virtual PMU IRQ if IRQ is pending for this cpu.
> + */
> +void kvm_pmu_sync_hwstate(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_pmu *pmu = &vcpu->arch.pmu;
> +
> +	if (pmu->irq_pending) {
> +		kvm_vgic_inject_irq(vcpu->kvm, vcpu->vcpu_id, pmu->irq_num, 1);

don't you need to check if irq_num is set all these places where you use
it, somehow?

> +		pmu->irq_pending = 0;
> +		return;
> +	}
> +}

I'm not sure I understand why this function is needed at this point in
the first place.  Why don't we just inject the interrupt when the
overflow happens?

I'm also not completely clear on the relationship between when the
physical counter overflows and when the virtual one does - do we always
keep that in sync somehow?  (this may relate to one of my questions
in one of the previous patches).


> +
> +/**
>   * kvm_pmu_vcpu_reset - reset pmu state for cpu
>   * @vcpu: The vcpu pointer
>   *
> @@ -96,6 +114,37 @@ void kvm_pmu_vcpu_reset(struct kvm_vcpu *vcpu)
>  	pmu->irq_pending = false;
>  }
>  
> +static void kvm_pum_trigger_pmi(struct irq_work *irq_work)
> +{
> +	struct kvm_pmu *pmu = container_of(irq_work, struct kvm_pmu, irq_work);
> +	struct kvm_vcpu *vcpu = container_of(pmu, struct kvm_vcpu, arch.pmu);
> +
> +	kvm_vgic_inject_irq(vcpu->kvm, vcpu->vcpu_id, pmu->irq_num, 1);
> +}
> +
> +/**
> + * When perf event overflows, if vcpu doesn't run, call irq_work_queue to wake
> + * up vcpu. Otherwise call kvm_vgic_inject_irq to inject the interrupt.
> + */
> +static void kvm_pmu_perf_overflow(struct perf_event *perf_event,
> +				  struct perf_sample_data *data,
> +				  struct pt_regs *regs)
> +{
> +	struct kvm_pmc *pmc = perf_event->overflow_handler_context;
> +	struct kvm_vcpu *vcpu = pmc->vcpu;
> +	struct kvm_pmu *pmu = &vcpu->arch.pmu;
> +
> +	if (pmc->interrupt == true) {
> +		__set_bit(pmc->idx, (unsigned long *)&pmu->overflow_status);

why not declare overflow_status as an unsigned long instead?

> +		pmu->irq_pending = 1;
> +		if (vcpu->mode != IN_GUEST_MODE)
> +			irq_work_queue(&pmu->irq_work);

why do you need to do this only when the vcpu is in guest mode?

also, aren't all the counters per-cpu, so how can the cpu ever be in
guest mode while this is happening?

> +		else
> +			kvm_vgic_inject_irq(vcpu->kvm, vcpu->vcpu_id,
> +					    pmu->irq_num, 1);

what context is this overflow handler function?  kvm_vgic_inject_irq
grabs a mutex, so it can sleep...

from a quick glance at the perf core code, it looks like this is in
interrupt context, so that call to kvm_vgic_inject_irq looks bad.


> +	}
> +}
> +
>  /**
>   * kvm_pmu_set_counter_value - set PMU counter value
>   * @vcpu: The vcpu pointer
> @@ -322,7 +371,8 @@ void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, unsigned long data,
>  	attr.config = config;
>  	attr.sample_period = (-pmc->counter) & (((u64)1 << 32) - 1);
>  
> -	event = perf_event_create_kernel_counter(&attr, -1, current, NULL, pmc);
> +	event = perf_event_create_kernel_counter(&attr, -1, current,
> +						 kvm_pmu_perf_overflow, pmc);

do we properly tear this down when the vcpu dies so that we never start
dereferencing the vcpu in kvm_pmu_perf_overflow if the vcpu goes away?

>  	if (IS_ERR(event)) {
>  		kvm_err("kvm: pmu event creation failed %ld\n",
>  			  PTR_ERR(event));
> @@ -351,4 +401,5 @@ void kvm_pmu_init(struct kvm_vcpu *vcpu)
>  	}
>  
>  	pmu->irq_num = -1;
> +	init_irq_work(&pmu->irq_work, kvm_pum_trigger_pmi);
>  }
> -- 
> 2.1.0
> 

Thanks,
-Christoffer
