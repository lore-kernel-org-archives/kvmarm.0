Return-Path: <SRS0=T7gh=UM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F8D9C31E45
	for <kvmarm@archiver.kernel.org>; Thu, 13 Jun 2019 15:45:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AC9E5206BB
	for <kvmarm@archiver.kernel.org>; Thu, 13 Jun 2019 15:45:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AC9E5206BB
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D295D4A4A0;
	Thu, 13 Jun 2019 11:45:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id OYWjqBCzlpPf; Thu, 13 Jun 2019 11:45:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4B0394A4F4;
	Thu, 13 Jun 2019 11:45:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CA1714A4A0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 Jun 2019 11:45:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wLeOGgg9B4ks for <kvmarm@lists.cs.columbia.edu>;
 Thu, 13 Jun 2019 11:45:13 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 233D94A483
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 Jun 2019 11:45:13 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9437B367;
 Thu, 13 Jun 2019 08:45:12 -0700 (PDT)
Received: from localhost (e113682-lin.copenhagen.arm.com [10.32.144.41])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2700B3F246;
 Thu, 13 Jun 2019 08:45:12 -0700 (PDT)
Date: Thu, 13 Jun 2019 17:45:10 +0200
From: Christoffer Dall <christoffer.dall@arm.com>
To: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] KVM: arm/arm64: fix emulated ptimer irq injection
Message-ID: <20190613154510.GA32647@e113682-lin.lund.arm.com>
References: <20190528110152.GA6775@e113682-lin.lund.arm.com>
 <3f9d398b-3be2-5988-d3f9-01b28c4ccb1c@arm.com>
 <20190528131215.GB6775@e113682-lin.lund.arm.com>
 <20190528134044.olzox3c5xdhf3b4l@kamzik.brq.redhat.com>
 <b76516f8-0d28-4683-ea25-28bfc2ccce62@arm.com>
 <20190529090849.GC6775@e113682-lin.lund.arm.com>
 <058e239f-c29b-eec2-c599-f6fe03f76174@arm.com>
 <20190529100310.GD6775@e113682-lin.lund.arm.com>
 <20190603121440.dsmmv3b55lzmjsqa@kamzik.brq.redhat.com>
 <86lfy5by7u.wl-marc.zyngier@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <86lfy5by7u.wl-marc.zyngier@arm.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Cc: kvmarm@lists.cs.columbia.edu
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Thu, Jun 13, 2019 at 11:01:41AM +0100, Marc Zyngier wrote:
> On Mon, 03 Jun 2019 13:14:40 +0100,
> Andrew Jones <drjones@redhat.com> wrote:
> > 
> > On Wed, May 29, 2019 at 12:03:11PM +0200, Christoffer Dall wrote:
> > > On Wed, May 29, 2019 at 10:13:21AM +0100, Marc Zyngier wrote:
> > > > On 29/05/2019 10:08, Christoffer Dall wrote:
> > > > > On Tue, May 28, 2019 at 05:08:53PM +0100, Marc Zyngier wrote:
> > > > >> On 28/05/2019 14:40, Andrew Jones wrote:
> > > > >>> On Tue, May 28, 2019 at 03:12:15PM +0200, Christoffer Dall wrote:
> > > > >>>> On Tue, May 28, 2019 at 01:25:52PM +0100, Marc Zyngier wrote:
> > > > >>>>> On 28/05/2019 12:01, Christoffer Dall wrote:
> > > > >>>>>> On Mon, May 27, 2019 at 01:46:19PM +0200, Andrew Jones wrote:
> > > > >>>>>>> The emulated ptimer needs to track the level changes, otherwise the
> > > > >>>>>>> the interrupt will never get deasserted, resulting in the guest getting
> > > > >>>>>>> stuck in an interrupt storm if it enables ptimer interrupts. This was
> > > > >>>>>>> found with kvm-unit-tests; the ptimer tests hung as soon as interrupts
> > > > >>>>>>> were enabled. Typical Linux guests don't have a problem as they prefer
> > > > >>>>>>> using the virtual timer.
> > > > >>>>>>>
> > > > >>>>>>> Fixes: bee038a674875 ("KVM: arm/arm64: Rework the timer code to use a timer_map")
> > > > >>>>>>> Signed-off-by: Andrew Jones <drjones@redhat.com>
> > > > >>>>>>> ---
> > > > >>>>>>>  virt/kvm/arm/arch_timer.c | 7 ++++++-
> > > > >>>>>>>  1 file changed, 6 insertions(+), 1 deletion(-)
> > > > >>>>>>>
> > > > >>>>>>> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
> > > > >>>>>>> index 7fc272ecae16..9f5d8cc8b5e5 100644
> > > > >>>>>>> --- a/virt/kvm/arm/arch_timer.c
> > > > >>>>>>> +++ b/virt/kvm/arm/arch_timer.c
> > > > >>>>>>> @@ -324,10 +324,15 @@ static void kvm_timer_update_irq(struct kvm_vcpu *vcpu, bool new_level,
> > > > >>>>>>>  static void timer_emulate(struct arch_timer_context *ctx)
> > > > >>>>>>>  {
> > > > >>>>>>>  	bool should_fire = kvm_timer_should_fire(ctx);
> > > > >>>>>>> +	struct timer_map map;
> > > > >>>>>>> +
> > > > >>>>>>> +	get_timer_map(ctx->vcpu, &map);
> > > > >>>>>>>  
> > > > >>>>>>>  	trace_kvm_timer_emulate(ctx, should_fire);
> > > > >>>>>>>  
> > > > >>>>>>> -	if (should_fire) {
> > > > >>>>>>> +	if (ctx == map.emul_ptimer && should_fire != ctx->irq.level) {
> > > > >>>>>>> +		kvm_timer_update_irq(ctx->vcpu, !ctx->irq.level, ctx);
> > > > >>>>>>> +	} else if (should_fire) {
> > > > >>>>>>>  		kvm_timer_update_irq(ctx->vcpu, true, ctx);
> > > > >>>>>>>  		return;
> > > > >>>>>>>  	}
> > > > >>>>>>
> > > > >>>>>> Hmm, this doesn't feel completely right.
> > > > >>>
> > > > >>> I won't try to argue that this is the right fix, as I haven't fully
> > > > >>> grasped how all this code works, but, afaict, this is how it worked
> > > > >>> prior to bee038a6.
> > > > >>>
> > > > >>>>>>
> > > > >>>>>> Lowering the line of an emulated timer should only ever happen when the
> > > > >>>>>> guest (or user space) writes to one of the system registers for that
> > > > >>>>>> timer, which should be trapped and that should cause an update of the
> > > > >>>>>> line.
> > > > >>>>>>
> > > > >>>>>> Are we missing a call to kvm_timer_update_irq() from
> > > > >>>>>> kvm_arm_timer_set_reg() ?
> > > > >>>>>
> > > > >>>>> Which is exactly what we removed in 6bc210003dff, for good reasons.
> > > > >>>>>
> > > > >>>>
> > > > >>>> Ah well, I can be wrong twice.  Or even three times.
> > > > >>>>
> > > > >>>>> Looking at kvm_arm_timer_write_sysreg(), we end-up calling kvm_timer_vcpu_load, but not updating the irq status.
> > > > >>>>>
> > > > >>>>> How about something like this instead (untested):
> > > > >>>>>
> > > > >>>>> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
> > > > >>>>> index 7fc272ecae16..6a418dcc5433 100644
> > > > >>>>> --- a/virt/kvm/arm/arch_timer.c
> > > > >>>>> +++ b/virt/kvm/arm/arch_timer.c
> > > > >>>>> @@ -882,10 +882,14 @@ void kvm_arm_timer_write_sysreg(struct kvm_vcpu *vcpu,
> > > > >>>>>  				enum kvm_arch_timer_regs treg,
> > > > >>>>>  				u64 val)
> > > > >>>>>  {
> > > > >>>>> +	struct arch_timer_context *timer;
> > > > >>>>> +
> > > > >>>>>  	preempt_disable();
> > > > >>>>>  	kvm_timer_vcpu_put(vcpu);
> > > > >>>>>  
> > > > >>>>> -	kvm_arm_timer_write(vcpu, vcpu_get_timer(vcpu, tmr), treg, val);
> > > > >>>>> +	timer = vcpu_get_timer(vcpu, tmr);
> > > > >>>>> +	kvm_arm_timer_write(vcpu, timer, treg, val);
> > > > >>>>> +	kvm_timer_update_irq(vcpu, kvm_timer_should_fire(timer), timer);
> > > > >>>>>  
> > > > >>>>>  	kvm_timer_vcpu_load(vcpu);
> > > > >>>>>  	preempt_enable();
> > > > >>>>>
> > > > >>>
> > > > >>> Marc, I've tested this and it resolves the issue for me. If/when you post
> > > > >>> it you can add a t-b from me if you like.
> > > > >>>
> > > > >>>>
> > > > >>>> Yes, that looks reasonable.  Basically, in 6bc210003dff we should have
> > > > >>>> only removed the call to timer_emulate, and not messed around with
> > > > >>>> kvm_timer_update_irq()?
> > > > >>>>
> > > > >>>> After this patch, we'll have moved the call to kvm_timer_update_irq()
> > > > >>>> from kvm_arm_timer_set_reg() to kvm_arm_timer_write_sysreg().  I can't
> > > > >>>> seem to decide if clearly belongs in one place or the other.
> > > > >>>>
> > > > >>>
> > > > >>> Isn't kvm_arm_timer_set_reg() only for userspace setting of the register?
> > > > >>> In this test case I don't think userspace is involved at that point.
> > > > >>
> > > > >> It still remains that userspace writing to any of the registers has an
> > > > >> effect on the interrupt line. Or rather that it should.
> > > > >>
> > > > >> And the more I look at this, the more I have the feeling this thing
> > > > >> should happen on kvm_timer_vcpu_load(), wherever the writes comes from.
> > > > >> It'd have slightly more overhead than doing it from every register
> > > > >> access path, but at least it'd be clearer... Untested, again.
> > > > >>
> > > > >> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
> > > > >> index 7fc272ecae16..8244e40af196 100644
> > > > >> --- a/virt/kvm/arm/arch_timer.c
> > > > >> +++ b/virt/kvm/arm/arch_timer.c
> > > > >> @@ -557,8 +557,12 @@ void kvm_timer_vcpu_load(struct kvm_vcpu *vcpu)
> > > > >>  	if (map.direct_ptimer)
> > > > >>  		timer_restore_state(map.direct_ptimer);
> > > > >>  
> > > > >> -	if (map.emul_ptimer)
> > > > >> +	if (map.emul_ptimer) {
> > > > >> +		kvm_timer_update_irq(vcpu,
> > > > >> +				     kvm_timer_should_fire(map.emul_ptimer),
> > > > >> +				     map.emul_ptimer);
> > > > >>  		timer_emulate(map.emul_ptimer);
> > > > >> +	}
> > > > >>  }
> > > > >>  
> > > > >>  bool kvm_timer_should_notify_user(struct kvm_vcpu *vcpu)
> > > > >>
> > > > > 
> > > > > But do we do the put/load dance when we trap a write to a register from
> > > > > the VM ?
> > > > 
> > > > Yup, that's what kvm_arm_timer_write_sysreg() does:
> > > > 
> > > > 	preempt_disable();
> > > > 	kvm_timer_vcpu_put(vcpu);
> > > > 
> > > > 	kvm_arm_timer_write(vcpu, vcpu_get_timer(vcpu, tmr), treg, val);
> > > > 
> > > > 	kvm_timer_vcpu_load(vcpu);
> > > > 	preempt_enable();
> > > > 
> > > 
> > > Ah, I missed that.  In that case, fair enough.  The only question then
> > > is if we should unconditionally do this in timer_emulate (almost Drew's
> > > original patch) or do it here in vcpu_load ?
> > > 
> > > I don't remember how the nesting code looks like, but when it will start
> > > to use emul_vtimer, we now need to do this for both, which would be an
> > > argument for doing it in timer_emulate, I believe.
> > > 
> > > Also, a nice comment in there why this is necessary (i.e. for handling
> > > proper emulation when trapping sysreg changes) would probably be
> > > worthwhile.
> > >
> > 
> > Any more thoughts on how to proceed with this? FWIW, I found a commit[*]
> > that indicates kvm_timer_vcpu_load() was at least once the correct place.
> > 
> > [*] 245715cbe83c ("KVM: arm/arm64: Fix lost IRQs from emulated physcial timer
> > when blocked", 2018-07-25)
> 
> Coming back to this: I wonder if the simplest fix isn't a small
> variation on your initial patch:
> 
> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
> index 7fc272ecae16..1b1c449ceaf4 100644
> --- a/virt/kvm/arm/arch_timer.c
> +++ b/virt/kvm/arm/arch_timer.c
> @@ -321,14 +321,15 @@ static void kvm_timer_update_irq(struct kvm_vcpu *vcpu, bool new_level,
>  	}
>  }
>  
> +/* Only called for a fully emulated timer */
>  static void timer_emulate(struct arch_timer_context *ctx)
>  {
>  	bool should_fire = kvm_timer_should_fire(ctx);
>  
>  	trace_kvm_timer_emulate(ctx, should_fire);
>  
> -	if (should_fire) {
> -		kvm_timer_update_irq(ctx->vcpu, true, ctx);
> +	if (should_fire != ctx->irq.level) {
> +		kvm_timer_update_irq(ctx->vcpu, should_fire, ctx);
>  		return;
>  	}
>  
> It fixes the emulated ptimer for me (just gave KVM unit tests a
> go). The rational is that we only come here for the emulated ptimer
> already (from vcpu_load), so the whole test can be simplified.

This is what I had in mind as well.

> 
> Christoffer, am I missing anything with respect to cancelling the
> timer by always returning early?
> 

Always returning early?  Not sure I understand.

Thanks,

    Christoffer
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
