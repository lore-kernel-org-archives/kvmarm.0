From: Wei Huang <wei@redhat.com>
Subject: Re: [Qemu-devel] [kvm-unit-tests PATCH v13 3/4] arm: pmu: Check cycle
 count increases
Date: Thu, 1 Dec 2016 11:36:55 -0600
Message-ID: <cb8f7b58-504a-d70f-a74e-a520b0d3d5c1@redhat.com>
References: <1480569402-8848-1-git-send-email-wei@redhat.com>
 <1480569402-8848-4-git-send-email-wei@redhat.com>
 <20161201091848.vrr7ojk5snmz6gv3@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20161201091848.vrr7ojk5snmz6gv3@kamzik.brq.redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Andrew Jones <drjones@redhat.com>
Cc: cov@codeaurora.org, alindsay@codeaurora.org, kvm@vger.kernel.org, andre.przywara@arm.com, croberts@codeaurora.org, qemu-devel@nongnu.org, alistair.francis@xilinx.com, shannon.zhao@linaro.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu



On 12/01/2016 03:18 AM, Andrew Jones wrote:
> On Wed, Nov 30, 2016 at 11:16:41PM -0600, Wei Huang wrote:
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
> 
> Seeing how we get lots of redundant looking lines, I think instead
> of defining DEFINE_SET/GET_SYSREG32/64, we should instead have
> 
> DEFINE_SYSREG32/64      ... creates both get_<reg> and set_<reg>
> DEFINE_SYSREG32/64_RO   ... creates just get_<reg>

Don't like the naming. I think we can create a new macro, named
DEFINE_GET_SET_SYSREG32/64. I know it is boring, but readers should get
the idea easily.

> 
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
> 
> So the two accessors above are exceptional, which is why we don't
> use SYSREG for them. These can have uint64_t for there external
> interface. We can't require 'unsigned long' or 'unsigned long long'
> 
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
>>  
>>  	return report_summary();
>>  }
>> -- 
>> 1.8.3.1
>>
>>
> 
> drew 
> 
