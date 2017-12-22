From: Yury Norov <ynorov@caviumnetworks.com>
Subject: Re: [kvm-unit-tests PATCH V2 2/2] arm64: add micro test
Date: Fri, 22 Dec 2017 09:07:06 +0300
Message-ID: <20171222060706.ibf7sakrgzrtyn5f@yury-thinkpad>
References: <1513733685-32573-1-git-send-email-shihwei@cs.columbia.edu>
 <1513733685-32573-3-git-send-email-shihwei@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1513733685-32573-3-git-send-email-shihwei@cs.columbia.edu>
Sender: kvm-owner@vger.kernel.org
To: Shih-Wei Li <shihwei@cs.columbia.edu>
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com, drjones@redhat.com, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Dec 19, 2017 at 08:34:45PM -0500, Shih-Wei Li wrote:
> Here we provide the support for measuring various micro level
> operations on arm64. We iterate each of the tests for millions of
> times and output their average, minimum and maximum cost in timer
> counts. Instruction barriers were used before and after taking
> timestamps to avoid out-of-order execution or pipelining from
> skewing our measurements.

Instruction barriers are used only before, right? Also, I think it
should be the comment to function rather than part of patch
description.

> The operations we currently supported and measured are mostly
> self-explanatory by their function name. For IPI, we measured the
> cost of sending IPI from a source VCPU to a target VCPU, until the
> target VCPU receives the IPI.
 
Please describe changes since v1.

> Signed-off-by: Shih-Wei Li <shihwei@cs.columbia.edu>
> ---
>  arm/Makefile.common |   1 +
>  arm/micro-test.c    | 219 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  arm/unittests.cfg   |   7 ++
>  3 files changed, 227 insertions(+)
>  create mode 100644 arm/micro-test.c
> 
> diff --git a/arm/Makefile.common b/arm/Makefile.common
> index 0a039cf..c7d5c27 100644
> --- a/arm/Makefile.common
> +++ b/arm/Makefile.common
> @@ -16,6 +16,7 @@ tests-common += $(TEST_DIR)/pmu.flat
>  tests-common += $(TEST_DIR)/gic.flat
>  tests-common += $(TEST_DIR)/psci.flat
>  tests-common += $(TEST_DIR)/sieve.flat
> +tests-common += $(TEST_DIR)/micro-test.flat
>  
>  tests-all = $(tests-common) $(tests)
>  all: directories $(tests-all)
> diff --git a/arm/micro-test.c b/arm/micro-test.c
> new file mode 100644
> index 0000000..c31c9ac
> --- /dev/null
> +++ b/arm/micro-test.c
> @@ -0,0 +1,219 @@
> +/*
> + * Measure the cost of micro level operations.
> + *
> + * Copyright Columbia University
> + * Author: Shih-Wei Li <shihwei@cs.columbia.edu>
> + * Author: Christoffer Dall <cdall@cs.columbia.edu>

Nit. If Christoffer is author, he should also sing-off the patch.

> + *
> + * This work is licensed under the terms of the GNU LGPL, version 2.
> + */
> +#include "libcflat.h"
> +#include <util.h>
> +#include <asm/gic.h>
> +
> +static volatile bool ipi_received;
> +static volatile bool ipi_ready;
> +#define IPI_IRQ		1
> +
> +#define TIMEOUT (1U << 28)
> +
> +/*
> + * The counter may not always start with zero, which means it could
> + * overflow after some time.
> + */

Is this comment relevant? In discussion people say that they have always
c1 == c2 because timer cannot tick even once, not because it ticks
2^64 times. And this is what really occurs. Also, if ci == c2, 
(c2 - c1) is already zero, and you don't need do something special to 
handle it.

> +#define COUNT(c1, c2) \
> +	(((c1) > (c2) || ((c1) == (c2))) ? 0 : (c2) - (c1))
> +
> +static uint64_t read_cc(void)
> +{
> +	isb();
> +	return read_sysreg(cntpct_el0);
> +}
> +
> +static void ipi_irq_handler(struct pt_regs *regs __unused)
> +{
> +	u32 ack;
> +	ipi_ready = false;
> +	ipi_received = true;
> +	ack = gic_read_iar();
> +	gic_write_eoir(ack);
> +	ipi_ready = true;
> +}
> +
> +static void ipi_test_secondary_entry(void *data __unused)
> +{
> +	enum vector v = EL1H_IRQ;
> +	install_irq_handler(v, ipi_irq_handler);
> +
> +	gic_enable_defaults();
> +
> +	local_irq_enable(); /* Enter small wait-loop */
> +	ipi_ready = true;
> +	while (true);

I remember, it was asked in v1, but anyway, is it intentional here and
in other similar busy-loops not to use wfe/wfi or cpu_relax()? 

Andrew Jones asked you:

>> cpu_relax() here will help get that first-cpu ack on TCG faster. That
>> said, this test doesn't make sense on TCG anyway, other than debugging
>> it. So you could just add 'accel = kvm' to it's unittests.cfg parameter
>> list.
>
>ok, thanks.

Or I misunderstood something?

> +}
> +
> +static int test_init(void)
> +{
> +	if (!gic_init()) {
> +		printf("No supported gic present, skipping tests...\n");
> +		return 0;
> +	}
> +
> +	ipi_ready = false;
> +
> +	gic_enable_defaults();
> +	on_cpu_async(1, ipi_test_secondary_entry, 0);
> +
> +	printf("Timer Frequency %d Hz (Output in timer count)\n", get_cntfrq());
> +
> +	return 1;
> +}
> +
> +static unsigned long ipi_test(void)
> +{
> +	unsigned int timeout = TIMEOUT;
> +	uint64_t c1, c2;
> +
> +	while (!ipi_ready && timeout--);

Again, this is not timeout. It's nothing about time.
If you need limit the loop by time, it would probably look
like this:

	while (!ipi_ready && read_cc() - start_cc < timeout)
                cpu_relax();

This snippet is repeated too much times in the test to make it a
function, like wait(addr, value).

> +	assert(ipi_ready);
> +
> +	ipi_received = false;
> +
> +	c1 = read_cc();
> +
> +	gic_ipi_send_single(IPI_IRQ, 1);
> +
> +	timeout = TIMEOUT;
> +	while (!ipi_received && timeout--);
> +	assert(ipi_received);
> +
> +	c2 = read_cc();
> +	return COUNT(c1, c2);
> +}
> +
> +

Odd line is still here.

> +static unsigned long hvc_test(void)
> +{
> +	uint64_t c1, c2;
> +
> +	c1 = read_cc();
> +	asm volatile("mov w0, #0x4b000000; hvc #0" ::: "w0");
> +	c2 = read_cc();
> +	return COUNT(c1, c2);
> +}
> +
> +static unsigned long mmio_read_user(void)
> +{
> +	uint64_t c1, c2;
> +	/*
> +	 * FIXME: Read device-id in virtio mmio here. This address
> +	 * needs to be updated in the future if any relavent

Typo: relevant

> +	 * changes in QEMU test-dev are made.
> +	 */
> +	void *mmio_read_user_addr = (void*) 0x0a000008;

It sounds like function name. Or you mean mmio read-only address?
If no, I'd rename it to mmio_user_addr

> +
> +	c1 = read_cc();
> +	readl(mmio_read_user_addr);
> +	c2 = read_cc();
> +	return COUNT(c1, c2);
> +}
> +
> +static unsigned long mmio_read_vgic(void)
> +{
> +	uint64_t c1, c2;
> +	int v = gic_version();

I think gic version cannot be changed while test is running,
so you can check it once on init and store at global variable.

> +	void *vgic_dist_addr = NULL;

Useless initialization

> +
> +	if (v == 2)
> +		vgic_dist_addr = gicv2_dist_base();
> +	else if (v == 3)
> +		vgic_dist_addr = gicv3_dist_base();

Again, if there's real chance that gic version will appear not 2 or 3,
you'd take care of it. If no, make else-branch unconditional, like say 
in ipi_clear_active_handler().

> +	c1 = read_cc();
> +	readl(vgic_dist_addr + GICD_IIDR);

Normally here should be smp_rmb(), but it seems there's no writers at
this address. But if you test mmio performance, you'd take into account
the time for synchronization. Is it correct?

> +	c2 = read_cc();
> +	return COUNT(c1, c2);
> +}
> +
> +static unsigned long eoi_test(void)
> +{
> +	uint64_t c1, c2;
> +	int v = gic_version();
> +	void (*write_eoir)(u32 irqstat) = NULL;

Again, useless initialization. If you make else-branch below
unconditional, you wouldn't need to shut the compiler up.

> +
> +	u32 val = 1023; /* spurious IDs, writes to EOI are ignored */
> +
> +	/* To avoid measuring assert(..) in gic_write_eoir */

Sorry, I don't understand what this comment means.
To avoid measuring assert(..) in gic_write_eoir, let's segfault here 
by executing at NULL address - like this? 

> +	if (v == 2)
> +		write_eoir = gicv2_write_eoir;
> +	else if (v == 3)
> +		write_eoir = gicv3_write_eoir;

IIUC, you can do it once at init, right?

> +
> +	c1 = read_cc();
> +	write_eoir(val);
> +	c2 = read_cc();
> +
> +	return COUNT(c1, c2);
> +}
> +
> +struct exit_test {
> +	const char *name;
> +	unsigned long (*test_fn)(void);
> +	bool run;
> +};
> +
> +static struct exit_test tests[] = {
> +	{"hvc",                hvc_test,           true},
> +	{"mmio_read_user",     mmio_read_user,     true},
> +	{"mmio_read_vgic",     mmio_read_vgic,     true},
> +	{"eoi",                eoi_test,           true},
> +	{"ipi",                ipi_test,           true},
> +};
> +
> +static void loop_test(struct exit_test *test)
> +{
> +	unsigned long i, iterations = 32;
> +	unsigned long sample, cycles;
> +	unsigned long long min = 0, max = 0;
> +	const unsigned long long goal = (1ULL << 25);
> +
> +	do {
> +		iterations *= 2;
> +		cycles = 0;
> +		i = 0;
> +		while (i < iterations) {
> +			sample = test->test_fn();
> +			if (sample == 0) {
> +				/*
> +				 * If something went wrong or we had an
> +				 * overflow, don't count that sample.
> +				 */
> +				printf("cycle count overflow: %lu\n", sample);

Text doesn't match the comment.

Sample doesn't contain error code and is always zero. what's the point
to print it?

> +				continue;
> +			}
> +			cycles += sample;
> +			if (min == 0 || min > sample)

Hint: initialize min as ULONGLONG_MAX, and drop this (min == 0) check.

> +				min = sample;
> +			if (max < sample)
> +				max = sample;
> +			++i;
> +		}
> +	} while (cycles < goal);
> +	printf("%s:\t avg %lu\t min %llu\t max %llu\n",
> +		test->name, cycles / iterations, min, max);
> +}
> +
> +int main(int argc, char **argv)
> +{
> +	int i;
> +
> +	assert(test_init());
> +
> +	for (i = 0; i < ARRAY_SIZE(tests); i++) {
> +		if (!tests[i].run)
> +			continue;
> +		loop_test(&tests[i]);
> +	}
> +
> +	return 0;
> +}
> diff --git a/arm/unittests.cfg b/arm/unittests.cfg
> index 44b98cf..a8fb0b3 100644
> --- a/arm/unittests.cfg
> +++ b/arm/unittests.cfg
> @@ -116,3 +116,10 @@ file = timer.flat
>  groups = timer
>  timeout = 2s
>  arch = arm64
> +
> +# Exit tests
> +[micro-test]
> +file = micro-test.flat
> +smp = 2
> +groups = micro-test
> +accel = kvm
> -- 
> 1.9.1
> 
