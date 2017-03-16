From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [RFC PATCH 19/33] irqchip/gic-v3-its: Add VLPI configuration
 handling
Date: Thu, 16 Mar 2017 09:59:33 +0100
Message-ID: <b459a98c-e2bc-d338-82c0-08bd06060e92@redhat.com>
References: <1484648454-21216-1-git-send-email-marc.zyngier@arm.com>
 <1484648454-21216-20-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C58B408EB
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Mar 2017 04:58:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3vviu3mL4S2d for <kvmarm@lists.cs.columbia.edu>;
 Thu, 16 Mar 2017 04:57:59 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B037B40905
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Mar 2017 04:57:59 -0400 (EDT)
In-Reply-To: <1484648454-21216-20-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 17/01/2017 11:20, Marc Zyngier wrote:
> When a VLPI is reconfigured (enabled, disabled, change in priority),
> the full configuration byte must be written, and the caches invalidated.
> 
> Also, when using the irq_mask/irq_unmask methods, it is necessary
> to disable the doorbell for that particular interrupt (by mapping it
> to 1023) on top of clearing the Enable bit.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

> ---
>  drivers/irqchip/irq-gic-v3-its.c | 37 +++++++++++++++++++++++++++++++++++--
>  1 file changed, 35 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
> index d50a019..6931018 100644
> --- a/drivers/irqchip/irq-gic-v3-its.c
> +++ b/drivers/irqchip/irq-gic-v3-its.c
> @@ -796,11 +796,18 @@ static inline u32 its_get_event_id(struct irq_data *d)
>  static void lpi_update_config(struct irq_data *d, u8 clr, u8 set)
>  {
>  	struct its_device *its_dev = irq_data_get_irq_chip_data(d);
> -	irq_hw_number_t hwirq = d->hwirq;
> +	irq_hw_number_t hwirq;
>  	struct page *prop_page;
>  	u8 *cfg;
>  
> -	prop_page = gic_rdists->prop_page;
> +	if (irqd_is_forwarded_to_vcpu(d)) {
> +		u32 event = its_get_event_id(d);
> +		prop_page = its_dev->event_map.vlpi_map->vpes[0]->its_vm->vprop_page;
> +		hwirq = its_dev->event_map.vlpi_map->vlpis[event].vintid;
> +	} else {
> +		prop_page = gic_rdists->prop_page;
> +		hwirq = d->hwirq;
> +	}
>  
>  	cfg = page_address(prop_page) + hwirq - 8192;
>  	*cfg &= ~clr;
> @@ -818,13 +825,28 @@ static void lpi_update_config(struct irq_data *d, u8 clr, u8 set)
>  	its_send_inv(its_dev, its_get_event_id(d));
>  }
>  
> +static void its_vlpi_set_doorbell(struct irq_data *d, bool enable)
> +{
> +	struct its_device *its_dev = irq_data_get_irq_chip_data(d);
> +	u32 event = its_get_event_id(d);
> +
> +	its_dev->event_map.vlpi_map->vlpis[event].db_enabled = enable;
> +	its_send_vmapti(its_dev, event);
> +}
> +
>  static void its_mask_irq(struct irq_data *d)
>  {
> +	if (irqd_is_forwarded_to_vcpu(d))
> +		its_vlpi_set_doorbell(d, false);
> +
>  	lpi_update_config(d, LPI_PROP_ENABLED, 0);
>  }
>  
>  static void its_unmask_irq(struct irq_data *d)
>  {
> +	if (irqd_is_forwarded_to_vcpu(d))
> +		its_vlpi_set_doorbell(d, true);
> +
>  	lpi_update_config(d, 0, LPI_PROP_ENABLED);
>  }
>  
> @@ -837,6 +859,10 @@ static int its_set_affinity(struct irq_data *d, const struct cpumask *mask_val,
>  	struct its_collection *target_col;
>  	u32 id = its_get_event_id(d);
>  
> +	/* A forwarded interrupt should use irq_set_vcpu_affinity */
> +	if (irqd_is_forwarded_to_vcpu(d))
> +		return -EINVAL;
> +
>         /* lpi cannot be routed to a redistributor that is on a foreign node */
>  	if (its_dev->its->flags & ITS_FLAGS_WORKAROUND_CAVIUM_23144) {
>  		if (its_dev->its->numa_node >= 0) {
> @@ -969,6 +995,13 @@ static int its_irq_set_vcpu_affinity(struct irq_data *d, void *vcpu_info)
>  
>  	case PROP_UPDATE_VLPI:
>  	{
> +		if (!its_dev->event_map.vlpi_map ||
> +		    !irqd_is_forwarded_to_vcpu(d))
> +			return -EINVAL;
> +
> +		lpi_update_config(d, 0xff, info->config);
> +		its_vlpi_set_doorbell(d, !!(info->config & LPI_PROP_ENABLED));
> +
>  		return 0;
>  	}
>  
> 
