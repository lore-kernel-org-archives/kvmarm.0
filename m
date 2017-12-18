From: Yury Norov <ynorov@caviumnetworks.com>
Subject: Re: [kvm-unit-tests PATCH] arm64: add micro test
Date: Mon, 18 Dec 2017 20:31:21 +0300
Message-ID: <20171218173121.kmef47u2q7qa4eqb@yury-thinkpad>
References: <1513372539-10180-1-git-send-email-shihwei@cs.columbia.edu>
 <1513372539-10180-2-git-send-email-shihwei@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0E4DD49D78
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Dec 2017 12:27:51 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cyrLb4JrUSXb for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Dec 2017 12:27:49 -0500 (EST)
Received: from NAM01-SN1-obe.outbound.protection.outlook.com
 (mail-sn1nam01on0081.outbound.protection.outlook.com [104.47.32.81])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0FA8949D46
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Dec 2017 12:27:49 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <1513372539-10180-2-git-send-email-shihwei@cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Shih-Wei Li <shihwei@cs.columbia.edu>
Cc: "Goutham, Sunil" <Sunil.Goutham@cavium.com>, kvm@vger.kernel.org, marc.zyngier@arm.com, "Cherian, Linu" <Linu.Cherian@cavium.com>, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi Shih-Wei,

(CC Cavium folks)

Thank you for the test! I was going to write something like
this, and instead found your patch submitted - good luck to me. 

Soon I'll test my hardware with it and share you results.
Comments inline.

Yury

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
> +#define for_each_test(_iter, _tests, _tmp) \
> +	for (_tmp = 0, _iter = _tests; \
> +			_tmp < ARR_SIZE(_tests); \
> +			_tmp++, _iter++)
> +
> +#define CYCLE_COUNT(c1, c2) \
> +	(((c1) > (c2) || ((c1) == (c2))) ? 0 : (c2) - (c1))

Is my understanding correct that this is overflow protection?
c1 and c2 are 64-bit values. To overflow them you need 58 years
at 1G CPU freq.

And anyway,
#define CYCLE_COUNT(c1, c2)  ((c1) >= (c2) ? 0 : (c2) - (c1))

> +
> +#define IPI_DEBUG 0
> +

If you assume to pass IPI_DEBUG as GCC parameter, like -DIPI_DEBUG=1,
it should be 

#ifndef IPI_DEBUG
#define IPI_DEBUG 0
#endif

But I wonder if there's already existing switch for debug info?

> +#if IPI_DEBUG == 1
> +#define debug(fmt, ...) \
> +	printf("[cpu %d]: " fmt, smp_processor_id(),  ## __VA_ARGS__)
> +#else
> +#define debug(fmt, ...) {}
> +#endif

There are some fancy printing functions in lib/report.c. I didn't
look deeply into thet, but at first glance you can use it here.

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

Flushing pipeline before mrs is enough. Also, you can use read_sysreg()
instead of inline assembly. Refer arch_counter_get_cntpct() in kernel:

151 static inline u64 arch_counter_get_cntpct(void)
152 {
153         isb();   
154         return arch_timer_reg_read_stable(cntpct_el0);
155 }

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
> +	if (!first_cpu_ack) {
> +		debug("ipi_test: First CPU did not ack wake-up\n");
> +		exit(1);
> +	}

Nit: here and later, timeout is not actually timeout, but something like
counter of attempts. Maybe it worth to use read_cc() here if you need
time intervals? 

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
> +
> +	printf("Timer Frequency %d Hz (Output in timer count)\n", get_cntfrq());
> +
> +out:

Nit: it's simpler to return error at place and drop the 'out' label,
like this:
if (!gic_init()) {
        debug(...);
        return 0;
}

> +	return ret;
> +}
> +
> +static unsigned long ipi_test(void)
> +{
> +	unsigned int timeout = TIMEOUT;
> +	unsigned long c1, c2;

read_cc() returns uint64_t, so c1 and c2 should also be fixed-size
variables. Maybe one day we'll port test to arm32 where unsigned long is
32-bit...

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

Nit: odd line.

> +static unsigned long hvc_test(void)
> +{
> +	unsigned long c1, c2;
> +
> +	c1 = read_cc();
> +	asm volatile("mov w0, #0x4b000000; hvc #0");
> +	c2 = read_cc();
> +	return CYCLE_COUNT(c1, c2);
> +}

This will be broken if compiler decide to assign r0 for variable c1,
or I miss something?

> +
> +static void __noop(void)
> +{
> +}

This would be completely optimized out. Is it for demonstrative
purpose?

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
> +	c2 = read_cc();
> +	return CYCLE_COUNT(c1, c2);
> +}

So if gic version is not 2 or 3, it will readl() at broken
address. I think it's better to return error and print relevant
message to system log.

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
> +
> +	c1 = read_cc();
> +	write_eoir(val);
> +	c2 = read_cc();
> +
> +	return CYCLE_COUNT(c1, c2);
> +}

Similar here.

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
> +}
> +
> +int main(int argc, char **argv)
> +{
> +	if (!test_init())
> +		exit(1);
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
