From: Andrew Jones <drjones@redhat.com>
Subject: Re: [Qemu-devel] [kvm-unit-tests PATCHv5 3/3] arm: pmu: Add CPI
 checking
Date: Fri, 30 Oct 2015 08:00:22 -0500
Message-ID: <20151030130022.GA8197@hawk.localdomain>
References: <1444662470-13045-1-git-send-email-cov@codeaurora.org>
 <1446059575-23903-1-git-send-email-cov@codeaurora.org>
 <1446059575-23903-4-git-send-email-cov@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1446059575-23903-4-git-send-email-cov@codeaurora.org>
Sender: kvm-owner@vger.kernel.org
To: Christopher Covington <cov@codeaurora.org>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, wei@redhat.com, alindsay@codeaurora.org, croberts@codeaurora.org, shannon.zhao@linaro.org, alistair.francis@xilinx.com
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Oct 28, 2015 at 03:12:55PM -0400, Christopher Covington wrote:
> Calculate the numbers of cycles per instruction (CPI) implied by ARM
> PMU cycle counter values. The code includes a strict checking facility
> intended for the -icount option in TCG mode but it is not yet enabled
> in the configuration file. Enabling it must wait on infrastructure
> improvements which allow for different tests to be run on TCG versus
> KVM.
> 
> Signed-off-by: Christopher Covington <cov@codeaurora.org>
> ---
>  arm/pmu.c | 103 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 102 insertions(+), 1 deletion(-)
> 
> diff --git a/arm/pmu.c b/arm/pmu.c
> index 4334de4..788886a 100644
> --- a/arm/pmu.c
> +++ b/arm/pmu.c
> @@ -43,6 +43,23 @@ static inline unsigned long get_pmccntr(void)
>  	asm volatile("mrc p15, 0, %0, c9, c13, 0" : "=r" (cycles));
>  	return cycles;
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
> +	"	mcr	p15, 0, %[pmcr], c9, c12, 0\n"
> +	"1:	subs	%[i], %[i], #1\n"
> +	"	bgt	1b\n"
> +	"	mcr	p15, 0, %[z], c9, c12, 0\n"
> +	: [i] "+r" (i)
> +	: [pmcr] "r" (pmcr), [z] "r" (0)
> +	: "cc");
> +}
>  #elif defined(__aarch64__)
>  static inline uint32_t get_pmcr(void)
>  {
> @@ -64,6 +81,23 @@ static inline unsigned long get_pmccntr(void)
>  	asm volatile("mrs %0, pmccntr_el0" : "=r" (cycles));
>  	return cycles;
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
> +	"1:	subs	%[i], %[i], #1\n"
> +	"	b.gt	1b\n"
> +	"	msr	pmcr_el0, xzr\n"
> +	: [i] "+r" (i)
> +	: [pmcr] "r" (pmcr)
> +	: "cc");
> +}
>  #endif
>  
>  struct pmu_data {
> @@ -131,12 +165,79 @@ static bool check_cycles_increase(void)
>  	return true;
>  }
>  
> -int main(void)
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
> +	struct pmu_data pmu = {0};
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
> +	if (argc >= 1)
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

I applied and tested this (by adding -icount 1 -append 1 to the cmdline),
but get

qemu-system-aarch64 -machine virt,accel=tcg -cpu cortex-a57 \
	-device virtio-serial-device -device virtconsole,chardev=ctd \
	-chardev testdev,id=ctd -display none -serial stdio \
	-kernel arm/pmu.flat -smp 1 -icount 1 -append 1
PMU implementer:     A
Identification code: 0x0
Event counters:      0
PASS: pmu: Control register
PASS: pmu: Monotonically increasing cycle count
Checking for CPI=1.
instrs : cycles0 cycles1 ...
3 : 6
FAIL: pmu: Cycle/instruction ratio

SUMMARY: 3 tests, 1 unexpected failures 

I'm using a latest pull of qemu master. Taking '-append 1' off the cmdline,
we can see that for all trials we're getting twice the expected cpi.

3 : 6 6 6 6 6 6 6 6 6 6 sum=60 avg=6 avg_ipc=0 avg_cpi=2
35 : 70 70 70 70 70 70 70 70 70 70 sum=700 avg=70 avg_ipc=0 avg_cpi=2
67 : 134 134 134 134 134 134 134 134 134 134 sum=1340 avg=134 avg_ipc=0 avg_cpi=2
99 : 198 198 198 198 198 198 198 198 198 198 sum=1980 avg=198 avg_ipc=0 avg_cpi=2
131 : 262 262 262 262 262 262 262 262 262 262 sum=2620 avg=262 avg_ipc=0 avg_cpi=2
163 : 326 326 326 326 326 326 326 326 326 326 sum=3260 avg=326 avg_ipc=0 avg_cpi=2
195 : 390 390 390 390 390 390 390 390 390 390 sum=3900 avg=390 avg_ipc=0 avg_cpi=2
227 : 454 454 454 454 454 454 454 454 454 454 sum=4540 avg=454 avg_ipc=0 avg_cpi=2
259 : 518 518 518 518 518 518 518 518 518 518 sum=5180 avg=518 avg_ipc=0 avg_cpi=2
291 : 582 582 582 582 582 582 582 582 582 582 sum=5820 avg=582 avg_ipc=0 avg_cpi=2

drew
