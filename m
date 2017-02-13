From: Shanker Donthineni <shankerd@codeaurora.org>
Subject: Re: [RFC PATCH 06/33] irqchip/gic-v3-its: Add probing for VLPI
 properties
Date: Mon, 13 Feb 2017 15:58:27 -0600
Message-ID: <5e2c1396-835c-93c6-ac73-dd50905127a2@codeaurora.org>
References: <1484648454-21216-1-git-send-email-marc.zyngier@arm.com>
 <1484648454-21216-7-git-send-email-marc.zyngier@arm.com>
Reply-To: shankerd@codeaurora.org
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E7D5A40A95
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Feb 2017 16:57:48 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8088XD25eTcU for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Feb 2017 16:57:48 -0500 (EST)
Received: from smtp.codeaurora.org (smtp.codeaurora.org [198.145.29.96])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 07AE9400E9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Feb 2017 16:57:47 -0500 (EST)
In-Reply-To: <1484648454-21216-7-git-send-email-marc.zyngier@arm.com>
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
> Add the probing code for the ITS VLPI support. This includes
> configuring the ITS number if not supporting the single VMOVP
> command feature.
>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>   drivers/irqchip/irq-gic-v3-its.c   | 47
> ++++++++++++++++++++++++++++++++++----
>   include/linux/irqchip/arm-gic-v3.h |  4 ++++
>   2 files changed, 47 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/irqchip/irq-gic-v3-its.c
> b/drivers/irqchip/irq-gic-v3-its.c
> index 9304dd2..99f6130 100644
> --- a/drivers/irqchip/irq-gic-v3-its.c
> +++ b/drivers/irqchip/irq-gic-v3-its.c
> @@ -103,6 +103,7 @@ struct its_node {
>   	u32			ite_size;
>   	u32			device_ids;
>   	int			numa_node;
> +	bool			is_v4;
>   };
>   
>   #define ITS_ITT_ALIGN		SZ_256
> @@ -135,6 +136,8 @@ static DEFINE_SPINLOCK(its_lock);
>   static struct rdists *gic_rdists;
>   static struct irq_domain *its_parent;
>   
> +static unsigned long its_list_map;
> +
>   #define gic_data_rdist()		(raw_cpu_ptr(gic_rdists->rdist))
>   #define gic_data_rdist_rd_base()	(gic_data_rdist()->rd_base)
>   
> @@ -1661,8 +1664,8 @@ static int __init its_probe_one(struct resource
> *res,
>   {
>   	struct its_node *its;
>   	void __iomem *its_base;
> -	u32 val;
> -	u64 baser, tmp;
> +	u32 val, ctlr;
> +	u64 baser, tmp, typer;
>   	int err;
>   
>   	its_base = ioremap(res->start, resource_size(res));
> @@ -1695,9 +1698,44 @@ static int __init its_probe_one(struct resource
> *res,
>   	raw_spin_lock_init(&its->lock);
>   	INIT_LIST_HEAD(&its->entry);
>   	INIT_LIST_HEAD(&its->its_device_list);
> +	typer = gic_read_typer(its_base + GITS_TYPER);
>   	its->base = its_base;
>   	its->phys_base = res->start;
> -	its->ite_size = ((gic_read_typer(its_base + GITS_TYPER) >> 4) &
> 0xf) + 1;
> +	its->ite_size = ((typer >> 4) & 0xf) + 1;
I think we should move bit manipulations to a macro, some thing like this.
its->ite_size = GITS_TYPER_ITEBITS(typer);

#define GITS_TYPER_ITEBITS_SHIFT        4
#define GITS_TYPER_ITEBITS(r)           ((((r) >> 
GITS_TYPER_ITEBITS_SHIFT) & 0xf) + 1)

> +	its->is_v4 = !!(typer & GITS_TYPER_VLPIS);
> +	if (its->is_v4 && !(typer & GITS_TYPER_VMOVP)) {
> +		int its_number;
> +
> +		its_number = find_first_zero_bit(&its_list_map, 16);
> +		if (its_number >= 16) {
> +			pr_err("ITS@%pa: No ITSList entry available!\n",
> +			       &res->start);
> +			err = -EINVAL;
> +			goto out_free_its;
> +		}
> +
> +		ctlr = readl_relaxed(its_base + GITS_CTLR);
> +		ctlr &= ~GITS_CTLR_ITS_NUMBER;
> +		ctlr |= its_number << GITS_CTLR_ITS_NUMBER_SHIFT;
> +		writel_relaxed(ctlr, its_base + GITS_CTLR);
> +		ctlr = readl_relaxed(its_base + GITS_CTLR);
> +		if ((ctlr & GITS_CTLR_ITS_NUMBER) != (its_number <<
> GITS_CTLR_ITS_NUMBER_SHIFT)) {
> +			its_number = ctlr & GITS_CTLR_ITS_NUMBER;
> +			its_number >>= GITS_CTLR_ITS_NUMBER_SHIFT;
> +		}
> +
> +		if (test_and_set_bit(its_number, &its_list_map)) {
> +			pr_err("ITS@%pa: Duplicate ITSList entry %d\n",
> +			       &res->start, its_number);
> +			err = -EINVAL;
> +			goto out_free_its;
> +		}
> +
> +		pr_info("ITS@%pa: Using ITS number %d\n", &res->start,
> its_number);
> +	} else {
> +		pr_info("ITS@%pa: Single VMOVP capable\n", &res->start);
> +	}
Can we move to a separate function for code readability purpose?

-- 
Shanker Donthineni
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project.
