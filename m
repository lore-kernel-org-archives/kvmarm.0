From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v5 4/9] irqchip/gic-v2: Parse and export virtual GIC
 information
Date: Wed, 6 Apr 2016 19:04:32 +0200
Message-ID: <20160406170432.GD8961@cbox>
References: <1459769860-6629-1-git-send-email-julien.grall@arm.com>
 <1459769860-6629-5-git-send-email-julien.grall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F1731409A2
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Apr 2016 13:03:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id y2DTH4mFgkDF for <kvmarm@lists.cs.columbia.edu>;
 Wed,  6 Apr 2016 13:03:01 -0400 (EDT)
Received: from mail-wm0-f41.google.com (mail-wm0-f41.google.com [74.125.82.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 672D5407A5
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Apr 2016 13:03:01 -0400 (EDT)
Received: by mail-wm0-f41.google.com with SMTP id 191so65275558wmq.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 06 Apr 2016 10:04:23 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1459769860-6629-5-git-send-email-julien.grall@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Julien Grall <julien.grall@arm.com>
Cc: al.stone@linaro.org, kvm@vger.kernel.org, marc.zyngier@arm.com, Jason Cooper <jason@lakedaemon.net>, linux-kernel@vger.kernel.org, fu.wei@linaro.org, Thomas Gleixner <tglx@linutronix.de>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, gg@slimlogic.co.uk
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Apr 04, 2016 at 12:37:35PM +0100, Julien Grall wrote:
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
>     Changes in v4:
>         - Change the flow to call gic_set_kvm_info when all the
>         information are present.
>         - Rework comments in arm-gic-common.h
>         - Replace WARN_ON with BUG_ON in gic_set_kvm_info
> 
>     Changes in v2:
>         - Use 0 rather than a negative value to know when the maintenance IRQ
>         is not present.
>         - Use resource for vcpu and vctrl
> ---
>  drivers/irqchip/irq-gic-common.c       | 13 ++++++
>  drivers/irqchip/irq-gic-common.h       |  3 ++
>  drivers/irqchip/irq-gic.c              | 76 +++++++++++++++++++++++++++++++++-
>  include/linux/irqchip/arm-gic-common.h | 33 +++++++++++++++
>  4 files changed, 124 insertions(+), 1 deletion(-)
>  create mode 100644 include/linux/irqchip/arm-gic-common.h
> 
> diff --git a/drivers/irqchip/irq-gic-common.c b/drivers/irqchip/irq-gic-common.c
> index f174ce0..2e9443b 100644
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
> +	BUG_ON(gic_kvm_info != NULL);
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
> index 7a73786..24c05f3 100644
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
> @@ -1189,6 +1191,29 @@ static bool gic_check_eoimode(struct device_node *node, void __iomem **base)
>  	return true;
>  }
>  
> +static void __init gic_of_setup_kvm_info(struct device_node *node)
> +{
> +	int ret;
> +	struct resource *vctrl_res = &gic_v2_kvm_info.vctrl;
> +	struct resource *vcpu_res = &gic_v2_kvm_info.vcpu;
> +
> +	gic_v2_kvm_info.type = GIC_V2;
> +
> +	gic_v2_kvm_info.maint_irq = irq_of_parse_and_map(node, 0);
> +	if (!gic_v2_kvm_info.maint_irq)
> +		return;
> +
> +	ret = of_address_to_resource(node, 2, vctrl_res);
> +	if (ret)
> +		return;
> +
> +	ret = of_address_to_resource(node, 3, vcpu_res);
> +	if (ret)
> +		return;
> +
> +	gic_set_kvm_info(&gic_v2_kvm_info);
> +}
> +
>  int __init
>  gic_of_init(struct device_node *node, struct device_node *parent)
>  {
> @@ -1218,8 +1243,10 @@ gic_of_init(struct device_node *node, struct device_node *parent)
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
> @@ -1248,6 +1275,10 @@ IRQCHIP_DECLARE(pl390, "arm,pl390", gic_of_init);
>  static struct
>  {
>  	phys_addr_t cpu_phys_base;
> +	u32 maint_irq;
> +	int maint_irq_mode;
> +	phys_addr_t vctrl_base;
> +	phys_addr_t vcpu_base;
>  } acpi_data __initdata;
>  
>  static int __init
> @@ -1272,6 +1303,12 @@ gic_acpi_parse_madt_cpu(struct acpi_subtable_header *header,
>  		return -EINVAL;
>  
>  	acpi_data.cpu_phys_base = gic_cpu_base;
> +	acpi_data.maint_irq = processor->vgic_interrupt;
> +	acpi_data.maint_irq_mode = (processor->flags & ACPI_MADT_VGIC_IRQ_MODE) ?
> +				    ACPI_EDGE_SENSITIVE : ACPI_LEVEL_SENSITIVE;
> +	acpi_data.vctrl_base = processor->gich_base_address;
> +	acpi_data.vcpu_base = processor->gicv_base_address;
> +
>  	cpu_base_assigned = 1;
>  	return 0;
>  }
> @@ -1302,6 +1339,41 @@ static bool __init gic_validate_dist(struct acpi_subtable_header *header,
>  
>  #define ACPI_GICV2_DIST_MEM_SIZE	(SZ_4K)
>  #define ACPI_GIC_CPU_IF_MEM_SIZE	(SZ_8K)
> +#define ACPI_GICV2_VCTRL_MEM_SIZE	(SZ_4K)
> +#define ACPI_GICV2_VCPU_MEM_SIZE	(SZ_8K)
> +
> +static void __init gic_acpi_setup_kvm_info(void)
> +{
> +	int irq;
> +	struct resource *vctrl_res = &gic_v2_kvm_info.vctrl;
> +	struct resource *vcpu_res = &gic_v2_kvm_info.vcpu;
> +
> +	gic_v2_kvm_info.type = GIC_V2;
> +
> +	irq = acpi_register_gsi(NULL, acpi_data.maint_irq,
> +				acpi_data.maint_irq_mode,
> +				ACPI_ACTIVE_HIGH);
> +	if (irq <= 0)
> +		return;
> +
> +	gic_v2_kvm_info.maint_irq = irq;
> +
> +	if (!acpi_data.vctrl_base)
> +		return;
> +
> +	vctrl_res->flags = IORESOURCE_MEM;
> +	vctrl_res->start = acpi_data.vctrl_base;
> +	vctrl_res->end = vctrl_res->start + ACPI_GICV2_VCTRL_MEM_SIZE - 1;
> +
> +	if (!acpi_data.vcpu_base)
> +		return;
> +
> +	vcpu_res->flags = IORESOURCE_MEM;
> +	vcpu_res->start = acpi_data.vcpu_base;
> +	vcpu_res->end = vcpu_res->start + ACPI_GICV2_VCPU_MEM_SIZE - 1;
> +
> +	gic_set_kvm_info(&gic_v2_kvm_info);
> +}
>  
>  static int __init gic_v2_acpi_init(struct acpi_subtable_header *header,
>  				   const unsigned long end)
> @@ -1359,6 +1431,8 @@ static int __init gic_v2_acpi_init(struct acpi_subtable_header *header,
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
> index 0000000..ef34f6f
> --- /dev/null
> +++ b/include/linux/irqchip/arm-gic-common.h

just out of curiosity, why is include/linux/irqchip/arm-gic.h not
suitable?

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
> +	/* Virtual CPU interface */
> +	struct resource vcpu;
> +	/* Interrupt number */
> +	unsigned int	maint_irq;
> +	/* Virtual control interface */
> +	struct resource vctrl;
> +};
> +
> +const struct gic_kvm_info *gic_get_kvm_info(void);
> +
> +#endif /* __LINUX_IRQCHIP_ARM_GIC_COMMON_H */
> -- 
> 1.9.1
> 

Otherwise this looks good to me.

-Christoffer
