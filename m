From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [kvm-unit-tests PATCH v7 09/11] arm/locking-tests: add comprehensive locking test
Date: Thu, 24 Nov 2016 16:10:31 +0000
Message-ID: <20161124161033.11456-10-alex.bennee@linaro.org>
References: <20161124161033.11456-1-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20161124161033.11456-1-alex.bennee@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com
Cc: qemu-devel@nongnu.org, mttcg@listserver.greensocs.com, fred.konrad@greensocs.com, a.rigo@virtualopensystems.com, cota@braap.org, bobby.prani@gmail.com, nikunj@linux.vnet.ibm.com, mark.burton@greensocs.com, pbonzini@redhat.com, jan.kiszka@siemens.com, serge.fdrv@gmail.com, rth@twiddle.net, peter.maydell@linaro.org, claudio.fontana@huawei.com, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

This test has been written mainly to stress multi-threaded TCG behaviour
but will demonstrate failure by default on real hardware. The test takes
the following parameters:

  - "lock" use GCC's locking semantics
  - "atomic" use GCC's __atomic primitives
  - "wfelock" use WaitForEvent sleep
  - "excl" use load/store exclusive semantics

Also two more options allow the test to be tweaked

  - "noshuffle" disables the memory shuffling
  - "count=%ld" set your own per-CPU increment count

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>

---
v2
  - Don't use thumb style strexeq stuff
  - Add atomic and wfelock tests
  - Add count/noshuffle test controls
  - Move barrier tests to separate test file
v4
  - fix up unitests.cfg to use correct test name
  - move into "locking" group, remove barrier tests
  - use a table to add tests, mark which are expected to work
  - correctly report XFAIL
v5
  - max out at -smp 4 in unittest.cfg
v7
  - make test control flags bools
  - default the count to 100000 (so it doesn't timeout)
---
 arm/Makefile.common |   2 +
 arm/locking-test.c  | 302 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 arm/unittests.cfg   |  34 ++++++
 3 files changed, 338 insertions(+)
 create mode 100644 arm/locking-test.c

diff --git a/arm/Makefile.common b/arm/Makefile.common
index 528166d..eb4cfdf 100644
--- a/arm/Makefile.common
+++ b/arm/Makefile.common
@@ -15,6 +15,7 @@ tests-common += $(TEST_DIR)/pci-test.flat
 tests-common += $(TEST_DIR)/gic.flat
 tests-common += $(TEST_DIR)/tlbflush-code.flat
 tests-common += $(TEST_DIR)/tlbflush-data.flat
+tests-common += $(TEST_DIR)/locking-test.flat
 
 all: test_cases
 
@@ -85,3 +86,4 @@ test_cases: $(generated_files) $(tests-common) $(tests)
 $(TEST_DIR)/selftest.o $(cstart.o): $(asm-offsets)
 $(TEST_DIR)/tlbflush-code.elf: $(cstart.o) $(TEST_DIR)/tlbflush-code.o
 $(TEST_DIR)/tlbflush-data.elf: $(cstart.o) $(TEST_DIR)/tlbflush-data.o
+$(TEST_DIR)/locking-test.elf: $(cstart.o) $(TEST_DIR)/locking-test.o
diff --git a/arm/locking-test.c b/arm/locking-test.c
new file mode 100644
index 0000000..f10c61b
--- /dev/null
+++ b/arm/locking-test.c
@@ -0,0 +1,302 @@
+#include <libcflat.h>
+#include <asm/smp.h>
+#include <asm/cpumask.h>
+#include <asm/barrier.h>
+#include <asm/mmu.h>
+
+#include <prng.h>
+
+#define MAX_CPUS 8
+
+/* Test definition structure
+ *
+ * A simple structure that describes the test name, expected pass and
+ * increment function.
+ */
+
+/* Function pointers for test */
+typedef void (*inc_fn)(int cpu);
+
+typedef struct {
+	const char *test_name;
+	bool  should_pass;
+	inc_fn main_fn;
+} test_descr_t;
+
+/* How many increments to do */
+static int increment_count = 1000000;
+static bool do_shuffle = true;
+
+/* Shared value all the tests attempt to safely increment using
+ * various forms of atomic locking and exclusive behaviour.
+ */
+static unsigned int shared_value;
+
+/* PAGE_SIZE * uint32_t means we span several pages */
+__attribute__((aligned(PAGE_SIZE))) static uint32_t memory_array[PAGE_SIZE];
+
+/* We use the alignment of the following to ensure accesses to locking
+ * and synchronisation primatives don't interfere with the page of the
+ * shared value
+ */
+__attribute__((aligned(PAGE_SIZE))) static unsigned int per_cpu_value[MAX_CPUS];
+__attribute__((aligned(PAGE_SIZE))) static cpumask_t smp_test_complete;
+__attribute__((aligned(PAGE_SIZE))) struct isaac_ctx prng_context[MAX_CPUS];
+
+/* Some of the approaches use a global lock to prevent contention. */
+static int global_lock;
+
+/* In any SMP setting this *should* fail due to cores stepping on
+ * each other updating the shared variable
+ */
+static void increment_shared(int cpu)
+{
+	(void)cpu;
+
+	shared_value++;
+}
+
+/* GCC __sync primitives are deprecated in favour of __atomic */
+static void increment_shared_with_lock(int cpu)
+{
+	(void)cpu;
+
+	while (__sync_lock_test_and_set(&global_lock, 1));
+	shared_value++;
+	__sync_lock_release(&global_lock);
+}
+
+/* In practice even __ATOMIC_RELAXED uses ARM's ldxr/stex exclusive
+ * semantics */
+static void increment_shared_with_atomic(int cpu)
+{
+	(void)cpu;
+
+	__atomic_add_fetch(&shared_value, 1, __ATOMIC_SEQ_CST);
+}
+
+
+/*
+ * Load/store exclusive with WFE (wait-for-event)
+ *
+ * See ARMv8 ARM examples:
+ *   Use of Wait For Event (WFE) and Send Event (SEV) with locks
+ */
+
+static void increment_shared_with_wfelock(int cpu)
+{
+	(void)cpu;
+
+#if defined(__aarch64__)
+	asm volatile(
+	"	mov     w1, #1\n"
+	"       sevl\n"
+	"       prfm PSTL1KEEP, [%[lock]]\n"
+	"1:     wfe\n"
+	"	ldaxr	w0, [%[lock]]\n"
+	"	cbnz    w0, 1b\n"
+	"	stxr    w0, w1, [%[lock]]\n"
+	"	cbnz	w0, 1b\n"
+	/* lock held */
+	"	ldr	w0, [%[sptr]]\n"
+	"	add	w0, w0, #0x1\n"
+	"	str	w0, [%[sptr]]\n"
+	/* now release */
+	"	stlr	wzr, [%[lock]]\n"
+	: /* out */
+	: [lock] "r" (&global_lock), [sptr] "r" (&shared_value) /* in */
+	: "w0", "w1", "cc");
+#else
+	asm volatile(
+	"	mov     r1, #1\n"
+	"1:	ldrex	r0, [%[lock]]\n"
+	"	cmp     r0, #0\n"
+	"	wfene\n"
+	"	strexeq r0, r1, [%[lock]]\n"
+	"	cmpeq	r0, #0\n"
+	"	bne	1b\n"
+	"	dmb\n"
+	/* lock held */
+	"	ldr	r0, [%[sptr]]\n"
+	"	add	r0, r0, #0x1\n"
+	"	str	r0, [%[sptr]]\n"
+	/* now release */
+	"	mov	r0, #0\n"
+	"	dmb\n"
+	"	str	r0, [%[lock]]\n"
+	"	dsb\n"
+	"	sev\n"
+	: /* out */
+	: [lock] "r" (&global_lock), [sptr] "r" (&shared_value) /* in */
+	: "r0", "r1", "cc");
+#endif
+}
+
+
+/*
+ * Hand-written version of the load/store exclusive
+ */
+static void increment_shared_with_excl(int cpu)
+{
+	(void)cpu;
+
+#if defined(__aarch64__)
+        asm volatile(
+	"1:	ldxr	w0, [%[sptr]]\n"
+	"	add     w0, w0, #0x1\n"
+	"	stxr	w1, w0, [%[sptr]]\n"
+	"	cbnz	w1, 1b\n"
+	: /* out */
+	: [sptr] "r" (&shared_value) /* in */
+	: "w0", "w1", "cc");
+#else
+	asm volatile(
+	"1:	ldrex	r0, [%[sptr]]\n"
+	"	add     r0, r0, #0x1\n"
+	"	strex	r1, r0, [%[sptr]]\n"
+	"	cmp	r1, #0\n"
+	"	bne	1b\n"
+	: /* out */
+	: [sptr] "r" (&shared_value) /* in */
+	: "r0", "r1", "cc");
+#endif
+}
+
+/* Test array */
+static test_descr_t tests[] = {
+	{ "none", false, increment_shared },
+	{ "lock", true, increment_shared_with_lock },
+	{ "atomic", true, increment_shared_with_atomic },
+	{ "wfelock", true, increment_shared_with_wfelock },
+	{ "excl", true, increment_shared_with_excl }
+};
+
+/* The idea of this is just to generate some random load/store
+ * activity which may or may not race with an un-barried incremented
+ * of the shared counter
+ */
+static void shuffle_memory(int cpu)
+{
+	int i;
+	uint32_t lspat = isaac_next_uint32(&prng_context[cpu]);
+	uint32_t seq = isaac_next_uint32(&prng_context[cpu]);
+	int count = seq & 0x1f;
+	uint32_t val=0;
+
+	seq >>= 5;
+
+	for (i=0; i<count; i++) {
+		int index = seq & ~PAGE_MASK;
+		if (lspat & 1) {
+			val ^= memory_array[index];
+		} else {
+			memory_array[index] = val;
+		}
+		seq >>= PAGE_SHIFT;
+		seq ^= lspat;
+		lspat >>= 1;
+	}
+
+}
+
+static inc_fn increment_function;
+
+static void do_increment(void)
+{
+	int i;
+	int cpu = smp_processor_id();
+
+	printf("CPU%d: online and ++ing\n", cpu);
+
+	for (i=0; i < increment_count; i++) {
+		per_cpu_value[cpu]++;
+		increment_function(cpu);
+
+		if (do_shuffle)
+			shuffle_memory(cpu);
+	}
+
+	printf("CPU%d: Done, %d incs\n", cpu, per_cpu_value[cpu]);
+
+	cpumask_set_cpu(cpu, &smp_test_complete);
+	if (cpu != 0)
+		halt();
+}
+
+static void setup_and_run_test(test_descr_t *test)
+{
+	unsigned int i, sum = 0;
+	int cpu, cpu_cnt = 0;
+
+	increment_function = test->main_fn;
+
+	/* fill our random page */
+        for (i=0; i<PAGE_SIZE; i++) {
+		memory_array[i] = isaac_next_uint32(&prng_context[0]);
+	}
+
+	for_each_present_cpu(cpu) {
+		uint32_t seed2 = isaac_next_uint32(&prng_context[0]);
+		cpu_cnt++;
+		if (cpu == 0)
+			continue;
+
+		isaac_init(&prng_context[cpu], (unsigned char *) &seed2, sizeof(seed2));
+		smp_boot_secondary(cpu, do_increment);
+	}
+
+	do_increment();
+
+	while (!cpumask_full(&smp_test_complete))
+		cpu_relax();
+
+	/* All CPUs done, do we add up */
+	for_each_present_cpu(cpu) {
+		sum += per_cpu_value[cpu];
+	}
+
+	if (test->should_pass) {
+		report("total incs %d", sum == shared_value, shared_value);
+	} else {
+		report_xfail("total incs %d", true, sum == shared_value, shared_value);
+	}
+}
+
+int main(int argc, char **argv)
+{
+	static const unsigned char seed[] = "myseed";
+	test_descr_t *test = &tests[0];
+	int i;
+	unsigned int j;
+
+	isaac_init(&prng_context[0], &seed[0], sizeof(seed));
+
+	for (i=0; i<argc; i++) {
+		char *arg = argv[i];
+
+		/* Check for test name */
+		for (j = 0; j < ARRAY_SIZE(tests); j++) {
+			if (strcmp(arg, tests[j].test_name) == 0)
+				test = &tests[j];
+		}
+
+		/* Test modifiers */
+		if (strcmp(arg, "noshuffle") == 0) {
+			do_shuffle = false;
+			report_prefix_push("noshuffle");
+		} else if (strstr(arg, "count=") != NULL) {
+			char *p = strstr(arg, "=");
+			increment_count = atol(p+1);
+		} else {
+			isaac_reseed(&prng_context[0], (unsigned char *) arg, strlen(arg));
+		}
+	}
+
+	if (test) {
+		setup_and_run_test(test);
+	} else {
+		report("Unknown test", false);
+	}
+
+	return report_summary();
+}
diff --git a/arm/unittests.cfg b/arm/unittests.cfg
index 7dc7799..abbfe79 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -108,3 +108,37 @@ smp = $(($MAX_SMP>4?4:$MAX_SMP))
 extra_params = -append "page"
 groups = tlbflush
 
+# Locking tests
+[locking::none]
+file = locking-test.flat
+smp = $(($MAX_SMP>4?4:$MAX_SMP))
+groups = locking
+accel = tcg
+
+[locking::lock]
+file = locking-test.flat
+smp = $(($MAX_SMP>4?4:$MAX_SMP))
+extra_params = -append 'lock'
+groups = locking
+accel = tcg
+
+[locking::atomic]
+file = locking-test.flat
+smp = $(($MAX_SMP>4?4:$MAX_SMP))
+extra_params = -append 'atomic'
+groups = locking
+accel = tcg
+
+[locking::wfelock]
+file = locking-test.flat
+smp = $(($MAX_SMP>4?4:$MAX_SMP))
+extra_params = -append 'wfelock'
+groups = locking
+accel = tcg
+
+[locking::excl]
+file = locking-test.flat
+smp = $(($MAX_SMP>4?4:$MAX_SMP))
+extra_params = -append 'excl'
+groups = locking
+accel = tcg
-- 
2.10.1

