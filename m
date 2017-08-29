From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v2 5/8] KVM: arm/arm64: vgic: Handle mapped level
 sensitive SPIs
Date: Tue, 29 Aug 2017 08:45:49 +0200
Message-ID: <20170829064549.GR24649@cbox>
References: <1497531160-29162-1-git-send-email-eric.auger@redhat.com>
 <1497531160-29162-6-git-send-email-eric.auger@redhat.com>
 <20170721121137.GF16350@cbox>
 <772938b1-607d-1f3b-83c0-95a3d687020d@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <772938b1-607d-1f3b-83c0-95a3d687020d@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Auger Eric <eric.auger@redhat.com>
Cc: eric.auger.pro@gmail.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, alex.williamson@redhat.com, b.reynal@virtualopensystems.com, pbonzini@redhat.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, drjones@redhat.com, wei@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Aug 22, 2017 at 04:33:42PM +0200, Auger Eric wrote:
> Hi Christoffer,
> 
> On 21/07/2017 14:11, Christoffer Dall wrote:
> > On Thu, Jun 15, 2017 at 02:52:37PM +0200, Eric Auger wrote:
> >> Currently, the line level of unmapped level sensitive SPIs is
> >> toggled down by the maintenance IRQ handler/resamplefd mechanism.
> >>
> >> As mapped SPI completion is not trapped, we cannot rely on this
> >> mechanism and the line level needs to be observed at distributor
> >> level instead.
> >>
> >> This patch handles the physical IRQ case in vgic_validate_injection
> >> and get the line level of a mapped SPI at distributor level.
> >>
> >> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> >>
> >> ---
> >>
> >> v1 -> v2:
> >> - renamed is_unshared_mapped into is_mapped_spi
> >> - changes to kvm_vgic_map_phys_irq moved in the previous patch
> >> - make vgic_validate_injection more readable
> >> - reword the commit message
> >> ---
> >>  virt/kvm/arm/vgic/vgic.c | 16 ++++++++++++++--
> >>  virt/kvm/arm/vgic/vgic.h |  7 ++++++-
> >>  2 files changed, 20 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
> >> index 075f073..2e35ac7 100644
> >> --- a/virt/kvm/arm/vgic/vgic.c
> >> +++ b/virt/kvm/arm/vgic/vgic.c
> >> @@ -139,6 +139,17 @@ void vgic_put_irq(struct kvm *kvm, struct vgic_irq *irq)
> >>  	kfree(irq);
> >>  }
> >>  
> >> +bool irq_line_level(struct vgic_irq *irq)
> >> +{
> >> +	bool line_level = irq->line_level;
> >> +
> >> +	if (unlikely(is_mapped_spi(irq)))
> >> +		WARN_ON(irq_get_irqchip_state(irq->host_irq,
> >> +					      IRQCHIP_STATE_PENDING,
> >> +					      &line_level));
> >> +	return line_level;
> >> +}
> >> +
> >>  /**
> >>   * kvm_vgic_target_oracle - compute the target vcpu for an irq
> >>   *
> >> @@ -236,13 +247,14 @@ static void vgic_sort_ap_list(struct kvm_vcpu *vcpu)
> >>  
> >>  /*
> >>   * Only valid injection if changing level for level-triggered IRQs or for a
> >> - * rising edge.
> >> + * rising edge. Injection of virtual interrupts associated to physical
> >> + * interrupts always is valid.
> > 
> > why?  I don't remember this now, and that means I probably won't in the
> > future either.
> 
> Sorry for the late reply.
> 
> The life cycle of the physically mapped IRQ is as follows:
> - pIRQ becomes pending
> - pIRQ is acknowledged by the physical handler and becomes active
> - vIRQ gets injected as part of the physical handler chain
>   (VFIO->irqfd kvm_vgic_inject_irq for instance). Linux irq cannot
>   hit until vIRQ=pIRQ deactivation
> - guest deactivates the vIRQ which automatically deactivates the pIRQ
> 
> 
> So to me if we are about to vgic_validate_injection() an injection of a
> physically mapped vIRQ this means the vgic state is ready to accept it:
> previous occurence was deactivated. There cannot be any state
> inconsistency around the line_level/level.
> 
> Do you agree?
> 
> I will add this description at least in the commit message.

I think the important point is, that even though we don't change the
level, we still add it to the AP list if not already there, and
therefore we still do this.

> > 
> > When I look at this now, I'm thinking, if we're not going to change
> > anything, why proceed beyond validate injection?
> 
> don't catch this one. validation always succeeds and then we further
> handle the IRQ.

The problem is that the code suggests that we will not change something,
but in fact, later on, in the caller, we do queue this IRQ if not on the
AP list, even though there were no state change in the struct IRQ.

But Marc and I sketched out another proposal which could benefit the
timer as well.  Let me try to verify if it works and send it to you and
see if that is an improvement over this one.

Thanks,
-Christoffer
