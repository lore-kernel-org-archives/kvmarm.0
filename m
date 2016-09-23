From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v5] KVM: arm/arm64: Route vtimer events to user space
Date: Fri, 23 Sep 2016 11:22:48 +0200
Message-ID: <20160923092248.GF9101@cbox>
References: <1474548769-195643-1-git-send-email-agraf@suse.de>
 <20160922212831.GD9101@cbox>
 <d90f04d4-b29f-f08e-df39-ec307af44225@suse.de>
 <63a1e3a2-f551-017f-b6be-593b53a0b407@redhat.com>
 <7afbc08e-0ba2-d6fd-c1ed-e5822e05c00b@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EF76E49B59
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Sep 2016 05:13:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3M9WHa5P476J for <kvmarm@lists.cs.columbia.edu>;
 Fri, 23 Sep 2016 05:13:29 -0400 (EDT)
Received: from mail-wm0-f54.google.com (mail-wm0-f54.google.com [74.125.82.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8169049B46
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Sep 2016 05:13:29 -0400 (EDT)
Received: by mail-wm0-f54.google.com with SMTP id l132so18640581wmf.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Sep 2016 02:22:40 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <7afbc08e-0ba2-d6fd-c1ed-e5822e05c00b@suse.de>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Alexander Graf <agraf@suse.de>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Sep 23, 2016 at 11:10:46AM +0200, Alexander Graf wrote:
> 
> 
> On 23.09.16 10:57, Paolo Bonzini wrote:
> > 
> > 
> > On 23/09/2016 09:14, Alexander Graf wrote:
> >>>> +/*
> >>>> + * Synchronize the timer IRQ state with the interrupt controller.
> >>>> + */
> >>>>  static void kvm_timer_update_irq(struct kvm_vcpu *vcpu, bool new_level)
> >>>>  {
> >>>>  	int ret;
> >>>>  	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
> >>>>  
> >>>>  	timer->active_cleared_last = false;
> >>>>  	timer->irq.level = new_level;
> >>>> -	trace_kvm_timer_update_irq(vcpu->vcpu_id, timer->irq.irq,
> >>>> +	trace_kvm_timer_update_irq(vcpu->vcpu_id, host_vtimer_irq,
> >>>>  				   timer->irq.level);
> >>>> +	[...]
> >>>> +		struct kvm_sync_regs *regs = &vcpu->run->s.regs;
> >>>> +
> >>>> +		/* Populate the timer bitmap for user space */
> >>>> +		regs->kernel_timer_pending &= ~KVM_ARM_TIMER_VTIMER;
> >>>> +		if (new_level)
> >>>> +			regs->kernel_timer_pending |= KVM_ARM_TIMER_VTIMER;
> >>>
> >>> I think if you got here, it means you have to exit to userspace to
> >>> update it of the new state.  If you don't want to propagate a return
> >>
> >> Yes, but we can't exit straight away with our own exit reason because we
> >> might be inside an MMIO exit path here which already occupies the
> >> exit_reason.
> > 
> > So the idea is that whenever you're here you have one of the following
> > cases:
> > 
> > - are coming from kvm_timer_flush_hwstate, and then you exit immediately
> > with KVM_EXIT_INTR if needed
> > 
> > - you are coming from the kvm_timer_sync_hwstate just before
> > handle_exit.  Then if there's a vmexit you have already set
> > regs->kernel_timer_pending, if not you'll do a kvm_timer_flush_hwstate soon.
> > 
> > - you are coming from the kvm_timer_sync_hwstate in the middle of
> > kvm_arch_vcpu_ioctl_run, and then "continue" will either exit the loop
> > immediately (if ret <= 0) or go to kvm_timer_flush_hwstate as in the
> > previous case
> > 
> > Right?
> 
> Yup :)
> 
> > 
> >>> Maybe I'm misunderstanding and user_timer_pending is just a cached
> >>> verison of what you said last, but as I said above, I think you can just
> >>> compare timer->irq.level with the last value the kvm_run struct, and if
> >>> something changed, you have to exit.
> >>
> >> So how would user space know whether the line went up or down? Or didn't
> >> change at all (if we coalesce with an MMIO exit)?
> > 
> > It would save the status of the line somewhere in its own variable,
> > without introducing a relatively delicate API between kernel and user.
> > 
> > I agree that you cannot update kernel_timer_pending only in
> > flush_hwstate; otherwise you miss on case (2) when there is a vmexit.
> > That has to stay in kvm_timer_sync_hwstate (or it could become a new
> > function called at the very end of kvm_arch_vcpu_ioctl_run).
> 
> The beauty of having it in the timer update function is that it gets
> called from flush_hwstate() as well. That way we catch the update also
> in cases where we need it before we enter the vcpu.
> 
> > However, I'm not sure why user_timer_pending is necessary.  If it is
> > just the value you assigned to regs->kernel_timer_pending at the time of
> > the previous vmexit, can kvm_timer_flush_hwstate just do
> > 
> >    if (timer->prev_kernel_timer_pending != regs->kernel_timer_pending) {
> >        timer->prev_kernel_timer_pending = regs->kernel_timer_pending;
> >        return 1;
> >    }
> > 
> > ?  Or even
> > 
> >    if (timer->prev_irq_level != timer->irq.level) {
> >        timer->prev_irq_level = regs->irq.level;
> >        return 1;
> >    }
> > 
> > so that regs->kernel_timer_pending remains exclusively
> > kvm_timer_sync_hwstate's business?
> 
> We could do that too, yes. But it puts more burden on user space - it
> would have to ensure that it *always* checks for the pending timer
> status. With this approach, user space may opt to only check for timer
> state changes on -EINTR and things would still work.
> 
Huh?  I thought the whole point was that you could piggy back on an MMIO
exit with a change in the line state, for example.  So I don't
understand this.

In any case, exposing internal historical state only used by the kernel
to figure out whether or not it should force an exit if there's not
already one happening, to user space, just feels weird to me, and my
emphasis is on having a clean timer emulation component in the kernel
where the semantics are clear.  Have a look at my proposal in the other
mail on this thread.

-Christoffer
