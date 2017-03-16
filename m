From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [RFC PATCH 12/33] irqchip/gic-v3-its: Rework LPI freeing
Date: Thu, 16 Mar 2017 09:57:42 +0100
Message-ID: <11c696bd-b044-285e-a699-716e644a1a99@redhat.com>
References: <1484648454-21216-1-git-send-email-marc.zyngier@arm.com>
 <1484648454-21216-13-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E947240B40
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Mar 2017 04:56:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SZldx+vT5kl9 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 16 Mar 2017 04:56:08 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 177BD40430
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Mar 2017 04:56:08 -0400 (EDT)
In-Reply-To: <1484648454-21216-13-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 17/01/2017 11:20, Marc Zyngier wrote:
> Rework LPI deallocation so that it can be reused by the v4 support
> code.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  drivers/irqchip/irq-gic-v3-its.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
> index dce8f8c..5d96b37 100644
> --- a/drivers/irqchip/irq-gic-v3-its.c
> +++ b/drivers/irqchip/irq-gic-v3-its.c
> @@ -865,10 +865,8 @@ static unsigned long *its_lpi_alloc_chunks(int nr_irqs, int *base, int *nr_ids)
>  	return bitmap;
>  }
>  
> -static void its_lpi_free(struct event_lpi_map *map)
> +static void its_lpi_free_chunks(unsigned long *bitmap, int base, int nr_ids)
>  {
> -	int base = map->lpi_base;
> -	int nr_ids = map->nr_lpis;
>  	int lpi;
nit: while you are touching the function you may add a blank line after
chunk declaration in the for block

Besides

Reviewed-by: Eric Auger <eric.auger@redhat.com>

>  
>  	spin_lock(&lpi_lock);
> @@ -885,8 +883,7 @@ static void its_lpi_free(struct event_lpi_map *map)
>  
>  	spin_unlock(&lpi_lock);
>  
> -	kfree(map->lpi_map);
> -	kfree(map->col_map);
> +	kfree(bitmap);
>  }
>  
>  static struct page *its_allocate_prop_table(gfp_t gfp_flags)
> @@ -1654,7 +1651,10 @@ static void its_irq_domain_free(struct irq_domain *domain, unsigned int virq,
>  	/* If all interrupts have been freed, start mopping the floor */
>  	if (bitmap_empty(its_dev->event_map.lpi_map,
>  			 its_dev->event_map.nr_lpis)) {
> -		its_lpi_free(&its_dev->event_map);
> +		its_lpi_free_chunks(its_dev->event_map.lpi_map,
> +				    its_dev->event_map.lpi_base,
> +				    its_dev->event_map.nr_lpis);
> +		kfree(its_dev->event_map.col_map);
>  
>  		/* Unmap device/itt */
>  		its_send_mapd(its_dev, 0);
> 
