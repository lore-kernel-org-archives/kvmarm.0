From: Andrew Jones <drjones@redhat.com>
Subject: Re: [Qemu-devel] [kvm-unit-tests PATCH v3 10/10] arm/arm64: gic:
 don't just use zero
Date: Mon, 17 Oct 2016 21:53:40 +0200
Message-ID: <20161017195340.44qfipzkeb4trpuq@kamzik.brq.redhat.com>
References: <1468587641-7300-1-git-send-email-drjones@redhat.com>
 <1468587641-7300-11-git-send-email-drjones@redhat.com>
 <480c308b-4706-65f7-3c60-2156d801080f@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BCB0C40FA6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Oct 2016 15:43:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7XE+tk9UkpaE for <kvmarm@lists.cs.columbia.edu>;
 Mon, 17 Oct 2016 15:43:27 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A355440F9B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Oct 2016 15:43:27 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <480c308b-4706-65f7-3c60-2156d801080f@redhat.com>
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

On Fri, Sep 02, 2016 at 11:43:33AM +0200, Auger Eric wrote:
> Hi Drew,
> 
> On 15/07/2016 15:00, Andrew Jones wrote:
> > Allow user to select who sends ipis and with which irq,
> > rather than just always sending irq=0 from cpu0.
> > 
> > Signed-off-by: Andrew Jones <drjones@redhat.com>
> > 
> > ---
> > v2: actually check that the irq received was the irq sent,
> >     and (for gicv2) that the sender is the expected one.
> > ---
> >  arm/gic.c | 80 ++++++++++++++++++++++++++++++++++++++++++++++++++-------------
> >  1 file changed, 64 insertions(+), 16 deletions(-)
> > 
> > diff --git a/arm/gic.c b/arm/gic.c
> > index fc7ef241de3e2..d3ab97d4ae470 100644
> > --- a/arm/gic.c
> > +++ b/arm/gic.c
> > @@ -11,6 +11,7 @@
> >   * This work is licensed under the terms of the GNU LGPL, version 2.
> >   */
> >  #include <libcflat.h>
> > +#include <util.h>
> >  #include <asm/setup.h>
> >  #include <asm/processor.h>
> >  #include <asm/gic.h>
> > @@ -33,6 +34,8 @@ static struct gic *gic;
> >  static int gic_version;
> >  static int acked[NR_CPUS], spurious[NR_CPUS];
> >  static cpumask_t ready;
> > +static int sender;
> > +static u32 irq;
> >  
> >  static void nr_cpu_check(int nr)
> >  {
> > @@ -85,7 +88,16 @@ static void check_acked(cpumask_t *mask)
> >  
> >  static u32 gicv2_read_iar(void)
> >  {
> > -	return readl(gicv2_cpu_base() + GIC_CPU_INTACK);
> > +	u32 iar = readl(gicv2_cpu_base() + GIC_CPU_INTACK);
> > +	int src = (iar >> 10) & 7;
> > +
> > +	if (src != sender) {
> > +		report("cpu%d received IPI from unexpected source cpu%d "
> > +		       "(expected cpu%d)",
> > +		       false, smp_processor_id(), src, sender);
> > +	}
> > +
> > +	return iar & 0x3ff;
> you can use GICC_IAR_INT_ID_MASK instead

OK

> >  }
> >  
> >  static void gicv2_write_eoi(u32 irq)
> > @@ -99,9 +111,15 @@ static void ipi_handler(struct pt_regs *regs __unused)
> >  
> >  	if (iar != GICC_INT_SPURIOUS) {
> >  		gic->write_eoi(iar);
> > -		smp_rmb(); /* pairs with wmb in ipi_test functions */
> > -		++acked[smp_processor_id()];
> > -		smp_wmb(); /* pairs with rmb in check_acked */
> > +		if (iar == irq) {
> > +			smp_rmb(); /* pairs with wmb in ipi_test functions */
> > +			++acked[smp_processor_id()];
> > +			smp_wmb(); /* pairs with rmb in check_acked */
> > +		} else {
> > +			report("cpu%d received unexpected irq %u "
> > +			       "(expected %u)",
> > +			       false, smp_processor_id(), iar, irq);
> > +		}
> >  	} else {
> >  		++spurious[smp_processor_id()];
> >  		smp_wmb();
> > @@ -110,19 +128,19 @@ static void ipi_handler(struct pt_regs *regs __unused)
> >  
> >  static void gicv2_ipi_send_self(void)
> >  {
> > -	writel(2 << 24, gicv2_dist_base() + GIC_DIST_SOFTINT);
> > +	writel(2 << 24 | irq, gicv2_dist_base() + GIC_DIST_SOFTINT);
> >  }
> >  
> >  static void gicv2_ipi_send_tlist(cpumask_t *mask)
> >  {
> >  	u8 tlist = (u8)cpumask_bits(mask)[0];
> >  
> > -	writel(tlist << 16, gicv2_dist_base() + GIC_DIST_SOFTINT);
> > +	writel(tlist << 16 | irq, gicv2_dist_base() + GIC_DIST_SOFTINT);
> >  }
> >  
> >  static void gicv2_ipi_send_broadcast(void)
> >  {
> > -	writel(1 << 24, gicv2_dist_base() + GIC_DIST_SOFTINT);
> > +	writel(1 << 24 | irq, gicv2_dist_base() + GIC_DIST_SOFTINT);
> >  }
> >  
> >  #define ICC_SGI1R_AFFINITY_1_SHIFT	16
> > @@ -165,7 +183,7 @@ static void gicv3_ipi_send_tlist(cpumask_t *mask)
> >  
> >  		sgi1r = (MPIDR_TO_SGI_AFFINITY(cluster_id, 3)	|
> >  			 MPIDR_TO_SGI_AFFINITY(cluster_id, 2)	|
> > -			 /* irq << 24				| */
> > +			 irq << 24				|
> >  			 MPIDR_TO_SGI_AFFINITY(cluster_id, 1)	|
> >  			 tlist);
> >  
> > @@ -187,7 +205,7 @@ static void gicv3_ipi_send_self(void)
> >  
> >  static void gicv3_ipi_send_broadcast(void)
> >  {
> > -	gicv3_write_sgi1r(1ULL << 40);
> > +	gicv3_write_sgi1r(1ULL << 40 | irq << 24);
> >  	isb();
> >  }
> >  
> > @@ -199,7 +217,7 @@ static void ipi_test_self(void)
> >  	memset(acked, 0, sizeof(acked));
> >  	smp_wmb();
> >  	cpumask_clear(&mask);
> > -	cpumask_set_cpu(0, &mask);
> > +	cpumask_set_cpu(smp_processor_id(), &mask);
> >  	gic->ipi.send_self();
> >  	check_acked(&mask);
> >  	report_prefix_pop();
> > @@ -214,7 +232,7 @@ static void ipi_test_smp(void)
> >  	memset(acked, 0, sizeof(acked));
> >  	smp_wmb();
> >  	cpumask_copy(&mask, &cpu_present_mask);
> > -	for (i = 0; i < nr_cpus; i += 2)
> > +	for (i = smp_processor_id() & 1; i < nr_cpus; i += 2)
> >  		cpumask_clear_cpu(i, &mask);
> >  	gic->ipi.send_tlist(&mask);
> >  	check_acked(&mask);
> > @@ -224,7 +242,7 @@ static void ipi_test_smp(void)
> >  	memset(acked, 0, sizeof(acked));
> >  	smp_wmb();
> >  	cpumask_copy(&mask, &cpu_present_mask);
> > -	cpumask_clear_cpu(0, &mask);
> > +	cpumask_clear_cpu(smp_processor_id(), &mask);
> >  	gic->ipi.send_broadcast();
> >  	check_acked(&mask);
> >  	report_prefix_pop();
> > @@ -241,6 +259,15 @@ static void ipi_enable(void)
> >  	local_irq_enable();
> >  }
> >  
> > +static void ipi_send(void)
> > +{
> > +	ipi_enable();
> > +	wait_on_ready();
> > +	ipi_test_self();
> > +	ipi_test_smp();
> > +	exit(report_summary());
> > +}
> > +
> >  static void ipi_recv(void)
> >  {
> >  	ipi_enable();
> > @@ -300,19 +327,40 @@ int main(int argc, char **argv)
> >  		report_prefix_pop();
> >  
> >  	} else if (!strcmp(argv[1], "ipi")) {
> > +		int off, i = 1;
> > +		long val;
> >  
> >  		report_prefix_push(argv[1]);
> > +
> > +		while (--argc != 1) {
> > +			off = parse_keyval(argv[++i], &val);
> > +			if (off == -1)
> > +				continue;
> > +			argv[i][off] = '\0';
> > +			if (strcmp(argv[i], "sender") == 0)
> > +				sender = val;
> > +			else if (strcmp(argv[i], "irq") == 0)
> > +				irq = val;
> > +		}
> > +
> >  		nr_cpu_check(2);
> >  		ipi_enable();
> >  
> >  		for_each_present_cpu(cpu) {
> >  			if (cpu == 0)
> >  				continue;
> > -			smp_boot_secondary(cpu, ipi_recv);
> > +			if (cpu == sender)
> > +				smp_boot_secondary(cpu, ipi_send);
> > +			else
> > +				smp_boot_secondary(cpu, ipi_recv);
> > +		}
> > +		if (sender == 0)  {
> > +			wait_on_ready();
> > +			ipi_test_self();
> > +			ipi_test_smp();
> > +		} else {
> > +			ipi_recv();
> >  		}
> > -		wait_on_ready();
> > -		ipi_test_self();
> > -		ipi_test_smp();
> >  
> >  		smp_rmb();
> >  		for_each_present_cpu(cpu) {
> > 
> 
> I ran the tests on both Cavium & Seattle HW without noticing issues.
> 
> I guess the file organization & infra will need to change while adding
> some new tests, removing some globals ... but that's a good start to

Can you explain what you have in mind for removing some globals, changing
things? I can change it now :-)  As for adding new tests, though, while
I think we can extend arm/gic.c with more tests, anytime a unit test
differs too much from a framework of a current unit test (group of tests)
it should just create a new unit test file in arm/ and then do whatever
it likes. The common code lib/* is where changes should be made if the
framework doesn't work - but I should get that as close to right as
possible before merging the series.

> show how to write new tests. I am a bit concerned by the LOCs and
> redundancies with the kernel with possible out-of-sync macros but well I
> think there is no other way.

Me neither. We've debated using kernel headers straight from a kernel
source directory in the past, but opted against it. I don't think we'll
need to synch too much though. If somebody writes a test that needs new
defines, then that's when it can be synched.

> 
> I will spend some time writing some tests within the next weeks.

Awesome. Of course that was some weeks ago that you wrote that :-)

Thanks for the review of the series. I'll send a v4 soon.

drew
