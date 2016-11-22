From: Andrew Jones <drjones@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v10 2/3] arm: pmu: Check cycle count
 increases
Date: Tue, 22 Nov 2016 13:42:55 +0100
Message-ID: <20161122124255.y462bmnv23e4fqjr@kamzik.brq.redhat.com>
References: <1479759895-10042-1-git-send-email-wei@redhat.com>
 <1479759895-10042-3-git-send-email-wei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1479759895-10042-3-git-send-email-wei@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Wei Huang <wei@redhat.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, shannon.zhao@linaro.org, kvm@vger.kernel.org, marc.zyngier@arm.com, christoffer.dall@linaro.org, cov@codeaurora.org, will.deacon@arm.com, mark.rutland@arm.com, catalin.marinas@arm.com, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Nov 21, 2016 at 02:24:54PM -0600, Wei Huang wrote:
> From: Christopher Covington <cov@codeaurora.org>
> 
> Ensure that reads of the PMCCNTR_EL0 are monotonically increasing,
> even for the smallest delta of two subsequent reads.
> 
> Signed-off-by: Christopher Covington <cov@codeaurora.org>
> Signed-off-by: Wei Huang <wei@redhat.com>

Reviewed-by: Andrew Jones <drjones@redhat.com>

> ---
>  arm/pmu.c | 156 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 156 insertions(+)
> 
> diff --git a/arm/pmu.c b/arm/pmu.c
> index 9d9c53b..176b070 100644
> --- a/arm/pmu.c
> +++ b/arm/pmu.c
> @@ -15,6 +15,9 @@
>  #include "libcflat.h"
>  #include "asm/barrier.h"
>  
> +#define PMU_PMCR_E         (1 << 0)
> +#define PMU_PMCR_C         (1 << 2)
> +#define PMU_PMCR_LC        (1 << 6)
>  #define PMU_PMCR_N_SHIFT   11
>  #define PMU_PMCR_N_MASK    0x1f
>  #define PMU_PMCR_ID_SHIFT  16
> @@ -22,6 +25,14 @@
>  #define PMU_PMCR_IMP_SHIFT 24
>  #define PMU_PMCR_IMP_MASK  0xff
>  
> +#define ID_DFR0_PERFMON_SHIFT 24
> +#define ID_DFR0_PERFMON_MASK  0xf
> +
> +#define PMU_CYCLE_IDX         31
> +
> +#define NR_SAMPLES 10
> +
> +static unsigned int pmu_version;
>  #if defined(__arm__)
>  static inline uint32_t pmcr_read(void)
>  {
> @@ -30,6 +41,69 @@ static inline uint32_t pmcr_read(void)
>  	asm volatile("mrc p15, 0, %0, c9, c12, 0" : "=r" (ret));
>  	return ret;
>  }
> +
> +static inline void pmcr_write(uint32_t value)
> +{
> +	asm volatile("mcr p15, 0, %0, c9, c12, 0" : : "r" (value));
> +	isb();
> +}
> +
> +static inline void pmselr_write(uint32_t value)
> +{
> +	asm volatile("mcr p15, 0, %0, c9, c12, 5" : : "r" (value));
> +	isb();
> +}
> +
> +static inline void pmxevtyper_write(uint32_t value)
> +{
> +	asm volatile("mcr p15, 0, %0, c9, c13, 1" : : "r" (value));
> +}
> +
> +static inline uint64_t pmccntr_read(void)
> +{
> +	uint32_t lo, hi = 0;
> +
> +	if (pmu_version == 0x3)
> +		asm volatile("mrrc p15, 0, %0, %1, c9" : "=r" (lo), "=r" (hi));
> +	else
> +		asm volatile("mrc p15, 0, %0, c9, c13, 0" : "=r" (lo));
> +
> +	return ((uint64_t)hi << 32) | lo;
> +}
> +
> +static inline void pmccntr_write(uint64_t value)
> +{
> +	uint32_t lo, hi;
> +
> +	lo = value & 0xffffffff;
> +	hi = (value >> 32) & 0xffffffff;
> +
> +	if (pmu_version == 0x3)
> +		asm volatile("mcrr p15, 0, %0, %1, c9" : : "r" (lo), "r" (hi));
> +	else
> +		asm volatile("mcr p15, 0, %0, c9, c13, 0" : : "r" (lo));
> +}
> +
> +static inline void pmcntenset_write(uint32_t value)
> +{
> +	asm volatile("mcr p15, 0, %0, c9, c12, 1" : : "r" (value));
> +}
> +
> +/* PMCCFILTR is an obsolete name for PMXEVTYPER31 in ARMv7 */
> +static inline void pmccfiltr_write(uint32_t value)
> +{
> +	pmselr_write(PMU_CYCLE_IDX);
> +	pmxevtyper_write(value);
> +	isb();
> +}
> +
> +static inline uint32_t id_dfr0_read(void)
> +{
> +	uint32_t val;
> +
> +	asm volatile("mrc p15, 0, %0, c0, c1, 2" : "=r" (val));
> +	return val;
> +}
>  #elif defined(__aarch64__)
>  static inline uint32_t pmcr_read(void)
>  {
> @@ -38,6 +112,44 @@ static inline uint32_t pmcr_read(void)
>  	asm volatile("mrs %0, pmcr_el0" : "=r" (ret));
>  	return ret;
>  }
> +
> +static inline void pmcr_write(uint32_t value)
> +{
> +	asm volatile("msr pmcr_el0, %0" : : "r" (value));
> +	isb();
> +}
> +
> +static inline uint64_t pmccntr_read(void)
> +{
> +	uint64_t cycles;
> +
> +	asm volatile("mrs %0, pmccntr_el0" : "=r" (cycles));
> +	return cycles;
> +}
> +
> +static inline void pmccntr_write(uint64_t value)
> +{
> +	asm volatile("msr pmccntr_el0, %0" : : "r" (value));
> +}
> +
> +static inline void pmcntenset_write(uint32_t value)
> +{
> +	asm volatile("msr pmcntenset_el0, %0" : : "r" (value));
> +}
> +
> +static inline void pmccfiltr_write(uint32_t value)
> +{
> +	asm volatile("msr pmccfiltr_el0, %0" : : "r" (value));
> +	isb();
> +}
> +
> +static inline uint32_t id_dfr0_read(void)
> +{
> +	uint32_t id;
> +
> +	asm volatile("mrs %0, id_dfr0_el1" : "=r" (id));
> +	return id;
> +}
>  #endif
>  
>  /*
> @@ -64,11 +176,55 @@ static bool check_pmcr(void)
>  	return ((pmcr >> PMU_PMCR_IMP_SHIFT) & PMU_PMCR_IMP_MASK) != 0;
>  }
>  
> +/*
> + * Ensure that the cycle counter progresses between back-to-back reads.
> + */
> +static bool check_cycles_increase(void)
> +{
> +	bool success = true;
> +
> +	/* init before event access, this test only cares about cycle count */
> +	pmcntenset_write(1 << PMU_CYCLE_IDX);
> +	pmccfiltr_write(0); /* count cycles in EL0, EL1, but not EL2 */
> +	pmccntr_write(0);
> +
> +	pmcr_write(pmcr_read() | PMU_PMCR_LC | PMU_PMCR_C | PMU_PMCR_E);
> +
> +	for (int i = 0; i < NR_SAMPLES; i++) {
> +		uint64_t a, b;
> +
> +		a = pmccntr_read();
> +		b = pmccntr_read();
> +
> +		if (a >= b) {
> +			printf("Read %"PRId64" then %"PRId64".\n", a, b);
> +			success = false;
> +			break;
> +		}
> +	}
> +
> +	pmcr_write(pmcr_read() & ~PMU_PMCR_E);
> +
> +	return success;
> +}
> +
> +void pmu_init(void)
> +{
> +	uint32_t dfr0;
> +
> +	/* probe pmu version */
> +	dfr0 = id_dfr0_read();
> +	pmu_version = (dfr0 >> ID_DFR0_PERFMON_SHIFT) & ID_DFR0_PERFMON_MASK;
> +	printf("PMU version: %d\n", pmu_version);
> +}
> +
>  int main(void)
>  {
>  	report_prefix_push("pmu");
>  
> +	pmu_init();
>  	report("Control register", check_pmcr());
> +	report("Monotonically increasing cycle count", check_cycles_increase());
>  
>  	return report_summary();
>  }
> -- 
> 1.8.3.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
