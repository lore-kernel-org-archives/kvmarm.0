From: Shanker Donthineni <shankerd@codeaurora.org>
Subject: Re: [RFC PATCH 17/33] irqchip/gic-v3-its: Add VLPI configuration hook
Date: Mon, 13 Feb 2017 17:07:18 -0600
Message-ID: <a5783b6c-8276-0bc3-227d-7bf74465dae8@codeaurora.org>
References: <1484648454-21216-1-git-send-email-marc.zyngier@arm.com>
 <1484648454-21216-18-git-send-email-marc.zyngier@arm.com>
Reply-To: shankerd@codeaurora.org
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D0D840A69
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Feb 2017 18:06:39 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RA4qHjcS8MvQ for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Feb 2017 18:06:38 -0500 (EST)
Received: from smtp.codeaurora.org (smtp.codeaurora.org [198.145.29.96])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8B38640A54
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Feb 2017 18:06:38 -0500 (EST)
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



On 01/17/2017 04:20 AM, Marc Zyngier wrote:
> Add the skeleton irq_set_vcpu_affinity method that will be used
> to configure VLPIs.
>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>   drivers/irqchip/irq-gic-v3-its.c | 33 +++++++++++++++++++++++++++++++++
>   1 file changed, 33 insertions(+)
>
> diff --git a/drivers/irqchip/irq-gic-v3-its.c
> b/drivers/irqchip/irq-gic-v3-its.c
> index 0dbc8b0..1bd78ca 100644
> --- a/drivers/irqchip/irq-gic-v3-its.c
> +++ b/drivers/irqchip/irq-gic-v3-its.c
> @@ -36,6 +36,7 @@
>   
>   #include <linux/irqchip.h>
>   #include <linux/irqchip/arm-gic-v3.h>
> +#include <linux/irqchip/arm-gic-v4.h>
>   
>   #include <asm/cputype.h>
>   #include <asm/exception.h>
> @@ -771,6 +772,37 @@ static int its_irq_set_irqchip_state(struct irq_data
> *d,
>   	return 0;
>   }
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
Missing a return statement.

-- 
Shanker Donthineni
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project.
