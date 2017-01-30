From: Jintack Lim <jintack@cs.columbia.edu>
Subject: Re: [RFC v2 02/10] KVM: arm/arm64: Move cntvoff to each timer context
Date: Mon, 30 Jan 2017 13:45:04 -0500
Message-ID: <CAHyh4xjQ3XbY_o7urRKLwQ=0QoQmvbSfzsCfxOciV8HDMrNVtA@mail.gmail.com>
References: <1485479100-4966-1-git-send-email-jintack@cs.columbia.edu>
 <1485479100-4966-3-git-send-email-jintack@cs.columbia.edu>
 <867f5e9j4y.fsf@arm.com> <CAHyh4xiL18DPsR52FtLhafRWuycb5zA6MRL-SSSCRX96Ce-6ug@mail.gmail.com>
 <26af5458-ce45-447b-6ecf-d269e3cc631d@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <26af5458-ce45-447b-6ecf-d269e3cc631d@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Christoffer Dall <christoffer.dall@linaro.org>, linux@armlinux.org.uk, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andre Przywara <andre.przywara@arm.com>, KVM General <kvm@vger.kernel.org>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, kvmarm@lists.cs.columbia.edu, lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jan 30, 2017 at 1:05 PM, Marc Zyngier <marc.zyngier@arm.com> wrote:
> On 30/01/17 17:58, Jintack Lim wrote:
>> On Sun, Jan 29, 2017 at 6:54 AM, Marc Zyngier <marc.zyngier@arm.com> wrote:
>>> On Fri, Jan 27 2017 at 01:04:52 AM, Jintack Lim <jintack@cs.columbia.edu> wrote:
>>>> Make cntvoff per each timer context. This is helpful to abstract kvm
>>>> timer functions to work with timer context without considering timer
>>>> types (e.g. physical timer or virtual timer).
>>>>
>>>> This also would pave the way for ever doing adjustments of the cntvoff
>>>> on a per-CPU basis if that should ever make sense.
>>>>
>>>> Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
>>>> ---
>>>>  arch/arm/include/asm/kvm_host.h   |  6 +++---
>>>>  arch/arm64/include/asm/kvm_host.h |  4 ++--
>>>>  include/kvm/arm_arch_timer.h      |  8 +++-----
>>>>  virt/kvm/arm/arch_timer.c         | 26 ++++++++++++++++++++------
>>>>  virt/kvm/arm/hyp/timer-sr.c       |  3 +--
>>>>  5 files changed, 29 insertions(+), 18 deletions(-)
>>>>
>>>> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
>>>> index d5423ab..f5456a9 100644
>>>> --- a/arch/arm/include/asm/kvm_host.h
>>>> +++ b/arch/arm/include/asm/kvm_host.h
>>>> @@ -60,9 +60,6 @@ struct kvm_arch {
>>>>       /* The last vcpu id that ran on each physical CPU */
>>>>       int __percpu *last_vcpu_ran;
>>>>
>>>> -     /* Timer */
>>>> -     struct arch_timer_kvm   timer;
>>>> -
>>>>       /*
>>>>        * Anything that is not used directly from assembly code goes
>>>>        * here.
>>>> @@ -75,6 +72,9 @@ struct kvm_arch {
>>>>       /* Stage-2 page table */
>>>>       pgd_t *pgd;
>>>>
>>>> +     /* A lock to synchronize cntvoff among all vtimer context of vcpus */
>>>> +     spinlock_t cntvoff_lock;
>>>
>>> Is there any condition where we need this to be a spinlock? I would have
>>> thought that a mutex should have been enough, as this should only be
>>> updated on migration or initialization. Not that it matters much in this
>>> case, but I wondered if there is something I'm missing.
>>>
>>>> +
>>>>       /* Interrupt controller */
>>>>       struct vgic_dist        vgic;
>>>>       int max_vcpus;
>>>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>>>> index e505038..23749a8 100644
>>>> --- a/arch/arm64/include/asm/kvm_host.h
>>>> +++ b/arch/arm64/include/asm/kvm_host.h
>>>> @@ -71,8 +71,8 @@ struct kvm_arch {
>>>>       /* Interrupt controller */
>>>>       struct vgic_dist        vgic;
>>>>
>>>> -     /* Timer */
>>>> -     struct arch_timer_kvm   timer;
>>>> +     /* A lock to synchronize cntvoff among all vtimer context of vcpus */
>>>> +     spinlock_t cntvoff_lock;
>>>>  };
>>>>
>>>>  #define KVM_NR_MEM_OBJS     40
>>>> diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
>>>> index daad3c1..1b9c988 100644
>>>> --- a/include/kvm/arm_arch_timer.h
>>>> +++ b/include/kvm/arm_arch_timer.h
>>>> @@ -23,11 +23,6 @@
>>>>  #include <linux/hrtimer.h>
>>>>  #include <linux/workqueue.h>
>>>>
>>>> -struct arch_timer_kvm {
>>>> -     /* Virtual offset */
>>>> -     u64                     cntvoff;
>>>> -};
>>>> -
>>>>  struct arch_timer_context {
>>>>       /* Registers: control register, timer value */
>>>>       u32                             cnt_ctl;
>>>> @@ -38,6 +33,9 @@ struct arch_timer_context {
>>>>
>>>>       /* Active IRQ state caching */
>>>>       bool                            active_cleared_last;
>>>> +
>>>> +     /* Virtual offset */
>>>> +     u64                     cntvoff;
>>>>  };
>>>>
>>>>  struct arch_timer_cpu {
>>>> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
>>>> index 6740efa..fa4c042 100644
>>>> --- a/virt/kvm/arm/arch_timer.c
>>>> +++ b/virt/kvm/arm/arch_timer.c
>>>> @@ -101,9 +101,10 @@ static void kvm_timer_inject_irq_work(struct work_struct *work)
>>>>  static u64 kvm_timer_compute_delta(struct kvm_vcpu *vcpu)
>>>>  {
>>>>       u64 cval, now;
>>>> +     struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
>>>>
>>>> -     cval = vcpu_vtimer(vcpu)->cnt_cval;
>>>> -     now = kvm_phys_timer_read() - vcpu->kvm->arch.timer.cntvoff;
>>>> +     cval = vtimer->cnt_cval;
>>>> +     now = kvm_phys_timer_read() - vtimer->cntvoff;
>>>>
>>>>       if (now < cval) {
>>>>               u64 ns;
>>>> @@ -159,7 +160,7 @@ bool kvm_timer_should_fire(struct kvm_vcpu *vcpu)
>>>>               return false;
>>>>
>>>>       cval = vtimer->cnt_cval;
>>>> -     now = kvm_phys_timer_read() - vcpu->kvm->arch.timer.cntvoff;
>>>> +     now = kvm_phys_timer_read() - vtimer->cntvoff;
>>>>
>>>>       return cval <= now;
>>>>  }
>>>> @@ -353,10 +354,23 @@ int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu,
>>>>       return 0;
>>>>  }
>>>>
>>>> +/* Make the updates of cntvoff for all vtimer contexts atomic */
>>>> +static void update_vtimer_cntvoff(struct kvm_vcpu *vcpu, u64 cntvoff)
>>>
>>> Arguably, this acts on the VM itself and not a single vcpu. maybe you
>>> should consider passing the struct kvm pointer to reflect this.
>>>
>>
>> Yes, that would be better.
>>
>>>> +{
>>>> +     int i;
>>>> +
>>>> +     spin_lock(&vcpu->kvm->arch.cntvoff_lock);
>>>> +     kvm_for_each_vcpu(i, vcpu, vcpu->kvm)
>>>> +             vcpu_vtimer(vcpu)->cntvoff = cntvoff;
>>>> +     spin_unlock(&vcpu->kvm->arch.cntvoff_lock);
>>>> +}
>>>> +
>>>>  void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu)
>>>>  {
>>>>       struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
>>>>
>>>> +     update_vtimer_cntvoff(vcpu, kvm_phys_timer_read());
>>>
>>> Maybe a comment indicating that we recompute CNTVOFF for all vcpus would
>>> be welcome (this is not a change in semantics, but it was never obvious
>>> in the existing code).
>>
>> I'll add a comment. In fact, I was told to make cntvoff synchronized
>> across all the vcpus, but I'm afraid that I understand why. Could you
>> explain me where this constraint comes from?
>
> The virtual counter is the only one a guest can rely on (as the physical
> one is disabled). So we must present to the guest a view of time that is
> uniform across CPUs. If we allow CNTVOFF to vary across CPUs, time
> starts fluctuating when we migrate a process from a vcpu to another, and
> Linux gets *really* unhappy.

Ah, that makes sense to me. Thanks a lot.

>
> An easy fix for this is to make CNTVOFF a VM-global value, ensuring that
> all the CPUs see the same counter values at the same time.
>
> Thanks,
>
>         M.
> --
> Jazz is not dead. It just smells funny...
>
