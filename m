From: Christoffer Dall <cdall@kernel.org>
Subject: Re: [PATCH v5 2/8] KVM: arm/arm64: Factor out functionality to get
 vgic mmio requester_vcpu
Date: Mon, 4 Dec 2017 20:21:01 +0100
Message-ID: <20171204192101.GF32397@cbox>
References: <20171120191649.17290-1-christoffer.dall@linaro.org>
 <20171120191649.17290-3-christoffer.dall@linaro.org>
 <aab23eee-aa3b-9349-6e78-473beeb46969@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <aab23eee-aa3b-9349-6e78-473beeb46969@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Eric Auger <eric.auger@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Dec 01, 2017 at 06:04:32PM +0000, Andre Przywara wrote:
> Hi,
> 
> On 20/11/17 19:16, Christoffer Dall wrote:
> > We are about to distinguish between userspace accesses and mmio traps
> > for a number of the mmio handlers.  When the requester vcpu is NULL, it
> > mens we are handling a userspace acccess.
> > 
> > Factor out the functionality to get the request vcpu into its own
> > function, mostly so we have a common place to document the semantics of
> > the return value.
> > 
> > Also take the chance to move the functionality outside of holding a
> > spinlock and instead explicitly disable and enable preemption.  This
> > supports PREEMPT_RT kernels as well.
> > 
> > Acked-by: Marc Zyngier <marc.zyngier@arm.com>
> > Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> > ---
> >  virt/kvm/arm/vgic/vgic-mmio.c | 43 +++++++++++++++++++++++++++----------------
> >  1 file changed, 27 insertions(+), 16 deletions(-)
> > 
> > diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
> > index deb51ee16a3d..6113cf850f47 100644
> > --- a/virt/kvm/arm/vgic/vgic-mmio.c
> > +++ b/virt/kvm/arm/vgic/vgic-mmio.c
> > @@ -122,6 +122,26 @@ unsigned long vgic_mmio_read_pending(struct kvm_vcpu *vcpu,
> >  	return value;
> >  }
> >  
> > +/*
> > + * This function will return the VCPU that performed the MMIO access and
> > + * trapped from twithin the VM, and will return NULL if this is a userspace
> > + * access.
> > + *
> > + * We can disable preemption locally around accessing the per-CPU variable
> > + * because even if the current thread is migrated to another CPU, reading the
> > + * per-CPU value later will give us the same value as we update the per-CPU
> > + * variable in the preempt notifier handlers.
> 
> This comment left me scratching my head a bit. Maybe you could change it
> to point out that ... it's safe to *enable* preemption after the call
> again, because of said reasons? Because disabling preemption before
> accessing a per-CPU variable is not really an issue.

I'll try to clarify.

> 
> Apart from that it's fine.
> 
> Reviewed-by: Andre Przywara <andre.przywara@arm.com>
> 
Thanks,
-Christoffer
