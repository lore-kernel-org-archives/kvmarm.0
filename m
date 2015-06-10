From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH V2 1/5] kvm: arm64: Enable ACPI support for virt arch timer
Date: Wed, 10 Jun 2015 14:51:11 +0200
Message-ID: <20150610125111.GA4307@hawk.localdomain>
References: <1433909767-12189-1-git-send-email-wei@redhat.com>
 <1433909767-12189-2-git-send-email-wei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 073CE540EA
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Jun 2015 08:40:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UA+VkdVDtpbA for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Jun 2015 08:40:57 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AA8F9540E8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Jun 2015 08:40:57 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <1433909767-12189-2-git-send-email-wei@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Wei Huang <wei@redhat.com>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, hanjun.guo@linaro.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Jun 10, 2015 at 12:16:03AM -0400, Wei Huang wrote:
> This patches enables ACPI support for KVM virtual arch timer. It allows
> KVM to parse ACPI table for arch timer PPI when DT table is not present.
> 
> Signed-off-by: Alexander Spyridaki <a.spyridakis@virtualopensystems.com>
> Signed-off-by: Wei Huang <wei@redhat.com>
> ---
>  virt/kvm/arm/arch_timer.c | 75 +++++++++++++++++++++++++++++++++++++++--------
>  1 file changed, 62 insertions(+), 13 deletions(-)
> 
> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
> index 98c95f2..a9da75a 100644
> --- a/virt/kvm/arm/arch_timer.c
> +++ b/virt/kvm/arm/arch_timer.c
> @@ -21,6 +21,7 @@
>  #include <linux/kvm.h>
>  #include <linux/kvm_host.h>
>  #include <linux/interrupt.h>
> +#include <linux/acpi.h>
>  
>  #include <clocksource/arm_arch_timer.h>
>  #include <asm/arch_timer.h>
> @@ -274,9 +275,57 @@ static const struct of_device_id arch_timer_of_match[] = {
>  	{},
>  };
>  
> -int kvm_timer_hyp_init(void)
> +static int kvm_timer_ppi_dt_parse(unsigned int *ppi)
>  {
>  	struct device_node *np;
> +
> +	np = of_find_matching_node(NULL, arch_timer_of_match);
> +	if (!np)
> +		return -ENODEV;
> +
> +	*ppi = irq_of_parse_and_map(np, 2);
> +	if (*ppi == 0) {
> +		of_node_put(np);
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +#ifdef CONFIG_ACPI
> +struct acpi_table_gtdt *gtdt_acpi;

I think gtdt_acpi can/should be static.

> +static void arch_timer_acpi_parse(struct acpi_table_header *table)
> +{
> +	gtdt_acpi = container_of(table, struct acpi_table_gtdt, header);
> +}
> +
> +static int kvm_timer_ppi_acpi_parse(unsigned int *ppi)
> +{
> +	u32 flags;
> +	int trigger, polarity;
> +
> +	/*Get the interrupt number from the GTDT table */
> +	acpi_table_parse(ACPI_SIG_GTDT,
> +			 (acpi_tbl_table_handler)arch_timer_acpi_parse);
> +
> +	if (!gtdt_acpi->virtual_timer_interrupt)
> +		return -EINVAL;
> +
> +	flags = gtdt_acpi->virtual_timer_flags;
> +	trigger = (flags & ACPI_GTDT_INTERRUPT_MODE) ? ACPI_EDGE_SENSITIVE
> +		: ACPI_LEVEL_SENSITIVE;
> +	polarity = (flags & ACPI_GTDT_INTERRUPT_POLARITY) ? ACPI_ACTIVE_LOW
> +		: ACPI_ACTIVE_HIGH;
> +
> +	*ppi = acpi_register_gsi(NULL, gtdt_acpi->virtual_timer_interrupt,
> +				 trigger, polarity);
> +
> +	return 0;
> +}
> +#endif
> +
> +int kvm_timer_hyp_init(void)
> +{
>  	unsigned int ppi;
>  	int err;
>  
> @@ -284,19 +333,20 @@ int kvm_timer_hyp_init(void)
>  	if (!timecounter)
>  		return -ENODEV;
>  
> -	np = of_find_matching_node(NULL, arch_timer_of_match);
> -	if (!np) {
> -		kvm_err("kvm_arch_timer: can't find DT node\n");
> -		return -ENODEV;
> -	}
> +	/* PPI parsing: try DT first, then ACPI */
> +	err = kvm_timer_ppi_dt_parse(&ppi);
> +#ifdef CONFIG_ACPI
> +	if (err && !acpi_disabled)
> +		err = kvm_timer_ppi_acpi_parse(&ppi);
> +#endif
>  
> -	ppi = irq_of_parse_and_map(np, 2);
> -	if (!ppi) {
> -		kvm_err("kvm_arch_timer: no virtual timer interrupt\n");
> -		err = -EINVAL;
> -		goto out;
> +	if (err) {
> +		kvm_err("kvm_arch_timer: can't find virtual timer info or "
> +			"config virtual timer interrupt\n");
> +		return err;
>  	}
>  
> +	/* configure IRQ handler */
>  	err = request_percpu_irq(ppi, kvm_arch_timer_handler,
>  				 "kvm guest timer", kvm_get_running_vcpus());
>  	if (err) {
> @@ -319,14 +369,13 @@ int kvm_timer_hyp_init(void)
>  		goto out_free;
>  	}
>  
> -	kvm_info("%s IRQ%d\n", np->name, ppi);
> +	kvm_info("timer IRQ%d\n", ppi);
>  	on_each_cpu(kvm_timer_init_interrupt, NULL, 1);
>  
>  	goto out;
>  out_free:
>  	free_percpu_irq(ppi, kvm_get_running_vcpus());
>  out:
> -	of_node_put(np);
>  	return err;
>  }
>  
> -- 
> 1.8.3.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
