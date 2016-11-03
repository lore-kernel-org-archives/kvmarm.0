From: Andrew Jones <drjones@redhat.com>
Subject: Re: [Qemu-devel] [kvm-unit-tests PATCHv7 2/3] arm: pmu: Check cycle
 count increases
Date: Thu, 3 Nov 2016 11:35:07 +0100
Message-ID: <20161103103507.qg65rruprmm6drzk@kamzik.brq.redhat.com>
References: <1478125337-11770-1-git-send-email-wei@redhat.com>
 <1478125337-11770-3-git-send-email-wei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1478125337-11770-3-git-send-email-wei@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Wei Huang <wei@redhat.com>
Cc: cov@codeaurora.org, alindsay@codeaurora.org, kvm@vger.kernel.org, croberts@codeaurora.org, qemu-devel@nongnu.org, alistair.francis@xilinx.com, shannon.zhao@linaro.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Nov 02, 2016 at 05:22:16PM -0500, Wei Huang wrote:

Missing From: Christopher

> Ensure that reads of the PMCCNTR_EL0 are monotonically increasing,
> even for the smallest delta of two subsequent reads.
> 
> Signed-off-by: Christopher Covington <cov@codeaurora.org>
> Signed-off-by: Wei Huang <wei@redhat.com>
> ---
>  arm/pmu.c | 100 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 100 insertions(+)
> 
> diff --git a/arm/pmu.c b/arm/pmu.c
> index 42d0ee1..65b7df1 100644
> --- a/arm/pmu.c
> +++ b/arm/pmu.c
> @@ -14,6 +14,9 @@
>   */
>  #include "libcflat.h"
>  
> +#define NR_SAMPLES 10
> +#define ARMV8_PMU_CYCLE_IDX 31

Now I'd really like to drop the bitfields and go to bit defines if we're
going to start mixing them anyway...

> +
>  #if defined(__arm__)
>  static inline uint32_t get_pmcr(void)
>  {
> @@ -22,6 +25,43 @@ static inline uint32_t get_pmcr(void)
>  	asm volatile("mrc p15, 0, %0, c9, c12, 0" : "=r" (ret));
>  	return ret;
>  }
> +
> +static inline void set_pmcr(uint32_t pmcr)
> +{
> +	asm volatile("mcr p15, 0, %0, c9, c12, 0" : : "r" (pmcr));
> +}
> +
> +static inline void set_pmccfiltr(uint32_t filter)
> +{
> +	uint32_t cycle_idx = ARMV8_PMU_CYCLE_IDX;
> +
> +	asm volatile("mcr p15, 0, %0, c9, c12, 5" : : "r" (cycle_idx));
> +	asm volatile("mcr p15, 0, %0, c9, c13, 1" : : "r" (filter));
> +}

I agree with Chistopher that we should create per-register accessors.
Enabling the test code the flexibility to do what it wants but without
requiring a bunch of armv7/armv8 sysreg clutter.

> +
> +/*
> + * While PMCCNTR can be accessed as a 64 bit coprocessor register, returning 64
> + * bits doesn't seem worth the trouble when differential usage of the result is
> + * expected (with differences that can easily fit in 32 bits). So just return

Except for the fact this is a test and we should confirm those upper bits
are whatever we expect, even if we expect zero.

> + * the lower 32 bits of the cycle count in AArch32.
> + */
> +static inline unsigned long get_pmccntr(void)
> +{
> +	unsigned long cycles;
> +
> +	asm volatile("mrc p15, 0, %0, c9, c13, 0" : "=r" (cycles));
> +	return cycles;
> +}
> +
> +static inline void enable_counter(uint32_t idx)
> +{
> +	asm volatile("mcr p15, 0, %0, c9, c12, 1" : : "r" (1 << idx));
> +}
> +
> +static inline void disable_counter(uint32_t idx)
> +{
> +	asm volatile("mrc p15, 0, %0, c9, c12, 1" : : "r" (1 << idx));
> +}

I'll echo Chistopher here as well with the opinion that the test
should supply the shifted value and the accessor should just be a
simply read or write.

Please name the accessors <regname>_read/write

>  #elif defined(__aarch64__)
>  static inline uint32_t get_pmcr(void)
>  {
> @@ -30,6 +70,34 @@ static inline uint32_t get_pmcr(void)
>  	asm volatile("mrs %0, pmcr_el0" : "=r" (ret));
>  	return ret;
>  }
> +
> +static inline void set_pmcr(uint32_t pmcr)
> +{
> +	asm volatile("msr pmcr_el0, %0" : : "r" (pmcr));
> +}
> +
> +static inline void set_pmccfiltr(uint32_t filter)
> +{
> +	asm volatile("msr pmccfiltr_el0, %0" : : "r" (filter));
> +}
> +
> +static inline unsigned long get_pmccntr(void)
> +{
> +	unsigned long cycles;
> +
> +	asm volatile("mrs %0, pmccntr_el0" : "=r" (cycles));
> +	return cycles;
> +}
> +
> +static inline void enable_counter(uint32_t idx)
> +{
> +	asm volatile("msr pmcntenset_el0, %0" : : "r" (1 << idx));
> +}
> +
> +static inline void disable_counter(uint32_t idx)
> +{
> +	asm volatile("msr pmcntensclr_el0, %0" : : "r" (1 << idx));
> +}
>  #endif
>  
>  struct pmu_data {
> @@ -72,11 +140,43 @@ static bool check_pmcr(void)
>  	return pmu.implementer != 0;
>  }
>  
> +/*
> + * Ensure that the cycle counter progresses between back-to-back reads.
> + */
> +static bool check_cycles_increase(void)
> +{
> +	struct pmu_data pmu = {{0}};
> +
> +	enable_counter(ARMV8_PMU_CYCLE_IDX);
> +	set_pmccfiltr(0); /* count cycles in EL0, EL1, but not EL2 */
> +
> +	pmu.enable = 1;
> +	set_pmcr(pmu.pmcr_el0);
> +
> +	for (int i = 0; i < NR_SAMPLES; i++) {
> +		unsigned long a, b;
> +
> +		a = get_pmccntr();
> +		b = get_pmccntr();
> +
> +		if (a >= b) {
> +			printf("Read %ld then %ld.\n", a, b);
> +			return false;
> +		}
> +	}
> +
> +	pmu.enable = 0;
> +	set_pmcr(pmu.pmcr_el0);
> +
> +	return true;
> +}
> +
>  int main(void)
>  {
>  	report_prefix_push("pmu");
>  
>  	report("Control register", check_pmcr());
> +	report("Monotonically increasing cycle count", check_cycles_increase());
>  
>  	return report_summary();
>  }

What happens with this test running on tcg? Do we just fail? Does it
explode? Is there a register we can probe and when it indicates things
won't work we can invoke a report_skip?

Thanks,
drew
