From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v6 07/24] KVM: arm64: vgic-its: Implement
 vgic_its_has_attr_regs and attr_regs_access
Date: Thu, 4 May 2017 18:48:51 +0200
Message-ID: <20170504164851.GQ5923@cbox>
References: <1493898284-29504-1-git-send-email-eric.auger@redhat.com>
 <1493898284-29504-8-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1493898284-29504-8-git-send-email-eric.auger@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Eric Auger <eric.auger@redhat.com>
Cc: eric.auger.pro@gmail.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, andre.przywara@arm.com, vijayak@caviumnetworks.com, Vijaya.Kumar@cavium.com, peter.maydell@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Prasun.Kapoor@cavium.com, drjones@redhat.com, pbonzini@redhat.com, dgilbert@redhat.com, quintela@redhat.com, bjsprakash.linux@gmail.com
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, May 04, 2017 at 01:44:27PM +0200, Eric Auger wrote:
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
> v6 -> v6:
> - fix GITS_PIDR/CIDR accesses
> - remove vgic_data_mmio_bus_to_host/vgic_data_host_to_mmio_bus
> - 64b full reg access comment rewording
> - vgic_its_attr_regs_access declaration block rework including
>   removal of iodev
> 
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
>  virt/kvm/arm/vgic/vgic-its.c  | 70 +++++++++++++++++++++++++++++++++++++++++--
>  virt/kvm/arm/vgic/vgic-mmio.h |  9 ++++--
>  2 files changed, 75 insertions(+), 4 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> index f687e91..222fad5 100644
> --- a/virt/kvm/arm/vgic/vgic-its.c
> +++ b/virt/kvm/arm/vgic/vgic-its.c
> @@ -1469,14 +1469,80 @@ static void vgic_its_destroy(struct kvm_device *kvm_dev)
>  int vgic_its_has_attr_regs(struct kvm_device *dev,
>  			   struct kvm_device_attr *attr)
>  {
> -	return -ENXIO;
> +	const struct vgic_register_region *region;
> +	gpa_t offset = attr->attr;
> +
> +	region = vgic_find_mmio_region(its_registers,
> +				       ARRAY_SIZE(its_registers),
> +				       offset);
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
> +	struct vgic_its *its;
> +	gpa_t addr, offset;
> +	unsigned int len;
> +	int align, ret = 0;
> +
> +	its = dev->private;
> +	offset = attr->attr;
> +
> +	/*
> +	 * Although the spec supports upper/lower 32-bit accesses to
> +	 * 64-bit ITS registers, the userspace ABI requires 64-bit
> +	 * accesses to all 64-bit wide registers. We therefore only
> +	 * support 32-bit accesses to GITS_CTLR, GITS_IIDR and GITS ID
> +	 * registers
> +	 */
> +	align = (offset < GITS_TYPER) || (offset >= GITS_PIDR4) ? 0x3 : 0x7;

nit: this should be written out instead of using the ternary
conditional.

> +
> +	if (offset & align)
> +		return -EINVAL;
> +
> +	mutex_lock(&dev->kvm->lock);
> +
> +	if (IS_VGIC_ADDR_UNDEF(its->vgic_its_base)) {
> +		ret = -ENXIO;
> +		goto out;
> +	}
> +
> +	region = vgic_find_mmio_region(its_registers,
> +				       ARRAY_SIZE(its_registers),
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
> +	len = region->access_flags & VGIC_ACCESS_64bit ? 8 : 4;
> +
> +	if (is_write) {
> +		if (region->uaccess_its_write)
> +			ret = region->uaccess_its_write(dev->kvm, its, addr,
> +							len, *reg);
> +		else
> +			region->its_write(dev->kvm, its, addr, len, *reg);
> +	} else {
> +		*reg = region->its_read(dev->kvm, its, addr, len);
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

Otherwise:

Reviewed-by: Christoffer Dall <cdall@linaro.org>
