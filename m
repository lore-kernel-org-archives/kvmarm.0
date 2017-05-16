From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v2 07/11] KVM: arm/arm64: Register iodevs when setting
 redist base and creating VCPUs
Date: Tue, 16 May 2017 22:31:46 +0200
Message-ID: <20170516203146.GA24893@cbox>
References: <20170509085618.28311-1-cdall@linaro.org>
 <20170509085618.28311-8-cdall@linaro.org>
 <de4eb037-2837-fe77-d5ee-514529bfcd99@arm.com>
 <c6d828a8-e763-bdec-09fa-22d94a717acb@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <c6d828a8-e763-bdec-09fa-22d94a717acb@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Auger Eric <eric.auger@redhat.com>
Cc: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Marc Zyngier <marc.zyngier@arm.com>, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, May 16, 2017 at 02:39:18PM +0200, Auger Eric wrote:
> Hi Jean, Christoffer,
> 
> On 16/05/2017 13:23, Jean-Philippe Brucker wrote:
> > Hi,
> > 
> > On 09/05/17 09:56, Christoffer Dall wrote:
> >> Instead of waiting with registering KVM iodevs until the first VCPU is
> >> run, we can actually create the iodevs when the redist base address is
> >> set.  The only downside is that we must now also check if we need to do
> >> this for VCPUs which are created after creating the VGIC, because there
> >> is no enforced ordering between creating the VGIC (and setting its base
> >> addresses) and creating the VCPUs.
> > 
> > This triggers a BUG(), when the order is VGIC init, then VCPU init (which
> > is what kvmtool does).
> > 
> > Issuing KVM_CREATE_VCPU after VGIC intialization produces the following calls:
> > 
> > kvm_vm_ioctl_create_vcpu
> >  kvm_arch_vcpu_create
> >   kvm_vcpu_init
> >    kvm_arch_vcpu_init
> >     kvm_vgic_vcpu_init
> >      vgic_register_redist_iodev
> >       kvm_vcpu_get_idx
> >        ... no VCPU registered yet in kvm->vcpus :(
> >        BUG();
> 
> in QEMU use case, kvm_vgic_vcpu_init/vgic_register_redist_iodev does
> nothing since KVM_VGIC_V3_ADDR_TYPE_REDIST was not called yet and
> vgic->vgic_redist_base is undefined. Thus we postpone the redist_iodev
> registration until the redist base address is set.
> 
> In QEMU case KVM_VGIC_V3_ADDR_TYPE_REDIST is called when all the CPUs
> are initialized and we were lucky.
> > 
> >  ... would later register vcpu:
> >  kvm->vcpus[atomic_read(&kvm->online_vcpus)] = vcpu
> > 
> > My quick fix is to move kvm_vgic_vcpu_init into kvm_arch_vcpu_postcreate,
> > but it discards the return value of kvm_vgic_vcpu_init, so I don't know
> > how to do it properly.
> 
> changing the proto of kvm_arch_vcpu_postcreate and moving the
> kvm_vgic_vcpu_init there could be an alternative.

I think the whole point of postcreate is a hook that can be called where
it doesn't produce an error (rolling back the create at that point is
pretty horrid).

I'll have a closer look in the morning at what we can do - perhaps the
idx thing is just a ridiculous requirement and we can do something more
clever.

Thanks for the heads up, and sorry about breaking stuff.

-Christoffer
