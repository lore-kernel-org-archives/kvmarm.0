From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v10 7/8] arm/arm64: vgic: Implement
 KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO ioctl
Date: Fri, 20 Jan 2017 20:53:38 +0100
Message-ID: <20170120195338.GH13531@cbox>
References: <1480576187-5012-1-git-send-email-vijay.kilari@gmail.com>
 <1480576187-5012-8-git-send-email-vijay.kilari@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EFA934092C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Jan 2017 14:53:47 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id d8g7tJ9ECj+5 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 20 Jan 2017 14:53:46 -0500 (EST)
Received: from mail-lf0-f42.google.com (mail-lf0-f42.google.com
 [209.85.215.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 109FA40783
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Jan 2017 14:53:45 -0500 (EST)
Received: by mail-lf0-f42.google.com with SMTP id z134so64250961lff.3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Jan 2017 11:53:46 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1480576187-5012-8-git-send-email-vijay.kilari@gmail.com>
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

On Thu, Dec 01, 2016 at 12:39:46PM +0530, vijay.kilari@gmail.com wrote:
> From: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
> 
> Userspace requires to store and restore of line_level for
> level triggered interrupts using ioctl KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO.
> 
> Signed-off-by: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
> ---
>  arch/arm/include/uapi/asm/kvm.h     |  7 ++++++
>  arch/arm64/include/uapi/asm/kvm.h   |  6 +++++
>  virt/kvm/arm/vgic/vgic-kvm-device.c | 45 +++++++++++++++++++++++++++++++++++-
>  virt/kvm/arm/vgic/vgic-mmio-v3.c    | 11 +++++++++
>  virt/kvm/arm/vgic/vgic-mmio.c       | 46 +++++++++++++++++++++++++++++++++++++
>  virt/kvm/arm/vgic/vgic-mmio.h       |  5 ++++
>  virt/kvm/arm/vgic/vgic.h            |  2 ++
>  7 files changed, 121 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/include/uapi/asm/kvm.h b/arch/arm/include/uapi/asm/kvm.h
> index 98658d9d..f347779 100644
> --- a/arch/arm/include/uapi/asm/kvm.h
> +++ b/arch/arm/include/uapi/asm/kvm.h
> @@ -191,6 +191,13 @@ struct kvm_arch_memory_slot {
>  #define KVM_DEV_ARM_VGIC_GRP_CTRL       4
>  #define KVM_DEV_ARM_VGIC_GRP_REDIST_REGS 5
>  #define KVM_DEV_ARM_VGIC_CPU_SYSREGS    6
> +#define KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO 7
> +#define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT	10
> +#define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_MASK \
> +			(0x3fffffULL << KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT)
> +#define KVM_DEV_ARM_VGIC_LINE_LEVEL_INTID_MASK	0x3ff
> +#define VGIC_LEVEL_INFO_LINE_LEVEL	0
> +
>  #define   KVM_DEV_ARM_VGIC_CTRL_INIT    0
>  
>  /* KVM_IRQ_LINE irq field index values */
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
> index b6266fe..d5f7197 100644
> --- a/virt/kvm/arm/vgic/vgic-kvm-device.c
> +++ b/virt/kvm/arm/vgic/vgic-kvm-device.c
> @@ -510,6 +510,21 @@ static int vgic_v3_attr_regs_access(struct kvm_device *dev,
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
> @@ -552,6 +567,17 @@ static int vgic_v3_set_attr(struct kvm_device *dev,
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
> @@ -587,8 +613,18 @@ static int vgic_v3_get_attr(struct kvm_device *dev,
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
> @@ -609,6 +645,13 @@ static int vgic_v3_has_attr(struct kvm_device *dev,
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
> index 51439c9..9491d72 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
> +++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
> @@ -809,3 +809,14 @@ int vgic_v3_redist_uaccess(struct kvm_vcpu *vcpu, bool is_write,
>  		return vgic_uaccess(vcpu, &rd_dev, is_write,
>  				    offset, val);
>  }
> +
> +int vgic_v3_line_level_info_uaccess(struct kvm_vcpu *vcpu, bool is_write,
> +				    u32 intid, u64 *val)
> +{
> +	if (is_write)
> +		vgic_write_irq_line_level_info(vcpu, intid, *val);
> +	else
> +		*val = vgic_read_irq_line_level_info(vcpu, intid);
> +
> +	return 0;
> +}
> diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
> index f81e0e5..28fef92b 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio.c
> +++ b/virt/kvm/arm/vgic/vgic-mmio.c
> @@ -371,6 +371,52 @@ void vgic_mmio_write_config(struct kvm_vcpu *vcpu,
>  	}
>  }
>  
> +u64 vgic_read_irq_line_level_info(struct kvm_vcpu *vcpu, u32 intid)
> +{
> +	int i;
> +	u64 val = 0;
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
> +				    const u64 val)
> +{
> +	int i;
> +
> +	for (i = 0; i < 32; i++) {
> +		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
> +
> +		spin_lock(&irq->irq_lock);
> +		if (val & (1U << i)) {
> +			if (irq->config == VGIC_CONFIG_LEVEL) {
> +				irq->line_level = true;
> +				irq->pending = true;
> +				vgic_queue_irq_unlock(vcpu->kvm, irq);
> +			} else {
> +				spin_unlock(&irq->irq_lock);
> +			}
> +		} else {
> +			if (irq->config == VGIC_CONFIG_EDGE ||
> +			    (irq->config == VGIC_CONFIG_LEVEL &&
> +			    !irq->soft_pending))
> +				irq->line_level = false;
> +			spin_unlock(&irq->irq_lock);
> +		}


So last time we had a discussion about whether or not the API should
support any random order of restoring the registers, but I cannot see
how we can support that, because how can we tell the difference between
the following two scenarios without knowing if an interrupt is
edge-triggered or level triggered:

  (1) Clearing the line_level for an edge-triggered interrupt after
      having set it to pending, which means it should stay pending.

  (2) Clearing the line_level for a level-triggered interrupt when the
      state is already pending for some reason, but the soft_pending
      (latch) state is not set, in which case the pending state should
      be removed.

This leads me to conclude that userspace must restore the configuration
state of the interrupt before at least the line_level, in which case the
implementation becomes:

	for (i = 0; i < 32; i++) {
		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
		bool new_level = !!(val & (1U << i));

		if (irq->config == VGIC_CONFIG_EDGE)
			continue;

		spin_lock(&irq->irq_lock);
		irq->line_level = new_level;
		if (new_level) {
			irq->pending = true;
			vgic_queue_irq_unlock(vcpu->kvm, irq);
		} else {
			if (!irq->soft_pending)
				irq->pending = false;
			spin_unlock(&irq->irq_lock);
		}

		vgic_put_irq(vcpu->kvm, irq);
	}

Thanks,
-Christoffer
