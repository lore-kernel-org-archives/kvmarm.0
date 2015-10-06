From: Andrew Jones <drjones@redhat.com>
Subject: Re: [kvm-unit-tests PATCHv3 3/3] arm: pmu: Add CPI checking
Date: Tue, 6 Oct 2015 22:14:20 +0200
Message-ID: <20151006201420.GH9323@hawk.localdomain>
References: <5612EDA5.9010506@redhat.com>
 <1444153766-12532-1-git-send-email-cov@codeaurora.org>
 <1444153766-12532-4-git-send-email-cov@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1444153766-12532-4-git-send-email-cov@codeaurora.org>
Sender: kvm-owner@vger.kernel.org
To: Christopher Covington <cov@codeaurora.org>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, wei@redhat.com, shannon.zhao@linaro.org, alistair.francis@xilinx.com, croberts@codeaurora.org, alindsay@codeaurora.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Oct 06, 2015 at 01:49:26PM -0400, Christopher Covington wrote:
> Check the numbers of cycles per instruction (CPI) implied by ARM PMU
> cycle counter values. Check that in -icount mode these strictly
> match the specified rate.
> 
> Signed-off-by: Christopher Covington <cov@codeaurora.org>
> ---
>  arm/pmu.c         | 72 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  arm/unittests.cfg | 13 ++++++++++
>  2 files changed, 84 insertions(+), 1 deletion(-)
> 
> diff --git a/arm/pmu.c b/arm/pmu.c
> index 589e605..0ad113d 100644
> --- a/arm/pmu.c
> +++ b/arm/pmu.c
> @@ -84,12 +84,82 @@ static bool check_cycles_increase(void)
>  	return true;
>  }
>  
> -int main(void)
> +/* Execute a known number of guest instructions. Only odd instruction counts
> + * greater than or equal to 3 are supported by the in-line assembly code. The
> + * control register (PMCR_EL0) is initialized with the provided value (allowing
> + * for example for the cycle counter or event counters to be reset). At the end
> + * of the exact instruction loop, zero is written to PMCR_EL0 to disable
> + * counting, allowing the cycle counter or event counters to be read at the
> + * leisure of the calling code.
> + */
> +static void measure_instrs(int num, struct pmu_data pmcr)
> +{
> +	int i = (num - 1) / 2;
> +
> +	if (num < 3 || ((num - 1) % 2))
> +		abort();

assert(num >= 3 && ((num - 1) % 2) == 0);

> +
> +	asm volatile(
> +		"msr pmcr_el0, %[pmcr]\n"
                    ^\t
> +		"1: subs %[i], %[i], #1\n"
                   ^\t  ^\t
> +		"b.gt 1b\n"
                     ^\t
> +		"msr pmcr_el0, xzr"
                    ^\t
> +	: [i] "+r" (i) : [pmcr] "r" (pmcr) : "cc");
> +}
> +
> +/* Measure cycle counts for various known instruction counts. Ensure that the
> + * cycle counter progresses (similar to check_cycles_increase() but with more
> + * instructions and using reset and stop controls). If supplied a positive,
> + * nonzero CPI parameter, also strictly check that every measurement matches
> + * it. Strict CPI checking is used to test -icount mode.
> + */
> +static bool check_cpi(int cpi)
> +{
> +	struct pmu_data pmcr;
> +
> +	pmcr.cycle_counter_reset = 1;
> +	pmcr.enable = 1;
> +
> +	if (cpi > 0)
> +		printf("Checking for CPI=%d.\n", cpi);
> +	printf("instrs : cycles0 cycles1 ...\n");
> +
> +	for (int i = 3; i < 300; i += 32) {
> +		int avg, sum = 0;
> +
> +		printf("%d :", i);
> +		for (int j = 0; j < samples; j++) {
> +			int cycles;
> +
> +			measure_instrs(i, pmcr);
> +			asm volatile("mrs %0, pmccntr_el0" : "=r" (cycles));
> +			printf(" %d", cycles);
> +
> +			if (!cycles || (cpi > 0 && cycles != i * cpi)) {
> +				printf("\n");
> +				return false;
> +			}
> +
> +			sum += cycles;
> +		}
> +		avg = sum / samples;
> +		printf(" sum=%d avg=%d avg_ipc=%d avg_cpi=%d\n",
> +			sum, avg, i / avg, avg / i);
> +	}
> +
> +	return true;
> +}
> +
> +int main(int argc, char *argv[])
>  {
>  	report_prefix_push("pmu");
>  
>  	report("Control register", check_pmcr());
>  	report("Monotonically increasing cycle count", check_cycles_increase());
>  
> +	int cpi = (argc == 1 ? atol(argv[0]) : 0);

I prefer variable declarations at the top of the function, and

  int cpi = 0;

  if (argc > 1)
    cpi = atol(argv[0]);

looks a bit better to me.


> +
> +	report("Cycle/instruction ratio", check_cpi(cpi));
> +
>  	return report_summary();
>  }
> diff --git a/arm/unittests.cfg b/arm/unittests.cfg
> index fd94adb..333ee0d 100644
> --- a/arm/unittests.cfg
> +++ b/arm/unittests.cfg
> @@ -39,4 +39,17 @@ groups = selftest
>  # Test PMU support without -icount
>  [pmu]
>  file = pmu.flat
> +extra_params = -append '-1'

Why do we need this cpu == -1? Can't it just be zero?

> +groups = pmu
> +
> +# Test PMU support with -icount IPC=1
> +[pmu-icount-1]
> +file = pmu.flat
> +extra_params = -icount 0 -append '1'
> +groups = pmu
> +
> +# Test PMU support with -icount IPC=256
> +[pmu-icount-256]
> +file = pmu.flat
> +extra_params = -icount 8 -append '256'
>  groups = pmu

-icount is a tcg specific parameter. I have a patch[*] in my staging
branch which allows you to specify 'accel = tcg' in unittests.cfg for
this type of test. You'll need to use that for anything with -icount
on the extra_params list.

Thanks,
drew

[*] https://github.com/rhdrjones/kvm-unit-tests/commit/85e084cf263e76484f7d82cbc9add4e7602f80a4
