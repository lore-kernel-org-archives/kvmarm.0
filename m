From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v3 3/4] irqchip: GIC: Convert to EOImode == 1
Date: Tue, 25 Aug 2015 17:46:44 +0200 (CEST)
Message-ID: <alpine.DEB.2.11.1508251745070.15006@nanos>
References: <1440503605-10185-1-git-send-email-marc.zyngier@arm.com> <1440503605-10185-4-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1440503605-10185-4-git-send-email-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Jason Cooper <jason@lakedaemon.net>, Christoffer Dall <christoffer.dall@linaro.org>, Jiang Liu <jiang.liu@linux.intel.com>, Eric Auger <eric.auger@linaro.org>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, 25 Aug 2015, Marc Zyngier wrote:
> +static struct static_key supports_deactivate = STATIC_KEY_INIT_TRUE;
> +
>  #ifndef MAX_GIC_NR
>  #define MAX_GIC_NR	1
>  #endif
> @@ -137,6 +140,14 @@ static inline unsigned int gic_irq(struct irq_data *d)
>  	return d->hwirq;
>  }
>  
> +static inline bool primary_gic_irq(struct irq_data *d)
> +{
> +	if (MAX_GIC_NR > 1)
> +		return irq_data_get_irq_chip_data(d) == &gic_data[0];
> +
> +	return true;
> +}
> +
>  /*
>   * Routines to acknowledge, disable and enable interrupts
>   */
> @@ -164,7 +175,14 @@ static void gic_unmask_irq(struct irq_data *d)
>  
>  static void gic_eoi_irq(struct irq_data *d)
>  {
> -	writel_relaxed(gic_irq(d), gic_cpu_base(d) + GIC_CPU_EOI);
> +	u32 deact_offset = GIC_CPU_EOI;
> +
> +	if (static_key_true(&supports_deactivate)) {
> +		if (primary_gic_irq(d))
> +			deact_offset = GIC_CPU_DEACTIVATE;

I really wonder for the whole series whether you really want all that
static key dance and extra conditionals in the callbacks instead of
just using seperate irq chips for the different interrupts.

Thanks,

	tglx
