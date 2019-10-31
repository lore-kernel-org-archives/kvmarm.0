Return-Path: <SRS0=oLPE=YY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9943CCA9EC3
	for <kvmarm@archiver.kernel.org>; Thu, 31 Oct 2019 12:02:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 29F272086D
	for <kvmarm@archiver.kernel.org>; Thu, 31 Oct 2019 12:02:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 29F272086D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8EE1D4AC91;
	Thu, 31 Oct 2019 08:02:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SaRfp7T8yezj; Thu, 31 Oct 2019 08:02:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 63E034AC86;
	Thu, 31 Oct 2019 08:02:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CDB3E4A95C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 31 Oct 2019 08:02:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qKeuXqXnkJzZ for <kvmarm@lists.cs.columbia.edu>;
 Thu, 31 Oct 2019 08:02:40 -0400 (EDT)
Received: from huawei.com (szxga07-in.huawei.com [45.249.212.35])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D6DD44A52E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 31 Oct 2019 08:02:38 -0400 (EDT)
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.59])
 by Forcepoint Email with ESMTP id 35D97779D44FF684F7B9;
 Thu, 31 Oct 2019 20:02:35 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.27) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.439.0; Thu, 31 Oct 2019
 20:02:26 +0800
Subject: Re: [PATCH v2 09/36] irqchip/gic-v3: Add GICv4.1 VPEID size discovery
To: Marc Zyngier <maz@kernel.org>, <kvmarm@lists.cs.columbia.edu>,
 <linux-kernel@vger.kernel.org>
References: <20191027144234.8395-1-maz@kernel.org>
 <20191027144234.8395-10-maz@kernel.org>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <ec979d9b-cfe8-bfd8-fc4c-c41a602b2494@huawei.com>
Date: Thu, 31 Oct 2019 20:02:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20191027144234.8395-10-maz@kernel.org>
Content-Language: en-US
X-Originating-IP: [10.173.222.27]
X-CFilter-Loop: Reflected
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Jason Cooper <jason@lakedaemon.net>, Robert Richter <rrichter@marvell.com>,
 Jayachandran C <jnair@marvell.com>, Thomas Gleixner <tglx@linutronix.de>
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

On 2019/10/27 22:42, Marc Zyngier wrote:
> While GICv4.0 mandates 16 bit worth of VPEIDs, GICv4.1 allows smaller
> implementations to be built. Add the required glue to dynamically
> compute the limit.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>   drivers/irqchip/irq-gic-v3-its.c   | 11 ++++++++++-
>   drivers/irqchip/irq-gic-v3.c       |  3 +++
>   include/linux/irqchip/arm-gic-v3.h |  5 +++++
>   3 files changed, 18 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
> index 94c9c2e9f917..40912b3fb0e1 100644
> --- a/drivers/irqchip/irq-gic-v3-its.c
> +++ b/drivers/irqchip/irq-gic-v3-its.c
> @@ -121,7 +121,16 @@ struct its_node {
>   #define ITS_ITT_ALIGN		SZ_256
>   
>   /* The maximum number of VPEID bits supported by VLPI commands */
> -#define ITS_MAX_VPEID_BITS	(16)
> +#define ITS_MAX_VPEID_BITS						\
> +	({								\
> +		int nvpeid = 16;					\
> +		if (gic_rdists->has_rvpeid &&				\
> +		    gic_rdists->gicd_typer2 & GICD_TYPER2_VIL)		\
> +			nvpeid = 1 + (gic_rdists->gicd_typer2 &		\
> +				      GICD_TYPER2_VID);			\

Does it make sense to let nvpeid not more than 16 here? As the spec says
"Values above 0x0F are RESERVED". But I don't know why should we have
this restriction ;-)

Either way,

Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>


Thanks

> +									\
> +		nvpeid;							\
> +	})
>   #define ITS_MAX_VPEID		(1 << (ITS_MAX_VPEID_BITS))
>   
>   /* Convert page order to size in bytes */
> diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
> index 4f20caf9bc88..50538709bd49 100644
> --- a/drivers/irqchip/irq-gic-v3.c
> +++ b/drivers/irqchip/irq-gic-v3.c
> @@ -1556,6 +1556,9 @@ static int __init gic_init_bases(void __iomem *dist_base,
>   
>   	pr_info("%d SPIs implemented\n", GIC_LINE_NR - 32);
>   	pr_info("%d Extended SPIs implemented\n", GIC_ESPI_NR);
> +
> +	gic_data.rdists.gicd_typer2 = readl_relaxed(gic_data.dist_base + GICD_TYPER2);
> +
>   	gic_data.domain = irq_domain_create_tree(handle, &gic_irq_domain_ops,
>   						 &gic_data);
>   	irq_domain_update_bus_token(gic_data.domain, DOMAIN_BUS_WIRED);
> diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
> index c98f34296599..8c6be56da7e9 100644
> --- a/include/linux/irqchip/arm-gic-v3.h
> +++ b/include/linux/irqchip/arm-gic-v3.h
> @@ -13,6 +13,7 @@
>   #define GICD_CTLR			0x0000
>   #define GICD_TYPER			0x0004
>   #define GICD_IIDR			0x0008
> +#define GICD_TYPER2			0x000C
>   #define GICD_STATUSR			0x0010
>   #define GICD_SETSPI_NSR			0x0040
>   #define GICD_CLRSPI_NSR			0x0048
> @@ -89,6 +90,9 @@
>   #define GICD_TYPER_ESPIS(typer)						\
>   	(((typer) & GICD_TYPER_ESPI) ? GICD_TYPER_SPIS((typer) >> 27) : 0)
>   
> +#define GICD_TYPER2_VIL			(1U << 7)
> +#define GICD_TYPER2_VID			GENMASK(4, 0)
> +
>   #define GICD_IROUTER_SPI_MODE_ONE	(0U << 31)
>   #define GICD_IROUTER_SPI_MODE_ANY	(1U << 31)
>   
> @@ -613,6 +617,7 @@ struct rdists {
>   	void			*prop_table_va;
>   	u64			flags;
>   	u32			gicd_typer;
> +	u32			gicd_typer2;
>   	bool			has_vlpis;
>   	bool			has_rvpeid;
>   	bool			has_direct_lpi;
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
