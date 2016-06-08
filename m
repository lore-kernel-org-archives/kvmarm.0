From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v5 07/13] KVM: arm64: introduce new KVM ITS device
Date: Wed, 8 Jun 2016 13:32:15 +0100
Message-ID: <5758104F.6020804@arm.com>
References: <1464962572-3925-1-git-send-email-andre.przywara@arm.com>
 <1464962572-3925-8-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1464962572-3925-8-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: Eric Auger <eric.auger@redhat.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 03/06/16 15:02, Andre Przywara wrote:
> Introduce a new KVM device that represents an ARM Interrupt Translation
> Service (ITS) controller. Since there can be multiple of this per guest,
> we can't piggy back on the existing GICv3 distributor device, but create
> a new type of KVM device.
> On the KVM_CREATE_DEVICE ioctl we initialize the ITS data structure and
> add this ITS to a linked list. Userland is expected to set the frame
> address using an ioctl during the VM initialization process, this will
> be used to pick the right ITS for a particular device or MMIO access.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  Documentation/virtual/kvm/devices/arm-vgic.txt |  23 ++++-
>  arch/arm/include/asm/kvm_host.h                |   3 +
>  arch/arm/kvm/arm.c                             |   3 +
>  arch/arm64/include/asm/kvm_host.h              |   2 +
>  arch/arm64/include/uapi/asm/kvm.h              |   2 +
>  include/kvm/vgic/vgic.h                        |   2 +
>  include/uapi/linux/kvm.h                       |   2 +
>  virt/kvm/arm/vgic/vgic-init.c                  |  13 +++
>  virt/kvm/arm/vgic/vgic-its.c                   | 121 +++++++++++++++++++++++++
>  virt/kvm/arm/vgic/vgic-kvm-device.c            |   7 +-
>  virt/kvm/arm/vgic/vgic-mmio-v3.c               |   2 +-
>  virt/kvm/arm/vgic/vgic.h                       |   9 ++
>  12 files changed, 182 insertions(+), 7 deletions(-)
> 
> diff --git a/Documentation/virtual/kvm/devices/arm-vgic.txt b/Documentation/virtual/kvm/devices/arm-vgic.txt
> index 59541d4..d263fffd 100644
> --- a/Documentation/virtual/kvm/devices/arm-vgic.txt
> +++ b/Documentation/virtual/kvm/devices/arm-vgic.txt
> @@ -4,16 +4,22 @@ ARM Virtual Generic Interrupt Controller (VGIC)
>  Device types supported:
>    KVM_DEV_TYPE_ARM_VGIC_V2     ARM Generic Interrupt Controller v2.0
>    KVM_DEV_TYPE_ARM_VGIC_V3     ARM Generic Interrupt Controller v3.0
> +  KVM_DEV_TYPE_ARM_VGIC_ITS    ARM Interrupt Translation Service Controller
>  
> -Only one VGIC instance may be instantiated through either this API or the
> -legacy KVM_CREATE_IRQCHIP api.  The created VGIC will act as the VM interrupt
> -controller, requiring emulated user-space devices to inject interrupts to the
> -VGIC instead of directly to CPUs.
> +Only one VGIC instance of the V2/V3 types above may be instantiated through
> +either this API or the legacy KVM_CREATE_IRQCHIP api.  The created VGIC will
> +act as the VM interrupt controller, requiring emulated user-space devices to
> +inject interrupts to the VGIC instead of directly to CPUs.
>  
>  Creating a guest GICv3 device requires a host GICv3 as well.
>  GICv3 implementations with hardware compatibility support allow a guest GICv2
>  as well.
>  
> +Creating a virtual ITS controller requires a host GICv3 (but does not depend
> +on having physical ITS controllers).
> +There can be multiple ITS controllers per guest, each of them has to have
> +a separate, non-overlapping MMIO region.
> +
>  Groups:
>    KVM_DEV_ARM_VGIC_GRP_ADDR
>    Attributes:
> @@ -39,6 +45,15 @@ Groups:
>        Only valid for KVM_DEV_TYPE_ARM_VGIC_V3.
>        This address needs to be 64K aligned.
>  
> +    KVM_VGIC_V3_ADDR_TYPE_ITS (rw, 64-bit)
> +      Base address in the guest physical address space of the GICv3 ITS
> +      control register frame. The ITS allows MSI(-X) interrupts to be
> +      injected into guests. This extension is optional. If the kernel
> +      does not support the ITS, the call returns -ENODEV.
> +      This address region is solely for the guest to access the ITS control
> +      registers and does not cover the ITS translation register.
> +      Only valid for KVM_DEV_TYPE_ARM_VGIC_ITS.
> +      This address needs to be 64K aligned and the region covers 64K.
>  
>    KVM_DEV_ARM_VGIC_GRP_DIST_REGS
>    Attributes:
> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
> index 3c40facd..917a330 100644
> --- a/arch/arm/include/asm/kvm_host.h
> +++ b/arch/arm/include/asm/kvm_host.h
> @@ -69,6 +69,9 @@ struct kvm_arch {
>  
>  	/* Interrupt controller */
>  	struct vgic_dist	vgic;
> +	/* List of virtual ITS MSI controllers */
> +	struct list_head	vits_list;

32bit ARM does not have an ITS, as it doesn't have GICv3 either. Why do
we have to have this? Also, you could perfectly move the list into the
vgic_dist structure (and rename vgic_dist to something else if that's
too ugly).

> +
>  	int max_vcpus;
>  };
>  
> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
> index a268c85..bfe1af2 100644
> --- a/arch/arm/kvm/arm.c
> +++ b/arch/arm/kvm/arm.c
> @@ -20,6 +20,7 @@
>  #include <linux/errno.h>
>  #include <linux/err.h>
>  #include <linux/kvm_host.h>
> +#include <linux/list.h>
>  #include <linux/module.h>
>  #include <linux/vmalloc.h>
>  #include <linux/fs.h>
> @@ -126,7 +127,9 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>  	if (ret)
>  		goto out_free_stage2_pgd;
>  
> +	INIT_LIST_HEAD(&kvm->arch.vits_list);

Why can't that be moved to kvm_vgic_early_init? And does it actually
need to be done that early?

>  	kvm_vgic_early_init(kvm);
> +

Spurious whitespace.

>  	kvm_timer_init(kvm);
>  
>  	/* Mark the initial VMID generation invalid */
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index ebe8904..b4b1814 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -68,6 +68,8 @@ struct kvm_arch {
>  
>  	/* Interrupt controller */
>  	struct vgic_dist	vgic;
> +	/* List of virtual ITS MSI controllers */
> +	struct list_head	vits_list;
>  
>  	/* Timer */
>  	struct arch_timer_kvm	timer;
> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> index f209ea1..f8c257b 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -87,9 +87,11 @@ struct kvm_regs {
>  /* Supported VGICv3 address types  */
>  #define KVM_VGIC_V3_ADDR_TYPE_DIST	2
>  #define KVM_VGIC_V3_ADDR_TYPE_REDIST	3
> +#define KVM_VGIC_ITS_ADDR_TYPE		4
>  
>  #define KVM_VGIC_V3_DIST_SIZE		SZ_64K
>  #define KVM_VGIC_V3_REDIST_SIZE		(2 * SZ_64K)
> +#define KVM_VGIC_V3_ITS_SIZE		SZ_64K
>  
>  #define KVM_ARM_VCPU_POWER_OFF		0 /* CPU is started in OFF state */
>  #define KVM_ARM_VCPU_EL1_32BIT		1 /* CPU running a 32bit VM */
> diff --git a/include/kvm/vgic/vgic.h b/include/kvm/vgic/vgic.h
> index 6a7f5e4..8cf8018f 100644
> --- a/include/kvm/vgic/vgic.h
> +++ b/include/kvm/vgic/vgic.h
> @@ -117,6 +117,8 @@ struct vgic_io_device {
>  };
>  
>  struct vgic_its {
> +	struct list_head	its_list;

Consider renaming this to "entry", or something else that doesn't feel
like it is a list on its own.

> +
>  	/* The base address of the ITS control register frame */
>  	gpa_t			vgic_its_base;
>  
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 7de96f5..d8c4c32 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1077,6 +1077,8 @@ enum kvm_device_type {
>  #define KVM_DEV_TYPE_FLIC		KVM_DEV_TYPE_FLIC
>  	KVM_DEV_TYPE_ARM_VGIC_V3,
>  #define KVM_DEV_TYPE_ARM_VGIC_V3	KVM_DEV_TYPE_ARM_VGIC_V3
> +	KVM_DEV_TYPE_ARM_VGIC_ITS,
> +#define KVM_DEV_TYPE_ARM_VGIC_ITS	KVM_DEV_TYPE_ARM_VGIC_ITS
>  	KVM_DEV_TYPE_MAX,
>  };
>  
> diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
> index 90cae48..adf3c1d 100644
> --- a/virt/kvm/arm/vgic/vgic-init.c
> +++ b/virt/kvm/arm/vgic/vgic-init.c
> @@ -239,6 +239,7 @@ static void kvm_vgic_vcpu_init(struct kvm_vcpu *vcpu)
>  int vgic_init(struct kvm *kvm)
>  {
>  	struct vgic_dist *dist = &kvm->arch.vgic;
> +	struct vgic_its *its;
>  	struct kvm_vcpu *vcpu;
>  	int ret = 0, i;
>  
> @@ -253,6 +254,12 @@ int vgic_init(struct kvm *kvm)
>  	if (ret)
>  		goto out;
>  
> +	list_for_each_entry(its, &kvm->arch.vits_list, its_list) {
> +		ret = vits_init(kvm, its);
> +		if (ret)
> +			goto out;
> +	}
> +
>  	kvm_for_each_vcpu(i, vcpu, kvm)
>  		kvm_vgic_vcpu_init(vcpu);
>  
> @@ -286,10 +293,16 @@ void kvm_vgic_vcpu_destroy(struct kvm_vcpu *vcpu)
>  void kvm_vgic_destroy(struct kvm *kvm)
>  {
>  	struct kvm_vcpu *vcpu;
> +	struct vgic_its *its, *next;
>  	int i;
>  
>  	kvm_vgic_dist_destroy(kvm);
>  
> +	list_for_each_entry_safe(its, next, &kvm->arch.vits_list, its_list) {
> +		vits_destroy(kvm, its);
> +		kfree(its);
> +	}
> +
>  	kvm_for_each_vcpu(i, vcpu, kvm)
>  		kvm_vgic_vcpu_destroy(vcpu);
>  }
> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> index 61f3b8e..61f550d 100644
> --- a/virt/kvm/arm/vgic/vgic-its.c
> +++ b/virt/kvm/arm/vgic/vgic-its.c
> @@ -21,6 +21,7 @@
>  #include <linux/kvm.h>
>  #include <linux/kvm_host.h>
>  #include <linux/interrupt.h>
> +#include <linux/uaccess.h>
>  
>  #include <linux/irqchip/arm-gic-v3.h>
>  
> @@ -82,3 +83,123 @@ void vits_destroy(struct kvm *kvm, struct vgic_its *its)
>  
>  	its->enabled = false;
>  }
> +
> +static int vgic_its_create(struct kvm_device *dev, u32 type)
> +{
> +	struct vgic_its *its;
> +
> +	if (type != KVM_DEV_TYPE_ARM_VGIC_ITS)
> +		return -ENODEV;
> +
> +	its = kzalloc(sizeof(struct vgic_its), GFP_KERNEL);
> +	if (!its)
> +		return -ENOMEM;
> +
> +	spin_lock_init(&its->lock);
> +
> +	its->vgic_its_base = VGIC_ADDR_UNDEF;
> +
> +	its->enabled = false;
> +
> +	dev->private = its;
> +
> +	list_add_tail(&its->its_list, &dev->kvm->arch.vits_list);

Where is the lock that protects the list when you perform the insertion?

> +
> +	return 0;
> +}
> +
> +static void vgic_its_destroy(struct kvm_device *dev)
> +{
> +	struct vgic_its *its = dev->private;
> +
> +	list_del(&its->its_list);
> +
> +	vits_destroy(dev->kvm, its);
> +
> +	kfree(its);
> +}
> +
> +static int vgic_its_has_attr(struct kvm_device *dev,
> +			     struct kvm_device_attr *attr)
> +{
> +	switch (attr->group) {
> +	case KVM_DEV_ARM_VGIC_GRP_ADDR:
> +		switch (attr->attr) {
> +		case KVM_VGIC_ITS_ADDR_TYPE:
> +			return 0;
> +		}
> +		break;
> +	}
> +	return -ENXIO;
> +}
> +
> +static int vgic_its_set_attr(struct kvm_device *dev,
> +			     struct kvm_device_attr *attr)
> +{
> +	int ret;
> +
> +	switch (attr->group) {
> +	case KVM_DEV_ARM_VGIC_GRP_ADDR: {
> +		struct vgic_its *its = dev->private;
> +		u64 __user *uaddr = (u64 __user *)(long)attr->addr;
> +		unsigned long type = (unsigned long)attr->attr;
> +		u64 addr;
> +
> +		if (type != KVM_VGIC_ITS_ADDR_TYPE)
> +			return -ENODEV;
> +
> +		if (copy_from_user(&addr, uaddr, sizeof(addr)))
> +			return -EFAULT;
> +
> +		ret = vgic_check_ioaddr(dev->kvm, &its->vgic_its_base,
> +					addr, SZ_64K);
> +		if (ret)
> +			return ret;
> +
> +		its->vgic_its_base = addr;
> +
> +		return 0;
> +	}
> +	}
> +
> +	return -ENXIO;
> +}
> +
> +static int vgic_its_get_attr(struct kvm_device *dev,
> +			     struct kvm_device_attr *attr)
> +{
> +	switch (attr->group) {
> +	case KVM_DEV_ARM_VGIC_GRP_ADDR: {
> +		struct vgic_its *its = dev->private;
> +		u64 addr = its->vgic_its_base;
> +		u64 __user *uaddr = (u64 __user *)(long)attr->addr;
> +		unsigned long type = (unsigned long)attr->attr;
> +
> +		if (type != KVM_VGIC_ITS_ADDR_TYPE)
> +			return -ENODEV;
> +
> +		if (copy_to_user(uaddr, &addr, sizeof(addr)))
> +			return -EFAULT;
> +		break;
> +	default:
> +		return -ENXIO;
> +	}
> +	}
> +
> +	return 0;
> +}
> +
> +struct kvm_device_ops kvm_arm_vgic_its_ops = {

Why isn't this static?

> +	.name = "kvm-arm-vgic-its",
> +	.create = vgic_its_create,
> +	.destroy = vgic_its_destroy,
> +	.set_attr = vgic_its_set_attr,
> +	.get_attr = vgic_its_get_attr,
> +	.has_attr = vgic_its_has_attr,
> +};
> +
> +int kvm_vgic_register_its_device(void)
> +{
> +	return kvm_register_device_ops(&kvm_arm_vgic_its_ops,
> +				       KVM_DEV_TYPE_ARM_VGIC_ITS);
> +}
> diff --git a/virt/kvm/arm/vgic/vgic-kvm-device.c b/virt/kvm/arm/vgic/vgic-kvm-device.c
> index 2f24f13..1813f93 100644
> --- a/virt/kvm/arm/vgic/vgic-kvm-device.c
> +++ b/virt/kvm/arm/vgic/vgic-kvm-device.c
> @@ -21,8 +21,8 @@
>  
>  /* common helpers */
>  
> -static int vgic_check_ioaddr(struct kvm *kvm, phys_addr_t *ioaddr,
> -			     phys_addr_t addr, phys_addr_t alignment)
> +int vgic_check_ioaddr(struct kvm *kvm, phys_addr_t *ioaddr,
> +		      phys_addr_t addr, phys_addr_t alignment)
>  {
>  	if (addr & ~KVM_PHYS_MASK)
>  		return -E2BIG;
> @@ -223,6 +223,9 @@ int kvm_register_vgic_device(unsigned long type)
>  	case KVM_DEV_TYPE_ARM_VGIC_V3:
>  		ret = kvm_register_device_ops(&kvm_arm_vgic_v3_ops,
>  					      KVM_DEV_TYPE_ARM_VGIC_V3);
> +		if (ret)
> +			break;
> +		ret = kvm_vgic_register_its_device();

You're mixing two init style here. One that uses kvm_register_device_ops
directly, and one that uses a helper. Please choose one way or the
other, but keep the init sequence uniform.

>  		break;
>  #endif
>  	}
> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
> index 2eb9f0e..d3511d6 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
> +++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
> @@ -46,7 +46,7 @@ bool vgic_has_its(struct kvm *kvm)
>  	if (dist->vgic_model != KVM_DEV_TYPE_ARM_VGIC_V3)
>  		return false;
>  
> -	return false;
> +	return !list_empty(&kvm->arch.vits_list);
>  }
>  
>  static unsigned long vgic_mmio_read_v3_misc(struct kvm_vcpu *vcpu,
> diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
> index 0baad03..66578d2 100644
> --- a/virt/kvm/arm/vgic/vgic.h
> +++ b/virt/kvm/arm/vgic/vgic.h
> @@ -41,6 +41,9 @@ struct vgic_irq *vgic_get_irq(struct kvm *kvm, struct kvm_vcpu *vcpu,
>  bool vgic_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq);
>  void vgic_kick_vcpus(struct kvm *kvm);
>  
> +int vgic_check_ioaddr(struct kvm *kvm, phys_addr_t *ioaddr,
> +		      phys_addr_t addr, phys_addr_t alignment);
> +
>  void vgic_v2_process_maintenance(struct kvm_vcpu *vcpu);
>  void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu);
>  void vgic_v2_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr);
> @@ -74,6 +77,7 @@ int vgic_register_redist_iodevs(struct kvm *kvm, gpa_t dist_base_address);
>  bool vgic_has_its(struct kvm *kvm);
>  int vits_init(struct kvm *kvm, struct vgic_its *its);
>  void vits_destroy(struct kvm *kvm, struct vgic_its *its);
> +int kvm_vgic_register_its_device(void);
>  #else
>  static inline void vgic_v3_process_maintenance(struct kvm_vcpu *vcpu)
>  {
> @@ -139,6 +143,11 @@ static int vits_init(struct kvm *kvm, struct vgic_its *its)
>  static inline void vits_destroy(struct kvm *kvm, struct vgic_its *its)
>  {
>  }
> +
> +static int kvm_vgic_register_its_device(void)
> +{
> +	return -ENODEV;
> +}
>  #endif
>  
>  int kvm_register_vgic_device(unsigned long type);
> 

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
