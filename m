From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [RFC PATCH v3 2/5] arm/arm64: vgic-new: Add distributor and
 redistributor access
Date: Tue, 30 Aug 2016 14:31:26 +0200
Message-ID: <20160830123126.GH10162@cbox>
References: <1472037609-4164-1-git-send-email-vijay.kilari@gmail.com>
 <1472037609-4164-3-git-send-email-vijay.kilari@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B238340F90
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Aug 2016 08:21:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4cL+1joAWrRe for <kvmarm@lists.cs.columbia.edu>;
 Tue, 30 Aug 2016 08:21:04 -0400 (EDT)
Received: from mail-wm0-f50.google.com (mail-wm0-f50.google.com [74.125.82.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4633140B58
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Aug 2016 08:21:03 -0400 (EDT)
Received: by mail-wm0-f50.google.com with SMTP id q128so118659739wma.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Aug 2016 05:29:09 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1472037609-4164-3-git-send-email-vijay.kilari@gmail.com>
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

On Wed, Aug 24, 2016 at 04:50:06PM +0530, vijay.kilari@gmail.com wrote:
> From: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
> 
> VGICv3 Distributor and Redistributor registers are accessed using
> KVM_DEV_ARM_VGIC_GRP_DIST_REGS and KVM_DEV_ARM_VGIC_GRP_DIST_REGS
> with KVM_SET_DEVICE_ATTR and KVM_GET_DEVICE_ATTR ioctls.
> These registers are accessed as 32-bit and cpu mpidr
> value passed along with register offset is used to identify the
> cpu for redistributor registers access.
> 
> The version of VGIC v3 specification is define here
> http://lists.infradead.org/pipermail/linux-arm-kernel/2016-July/445611.html
> 
> Signed-off-by: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
> ---
>  arch/arm64/include/uapi/asm/kvm.h   |   3 +
>  virt/kvm/arm/vgic/vgic-kvm-device.c | 127 +++++++++++++++++++++++++++++++++++-
>  virt/kvm/arm/vgic/vgic-mmio-v3.c    | 113 ++++++++++++++++++++++++++++++++
>  virt/kvm/arm/vgic/vgic-mmio.c       |   2 +-
>  virt/kvm/arm/vgic/vgic.h            |   8 +++
>  5 files changed, 250 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> index 3051f86..94ea676 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -201,10 +201,13 @@ struct kvm_arch_memory_slot {
>  #define KVM_DEV_ARM_VGIC_GRP_CPU_REGS	2
>  #define   KVM_DEV_ARM_VGIC_CPUID_SHIFT	32
>  #define   KVM_DEV_ARM_VGIC_CPUID_MASK	(0xffULL << KVM_DEV_ARM_VGIC_CPUID_SHIFT)
> +#define   KVM_DEV_ARM_VGIC_V3_CPUID_MASK \
> +				(0xffffffffULL << KVM_DEV_ARM_VGIC_CPUID_SHIFT)

I think this should be KVM_DEV_ARM_VGIC_V3_MPIDR_MASK, and I would
probably define a V3 of the shift as well, since we're really talking
about two distinct APIs here.

>  #define   KVM_DEV_ARM_VGIC_OFFSET_SHIFT	0
>  #define   KVM_DEV_ARM_VGIC_OFFSET_MASK	(0xffffffffULL << KVM_DEV_ARM_VGIC_OFFSET_SHIFT)
>  #define KVM_DEV_ARM_VGIC_GRP_NR_IRQS	3
>  #define KVM_DEV_ARM_VGIC_GRP_CTRL	4
> +#define KVM_DEV_ARM_VGIC_GRP_REDIST_REGS 5
>  #define   KVM_DEV_ARM_VGIC_CTRL_INIT	0
>  
>  /* Device Control API on vcpu fd */
> diff --git a/virt/kvm/arm/vgic/vgic-kvm-device.c b/virt/kvm/arm/vgic/vgic-kvm-device.c
> index 163b057..06f0158 100644
> --- a/virt/kvm/arm/vgic/vgic-kvm-device.c
> +++ b/virt/kvm/arm/vgic/vgic-kvm-device.c
> @@ -433,16 +433,136 @@ struct kvm_device_ops kvm_arm_vgic_v2_ops = {
>  
>  #ifdef CONFIG_KVM_ARM_VGIC_V3
>  
> +static int parse_vgic_v3_attr(struct kvm_device *dev,
> +			      struct kvm_device_attr *attr,
> +			      struct vgic_reg_attr *reg_attr)
> +{
> +	int cpuid;
> +
> +	cpuid = (attr->attr & KVM_DEV_ARM_VGIC_V3_CPUID_MASK) >>
> +		 KVM_DEV_ARM_VGIC_CPUID_SHIFT;
> +
> +	if (cpuid >= atomic_read(&dev->kvm->online_vcpus))
> +		return -EINVAL;

huh?  it's an MPIDR, not a cpu id.

just resolve it with kvm_mpidr_to_vcpu and check its return value.


> +
> +	reg_attr->vcpu = kvm_mpidr_to_vcpu(dev->kvm, cpuid);

please check the return value of this function in any case...

> +	reg_attr->addr = attr->attr & KVM_DEV_ARM_VGIC_OFFSET_MASK;
> +
> +	return 0;
> +}
> +
> +/**
> + * vgic_attr_regs_access_v3 - allows user space to access VGIC v3 state
> + *
> + * @dev:      kvm device handle
> + * @attr:     kvm device attribute
> + * @reg:      address the value is read or written
> + * @is_write: true if userspace is writing a register
> + */
> +static int vgic_attr_regs_access_v3(struct kvm_device *dev,
> +				    struct kvm_device_attr *attr,
> +				    u64 *reg, bool is_write)
> +{
> +	struct vgic_reg_attr reg_attr;
> +	gpa_t addr;
> +	struct kvm_vcpu *vcpu;
> +	int ret;
> +	u32 tmp32;
> +
> +	ret = parse_vgic_v3_attr(dev, attr, &reg_attr);
> +	if (ret)
> +		return ret;
> +
> +	vcpu = reg_attr.vcpu;
> +	addr = reg_attr.addr;
> +
> +	mutex_lock(&dev->kvm->lock);
> +
> +	ret = vgic_init(dev->kvm);
> +	if (ret)
> +		goto out;

no, no, please no more auto-init at userspace access time.  This code
should instead check vgic_initialized() and return an error to userspace
if not initialized.


> +
> +	if (!lock_all_vcpus(dev->kvm)) {
> +		ret = -EBUSY;
> +		goto out;
> +	}
> +
> +	switch (attr->group) {
> +	case KVM_DEV_ARM_VGIC_GRP_DIST_REGS:
> +		tmp32 = *reg;

why is this assignment not predicated on if (is_write) ?

also, all this type conversion nonsense is probably unnecessary, see my
comment below.

> +		ret = vgic_v3_dist_uaccess(vcpu, is_write, addr, &tmp32);
> +		if (!is_write)
> +			*reg = tmp32;
> +		break;
> +	case KVM_DEV_ARM_VGIC_GRP_REDIST_REGS:
> +		tmp32 = *reg;
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
> +		return vgic_attr_regs_access_v3(dev, attr, &reg, true);

oh, but wait, you already had a 32-bit value, which you convert into a
64-bit value, just to convert it back again, to do some extra data
copies?

I'm really confused as to why this has to be so complicated.

Why not simply use u32 all the way?

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
> +		ret = vgic_attr_regs_access_v3(dev, attr, &reg, false);
> +		if (ret)
> +			return ret;
> +		tmp32 = reg;
> +		ret = put_user(tmp32, uaddr);

same, type stuff.

> +		return ret;
> +	}
> +	}
> +
> +	return -ENXIO;
>  }
>  
>  static int vgic_v3_has_attr(struct kvm_device *dev,
> @@ -456,6 +576,9 @@ static int vgic_v3_has_attr(struct kvm_device *dev,
>  			return 0;
>  		}
>  		break;
> +	case KVM_DEV_ARM_VGIC_GRP_DIST_REGS:
> +	case KVM_DEV_ARM_VGIC_GRP_REDIST_REGS:
> +		return vgic_v3_has_attr_regs(dev, attr);
>  	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
>  		return 0;
>  	case KVM_DEV_ARM_VGIC_GRP_CTRL:
> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
> index dd0d602..c2df103 100644
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
> @@ -391,6 +393,9 @@ static const struct vgic_register_region vgic_v3_dist_registers[] = {
>  	REGISTER_DESC_WITH_LENGTH(GICD_CTLR,
>  		vgic_mmio_read_v3_misc, vgic_mmio_write_v3_misc, 16,
>  		VGIC_ACCESS_32bit),
> +	REGISTER_DESC_WITH_LENGTH(GICD_STATUSR,
> +		vgic_mmio_read_rao, vgic_mmio_write_wi, 4,
> +		VGIC_ACCESS_32bit),
>  	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_IGROUPR,
>  		vgic_mmio_read_rao, vgic_mmio_write_wi, 1,
>  		VGIC_ACCESS_32bit),
> @@ -438,12 +443,18 @@ static const struct vgic_register_region vgic_v3_rdbase_registers[] = {
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
> @@ -564,6 +575,46 @@ int vgic_register_redist_iodevs(struct kvm *kvm, gpa_t redist_base_address)
>  	return ret;
>  }
>  
> +int vgic_v3_has_attr_regs(struct kvm_device *dev, struct kvm_device_attr *attr)
> +{
> +	struct kvm_vcpu *vcpu;
> +	int nr_irqs = dev->kvm->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS;
> +	const struct vgic_register_region *regions;
> +	gpa_t addr;
> +	int nr_regions, i, len, cpuid;
> +
> +	addr = attr->attr & KVM_DEV_ARM_VGIC_OFFSET_MASK;
> +	cpuid = (attr->attr & KVM_DEV_ARM_VGIC_V3_CPUID_MASK) >>
> +		 KVM_DEV_ARM_VGIC_CPUID_SHIFT;
> +	vcpu = kvm_mpidr_to_vcpu(dev->kvm, cpuid);

why do you need the vcpu variable?
(also, you don't check the return value)

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

why don't you need an address alignment check here?

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

this is directly lifted from v2, definitely this loop or the whole
function can be shared between v2/v3 somehow.

> +
> +	return -ENXIO;
> +}
>  /*
>   * Compare a given affinity (level 1-3 and a level 0 mask, from the SGI
>   * generation register ICC_SGI1R_EL1) with a given VCPU.
> @@ -670,3 +721,65 @@ void vgic_v3_dispatch_sgi(struct kvm_vcpu *vcpu, u64 reg)
>  		vgic_put_irq(vcpu->kvm, irq);
>  	}
>  }
> +
> +/*
> + * When userland tries to access the VGIC register handlers, we need to
> + * create a usable struct vgic_io_device to be passed to the handlers and we
> + * have to set up a buffer similar to what would have happened if a guest MMIO
> + * access occurred, including doing endian conversions on BE systems.
> + */
> +static int vgic_v3_uaccess(struct kvm_vcpu *vcpu, struct vgic_io_device *dev,
> +			   bool is_write, int offset, u32 *val)
> +{
> +	unsigned int len = 4;
> +	u8 buf[4];
> +	int ret;
> +
> +	if (is_write) {
> +		vgic_data_host_to_mmio_bus(buf, len, *val);
> +		ret = vgic_mmio_uaccess_write(vcpu, &dev->dev, offset,
> +					      len, buf);
> +	} else {
> +		ret = vgic_mmio_uaccess_read(vcpu, &dev->dev, offset, len, buf);
> +		if (!ret)
> +			*val = vgic_data_mmio_bus_to_host(buf, len);
> +	}
> +
> +	return ret;
> +}

this as well seems to be completely identical to the v2 version, or am I
missing something?

> +
> +int vgic_v3_dist_uaccess(struct kvm_vcpu *vcpu, bool is_write,
> +			 int offset, u32 *val)
> +{
> +	struct vgic_io_device dev = {
> +		.regions = vgic_v3_dist_registers,
> +		.nr_regions = ARRAY_SIZE(vgic_v3_dist_registers),
> +	};
> +
> +	return vgic_v3_uaccess(vcpu, &dev, is_write, offset, val);
> +}
> +
> +int vgic_v3_redist_uaccess(struct kvm_vcpu *vcpu, bool is_write,
> +			   int offset, u32 *val)
> +{
> +	struct vgic_io_device *dev;
> +	const struct vgic_register_region *region;
> +
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

The whole bit following here deserves a comment.

I'm guessing the idea is to check if the offset falls into the sgi_dev
or rd_dev region?

Why not simply do:

	/* SGI_base is the next 64K frame after RD_base */
	if (offset >= SZ_64K)
		return vgic_v3_uaccess(vcpu, &sgi_dev, is_write,
				       offset - SZ_64K, val);
	else
		return vgic_v3_uaccess(vcpu, &rd_dev, is_write, offset, val);



> +	dev = &sgi_dev;
> +	region = vgic_find_mmio_region(dev->regions, dev->nr_regions,
> +				       offset - dev->base_addr);

In any case, this doesn't look right: dev->base_addr is not set?

> +	if (region == NULL)

If you must, then do: if (!region)

> +		dev = &rd_dev;
> +
> +	return vgic_v3_uaccess(vcpu, dev, is_write, offset, val);
> +}
> diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
> index dcf5d25..38f2c75 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio.c
> +++ b/virt/kvm/arm/vgic/vgic-mmio.c
> @@ -406,7 +406,7 @@ static int match_region(const void *key, const void *elt)
>  }
>  
>  /* Find the proper register handler entry given a certain address offset. */
> -static const struct vgic_register_region *
> +const struct vgic_register_region *
>  vgic_find_mmio_region(const struct vgic_register_region *region, int nr_regions,
>  		      unsigned int offset)
>  {
> diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
> index 1d8e21d..14e4ce5 100644
> --- a/virt/kvm/arm/vgic/vgic.h
> +++ b/virt/kvm/arm/vgic/vgic.h
> @@ -72,6 +72,9 @@ static inline void vgic_get_irq_kref(struct vgic_irq *irq)
>  	kref_get(&irq->refcount);
>  }
>  
> +const struct vgic_register_region *
> +	vgic_find_mmio_region(const struct vgic_register_region *region,
> +			      int nr_regions, unsigned int offset);
>  #ifdef CONFIG_KVM_ARM_VGIC_V3
>  void vgic_v3_process_maintenance(struct kvm_vcpu *vcpu);
>  void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu);
> @@ -88,6 +91,11 @@ bool vgic_has_its(struct kvm *kvm);
>  int kvm_vgic_register_its_device(void);
>  void vgic_enable_lpis(struct kvm_vcpu *vcpu);
>  int vgic_its_inject_msi(struct kvm *kvm, struct kvm_msi *msi);
> +int vgic_v3_has_attr_regs(struct kvm_device *dev, struct kvm_device_attr *attr);
> +int vgic_v3_dist_uaccess(struct kvm_vcpu *vcpu, bool is_write,
> +			 int offset, u32 *val);
> +int vgic_v3_redist_uaccess(struct kvm_vcpu *vcpu, bool is_write,
> +			 int offset, u32 *val);
>  #else
>  static inline void vgic_v3_process_maintenance(struct kvm_vcpu *vcpu)
>  {
> -- 
> 1.9.1
> 
