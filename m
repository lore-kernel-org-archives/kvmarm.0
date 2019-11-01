Return-Path: <SRS0=K73f=YZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 551B0CA9ECF
	for <kvmarm@archiver.kernel.org>; Fri,  1 Nov 2019 11:06:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D6FB121734
	for <kvmarm@archiver.kernel.org>; Fri,  1 Nov 2019 11:06:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D6FB121734
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 533A34ACEB;
	Fri,  1 Nov 2019 07:06:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id iUkwJ06j3D+z; Fri,  1 Nov 2019 07:06:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 20DF64ACEC;
	Fri,  1 Nov 2019 07:06:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D8AA4ACE9
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Nov 2019 07:06:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZOKAxLLsHZw2 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  1 Nov 2019 07:06:12 -0400 (EDT)
Received: from huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8A1D04ACD0
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Nov 2019 07:06:11 -0400 (EDT)
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
 by Forcepoint Email with ESMTP id BE556712A63643A18BCD;
 Fri,  1 Nov 2019 19:06:07 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.27) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.439.0; Fri, 1 Nov 2019
 19:05:57 +0800
Subject: Re: [PATCH v2 13/36] irqchip/gic-v4.1: Don't use the VPE proxy if
 RVPEID is set
To: Marc Zyngier <maz@kernel.org>, <kvmarm@lists.cs.columbia.edu>,
 <linux-kernel@vger.kernel.org>
References: <20191027144234.8395-1-maz@kernel.org>
 <20191027144234.8395-14-maz@kernel.org>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <8514ccbe-814a-5bdd-3791-bdd65510ce68@huawei.com>
Date: Fri, 1 Nov 2019 19:05:56 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20191027144234.8395-14-maz@kernel.org>
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
> The infamous VPE proxy device isn't used with GICv4.1 because:
> - we can invalidate any LPI from the DirectLPI MMIO interface
> - the ITS and redistributors understand the life cycle of
>    the doorbell, so we don't need to enable/disable it all
>    the time
> 
> So let's escape early from the proxy related functions.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>

> ---
>   drivers/irqchip/irq-gic-v3-its.c | 23 ++++++++++++++++++++++-
>   1 file changed, 22 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
> index 220d490d516e..999e61a9b2c3 100644
> --- a/drivers/irqchip/irq-gic-v3-its.c
> +++ b/drivers/irqchip/irq-gic-v3-its.c
> @@ -3069,7 +3069,7 @@ static const struct irq_domain_ops its_domain_ops = {
>   /*
>    * This is insane.
>    *
> - * If a GICv4 doesn't implement Direct LPIs (which is extremely
> + * If a GICv4.0 doesn't implement Direct LPIs (which is extremely
>    * likely), the only way to perform an invalidate is to use a fake
>    * device to issue an INV command, implying that the LPI has first
>    * been mapped to some event on that device. Since this is not exactly
> @@ -3077,9 +3077,18 @@ static const struct irq_domain_ops its_domain_ops = {
>    * only issue an UNMAP if we're short on available slots.
>    *
>    * Broken by design(tm).
> + *
> + * GICv4.1 actually mandates that we're able to invalidate by writing to a
> + * MMIO register. It doesn't implement the whole of DirectLPI, but that's
> + * good enough. And most of the time, we don't even have to invalidate
> + * anything, so that's actually pretty good!

I can't understand the meaning of this last sentence. May I ask for an
explanation? :)


Thanks,
Zenghui

>    */
>   static void its_vpe_db_proxy_unmap_locked(struct its_vpe *vpe)
>   {
> +	/* GICv4.1 doesn't use a proxy, so nothing to do here */
> +	if (gic_rdists->has_rvpeid)
> +		return;
> +
>   	/* Already unmapped? */
>   	if (vpe->vpe_proxy_event == -1)
>   		return;
> @@ -3102,6 +3111,10 @@ static void its_vpe_db_proxy_unmap_locked(struct its_vpe *vpe)
>   
>   static void its_vpe_db_proxy_unmap(struct its_vpe *vpe)
>   {
> +	/* GICv4.1 doesn't use a proxy, so nothing to do here */
> +	if (gic_rdists->has_rvpeid)
> +		return;
> +
>   	if (!gic_rdists->has_direct_lpi) {
>   		unsigned long flags;
>   
> @@ -3113,6 +3126,10 @@ static void its_vpe_db_proxy_unmap(struct its_vpe *vpe)
>   
>   static void its_vpe_db_proxy_map_locked(struct its_vpe *vpe)
>   {
> +	/* GICv4.1 doesn't use a proxy, so nothing to do here */
> +	if (gic_rdists->has_rvpeid)
> +		return;
> +
>   	/* Already mapped? */
>   	if (vpe->vpe_proxy_event != -1)
>   		return;
> @@ -3135,6 +3152,10 @@ static void its_vpe_db_proxy_move(struct its_vpe *vpe, int from, int to)
>   	unsigned long flags;
>   	struct its_collection *target_col;
>   
> +	/* GICv4.1 doesn't use a proxy, so nothing to do here */
> +	if (gic_rdists->has_rvpeid)
> +		return;
> +
>   	if (gic_rdists->has_direct_lpi) {
>   		void __iomem *rdbase;
>   
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
