From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 2/9] arm/arm64: KVM: arch_timer: Only schedule soft timer
 on vcpu_block
Date: Thu, 3 Sep 2015 18:09:24 +0200
Message-ID: <20150903160924.GF5171@cbox>
References: <1440942866-23802-1-git-send-email-christoffer.dall@linaro.org>
 <1440942866-23802-3-git-send-email-christoffer.dall@linaro.org>
 <55E85C87.8060704@arm.com> <20150903145838.GE5171@cbox>
 <55E86CF2.8050902@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 00E054156D
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Sep 2015 12:07:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id M4RnniqX09TM for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Sep 2015 12:07:34 -0400 (EDT)
Received: from mail-lb0-f174.google.com (mail-lb0-f174.google.com
 [209.85.217.174])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 86F734141D
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Sep 2015 12:07:34 -0400 (EDT)
Received: by lbpo4 with SMTP id o4so27300778lbp.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 03 Sep 2015 09:07:57 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <55E86CF2.8050902@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Sep 03, 2015 at 04:53:22PM +0100, Marc Zyngier wrote:
> On 03/09/15 15:58, Christoffer Dall wrote:
> > On Thu, Sep 03, 2015 at 03:43:19PM +0100, Marc Zyngier wrote:
> >> On 30/08/15 14:54, Christoffer Dall wrote:
> >>> We currently schedule a soft timer every time we exit the guest if the
> >>> timer did not expire while running the guest.  This is really not
> >>> necessary, because the only work we do in the timer work function is to
> >>> kick the vcpu.
> >>>
> >>> Kicking the vcpu does two things:
> >>> (1) If the vpcu thread is on a waitqueue, make it runnable and remove it
> >>> from the waitqueue.
> >>> (2) If the vcpu is running on a different physical CPU from the one
> >>> doing the kick, it sends a reschedule IPI.
> >>>
> >>> The second case cannot happen, because the soft timer is only ever
> >>> scheduled when the vcpu is not running.  The first case is only relevant
> >>> when the vcpu thread is on a waitqueue, which is only the case when the
> >>> vcpu thread has called kvm_vcpu_block().
> >>>
> >>> Therefore, we only need to make sure a timer is scheduled for
> >>> kvm_vcpu_block(), which we do by encapsulating all calls to
> >>> kvm_vcpu_block() with kvm_timer_{un}schedule calls.
> >>>
> >>> Additionally, we only schedule a soft timer if the timer is enabled and
> >>> unmasked, since it is useless otherwise.
> >>>
> >>> Note that theoretically userspace can use the SET_ONE_REG interface to
> >>> change registers that should cause the timer to fire, even if the vcpu
> >>> is blocked without a scheduled timer, but this case was not supported
> >>> before this patch and we leave it for future work for now.
> >>>
> >>> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> >>> ---
> >>>  arch/arm/include/asm/kvm_host.h   |  3 --
> >>>  arch/arm/kvm/arm.c                | 10 +++++
> >>>  arch/arm64/include/asm/kvm_host.h |  3 --
> >>>  include/kvm/arm_arch_timer.h      |  2 +
> >>>  virt/kvm/arm/arch_timer.c         | 89 +++++++++++++++++++++++++--------------
> >>>  5 files changed, 70 insertions(+), 37 deletions(-)
> >>>
> >>> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
> >>> index 86fcf6e..dcba0fa 100644
> >>> --- a/arch/arm/include/asm/kvm_host.h
> >>> +++ b/arch/arm/include/asm/kvm_host.h
> >>> @@ -236,7 +236,4 @@ static inline void kvm_arm_setup_debug(struct kvm_vcpu *vcpu) {}
> >>>  static inline void kvm_arm_clear_debug(struct kvm_vcpu *vcpu) {}
> >>>  static inline void kvm_arm_reset_debug_ptr(struct kvm_vcpu *vcpu) {}
> >>>  
> >>> -static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu) {}
> >>> -static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
> >>> -
> >>>  #endif /* __ARM_KVM_HOST_H__ */
> >>> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
> >>> index ce404a5..bdf8871 100644
> >>> --- a/arch/arm/kvm/arm.c
> >>> +++ b/arch/arm/kvm/arm.c
> >>> @@ -271,6 +271,16 @@ int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
> >>>  	return kvm_timer_should_fire(vcpu);
> >>>  }
> >>>  
> >>> +void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu)
> >>> +{
> >>> +	kvm_timer_schedule(vcpu);
> >>> +}
> >>> +
> >>> +void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu)
> >>> +{
> >>> +	kvm_timer_unschedule(vcpu);
> >>> +}
> >>> +
> >>>  int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
> >>>  {
> >>>  	/* Force users to call KVM_ARM_VCPU_INIT */
> >>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> >>> index dd143f5..415938d 100644
> >>> --- a/arch/arm64/include/asm/kvm_host.h
> >>> +++ b/arch/arm64/include/asm/kvm_host.h
> >>> @@ -257,7 +257,4 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu);
> >>>  void kvm_arm_clear_debug(struct kvm_vcpu *vcpu);
> >>>  void kvm_arm_reset_debug_ptr(struct kvm_vcpu *vcpu);
> >>>  
> >>> -static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu) {}
> >>> -static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
> >>> -
> >>>  #endif /* __ARM64_KVM_HOST_H__ */
> >>> diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
> >>> index e1e4d7c..ef14cc1 100644
> >>> --- a/include/kvm/arm_arch_timer.h
> >>> +++ b/include/kvm/arm_arch_timer.h
> >>> @@ -71,5 +71,7 @@ u64 kvm_arm_timer_get_reg(struct kvm_vcpu *, u64 regid);
> >>>  int kvm_arm_timer_set_reg(struct kvm_vcpu *, u64 regid, u64 value);
> >>>  
> >>>  bool kvm_timer_should_fire(struct kvm_vcpu *vcpu);
> >>> +void kvm_timer_schedule(struct kvm_vcpu *vcpu);
> >>> +void kvm_timer_unschedule(struct kvm_vcpu *vcpu);
> >>>  
> >>>  #endif
> >>> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
> >>> index 76e38d2..018f3d6 100644
> >>> --- a/virt/kvm/arm/arch_timer.c
> >>> +++ b/virt/kvm/arm/arch_timer.c
> >>> @@ -111,14 +111,21 @@ static enum hrtimer_restart kvm_timer_expire(struct hrtimer *hrt)
> >>>  	return HRTIMER_NORESTART;
> >>>  }
> >>>  
> >>> +static bool kvm_timer_irq_enabled(struct kvm_vcpu *vcpu)
> >>> +{
> >>> +	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
> >>> +
> >>> +	return !(timer->cntv_ctl & ARCH_TIMER_CTRL_IT_MASK) &&
> >>> +		(timer->cntv_ctl & ARCH_TIMER_CTRL_ENABLE) &&
> >>> +		!kvm_vgic_get_phys_irq_active(timer->map);
> >>> +}
> >>
> >> Nit: To me, this is not a predicate for "IRQ enabled", but "IRQ can
> >> fire" instead, which seems to complement the kvm_timer_should_fire just
> >> below.
> >>
> > 
> > so you're suggesting kvm_timer_irq_can_fire (or
> > kvm_timer_irq_could_file) or something else?
> 
> kvm_timer_can_fire() would have my preference (but I'm known to be bad
> at picking names...).
> 
> >>> +
> >>>  bool kvm_timer_should_fire(struct kvm_vcpu *vcpu)
> >>>  {
> >>>  	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
> >>>  	cycle_t cval, now;
> >>>  
> >>> -	if ((timer->cntv_ctl & ARCH_TIMER_CTRL_IT_MASK) ||
> >>> -	    !(timer->cntv_ctl & ARCH_TIMER_CTRL_ENABLE) ||
> >>> -	    kvm_vgic_get_phys_irq_active(timer->map))
> >>> +	if (!kvm_timer_irq_enabled(vcpu))
> >>>  		return false;
> >>>  
> >>>  	cval = timer->cntv_cval;
> >>> @@ -127,24 +134,59 @@ bool kvm_timer_should_fire(struct kvm_vcpu *vcpu)
> >>>  	return cval <= now;
> >>>  }
> >>>  
> >>> -/**
> >>> - * kvm_timer_flush_hwstate - prepare to move the virt timer to the cpu
> >>> - * @vcpu: The vcpu pointer
> >>> - *
> >>> - * Disarm any pending soft timers, since the world-switch code will write the
> >>> - * virtual timer state back to the physical CPU.
> >>> +/*
> >>> + * Schedule the background timer before calling kvm_vcpu_block, so that this
> >>> + * thread is removed from its waitqueue and made runnable when there's a timer
> >>> + * interrupt to handle.
> >>>   */
> >>> -void kvm_timer_flush_hwstate(struct kvm_vcpu *vcpu)
> >>> +void kvm_timer_schedule(struct kvm_vcpu *vcpu)
> >>>  {
> >>>  	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
> >>> +	u64 ns;
> >>> +	cycle_t cval, now;
> >>> +
> >>> +	/*
> >>> +	 * No need to schedule a background timer if the guest timer has
> >>> +	 * already expired, because kvm_vcpu_block will return before putting
> >>> +	 * the thread to sleep.
> >>> +	 */
> >>> +	if (kvm_timer_should_fire(vcpu))
> >>> +		return;
> >>>  
> >>>  	/*
> >>> -	 * We're about to run this vcpu again, so there is no need to
> >>> -	 * keep the background timer running, as we're about to
> >>> -	 * populate the CPU timer again.
> >>> +	 * If the timer is either not capable of raising interrupts (disabled
> >>> +	 * or masked) or if we already have a background timer, then there's
> >>> +	 * no more work for us to do.
> >>>  	 */
> >>> +	if (!kvm_timer_irq_enabled(vcpu) || timer_is_armed(timer))
> >>> +		return;
> >>
> >> Do we need to retest kvm_timer_irq_enabled here? It is already implied
> >> by kvm_timer_should_fire...
> >>
> > 
> > yes we do, when we reach this if statement there are two cases:
> > (1) kvm_timer_irq_enabled == true but cval > now
> > (2) kvm_timer_irq_enabled == false
> > 
> > We hould only schedule a timer in in case (1), which happens exactly
> > when kvm_timer_irq_enabled == true, hence the return on the opposite.
> > Does that make sense?
> 
> It does now.
> 
> What is not completely obvious at the moment is how we can end-up with
> timer_is_armed() being true here. If a timer is already armed, it means
> we've blocked already... What am I missing?
> 
Hmm, this is probably a leftover from my development cycles.  This could
be modified to a BUG_ON, except if we start calling this function when
userspace modified the registers, but I don't remember if that's even
possible when the thread is blocked (i.e. modified from another thread).

Thanks,
-Christoffer
