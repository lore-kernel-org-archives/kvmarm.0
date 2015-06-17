From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3 09/10] arm: add support for supplying GICv3 redistributor
 addresses
Date: Wed, 17 Jun 2015 14:09:51 +0100
Message-ID: <5581719F.6090405@arm.com>
References: <1434540121-21283-1-git-send-email-andre.przywara@arm.com> <1434540121-21283-10-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1434540121-21283-10-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>, Will Deacon <Will.Deacon@arm.com>
Cc: "penberg@kernel.org" <penberg@kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 17/06/15 12:22, Andre Przywara wrote:
> Instead of the GIC virtual CPU interface an emulated GICv3 needs to
> have accesses to its emulated redistributors trapped in the guest.
> Add code to tell the kernel about the mapping if a GICv3 emulation was
> requested by the user.
> 
> This contains some defines which are not (yet) in the (32 bit) header
> files to allow compilation for ARM.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  arm/gic.c                         | 36 +++++++++++++++++++++++++++++++++++-
>  arm/include/arm-common/gic.h      |  3 ++-
>  arm/include/arm-common/kvm-arch.h |  7 +++++++
>  3 files changed, 44 insertions(+), 2 deletions(-)
> 
> diff --git a/arm/gic.c b/arm/gic.c
> index b6c5868..efe4b42 100644
> --- a/arm/gic.c
> +++ b/arm/gic.c
> @@ -9,7 +9,18 @@
>  #include <linux/kernel.h>
>  #include <linux/kvm.h>
>  
> +/* Those names are not defined for ARM (yet) */
> +#ifndef KVM_VGIC_V3_ADDR_TYPE_DIST
> +#define KVM_VGIC_V3_ADDR_TYPE_DIST 2
> +#endif
> +
> +#ifndef KVM_VGIC_V3_ADDR_TYPE_REDIST
> +#define KVM_VGIC_V3_ADDR_TYPE_REDIST 3
> +#endif
> +
>  static int gic_fd = -1;
> +static u64 gic_redists_base;
> +static u64 gic_redists_size;
>  
>  static int gic__create_device(struct kvm *kvm, enum irqchip_type type)
>  {
> @@ -28,12 +39,21 @@ static int gic__create_device(struct kvm *kvm, enum irqchip_type type)
>  		.group	= KVM_DEV_ARM_VGIC_GRP_ADDR,
>  		.addr	= (u64)(unsigned long)&dist_addr,
>  	};
> +	struct kvm_device_attr redist_attr = {
> +		.group	= KVM_DEV_ARM_VGIC_GRP_ADDR,
> +		.attr	= KVM_VGIC_V3_ADDR_TYPE_REDIST,
> +		.addr	= (u64)(unsigned long)&gic_redists_base,
> +	};
>  
>  	switch (type) {
>  	case IRQCHIP_GICV2:
>  		gic_device.type = KVM_DEV_TYPE_ARM_VGIC_V2;
>  		dist_attr.attr  = KVM_VGIC_V2_ADDR_TYPE_DIST;
>  		break;
> +	case IRQCHIP_GICV3:
> +		gic_device.type = KVM_DEV_TYPE_ARM_VGIC_V3;
> +		dist_attr.attr  = KVM_VGIC_V3_ADDR_TYPE_DIST;
> +		break;
>  	}
>  
>  	err = ioctl(kvm->vm_fd, KVM_CREATE_DEVICE, &gic_device);
> @@ -46,6 +66,9 @@ static int gic__create_device(struct kvm *kvm, enum irqchip_type type)
>  	case IRQCHIP_GICV2:
>  		err = ioctl(gic_fd, KVM_SET_DEVICE_ATTR, &cpu_if_attr);
>  		break;
> +	case IRQCHIP_GICV3:
> +		err = ioctl(gic_fd, KVM_SET_DEVICE_ATTR, &redist_attr);
> +		break;
>  	}
>  	if (err)
>  		goto out_err;
> @@ -97,6 +120,10 @@ int gic__create(struct kvm *kvm, enum irqchip_type type)
>  	switch (type) {
>  	case IRQCHIP_GICV2:
>  		break;
> +	case IRQCHIP_GICV3:
> +		gic_redists_size = kvm->cfg.nrcpus * ARM_GIC_REDIST_SIZE;
> +		gic_redists_base = ARM_GIC_DIST_BASE - gic_redists_size;
> +		break;
>  	default:
>  		return -ENODEV;
>  	}
> @@ -156,12 +183,19 @@ void gic__generate_fdt_nodes(void *fdt, u32 phandle, enum irqchip_type type)
>  	const char *compatible;
>  	u64 reg_prop[] = {
>  		cpu_to_fdt64(ARM_GIC_DIST_BASE), cpu_to_fdt64(ARM_GIC_DIST_SIZE),
> -		cpu_to_fdt64(ARM_GIC_CPUI_BASE), cpu_to_fdt64(ARM_GIC_CPUI_SIZE),
> +		0, 0,				/* to be filled */
>  	};
>  
>  	switch (type) {
>  	case IRQCHIP_GICV2:
>  		compatible = "arm,cortex-a15-gic";
> +		reg_prop[2] = cpu_to_fdt64(ARM_GIC_CPUI_BASE);
> +		reg_prop[3] = cpu_to_fdt64(ARM_GIC_CPUI_SIZE);
> +		break;
> +	case IRQCHIP_GICV3:
> +		compatible = "arm,gic-v3";
> +		reg_prop[2] = cpu_to_fdt64(gic_redists_base);
> +		reg_prop[3] = cpu_to_fdt64(gic_redists_size);
>  		break;
>  	default:
>  		return;
> diff --git a/arm/include/arm-common/gic.h b/arm/include/arm-common/gic.h
> index 2ed76fa..403d93b 100644
> --- a/arm/include/arm-common/gic.h
> +++ b/arm/include/arm-common/gic.h
> @@ -22,7 +22,8 @@
>  #define GIC_MAX_IRQ			255
>  
>  enum irqchip_type {
> -	IRQCHIP_GICV2
> +	IRQCHIP_GICV2,
> +	IRQCHIP_GICV3

Same remark as for the previous patch.

>  };
>  
>  struct kvm;
> diff --git a/arm/include/arm-common/kvm-arch.h b/arm/include/arm-common/kvm-arch.h
> index 90d6733..0f5fb7f 100644
> --- a/arm/include/arm-common/kvm-arch.h
> +++ b/arm/include/arm-common/kvm-arch.h
> @@ -30,6 +30,13 @@
>  #define KVM_PCI_MMIO_AREA	(KVM_PCI_CFG_AREA + ARM_PCI_CFG_SIZE)
>  #define KVM_VIRTIO_MMIO_AREA	ARM_MMIO_AREA
>  
> +/*
> + * On a GICv3 there must be one redistributor per vCPU.
> + * The value here is the size for one, we multiply this at runtime with
> + * the number of requested vCPUs to get the actual size.
> + */
> +#define ARM_GIC_REDIST_SIZE	0x20000
> +
>  #define KVM_IRQ_OFFSET		GIC_SPI_IRQ_BASE
>  
>  #define KVM_VM_TYPE		0
> 

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
