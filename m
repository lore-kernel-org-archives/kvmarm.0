From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH kvmtool 2/2] Add GICv2m support
Date: Fri, 3 Nov 2017 14:27:07 +0000
Message-ID: <fa935a6d-2692-f4d9-7527-b434452ff334@arm.com>
References: <20171103113841.3066-1-jean-philippe.brucker@arm.com>
 <20171103113841.3066-3-jean-philippe.brucker@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3685549D46
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Nov 2017 10:25:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fxSonUog9rzc for <kvmarm@lists.cs.columbia.edu>;
 Fri,  3 Nov 2017 10:25:31 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 181C549D21
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Nov 2017 10:25:31 -0400 (EDT)
In-Reply-To: <20171103113841.3066-3-jean-philippe.brucker@arm.com>
Content-Language: en-GB
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>, kvm@vger.kernel.org
Cc: marc.zyngier@arm.com, punit.agrawal@arm.com, will.deacon@arm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

good stuff, thanks for doing this!

On 03/11/17 11:38, Jean-Philippe Brucker wrote:
> GICv2m is a small extension to the GICv2 architecture, specified in the
> Server Base System Architecture (SBSA). It adds a set of register to
> converts MSIs into SPIs, effectively enabling MSI support for pre-GICv3
> platforms.

I was wondering if it would be worth to split this up, and introduce the
msi_routing_ops in a separate patch first, possibly even the changes to
pci.c.

> Implement a GICv2m emulation entirely in userspace. Add a thin translation
> layer in irq.c to catch the MSI->SPI routing setup of the guest, and then
> transform irqfd injection of MSI into the associated SPI. There shouldn't
> be any significant runtime overhead compared to gicv3-its.

As others have pointed out already, these patches seem to rely on some
other patches.
However by ignoring the two hunks in non-yet-existing functions in irq.c
and adding #include <stdbool.h> to include/kvm/irq.h I could compile and
run it on a Juno.

> The device can be enabled by passing "--irqchip gicv2m" to kvmtool.

Might be worth to mention that for actually using MSIs in general one
needs "--force-pci" on the command line as well.

Given the compile fixes mentioned above, this boots with MSIs on my
Juno. Testing 32 bit in a minute.

Cheers,
Andre.

> 
> Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
> ---
>  Makefile                                 |   2 +-
>  arm/aarch32/include/asm/kvm.h            |   2 +
>  arm/aarch64/include/asm/kvm.h            |   2 +
>  arm/gic.c                                |  13 +++
>  arm/gicv2m.c                             | 153 +++++++++++++++++++++++++++++++
>  arm/include/arm-common/gic.h             |   3 +
>  arm/include/arm-common/kvm-config-arch.h |   2 +-
>  include/kvm/irq.h                        |  11 +++
>  irq.c                                    |  68 +++++++++++---
>  virtio/pci.c                             |   4 +-
>  10 files changed, 244 insertions(+), 16 deletions(-)
>  create mode 100644 arm/gicv2m.c
> 
> diff --git a/Makefile b/Makefile
> index 6414b5853947..93dc0673571d 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -153,7 +153,7 @@ ifeq ($(ARCH), powerpc)
>  endif
>  
>  # ARM
> -OBJS_ARM_COMMON		:= arm/fdt.o arm/gic.o arm/ioport.o \
> +OBJS_ARM_COMMON		:= arm/fdt.o arm/gic.o arm/gicv2m.o arm/ioport.o \
>  			   arm/kvm.o arm/kvm-cpu.o arm/pci.o arm/timer.o \
>  			   arm/pmu.o
>  HDRS_ARM_COMMON		:= arm/include
> diff --git a/arm/aarch32/include/asm/kvm.h b/arm/aarch32/include/asm/kvm.h
> index 6ebd3e6a1fd1..022066730dc7 100644
> --- a/arm/aarch32/include/asm/kvm.h
> +++ b/arm/aarch32/include/asm/kvm.h
> @@ -84,6 +84,8 @@ struct kvm_regs {
>  #define KVM_VGIC_V2_DIST_SIZE		0x1000
>  #define KVM_VGIC_V2_CPU_SIZE		0x2000
>  
> +#define KVM_VGIC_V2M_SIZE		0x1000
> +
>  /* Supported VGICv3 address types  */
>  #define KVM_VGIC_V3_ADDR_TYPE_DIST	2
>  #define KVM_VGIC_V3_ADDR_TYPE_REDIST	3
> diff --git a/arm/aarch64/include/asm/kvm.h b/arm/aarch64/include/asm/kvm.h
> index c2860358ae3e..7d14507bd329 100644
> --- a/arm/aarch64/include/asm/kvm.h
> +++ b/arm/aarch64/include/asm/kvm.h
> @@ -84,6 +84,8 @@ struct kvm_regs {
>  #define KVM_VGIC_V2_DIST_SIZE		0x1000
>  #define KVM_VGIC_V2_CPU_SIZE		0x2000
>  
> +#define KVM_VGIC_V2M_SIZE		0x1000
> +
>  /* Supported VGICv3 address types  */
>  #define KVM_VGIC_V3_ADDR_TYPE_DIST	2
>  #define KVM_VGIC_V3_ADDR_TYPE_REDIST	3
> diff --git a/arm/gic.c b/arm/gic.c
> index e53f932e28c3..46cfa245e590 100644
> --- a/arm/gic.c
> +++ b/arm/gic.c
> @@ -32,6 +32,8 @@ int irqchip_parser(const struct option *opt, const char *arg, int unset)
>  
>  	if (!strcmp(arg, "gicv2")) {
>  		*type = IRQCHIP_GICV2;
> +	} else if (!strcmp(arg, "gicv2m")) {
> +		*type = IRQCHIP_GICV2M;
>  	} else if (!strcmp(arg, "gicv3")) {
>  		*type = IRQCHIP_GICV3;
>  	} else if (!strcmp(arg, "gicv3-its")) {
> @@ -134,6 +136,8 @@ static int gic__create_msi_frame(struct kvm *kvm, enum irqchip_type type,
>  				 u64 msi_frame_addr)
>  {
>  	switch (type) {
> +	case IRQCHIP_GICV2M:
> +		return gic__create_gicv2m_frame(kvm, msi_frame_addr);
>  	case IRQCHIP_GICV3_ITS:
>  		return gic__create_its_frame(kvm, msi_frame_addr);
>  	default:	/* No MSI frame needed */
> @@ -165,6 +169,7 @@ static int gic__create_device(struct kvm *kvm, enum irqchip_type type)
>  	};
>  
>  	switch (type) {
> +	case IRQCHIP_GICV2M:
>  	case IRQCHIP_GICV2:
>  		gic_device.type = KVM_DEV_TYPE_ARM_VGIC_V2;
>  		dist_attr.attr  = KVM_VGIC_V2_ADDR_TYPE_DIST;
> @@ -183,6 +188,7 @@ static int gic__create_device(struct kvm *kvm, enum irqchip_type type)
>  	gic_fd = gic_device.fd;
>  
>  	switch (type) {
> +	case IRQCHIP_GICV2M:
>  	case IRQCHIP_GICV2:
>  		err = ioctl(gic_fd, KVM_SET_DEVICE_ATTR, &cpu_if_attr);
>  		break;
> @@ -243,6 +249,10 @@ int gic__create(struct kvm *kvm, enum irqchip_type type)
>  	int err;
>  
>  	switch (type) {
> +	case IRQCHIP_GICV2M:
> +		gic_msi_size = KVM_VGIC_V2M_SIZE;
> +		gic_msi_base = ARM_GIC_DIST_BASE - gic_msi_size;
> +		break;
>  	case IRQCHIP_GICV2:
>  		break;
>  	case IRQCHIP_GICV3_ITS:
> @@ -325,6 +335,9 @@ void gic__generate_fdt_nodes(void *fdt, enum irqchip_type type)
>  	};
>  
>  	switch (type) {
> +	case IRQCHIP_GICV2M:
> +		msi_compatible = "arm,gic-v2m-frame";
> +		/* fall-through */
>  	case IRQCHIP_GICV2:
>  		compatible = "arm,cortex-a15-gic";
>  		reg_prop[2] = cpu_to_fdt64(ARM_GIC_CPUI_BASE);
> diff --git a/arm/gicv2m.c b/arm/gicv2m.c
> new file mode 100644
> index 000000000000..d7e6398a13a8
> --- /dev/null
> +++ b/arm/gicv2m.c
> @@ -0,0 +1,153 @@
> +#include <errno.h>
> +#include <stdlib.h>
> +
> +#include "kvm/irq.h"
> +#include "kvm/kvm.h"
> +#include "kvm/util.h"
> +
> +#include "arm-common/gic.h"
> +
> +#define GICV2M_MSI_TYPER	0x008
> +#define GICV2M_MSI_SETSPI	0x040
> +#define GICV2M_MSI_IIDR		0xfcc
> +
> +#define GICV2M_SPI_MASK		0x3ff
> +#define GICV2M_MSI_TYPER_VAL(start, nr)	\
> +	(((start) & GICV2M_SPI_MASK) << 16 | ((nr) & GICV2M_SPI_MASK))
> +
> +struct gicv2m_chip {
> +	int	first_spi;
> +	int	num_spis;
> +	int	*spis;
> +	u64	base;
> +	u64	size;
> +};
> +
> +static struct gicv2m_chip v2m;
> +
> +/*
> + * MSI routing is setup lazily, when the guest writes the MSI tables. The guest
> + * writes which SPI is associated to an MSI vector into the message data field.
> + * The IRQ code notifies us of any change to MSI routing via this callback.
> + * Store the MSI->SPI translation for later.
> + *
> + * Data is the GIC interrupt ID, that includes SGIs and PPIs. SGIs at 0-15, PPIs
> + * are 16-31 and SPIs are 32-1019. What we're saving for later is the MSI's GSI
> + * number, a logical ID used by KVM for routing. The GSI of an SPI is implicitly
> + * defined by KVM to be its pin number (SPI index), and the GSI of an MSI is
> + * allocated by kvmtool.
> + */
> +static int gicv2m_update_routing(struct kvm *kvm,
> +				 struct kvm_irq_routing_entry *entry)
> +{
> +	int spi;
> +
> +	if (entry->type != KVM_IRQ_ROUTING_MSI)
> +		return -EINVAL;
> +
> +	if (!entry->u.msi.address_hi && !entry->u.msi.address_lo)
> +		return 0;
> +
> +	spi = entry->u.msi.data & GICV2M_SPI_MASK;
> +	if (spi < v2m.first_spi || spi >= v2m.first_spi + v2m.num_spis) {
> +		pr_err("invalid SPI number %d", spi);
> +		return -EINVAL;
> +	}
> +
> +	v2m.spis[spi - v2m.first_spi] = entry->gsi;
> +
> +	return 0;
> +}
> +
> +/*
> + * Find SPI bound to the given MSI and return the associated GSI.
> + */
> +static int gicv2m_translate_gsi(struct kvm *kvm, u32 gsi)
> +{
> +	int i;
> +
> +	for (i = 0; i < v2m.num_spis; i++) {
> +		if (v2m.spis[i] == (int)gsi)
> +			return i + v2m.first_spi - KVM_IRQ_OFFSET;
> +	}
> +
> +	/* Not an MSI */
> +	return gsi;
> +}
> +
> +static bool gicv2m_can_signal_msi(struct kvm *kvm)
> +{
> +	return true;
> +}
> +
> +/*
> + * Instead of setting up MSI routes, virtual devices can also trigger them
> + * manually (like a direct write to MSI_SETSPI). In this case, trigger the SPI
> + * directly.
> + */
> +static int gicv2m_signal_msi(struct kvm *kvm, struct kvm_msi *msi)
> +{
> +	int spi = msi->data & GICV2M_SPI_MASK;
> +
> +	if (spi < v2m.first_spi || spi >= v2m.first_spi + v2m.num_spis) {
> +		pr_err("invalid SPI number %d", spi);
> +		return -EINVAL;
> +	}
> +
> +	kvm__irq_trigger(kvm, spi);
> +	return 0;
> +}
> +
> +static struct msi_routing_ops gicv2m_routing = {
> +	.update_route	= gicv2m_update_routing,
> +	.translate_gsi	= gicv2m_translate_gsi,
> +	.can_signal_msi	= gicv2m_can_signal_msi,
> +	.signal_msi	= gicv2m_signal_msi,
> +};
> +
> +static void gicv2m_mmio_callback(struct kvm_cpu *vcpu, u64 addr, u8 *data,
> +				  u32 len, u8 is_write, void *ptr)
> +{
> +	if (is_write)
> +		return;
> +
> +	addr -= v2m.base;
> +
> +	switch (addr) {
> +		case GICV2M_MSI_TYPER:
> +			*(u32 *)data = GICV2M_MSI_TYPER_VAL(v2m.first_spi,
> +							    v2m.num_spis);
> +			break;
> +		case GICV2M_MSI_IIDR:
> +			*(u32 *)data = 0x0;
> +			break;
> +	}
> +}
> +
> +int gic__create_gicv2m_frame(struct kvm *kvm, u64 base)
> +{
> +	int i;
> +	int irq = irq__alloc_line();
> +
> +	v2m = (struct gicv2m_chip) {
> +		.first_spi	= irq,	/* Includes GIC_SPI_IRQ_BASE */
> +		.num_spis	= 64,	/* arbitrary */
> +		.base		= base,
> +		.size		= KVM_VGIC_V2M_SIZE,
> +	};
> +
> +	v2m.spis = calloc(v2m.num_spis, sizeof(int));
> +	if (!v2m.spis)
> +		return -ENOMEM;
> +
> +	v2m.spis[0] = -1;
> +	for (i = 1; i < v2m.num_spis; i++) {
> +		irq__alloc_line();
> +		v2m.spis[i] = -1;
> +	}
> +
> +	msi_routing_ops = &gicv2m_routing;
> +
> +	return kvm__register_mmio(kvm, base, KVM_VGIC_V2M_SIZE, false,
> +				  gicv2m_mmio_callback, kvm);
> +}
> diff --git a/arm/include/arm-common/gic.h b/arm/include/arm-common/gic.h
> index 0c279aca8a5e..560fea2a2c5a 100644
> --- a/arm/include/arm-common/gic.h
> +++ b/arm/include/arm-common/gic.h
> @@ -23,6 +23,7 @@
>  
>  enum irqchip_type {
>  	IRQCHIP_GICV2,
> +	IRQCHIP_GICV2M,
>  	IRQCHIP_GICV3,
>  	IRQCHIP_GICV3_ITS,
>  };
> @@ -39,4 +40,6 @@ void gic__del_irqfd(struct kvm *kvm, unsigned int gsi, int trigger_fd);
>  #define irq__add_irqfd gic__add_irqfd
>  #define irq__del_irqfd gic__del_irqfd
>  
> +int gic__create_gicv2m_frame(struct kvm *kvm, u64 msi_frame_addr);
> +
>  #endif /* ARM_COMMON__GIC_H */
> diff --git a/arm/include/arm-common/kvm-config-arch.h b/arm/include/arm-common/kvm-config-arch.h
> index f18b2c88fa79..6a196f1852de 100644
> --- a/arm/include/arm-common/kvm-config-arch.h
> +++ b/arm/include/arm-common/kvm-config-arch.h
> @@ -28,7 +28,7 @@ int irqchip_parser(const struct option *opt, const char *arg, int unset);
>  		    "Force virtio devices to use PCI as their default "		\
>  		    "transport"),						\
>          OPT_CALLBACK('\0', "irqchip", &(cfg)->irqchip,				\
> -		     "[gicv2|gicv3|gicv3-its]",					\
> +		     "[gicv2|gicv2m|gicv3|gicv3-its]",				\
>  		     "Type of interrupt controller to emulate in the guest",	\
>  		     irqchip_parser, NULL),
>  
> diff --git a/include/kvm/irq.h b/include/kvm/irq.h
> index b24385b13f66..530ce3f9133d 100644
> --- a/include/kvm/irq.h
> +++ b/include/kvm/irq.h
> @@ -11,6 +11,14 @@
>  
>  struct kvm;
>  
> +struct msi_routing_ops {
> +	int (*update_route)(struct kvm *kvm, struct kvm_irq_routing_entry *);
> +	bool (*can_signal_msi)(struct kvm *kvm);
> +	int (*signal_msi)(struct kvm *kvm, struct kvm_msi *msi);
> +	int (*translate_gsi)(struct kvm *kvm, u32 gsi);
> +};
> +
> +extern struct msi_routing_ops *msi_routing_ops;
>  extern struct kvm_irq_routing *irq_routing;
>  extern int next_gsi;
>  
> @@ -24,6 +32,9 @@ int irq__allocate_routing_entry(void);
>  int irq__add_msix_route(struct kvm *kvm, struct msi_msg *msg, u32 device_id);
>  void irq__update_msix_route(struct kvm *kvm, u32 gsi, struct msi_msg *msg);
>  
> +bool irq__can_signal_msi(struct kvm *kvm);
> +int irq__signal_msi(struct kvm *kvm, struct kvm_msi *msi);
> +
>  /*
>   * The function takes two eventfd arguments, trigger_fd and resample_fd. If
>   * resample_fd is <= 0, resampling is disabled and the IRQ is edge-triggered
> diff --git a/irq.c b/irq.c
> index 25fa572761fa..cdcf99233baa 100644
> --- a/irq.c
> +++ b/irq.c
> @@ -13,6 +13,9 @@ static int allocated_gsis = 0;
>  
>  int next_gsi;
>  
> +struct msi_routing_ops irq__default_routing_ops;
> +struct msi_routing_ops *msi_routing_ops = &irq__default_routing_ops;
> +
>  struct kvm_irq_routing *irq_routing = NULL;
>  
>  int irq__alloc_line(void)
> @@ -66,9 +69,42 @@ static bool check_for_irq_routing(struct kvm *kvm)
>  	return has_irq_routing > 0;
>  }
>  
> +static int irq__update_msix_routes(struct kvm *kvm,
> +				   struct kvm_irq_routing_entry *entry)
> +{
> +	return ioctl(kvm->vm_fd, KVM_SET_GSI_ROUTING, irq_routing);
> +}
> +
> +static bool irq__default_can_signal_msi(struct kvm *kvm)
> +{
> +	return kvm__supports_extension(kvm, KVM_CAP_SIGNAL_MSI);
> +}
> +
> +static int irq__default_signal_msi(struct kvm *kvm, struct kvm_msi *msi)
> +{
> +	return ioctl(kvm->vm_fd, KVM_SIGNAL_MSI, msi);
> +}
> +
> +struct msi_routing_ops irq__default_routing_ops = {
> +	.update_route	= irq__update_msix_routes,
> +	.signal_msi	= irq__default_signal_msi,
> +	.can_signal_msi	= irq__default_can_signal_msi,
> +};
> +
> +bool irq__can_signal_msi(struct kvm *kvm)
> +{
> +	return msi_routing_ops->can_signal_msi(kvm);
> +}
> +
> +int irq__signal_msi(struct kvm *kvm, struct kvm_msi *msi)
> +{
> +	return msi_routing_ops->signal_msi(kvm, msi);
> +}
> +
>  int irq__add_msix_route(struct kvm *kvm, struct msi_msg *msg, u32 device_id)
>  {
>  	int r;
> +	struct kvm_irq_routing_entry *entry;
>  
>  	if (!check_for_irq_routing(kvm))
>  		return -ENXIO;
> @@ -77,22 +113,23 @@ int irq__add_msix_route(struct kvm *kvm, struct msi_msg *msg, u32 device_id)
>  	if (r)
>  		return r;
>  
> -	irq_routing->entries[irq_routing->nr] =
> -		(struct kvm_irq_routing_entry) {
> -			.gsi = next_gsi,
> -			.type = KVM_IRQ_ROUTING_MSI,
> -			.u.msi.address_hi = msg->address_hi,
> -			.u.msi.address_lo = msg->address_lo,
> -			.u.msi.data = msg->data,
> -		};
> +	entry = &irq_routing->entries[irq_routing->nr];
> +	*entry = (struct kvm_irq_routing_entry) {
> +		.gsi = next_gsi,
> +		.type = KVM_IRQ_ROUTING_MSI,
> +		.u.msi.address_hi = msg->address_hi,
> +		.u.msi.address_lo = msg->address_lo,
> +		.u.msi.data = msg->data,
> +	};
>  
>  	if (kvm->msix_needs_devid) {
> -		irq_routing->entries[irq_routing->nr].flags = KVM_MSI_VALID_DEVID;
> -		irq_routing->entries[irq_routing->nr].u.msi.devid = device_id;
> +		entry->flags = KVM_MSI_VALID_DEVID;
> +		entry->u.msi.devid = device_id;
>  	}
> +
>  	irq_routing->nr++;
>  
> -	r = ioctl(kvm->vm_fd, KVM_SET_GSI_ROUTING, irq_routing);
> +	r = msi_routing_ops->update_route(kvm, entry);
>  	if (r)
>  		return r;
>  
> @@ -129,7 +166,7 @@ void irq__update_msix_route(struct kvm *kvm, u32 gsi, struct msi_msg *msg)
>  	if (!changed)
>  		return;
>  
> -	if (ioctl(kvm->vm_fd, KVM_SET_GSI_ROUTING, irq_routing) == -1)
> +	if (msi_routing_ops->update_route(kvm, &irq_routing->entries[i]))
>  		die_perror("KVM_SET_GSI_ROUTING");
>  }
>  
> @@ -143,6 +180,10 @@ int irq__common_add_irqfd(struct kvm *kvm, unsigned int gsi, int trigger_fd,
>  		.resamplefd	= resample_fd,
>  	};
>  
> +	/* If we emulate MSI routing, translate the MSI to the corresponding IRQ */
> +	if (msi_routing_ops->translate_gsi)
> +		irqfd.gsi = msi_routing_ops->translate_gsi(kvm, gsi);
> +
>  	return ioctl(kvm->vm_fd, KVM_IRQFD, &irqfd);
>  }
>  
> @@ -154,6 +195,9 @@ void irq__common_del_irqfd(struct kvm *kvm, unsigned int gsi, int trigger_fd)
>  		.flags		= KVM_IRQFD_FLAG_DEASSIGN,
>  	};
>  
> +	if (msi_routing_ops->translate_gsi)
> +		irqfd.gsi = msi_routing_ops->translate_gsi(kvm, gsi);
> +
>  	ioctl(kvm->vm_fd, KVM_IRQFD, &irqfd);
>  }
>  
> diff --git a/virtio/pci.c b/virtio/pci.c
> index 46473b00029b..4ce111108100 100644
> --- a/virtio/pci.c
> +++ b/virtio/pci.c
> @@ -350,7 +350,7 @@ static void virtio_pci__signal_msi(struct kvm *kvm, struct virtio_pci *vpci,
>  		msi.devid = vpci->dev_hdr.dev_num << 3;
>  	}
>  
> -	ioctl(kvm->vm_fd, KVM_SIGNAL_MSI, &msi);
> +	irq__signal_msi(kvm, &msi);
>  }
>  
>  int virtio_pci__signal_vq(struct kvm *kvm, struct virtio_device *vdev, u32 vq)
> @@ -488,7 +488,7 @@ int virtio_pci__init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
>  	vpci->pci_hdr.msix.pba_offset = cpu_to_le32(2 | PCI_IO_SIZE);
>  	vpci->config_vector = 0;
>  
> -	if (kvm__supports_extension(kvm, KVM_CAP_SIGNAL_MSI))
> +	if (irq__can_signal_msi(kvm))
>  		vpci->features |= VIRTIO_PCI_F_SIGNAL_MSI;
>  
>  	r = device__register(&vpci->dev_hdr);
> 
