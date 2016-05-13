From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3 45/55] KVM: arm/arm64: vgic-new: Add userland access
 to VGIC dist registers
Date: Fri, 13 May 2016 09:51:32 +0200
Message-ID: <20160513075132.GE27623@cbox>
References: <1462531568-9799-1-git-send-email-andre.przywara@arm.com>
 <1462531568-9799-46-git-send-email-andre.przywara@arm.com>
 <20160512184110.GK27623@cbox>
 <5734D51D.3000105@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5734D51D.3000105@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Eric Auger <eric.auger@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, May 12, 2016 at 08:10:21PM +0100, Andre Przywara wrote:
> Hi,
> 
> On 12/05/16 19:41, Christoffer Dall wrote:
> > On Fri, May 06, 2016 at 11:45:58AM +0100, Andre Przywara wrote:
> >> Userland may want to save and restore the state of the in-kernel VGIC,
> >> so we provide the code which takes a userland request and translate
> >> that into calls to our MMIO framework.
> >>
> >> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> >> ---
> >>  virt/kvm/arm/vgic/vgic-kvm-device.c | 50 ++++++++++++++++++++++++++++++++++++-
> >>  1 file changed, 49 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/virt/kvm/arm/vgic/vgic-kvm-device.c b/virt/kvm/arm/vgic/vgic-kvm-device.c
> >> index c952f6f..bb33af8 100644
> >> --- a/virt/kvm/arm/vgic/vgic-kvm-device.c
> >> +++ b/virt/kvm/arm/vgic/vgic-kvm-device.c
> >> @@ -264,7 +264,55 @@ static int vgic_attr_regs_access(struct kvm_device *dev,
> > 
> > come to think of it, this is GICv2 specific right?
> > 
> > why don't we call it vgic_v2_attr_regs_access then?
> > 
> > and should it really live in this file?
> 
> Mmmh, at the moment every userland access is v2 specific, but
> potentially this function should cover GICv3 as well, I think. We might
> need some adjustments once this will be implemented, but in general I
> don't see anything too v2 specific in here?


the defines being used below are v2 specific and it's going to stay that
way.  But ok, if you think it will be reworked to cater for both v2 and
v3, fine.

> 
> >>  				 struct kvm_device_attr *attr,
> >>  				 u32 *reg, bool is_write)
> >>  {
> >> -	return -ENXIO;
> >> +	gpa_t addr;
> >> +	int cpuid, ret, c;
> >> +	struct kvm_vcpu *vcpu, *tmp_vcpu;
> >> +
> >> +	cpuid = (attr->attr & KVM_DEV_ARM_VGIC_CPUID_MASK) >>
> >> +		 KVM_DEV_ARM_VGIC_CPUID_SHIFT;
> >> +	vcpu = kvm_get_vcpu(dev->kvm, cpuid);
> >> +	addr = attr->attr & KVM_DEV_ARM_VGIC_OFFSET_MASK;
> >> +
> >> +	mutex_lock(&dev->kvm->lock);
> >> +
> >> +	ret = vgic_init(dev->kvm);
> >> +	if (ret)
> >> +		goto out;
> >> +
> >> +	if (cpuid >= atomic_read(&dev->kvm->online_vcpus)) {
> >> +		ret = -EINVAL;
> >> +		goto out;
> >> +	}
> >> +
> >> +	/*
> >> +	 * Ensure that no other VCPU is running by checking the vcpu->cpu
> >> +	 * field.  If no other VPCUs are running we can safely access the VGIC
> >> +	 * state, because even if another VPU is run after this point, that
> >> +	 * VCPU will not touch the vgic state, because it will block on
> >> +	 * getting the vgic->lock in kvm_vgic_sync_hwstate().
> >> +	 */
> > 
> > eh, I don't see us grabbing any vgic->lock (does that still exist?)
> > here?
> 
> Yeah, that scared me the other day too.
> In fact I think we cannot guarantee this requirement anymore with our
> existing locks - but maybe we can pause the guest explicitly as we do
> now for the clear-active handler?
> 

I think that should work, yes.

Even if you're doing a restore of the state before actually running your
VCPUs, the make all requests wouldn't do anything and your VCPUs would
block in the early part of the run loop.  They will call
first_run_init() though, but I can't easily make that out to be a
problem.

An alternative is to do something similar to kvm_vgic_create(), perhaps
factor out that logic, which grabs the mutexes of all vcpus.

-Christoffer
