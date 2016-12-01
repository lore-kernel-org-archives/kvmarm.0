From: Wei Huang <wei@redhat.com>
Subject: Re: [Qemu-devel] [kvm-unit-tests PATCH v13 1/4] arm: Define macros
 for accessing system registers
Date: Thu, 1 Dec 2016 09:27:59 -0600
Message-ID: <f502c9c7-50dc-e62e-fbb8-7a8b82f466a0@redhat.com>
References: <1480569402-8848-1-git-send-email-wei@redhat.com>
 <1480569402-8848-2-git-send-email-wei@redhat.com>
 <20161201085903.gcc5g7x6ixxgxofl@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 24D4E4055D
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Dec 2016 10:27:15 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5hs-txRqnfdj for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Dec 2016 10:27:12 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4F8ED4047D
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Dec 2016 10:27:12 -0500 (EST)
In-Reply-To: <20161201085903.gcc5g7x6ixxgxofl@kamzik.brq.redhat.com>
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
Cc: alindsay@codeaurora.org, kvm@vger.kernel.org, andre.przywara@arm.com, croberts@codeaurora.org, qemu-devel@nongnu.org, alistair.francis@xilinx.com, kvmarm@lists.cs.columbia.edu, shannon.zhao@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu



On 12/01/2016 02:59 AM, Andrew Jones wrote:
> 
> Should this be From: Andre?
> 
> On Wed, Nov 30, 2016 at 11:16:39PM -0600, Wei Huang wrote:
>> This patch defines four macros to assist creating system register
>> accessors under both ARMv7 and AArch64:
>>    * DEFINE_GET_SYSREG32(name, ...)
>>    * DEFINE_SET_SYSREG32(name, ...)
>>    * DEFINE_GET_SYSREG64(name, ...)
>>    * DEFINE_SET_SYSREG64(name, ...)
>> These macros are translated to inline functions with consistent naming,
>> get_##name() and set_##name(), which can be used by C code directly.
>>
>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>> Signed-off-by: Wei Huang <wei@redhat.com>
>> ---
>>  lib/arm/asm/processor.h   | 37 ++++++++++++++++++++++++++++++++-----
>>  lib/arm64/asm/processor.h | 35 ++++++++++++++++++++++++++++-------
>>  2 files changed, 60 insertions(+), 12 deletions(-)
>>
>> diff --git a/lib/arm/asm/processor.h b/lib/arm/asm/processor.h
>> index f25e7ee..3ca6b42 100644
>> --- a/lib/arm/asm/processor.h
>> +++ b/lib/arm/asm/processor.h
>> @@ -33,13 +33,40 @@ static inline unsigned long current_cpsr(void)
>>  
>>  #define current_mode() (current_cpsr() & MODE_MASK)
>>  
>> -static inline unsigned int get_mpidr(void)
>> -{
>> -	unsigned int mpidr;
>> -	asm volatile("mrc p15, 0, %0, c0, c0, 5" : "=r" (mpidr));
>> -	return mpidr;
>> +#define DEFINE_GET_SYSREG32(name, opc1, crn, crm, opc2)			\
>> +static inline uint32_t get_##name(void)					\
>> +{									\
>> +	uint32_t reg;							\
>> +	asm volatile("mrc p15, " #opc1 ", %0, " #crn ", " #crm ", "	\
>> +		     #opc2 : "=r" (reg));				\
>> +	return reg;							\
>> +}
>> +
>> +#define DEFINE_SET_SYSREG32(name, opc1, crn, crm, opc2)			\
>> +static inline void set_##name(uint32_t value)				\
>> +{									\
>> +	asm volatile("mcr p15, " #opc1 ", %0, " #crn ", " #crm ", "	\
>> +		     #opc2 :: "r" (value));				\
>                            ^ nit: no space here, checkpatch would complain

Which checkpatch script you are using? I didn't find one in
kvm-unit-tests. I tried kernel's checkpatch script, but it didn't
complain anything against this patch.

>> +}
>> +

<snip>
