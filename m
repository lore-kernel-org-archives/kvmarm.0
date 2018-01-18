From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v3 2/2] arm64: add micro test
Date: Thu, 18 Jan 2018 11:37:37 +0100
Message-ID: <20180118103737.jiwf5ly3up6w7f7r@kamzik.brq.redhat.com>
References: <1516225596-27071-1-git-send-email-shihwei@cs.columbia.edu>
 <1516225596-27071-3-git-send-email-shihwei@cs.columbia.edu>
 <20180118100958.j4iiq3ep2uruikss@yury-thinkpad>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 207F349E01
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Jan 2018 05:32:38 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id P5CzU7pgaKPK for <kvmarm@lists.cs.columbia.edu>;
 Thu, 18 Jan 2018 05:32:36 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 959A649DFD
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Jan 2018 05:32:36 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20180118100958.j4iiq3ep2uruikss@yury-thinkpad>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Yury Norov <ynorov@caviumnetworks.com>
Cc: Christoffer Dall <cdall@cs.columbia.edu>, kvm@vger.kernel.org, marc.zyngier@arm.com, Shih-Wei Li <shihwei@cs.columbia.edu>, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Jan 18, 2018 at 01:09:58PM +0300, Yury Norov wrote:
> On Wed, Jan 17, 2018 at 04:46:36PM -0500, Shih-Wei Li wrote:
> > Here we provide the support for measuring various micro level
> > operations on arm64. We iterate each of the tests and output
> > their average, minimum and maximum cost in microseconds.
> > Instruction barriers were used before taking timestamps to
> > avoid out-of-order execution or pipelining from skewing our
> > measurements.
> > 
> > The operations we currently supported and measured are mostly
> > self-explanatory by their function name. For IPI, we measured the
> > cost of sending IPI from a source VCPU to a target VCPU, until the
> > target VCPU receives the IPI.
> > 
> > Signed-off-by: Shih-Wei Li <shihwei@cs.columbia.edu>
> > Signed-off-by: Christoffer Dall <cdall@cs.columbia.edu>
> > ---
> >  arm/Makefile.common |   1 +
> >  arm/micro-test.c    | 252 ++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  arm/unittests.cfg   |   7 ++
> >  3 files changed, 260 insertions(+)
> >  create mode 100644 arm/micro-test.c
> > 
> > diff --git a/arm/Makefile.common b/arm/Makefile.common
> > index 0a039cf..c7d5c27 100644
> > --- a/arm/Makefile.common
> > +++ b/arm/Makefile.common
> > @@ -16,6 +16,7 @@ tests-common += $(TEST_DIR)/pmu.flat
> >  tests-common += $(TEST_DIR)/gic.flat
> >  tests-common += $(TEST_DIR)/psci.flat
> >  tests-common += $(TEST_DIR)/sieve.flat
> > +tests-common += $(TEST_DIR)/micro-test.flat
> >  
> >  tests-all = $(tests-common) $(tests)
> >  all: directories $(tests-all)
> > diff --git a/arm/micro-test.c b/arm/micro-test.c
> > new file mode 100644
> > index 0000000..407ce8b
> > --- /dev/null
> > +++ b/arm/micro-test.c
> > @@ -0,0 +1,252 @@
> > +/*
> > + * Measure the cost of micro level operations.
> > + *
> > + * Copyright Columbia University
> > + * Author: Shih-Wei Li <shihwei@cs.columbia.edu>
> > + * Author: Christoffer Dall <cdall@cs.columbia.edu>
> > + *
> > + * This work is licensed under the terms of the GNU LGPL, version 2.
> > + */
> > +#include <asm/gic.h>
> > +#include "libcflat.h"
> > +#include <util.h>
> > +#include <limits.h>
> > +
> > +static volatile bool ipi_received;
> > +static volatile bool ipi_ready;
> > +static volatile unsigned int cntfrq;
> > +static volatile void *vgic_dist_addr;
> 
> Volatiles considered harmful for kernel code. I think it is also correct
> for your case:
> https://lwn.net/Articles/234017/
> 
> I would prefer use readl/writel accessors for interprocessor
> communications which guaranties cache synchronization and proper
> ordering.
> 
> Also, ipi_received and ipi_ready are looking like synchronization
> primitives. Did you consider using spinlocks instead?
> 
> Also-also, cntfrq is written only once at init. What for you make it
> volatile?

We frequently take some shortcuts in kvm-unit-tests, using busy loops and
volatile globals for synchronization, trying to keep things as simple as
possible. I'm ok with the ipi_* synchronization variables being volatile,
but agree the other two don't need to be.

> 
> > +void (*write_eoir)(u32 irqstat);
> > +
> > +#define IPI_IRQ		1
> > +
> > +#define TRIES	(1U << 28)
> > +
> > +#define MAX_FAILURES	1000
> > +
> > +/*
> > + * The counter may not always start with zero, which means it could
> > + * overflow after some period of time.
> > + */
> > +#define COUNT(c1, c2) \
> > +	((c1) > (c2) ? 0 : (c2) - (c1))
> > +
> > +static uint64_t read_cc(void)
> > +{
> > +	isb();
> > +	return read_sysreg(cntpct_el0);
> > +}
> > +
> > +static void ipi_irq_handler(struct pt_regs *regs __unused)
> > +{
> > +	u32 ack;
> > +	ipi_ready = false;
> > +	ipi_received = true;
> > +	ack = gic_read_iar();
> > +	gic_write_eoir(ack);
> > +	ipi_ready = true;
> > +}
> > +
> > +static void ipi_test_secondary_entry(void *data __unused)
> > +{
> > +	enum vector v = EL1H_IRQ;
> > +	install_irq_handler(v, ipi_irq_handler);
> > +
> > +	gic_enable_defaults();
> > +
> > +	local_irq_enable(); /* Enter small wait-loop */
> > +	ipi_ready = true;
> > +	while (true);
> > +}
> > +
> > +static int test_init(void)
> > +{
> > +	int v;
> > +
> > +	v = gic_init();
> > +	if (v == 2) {
> > +		vgic_dist_addr = gicv2_dist_base();
> > +		write_eoir = gicv2_write_eoir;
> > +	} else if (v == 3) {
> > +		vgic_dist_addr = gicv3_dist_base();
> > +		write_eoir = gicv3_write_eoir;
> > +	} else {
> > +		printf("No supported gic present, skipping tests...\n");
> > +		return 0;
> > +	}
> > +
> > +	ipi_ready = false;
> > +
> > +	gic_enable_defaults();
> > +	on_cpu_async(1, ipi_test_secondary_entry, 0);
> > +
> > +	cntfrq = get_cntfrq();
> > +	printf("Timer Frequency %d Hz (Output in microseconds)\n", cntfrq);
> > +
> > +	return 1;
> > +}
> > +
> > +static unsigned long ipi_test(void)
> > +{
> > +	unsigned int tries = TRIES;
> > +	uint64_t c1, c2;
> > +
> > +	while (!ipi_ready && tries--);
> > +	assert(ipi_ready);
> > +
> > +	ipi_received = false;
> > +
> > +	c1 = read_cc();
> > +
> > +	gic_ipi_send_single(IPI_IRQ, 1);
> > +
> > +	tries = TRIES;
> > +	while (!ipi_received && tries--);
> > +	assert(ipi_received);
> > +
> > +	c2 = read_cc();
> > +	return COUNT(c1, c2);
> > +}
> > +
> > +static unsigned long hvc_test(void)
> > +{
> > +	uint64_t c1, c2;
> > +
> > +	c1 = read_cc();
> > +	asm volatile("mov w0, #0x4b000000; hvc #0" ::: "w0");
> > +	c2 = read_cc();
> > +	return COUNT(c1, c2);
> > +}
> > +
> > +static unsigned long mmio_read_user(void)
> > +{
> > +	uint64_t c1, c2;
> > +	/*
> > +	 * FIXME: Read device-id in virtio mmio here. This address
> > +	 * needs to be updated in the future if any relevent
> > +	 * changes in QEMU test-dev are made.
> > +	 */
> > +	void *mmio_read_user_addr = (void*) 0x0a000008;
> 
> Again, could you rename it? device_id_ptr sounds much better.
> 
> > +	c1 = read_cc();
> > +	readl(mmio_read_user_addr);
> > +	c2 = read_cc();
> > +	return COUNT(c1, c2);
> > +}
> > +
> > +static unsigned long mmio_read_vgic(void)
> > +{
> > +	uint64_t c1, c2;
> > +
> > +	c1 = read_cc();
> > +	readl(vgic_dist_addr + GICD_IIDR);
> > +	c2 = read_cc();
> > +	return COUNT(c1, c2);
> > +}
> > +
> > +static unsigned long eoi_test(void)
> > +{
> > +	uint64_t c1, c2;
> > +
> > +	u32 val = 1023; /* spurious IDs, writes to EOI are ignored */
> > +
> > +	/* Avoid measuring assert(..) in gic_write_eoir */
> > +	c1 = read_cc();
> > +	write_eoir(val);
> > +	c2 = read_cc();
> > +
> > +	return COUNT(c1, c2);
> > +}
> > +
> > +struct exit_test {
> > +	const char *name;
> > +	unsigned long (*test_fn)(void);
> > +	bool run;
> > +};
> > +
> > +static struct exit_test tests[] = {
> > +	{"hvc",                hvc_test,           true},
> > +	{"mmio_read_user",     mmio_read_user,     true},
> > +	{"mmio_read_vgic",     mmio_read_vgic,     true},
> > +	{"eoi",                eoi_test,           true},
> > +	{"ipi",                ipi_test,           true},
> > +};
> > +
> > +static void get_us_output(const char *name,
> > +			  unsigned long cycles)
> > +{
> > +	unsigned int ns_per_cycle = 10^9U / cntfrq;
> > +	unsigned int ns, us, us_frac;
> 
> '^' is 'xor', you probably mean 1000*1000*1000. And anyway,
> ThunderX2 works at ~2GHz, so 10E9/get_cntfrq() is 0 for it.

The counter (cntpct_el0) ticks that fast? We could start with picoseconds
if necessary.

> 
> For CPUs working at 500...1000 MHz, ns_per_cycle is 1,
> For CPUs working at 1GHz+ it is 0. What's point in it?

We're not looking at the CPU cycles, we're looking at counter ticks.
Indeed we could rename cycles to ticks everywhere to make that more
explicit.

> 
> > +	ns =  cycles * ns_per_cycle;
> > +	us = ns / 1000;
> > +	us_frac = (ns % 1000) / 100;
> > +
> > +	printf("%s %10d.%d\t", name, us, us_frac);
> > +}
> > +
> > +static void output_result(const char *name,
> > +			  unsigned long avg_cycle,
> > +			  unsigned long min_cycle,
> > +			  unsigned long max_cycle)
> > +{
> > +	printf("%10s:\t", name);
> > +	get_us_output("avg", avg_cycle);
> > +	get_us_output("min", min_cycle);
> > +	get_us_output("max", max_cycle);
> > +	printf("\n");
> > +}
> > +
> > +static void loop_test(struct exit_test *test)
> > +{
> > +	unsigned long i, iterations = 32;
> > +	unsigned long sample, cycles;
> > +	unsigned long min = ULONG_MAX, max = 0;
> > +	const unsigned long goal = (1ULL << 26);
> > +	int failures = 0;
> > +
> > +	do {
> > +		iterations *= 2;
> > +		cycles = 0;
> > +		i = 0;
> > +		while (i < iterations) {
> > +			sample = test->test_fn();
> > +			if (sample == 0) {
> > +				if (failures++ > MAX_FAILURES) {
> > +				/*
> > +				 * If the cost is smaller than a cycle count for
> > +				 * over MAX_FAILURES of times, we simply ignore the test.
> > +				 */
> > +					printf("%s: Too many cycle count overflows\n",
> > +						test->name);
> 
> Again, this is not overflow. Printed message does not correspond the
> comment. 
> 
> Also, why do you think that sample == 0 means fail? I'd rather suspect my
> measurement procedure, or if everything is correct, simply take this
> result.

I agree that we don't need to skip the test, giving no feedback to the
user at all about the time the test takes. The '== 0' result should
output something indicating the test executed in less time than 1/cntfrq.

> 
> Now sample == 0 indicates 2 different cases - too small cost and
> overflow. Could you introduce special error code to distinguish
> between them?

I agree we should do that as well in order to output the test was too
fast to get non-zero samples vs. skipping the sample due to overflow.

> 
> > +					return;
> > +				}
> > +				continue;
> > +			}
> > +			cycles += sample;
> > +			if (min > sample)
> > +				min = sample;
> > +			if (max < sample)
> > +				max = sample;
> > +			++i;
> > +		}
> > +	} while (cycles < goal);
> > +
> > +	output_result(test->name, (cycles / iterations), min, max);	
> > +}
> > +
> > +int main(int argc, char **argv)
> > +{
> > +	int i, ret;
> > +
> > +	ret = test_init();
> > +	assert(ret);
> > +
> > +	for (i = 0; i < ARRAY_SIZE(tests); i++) {
> > +		if (!tests[i].run)
> > +			continue;
> > +		loop_test(&tests[i]);
> > +	}
> > +
> > +	return 0;
> > +}
> > diff --git a/arm/unittests.cfg b/arm/unittests.cfg
> > index 44b98cf..5759fa8 100644
> > --- a/arm/unittests.cfg
> > +++ b/arm/unittests.cfg
> > @@ -116,3 +116,10 @@ file = timer.flat
> >  groups = timer
> >  timeout = 2s
> >  arch = arm64
> > +
> > +# Exit tests
> > +[micro-test]
> > +file = micro-test.flat
> > +smp = 2
> > +groups = nodefault,micro-test
> > +accel = kvm
> > -- 
> > 1.9.1
> > 

Thanks,
drew
