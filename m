From: Andrew Jones <drjones@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v9 3/3] arm: pmu: Add CPI checking
Date: Mon, 21 Nov 2016 10:41:15 +0100
Message-ID: <20161121094115.j6kqkhubzabclfm2@kamzik.brq.redhat.com>
References: <1479528942-21866-1-git-send-email-wei@redhat.com>
 <1479528942-21866-4-git-send-email-wei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1479528942-21866-4-git-send-email-wei@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Wei Huang <wei@redhat.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, shannon.zhao@linaro.org, kvm@vger.kernel.org, marc.zyngier@arm.com, christoffer.dall@linaro.org, cov@codeaurora.org, will.deacon@arm.com, mark.rutland@arm.com, catalin.marinas@arm.com, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Nov 18, 2016 at 10:15:42PM -0600, Wei Huang wrote:
> From: Christopher Covington <cov@codeaurora.org>
> 
> Calculate the numbers of cycles per instruction (CPI) implied by ARM
> PMU cycle counter values. The code includes a strict checking facility
> intended for the -icount option in TCG mode in the configuration file.
> 
> Signed-off-by: Christopher Covington <cov@codeaurora.org>
> Signed-off-by: Wei Huang <wei@redhat.com>
> ---
>  arm/pmu.c         | 111 +++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  arm/unittests.cfg |  14 +++++++
>  2 files changed, 124 insertions(+), 1 deletion(-)
> 
> diff --git a/arm/pmu.c b/arm/pmu.c
> index fa87de4..b36c4fb 100644
> --- a/arm/pmu.c
> +++ b/arm/pmu.c
> @@ -104,6 +104,25 @@ static inline uint32_t id_dfr0_read(void)
>  	asm volatile("mrc p15, 0, %0, c0, c1, 2" : "=r" (val));
>  	return val;
>  }
> +
> +/*
> + * Extra instructions inserted by the compiler would be difficult to compensate
> + * for, so hand assemble everything between, and including, the PMCR accesses
> + * to start and stop counting.
> + */
> +static inline void loop(int i, uint32_t pmcr)

Thought you were going to rename this function.

> +{
> +	asm volatile(
> +	"	mcr	p15, 0, %[pmcr], c9, c12, 0\n"
> +	"	isb\n"
> +	"1:	subs	%[i], %[i], #1\n"
> +	"	bgt	1b\n"
> +	"	mcr	p15, 0, %[z], c9, c12, 0\n"
> +	"	isb\n"
> +	: [i] "+r" (i)
> +	: [pmcr] "r" (pmcr), [z] "r" (0)
> +	: "cc");
> +}
>  #elif defined(__aarch64__)
>  static inline uint32_t pmcr_read(void)
>  {
> @@ -150,6 +169,25 @@ static inline uint32_t id_dfr0_read(void)
>  	asm volatile("mrs %0, id_dfr0_el1" : "=r" (id));
>  	return id;
>  }
> +
> +/*
> + * Extra instructions inserted by the compiler would be difficult to compensate
> + * for, so hand assemble everything between, and including, the PMCR accesses
> + * to start and stop counting.
> + */
> +static inline void loop(int i, uint32_t pmcr)
> +{
> +	asm volatile(
> +	"	msr	pmcr_el0, %[pmcr]\n"
> +	"	isb\n"
> +	"1:	subs	%[i], %[i], #1\n"
> +	"	b.gt	1b\n"
> +	"	msr	pmcr_el0, xzr\n"
> +	"	isb\n"
> +	: [i] "+r" (i)
> +	: [pmcr] "r" (pmcr)
> +	: "cc");
> +}
>  #endif
>  
>  /*
> @@ -204,6 +242,71 @@ static bool check_cycles_increase(void)
>  	return success;
>  }
>  
> +/*
> + * Execute a known number of guest instructions. Only odd instruction counts
> + * greater than or equal to 3 are supported by the in-line assembly code. The
> + * control register (PMCR_EL0) is initialized with the provided value (allowing
> + * for example for the cycle counter or event counters to be reset). At the end
> + * of the exact instruction loop, zero is written to PMCR_EL0 to disable
> + * counting, allowing the cycle counter or event counters to be read at the
> + * leisure of the calling code.
> + */
> +static void measure_instrs(int num, uint32_t pmcr)
> +{
> +	int i = (num - 1) / 2;
> +
> +	assert(num >= 3 && ((num - 1) % 2 == 0));
> +	loop(i, pmcr);
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
> +	uint32_t pmcr = pmcr_read() | PMU_PMCR_LC | PMU_PMCR_C | PMU_PMCR_E;
> +	
> +	if (cpi > 0)
> +		printf("Checking for CPI=%d.\n", cpi);
> +	printf("instrs : cycles0 cycles1 ...\n");
> +
> +	for (unsigned int i = 3; i < 300; i += 32) {
> +		uint64_t avg, sum = 0;
> +
> +		printf("%d :", i);
> +		for (int j = 0; j < NR_SAMPLES; j++) {
> +			uint64_t cycles;
> +
> +			pmccntr_write(0);
> +			measure_instrs(i, pmcr);
> +			cycles = pmccntr_read();
> +			printf(" %"PRId64"", cycles);
> +
> +			/*
> +			 * The cycles taken by the loop above should fit in
> +			 * 32 bits easily. We check the upper 32 bits of the
> +			 * cycle counter to make sure there is no supprise.
> +			 */
> +			if (!cycles || (cpi > 0 && cycles != i * cpi) ||
> +			    (cycles & 0xffffffff00000000)) {

 (cycles >> 32) != 0 would look better.

> +				printf("\n");

We have 3 cases where we return false here. How about doing the tests
separately and adding descriptive print statements for each?

 if (!cycles) {
     printf("\ncycles not incrementing!\n");
     return false;
 } else if (cpi > 0 && cycles != i * cpi) {
     ...
 } else if ((cycles >> 32) != 0) {
     ...
 }

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
> @@ -218,13 +321,19 @@ void pmu_init(void)
>  	pmccfiltr_write(0); /* count cycles in EL0, EL1, but not EL2 */
>  }
>  
> -int main(void)
> +int main(int argc, char *argv[])
>  {
> +	int cpi = 0;
> +
> +	if (argc >= 1)
                  ^ this '=' shouldn't be here
> +		cpi = atol(argv[0]);
                                ^ sigh, this is still zero...

Looks like you forgot all my comments from the last review round...

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
> index 7645180..2050dc8 100644
> --- a/arm/unittests.cfg
> +++ b/arm/unittests.cfg
> @@ -59,3 +59,17 @@ groups = selftest
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

drew
