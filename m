From: Christopher Covington <cov@codeaurora.org>
Subject: Re: [Qemu-devel] [kvm-unit-tests PATCHv5 2/3] arm: pmu: Check
 cycle count increases
Date: Mon, 26 Oct 2015 12:04:29 -0400
Message-ID: <562E4F0D.7090001@codeaurora.org>
References: <1444662470-13045-1-git-send-email-cov@codeaurora.org> <1445873930-9058-1-git-send-email-cov@codeaurora.org> <1445873930-9058-3-git-send-email-cov@codeaurora.org> <20151026155843.GG30256@hawk.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20151026155843.GG30256@hawk.localdomain>
Sender: kvm-owner@vger.kernel.org
To: Andrew Jones <drjones@redhat.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, wei@redhat.com, alindsay@codeaurora.org, croberts@codeaurora.org, shannon.zhao@linaro.org, alistair.francis@xilinx.com
List-Id: kvmarm@lists.cs.columbia.edu

On 10/26/2015 11:58 AM, Andrew Jones wrote:
> On Mon, Oct 26, 2015 at 11:38:49AM -0400, Christopher Covington wrote:
>> Ensure that reads of the PMCCNTR_EL0 are monotonically increasing,
>> even for the smallest delta of two subsequent reads.
>>
>> Signed-off-by: Christopher Covington <cov@codeaurora.org>
>> ---
>>  arm/pmu.c | 60 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 60 insertions(+)
>>
>> diff --git a/arm/pmu.c b/arm/pmu.c
>> index 42d0ee1..c44d708 100644
>> --- a/arm/pmu.c
>> +++ b/arm/pmu.c
>> @@ -14,6 +14,8 @@
>>   */
>>  #include "libcflat.h"
>>  
>> +#define NR_SAMPLES 10
>> +
>>  #if defined(__arm__)
>>  static inline uint32_t get_pmcr(void)
>>  {
>> @@ -22,6 +24,25 @@ static inline uint32_t get_pmcr(void)
>>  	asm volatile("mrc p15, 0, %0, c9, c12, 0" : "=r" (ret));
>>  	return ret;
>>  }
>> +
>> +static inline void set_pmcr(uint32_t pmcr)
>> +{
>> +	asm volatile("mcr p15, 0, %0, c9, c12, 0" : : "r" (pmcr));
>> +}
>> +
>> +/*
>> + * While PMCCNTR can be accessed as a 64 bit coprocessor register, returning 64
>> + * bits doesn't seem worth the trouble when differential usage of the result is
>> + * expected (with differences that can easily fit in 32 bits). So just return
>> + * the lower 32 bits of the cycle count in AArch32.
>> + */
>> +static inline unsigned long get_pmccntr(void)
>> +{
>> +	unsigned long cycles;
>> +
>> +	asm volatile("mrc p15, 0, %0, c9, c13, 0" : "=r" (cycles));
>> +	return cycles;
>> +}
>>  #elif defined(__aarch64__)
>>  static inline uint32_t get_pmcr(void)
>>  {
>> @@ -30,6 +51,19 @@ static inline uint32_t get_pmcr(void)
>>  	asm volatile("mrs %0, pmcr_el0" : "=r" (ret));
>>  	return ret;
>>  }
>> +
>> +static inline void set_pmcr(uint32_t pmcr)
>> +{
>> +	asm volatile("msr pmcr_el0, %0" : : "r" (pmcr));
>> +}
>> +
>> +static inline unsigned long get_pmccntr(void)
>> +{
>> +	unsigned long cycles;
>> +
>> +	asm volatile("mrs %0, pmccntr_el0" : "=r" (cycles));
>> +	return cycles;
>> +}
>>  #endif
>>  
>>  struct pmu_data {
>> @@ -72,11 +106,37 @@ static bool check_pmcr(void)
>>  	return pmu.implementer != 0;
>>  }
>>  
>> +/*
>> + * Ensure that the cycle counter progresses between back-to-back reads.
>> + */
>> +static bool check_cycles_increase(void)
>> +{
>> +	struct pmu_data pmu = { {0} };
> 
> One set of {} is enough, and looks better.

As I tried to mention in the cover letter, that can trigger a spurious GCC
warning (https://gcc.gnu.org/bugzilla/show_bug.cgi?id=53119). But if you don't
mind, I don't mind.

> Otherwise
> Reviewed-by: Andrew Jones <drjones@redhat.com>

Thanks!

Christopher Covington

-- 
Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
