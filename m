From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH 7/8] KVM: arm/arm64: Register ITS iodev when setting base
 address
Date: Mon, 8 May 2017 21:21:53 +0200
Message-ID: <20170508192153.GM28342@cbox>
References: <20170508115454.5075-1-cdall@linaro.org>
 <20170508115454.5075-8-cdall@linaro.org>
 <a33cabd3-cf92-1a49-7b47-8d35d3daab4d@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <a33cabd3-cf92-1a49-7b47-8d35d3daab4d@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Eric Auger <eric.auger@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, May 08, 2017 at 06:41:36PM +0100, Marc Zyngier wrote:
> Hi Christoffer,
> 
> On 08/05/17 12:54, Christoffer Dall wrote:
> > We have to register the ITS iodevice before running the VM, because in
> > migration scenarios, we may be restoring a live device that wishes to
> > inject MSIs before we get a chance to run the VM.
> > 
> > All we need to register the ITS io device is the base address of the
> > ITS, so we can simply register that when the base address of the ITS is
> > set.
> > 
> > Signed-off-by: Christoffer Dall <cdall@linaro.org>
> > ---
> >  virt/kvm/arm/vgic/vgic-its.c | 29 +----------------------------
> >  virt/kvm/arm/vgic/vgic-v3.c  |  8 --------
> >  virt/kvm/arm/vgic/vgic.h     |  1 -
> >  3 files changed, 1 insertion(+), 37 deletions(-)
> > 
> > diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> > index 9f7105c..375c503 100644
> > --- a/virt/kvm/arm/vgic/vgic-its.c
> > +++ b/virt/kvm/arm/vgic/vgic-its.c
> > @@ -2390,7 +2390,7 @@ static int vgic_its_set_attr(struct kvm_device *dev,
> >  
> >  		its->vgic_its_base = addr;
> >  
> > -		return 0;
> > +		return vgic_register_its_iodev(dev->kvm, its);
> >  	}
> >  	case KVM_DEV_ARM_VGIC_GRP_CTRL: {
> >  		const struct vgic_its_abi *abi = vgic_its_get_abi(its);
> > @@ -2467,30 +2467,3 @@ int kvm_vgic_register_its_device(void)
> >  	return kvm_register_device_ops(&kvm_arm_vgic_its_ops,
> >  				       KVM_DEV_TYPE_ARM_VGIC_ITS);
> >  }
> 
> This patch has the unfortunate side effect of breaking kvmtool 
> (although the ITS support patches are not merged yet). The code 
> sequence now requires that KVM_DEV_ARM_VGIC_CTRL_INIT has been issued 
> on the ITS *before* we can set the ITS base address.
> 
> I find it a bit odd (I see KVM_DEV_ARM_VGIC_CTRL_INIT as a way to say 
> "I'm done, do what you must and make it work"), but that's obviously 
> what QEMU must be doing (the save/restore sequence hints at that, but I 
> only just realized the issue). Of course, kvmtool does the opposite.
> 
> But now that we've coupled setting the address and mapping the iodev, 
> there is not much that's left for KVM_DEV_ARM_VGIC_CTRL_INIT, and I 
> wonder why we're keeping it (other than for backward compatibility)?
> 
> We're now unable to set the address more than once (fair enough). What 
> is also interesting is that this makes it plain obvious that we have a 
> race between setting the address and registering the device (no lock is 
> taken here, and two threads could try and play a dirty game on us).
> 
> I've come up with the two following patches, that seem to make it work.

Both patches look good, thanks.

-Christoffer
