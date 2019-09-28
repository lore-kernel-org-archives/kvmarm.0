Return-Path: <SRS0=ReDF=XX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA532C4360C
	for <kvmarm@archiver.kernel.org>; Sat, 28 Sep 2019 03:13:27 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 55EE6207FA
	for <kvmarm@archiver.kernel.org>; Sat, 28 Sep 2019 03:13:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 55EE6207FA
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D51624A70B;
	Fri, 27 Sep 2019 23:13:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hokkrYgGD3yy; Fri, 27 Sep 2019 23:13:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CEB9A4A71C;
	Fri, 27 Sep 2019 23:13:25 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AD6D24A70B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Sep 2019 23:13:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ETia6btTNRzp for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 Sep 2019 23:13:23 -0400 (EDT)
Received: from huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7DDC54A703
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Sep 2019 23:13:23 -0400 (EDT)
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
 by Forcepoint Email with ESMTP id 55649E13E901CAD785BF;
 Sat, 28 Sep 2019 11:13:19 +0800 (CST)
Received: from [127.0.0.1] (10.184.12.158) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.439.0; Sat, 28 Sep 2019
 11:13:10 +0800
Subject: Re: [PATCH 31/35] irqchip/gic-v4.1: Eagerly vmap vPEs
To: Marc Zyngier <maz@kernel.org>, <kvmarm@lists.cs.columbia.edu>,
 <linux-kernel@vger.kernel.org>
References: <20190923182606.32100-1-maz@kernel.org>
 <20190923182606.32100-32-maz@kernel.org>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <82576f6e-3736-8069-bbf2-7744fbea9ed2@huawei.com>
Date: Sat, 28 Sep 2019 11:11:42 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:64.0) Gecko/20100101
 Thunderbird/64.0
MIME-Version: 1.0
In-Reply-To: <20190923182606.32100-32-maz@kernel.org>
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

On 2019/9/24 2:26, Marc Zyngier wrote:
> Now that we have HW-accelerated SGIs being delivered to VPEs, it
> becomes required to map the VPEs on all ITSs instead of relying
> on the lazy approach that we would use when using the ITS-list
> mechanism.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>   drivers/irqchip/irq-gic-v3-its.c | 39 +++++++++++++++++++++++++-------
>   1 file changed, 31 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
> index 4aae9582182b..a1e8c4c2598a 100644
> --- a/drivers/irqchip/irq-gic-v3-its.c
> +++ b/drivers/irqchip/irq-gic-v3-its.c
> @@ -1417,12 +1417,31 @@ static int its_irq_set_irqchip_state(struct irq_data *d,
>   	return 0;
>   }
>   
> +/*
> + * Two favourable cases:
> + *
> + * (a) Either we have a GICv4.1, and all vPEs have to be mapped at all times
> + *     for vSGI delivery
> + *
> + * (b) Or the ITSs do not use a list map, meaning that VMOVP is cheap enough
> + *     and we're better off mapping all VPEs always
> + *
> + * If neither (a) nor (b) is true, then we map VLPIs on demand.
                                                  ^^^^^
vPEs

> + *
> + */
> +static bool gic_requires_eager_mapping(void)
> +{
> +	if (!its_list_map || gic_rdists->has_rvpeid)
> +		return true;
> +
> +	return false;
> +}
> +
>   static void its_map_vm(struct its_node *its, struct its_vm *vm)
>   {
>   	unsigned long flags;
>   
> -	/* Not using the ITS list? Everything is always mapped. */
> -	if (!its_list_map)
> +	if (gic_requires_eager_mapping())
>   		return;
>   
>   	raw_spin_lock_irqsave(&vmovp_lock, flags);
> @@ -1456,7 +1475,7 @@ static void its_unmap_vm(struct its_node *its, struct its_vm *vm)
>   	unsigned long flags;
>   
>   	/* Not using the ITS list? Everything is always mapped. */
> -	if (!its_list_map)
> +	if (gic_requires_eager_mapping())
>   		return;
>   
>   	raw_spin_lock_irqsave(&vmovp_lock, flags);
> @@ -3957,8 +3976,12 @@ static int its_vpe_irq_domain_activate(struct irq_domain *domain,
>   	struct its_vpe *vpe = irq_data_get_irq_chip_data(d);
>   	struct its_node *its;
>   
> -	/* If we use the list map, we issue VMAPP on demand... */
> -	if (its_list_map)
> +	/*
> +	 * If we use the list map, we issue VMAPP on demand... Unless
> +	 * we're on a GICv4.1 and we eagerly map the VPE on all ITSs
> +	 * so that VSGIs can work.
> +	 */
> +	if (!gic_requires_eager_mapping())
>   		return 0;
>   
>   	/* Map the VPE to the first possible CPU */
> @@ -3984,10 +4007,10 @@ static void its_vpe_irq_domain_deactivate(struct irq_domain *domain,
>   	struct its_node *its;
>   
>   	/*
> -	 * If we use the list map, we unmap the VPE once no VLPIs are
> -	 * associated with the VM.
> +	 * If we use the list map on GICv4.0, we unmap the VPE once no
> +	 * VLPIs are associated with the VM.
>   	 */
> -	if (its_list_map)
> +	if (!gic_requires_eager_mapping())
>   		return;
>   
>   	list_for_each_entry(its, &its_nodes, entry) {
> 


Thanks,
zenghui

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
