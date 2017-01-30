From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [RFC v2 06/10] KVM: arm/arm64: Update the physical timer
 interrupt level
Date: Mon, 30 Jan 2017 16:02:03 +0100
Message-ID: <20170130150203.GD16459@cbox>
References: <1485479100-4966-1-git-send-email-jintack@cs.columbia.edu>
 <1485479100-4966-7-git-send-email-jintack@cs.columbia.edu>
 <86sho199jx.fsf@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <86sho199jx.fsf@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Jintack Lim <jintack@cs.columbia.edu>, pbonzini@redhat.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, andre.przywara@arm.com, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Sun, Jan 29, 2017 at 03:21:06PM +0000, Marc Zyngier wrote:
> On Fri, Jan 27 2017 at 01:04:56 AM, Jintack Lim <jintack@cs.columbia.edu> wrote:
> > Now that we maintain the EL1 physical timer register states of VMs,
> > update the physical timer interrupt level along with the virtual one.
> >
> > Note that the emulated EL1 physical timer is not mapped to any hardware
> > timer, so we call a proper vgic function.
> >
> > Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
> > ---
> >  virt/kvm/arm/arch_timer.c | 20 ++++++++++++++++++++
> >  1 file changed, 20 insertions(+)
> >
> > diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
> > index 0f6e935..3b6bd50 100644
> > --- a/virt/kvm/arm/arch_timer.c
> > +++ b/virt/kvm/arm/arch_timer.c
> > @@ -180,6 +180,21 @@ static void kvm_timer_update_mapped_irq(struct kvm_vcpu *vcpu, bool new_level,
> >  	WARN_ON(ret);
> >  }
> >  
> > +static void kvm_timer_update_irq(struct kvm_vcpu *vcpu, bool new_level,
> > +				 struct arch_timer_context *timer)
> > +{
> > +	int ret;
> > +
> > +	BUG_ON(!vgic_initialized(vcpu->kvm));
> 
> Although I've added my fair share of BUG_ON() in the code base, I've
> since reconsidered my position. If we get in a situation where the vgic
> is not initialized, maybe it would be better to just WARN_ON and return
> early rather than killing the whole box. Thoughts?
> 

The distinction to me is whether this will cause fatal crashes or
exploits down the road if we're working on uninitialized data.  If all
that can happen if the vgic is not initialized, is that the guest
doesn't see interrupts, for example, then a WARN_ON is appropriate.

Which is the case here?

That being said, do we need this at all?  This is in the critial path
and is actually measurable (I know this from my work on the other timer
series), so it's better to get rid of it if we can.  Can we simply
convince ourselves this will never happen, and is the code ever likely
to change so that it gets called with the vgic disabled later?


Thanks,
-Christoffer
