From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH 21/33] irqchip/gic-v3-its: Add VPE irq domain
 allocation/teardown
Date: Mon, 13 Feb 2017 11:45:03 +0100 (CET)
Message-ID: <alpine.DEB.2.20.1702131142430.3619@nanos>
References: <1484648454-21216-1-git-send-email-marc.zyngier@arm.com>
 <1484648454-21216-22-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D9D540C38
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Feb 2017 05:44:26 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eQuK+aPMMsEL for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Feb 2017 05:44:25 -0500 (EST)
Received: from Galois.linutronix.de (Galois.linutronix.de [146.0.238.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9A7A840C21
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Feb 2017 05:44:24 -0500 (EST)
In-Reply-To: <1484648454-21216-22-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Jason Cooper <jason@lakedaemon.net>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, 17 Jan 2017, Marc Zyngier wrote:
> +static int its_vpe_irq_domain_alloc(struct irq_domain *domain, unsigned int virq,
> +				    unsigned int nr_irqs, void *args)
> +{
> +	msi_alloc_info_t *info = args;
> +	struct its_vpe **vpes = info->scratchpad[0].ptr;
> +	struct its_vm *vm = vpes[0]->its_vm;
> +	unsigned long *bitmap;
> +	struct page *vprop_page;
> +	int base, nr_ids, i, err = 0;
> +
> +	bitmap = its_lpi_alloc_chunks(nr_irqs, &base, &nr_ids);
> +	if (!bitmap)
> +		return -ENOMEM;
> +
> +	if (nr_ids < nr_irqs) {
> +		its_lpi_free_chunks(bitmap, base, nr_ids);
> +		return -ENOMEM;
> +	}
> +
> +	vprop_page = its_allocate_prop_table(GFP_KERNEL);
> +	if (!vprop_page) {
> +		its_lpi_free_chunks(bitmap, base, nr_ids);
> +		return ENOMEM;
> +	}
> +
> +	for (i = 0; i < nr_irqs; i++) {
> +		vpes[i]->vpe_db_lpi = base + i;
> +		err = its_vpe_init(vpes[i]);
> +		if (err)
> +			break;
> +		irq_domain_set_hwirq_and_chip(domain,
> +					      virq + i, vpes[i]->vpe_db_lpi,
> +					      &its_vpe_irq_chip, vpes[i]);
> +		set_bit(i, bitmap);
> +	}
> +
> +	if (err) {
> +		while (--i >= 0) {
> +			its_vpe_teardown(vpes[i]);
> +			clear_bit(i, bitmap);
> +		}
> +
> +		its_lpi_free_chunks(bitmap, base, nr_ids);
> +		its_free_prop_table(vprop_page);

Couldn't you just do:

	if (err) {
		if (i > 0)
			its_vpe_irq_domain_free(domain, virq, i - 1)

Hmm?

Thanks,

	tglx
