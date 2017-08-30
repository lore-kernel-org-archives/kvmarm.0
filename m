From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v3 51/59] KVM: arm/arm64: GICv4: Add doorbell interrupt
 handling
Date: Wed, 30 Aug 2017 14:28:30 +0200
Message-ID: <20170830122830.qfa4gbooguee6v5r@kamzik.brq.redhat.com>
References: <20170731172637.29355-1-marc.zyngier@arm.com>
 <20170731172637.29355-52-marc.zyngier@arm.com>
 <8a35ee18-85a5-168b-b3d2-b9f51390b475@arm.com>
 <20170828181850.GL24649@cbox>
 <20170830103141.jarquijxzntv2feo@kamzik.brq.redhat.com>
 <20170830115510.GE24522@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170830115510.GE24522@cbox>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Christoffer Dall <christoffer.dall@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>, Eric Auger <eric.auger@redhat.com>, Shanker Donthineni <shankerd@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>, Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Aug 30, 2017 at 01:55:10PM +0200, Christoffer Dall wrote:
> On Wed, Aug 30, 2017 at 12:31:41PM +0200, Andrew Jones wrote:
> > On Mon, Aug 28, 2017 at 08:18:50PM +0200, Christoffer Dall wrote:
> > > On Fri, Aug 04, 2017 at 08:44:04AM +0100, Marc Zyngier wrote:
> > > > On 31/07/17 18:26, Marc Zyngier wrote:
> > > > > When a vPE is not running, a VLPI being made pending results in a
> > > > > doorbell interrupt being delivered. Let's handle this interrupt
> > > > > and update the pending_last flag that indicates that VLPIs are
> > > > > pending. The corresponding vcpu is also kicked into action.
> > > > > 
> > > > > Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> > > > > ---
> > > > >  virt/kvm/arm/vgic/vgic-v4.c | 34 ++++++++++++++++++++++++++++++++++
> > > > >  1 file changed, 34 insertions(+)
> > > > > 
> > > > > diff --git a/virt/kvm/arm/vgic/vgic-v4.c b/virt/kvm/arm/vgic/vgic-v4.c
> > > > > index 534d3051a078..6af3cde6d7d4 100644
> > > > > --- a/virt/kvm/arm/vgic/vgic-v4.c
> > > > > +++ b/virt/kvm/arm/vgic/vgic-v4.c
> > > > > @@ -21,6 +21,19 @@
> > > > >  
> > > > >  #include "vgic.h"
> > > > >  
> > > > > +static irqreturn_t vgic_v4_doorbell_handler(int irq, void *info)
> > > > > +{
> > > > > +	struct kvm_vcpu *vcpu = info;
> > > > > +
> > > > > +	if (!kvm_vgic_vcpu_pending_irq(vcpu)) {
> > > > > +		vcpu->arch.vgic_cpu.vgic_v3.its_vpe.pending_last = true;
> > > > > +		kvm_make_request(KVM_REQ_IRQ_PENDING, vcpu);
> > > > > +		kvm_vcpu_kick(vcpu);
> > > > > +	}
> > > > 
> > > > This code is so obviously broken that I completely overlooked it.
> > > > 
> > > > If we have take a doorbell interrupt, then it means nothing was
> > > > otherwise pending (because we'd have been kicked out of the blocking
> > > > state, and will have masked the doorbell). So checking for pending
> > > > interrupts is pointless.
> > > > 
> > > > Furthermore, calling kvm_vgic_vcpu_pending_irq() takes the ap_list
> > > > lock. If we take a doorbell interrupt while injecting a virtual
> > > > interrupt (from userspace, for example) on the same CPU, we end-up
> > > > in deadlock land. This would be solved by Christoffer's latest
> > > > crop of timer patches, but there is no point getting there the first
> > > > place.
> > > > 
> > > > The patchlet below solves it:
> > > > 
> > > > diff --git a/virt/kvm/arm/vgic/vgic-v4.c b/virt/kvm/arm/vgic/vgic-v4.c
> > > > index 15feb1151797..48e4d6ebeaa8 100644
> > > > --- a/virt/kvm/arm/vgic/vgic-v4.c
> > > > +++ b/virt/kvm/arm/vgic/vgic-v4.c
> > > > @@ -94,11 +94,9 @@ static irqreturn_t vgic_v4_doorbell_handler(int irq, void *info)
> > > >  {
> > > >  	struct kvm_vcpu *vcpu = info;
> > > >  
> > > > -	if (!kvm_vgic_vcpu_pending_irq(vcpu)) {
> > > > -		vcpu->arch.vgic_cpu.vgic_v3.its_vpe.pending_last = true;
> > > > -		kvm_make_request(KVM_REQ_IRQ_PENDING, vcpu);
> > > > -		kvm_vcpu_kick(vcpu);
> > > > -	}
> > > > +	vcpu->arch.vgic_cpu.vgic_v3.its_vpe.pending_last = true;
> > > > +	kvm_make_request(KVM_REQ_IRQ_PENDING, vcpu);
> > > > +	kvm_vcpu_kick(vcpu);
> > > 
> > > I don't think you need the request and kick, because if you're getting
> > > this doorbell, doesn't that also mean that the VCPU is not running in
> > > the guest and you simply need to make sure the VCPU thread gets
> > > scheduled again, so you could call kvm_vcpu_wake_up() instead.
> > 
> > While we do that in kvm_timer_inject_irq_work(), which is scheduled from
> > the same function that vgic_v4_doorbell_handler() would be enabled from
> > (kvm_vcpu_block->kvm_arch_vcpu_blocking), just a wake up isn't sufficient
> > in this case.
> > 
> > > 
> > > Unless the request is there to ensure proper memory barriers around
> > > setting pending_last?
> > 
> > Right, unlike pending timers, we need the barriers in this handler.
> > Pending timers are safe because their pending test compares state set by
> > the VCPU thread itself to state acquired by the VCPU thread reading a host
> > sysreg itself. IOW, handlers making "set vcpu timer pending requests"
> > don't need to do anything but wake up the VCPU. Handlers that set some
> > sort of irq pending state, like vgic_v4_doorbell_handler(), do need to
> > worry about the visibility of that state though.
> > 
> > > 
> > > In that case, is the read barrier taken care of by prepare_to_swait in
> > > kvm_vcpu_block()?
> > 
> > Thanks for the bug report :-)
> > 
> > There's a barrier, but it's not properly paired. Currently we have
> > 
> >  VCPU                                        handler
> >  ----                                        -------
> >  for (;;) {
> >    WRITE_ONCE(task->state, INTERRUPTIBLE);   pending=true;
> >    smp_mb();                                 smp_wmb(); // kvm_make_request()
> >    if (pending) {                            WRITE_ONCE(vcpu->state, NORMAL);
> >      ... stop waiting ...
> >    }
> >    schedule();
> >  }
> > 
> > Proper barrier use with swait/swake should instead look like this
> > 
> >  VCPU                                        handler
> >  ----                                        -------
> >  for (;;) {
> >    WRITE_ONCE(task->state, INTERRUPTIBLE);
> >    smp_mb();
> >    if (READ_ONCE(task->state) == NORMAL) {   pending=true;
> >      smp_rmb();                              smp_wmb();
> >      if (pending)                            WRITE_ONCE(vcpu->state, NORMAL);
> >        ... stop waiting ...
> >      else
> >        continue;
> >    }
> >    schedule();
> >  }
> > 
> > But checking task state adds complexity and would only cover a small
> > window anyway (the window between prepare_to_swait() and
> > kvm_vcpu_check_block()). We need to cover a larger window, for this
> > particular case it's from kvm_arch_vcpu_blocking() to
> > kvm_vcpu_check_block(). Better use of VCPU requests is the answer:
> > 
> >  VCPU                                        handler
> >  ----                                        -------
> >  kvm_arch_vcpu_blocking();
> >  for (;;) {
> >    prepare_to_swait(); 
> >    if (test_bit(IRQ_PENDING)) {              pending=true;
> >      smp_rmb();                              smp_wmb();
> >      if (pending)                            set_bit(IRQ_PENDING);
> >        ... stop waiting ...
> >      else
> >        continue;
> >    }
> >    schedule();
> >  }
> > 
> > The handler side is covered by kvm_make_request() and the vcpu kick, so
> > this patch looks good. However we need a patch to kvm_arch_vcpu_runnable()
> > to fix the VCPU side.
> > 
> >  int kvm_arch_vcpu_runnable(struct kvm_vcpu *v)
> >  {
> > -       return ((!!v->arch.irq_lines || kvm_vgic_vcpu_pending_irq(v))
> > -               && !v->arch.power_off && !v->arch.pause);
> > +       if (v->arch.power_off || v->arch.pause)
> > +               return false;
> 
> Why don't we need to ensure reads of these flags are observable when
> waking up, if the thread waking us up had se the variables prior to
> issuing the wake up call?

They're "special". I analyzed the cases for them and I *think* they're
all safe. I can do another round, or perhaps better would be to replace
them in some way with VCPU requests to make the analysis consistent.

> 
> > +
> > +       if (kvm_test_request(KVM_REQ_IRQ_PENDING, vcpu)) {
> > +               smp_rmb();
> 
> This looks wrong.  What does this barrier ensure exactly?  Some kind of
> read following whoever called this function?

Yes, it's similar to how kvm_check_request() is written. Actually, I
should probably just copy that more completely, i.e.

 if (kvm_test_request(KVM_REQ_IRQ_PENDING, vcpu)) {
    /*
     * Ensure the rest of the request is visible to the caller.
     * Pairs with the smp_wmb in kvm_make_request.
     */
     smp_mb__after_atomic();
     return true;
 }

> 
> > +               return true;
> > +       }
> >  }
> > 
> > We can keep the kvm_vgic_vcpu_pending_irq() check, after the IRQ_PENDING
> > check, if there are cases where IRQ_PENDING wouldn't be set, but
> > kvm_vgic_vcpu_pending_irq() would return true. Either way we also get a
> > bit of an optimization with this fix.
> > 
> > I'll think/test some more, and then send a patch.
> > 
> 
> I'll review it more thoroughly then.

Thanks,
drew
