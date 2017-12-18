From: Andrew Jones <drjones@redhat.com>
Subject: Re: [kvm-unit-tests PATCH] arm64: add micro test
Date: Mon, 18 Dec 2017 20:10:37 +0100
Message-ID: <20171218191037.wjocr7jbf5ua2duj@hawk.localdomain>
References: <1513372539-10180-1-git-send-email-shihwei@cs.columbia.edu>
 <1513372539-10180-2-git-send-email-shihwei@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1513372539-10180-2-git-send-email-shihwei@cs.columbia.edu>
Sender: kvm-owner@vger.kernel.org
To: Shih-Wei Li <shihwei@cs.columbia.edu>
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Dec 15, 2017 at 04:15:39PM -0500, Shih-Wei Li wrote:
> Here we provide the support for measuring various micro level
> operations on arm64. We iterate each of the tests for millions of
> times and output their average, minimum and maximum cost in timer
> counts. Instruction barriers are used before and after taking
> timestamps to avoid out-of-order execution or pipelining from
> skewing our measurements.
> 
> The tests we currently support and measure are mostly
> straightforward by the function names and the respective comments.
> For IPI test, we measure the cost of sending IPI from a source
> VCPU to a target VCPU, until the target VCPU receives the IPI.
> 
> Signed-off-by: Shih-Wei Li <shihwei@cs.columbia.edu>
> ---
>  arm/Makefile.common |   1 +
>  arm/micro-test.c    | 289 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  arm/unittests.cfg   |   6 ++
>  3 files changed, 296 insertions(+)
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
> index 0000000..7df2272
> --- /dev/null
> +++ b/arm/micro-test.c
> @@ -0,0 +1,289 @@

Please add the copyright and license header like we have in other files.

> +#include <util.h>
> +#include <asm/gic.h>
> +
> +static volatile bool second_cpu_up;
> +static volatile bool first_cpu_ack;
> +static volatile bool ipi_acked;
> +static volatile bool ipi_received;
> +static volatile bool ipi_ready;
> +#define IPI_IRQ		1
> +
> +#define TIMEOUT (1U << 28)
> +
> +#define ARR_SIZE(_x) ((int)(sizeof(_x) / sizeof(_x[0])))

We have this in libcflat already, ARRAY_SIZE()

> +#define for_each_test(_iter, _tests, _tmp) \
> +	for (_tmp = 0, _iter = _tests; \
> +			_tmp < ARR_SIZE(_tests); \
> +			_tmp++, _iter++)

One time used macro is probably not necessary and the tmp
var wouldn't be necessary if you make the last entry of
available_tests a null entry.

> +
> +#define CYCLE_COUNT(c1, c2) \
> +	(((c1) > (c2) || ((c1) == (c2))) ? 0 : (c2) - (c1))
> +
> +#define IPI_DEBUG 0
> +
> +#if IPI_DEBUG == 1
> +#define debug(fmt, ...) \
> +	printf("[cpu %d]: " fmt, smp_processor_id(),  ## __VA_ARGS__)
> +#else
> +#define debug(fmt, ...) {}
> +#endif

We don't generally turn off print statements in kvm-unit-tests.
If the statement is really a temporary debug statement, then
maybe just remove it before posting the patch. If it's even just a
little helpful, then just leave it in and always print it. To promote
messages to a higher level of importance than printf use report_*
functions.

> +
> +static uint64_t read_cc(void)
> +{
> +	uint64_t cc;
> +	asm volatile(
> +		"isb\n"
> +		"mrs %0, CNTPCT_EL0\n"
> +		"isb\n"
> +		: [reg] "=r" (cc)
> +		::
> +	);
> +	return cc;
> +}
> +
> +static void ipi_irq_handler(struct pt_regs *regs __unused)
> +{
> +	u32 ack;
> +	ipi_ready = false;
> +	ipi_received = true;
> +	ack = gic_read_iar();
> +	ipi_acked = true;
> +	gic_write_eoir(ack);
> +	ipi_ready = true;
> +}
> +
> +static void ipi_test_secondary_entry(void)
> +{
> +	unsigned int timeout = TIMEOUT;
> +
> +	debug("secondary core up\n");
> +
> +	enum vector v = EL1H_IRQ;
> +	install_irq_handler(v, ipi_irq_handler);
> +
> +	gic_enable_defaults();
> +
> +	second_cpu_up = true;
> +
> +	debug("secondary initialized vgic\n");
> +
> +	while (!first_cpu_ack && timeout--);

cpu_relax() here will help get that first-cpu ack on TCG faster. That
said, this test doesn't make sense on TCG anyway, other than debugging
it. So you could just add 'accel = kvm' to it's unittests.cfg parameter
list.

I just tried on TCG now. It doesn't run. It gets

Timer Frequency 62500000 Hz (Output in timer count)
Unhandled exception ec=0 (UNKNOWN)
Vector: 4 (el1h_sync)
ESR_EL1:         02000000, ec=0 (UNKNOWN)
FAR_EL1: 0000000000000000 (not valid)
Exception frame registers:
pc : [<0000000040080088>] lr : [<00000000400803e8>] pstate: 800003c5
sp : 00000000400aff90
x29: 0000000000000000 x28: 0000000000000000 
x27: 0000000040090000 x26: 0000000040090c60 
x25: 0000000040090000 x24: 000000001fffffff 
x23: 0000000000000000 x22: 0000000000000000 
x21: 0000000000000040 x20: 0000000000000000 
x19: 0000000000000000 x18: 00000000400b0000 
x17: 0000000000000000 x16: 0000000000000000 
x15: 00000000400afe8c x14: 00000000400b0000 
x13: 00000000400afecc x12: 0000000000001680 
x11: 0000000000000000 x10: 6666666666666667 
x9 : 0000000000000030 x8 : 0000000000000030 
x7 : 00000000400af670 x6 : 00000000400af673 
x5 : 00000000400af678 x4 : 00000000000007b7 
x3 : 00000000400af6ec x2 : 0000000040090000 
x1 : 000000000015909e x0 : 000000004b000000

You don't need to get it to work on TCG if you add the 'accel = kvm'
parameter, but it's sometimes indicative of a bug in the unit test
when it doesn't run, so you might want to take a look.

Also need to do s/timeout/tries/ or something, as it's not time related.

> +	if (!first_cpu_ack) {
> +		debug("ipi_test: First CPU did not ack wake-up\n");

I think you should drop the debug() macro completely, but in here
it should certainly be changed. Erroring out shouldn't be silent,
as it would be when out debug turned on.

> +		exit(1);
> +	}
> +
> +	debug("detected first cpu ack\n");
> +
> +	local_irq_enable(); /* Enter small wait-loop */
> +	ipi_ready = true;
> +	while (true);
> +}
> +
> +static int test_init(void)
> +{
> +	int ret;
> +	unsigned int timeout = TIMEOUT;
> +
> +	ret = gic_init();
> +	if (!ret) {
> +		debug("No supported gic present, skipping tests...\n");
> +		goto out;
> +	}
> +
> +	ipi_ready = false;
> +
> +	gic_enable_defaults();
> +
> +	debug("starting second CPU\n");
> +	smp_boot_secondary(1, ipi_test_secondary_entry);
> +
> +	while (!second_cpu_up && timeout--); /* Wait for second CPU! */
> +
> +	if (!second_cpu_up) {
> +		debug("ipi_test: timeout waiting for secondary CPU\n");
> +		ret = 0;
> +		goto out;
> +	}
> +
> +	debug("detected secondary core up\n");
> +
> +	first_cpu_ack = true;

I think you should be able to avoid most of this manual cpu
synchronization by using the on_cpu() call, which is the
recommended way to start secondaries anyway.

> +
> +	printf("Timer Frequency %d Hz (Output in timer count)\n", get_cntfrq());
> +
> +out:
> +	return ret;
> +}
> +
> +static unsigned long ipi_test(void)
> +{
> +	unsigned int timeout = TIMEOUT;
> +	unsigned long c1, c2;
> +
> +	while (!ipi_ready && timeout--);
> +	if (!ipi_ready) {
> +		debug("ipi_test: second core not ready for IPIs\n");
> +		exit(1);
> +	}
> +
> +	ipi_received = false;
> +
> +	c1 = read_cc();
> +
> +	gic_ipi_send_single(IPI_IRQ, 1);
> +
> +	timeout = TIMEOUT;
> +	while (!ipi_received && timeout--);
> +	if (!ipi_received) {
> +		debug("ipi_test: secondary core never received ipi\n");
> +		exit(1);
> +	}
> +
> +	c2 = read_cc();
> +	return CYCLE_COUNT(c1, c2);
> +}
> +
> +
> +static unsigned long hvc_test(void)
> +{
> +	unsigned long c1, c2;
> +
> +	c1 = read_cc();
> +	asm volatile("mov w0, #0x4b000000; hvc #0");
> +	c2 = read_cc();
> +	return CYCLE_COUNT(c1, c2);
> +}
> +
> +static void __noop(void)
> +{
> +}
> +
> +static unsigned long noop_guest(void)
> +{
> +	unsigned long c1, c2;
> +
> +	c1 = read_cc();
> +	__noop();
> +	c2 = read_cc();
> +	return CYCLE_COUNT(c1, c2);
> +}
> +
> +static unsigned long mmio_read_user(void)
> +{
> +	unsigned long c1, c2;
> +	void *mmio_read_user_addr = (void*) 0x0a000008;

This is a virtio-mmio transport device-id address. It's harmless to
read it, as long as we don't change it. I've had plans to provide
mmio addresses with different read, write permissions and sizes through
extending a test-dev for quite a while. I should do that. For this patch
I guess this is fine, but please comment it with a big FIXME or TODO to
make sure we change it when we can someday.

> +
> +	/* Measure MMIO exit to QEMU in userspace */
> +	c1 = read_cc();
> +	readl(mmio_read_user_addr);
> +	c2 = read_cc();
> +	return CYCLE_COUNT(c1, c2);
> +}
> +
> +static unsigned long mmio_read_vgic(void)
> +{
> +	unsigned long c1, c2;
> +	int v = gic_version();
> +	void *vgic_dist_addr = NULL;
> +
> +	if (v == 2)
> +		vgic_dist_addr = gicv2_dist_base();
> +	else if (v == 3)
> +		vgic_dist_addr = gicv3_dist_base();
> +
> +	/* Measure MMIO exit to host kernel */
> +	c1 = read_cc();
> +	readl(vgic_dist_addr + 0x8); /* Read GICD_IIDR */

You can add GICD_IIDR to lib/arm/asm/gic.h

> +	c2 = read_cc();
> +	return CYCLE_COUNT(c1, c2);
> +}
> +
> +static unsigned long eoi_test(void)
> +{
> +	unsigned long c1, c2;
> +	int v = gic_version();
> +	void (*write_eoir)(u32 irqstat) = NULL;
> +
> +	u32 val = 1023; /* spurious IDs, writes to EOI are ignored */
> +
> +	if (v == 2)
> +		write_eoir = gicv2_write_eoir;
> +	else if (v == 3)
> +		write_eoir = gicv3_write_eoir;

You don't need this, we have gic_write_eoir(), which you used above.

> +
> +	c1 = read_cc();
> +	write_eoir(val);
> +	c2 = read_cc();
> +
> +	return CYCLE_COUNT(c1, c2);
> +}
> +
> +struct exit_test {
> +	const char *name;
> +	unsigned long (*test_fn)(void);
> +	bool run;
> +};
> +
> +static struct exit_test available_tests[] = {
> +	{"hvc",                hvc_test,           true},
> +	{"noop_guest",         noop_guest,         true},
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
> +	const unsigned long long goal = (1ULL << 29);
> +
> +	do {
> +		iterations *= 2;
> +		cycles = 0;
> +		for (i = 0; i < iterations; i++) {
> +			sample = test->test_fn();
> +			if (sample == 0) {
> +				/*
> +				 * If something went wrong or we had an
> +				 * overflow, don't count that sample.
> +				 */
> +				iterations--;
> +				i--;

I'd prefer incrementing a different counter after the sample==0 test /
continue, than to decrement both i and iterations.

> +				debug("cycle count overflow: %lu\n", sample);
> +				continue;
> +			}
> +			cycles += sample;
> +			if (min == 0 || min > sample)
> +				min = sample;
> +			if (max < sample)
> +				max = sample;
> +		}
> +	} while (cycles < goal);
> +	printf("%s:\t avg %lu\t min %llu\t max %llu\n",
> +		test->name, cycles / (iterations), min, max);

No need for () around iterations.

> +}
> +
> +void kvm_unit_test(void)
> +{
> +	int i=0;
> +	struct exit_test *test;
> +	for_each_test(test, available_tests, i) {
> +		if (!test->run)
> +			continue;
> +		loop_test(test);
> +	}
> +
> +	return;

pointless return

> +}

nit: no need for the above function, just inline it in main().

> +
> +int main(int argc, char **argv)
> +{
> +	if (!test_init())
> +		exit(1);

I think this and all exit(1)'s in this unit test could/should be
replaced with asserts.

> +	kvm_unit_test();
> +	return 0;
> +}
> diff --git a/arm/unittests.cfg b/arm/unittests.cfg
> index 44b98cf..1d0c4ca 100644
> --- a/arm/unittests.cfg
> +++ b/arm/unittests.cfg
> @@ -116,3 +116,9 @@ file = timer.flat
>  groups = timer
>  timeout = 2s
>  arch = arm64
> +
> +# Exit tests
> +[micro-test]
> +file = micro-test.flat
> +smp = 2
> +groups = micro-test
> -- 
> 1.9.1
> 
>

Thanks again for contributing to kvm-unit-tests. I look forward to v2.

drew
