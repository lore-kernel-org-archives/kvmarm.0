From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v8 7/7] arm/arm64: vgic: Implement
 KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO ioctl
Date: Wed, 16 Nov 2016 19:52:38 +0100
Message-ID: <20161116185238.GG3811@cbox>
References: <1478258013-6669-1-git-send-email-vijay.kilari@gmail.com>
 <1478258013-6669-8-git-send-email-vijay.kilari@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 39AA9404E4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Nov 2016 13:52:12 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qeFiCPbUoN9t for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Nov 2016 13:52:11 -0500 (EST)
Received: from mail-qt0-f170.google.com (mail-qt0-f170.google.com
 [209.85.216.170])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 20C7F4044D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Nov 2016 13:52:11 -0500 (EST)
Received: by mail-qt0-f170.google.com with SMTP id c47so113298539qtc.2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Nov 2016 10:52:43 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1478258013-6669-8-git-send-email-vijay.kilari@gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: vijay.kilari@gmail.com
Cc: marc.zyngier@arm.com, Vijaya Kumar K <Vijaya.Kumar@cavium.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Nov 04, 2016 at 04:43:33PM +0530, vijay.kilari@gmail.com wrote:
> From: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
> 
> Userspace requires to store and restore of line_level for
> level triggered interrupts using ioctl KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO.
> 
> Signed-off-by: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
> ---
>  arch/arm64/include/uapi/asm/kvm.h   |  6 +++++
>  virt/kvm/arm/vgic/vgic-kvm-device.c | 50 ++++++++++++++++++++++++++++++++++++-
>  virt/kvm/arm/vgic/vgic-mmio-v3.c    | 11 ++++++++
>  virt/kvm/arm/vgic/vgic-mmio.c       | 33 ++++++++++++++++++++++++
>  virt/kvm/arm/vgic/vgic-mmio.h       |  5 ++++
>  virt/kvm/arm/vgic/vgic.h            |  3 +++
>  6 files changed, 107 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> index 91c7137..4100f8c 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -211,6 +211,12 @@ struct kvm_arch_memory_slot {
>  #define KVM_DEV_ARM_VGIC_GRP_CTRL	4
>  #define KVM_DEV_ARM_VGIC_GRP_REDIST_REGS 5
>  #define KVM_DEV_ARM_VGIC_CPU_SYSREGS    6
> +#define KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO 7
> +#define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT	10
> +#define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_MASK \
> +			(0x3fffffULL << KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT)
> +#define KVM_DEV_ARM_VGIC_LINE_LEVEL_INTID_MASK	0x3ff
> +#define VGIC_LEVEL_INFO_LINE_LEVEL	0
>  
>  #define   KVM_DEV_ARM_VGIC_CTRL_INIT	0
>  
> diff --git a/virt/kvm/arm/vgic/vgic-kvm-device.c b/virt/kvm/arm/vgic/vgic-kvm-device.c
> index da532d1..0f82a91 100644
> --- a/virt/kvm/arm/vgic/vgic-kvm-device.c
> +++ b/virt/kvm/arm/vgic/vgic-kvm-device.c
> @@ -512,6 +512,25 @@ static int vgic_v3_attr_regs_access(struct kvm_device *dev,
>  						  regid, reg);
>  		break;
>  	}
> +	case KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO: {
> +		unsigned int info, intid;
> +
> +		info = (attr->attr & KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_MASK) >>
> +			KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT;
> +		if (info == VGIC_LEVEL_INFO_LINE_LEVEL) {
> +			if (is_write)
> +				tmp32 = *reg;
> +			intid = attr->attr &
> +				KVM_DEV_ARM_VGIC_LINE_LEVEL_INTID_MASK;
> +			ret = vgic_v3_line_level_info_uaccess(vcpu, is_write,
> +							      intid, &tmp32);
> +			if (!is_write)
> +				*reg = tmp32;

I think you can avoid the indirection with tmp32 here by just making the
line level interface use an unsigned long.

> +		} else {
> +			ret = -EINVAL;
> +		}
> +		break;
> +	}
>  	default:
>  		ret = -EINVAL;
>  		break;
> @@ -554,6 +573,17 @@ static int vgic_v3_set_attr(struct kvm_device *dev,
>  
>  		return vgic_v3_attr_regs_access(dev, attr, &reg, true);
>  	}
> +	case KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO: {
> +		u32 __user *uaddr = (u32 __user *)(long)attr->addr;
> +		u64 reg;
> +		u32 tmp32;
> +
> +		if (get_user(tmp32, uaddr))
> +			return -EFAULT;
> +
> +		reg = tmp32;
> +		return vgic_v3_attr_regs_access(dev, attr, &reg, true);
> +	}
>  	}
>  	return -ENXIO;
>  }
> @@ -589,8 +619,18 @@ static int vgic_v3_get_attr(struct kvm_device *dev,
>  			return ret;
>  		return put_user(reg, uaddr);
>  	}
> -	}
> +	case KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO: {
> +		u32 __user *uaddr = (u32 __user *)(long)attr->addr;
> +		u64 reg;
> +		u32 tmp32;
>  
> +		ret = vgic_v3_attr_regs_access(dev, attr, &reg, false);
> +		if (ret)
> +			return ret;
> +		tmp32 = reg;
> +		return put_user(tmp32, uaddr);
> +	}
> +	}
>  	return -ENXIO;
>  }
>  
> @@ -611,11 +651,19 @@ static int vgic_v3_has_attr(struct kvm_device *dev,
>  		return vgic_v3_has_attr_regs(dev, attr);
>  	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
>  		return 0;
> +	case KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO: {
> +		if (((attr->attr & KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_MASK) >>
> +		      KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT) ==
> +		      VGIC_LEVEL_INFO_LINE_LEVEL)
> +			return 0;
> +		break;
> +	}
>  	case KVM_DEV_ARM_VGIC_GRP_CTRL:
>  		switch (attr->attr) {
>  		case KVM_DEV_ARM_VGIC_CTRL_INIT:
>  			return 0;
>  		}
> +		break;

spurious change?

>  	}
>  	return -ENXIO;
>  }
> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
> index 519b919..38b481c 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
> +++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
> @@ -807,3 +807,14 @@ int vgic_v3_redist_uaccess(struct kvm_vcpu *vcpu, bool is_write,
>  		return vgic_uaccess(vcpu, &rd_dev, is_write,
>  				    offset, val);
>  }
> +
> +int vgic_v3_line_level_info_uaccess(struct kvm_vcpu *vcpu, bool is_write,
> +				    u32 intid, u32 *val)
> +{
> +	if (is_write)
> +		vgic_write_irq_line_level_info(vcpu, intid, *val);
> +	else
> +		*val = vgic_read_irq_line_level_info(vcpu, intid);
> +
> +	return 0;
> +}
> diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
> index 173d6f0..fb018eb 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio.c
> +++ b/virt/kvm/arm/vgic/vgic-mmio.c
> @@ -371,6 +371,39 @@ void vgic_mmio_write_config(struct kvm_vcpu *vcpu,
>  	}
>  }
>  
> +unsigned long vgic_read_irq_line_level_info(struct kvm_vcpu *vcpu, u32 intid)
> +{
> +	int i;
> +	unsigned long val = 0;
> +
> +	for (i = 0; i < 32; i++) {
> +		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
> +
> +		if (irq->line_level)
> +			val |= (1U << i);
> +
> +		vgic_put_irq(vcpu->kvm, irq);
> +	}
> +
> +	return val;
> +}
> +
> +void vgic_write_irq_line_level_info(struct kvm_vcpu *vcpu, u32 intid,
> +				    const unsigned long val)
> +{
> +	int i;
> +
> +	for_each_set_bit(i, &val, 32) {

I think you misunderstood this part of the API.  Userspace should be
able to both set an asserted and deasserted line level, regardless of
what the value was before.  So you need to loop through all of them and
set the level as nneded.

> +		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
> +
> +		spin_lock(&irq->irq_lock);
> +		irq->line_level = true;

why don't you have to set pending as well and potentially queue the interrupt?

> +		spin_unlock(&irq->irq_lock);
> +
> +		vgic_put_irq(vcpu->kvm, irq);
> +	}
> +}
> +
>  static int match_region(const void *key, const void *elt)
>  {
>  	const unsigned int offset = (unsigned long)key;
> diff --git a/virt/kvm/arm/vgic/vgic-mmio.h b/virt/kvm/arm/vgic/vgic-mmio.h
> index acbf99e..938702c 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio.h
> +++ b/virt/kvm/arm/vgic/vgic-mmio.h
> @@ -181,6 +181,11 @@ int vgic_validate_mmio_region_addr(struct kvm_device *dev,
>  				   const struct vgic_register_region *regions,
>  				   int nr_regions, gpa_t addr);
>  
> +unsigned long vgic_read_irq_line_level_info(struct kvm_vcpu *vcpu, u32 intid);
> +
> +void vgic_write_irq_line_level_info(struct kvm_vcpu *vcpu, u32 intid,
> +				    const unsigned long val);
> +
>  unsigned int vgic_v2_init_dist_iodev(struct vgic_io_device *dev);
>  
>  unsigned int vgic_v3_init_dist_iodev(struct vgic_io_device *dev);
> diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
> index 0e632d0..77d3d84 100644
> --- a/virt/kvm/arm/vgic/vgic.h
> +++ b/virt/kvm/arm/vgic/vgic.h
> @@ -130,6 +130,9 @@ int vgic_v3_cpu_sysregs_uaccess(struct kvm_vcpu *vcpu, bool is_write,
>  			 u64 id, u64 *val);
>  int vgic_v3_has_cpu_sysregs_attr(struct kvm_vcpu *vcpu, bool is_write, u64 id,
>  				u64 *reg);
> +int vgic_v3_line_level_info_uaccess(struct kvm_vcpu *vcpu, bool is_write,
> +				    u32 intid, u32 *val);
> +
>  #else
>  static inline int vgic_register_its_iodevs(struct kvm *kvm)
>  {
> -- 
> 1.9.1
> 


Thanks,
-Christoffer
