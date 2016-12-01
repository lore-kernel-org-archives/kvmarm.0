From: Andrew Jones <drjones@redhat.com>
Subject: Re: [Qemu-devel] [kvm-unit-tests PATCH v13 4/4] arm: pmu: Add CPI
 checking
Date: Thu, 1 Dec 2016 10:26:20 +0100
Message-ID: <20161201092620.hvyndkroiauscxaa@kamzik.brq.redhat.com>
References: <1480569402-8848-1-git-send-email-wei@redhat.com>
 <1480569402-8848-5-git-send-email-wei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1480569402-8848-5-git-send-email-wei@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Wei Huang <wei@redhat.com>
Cc: cov@codeaurora.org, alindsay@codeaurora.org, kvm@vger.kernel.org, andre.przywara@arm.com, croberts@codeaurora.org, qemu-devel@nongnu.org, alistair.francis@xilinx.com, shannon.zhao@linaro.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Nov 30, 2016 at 11:16:42PM -0600, Wei Huang wrote:
> From: Christopher Covington <cov@codeaurora.org>
> 
> Calculate the numbers of cycles per instruction (CPI) implied by ARM
> PMU cycle counter values. The code includes a strict checking facility
> intended for the -icount option in TCG mode in the configuration file.
> 
> Signed-off-by: Christopher Covington <cov@codeaurora.org>
> Signed-off-by: Wei Huang <wei@redhat.com>
> Reviewed-by: Andrew Jones <drjones@redhat.com>
> ---
>  arm/pmu.c         | 123 +++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  arm/unittests.cfg |  14 +++++++
>  2 files changed, 136 insertions(+), 1 deletion(-)
> 
> diff --git a/arm/pmu.c b/arm/pmu.c
> index 3566a27..29d7c2c 100644
> --- a/arm/pmu.c
> +++ b/arm/pmu.c
> @@ -69,6 +69,27 @@ static inline void set_pmccfiltr(uint32_t value)
>  	set_pmxevtyper(value);
>  	isb();
>  }
> +
> +/*
> + * Extra instructions inserted by the compiler would be difficult to compensate
> + * for, so hand assemble everything between, and including, the PMCR accesses
> + * to start and stop counting. isb instructions were inserted to make sure
> + * pmccntr read after this function returns the exact instructions executed in
> + * the controlled block. Total instrs = isb + mcr + 2*loop = 2 + 2*loop.
> + */
> +static inline void precise_instrs_loop(int loop, uint32_t pmcr)
> +{
> +	asm volatile(
> +	"	mcr	p15, 0, %[pmcr], c9, c12, 0\n"
> +	"	isb\n"
> +	"1:	subs	%[loop], %[loop], #1\n"
> +	"	bgt	1b\n"
> +	"	mcr	p15, 0, %[z], c9, c12, 0\n"
> +	"	isb\n"
> +	: [loop] "+r" (loop)
> +	: [pmcr] "r" (pmcr), [z] "r" (0)
> +	: "cc");
> +}
>  #elif defined(__aarch64__)
>  DEFINE_GET_SYSREG32(pmcr, el0)
>  DEFINE_SET_SYSREG32(pmcr, el0)
> @@ -77,6 +98,27 @@ DEFINE_GET_SYSREG64(pmccntr, el0);
>  DEFINE_SET_SYSREG64(pmccntr, el0);
>  DEFINE_SET_SYSREG32(pmcntenset, el0);
>  DEFINE_SET_SYSREG32(pmccfiltr, el0);
> +
> +/*
> + * Extra instructions inserted by the compiler would be difficult to compensate
> + * for, so hand assemble everything between, and including, the PMCR accesses
> + * to start and stop counting. isb instructions are inserted to make sure
> + * pmccntr read after this function returns the exact instructions executed
> + * in the controlled block. Total instrs = isb + msr + 2*loop = 2 + 2*loop.
> + */
> +static inline void precise_instrs_loop(int loop, uint32_t pmcr)
> +{
> +	asm volatile(
> +	"	msr	pmcr_el0, %[pmcr]\n"
> +	"	isb\n"
> +	"1:	subs	%[loop], %[loop], #1\n"
> +	"	b.gt	1b\n"
> +	"	msr	pmcr_el0, xzr\n"
> +	"	isb\n"
> +	: [loop] "+r" (loop)
> +	: [pmcr] "r" (pmcr)
> +	: "cc");
> +}
>  #endif
>  
>  /*
> @@ -134,6 +176,79 @@ static bool check_cycles_increase(void)
>  	return success;
>  }
>  
> +/*
> + * Execute a known number of guest instructions. Only even instruction counts
> + * greater than or equal to 4 are supported by the in-line assembly code. The
> + * control register (PMCR_EL0) is initialized with the provided value (allowing
> + * for example for the cycle counter or event counters to be reset). At the end
> + * of the exact instruction loop, zero is written to PMCR_EL0 to disable
> + * counting, allowing the cycle counter or event counters to be read at the
> + * leisure of the calling code.
> + */
> +static void measure_instrs(int num, uint32_t pmcr)
> +{
> +	int loop = (num - 2) / 2;
> +
> +	assert(num >= 4 && ((num - 2) % 2 == 0));
> +	precise_instrs_loop(loop, pmcr);
> +}
> +
> +/*
> + * Measure cycle counts for various known instruction counts. Ensure that the
> + * cycle counter progresses (similar to check_cycles_increase() but with more
> + * instructions and using reset and stop controls). If supplied a positive,
> + * nonzero CPI parameter, also strictly check that every measurement matches
> + * it. Strict CPI checking is used to test -icount mode.
> + */
> +static bool check_cpi(int cpi)
> +{
> +	uint32_t pmcr = get_pmcr() | PMU_PMCR_LC | PMU_PMCR_C | PMU_PMCR_E;
> +
> +	/* init before event access, this test only cares about cycle count */
> +	set_pmcntenset(1 << PMU_CYCLE_IDX);
> +	set_pmccfiltr(0); /* count cycles in EL0, EL1, but not EL2 */
> +
> +	if (cpi > 0)
> +		printf("Checking for CPI=%d.\n", cpi);
> +	printf("instrs : cycles0 cycles1 ...\n");
> +
> +	for (unsigned int i = 4; i < 300; i += 32) {
> +		uint64_t avg, sum = 0;
> +
> +		printf("%d :", i);
> +		for (int j = 0; j < NR_SAMPLES; j++) {
> +			uint64_t cycles;
> +
> +			set_pmccntr(0);
> +			measure_instrs(i, pmcr);
> +			cycles = get_pmccntr();
> +			printf(" %"PRId64"", cycles);
> +
> +			if (!cycles) {
> +				printf("\ncycles not incrementing!\n");
> +				return false;
> +			} else if (cpi > 0 && cycles != i * cpi) {
> +				printf("\nunexpected cycle count received!\n");
> +				return false;
> +			} else if ((cycles >> 32) != 0) {
> +				/* The cycles taken by the loop above should
> +				 * fit in 32 bits easily. We check the upper
> +				 * 32 bits of the cycle counter to make sure
> +				 * there is no supprise. */
> +				printf("\ncycle count bigger than 32bit!\n");
> +				return false;
> +			}
> +
> +			sum += cycles;
> +		}
> +		avg = sum / NR_SAMPLES;
> +		printf(" sum=%"PRId64" avg=%"PRId64" avg_ipc=%"PRId64" "
> +		       "avg_cpi=%"PRId64"\n", sum, avg, i / avg, avg / i);
> +	}
> +
> +	return true;
> +}
> +
>  void pmu_init(void)
>  {
>  	uint32_t dfr0;
> @@ -144,13 +259,19 @@ void pmu_init(void)
>  	report_info("PMU version: %d", pmu_version);
>  }
>  
> -int main(void)
> +int main(int argc, char *argv[])
>  {
> +	int cpi = 0;
> +
> +	if (argc > 1)
> +		cpi = atol(argv[1]);
> +
>  	report_prefix_push("pmu");
>  
>  	pmu_init();
>  	report("Control register", check_pmcr());
>  	report("Monotonically increasing cycle count", check_cycles_increase());
> +	report("Cycle/instruction ratio", check_cpi(cpi));
>  
>  	return report_summary();
>  }
> diff --git a/arm/unittests.cfg b/arm/unittests.cfg
> index 816f494..044d97c 100644
> --- a/arm/unittests.cfg
> +++ b/arm/unittests.cfg
> @@ -63,3 +63,17 @@ groups = pci
>  [pmu]
>  file = pmu.flat
>  groups = pmu
> +
> +# Test PMU support (TCG) with -icount IPC=1
> +[pmu-tcg-icount-1]
> +file = pmu.flat
> +extra_params = -icount 0 -append '1'
> +groups = pmu
> +accel = tcg
> +
> +# Test PMU support (TCG) with -icount IPC=256
> +[pmu-tcg-icount-256]
> +file = pmu.flat
> +extra_params = -icount 8 -append '256'
> +groups = pmu
> +accel = tcg
> -- 
> 1.8.3.1
> 
>

As we work out how best to handle tcg-only tests in order to get Alex
Bennee's MTTCG tests merged, we'll probably revisit this file, factoring
out common PMU code and pulling the tcg-only code out to its own unit
test file (maybe arm/tcg/pmu.c). But that's future work.

Thanks,
drew
