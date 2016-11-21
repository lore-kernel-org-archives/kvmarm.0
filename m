From: Christopher Covington <cov@codeaurora.org>
Subject: Re: [kvm-unit-tests PATCH v10 3/3] arm: pmu: Add CPI checking
Date: Mon, 21 Nov 2016 16:40:54 -0500
Message-ID: <13b86440-3b37-ff24-3080-f0deece175fa@codeaurora.org>
References: <1479759895-10042-1-git-send-email-wei@redhat.com>
 <1479759895-10042-4-git-send-email-wei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1479759895-10042-4-git-send-email-wei@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Wei Huang <wei@redhat.com>, kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org, shannon.zhao@linaro.org, kvm@vger.kernel.org, marc.zyngier@arm.com, christoffer.dall@linaro.org, drjones@redhat.com, will.deacon@arm.com, mark.rutland@arm.com, catalin.marinas@arm.com, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Wei,

On 11/21/2016 03:24 PM, Wei Huang wrote:
> From: Christopher Covington <cov@codeaurora.org>

I really appreciate your work on these patches. If for any or all of these
you have more lines added/modified than me (or using any other better
metric), please make sure to change the author to be you with
`git commit --amend --reset-author` or equivalent.

> Calculate the numbers of cycles per instruction (CPI) implied by ARM
> PMU cycle counter values. The code includes a strict checking facility
> intended for the -icount option in TCG mode in the configuration file.
> 
> Signed-off-by: Christopher Covington <cov@codeaurora.org>
> Signed-off-by: Wei Huang <wei@redhat.com>
> ---
>  arm/pmu.c         | 119 +++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  arm/unittests.cfg |  14 +++++++
>  2 files changed, 132 insertions(+), 1 deletion(-)
> 
> diff --git a/arm/pmu.c b/arm/pmu.c
> index 176b070..129ef1e 100644
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
> + * to start and stop counting. Total cycles = isb + mcr + 2*loop = 2 + 2*loop.
> + */
> +static inline void precise_cycles_loop(int loop, uint32_t pmcr)

Nit: I would call this precise_instrs_loop. How many cycles it takes is
IMPLEMENTATION DEFINED.

> +{
> +	asm volatile(
> +	"	mcr	p15, 0, %[pmcr], c9, c12, 0\n"
> +	"	isb\n"
> +	"1:	subs	%[loop], %[loop], #1\n"
> +	"	bgt	1b\n"

Is there any chance we might need an isb here, to prevent the stop from happening
before or during the loop? Where ISBs are required, the Linux best practice is to
diligently comment why they are needed. Perhaps it would be a good habit to
carry over into kvm-unit-tests.

> +	"	mcr	p15, 0, %[z], c9, c12, 0\n"
> +	"	isb\n"
> +	: [loop] "+r" (loop)
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
> + * to start and stop counting. Total cycles = isb + msr + 2*loop = 2 + 2*loop.
> + */
> +static inline void precise_cycles_loop(int loop, uint32_t pmcr)
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
> @@ -208,6 +246,79 @@ static bool check_cycles_increase(void)
>  	return success;
>  }
>  
> +/*
> + * Execute a known number of guest instructions. Only odd instruction counts
> + * greater than or equal to 3 are supported by the in-line assembly code. The

Nit: needs updating as well (or removal if you prefer)

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
> +	precise_cycles_loop(loop, pmcr);
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
> +	/* init before event access, this test only cares about cycle count */
> +	pmcntenset_write(1 << PMU_CYCLE_IDX);
> +	pmccfiltr_write(0); /* count cycles in EL0, EL1, but not EL2 */
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
> +			pmccntr_write(0);
> +			measure_instrs(i, pmcr);
> +			cycles = pmccntr_read();
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
> @@ -218,13 +329,19 @@ void pmu_init(void)
>  	printf("PMU version: %d\n", pmu_version);
>  }

This is clearly the right feature register to check. Sorry to have
gotten excited about an inferior method.

Cov

-- 
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm
Technologies, Inc. Qualcomm Technologies, Inc. is a member of the Code
Aurora Forum, a Linux Foundation Collaborative Project.
