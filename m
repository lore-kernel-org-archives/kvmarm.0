From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3 07/20] KVM: arm/arm64: Make timer_arm and timer_disarm helpers more generic
Date: Wed, 18 Oct 2017 17:53:23 +0100
Message-ID: <87o9p4ieik.fsf@on-the-bus.cambridge.arm.com>
References: <20170923004207.22356-1-cdall@linaro.org>
        <20170923004207.22356-8-cdall@linaro.org>
        <f593256a-3f37-0f4c-ba9d-913481a95e0b@arm.com>
        <20171018164750.GI8900@cbox>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20171018164750.GI8900@cbox> (Christoffer Dall's message of "Wed,
        18 Oct 2017 18:47:50 +0200")
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Oct 18 2017 at  6:47:50 pm BST, Christoffer Dall <cdall@linaro.org> wrote:
> On Mon, Oct 09, 2017 at 06:05:04PM +0100, Marc Zyngier wrote:
>> On 23/09/17 01:41, Christoffer Dall wrote:
>> > We are about to add an additional soft timer to the arch timer state for
>> > a VCPU and would like to be able to reuse the functions to program and
>> > cancel a timer, so we make them slightly more generic and rename to make
>> > it more clear that these functions work on soft timers and not the
>> > hardware resource that this code is managing.
>> > 
>> > Signed-off-by: Christoffer Dall <cdall@linaro.org>
>> > ---
>> >  virt/kvm/arm/arch_timer.c | 33 ++++++++++++++++-----------------
>> >  1 file changed, 16 insertions(+), 17 deletions(-)
>> > 
>> > diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
>> > index 8e89d63..871d8ae 100644
>> > --- a/virt/kvm/arm/arch_timer.c
>> > +++ b/virt/kvm/arm/arch_timer.c
>> > @@ -56,26 +56,22 @@ u64 kvm_phys_timer_read(void)
>> >  	return timecounter->cc->read(timecounter->cc);
>> >  }
>> >  
>> > -static bool timer_is_armed(struct arch_timer_cpu *timer)
>> > +static bool soft_timer_is_armed(struct arch_timer_cpu *timer)
>> >  {
>> >  	return timer->armed;
>> >  }
>> >  
>> > -/* timer_arm: as in "arm the timer", not as in ARM the company */
>> > -static void timer_arm(struct arch_timer_cpu *timer, u64 ns)
>> > +static void soft_timer_start(struct hrtimer *hrt, u64 ns)
>> >  {
>> > -	timer->armed = true;
>> > -	hrtimer_start(&timer->timer, ktime_add_ns(ktime_get(), ns),
>> > +	hrtimer_start(hrt, ktime_add_ns(ktime_get(), ns),
>> >  		      HRTIMER_MODE_ABS);
>> >  }
>> >  
>> > -static void timer_disarm(struct arch_timer_cpu *timer)
>> > +static void soft_timer_cancel(struct hrtimer *hrt, struct work_struct *work)
>> >  {
>> > -	if (timer_is_armed(timer)) {
>> > -		hrtimer_cancel(&timer->timer);
>> > -		cancel_work_sync(&timer->expired);
>> > -		timer->armed = false;
>> > -	}
>> > +	hrtimer_cancel(hrt);
>> > +	if (work)
>> 
>> When can this happen? Something in a following patch?
>> 
>
> Yeah, sorry about that.  I will point this out in the commit message.
>
>> > +		cancel_work_sync(work);
>> >  }
>> >  
>> >  static irqreturn_t kvm_arch_timer_handler(int irq, void *dev_id)
>> > @@ -271,7 +267,7 @@ static void kvm_timer_emulate(struct kvm_vcpu *vcpu,
>> >  		return;
>> >  
>> >  	/*  The timer has not yet expired, schedule a background timer */
>> > -	timer_arm(timer, kvm_timer_compute_delta(timer_ctx));
>> > +	soft_timer_start(&timer->timer, kvm_timer_compute_delta(timer_ctx));
>> >  }
>> >  
>> >  /*
>> > @@ -285,7 +281,7 @@ void kvm_timer_schedule(struct kvm_vcpu *vcpu)
>> >  	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
>> >  	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
>> >  
>> > -	BUG_ON(timer_is_armed(timer));
>> > +	BUG_ON(soft_timer_is_armed(timer));
>> >  
>> >  	/*
>> >  	 * No need to schedule a background timer if any guest timer has
>> > @@ -306,13 +302,16 @@ void kvm_timer_schedule(struct kvm_vcpu *vcpu)
>> >  	 * The guest timers have not yet expired, schedule a background timer.
>> >  	 * Set the earliest expiration time among the guest timers.
>> >  	 */
>> > -	timer_arm(timer, kvm_timer_earliest_exp(vcpu));
>> > +	timer->armed = true;
>> > +	soft_timer_start(&timer->timer, kvm_timer_earliest_exp(vcpu));
>> >  }
>> >  
>> >  void kvm_timer_unschedule(struct kvm_vcpu *vcpu)
>> >  {
>> >  	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
>> > -	timer_disarm(timer);
>> > +
>> > +	soft_timer_cancel(&timer->timer, &timer->expired);
>> > +	timer->armed = false;
>> >  }
>> >  
>> >  static void kvm_timer_flush_hwstate_vgic(struct kvm_vcpu *vcpu)
>> > @@ -448,7 +447,7 @@ void kvm_timer_sync_hwstate(struct kvm_vcpu *vcpu)
>> >  	 * This is to cancel the background timer for the physical timer
>> >  	 * emulation if it is set.
>> >  	 */
>> > -	timer_disarm(timer);
>> > +	soft_timer_cancel(&timer->timer, &timer->expired);
>> 
>> timer_disarm() used to set timer->armed to false, but that's not the
>> case any more. Don't we risk hitting the BUG_ON() in kvm_timer_schedule
>> if we hit WFI?
>> 
>
> We do, and I just didn't hit that because this goes away at the end of
> the series, and I didn't vigurously test every single patch in the
> series (just a compile test).
>
> We actually only use the armed flag for the BUG_ON(), and I don't think
> we need that check really.  So I suggest simply merging this logic into
> this patch:
>
> diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
> index f0053f884b4a..d0beae98f755 100644
> --- a/include/kvm/arm_arch_timer.h
> +++ b/include/kvm/arm_arch_timer.h
> @@ -48,9 +48,6 @@ struct arch_timer_cpu {
>  	/* Work queued with the above timer expires */
>  	struct work_struct		expired;
>  
> -	/* Background timer active */
> -	bool				armed;
> -
>  	/* Is the timer enabled */
>  	bool			enabled;
>  };
> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
> index 871d8ae52f9b..98643bc696a9 100644
> --- a/virt/kvm/arm/arch_timer.c
> +++ b/virt/kvm/arm/arch_timer.c
> @@ -56,11 +56,6 @@ u64 kvm_phys_timer_read(void)
>  	return timecounter->cc->read(timecounter->cc);
>  }
>  
> -static bool soft_timer_is_armed(struct arch_timer_cpu *timer)
> -{
> -	return timer->armed;
> -}
> -
>  static void soft_timer_start(struct hrtimer *hrt, u64 ns)
>  {
>  	hrtimer_start(hrt, ktime_add_ns(ktime_get(), ns),
> @@ -281,8 +276,6 @@ void kvm_timer_schedule(struct kvm_vcpu *vcpu)
>  	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
>  	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
>  
> -	BUG_ON(soft_timer_is_armed(timer));
> -
>  	/*
>  	 * No need to schedule a background timer if any guest timer has
>  	 * already expired, because kvm_vcpu_block will return before putting
> @@ -302,7 +295,6 @@ void kvm_timer_schedule(struct kvm_vcpu *vcpu)
>  	 * The guest timers have not yet expired, schedule a background timer.
>  	 * Set the earliest expiration time among the guest timers.
>  	 */
> -	timer->armed = true;
>  	soft_timer_start(&timer->timer, kvm_timer_earliest_exp(vcpu));
>  }
>  
> @@ -311,7 +303,6 @@ void kvm_timer_unschedule(struct kvm_vcpu *vcpu)
>  	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
>  
>  	soft_timer_cancel(&timer->timer, &timer->expired);
> -	timer->armed = false;
>  }
>  
>  static void kvm_timer_flush_hwstate_vgic(struct kvm_vcpu *vcpu)

Yes, this seems like a sensible thing to do.

Thanks,

	M.
-- 
Jazz is not dead, it just smell funny.
