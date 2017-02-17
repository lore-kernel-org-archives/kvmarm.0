From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [RFC PATCH 09/33] irqchip/gic-v3-its: Split out property table
 allocation
Date: Fri, 17 Feb 2017 07:15:34 +0100
Message-ID: <c98bf0f6-884a-3851-aefc-571b0cbce703@redhat.com>
References: <1484648454-21216-1-git-send-email-marc.zyngier@arm.com>
 <1484648454-21216-10-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C8A4440D16
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Feb 2017 01:14:49 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TsgXc4LbU1YJ for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Feb 2017 01:14:48 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E1CAB40CE9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Feb 2017 01:14:48 -0500 (EST)
In-Reply-To: <1484648454-21216-10-git-send-email-marc.zyngier@arm.com>
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

Hi Marc,
On 17/01/2017 11:20, Marc Zyngier wrote:
> Move the LPI property table allocation into its own function, as
> this is going to be required for those associated with VMs in
> the future.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  drivers/irqchip/irq-gic-v3-its.c | 28 ++++++++++++++++++----------
>  1 file changed, 18 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
> index b28fb19..c92ff4d 100644
> --- a/drivers/irqchip/irq-gic-v3-its.c
> +++ b/drivers/irqchip/irq-gic-v3-its.c
> @@ -889,15 +889,31 @@ static void its_lpi_free(struct event_lpi_map *map)
>  	kfree(map->col_map);
>  }
>  
> +static struct page *its_allocate_prop_table(gfp_t gfp_flags)
> +{
> +	struct page *prop_page;
> +
> +	prop_page = alloc_pages(gfp_flags, get_order(LPI_PROPBASE_SZ));
> +	if (!prop_page)
> +		return NULL;
> +
> +	/* Priority 0xa0, Group-1, disabled */
> +	memset(page_address(prop_page),
> +	       LPI_PROP_DEFAULT_PRIO | LPI_PROP_GROUP1,
> +	       LPI_PROPBASE_SZ);
> +
> +	/* Make sure the GIC will observe the written configuration */
> +	gic_flush_dcache_to_poc(page_address(gic_rdists->prop_page), LPI_PROPBASE_SZ);
s/gic_rdists->prop_page/prop_page.

With that fix,

Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric


>  
> +	return prop_page;
> +}
>  
>  
>  static int __init its_alloc_lpi_tables(void)
>  {
>  	phys_addr_t paddr;
>  
> -	gic_rdists->prop_page = alloc_pages(GFP_NOWAIT,
> -					   get_order(LPI_PROPBASE_SZ));
> +	gic_rdists->prop_page = its_allocate_prop_table(GFP_NOWAIT);
>  	if (!gic_rdists->prop_page) {
>  		pr_err("Failed to allocate PROPBASE\n");
>  		return -ENOMEM;
> @@ -906,14 +922,6 @@ static int __init its_alloc_lpi_tables(void)
>  	paddr = page_to_phys(gic_rdists->prop_page);
>  	pr_info("GIC: using LPI property table @%pa\n", &paddr);
>  
> -	/* Priority 0xa0, Group-1, disabled */
> -	memset(page_address(gic_rdists->prop_page),
> -	       LPI_PROP_DEFAULT_PRIO | LPI_PROP_GROUP1,
> -	       LPI_PROPBASE_SZ);
> -
> -	/* Make sure the GIC will observe the written configuration */
> -	gic_flush_dcache_to_poc(page_address(gic_rdists->prop_page), LPI_PROPBASE_SZ);
> -
>  	return 0;
>  }
>  
> 
