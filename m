From: Shannon Zhao <shannon.zhao@linaro.org>
Subject: Re: [PATCH v12 16/21] KVM: ARM64: Add PMU overflow interrupt routing
Date: Tue, 23 Feb 2016 22:52:16 +0800
Message-ID: <56CC7220.3020807@linaro.org>
References: <1456133877-9584-1-git-send-email-zhaoshenglong@huawei.com>
 <1456133877-9584-17-git-send-email-zhaoshenglong@huawei.com>
 <56CC695E.4010805@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BB96F412F3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Feb 2016 09:45:55 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9Orl9bh1h3S8 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 23 Feb 2016 09:45:53 -0500 (EST)
Received: from mail-wm0-f54.google.com (mail-wm0-f54.google.com [74.125.82.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 75DF3412DD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Feb 2016 09:45:53 -0500 (EST)
Received: by mail-wm0-f54.google.com with SMTP id b205so203055283wmb.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Feb 2016 06:52:33 -0800 (PST)
In-Reply-To: <56CC695E.4010805@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Shannon Zhao <zhaoshenglong@huawei.com>, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org
Cc: kvm@vger.kernel.org, will.deacon@arm.com, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu



On 2016/2/23 22:14, Marc Zyngier wrote:
> On 22/02/16 09:37, Shannon Zhao wrote:
>> From: Shannon Zhao <shannon.zhao@linaro.org>
>>
>> When calling perf_event_create_kernel_counter to create perf_event,
>> assign a overflow handler. Then when the perf event overflows, set the
>> corresponding bit of guest PMOVSSET register. If this counter is enabled
>> and its interrupt is enabled as well, kick the vcpu to sync the
>> interrupt.
>>
>> On VM entry, if there is counter overflowed, inject the interrupt with
>> the level set to 1. Otherwise, inject the interrupt with the level set
>> to 0.
>>
>> Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
>> Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
>> Reviewed-by: Andrew Jones <drjones@redhat.com>
>
> As I mentioned yesterday, I was trying to pinpoint a performance drop, so I added PMU support to kvmtool (and made it an optional flag). This allowed be to find this:
>
>> ---
>>   arch/arm/kvm/arm.c    |  2 ++
>>   include/kvm/arm_pmu.h |  2 ++
>>   virt/kvm/arm/pmu.c    | 47 ++++++++++++++++++++++++++++++++++++++++++++++-
>>   3 files changed, 50 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
>> index dda1959..f54264c 100644
>> --- a/arch/arm/kvm/arm.c
>> +++ b/arch/arm/kvm/arm.c
>> @@ -28,6 +28,7 @@
>>   #include <linux/sched.h>
>>   #include <linux/kvm.h>
>>   #include <trace/events/kvm.h>
>> +#include <kvm/arm_pmu.h>
>>
>>   #define CREATE_TRACE_POINTS
>>   #include "trace.h"
>> @@ -577,6 +578,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
>>   		 * non-preemptible context.
>>   		 */
>>   		preempt_disable();
>> +		kvm_pmu_flush_hwstate(vcpu);
>>   		kvm_timer_flush_hwstate(vcpu);
>>   		kvm_vgic_flush_hwstate(vcpu);
>>
>> diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
>> index 8bc92d1..cf68f9a 100644
>> --- a/include/kvm/arm_pmu.h
>> +++ b/include/kvm/arm_pmu.h
>> @@ -44,6 +44,7 @@ u64 kvm_pmu_valid_counter_mask(struct kvm_vcpu *vcpu);
>>   void kvm_pmu_disable_counter(struct kvm_vcpu *vcpu, u64 val);
>>   void kvm_pmu_enable_counter(struct kvm_vcpu *vcpu, u64 val);
>>   void kvm_pmu_overflow_set(struct kvm_vcpu *vcpu, u64 val);
>> +void kvm_pmu_flush_hwstate(struct kvm_vcpu *vcpu);
>>   void kvm_pmu_software_increment(struct kvm_vcpu *vcpu, u64 val);
>>   void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val);
>>   void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
>> @@ -67,6 +68,7 @@ static inline u64 kvm_pmu_valid_counter_mask(struct kvm_vcpu *vcpu)
>>   static inline void kvm_pmu_disable_counter(struct kvm_vcpu *vcpu, u64 val) {}
>>   static inline void kvm_pmu_enable_counter(struct kvm_vcpu *vcpu, u64 val) {}
>>   static inline void kvm_pmu_overflow_set(struct kvm_vcpu *vcpu, u64 val) {}
>> +static inline void kvm_pmu_flush_hwstate(struct kvm_vcpu *vcpu) {}
>>   static inline void kvm_pmu_software_increment(struct kvm_vcpu *vcpu, u64 val) {}
>>   static inline void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val) {}
>>   static inline void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu,
>> diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
>> index cda869c..6ac52ce 100644
>> --- a/virt/kvm/arm/pmu.c
>> +++ b/virt/kvm/arm/pmu.c
>> @@ -21,6 +21,7 @@
>>   #include <linux/perf_event.h>
>>   #include <asm/kvm_emulate.h>
>>   #include <kvm/arm_pmu.h>
>> +#include <kvm/arm_vgic.h>
>>
>>   /**
>>    * kvm_pmu_get_counter_value - get PMU counter value
>> @@ -181,6 +182,49 @@ void kvm_pmu_overflow_set(struct kvm_vcpu *vcpu, u64 val)
>>   }
>>
>>   /**
>> + * kvm_pmu_flush_hwstate - flush pmu state to cpu
>> + * @vcpu: The vcpu pointer
>> + *
>> + * Inject virtual PMU IRQ if IRQ is pending for this cpu.
>> + */
>> +void kvm_pmu_flush_hwstate(struct kvm_vcpu *vcpu)
>> +{
>> +	struct kvm_pmu *pmu = &vcpu->arch.pmu;
>> +	u64 overflow;
>> +
>> +	if (!kvm_arm_pmu_v3_ready(vcpu))
>> +		return;
>> +
>> +	overflow = kvm_pmu_overflow_status(vcpu);
>> +	kvm_vgic_inject_irq(vcpu->kvm, vcpu->vcpu_id, pmu->irq_num, !!overflow);
>
> It turns out that this single line costs us about 400 cycles on each entry:
>
Oh, it's really a time-consuming function.

> maz@flakes:~/kvm-ws-tests$ make LKVM=~/kvmtool/lkvm LKVM_ARGS=--pmu PERF=perf_4.3 tests-gicv2
> GICv2:
> do_hvc.bin:5690.17
> do_sgi.bin:9395.05
> do_sysreg.bin:5912.6
> maz@flakes:~/kvm-ws-tests$ make LKVM=~/kvmtool/lkvm PERF=perf_4.3 tests-gicv2
> GICv2:
> do_hvc.bin:5285.02
> do_sgi.bin:9131.24
> do_sysreg.bin:5563.7
>
> Caching the irq state and only injecting it if it has changed (just like we do for the timer) brings performance back to its previous level:
>
Marc, thanks a lot for finding out this. I'll merge below changes into 
this series and send out v13 tomorrow.

> diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
> index 176913f..b23e636 100644
> --- a/include/kvm/arm_pmu.h
> +++ b/include/kvm/arm_pmu.h
> @@ -35,6 +35,7 @@ struct kvm_pmu {
>   	int irq_num;
>   	struct kvm_pmc pmc[ARMV8_PMU_MAX_COUNTERS];
>   	bool ready;
> +	bool irq_level;
>   };
>
>   #define kvm_arm_pmu_v3_ready(v)		((v)->arch.pmu.ready)
> diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
> index 904617e..7156f8b 100644
> --- a/virt/kvm/arm/pmu.c
> +++ b/virt/kvm/arm/pmu.c
> @@ -229,13 +229,17 @@ void kvm_pmu_overflow_set(struct kvm_vcpu *vcpu, u64 val)
>   void kvm_pmu_flush_hwstate(struct kvm_vcpu *vcpu)
>   {
>   	struct kvm_pmu *pmu = &vcpu->arch.pmu;
> -	u64 overflow;
> +	bool overflow;
>
>   	if (!kvm_arm_pmu_v3_ready(vcpu))
>   		return;
>
> -	overflow = kvm_pmu_overflow_status(vcpu);
> -	kvm_vgic_inject_irq(vcpu->kvm, vcpu->vcpu_id, pmu->irq_num, !!overflow);
> +	overflow = !!kvm_pmu_overflow_status(vcpu);
> +	if (pmu->irq_level != overflow) {
> +		pmu->irq_level = overflow;
> +		kvm_vgic_inject_irq(vcpu->kvm, vcpu->vcpu_id,
> +				    pmu->irq_num, overflow);
> +	}
>   }
>
>   static inline struct kvm_vcpu *kvm_pmc_to_vcpu(struct kvm_pmc *pmc)
>
>
> Thanks,
>
> 	M.
>

-- 
Shannon
