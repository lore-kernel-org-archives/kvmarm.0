From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v6 7/8] KVM: arm/arm64: Provide a get_input_level for the
 arch timer
Date: Wed, 6 Dec 2017 11:59:04 +0100
Message-ID: <20171206105904.GM32397@cbox>
References: <20171204200506.3224-1-cdall@kernel.org>
 <20171204200506.3224-8-cdall@kernel.org>
 <20171205152446.rcmkowdnuhkqbrdb@yury-thinkpad>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1602C49D40
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Dec 2017 05:55:56 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id G3FlWzvLMgL2 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  6 Dec 2017 05:55:53 -0500 (EST)
Received: from mail-wm0-f68.google.com (mail-wm0-f68.google.com [74.125.82.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7B5DA49D36
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Dec 2017 05:55:53 -0500 (EST)
Received: by mail-wm0-f68.google.com with SMTP id i11so6304621wmf.4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 06 Dec 2017 02:59:06 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20171205152446.rcmkowdnuhkqbrdb@yury-thinkpad>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Yury Norov <ynorov@caviumnetworks.com>
Cc: Christoffer Dall <cdall@kernel.org>, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Dec 05, 2017 at 06:24:46PM +0300, Yury Norov wrote:
> On Mon, Dec 04, 2017 at 09:05:05PM +0100, Christoffer Dall wrote:
> > From: Christoffer Dall <christoffer.dall@linaro.org>
> > 
> > The VGIC can now support the life-cycle of mapped level-triggered
> > interrupts, and we no longer have to read back the timer state on every
> > exit from the VM if we had an asserted timer interrupt signal, because
> > the VGIC already knows if we hit the unlikely case where the guest
> > disables the timer without ACKing the virtual timer interrupt.
> > 
> > This means we rework a bit of the code to factor out the functionality
> > to snapshot the timer state from vtimer_save_state(), and we can reuse
> > this functionality in the sync path when we have an irqchip in
> > userspace, and also to support our implementation of the
> > get_input_level() function for the timer.
> > 
> > This change also means that we can no longer rely on the timer's view of
> > the interrupt line to set the active state, because we no longer
> > maintain this state for mapped interrupts when exiting from the guest.
> > Instead, we only set the active state if the virtual interrupt is
> > active, and otherwise we simply let the timer fire again and raise the
> > virtual interrupt from the ISR.
> > 
> > Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> > ---
> >  include/kvm/arm_arch_timer.h |  2 ++
> >  virt/kvm/arm/arch_timer.c    | 75 +++++++++++++++++++++-----------------------
> >  2 files changed, 38 insertions(+), 39 deletions(-)
> > 
> > diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
> > index 01ee473517e2..f57f795d704c 100644
> > --- a/include/kvm/arm_arch_timer.h
> > +++ b/include/kvm/arm_arch_timer.h
> > @@ -90,6 +90,8 @@ void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu);
> >  
> >  void kvm_timer_init_vhe(void);
> >  
> > +bool kvm_arch_timer_get_input_level(int vintid);
> > +
> >  #define vcpu_vtimer(v)	(&(v)->arch.timer_cpu.vtimer)
> >  #define vcpu_ptimer(v)	(&(v)->arch.timer_cpu.ptimer)
> >  
> 
> [...]
> 
> > +bool kvm_arch_timer_get_input_level(int vintid)
> > +{
> > +	struct kvm_vcpu *vcpu = kvm_arm_get_running_vcpu();
> > +	struct arch_timer_context *timer;
> > +
> > +	if (vintid == vcpu_vtimer(vcpu)->irq.irq)
> > +		timer = vcpu_vtimer(vcpu);
> > +	else
> > +		BUG(); /* We only map the vtimer so far */
> > +
> > +	if (timer->loaded)
> > +		__timer_snapshot_state(timer);
> > +
> > +	return kvm_timer_should_fire(timer);
> > +}
> 
> I think it worth to reword to highlight your intention about BUG,
> and save 1 call to vcpu_vtimer()
> 
> bool kvm_arch_timer_get_input_level(int vintid)
> {
> 	struct kvm_vcpu *vcpu = kvm_arm_get_running_vcpu();
> 	struct arch_timer_context *timer = vcpu_vtimer(vcpu);
> 
>         /* We only map the vtimer so far */
> 	BUG_ON(vintid != timer->irq.irq)
> 
> 	if (timer->loaded)
> 		__timer_snapshot_state(timer);
> 
> 	return kvm_timer_should_fire(timer);
> }
> 

Besides the incredible bikesheding nature of your comments, I disagree.
The current code suggests where to add functionality once we move to
using the physical timer hardware to drive an EL1 physical timer on VHE
systems, and is purposely written this way.

I'm sure we have real bugs and real issues in the code, perhaps you
could spend your energy looking for those, and if you cannot find any,
then provide a reviewed-by instead of these pointless cosmetic
adjustments.

Thanks,
-Christoffer
