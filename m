From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3 3/9] irqchip/gic-v2: Gather ACPI specific data in a
 single structure
Date: Tue, 8 Mar 2016 21:47:10 -0800
Message-ID: <20160309054710.GI26583@lvm>
References: <1457436573-6180-1-git-send-email-julien.grall@arm.com>
 <1457436573-6180-4-git-send-email-julien.grall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 541F9412A2
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2016 00:47:22 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0c+HWS6IDT+F for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Mar 2016 00:47:21 -0500 (EST)
Received: from mail-pf0-f178.google.com (mail-pf0-f178.google.com
 [209.85.192.178])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 05B8E4113E
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2016 00:47:20 -0500 (EST)
Received: by mail-pf0-f178.google.com with SMTP id u190so1894623pfb.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 08 Mar 2016 21:47:24 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1457436573-6180-4-git-send-email-julien.grall@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Julien Grall <julien.grall@arm.com>
Cc: al.stone@linaro.org, kvm@vger.kernel.org, marc.zyngier@arm.com, linux-kernel@vger.kernel.org, fu.wei@linaro.org, Thomas Gleixner <tglx@linutronix.de>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Jason Cooper <jason@lakedaemon.net>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Mar 08, 2016 at 11:29:27AM +0000, Julien Grall wrote:
> For now, there is only one member. More member will be added later.

questionable commit message

> 
> Signed-off-by: Julien Grall <julien.grall@arm.com>
> 
> ---
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Jason Cooper <jason@lakedaemon.net>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> 
>     Changes in v2:
>         - Patch added
> ---
>  drivers/irqchip/irq-gic.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
> index 8f9ebf7..fbde202 100644
> --- a/drivers/irqchip/irq-gic.c
> +++ b/drivers/irqchip/irq-gic.c
> @@ -1245,7 +1245,10 @@ IRQCHIP_DECLARE(pl390, "arm,pl390", gic_of_init);
>  #endif
>  
>  #ifdef CONFIG_ACPI
> -static phys_addr_t cpu_phy_base __initdata;
> +static struct
> +{
> +	phys_addr_t cpu_phy_base;
> +} acpi_data __initdata;
>  
>  static int __init
>  gic_acpi_parse_madt_cpu(struct acpi_subtable_header *header,
> @@ -1265,10 +1268,10 @@ gic_acpi_parse_madt_cpu(struct acpi_subtable_header *header,
>  	 * All CPU interface addresses have to be the same.
>  	 */
>  	gic_cpu_base = processor->base_address;
> -	if (cpu_base_assigned && gic_cpu_base != cpu_phy_base)
> +	if (cpu_base_assigned && gic_cpu_base != acpi_data.cpu_phy_base)
>  		return -EINVAL;
>  
> -	cpu_phy_base = gic_cpu_base;
> +	acpi_data.cpu_phy_base = gic_cpu_base;
>  	cpu_base_assigned = 1;
>  	return 0;
>  }
> @@ -1316,7 +1319,7 @@ static int __init gic_v2_acpi_init(struct acpi_subtable_header *header,
>  		return -EINVAL;
>  	}
>  
> -	cpu_base = ioremap(cpu_phy_base, ACPI_GIC_CPU_IF_MEM_SIZE);
> +	cpu_base = ioremap(acpi_data.cpu_phy_base, ACPI_GIC_CPU_IF_MEM_SIZE);
>  	if (!cpu_base) {
>  		pr_err("Unable to map GICC registers\n");
>  		return -ENOMEM;
> -- 
> 1.9.1
> 
super nit: I would use cpu_phys_base instead of cpu_phy_base, but I'll
leave it up to you.

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
