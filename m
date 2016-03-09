From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3 4/9] irqchip/gic-v2: Parse and export virtual GIC
 information
Date: Tue, 8 Mar 2016 21:14:04 -0800
Message-ID: <20160309051404.GG26583@lvm>
References: <1457436573-6180-1-git-send-email-julien.grall@arm.com>
 <1457436573-6180-5-git-send-email-julien.grall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1457436573-6180-5-git-send-email-julien.grall@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Julien Grall <julien.grall@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, fu.wei@linaro.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, wei@redhat.com, al.stone@linaro.org, Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Mar 08, 2016 at 11:29:28AM +0000, Julien Grall wrote:
> For now, the firmware tables are parsed 2 times: once in the GIC
> drivers, the other timer when initializing the vGIC. It means code
> duplication and make more tedious to add the support for another
> firmware table (like ACPI).
> 
> Introduce a new structure and set of helpers to get/set the virtual GIC
> information. Also fill up the structure for GICv2.
> 
> Signed-off-by: Julien Grall <julien.grall@arm.com>
> 
> ---
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Jason Cooper <jason@lakedaemon.net>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> 
>     Changes in v2:
>         - Use 0 rather than a negative value to know when the maintenance IRQ
>         is not present.
>         - Use resource for vcpu and vctrl
> ---
>  drivers/irqchip/irq-gic-common.c       | 13 ++++++
>  drivers/irqchip/irq-gic-common.h       |  3 ++
>  drivers/irqchip/irq-gic.c              | 80 +++++++++++++++++++++++++++++++++-
>  include/linux/irqchip/arm-gic-common.h | 33 ++++++++++++++
>  4 files changed, 128 insertions(+), 1 deletion(-)
>  create mode 100644 include/linux/irqchip/arm-gic-common.h
> 
> diff --git a/drivers/irqchip/irq-gic-common.c b/drivers/irqchip/irq-gic-common.c
> index f174ce0..704caf4 100644
> --- a/drivers/irqchip/irq-gic-common.c
> +++ b/drivers/irqchip/irq-gic-common.c
> @@ -21,6 +21,19 @@
>  
>  #include "irq-gic-common.h"
>  
> +static const struct gic_kvm_info *gic_kvm_info;
> +
> +const struct gic_kvm_info *gic_get_kvm_info(void)
> +{
> +	return gic_kvm_info;
> +}
> +
> +void gic_set_kvm_info(const struct gic_kvm_info *info)
> +{
> +	WARN(gic_kvm_info != NULL, "gic_kvm_info already set\n");

why do we WARN here?  Wouldn't this be an obvious bug?

> +	gic_kvm_info = info;
> +}
> +
>  void gic_enable_quirks(u32 iidr, const struct gic_quirk *quirks,
>  		void *data)
>  {
> diff --git a/drivers/irqchip/irq-gic-common.h b/drivers/irqchip/irq-gic-common.h
> index fff697d..205e5fd 100644
> --- a/drivers/irqchip/irq-gic-common.h
> +++ b/drivers/irqchip/irq-gic-common.h
> @@ -19,6 +19,7 @@
>  
>  #include <linux/of.h>
>  #include <linux/irqdomain.h>
> +#include <linux/irqchip/arm-gic-common.h>
>  
>  struct gic_quirk {
>  	const char *desc;
> @@ -35,4 +36,6 @@ void gic_cpu_config(void __iomem *base, void (*sync_access)(void));
>  void gic_enable_quirks(u32 iidr, const struct gic_quirk *quirks,
>  		void *data);
>  
> +void gic_set_kvm_info(const struct gic_kvm_info *info);
> +
>  #endif /* _IRQ_GIC_COMMON_H */
> diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
> index fbde202..0c58112 100644
> --- a/drivers/irqchip/irq-gic.c
> +++ b/drivers/irqchip/irq-gic.c
> @@ -102,6 +102,8 @@ static struct static_key supports_deactivate = STATIC_KEY_INIT_TRUE;
>  
>  static struct gic_chip_data gic_data[CONFIG_ARM_GIC_MAX_NR] __read_mostly;
>  
> +static struct gic_kvm_info gic_v2_kvm_info;
> +
>  #ifdef CONFIG_GIC_NON_BANKED
>  static void __iomem *gic_get_percpu_base(union gic_base *base)
>  {
> @@ -1189,6 +1191,35 @@ static bool gic_check_eoimode(struct device_node *node, void __iomem **base)
>  	return true;
>  }
>  
> +static void __init gic_of_setup_kvm_info(struct device_node *node)
> +{
> +	int ret;
> +	struct resource r;

I would prefer two struct resource variables more akin to how the KVM
code did it already, and then name them something more understandable
than 'r'.

You could also argue that you can then only populate the gic_v2_kvm_info
with all coherent info or nothing, instead of filling it out partially
and then exiting.

> +
> +	gic_v2_kvm_info.type = GIC_V2;
> +
> +	gic_v2_kvm_info.maint_irq = irq_of_parse_and_map(node, 0);
> +
> +	ret = of_address_to_resource(node, 2, &r);
> +	if (!ret)
> +		gic_v2_kvm_info.vctrl = r;
> +
> +	ret = of_address_to_resource(node, 3, &r);

here you're overwriting the error return value if the first call to
of_address_to_resource failed ?

> +	if (!ret) {
> +		if (!PAGE_ALIGNED(r.start))
> +			pr_warn("GICV physical address 0x%llx not page aligned\n",
> +				(unsigned long long)r.start);

how does KVM know that this went bad?

> +		else if (!PAGE_ALIGNED(resource_size(&r)))
> +			pr_warn("GICV size 0x%llx not a multiple of page size 0x%lx\n",
> +				(unsigned long long)resource_size(&r),
> +				PAGE_SIZE);

same?

> +		else
> +			gic_v2_kvm_info.vcpu = r;
> +	}
> +
> +	gic_set_kvm_info(&gic_v2_kvm_info);

so here you're setting the kvm info even if one of the calls above
fails?

I think this function could leverage much more of the existing KVM
implementation to avoid these kinds of mistakes.

> +}
> +
>  int __init
>  gic_of_init(struct device_node *node, struct device_node *parent)
>  {
> @@ -1218,8 +1249,10 @@ gic_of_init(struct device_node *node, struct device_node *parent)
>  
>  	__gic_init_bases(gic_cnt, -1, dist_base, cpu_base, percpu_offset,
>  			 &node->fwnode);
> -	if (!gic_cnt)
> +	if (!gic_cnt) {
>  		gic_init_physaddr(node);
> +		gic_of_setup_kvm_info(node);
> +	}
>  
>  	if (parent) {
>  		irq = irq_of_parse_and_map(node, 0);
> @@ -1248,6 +1281,10 @@ IRQCHIP_DECLARE(pl390, "arm,pl390", gic_of_init);
>  static struct
>  {
>  	phys_addr_t cpu_phy_base;
> +	u32 maint_irq;
> +	int maint_irq_mode;
> +	phys_addr_t vctrl_base;
> +	phys_addr_t vcpu_base;
>  } acpi_data __initdata;
>  
>  static int __init
> @@ -1272,6 +1309,12 @@ gic_acpi_parse_madt_cpu(struct acpi_subtable_header *header,
>  		return -EINVAL;
>  
>  	acpi_data.cpu_phy_base = gic_cpu_base;
> +	acpi_data.maint_irq = processor->vgic_interrupt;
> +	acpi_data.maint_irq_mode = (processor->flags & ACPI_MADT_VGIC_IRQ_MODE) ?
> +				    ACPI_EDGE_SENSITIVE : ACPI_LEVEL_SENSITIVE;

I can only assume that bit 2 set means edge, and the default is leve,
but I really don't know how ACPI works here.

> +	acpi_data.vctrl_base = processor->gich_base_address;
> +	acpi_data.vcpu_base = processor->gicv_base_address;
> +
>  	cpu_base_assigned = 1;
>  	return 0;
>  }
> @@ -1302,6 +1345,39 @@ static bool __init gic_validate_dist(struct acpi_subtable_header *header,
>  
>  #define ACPI_GICV2_DIST_MEM_SIZE	(SZ_4K)
>  #define ACPI_GIC_CPU_IF_MEM_SIZE	(SZ_8K)
> +#define ACPI_GICV2_VCTRL_MEM_SIZE	(SZ_4K)
> +#define ACPI_GICV2_VCPU_MEM_SIZE	(SZ_8K)
> +
> +static void __init gic_acpi_setup_kvm_info(void)
> +{
> +	int irq;
> +
> +	gic_v2_kvm_info.type = GIC_V2;
> +
> +	irq = acpi_register_gsi(NULL, acpi_data.maint_irq,
> +				acpi_data.maint_irq_mode,
> +				ACPI_ACTIVE_HIGH);
> +	if (irq > 0)
> +		gic_v2_kvm_info.maint_irq = irq;
> +
> +	if (acpi_data.vctrl_base) {
> +		struct resource *vctrl = &gic_v2_kvm_info.vctrl;
> +
> +		vctrl->flags = IORESOURCE_MEM;
> +		vctrl->start = acpi_data.vctrl_base;
> +		vctrl->end = vctrl->start + ACPI_GICV2_VCTRL_MEM_SIZE - 1;
> +	}
> +
> +	if (acpi_data.vcpu_base) {
> +		struct resource *vcpu = &gic_v2_kvm_info.vcpu;
> +
> +		vcpu->flags = IORESOURCE_MEM;
> +		vcpu->start = acpi_data.vcpu_base;
> +		vcpu->end = vcpu->start + ACPI_GICV2_VCPU_MEM_SIZE - 1;
> +	}
> +
> +	gic_set_kvm_info(&gic_v2_kvm_info);

again, if something fails above, you're still setting the struct
pointer.

how will KVM know?

> +}
>  
>  static int __init gic_v2_acpi_init(struct acpi_subtable_header *header,
>  				   const unsigned long end)
> @@ -1359,6 +1435,8 @@ static int __init gic_v2_acpi_init(struct acpi_subtable_header *header,
>  	if (IS_ENABLED(CONFIG_ARM_GIC_V2M))
>  		gicv2m_init(NULL, gic_data[0].domain);
>  
> +	gic_acpi_setup_kvm_info();
> +
>  	return 0;
>  }
>  IRQCHIP_ACPI_DECLARE(gic_v2, ACPI_MADT_TYPE_GENERIC_DISTRIBUTOR,
> diff --git a/include/linux/irqchip/arm-gic-common.h b/include/linux/irqchip/arm-gic-common.h
> new file mode 100644
> index 0000000..f7723b9
> --- /dev/null
> +++ b/include/linux/irqchip/arm-gic-common.h
> @@ -0,0 +1,33 @@
> +/*
> + * include/linux/irqchip/arm-gic-common.h
> + *
> + * Copyright (C) 2016 ARM Limited, All Rights Reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +#ifndef __LINUX_IRQCHIP_ARM_GIC_COMMON_H
> +#define __LINUX_IRQCHIP_ARM_GIC_COMMON_H
> +
> +#include <linux/types.h>
> +#include <linux/ioport.h>
> +
> +enum gic_type {
> +	GIC_V2,
> +};
> +
> +struct gic_kvm_info {
> +	/* GIC type */
> +	enum gic_type	type;
> +	/* Physical address & size of virtual cpu interface */

is this a bitwise '&' or did you want to save two ascii characters by
not writing 'and' ?  If the latter, please write 'and'.

> +	struct resource vcpu;
> +	/* Interrupt number */

if you're going to comment on the fact that this is an interrupt number,
I would be more interested in knowing if it's a Linux IRQ number or the
INTID...

> +	unsigned int	maint_irq;
> +	/* Physical address & size of virtual control interface */

same here

> +	struct resource vctrl;

I'm actually not convinced the comments on this struct help a lot, but
ok.

> +};
> +
> +const struct gic_kvm_info *gic_get_kvm_info(void);
> +
> +#endif /* __LINUX_IRQCHIP_ARM_GIC_COMMON_H */
> -- 
> 1.9.1
> 
