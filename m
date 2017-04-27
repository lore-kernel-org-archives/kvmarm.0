From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v5 07/22] KVM: arm64: vgic-its: Implement
 vgic_its_has_attr_regs and attr_regs_access
Date: Thu, 27 Apr 2017 04:00:03 -0700
Message-ID: <20170427110003.GG50776@lvm>
References: <1492164934-988-1-git-send-email-eric.auger@redhat.com>
 <1492164934-988-8-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1492164934-988-8-git-send-email-eric.auger@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Eric Auger <eric.auger@redhat.com>
Cc: eric.auger.pro@gmail.com, marc.zyngier@arm.com, andre.przywara@arm.com, vijayak@caviumnetworks.com, Vijaya.Kumar@cavium.com, peter.maydell@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Prasun.Kapoor@cavium.com, drjones@redhat.com, pbonzini@redhat.com, dgilbert@redhat.com, quintela@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Apr 14, 2017 at 12:15:19PM +0200, Eric Auger wrote:
> This patch implements vgic_its_has_attr_regs and vgic_its_attr_regs_access
> upon the MMIO framework. VGIC ITS KVM device KVM_DEV_ARM_VGIC_GRP_ITS_REGS
> group becomes functional.
> 
> At least GITS_CREADR and GITS_IIDR require to differentiate a guest write
> action from a user access. As such let's introduce a new uaccess_its_write
> vgic_register_region callback.
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> 
> ---
> v4 -> v5:
> - use GITS_TYPER instead of offset 0x8
> - uaccess_its_write now can return an error
> 
> v3 -> v4:
> - remove changes to the REGISTER_ITS_DESC macro. This will be handled in
>   subsequent patch with the introduction of a new REGISTER_ITS_DESC_UACCESS
>   macro
> - fix IIDR access and add a comment wrt full length access
> - handle endianness
> - add kvm lock and vcpus lock
> ---
>  virt/kvm/arm/vgic/vgic-its.c  | 79 +++++++++++++++++++++++++++++++++++++++++--
>  virt/kvm/arm/vgic/vgic-mmio.h |  9 +++--
>  2 files changed, 84 insertions(+), 4 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> index f687e91..a9a2c12 100644
> --- a/virt/kvm/arm/vgic/vgic-its.c
> +++ b/virt/kvm/arm/vgic/vgic-its.c
> @@ -1469,14 +1469,89 @@ static void vgic_its_destroy(struct kvm_device *kvm_dev)
>  int vgic_its_has_attr_regs(struct kvm_device *dev,
>  			   struct kvm_device_attr *attr)
>  {
> -	return -ENXIO;
> +	const struct vgic_register_region *region;
> +	struct vgic_io_device iodev = {
> +		.regions = its_registers,
> +		.nr_regions = ARRAY_SIZE(its_registers),
> +	};
> +	gpa_t offset = attr->attr;
> +
> +	region = vgic_find_mmio_region(iodev.regions,
> +				       iodev.nr_regions,
> +				       offset);

why do you need to define the iodev here?  Can't you just pass
its_registers and ARRAY_SIZE(its_registers) directly?

> +	if (!region)
> +		return -ENXIO;
> +
> +	return 0;
>  }
>  
>  int vgic_its_attr_regs_access(struct kvm_device *dev,
>  			      struct kvm_device_attr *attr,
>  			      u64 *reg, bool is_write)
>  {
> -	return -ENXIO;
> +	const struct vgic_register_region *region;
> +	struct vgic_io_device iodev = {
> +		.regions = its_registers,
> +		.nr_regions = ARRAY_SIZE(its_registers),
> +	};
> +	struct vgic_its *its = dev->private;
> +	gpa_t addr, offset = attr->attr;
> +	unsigned int len;
> +	unsigned long data = 0;
> +	int ret = 0;

nit: you could structure this whole declaration block more nicely by
having a separate line for the declaration and initialization of offset,
and by moving the iodev declaration/initialization to the end.

It might also be cleaner to do any non-zero initialization in a separate
block following the declarations.

> +
> +	/*
> +	 * Among supported registers, only GITS_CTLR (0x0) and GITS_IIDR (0x4)
> +	 * are 32 bits. Others are 64 bits.
> +	 */
> +	if ((offset < GITS_TYPER && offset & 0x3) ||
> +	    (offset >= GITS_TYPER && offset & 0x7))
> +		return -EINVAL;
> +
> +	mutex_lock(&dev->kvm->lock);
> +
> +	if (IS_VGIC_ADDR_UNDEF(its->vgic_its_base)) {
> +		ret = -ENXIO;
> +		goto out;
> +	}
> +
> +	region = vgic_find_mmio_region(iodev.regions,
> +				       iodev.nr_regions,
> +				       offset);
> +	if (!region) {
> +		ret = -ENXIO;
> +		goto out;
> +	}
> +
> +	if (!lock_all_vcpus(dev->kvm)) {
> +		ret = -EBUSY;
> +		goto out;
> +	}
> +
> +	addr = its->vgic_its_base + offset;
> +
> +	/*
> +	 * Only full length register accesses are supported although
> +	 * the architecture spec theoretically allows upper/lower 32

does the spec allow 32-bit accesses, or only theoretically ?  :)

> +	 * bits to be accessed independently
> +	 */

In any case, the comment is a bit confusing, because it seems to imply
that we only support 64-bit accesses, but we do set the length below to
4 or 8.

Did you mean:

	/* 
	 * Althought the spec supports upper/lower 32-bit accesses to
	 * 64-bit ITS registers, the userspace ABI requires 64-bit
	 * accesses to all 64-bit wide registers.  We therefore only 32-bit
	 * accesses to the GITS_CTLR, GITS_IIDR registers.
	 */

Also, I don't understand how this works with the ID registers?  For
example, if userspace wants to read GITS_PIDR1 does it have to read
GITS_PIDR0 as a 64-bit register and split it afterwards?  (that doesn't
work with this implementation)

> +	len = region->access_flags & VGIC_ACCESS_64bit ? 8 : 4;
> +
> +	if (is_write) {
> +		data = vgic_data_mmio_bus_to_host(reg, len);

I don't think we need this anymore; we no longer share the guest
trapping MMIO path with uaccesses.

> +		if (region->uaccess_its_write)
> +			ret = region->uaccess_its_write(dev->kvm, its, addr,
> +							len, data);
> +		else
> +			region->its_write(dev->kvm, its, addr, len, data);
> +	} else {
> +		data = region->its_read(dev->kvm, its, addr, len);
> +		vgic_data_host_to_mmio_bus(reg, len, data);

same here.

> +	}
> +	unlock_all_vcpus(dev->kvm);
> +out:
> +	mutex_unlock(&dev->kvm->lock);
> +	return ret;
>  }
>  
>  static int vgic_its_has_attr(struct kvm_device *dev,
> diff --git a/virt/kvm/arm/vgic/vgic-mmio.h b/virt/kvm/arm/vgic/vgic-mmio.h
> index 6eec91b..ea4171a 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio.h
> +++ b/virt/kvm/arm/vgic/vgic-mmio.h
> @@ -36,8 +36,13 @@ struct vgic_register_region {
>  	};
>  	unsigned long (*uaccess_read)(struct kvm_vcpu *vcpu, gpa_t addr,
>  				      unsigned int len);
> -	void (*uaccess_write)(struct kvm_vcpu *vcpu, gpa_t addr,
> -			      unsigned int len, unsigned long val);
> +	union {
> +		void (*uaccess_write)(struct kvm_vcpu *vcpu, gpa_t addr,
> +				      unsigned int len, unsigned long val);
> +		int (*uaccess_its_write)(struct kvm *kvm, struct vgic_its *its,
> +					 gpa_t addr, unsigned int len,
> +					 unsigned long val);
> +	};
>  };
>  
>  extern struct kvm_io_device_ops kvm_io_gic_ops;
> -- 
> 2.5.5
> 

Thanks,
-Christoffer
