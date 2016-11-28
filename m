From: Andrew Jones <drjones@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v7 08/11] arm/tlbflush-data:
 Add TLB flush during data writes test
Date: Mon, 28 Nov 2016 11:11:06 +0100
Message-ID: <20161128101106.ge4eyj6l7sw4jwbe@kamzik.brq.redhat.com>
References: <20161124161033.11456-1-alex.bennee@linaro.org>
	<20161124161033.11456-9-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org>
Content-Disposition: inline
In-Reply-To: <20161124161033.11456-9-alex.bennee@linaro.org>
List-Unsubscribe: <https://lists.nongnu.org/mailman/options/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=unsubscribe>
List-Archive: <http://lists.nongnu.org/archive/html/qemu-devel/>
List-Post: <mailto:qemu-devel@nongnu.org>
List-Help: <mailto:qemu-devel-request@nongnu.org?subject=help>
List-Subscribe: <https://lists.nongnu.org/mailman/listinfo/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=subscribe>
Errors-To: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
Sender: "Qemu-devel" <qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org>
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc: mttcg@greensocs.com, nikunj@linux.vnet.ibm.com, kvm@vger.kernel.org, marc.zyngier@arm.com, jan.kiszka@siemens.com, mark.burton@greensocs.com, qemu-devel@nongnu.org, cota@braap.org, linux-arm-kernel@lists.infradead.org, pbonzini@redhat.com, serge.fdrv@gmail.com, bobby.prani@gmail.com, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, rth@twiddle.net
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Nov 24, 2016 at 04:10:30PM +0000, Alex Benn=E9e wrote:
> This test is the cousin of the tlbflush-code test. Instead of flushing
> running code it re-maps virtual addresses while a buffer is being fille=
d
> up. It then audits the results checking for writes that have ended up i=
n
> the wrong place.
>=20
> While tlbflush-code exercises QEMU's translation invalidation logic thi=
s
> test stresses the SoftMMU cputlb code and ensures it is semantically
> correct.
>=20
> The test optionally takes two parameters for debugging:
>=20
>    cycles           - change the default number of test iterations
>    page             - flush pages individually instead of all
>=20
> Signed-off-by: Alex Benn=E9e <alex.bennee@linaro.org>
> CC: Mark Rutland <mark.rutland@arm.com>
> ---
>  arm/Makefile.common |   2 +
>  arm/tlbflush-data.c | 401 ++++++++++++++++++++++++++++++++++++++++++++=
++++++++
>  arm/unittests.cfg   |  12 ++
>  3 files changed, 415 insertions(+)
>  create mode 100644 arm/tlbflush-data.c
>=20
> diff --git a/arm/Makefile.common b/arm/Makefile.common
> index de99a6e..528166d 100644
> --- a/arm/Makefile.common
> +++ b/arm/Makefile.common
> @@ -14,6 +14,7 @@ tests-common +=3D $(TEST_DIR)/spinlock-test.flat
>  tests-common +=3D $(TEST_DIR)/pci-test.flat
>  tests-common +=3D $(TEST_DIR)/gic.flat
>  tests-common +=3D $(TEST_DIR)/tlbflush-code.flat
> +tests-common +=3D $(TEST_DIR)/tlbflush-data.flat
> =20
>  all: test_cases
> =20
> @@ -83,3 +84,4 @@ test_cases: $(generated_files) $(tests-common) $(test=
s)
> =20
>  $(TEST_DIR)/selftest.o $(cstart.o): $(asm-offsets)
>  $(TEST_DIR)/tlbflush-code.elf: $(cstart.o) $(TEST_DIR)/tlbflush-code.o
> +$(TEST_DIR)/tlbflush-data.elf: $(cstart.o) $(TEST_DIR)/tlbflush-data.o

This isn't necessary

> diff --git a/arm/tlbflush-data.c b/arm/tlbflush-data.c
> new file mode 100644
> index 0000000..7920179
> --- /dev/null
> +++ b/arm/tlbflush-data.c
> @@ -0,0 +1,401 @@
> +/*
> + * TLB Flush Race Tests
> + *
> + * These tests are designed to test for incorrect TLB flush semantics
> + * under emulation. The initial CPU will set all the others working on
> + * a writing to a set of pages. It will then re-map one of the pages
> + * back and forth while recording the timestamps of when each page was
> + * active. The test fails if a write was detected on a page after the
> + * tlbflush switching to a new page should have completed.
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
> +#define NR_TIMESTAMPS 		((PAGE_SIZE/sizeof(u64)) << 2)
> +#define NR_AUDIT_RECORDS	16384
> +#define NR_DYNAMIC_PAGES 	3
> +#define MAX_CPUS 		8
> +
> +#define MIN(a, b)		((a) < (b) ? (a) : (b))

Peter Xu is bringing MIN to libcflat with his edu series.

> +
> +typedef struct {
> +	u64    		timestamps[NR_TIMESTAMPS];
> +} write_buffer;
> +
> +typedef struct {
> +	write_buffer 	*newbuf;
> +	u64		time_before_flush;
> +	u64		time_after_flush;
> +} audit_rec_t;
> +
> +typedef struct {
> +	audit_rec_t 	records[NR_AUDIT_RECORDS];
> +} audit_buffer;
> +
> +typedef struct {
> +	write_buffer 	*stable_pages;
> +	write_buffer    *dynamic_pages[NR_DYNAMIC_PAGES];
> +	audit_buffer 	*audit;
> +	unsigned int 	flush_count;
> +} test_data_t;
> +
> +static test_data_t test_data[MAX_CPUS];
> +
> +static cpumask_t ready;
> +static cpumask_t complete;
> +
> +static bool test_complete;
> +static bool flush_verbose;
> +static bool flush_by_page;
> +static int test_cycles=3D3;
> +static int secondary_cpus;
> +
> +static write_buffer * alloc_test_pages(void)
> +{
> +	write_buffer *pg;
> +	pg =3D calloc(NR_TIMESTAMPS, sizeof(u64));
> +	return pg;
> +}
> +
> +static void setup_pages_for_cpu(int cpu)
> +{
> +	unsigned int i;
> +
> +	test_data[cpu].stable_pages =3D alloc_test_pages();
> +
> +	for (i=3D0; i<NR_DYNAMIC_PAGES; i++) {
> +		test_data[cpu].dynamic_pages[i] =3D alloc_test_pages();
> +	}
> +
> +	test_data[cpu].audit =3D calloc(NR_AUDIT_RECORDS, sizeof(audit_rec_t)=
);
> +}
> +
> +static audit_rec_t * get_audit_record(audit_buffer *buf, unsigned int =
record)
> +{
> +	return &buf->records[record];
> +}
> +
> +/* Sync on a given cpumask */
> +static void wait_on(int cpu, cpumask_t *mask)
> +{

Why take 'cpu' as a parameter. Just use smp_processor_id()

> +	cpumask_set_cpu(cpu, mask);
> +	while (!cpumask_full(mask))
> +		cpu_relax();
> +}
> +
> +static uint64_t sync_start(void)
> +{
> +	const uint64_t gate_mask =3D ~0x7ff;
> +	uint64_t gate, now;
> +	gate =3D get_cntvct() & gate_mask;
> +	do {
> +		now =3D get_cntvct();
> +	} while ((now & gate_mask) =3D=3D gate);

I'm not really sure what this function is doing. Trying to
get synchronized timestamps between cpus?

> +
> +	return now;
> +}
> +
> +static void do_page_writes(void)
> +{
> +	unsigned int i, runs =3D 0;
> +	int cpu =3D smp_processor_id();
> +	write_buffer *stable_pages =3D test_data[cpu].stable_pages;
> +	write_buffer *moving_page =3D test_data[cpu].dynamic_pages[0];
> +
> +	printf("CPU%d: ready %p/%p @ 0x%08" PRIx64"\n",
> +		cpu, stable_pages, moving_page, get_cntvct());
> +
> +	while (!test_complete) {
> +		u64 run_start, run_end;
> +
> +		smp_mb();
> +		wait_on(cpu, &ready);
> +		run_start =3D sync_start();
> +
> +		for (i =3D 0; i < NR_TIMESTAMPS; i++) {
> +			u64 ts =3D get_cntvct();
> +			moving_page->timestamps[i] =3D ts;
> +			stable_pages->timestamps[i] =3D ts;
> +		}
> +
> +		run_end =3D get_cntvct();
> +		printf("CPU%d: run %d 0x%" PRIx64 "->0x%" PRIx64 " (%" PRId64 " cycl=
es)\n",
> +			cpu, runs++, run_start, run_end, run_end - run_start);
> +
> +		/* wait on completion - gets clear my main thread*/
> +		wait_on(cpu, &complete);
> +	}
> +}
> +
> +
> +/*
> + * This is the core of the test. Timestamps are taken either side of
> + * the updating of the page table and the flush instruction. By
> + * keeping track of when the page mapping is changed we can detect any
> + * writes that shouldn't have made it to the other pages.
> + *
> + * This isn't the recommended way to update the page table. ARM
> + * recommends break-before-make so accesses that are in flight can
> + * trigger faults that can be handled cleanly.
> + */
> +
> +/* This mimics  __flush_tlb_range from the kernel, doing a series of
> + * flush operations and then the dsb() to complete. */
> +static void flush_pages(unsigned long start, unsigned long end)
> +{
> +	unsigned long addr;
> +	start =3D start >> 12;
> +	end =3D end >> 12;

Looks like you're assuming 4K pages, but AArch64 unit tests have 64K
pages. You're free to change that, but you'll need to disable and
re-enable the mmu with new parameters.

> +
> +	dsb(ishst);
> +	for (addr =3D start; addr < end; addr +=3D 1 << (PAGE_SHIFT -12)) {

Hmm, start and end are 4K aligned, but now you do shift addr appropriatel=
y
for 64K pages. Why not just do

start &=3D PAGE_MASK;
end &=3D PAGE_MASK;
addr +=3D PAGE_SIZE

> +#if defined(__aarch64__)
> +		asm("tlbi	vaae1is, %0" :: "r" (addr));
> +#else
> +		asm volatile("mcr p15, 0, %0, c8, c7, 3" :: "r" (addr));
> +#endif
> +	}
> +	dsb(ish);

flush_pages() may be something we want in common code.

> +}
> +
> +static void remap_one_page(test_data_t *data)
> +{
> +	u64 ts_before, ts_after;
> +	int pg =3D (data->flush_count % (NR_DYNAMIC_PAGES + 1));
> +	write_buffer *dynamic_pages_vaddr =3D data->dynamic_pages[0];
> +	write_buffer *newbuf_paddr =3D data->dynamic_pages[pg];
> +	write_buffer *end_page_paddr =3D newbuf_paddr+1;
> +
> +	ts_before =3D get_cntvct();
> +	/* update the page table */
> +	mmu_set_range_ptes(mmu_idmap,
> +			(unsigned long) dynamic_pages_vaddr,
> +			(unsigned long) newbuf_paddr,
> +			(unsigned long) end_page_paddr,
> +			__pgprot(PTE_WBWA));
> +	/* until the flush + isb() writes may still go to old address */
> +	if (flush_by_page) {
> +		flush_pages((unsigned long)dynamic_pages_vaddr, (unsigned long)(dyna=
mic_pages_vaddr+1));
> +	} else {
> +		flush_tlb_all();
> +	}
> +	ts_after =3D get_cntvct();
> +
> +	if (data->flush_count < NR_AUDIT_RECORDS) {
> +		audit_rec_t *rec =3D get_audit_record(data->audit, data->flush_count=
);
> +		rec->newbuf =3D newbuf_paddr;
> +		rec->time_before_flush =3D ts_before;
> +		rec->time_after_flush =3D ts_after;
> +	}
> +	data->flush_count++;
> +}
> +
> +static int check_pages(int cpu, char *msg,
> +		write_buffer *base_page, write_buffer *test_page,
> +		audit_buffer *audit, unsigned int flushes)
> +{
> +	write_buffer *prev_page =3D base_page;
> +	unsigned int empty =3D 0, write =3D 0, late =3D 0, weird =3D 0;

The variable 'weird' is a bit weird. How about 'bad'?

> +	unsigned int ts_index =3D 0, audit_index;
> +	u64 ts;
> +
> +	/* For each audit record */
> +	for (audit_index =3D 0; audit_index < MIN(flushes, NR_AUDIT_RECORDS);=
 audit_index++) {
> +		audit_rec_t *rec =3D get_audit_record(audit, audit_index);
> +
> +		do {
> +			/* Work through timestamps until we overtake
> +			 * this audit record */
> +			ts =3D test_page->timestamps[ts_index];
> +
> +			if (ts =3D=3D 0) {
> +				empty++;
> +			} else if (ts < rec->time_before_flush) {
> +				if (test_page =3D=3D prev_page) {
> +					write++;
> +				} else {
> +					late++;
> +				}
> +			} else if (ts >=3D rec->time_before_flush
> +				&& ts <=3D rec->time_after_flush) {
> +				if (test_page =3D=3D prev_page
> +					|| test_page =3D=3D rec->newbuf) {
> +					write++;
> +				} else {
> +					weird++;
> +				}
> +			} else if (ts > rec->time_after_flush) {
> +				if (test_page =3D=3D rec->newbuf) {
> +					write++;
> +				}
> +				/* It's possible the ts is way ahead
> +				 * of the current record so we can't
> +				 * call a non-match weird...
> +				 *
> +				 * Time to skip to next audit record
> +				 */
> +				break;
> +			}
> +
> +			ts =3D test_page->timestamps[ts_index++];
> +		} while (ts <=3D rec->time_after_flush && ts_index < NR_TIMESTAMPS);
> +
> +
> +		/* Next record */
> +		prev_page =3D rec->newbuf;
> +	} /* for each audit record */
> +
> +	if (flush_verbose) {
> +		printf("CPU%d: %s %p =3D> %p %u/%u/%u/%u (0/OK/L/?) =3D %u total\n",
> +			cpu, msg, test_page, base_page,
> +			empty, write, late, weird, empty+write+late+weird);
> +	}
> +
> +	return weird;
> +}
> +
> +static int audit_cpu_pages(int cpu, test_data_t *data)
> +{
> +	unsigned int pg, writes=3D0, ts_index =3D 0;
> +	write_buffer *test_page;
> +	int errors =3D 0;
> +
> +	/* first the stable page */
> +	test_page =3D data->stable_pages;
> +	do {
> +		if (test_page->timestamps[ts_index++]) {
> +			writes++;
> +		}
> +	} while (ts_index < NR_TIMESTAMPS);
> +
> +	if (writes !=3D ts_index) {
> +		errors +=3D 1;
> +	}
> +
> +	if (flush_verbose) {
> +		printf("CPU%d: stable page %p %u writes\n",
> +			cpu, test_page, writes);
> +	}
> +
> +
> +	/* Restore the mapping for dynamic page */
> +	test_page =3D data->dynamic_pages[0];
> +
> +	mmu_set_range_ptes(mmu_idmap,
> +			(unsigned long) test_page,
> +			(unsigned long) test_page,
> +			(unsigned long) &test_page[1],
> +			__pgprot(PTE_WBWA));
> +	flush_tlb_all();
> +
> +	for (pg=3D0; pg<NR_DYNAMIC_PAGES; pg++) {
> +		errors +=3D check_pages(cpu, "dynamic page", test_page,
> +				data->dynamic_pages[pg],
> +				data->audit, data->flush_count);
> +	}
> +
> +	/* reset for next run */
> +	memset(data->stable_pages, 0, sizeof(write_buffer));
> +	for (pg=3D0; pg<NR_DYNAMIC_PAGES; pg++) {
> +		memset(data->dynamic_pages[pg], 0, sizeof(write_buffer));
> +	}
> +	memset(data->audit, 0, sizeof(audit_buffer));
> +	data->flush_count =3D 0;
> +	smp_mb();
> +
> +	report("CPU%d: checked, errors: %d", errors =3D=3D 0, cpu, errors);
> +	return errors;
> +}
> +
> +static void do_page_flushes(void)
> +{
> +	int i, cpu;
> +
> +	printf("CPU0: ready @ 0x%08" PRIx64"\n", get_cntvct());
> +
> +	for (i=3D0; i<test_cycles; i++) {
> +		unsigned int flushes=3D0;
> +		u64 run_start, run_end;
> +		int cpus_finished;
> +
> +		cpumask_clear(&complete);
> +		wait_on(0, &ready);
> +		run_start =3D sync_start();
> +
> +		do {
> +			for_each_present_cpu(cpu) {
> +				if (cpu =3D=3D 0)
> +					continue;
> +
> +				/* do remap & flush */
> +				remap_one_page(&test_data[cpu]);
> +				flushes++;
> +			}
> +
> +			cpus_finished =3D cpumask_weight(&complete);
> +		} while (cpus_finished < secondary_cpus);
> +
> +		run_end =3D get_cntvct();
> +
> +		printf("CPU0: run %d 0x%" PRIx64 "->0x%" PRIx64 " (%" PRId64 " cycle=
s, %u flushes)\n",
> +			i, run_start, run_end, run_end - run_start, flushes);
> +
> +		/* Reset our ready mask for next cycle */
> +		cpumask_clear_cpu(0, &ready);
> +		smp_mb();
> +		wait_on(0, &complete);
> +
> +		/* Check for discrepancies */
> +		for_each_present_cpu(cpu) {
> +			if (cpu =3D=3D 0)
> +				continue;
> +			audit_cpu_pages(cpu, &test_data[cpu]);
> +		}
> +	}
> +
> +	test_complete =3D true;
> +	smp_mb();
> +	cpumask_set_cpu(0, &ready);
> +	cpumask_set_cpu(0, &complete);
> +}
> +
> +int main(int argc, char **argv)
> +{
> +	int cpu, i;
> +
> +	for (i=3D0; i<argc; i++) {
> +		char *arg =3D argv[i];
> +		if (strcmp(arg, "verbose") =3D=3D 0) {
> +			flush_verbose =3D true;
> +		}
> +		if (strcmp(arg, "page") =3D=3D 0) {
> +			flush_by_page =3D true;
> +		}
> +		if (strstr(arg, "cycles=3D") !=3D NULL) {
> +			char *p =3D strstr(arg, "=3D");
> +			test_cycles =3D atol(p+1);

We have parse_keyval for this. Radim has plans to improve
parse_keyval though, as nobody (including the author, me)
really like it as is...

> +		}
> +	}
> +
> +	for_each_present_cpu(cpu) {
> +		if (cpu =3D=3D 0)
> +			continue;
> +
> +		setup_pages_for_cpu(cpu);
> +		smp_boot_secondary(cpu, do_page_writes);
> +		secondary_cpus++;
> +	}
> +
> +	/* CPU 0 does the flushes and checks the results */
> +	do_page_flushes();
> +
> +	return report_summary();
> +}
> diff --git a/arm/unittests.cfg b/arm/unittests.cfg
> index beaae84..7dc7799 100644
> --- a/arm/unittests.cfg
> +++ b/arm/unittests.cfg
> @@ -96,3 +96,15 @@ file =3D tlbflush-code.flat
>  smp =3D $(($MAX_SMP>4?4:$MAX_SMP))
>  extra_params =3D -append 'page self'
>  groups =3D tlbflush
> +
> +[tlbflush-data::all]
> +file =3D tlbflush-data.flat
> +smp =3D $(($MAX_SMP>4?4:$MAX_SMP))
> +groups =3D tlbflush
> +
> +[tlbflush-data::page]
> +file =3D tlbflush-data.flat
> +smp =3D $(($MAX_SMP>4?4:$MAX_SMP))
> +extra_params =3D -append "page"
> +groups =3D tlbflush
> +
> --=20
> 2.10.1
>

Same style comments as last patch apply to this one too.

I skimmed this pretty quickly mostly looking at it wrt framework API and
style. And that looks pretty good to me.

Thanks,
drew
