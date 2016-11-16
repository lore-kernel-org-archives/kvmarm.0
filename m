From: Christopher Covington <cov@codeaurora.org>
Subject: Re: [Qemu-devel] [kvm-unit-tests PATCH v8 2/3] arm: pmu: Check cycle
 count increases
Date: Wed, 16 Nov 2016 11:41:11 -0500
Message-ID: <630ef130-0beb-2e5b-e9ef-8e032800a01c@codeaurora.org>
References: <1478629035-12938-1-git-send-email-wei@redhat.com>
 <1478629035-12938-3-git-send-email-wei@redhat.com>
 <20161111074321.5ayzmy4w7w73x4fi@hawk.localdomain>
 <cdc283e2-8905-5344-ac91-2b20e5c4980b@redhat.com>
 <20161114100510.k3pkhnyzqfraago2@kamzik.brq.redhat.com>
 <527cb90a-1c72-43df-7149-7058e988f562@codeaurora.org>
 <8e5d194e-ae4c-3a0d-b9f8-5ea1fa3d1921@redhat.com>
 <20161116130145.3x52rdlyytknclpy@kamzik.brq.redhat.com>
 <ea798994-fdb0-88b7-6097-c070ec22b8ba@codeaurora.org>
 <20161116162537.wyxo4c22uietxmz4@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F403D4022C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Nov 2016 11:40:44 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8hCSHHywqCPg for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Nov 2016 11:40:43 -0500 (EST)
Received: from smtp.codeaurora.org (smtp.codeaurora.org [198.145.29.96])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B29D34019A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Nov 2016 11:40:43 -0500 (EST)
In-Reply-To: <20161116162537.wyxo4c22uietxmz4@kamzik.brq.redhat.com>
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
Cc: alindsay@codeaurora.org, kvm@vger.kernel.org, croberts@codeaurora.org, qemu-devel@nongnu.org, alistair.francis@xilinx.com, shannon.zhao@linaro.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 11/16/2016 11:25 AM, Andrew Jones wrote:
> On Wed, Nov 16, 2016 at 11:08:42AM -0500, Christopher Covington wrote:
>> On 11/16/2016 08:01 AM, Andrew Jones wrote:
>>> On Tue, Nov 15, 2016 at 04:50:53PM -0600, Wei Huang wrote:
>>>>
>>>>
>>>> On 11/14/2016 09:12 AM, Christopher Covington wrote:
>>>>> Hi Drew, Wei,
>>>>>
>>>>> On 11/14/2016 05:05 AM, Andrew Jones wrote:
>>>>>> On Fri, Nov 11, 2016 at 01:55:49PM -0600, Wei Huang wrote:
>>>>>>>
>>>>>>>
>>>>>>> On 11/11/2016 01:43 AM, Andrew Jones wrote:
>>>>>>>> On Tue, Nov 08, 2016 at 12:17:14PM -0600, Wei Huang wrote:
>>>>>>>>> From: Christopher Covington <cov@codeaurora.org>
>>>>>>>>>
>>>>>>>>> Ensure that reads of the PMCCNTR_EL0 are monotonically increasing,
>>>>>>>>> even for the smallest delta of two subsequent reads.
>>>>>>>>>
>>>>>>>>> Signed-off-by: Christopher Covington <cov@codeaurora.org>
>>>>>>>>> Signed-off-by: Wei Huang <wei@redhat.com>
>>>>>>>>> ---
>>>>>>>>>  arm/pmu.c | 98 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>>>>>>>>  1 file changed, 98 insertions(+)
>>>>>>>>>
>>>>>>>>> diff --git a/arm/pmu.c b/arm/pmu.c
>>>>>>>>> index 0b29088..d5e3ac3 100644
>>>>>>>>> --- a/arm/pmu.c
>>>>>>>>> +++ b/arm/pmu.c
>>>>>>>>> @@ -14,6 +14,7 @@
>>>>>>>>>   */
>>>>>>>>>  #include "libcflat.h"
>>>>>>>>>  
>>>>>>>>> +#define PMU_PMCR_E         (1 << 0)
>>>>>>>>>  #define PMU_PMCR_N_SHIFT   11
>>>>>>>>>  #define PMU_PMCR_N_MASK    0x1f
>>>>>>>>>  #define PMU_PMCR_ID_SHIFT  16
>>>>>>>>> @@ -21,6 +22,10 @@
>>>>>>>>>  #define PMU_PMCR_IMP_SHIFT 24
>>>>>>>>>  #define PMU_PMCR_IMP_MASK  0xff
>>>>>>>>>  
>>>>>>>>> +#define PMU_CYCLE_IDX      31
>>>>>>>>> +
>>>>>>>>> +#define NR_SAMPLES 10
>>>>>>>>> +
>>>>>>>>>  #if defined(__arm__)
>>>>>>>>>  static inline uint32_t pmcr_read(void)
>>>>>>>>>  {
>>>>>>>>> @@ -29,6 +34,47 @@ static inline uint32_t pmcr_read(void)
>>>>>>>>>  	asm volatile("mrc p15, 0, %0, c9, c12, 0" : "=r" (ret));
>>>>>>>>>  	return ret;
>>>>>>>>>  }
>>>>>>>>> +
>>>>>>>>> +static inline void pmcr_write(uint32_t value)
>>>>>>>>> +{
>>>>>>>>> +	asm volatile("mcr p15, 0, %0, c9, c12, 0" : : "r" (value));
>>>>>>>>> +}
>>>>>>>>> +
>>>>>>>>> +static inline void pmselr_write(uint32_t value)
>>>>>>>>> +{
>>>>>>>>> +	asm volatile("mcr p15, 0, %0, c9, c12, 5" : : "r" (value));
>>>>>>>>> +}
>>>>>>>>> +
>>>>>>>>> +static inline void pmxevtyper_write(uint32_t value)
>>>>>>>>> +{
>>>>>>>>> +	asm volatile("mcr p15, 0, %0, c9, c13, 1" : : "r" (value));
>>>>>>>>> +}
>>>>>>>>> +
>>>>>>>>> +/*
>>>>>>>>> + * While PMCCNTR can be accessed as a 64 bit coprocessor register, returning 64
>>>>>>>>> + * bits doesn't seem worth the trouble when differential usage of the result is
>>>>>>>>> + * expected (with differences that can easily fit in 32 bits). So just return
>>>>>>>>> + * the lower 32 bits of the cycle count in AArch32.
>>>>>>>>
>>>>>>>> Like I said in the last review, I'd rather we not do this. We should
>>>>>>>> return the full value and then the test case should confirm the upper
>>>>>>>> 32 bits are zero.
>>>>>>>
>>>>>>> Unless I miss something in ARM documentation, ARMv7 PMCCNTR is a 32-bit
>>>>>>> register. We can force it to a more coarse-grained cycle counter with
>>>>>>> PMCR.D bit=1 (see below). But it is still not a 64-bit register.
>>>>>
>>>>> AArch32 System Register Descriptions
>>>>> Performance Monitors registers
>>>>> PMCCNTR, Performance Monitors Cycle Count Register
>>>>>
>>>>> To access the PMCCNTR when accessing as a 32-bit register:
>>>>> MRC p15,0,<Rt>,c9,c13,0 ; Read PMCCNTR[31:0] into Rt
>>>>> MCR p15,0,<Rt>,c9,c13,0 ; Write Rt to PMCCNTR[31:0]. PMCCNTR[63:32] are unchanged
>>>>>
>>>>> To access the PMCCNTR when accessing as a 64-bit register:
>>>>> MRRC p15,0,<Rt>,<Rt2>,c9 ; Read PMCCNTR[31:0] into Rt and PMCCNTR[63:32] into Rt2
>>>>> MCRR p15,0,<Rt>,<Rt2>,c9 ; Write Rt to PMCCNTR[31:0] and Rt2 to PMCCNTR[63:32]
>>>>>
>>>>
>>>> Thanks. I did some research based on your info and came back with the
>>>> following proposals (Cov, correct me if I am wrong):
>>>>
>>>> By comparing A57 TRM (page 394 in [1]) with A15 TRM (page 273 in [2]), I
>>>> think this 64-bit cycle register is only available when running under
>>>> aarch32 compatibility mode on ARMv8 because it is not specified in A15
>>>> TRM.
>>
>> That interpretation sounds really strange to me. My recollection is that the
>> cycle counter was available as a 64 bit register in ARMv7 as well. I would
>> expect the Cortex TRMs to omit such details. The ARMv7 Architecture Reference
>> Manual is the complete and authoritative source.
> 
> Yes, the v7 ARM ARM is the authoritative source, and it says 32-bit.
> Whereas the v8 ARM ARM wrt to AArch32 mode says it's both 32 and 64.

Just looked it up as well in the good old ARM DDI 0406C.c and you're absolutely
right. Sorry for the bad recollection.

Cov

-- 
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm
Technologies, Inc. Qualcomm Technologies, Inc. is a member of the Code
Aurora Forum, a Linux Foundation Collaborative Project.
