From: Andrew Jones <drjones@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v7 09/11] arm/locking-tests: add
 comprehensive locking test
Date: Mon, 28 Nov 2016 11:29:58 +0100
Message-ID: <20161128102958.6i4cfi2osbppr6t3@kamzik.brq.redhat.com>
References: <20161124161033.11456-1-alex.bennee@linaro.org>
 <20161124161033.11456-10-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 02BFC405CC
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Nov 2016 05:29:22 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JFv8x8e8uZgi for <kvmarm@lists.cs.columbia.edu>;
 Mon, 28 Nov 2016 05:29:19 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8EE5040194
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Nov 2016 05:29:19 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20161124161033.11456-10-alex.bennee@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc: mttcg@greensocs.com, nikunj@linux.vnet.ibm.com, kvm@vger.kernel.org, marc.zyngier@arm.com, jan.kiszka@siemens.com, mark.burton@greensocs.com, qemu-devel@nongnu.org, cota@braap.org, linux-arm-kernel@lists.infradead.org, serge.fdrv@gmail.com, pbonzini@redhat.com, bobby.prani@gmail.com, rth@twiddle.net, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Nov 24, 2016 at 04:10:31PM +0000, Alex Benn=E9e wrote:
> This test has been written mainly to stress multi-threaded TCG behaviour
> but will demonstrate failure by default on real hardware. The test takes
> the following parameters:
> =

>   - "lock" use GCC's locking semantics
>   - "atomic" use GCC's __atomic primitives
>   - "wfelock" use WaitForEvent sleep
>   - "excl" use load/store exclusive semantics
> =

> Also two more options allow the test to be tweaked
> =

>   - "noshuffle" disables the memory shuffling
>   - "count=3D%ld" set your own per-CPU increment count
> =

> Signed-off-by: Alex Benn=E9e <alex.bennee@linaro.org>
> =

> ---
> v2
>   - Don't use thumb style strexeq stuff
>   - Add atomic and wfelock tests
>   - Add count/noshuffle test controls
>   - Move barrier tests to separate test file
> v4
>   - fix up unitests.cfg to use correct test name
>   - move into "locking" group, remove barrier tests
>   - use a table to add tests, mark which are expected to work
>   - correctly report XFAIL
> v5
>   - max out at -smp 4 in unittest.cfg
> v7
>   - make test control flags bools
>   - default the count to 100000 (so it doesn't timeout)
> ---
>  arm/Makefile.common |   2 +
>  arm/locking-test.c  | 302 ++++++++++++++++++++++++++++++++++++++++++++++=
++++++
>  arm/unittests.cfg   |  34 ++++++
>  3 files changed, 338 insertions(+)
>  create mode 100644 arm/locking-test.c
> =

> diff --git a/arm/Makefile.common b/arm/Makefile.common
> index 528166d..eb4cfdf 100644
> --- a/arm/Makefile.common
> +++ b/arm/Makefile.common
> @@ -15,6 +15,7 @@ tests-common +=3D $(TEST_DIR)/pci-test.flat
>  tests-common +=3D $(TEST_DIR)/gic.flat
>  tests-common +=3D $(TEST_DIR)/tlbflush-code.flat
>  tests-common +=3D $(TEST_DIR)/tlbflush-data.flat
> +tests-common +=3D $(TEST_DIR)/locking-test.flat
>  =

>  all: test_cases
>  =

> @@ -85,3 +86,4 @@ test_cases: $(generated_files) $(tests-common) $(tests)
>  $(TEST_DIR)/selftest.o $(cstart.o): $(asm-offsets)
>  $(TEST_DIR)/tlbflush-code.elf: $(cstart.o) $(TEST_DIR)/tlbflush-code.o
>  $(TEST_DIR)/tlbflush-data.elf: $(cstart.o) $(TEST_DIR)/tlbflush-data.o
> +$(TEST_DIR)/locking-test.elf: $(cstart.o) $(TEST_DIR)/locking-test.o

Instead of adding a new test file, please extend the one we already have,
which iirc was the first MTTCG test, arm/spinlock-test.c. If you don't
like the naming or code in spinlock-test.c, then feel free to change it,
delete it. It's currently not getting run by arm/unittests.cfg, and it's
not getting maintained.

> diff --git a/arm/locking-test.c b/arm/locking-test.c
> new file mode 100644
> index 0000000..f10c61b
> --- /dev/null
> +++ b/arm/locking-test.c
> @@ -0,0 +1,302 @@
> +#include <libcflat.h>
> +#include <asm/smp.h>
> +#include <asm/cpumask.h>
> +#include <asm/barrier.h>
> +#include <asm/mmu.h>
> +
> +#include <prng.h>
> +
> +#define MAX_CPUS 8
> +
> +/* Test definition structure
> + *
> + * A simple structure that describes the test name, expected pass and
> + * increment function.
> + */
> +
> +/* Function pointers for test */
> +typedef void (*inc_fn)(int cpu);
> +
> +typedef struct {
> +	const char *test_name;
> +	bool  should_pass;
> +	inc_fn main_fn;
> +} test_descr_t;
> +
> +/* How many increments to do */
> +static int increment_count =3D 1000000;
> +static bool do_shuffle =3D true;
> +
> +/* Shared value all the tests attempt to safely increment using
> + * various forms of atomic locking and exclusive behaviour.
> + */
> +static unsigned int shared_value;
> +
> +/* PAGE_SIZE * uint32_t means we span several pages */
> +__attribute__((aligned(PAGE_SIZE))) static uint32_t memory_array[PAGE_SI=
ZE];
> +
> +/* We use the alignment of the following to ensure accesses to locking
> + * and synchronisation primatives don't interfere with the page of the
> + * shared value
> + */
> +__attribute__((aligned(PAGE_SIZE))) static unsigned int per_cpu_value[MA=
X_CPUS];
> +__attribute__((aligned(PAGE_SIZE))) static cpumask_t smp_test_complete;
> +__attribute__((aligned(PAGE_SIZE))) struct isaac_ctx prng_context[MAX_CP=
US];
> +
> +/* Some of the approaches use a global lock to prevent contention. */
> +static int global_lock;
> +
> +/* In any SMP setting this *should* fail due to cores stepping on
> + * each other updating the shared variable
> + */
> +static void increment_shared(int cpu)
> +{
> +	(void)cpu;
> +
> +	shared_value++;
> +}
> +
> +/* GCC __sync primitives are deprecated in favour of __atomic */
> +static void increment_shared_with_lock(int cpu)
> +{
> +	(void)cpu;
> +
> +	while (__sync_lock_test_and_set(&global_lock, 1));
> +	shared_value++;
> +	__sync_lock_release(&global_lock);
> +}
> +
> +/* In practice even __ATOMIC_RELAXED uses ARM's ldxr/stex exclusive
> + * semantics */
> +static void increment_shared_with_atomic(int cpu)
> +{
> +	(void)cpu;
> +
> +	__atomic_add_fetch(&shared_value, 1, __ATOMIC_SEQ_CST);
> +}
> +
> +
> +/*
> + * Load/store exclusive with WFE (wait-for-event)
> + *
> + * See ARMv8 ARM examples:
> + *   Use of Wait For Event (WFE) and Send Event (SEV) with locks
> + */
> +
> +static void increment_shared_with_wfelock(int cpu)
> +{
> +	(void)cpu;
> +
> +#if defined(__aarch64__)
> +	asm volatile(
> +	"	mov     w1, #1\n"
> +	"       sevl\n"
> +	"       prfm PSTL1KEEP, [%[lock]]\n"
> +	"1:     wfe\n"
> +	"	ldaxr	w0, [%[lock]]\n"
> +	"	cbnz    w0, 1b\n"
> +	"	stxr    w0, w1, [%[lock]]\n"
> +	"	cbnz	w0, 1b\n"
> +	/* lock held */
> +	"	ldr	w0, [%[sptr]]\n"
> +	"	add	w0, w0, #0x1\n"
> +	"	str	w0, [%[sptr]]\n"
> +	/* now release */
> +	"	stlr	wzr, [%[lock]]\n"
> +	: /* out */
> +	: [lock] "r" (&global_lock), [sptr] "r" (&shared_value) /* in */
> +	: "w0", "w1", "cc");
> +#else
> +	asm volatile(
> +	"	mov     r1, #1\n"
> +	"1:	ldrex	r0, [%[lock]]\n"
> +	"	cmp     r0, #0\n"
> +	"	wfene\n"
> +	"	strexeq r0, r1, [%[lock]]\n"
> +	"	cmpeq	r0, #0\n"
> +	"	bne	1b\n"
> +	"	dmb\n"
> +	/* lock held */
> +	"	ldr	r0, [%[sptr]]\n"
> +	"	add	r0, r0, #0x1\n"
> +	"	str	r0, [%[sptr]]\n"
> +	/* now release */
> +	"	mov	r0, #0\n"
> +	"	dmb\n"
> +	"	str	r0, [%[lock]]\n"
> +	"	dsb\n"
> +	"	sev\n"
> +	: /* out */
> +	: [lock] "r" (&global_lock), [sptr] "r" (&shared_value) /* in */
> +	: "r0", "r1", "cc");
> +#endif
> +}
> +
> +
> +/*
> + * Hand-written version of the load/store exclusive
> + */
> +static void increment_shared_with_excl(int cpu)
> +{
> +	(void)cpu;
> +
> +#if defined(__aarch64__)
> +        asm volatile(
> +	"1:	ldxr	w0, [%[sptr]]\n"
> +	"	add     w0, w0, #0x1\n"
> +	"	stxr	w1, w0, [%[sptr]]\n"
> +	"	cbnz	w1, 1b\n"
> +	: /* out */
> +	: [sptr] "r" (&shared_value) /* in */
> +	: "w0", "w1", "cc");
> +#else
> +	asm volatile(
> +	"1:	ldrex	r0, [%[sptr]]\n"
> +	"	add     r0, r0, #0x1\n"
> +	"	strex	r1, r0, [%[sptr]]\n"
> +	"	cmp	r1, #0\n"
> +	"	bne	1b\n"
> +	: /* out */
> +	: [sptr] "r" (&shared_value) /* in */
> +	: "r0", "r1", "cc");
> +#endif
> +}
> +
> +/* Test array */
> +static test_descr_t tests[] =3D {
> +	{ "none", false, increment_shared },
> +	{ "lock", true, increment_shared_with_lock },
> +	{ "atomic", true, increment_shared_with_atomic },
> +	{ "wfelock", true, increment_shared_with_wfelock },
> +	{ "excl", true, increment_shared_with_excl }
> +};
> +
> +/* The idea of this is just to generate some random load/store
> + * activity which may or may not race with an un-barried incremented
> + * of the shared counter
> + */
> +static void shuffle_memory(int cpu)
> +{
> +	int i;
> +	uint32_t lspat =3D isaac_next_uint32(&prng_context[cpu]);
> +	uint32_t seq =3D isaac_next_uint32(&prng_context[cpu]);
> +	int count =3D seq & 0x1f;
> +	uint32_t val=3D0;
> +
> +	seq >>=3D 5;
> +
> +	for (i=3D0; i<count; i++) {
> +		int index =3D seq & ~PAGE_MASK;
> +		if (lspat & 1) {
> +			val ^=3D memory_array[index];
> +		} else {
> +			memory_array[index] =3D val;
> +		}
> +		seq >>=3D PAGE_SHIFT;
> +		seq ^=3D lspat;
> +		lspat >>=3D 1;
> +	}
> +

extra line here

> +}
> +
> +static inc_fn increment_function;
> +
> +static void do_increment(void)
> +{
> +	int i;
> +	int cpu =3D smp_processor_id();
> +
> +	printf("CPU%d: online and ++ing\n", cpu);
> +
> +	for (i=3D0; i < increment_count; i++) {
> +		per_cpu_value[cpu]++;
> +		increment_function(cpu);
> +
> +		if (do_shuffle)
> +			shuffle_memory(cpu);
> +	}
> +
> +	printf("CPU%d: Done, %d incs\n", cpu, per_cpu_value[cpu]);
> +
> +	cpumask_set_cpu(cpu, &smp_test_complete);
> +	if (cpu !=3D 0)
> +		halt();
> +}
> +
> +static void setup_and_run_test(test_descr_t *test)
> +{
> +	unsigned int i, sum =3D 0;
> +	int cpu, cpu_cnt =3D 0;
> +
> +	increment_function =3D test->main_fn;
> +
> +	/* fill our random page */
> +        for (i=3D0; i<PAGE_SIZE; i++) {
> +		memory_array[i] =3D isaac_next_uint32(&prng_context[0]);
> +	}
> +
> +	for_each_present_cpu(cpu) {
> +		uint32_t seed2 =3D isaac_next_uint32(&prng_context[0]);
> +		cpu_cnt++;
> +		if (cpu =3D=3D 0)
> +			continue;
> +
> +		isaac_init(&prng_context[cpu], (unsigned char *) &seed2, sizeof(seed2)=
);
> +		smp_boot_secondary(cpu, do_increment);
> +	}
> +
> +	do_increment();
> +
> +	while (!cpumask_full(&smp_test_complete))
> +		cpu_relax();
> +
> +	/* All CPUs done, do we add up */
> +	for_each_present_cpu(cpu) {
> +		sum +=3D per_cpu_value[cpu];
> +	}
> +
> +	if (test->should_pass) {
> +		report("total incs %d", sum =3D=3D shared_value, shared_value);
> +	} else {
> +		report_xfail("total incs %d", true, sum =3D=3D shared_value, shared_va=
lue);
> +	}
> +}
> +
> +int main(int argc, char **argv)
> +{
> +	static const unsigned char seed[] =3D "myseed";
> +	test_descr_t *test =3D &tests[0];
> +	int i;
> +	unsigned int j;
> +
> +	isaac_init(&prng_context[0], &seed[0], sizeof(seed));
> +
> +	for (i=3D0; i<argc; i++) {
> +		char *arg =3D argv[i];
> +
> +		/* Check for test name */
> +		for (j =3D 0; j < ARRAY_SIZE(tests); j++) {
> +			if (strcmp(arg, tests[j].test_name) =3D=3D 0)
> +				test =3D &tests[j];
> +		}
> +
> +		/* Test modifiers */
> +		if (strcmp(arg, "noshuffle") =3D=3D 0) {
> +			do_shuffle =3D false;
> +			report_prefix_push("noshuffle");
> +		} else if (strstr(arg, "count=3D") !=3D NULL) {
> +			char *p =3D strstr(arg, "=3D");
> +			increment_count =3D atol(p+1);
> +		} else {
> +			isaac_reseed(&prng_context[0], (unsigned char *) arg, strlen(arg));
> +		}
> +	}
> +
> +	if (test) {
> +		setup_and_run_test(test);
> +	} else {
> +		report("Unknown test", false);
> +	}
> +
> +	return report_summary();
> +}
> diff --git a/arm/unittests.cfg b/arm/unittests.cfg
> index 7dc7799..abbfe79 100644
> --- a/arm/unittests.cfg
> +++ b/arm/unittests.cfg
> @@ -108,3 +108,37 @@ smp =3D $(($MAX_SMP>4?4:$MAX_SMP))
>  extra_params =3D -append "page"
>  groups =3D tlbflush
>  =

> +# Locking tests
> +[locking::none]
> +file =3D locking-test.flat
> +smp =3D $(($MAX_SMP>4?4:$MAX_SMP))
> +groups =3D locking
> +accel =3D tcg
> +
> +[locking::lock]
> +file =3D locking-test.flat
> +smp =3D $(($MAX_SMP>4?4:$MAX_SMP))
> +extra_params =3D -append 'lock'
> +groups =3D locking
> +accel =3D tcg
> +
> +[locking::atomic]
> +file =3D locking-test.flat
> +smp =3D $(($MAX_SMP>4?4:$MAX_SMP))
> +extra_params =3D -append 'atomic'
> +groups =3D locking
> +accel =3D tcg
> +
> +[locking::wfelock]
> +file =3D locking-test.flat
> +smp =3D $(($MAX_SMP>4?4:$MAX_SMP))
> +extra_params =3D -append 'wfelock'
> +groups =3D locking
> +accel =3D tcg
> +
> +[locking::excl]
> +file =3D locking-test.flat
> +smp =3D $(($MAX_SMP>4?4:$MAX_SMP))
> +extra_params =3D -append 'excl'
> +groups =3D locking
> +accel =3D tcg
> -- =

> 2.10.1
>

I didn't look too closely at this one...

Thanks,
drew
