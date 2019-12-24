Return-Path: <SRS0=PUN/=2O=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B877FC2D0CF
	for <kvmarm@archiver.kernel.org>; Tue, 24 Dec 2019 07:11:14 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 44DF2206CB
	for <kvmarm@archiver.kernel.org>; Tue, 24 Dec 2019 07:11:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 44DF2206CB
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C3BD24AF5E;
	Tue, 24 Dec 2019 02:11:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3-34jxl99pft; Tue, 24 Dec 2019 02:11:12 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D13F54AF47;
	Tue, 24 Dec 2019 02:11:12 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EDCAC4AF2F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Dec 2019 02:11:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MBsfSI4Sny2K for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 Dec 2019 02:11:10 -0500 (EST)
Received: from huawei.com (szxga06-in.huawei.com [45.249.212.32])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D651B4AEF6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Dec 2019 02:11:09 -0500 (EST)
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.59])
 by Forcepoint Email with ESMTP id 87DA525A48C8506A8904;
 Tue, 24 Dec 2019 15:11:06 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.27) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.439.0; Tue, 24 Dec 2019
 15:10:56 +0800
Subject: Re: [PATCH v2 11/36] irqchip/gic-v4.1: VPE table (aka
 GICR_VPROPBASER) allocation
To: Marc Zyngier <maz@kernel.org>, <kvmarm@lists.cs.columbia.edu>,
 <linux-kernel@vger.kernel.org>
References: <20191027144234.8395-1-maz@kernel.org>
 <20191027144234.8395-12-maz@kernel.org>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <61526052-aa00-0769-d5bb-3524161c5650@huawei.com>
Date: Tue, 24 Dec 2019 15:10:54 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20191027144234.8395-12-maz@kernel.org>
Content-Language: en-US
X-Originating-IP: [10.173.222.27]
X-CFilter-Loop: Reflected
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Jason Cooper <jason@lakedaemon.net>, wangwudi@hisilicon.com,
 Robert Richter <rrichter@marvell.com>, Jayachandran C <jnair@marvell.com>,
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

[ +Wudi and Nianyao. As they spotted the following issue but
  I forgot to send it out. ]

On 2019/10/27 22:42, Marc Zyngier wrote:
> GICv4.1 defines a new VPE table that is potentially shared between
> both the ITSs and the redistributors, following complicated affinity
> rules.
> 
> To make things more confusing, the programming of this table at
> the redistributor level is reusing the GICv4.0 GICR_VPROPBASER register
> for something completely different.
> 
> The code flow is somewhat complexified by the need to respect the
> affinities required by the HW, meaning that tables can either be
> inherited from a previously discovered ITS or redistributor.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---[...]
> diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
> index 40912b3fb0e1..478d3678850c 100644
> --- a/drivers/irqchip/irq-gic-v3-its.c
> +++ b/drivers/irqchip/irq-gic-v3-its.c
[...]
> @@ -2025,6 +2098,214 @@ static int its_alloc_tables(struct its_node *its)
>   	return 0;
>   }
>   
> +static u64 inherit_vpe_l1_table_from_its(void)
> +{
> +	struct its_node *its;
> +	u64 val;
> +	u32 aff;
> +
> +	val = gic_read_typer(gic_data_rdist_rd_base() + GICR_TYPER);
> +	aff = compute_common_aff(val);
> +
> +	list_for_each_entry(its, &its_nodes, entry) {
> +		u64 baser;
> +
> +		if (!is_v4_1(its))
> +			continue;
> +
> +		if (!FIELD_GET(GITS_TYPER_SVPET, its->typer))
> +			continue;
> +
> +		if (aff != compute_its_aff(its))
> +			continue;
> +
> +		/* GICv4.1 guarantees that the vPE table is GITS_BASER2 */
> +		baser = its->tables[2].val;
> +		if (!(baser & GITS_BASER_VALID))
> +			continue;
> +
> +		/* We have a winner! */
> +		val  = GICR_VPROPBASER_4_1_VALID;
> +		if (baser & GITS_BASER_INDIRECT)
> +			val |= GICR_VPROPBASER_4_1_INDIRECT;
> +		val |= FIELD_PREP(GICR_VPROPBASER_4_1_PAGE_SIZE,
> +				  FIELD_GET(GITS_BASER_PAGE_SIZE_MASK, baser));
> +		val |= FIELD_PREP(GICR_VPROPBASER_4_1_ADDR,
> +				  GITS_BASER_ADDR_48_to_52(baser) >> 12);

We've used GITS_BASER_ADDR_48_to_52() only in the KVM code where the
pagesize of ITS table is fixed to 64K.
It may not work when the pagesize is 4K or 16K?


Thanks,
Zenghui

> +		val |= FIELD_PREP(GICR_VPROPBASER_SHAREABILITY_MASK,
> +				  FIELD_GET(GITS_BASER_SHAREABILITY_MASK, baser));
> +		val |= FIELD_PREP(GICR_VPROPBASER_INNER_CACHEABILITY_MASK,
> +				  FIELD_GET(GITS_BASER_INNER_CACHEABILITY_MASK, baser));
> +		val |= FIELD_PREP(GICR_VPROPBASER_4_1_SIZE, GITS_BASER_NR_PAGES(baser) - 1);
> +
> +		return val;
> +	}
> +
> +	return 0;
> +}

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
