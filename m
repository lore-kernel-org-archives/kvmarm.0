From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3 47/55] KVM: arm/arm64: vgic-new: Add userland GIC CPU
 interface access
Date: Fri, 13 May 2016 13:54:19 +0200
Message-ID: <20160513115419.GH27623@cbox>
References: <1462531568-9799-1-git-send-email-andre.przywara@arm.com>
 <1462531568-9799-48-git-send-email-andre.przywara@arm.com>
 <20160512184740.GM27623@cbox>
 <5734D0F6.9090406@arm.com>
 <20160513075323.GF27623@cbox>
 <5735B016.50207@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5735B016.50207@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>, g@cbox
Cc: Marc Zyngier <marc.zyngier@arm.com>, Eric Auger <eric.auger@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, May 13, 2016 at 11:44:38AM +0100, Andre Przywara wrote:
> Hi,
> 
> On 13/05/16 08:53, Christoffer Dall wrote:
> > On Thu, May 12, 2016 at 07:52:38PM +0100, Andre Przywara wrote:
> >> Hi,
> >>
> >> On 12/05/16 19:47, Christoffer Dall wrote:
> >>> On Fri, May 06, 2016 at 11:46:00AM +0100, Andre Przywara wrote:
> >>>> Using the VMCR accessors we provide access to GIC CPU interface state
> >>>> to userland by wiring it up to the existing userland interface.
> >>>> [Marc: move and make VMCR accessors static, streamline MMIO handlers]
> >>>
> >>> does this mean Marc did this and serves as credit or is it a lost
> >>> reminder?
> >>
> >> It was meant as credit. I thought that is the usual annotation for this?
> >>
> > 
> > I'm not sure if that's the usual way, I read it as a reminder, but it's
> > not too important.  Mostly wanting to make sure we're not forgetting
> > some todo item.
> > 
> >>>>
> >>>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> >>>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> >>>> ---
> >>>> Changelog v2 .. v3:
> >>>> - total rework, moving into vgic-mmio-v2.c
> >>>> - move vmcr accessor wrapper functions into this file
> >>>> - use the register description table for CPU i/f registers as well
> >>>> - add RAZ/WI handling for the active priority registers
> >>>> - streamline MMIO handler functions
> >>>>
> >>>>  virt/kvm/arm/vgic/vgic-kvm-device.c |   2 +-
> >>>>  virt/kvm/arm/vgic/vgic-mmio-v2.c    | 104 ++++++++++++++++++++++++++++++++++++
> >>>>  virt/kvm/arm/vgic/vgic.h            |   2 +
> >>>>  3 files changed, 107 insertions(+), 1 deletion(-)
> >>>>
> >>>> diff --git a/virt/kvm/arm/vgic/vgic-kvm-device.c b/virt/kvm/arm/vgic/vgic-kvm-device.c
> >>>> index bb33af8..2122ff2 100644
> >>>> --- a/virt/kvm/arm/vgic/vgic-kvm-device.c
> >>>> +++ b/virt/kvm/arm/vgic/vgic-kvm-device.c
> >>>> @@ -300,7 +300,7 @@ static int vgic_attr_regs_access(struct kvm_device *dev,
> >>>>  
> >>>>  	switch (attr->group) {
> >>>>  	case KVM_DEV_ARM_VGIC_GRP_CPU_REGS:
> >>>> -		ret = -EINVAL;
> >>>> +		ret = vgic_v2_cpuif_uaccess(vcpu, is_write, addr, reg);
> >>>>  		break;
> >>>>  	case KVM_DEV_ARM_VGIC_GRP_DIST_REGS:
> >>>>  		ret = vgic_v2_dist_uaccess(vcpu, is_write, addr, reg);
> >>>> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
> >>>> index c453e6f..0060539 100644
> >>>> --- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
> >>>> +++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
> >>>> @@ -206,6 +206,84 @@ static void vgic_mmio_write_sgipends(struct kvm_vcpu *vcpu,
> >>>>  	}
> >>>>  }
> >>>>  
> >>>> +static void vgic_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr)
> >>>> +{
> >>>> +	if (kvm_vgic_global_state.type == VGIC_V2)
> >>>> +		vgic_v2_set_vmcr(vcpu, vmcr);
> >>>> +	else
> >>>> +		vgic_v3_set_vmcr(vcpu, vmcr);
> >>>> +}
> >>>> +
> >>>> +static void vgic_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr)
> >>>> +{
> >>>> +	if (kvm_vgic_global_state.type == VGIC_V2)
> >>>> +		vgic_v2_get_vmcr(vcpu, vmcr);
> >>>> +	else
> >>>> +		vgic_v3_get_vmcr(vcpu, vmcr);
> >>>> +}
> >>>> +
> >>>> +#define GICC_ARCH_VERSION_V2	0x2
> >>>> +
> >>>> +/* These are for userland accesses only, there is no guest-facing emulation. */
> >>>> +static unsigned long vgic_mmio_read_vcpuif(struct kvm_vcpu *vcpu,
> >>>> +					   gpa_t addr, unsigned int len)
> >>>> +{
> >>>> +	struct vgic_vmcr vmcr;
> >>>> +	u32 val;
> >>>> +
> >>>> +	vgic_get_vmcr(vcpu, &vmcr);
> >>>> +
> >>>> +	switch (addr & 0xff) {
> >>>> +	case GIC_CPU_CTRL:
> >>>> +		val = vmcr.ctlr;
> >>>> +		break;
> >>>> +	case GIC_CPU_PRIMASK:
> >>>> +		val = vmcr.pmr;
> >>>> +		break;
> >>>> +	case GIC_CPU_BINPOINT:
> >>>> +		val = vmcr.bpr;
> >>>> +		break;
> >>>> +	case GIC_CPU_ALIAS_BINPOINT:
> >>>> +		val = vmcr.abpr;
> >>>> +		break;
> >>>> +	case GIC_CPU_IDENT:
> >>>> +		val = ((PRODUCT_ID_KVM << 20) |
> >>>> +		       (GICC_ARCH_VERSION_V2 << 16) |
> >>>> +		       IMPLEMENTER_ARM);
> >>>> +		break;
> >>>> +	default:
> >>>> +		return 0;
> >>>> +	}
> >>>> +
> >>>> +	return extract_bytes(val, addr & 3, len);
> >>>
> >>> I don't think we allow anything than a full 32-bit aligned accesses
> >>> from userspace - we shouldn't at least.
> >>
> >> Indeed - I think userland was always 32-bit only. And since last night
> >> we even enforce this. So potentially there are more extract_bytes()
> >> calls that can go.
> >>
> > Right.
> 
> So can I replace every call to extract_bytes() with just a "return val;"
> for every register that allows 32-bit accesses only?
> I think that's safe now, just checking ...

yes, I think the way we do it now, you simply return val (asuming you
build that variable at the right offset, even for byte accesses).

The only exception is for 32-bit accesses to 64-bit registers, where you
have to return either the upper or lower 32-bits.  I think you can still
use extract_bytes() there should you be so inclined.

-Christoffer

