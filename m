From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v13 15/20] KVM: ARM64: Add PMU overflow interrupt routing
Date: Wed, 24 Feb 2016 13:27:18 +0100
Message-ID: <20160224122718.GD18451@cbox>
References: <1456290520-10012-1-git-send-email-zhaoshenglong@huawei.com>
 <1456290520-10012-16-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4CC92410EB
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Feb 2016 07:19:37 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QGA9yavVsIJX for <kvmarm@lists.cs.columbia.edu>;
 Wed, 24 Feb 2016 07:19:36 -0500 (EST)
Received: from mail-wm0-f51.google.com (mail-wm0-f51.google.com [74.125.82.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D5739410B5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Feb 2016 07:19:35 -0500 (EST)
Received: by mail-wm0-f51.google.com with SMTP id b205so32300610wmb.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Feb 2016 04:26:19 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1456290520-10012-16-git-send-email-zhaoshenglong@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Shannon Zhao <zhaoshenglong@huawei.com>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, will.deacon@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, shannon.zhao@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Feb 24, 2016 at 01:08:35PM +0800, Shannon Zhao wrote:
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
> Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
> Reviewed-by: Andrew Jones <drjones@redhat.com>
> ---
>  arch/arm/kvm/arm.c    |  2 ++
>  include/kvm/arm_pmu.h |  3 +++
>  virt/kvm/arm/pmu.c    | 51 ++++++++++++++++++++++++++++++++++++++++++++++++++-
>  3 files changed, 55 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
> index dda1959..f54264c 100644
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
> @@ -577,6 +578,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  		 * non-preemptible context.
>  		 */
>  		preempt_disable();
> +		kvm_pmu_flush_hwstate(vcpu);
>  		kvm_timer_flush_hwstate(vcpu);
>  		kvm_vgic_flush_hwstate(vcpu);
>  
> diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
> index 8bc92d1..0aed4d4 100644
> --- a/include/kvm/arm_pmu.h
> +++ b/include/kvm/arm_pmu.h
> @@ -35,6 +35,7 @@ struct kvm_pmu {
>  	int irq_num;
>  	struct kvm_pmc pmc[ARMV8_PMU_MAX_COUNTERS];
>  	bool ready;
> +	bool irq_level;
>  };
>  
>  #define kvm_arm_pmu_v3_ready(v)		((v)->arch.pmu.ready)
> @@ -44,6 +45,7 @@ u64 kvm_pmu_valid_counter_mask(struct kvm_vcpu *vcpu);
>  void kvm_pmu_disable_counter(struct kvm_vcpu *vcpu, u64 val);
>  void kvm_pmu_enable_counter(struct kvm_vcpu *vcpu, u64 val);
>  void kvm_pmu_overflow_set(struct kvm_vcpu *vcpu, u64 val);
> +void kvm_pmu_flush_hwstate(struct kvm_vcpu *vcpu);
>  void kvm_pmu_software_increment(struct kvm_vcpu *vcpu, u64 val);
>  void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val);
>  void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
> @@ -67,6 +69,7 @@ static inline u64 kvm_pmu_valid_counter_mask(struct kvm_vcpu *vcpu)
>  static inline void kvm_pmu_disable_counter(struct kvm_vcpu *vcpu, u64 val) {}
>  static inline void kvm_pmu_enable_counter(struct kvm_vcpu *vcpu, u64 val) {}
>  static inline void kvm_pmu_overflow_set(struct kvm_vcpu *vcpu, u64 val) {}
> +static inline void kvm_pmu_flush_hwstate(struct kvm_vcpu *vcpu) {}
>  static inline void kvm_pmu_software_increment(struct kvm_vcpu *vcpu, u64 val) {}
>  static inline void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val) {}
>  static inline void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu,
> diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
> index cda869c..1cd4214 100644
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
> @@ -181,6 +182,53 @@ void kvm_pmu_overflow_set(struct kvm_vcpu *vcpu, u64 val)
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
> +	bool overflow;
> +
> +	if (!kvm_arm_pmu_v3_ready(vcpu))
> +		return;
> +
> +	overflow = !!kvm_pmu_overflow_status(vcpu);
> +	if (pmu->irq_level != overflow) {
> +		pmu->irq_level = overflow;
> +		kvm_vgic_inject_irq(vcpu->kvm, vcpu->vcpu_id,
> +				    pmu->irq_num, overflow);
> +	}

a consequence of only doing this on flush and not checking if the input
to the vgic should be adjusted on sync is that if you exit the guest
because the guest does a 'wfi', for example, and you entered with the
overflow interrupt set, then kvm_arch_vcpu_runnable() will return true,
and the VCPU will not block but will run anyway.

Maybe not a big deal, but I think we might as well check the overflow
status on sync (coming back from the VM) and reset the line at that time
so that we have a 'more up to date' view of the interrupt line after
exiting a vcpu.

Thanks,
-Christoffer

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
>   * kvm_pmu_software_increment - do software increment
>   * @vcpu: The vcpu pointer
>   * @val: the value guest writes to PMSWINC register
> @@ -291,7 +339,8 @@ void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
>  	/* The initial sample period (overflow count) of an event. */
>  	attr.sample_period = (-counter) & pmc->bitmask;
>  
> -	event = perf_event_create_kernel_counter(&attr, -1, current, NULL, pmc);
> +	event = perf_event_create_kernel_counter(&attr, -1, current,
> +						 kvm_pmu_perf_overflow, pmc);
>  	if (IS_ERR(event)) {
>  		pr_err_once("kvm: pmu event creation failed %ld\n",
>  			    PTR_ERR(event));
> -- 
> 2.0.4
> 
> 
