Return-Path: <SRS0=CLkw=ZE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7137BC43331
	for <kvmarm@archiver.kernel.org>; Tue, 12 Nov 2019 11:11:47 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F08FD2084E
	for <kvmarm@archiver.kernel.org>; Tue, 12 Nov 2019 11:11:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F08FD2084E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 81C904B196;
	Tue, 12 Nov 2019 06:11:46 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WrDNBB31ntBt; Tue, 12 Nov 2019 06:11:45 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A2514B184;
	Tue, 12 Nov 2019 06:11:45 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BAE654B14B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Nov 2019 06:11:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id r859jzoW7j63 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 12 Nov 2019 06:11:42 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6BC464B146
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Nov 2019 06:11:42 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F390A31B;
 Tue, 12 Nov 2019 03:11:41 -0800 (PST)
Received: from [10.1.196.63] (e123195-lin.cambridge.arm.com [10.1.196.63])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0E5A23F6C4;
 Tue, 12 Nov 2019 03:11:40 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH 02/17] arm: gic: Generalise function names
To: Andre Przywara <andre.przywara@arm.com>, Andrew Jones
 <drjones@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
References: <20191108144240.204202-1-andre.przywara@arm.com>
 <20191108144240.204202-3-andre.przywara@arm.com>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <d5162b00-e0c1-132c-225c-a1c16fba3c0a@arm.com>
Date: Tue, 12 Nov 2019 11:11:35 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191108144240.204202-3-andre.przywara@arm.com>
Content-Language: en-US
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
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

Hi,

On 11/8/19 2:42 PM, Andre Przywara wrote:
> In preparation for adding functions to test SPI interrupts, generalise
> some existing functions dealing with IPIs so far, since most of them
> are actually generic for all kind of interrupts.
> This also reformats the irq_handler() function, to later expand it
> more easily.
>
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  arm/gic.c | 40 +++++++++++++++++++++-------------------
>  1 file changed, 21 insertions(+), 19 deletions(-)
>
> diff --git a/arm/gic.c b/arm/gic.c
> index 04b3337..a114009 100644
> --- a/arm/gic.c
> +++ b/arm/gic.c
> @@ -135,28 +135,30 @@ static void check_ipi_sender(u32 irqstat)
>  	}
>  }
>  
> -static void check_irqnr(u32 irqnr)
> +static void check_irqnr(u32 irqnr, int expected)
>  {
> -	if (irqnr != IPI_IRQ)
> +	if (irqnr != expected)
>  		bad_irq[smp_processor_id()] = irqnr;
>  }
>  
> -static void ipi_handler(struct pt_regs *regs __unused)
> +static void irq_handler(struct pt_regs *regs __unused)
>  {
>  	u32 irqstat = gic_read_iar();
>  	u32 irqnr = gic_iar_irqnr(irqstat);
>  
> -	if (irqnr != GICC_INT_SPURIOUS) {
> -		gic_write_eoir(irqstat);
> -		smp_rmb(); /* pairs with wmb in stats_reset */
> -		++acked[smp_processor_id()];
> -		check_ipi_sender(irqstat);
> -		check_irqnr(irqnr);
> -		smp_wmb(); /* pairs with rmb in check_acked */
> -	} else {
> +	if (irqnr == GICC_INT_SPURIOUS) {
>  		++spurious[smp_processor_id()];
>  		smp_wmb();
> +		return;
>  	}
> +
> +	gic_write_eoir(irqstat);
> +
> +	smp_rmb(); /* pairs with wmb in stats_reset */
> +	++acked[smp_processor_id()];
> +	check_ipi_sender(irqstat);
> +	check_irqnr(irqnr, IPI_IRQ);
> +	smp_wmb(); /* pairs with rmb in check_acked */
>  }

I'm not sure this change is necessary. In its current form, it is consistent with
the other irq handler, ipi_clear_active_handler, and your patches add only two
lines: an if statement to check for SPIs and call check_irqnr if true. That is
trivial to integrate in the current handler. Would you care to elaborate why you
think this change is needed?

Thanks,
Alex
>  
>  static void gicv2_ipi_send_self(void)
> @@ -216,20 +218,20 @@ static void ipi_test_smp(void)
>  	report_prefix_pop();
>  }
>  
> -static void ipi_enable(void)
> +static void irqs_enable(void)
>  {
>  	gic_enable_defaults();
>  #ifdef __arm__
> -	install_exception_handler(EXCPTN_IRQ, ipi_handler);
> +	install_exception_handler(EXCPTN_IRQ, irq_handler);
>  #else
> -	install_irq_handler(EL1H_IRQ, ipi_handler);
> +	install_irq_handler(EL1H_IRQ, irq_handler);
>  #endif
>  	local_irq_enable();
>  }
>  
>  static void ipi_send(void)
>  {
> -	ipi_enable();
> +	irqs_enable();
>  	wait_on_ready();
>  	ipi_test_self();
>  	ipi_test_smp();
> @@ -237,9 +239,9 @@ static void ipi_send(void)
>  	exit(report_summary());
>  }
>  
> -static void ipi_recv(void)
> +static void irq_recv(void)
>  {
> -	ipi_enable();
> +	irqs_enable();
>  	cpumask_set_cpu(smp_processor_id(), &ready);
>  	while (1)
>  		wfi();
> @@ -250,7 +252,7 @@ static void ipi_test(void *data __unused)
>  	if (smp_processor_id() == IPI_SENDER)
>  		ipi_send();
>  	else
> -		ipi_recv();
> +		irq_recv();
>  }
>  
>  static struct gic gicv2 = {
> @@ -285,7 +287,7 @@ static void ipi_clear_active_handler(struct pt_regs *regs __unused)
>  
>  		smp_rmb(); /* pairs with wmb in stats_reset */
>  		++acked[smp_processor_id()];
> -		check_irqnr(irqnr);
> +		check_irqnr(irqnr, IPI_IRQ);
>  		smp_wmb(); /* pairs with rmb in check_acked */
>  	} else {
>  		++spurious[smp_processor_id()];
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
