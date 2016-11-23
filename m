From: Andrew Jones <drjones@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v6 11/11] arm/arm64: gic: don't just use
 zero
Date: Wed, 23 Nov 2016 14:46:27 +0100
Message-ID: <20161123134627.gox25oqshkrrqsgv@kamzik.brq.redhat.com>
References: <1479157719-31021-1-git-send-email-drjones@redhat.com>
 <1479157719-31021-12-git-send-email-drjones@redhat.com>
 <90b580c8-e797-9da7-ebe7-e76719427535@redhat.com>
 <20161123130102.rplq3d3ejipcytnw@kamzik.brq.redhat.com>
 <fb04266a-47fd-48b4-3773-1b171c4bd325@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E326B40C42
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Nov 2016 08:45:59 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id n13yKMHLJGSt for <kvmarm@lists.cs.columbia.edu>;
 Wed, 23 Nov 2016 08:45:53 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A075D40878
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Nov 2016 08:45:52 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <fb04266a-47fd-48b4-3773-1b171c4bd325@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Auger Eric <eric.auger@redhat.com>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, andre.przywara@arm.com, qemu-devel@nongnu.org, qemu-arm@nongnu.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Nov 23, 2016 at 02:33:31PM +0100, Auger Eric wrote:
> 
> 
> On 23/11/2016 14:01, Andrew Jones wrote:
> > On Wed, Nov 23, 2016 at 12:28:34PM +0100, Auger Eric wrote:
> >> Hi,
> >>
> >> On 14/11/2016 22:08, Andrew Jones wrote:
> >>> Allow user to select who sends ipis and with which irq,
> >>> rather than just always sending irq=0 from cpu0.
> >> From a user point of view is there a way to know the list of available
> >> tests and their arg?
> > 
> > Not at the moment. I could change the arg-less run and/or add
> > a '-h' though that would provide a usage. So far unit tests
> > have never had -h's, but it's not a bad idea.
> 
> OK thanks for the info
> > 
> >>>
> >>> Signed-off-by: Andrew Jones <drjones@redhat.com>
> >>>
> >>> ---
> >>> v6:
> >>>  - make sender/irq names more future-proof [drew]
> >>>  - sanity check inputs [drew]
> >>>  - introduce check_sender/irq and bad_sender/irq to more
> >>>    cleanly do checks [drew]
> >>>  - default sender and irq to 1, instead of still zero [drew]
> >>> v4: improve structure and make sure spurious checking is
> >>>     done even when the sender isn't cpu0
> >>> v2: actually check that the irq received was the irq sent,
> >>>     and (for gicv2) that the sender is the expected one.
> >>> ---
> >>>  arm/gic.c | 124 +++++++++++++++++++++++++++++++++++++++++++++++++-------------
> >>>  1 file changed, 99 insertions(+), 25 deletions(-)
> >>>
> >>> diff --git a/arm/gic.c b/arm/gic.c
> >>> index d954a3775c26..638b8b140c96 100644
> >>> --- a/arm/gic.c
> >>> +++ b/arm/gic.c
> >>> @@ -11,6 +11,7 @@
> >>>   * This work is licensed under the terms of the GNU LGPL, version 2.
> >>>   */
> >>>  #include <libcflat.h>
> >>> +#include <util.h>
> >>>  #include <asm/setup.h>
> >>>  #include <asm/processor.h>
> >>>  #include <asm/gic.h>
> >>> @@ -28,6 +29,8 @@ struct gic {
> >>>  
> >>>  static struct gic *gic;
> >>>  static int acked[NR_CPUS], spurious[NR_CPUS];
> >>> +static int bad_sender[NR_CPUS], bad_irq[NR_CPUS];
> >>> +static int cmdl_sender = 1, cmdl_irq = 1;
> >>>  static cpumask_t ready;
> >>>  
> >>>  static void nr_cpu_check(int nr)
> >>> @@ -43,10 +46,23 @@ static void wait_on_ready(void)
> >>>  		cpu_relax();
> >>>  }
> >>>  
> >>> +static void stats_reset(void)
> >>> +{
> >>> +	int i;
> >>> +
> >>> +	for (i = 0; i < nr_cpus; ++i) {
> >>> +		acked[i] = 0;
> >>> +		bad_sender[i] = -1;
> >>> +		bad_irq[i] = -1;
> >>> +	}
> >>> +	smp_wmb();
> >>> +}
> >>> +
> >>>  static void check_acked(cpumask_t *mask)
> >>>  {
> >>>  	int missing = 0, extra = 0, unexpected = 0;
> >>>  	int nr_pass, cpu, i;
> >>> +	bool bad = false;
> >>>  
> >>>  	/* Wait up to 5s for all interrupts to be delivered */
> >>>  	for (i = 0; i < 50; ++i) {
> >>> @@ -56,9 +72,21 @@ static void check_acked(cpumask_t *mask)
> >>>  			smp_rmb();
> >>>  			nr_pass += cpumask_test_cpu(cpu, mask) ?
> >>>  				acked[cpu] == 1 : acked[cpu] == 0;
> >>> +
> >>> +			if (bad_sender[cpu] != -1) {
> >>> +				printf("cpu%d received IPI from wrong sender %d\n",
> >>> +					cpu, bad_sender[cpu]);
> >>> +				bad = true;
> >>> +			}
> >>> +
> >>> +			if (bad_irq[cpu] != -1) {
> >>> +				printf("cpu%d received wrong irq %d\n",
> >>> +					cpu, bad_irq[cpu]);
> >>> +				bad = true;
> >>> +			}
> >>>  		}
> >>>  		if (nr_pass == nr_cpus) {
> >>> -			report("Completed in %d ms", true, ++i * 100);
> >>> +			report("Completed in %d ms", !bad, ++i * 100);
> >>>  			return;
> >>>  		}
> >>>  	}
> >>> @@ -91,6 +119,22 @@ static void check_spurious(void)
> >>>  	}
> >>>  }
> >>>  
> >>> +static void check_ipi_sender(u32 irqstat)
> >>> +{
> >>> +	if (gic_version() == 2) {
> >>> +		int src = (irqstat >> 10) & 7;
> >>> +
> >>> +		if (src != cmdl_sender)
> >>> +			bad_sender[smp_processor_id()] = src;
> >>> +	}
> >>> +}
> >>> +
> >>> +static void check_irqnr(u32 irqnr)
> >>> +{
> >>> +	if (irqnr != (u32)cmdl_irq)
> >>> +		bad_irq[smp_processor_id()] = irqnr;
> >>> +}
> >>> +
> >>>  static void ipi_handler(struct pt_regs *regs __unused)
> >>>  {
> >>>  	u32 irqstat = gic_read_iar();
> >>> @@ -98,8 +142,10 @@ static void ipi_handler(struct pt_regs *regs __unused)
> >>>  
> >>>  	if (irqnr != GICC_INT_SPURIOUS) {
> >>>  		gic_write_eoir(irqstat);
> >>> -		smp_rmb(); /* pairs with wmb in ipi_test functions */
> >>> +		smp_rmb(); /* pairs with wmb in stats_reset */
> >>>  		++acked[smp_processor_id()];
> >>> +		check_ipi_sender(irqstat);
> >>> +		check_irqnr(irqnr);
> >>>  		smp_wmb(); /* pairs with rmb in check_acked */
> >>>  	} else {
> >>>  		++spurious[smp_processor_id()];
> >>> @@ -109,19 +155,19 @@ static void ipi_handler(struct pt_regs *regs __unused)
> >>>  
> >>>  static void gicv2_ipi_send_self(void)
> >>>  {
> >>> -	writel(2 << 24, gicv2_dist_base() + GICD_SGIR);
> >>> +	writel(2 << 24 | cmdl_irq, gicv2_dist_base() + GICD_SGIR);
> >>>  }
> >>>  
> >>> -static void gicv2_ipi_send_tlist(cpumask_t *mask, int irq __unused)
> >>> +static void gicv2_ipi_send_tlist(cpumask_t *mask, int irq)
> >>>  {
> >>>  	u8 tlist = (u8)cpumask_bits(mask)[0];
> >>>  
> >>> -	writel(tlist << 16, gicv2_dist_base() + GICD_SGIR);
> >>> +	writel(tlist << 16 | irq, gicv2_dist_base() + GICD_SGIR);
> >>>  }
> >>>  
> >>>  static void gicv2_ipi_send_broadcast(void)
> >>>  {
> >>> -	writel(1 << 24, gicv2_dist_base() + GICD_SGIR);
> >>> +	writel(1 << 24 | cmdl_irq, gicv2_dist_base() + GICD_SGIR);
> >>>  }
> >>>  
> >>>  static void gicv3_ipi_send_self(void)
> >>> @@ -130,12 +176,12 @@ static void gicv3_ipi_send_self(void)
> >>>  
> >>>  	cpumask_clear(&mask);
> >>>  	cpumask_set_cpu(smp_processor_id(), &mask);
> >>> -	gicv3_ipi_send_tlist(&mask, 0);
> >>> +	gicv3_ipi_send_tlist(&mask, cmdl_irq);
> >>>  }
> >>>  
> >>>  static void gicv3_ipi_send_broadcast(void)
> >>>  {
> >>> -	gicv3_write_sgi1r(1ULL << 40);
> >>> +	gicv3_write_sgi1r(1ULL << 40 | cmdl_irq << 24);
> >>>  	isb();
> >>>  }
> >>>  
> >>> @@ -144,10 +190,9 @@ static void ipi_test_self(void)
> >>>  	cpumask_t mask;
> >>>  
> >>>  	report_prefix_push("self");
> >>> -	memset(acked, 0, sizeof(acked));
> >>> -	smp_wmb();
> >>> +	stats_reset();
> >>>  	cpumask_clear(&mask);
> >>> -	cpumask_set_cpu(0, &mask);
> >>> +	cpumask_set_cpu(smp_processor_id(), &mask);
> >>>  	gic->ipi.send_self();
> >>>  	check_acked(&mask);
> >>>  	report_prefix_pop();
> >>> @@ -159,20 +204,18 @@ static void ipi_test_smp(void)
> >>>  	int i;
> >>>  
> >>>  	report_prefix_push("target-list");
> >>> -	memset(acked, 0, sizeof(acked));
> >>> -	smp_wmb();
> >>> +	stats_reset();
> >>>  	cpumask_copy(&mask, &cpu_present_mask);
> >>> -	for (i = 0; i < nr_cpus; i += 2)
> >>> +	for (i = smp_processor_id() & 1; i < nr_cpus; i += 2)
> >>>  		cpumask_clear_cpu(i, &mask);
> >>> -	gic->ipi.send_tlist(&mask, 0);
> >>> +	gic->ipi.send_tlist(&mask, cmdl_irq);
> >>>  	check_acked(&mask);
> >>>  	report_prefix_pop();
> >>>  
> >>>  	report_prefix_push("broadcast");
> >>> -	memset(acked, 0, sizeof(acked));
> >>> -	smp_wmb();
> >>> +	stats_reset();
> >>>  	cpumask_copy(&mask, &cpu_present_mask);
> >>> -	cpumask_clear_cpu(0, &mask);
> >>> +	cpumask_clear_cpu(smp_processor_id(), &mask);
> >>>  	gic->ipi.send_broadcast();
> >>>  	check_acked(&mask);
> >>>  	report_prefix_pop();
> >>> @@ -189,6 +232,16 @@ static void ipi_enable(void)
> >>>  	local_irq_enable();
> >>>  }
> >>>  
> >>> +static void ipi_send(void)
> >>> +{
> >>> +	ipi_enable();
> >>> +	wait_on_ready();
> >>> +	ipi_test_self();
> >>> +	ipi_test_smp();
> >>> +	check_spurious();
> >>> +	exit(report_summary());
> >>> +}
> >>> +
> >>>  static void ipi_recv(void)
> >>>  {
> >>>  	ipi_enable();
> >>> @@ -197,6 +250,14 @@ static void ipi_recv(void)
> >>>  		wfi();
> >>>  }
> >>>  
> >>> +static void ipi_test(void)
> >>> +{
> >>> +	if (smp_processor_id() == cmdl_sender)
> >>> +		ipi_send();
> >>> +	else
> >>> +		ipi_recv();
> >>> +}
> >>> +
> >>>  static struct gic gicv2 = {
> >>>  	.ipi = {
> >>>  		.send_self = gicv2_ipi_send_self,
> >>> @@ -242,21 +303,34 @@ int main(int argc, char **argv)
> >>>  		report_prefix_pop();
> >>>  
> >>>  	} else if (strcmp(argv[1], "ipi") == 0) {
> >>> +		int off, i = 1;
> >>> +		long val;
> >>>  
> >>>  		report_prefix_push(argv[1]);
> >>>  		nr_cpu_check(2);
> >>>  
> >>> +		while (--argc != 1) {
> >>> +			off = parse_keyval(argv[++i], &val);
> >>> +			if (off == -1)
> >>> +				continue;
> >>> +			argv[i][off] = '\0';
> >>> +			if (strcmp(argv[i], "sender") == 0) {
> >>> +				if (val >= nr_cpus)
> >>> +					report_abort("invalid sender %d, nr_cpus=%d", val, nr_cpus);
> >>> +				cmdl_sender = val;
> >>> +			} else if (strcmp(argv[i], "irq") == 0) {
> >>> +				if (val > 15)
> >>> +					report_abort("irq (SGI) must be < 16");
> >>> +				cmdl_irq = val;
> >>> +			}
> >> wrong arg could potentially be tested.
> > 
> > What do you mean by 'wrong arg'? Can you give me an example?
> I meant bad option, ie if the tester makes a typo such as sende=3, this
> gets ignored, right?.

Right, it just gets ignored. I can check for that and add a usage output
here.

Thanks,
drew

> 
> Thanks
> 
> Eric
> > 
> >>
> >> Besides
> >> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> > 
> > Thanks!
> > 
> > drew
> > --
> > To unsubscribe from this list: send the line "unsubscribe kvm" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
