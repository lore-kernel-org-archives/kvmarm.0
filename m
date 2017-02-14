From: Shanker Donthineni <shankerd@codeaurora.org>
Subject: Re: [RFC PATCH 24/33] irqchip/gic-v3-its: Add VPE scheduling
Date: Mon, 13 Feb 2017 18:13:23 -0600
Message-ID: <fffc9c09-47b3-2c40-4610-d266fee4f0fd@codeaurora.org>
References: <1484648454-21216-1-git-send-email-marc.zyngier@arm.com>
 <1484648454-21216-25-git-send-email-marc.zyngier@arm.com>
Reply-To: shankerd@codeaurora.org
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1484648454-21216-25-git-send-email-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,


On 01/17/2017 04:20 AM, Marc Zyngier wrote:
> When a VPE is scheduled to run, the corresponding redistributor must
> be told so, by setting VPROPBASER to the VM's property table, and
> VPENDBASER to the vcpu's pending table.
>
> When scheduled out, we preserve the IDAI and PendingLast bits. The
> latter is specially important, as it tells the hypervisor that
> there are pending interrupts for this vcpu.
>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>   drivers/irqchip/irq-gic-v3-its.c   | 57
> ++++++++++++++++++++++++++++++++++
>   include/linux/irqchip/arm-gic-v3.h | 63
> ++++++++++++++++++++++++++++++++++++++
>   2 files changed, 120 insertions(+)
>
> diff --git a/drivers/irqchip/irq-gic-v3-its.c
> b/drivers/irqchip/irq-gic-v3-its.c
> index 598e25b..f918d59 100644
> --- a/drivers/irqchip/irq-gic-v3-its.c
> +++ b/drivers/irqchip/irq-gic-v3-its.c
> @@ -143,6 +143,7 @@ static DEFINE_IDA(its_vpeid_ida);
>   
>   #define gic_data_rdist()		(raw_cpu_ptr(gic_rdists->rdist))
>   #define gic_data_rdist_rd_base()	(gic_data_rdist()->rd_base)
> +#define gic_data_rdist_vlpi_base()	(gic_data_rdist_rd_base() +
> SZ_128K)
>   
>   static struct its_collection *dev_event_to_col(struct its_device
> *its_dev,
>   					       u32 event)
> @@ -2039,8 +2040,64 @@ static const struct irq_domain_ops its_domain_ops =
> {
>   	.deactivate		= its_irq_domain_deactivate,
>   };
>   
> +static int its_vpe_set_vcpu_affinity(struct irq_data *d, void *vcpu_info)
> +{
> +	struct its_vpe *vpe = irq_data_get_irq_chip_data(d);
> +	struct its_cmd_info *info = vcpu_info;
> +	u64 val;
> +
> +	switch (info->cmd_type) {
> +	case SCHEDULE_VPE:
> +	{
> +		void * __iomem vlpi_base = gic_data_rdist_vlpi_base();
> +
> +		/* Schedule the VPE */
> +		val  = virt_to_phys(page_address(vpe->its_vm->vprop_page))
> &
> +			GENMASK_ULL(51, 12);
> +		val |= (LPI_NRBITS - 1) & GICR_VPROPBASER_IDBITS_MASK;
> +		val |= GICR_VPROPBASER_RaWb;
> +		val |= GICR_VPROPBASER_InnerShareable;
> +		gits_write_vpropbaser(val, vlpi_base + GICR_VPROPBASER);
> +
> +		val  = virt_to_phys(page_address(vpe->vpt_page)) &
> GENMASK(51, 16);
> +		val |= GICR_VPENDBASER_WaWb;
> +		val |= GICR_VPENDBASER_NonShareable;
> +		val |= GICR_PENDBASER_PendingLast;
Why always enabling PendingLast bit? You are keeping the pending last 
bit in vpe->pending_last but not used here.
> +		val |= vpe->idai ? GICR_PENDBASER_IDAI : 0;
> +		val |= GICR_PENDBASER_Valid;
What is the status of the virtual CPU interface (ICH_HCR_EL2.En) at the 
time of changing vPE state to resident? I believe the GICR will start 
processing a pending table immediately after setting V=1 and with valid 
PHYS address, GICR signals a virtual IRQ to virtual CPU if it has 
outstanding interrupts. With my understanding of GIC spec, a virtual CPU 
interface must be enabled before setting GICR_VPENDBASERR.Valid=1. 
Otherwise, it leads to flooded vSet and Release messages between GICR 
and CPU interface.

You can find Vset details in section 'A.4.18 VSet (IRI)' of GIC spec.

The CPU interface must Release an interrupt, ensuring that V == 1, if it 
cannot handle the interrupt for either of the
following reasons:
      The interrupt group is disabled. This includes when the VM 
interface is disabled, that is, when
GICH_HCR.En or ICH_HCR.En, as appropriate, is cleared to 0.

> +		gits_write_vpendbaser(val, vlpi_base + GICR_VPENDBASER);
> +
> +		return 0;
> +	}
> +
> +	case DESCHEDULE_VPE:
> +	{
> +		void * __iomem vlpi_base = gic_data_rdist_vlpi_base();
> +
> +		/* We're being scheduled out */
> +		val = gits_read_vpendbaser(vlpi_base + GICR_VPENDBASER);
> +		val &= ~GICR_PENDBASER_Valid;
> +		gits_write_vpendbaser(val, vlpi_base + GICR_VPENDBASER);
> +
> +		val = gits_read_vpendbaser(vlpi_base + GICR_VPENDBASER);
> +		while (val & GICR_PENDBASER_Dirty) {
> +			cpu_relax();
> +			val = gits_read_vpendbaser(vlpi_base +
> GICR_VPENDBASER);
> +		}
> +
> +		vpe->idai = !!(val & GICR_PENDBASER_IDAI);
> +		vpe->pending_last = !!(val & GICR_PENDBASER_PendingLast);
> +		return 0;
> +	}
> +
> +	default:
> +		return -EINVAL;
> +	}
> +}
> +
>   static struct irq_chip its_vpe_irq_chip = {
>   	.name			= "GICv4-vpe",
> +	.irq_set_vcpu_affinity	= its_vpe_set_vcpu_affinity,
>   };
>   
>   static int its_vpe_id_alloc(void)
> diff --git a/include/linux/irqchip/arm-gic-v3.h
> b/include/linux/irqchip/arm-gic-v3.h
> index 1b3a070..2789c9a 100644
> --- a/include/linux/irqchip/arm-gic-v3.h
> +++ b/include/linux/irqchip/arm-gic-v3.h
> @@ -209,6 +209,69 @@
>   #define LPI_PROP_ENABLED		(1 << 0)
>   
>   /*
> + * Re-Distributor registers, offsets from VLPI_base
> + */
> +#define GICR_VPROPBASER			0x0070
> +
> +#define GICR_VPROPBASER_IDBITS_MASK	0x1f
> +
> +#define GICR_VPROPBASER_SHAREABILITY_SHIFT		(10)
> +#define GICR_VPROPBASER_INNER_CACHEABILITY_SHIFT	(7)
> +#define GICR_VPROPBASER_OUTER_CACHEABILITY_SHIFT	(56)
> +
> +#define GICR_VPROPBASER_SHAREABILITY_MASK				\
> +	GIC_BASER_SHAREABILITY(GICR_VPROPBASER, SHAREABILITY_MASK)
> +#define GICR_VPROPBASER_INNER_CACHEABILITY_MASK
> \
> +	GIC_BASER_CACHEABILITY(GICR_VPROPBASER, INNER, MASK)
> +#define GICR_VPROPBASER_OUTER_CACHEABILITY_MASK
> \
> +	GIC_BASER_CACHEABILITY(GICR_VPROPBASER, OUTER, MASK)
> +#define GICR_VPROPBASER_CACHEABILITY_MASK				\
> +	GICR_VPROPBASER_INNER_CACHEABILITY_MASK
> +
> +#define GICR_VPROPBASER_InnerShareable					\
> +	GIC_BASER_SHAREABILITY(GICR_VPROPBASER, InnerShareable)
> +
> +#define GICR_VPROPBASER_nCnB	GIC_BASER_CACHEABILITY(GICR_VPROPBASER,
> INNER, nCnB)
> +#define GICR_VPROPBASER_nC 	GIC_BASER_CACHEABILITY(GICR_VPROPBASER,
> INNER, nC)
> +#define GICR_VPROPBASER_RaWt	GIC_BASER_CACHEABILITY(GICR_VPROPBASER,
> INNER, RaWt)
> +#define GICR_VPROPBASER_RaWb	GIC_BASER_CACHEABILITY(GICR_VPROPBASER,
> INNER, RaWt)
> +#define GICR_VPROPBASER_WaWt	GIC_BASER_CACHEABILITY(GICR_VPROPBASER,
> INNER, WaWt)
> +#define GICR_VPROPBASER_WaWb	GIC_BASER_CACHEABILITY(GICR_VPROPBASER,
> INNER, WaWb)
> +#define GICR_VPROPBASER_RaWaWt	GIC_BASER_CACHEABILITY(GICR_VPROPBASER,
> INNER, RaWaWt)
> +#define GICR_VPROPBASER_RaWaWb	GIC_BASER_CACHEABILITY(GICR_VPROPBASER,
> INNER, RaWaWb)
> +
> +#define GICR_VPENDBASER			0x0078
> +
> +#define GICR_VPENDBASER_SHAREABILITY_SHIFT		(10)
> +#define GICR_VPENDBASER_INNER_CACHEABILITY_SHIFT	(7)
> +#define GICR_VPENDBASER_OUTER_CACHEABILITY_SHIFT	(56)
> +#define GICR_VPENDBASER_SHAREABILITY_MASK				\
> +	GIC_BASER_SHAREABILITY(GICR_VPENDBASER, SHAREABILITY_MASK)
> +#define GICR_VPENDBASER_INNER_CACHEABILITY_MASK
> \
> +	GIC_BASER_CACHEABILITY(GICR_VPENDBASER, INNER, MASK)
> +#define GICR_VPENDBASER_OUTER_CACHEABILITY_MASK
> \
> +	GIC_BASER_CACHEABILITY(GICR_VPENDBASER, OUTER, MASK)
> +#define GICR_VPENDBASER_CACHEABILITY_MASK				\
> +	GICR_VPENDBASER_INNER_CACHEABILITY_MASK
> +
> +#define GICR_VPENDBASER_NonShareable					\
> +	GIC_BASER_SHAREABILITY(GICR_VPENDBASER, NonShareable)
> +
> +#define GICR_VPENDBASER_nCnB	GIC_BASER_CACHEABILITY(GICR_VPENDBASER,
> INNER, nCnB)
> +#define GICR_VPENDBASER_nC 	GIC_BASER_CACHEABILITY(GICR_VPENDBASER,
> INNER, nC)
> +#define GICR_VPENDBASER_RaWt	GIC_BASER_CACHEABILITY(GICR_VPENDBASER,
> INNER, RaWt)
> +#define GICR_VPENDBASER_RaWb	GIC_BASER_CACHEABILITY(GICR_VPENDBASER,
> INNER, RaWt)
> +#define GICR_VPENDBASER_WaWt	GIC_BASER_CACHEABILITY(GICR_VPENDBASER,
> INNER, WaWt)
> +#define GICR_VPENDBASER_WaWb	GIC_BASER_CACHEABILITY(GICR_VPENDBASER,
> INNER, WaWb)
> +#define GICR_VPENDBASER_RaWaWt	GIC_BASER_CACHEABILITY(GICR_VPENDBASER,
> INNER, RaWaWt)
> +#define GICR_VPENDBASER_RaWaWb	GIC_BASER_CACHEABILITY(GICR_VPENDBASER,
> INNER, RaWaWb)
> +
> +#define GICR_PENDBASER_Dirty		(1ULL << 60)
> +#define GICR_PENDBASER_PendingLast	(1ULL << 61)
> +#define GICR_PENDBASER_IDAI		(1ULL << 62)
> +#define GICR_PENDBASER_Valid		(1ULL << 63)
> +
> +/*
>    * ITS registers, offsets from ITS_base
>    */
>   #define GITS_CTLR			0x0000

-- 
Shanker Donthineni
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project.
