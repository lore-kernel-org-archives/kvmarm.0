From: Andrew Jones <drjones@redhat.com>
Subject: Re: [Qemu-devel] [kvm-unit-tests PATCHv4 3/3] arm: pmu: Add CPI
 checking
Date: Sun, 18 Oct 2015 20:28:21 +0200
Message-ID: <20151018182821.GC12158@hawk.localdomain>
References: <5612EDA5.9010506@redhat.com>
 <1444662470-13045-1-git-send-email-cov@codeaurora.org>
 <1444662470-13045-4-git-send-email-cov@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2951D40FF5
 for <kvmarm@lists.cs.columbia.edu>; Sun, 18 Oct 2015 14:26:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NtfOhpvSzwN4 for <kvmarm@lists.cs.columbia.edu>;
 Sun, 18 Oct 2015 14:26:01 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4E82C40FA6
 for <kvmarm@lists.cs.columbia.edu>; Sun, 18 Oct 2015 14:26:00 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <1444662470-13045-4-git-send-email-cov@codeaurora.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christopher Covington <cov@codeaurora.org>
Cc: alindsay@codeaurora.org, kvm@vger.kernel.org, croberts@codeaurora.org, qemu-devel@nongnu.org, alistair.francis@xilinx.com, shannon.zhao@linaro.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Oct 12, 2015 at 11:07:50AM -0400, Christopher Covington wrote:
> Calculate the numbers of cycles per instruction (CPI) implied by ARM
> PMU cycle counter values. The code includes a strict checking facility
> intended for the -icount option in TCG mode but it is not yet enabled
> in the configuration file. Enabling it must wait on infrastructure
> improvements which allow for different tests to be run on TCG versus
> KVM.
> 
> Signed-off-by: Christopher Covington <cov@codeaurora.org>
> ---
>  arm/pmu.c | 91 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 90 insertions(+), 1 deletion(-)
> 
> diff --git a/arm/pmu.c b/arm/pmu.c
> index ae81970..169c36c 100644
> --- a/arm/pmu.c
> +++ b/arm/pmu.c
> @@ -37,6 +37,18 @@ static inline unsigned long get_pmccntr(void)
>  	asm volatile("mrc p15, 0, %0, c9, c13, 0" : "=r" (cycles));
>  	return cycles;
>  }
> +
> +static inline void loop(int i, uint32_t pmcr)
> +{
> +	uint32_t z = 0;
> +
> +	asm volatile(
> +		"	mcr p15, 0, %[pmcr], c9, c12, 0\n"
> +		"	1: subs %[i], %[i], #1\n"
> +		"	bgt 1b\n"
> +		"	mcr p15, 0, %[z], c9, c12, 0\n"
> +	: [i] "+r" (i) : [pmcr] "r" (pmcr), [z] "r" (z) : "cc");

Assembly is always ugly, but we can do a bit better formatting with tabs

	asm volatile(
	"	mcr	p15, 0, %[pmcr], c9, c12, 0\n"
	"1:	subs	%[i], %[i], #1\n"
	"	bgt	1b\n"
	"	mcr	p15, 0, %[z], c9, c12, 0\n"
	: [i] "+r" (i)
	: [pmcr] "r" (pmcr), [z] "r" (z)
	: "cc");

Actually it can be even cleaner because you already created set_pmcr()

	set_pmcr(pmcr);

	asm volatile(
	"1:	subs	%0, %0, #1\n"
	"	bgt     1b\n"
	: "+r" (i) : : "cc");

	set_pmcr(0);


> +}
>  #elif defined(__aarch64__)
>  static inline uint32_t get_pmcr(void)
>  {
> @@ -58,6 +70,16 @@ static inline unsigned long get_pmccntr(void)
>  	asm volatile("mrs %0, pmccntr_el0" : "=r" (cycles));
>  	return cycles;
>  }
> +
> +static inline void loop(int i, uint32_t pmcr)
> +{
> +	asm volatile(
> +		"	msr pmcr_el0, %[pmcr]\n"
> +		"	1: subs %[i], %[i], #1\n"
> +		"	b.gt 1b\n"
> +		"	msr pmcr_el0, xzr\n"
> +	: [i] "+r" (i) : [pmcr] "r" (pmcr) : "cc");

same comment as above

> +}
>  #endif
>  
>  struct pmu_data {
> @@ -125,12 +147,79 @@ static bool check_cycles_increase(void)
>  	return true;
>  }
>  
> -int main(void)
> +/*
> + * Execute a known number of guest instructions. Only odd instruction counts
> + * greater than or equal to 3 are supported by the in-line assembly code. The

Not all odd counts, right? But rather all multiples of 3? IIUC this is because
the loop is two instructions (sub + branch), and then the clearing of the pmcr
register counts as the 3rd?

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
> +	struct pmu_data pmu;

memset(&pmu, 0, sizeof(pmu));

> +
> +	pmu.cycle_counter_reset = 1;
> +	pmu.enable = 1;
> +
> +	if (cpi > 0)
> +		printf("Checking for CPI=%d.\n", cpi);
> +	printf("instrs : cycles0 cycles1 ...\n");
> +
> +	for (int i = 3; i < 300; i += 32) {
> +		int avg, sum = 0;
> +
> +		printf("%d :", i);
> +		for (int j = 0; j < NR_SAMPLES; j++) {
> +			int cycles;
> +
> +			measure_instrs(i, pmu.pmcr_el0);
> +			cycles = get_pmccntr();
> +			printf(" %d", cycles);
> +
> +			if (!cycles || (cpi > 0 && cycles != i * cpi)) {
> +				printf("\n");
> +				return false;
> +			}
> +
> +			sum += cycles;
> +		}
> +		avg = sum / NR_SAMPLES;
> +		printf(" sum=%d avg=%d avg_ipc=%d avg_cpi=%d\n",
> +			sum, avg, i / avg, avg / i);
> +	}
> +
> +	return true;
> +}
> +
> +int main(int argc, char *argv[])
>  {
> +	int cpi = 0;
> +
> +	if (argc > 1)
> +		cpi = atol(argv[0]);
> +
>  	report_prefix_push("pmu");
>  
>  	report("Control register", check_pmcr());
>  	report("Monotonically increasing cycle count", check_cycles_increase());
> +	report("Cycle/instruction ratio", check_cpi(cpi));
>  
>  	return report_summary();
>  }
> -- 
> Qualcomm Innovation Center, Inc.
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> a Linux Foundation Collaborative Project
> 
> 
