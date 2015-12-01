From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v4 18/21] KVM: ARM64: Add PMU overflow interrupt routing
Date: Tue, 01 Dec 2015 15:41:01 +0000
Message-ID: <565DBF8D.1070006@arm.com>
References: <1446186123-11548-1-git-send-email-zhaoshenglong@huawei.com>	<1446186123-11548-19-git-send-email-zhaoshenglong@huawei.com> <20151130182258.684c9df6@arm.com> <565DB021.3020901@huawei.com> <565DB3A5.3030701@arm.com> <565DB935.5040609@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <565DB935.5040609@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Shannon Zhao <shannon.zhao@linaro.org>, Shannon Zhao <zhaoshenglong@huawei.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, christoffer.dall@linaro.org, will.deacon@arm.com, alex.bennee@linaro.org, wei@redhat.com, cov@codeaurora.org, peter.huangpeng@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

On 01/12/15 15:13, Shannon Zhao wrote:
> 
> 
> On 2015/12/1 22:50, Marc Zyngier wrote:
>> On 01/12/15 14:35, Shannon Zhao wrote:
>>>
>>>
>>> On 2015/12/1 2:22, Marc Zyngier wrote:
>>>> On Fri, 30 Oct 2015 14:22:00 +0800
>>>> Shannon Zhao <zhaoshenglong@huawei.com> wrote:
>>>>
>>>>> From: Shannon Zhao <shannon.zhao@linaro.org>
>>>>>
>>>>> When calling perf_event_create_kernel_counter to create perf_event,
>>>>> assign a overflow handler. Then when perf event overflows, set
>>>>> irq_pending and call kvm_vcpu_kick() to sync the interrupt.
>>>>>
>>>>> Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
>>>>> ---
>>>>>   arch/arm/kvm/arm.c    |  4 +++
>>>>>   include/kvm/arm_pmu.h |  4 +++
>>>>>   virt/kvm/arm/pmu.c    | 76 ++++++++++++++++++++++++++++++++++++++++++++++++++-
>>>>>   3 files changed, 83 insertions(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
>>>>> index 78b2869..9c0fec4 100644
>>>>> --- a/arch/arm/kvm/arm.c
>>>>> +++ b/arch/arm/kvm/arm.c
>>>>> @@ -28,6 +28,7 @@
>>>>>   #include <linux/sched.h>
>>>>>   #include <linux/kvm.h>
>>>>>   #include <trace/events/kvm.h>
>>>>> +#include <kvm/arm_pmu.h>
>>>>>
>>>>>   #define CREATE_TRACE_POINTS
>>>>>   #include "trace.h"
>>>>> @@ -551,6 +552,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
>>>>>
>>>>>   		if (ret <= 0 || need_new_vmid_gen(vcpu->kvm)) {
>>>>>   			local_irq_enable();
>>>>> +			kvm_pmu_sync_hwstate(vcpu);
>>>>
>>>> This is very weird. Are you only injecting interrupts when a signal is
>>>> pending? I don't understand how this works...
>>>>
>>>>>   			kvm_vgic_sync_hwstate(vcpu);
>>>>>   			preempt_enable();
>>>>>   			kvm_timer_sync_hwstate(vcpu);
>>>>> @@ -598,6 +600,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
>>>>>   		kvm_guest_exit();
>>>>>   		trace_kvm_exit(kvm_vcpu_trap_get_class(vcpu), *vcpu_pc(vcpu));
>>>>>
>>>>> +		kvm_pmu_post_sync_hwstate(vcpu);
>>>>> +
>>>>>   		kvm_vgic_sync_hwstate(vcpu);
>>>>>
>>>>>   		preempt_enable();
>>>>> diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
>>>>> index acd025a..5e7f943 100644
>>>>> --- a/include/kvm/arm_pmu.h
>>>>> +++ b/include/kvm/arm_pmu.h
>>>>> @@ -39,6 +39,8 @@ struct kvm_pmu {
>>>>>   };
>>>>>
>>>>>   #ifdef CONFIG_KVM_ARM_PMU
>>>>> +void kvm_pmu_sync_hwstate(struct kvm_vcpu *vcpu);
>>>>> +void kvm_pmu_post_sync_hwstate(struct kvm_vcpu *vcpu);
>>>>
>>>> Please follow the current terminology: _flush_ on VM entry, _sync_ on
>>>> VM exit.
>>>>
>>>
>>> Hi Marc,
>>>
>>> Is below patch the right way for this?
>>>
>>> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
>>> index 78b2869..84008d1 100644
>>> --- a/arch/arm/kvm/arm.c
>>> +++ b/arch/arm/kvm/arm.c
>>> @@ -28,6 +28,7 @@
>>>   #include <linux/sched.h>
>>>   #include <linux/kvm.h>
>>>   #include <trace/events/kvm.h>
>>> +#include <kvm/arm_pmu.h>
>>>
>>>   #define CREATE_TRACE_POINTS
>>>   #include "trace.h"
>>> @@ -531,6 +532,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu,
>>> struct kvm_run *run)
>>>                   */
>>>                  kvm_timer_flush_hwstate(vcpu);
>>>
>>> +               kvm_pmu_flush_hwstate(vcpu);
>>> +
>>>                  /*
>>>                   * Preparing the interrupts to be injected also
>>>                   * involves poking the GIC, which must be done in a
>>> @@ -554,6 +557,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu,
>>> struct kvm_run *run)
>>>                          kvm_vgic_sync_hwstate(vcpu);
>>>                          preempt_enable();
>>>                          kvm_timer_sync_hwstate(vcpu);
>>> +                       kvm_pmu_sync_hwstate(vcpu);
>>>                          continue;
>>>                  }
>>>
>>> @@ -604,6 +608,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu,
>>> struct kvm_run *run)
>>>
>>>                  kvm_timer_sync_hwstate(vcpu);
>>>
>>> +               kvm_pmu_sync_hwstate(vcpu);
>>> +
>>>                  ret = handle_exit(vcpu, run, ret);
>>>          }
>>
>> yeah, that's more like it!
>>
>>>
>>> diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
>>> index 47bbd43..edfe4e5 100644
>>> --- a/include/kvm/arm_pmu.h
>>> +++ b/include/kvm/arm_pmu.h
>>> @@ -41,6 +41,8 @@ struct kvm_pmu {
>>>   };
>>>
>>>   #ifdef CONFIG_KVM_ARM_PMU
>>> +void kvm_pmu_flush_hwstate(struct kvm_vcpu *vcpu);
>>> +void kvm_pmu_sync_hwstate(struct kvm_vcpu *vcpu);
>>>   unsigned long kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u32
>>> select_idx);
>>>   void kvm_pmu_disable_counter(struct kvm_vcpu *vcpu, u32 val);
>>>   void kvm_pmu_enable_counter(struct kvm_vcpu *vcpu, u32 val, bool
>>> all_enable);
>>> @@ -51,6 +53,8 @@ void kvm_pmu_set_counter_event_type(struct kvm_vcpu
>>> *vcpu, u32 data,
>>>                                      u32 select_idx);
>>>   void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u32 val);
>>>   #else
>>> +void kvm_pmu_flush_hwstate(struct kvm_vcpu *vcpu) {}
>>> +void kvm_pmu_sync_hwstate(struct kvm_vcpu *vcpu) {}
>>>   unsigned long kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u32
>>> select_idx)
>>>   {
>>>          return 0;
>>> diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
>>> index 15cac45..9aad2f7 100644
>>> --- a/virt/kvm/arm/pmu.c
>>> +++ b/virt/kvm/arm/pmu.c
>>> @@ -21,6 +21,7 @@
>>>   #include <linux/perf_event.h>
>>>   #include <asm/kvm_emulate.h>
>>>   #include <kvm/arm_pmu.h>
>>> +#include <kvm/arm_vgic.h>
>>>
>>>   /**
>>>    * kvm_pmu_get_counter_value - get PMU counter value
>>> @@ -79,6 +80,78 @@ static void kvm_pmu_stop_counter(struct kvm_pmc *pmc)
>>>   }
>>>
>>>   /**
>>> + * kvm_pmu_flush_hwstate - flush pmu state to cpu
>>> + * @vcpu: The vcpu pointer
>>> + *
>>> + * Inject virtual PMU IRQ if IRQ is pending for this cpu.
>>> + */
>>> +void kvm_pmu_flush_hwstate(struct kvm_vcpu *vcpu)
>>> +{
>>> +       struct kvm_pmu *pmu = &vcpu->arch.pmu;
>>> +       u32 overflow;
>>> +
>>> +       if (!vcpu_mode_is_32bit(vcpu))
>>> +               overflow = vcpu_sys_reg(vcpu, PMOVSSET_EL0);
>>> +       else
>>> +               overflow = vcpu_cp15(vcpu, c9_PMOVSSET);
>>> +
>>> +       if ((pmu->irq_pending || overflow != 0) && (pmu->irq_num != -1))
>>> +               kvm_vgic_inject_irq(vcpu->kvm, vcpu->vcpu_id,
>>> pmu->irq_num, 1);
>>> +
>>> +       pmu->irq_pending = false;
>>
>> Now, we get to the critical point. Why do you need to keep this shadow
>> state for the interrupt?
>>
> The reason is that when guest clear the overflow register, it will trap 
> to kvm and call kvm_pmu_sync_hwstate() as you see above. At this moment, 
> the overflow register is still overflowed(that is some bit is still 1). 
> So We need to use some flag to mark we already inject this interrupt. 
> And if during guest handling the overflow, there is a new overflow 
> happening, the pmu->irq_pending will be set ture by 
> kvm_pmu_perf_overflow(), then it needs to inject this new interrupt, right?

I don't think so. This is a level interrupt, so the level should stay
high as long as the guest hasn't cleared all possible sources for that
interrupt.

For your example, the guest writes to PMOVSCLR to clear the overflow
caused by a given counter. If the status is now 0, the interrupt line
drops. If the status is still non zero, the line stays high. And I
believe that writing a 1 to PMOVSSET would actually trigger an
interrupt, or keep it high if it has already high.

In essence, do not try to maintain side state. I've been bitten.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
