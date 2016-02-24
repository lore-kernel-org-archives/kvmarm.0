From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v13 15/20] KVM: ARM64: Add PMU overflow interrupt routing
Date: Wed, 24 Feb 2016 13:19:57 +0000
Message-ID: <56CDADFD.10805@arm.com>
References: <1456290520-10012-1-git-send-email-zhaoshenglong@huawei.com>
 <1456290520-10012-16-git-send-email-zhaoshenglong@huawei.com>
 <20160224122718.GD18451@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20160224122718.GD18451@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>, Shannon Zhao <zhaoshenglong@huawei.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, will.deacon@arm.com, wei@redhat.com, cov@codeaurora.org, shannon.zhao@linaro.org, peter.huangpeng@huawei.com, hangaohuai@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

On 24/02/16 12:27, Christoffer Dall wrote:
> On Wed, Feb 24, 2016 at 01:08:35PM +0800, Shannon Zhao wrote:
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
>> ---
>>  arch/arm/kvm/arm.c    |  2 ++
>>  include/kvm/arm_pmu.h |  3 +++
>>  virt/kvm/arm/pmu.c    | 51 ++++++++++++++++++++++++++++++++++++++++++++++++++-
>>  3 files changed, 55 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
>> index dda1959..f54264c 100644
>> --- a/arch/arm/kvm/arm.c
>> +++ b/arch/arm/kvm/arm.c
>> @@ -28,6 +28,7 @@
>>  #include <linux/sched.h>
>>  #include <linux/kvm.h>
>>  #include <trace/events/kvm.h>
>> +#include <kvm/arm_pmu.h>
>>  
>>  #define CREATE_TRACE_POINTS
>>  #include "trace.h"
>> @@ -577,6 +578,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
>>  		 * non-preemptible context.
>>  		 */
>>  		preempt_disable();
>> +		kvm_pmu_flush_hwstate(vcpu);
>>  		kvm_timer_flush_hwstate(vcpu);
>>  		kvm_vgic_flush_hwstate(vcpu);
>>  
>> diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
>> index 8bc92d1..0aed4d4 100644
>> --- a/include/kvm/arm_pmu.h
>> +++ b/include/kvm/arm_pmu.h
>> @@ -35,6 +35,7 @@ struct kvm_pmu {
>>  	int irq_num;
>>  	struct kvm_pmc pmc[ARMV8_PMU_MAX_COUNTERS];
>>  	bool ready;
>> +	bool irq_level;
>>  };
>>  
>>  #define kvm_arm_pmu_v3_ready(v)		((v)->arch.pmu.ready)
>> @@ -44,6 +45,7 @@ u64 kvm_pmu_valid_counter_mask(struct kvm_vcpu *vcpu);
>>  void kvm_pmu_disable_counter(struct kvm_vcpu *vcpu, u64 val);
>>  void kvm_pmu_enable_counter(struct kvm_vcpu *vcpu, u64 val);
>>  void kvm_pmu_overflow_set(struct kvm_vcpu *vcpu, u64 val);
>> +void kvm_pmu_flush_hwstate(struct kvm_vcpu *vcpu);
>>  void kvm_pmu_software_increment(struct kvm_vcpu *vcpu, u64 val);
>>  void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val);
>>  void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
>> @@ -67,6 +69,7 @@ static inline u64 kvm_pmu_valid_counter_mask(struct kvm_vcpu *vcpu)
>>  static inline void kvm_pmu_disable_counter(struct kvm_vcpu *vcpu, u64 val) {}
>>  static inline void kvm_pmu_enable_counter(struct kvm_vcpu *vcpu, u64 val) {}
>>  static inline void kvm_pmu_overflow_set(struct kvm_vcpu *vcpu, u64 val) {}
>> +static inline void kvm_pmu_flush_hwstate(struct kvm_vcpu *vcpu) {}
>>  static inline void kvm_pmu_software_increment(struct kvm_vcpu *vcpu, u64 val) {}
>>  static inline void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val) {}
>>  static inline void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu,
>> diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
>> index cda869c..1cd4214 100644
>> --- a/virt/kvm/arm/pmu.c
>> +++ b/virt/kvm/arm/pmu.c
>> @@ -21,6 +21,7 @@
>>  #include <linux/perf_event.h>
>>  #include <asm/kvm_emulate.h>
>>  #include <kvm/arm_pmu.h>
>> +#include <kvm/arm_vgic.h>
>>  
>>  /**
>>   * kvm_pmu_get_counter_value - get PMU counter value
>> @@ -181,6 +182,53 @@ void kvm_pmu_overflow_set(struct kvm_vcpu *vcpu, u64 val)
>>  }
>>  
>>  /**
>> + * kvm_pmu_flush_hwstate - flush pmu state to cpu
>> + * @vcpu: The vcpu pointer
>> + *
>> + * Inject virtual PMU IRQ if IRQ is pending for this cpu.
>> + */
>> +void kvm_pmu_flush_hwstate(struct kvm_vcpu *vcpu)
>> +{
>> +	struct kvm_pmu *pmu = &vcpu->arch.pmu;
>> +	bool overflow;
>> +
>> +	if (!kvm_arm_pmu_v3_ready(vcpu))
>> +		return;
>> +
>> +	overflow = !!kvm_pmu_overflow_status(vcpu);
>> +	if (pmu->irq_level != overflow) {
>> +		pmu->irq_level = overflow;
>> +		kvm_vgic_inject_irq(vcpu->kvm, vcpu->vcpu_id,
>> +				    pmu->irq_num, overflow);
>> +	}
> 
> a consequence of only doing this on flush and not checking if the input
> to the vgic should be adjusted on sync is that if you exit the guest
> because the guest does a 'wfi', for example, and you entered with the
> overflow interrupt set, then kvm_arch_vcpu_runnable() will return true,
> and the VCPU will not block but will run anyway.
> 
> Maybe not a big deal, but I think we might as well check the overflow
> status on sync (coming back from the VM) and reset the line at that time
> so that we have a 'more up to date' view of the interrupt line after
> exiting a vcpu.

That's a very good point. I can definitely imagine pathological
behaviours if the guest otherwise relies on the overflow interrupt
triggering.

Shannon, can you please address this?

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
