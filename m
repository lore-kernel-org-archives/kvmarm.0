From: Tomasz Nowicki <tn@semihalf.com>
Subject: Re: [PATCH] KVM: arm/arm64: Handle forward time correction gracefully
Date: Sun, 17 Apr 2016 19:40:45 +0200
Message-ID: <5713CA9D.1030801@semihalf.com>
References: <1459931842-29465-1-git-send-email-marc.zyngier@arm.com>
 <570B93F2.7000905@semihalf.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <570B93F2.7000905@semihalf.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 11.04.2016 14:09, Tomasz Nowicki wrote:
> On 06.04.2016 10:37, Marc Zyngier wrote:
>> On a host that runs NTP, corrections can have a direct impact on
>> the background timer that we program on the behalf of a vcpu.
>>
>> In particular, NTP performing a forward correction will result in
>> a timer expiring sooner than expected from a guest point of view.
>> Not a big deal, we kick the vcpu anyway.
>>
>> But on wake-up, the vcpu thread is going to perform a check to
>> find out whether or not it should block. And at that point, the
>> timer check is going to say "timer has not expired yet, go back
>> to sleep". This results in the timer event being lost forever.
>>
>> There are multiple ways to handle this. One would be record that
>> the timer has expired and let kvm_cpu_has_pending_timer return
>> true in that case, but that would be fairly invasive. Another is
>> to check for the "short sleep" condition in the hrtimer callback,
>> and restart the timer for the remaining time when the condition
>> is detected.
>>
>> This patch implements the latter, with a bit of refactoring in
>> order to avoid too much code duplication.
>>
>> Reported-by: Alexander Graf <agraf@suse.de>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>   virt/kvm/arm/arch_timer.c | 47
>> +++++++++++++++++++++++++++++++++++++----------
>>   1 file changed, 37 insertions(+), 10 deletions(-)
>>
>> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
>> index a9ad4fe..4d0e77a 100644
>> --- a/virt/kvm/arm/arch_timer.c
>> +++ b/virt/kvm/arm/arch_timer.c
>> @@ -98,10 +98,46 @@ static void kvm_timer_inject_irq_work(struct
>> work_struct *work)
>>       kvm_vcpu_kick(vcpu);
>>   }
>>
>> +static u64 kvm_timer_compute_delta(struct kvm_vcpu *vcpu)
>> +{
>> +    cycle_t cval, now;
>> +
>> +    cval = vcpu->arch.timer_cpu.cntv_cval;
>> +    now = kvm_phys_timer_read() - vcpu->kvm->arch.timer.cntvoff;
>> +
>> +    if (now < cval) {
>> +        u64 ns;
>> +
>> +        ns = cyclecounter_cyc2ns(timecounter->cc,
>> +                     cval - now,
>> +                     timecounter->mask,
>> +                     &timecounter->frac);
>> +        return ns;
>> +    }
>> +
>> +    return 0;
>> +}
>> +
>>   static enum hrtimer_restart kvm_timer_expire(struct hrtimer *hrt)
>>   {
>>       struct arch_timer_cpu *timer;
>> +    struct kvm_vcpu *vcpu;
>> +    u64 ns;
>> +
>>       timer = container_of(hrt, struct arch_timer_cpu, timer);
>> +    vcpu = container_of(timer, struct kvm_vcpu, arch.timer_cpu);
>> +
>> +    /*
>> +     * Check that the timer has really expired from the guest's
>> +     * PoV (NTP on the host may have forced it to expire
>> +     * early). If we should have slept longer, restart it.
>> +     */
>> +    ns = kvm_timer_compute_delta(vcpu);
>> +    if (unlikely(ns)) {
>> +        hrtimer_forward_now(hrt, ns_to_ktime(ns));
>> +        return HRTIMER_RESTART;
>> +    }
>> +
>>       queue_work(wqueue, &timer->expired);
>>       return HRTIMER_NORESTART;
>>   }
>> @@ -176,8 +212,6 @@ static int kvm_timer_update_state(struct kvm_vcpu
>> *vcpu)
>>   void kvm_timer_schedule(struct kvm_vcpu *vcpu)
>>   {
>>       struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
>> -    u64 ns;
>> -    cycle_t cval, now;
>>
>>       BUG_ON(timer_is_armed(timer));
>>
>> @@ -197,14 +231,7 @@ void kvm_timer_schedule(struct kvm_vcpu *vcpu)
>>           return;
>>
>>       /*  The timer has not yet expired, schedule a background timer */
>> -    cval = timer->cntv_cval;
>> -    now = kvm_phys_timer_read() - vcpu->kvm->arch.timer.cntvoff;
>> -
>> -    ns = cyclecounter_cyc2ns(timecounter->cc,
>> -                 cval - now,
>> -                 timecounter->mask,
>> -                 &timecounter->frac);
>> -    timer_arm(timer, ns);
>> +    timer_arm(timer, kvm_timer_compute_delta(vcpu));
>>   }
>>
>>   void kvm_timer_unschedule(struct kvm_vcpu *vcpu)
>>
>
> Works for me, thanks Marc!
>
> Tested-by: Tomasz Nowicki <tn@semihalf.com>
>

FYI: The patch was tested on Cavium ThunderX server.

Tomasz

