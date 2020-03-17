Return-Path: <SRS0=FDwM=5C=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A1C5C18E5B
	for <kvmarm@archiver.kernel.org>; Tue, 17 Mar 2020 02:49:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1100520674
	for <kvmarm@archiver.kernel.org>; Tue, 17 Mar 2020 02:49:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1100520674
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4FF154A4AA;
	Mon, 16 Mar 2020 22:49:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vOOscIinLht8; Mon, 16 Mar 2020 22:49:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3349E4A4C0;
	Mon, 16 Mar 2020 22:49:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1B94E4A4A4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Mar 2020 22:49:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jWDF8Rm0wpBS for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 Mar 2020 22:49:33 -0400 (EDT)
Received: from huawei.com (szxga06-in.huawei.com [45.249.212.32])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 73DB44A3A5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Mar 2020 22:49:33 -0400 (EDT)
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
 by Forcepoint Email with ESMTP id AC9D0E0409BF2661E9C8;
 Tue, 17 Mar 2020 10:49:28 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.27) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.487.0; Tue, 17 Mar 2020
 10:49:20 +0800
Subject: Re: [PATCH v5 16/23] irqchip/gic-v4.1: Eagerly vmap vPEs
To: Marc Zyngier <maz@kernel.org>, <linux-arm-kernel@lists.infradead.org>,
 <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>
References: <20200304203330.4967-1-maz@kernel.org>
 <20200304203330.4967-17-maz@kernel.org>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <2817cb89-4cc2-549f-6e40-91d941aa8a5f@huawei.com>
Date: Tue, 17 Mar 2020 10:49:18 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20200304203330.4967-17-maz@kernel.org>
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

On 2020/3/5 4:33, Marc Zyngier wrote:
> Now that we have HW-accelerated SGIs being delivered to VPEs, it
> becomes required to map the VPEs on all ITSs instead of relying
> on the lazy approach that we would use when using the ITS-list
> mechanism.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Before GICv4.1, we use vlpi_count to evaluate whether the vPE has been
mapped on the specified ITS, and use this refcount to only issue VMOVP
to those involved ITSes. It's broken after this patch.

We may need to re-evaluate "whether the vPE is mapped" now that we're at
GICv4.1, otherwise *no* VMOVP will be issued on the v4.1 capable machine
(I mean those without single VMOVP support).

What I'm saying is something like below (only an idea, it even can't
compile), any thoughts?


diff --git a/drivers/irqchip/irq-gic-v3-its.c 
b/drivers/irqchip/irq-gic-v3-its.c
index 2e12bc52e3a2..3450b5e847ca 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -198,7 +198,8 @@ static u16 get_its_list(struct its_vm *vm)
  		if (!is_v4(its))
  			continue;

-		if (vm->vlpi_count[its->list_nr])
+		if (vm->vlpi_count[its->list_nr] ||
+		    gic_requires_eager_mapping())
  			__set_bit(its->list_nr, &its_list);
  	}

@@ -1295,7 +1296,8 @@ static void its_send_vmovp(struct its_vpe *vpe)
  		if (!is_v4(its))
  			continue;

-		if (!vpe->its_vm->vlpi_count[its->list_nr])
+		if (!vpe->its_vm->vlpi_count[its->list_nr] &&
+		    !gic_requires_eager_mapping())
  			continue;

  		desc.its_vmovp_cmd.col = &its->collections[col_id];


Thanks,
Zenghui

> ---
>   drivers/irqchip/irq-gic-v3-its.c | 39 +++++++++++++++++++++++++-------
>   1 file changed, 31 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
> index b65fba67bd85..6277b3e3731f 100644
> --- a/drivers/irqchip/irq-gic-v3-its.c
> +++ b/drivers/irqchip/irq-gic-v3-its.c
> @@ -1586,12 +1586,31 @@ static int its_irq_set_irqchip_state(struct irq_data *d,
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
> + * If neither (a) nor (b) is true, then we map vPEs on demand.
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
> @@ -1625,7 +1644,7 @@ static void its_unmap_vm(struct its_node *its, struct its_vm *vm)
>   	unsigned long flags;
>   
>   	/* Not using the ITS list? Everything is always mapped. */
> -	if (!its_list_map)
> +	if (gic_requires_eager_mapping())
>   		return;
>   
>   	raw_spin_lock_irqsave(&vmovp_lock, flags);
> @@ -4260,8 +4279,12 @@ static int its_vpe_irq_domain_activate(struct irq_domain *domain,
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
> @@ -4287,10 +4310,10 @@ static void its_vpe_irq_domain_deactivate(struct irq_domain *domain,
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

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
