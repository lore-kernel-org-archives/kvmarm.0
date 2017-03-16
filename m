From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [RFC PATCH 17/33] irqchip/gic-v3-its: Add VLPI configuration hook
Date: Thu, 16 Mar 2017 09:59:01 +0100
Message-ID: <fb06cd69-7a5d-0615-89ab-abe861ab4045@redhat.com>
References: <1484648454-21216-1-git-send-email-marc.zyngier@arm.com>
 <1484648454-21216-18-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 164E840190
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Mar 2017 04:57:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BS5EUleUAtYU for <kvmarm@lists.cs.columbia.edu>;
 Thu, 16 Mar 2017 04:57:28 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 26DBB40187
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Mar 2017 04:57:28 -0400 (EDT)
In-Reply-To: <1484648454-21216-18-git-send-email-marc.zyngier@arm.com>
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
> Add the skeleton irq_set_vcpu_affinity method that will be used
> to configure VLPIs.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric

> ---
>  drivers/irqchip/irq-gic-v3-its.c | 33 +++++++++++++++++++++++++++++++++
>  1 file changed, 33 insertions(+)
> 
> diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
> index 0dbc8b0..1bd78ca 100644
> --- a/drivers/irqchip/irq-gic-v3-its.c
> +++ b/drivers/irqchip/irq-gic-v3-its.c
> @@ -36,6 +36,7 @@
>  
>  #include <linux/irqchip.h>
>  #include <linux/irqchip/arm-gic-v3.h>
> +#include <linux/irqchip/arm-gic-v4.h>
>  
>  #include <asm/cputype.h>
>  #include <asm/exception.h>
> @@ -771,6 +772,37 @@ static int its_irq_set_irqchip_state(struct irq_data *d,
>  	return 0;
>  }
>  
> +static int its_irq_set_vcpu_affinity(struct irq_data *d, void *vcpu_info)
> +{
> +	struct its_device *its_dev = irq_data_get_irq_chip_data(d);
> +	struct its_cmd_info *info = vcpu_info;
> +	u32 event = its_get_event_id(d);
> +
> +	/* Need a v4 ITS */
> +	if (!its_dev->its->is_v4 || !info)
> +		return -EINVAL;
> +
> +	switch (info->cmd_type) {
> +	case MAP_VLPI:
> +	{
> +		return 0;
> +	}
> +
> +	case UNMAP_VLPI:
> +	{
> +		return 0;
> +	}
> +
> +	case PROP_UPDATE_VLPI:
> +	{
> +		return 0;
> +	}
> +
> +	default:
> +		return -EINVAL;
> +	}
> +}
> +
>  static struct irq_chip its_irq_chip = {
>  	.name			= "ITS",
>  	.irq_mask		= its_mask_irq,
> @@ -779,6 +811,7 @@ static struct irq_chip its_irq_chip = {
>  	.irq_set_affinity	= its_set_affinity,
>  	.irq_compose_msi_msg	= its_irq_compose_msi_msg,
>  	.irq_set_irqchip_state	= its_irq_set_irqchip_state,
> +	.irq_set_vcpu_affinity	= its_irq_set_vcpu_affinity,
>  };
>  
>  /*
> 
