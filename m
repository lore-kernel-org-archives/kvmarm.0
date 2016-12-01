From: Wei Huang <wei@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v13 3/4] arm: pmu: Check cycle count
 increases
Date: Thu, 1 Dec 2016 11:39:20 -0600
Message-ID: <04f420f1-666e-07e9-3c97-fab4acf0ebcf@redhat.com>
References: <1480569402-8848-1-git-send-email-wei@redhat.com>
 <1480569402-8848-4-git-send-email-wei@redhat.com>
 <b19abcd1-c59d-5b72-4cd5-9fcefc493a1e@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <b19abcd1-c59d-5b72-4cd5-9fcefc493a1e@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>, cov@codeaurora.org
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, shannon.zhao@linaro.org, alistair.francis@xilinx.com, croberts@codeaurora.org, alindsay@codeaurora.org, drjones@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu



On 12/01/2016 05:27 AM, Andre Przywara wrote:
> Hi,
> 
> On 01/12/16 05:16, Wei Huang wrote:
>> From: Christopher Covington <cov@codeaurora.org>
>>
>> Ensure that reads of the PMCCNTR_EL0 are monotonically increasing,
>> even for the smallest delta of two subsequent reads.
>>
>> Signed-off-by: Christopher Covington <cov@codeaurora.org>
>> Signed-off-by: Wei Huang <wei@redhat.com>
>> Reviewed-by: Andrew Jones <drjones@redhat.com>
>> ---
>>  arm/pmu.c | 94 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 94 insertions(+)
>>
>> diff --git a/arm/pmu.c b/arm/pmu.c
>> index 1fe2b1a..3566a27 100644
>> --- a/arm/pmu.c
>> +++ b/arm/pmu.c
>> @@ -16,6 +16,9 @@
>>  #include "asm/barrier.h"
>>  #include "asm/processor.h"
>>  
>> +#define PMU_PMCR_E         (1 << 0)
>> +#define PMU_PMCR_C         (1 << 2)
>> +#define PMU_PMCR_LC        (1 << 6)
>>  #define PMU_PMCR_N_SHIFT   11
>>  #define PMU_PMCR_N_MASK    0x1f
>>  #define PMU_PMCR_ID_SHIFT  16
>> @@ -23,10 +26,57 @@
>>  #define PMU_PMCR_IMP_SHIFT 24
>>  #define PMU_PMCR_IMP_MASK  0xff
>>  
>> +#define ID_DFR0_PERFMON_SHIFT 24
>> +#define ID_DFR0_PERFMON_MASK  0xf
>> +
>> +#define PMU_CYCLE_IDX         31
>> +
>> +#define NR_SAMPLES 10
>> +
>> +static unsigned int pmu_version;
>>  #if defined(__arm__)
>>  DEFINE_GET_SYSREG32(pmcr, 0, c9, c12, 0)
>> +DEFINE_SET_SYSREG32(pmcr, 0, c9, c12, 0)
>> +DEFINE_GET_SYSREG32(id_dfr0, 0, c0, c1, 2)
>> +DEFINE_SET_SYSREG32(pmselr, 0, c9, c12, 5)
>> +DEFINE_SET_SYSREG32(pmxevtyper, 0, c9, c13, 1)
>> +DEFINE_GET_SYSREG32(pmccntr32, 0, c9, c13, 0)
>> +DEFINE_SET_SYSREG32(pmccntr32, 0, c9, c13, 0)
>> +DEFINE_GET_SYSREG64(pmccntr64, 0, c9)
>> +DEFINE_SET_SYSREG64(pmccntr64, 0, c9)
>> +DEFINE_SET_SYSREG32(pmcntenset, 0, c9, c12, 1)
>> +
>> +static inline uint64_t get_pmccntr(void)
>> +{
>> +	if (pmu_version == 0x3)
>> +		return get_pmccntr64();
>> +	else
>> +		return get_pmccntr32();
>> +}
>> +
>> +static inline void set_pmccntr(uint64_t value)
>> +{
>> +	if (pmu_version == 0x3)
>> +		set_pmccntr64(value);
>> +	else
>> +		set_pmccntr32(value & 0xffffffff);
>> +}
>> +
>> +/* PMCCFILTR is an obsolete name for PMXEVTYPER31 in ARMv7 */
>> +static inline void set_pmccfiltr(uint32_t value)
>> +{
>> +	set_pmselr(PMU_CYCLE_IDX);
>> +	set_pmxevtyper(value);
>> +	isb();
>> +}
>>  #elif defined(__aarch64__)
>>  DEFINE_GET_SYSREG32(pmcr, el0)
>> +DEFINE_SET_SYSREG32(pmcr, el0)
>> +DEFINE_GET_SYSREG32(id_dfr0, el1)
>> +DEFINE_GET_SYSREG64(pmccntr, el0);
>> +DEFINE_SET_SYSREG64(pmccntr, el0);
>> +DEFINE_SET_SYSREG32(pmcntenset, el0);
>> +DEFINE_SET_SYSREG32(pmccfiltr, el0);
>>  #endif
>>  
>>  /*
>> @@ -52,11 +102,55 @@ static bool check_pmcr(void)
>>  	return ((pmcr >> PMU_PMCR_IMP_SHIFT) & PMU_PMCR_IMP_MASK) != 0;
>>  }
>>  
>> +/*
>> + * Ensure that the cycle counter progresses between back-to-back reads.
>> + */
>> +static bool check_cycles_increase(void)
>> +{
>> +	bool success = true;
>> +
>> +	/* init before event access, this test only cares about cycle count */
>> +	set_pmcntenset(1 << PMU_CYCLE_IDX);
>> +	set_pmccfiltr(0); /* count cycles in EL0, EL1, but not EL2 */
>> +	set_pmccntr(0);
> 
> Why do we need this? Shouldn't PMU_PMCR_C below take care of that?

PMU_PMCR_C does reset cycle counter, I can remove this one.

> 
>> +
>> +	set_pmcr(get_pmcr() | PMU_PMCR_LC | PMU_PMCR_C | PMU_PMCR_E);
>> +
>> +	for (int i = 0; i < NR_SAMPLES; i++) {
>> +		uint64_t a, b;
>> +
>> +		a = get_pmccntr();
>> +		b = get_pmccntr();
>> +
>> +		if (a >= b) {
>> +			printf("Read %"PRId64" then %"PRId64".\n", a, b);
>> +			success = false;
>> +			break;
>> +		}
>> +	}
>> +
>> +	set_pmcr(get_pmcr() & ~PMU_PMCR_E);
>> +
>> +	return success;
>> +}
>> +
>> +void pmu_init(void)
> 
> Mmh, this function doesn't really initialize anything, does it?
> Should it be named pmu_available() or pmu_version() or the like?
> 

This function used to contain cycle counter configuration code. It sets
up PMCCNFILTR, PMCNTENSET, etc. Since then, the configuration code has
been moved to sub-unit tests. We can change its name to something like
pmu_probe().

> And should we bail out early here (or rather at the caller) if this
> register reports that no PMU is available? For instance by making it
> return a boolean?

This could do.

> 
>> +{
>> +	uint32_t dfr0;
>> +
>> +	/* probe pmu version */
>> +	dfr0 = get_id_dfr0();
>> +	pmu_version = (dfr0 >> ID_DFR0_PERFMON_SHIFT) & ID_DFR0_PERFMON_MASK;
>> +	report_info("PMU version: %d", pmu_version);
>> +}
>> +
>>  int main(void)
>>  {
>>  	report_prefix_push("pmu");
>>  
>> +	pmu_init();
>>  	report("Control register", check_pmcr());
>> +	report("Monotonically increasing cycle count", check_cycles_increase());
> 
> I wonder if we should skip this test if check_pmcr() has returned false
> before? We let it return a boolean, so it seems quite natural to use
> this information here.
> This would avoid a lot of false FAILs due to the PMU not being available
> (because QEMU is too old, for instance).
> 
> Cheers,
> Andre.
> 
