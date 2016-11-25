From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [Qemu-devel] [kvm-unit-tests PATCH v11 1/3] arm: Add PMU test
Date: Fri, 25 Nov 2016 14:39:52 +0000
Message-ID: <392be1f7-5d6d-5359-450a-a48fbc75fcc7@arm.com>
References: <20161123171551.qfvdcxvys2pphzs3@kamzik.brq.redhat.com>
 <20161125123224.3267-1-andre.przywara@arm.com>
 <20161125142625.43mytkuk5vrwzq6j@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 76565406D0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Nov 2016 09:38:30 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qg02mz66aEoC for <kvmarm@lists.cs.columbia.edu>;
 Fri, 25 Nov 2016 09:38:28 -0500 (EST)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7B8AA405C4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Nov 2016 09:38:27 -0500 (EST)
In-Reply-To: <20161125142625.43mytkuk5vrwzq6j@kamzik.brq.redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>
Cc: alindsay@codeaurora.org, kvm@vger.kernel.org, croberts@codeaurora.org, qemu-devel@nongnu.org, alistair.francis@xilinx.com, kvmarm@lists.cs.columbia.edu, shannon.zhao@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 25/11/16 14:26, Andrew Jones wrote:
> On Fri, Nov 25, 2016 at 12:32:24PM +0000, Andre Przywara wrote:
>> Hi Drew,
>>
>> ....
>>
>> On 23/11/16 17:15, Andrew Jones wrote:
>>>>> +
>>>>> +#if defined(__arm__)
>>>>
>>>> I guess you should use the arch specific header files we have in place
>>>> for that (lib/arm{.64}/asm/processor.h). Also there are sysreg read
>>>> wrappers (at least for arm64) in there already, can't we base this
>>>> function on them: DEFINE_GET_SYSREG32(pmcr, el0)?
>>>> (Requires a small change to get rid of the forced "_el1" suffix)
>>>>
>>>> We should wait for the GIC series to be merged, as this contains some
>>>> changes in this area.
>>>
>>> As this unit test is the only consumer of PMC registers so far, then
>>> I'd prefer the defines and accessors stay here for now. Once we see
>>> a use in other unit tests then we can move some of it out.
>>
>> Well, I was more thinking of something like below.
>> I am fine with keeping the PMU sysregs private to pmu.c, but we can still
>> use the sysreg wrappers, can't we?
>> This is on top of Wei's series, so doesn't have your SYSREG32/64
>> unification, but I leave this as an exercise to the reader.
>> There is some churn in pmu.c below due to the change of <sysreg>_write to
>> set_<sysreg>, but the rest looks like simplification to me.
>>
>> Does that make sense?
> 
> Ah, now I see what you mean, and I think I like that. The question is
> whether or not I like my SYSREG macros :-) I see value in having the
> asm's easy to read (open-coded),

Mmh, where is this easy to read? Especially the v7 syntax is really
error prone and hard to grasp with all these c9s, c12s and friends, in
addition to the weird ordering and mixing in of register names in the
(inline) assembly syntax. Blame the company that came up with this
architecture ;-)

Compare:
mrc p15, 0, %0, c9, c12, 0
with:
DEFINE_GET_SYSREG32(pmcr, 0, c9, c12, 0)

The "0, %0" in there always kills me when reading this.

On top of this a list of one-line-per-sysreg declarations is much easier
to compare with the manual than the open coded versions.

Another benefit is that we don't need to encode versions for both
bitnesses in each test. For shared sysregs we could put the definitions
in processor.h, the code then just uses one architecture agnostic version.

But I leave it up to you guys to decide on this, you don't break my
heart if you stick with inline assembly ;-)

Cheers,
Andre.

 as well as value in making sure we
> only have to review sysreg functions once. Let's ask for Wei's and
> Cov's votes. If they like the SYSREG direction, then they can vote
> with another version of this series :-)
> 
> Thanks,
> drew
> 
>>
>> Cheers,
>> Andre.
>>
>> ---
>>  arm/pmu.c                 | 159 +++++++++++++---------------------------------
>>  lib/arm/asm/processor.h   |  34 ++++++++--
>>  lib/arm64/asm/processor.h |  23 ++++++-
>>  3 files changed, 92 insertions(+), 124 deletions(-)
>>
>> diff --git a/arm/pmu.c b/arm/pmu.c
>> index f667676..f0ad02a 100644
>> --- a/arm/pmu.c
>> +++ b/arm/pmu.c
>> @@ -14,6 +14,7 @@
>>   */
>>  #include "libcflat.h"
>>  #include "asm/barrier.h"
>> +#include "asm/processor.h"
>>  
>>  #define PMU_PMCR_E         (1 << 0)
>>  #define PMU_PMCR_C         (1 << 2)
>> @@ -33,78 +34,42 @@
>>  #define NR_SAMPLES 10
>>  
>>  static unsigned int pmu_version;
>> -#if defined(__arm__)
>> -static inline uint32_t pmcr_read(void)
>> -{
>> -	uint32_t ret;
>> -
>> -	asm volatile("mrc p15, 0, %0, c9, c12, 0" : "=r" (ret));
>> -	return ret;
>> -}
>> -
>> -static inline void pmcr_write(uint32_t value)
>> -{
>> -	asm volatile("mcr p15, 0, %0, c9, c12, 0" : : "r" (value));
>> -	isb();
>> -}
>>  
>> -static inline void pmselr_write(uint32_t value)
>> -{
>> -	asm volatile("mcr p15, 0, %0, c9, c12, 5" : : "r" (value));
>> -	isb();
>> -}
>> -
>> -static inline void pmxevtyper_write(uint32_t value)
>> -{
>> -	asm volatile("mcr p15, 0, %0, c9, c13, 1" : : "r" (value));
>> -}
>> -
>> -static inline uint64_t pmccntr_read(void)
>> +#if defined(__arm__)
>> +DEFINE_GET_SYSREG32(pmcr, 0, c9, c12, 0)
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
>>  {
>> -	uint32_t lo, hi = 0;
>> -
>>  	if (pmu_version == 0x3)
>> -		asm volatile("mrrc p15, 0, %0, %1, c9" : "=r" (lo), "=r" (hi));
>> +		return get_pmccntr32();
>>  	else
>> -		asm volatile("mrc p15, 0, %0, c9, c13, 0" : "=r" (lo));
>> -
>> -	return ((uint64_t)hi << 32) | lo;
>> +		return get_pmccntr64();
>>  }
>>  
>> -static inline void pmccntr_write(uint64_t value)
>> +static inline void set_pmccntr(uint64_t value)
>>  {
>> -	uint32_t lo, hi;
>> -
>> -	lo = value & 0xffffffff;
>> -	hi = (value >> 32) & 0xffffffff;
>> -
>>  	if (pmu_version == 0x3)
>> -		asm volatile("mcrr p15, 0, %0, %1, c9" : : "r" (lo), "r" (hi));
>> +		set_pmccntr64(value);
>>  	else
>> -		asm volatile("mcr p15, 0, %0, c9, c13, 0" : : "r" (lo));
>> +		set_pmccntr64(value & 0xffffffff);
>>  }
>> -
>> -static inline void pmcntenset_write(uint32_t value)
>> -{
>> -	asm volatile("mcr p15, 0, %0, c9, c12, 1" : : "r" (value));
>> -}
>> -
>>  /* PMCCFILTR is an obsolete name for PMXEVTYPER31 in ARMv7 */
>> -static inline void pmccfiltr_write(uint32_t value)
>> +static inline void set_pmccfiltr(uint32_t value)
>>  {
>> -	pmselr_write(PMU_CYCLE_IDX);
>> -	pmxevtyper_write(value);
>> +	set_pmselr(PMU_CYCLE_IDX);
>> +	set_pmxevtyper(value);
>>  	isb();
>>  }
>>  
>> -static inline uint32_t id_dfr0_read(void)
>> -{
>> -	uint32_t val;
>> -
>> -	asm volatile("mrc p15, 0, %0, c0, c1, 2" : "=r" (val));
>> -	return val;
>> -}
>> -
>>  /*
>>   * Extra instructions inserted by the compiler would be difficult to compensate
>>   * for, so hand assemble everything between, and including, the PMCR accesses
>> @@ -126,51 +91,13 @@ static inline void precise_instrs_loop(int loop, uint32_t pmcr)
>>  	: "cc");
>>  }
>>  #elif defined(__aarch64__)
>> -static inline uint32_t pmcr_read(void)
>> -{
>> -	uint32_t ret;
>> -
>> -	asm volatile("mrs %0, pmcr_el0" : "=r" (ret));
>> -	return ret;
>> -}
>> -
>> -static inline void pmcr_write(uint32_t value)
>> -{
>> -	asm volatile("msr pmcr_el0, %0" : : "r" (value));
>> -	isb();
>> -}
>> -
>> -static inline uint64_t pmccntr_read(void)
>> -{
>> -	uint64_t cycles;
>> -
>> -	asm volatile("mrs %0, pmccntr_el0" : "=r" (cycles));
>> -	return cycles;
>> -}
>> -
>> -static inline void pmccntr_write(uint64_t value)
>> -{
>> -	asm volatile("msr pmccntr_el0, %0" : : "r" (value));
>> -}
>> -
>> -static inline void pmcntenset_write(uint32_t value)
>> -{
>> -	asm volatile("msr pmcntenset_el0, %0" : : "r" (value));
>> -}
>> -
>> -static inline void pmccfiltr_write(uint32_t value)
>> -{
>> -	asm volatile("msr pmccfiltr_el0, %0" : : "r" (value));
>> -	isb();
>> -}
>> -
>> -static inline uint32_t id_dfr0_read(void)
>> -{
>> -	uint32_t id;
>> -
>> -	asm volatile("mrs %0, id_dfr0_el1" : "=r" (id));
>> -	return id;
>> -}
>> +DEFINE_GET_SYSREG32(pmcr, el0)
>> +DEFINE_SET_SYSREG32(pmcr, el0)
>> +DEFINE_GET_SYSREG32(id_dfr0, el1)
>> +DEFINE_GET_SYSREG64(pmccntr, el0);
>> +DEFINE_SET_SYSREG64(pmccntr, el0);
>> +DEFINE_SET_SYSREG32(pmcntenset, el0);
>> +DEFINE_SET_SYSREG32(pmccfiltr, el0);
>>  
>>  /*
>>   * Extra instructions inserted by the compiler would be difficult to compensate
>> @@ -206,7 +133,7 @@ static bool check_pmcr(void)
>>  {
>>  	uint32_t pmcr;
>>  
>> -	pmcr = pmcr_read();
>> +	pmcr = get_pmcr();
>>  
>>  	printf("PMU implementer:     %c\n",
>>  	       (pmcr >> PMU_PMCR_IMP_SHIFT) & PMU_PMCR_IMP_MASK);
>> @@ -226,17 +153,17 @@ static bool check_cycles_increase(void)
>>  	bool success = true;
>>  
>>  	/* init before event access, this test only cares about cycle count */
>> -	pmcntenset_write(1 << PMU_CYCLE_IDX);
>> -	pmccfiltr_write(0); /* count cycles in EL0, EL1, but not EL2 */
>> -	pmccntr_write(0);
>> +	set_pmcntenset(1 << PMU_CYCLE_IDX);
>> +	set_pmccfiltr(0); /* count cycles in EL0, EL1, but not EL2 */
>> +	set_pmccntr(0);
>>  
>> -	pmcr_write(pmcr_read() | PMU_PMCR_LC | PMU_PMCR_C | PMU_PMCR_E);
>> +	set_pmcr(get_pmcr() | PMU_PMCR_LC | PMU_PMCR_C | PMU_PMCR_E);
>>  
>>  	for (int i = 0; i < NR_SAMPLES; i++) {
>>  		uint64_t a, b;
>>  
>> -		a = pmccntr_read();
>> -		b = pmccntr_read();
>> +		a = get_pmccntr();
>> +		b = get_pmccntr();
>>  
>>  		if (a >= b) {
>>  			printf("Read %"PRId64" then %"PRId64".\n", a, b);
>> @@ -245,7 +172,7 @@ static bool check_cycles_increase(void)
>>  		}
>>  	}
>>  
>> -	pmcr_write(pmcr_read() & ~PMU_PMCR_E);
>> +	set_pmcr(get_pmcr() & ~PMU_PMCR_E);
>>  
>>  	return success;
>>  }
>> @@ -276,11 +203,11 @@ static void measure_instrs(int num, uint32_t pmcr)
>>   */
>>  static bool check_cpi(int cpi)
>>  {
>> -	uint32_t pmcr = pmcr_read() | PMU_PMCR_LC | PMU_PMCR_C | PMU_PMCR_E;
>> +	uint32_t pmcr = get_pmcr() | PMU_PMCR_LC | PMU_PMCR_C | PMU_PMCR_E;
>>  
>>  	/* init before event access, this test only cares about cycle count */
>> -	pmcntenset_write(1 << PMU_CYCLE_IDX);
>> -	pmccfiltr_write(0); /* count cycles in EL0, EL1, but not EL2 */
>> +	set_pmcntenset(1 << PMU_CYCLE_IDX);
>> +	set_pmccfiltr(0); /* count cycles in EL0, EL1, but not EL2 */
>>  
>>  	if (cpi > 0)
>>  		printf("Checking for CPI=%d.\n", cpi);
>> @@ -293,9 +220,9 @@ static bool check_cpi(int cpi)
>>  		for (int j = 0; j < NR_SAMPLES; j++) {
>>  			uint64_t cycles;
>>  
>> -			pmccntr_write(0);
>> +			set_pmccntr(0);
>>  			measure_instrs(i, pmcr);
>> -			cycles = pmccntr_read();
>> +			cycles = get_pmccntr();
>>  			printf(" %"PRId64"", cycles);
>>  
>>  			if (!cycles) {
>> @@ -328,7 +255,7 @@ void pmu_init(void)
>>  	uint32_t dfr0;
>>  
>>  	/* probe pmu version */
>> -	dfr0 = id_dfr0_read();
>> +	dfr0 = get_id_dfr0();
>>  	pmu_version = (dfr0 >> ID_DFR0_PERFMON_SHIFT) & ID_DFR0_PERFMON_MASK;
>>  	printf("PMU version: %d\n", pmu_version);
>>  }
>> diff --git a/lib/arm/asm/processor.h b/lib/arm/asm/processor.h
>> index f25e7ee..6e7ffa3 100644
>> --- a/lib/arm/asm/processor.h
>> +++ b/lib/arm/asm/processor.h
>> @@ -33,12 +33,36 @@ static inline unsigned long current_cpsr(void)
>>  
>>  #define current_mode() (current_cpsr() & MODE_MASK)
>>  
>> -static inline unsigned int get_mpidr(void)
>> -{
>> -	unsigned int mpidr;
>> -	asm volatile("mrc p15, 0, %0, c0, c0, 5" : "=r" (mpidr));
>> -	return mpidr;
>> +#define DEFINE_GET_SYSREG32(name, opc1, crn, crm, opc2)			\
>> +static inline unsigned long get_##name(void)				\
>> +{									\
>> +	unsigned long reg;						\
>> +	asm volatile("mrc p15, " #opc1 ", %0, " #crn ", " #crm ", " #opc2  \
>> +		     : "=r" (reg));					\
>> +	return reg;							\
>> +}
>> +#define DEFINE_SET_SYSREG32(name, opc1, crn, crm, opc2)			\
>> +static inline void set_##name(unsigned int value)			\
>> +{									\
>> +	asm volatile("mcr p15, " #opc1 ", %0, " #crn ", " #crm ", " #opc2  \
>> +		     :: "r" (value));					\
>> +}
>> +#define DEFINE_GET_SYSREG64(name, opc1, crm)				\
>> +static inline uint64_t get_##name(void)					\
>> +{									\
>> +	uint32_t lo, hi;						\
>> +	asm volatile("mrrc p15, " #opc1 ", %0, %1, " #crm		\
>> +		     : "=r" (lo), "=r" (hi));				\
>> +	return lo | (uint64_t)hi << 32;					\
>>  }
>> +#define DEFINE_SET_SYSREG64(name, opc1, crm)				\
>> +static inline void set_##name(uint64_t value)				\
>> +{									\
>> +	asm volatile("mcrr p15, " #opc1 ", %0, %1, " #crm		\
>> +		     :: "r" (value & 0xffffffff), "r" (value >> 32));	\
>> +}
>> +
>> +DEFINE_GET_SYSREG32(mpidr, 0, c0, c0, 5)
>>  
>>  /* Only support Aff0 for now, up to 4 cpus */
>>  #define mpidr_to_cpu(mpidr) ((int)((mpidr) & 0xff))
>> diff --git a/lib/arm64/asm/processor.h b/lib/arm64/asm/processor.h
>> index 84d5c7c..cf06c41 100644
>> --- a/lib/arm64/asm/processor.h
>> +++ b/lib/arm64/asm/processor.h
>> @@ -66,14 +66,31 @@ static inline unsigned long current_level(void)
>>  	return el & 0xc;
>>  }
>>  
>> -#define DEFINE_GET_SYSREG32(reg)				\
>> +#define DEFINE_GET_SYSREG32(reg, el)				\
>>  static inline unsigned int get_##reg(void)			\
>>  {								\
>>  	unsigned int reg;					\
>> -	asm volatile("mrs %0, " #reg "_el1" : "=r" (reg));	\
>> +	asm volatile("mrs %0, " #reg "_" #el : "=r" (reg));	\
>>  	return reg;						\
>>  }
>> -DEFINE_GET_SYSREG32(mpidr)
>> +#define DEFINE_SET_SYSREG32(reg, el)				\
>> +static inline void set_##reg(unsigned int value)		\
>> +{								\
>> +	asm volatile("msr " #reg "_" #el ", %0" :: "r" (value));\
>> +}
>> +#define DEFINE_GET_SYSREG64(reg, el)				\
>> +static inline uint64_t get_##reg(void)				\
>> +{								\
>> +	uint64_t reg;						\
>> +	asm volatile("mrs %0, " #reg "_" #el : "=r" (reg));	\
>> +	return reg;						\
>> +}
>> +#define DEFINE_SET_SYSREG64(reg, el)				\
>> +static inline void set_##reg(uint64_t value)			\
>> +{								\
>> +	asm volatile("msr " #reg "_" #el ", %0" :: "r" (value));\
>> +}
>> +DEFINE_GET_SYSREG32(mpidr, el1)
>>  
>>  /* Only support Aff0 for now, gicv2 only */
>>  #define mpidr_to_cpu(mpidr) ((int)((mpidr) & 0xff))
>> -- 
>> 2.9.0
>>
>>
