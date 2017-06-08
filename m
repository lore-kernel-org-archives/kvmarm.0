From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH 08/10] KVM: arm/arm64: vgic: Handle unshared mapped
 interrupts
Date: Thu, 8 Jun 2017 12:14:07 +0200
Message-ID: <20170608101407.GC7657@cbox>
References: <1495656803-28011-1-git-send-email-eric.auger@redhat.com>
 <1495656803-28011-9-git-send-email-eric.auger@redhat.com>
 <20170602133301.GD397@cbox>
 <23b9aee3-abf4-928e-e731-e38e729abbeb@arm.com>
 <20170602162944.GE397@cbox> <874lvqkhvv.fsf@arm.com>
 <20170608083432.GA7657@cbox>
 <0e1d4754-a24c-2207-d969-d05c253618e9@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A834B40BC5
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Jun 2017 06:10:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mpseU9TEm5sf for <kvmarm@lists.cs.columbia.edu>;
 Thu,  8 Jun 2017 06:10:00 -0400 (EDT)
Received: from mail-wm0-f51.google.com (mail-wm0-f51.google.com [74.125.82.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4F82440430
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Jun 2017 06:10:00 -0400 (EDT)
Received: by mail-wm0-f51.google.com with SMTP id m7so36992570wmg.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 08 Jun 2017 03:14:09 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <0e1d4754-a24c-2207-d969-d05c253618e9@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Auger Eric <eric.auger@redhat.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, linux-kernel@vger.kernel.org, alex.williamson@redhat.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, eric.auger.pro@gmail.com
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Jun 08, 2017 at 10:55:29AM +0200, Auger Eric wrote:
> Hi Christoffer, Marc,
> 
> On 08/06/2017 10:34, Christoffer Dall wrote:
> > On Thu, Jun 08, 2017 at 09:23:16AM +0100, Marc Zyngier wrote:
> >> On Fri, Jun 02 2017 at  6:29:44 pm BST, Christoffer Dall <cdall@linaro.org> wrote:
> >>> On Fri, Jun 02, 2017 at 03:10:23PM +0100, Marc Zyngier wrote:
> >>>> On 02/06/17 14:33, Christoffer Dall wrote:
> >>>>> On Wed, May 24, 2017 at 10:13:21PM +0200, Eric Auger wrote:
> >>>>>> Virtual interrupts directly mapped to physical interrupts require
> >>>>>> some special care. Their pending and active state must be observed
> >>>>>> at distributor level and not in the list register.
> >>>>>
> >>>>> This is not entirely true.  There's a dependency, but there is also
> >>>>> separate virtual vs. physical state, see below.
> >>>>
> >>>> I think this stems for the usual confusion about the "pending and active
> >>>> state" vs "pending and active states". Yes, the GIC spec is rubbish. Can
> >>>> I state this again?
> >>>>
> >>>>>>
> >>>>>> Also a level sensitive interrupt's level is not toggled down by any
> >>>>>> maintenance IRQ handler as the EOI is not trapped.
> >>>>>>
> >>>>>> This patch adds an host_irq field in vgic_irq struct to easily
> >>>>>> get the irqchip state of the host irq. We also handle the
> >>>>>> physical IRQ case in vgic_validate_injection and add helpers to
> >>>>>> get the line level and active state.
> >>>>>>
> >>>>>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> >>>>>> ---
> >>>>>>  include/kvm/arm_vgic.h    |  4 +++-
> >>>>>>  virt/kvm/arm/arch_timer.c |  3 ++-
> >>>>>>  virt/kvm/arm/vgic/vgic.c  | 44 ++++++++++++++++++++++++++++++++++++++------
> >>>>>>  virt/kvm/arm/vgic/vgic.h  |  9 ++++++++-
> >>>>>>  4 files changed, 51 insertions(+), 9 deletions(-)
> >>>>>>
> >>>>>> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> >>>>>> index ef71858..695ebc7 100644
> >>>>>> --- a/include/kvm/arm_vgic.h
> >>>>>> +++ b/include/kvm/arm_vgic.h
> >>>>>> @@ -112,6 +112,7 @@ struct vgic_irq {
> >>>>>>  	bool hw;			/* Tied to HW IRQ */
> >>>>>>  	struct kref refcount;		/* Used for LPIs */
> >>>>>>  	u32 hwintid;			/* HW INTID number */
> >>>>>> +	unsigned int host_irq;		/* linux irq corresponding to hwintid */
> >>>>>>  	union {
> >>>>>>  		u8 targets;			/* GICv2 target VCPUs mask */
> >>>>>>  		u32 mpidr;			/* GICv3 target VCPU */
> >>>>>> @@ -301,7 +302,8 @@ int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int intid,
> >>>>>>  			bool level);
> >>>>>>  int kvm_vgic_inject_mapped_irq(struct kvm *kvm, int cpuid, unsigned int intid,
> >>>>>>  			       bool level);
> >>>>>> -int kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu, u32 virt_irq, u32 phys_irq);
> >>>>>> +int kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu, unsigned int host_irq,
> >>>>>> +			  u32 virt_irq, u32 phys_irq);
> >>>>>>  int kvm_vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, unsigned int virt_irq);
> >>>>>>  bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, unsigned int virt_irq);
> >>>>>>  
> >>>>>> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
> >>>>>> index 5976609..45f4779 100644
> >>>>>> --- a/virt/kvm/arm/arch_timer.c
> >>>>>> +++ b/virt/kvm/arm/arch_timer.c
> >>>>>> @@ -651,7 +651,8 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
> >>>>>>  	 * Tell the VGIC that the virtual interrupt is tied to a
> >>>>>>  	 * physical interrupt. We do that once per VCPU.
> >>>>>>  	 */
> >>>>>> -	ret = kvm_vgic_map_phys_irq(vcpu, vtimer->irq.irq, phys_irq);
> >>>>>> +	ret = kvm_vgic_map_phys_irq(vcpu, host_vtimer_irq,
> >>>>>> +				    vtimer->irq.irq, phys_irq);
> >>>>>>  	if (ret)
> >>>>>>  		return ret;
> >>>>>>  
> >>>>>> diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
> >>>>>> index 83b24d2..aa0618c 100644
> >>>>>> --- a/virt/kvm/arm/vgic/vgic.c
> >>>>>> +++ b/virt/kvm/arm/vgic/vgic.c
> >>>>>> @@ -137,6 +137,28 @@ void vgic_put_irq(struct kvm *kvm, struct vgic_irq *irq)
> >>>>>>  	kfree(irq);
> >>>>>>  }
> >>>>>>  
> >>>>>> +bool irq_line_level(struct vgic_irq *irq)
> >>>>>> +{
> >>>>>> +	bool line_level = irq->line_level;
> >>>>>> +
> >>>>>> +	if (unlikely(is_unshared_mapped(irq)))
> >>>>>> +		WARN_ON(irq_get_irqchip_state(irq->host_irq,
> >>>>>> +					      IRQCHIP_STATE_PENDING,
> >>>>>> +					      &line_level));
> >>>>>> +	return line_level;
> >>>>>> +}
> >>>>>
> >>>>> This really looks fishy.  When do we need this exactly?
> >>>>>
> >>>>> I feel like we should treat this more like everything else and set the
> >>>>> line_level on the irq even for forwarded interrupts, and then you don't
> >>>>> need changes to validate injection.
> >>>>>
> >>>>> The challenge, then, is how to re-sample the line and lower the
> >>>>> line_level field when necessary.  Can't we simply do this in
> >>>>> vgic_fold_lr_state(), and if you have a forwarded interrupt which is
> >>>>> level triggered and the level is high, then notify the one who injected
> >>>>> this and tell it to adjust its line level (lower it if it changed).
> >>>>>
> >>>>> That would follow our existing path very closely.
> >>>>>
> >>>>> Am I missing something?
> >>>>
> >>>> I don't think you are. I think Eric got confused because of the above.
> >>>> But the flow is a bit a brainfsck :-(
> >>>>
> >>>> - Physical interrupt fires, activated, injected in the vgic
> >>>> - Injecting the interrupt has a very different flow from what we
> >>>> currently have, and follow the same pattern as an Edge interrupt
> >>>> (because the Pending state is kept at the physical distributor, so we
> >>>> cannot preserve it in the emulation).
> >>>> - Normal life cycle of the interrupt
> >>>> - The fact that the Pending bit is kept at the distributor level ensures
> >>>> that if it becomes pending again in the emulation, that's because the
> >>>> guest has deactivated the physical interrupt by doing an EOI.
> >>>>
> >>>
> >>> I think there's a choice between how we choose to support this.  We can
> >>> either do the edge-like injection, or we can model the line_level to the
> >>> best of our ability (we just have to lower the line after the guest
> >>> exits after deactivation if it's not still pending at the physical
> >>> distributor).
> >>>
> >>> One question with doing this edge-like, can you ahve this scenario:
> >>>  1. VM runs with active virtual interrupt linked to physical
> >>>     interrupt.
> >>>  2. VM deactivates virtual+physical interrupt
> >>>  3. Physical interrupt fires again on the host
> >>>  4. The host injects the virtual interrupt as pending to the VGIC (and
> >>>     IPIs the VCPU etc.)
> >>>  5. The device lowers the physical line (another VPCU programs the
> >>>     device, there's some delay, or whatever)
> >>>  6. The VCPU now sees a pending interrupt, which is no longer pending.
> >>>
> >>> Not sure if the line-like approach really solves this, though, or if
> >>> getting a spurius interrupt is something we care about.
> >>
> >> That would be a spurious interrupt indeed, but I'm not sure that's
> >> something the line level sampling you suggest would avoid either. There
> >> is a fundamental disconnect between the injection and the physical line,
> >> and it can only be modelled to some level of accuracy (/me curse the
> >> architecture again).
> >>
> >>> Perhaps we need to try to implement both and see how it looks like?
> >>
> >> There is definitely room for experiment, but I feel Eric should focus on
> >> one of them (whichever it is). Happy to help prototyping the other one
> >> though.
> >>
> > That's fair.  I'm just worried about the whole "emulate level triggered
> > interrupts as edge triggered" thing, but as you said, the architecture
> > doesn't allow us to model it more accurately.
> if the line level is modeled using the physical distributor pending
> state, don't you fix that case?
> 

I see what you mean.  Perhaps.  So that would mean that we move
line_level() to the physical distributor for forwarded interrupts, but
the active state is managed virtually in the GIC?

That contradicts my argument on the other mail, but if it's a more
accurate emulation, then that's definitely worth considering.

Thanks,
-Christoffer
