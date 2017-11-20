From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v5 04/20] KVM: arm/arm64: Guard kvm_vgic_map_is_active
 against !vgic_initialized
Date: Mon, 20 Nov 2017 12:20:58 +0100
Message-ID: <20171120112058.GF28855@cbox>
References: <1509093281-15225-1-git-send-email-cdall@linaro.org>
 <1509093281-15225-5-git-send-email-cdall@linaro.org>
 <475960cf-8b85-3a9f-d166-455e8bc5a43c@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <475960cf-8b85-3a9f-d166-455e8bc5a43c@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Nov 16, 2017 at 12:29:48PM +0000, Andre Przywara wrote:
> Hi,
> 
> On 27/10/17 09:34, Christoffer Dall wrote:
> > If the vgic is not initialized, don't try to grab its spinlocks or
> > traverse its data structures.
> > 
> > This is important because we soon have to start considering the active
> > state of a virtual interrupts when doing vcpu_load, which may happen
> > early on before the vgic is initialized.
> 
> I understand this patch is on its way to Linus already, but I just found
> this by browsing for VGIC changes...
> 
> > Signed-off-by: Christoffer Dall <cdall@linaro.org>
> > Acked-by: Marc Zyngier <marc.zyngier@arm.com>
> > ---
> >  virt/kvm/arm/vgic/vgic.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
> > index fed717e..e1f7dbc 100644
> > --- a/virt/kvm/arm/vgic/vgic.c
> > +++ b/virt/kvm/arm/vgic/vgic.c
> > @@ -777,6 +777,9 @@ bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, unsigned int virt_irq)
> >  	struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, virt_irq);
> 
> Isn't vgic_get_irq() already accessing VGIC data structures? In which
> case this assignment should be moved after the vgic_initialized() check
> below?

Theoretically, yes, but we're saved by two things:

First, this is only ever called on PPIs from the timer code, which are
always statically allocated as part of the VCPU.

Second, this isn't actually needed anymore after the irqchip in
userspace support, which partially reworked the timer init sequence
(done after the first version of these patches), so this patch could
actually have been entirely dropped, or reworked as you suggest.

Thanks,
-Christoffer
