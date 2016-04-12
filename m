From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [RFC PATCH 20/45] KVM: arm/arm64: vgic-new: Add TARGET registers
 handlers
Date: Tue, 12 Apr 2016 17:26:47 +0200
Message-ID: <20160412152647.GM3039@cbox>
References: <1458871508-17279-1-git-send-email-andre.przywara@arm.com>
 <1458871508-17279-21-git-send-email-andre.przywara@arm.com>
 <20160331113126.GZ4126@cbox> <570B9430.2040305@arm.com>
 <20160412131851.GI3039@cbox> <570D11D9.2090604@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 159D849BD9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Apr 2016 11:24:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id e3nzu3RVyy78 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 12 Apr 2016 11:24:53 -0400 (EDT)
Received: from mail-wm0-f45.google.com (mail-wm0-f45.google.com [74.125.82.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CABD649BD6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Apr 2016 11:24:51 -0400 (EDT)
Received: by mail-wm0-f45.google.com with SMTP id u206so33044279wme.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Apr 2016 08:26:30 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <570D11D9.2090604@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andre Przywara <andre.przywara@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Apr 12, 2016 at 04:18:49PM +0100, Andre Przywara wrote:
> Hi,
> 
> On 12/04/16 14:18, Christoffer Dall wrote:
> > On Mon, Apr 11, 2016 at 01:10:24PM +0100, Andre Przywara wrote:
> >> On 31/03/16 12:31, Christoffer Dall wrote:
> >>> On Fri, Mar 25, 2016 at 02:04:43AM +0000, Andre Przywara wrote:
> >>>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> >>>> ---
> >>>>  virt/kvm/arm/vgic/vgic_mmio.c | 43 ++++++++++++++++++++++++++++++++++++++++++-
> >>>>  1 file changed, 42 insertions(+), 1 deletion(-)
> >>>>
> >>>> diff --git a/virt/kvm/arm/vgic/vgic_mmio.c b/virt/kvm/arm/vgic/vgic_mmio.c
> >>>> index 76657ce..cde153f 100644
> >>>> --- a/virt/kvm/arm/vgic/vgic_mmio.c
> >>>> +++ b/virt/kvm/arm/vgic/vgic_mmio.c
> >>>> @@ -471,6 +471,47 @@ static int vgic_mmio_write_config(struct kvm_vcpu *vcpu,
> >>>>  	return 0;
> >>>>  }
> >>>>  
> >>>> +static int vgic_mmio_read_target(struct kvm_vcpu *vcpu,
> >>>> +				 struct kvm_io_device *this,
> >>>> +				 gpa_t addr, int len, void *val)
> >>>> +{
> >>>> +	struct vgic_io_device *iodev = container_of(this,
> >>>> +						    struct vgic_io_device, dev);
> >>>> +	u32 intid = (addr - iodev->base_addr);
> >>>> +	int i;
> >>>> +
> >>>> +	if (iodev->redist_vcpu)
> >>>> +		vcpu = iodev->redist_vcpu;
> >>>> +
> >>>> +	for (i = 0; i < len; i++) {
> >>>> +		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
> >>>> +
> >>>> +		((u8 *)val)[i] = irq->targets;
> >>>> +	}
> >>>> +
> >>>> +	return 0;
> >>>> +}
> >>>> +
> >>>> +static int vgic_mmio_write_target(struct kvm_vcpu *vcpu,
> >>>> +				  struct kvm_io_device *this,
> >>>> +				  gpa_t addr, int len, const void *val)
> >>>> +{
> >>>> +	struct vgic_io_device *iodev = container_of(this,
> >>>> +						    struct vgic_io_device, dev);
> >>>> +	u32 intid = (addr - iodev->base_addr);
> >>>> +	int i;
> >>>> +
> >>>> +	/* GICD_ITARGETSR[0-7] are read-only */
> >>>> +	if (intid < VGIC_NR_PRIVATE_IRQS)
> >>>> +		return 0;
> >>>> +
> >>>> +	for (i = 0; i < len; i++)
> >>>> +		vgic_v2_irq_change_affinity(vcpu->kvm, intid + i,
> >>>> +					    ((u8 *)val)[i]);
> >>>> +
> >>>> +	return 0;
> >>>> +}
> >>>> +
> >>>
> >>> these functions are v2 specific but are in a generic file and are not
> >>> named anything specific to v2?
> >>
> >> Well, technically the target register is still defined for the GICv3
> >> distributor, but just RES0 if affinity routing is enabled.
> > 
> > Shouldn't we support that then (or do we do this already via a call to
> > a RAZ handle function in the register table instead)?
> 
> Yes:
> 	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_ITARGETSR,
> 		vgic_mmio_read_raz, vgic_mmio_write_wi, 8),
> 
> > 
> >> But I can of course easily add a _v2_ in here.
> >>
> >> While I look at the function, it makes me wonder if the abstraction for
> >> the affinity change call is actually correct at all. In contrast to the
> >> other vgic_v<n>_* functions this one is about the _emulated_ VGIC model,
> >> not the hardware GIC version.
> >> Also we actually only have this one user here, the other call is about
> >> initializing the affinity setting, for which this function is really
> >> overkill.
> > 
> > How is it overkill?  In that it takes locks which are not necessary?
> 
> Well, yes, and the diff for the init part looks like:
> (pls excuse my stupid mailer for breaking the lines)
> 
> @@ -154,6 +154,7 @@ out:
> int kvm_vgic_dist_init(struct kvm *kvm, unsigned int nr_spis)
> {
>  	struct vgic_dist *dist = &kvm->arch.vgic;
> +	struct kvm_vcpu *vcpu0 = kvm_get_vcpu(kvm, 0);
>  	int i;
> 
>  	dist->spis = kcalloc(nr_spis, sizeof(struct vgic_irq), GFP_KERNEL);
> @@ -174,10 +175,11 @@ int kvm_vgic_dist_init(struct kvm *kvm, unsigned
> int nr_spis)
>  		INIT_LIST_HEAD(&irq->ap_list);
>  		spin_lock_init(&irq->irq_lock);
>  		irq->vcpu = NULL;
> +		irq->target_vcpu = vcpu0;
>  		if (dist->vgic_model == KVM_DEV_TYPE_ARM_VGIC_V2)
> -			vgic_v2_irq_change_affinity(kvm, irq->intid, 0);
> +			irq->targets = 0;
>  		else
> -			vgic_v3_irq_change_affinity(kvm, irq->intid, 0);
> +			irq->mpidr = 0;
>  	}
>  	return 0;
>  }
> 
> The amended MMIO handling part for the v3 IROUTER register looks similar
> (call to the function replaced with lock; assignment; unlock;). Also the
> v2 implementation is still shorter than the original function.
> So I am tempted to keep the change I just did in the next version.

looks fine to me.

> 
> >> So what about we move the content of the change_affinity function in
> >> here (same for the v3 case later), and tackle the init case separately
> >> (which is trivial)?
> > 
> > I don't think there's much to gain in moving the code into the function,
> > on the contrary, but you could move the function into this file and make
> > it static.
> > 
> > So, you're saying that the current _vX_ functions we have denote the
> > hardware version, not the emulated version, so that would be wrong to do
> > here?
> 
> Yes, at least for everything in vgic/vgic-v[23].c. So having
> vgic_v2_irq_change_affinity() in there is not right.
> 

ok.  I would still like the change_affinity logic in a separate static
function, but you can call it and place it whereever you like :)

-Christoffer
