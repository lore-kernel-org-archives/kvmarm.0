From: Shih-Wei Li <shihwei@cs.columbia.edu>
Subject: [PATCH v3 2/2] arm64: add micro test
Date: Wed, 17 Jan 2018 16:46:36 -0500
Message-ID: <1516225596-27071-3-git-send-email-shihwei@cs.columbia.edu>
References: <1516225596-27071-1-git-send-email-shihwei@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B69B849E12
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Jan 2018 16:41:13 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1ZW3RHfQmCuG for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Jan 2018 16:41:12 -0500 (EST)
Received: from outprodmail02.cc.columbia.edu (outprodmail02.cc.columbia.edu
 [128.59.72.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C5C7149E19
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Jan 2018 16:41:12 -0500 (EST)
Received: from hazelnut (hazelnut.cc.columbia.edu [128.59.213.250])
 by outprodmail02.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id w0HLk715039446
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Jan 2018 16:46:17 -0500
Received: from hazelnut (localhost.localdomain [127.0.0.1])
 by hazelnut (Postfix) with ESMTP id 709C381
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Jan 2018 16:46:18 -0500 (EST)
Received: from sendprodmail02.cc.columbia.edu (sendprodmail02.cc.columbia.edu
 [128.59.72.14]) by hazelnut (Postfix) with ESMTP id 5A3A082
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Jan 2018 16:46:18 -0500 (EST)
Received: from mail-qt0-f200.google.com (mail-qt0-f200.google.com
 [209.85.216.200])
 by sendprodmail02.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id w0HLkHt8023353
 (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Jan 2018 16:46:17 -0500
Received: by mail-qt0-f200.google.com with SMTP id e20so8089027qtg.8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Jan 2018 13:46:17 -0800 (PST)
In-Reply-To: <1516225596-27071-1-git-send-email-shihwei@cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Christoffer Dall <cdall@cs.columbia.edu>, marc.zyngier@arm.com, pbonzini@redhat.com, Shih-Wei Li <shihwei@cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

Here we provide the support for measuring various micro level
operations on arm64. We iterate each of the tests and output
their average, minimum and maximum cost in microseconds.
Instruction barriers were used before taking timestamps to
avoid out-of-order execution or pipelining from skewing our
measurements.

The operations we currently supported and measured are mostly
self-explanatory by their function name. For IPI, we measured the
cost of sending IPI from a source VCPU to a target VCPU, until the
target VCPU receives the IPI.

Signed-off-by: Shih-Wei Li <shihwei@cs.columbia.edu>
Signed-off-by: Christoffer Dall <cdall@cs.columbia.edu>
---
 arm/Makefile.common |   1 +
 arm/micro-test.c    | 252 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 arm/unittests.cfg   |   7 ++
 3 files changed, 260 insertions(+)
 create mode 100644 arm/micro-test.c

diff --git a/arm/Makefile.common b/arm/Makefile.common
index 0a039cf..c7d5c27 100644
--- a/arm/Makefile.common
+++ b/arm/Makefile.common
@@ -16,6 +16,7 @@ tests-common += $(TEST_DIR)/pmu.flat
 tests-common += $(TEST_DIR)/gic.flat
 tests-common += $(TEST_DIR)/psci.flat
 tests-common += $(TEST_DIR)/sieve.flat
+tests-common += $(TEST_DIR)/micro-test.flat
 
 tests-all = $(tests-common) $(tests)
 all: directories $(tests-all)
diff --git a/arm/micro-test.c b/arm/micro-test.c
new file mode 100644
index 0000000..407ce8b
--- /dev/null
+++ b/arm/micro-test.c
@@ -0,0 +1,252 @@
+/*
+ * Measure the cost of micro level operations.
+ *
+ * Copyright Columbia University
+ * Author: Shih-Wei Li <shihwei@cs.columbia.edu>
+ * Author: Christoffer Dall <cdall@cs.columbia.edu>
+ *
+ * This work is licensed under the terms of the GNU LGPL, version 2.
+ */
+#include <asm/gic.h>
+#include "libcflat.h"
+#include <util.h>
+#include <limits.h>
+
+static volatile bool ipi_received;
+static volatile bool ipi_ready;
+static volatile unsigned int cntfrq;
+static volatile void *vgic_dist_addr;
+void (*write_eoir)(u32 irqstat);
+
+#define IPI_IRQ		1
+
+#define TRIES	(1U << 28)
+
+#define MAX_FAILURES	1000
+
+/*
+ * The counter may not always start with zero, which means it could
+ * overflow after some period of time.
+ */
+#define COUNT(c1, c2) \
+	((c1) > (c2) ? 0 : (c2) - (c1))
+
+static uint64_t read_cc(void)
+{
+	isb();
+	return read_sysreg(cntpct_el0);
+}
+
+static void ipi_irq_handler(struct pt_regs *regs __unused)
+{
+	u32 ack;
+	ipi_ready = false;
+	ipi_received = true;
+	ack = gic_read_iar();
+	gic_write_eoir(ack);
+	ipi_ready = true;
+}
+
+static void ipi_test_secondary_entry(void *data __unused)
+{
+	enum vector v = EL1H_IRQ;
+	install_irq_handler(v, ipi_irq_handler);
+
+	gic_enable_defaults();
+
+	local_irq_enable(); /* Enter small wait-loop */
+	ipi_ready = true;
+	while (true);
+}
+
+static int test_init(void)
+{
+	int v;
+
+	v = gic_init();
+	if (v == 2) {
+		vgic_dist_addr = gicv2_dist_base();
+		write_eoir = gicv2_write_eoir;
+	} else if (v == 3) {
+		vgic_dist_addr = gicv3_dist_base();
+		write_eoir = gicv3_write_eoir;
+	} else {
+		printf("No supported gic present, skipping tests...\n");
+		return 0;
+	}
+
+	ipi_ready = false;
+
+	gic_enable_defaults();
+	on_cpu_async(1, ipi_test_secondary_entry, 0);
+
+	cntfrq = get_cntfrq();
+	printf("Timer Frequency %d Hz (Output in microseconds)\n", cntfrq);
+
+	return 1;
+}
+
+static unsigned long ipi_test(void)
+{
+	unsigned int tries = TRIES;
+	uint64_t c1, c2;
+
+	while (!ipi_ready && tries--);
+	assert(ipi_ready);
+
+	ipi_received = false;
+
+	c1 = read_cc();
+
+	gic_ipi_send_single(IPI_IRQ, 1);
+
+	tries = TRIES;
+	while (!ipi_received && tries--);
+	assert(ipi_received);
+
+	c2 = read_cc();
+	return COUNT(c1, c2);
+}
+
+static unsigned long hvc_test(void)
+{
+	uint64_t c1, c2;
+
+	c1 = read_cc();
+	asm volatile("mov w0, #0x4b000000; hvc #0" ::: "w0");
+	c2 = read_cc();
+	return COUNT(c1, c2);
+}
+
+static unsigned long mmio_read_user(void)
+{
+	uint64_t c1, c2;
+	/*
+	 * FIXME: Read device-id in virtio mmio here. This address
+	 * needs to be updated in the future if any relevent
+	 * changes in QEMU test-dev are made.
+	 */
+	void *mmio_read_user_addr = (void*) 0x0a000008;
+
+	c1 = read_cc();
+	readl(mmio_read_user_addr);
+	c2 = read_cc();
+	return COUNT(c1, c2);
+}
+
+static unsigned long mmio_read_vgic(void)
+{
+	uint64_t c1, c2;
+
+	c1 = read_cc();
+	readl(vgic_dist_addr + GICD_IIDR);
+	c2 = read_cc();
+	return COUNT(c1, c2);
+}
+
+static unsigned long eoi_test(void)
+{
+	uint64_t c1, c2;
+
+	u32 val = 1023; /* spurious IDs, writes to EOI are ignored */
+
+	/* Avoid measuring assert(..) in gic_write_eoir */
+	c1 = read_cc();
+	write_eoir(val);
+	c2 = read_cc();
+
+	return COUNT(c1, c2);
+}
+
+struct exit_test {
+	const char *name;
+	unsigned long (*test_fn)(void);
+	bool run;
+};
+
+static struct exit_test tests[] = {
+	{"hvc",                hvc_test,           true},
+	{"mmio_read_user",     mmio_read_user,     true},
+	{"mmio_read_vgic",     mmio_read_vgic,     true},
+	{"eoi",                eoi_test,           true},
+	{"ipi",                ipi_test,           true},
+};
+
+static void get_us_output(const char *name,
+			  unsigned long cycles)
+{
+	unsigned int ns_per_cycle = 10^9U / cntfrq;
+	unsigned int ns, us, us_frac;
+
+	ns =  cycles * ns_per_cycle;
+	us = ns / 1000;
+	us_frac = (ns % 1000) / 100;
+
+	printf("%s %10d.%d\t", name, us, us_frac);
+}
+
+static void output_result(const char *name,
+			  unsigned long avg_cycle,
+			  unsigned long min_cycle,
+			  unsigned long max_cycle)
+{
+	printf("%10s:\t", name);
+	get_us_output("avg", avg_cycle);
+	get_us_output("min", min_cycle);
+	get_us_output("max", max_cycle);
+	printf("\n");
+}
+
+static void loop_test(struct exit_test *test)
+{
+	unsigned long i, iterations = 32;
+	unsigned long sample, cycles;
+	unsigned long min = ULONG_MAX, max = 0;
+	const unsigned long goal = (1ULL << 26);
+	int failures = 0;
+
+	do {
+		iterations *= 2;
+		cycles = 0;
+		i = 0;
+		while (i < iterations) {
+			sample = test->test_fn();
+			if (sample == 0) {
+				if (failures++ > MAX_FAILURES) {
+				/*
+				 * If the cost is smaller than a cycle count for
+				 * over MAX_FAILURES of times, we simply ignore the test.
+				 */
+					printf("%s: Too many cycle count overflows\n",
+						test->name);
+					return;
+				}
+				continue;
+			}
+			cycles += sample;
+			if (min > sample)
+				min = sample;
+			if (max < sample)
+				max = sample;
+			++i;
+		}
+	} while (cycles < goal);
+
+	output_result(test->name, (cycles / iterations), min, max);	
+}
+
+int main(int argc, char **argv)
+{
+	int i, ret;
+
+	ret = test_init();
+	assert(ret);
+
+	for (i = 0; i < ARRAY_SIZE(tests); i++) {
+		if (!tests[i].run)
+			continue;
+		loop_test(&tests[i]);
+	}
+
+	return 0;
+}
diff --git a/arm/unittests.cfg b/arm/unittests.cfg
index 44b98cf..5759fa8 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -116,3 +116,10 @@ file = timer.flat
 groups = timer
 timeout = 2s
 arch = arm64
+
+# Exit tests
+[micro-test]
+file = micro-test.flat
+smp = 2
+groups = nodefault,micro-test
+accel = kvm
-- 
1.9.1
