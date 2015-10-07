From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3 17/20] KVM: ARM64: Add PMU overflow interrupt routing
Date: Wed, 07 Oct 2015 09:17:25 +0100
Message-ID: <5614D515.3060800@arm.com>
References: <1443133885-3366-1-git-send-email-shannon.zhao@linaro.org> <1443133885-3366-18-git-send-email-shannon.zhao@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1443133885-3366-18-git-send-email-shannon.zhao@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Shannon Zhao <shannon.zhao@linaro.org>, kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, christoffer.dall@linaro.org, will.deacon@arm.com, wei@redhat.com, alex.bennee@linaro.org, peter.huangpeng@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

On 24/09/15 23:31, Shannon Zhao wrote:
> When calling perf_event_create_kernel_counter to create perf_event,
> assign a overflow handler. Then when perf event overflows, set
> irq_pending and call kvm_vcpu_kick() to sync the interrupt.
> 
> Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
> ---
>  arch/arm/kvm/arm.c    |  4 ++++
>  include/kvm/arm_pmu.h |  2 ++
>  virt/kvm/arm/pmu.c    | 54 ++++++++++++++++++++++++++++++++++++++++++++++++++-
>  3 files changed, 59 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
> index ce404a5..3fca263 100644
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
> @@ -554,6 +555,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  			kvm_vgic_sync_hwstate(vcpu);
>  			preempt_enable();
>  			kvm_timer_sync_hwstate(vcpu);
> +			kvm_pmu_sync_hwstate(vcpu);
>  			continue;
>  		}
>  
> @@ -604,6 +606,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  
>  		kvm_timer_sync_hwstate(vcpu);
>  
> +		kvm_pmu_sync_hwstate(vcpu);
> +
>  		ret = handle_exit(vcpu, run, ret);
>  	}

The code around here is about to change with Christopher's patches. Most
importantly, virtual devices must signal their changes before we touch
the vgic. I suspect this will have some impacts, see below.

>  
> diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
> index 9293133..953c400 100644
> --- a/include/kvm/arm_pmu.h
> +++ b/include/kvm/arm_pmu.h
> @@ -38,6 +38,7 @@ struct kvm_pmu {
>  };
>  
>  #ifdef CONFIG_KVM_ARM_PMU
> +void kvm_pmu_sync_hwstate(struct kvm_vcpu *vcpu);
>  unsigned long kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u32 select_idx);
>  void kvm_pmu_disable_counter(struct kvm_vcpu *vcpu, u32 val);
>  void kvm_pmu_enable_counter(struct kvm_vcpu *vcpu, u32 val);
> @@ -45,6 +46,7 @@ void kvm_pmu_software_increment(struct kvm_vcpu *vcpu, u32 val);
>  void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u32 data,
>  				    u32 select_idx);
>  #else
> +void kvm_pmu_sync_hwstate(struct kvm_vcpu *vcpu) {}
>  unsigned long kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u32 select_idx)
>  {
>  	return 0;
> diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
> index 18637c9..ca7e849 100644
> --- a/virt/kvm/arm/pmu.c
> +++ b/virt/kvm/arm/pmu.c
> @@ -21,6 +21,7 @@
>  #include <linux/perf_event.h>
>  #include <asm/kvm_emulate.h>
>  #include <kvm/arm_pmu.h>
> +#include <kvm/arm_vgic.h>
>  
>  static void kvm_pmu_set_evttyper(struct kvm_vcpu *vcpu, u32 idx, u32 val)
>  {
> @@ -62,6 +63,56 @@ static void kvm_pmu_stop_counter(struct kvm_vcpu *vcpu, u32 select_idx)
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
> +	if (pmu->irq_pending && (pmu->irq_num != -1)) {

How likely is that pmu->irq_num could be -1? I don't think the interrupt
can be made optional.

> +		kvm_vgic_inject_irq(vcpu->kvm, vcpu->vcpu_id, pmu->irq_num, 1);
> +		pmu->irq_pending = false;
> +	}

So you're signalling the interrupt as an edge, not a level. Is that an
accurate modelling of the PMU interrupt?

My hunch is that the interrupt should still be pending until the guest
has cleared the overflow condition (by writing to PMOVSCLR_EL0). You can
probably lift most of that logic from  Christoffer's rework of the timer
state.

> +}
> +
> +/**
> + * When perf event overflows, set irq_pending and call kvm_vcpu_kick() to inject
> + * the interrupt.
> + */
> +static void kvm_pmu_perf_overflow(struct perf_event *perf_event,
> +				  struct perf_sample_data *data,
> +				  struct pt_regs *regs)
> +{
> +	struct kvm_pmc *pmc = perf_event->overflow_handler_context;
> +	struct kvm_vcpu *vcpu = pmc->vcpu;
> +	struct kvm_pmu *pmu = &vcpu->arch.pmu;
> +	int idx = pmc->idx;
> +
> +	if (!vcpu_mode_is_32bit(vcpu)) {
> +		if ((vcpu_sys_reg(vcpu, PMINTENSET_EL1) >> idx) & 0x1) {
> +			__set_bit(idx,
> +			    (unsigned long *)&vcpu_sys_reg(vcpu, PMOVSSET_EL0));
> +			__set_bit(idx,
> +			    (unsigned long *)&vcpu_sys_reg(vcpu, PMOVSCLR_EL0));
> +			pmu->irq_pending = true;
> +			kvm_vcpu_kick(vcpu);
> +		}
> +	} else {
> +		if ((vcpu_cp15(vcpu, c9_PMINTENSET) >> idx) & 0x1) {
> +			__set_bit(idx,
> +				(unsigned long *)&vcpu_cp15(vcpu, c9_PMOVSSET));
> +			__set_bit(idx,
> +				(unsigned long *)&vcpu_cp15(vcpu, c9_PMOVSCLR));
> +			pmu->irq_pending = true;
> +			kvm_vcpu_kick(vcpu);
> +		}
> +	}
> +}
> +
> +/**
>   * kvm_pmu_get_counter_value - get PMU counter value
>   * @vcpu: The vcpu pointer
>   * @select_idx: The counter index
> @@ -225,7 +276,8 @@ void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u32 data,
>  	/* The initial sample period (overflow count) of an event. */
>  	attr.sample_period = (-counter) & (((u64)1 << overflow_bit) - 1);
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
