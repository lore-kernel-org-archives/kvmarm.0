From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [RFC PATCH 31/33] irqchip/gic-v4: Add VLPI configuration interface
Date: Thu, 16 Mar 2017 22:08:06 +0100
Message-ID: <6300fefc-9dc5-88f0-2de1-0d5ba7fac20e@redhat.com>
References: <1484648454-21216-1-git-send-email-marc.zyngier@arm.com>
 <1484648454-21216-32-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 599A040BC5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Mar 2017 17:06:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id X+M2Wt46C9UH for <kvmarm@lists.cs.columbia.edu>;
 Thu, 16 Mar 2017 17:06:33 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5BA5840BC4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Mar 2017 17:06:32 -0400 (EDT)
In-Reply-To: <1484648454-21216-32-git-send-email-marc.zyngier@arm.com>
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
> Add the required interfaces to map, unmap and update a VLPI.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric

> ---
>  drivers/irqchip/irq-gic-v4.c       | 29 +++++++++++++++++++++++++++++
>  include/linux/irqchip/arm-gic-v4.h |  3 +++
>  2 files changed, 32 insertions(+)
> 
> diff --git a/drivers/irqchip/irq-gic-v4.c b/drivers/irqchip/irq-gic-v4.c
> index 7d74089..36ccaac 100644
> --- a/drivers/irqchip/irq-gic-v4.c
> +++ b/drivers/irqchip/irq-gic-v4.c
> @@ -140,3 +140,32 @@ int its_invall_vpe(struct its_vpe *vpe)
>  
>  	return its_send_vpe_cmd(vpe, &info);
>  }
> +
> +int its_map_vlpi(int irq, struct its_vlpi_map *map)
> +{
> +	struct its_cmd_info info = {
> +		.cmd_type = MAP_VLPI,
> +		.map      = map,
> +	};
> +
> +	return irq_set_vcpu_affinity(irq, &info);
> +}
> +
> +int its_unmap_vlpi(int irq)
> +{
> +	struct its_cmd_info info = {
> +		.cmd_type = UNMAP_VLPI,
> +	};
> +
> +	return irq_set_vcpu_affinity(irq, &info);
> +}
> +
> +int its_prop_update_vlpi(int irq, u8 config)
> +{
> +	struct its_cmd_info info = {
> +		.cmd_type = PROP_UPDATE_VLPI,
> +		.config   = config,
> +	};
> +
> +	return irq_set_vcpu_affinity(irq, &info);
> +}
> diff --git a/include/linux/irqchip/arm-gic-v4.h b/include/linux/irqchip/arm-gic-v4.h
> index 1c58add..f85a929 100644
> --- a/include/linux/irqchip/arm-gic-v4.h
> +++ b/include/linux/irqchip/arm-gic-v4.h
> @@ -93,5 +93,8 @@ int its_alloc_vcpu_irqs(struct its_vm *vm, struct its_vpe **vpes, int nr_vpes);
>  void its_free_vcpu_irqs(struct its_vm *vm, int nr_vpes);
>  int its_schedule_vpe(struct its_vpe *vpe, bool on);
>  int its_invall_vpe(struct its_vpe *vpe);
> +int its_map_vlpi(int irq, struct its_vlpi_map *map);
> +int its_unmap_vlpi(int irq);
> +int its_prop_update_vlpi(int irq, u8 config);
>  
>  #endif
> 
