Return-Path: <SRS0=oENQ=XT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE556C432C1
	for <kvmarm@archiver.kernel.org>; Tue, 24 Sep 2019 08:59:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5BC162146E
	for <kvmarm@archiver.kernel.org>; Tue, 24 Sep 2019 08:59:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5BC162146E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EB8AA4A683;
	Tue, 24 Sep 2019 04:59:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zi5QvqrvJYS8; Tue, 24 Sep 2019 04:59:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C6B884A67B;
	Tue, 24 Sep 2019 04:59:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3308E4A66A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Sep 2019 04:59:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gmTStEpRjFYs for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 Sep 2019 04:58:59 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0DD914A650
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Sep 2019 04:58:59 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 73F87142F;
 Tue, 24 Sep 2019 01:58:58 -0700 (PDT)
Received: from localhost (unknown [10.37.6.20])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DF0E23F59C;
 Tue, 24 Sep 2019 01:58:57 -0700 (PDT)
Date: Tue, 24 Sep 2019 09:58:56 +0100
From: Andrew Murray <andrew.murray@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 02/35] irqchip/gic-v3-its: Factor out wait_for_syncr
 primitive
Message-ID: <20190924085855.GM9720@e119886-lin.cambridge.arm.com>
References: <20190923182606.32100-1-maz@kernel.org>
 <20190923182606.32100-3-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190923182606.32100-3-maz@kernel.org>
User-Agent: Mutt/1.10.1+81 (426a6c1) (2018-08-26)
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Jason Cooper <jason@lakedaemon.net>, linux-kernel@vger.kernel.org,
 Thomas Gleixner <tglx@linutronix.de>, kvmarm@lists.cs.columbia.edu
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

On Mon, Sep 23, 2019 at 07:25:33PM +0100, Marc Zyngier wrote:
> Waiting for a redistributor to have performed an operation is a
> common thing to do, and the idiom is already spread around.
> As we're going to make even more use of this, let's have a primitive
> that does just that.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Andrew Murray <andrew.murray@arm.com>

> ---
>  drivers/irqchip/irq-gic-v3-its.c | 15 +++++++++------
>  1 file changed, 9 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
> index 62e54f1a248b..58cb233cf138 100644
> --- a/drivers/irqchip/irq-gic-v3-its.c
> +++ b/drivers/irqchip/irq-gic-v3-its.c
> @@ -1075,6 +1075,12 @@ static void lpi_write_config(struct irq_data *d, u8 clr, u8 set)
>  		dsb(ishst);
>  }
>  
> +static void wait_for_syncr(void __iomem *rdbase)
> +{
> +	while (gic_read_lpir(rdbase + GICR_SYNCR) & 1)
> +		cpu_relax();
> +}
> +
>  static void lpi_update_config(struct irq_data *d, u8 clr, u8 set)
>  {
>  	struct its_device *its_dev = irq_data_get_irq_chip_data(d);
> @@ -2757,8 +2763,7 @@ static void its_vpe_db_proxy_move(struct its_vpe *vpe, int from, int to)
>  
>  		rdbase = per_cpu_ptr(gic_rdists->rdist, from)->rd_base;
>  		gic_write_lpir(vpe->vpe_db_lpi, rdbase + GICR_CLRLPIR);
> -		while (gic_read_lpir(rdbase + GICR_SYNCR) & 1)
> -			cpu_relax();
> +		wait_for_syncr(rdbase);
>  
>  		return;
>  	}
> @@ -2914,8 +2919,7 @@ static void its_vpe_send_inv(struct irq_data *d)
>  
>  		rdbase = per_cpu_ptr(gic_rdists->rdist, vpe->col_idx)->rd_base;
>  		gic_write_lpir(vpe->vpe_db_lpi, rdbase + GICR_INVLPIR);
> -		while (gic_read_lpir(rdbase + GICR_SYNCR) & 1)
> -			cpu_relax();
> +		wait_for_syncr(rdbase);
>  	} else {
>  		its_vpe_send_cmd(vpe, its_send_inv);
>  	}
> @@ -2957,8 +2961,7 @@ static int its_vpe_set_irqchip_state(struct irq_data *d,
>  			gic_write_lpir(vpe->vpe_db_lpi, rdbase + GICR_SETLPIR);
>  		} else {
>  			gic_write_lpir(vpe->vpe_db_lpi, rdbase + GICR_CLRLPIR);
> -			while (gic_read_lpir(rdbase + GICR_SYNCR) & 1)
> -				cpu_relax();
> +			wait_for_syncr(rdbase);
>  		}
>  	} else {
>  		if (state)
> -- 
> 2.20.1
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
