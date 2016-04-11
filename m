From: Hanjun Guo <hanjun.guo@linaro.org>
Subject: Re: [PATCH v5 6/9] irqchip/gic-v3: Parse and export virtual GIC
 information
Date: Mon, 11 Apr 2016 13:27:54 +0800
Message-ID: <570B35DA.5050600@linaro.org>
References: <1459769860-6629-1-git-send-email-julien.grall@arm.com>
 <1459769860-6629-7-git-send-email-julien.grall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C414840C9A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Apr 2016 01:26:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Yjdm1+W71ue5 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 11 Apr 2016 01:26:29 -0400 (EDT)
Received: from mail-pa0-f43.google.com (mail-pa0-f43.google.com
 [209.85.220.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7624E4011D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Apr 2016 01:26:29 -0400 (EDT)
Received: by mail-pa0-f43.google.com with SMTP id bx7so98389494pad.3
 for <kvmarm@lists.cs.columbia.edu>; Sun, 10 Apr 2016 22:28:03 -0700 (PDT)
In-Reply-To: <1459769860-6629-7-git-send-email-julien.grall@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Julien Grall <julien.grall@arm.com>, kvmarm@lists.cs.columbia.edu
Cc: al.stone@linaro.org, kvm@vger.kernel.org, marc.zyngier@arm.com, linux-kernel@vger.kernel.org, fu.wei@linaro.org, Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>, linux-arm-kernel@lists.infradead.org, gg@slimlogic.co.uk
List-Id: kvmarm@lists.cs.columbia.edu

On 2016/4/4 19:37, Julien Grall wrote:
> Fill up the recently introduced gic_kvm_info with the hardware
> information used for virtualization.
>
> Signed-off-by: Julien Grall <julien.grall@arm.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Jason Cooper <jason@lakedaemon.net>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
>
> ---
>      Changes in v5:
>          - Remove the alignment check for GICV. It's already done in the
>          KVM code.
>          - Fix initialization of KVM with ACPI.
>
>      Changes in v4:
>          - Change the flow to call gic_kvm_set_info only when all the
>          mandatory information are valid.
>          - Remove unecessary code in ACPI parsing (the virtual control
>          interface doesn't exist for GICv3).
>          - Rework commit message
>          - Rework the ACPI support as it didn't collect hardware info for
>          virtualization when there is more than 1 redistributor region
>
>      Changes in v3:
>          - Add ACPI support
>
>      Changes in v2:
>          - Use 0 rather than a negative value to know when the maintenance IRQ
>          is not present.
>          - Use resource for vcpu and vctrl
> ---
>   drivers/irqchip/irq-gic-v3.c           | 110 ++++++++++++++++++++++++++++++++-
>   include/linux/irqchip/arm-gic-common.h |   1 +
>   2 files changed, 110 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
> index 50e87e6..08afbfe 100644
> --- a/drivers/irqchip/irq-gic-v3.c
> +++ b/drivers/irqchip/irq-gic-v3.c
> @@ -28,6 +28,7 @@
>   #include <linux/slab.h>
>
>   #include <linux/irqchip.h>
> +#include <linux/irqchip/arm-gic-common.h>
>   #include <linux/irqchip/arm-gic-v3.h>
>
>   #include <asm/cputype.h>
> @@ -56,6 +57,8 @@ struct gic_chip_data {
>   static struct gic_chip_data gic_data __read_mostly;
>   static struct static_key supports_deactivate = STATIC_KEY_INIT_TRUE;
>
> +static struct gic_kvm_info gic_v3_kvm_info;
> +
>   #define gic_data_rdist()		(this_cpu_ptr(gic_data.rdists.rdist))
>   #define gic_data_rdist_rd_base()	(gic_data_rdist()->rd_base)
>   #define gic_data_rdist_sgi_base()	(gic_data_rdist_rd_base() + SZ_64K)
> @@ -901,6 +904,30 @@ static int __init gic_validate_dist_version(void __iomem *dist_base)
>   	return 0;
>   }
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
> +	if (!ret)
> +		gic_v3_kvm_info.vcpu = r;
> +
> +	gic_set_kvm_info(&gic_v3_kvm_info);
> +}
> +
>   static int __init gic_of_init(struct device_node *node, struct device_node *parent)
>   {
>   	void __iomem *dist_base;
> @@ -952,8 +979,10 @@ static int __init gic_of_init(struct device_node *node, struct device_node *pare
>
>   	err = gic_init_bases(dist_base, rdist_regs, nr_redist_regions,
>   			     redist_stride, &node->fwnode);
> -	if (!err)
> +	if (!err) {
> +		gic_of_setup_kvm_info(node);
>   		return 0;
> +	}
>
>   out_unmap_rdist:
>   	for (i = 0; i < nr_redist_regions; i++)
> @@ -974,6 +1003,9 @@ static struct
>   	struct redist_region *redist_regs;
>   	u32 nr_redist_regions;
>   	bool single_redist;
> +	u32 maint_irq;
> +	int maint_irq_mode;
> +	phys_addr_t vcpu_base;
>   } acpi_data __initdata;
>
>   static void __init
> @@ -1110,7 +1142,81 @@ static bool __init acpi_validate_gic_table(struct acpi_subtable_header *header,
>   	return true;
>   }
>
> +static int __init gic_acpi_parse_virt_madt_gicc(struct acpi_subtable_header *header,
> +						const unsigned long end)
> +{
> +	struct acpi_madt_generic_interrupt *gicc =
> +		(struct acpi_madt_generic_interrupt *)header;
> +	int maint_irq_mode;
> +	static int first_madt = true;
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
> +	return (count > 0);
> +}
> +
>   #define ACPI_GICV3_DIST_MEM_SIZE (SZ_64K)
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

Sorry, I'm not familiar with KVM, but I got a question here, will
KVM works without valid vcpu_base in GICv3 mode?

Thanks
Hanjun
