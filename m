From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [RFC 7/8] KVM: arm/arm64: Set up a background timer for the
 physical timer emulation
Date: Tue, 10 Jan 2017 20:39:05 +0100
Message-ID: <20170110193905.GO4348@cbox>
References: <1482772326-29110-1-git-send-email-jintack@cs.columbia.edu>
 <1482772326-29110-8-git-send-email-jintack@cs.columbia.edu>
 <20170109121326.GE4348@cbox>
 <CAHyh4xhvjR2k5H4kTM3t_rXyzih-h2aHQTN9VPqrzJbJ=Zuq0g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 23B5A40296
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Jan 2017 14:37:26 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id S2OdrTxJtXwL for <kvmarm@lists.cs.columbia.edu>;
 Tue, 10 Jan 2017 14:37:24 -0500 (EST)
Received: from mail-lf0-f43.google.com (mail-lf0-f43.google.com
 [209.85.215.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7210F40295
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Jan 2017 14:37:24 -0500 (EST)
Received: by mail-lf0-f43.google.com with SMTP id v186so68298581lfa.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Jan 2017 11:39:07 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <CAHyh4xhvjR2k5H4kTM3t_rXyzih-h2aHQTN9VPqrzJbJ=Zuq0g@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Jintack Lim <jintack@cs.columbia.edu>
Cc: KVM General <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, will.deacon@arm.com, linux@armlinux.org.uk, linux-kernel@vger.kernel.org, andre.przywara@arm.com, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Jan 10, 2017 at 01:47:49PM -0500, Jintack Lim wrote:
> Hi Christoffer,
> 
> thanks for the review!
> 
> On Mon, Jan 9, 2017 at 7:13 AM, Christoffer Dall
> <christoffer.dall@linaro.org> wrote:
> > On Mon, Dec 26, 2016 at 12:12:05PM -0500, Jintack Lim wrote:
> >> Set a background timer for the EL1 physical timer emulation while VMs are
> >> running, so that VMs get interrupts for the physical timer in a timely
> >> manner.
> >>
> >> We still use just one background timer. When a VM is runnable, we use
> >> the background timer for the physical timer emulation.  When the VM is
> >> about to be blocked, we use the background timer to wake up the vcpu at
> >> the earliest timer expiration among timers the VM is using.
> >>
> >> As a result, the assumption that the background timer is not armed while
> >> VMs are running does not hold any more. So, remove BUG_ON()s and
> >> WARN_ON()s accordingly.
> >>
> >> Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
> >> ---
> >>  virt/kvm/arm/arch_timer.c | 42 +++++++++++++++++++++++++++++++-----------
> >>  1 file changed, 31 insertions(+), 11 deletions(-)
> >>
> >> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
> >> index aa7e243..be8d953 100644
> >> --- a/virt/kvm/arm/arch_timer.c
> >> +++ b/virt/kvm/arm/arch_timer.c
> >> @@ -91,9 +91,6 @@ static void kvm_timer_inject_irq_work(struct work_struct *work)
> >>       vcpu = container_of(work, struct kvm_vcpu, arch.timer_cpu.expired);
> >>       vcpu->arch.timer_cpu.armed = false;
> >>
> >> -     WARN_ON(!kvm_timer_should_fire(vcpu, vcpu_vtimer(vcpu)) &&
> >> -             !kvm_timer_should_fire(vcpu, vcpu_ptimer(vcpu)));
> >> -
> >
> > This seems misplaced and has been addressed here:
> > https://lists.cs.columbia.edu/pipermail/kvmarm/2017-January/022933.html
> >
> > When you respin you can benefit from basing on that (assuming it gets
> > acked and goes int).
> 
> Ok, I got it.
> 
> >
> >>       /*
> >>        * If the vcpu is blocked we want to wake it up so that it will see
> >>        * the timer has expired when entering the guest.
> >> @@ -139,7 +136,6 @@ static bool kvm_timer_irq_can_fire(struct arch_timer_context *timer_ctx)
> >>
> >>  /*
> >>   * Returns minimal timer expiration time in ns among guest timers.
> >> - * Note that it will return inf time if none of timers can fire.
> >>   */
> >>  static u64 kvm_timer_min_block(struct kvm_vcpu *vcpu)
> >>  {
> >> @@ -153,7 +149,9 @@ static u64 kvm_timer_min_block(struct kvm_vcpu *vcpu)
> >>       if (kvm_timer_irq_can_fire(ptimer))
> >>               min_phys = kvm_timer_compute_delta(vcpu, ptimer);
> >>
> >> -     WARN_ON((min_virt == ULLONG_MAX) && (min_phys == ULLONG_MAX));
> >> +     /* If none of timers can fire, then return 0 */
> >> +     if ((min_virt == ULLONG_MAX) && (min_phys == ULLONG_MAX))
> >> +             return 0;
> >
> > Why didn't you have this semantics in the previous patch?
> 
> I should have put this in the previous patch, and I'll do that.
> 
> Just let you know, WARN_ON() in the previous patch was there because I
> thought that the caller of this function is sure that one of the
> timers are able to fire. But I think that's beyond the scope of this
> function.
> 
> >
> >>
> >>       return min(min_virt, min_phys);
> >>  }
> >> @@ -257,6 +255,26 @@ static int kvm_timer_update_state(struct kvm_vcpu *vcpu)
> >>  }
> >>
> >>  /*
> >> + * Schedule the background timer for the emulated timer. The background timer
> >> + * runs whenever vcpu is runnable and the timer is not expired.
> >> + */
> >> +static void kvm_timer_emulate(struct kvm_vcpu *vcpu,
> >> +                    struct arch_timer_context *timer_ctx)
> >> +{
> >> +     struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
> >> +
> >> +     if (kvm_timer_should_fire(vcpu, timer_ctx))
> >> +             return;
> >> +
> >> +     if (!kvm_timer_irq_can_fire(timer_ctx))
> >> +             return;
> >> +
> >> +     /*  The timer has not yet expired, schedule a background timer */
> >> +     timer_disarm(timer);
> >> +     timer_arm(timer, kvm_timer_compute_delta(vcpu, timer_ctx));
> >
> > I'm wondering what the effect of this thing really is.  Isn't the soft
> > timer programmed in timer_arm() based on Linux's own timekeeping
> > schedule, such that the physical timer will be programmed to the next
> > tick, regardless of what you program here, so all you have to do is
> > check if you need to inject the phys timer on entry to the VM?
> >
> > On the other hand, if this can cause Linux to program the phys timer to
> > expire sooner, then I guess it makes sense.  Thinking about it, would
> > that be the case on a tickless system?
> 
> I don't have a good answer for this, so I'll get back to you!
> 
> >
> >> +}
> >> +
> >> +/*
> >>   * Schedule the background timer before calling kvm_vcpu_block, so that this
> >>   * thread is removed from its waitqueue and made runnable when there's a timer
> >>   * interrupt to handle.
> >> @@ -267,8 +285,6 @@ void kvm_timer_schedule(struct kvm_vcpu *vcpu)
> >>       struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
> >>       struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
> >>
> >> -     BUG_ON(timer_is_armed(timer));
> >> -
> >>       /*
> >>        * No need to schedule a background timer if any guest timer has
> >>        * already expired, because kvm_vcpu_block will return before putting
> >> @@ -290,13 +306,21 @@ void kvm_timer_schedule(struct kvm_vcpu *vcpu)
> >>        * The guest timers have not yet expired, schedule a background timer.
> >>        * Pick smaller expiration time between phys and virt timer.
> >>        */
> >> +     timer_disarm(timer);
> >>       timer_arm(timer, kvm_timer_min_block(vcpu));
> >>  }
> >>
> >>  void kvm_timer_unschedule(struct kvm_vcpu *vcpu)
> >>  {
> >>       struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
> >> +
> >>       timer_disarm(timer);
> >> +
> >> +     /*
> >> +      * Now we return from the blocking. If we have any timer to emulate,
> >> +      * and it's not expired, set the background timer for it.
> >> +      */
> >> +     kvm_timer_emulate(vcpu, vcpu_ptimer(vcpu));
> >
> > hmm, this is only called when returning from the kvm_vcpu_block() path.
> > What about when you do vcpu_load/put, don't you need to schedule/cancel
> > it there too?
> 
> We can do that, but I think that's not necessary. Firing the physical
> timer while a vcpu is unloaded doesn't affect the task scheduling. Or
> is it awkward to do so?
> 

Not sure I understand your question.

> >
> > Maybe it's simpler to just program the soft timer during flush_hwstate
> > and cancel the timer during sync_hwstate.  Does that work?
> 
> As far as I remember, it worked. I agree that it's simpler.
> But as I mentioned in the patch [8/8] reply this *may* cause more overhead.
> 

I think you should go for something we can easily convince ourselves
will work initially, and then we can measure if there's significant
overhead and improve on that.

At least we should have a clear idea of the when to schedule software
timers and why.

We know from my RFC series to optimize the timer behavior that on some
systems, not having to read/write the timer registers on every put/load
can save us a few hundred cycles, so it's not extremely expensive, but
we should at the same time avoid it if possible.

Assuming most guests will use the virt timer for now, if we can just
have an initial check on both flush/sync if the ptimer is even enabled,
and only do extra work when that's the case, then I think that would be
a good start.

Thanks,
-Christoffer
