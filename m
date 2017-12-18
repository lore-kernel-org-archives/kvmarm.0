From: "Kalra, Ashish" <Ashish.Kalra@cavium.com>
Subject: Re: [kvm-unit-tests PATCH] arm64: add micro test
Date: Tue, 19 Dec 2017 04:01:59 +0530
Message-ID: <75d4c7de-604e-d852-14e9-e3b582a5c292@cavium.com>
References: <1513372539-10180-1-git-send-email-shihwei@cs.columbia.edu>
 <1513372539-10180-2-git-send-email-shihwei@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1513372539-10180-2-git-send-email-shihwei@cs.columbia.edu>
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
To: Shih-Wei Li <shihwei@cs.columbia.edu>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: marc.zyngier@arm.com, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Hello Shih-Wei,

This "micro" test is really useful for micro-architectural performance
measurement of KVM/ARM.

But, to get more accurate cycle counts, it will be preferable to compute
counter read (and isb) overhead and deduct it from the final cycle
count, something like this :

+static unsigned long counter_read_overhead;

+static void compute_counter_read_overhead(void)
+{
+       unsigned long c1, c2;
+
+       c1 = read_cc();
+       c2 = read_cc();
+       counter_read_overhead = c2 - c1;
+}

+#define CYCLE_COUNT(c1, c2) \
+       (((c1) > (c2) || ((c1) == (c2))) ? 0 : ((c2) - (c1)) -
counter_read_overhead )
+

static int test_init(void)
{
         int ret;
         unsigned int timeout = TIMEOUT;

+       compute_counter_read_overhead();
..
..

Thanks,
Ashish

On 12/16/2017 2:45 AM, Shih-Wei Li wrote:
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
>   arm/Makefile.common |   1 +
>   arm/micro-test.c    | 289 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>   arm/unittests.cfg   |   6 ++
>   3 files changed, 296 insertions(+)
>   create mode 100644 arm/micro-test.c
> 
> diff --git a/arm/Makefile.common b/arm/Makefile.common
> index 0a039cf..c7d5c27 100644
> --- a/arm/Makefile.common
> +++ b/arm/Makefile.common
> @@ -16,6 +16,7 @@ tests-common += $(TEST_DIR)/pmu.flat
>   tests-common += $(TEST_DIR)/gic.flat
>   tests-common += $(TEST_DIR)/psci.flat
>   tests-common += $(TEST_DIR)/sieve.flat
> +tests-common += $(TEST_DIR)/micro-test.flat
>   
>   tests-all = $(tests-common) $(tests)
>   all: directories $(tests-all)
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
> +
> +#define IPI_DEBUG 0
> +
> +#if IPI_DEBUG == 1
> +#define debug(fmt, ...) \
> +	printf("[cpu %d]: " fmt, smp_processor_id(),  ## __VA_ARGS__)
> +#else
> +#define debug(fmt, ...) {}
> +#endif
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
> +	if (!first_cpu_ack) {
> +		debug("ipi_test: First CPU did not ack wake-up\n");
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
>   groups = timer
>   timeout = 2s
>   arch = arm64
> +
> +# Exit tests
> +[micro-test]
> +file = micro-test.flat
> +smp = 2
> +groups = micro-test
> 
