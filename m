From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3 43/55] KVM: arm/arm64: vgic-new: vgic_kvm_device:
 access to VGIC registers
Date: Fri, 13 May 2016 14:29:40 +0200
Message-ID: <20160513122940.GJ27623@cbox>
References: <1462531568-9799-1-git-send-email-andre.przywara@arm.com>
 <1462531568-9799-44-git-send-email-andre.przywara@arm.com>
 <20160512183016.GJ27623@cbox>
 <5735C767.7030807@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5735C767.7030807@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Eric Auger <eric.auger@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, May 13, 2016 at 01:24:07PM +0100, Andre Przywara wrote:
> Hi,
> 
> On 12/05/16 19:30, Christoffer Dall wrote:
> > On Fri, May 06, 2016 at 11:45:56AM +0100, Andre Przywara wrote:
> >> From: Eric Auger <eric.auger@linaro.org>
> >>
> >> This patch implements the switches for KVM_DEV_ARM_VGIC_GRP_DIST_REGS
> >> and KVM_DEV_ARM_VGIC_GRP_CPU_REGS API which allows the userspace to
> >> access VGIC registers.
> >>
> >> Signed-off-by: Eric Auger <eric.auger@linaro.org>
> >> Signed-off-by: Andre Przywara <andre.przywara@arm.com>

[...]

> >> +int vgic_v2_has_attr_regs(struct kvm_device *dev, struct kvm_device_attr *attr)
> >> +{
> >> +	int nr_irqs = dev->kvm->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS;
> >> +	const struct vgic_register_region *regions;
> >> +	gpa_t addr;
> >> +	int nr_regions, i, len;
> >> +
> >> +	addr = attr->attr & KVM_DEV_ARM_VGIC_OFFSET_MASK;
> >> +
> >> +	switch (attr->group) {
> >> +	case KVM_DEV_ARM_VGIC_GRP_DIST_REGS:
> >> +		regions = vgic_v2_dist_registers;
> >> +		nr_regions = ARRAY_SIZE(vgic_v2_dist_registers);
> >> +		break;
> >> +	case KVM_DEV_ARM_VGIC_GRP_CPU_REGS:
> >> +		return -ENXIO;		/* TODO: describe CPU i/f regs also */
> >> +	default:
> >> +		return -ENXIO;
> >> +	}
> >> +
> >> +	for (i = 0; i < nr_regions; i++) {
> >> +		if (regions[i].bits_per_irq)
> >> +			len = (regions[i].bits_per_irq * nr_irqs) / 8;
> >> +		else
> >> +			len = regions[i].len;
> >> +
> >> +		if (regions[i].reg_offset <= addr &&
> >> +		    regions[i].reg_offset + len > addr)
> >> +			return 0;
> > 
> > should we check if addr is word-aligned ?
> 
> Do we care here? This is just the function that says whether we support
> this register or not, so I don't see so much benefit in checking here.
> A check would be more useful in get/set_attr, if this isn't even
> enforced before.
> 

It's kind of weird that you can ask 'do you have an attribute with
offset 0x2' and be told, 'yes', and then if you try to get it, you get
'this attribute doesn't exist'.

Thanks,
-Christoffer
