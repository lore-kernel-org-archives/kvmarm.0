From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [RFC PATCH v3 5/5] arm/arm64: vgic-new: Implement
 KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO ioctl
Date: Tue, 30 Aug 2016 16:00:34 +0200
Message-ID: <20160830140034.GK10162@cbox>
References: <1472037609-4164-1-git-send-email-vijay.kilari@gmail.com>
 <1472037609-4164-6-git-send-email-vijay.kilari@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 25729410EB
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Aug 2016 09:50:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vN07Zjb2XRAf for <kvmarm@lists.cs.columbia.edu>;
 Tue, 30 Aug 2016 09:50:11 -0400 (EDT)
Received: from mail-wm0-f50.google.com (mail-wm0-f50.google.com [74.125.82.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8B4B540FA2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Aug 2016 09:50:11 -0400 (EDT)
Received: by mail-wm0-f50.google.com with SMTP id d196so22802329wmd.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Aug 2016 06:58:16 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1472037609-4164-6-git-send-email-vijay.kilari@gmail.com>
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

On Wed, Aug 24, 2016 at 04:50:09PM +0530, vijay.kilari@gmail.com wrote:
> From: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
> 
> Userspace requires to store and restore of line_level for
> level triggered interrupts. For this ioctl KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO
> is defined.
> 
> Signed-off-by: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
> ---
>  arch/arm64/include/uapi/asm/kvm.h   |  6 +++++
>  virt/kvm/arm/vgic/vgic-kvm-device.c | 44 ++++++++++++++++++++++++++++++++++++-
>  virt/kvm/arm/vgic/vgic-mmio-v3.c    | 19 ++++++++++++++++
>  virt/kvm/arm/vgic/vgic-mmio.c       | 34 ++++++++++++++++++++++++++++
>  virt/kvm/arm/vgic/vgic-mmio.h       |  6 +++++
>  virt/kvm/arm/vgic/vgic.h            |  3 +++
>  6 files changed, 111 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> index b13c944..45c56d7 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -209,6 +209,12 @@ struct kvm_arch_memory_slot {
>  #define KVM_DEV_ARM_VGIC_GRP_CTRL	4
>  #define KVM_DEV_ARM_VGIC_GRP_REDIST_REGS 5
>  #define KVM_DEV_ARM_VGIC_CPU_SYSREGS    6
> +#define KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO 7
> +#define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT	9

This should be 10, bits 0 through 9 gives you 10 to work with.

> +#define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_MASK \
> +			(0x7fffffULL << KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT)

this mask is also wrong, 32 - 10 == 22, not 23.

> +#define KVM_DEV_ARM_VGIC_LINE_LEVEL_INTID_MASK	0x1ff

this is also wrong, you have 10 bits, not 9 bits.

Hint: the max SPI number is around 1024.

> +#define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_VAL	1

This should really be KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO_LEVEL.  Why is 0
not a valid value?

>  
>  #define   KVM_DEV_ARM_VGIC_CTRL_INIT	0
>  #define   KVM_DEV_ARM_VGIC_SYSREG_MASK (KVM_REG_ARM64_SYSREG_OP0_MASK | \
> diff --git a/virt/kvm/arm/vgic/vgic-kvm-device.c b/virt/kvm/arm/vgic/vgic-kvm-device.c
> index 74e5c38..7e3bc49 100644
> --- a/virt/kvm/arm/vgic/vgic-kvm-device.c
> +++ b/virt/kvm/arm/vgic/vgic-kvm-device.c
> @@ -509,6 +509,23 @@ static int vgic_attr_regs_access_v3(struct kvm_device *dev,
>  						  regid, reg);
>  		break;
>  	}
> +	case KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO: {
> +		unsigned int info, intid;
> +
> +		info = (attr->attr & KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_MASK) >>
> +			KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT;
> +		if (info == KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_VAL) {
> +			intid = attr->attr &
> +				KVM_DEV_ARM_VGIC_LINE_LEVEL_INTID_MASK;
> +			ret = vgic_v3_line_level_info_uaccess(vcpu, is_write,
> +							      intid, &tmp32);
> +			if (!is_write)
> +				*reg = tmp32;
> +		} else {
> +			ret = -EINVAL;
> +		}
> +		break;
> +	}
>  	default:
>  		ret = -EINVAL;
>  		break;
> @@ -551,6 +568,17 @@ static int vgic_v3_set_attr(struct kvm_device *dev,
>  
>  		return vgic_attr_regs_access_v3(dev, attr, &reg, true);
>  	}
> +	case KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO: {
> +		u32 __user *uaddr = (u32 __user *)(long)attr->addr;
> +		u64 reg;
> +		u32 tmp32;

here we have more type fun, which I assume you fix based on my comments
on a previous patch.

> +
> +		if (get_user(tmp32, uaddr))
> +			return -EFAULT;
> +
> +		reg = tmp32;
> +		return vgic_attr_regs_access_v3(dev, attr, &reg, true);
> +	}
>  	}
>  	return -ENXIO;
>  }
> @@ -588,8 +616,19 @@ static int vgic_v3_get_attr(struct kvm_device *dev,
>  		ret = put_user(reg, uaddr);
>  		return ret;
>  	}
> -	}
> +	case KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO: {
> +		u32 __user *uaddr = (u32 __user *)(long)attr->addr;
> +		u64 reg;
> +		u32 tmp32;
>  
> +		ret = vgic_attr_regs_access_v3(dev, attr, &reg, false);
> +		if (ret)
> +			return ret;
> +		tmp32 = reg;
> +		ret = put_user(tmp32, uaddr);
> +		return ret;
> +	}
> +	}
>  	return -ENXIO;
>  }
>  
> @@ -610,11 +649,14 @@ static int vgic_v3_has_attr(struct kvm_device *dev,
>  		return vgic_v3_has_attr_regs(dev, attr);
>  	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
>  		return 0;
> +	case KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO:
> +		return 0;

probably you should check the info field here as well

>  	case KVM_DEV_ARM_VGIC_GRP_CTRL:
>  		switch (attr->attr) {
>  		case KVM_DEV_ARM_VGIC_CTRL_INIT:
>  			return 0;
>  		}
> +		break;
>  	}
>  	return -ENXIO;
>  }
> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
> index 61abea0..fde1472 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
> +++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
> @@ -789,3 +789,22 @@ int vgic_v3_redist_uaccess(struct kvm_vcpu *vcpu, bool is_write,
>  
>  	return vgic_v3_uaccess(vcpu, dev, is_write, offset, val);
>  }
> +
> +int vgic_v3_line_level_info_uaccess(struct kvm_vcpu *vcpu, bool is_write,
> +				    u32 intid, u32 *val)
> +{
> +	unsigned int len = 4;
> +	u8 buf[4];
> +	int ret;
> +
> +	if (is_write) {
> +		vgic_data_host_to_mmio_bus(buf, len, *val);

why do you involve the mmio bus in this?

> +		ret = vgic_write_irq_line_level_info(vcpu, intid, len, buf);
> +	} else {
> +		ret = vgic_read_irq_line_level_info(vcpu, intid, len, buf);
> +		if (!ret)
> +			*val = vgic_data_mmio_bus_to_host(buf, len);
> +	}
> +
> +	return ret;
> +}
> diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
> index 38f2c75..74d0449 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio.c
> +++ b/virt/kvm/arm/vgic/vgic-mmio.c
> @@ -391,6 +391,40 @@ void vgic_mmio_write_config(struct kvm_vcpu *vcpu,
>  	}
>  }
>  
> +int vgic_read_irq_line_level_info(struct kvm_vcpu *vcpu, u32 intid,
> +				  unsigned int len, void *val)
> +{
> +	unsigned long data = 0;
> +	int i;
> +
> +	for (i = 0; i < len * 8; i++) {
> +		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
> +
> +		if (irq->line_level)
> +			data |= (1U << i);
> +	}
> +	vgic_data_host_to_mmio_bus(val, len, data);

why???

> +
> +	return 0;
> +}
> +
> +int vgic_write_irq_line_level_info(struct kvm_vcpu *vcpu, u32 intid,
> +				   unsigned int len, const void *val)
> +{
> +	int i;
> +	unsigned long data = vgic_data_mmio_bus_to_host(val, len);

why???

> +
> +	for_each_set_bit(i, &data, len * 8) {
> +		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
> +
> +		spin_lock(&irq->irq_lock);
> +		irq->line_level = true;
> +		spin_unlock(&irq->irq_lock);
> +	}
> +
> +	return 0;
> +}
> +
>  static int match_region(const void *key, const void *elt)
>  {
>  	const unsigned int offset = (unsigned long)key;
> diff --git a/virt/kvm/arm/vgic/vgic-mmio.h b/virt/kvm/arm/vgic/vgic-mmio.h
> index b97a97b..b03c4e7 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio.h
> +++ b/virt/kvm/arm/vgic/vgic-mmio.h
> @@ -183,6 +183,12 @@ int vgic_mmio_uaccess_read(struct kvm_vcpu *vcpu, struct kvm_io_device *dev,
>  int vgic_mmio_uaccess_write(struct kvm_vcpu *vcpu, struct kvm_io_device *dev,
>  			    gpa_t addr, int len, const void *val);
>  
> +int vgic_read_irq_line_level_info(struct kvm_vcpu *vcpu, u32 intid,
> +				  unsigned int len, void *val);
> +
> +int vgic_write_irq_line_level_info(struct kvm_vcpu *vcpu, u32 intid,
> +				   unsigned int len, const void *val);
> +
>  unsigned int vgic_v2_init_dist_iodev(struct vgic_io_device *dev);
>  
>  unsigned int vgic_v3_init_dist_iodev(struct vgic_io_device *dev);
> diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
> index 20eab36c..b8ee5b9 100644
> --- a/virt/kvm/arm/vgic/vgic.h
> +++ b/virt/kvm/arm/vgic/vgic.h
> @@ -100,6 +100,9 @@ int vgic_v3_cpu_sysregs_uaccess(struct kvm_vcpu *vcpu, bool is_write,
>  			 u64 id, u64 *val);
>  int vgic_v3_has_cpu_sysregs_attr(struct kvm_vcpu *vcpu, bool is_write, u64 id,
>  				u64 *reg);
> +int vgic_v3_line_level_info_uaccess(struct kvm_vcpu *vcpu, bool is_write,
> +				    u32 intid, u32 *val);
> +
>  #else
>  static inline void vgic_v3_process_maintenance(struct kvm_vcpu *vcpu)
>  {
> -- 
> 1.9.1
> 
