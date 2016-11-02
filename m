From: Alexander Graf <agraf@suse.de>
Subject: Re: [RFC 2/2] ARM: KVM: Enable in-kernel timers with user space gic
Date: Wed, 2 Nov 2016 16:40:35 +0100
Message-ID: <581A08F3.1050501@suse.de>
References: <1477775449-115472-1-git-send-email-agraf@suse.de>
 <1477775449-115472-2-git-send-email-agraf@suse.de>
 <CAFEAcA9ABvy52WDX++ACUQNo+UiRJkyC+X_mT+QhMxqE154Nqw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <CAFEAcA9ABvy52WDX++ACUQNo+UiRJkyC+X_mT+QhMxqE154Nqw@mail.gmail.com>
Sender: kvm-owner@vger.kernel.org
To: Peter Maydell <peter.maydell@linaro.org>
Cc: QEMU Developers <qemu-devel@nongnu.org>, Paolo Bonzini <pbonzini@redhat.com>, kvm-devel <kvm@vger.kernel.org>, qemu-arm <qemu-arm@nongnu.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 11/01/2016 12:35 PM, Peter Maydell wrote:
> On 29 October 2016 at 22:10, Alexander Graf <agraf@suse.de> wrote:
>> When running with KVM enabled, you can choose between emulating the
>> gic in kernel or user space. If the kernel supports in-kernel virtualization
>> of the interrupt controller, it will default to that. If not, if will
>> default to user space emulation.
>>
>> Unfortunately when running in user mode gic emulation, we miss out on
>> timer events which are only available from kernel space. This patch leverages
>> the new kernel/user space pending line synchronization for those timer events.
>>
>> Signed-off-by: Alexander Graf <agraf@suse.de>
>> ---
>>   hw/arm/virt.c    | 10 ++++++++++
>>   target-arm/cpu.h |  3 +++
>>   target-arm/kvm.c | 19 +++++++++++++++++++
>>   3 files changed, 32 insertions(+)
>>
>> diff --git a/hw/arm/virt.c b/hw/arm/virt.c
>> index 070bbf8..8ac81e3 100644
>> --- a/hw/arm/virt.c
>> +++ b/hw/arm/virt.c
>> @@ -622,6 +622,16 @@ static void create_gic(VirtBoardInfo *vbi, qemu_irq *pic, int type,
>>       } else if (type == 2) {
>>           create_v2m(vbi, pic);
>>       }
>> +
>> +#ifdef CONFIG_KVM
>> +    if (kvm_enabled() && !kvm_irqchip_in_kernel()) {
>> +        if (!kvm_check_extension(kvm_state, KVM_CAP_ARM_TIMER)) {
>> +            error_report("KVM with user space irqchip only works when the "
>> +                         "host kernel supports KVM_CAP_ARM_TIMER");
>> +            exit(1);
>> +        }
>> +    }
>> +#endif
> I think this belongs somewhere in target-arm/kvm.c rather
> than in hw/arm/virt.c -- it's not the only board model that
> supports KVM.

Well, it only applies to boards that make use of the virtual gic. I 
could put it in arm_gic_common_realize()? But then we'd make that file 
target-specific I think...

>
>>   }
>>
>>   static void create_uart(const VirtBoardInfo *vbi, qemu_irq *pic, int uart,
>> diff --git a/target-arm/cpu.h b/target-arm/cpu.h
>> index 19d967b..7686082 100644
>> --- a/target-arm/cpu.h
>> +++ b/target-arm/cpu.h
>> @@ -659,6 +659,9 @@ struct ARMCPU {
>>
>>       ARMELChangeHook *el_change_hook;
>>       void *el_change_hook_opaque;
>> +
>> +    /* Used to synchronize KVM and QEMU timer levels */
>> +    uint8_t timer_irq_level;
>>   };
>>
>>   static inline ARMCPU *arm_env_get_cpu(CPUARMState *env)
>> diff --git a/target-arm/kvm.c b/target-arm/kvm.c
>> index c00b94e..0d8b642 100644
>> --- a/target-arm/kvm.c
>> +++ b/target-arm/kvm.c
>> @@ -527,6 +527,25 @@ void kvm_arch_pre_run(CPUState *cs, struct kvm_run *run)
>>
>>   MemTxAttrs kvm_arch_post_run(CPUState *cs, struct kvm_run *run)
>>   {
>> +    ARMCPU *cpu;
>> +
>> +    if (kvm_irqchip_in_kernel()) {
>> +        /*
>> +         * We only need to sync timer states with user-space interrupt
>> +         * controllers, so return early and save cycles if we don't.
>> +         */
>> +        return MEMTXATTRS_UNSPECIFIED;
>> +    }
>> +
>> +    cpu = ARM_CPU(cs);
>> +
>> +    /* Synchronize our internal vtimer irq line with the kvm one */
>> +    if (run->s.regs.timer_irq_level != cpu->timer_irq_level) {
>> +        qemu_set_irq(ARM_CPU(cs)->gt_timer_outputs[GTIMER_VIRT],
> You just set up a local variable, so you don't need to inline "ARM_CPU(cs)".

Good point :)

>
>> +                     run->s.regs.timer_irq_level & KVM_ARM_TIMER_VTIMER);
> This is setting a bear trap for the person who comes along later
> to add the next interrupt, because the level argument to qemu_set_irq()
> should be 0 or 1. That happens to be true for the KVM_ARM_TIMER_VTIMER
> bit but won't be for the cut-n-pasted version with the next bit name...

Yup, I agree. How about this version?

         vtimer_high = run->s.regs.timer_irq_level & KVM_ARM_TIMER_VTIMER;
         qemu_set_irq(cpu->gt_timer_outputs[GTIMER_VIRT], vtimer_high ? 
1 : 0);


>
>> +        cpu->timer_irq_level = run->s.regs.timer_irq_level;
>> +    }
>> +
>>       return MEMTXATTRS_UNSPECIFIED;
>>   }
> Does this code do the right thing across a vcpu reset or
> a full-system reset?

Good question. I'm not 100% sure - but I don't know for sure whether 
it's guaranteed without user space irqchip even.

In essence, the code above merely synchronizes kvm state to qemu state 
and is fully unaffected from any reset sequence. This is good, as the 
line status is transient. So from a QEMU pov, we really only copy the 
state of the vcpu interrupt line into the QEMU interrupt line. Pulling 
that line down would be responsibility of the KVM_ARM_VCPU_INIT ioctl if 
it also clears the timer registers I guess.

However, I don't see any clearing of cntv_ctrl inside KVM or from QEMU. 
How do we ensure that the irq active bit is off on reset?

The other part that could get in the way of working system reset is the 
interrupt controller emulation itself which resets all internal irq line 
state. So on reset we'd always end up with the irq line down from a gic 
pov, but with the vtimer line pending or not pending depending on 
previous state. I doubt it's really going to hurt though.


Alex

