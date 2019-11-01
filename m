Return-Path: <SRS0=K73f=YZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50CA4CA9ECF
	for <kvmarm@archiver.kernel.org>; Fri,  1 Nov 2019 11:52:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CFF9820656
	for <kvmarm@archiver.kernel.org>; Fri,  1 Nov 2019 11:52:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CFF9820656
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4F2814ACB2;
	Fri,  1 Nov 2019 07:52:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gLA1rTKIx0Z1; Fri,  1 Nov 2019 07:52:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 33F384ACC6;
	Fri,  1 Nov 2019 07:52:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DE70C4ACC6
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Nov 2019 07:52:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id P3NBuCqJHmFs for <kvmarm@lists.cs.columbia.edu>;
 Fri,  1 Nov 2019 07:52:10 -0400 (EDT)
Received: from huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 67F0F4ACC4
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Nov 2019 07:52:10 -0400 (EDT)
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
 by Forcepoint Email with ESMTP id E978E5D73C6E77742B42;
 Fri,  1 Nov 2019 19:52:05 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.27) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.439.0; Fri, 1 Nov 2019
 19:51:56 +0800
Subject: Re: [PATCH v2 19/36] irqchip/gic-v4.1: Add VPE INVALL callback
To: Marc Zyngier <maz@kernel.org>, <kvmarm@lists.cs.columbia.edu>,
 <linux-kernel@vger.kernel.org>
References: <20191027144234.8395-1-maz@kernel.org>
 <20191027144234.8395-20-maz@kernel.org>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <28e29c2d-a35a-6a67-c65d-7ab61d33b21b@huawei.com>
Date: Fri, 1 Nov 2019 19:51:54 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20191027144234.8395-20-maz@kernel.org>
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
> GICv4.1 redistributors have a VPE-aware INVALL register. Progress!
> We can now emulate a guest-requested INVALL without emiting a
> VINVALL command.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>

> ---
>   drivers/irqchip/irq-gic-v3-its.c   | 14 ++++++++++++++
>   include/linux/irqchip/arm-gic-v3.h |  3 +++
>   2 files changed, 17 insertions(+)
> 
> diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
> index f7effd453729..10bd156aa042 100644
> --- a/drivers/irqchip/irq-gic-v3-its.c
> +++ b/drivers/irqchip/irq-gic-v3-its.c
> @@ -3511,6 +3511,19 @@ static void its_vpe_4_1_deschedule(struct its_vpe *vpe,
>   	}
>   }
>   
> +static void its_vpe_4_1_invall(struct its_vpe *vpe)
> +{
> +	void __iomem *rdbase;
> +	u64 val;
> +
> +	val  = GICR_INVLPIR_V;
> +	val |= FIELD_PREP(GICR_INVLPIR_VPEID, vpe->vpe_id);

Can we use GICR_INVALL_V/VPEID instead, and ...

> +
> +	/* Target the redistributor this vPE is currently known on */
> +	rdbase = per_cpu_ptr(gic_rdists->rdist, vpe->col_idx)->rd_base;
> +	gic_write_lpir(val, rdbase + GICR_INVALLR);
> +}
> +
>   static int its_vpe_4_1_set_vcpu_affinity(struct irq_data *d, void *vcpu_info)
>   {
>   	struct its_vpe *vpe = irq_data_get_irq_chip_data(d);
> @@ -3526,6 +3539,7 @@ static int its_vpe_4_1_set_vcpu_affinity(struct irq_data *d, void *vcpu_info)
>   		return 0;
>   
>   	case INVALL_VPE:
> +		its_vpe_4_1_invall(vpe);
>   		return 0;
>   
>   	default:
> diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
> index 6fd89d77b2b2..b69f60792554 100644
> --- a/include/linux/irqchip/arm-gic-v3.h
> +++ b/include/linux/irqchip/arm-gic-v3.h
> @@ -247,6 +247,9 @@
>   #define GICR_TYPER_COMMON_LPI_AFF	GENMASK_ULL(25, 24)
>   #define GICR_TYPER_AFFINITY		GENMASK_ULL(63, 32)
>   
> +#define GICR_INVLPIR_VPEID		GENMASK_ULL(47, 32)
> +#define GICR_INVLPIR_V			GENMASK_ULL(63, 63)
> +

... define them here:

#define GICR_INVALL_VPEID		GICR_INVLPIR_VPEID
#define GICR_INVALL_V			GICR_INVLPIR_V


Thanks,
Zenghui

>   #define GIC_V3_REDIST_SIZE		0x20000
>   
>   #define LPI_PROP_GROUP1			(1 << 1)
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
