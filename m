Return-Path: <SRS0=WgPl=5B=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AA1AC0044D
	for <kvmarm@archiver.kernel.org>; Mon, 16 Mar 2020 21:43:34 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AE17E206C0
	for <kvmarm@archiver.kernel.org>; Mon, 16 Mar 2020 21:43:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dhn6D3yU"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AE17E206C0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 13FD34A4A0;
	Mon, 16 Mar 2020 17:43:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id CSvwzlyOYGBc; Mon, 16 Mar 2020 17:43:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BD1914B087;
	Mon, 16 Mar 2020 17:43:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BA52B4B085
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Mar 2020 17:43:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MbzFDZ4u9Usc for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 Mar 2020 17:43:29 -0400 (EDT)
Received: from us-smtp-delivery-74.mimecast.com
 (us-smtp-delivery-74.mimecast.com [63.128.21.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9D2024A4A0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Mar 2020 17:43:29 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1584395009;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=Miipgu0UxsqEQXnuF5qqtIQaGQJVXJmSSN/HUx7b+p4=;
 b=dhn6D3yUF0zS0DaQWmzj2S5JwF3bubSx7YC+b4KVg02nH4iagvyqc+z5AWiNXGwQEPZTWQ
 WVvN5cUg6xoSACm7eVdvpttImK6xT+TAQOSY7X6ZrsPKL+aByfZqRWhoslRY2FpoiUhENV
 kvNKaQhmJjx5miYf1ghTywEBbiAaWwI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-162-fGRj8VcfN0-XHR6WqLS96A-1; Mon, 16 Mar 2020 17:43:25 -0400
X-MC-Unique: fGRj8VcfN0-XHR6WqLS96A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
 [10.5.11.23])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3843518A6ECD;
 Mon, 16 Mar 2020 21:43:23 +0000 (UTC)
Received: from [10.3.117.77] (ovpn-117-77.phx2.redhat.com [10.3.117.77])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DDD283AC;
 Mon, 16 Mar 2020 21:43:19 +0000 (UTC)
Subject: Re: [PATCH v5 11/23] irqchip/gic-v4.1: Plumb get/set_irqchip_state
 SGI callbacks
To: Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20200304203330.4967-1-maz@kernel.org>
 <20200304203330.4967-12-maz@kernel.org>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <d6b95eeb-b1c7-802b-e29e-a6c6ecf9ea33@redhat.com>
Date: Mon, 16 Mar 2020 22:43:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20200304203330.4967-12-maz@kernel.org>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Marc,

On 3/4/20 9:33 PM, Marc Zyngier wrote:
> To implement the get/set_irqchip_state callbacks (limited to the
> PENDING state), we have to use a particular set of hacks:
> 
> - Reading the pending state is done by using a pair of new redistributor
>   registers (GICR_VSGIR, GICR_VSGIPENDR), which allow the 16 interrupts
>   state to be retrieved.
> - Setting the pending state is done by generating it as we'd otherwise do
>   for a guest (writing to GITS_SGIR).
> - Clearing the pending state is done by emiting a VSGI command with the
emitting
>   "clear" bit set.
> 
> This requires some interesting locking though:
> - When talking to the redistributor, we must make sure that the VPE
>   affinity doesn't change, hence taking the VPE lock.
> - At the same time, we must ensure that nobody accesses the same
>   redistributor's GICR_VSGI*R registers for a different VPE, which
GICR_VSGIR
>   would corrupt the reading of the pending bits. We thus take the
>   per-RD spinlock. Much fun.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  drivers/irqchip/irq-gic-v3-its.c   | 73 ++++++++++++++++++++++++++++++
>  include/linux/irqchip/arm-gic-v3.h | 14 ++++++
>  2 files changed, 87 insertions(+)
> 
> diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
> index c93f178914ee..fb2b836c31ff 100644
> --- a/drivers/irqchip/irq-gic-v3-its.c
> +++ b/drivers/irqchip/irq-gic-v3-its.c
> @@ -3962,11 +3962,84 @@ static int its_sgi_set_affinity(struct irq_data *d,
>  	return -EINVAL;
>  }
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
> +	void __iomem *base;
> +	unsigned long flags;
> +	u32 count = 1000000;	/* 1s! */
where does it come from? I did not find any info in the spec about this
delay.
> +	u32 status;
> +	int cpu;
> +
> +	if (which != IRQCHIP_STATE_PENDING)
> +		return -EINVAL;
> +
> +	/*
> +	 * Locking galore! We can race against two different events:
> +	 *
> +	 * - Concurent vPE affinity change: we must make sure it cannot
> +         *   happen, or we'll talk to the wrong redistributor. This is
> +         *   identical to what happens with vLPIs.
> +	 *
> +	 * - Concurrent VSGIPENDR access: As it involves accessing two
> +         *   MMIO registers, this must be made atomic one way or another.
> +	 */
> +	cpu = vpe_to_cpuid_lock(vpe, &flags);
> +	raw_spin_lock(&gic_data_rdist_cpu(cpu)->rd_lock);
> +	base = gic_data_rdist_cpu(cpu)->rd_base + SZ_128K;
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
> +	raw_spin_unlock(&gic_data_rdist_cpu(cpu)->rd_lock);
> +	vpe_to_cpuid_unlock(vpe, flags);
> +	*val = !!(status & (1 << d->hwirq));
> +
> +	return 0;
cascade an error on timeout?
> +}
> +
>  static struct irq_chip its_sgi_irq_chip = {
>  	.name			= "GICv4.1-sgi",
>  	.irq_mask		= its_sgi_mask_irq,
>  	.irq_unmask		= its_sgi_unmask_irq,
>  	.irq_set_affinity	= its_sgi_set_affinity,
> +	.irq_set_irqchip_state	= its_sgi_set_irqchip_state,
> +	.irq_get_irqchip_state	= its_sgi_get_irqchip_state,
>  };
>  
>  static int its_sgi_irq_domain_alloc(struct irq_domain *domain,
> diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
> index fd3be49ac9a5..830d2abf14b3 100644
> --- a/include/linux/irqchip/arm-gic-v3.h
> +++ b/include/linux/irqchip/arm-gic-v3.h
> @@ -345,6 +345,15 @@
>  #define GICR_VPENDBASER_4_1_VGRP1EN	(1ULL << 58)
>  #define GICR_VPENDBASER_4_1_VPEID	GENMASK_ULL(15, 0)
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
>  /*
>   * ITS registers, offsets from ITS_base
>   */
> @@ -368,6 +377,11 @@
>  
>  #define GITS_TRANSLATER			0x10040
>  
> +#define GITS_SGIR			0x20020
> +
> +#define GITS_SGIR_VPEID			GENMASK_ULL(47, 32)
> +#define GITS_SGIR_VINTID		GENMASK_ULL(7, 0)
as spotted by Zenghui 3, 0
> +
>  #define GITS_CTLR_ENABLE		(1U << 0)
>  #define GITS_CTLR_ImDe			(1U << 1)
>  #define	GITS_CTLR_ITS_NUMBER_SHIFT	4
> 

Thanks

Eric

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
