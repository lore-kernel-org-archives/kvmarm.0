From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v5 01/26] irqchip/gic-v3-its: Setup VLPI properties at
 map time
Date: Mon, 30 Oct 2017 07:46:33 +0100
Message-ID: <20171030064633.GM2166@lvm>
References: <20171027142855.21584-1-marc.zyngier@arm.com>
 <20171027142855.21584-2-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 71DAE49D28
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Oct 2017 02:45:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id U73D7dqZqR1M for <kvmarm@lists.cs.columbia.edu>;
 Mon, 30 Oct 2017 02:45:10 -0400 (EDT)
Received: from mail-lf0-f65.google.com (mail-lf0-f65.google.com
 [209.85.215.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 48BBB49D24
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Oct 2017 02:45:10 -0400 (EDT)
Received: by mail-lf0-f65.google.com with SMTP id 90so13643611lfs.13
 for <kvmarm@lists.cs.columbia.edu>; Sun, 29 Oct 2017 23:46:42 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20171027142855.21584-2-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvm@vger.kernel.org, Andre Przywara <Andre.Przywara@arm.com>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Oct 27, 2017 at 03:28:30PM +0100, Marc Zyngier wrote:
> So far, we require the hypervisor to update the VLPI properties
> once the the VLPI mapping has been established. While this
> makes it easy for the ITS driver, it creates a window where
> an incoming interrupt can be delivered with an unknown set
> of properties. Not very nice.
> 
> Instead, let's add a "properties" field to the mapping structure,
> and use that to configure the VLPI before it actually gets mapped.
> 

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>

> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  drivers/irqchip/irq-gic-v3-its.c   | 19 +++++++++++++++++--
>  include/linux/irqchip/arm-gic-v4.h |  2 ++
>  2 files changed, 19 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
> index 85f47ef4f1f7..2c4074c97454 100644
> --- a/drivers/irqchip/irq-gic-v3-its.c
> +++ b/drivers/irqchip/irq-gic-v3-its.c
> @@ -1006,9 +1006,15 @@ static void lpi_write_config(struct irq_data *d, u8 clr, u8 set)
>  	if (irqd_is_forwarded_to_vcpu(d)) {
>  		struct its_device *its_dev = irq_data_get_irq_chip_data(d);
>  		u32 event = its_get_event_id(d);
> +		struct its_vlpi_map *map;
>  
>  		prop_page = its_dev->event_map.vm->vprop_page;
> -		hwirq = its_dev->event_map.vlpi_maps[event].vintid;
> +		map = &its_dev->event_map.vlpi_maps[event];
> +		hwirq = map->vintid;
> +
> +		/* Remember the updated property */
> +		map->properties &= ~clr;
> +		map->properties |= set | LPI_PROP_GROUP1;
>  	} else {
>  		prop_page = gic_rdists->prop_page;
>  		hwirq = d->hwirq;
> @@ -1018,6 +1024,7 @@ static void lpi_write_config(struct irq_data *d, u8 clr, u8 set)
>  	*cfg &= ~clr;
>  	*cfg |= set | LPI_PROP_GROUP1;
>  
> +
>  	/*
>  	 * Make the above write visible to the redistributors.
>  	 * And yes, we're flushing exactly: One. Single. Byte.
> @@ -1238,12 +1245,20 @@ static int its_vlpi_map(struct irq_data *d, struct its_cmd_info *info)
>  		/* Ensure all the VPEs are mapped on this ITS */
>  		its_map_vm(its_dev->its, info->map->vm);
>  
> +		/*
> +		 * Flag the interrupt as forwarded so that we can
> +		 * start poking the virtual property table.
> +		 */
> +		irqd_set_forwarded_to_vcpu(d);
> +
> +		/* Write out the property to the prop table */
> +		lpi_write_config(d, 0xff, info->map->properties);
> +
>  		/* Drop the physical mapping */
>  		its_send_discard(its_dev, event);
>  
>  		/* and install the virtual one */
>  		its_send_vmapti(its_dev, event);
> -		irqd_set_forwarded_to_vcpu(d);
>  
>  		/* Increment the number of VLPIs */
>  		its_dev->event_map.nr_vlpis++;
> diff --git a/include/linux/irqchip/arm-gic-v4.h b/include/linux/irqchip/arm-gic-v4.h
> index 43cde15f221b..447da8ca2156 100644
> --- a/include/linux/irqchip/arm-gic-v4.h
> +++ b/include/linux/irqchip/arm-gic-v4.h
> @@ -71,12 +71,14 @@ struct its_vpe {
>   * @vm:		Pointer to the GICv4 notion of a VM
>   * @vpe:	Pointer to the GICv4 notion of a virtual CPU (VPE)
>   * @vintid:	Virtual LPI number
> + * @properties:	Priority and enable bits (as written in the prop table)
>   * @db_enabled:	Is the VPE doorbell to be generated?
>   */
>  struct its_vlpi_map {
>  	struct its_vm		*vm;
>  	struct its_vpe		*vpe;
>  	u32			vintid;
> +	u8			properties;
>  	bool			db_enabled;
>  };
>  
> -- 
> 2.11.0
> 
