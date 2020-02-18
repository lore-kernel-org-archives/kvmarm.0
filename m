Return-Path: <SRS0=SKU0=4G=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC67AC34031
	for <kvmarm@archiver.kernel.org>; Tue, 18 Feb 2020 07:01:14 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4EB88207FD
	for <kvmarm@archiver.kernel.org>; Tue, 18 Feb 2020 07:01:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4EB88207FD
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6237A4A4A0;
	Tue, 18 Feb 2020 02:01:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id AfaHXRp8R1Rp; Tue, 18 Feb 2020 02:01:12 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 554E74AF15;
	Tue, 18 Feb 2020 02:01:12 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4B3CC4AF25
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Feb 2020 02:01:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RNQd4Vo3XtoK for <kvmarm@lists.cs.columbia.edu>;
 Tue, 18 Feb 2020 02:01:08 -0500 (EST)
Received: from huawei.com (szxga06-in.huawei.com [45.249.212.32])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A13704AF21
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Feb 2020 02:01:08 -0500 (EST)
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
 by Forcepoint Email with ESMTP id 4669D921C802E35843D2;
 Tue, 18 Feb 2020 15:01:03 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.27) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.439.0; Tue, 18 Feb 2020
 15:00:55 +0800
Subject: Re: [PATCH v4 08/20] irqchip/gic-v4.1: Plumb get/set_irqchip_state
 SGI callbacks
To: Marc Zyngier <maz@kernel.org>, <linux-arm-kernel@lists.infradead.org>,
 <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>
References: <20200214145736.18550-1-maz@kernel.org>
 <20200214145736.18550-9-maz@kernel.org>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <4b7f71f1-5e7f-e6af-f47d-7ed0d3a8739f@huawei.com>
Date: Tue, 18 Feb 2020 15:00:54 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20200214145736.18550-9-maz@kernel.org>
Content-Language: en-US
X-Originating-IP: [10.173.222.27]
X-CFilter-Loop: Reflected
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Jason Cooper <jason@lakedaemon.net>, Robert Richter <rrichter@marvell.com>,
 Thomas Gleixner <tglx@linutronix.de>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Marc,

On 2020/2/14 22:57, Marc Zyngier wrote:
> To implement the get/set_irqchip_state callbacks (limited to the
> PENDING state), we have to use a particular set of hacks:
> 
> - Reading the pending state is done by using a pair of new redistributor
>    registers (GICR_VSGIR, GICR_VSGIPENDR), which allow the 16 interrupts
>    state to be retrieved.
> - Setting the pending state is done by generating it as we'd otherwise do
>    for a guest (writing to GITS_SGIR)
> - Clearing the pending state is done by emiting a VSGI command with the
>    "clear" bit set.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>   drivers/irqchip/irq-gic-v3-its.c   | 56 ++++++++++++++++++++++++++++++
>   include/linux/irqchip/arm-gic-v3.h | 14 ++++++++
>   2 files changed, 70 insertions(+)
> 
> diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
> index 1e448d9a16ea..a9753435c4ff 100644
> --- a/drivers/irqchip/irq-gic-v3-its.c
> +++ b/drivers/irqchip/irq-gic-v3-its.c
> @@ -3915,11 +3915,67 @@ static int its_sgi_set_affinity(struct irq_data *d,
>   	return -EINVAL;
>   }
>   
> +static int its_sgi_set_irqchip_state(struct irq_data *d,
> +				     enum irqchip_irq_state which,
> +				     bool state)
> +{
> +	if (which != IRQCHIP_STATE_PENDING)
> +		return -EINVAL;
> +
> +	if (state) {
> +		struct its_vpe *vpe = irq_data_get_irq_chip_data(d);
> +		struct its_node *its = find_4_1_its();
> +		u64 val;
> +
> +		val  = FIELD_PREP(GITS_SGIR_VPEID, vpe->vpe_id);
> +		val |= FIELD_PREP(GITS_SGIR_VINTID, d->hwirq);
> +		writeq_relaxed(val, its->sgir_base + GITS_SGIR - SZ_128K);
> +	} else {
> +		its_configure_sgi(d, true);
> +	}
> +
> +	return 0;
> +}
> +
> +static int its_sgi_get_irqchip_state(struct irq_data *d,
> +				     enum irqchip_irq_state which, bool *val)
> +{
> +	struct its_vpe *vpe = irq_data_get_irq_chip_data(d);
> +	void __iomem *base = gic_data_rdist_cpu(vpe->col_idx)->rd_base + SZ_128K;

There might be a race on reading the 'vpe->col_idx' against a concurrent
vPE schedule (col_idx will be modified in its_vpe_set_affinity)? Will we
end up accessing the GICR_VSGI* registers of the old redistributor,
while the vPE is now resident on the new one? Or is it harmful?

The same question for direct_lpi_inv(), where 'vpe->col_idx' will be
used in irq_to_cpuid().

> +	u32 count = 1000000;	/* 1s! */
> +	u32 status;
> +
> +	if (which != IRQCHIP_STATE_PENDING)
> +		return -EINVAL;
> +
> +	writel_relaxed(vpe->vpe_id, base + GICR_VSGIR);
> +	do {
> +		status = readl_relaxed(base + GICR_VSGIPENDR);
> +		if (!(status & GICR_VSGIPENDR_BUSY))
> +			goto out;
> +
> +		count--;
> +		if (!count) {
> +			pr_err_ratelimited("Unable to get SGI status\n");
> +			goto out;
> +		}
> +		cpu_relax();
> +		udelay(1);
> +	} while(count);
> +
> +out:
> +	*val = !!(status & (1 << d->hwirq));
> +
> +	return 0;
> +}
> +
>   static struct irq_chip its_sgi_irq_chip = {
>   	.name			= "GICv4.1-sgi",
>   	.irq_mask		= its_sgi_mask_irq,
>   	.irq_unmask		= its_sgi_unmask_irq,
>   	.irq_set_affinity	= its_sgi_set_affinity,
> +	.irq_set_irqchip_state	= its_sgi_set_irqchip_state,
> +	.irq_get_irqchip_state	= its_sgi_get_irqchip_state,
>   };
>   
>   static int its_sgi_irq_domain_alloc(struct irq_domain *domain,
> diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
> index a89578884263..64da945486ac 100644
> --- a/include/linux/irqchip/arm-gic-v3.h
> +++ b/include/linux/irqchip/arm-gic-v3.h
> @@ -345,6 +345,15 @@
>   #define GICR_VPENDBASER_4_1_VGRP1EN	(1ULL << 58)
>   #define GICR_VPENDBASER_4_1_VPEID	GENMASK_ULL(15, 0)
>   
> +#define GICR_VSGIR			0x0080
> +
> +#define GICR_VSGIR_VPEID		GENMASK(15, 0)
> +
> +#define GICR_VSGIPENDR			0x0088
> +
> +#define GICR_VSGIPENDR_BUSY		(1U << 31)
> +#define GICR_VSGIPENDR_PENDING		GENMASK(15, 0)
> +
>   /*
>    * ITS registers, offsets from ITS_base
>    */
> @@ -368,6 +377,11 @@
>   
>   #define GITS_TRANSLATER			0x10040
>   
> +#define GITS_SGIR			0x20020
> +
> +#define GITS_SGIR_VPEID			GENMASK_ULL(47, 32)
> +#define GITS_SGIR_VINTID		GENMASK_ULL(7, 0)

The spec says vINTID field is [3:0] of the GITS_SGIR.


Thanks,
Zenghui

> +
>   #define GITS_CTLR_ENABLE		(1U << 0)
>   #define GITS_CTLR_ImDe			(1U << 1)
>   #define	GITS_CTLR_ITS_NUMBER_SHIFT	4
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
