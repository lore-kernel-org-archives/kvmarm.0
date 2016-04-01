From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v4 6/9] irqchip/gic-v3: Parse and export virtual GIC
 information
Date: Fri, 1 Apr 2016 12:13:08 +0200
Message-ID: <20160401101308.GB20224@cbox>
References: <1458842023-31853-1-git-send-email-julien.grall@arm.com>
 <1458842023-31853-7-git-send-email-julien.grall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 34F1349AF5
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Apr 2016 06:12:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dK7PT6zRUMa9 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  1 Apr 2016 06:12:00 -0400 (EDT)
Received: from mail-wm0-f45.google.com (mail-wm0-f45.google.com [74.125.82.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 11CD741390
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Apr 2016 06:11:59 -0400 (EDT)
Received: by mail-wm0-f45.google.com with SMTP id p65so16806701wmp.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 01 Apr 2016 03:13:07 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1458842023-31853-7-git-send-email-julien.grall@arm.com>
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

On Thu, Mar 24, 2016 at 05:53:40PM +0000, Julien Grall wrote:
> Fill up the recently introduced gic_kvm_info with the hardware
> information used for virtualization.
> 
> Signed-off-by: Julien Grall <julien.grall@arm.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Jason Cooper <jason@lakedaemon.net>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> 
> ---
>     Changes in v4:
>         - Change the flow to call gic_kvm_set_info only when all the
>         mandatory information are valid.
>         - Remove unecessary code in ACPI parsing (the virtual control
>         interface doesn't exist for GICv3).
>         - Rework commit message
>         - Rework the ACPI support as it didn't collect hardware info for
>         virtualization when there is more than 1 redistributor region
> 
>     Changes in v3:
>         - Add ACPI support
> 
>     Changes in v2:
>         - Use 0 rather than a negative value to know when the maintenance IRQ
>         is not present.
>         - Use resource for vcpu and vctrl
> ---
>  drivers/irqchip/irq-gic-v3.c           | 123 ++++++++++++++++++++++++++++++++-
>  include/linux/irqchip/arm-gic-common.h |   1 +
>  2 files changed, 123 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
> index 50e87e6..b5ed8be 100644
> --- a/drivers/irqchip/irq-gic-v3.c
> +++ b/drivers/irqchip/irq-gic-v3.c
> @@ -28,6 +28,7 @@
>  #include <linux/slab.h>
>  
>  #include <linux/irqchip.h>
> +#include <linux/irqchip/arm-gic-common.h>
>  #include <linux/irqchip/arm-gic-v3.h>
>  
>  #include <asm/cputype.h>
> @@ -56,6 +57,8 @@ struct gic_chip_data {
>  static struct gic_chip_data gic_data __read_mostly;
>  static struct static_key supports_deactivate = STATIC_KEY_INIT_TRUE;
>  
> +static struct gic_kvm_info gic_v3_kvm_info;
> +
>  #define gic_data_rdist()		(this_cpu_ptr(gic_data.rdists.rdist))
>  #define gic_data_rdist_rd_base()	(gic_data_rdist()->rd_base)
>  #define gic_data_rdist_sgi_base()	(gic_data_rdist_rd_base() + SZ_64K)
> @@ -901,6 +904,39 @@ static int __init gic_validate_dist_version(void __iomem *dist_base)
>  	return 0;
>  }
>  
> +static void __init gic_of_setup_kvm_info(struct device_node *node)
> +{
> +	int ret;
> +	struct resource r;
> +	u32 gicv_idx;
> +
> +	gic_v3_kvm_info.type = GIC_V3;
> +
> +	gic_v3_kvm_info.maint_irq = irq_of_parse_and_map(node, 0);
> +	if (!gic_v3_kvm_info.maint_irq)
> +		return;
> +
> +	if (of_property_read_u32(node, "#redistributor-regions",
> +				 &gicv_idx))
> +		gicv_idx = 1;
> +
> +	gicv_idx += 3;	/* Also skip GICD, GICC, GICH */
> +	ret = of_address_to_resource(node, gicv_idx, &r);
> +	if (!ret) {
> +		if (!PAGE_ALIGNED(r.start))
> +			pr_warn("GICV physical address 0x%llx not page aligned\n",
> +				(unsigned long long)r.start);
> +		else if (!PAGE_ALIGNED(resource_size(&r)))
> +			pr_warn("GICV size 0x%llx not a multiple of page size 0x%lx\n",
> +				(unsigned long long)resource_size(&r),
> +				PAGE_SIZE);
> +		else

it seems like you're also checking the above items in the KVM code
itself, so I still don't understand why we have to do this twice.

My feeling here is that you want to just lookup if you have the proper
resources to fill in the struct in the GIC driver, and fill in the
struct with data if the firmware gave you something.

It's then up to KVM to deal with its constraints, such as the resources
being page-aligned etc.  But I suppose you could also argue that the GIC
code knows how this hardware resource can or cannot be used and
therefore should check it.

But in any case, I don't understand why we check it more than one place?

Thanks,
-Christoffer

> +			gic_v3_kvm_info.vcpu = r;
> +	}
> +
> +	gic_set_kvm_info(&gic_v3_kvm_info);
> +}
> +
>  static int __init gic_of_init(struct device_node *node, struct device_node *parent)
>  {
>  	void __iomem *dist_base;
> @@ -952,8 +988,10 @@ static int __init gic_of_init(struct device_node *node, struct device_node *pare
>  
>  	err = gic_init_bases(dist_base, rdist_regs, nr_redist_regions,
>  			     redist_stride, &node->fwnode);
> -	if (!err)
> +	if (!err) {
> +		gic_of_setup_kvm_info(node);
>  		return 0;
> +	}
>  
>  out_unmap_rdist:
>  	for (i = 0; i < nr_redist_regions; i++)
> @@ -974,6 +1012,9 @@ static struct
>  	struct redist_region *redist_regs;
>  	u32 nr_redist_regions;
>  	bool single_redist;
> +	u32 maint_irq;
> +	int maint_irq_mode;
> +	phys_addr_t vcpu_base;
>  } acpi_data __initdata;
>  
>  static void __init
> @@ -1020,6 +1061,7 @@ gic_acpi_parse_madt_gicc(struct acpi_subtable_header *header,
>  		return -ENOMEM;
>  
>  	gic_acpi_register_redist(gicc->gicr_base_address, redist_base);
> +
>  	return 0;
>  }
>  
> @@ -1110,7 +1152,84 @@ static bool __init acpi_validate_gic_table(struct acpi_subtable_header *header,
>  	return true;
>  }
>  
> +static int __init gic_acpi_parse_virt_madt_gicc(struct acpi_subtable_header *header,
> +						const unsigned long end)
> +{
> +	struct acpi_madt_generic_interrupt *gicc =
> +		(struct acpi_madt_generic_interrupt *)header;
> +	int maint_irq_mode;
> +	static int first_madt = false;
> +
> +
> +	maint_irq_mode = (gicc->flags & ACPI_MADT_VGIC_IRQ_MODE) ?
> +		ACPI_EDGE_SENSITIVE : ACPI_LEVEL_SENSITIVE;
> +
> +	if (first_madt) {
> +		first_madt = false;
> +
> +		acpi_data.maint_irq = gicc->vgic_interrupt;
> +		acpi_data.maint_irq_mode = maint_irq_mode;
> +		acpi_data.vcpu_base = gicc->gicv_base_address;
> +
> +		return 0;
> +	}
> +
> +	/*
> +	 * The maintenance interrupt and GICV should be the same for every CPU
> +	 */
> +	if ((acpi_data.maint_irq != gicc->vgic_interrupt) ||
> +	    (acpi_data.maint_irq_mode != maint_irq_mode) ||
> +	    (acpi_data.vcpu_base != gicc->gicv_base_address))
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
> +static bool __init gic_acpi_collect_virt_info(void)
> +{
> +	int count;
> +
> +	count = acpi_table_parse_madt(ACPI_MADT_TYPE_GENERIC_INTERRUPT,
> +				      gic_acpi_parse_virt_madt_gicc, 0);
> +
> +	return false;
> +}
> +
>  #define ACPI_GICV3_DIST_MEM_SIZE (SZ_64K)
> +#define ACPI_GICV2_VCTRL_MEM_SIZE	(SZ_4K)
> +#define ACPI_GICV2_VCPU_MEM_SIZE	(SZ_8K)
> +
> +static void __init gic_acpi_setup_kvm_info(void)
> +{
> +	int irq;
> +
> +	if (!gic_acpi_collect_virt_info()) {
> +		pr_warn("Unable to get hardware information used for virtualization\n");
> +		return;
> +	}
> +
> +	gic_acpi_collect_virt_info();
> +
> +	gic_v3_kvm_info.type = GIC_V3;
> +
> +	irq = acpi_register_gsi(NULL, acpi_data.maint_irq,
> +				acpi_data.maint_irq_mode,
> +				ACPI_ACTIVE_HIGH);
> +	if (irq <= 0)
> +		return;
> +
> +	gic_v3_kvm_info.maint_irq = irq;
> +
> +	if (acpi_data.vcpu_base) {
> +		struct resource *vcpu = &gic_v3_kvm_info.vcpu;
> +
> +		vcpu->flags = IORESOURCE_MEM;
> +		vcpu->start = acpi_data.vcpu_base;
> +		vcpu->end = vcpu->start + ACPI_GICV2_VCPU_MEM_SIZE - 1;
> +	}
> +
> +	gic_set_kvm_info(&gic_v3_kvm_info);
> +}
>  
>  static int __init
>  gic_acpi_init(struct acpi_subtable_header *header, const unsigned long end)
> @@ -1159,6 +1278,8 @@ gic_acpi_init(struct acpi_subtable_header *header, const unsigned long end)
>  		goto out_fwhandle_free;
>  
>  	acpi_set_irq_model(ACPI_IRQ_MODEL_GIC, domain_handle);
> +	gic_acpi_setup_kvm_info();
> +
>  	return 0;
>  
>  out_fwhandle_free:
> diff --git a/include/linux/irqchip/arm-gic-common.h b/include/linux/irqchip/arm-gic-common.h
> index ef34f6f..c647b05 100644
> --- a/include/linux/irqchip/arm-gic-common.h
> +++ b/include/linux/irqchip/arm-gic-common.h
> @@ -15,6 +15,7 @@
>  
>  enum gic_type {
>  	GIC_V2,
> +	GIC_V3,
>  };
>  
>  struct gic_kvm_info {
> -- 
> 1.9.1
> 
