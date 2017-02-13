From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH 06/33] irqchip/gic-v3-its: Add probing for VLPI
 properties
Date: Mon, 13 Feb 2017 11:00:38 +0100 (CET)
Message-ID: <alpine.DEB.2.20.1702131057290.3619@nanos>
References: <1484648454-21216-1-git-send-email-marc.zyngier@arm.com>
 <1484648454-21216-7-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AB72340C25
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Feb 2017 05:00:00 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Q5smE8aJtuv6 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Feb 2017 05:00:00 -0500 (EST)
Received: from Galois.linutronix.de (Galois.linutronix.de [146.0.238.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0A99640BE9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Feb 2017 04:59:59 -0500 (EST)
In-Reply-To: <1484648454-21216-7-git-send-email-marc.zyngier@arm.com>
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
> +	typer = gic_read_typer(its_base + GITS_TYPER);
>  	its->base = its_base;
>  	its->phys_base = res->start;
> -	its->ite_size = ((gic_read_typer(its_base + GITS_TYPER) >> 4) & 0xf) + 1;
> +	its->ite_size = ((typer >> 4) & 0xf) + 1;
> +	its->is_v4 = !!(typer & GITS_TYPER_VLPIS);
> +	if (its->is_v4 && !(typer & GITS_TYPER_VMOVP)) {
> +		int its_number;
> +
> +		its_number = find_first_zero_bit(&its_list_map, 16);

s/16/ITS_MAX_ENTITIES or whatever.

> +		if (its_number >= 16) {
> +			pr_err("ITS@%pa: No ITSList entry available!\n",
> +			       &res->start);
> +			err = -EINVAL;
> +			goto out_free_its;
> +		}
> +
> +		ctlr = readl_relaxed(its_base + GITS_CTLR);
> +		ctlr &= ~GITS_CTLR_ITS_NUMBER;
> +		ctlr |= its_number << GITS_CTLR_ITS_NUMBER_SHIFT;
> +		writel_relaxed(ctlr, its_base + GITS_CTLR);
> +		ctlr = readl_relaxed(its_base + GITS_CTLR);
> +		if ((ctlr & GITS_CTLR_ITS_NUMBER) != (its_number << GITS_CTLR_ITS_NUMBER_SHIFT)) {
> +			its_number = ctlr & GITS_CTLR_ITS_NUMBER;
> +			its_number >>= GITS_CTLR_ITS_NUMBER_SHIFT;
> +		}
> +
> +		if (test_and_set_bit(its_number, &its_list_map)) {

You just established above that the bit is not set. I assume that this is
code which has no concurrency concerns....

Thanks,

	tglx
