From: Wei Huang <wei@redhat.com>
Subject: Re: [Qemu-devel] [kvm-unit-tests PATCH v8 3/3] arm: pmu: Add CPI
 checking
Date: Fri, 11 Nov 2016 10:10:36 -0600
Message-ID: <4cc844b6-3265-b5f4-1b94-94bf588e12eb@redhat.com>
References: <1478629035-12938-1-git-send-email-wei@redhat.com>
 <1478629035-12938-4-git-send-email-wei@redhat.com>
 <20161111080802.66if2o5lxbizq2jm@hawk.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20161111080802.66if2o5lxbizq2jm@hawk.localdomain>
Sender: kvm-owner@vger.kernel.org
To: Andrew Jones <drjones@redhat.com>
Cc: cov@codeaurora.org, alindsay@codeaurora.org, kvm@vger.kernel.org, croberts@codeaurora.org, qemu-devel@nongnu.org, alistair.francis@xilinx.com, shannon.zhao@linaro.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu



On 11/11/2016 02:08 AM, Andrew Jones wrote:
> On Tue, Nov 08, 2016 at 12:17:15PM -0600, Wei Huang wrote:
>> From: Christopher Covington <cov@codeaurora.org>
>>
>> Calculate the numbers of cycles per instruction (CPI) implied by ARM
>> PMU cycle counter values. The code includes a strict checking facility
>> intended for the -icount option in TCG mode in the configuration file.
>>
>> Signed-off-by: Christopher Covington <cov@codeaurora.org>
>> Signed-off-by: Wei Huang <wei@redhat.com>
>> ---
>>  arm/pmu.c         | 101 +++++++++++++++++++++++++++++++++++++++++++++++++++++-
>>  arm/unittests.cfg |  14 ++++++++
>>  2 files changed, 114 insertions(+), 1 deletion(-)
>>
>> diff --git a/arm/pmu.c b/arm/pmu.c
>> index d5e3ac3..09aff89 100644
>> --- a/arm/pmu.c
>> +++ b/arm/pmu.c
>> @@ -15,6 +15,7 @@
>>  #include "libcflat.h"
>>  
>>  #define PMU_PMCR_E         (1 << 0)
>> +#define PMU_PMCR_C         (1 << 2)
>>  #define PMU_PMCR_N_SHIFT   11
>>  #define PMU_PMCR_N_MASK    0x1f
>>  #define PMU_PMCR_ID_SHIFT  16
>> @@ -75,6 +76,23 @@ static inline void pmccfiltr_write(uint32_t value)
>>  	pmselr_write(PMU_CYCLE_IDX);
>>  	pmxevtyper_write(value);
>>  }
>> +
>> +/*
>> + * Extra instructions inserted by the compiler would be difficult to compensate
>> + * for, so hand assemble everything between, and including, the PMCR accesses
>> + * to start and stop counting.
>> + */
>> +static inline void loop(int i, uint32_t pmcr)
> 
> We should probably pick a more descriptive name for this function, as
> we intend to add many more PMU tests to this file. While at it, let's
> change 'i' to 'n', as it's the number of times to loop.

I will rename it to fixed_num_loop(). When more tests are added to it,
we can standardize the name, e.g. *_test().

> 
>> +{
>> +	asm volatile(
>> +	"	mcr	p15, 0, %[pmcr], c9, c12, 0\n"
>> +	"1:	subs	%[i], %[i], #1\n"
>> +	"	bgt	1b\n"
>> +	"	mcr	p15, 0, %[z], c9, c12, 0\n"
>> +	: [i] "+r" (i)
>> +	: [pmcr] "r" (pmcr), [z] "r" (0)
>> +	: "cc");
>> +}
>>  #elif defined(__aarch64__)
>>  static inline uint32_t pmcr_read(void)
>>  {
>> @@ -106,6 +124,23 @@ static inline void pmccfiltr_write(uint32_t value)
>>  {
>>  	asm volatile("msr pmccfiltr_el0, %0" : : "r" (value));
>>  }
>> +
>> +/*
>> + * Extra instructions inserted by the compiler would be difficult to compensate
>> + * for, so hand assemble everything between, and including, the PMCR accesses
>> + * to start and stop counting.
>> + */
>> +static inline void loop(int i, uint32_t pmcr)
>> +{
>> +	asm volatile(
>> +	"	msr	pmcr_el0, %[pmcr]\n"
>> +	"1:	subs	%[i], %[i], #1\n"
>> +	"	b.gt	1b\n"
>> +	"	msr	pmcr_el0, xzr\n"
>> +	: [i] "+r" (i)
>> +	: [pmcr] "r" (pmcr)
>> +	: "cc");
>> +}
>>  #endif
>>  
>>  /*
>> @@ -156,8 +191,71 @@ static bool check_cycles_increase(void)
>>  	return true;
>>  }
>>  
>> -int main(void)
>> +/*
>> + * Execute a known number of guest instructions. Only odd instruction counts
>> + * greater than or equal to 3 are supported by the in-line assembly code. The
>> + * control register (PMCR_EL0) is initialized with the provided value (allowing
>> + * for example for the cycle counter or event counters to be reset). At the end
>> + * of the exact instruction loop, zero is written to PMCR_EL0 to disable
>> + * counting, allowing the cycle counter or event counters to be read at the
>> + * leisure of the calling code.
>> + */
>> +static void measure_instrs(int num, uint32_t pmcr)
>> +{
>> +	int i = (num - 1) / 2;
>> +
>> +	assert(num >= 3 && ((num - 1) % 2 == 0));
>> +	loop(i, pmcr);
>> +}
>> +
>> +/*
>> + * Measure cycle counts for various known instruction counts. Ensure that the
>> + * cycle counter progresses (similar to check_cycles_increase() but with more
>> + * instructions and using reset and stop controls). If supplied a positive,
>> + * nonzero CPI parameter, also strictly check that every measurement matches
>> + * it. Strict CPI checking is used to test -icount mode.
>> + */
>> +static bool check_cpi(int cpi)
>> +{
>> +	uint32_t pmcr = pmcr_read() | PMU_PMCR_C | PMU_PMCR_E;
>> +	
>> +	if (cpi > 0)
>> +		printf("Checking for CPI=%d.\n", cpi);
>> +	printf("instrs : cycles0 cycles1 ...\n");
>> +
>> +	for (int i = 3; i < 300; i += 32) {
>> +		int avg, sum = 0;
>> +
>> +		printf("%d :", i);
>> +		for (int j = 0; j < NR_SAMPLES; j++) {
>> +			int cycles;
>> +
>> +			measure_instrs(i, pmcr);
>> +			cycles =pmccntr_read();
>                                 ^ missing space
> 
>> +			printf(" %d", cycles);
>> +
>> +			if (!cycles || (cpi > 0 && cycles != i * cpi)) {
>> +				printf("\n");
>> +				return false;
>> +			}
>> +
>> +			sum += cycles;
>> +		}
>> +		avg = sum / NR_SAMPLES;
>> +		printf(" sum=%d avg=%d avg_ipc=%d avg_cpi=%d\n",
>> +			sum, avg, i / avg, avg / i);
>> +	}
>> +
>> +	return true;
>> +}
>> +
>> +int main(int argc, char *argv[])
>>  {
>> +	int cpi = 0;
>> +
>> +	if (argc >= 1)
>> +		cpi = atol(argv[0]);
>                                 ^ should be '1', otherwise cpi is
> getting set to the string "arm/pmu.flat" pointer. How did this
> work when you tested it?

This is a bug and the value is always 0. With that said, it didn't
change the testing result: other than in printf(), cpi is only used in
"(!cycles || (cpi > 0 && cycles != i * cpi))", which is always evaluated
as FALSE. So check_cpi() won't return early incorrectly. I will fix it.

> 
>> +
>>  	report_prefix_push("pmu");
>>  
>>  	/* init for PMU event access, right now only care about cycle count */
>> @@ -166,6 +264,7 @@ int main(void)
>>  
>>  	report("Control register", check_pmcr());
>>  	report("Monotonically increasing cycle count", check_cycles_increase());
>> +	report("Cycle/instruction ratio", check_cpi(cpi));
>>  
>>  	return report_summary();
>>  }
>> diff --git a/arm/unittests.cfg b/arm/unittests.cfg
>> index 7645180..2050dc8 100644
>> --- a/arm/unittests.cfg
>> +++ b/arm/unittests.cfg
>> @@ -59,3 +59,17 @@ groups = selftest
>>  [pmu]
>>  file = pmu.flat
>>  groups = pmu
>> +
>> +# Test PMU support (TCG) with -icount IPC=1
>> +[pmu-tcg-icount-1]
>> +file = pmu.flat
>> +extra_params = -icount 0 -append '1'
>> +groups = pmu
>> +accel = tcg
>> +
>> +# Test PMU support (TCG) with -icount IPC=256
>> +[pmu-tcg-icount-256]
>> +file = pmu.flat
>> +extra_params = -icount 8 -append '256'
>> +groups = pmu
>> +accel = tcg
> 
> The unittests.cfg looks good.
> 
> Thanks,
> drew 
> 
