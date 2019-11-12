Return-Path: <SRS0=CLkw=ZE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B340C17440
	for <kvmarm@archiver.kernel.org>; Tue, 12 Nov 2019 13:54:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A06BD21D7F
	for <kvmarm@archiver.kernel.org>; Tue, 12 Nov 2019 13:54:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A06BD21D7F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 244B84B1BE;
	Tue, 12 Nov 2019 08:54:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id r4ozSqtOgj16; Tue, 12 Nov 2019 08:54:28 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CE6FF4B178;
	Tue, 12 Nov 2019 08:54:28 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C81164B178
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Nov 2019 08:54:26 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eaMwlUYk7DZ0 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 12 Nov 2019 08:54:24 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DDDD24B163
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Nov 2019 08:54:24 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 504C21FB;
 Tue, 12 Nov 2019 05:54:24 -0800 (PST)
Received: from [10.1.196.63] (e123195-lin.cambridge.arm.com [10.1.196.63])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5FE4D3F6C4;
 Tue, 12 Nov 2019 05:54:23 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH 06/17] arm: gic: Add simple shared IRQ test
To: Andre Przywara <andre.przywara@arm.com>, Andrew Jones
 <drjones@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
References: <20191108144240.204202-1-andre.przywara@arm.com>
 <20191108144240.204202-7-andre.przywara@arm.com>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <de22edec-e562-426d-4d87-dd188d6d75de@arm.com>
Date: Tue, 12 Nov 2019 13:54:22 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191108144240.204202-7-andre.przywara@arm.com>
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
> So far we were testing the GIC's MMIO interface and IPI delivery.
> Add a simple test to trigger a shared IRQ (SPI), using the ISPENDR
> register in the (emulated) GIC distributor.
> This tests configuration of an IRQ (target CPU) and whether it can be
> properly enabled or disabled.
>
> This is a bit more sophisticated than actually needed at this time,
> but paves the way for extending this to FIQs in the future.
>
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  arm/gic.c         | 79 +++++++++++++++++++++++++++++++++++++++++++++++
>  arm/unittests.cfg | 12 +++++++
>  2 files changed, 91 insertions(+)
>
> diff --git a/arm/gic.c b/arm/gic.c
> index c909668..3be76cb 100644
> --- a/arm/gic.c
> +++ b/arm/gic.c
> @@ -546,6 +546,81 @@ static void gic_test_mmio(void)
>  		test_targets(nr_irqs);
>  }
>  
> +static void gic_spi_trigger(int irq)
> +{
> +	gic_set_irq_bit(irq, GICD_ISPENDR);
> +}
> +
> +static void spi_configure_irq(int irq, int cpu)

The function name is slightly misleading - it might be interpreted as configure
irq to target cpu. How about spi_enable_irq?

> +{
> +	gic_set_irq_target(irq, cpu);
> +	gic_set_irq_priority(irq, 0xa0);

It might be worth adding a comment here stating why you have chosen this priority
over priority 0.

> +	gic_enable_irq(irq);
> +}
> +
> +#define IRQ_STAT_NONE		0
> +#define IRQ_STAT_IRQ		1
> +#define IRQ_STAT_TYPE_MASK	0x3
> +#define IRQ_STAT_NO_CLEAR	4
> +
> +/*
> + * Wait for an SPI to fire (or not) on a certain CPU.
> + * Clears the pending bit if requested afterwards.
> + */
> +static void trigger_and_check_spi(const char *test_name,
> +				  unsigned int irq_stat,
> +				  int cpu)
> +{
> +	cpumask_t cpumask;
> +
> +	stats_reset();
> +	gic_spi_trigger(SPI_IRQ);
> +	cpumask_clear(&cpumask);
> +	switch (irq_stat & IRQ_STAT_TYPE_MASK) {
> +	case IRQ_STAT_NONE:
> +		break;
> +	case IRQ_STAT_IRQ:
> +		cpumask_set_cpu(cpu, &cpumask);
> +		break;
> +	}
> +
> +	check_acked(test_name, &cpumask);
> +
> +	/* Clean up pending bit in case this IRQ wasn't taken. */
> +	if (!(irq_stat & IRQ_STAT_NO_CLEAR))
> +		gic_set_irq_bit(SPI_IRQ, GICD_ICPENDR);

There's only one call site which sets this flag. How about you remove the flag
define and the above two lines of code and replace them with one line of code at
the call site? And if you do that, you can turn the flags into proper enums.

> +}
> +
> +static void spi_test_single(void)
> +{
> +	cpumask_t cpumask;
> +	int cpu = smp_processor_id();
> +
> +	spi_configure_irq(SPI_IRQ, cpu);
> +
> +	trigger_and_check_spi("SPI triggered by CPU write", IRQ_STAT_IRQ, cpu);
> +
> +	gic_disable_irq(SPI_IRQ);
> +	trigger_and_check_spi("disabled SPI does not fire",
> +			      IRQ_STAT_NONE | IRQ_STAT_NO_CLEAR, cpu);
> +
> +	stats_reset();
> +	cpumask_clear(&cpumask);
> +	cpumask_set_cpu(cpu, &cpumask);
> +	gic_enable_irq(SPI_IRQ);
> +	check_acked("now enabled SPI fires", &cpumask);
> +}
> +
> +static void spi_send(void)
> +{
> +	irqs_enable();
> +
> +	spi_test_single();

I suggest your rename this to spi_test_self, to match ipi_test_self.

> +
> +	check_spurious();
> +	exit(report_summary());
> +}
> +
>  int main(int argc, char **argv)
>  {
>  	if (!gic_init()) {
> @@ -577,6 +652,10 @@ int main(int argc, char **argv)
>  		report_prefix_push(argv[1]);
>  		gic_test_mmio();
>  		report_prefix_pop();
> +	} else if (strcmp(argv[1], "irq") == 0) {
> +		report_prefix_push(argv[1]);
> +		spi_send();
> +		report_prefix_pop();
>  	} else {
>  		report_abort("Unknown subtest '%s'", argv[1]);
>  	}
> diff --git a/arm/unittests.cfg b/arm/unittests.cfg
> index 12ac142..7a78275 100644
> --- a/arm/unittests.cfg
> +++ b/arm/unittests.cfg
> @@ -92,6 +92,18 @@ smp = $MAX_SMP
>  extra_params = -machine gic-version=3 -append 'ipi'
>  groups = gic
>  
> +[gicv2-spi]
> +file = gic.flat
> +smp = $((($MAX_SMP < 8)?$MAX_SMP:8))
> +extra_params = -machine gic-version=2 -append 'irq'

I think 'spi' as a command line parameter makes more sense for the gic{v2,v3}-spi
tests.

Thanks,
Alex
> +groups = gic
> +
> +[gicv3-spi]
> +file = gic.flat
> +smp = $MAX_SMP
> +extra_params = -machine gic-version=3 -append 'irq'
> +groups = gic
> +
>  [gicv2-max-mmio]
>  file = gic.flat
>  smp = $((($MAX_SMP < 8)?$MAX_SMP:8))
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
