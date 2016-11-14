From: Christopher Covington <cov@codeaurora.org>
Subject: Re: [Qemu-devel] [kvm-unit-tests PATCH v8 2/3] arm: pmu: Check cycle
 count increases
Date: Mon, 14 Nov 2016 10:12:35 -0500
Message-ID: <527cb90a-1c72-43df-7149-7058e988f562@codeaurora.org>
References: <1478629035-12938-1-git-send-email-wei@redhat.com>
 <1478629035-12938-3-git-send-email-wei@redhat.com>
 <20161111074321.5ayzmy4w7w73x4fi@hawk.localdomain>
 <cdc283e2-8905-5344-ac91-2b20e5c4980b@redhat.com>
 <20161114100510.k3pkhnyzqfraago2@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20161114100510.k3pkhnyzqfraago2@kamzik.brq.redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Andrew Jones <drjones@redhat.com>, Wei Huang <wei@redhat.com>
Cc: alindsay@codeaurora.org, kvm@vger.kernel.org, croberts@codeaurora.org, qemu-devel@nongnu.org, alistair.francis@xilinx.com, kvmarm@lists.cs.columbia.edu, shannon.zhao@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Drew, Wei,

On 11/14/2016 05:05 AM, Andrew Jones wrote:
> On Fri, Nov 11, 2016 at 01:55:49PM -0600, Wei Huang wrote:
>>
>>
>> On 11/11/2016 01:43 AM, Andrew Jones wrote:
>>> On Tue, Nov 08, 2016 at 12:17:14PM -0600, Wei Huang wrote:
>>>> From: Christopher Covington <cov@codeaurora.org>
>>>>
>>>> Ensure that reads of the PMCCNTR_EL0 are monotonically increasing,
>>>> even for the smallest delta of two subsequent reads.
>>>>
>>>> Signed-off-by: Christopher Covington <cov@codeaurora.org>
>>>> Signed-off-by: Wei Huang <wei@redhat.com>
>>>> ---
>>>>  arm/pmu.c | 98 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>>>  1 file changed, 98 insertions(+)
>>>>
>>>> diff --git a/arm/pmu.c b/arm/pmu.c
>>>> index 0b29088..d5e3ac3 100644
>>>> --- a/arm/pmu.c
>>>> +++ b/arm/pmu.c
>>>> @@ -14,6 +14,7 @@
>>>>   */
>>>>  #include "libcflat.h"
>>>>  
>>>> +#define PMU_PMCR_E         (1 << 0)
>>>>  #define PMU_PMCR_N_SHIFT   11
>>>>  #define PMU_PMCR_N_MASK    0x1f
>>>>  #define PMU_PMCR_ID_SHIFT  16
>>>> @@ -21,6 +22,10 @@
>>>>  #define PMU_PMCR_IMP_SHIFT 24
>>>>  #define PMU_PMCR_IMP_MASK  0xff
>>>>  
>>>> +#define PMU_CYCLE_IDX      31
>>>> +
>>>> +#define NR_SAMPLES 10
>>>> +
>>>>  #if defined(__arm__)
>>>>  static inline uint32_t pmcr_read(void)
>>>>  {
>>>> @@ -29,6 +34,47 @@ static inline uint32_t pmcr_read(void)
>>>>  	asm volatile("mrc p15, 0, %0, c9, c12, 0" : "=r" (ret));
>>>>  	return ret;
>>>>  }
>>>> +
>>>> +static inline void pmcr_write(uint32_t value)
>>>> +{
>>>> +	asm volatile("mcr p15, 0, %0, c9, c12, 0" : : "r" (value));
>>>> +}
>>>> +
>>>> +static inline void pmselr_write(uint32_t value)
>>>> +{
>>>> +	asm volatile("mcr p15, 0, %0, c9, c12, 5" : : "r" (value));
>>>> +}
>>>> +
>>>> +static inline void pmxevtyper_write(uint32_t value)
>>>> +{
>>>> +	asm volatile("mcr p15, 0, %0, c9, c13, 1" : : "r" (value));
>>>> +}
>>>> +
>>>> +/*
>>>> + * While PMCCNTR can be accessed as a 64 bit coprocessor register, returning 64
>>>> + * bits doesn't seem worth the trouble when differential usage of the result is
>>>> + * expected (with differences that can easily fit in 32 bits). So just return
>>>> + * the lower 32 bits of the cycle count in AArch32.
>>>
>>> Like I said in the last review, I'd rather we not do this. We should
>>> return the full value and then the test case should confirm the upper
>>> 32 bits are zero.
>>
>> Unless I miss something in ARM documentation, ARMv7 PMCCNTR is a 32-bit
>> register. We can force it to a more coarse-grained cycle counter with
>> PMCR.D bit=1 (see below). But it is still not a 64-bit register.

AArch32 System Register Descriptions
Performance Monitors registers
PMCCNTR, Performance Monitors Cycle Count Register

To access the PMCCNTR when accessing as a 32-bit register:
MRC p15,0,<Rt>,c9,c13,0 ; Read PMCCNTR[31:0] into Rt
MCR p15,0,<Rt>,c9,c13,0 ; Write Rt to PMCCNTR[31:0]. PMCCNTR[63:32] are unchanged

To access the PMCCNTR when accessing as a 64-bit register:
MRRC p15,0,<Rt>,<Rt2>,c9 ; Read PMCCNTR[31:0] into Rt and PMCCNTR[63:32] into Rt2
MCRR p15,0,<Rt>,<Rt2>,c9 ; Write Rt to PMCCNTR[31:0] and Rt2 to PMCCNTR[63:32]

Regards,
Cov

-- 
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm
Technologies, Inc. Qualcomm Technologies, Inc. is a member of the Code
Aurora Forum, a Linux Foundation Collaborative Project.
