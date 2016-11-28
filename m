From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v9 02/11] arm/arm64: vgic: Add distributor and
 redistributor access
Date: Mon, 28 Nov 2016 14:08:25 +0100
Message-ID: <20161128130825.GD18170@cbox>
References: <1479906118-15832-1-git-send-email-vijay.kilari@gmail.com>
 <1479906118-15832-3-git-send-email-vijay.kilari@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AFD3E4065B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Nov 2016 08:07:45 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aC3j9R+L3frd for <kvmarm@lists.cs.columbia.edu>;
 Mon, 28 Nov 2016 08:07:44 -0500 (EST)
Received: from mail-lf0-f42.google.com (mail-lf0-f42.google.com
 [209.85.215.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id ADD92405D5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Nov 2016 08:07:43 -0500 (EST)
Received: by mail-lf0-f42.google.com with SMTP id b14so95752202lfg.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Nov 2016 05:08:30 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1479906118-15832-3-git-send-email-vijay.kilari@gmail.com>
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

On Wed, Nov 23, 2016 at 06:31:49PM +0530, vijay.kilari@gmail.com wrote:
> From: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
> 
> VGICv3 Distributor and Redistributor registers are accessed using
> KVM_DEV_ARM_VGIC_GRP_DIST_REGS and KVM_DEV_ARM_VGIC_GRP_REDIST_REGS
> with KVM_SET_DEVICE_ATTR and KVM_GET_DEVICE_ATTR ioctls.
> These registers are accessed as 32-bit and cpu mpidr
> value passed along with register offset is used to identify the
> cpu for redistributor registers access.
> 
> The version of VGIC v3 specification is define here
> Documentation/virtual/kvm/devices/arm-vgic-v3.txt
> 
> Also update arch/arm/include/uapi/asm/kvm.h to compile for
> AArch32 mode.
> 
> Signed-off-by: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
> ---
>  arch/arm/include/uapi/asm/kvm.h     |   4 +
>  arch/arm64/include/uapi/asm/kvm.h   |   4 +
>  virt/kvm/arm/vgic/vgic-kvm-device.c | 144 ++++++++++++++++++++++++++++++++++--
>  virt/kvm/arm/vgic/vgic-mmio-v2.c    |  16 +---
>  virt/kvm/arm/vgic/vgic-mmio-v3.c    |  72 ++++++++++++++++++
>  virt/kvm/arm/vgic/vgic-mmio.c       |  22 ++++++
>  virt/kvm/arm/vgic/vgic-mmio.h       |   4 +
>  virt/kvm/arm/vgic/vgic.h            |  49 +++++++++++-
>  8 files changed, 292 insertions(+), 23 deletions(-)
> 
> diff --git a/arch/arm/include/uapi/asm/kvm.h b/arch/arm/include/uapi/asm/kvm.h
> index af05f8e..0ae6035 100644
> --- a/arch/arm/include/uapi/asm/kvm.h
> +++ b/arch/arm/include/uapi/asm/kvm.h
> @@ -181,10 +181,14 @@ struct kvm_arch_memory_slot {
>  #define KVM_DEV_ARM_VGIC_GRP_CPU_REGS	2
>  #define   KVM_DEV_ARM_VGIC_CPUID_SHIFT	32
>  #define   KVM_DEV_ARM_VGIC_CPUID_MASK	(0xffULL << KVM_DEV_ARM_VGIC_CPUID_SHIFT)
> +#define   KVM_DEV_ARM_VGIC_V3_MPIDR_SHIFT 32
> +#define   KVM_DEV_ARM_VGIC_V3_MPIDR_MASK \
> +			(0xffffffffULL << KVM_DEV_ARM_VGIC_V3_MPIDR_SHIFT)
>  #define   KVM_DEV_ARM_VGIC_OFFSET_SHIFT	0
>  #define   KVM_DEV_ARM_VGIC_OFFSET_MASK	(0xffffffffULL << KVM_DEV_ARM_VGIC_OFFSET_SHIFT)
>  #define KVM_DEV_ARM_VGIC_GRP_NR_IRQS	3
>  #define KVM_DEV_ARM_VGIC_GRP_CTRL       4
> +#define KVM_DEV_ARM_VGIC_GRP_REDIST_REGS 5
>  #define   KVM_DEV_ARM_VGIC_CTRL_INIT    0
>  
>  /* KVM_IRQ_LINE irq field index values */
> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> index 3051f86..56dc08d 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -201,10 +201,14 @@ struct kvm_arch_memory_slot {
>  #define KVM_DEV_ARM_VGIC_GRP_CPU_REGS	2
>  #define   KVM_DEV_ARM_VGIC_CPUID_SHIFT	32
>  #define   KVM_DEV_ARM_VGIC_CPUID_MASK	(0xffULL << KVM_DEV_ARM_VGIC_CPUID_SHIFT)
> +#define   KVM_DEV_ARM_VGIC_V3_MPIDR_SHIFT 32
> +#define   KVM_DEV_ARM_VGIC_V3_MPIDR_MASK \
> +			(0xffffffffULL << KVM_DEV_ARM_VGIC_V3_MPIDR_SHIFT)
>  #define   KVM_DEV_ARM_VGIC_OFFSET_SHIFT	0
>  #define   KVM_DEV_ARM_VGIC_OFFSET_MASK	(0xffffffffULL << KVM_DEV_ARM_VGIC_OFFSET_SHIFT)
>  #define KVM_DEV_ARM_VGIC_GRP_NR_IRQS	3
>  #define KVM_DEV_ARM_VGIC_GRP_CTRL	4
> +#define KVM_DEV_ARM_VGIC_GRP_REDIST_REGS 5
>  #define   KVM_DEV_ARM_VGIC_CTRL_INIT	0
>  
>  /* Device Control API on vcpu fd */
> diff --git a/virt/kvm/arm/vgic/vgic-kvm-device.c b/virt/kvm/arm/vgic/vgic-kvm-device.c
> index fbe87a6..bc7de95 100644
> --- a/virt/kvm/arm/vgic/vgic-kvm-device.c
> +++ b/virt/kvm/arm/vgic/vgic-kvm-device.c
> @@ -235,7 +235,7 @@ struct vgic_reg_attr {
>  	gpa_t addr;
>  };
>  
> -static int parse_vgic_v2_attr(struct kvm_device *dev,
> +static int vgic_v2_parse_attr(struct kvm_device *dev,
>  			      struct kvm_device_attr *attr,
>  			      struct vgic_reg_attr *reg_attr)
>  {
> @@ -292,14 +292,14 @@ static bool lock_all_vcpus(struct kvm *kvm)
>  }
>  
>  /**
> - * vgic_attr_regs_access_v2 - allows user space to access VGIC v2 state
> + * vgic_v2_attr_regs_access - allows user space to access VGIC v2 state
>   *
>   * @dev:      kvm device handle
>   * @attr:     kvm device attribute
>   * @reg:      address the value is read or written
>   * @is_write: true if userspace is writing a register
>   */
> -static int vgic_attr_regs_access_v2(struct kvm_device *dev,
> +static int vgic_v2_attr_regs_access(struct kvm_device *dev,
>  				    struct kvm_device_attr *attr,
>  				    u32 *reg, bool is_write)
>  {
> @@ -308,7 +308,7 @@ static int vgic_attr_regs_access_v2(struct kvm_device *dev,
>  	struct kvm_vcpu *vcpu;
>  	int ret;
>  
> -	ret = parse_vgic_v2_attr(dev, attr, &reg_attr);
> +	ret = vgic_v2_parse_attr(dev, attr, &reg_attr);
>  	if (ret)
>  		return ret;
>  
> @@ -362,7 +362,7 @@ static int vgic_v2_set_attr(struct kvm_device *dev,
>  		if (get_user(reg, uaddr))
>  			return -EFAULT;
>  
> -		return vgic_attr_regs_access_v2(dev, attr, &reg, true);
> +		return vgic_v2_attr_regs_access(dev, attr, &reg, true);
>  	}
>  	}
>  
> @@ -384,7 +384,7 @@ static int vgic_v2_get_attr(struct kvm_device *dev,
>  		u32 __user *uaddr = (u32 __user *)(long)attr->addr;
>  		u32 reg = 0;
>  
> -		ret = vgic_attr_regs_access_v2(dev, attr, &reg, false);
> +		ret = vgic_v2_attr_regs_access(dev, attr, &reg, false);
>  		if (ret)
>  			return ret;
>  		return put_user(reg, uaddr);
> @@ -428,16 +428,141 @@ struct kvm_device_ops kvm_arm_vgic_v2_ops = {
>  	.has_attr = vgic_v2_has_attr,
>  };
>  
> +static int vgic_v3_parse_attr(struct kvm_device *dev,
> +			      struct kvm_device_attr *attr,
> +			      struct vgic_reg_attr *reg_attr)
> +{
> +	unsigned long vgic_mpidr, mpidr_reg;
> +
> +	vgic_mpidr = (attr->attr & KVM_DEV_ARM_VGIC_V3_MPIDR_MASK) >>
> +		      KVM_DEV_ARM_VGIC_V3_MPIDR_SHIFT;
> +
> +	mpidr_reg = VGIC_TO_MPIDR(vgic_mpidr);
> +	reg_attr->vcpu = kvm_mpidr_to_vcpu(dev->kvm, mpidr_reg);
> +	if (!reg_attr->vcpu)
> +		return -EINVAL;
> +
> +	reg_attr->addr = attr->attr & KVM_DEV_ARM_VGIC_OFFSET_MASK;
> +
> +	return 0;
> +}
> +
> +/*
> + * vgic_v3_attr_regs_access - allows user space to access VGIC v3 state
> + *
> + * @dev:      kvm device handle
> + * @attr:     kvm device attribute
> + * @reg:      address the value is read or written
> + * @is_write: true if userspace is writing a register
> + */
> +static int vgic_v3_attr_regs_access(struct kvm_device *dev,
> +				    struct kvm_device_attr *attr,
> +				    u64 *reg, bool is_write)
> +{
> +	struct vgic_reg_attr reg_attr;
> +	gpa_t addr;
> +	struct kvm_vcpu *vcpu;
> +	int ret;
> +	u32 tmp32;
> +
> +	ret = vgic_v3_parse_attr(dev, attr, &reg_attr);
> +	if (ret)
> +		return ret;
> +
> +	vcpu = reg_attr.vcpu;
> +	addr = reg_attr.addr;
> +
> +	mutex_lock(&dev->kvm->lock);
> +
> +	if (unlikely(!vgic_initialized(dev->kvm))) {
> +		ret = -EBUSY;
> +		goto out;
> +	}
> +
> +	if (!lock_all_vcpus(dev->kvm)) {
> +		ret = -EBUSY;
> +		goto out;
> +	}
> +
> +	switch (attr->group) {
> +	case KVM_DEV_ARM_VGIC_GRP_DIST_REGS:
> +		if (is_write)
> +			tmp32 = *reg;
> +
> +		ret = vgic_v3_dist_uaccess(vcpu, is_write, addr, &tmp32);
> +		if (!is_write)
> +			*reg = tmp32;
> +		break;
> +	case KVM_DEV_ARM_VGIC_GRP_REDIST_REGS:
> +		if (is_write)
> +			tmp32 = *reg;
> +
> +		ret = vgic_v3_redist_uaccess(vcpu, is_write, addr, &tmp32);
> +		if (!is_write)
> +			*reg = tmp32;
> +		break;
> +	default:
> +		ret = -EINVAL;
> +		break;
> +	}
> +
> +	unlock_all_vcpus(dev->kvm);
> +out:
> +	mutex_unlock(&dev->kvm->lock);
> +	return ret;
> +}
> +
>  static int vgic_v3_set_attr(struct kvm_device *dev,
>  			    struct kvm_device_attr *attr)
>  {
> -	return vgic_set_common_attr(dev, attr);
> +	int ret;
> +
> +	ret = vgic_set_common_attr(dev, attr);
> +	if (ret != -ENXIO)
> +		return ret;
> +
> +	switch (attr->group) {
> +	case KVM_DEV_ARM_VGIC_GRP_DIST_REGS:
> +	case KVM_DEV_ARM_VGIC_GRP_REDIST_REGS: {
> +		u32 __user *uaddr = (u32 __user *)(long)attr->addr;
> +		u32 tmp32;
> +		u64 reg;
> +
> +		if (get_user(tmp32, uaddr))
> +			return -EFAULT;
> +
> +		reg = tmp32;
> +		return vgic_v3_attr_regs_access(dev, attr, &reg, true);
> +	}
> +	}
> +	return -ENXIO;
>  }
>  
>  static int vgic_v3_get_attr(struct kvm_device *dev,
>  			    struct kvm_device_attr *attr)
>  {
> -	return vgic_get_common_attr(dev, attr);
> +	int ret;
> +
> +	ret = vgic_get_common_attr(dev, attr);
> +	if (ret != -ENXIO)
> +		return ret;
> +
> +	switch (attr->group) {
> +	case KVM_DEV_ARM_VGIC_GRP_DIST_REGS:
> +	case KVM_DEV_ARM_VGIC_GRP_REDIST_REGS: {
> +		u32 __user *uaddr = (u32 __user *)(long)attr->addr;
> +		u64 reg;
> +		u32 tmp32;
> +
> +		ret = vgic_v3_attr_regs_access(dev, attr, &reg, false);
> +		if (ret)
> +			return ret;
> +		tmp32 = reg;
> +		return put_user(tmp32, uaddr);
> +	}
> +	}
> +
> +	return -ENXIO;
>  }
>  
>  static int vgic_v3_has_attr(struct kvm_device *dev,
> @@ -451,6 +576,9 @@ static int vgic_v3_has_attr(struct kvm_device *dev,
>  			return 0;
>  		}
>  		break;
> +	case KVM_DEV_ARM_VGIC_GRP_DIST_REGS:
> +	case KVM_DEV_ARM_VGIC_GRP_REDIST_REGS:
> +		return vgic_v3_has_attr_regs(dev, attr);
>  	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
>  		return 0;
>  	case KVM_DEV_ARM_VGIC_GRP_CTRL:
> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
> index 0b32f40..2cb04b7 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
> +++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
> @@ -368,10 +368,9 @@ unsigned int vgic_v2_init_dist_iodev(struct vgic_io_device *dev)
>  
>  int vgic_v2_has_attr_regs(struct kvm_device *dev, struct kvm_device_attr *attr)
>  {
> -	int nr_irqs = dev->kvm->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS;
>  	const struct vgic_register_region *regions;
>  	gpa_t addr;
> -	int nr_regions, i, len;
> +	int nr_regions;
>  
>  	addr = attr->attr & KVM_DEV_ARM_VGIC_OFFSET_MASK;
>  
> @@ -392,18 +391,7 @@ int vgic_v2_has_attr_regs(struct kvm_device *dev, struct kvm_device_attr *attr)
>  	if (addr & 3)
>  		return -ENXIO;
>  
> -	for (i = 0; i < nr_regions; i++) {
> -		if (regions[i].bits_per_irq)
> -			len = (regions[i].bits_per_irq * nr_irqs) / 8;
> -		else
> -			len = regions[i].len;
> -
> -		if (regions[i].reg_offset <= addr &&
> -		    regions[i].reg_offset + len > addr)
> -			return 0;
> -	}
> -
> -	return -ENXIO;
> +	return vgic_validate_mmio_region_addr(dev, regions, nr_regions, addr);
>  }
>  
>  int vgic_v2_cpuif_uaccess(struct kvm_vcpu *vcpu, bool is_write,
> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
> index 8e76d04..2a7cd62 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
> +++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
> @@ -18,6 +18,8 @@
>  #include <kvm/arm_vgic.h>
>  
>  #include <asm/kvm_emulate.h>
> +#include <asm/kvm_arm.h>
> +#include <asm/kvm_mmu.h>
>  
>  #include "vgic.h"
>  #include "vgic-mmio.h"
> @@ -439,6 +441,9 @@ static void vgic_mmio_write_pendbase(struct kvm_vcpu *vcpu,
>  	REGISTER_DESC_WITH_LENGTH(GICD_CTLR,
>  		vgic_mmio_read_v3_misc, vgic_mmio_write_v3_misc, 16,
>  		VGIC_ACCESS_32bit),
> +	REGISTER_DESC_WITH_LENGTH(GICD_STATUSR,
> +		vgic_mmio_read_rao, vgic_mmio_write_wi, 4,
> +		VGIC_ACCESS_32bit),
>  	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_IGROUPR,
>  		vgic_mmio_read_rao, vgic_mmio_write_wi, NULL, NULL, 1,
>  		VGIC_ACCESS_32bit),
> @@ -486,12 +491,18 @@ static void vgic_mmio_write_pendbase(struct kvm_vcpu *vcpu,
>  	REGISTER_DESC_WITH_LENGTH(GICR_CTLR,
>  		vgic_mmio_read_v3r_ctlr, vgic_mmio_write_v3r_ctlr, 4,
>  		VGIC_ACCESS_32bit),
> +	REGISTER_DESC_WITH_LENGTH(GICR_STATUSR,
> +		vgic_mmio_read_raz, vgic_mmio_write_wi, 4,
> +		VGIC_ACCESS_32bit),
>  	REGISTER_DESC_WITH_LENGTH(GICR_IIDR,
>  		vgic_mmio_read_v3r_iidr, vgic_mmio_write_wi, 4,
>  		VGIC_ACCESS_32bit),
>  	REGISTER_DESC_WITH_LENGTH(GICR_TYPER,
>  		vgic_mmio_read_v3r_typer, vgic_mmio_write_wi, 8,
>  		VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
> +	REGISTER_DESC_WITH_LENGTH(GICR_WAKER,
> +		vgic_mmio_read_raz, vgic_mmio_write_wi, 8,
> +		VGIC_ACCESS_32bit),
>  	REGISTER_DESC_WITH_LENGTH(GICR_PROPBASER,
>  		vgic_mmio_read_propbase, vgic_mmio_write_propbase, 8,
>  		VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
> @@ -612,6 +623,34 @@ int vgic_register_redist_iodevs(struct kvm *kvm, gpa_t redist_base_address)
>  	return ret;
>  }
>  
> +int vgic_v3_has_attr_regs(struct kvm_device *dev, struct kvm_device_attr *attr)
> +{
> +	const struct vgic_register_region *regions;
> +	gpa_t addr;
> +	int nr_regions;
> +
> +	addr = attr->attr & KVM_DEV_ARM_VGIC_OFFSET_MASK;
> +
> +	switch (attr->group) {
> +	case KVM_DEV_ARM_VGIC_GRP_DIST_REGS:
> +		regions = vgic_v3_dist_registers;
> +		nr_regions = ARRAY_SIZE(vgic_v3_dist_registers);
> +		break;
> +	case KVM_DEV_ARM_VGIC_GRP_REDIST_REGS:{
> +		regions = vgic_v3_rdbase_registers;
> +		nr_regions = ARRAY_SIZE(vgic_v3_rdbase_registers);
> +		break;
> +	}
> +	default:
> +		return -ENXIO;
> +	}
> +
> +	/* We only support aligned 32-bit accesses. */
> +	if (addr & 3)
> +		return -ENXIO;
> +
> +	return vgic_validate_mmio_region_addr(dev, regions, nr_regions, addr);
> +}
>  /*
>   * Compare a given affinity (level 1-3 and a level 0 mask, from the SGI
>   * generation register ICC_SGI1R_EL1) with a given VCPU.
> @@ -718,3 +757,36 @@ void vgic_v3_dispatch_sgi(struct kvm_vcpu *vcpu, u64 reg)
>  		vgic_put_irq(vcpu->kvm, irq);
>  	}
>  }
> +
> +int vgic_v3_dist_uaccess(struct kvm_vcpu *vcpu, bool is_write,
> +			 int offset, u32 *val)
> +{
> +	struct vgic_io_device dev = {
> +		.regions = vgic_v3_dist_registers,
> +		.nr_regions = ARRAY_SIZE(vgic_v3_dist_registers),
> +	};
> +
> +	return vgic_uaccess(vcpu, &dev, is_write, offset, val);
> +}
> +
> +int vgic_v3_redist_uaccess(struct kvm_vcpu *vcpu, bool is_write,
> +			   int offset, u32 *val)
> +{
> +	struct vgic_io_device rd_dev = {
> +		.regions = vgic_v3_rdbase_registers,
> +		.nr_regions = ARRAY_SIZE(vgic_v3_rdbase_registers),
> +	};
> +
> +	struct vgic_io_device sgi_dev = {
> +		.regions = vgic_v3_sgibase_registers,
> +		.nr_regions = ARRAY_SIZE(vgic_v3_sgibase_registers),
> +	};
> +
> +	/* SGI_base is the next 64K frame after RD_base */
> +	if (offset >= SZ_64K)
> +		return vgic_uaccess(vcpu, &sgi_dev, is_write,
> +				    offset - SZ_64K, val);
> +	else
> +		return vgic_uaccess(vcpu, &rd_dev, is_write,
> +				    offset, val);
> +}
> diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
> index d5f3ee2..0d1bc98 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio.c
> +++ b/virt/kvm/arm/vgic/vgic-mmio.c
> @@ -394,6 +394,28 @@ static int match_region(const void *key, const void *elt)
>  		       sizeof(region[0]), match_region);
>  }
>  
> +/* Check if address falls within the region */
> +int vgic_validate_mmio_region_addr(struct kvm_device *dev,
> +				   const struct vgic_register_region *regions,
> +				   int nr_regions, gpa_t addr)
> +{
> +	int i, len;
> +	int nr_irqs = dev->kvm->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS;
> +
> +	for (i = 0; i < nr_regions; i++) {
> +		if (regions[i].bits_per_irq)
> +			len = (regions[i].bits_per_irq * nr_irqs) / 8;
> +		else
> +			len = regions[i].len;
> +
> +		if (regions[i].reg_offset <= addr &&
> +		    regions[i].reg_offset + len > addr)
> +			return 0;
> +	}
> +
> +	return -ENXIO;
> +}
> +
>  /*
>   * kvm_mmio_read_buf() returns a value in a format where it can be converted
>   * to a byte array and be directly observed as the guest wanted it to appear
> diff --git a/virt/kvm/arm/vgic/vgic-mmio.h b/virt/kvm/arm/vgic/vgic-mmio.h
> index 7b30296..1cc7faf 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio.h
> +++ b/virt/kvm/arm/vgic/vgic-mmio.h
> @@ -177,6 +177,10 @@ void vgic_mmio_write_config(struct kvm_vcpu *vcpu,
>  int vgic_uaccess(struct kvm_vcpu *vcpu, struct vgic_io_device *dev,
>  		 bool is_write, int offset, u32 *val);
>  
> +int vgic_validate_mmio_region_addr(struct kvm_device *dev,
> +				   const struct vgic_register_region *regions,
> +				   int nr_regions, gpa_t addr);
> +
>  unsigned int vgic_v2_init_dist_iodev(struct vgic_io_device *dev);
>  
>  unsigned int vgic_v3_init_dist_iodev(struct vgic_io_device *dev);
> diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
> index 859f65c..91f58b2 100644
> --- a/virt/kvm/arm/vgic/vgic.h
> +++ b/virt/kvm/arm/vgic/vgic.h
> @@ -30,6 +30,49 @@
>  
>  #define vgic_irq_is_sgi(intid) ((intid) < VGIC_NR_SGIS)
>  
> +#define VGIC_AFFINITY_0_SHIFT 0
> +#define VGIC_AFFINITY_0_MASK (0xffUL << VGIC_AFFINITY_0_SHIFT)
> +#define VGIC_AFFINITY_1_SHIFT 8
> +#define VGIC_AFFINITY_1_MASK (0xffUL << VGIC_AFFINITY_1_SHIFT)
> +#define VGIC_AFFINITY_2_SHIFT 16
> +#define VGIC_AFFINITY_2_MASK (0xffUL << VGIC_AFFINITY_2_SHIFT)
> +#define VGIC_AFFINITY_3_SHIFT 24
> +#define VGIC_AFFINITY_3_MASK (0xffUL << VGIC_AFFINITY_3_SHIFT)
> +
> +#define VGIC_AFFINITY_LEVEL(reg, level) \
> +	((((reg) & VGIC_AFFINITY_## level ##_MASK) \
> +	>> VGIC_AFFINITY_## level ##_SHIFT) << MPIDR_LEVEL_SHIFT(level))
> +
> +/*
> + * The Userspace encodes the affinity differently from the MPIDR,
> + * Below macro converts vgic userspace format to MPIDR reg format.
> + */
> +#define VGIC_TO_MPIDR(val) (VGIC_AFFINITY_LEVEL(val, 0) | \
> +			    VGIC_AFFINITY_LEVEL(val, 1) | \
> +			    VGIC_AFFINITY_LEVEL(val, 2) | \
> +			    VGIC_AFFINITY_LEVEL(val, 3))
> +
> +/*
> + * As per Documentation/virtual/kvm/devices/arm-vgic-v3.txt,
> + * below macros are defined for CPUREG encoding.
> + */
> +#define KVM_REG_ARM_VGIC_SYSREG_OP0_MASK   0x000000000000c000
> +#define KVM_REG_ARM_VGIC_SYSREG_OP0_SHIFT  14
> +#define KVM_REG_ARM_VGIC_SYSREG_OP1_MASK   0x0000000000003800
> +#define KVM_REG_ARM_VGIC_SYSREG_OP1_SHIFT  11
> +#define KVM_REG_ARM_VGIC_SYSREG_CRN_MASK   0x0000000000000780
> +#define KVM_REG_ARM_VGIC_SYSREG_CRN_SHIFT  7
> +#define KVM_REG_ARM_VGIC_SYSREG_CRM_MASK   0x0000000000000078
> +#define KVM_REG_ARM_VGIC_SYSREG_CRM_SHIFT  3
> +#define KVM_REG_ARM_VGIC_SYSREG_OP2_MASK   0x0000000000000007
> +#define KVM_REG_ARM_VGIC_SYSREG_OP2_SHIFT  0
> +
> +#define KVM_DEV_ARM_VGIC_SYSREG_MASK (KVM_REG_ARM_VGIC_SYSREG_OP0_MASK | \
> +				      KVM_REG_ARM_VGIC_SYSREG_OP1_MASK | \
> +				      KVM_REG_ARM_VGIC_SYSREG_CRN_MASK | \
> +				      KVM_REG_ARM_VGIC_SYSREG_CRM_MASK | \
> +				      KVM_REG_ARM_VGIC_SYSREG_OP2_MASK)
> +
>  struct vgic_vmcr {
>  	u32	ctlr;
>  	u32	abpr;
> @@ -89,7 +132,11 @@ static inline void vgic_get_irq_kref(struct vgic_irq *irq)
>  int kvm_vgic_register_its_device(void);
>  void vgic_enable_lpis(struct kvm_vcpu *vcpu);
>  int vgic_its_inject_msi(struct kvm *kvm, struct kvm_msi *msi);
> -
> +int vgic_v3_has_attr_regs(struct kvm_device *dev, struct kvm_device_attr *attr);
> +int vgic_v3_dist_uaccess(struct kvm_vcpu *vcpu, bool is_write,
> +			 int offset, u32 *val);
> +int vgic_v3_redist_uaccess(struct kvm_vcpu *vcpu, bool is_write,
> +			 int offset, u32 *val);
>  int kvm_register_vgic_device(unsigned long type);
>  int vgic_lazy_init(struct kvm *kvm);
>  int vgic_init(struct kvm *kvm);
> -- 
> 1.9.1
> 

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
