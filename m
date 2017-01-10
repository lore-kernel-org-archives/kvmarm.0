From: Jintack Lim <jintack@cs.columbia.edu>
Subject: Re: [RFC 6/8] KVM: arm/arm64: Update the physical timer interrupt
 level
Date: Tue, 10 Jan 2017 12:27:19 -0500
Message-ID: <CAHyh4xge=A7z9B+aoZXYHB4M2_a6tRZVSiMk+QWXwV72mN4tpA@mail.gmail.com>
References: <1482772326-29110-1-git-send-email-jintack@cs.columbia.edu>
 <1482772326-29110-7-git-send-email-jintack@cs.columbia.edu>
 <20170109121445.GF4348@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 771CC403FB
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Jan 2017 12:25:40 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XmCz9N6OqnQW for <kvmarm@lists.cs.columbia.edu>;
 Tue, 10 Jan 2017 12:25:39 -0500 (EST)
Received: from outprodmail02.cc.columbia.edu (outprodmail02.cc.columbia.edu
 [128.59.72.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6229E402AF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Jan 2017 12:25:39 -0500 (EST)
Received: from hazelnut (hazelnut.cc.columbia.edu [128.59.213.250])
 by outprodmail02.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v0AHN5IT028610
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Jan 2017 12:27:22 -0500
Received: from hazelnut (localhost.localdomain [127.0.0.1])
 by hazelnut (Postfix) with ESMTP id 7BA7F86
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Jan 2017 12:27:22 -0500 (EST)
Received: from sendprodmail02.cc.columbia.edu (sendprodmail02.cc.columbia.edu
 [128.59.72.14]) by hazelnut (Postfix) with ESMTP id 5197386
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Jan 2017 12:27:22 -0500 (EST)
Received: from mail-oi0-f69.google.com (mail-oi0-f69.google.com
 [209.85.218.69])
 by sendprodmail02.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v0AHRLaH000935
 (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Jan 2017 12:27:22 -0500
Received: by mail-oi0-f69.google.com with SMTP id y140so214561145oie.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Jan 2017 09:27:22 -0800 (PST)
Received: from mail-oi0-f42.google.com (mail-oi0-f42.google.com.
 [209.85.218.42])
 by smtp.gmail.com with ESMTPSA id w48sm1104073otw.33.2017.01.10.09.27.19
 for <kvmarm@lists.cs.columbia.edu>
 (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
 Tue, 10 Jan 2017 09:27:20 -0800 (PST)
Received: by mail-oi0-f42.google.com with SMTP id 3so554607200oih.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Jan 2017 09:27:19 -0800 (PST)
In-Reply-To: <20170109121445.GF4348@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: KVM General <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, will.deacon@arm.com, linux@armlinux.org.uk, linux-kernel@vger.kernel.org, andre.przywara@arm.com, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jan 9, 2017 at 7:14 AM, Christoffer Dall
<christoffer.dall@linaro.org> wrote:
> On Mon, Dec 26, 2016 at 12:12:04PM -0500, Jintack Lim wrote:
>> Now that we maintain the EL1 physical timer register states of the VM,
>> update the physical timer interrupt level along with the virtual one.
>>
>> Note that the emulated EL1 physical timer is not mapped to any hardware
>> timer, so we let vgic know that.
>>
>> With this commit, VMs are able to get the physical timer interrupts
>> while they are runnable. But they won't get interrupts once vcpus go to
>> sleep since we don't have code to wake vcpus up on the emulated physical
>> timer expiration yet.
>
> I'm not sure I understand.  It looks to me like it's the other way
> around and that this code supports waking up a sleeping VCPU sooner if
> it has a physical timer scheduled, but doesn't yet support causing an
> early exit from running the VPCU base on programing the physical timer?
>

Ah, you are right. This was really two commits: one that checks the
physical timer expiration on entry to the VM AND another one that sets
up the background timer when the VM goes to sleep.

I'll split this into two and put the correct commit messages.

Thanks,
Jintack

>
> Thanks,
> -Christoffer
>
>>
>> Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
>> ---
>>  arch/arm/kvm/arm.c        |  3 +-
>>  virt/kvm/arm/arch_timer.c | 76 ++++++++++++++++++++++++++++++++++++++---------
>>  2 files changed, 64 insertions(+), 15 deletions(-)
>>
>> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
>> index 37d1623..d2dfa32 100644
>> --- a/arch/arm/kvm/arm.c
>> +++ b/arch/arm/kvm/arm.c
>> @@ -295,7 +295,8 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
>>
>>  int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
>>  {
>> -     return kvm_timer_should_fire(vcpu, vcpu_vtimer(vcpu));
>> +     return kvm_timer_should_fire(vcpu, vcpu_vtimer(vcpu)) ||
>> +             kvm_timer_should_fire(vcpu, vcpu_ptimer(vcpu));
>>  }
>>
>>  void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu)
>> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
>> index ed80864..aa7e243 100644
>> --- a/virt/kvm/arm/arch_timer.c
>> +++ b/virt/kvm/arm/arch_timer.c
>> @@ -91,7 +91,8 @@ static void kvm_timer_inject_irq_work(struct work_struct *work)
>>       vcpu = container_of(work, struct kvm_vcpu, arch.timer_cpu.expired);
>>       vcpu->arch.timer_cpu.armed = false;
>>
>> -     WARN_ON(!kvm_timer_should_fire(vcpu, vcpu_vtimer(vcpu)));
>> +     WARN_ON(!kvm_timer_should_fire(vcpu, vcpu_vtimer(vcpu)) &&
>> +             !kvm_timer_should_fire(vcpu, vcpu_ptimer(vcpu)));
>>
>>       /*
>>        * If the vcpu is blocked we want to wake it up so that it will see
>> @@ -130,6 +131,33 @@ static u64 kvm_timer_compute_delta(struct kvm_vcpu *vcpu,
>>       return 0;
>>  }
>>
>> +static bool kvm_timer_irq_can_fire(struct arch_timer_context *timer_ctx)
>> +{
>> +     return !(timer_ctx->cnt_ctl & ARCH_TIMER_CTRL_IT_MASK) &&
>> +             (timer_ctx->cnt_ctl & ARCH_TIMER_CTRL_ENABLE);
>> +}
>> +
>> +/*
>> + * Returns minimal timer expiration time in ns among guest timers.
>> + * Note that it will return inf time if none of timers can fire.
>> + */
>> +static u64 kvm_timer_min_block(struct kvm_vcpu *vcpu)
>> +{
>> +     u64 min_virt = ULLONG_MAX, min_phys = ULLONG_MAX;
>> +     struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
>> +     struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
>> +
>> +     if (kvm_timer_irq_can_fire(vtimer))
>> +             min_virt = kvm_timer_compute_delta(vcpu, vtimer);
>> +
>> +     if (kvm_timer_irq_can_fire(ptimer))
>> +             min_phys = kvm_timer_compute_delta(vcpu, ptimer);
>> +
>> +     WARN_ON((min_virt == ULLONG_MAX) && (min_phys == ULLONG_MAX));
>> +
>> +     return min(min_virt, min_phys);
>> +}
>> +
>>  static enum hrtimer_restart kvm_timer_expire(struct hrtimer *hrt)
>>  {
>>       struct arch_timer_cpu *timer;
>> @@ -144,7 +172,7 @@ static enum hrtimer_restart kvm_timer_expire(struct hrtimer *hrt)
>>        * PoV (NTP on the host may have forced it to expire
>>        * early). If we should have slept longer, restart it.
>>        */
>> -     ns = kvm_timer_compute_delta(vcpu, vcpu_vtimer(vcpu));
>> +     ns = kvm_timer_min_block(vcpu);
>>       if (unlikely(ns)) {
>>               hrtimer_forward_now(hrt, ns_to_ktime(ns));
>>               return HRTIMER_RESTART;
>> @@ -154,12 +182,6 @@ static enum hrtimer_restart kvm_timer_expire(struct hrtimer *hrt)
>>       return HRTIMER_NORESTART;
>>  }
>>
>> -static bool kvm_timer_irq_can_fire(struct arch_timer_context *timer_ctx)
>> -{
>> -     return !(timer_ctx->cnt_ctl & ARCH_TIMER_CTRL_IT_MASK) &&
>> -             (timer_ctx->cnt_ctl & ARCH_TIMER_CTRL_ENABLE);
>> -}
>> -
>>  bool kvm_timer_should_fire(struct kvm_vcpu *vcpu,
>>                          struct arch_timer_context *timer_ctx)
>>  {
>> @@ -191,6 +213,21 @@ static void kvm_timer_update_mapped_irq(struct kvm_vcpu *vcpu, bool new_level,
>>       WARN_ON(ret);
>>  }
>>
>> +static void kvm_timer_update_irq(struct kvm_vcpu *vcpu, bool new_level,
>> +                              struct arch_timer_context *timer)
>> +{
>> +     int ret;
>> +
>> +     BUG_ON(!vgic_initialized(vcpu->kvm));
>> +
>> +     timer->irq.level = new_level;
>> +     trace_kvm_timer_update_irq(vcpu->vcpu_id, timer->irq.irq,
>> +                                timer->irq.level);
>> +     ret = kvm_vgic_inject_irq(vcpu->kvm, vcpu->vcpu_id, timer->irq.irq,
>> +                               timer->irq.level);
>> +     WARN_ON(ret);
>> +}
>> +
>>  /*
>>   * Check if there was a change in the timer state (should we raise or lower
>>   * the line level to the GIC).
>> @@ -198,6 +235,7 @@ static void kvm_timer_update_mapped_irq(struct kvm_vcpu *vcpu, bool new_level,
>>  static int kvm_timer_update_state(struct kvm_vcpu *vcpu)
>>  {
>>       struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
>> +     struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
>>
>>       /*
>>        * If userspace modified the timer registers via SET_ONE_REG before
>> @@ -211,6 +249,10 @@ static int kvm_timer_update_state(struct kvm_vcpu *vcpu)
>>       if (kvm_timer_should_fire(vcpu, vtimer) != vtimer->irq.level)
>>               kvm_timer_update_mapped_irq(vcpu, !vtimer->irq.level, vtimer);
>>
>> +     /* The emulated EL1 physical timer irq is not mapped to hardware */
>> +     if (kvm_timer_should_fire(vcpu, ptimer) != ptimer->irq.level)
>> +             kvm_timer_update_irq(vcpu, !ptimer->irq.level, ptimer);
>> +
>>       return 0;
>>  }
>>
>> @@ -223,26 +265,32 @@ void kvm_timer_schedule(struct kvm_vcpu *vcpu)
>>  {
>>       struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
>>       struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
>> +     struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
>>
>>       BUG_ON(timer_is_armed(timer));
>>
>>       /*
>> -      * No need to schedule a background timer if the guest timer has
>> +      * No need to schedule a background timer if any guest timer has
>>        * already expired, because kvm_vcpu_block will return before putting
>>        * the thread to sleep.
>>        */
>> -     if (kvm_timer_should_fire(vcpu, vtimer))
>> +     if (kvm_timer_should_fire(vcpu, vtimer) ||
>> +         kvm_timer_should_fire(vcpu, ptimer))
>>               return;
>>
>>       /*
>> -      * If the timer is not capable of raising interrupts (disabled or
>> +      * If both timers are not capable of raising interrupts (disabled or
>>        * masked), then there's no more work for us to do.
>>        */
>> -     if (!kvm_timer_irq_can_fire(vtimer))
>> +     if (!kvm_timer_irq_can_fire(vtimer) &&
>> +         !kvm_timer_irq_can_fire(ptimer))
>>               return;
>>
>> -     /*  The timer has not yet expired, schedule a background timer */
>> -     timer_arm(timer, kvm_timer_compute_delta(vcpu, vtimer));
>> +     /*
>> +      * The guest timers have not yet expired, schedule a background timer.
>> +      * Pick smaller expiration time between phys and virt timer.
>> +      */
>> +     timer_arm(timer, kvm_timer_min_block(vcpu));
>>  }
>>
>>  void kvm_timer_unschedule(struct kvm_vcpu *vcpu)
>> --
>> 1.9.1
>>
>>
>
