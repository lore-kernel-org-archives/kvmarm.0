Return-Path: <SRS0=w40L=FW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D683C4361B
	for <kvmarm@archiver.kernel.org>; Fri, 18 Dec 2020 15:52:59 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1B67D23B74
	for <kvmarm@archiver.kernel.org>; Fri, 18 Dec 2020 15:52:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1B67D23B74
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B1C2D4B0BC;
	Fri, 18 Dec 2020 10:52:58 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rBMu4jv1XRGK; Fri, 18 Dec 2020 10:52:57 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 052754B0DB;
	Fri, 18 Dec 2020 10:52:57 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6CCA74B0BC
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Dec 2020 10:52:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sHNNBfyMuK3l for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Dec 2020 10:52:54 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B9B54B0E5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Dec 2020 10:52:54 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9FE12101E;
 Fri, 18 Dec 2020 07:52:53 -0800 (PST)
Received: from [192.168.2.22] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8B1463F66B;
 Fri, 18 Dec 2020 07:52:52 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH v2 09/12] arm/arm64: gic: Make
 check_acked() more generic
To: Alexandru Elisei <alexandru.elisei@arm.com>, drjones@redhat.com,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
References: <20201217141400.106137-1-alexandru.elisei@arm.com>
 <20201217141400.106137-10-alexandru.elisei@arm.com>
From: =?UTF-8?Q?Andr=c3=a9_Przywara?= <andre.przywara@arm.com>
Organization: ARM Ltd.
Message-ID: <03d0cfff-d7ce-3227-c6ec-7213b09dfd65@arm.com>
Date: Fri, 18 Dec 2020 15:52:41 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201217141400.106137-10-alexandru.elisei@arm.com>
Content-Language: en-GB
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

On 17/12/2020 14:13, Alexandru Elisei wrote:
> Testing that an interrupt is received as expected is done in three places:
> in check_ipi_sender(), check_irqnr() and check_acked(). check_irqnr()
> compares the interrupt ID with IPI_IRQ and records a failure in bad_irq,
> and check_ipi_sender() compares the sender with IPI_SENDER and writes to
> bad_sender when they don't match.
> 
> Let's move all the checks to check_acked() by renaming
> bad_sender->irq_sender and bad_irq->irq_number and changing their semantics
> so they record the interrupt sender, respectively the irq number.
> check_acked() now takes two new parameters: the expected interrupt number
> and sender.
> 
> This has two distinct advantages:
> 
> 1. check_acked() and ipi_handler() can now be used for interrupts other
>    than IPIs.
> 2. Correctness checks are consolidated in one function.
> 
> CC: Andre Przywara <andre.przywara@arm.com>
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>

Look all like valid transformations to me, and indeed it's more reusable
now:

Reviewed-by: Andre Przywara <andre.przywara@arm.com>

Cheers,
Andre

> ---
>  arm/gic.c | 68 +++++++++++++++++++++++++++----------------------------
>  1 file changed, 33 insertions(+), 35 deletions(-)
> 
> diff --git a/arm/gic.c b/arm/gic.c
> index a9ef1a5def56..fb91861900b7 100644
> --- a/arm/gic.c
> +++ b/arm/gic.c
> @@ -35,7 +35,7 @@ struct gic {
>  
>  static struct gic *gic;
>  static int acked[NR_CPUS], spurious[NR_CPUS];
> -static int bad_sender[NR_CPUS], bad_irq[NR_CPUS];
> +static int irq_sender[NR_CPUS], irq_number[NR_CPUS];
>  static cpumask_t ready;
>  
>  static void nr_cpu_check(int nr)
> @@ -57,8 +57,8 @@ static void stats_reset(void)
>  
>  	for (i = 0; i < nr_cpus; ++i) {
>  		acked[i] = 0;
> -		bad_sender[i] = -1;
> -		bad_irq[i] = -1;
> +		irq_sender[i] = -1;
> +		irq_number[i] = -1;
>  	}
>  }
>  
> @@ -92,9 +92,10 @@ static void wait_for_interrupts(cpumask_t *mask)
>  	report_info("interrupts timed-out (5s)");
>  }
>  
> -static bool check_acked(cpumask_t *mask)
> +static bool check_acked(cpumask_t *mask, int sender, int irqnum)
>  {
>  	int missing = 0, extra = 0, unexpected = 0;
> +	bool has_gicv2 = (gic_version() == 2);
>  	bool pass = true;
>  	int cpu;
>  
> @@ -108,17 +109,19 @@ static bool check_acked(cpumask_t *mask)
>  			if (acked[cpu])
>  				++unexpected;
>  		}
> +		if (!acked[cpu])
> +			continue;
>  		smp_rmb(); /* pairs with smp_wmb in ipi_handler */
>  
> -		if (bad_sender[cpu] != -1) {
> +		if (has_gicv2 && irq_sender[cpu] != sender) {
>  			report_info("cpu%d received IPI from wrong sender %d",
> -					cpu, bad_sender[cpu]);
> +					cpu, irq_sender[cpu]);
>  			pass = false;
>  		}
>  
> -		if (bad_irq[cpu] != -1) {
> +		if (irq_number[cpu] != irqnum) {
>  			report_info("cpu%d received wrong irq %d",
> -					cpu, bad_irq[cpu]);
> +					cpu, irq_number[cpu]);
>  			pass = false;
>  		}
>  	}
> @@ -143,26 +146,18 @@ static void check_spurious(void)
>  	}
>  }
>  
> -static void check_ipi_sender(u32 irqstat, int sender)
> +static int gic_get_sender(int irqstat)
>  {
> -	if (gic_version() == 2) {
> -		int src = (irqstat >> 10) & 7;
> -
> -		if (src != sender)
> -			bad_sender[smp_processor_id()] = src;
> -	}
> -}
> -
> -static void check_irqnr(u32 irqnr)
> -{
> -	if (irqnr != IPI_IRQ)
> -		bad_irq[smp_processor_id()] = irqnr;
> +	if (gic_version() == 2)
> +		return (irqstat >> 10) & 7;
> +	return -1;
>  }
>  
>  static void ipi_handler(struct pt_regs *regs __unused)
>  {
>  	u32 irqstat = gic_read_iar();
>  	u32 irqnr = gic_iar_irqnr(irqstat);
> +	int this_cpu = smp_processor_id();
>  
>  	if (irqnr != GICC_INT_SPURIOUS) {
>  		gic_write_eoir(irqstat);
> @@ -173,12 +168,12 @@ static void ipi_handler(struct pt_regs *regs __unused)
>  		 */
>  		if (gic_version() == 2)
>  			smp_rmb();
> -		check_ipi_sender(irqstat, IPI_SENDER);
> -		check_irqnr(irqnr);
> +		irq_sender[this_cpu] = gic_get_sender(irqstat);
> +		irq_number[this_cpu] = irqnr;
>  		smp_wmb(); /* pairs with smp_rmb in check_acked */
> -		++acked[smp_processor_id()];
> +		++acked[this_cpu];
>  	} else {
> -		++spurious[smp_processor_id()];
> +		++spurious[this_cpu];
>  	}
>  
>  	/* Wait for writes to acked/spurious to complete */
> @@ -314,40 +309,42 @@ static void gicv3_ipi_send_broadcast(void)
>  
>  static void ipi_test_self(void)
>  {
> +	int this_cpu = smp_processor_id();
>  	cpumask_t mask;
>  
>  	report_prefix_push("self");
>  	stats_reset();
>  	cpumask_clear(&mask);
> -	cpumask_set_cpu(smp_processor_id(), &mask);
> +	cpumask_set_cpu(this_cpu, &mask);
>  	gic->ipi.send_self();
>  	wait_for_interrupts(&mask);
> -	report(check_acked(&mask), "Interrupts received");
> +	report(check_acked(&mask, this_cpu, IPI_IRQ), "Interrupts received");
>  	report_prefix_pop();
>  }
>  
>  static void ipi_test_smp(void)
>  {
> +	int this_cpu = smp_processor_id();
>  	cpumask_t mask;
>  	int i;
>  
>  	report_prefix_push("target-list");
>  	stats_reset();
>  	cpumask_copy(&mask, &cpu_present_mask);
> -	for (i = smp_processor_id() & 1; i < nr_cpus; i += 2)
> +	for (i = this_cpu & 1; i < nr_cpus; i += 2)
>  		cpumask_clear_cpu(i, &mask);
>  	gic_ipi_send_mask(IPI_IRQ, &mask);
>  	wait_for_interrupts(&mask);
> -	report(check_acked(&mask), "Interrupts received");
> +	report(check_acked(&mask, this_cpu, IPI_IRQ), "Interrupts received");
>  	report_prefix_pop();
>  
>  	report_prefix_push("broadcast");
>  	stats_reset();
>  	cpumask_copy(&mask, &cpu_present_mask);
> -	cpumask_clear_cpu(smp_processor_id(), &mask);
> +	cpumask_clear_cpu(this_cpu, &mask);
>  	gic->ipi.send_broadcast();
>  	wait_for_interrupts(&mask);
> -	report(check_acked(&mask), "Interrupts received");
> +	report(check_acked(&mask, this_cpu, IPI_IRQ), "Interrupts received");
>  	report_prefix_pop();
>  }
>  
> @@ -396,6 +393,7 @@ static void ipi_clear_active_handler(struct pt_regs *regs __unused)
>  {
>  	u32 irqstat = gic_read_iar();
>  	u32 irqnr = gic_iar_irqnr(irqstat);
> +	int this_cpu = smp_processor_id();
>  
>  	if (irqnr != GICC_INT_SPURIOUS) {
>  		void *base;
> @@ -408,11 +406,11 @@ static void ipi_clear_active_handler(struct pt_regs *regs __unused)
>  
>  		writel(val, base + GICD_ICACTIVER);
>  
> -		check_ipi_sender(irqstat, smp_processor_id());
> -		check_irqnr(irqnr);
> -		++acked[smp_processor_id()];
> +		irq_sender[this_cpu] = gic_get_sender(irqstat);
> +		irq_number[this_cpu] = irqnr;
> +		++acked[this_cpu];
>  	} else {
> -		++spurious[smp_processor_id()];
> +		++spurious[this_cpu];
>  	}
>  }
>  
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
