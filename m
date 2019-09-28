Return-Path: <SRS0=ReDF=XX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17A47C4360C
	for <kvmarm@archiver.kernel.org>; Sat, 28 Sep 2019 02:05:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 778312086A
	for <kvmarm@archiver.kernel.org>; Sat, 28 Sep 2019 02:05:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 778312086A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AC71C4A79D;
	Fri, 27 Sep 2019 22:05:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZgqRBCKW3Bnz; Fri, 27 Sep 2019 22:05:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B76D24A789;
	Fri, 27 Sep 2019 22:05:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8B1104A3A5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Sep 2019 22:05:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dzns3htzLfnp for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 Sep 2019 22:05:13 -0400 (EDT)
Received: from huawei.com (szxga06-in.huawei.com [45.249.212.32])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F40784A752
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Sep 2019 22:05:12 -0400 (EDT)
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.60])
 by Forcepoint Email with ESMTP id 9DDB44CD10C3886E974F;
 Sat, 28 Sep 2019 10:05:06 +0800 (CST)
Received: from [127.0.0.1] (10.184.12.158) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.439.0; Sat, 28 Sep 2019
 10:04:57 +0800
Subject: Re: [PATCH 20/35] irqchip/gic-v4.1: Allow direct invalidation of VLPIs
To: Marc Zyngier <maz@kernel.org>, <kvmarm@lists.cs.columbia.edu>,
 <linux-kernel@vger.kernel.org>
References: <20190923182606.32100-1-maz@kernel.org>
 <20190923182606.32100-21-maz@kernel.org>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <db01f956-bc53-b8a5-9406-15b889d717f0@huawei.com>
Date: Sat, 28 Sep 2019 10:02:07 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:64.0) Gecko/20100101
 Thunderbird/64.0
MIME-Version: 1.0
In-Reply-To: <20190923182606.32100-21-maz@kernel.org>
Content-Language: en-US
X-Originating-IP: [10.184.12.158]
X-CFilter-Loop: Reflected
Cc: Thomas Gleixner <tglx@linutronix.de>,
 Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Jason Cooper <jason@lakedaemon.net>
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

On 2019/9/24 2:25, Marc Zyngier wrote:
> Just like for INVALL, GICv4.1 has grown a VPE-aware INVLPI register.
> Let's plumb it in and make use of the DirectLPI code in that case.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>   drivers/irqchip/irq-gic-v3-its.c   | 19 +++++++++++++++++--
>   include/linux/irqchip/arm-gic-v3.h |  1 +
>   2 files changed, 18 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
> index b791c9beddf2..34595a7fcccb 100644
> --- a/drivers/irqchip/irq-gic-v3-its.c
> +++ b/drivers/irqchip/irq-gic-v3-its.c
> @@ -1200,13 +1200,27 @@ static void wait_for_syncr(void __iomem *rdbase)
>   
>   static void direct_lpi_inv(struct irq_data *d)
>   {
> +	struct its_vlpi_map *map = get_vlpi_map(d);
>   	struct its_collection *col;
>   	void __iomem *rdbase;
> +	u64 val;
> +
> +	if (map) {
> +		struct its_device *its_dev = irq_data_get_irq_chip_data(d);
> +
> +		WARN_ON(!is_v4_1(its_dev->its));
> +
> +		val  = GICR_INVLPIR_V;
> +		val |= FIELD_PREP(GICR_INVLPIR_VPEID, map->vpe->vpe_id);
> +		val |= FIELD_PREP(GICR_INVLPIR_INTID, map->vintid);
> +	} else {
> +		val = d->hwirq;
> +	}
>   
>   	/* Target the redistributor this LPI is currently routed to */
>   	col = irq_to_col(d);

I think irq_to_col() may not work when GICv4.1 VLPIs are involved in.

irq_to_col() gives us col_map[event] as the target redistributor,
but the correct one for VLPIs should be vlpi_maps[event]->vpe->col_idx.
These two are not always pointing to the same physical RD.
For example, if guest issues a MOVI against a VLPI, we will update the
corresponding vlpi_map->vpe and issue a VMOVI on ITS... but leave the
col_map[event] unchanged.

col_map[event] usually describes the physical LPI's CPU affinity, but
when this physical LPI serves as something which the VLPI is backed by,
we take really little care of it.  Did I miss something here?


Thanks,
zenghui


>   	rdbase = per_cpu_ptr(gic_rdists->rdist, col->col_id)->rd_base;
> -	gic_write_lpir(d->hwirq, rdbase + GICR_INVLPIR);
> +	gic_write_lpir(val, rdbase + GICR_INVLPIR);
>   
>   	wait_for_syncr(rdbase);
>   }
> @@ -1216,7 +1230,8 @@ static void lpi_update_config(struct irq_data *d, u8 clr, u8 set)
>   	struct its_device *its_dev = irq_data_get_irq_chip_data(d);
>   
>   	lpi_write_config(d, clr, set);
> -	if (gic_rdists->has_direct_lpi && !irqd_is_forwarded_to_vcpu(d))
> +	if (gic_rdists->has_direct_lpi &&
> +	    (is_v4_1(its_dev->its) || !irqd_is_forwarded_to_vcpu(d)))
>   		direct_lpi_inv(d);
>   	else
>   		its_send_inv(its_dev, its_get_event_id(d));
> diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
> index b69f60792554..5f3278cbf247 100644
> --- a/include/linux/irqchip/arm-gic-v3.h
> +++ b/include/linux/irqchip/arm-gic-v3.h
> @@ -247,6 +247,7 @@
>   #define GICR_TYPER_COMMON_LPI_AFF	GENMASK_ULL(25, 24)
>   #define GICR_TYPER_AFFINITY		GENMASK_ULL(63, 32)
>   
> +#define GICR_INVLPIR_INTID		GENMASK_ULL(31, 0)
>   #define GICR_INVLPIR_VPEID		GENMASK_ULL(47, 32)
>   #define GICR_INVLPIR_V			GENMASK_ULL(63, 63)
>   
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
