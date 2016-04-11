From: Hanjun Guo <hanjun.guo@linaro.org>
Subject: Re: [PATCH v5 5/9] irqchip/gic-v3: Gather all ACPI specific data in a
 single structure
Date: Mon, 11 Apr 2016 13:21:40 +0800
Message-ID: <570B3464.4070905@linaro.org>
References: <1459769860-6629-1-git-send-email-julien.grall@arm.com>
 <1459769860-6629-6-git-send-email-julien.grall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1A58640C9A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Apr 2016 01:20:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0WYme2SJ3-wr for <kvmarm@lists.cs.columbia.edu>;
 Mon, 11 Apr 2016 01:20:14 -0400 (EDT)
Received: from mail-pf0-f169.google.com (mail-pf0-f169.google.com
 [209.85.192.169])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C715A4011D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Apr 2016 01:20:13 -0400 (EDT)
Received: by mail-pf0-f169.google.com with SMTP id 184so116991177pff.0
 for <kvmarm@lists.cs.columbia.edu>; Sun, 10 Apr 2016 22:21:48 -0700 (PDT)
In-Reply-To: <1459769860-6629-6-git-send-email-julien.grall@arm.com>
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

+cc Tomasz,

On 2016/4/4 19:37, Julien Grall wrote:
> The ACPI code requires to use global variales in order to collect
> information from the tables.
>
> To make clear those variables are ACPI specific, gather all of them in a
> single structure.
>
> Furthermore, even if some of the variables are not marked with
> __initdata, they are all only used during the initialization. Therefore,
> the new variable, which hold the structure, can be marked with
> __initdata.
>
> Signed-off-by: Julien Grall <julien.grall@arm.com>
>
> ---
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Jason Cooper <jason@lakedaemon.net>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
>
>      Changes in v4:
>          - Rework commit message
>
>      Changes in v3:
>          - Patch added
> ---
>   drivers/irqchip/irq-gic-v3.c | 60 ++++++++++++++++++++++++--------------------
>   1 file changed, 33 insertions(+), 27 deletions(-)
>
> diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
> index 5b7d3c2..50e87e6 100644
> --- a/drivers/irqchip/irq-gic-v3.c
> +++ b/drivers/irqchip/irq-gic-v3.c
> @@ -968,19 +968,22 @@ out_unmap_dist:
>   IRQCHIP_DECLARE(gic_v3, "arm,gic-v3", gic_of_init);
>
>   #ifdef CONFIG_ACPI
> -static void __iomem *dist_base;
> -static struct redist_region *redist_regs __initdata;
> -static u32 nr_redist_regions __initdata;
> -static bool single_redist;
> +static struct
> +{
> +	void __iomem *dist_base;
> +	struct redist_region *redist_regs;
> +	u32 nr_redist_regions;
> +	bool single_redist;
> +} acpi_data __initdata;
>
>   static void __init
>   gic_acpi_register_redist(phys_addr_t phys_base, void __iomem *redist_base)
>   {
>   	static int count = 0;
>
> -	redist_regs[count].phys_base = phys_base;
> -	redist_regs[count].redist_base = redist_base;
> -	redist_regs[count].single_redist = single_redist;
> +	acpi_data.redist_regs[count].phys_base = phys_base;
> +	acpi_data.redist_regs[count].redist_base = redist_base;
> +	acpi_data.redist_regs[count].single_redist = acpi_data.single_redist;
>   	count++;
>   }
>
> @@ -1008,7 +1011,7 @@ gic_acpi_parse_madt_gicc(struct acpi_subtable_header *header,
>   {
>   	struct acpi_madt_generic_interrupt *gicc =
>   				(struct acpi_madt_generic_interrupt *)header;
> -	u32 reg = readl_relaxed(dist_base + GICD_PIDR2) & GIC_PIDR2_ARCH_MASK;
> +	u32 reg = readl_relaxed(acpi_data.dist_base + GICD_PIDR2) & GIC_PIDR2_ARCH_MASK;
>   	u32 size = reg == GIC_PIDR2_ARCH_GICv4 ? SZ_64K * 4 : SZ_64K * 2;
>   	void __iomem *redist_base;
>
> @@ -1025,7 +1028,7 @@ static int __init gic_acpi_collect_gicr_base(void)
>   	acpi_tbl_entry_handler redist_parser;
>   	enum acpi_madt_type type;
>
> -	if (single_redist) {
> +	if (acpi_data.single_redist) {
>   		type = ACPI_MADT_TYPE_GENERIC_INTERRUPT;
>   		redist_parser = gic_acpi_parse_madt_gicc;
>   	} else {
> @@ -1076,14 +1079,14 @@ static int __init gic_acpi_count_gicr_regions(void)
>   	count = acpi_table_parse_madt(ACPI_MADT_TYPE_GENERIC_REDISTRIBUTOR,
>   				      gic_acpi_match_gicr, 0);
>   	if (count > 0) {
> -		single_redist = false;
> +		acpi_data.single_redist = false;
>   		return count;
>   	}
>
>   	count = acpi_table_parse_madt(ACPI_MADT_TYPE_GENERIC_INTERRUPT,
>   				      gic_acpi_match_gicc, 0);
>   	if (count > 0)
> -		single_redist = true;
> +		acpi_data.single_redist = true;
>
>   	return count;
>   }
> @@ -1103,7 +1106,7 @@ static bool __init acpi_validate_gic_table(struct acpi_subtable_header *header,
>   	if (count <= 0)
>   		return false;
>
> -	nr_redist_regions = count;
> +	acpi_data.nr_redist_regions = count;
>   	return true;
>   }
>
> @@ -1114,25 +1117,28 @@ gic_acpi_init(struct acpi_subtable_header *header, const unsigned long end)
>   {
>   	struct acpi_madt_generic_distributor *dist;
>   	struct fwnode_handle *domain_handle;
> +	size_t size;
>   	int i, err;
>
>   	/* Get distributor base address */
>   	dist = (struct acpi_madt_generic_distributor *)header;
> -	dist_base = ioremap(dist->base_address, ACPI_GICV3_DIST_MEM_SIZE);
> -	if (!dist_base) {
> +	acpi_data.dist_base = ioremap(dist->base_address,
> +				      ACPI_GICV3_DIST_MEM_SIZE);
> +	if (!acpi_data.dist_base) {
>   		pr_err("Unable to map GICD registers\n");
>   		return -ENOMEM;
>   	}
>
> -	err = gic_validate_dist_version(dist_base);
> +	err = gic_validate_dist_version(acpi_data.dist_base);
>   	if (err) {
> -		pr_err("No distributor detected at @%p, giving up", dist_base);
> +		pr_err("No distributor detected at @%p, giving up",
> +		       acpi_data.dist_base);
>   		goto out_dist_unmap;
>   	}
>
> -	redist_regs = kzalloc(sizeof(*redist_regs) * nr_redist_regions,
> -			      GFP_KERNEL);
> -	if (!redist_regs) {
> +	size = sizeof(*acpi_data.redist_regs) * acpi_data.nr_redist_regions;
> +	acpi_data.redist_regs = kzalloc(size, GFP_KERNEL);
> +	if (!acpi_data.redist_regs) {
>   		err = -ENOMEM;
>   		goto out_dist_unmap;
>   	}
> @@ -1141,14 +1147,14 @@ gic_acpi_init(struct acpi_subtable_header *header, const unsigned long end)
>   	if (err)
>   		goto out_redist_unmap;
>
> -	domain_handle = irq_domain_alloc_fwnode(dist_base);
> +	domain_handle = irq_domain_alloc_fwnode(acpi_data.dist_base);
>   	if (!domain_handle) {
>   		err = -ENOMEM;
>   		goto out_redist_unmap;
>   	}
>
> -	err = gic_init_bases(dist_base, redist_regs, nr_redist_regions, 0,
> -			     domain_handle);
> +	err = gic_init_bases(acpi_data.dist_base, acpi_data.redist_regs,
> +			     acpi_data.nr_redist_regions, 0, domain_handle);
>   	if (err)
>   		goto out_fwhandle_free;
>
> @@ -1158,12 +1164,12 @@ gic_acpi_init(struct acpi_subtable_header *header, const unsigned long end)
>   out_fwhandle_free:
>   	irq_domain_free_fwnode(domain_handle);
>   out_redist_unmap:
> -	for (i = 0; i < nr_redist_regions; i++)
> -		if (redist_regs[i].redist_base)
> -			iounmap(redist_regs[i].redist_base);
> -	kfree(redist_regs);
> +	for (i = 0; i < acpi_data.nr_redist_regions; i++)
> +		if (acpi_data.redist_regs[i].redist_base)
> +			iounmap(acpi_data.redist_regs[i].redist_base);
> +	kfree(acpi_data.redist_regs);
>   out_dist_unmap:
> -	iounmap(dist_base);
> +	iounmap(acpi_data.dist_base);
>   	return err;
>   }
>   IRQCHIP_ACPI_DECLARE(gic_v3, ACPI_MADT_TYPE_GENERIC_DISTRIBUTOR,

I'm fine with it,

Reviewed-by: Hanjun Guo <hanjun.guo@linaro.org>

I think you also need Marc and Tomasz's review.

Thanks
Hanjun
