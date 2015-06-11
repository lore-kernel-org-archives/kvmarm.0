From: Hanjun Guo <hanjun.guo@linaro.org>
Subject: Re: [PATCH V2 1/5] kvm: arm64: Enable ACPI support for virt arch
 timer
Date: Thu, 11 Jun 2015 19:27:25 +0800
Message-ID: <5579709D.7080905@linaro.org>
References: <1433909767-12189-1-git-send-email-wei@redhat.com> <1433909767-12189-2-git-send-email-wei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1433909767-12189-2-git-send-email-wei@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Wei Huang <wei@redhat.com>, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, christoffer.dall@linaro.org, pbonzini@redhat.com, drjones@redhat.com, a.spyridakis@virtualopensystems.com
List-Id: kvmarm@lists.cs.columbia.edu

On 06/10/2015 12:16 PM, Wei Huang wrote:
> This patches enables ACPI support for KVM virtual arch timer. It allows
> KVM to parse ACPI table for arch timer PPI when DT table is not present.
>
> Signed-off-by: Alexander Spyridaki <a.spyridakis@virtualopensystems.com>
> Signed-off-by: Wei Huang <wei@redhat.com>
> ---
>   virt/kvm/arm/arch_timer.c | 75 +++++++++++++++++++++++++++++++++++++++--------
>   1 file changed, 62 insertions(+), 13 deletions(-)
>
> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
> index 98c95f2..a9da75a 100644
> --- a/virt/kvm/arm/arch_timer.c
> +++ b/virt/kvm/arm/arch_timer.c
> @@ -21,6 +21,7 @@
>   #include <linux/kvm.h>
>   #include <linux/kvm_host.h>
>   #include <linux/interrupt.h>
> +#include <linux/acpi.h>
>
>   #include <clocksource/arm_arch_timer.h>
>   #include <asm/arch_timer.h>
> @@ -274,9 +275,57 @@ static const struct of_device_id arch_timer_of_match[] = {
>   	{},
>   };
>
> -int kvm_timer_hyp_init(void)
> +static int kvm_timer_ppi_dt_parse(unsigned int *ppi)
>   {
>   	struct device_node *np;
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

...

> +
> +	flags = gtdt_acpi->virtual_timer_flags;
> +	trigger = (flags & ACPI_GTDT_INTERRUPT_MODE) ? ACPI_EDGE_SENSITIVE
> +		: ACPI_LEVEL_SENSITIVE;
> +	polarity = (flags & ACPI_GTDT_INTERRUPT_POLARITY) ? ACPI_ACTIVE_LOW
> +		: ACPI_ACTIVE_HIGH;
> +
> +	*ppi = acpi_register_gsi(NULL, gtdt_acpi->virtual_timer_interrupt,
> +				 trigger, polarity);

Hmm, this is another duplication of getting trigger/polarity and
registering the interrupt, currently we are working on introducing
gtdt.c and put common used functions there [1], but I think this is
just some nitpick, we can refactor it later when that patch set
is accepted.

[1]: https://lkml.org/lkml/2015/6/10/367

Thanks
Hanjun
