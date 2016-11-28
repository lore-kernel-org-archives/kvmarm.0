From: Andrew Jones <drjones@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v7 07/11] arm/tlbflush-code: Add TLB flush
 during code execution test
Date: Mon, 28 Nov 2016 10:42:56 +0100
Message-ID: <20161128094256.4m3zfsb7cwmd2zf4@kamzik.brq.redhat.com>
References: <20161124161033.11456-1-alex.bennee@linaro.org>
 <20161124161033.11456-8-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AEDD340665
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Nov 2016 04:42:19 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PE3H2i2X1TSW for <kvmarm@lists.cs.columbia.edu>;
 Mon, 28 Nov 2016 04:42:17 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 84888405D7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Nov 2016 04:42:17 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20161124161033.11456-8-alex.bennee@linaro.org>
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
Cc: mttcg@greensocs.com, nikunj@linux.vnet.ibm.com, kvm@vger.kernel.org, marc.zyngier@arm.com, jan.kiszka@siemens.com, mark.burton@greensocs.com, qemu-devel@nongnu.org, cota@braap.org, linux-arm-kernel@lists.infradead.org, pbonzini@redhat.com, serge.fdrv@gmail.com, bobby.prani@gmail.com, kvmarm@lists.cs.columbia.edu, rth@twiddle.net
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Nov 24, 2016 at 04:10:29PM +0000, Alex Benn=E9e wrote:
> This adds a fairly brain dead torture test for TLB flushes intended for
> stressing the MTTCG QEMU build. It takes the usual -smp option for
> multiple CPUs.
> =

> By default it CPU0 will do a TLBIALL flush after each cycle. You can
> pass options via -append to control additional aspects of the test:
> =

>   - "page" flush each page in turn (one per function)
>   - "self" do the flush after each computation cycle
>   - "verbose" report progress on each computation cycle
> =

> Signed-off-by: Alex Benn=E9e <alex.bennee@linaro.org>
> CC: Mark Rutland <mark.rutland@arm.com>
> =

> ---
> v2
>   - rename to tlbflush-test
>   - made makefile changes cleaner
>   - added self/other flush mode
>   - create specific prefix
>   - whitespace fixes
> v3
>   - using new SMP framework for test runing
> v4
>   - merge in the unitests.cfg
> v5
>   - max out at -smp 4
>   - printf fmtfix
> v7
>   - rename to tlbflush-code
>   - int -> bool flags
> ---
>  arm/Makefile.common |   2 +
>  arm/tlbflush-code.c | 212 ++++++++++++++++++++++++++++++++++++++++++++++=
++++++
>  arm/unittests.cfg   |  24 ++++++
>  3 files changed, 238 insertions(+)
>  create mode 100644 arm/tlbflush-code.c
> =

> diff --git a/arm/Makefile.common b/arm/Makefile.common
> index cca0d9c..de99a6e 100644
> --- a/arm/Makefile.common
> +++ b/arm/Makefile.common
> @@ -13,6 +13,7 @@ tests-common  =3D $(TEST_DIR)/selftest.flat
>  tests-common +=3D $(TEST_DIR)/spinlock-test.flat
>  tests-common +=3D $(TEST_DIR)/pci-test.flat
>  tests-common +=3D $(TEST_DIR)/gic.flat
> +tests-common +=3D $(TEST_DIR)/tlbflush-code.flat
>  =

>  all: test_cases
>  =

> @@ -81,3 +82,4 @@ generated_files =3D $(asm-offsets)
>  test_cases: $(generated_files) $(tests-common) $(tests)
>  =

>  $(TEST_DIR)/selftest.o $(cstart.o): $(asm-offsets)
> +$(TEST_DIR)/tlbflush-code.elf: $(cstart.o) $(TEST_DIR)/tlbflush-code.o

This should no longer be necessary.

> diff --git a/arm/tlbflush-code.c b/arm/tlbflush-code.c
> new file mode 100644
> index 0000000..cb5cdc2
> --- /dev/null
> +++ b/arm/tlbflush-code.c
> @@ -0,0 +1,212 @@
> +/*
> + * TLB Flush Race Tests
> + *
> + * These tests are designed to test for incorrect TLB flush semantics
> + * under emulation. The initial CPU will set all the others working a
> + * compuation task and will then trigger TLB flushes across the
> + * system. It doesn't actually need to re-map anything but the flushes
> + * themselves will trigger QEMU's TCG self-modifying code detection
> + * which will invalidate any generated  code causing re-translation.
> + * Eventually the code buffer will fill and a general tb_lush() will
> + * be triggered.
> + *
> + * Copyright (C) 2016, Linaro, Alex Benn=E9e <alex.bennee@linaro.org>
> + *
> + * This work is licensed under the terms of the GNU LGPL, version 2.
> + */
> +
> +#include <libcflat.h>
> +#include <asm/smp.h>
> +#include <asm/cpumask.h>
> +#include <asm/barrier.h>
> +#include <asm/mmu.h>
> +
> +#define SEQ_LENGTH 10
> +#define SEQ_HASH 0x7cd707fe
> +
> +static cpumask_t smp_test_complete;
> +static int flush_count =3D 1000000;
> +static bool flush_self;
> +static bool flush_page;
> +static bool flush_verbose;
> +
> +/*
> + * Work functions
> + *
> + * These work functions need to be:
> + *
> + *  - page aligned, so we can flush one function at a time
> + *  - have branches, so QEMU TCG generates multiple basic blocks
> + *  - call across pages, so we exercise the TCG basic block slow path
> + */
> +
> +/* Adler32 */
> +__attribute__((aligned(PAGE_SIZE))) uint32_t hash_array(const void *buf,
> +							size_t buflen)

I think I'd prefer

__attribute__((aligned(PAGE_SIZE)))
uint32_t hash_array(const void *buf, size_t buflen)

to handle the long line

> +{
> +	const uint8_t *data =3D (uint8_t *) buf;
> +	uint32_t s1 =3D 1;
> +	uint32_t s2 =3D 0;
> +
> +	for (size_t n =3D 0; n < buflen; n++) {
> +		s1 =3D (s1 + data[n]) % 65521;
> +		s2 =3D (s2 + s1) % 65521;
> +	}
> +	return (s2 << 16) | s1;
> +}
> +
> +__attribute__((aligned(PAGE_SIZE))) void create_fib_sequence(int length,
> +							unsigned int *array)
> +{
> +	int i;
> +
> +	/* first two values */
> +	array[0] =3D 0;
> +	array[1] =3D 1;
> +	for (i=3D2; i<length; i++) {
> +		array[i] =3D array[i-2] + array[i-1];
> +	}

please don't use {} for one-liners. Try running the kernel's check_patch
on your patches. Applies many places below

> +}
> +
> +__attribute__((aligned(PAGE_SIZE))) unsigned long long factorial(unsigne=
d int n)

long line

> +{
> +	unsigned int i;
> +	unsigned long long fac =3D 1;
> +	for (i=3D1; i<=3Dn; i++)
> +	{
> +		fac =3D fac * i;
> +	}
> +	return fac;
> +}
> +
> +__attribute__((aligned(PAGE_SIZE))) void factorial_array
> +(unsigned int n, unsigned int *input, unsigned long long *output)
> +{
> +	unsigned int i;
> +	for (i=3D0; i<n; i++) {
> +		output[i] =3D factorial(input[i]);
> +	}
> +}
> +
> +__attribute__((aligned(PAGE_SIZE))) unsigned int do_computation(void)
> +{
> +	unsigned int fib_array[SEQ_LENGTH];
> +	unsigned long long facfib_array[SEQ_LENGTH];
> +	uint32_t fib_hash, facfib_hash;
> +
> +	create_fib_sequence(SEQ_LENGTH, &fib_array[0]);
> +	fib_hash =3D hash_array(&fib_array[0], sizeof(fib_array));
> +	factorial_array(SEQ_LENGTH, &fib_array[0], &facfib_array[0]);
> +	facfib_hash =3D hash_array(&facfib_array[0], sizeof(facfib_array));
> +
> +	return (fib_hash ^ facfib_hash);
> +}
> +
> +/* This provides a table of the work functions so we can flush each
> + * page individually
> + */
> +static void * pages[] =3D {&hash_array, &create_fib_sequence, &factorial,
> +			 &factorial_array, &do_computation};

please put the '*' by pages

> +
> +static void do_flush(int i)
> +{
> +	if (flush_page) {
> +		flush_tlb_page((unsigned long)pages[i % ARRAY_SIZE(pages)]);
> +	} else {
> +		flush_tlb_all();
> +	}
> +}
> +
> +
> +static void just_compute(void)
> +{
> +	int i, errors =3D 0;
> +	int cpu =3D smp_processor_id();
> +
> +	uint32_t result;
> +
> +	printf("CPU%d online\n", cpu);
> +
> +	for (i=3D0; i < flush_count; i++) {
> +		result =3D do_computation();
> +
> +		if (result !=3D SEQ_HASH) {
> +			errors++;
> +			printf("CPU%d: seq%d 0x%"PRIx32"!=3D0x%x\n",
> +				cpu, i, result, SEQ_HASH);
> +		}
> +
> +		if (flush_verbose && (i % 1000) =3D=3D 0) {
> +			printf("CPU%d: seq%d\n", cpu, i);
> +		}
> +
> +		if (flush_self) {
> +			do_flush(i);
> +		}
> +	}
> +
> +	report("CPU%d: Done - Errors: %d\n", errors =3D=3D 0, cpu, errors);
> +
> +	cpumask_set_cpu(cpu, &smp_test_complete);
> +	if (cpu !=3D 0)
> +		halt();
> +}
> +
> +static void just_flush(void)
> +{
> +	int cpu =3D smp_processor_id();
> +	int i =3D 0;
> +
> +	/* set our CPU as done, keep flushing until everyone else
> +	   finished */

Not our comment style

> +	cpumask_set_cpu(cpu, &smp_test_complete);
> +
> +	while (!cpumask_full(&smp_test_complete)) {
> +		do_flush(i++);
> +	}
> +
> +	report("CPU%d: Done - Triggered %d flushes\n", true, cpu, i);
> +}
> +
> +int main(int argc, char **argv)
> +{
> +	int cpu, i;
> +	char prefix[100];
> +
> +	for (i=3D0; i<argc; i++) {
> +		char *arg =3D argv[i];
> +
> +		if (strcmp(arg, "page") =3D=3D 0) {
> +			flush_page =3D true;
> +                }
> +
> +                if (strcmp(arg, "self") =3D=3D 0) {
> +			flush_self =3D true;
> +                }
> +
> +		if (strcmp(arg, "verbose") =3D=3D 0) {
> +			flush_verbose =3D true;
> +                }
> +	}
> +
> +	snprintf(prefix, sizeof(prefix), "tlbflush_%s_%s",
> +		flush_page?"page":"all",
> +		flush_self?"self":"other");
> +	report_prefix_push(prefix);
> +
> +	for_each_present_cpu(cpu) {
> +		if (cpu =3D=3D 0)
> +			continue;
> +		smp_boot_secondary(cpu, just_compute);
> +	}
> +
> +	if (flush_self)
> +		just_compute();
> +	else
> +		just_flush();
> +
> +	while (!cpumask_full(&smp_test_complete))
> +		cpu_relax();
> +
> +	return report_summary();
> +}
> diff --git a/arm/unittests.cfg b/arm/unittests.cfg
> index c7392c7..beaae84 100644
> --- a/arm/unittests.cfg
> +++ b/arm/unittests.cfg
> @@ -72,3 +72,27 @@ file =3D gic.flat
>  smp =3D $MAX_SMP
>  extra_params =3D -machine gic-version=3D3 -append 'ipi'
>  groups =3D gic
> +
> +# TLB Torture Tests
> +[tlbflush-code::all_other]

We don't use the '::' style anymore, as it doesn't work
well with mkstandalone.

> +file =3D tlbflush-code.flat
> +smp =3D $(($MAX_SMP>4?4:$MAX_SMP))
> +groups =3D tlbflush
> +
> +[tlbflush-code::page_other]
> +file =3D tlbflush-code.flat
> +smp =3D $(($MAX_SMP>4?4:$MAX_SMP))
> +extra_params =3D -append 'page'
> +groups =3D tlbflush
> +
> +[tlbflush-code::all_self]
> +file =3D tlbflush-code.flat
> +smp =3D $(($MAX_SMP>4?4:$MAX_SMP))
> +extra_params =3D -append 'self'
> +groups =3D tlbflush
> +
> +[tlbflush-code::page_self]
> +file =3D tlbflush-code.flat
> +smp =3D $(($MAX_SMP>4?4:$MAX_SMP))
> +extra_params =3D -append 'page self'
> +groups =3D tlbflush
> -- =

> 2.10.1
>

I only did a superficial review, but it looks familiar. I guess I've
reviewed some of it before.

drew
