From: Shanker Donthineni <shankerd@codeaurora.org>
Subject: Re: [RFC PATCH 21/33] irqchip/gic-v3-its: Add VPE irq domain
 allocation/teardown
Date: Mon, 13 Feb 2017 17:25:43 -0600
Message-ID: <96d57024-4fe9-c738-190e-80ea2d40c5bf@codeaurora.org>
References: <1484648454-21216-1-git-send-email-marc.zyngier@arm.com>
 <1484648454-21216-22-git-send-email-marc.zyngier@arm.com>
Reply-To: shankerd@codeaurora.org
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1484648454-21216-22-git-send-email-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,


On 01/17/2017 04:20 AM, Marc Zyngier wrote:
> When creating a VM, the low level GICv4 code is responsible for:
> - allocating each VPE a unique VPEID
> - allocating a doorbell interrupt for each VPE
> - allocating the pending tables for each VPE
> - allocating the property table for the VM
>
> This of course has to be reversed when the VM is brought down.
>
> All of this is wired into the irq domain alloc/free methods.
>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>   drivers/irqchip/irq-gic-v3-its.c | 174
> +++++++++++++++++++++++++++++++++++++++
>   1 file changed, 174 insertions(+)
>
> diff --git a/drivers/irqchip/irq-gic-v3-its.c
> b/drivers/irqchip/irq-gic-v3-its.c
> index ddd8096..54d0075 100644
> --- a/drivers/irqchip/irq-gic-v3-its.c
> +++ b/drivers/irqchip/irq-gic-v3-its.c
> @@ -139,6 +139,7 @@ static struct rdists *gic_rdists;
>   static struct irq_domain *its_parent;
>   
>   static unsigned long its_list_map;
> +static DEFINE_IDA(its_vpeid_ida);
>   
>   #define gic_data_rdist()		(raw_cpu_ptr(gic_rdists->rdist))
>   #define gic_data_rdist_rd_base()	(gic_data_rdist()->rd_base)
> @@ -1146,6 +1147,11 @@ static struct page *its_allocate_prop_table(gfp_t
> gfp_flags)
>   	return prop_page;
>   }
>   
> +static void its_free_prop_table(struct page *prop_page)
> +{
> +	free_pages((unsigned long)page_address(prop_page),
> +		   get_order(LPI_PROPBASE_SZ));
> +}
>   
>   static int __init its_alloc_lpi_tables(void)
>   {
> @@ -1444,6 +1450,12 @@ static struct page
> *its_allocate_pending_table(gfp_t gfp_flags)
>   	return pend_page;
>   }
>   
> +static void its_free_pending_table(struct page *pt)
> +{
> +	free_pages((unsigned long)page_address(pt),
> +		   get_order(max(LPI_PENDBASE_SZ, SZ_64K)));
> +}
> +
>   static void its_cpu_init_lpis(void)
>   {
>   	void __iomem *rbase = gic_data_rdist_rd_base();
> @@ -1666,6 +1678,34 @@ static bool its_alloc_device_table(struct its_node
> *its, u32 dev_id)
>   	return its_alloc_table_entry(baser, dev_id);
>   }
>   
> +static bool its_alloc_vpe_table(u32 vpe_id)
> +{
> +	struct its_node *its;
> +
> +	/*
> +	 * Make sure the L2 tables are allocated on *all* v4 ITSs. We
> +	 * could try and only do it on ITSs corresponding to devices
> +	 * that have interrupts targeted at this VPE, but the
> +	 * complexity becomes crazy (and you have tons of memory
> +	 * anyway, right?).
> +	 */
> +	list_for_each_entry(its, &its_nodes, entry) {
> +		struct its_baser *baser;
> +
> +		if (!its->is_v4)
> +			continue;
> +
> +		baser = its_get_baser(its, GITS_BASER_TYPE_VCPU);
> +		if (!baser)
> +			return false;
> +
> +		if (!its_alloc_table_entry(baser, vpe_id))
> +			return false;
> +	}
> +
> +	return true;
> +}
> +
>   static struct its_device *its_create_device(struct its_node *its, u32
> dev_id,
>   					    int nvecs)
>   {
> @@ -1922,7 +1962,141 @@ static struct irq_chip its_vpe_irq_chip = {
>   	.name			= "GICv4-vpe",
>   };
>   
> +static int its_vpe_id_alloc(void)
> +{
> +	return ida_simple_get(&its_vpeid_ida, 0, 1 << 16, GFP_KERNEL);
> +}
> +
> +static void its_vpe_id_free(u16 id)
> +{
> +	ida_simple_remove(&its_vpeid_ida, id);
> +}
> +
> +static int its_vpe_init(struct its_vpe *vpe)
> +{
> +	struct page *vpt_page;
> +	int vpe_id;
> +
> +	/* Allocate vpe_id */
> +	vpe_id = its_vpe_id_alloc();
> +	if (vpe_id < 0)
> +		return vpe_id;
> +
> +	/* Allocate VPT */
> +	vpt_page = its_allocate_pending_table(GFP_KERNEL);
> +	if (vpt_page) {


Change to 'if (!vpt_page)'.


-- 
Shanker Donthineni
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project.
