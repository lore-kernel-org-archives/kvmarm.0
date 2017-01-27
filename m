From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v11 7/8] arm/arm64: vgic: Implement
 KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO ioctl
Date: Fri, 27 Jan 2017 09:32:51 +0100
Message-ID: <682b1b3e-c5ab-6e8a-54b5-fc85317e58d8@redhat.com>
References: <1485440453-10597-1-git-send-email-vijay.kilari@gmail.com>
 <1485440453-10597-8-git-send-email-vijay.kilari@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A1AD840783
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Jan 2017 03:32:45 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DX4bH49g8BMI for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 Jan 2017 03:32:44 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6D354400E9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Jan 2017 03:32:44 -0500 (EST)
In-Reply-To: <1485440453-10597-8-git-send-email-vijay.kilari@gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: vijay.kilari@gmail.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, peter.maydell@linaro.org
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Vijaya Kumar K <Vijaya.Kumar@cavium.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 26/01/2017 15:20, vijay.kilari@gmail.com wrote:
> From: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
> 
> Userspace requires to store and restore of line_level for
> level triggered interrupts using ioctl KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO.
> 
> Signed-off-by: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
> ---
>  arch/arm/include/uapi/asm/kvm.h     |  6 +++++
>  arch/arm64/include/uapi/asm/kvm.h   |  6 +++++
>  virt/kvm/arm/vgic/vgic-kvm-device.c | 45 ++++++++++++++++++++++++++++++-
>  virt/kvm/arm/vgic/vgic-mmio-v3.c    | 14 ++++++++++
>  virt/kvm/arm/vgic/vgic-mmio.c       | 54 +++++++++++++++++++++++++++++++++++++
>  virt/kvm/arm/vgic/vgic-mmio.h       |  5 ++++
>  virt/kvm/arm/vgic/vgic.h            |  2 ++
>  7 files changed, 131 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/include/uapi/asm/kvm.h b/arch/arm/include/uapi/asm/kvm.h
> index 7a3e537..6ebd3e6 100644
> --- a/arch/arm/include/uapi/asm/kvm.h
> +++ b/arch/arm/include/uapi/asm/kvm.h
> @@ -191,6 +191,12 @@ struct kvm_arch_memory_slot {
>  #define KVM_DEV_ARM_VGIC_GRP_CTRL       4
>  #define KVM_DEV_ARM_VGIC_GRP_REDIST_REGS 5
>  #define KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS 6
> +#define KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO  7
> +#define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT	10
> +#define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_MASK \
> +			(0x3fffffULL << KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT)
> +#define KVM_DEV_ARM_VGIC_LINE_LEVEL_INTID_MASK 0x3ff
> +#define VGIC_LEVEL_INFO_LINE_LEVEL	0
>  
>  #define   KVM_DEV_ARM_VGIC_CTRL_INIT    0
>  
> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> index be379d7..c286035 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -211,6 +211,12 @@ struct kvm_arch_memory_slot {
>  #define KVM_DEV_ARM_VGIC_GRP_CTRL	4
>  #define KVM_DEV_ARM_VGIC_GRP_REDIST_REGS 5
>  #define KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS 6
> +#define KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO  7
> +#define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT	10
> +#define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_MASK \
> +			(0x3fffffULL << KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT)
> +#define KVM_DEV_ARM_VGIC_LINE_LEVEL_INTID_MASK	0x3ff
> +#define VGIC_LEVEL_INFO_LINE_LEVEL	0
>  
>  #define   KVM_DEV_ARM_VGIC_CTRL_INIT	0
>  
> diff --git a/virt/kvm/arm/vgic/vgic-kvm-device.c b/virt/kvm/arm/vgic/vgic-kvm-device.c
> index b30372b..d181d2b 100644
> --- a/virt/kvm/arm/vgic/vgic-kvm-device.c
> +++ b/virt/kvm/arm/vgic/vgic-kvm-device.c
> @@ -512,6 +512,21 @@ static int vgic_v3_attr_regs_access(struct kvm_device *dev,
>  						  regid, reg);
>  		break;
>  	}
> +	case KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO: {
> +		unsigned int info, intid;
> +
> +		info = (attr->attr & KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_MASK) >>
> +			KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT;
> +		if (info == VGIC_LEVEL_INFO_LINE_LEVEL) {
> +			intid = attr->attr &
> +				KVM_DEV_ARM_VGIC_LINE_LEVEL_INTID_MASK;
> +			ret = vgic_v3_line_level_info_uaccess(vcpu, is_write,
> +							      intid, reg);
> +		} else {
> +			ret = -EINVAL;
> +		}
> +		break;
> +	}
>  	default:
>  		ret = -EINVAL;
>  		break;
> @@ -554,6 +569,17 @@ static int vgic_v3_set_attr(struct kvm_device *dev,
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
> @@ -589,8 +615,18 @@ static int vgic_v3_get_attr(struct kvm_device *dev,
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
> @@ -611,6 +647,13 @@ static int vgic_v3_has_attr(struct kvm_device *dev,
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
> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
> index 549ae45..6afb3b4 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
> +++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
> @@ -803,3 +803,17 @@ int vgic_v3_redist_uaccess(struct kvm_vcpu *vcpu, bool is_write,
>  	else
>  		return vgic_uaccess(vcpu, &rd_dev, is_write, offset, val);
>  }
> +
> +int vgic_v3_line_level_info_uaccess(struct kvm_vcpu *vcpu, bool is_write,
> +				    u32 intid, u64 *val)
> +{
> +	if (intid % 32)
> +		return -EINVAL;
> +
> +	if (is_write)
> +		vgic_write_irq_line_level_info(vcpu, intid, *val);
> +	else
> +		*val = vgic_read_irq_line_level_info(vcpu, intid);
> +
> +	return 0;
> +}
> diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
> index 1d1886e..3654b4c 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio.c
> +++ b/virt/kvm/arm/vgic/vgic-mmio.c
> @@ -362,6 +362,60 @@ void vgic_mmio_write_config(struct kvm_vcpu *vcpu,
>  	}
>  }
>  
> +u64 vgic_read_irq_line_level_info(struct kvm_vcpu *vcpu, u32 intid)
> +{
> +	int i;
> +	u64 val = 0;
> +	int nr_irqs = vcpu->kvm->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS;
> +
> +	for (i = 0; i < 32; i++) {
> +		struct vgic_irq *irq;
> +
> +		if ((intid + i) < VGIC_NR_SGIS || (intid + i) >= nr_irqs)
> +			continue;
nit: there is vgic_irq_is_sgi and !vgic_valid_spi
> +
> +		irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
> +		if (irq->config == VGIC_CONFIG_LEVEL && irq->line_level)
> +			val |= (1U << i);
> +
> +		vgic_put_irq(vcpu->kvm, irq);
> +	}
> +
> +	return val;
> +}
> +
> +void vgic_write_irq_line_level_info(struct kvm_vcpu *vcpu, u32 intid,
> +				    const u64 val)
> +{
> +	int i;
> +	int nr_irqs = vcpu->kvm->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS;
> +
> +	for (i = 0; i < 32; i++) {
> +		struct vgic_irq *irq;
> +		bool new_level;
> +
> +		if ((intid + i) < VGIC_NR_SGIS || (intid + i) >= nr_irqs)
nit: same as above
> +			continue;
> +
> +		irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
> +
> +		/*
> +		 * Line level is set irrespective of irq type
> +		 * (level or edge) to avoid dependency that VM should
> +		 * restore irq config before line level.
> +		 */
> +		new_level = !!(val & (1U << i));
> +		spin_lock(&irq->irq_lock);
> +		irq->line_level = new_level;
> +		if (new_level)
> +			vgic_queue_irq_unlock(vcpu->kvm, irq);
> +		else
> +			spin_unlock(&irq->irq_lock);
> +
> +		vgic_put_irq(vcpu->kvm, irq);
> +	}
> +}
> +
>  static int match_region(const void *key, const void *elt)
>  {
>  	const unsigned int offset = (unsigned long)key;
> diff --git a/virt/kvm/arm/vgic/vgic-mmio.h b/virt/kvm/arm/vgic/vgic-mmio.h
> index 7b30296..98bb566 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio.h
> +++ b/virt/kvm/arm/vgic/vgic-mmio.h
> @@ -177,6 +177,11 @@ void vgic_mmio_write_config(struct kvm_vcpu *vcpu,
>  int vgic_uaccess(struct kvm_vcpu *vcpu, struct vgic_io_device *dev,
>  		 bool is_write, int offset, u32 *val);
>  
> +u64 vgic_read_irq_line_level_info(struct kvm_vcpu *vcpu, u32 intid);
> +
> +void vgic_write_irq_line_level_info(struct kvm_vcpu *vcpu, u32 intid,
> +				    const u64 val);
> +
>  unsigned int vgic_v2_init_dist_iodev(struct vgic_io_device *dev);
>  
>  unsigned int vgic_v3_init_dist_iodev(struct vgic_io_device *dev);
> diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
> index a5a45f6..db28f7c 100644
> --- a/virt/kvm/arm/vgic/vgic.h
> +++ b/virt/kvm/arm/vgic/vgic.h
> @@ -164,6 +164,8 @@ int vgic_v3_cpu_sysregs_uaccess(struct kvm_vcpu *vcpu, bool is_write,
>  			 u64 id, u64 *val);
>  int vgic_v3_has_cpu_sysregs_attr(struct kvm_vcpu *vcpu, bool is_write, u64 id,
>  				u64 *reg);
> +int vgic_v3_line_level_info_uaccess(struct kvm_vcpu *vcpu, bool is_write,
> +				    u32 intid, u64 *val);
>  int kvm_register_vgic_device(unsigned long type);
>  void vgic_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
>  void vgic_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
> 
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
