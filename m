From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 15/16] arm/arm64: smccc: Implement SMCCC v1.1 inline
 primitive
Date: Tue, 30 Jan 2018 08:54:17 +0000
Message-ID: <84eaa3ee-6838-466a-9974-98b6092b9e6c@arm.com>
References: <20180129174559.1866-1-marc.zyngier@arm.com>
 <20180129174559.1866-16-marc.zyngier@arm.com>
 <04d16ecd-044c-fe56-f9be-78d0cb591e71@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <04d16ecd-044c-fe56-f9be-78d0cb591e71@arm.com>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Robin Murphy <robin.murphy@arm.com>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Peter Maydell <peter.maydell@linaro.org>, Christoffer Dall <christoffer.dall@linaro.org>, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Jon Masters <jcm@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 29/01/18 19:07, Robin Murphy wrote:
> On 29/01/18 17:45, Marc Zyngier wrote:
>> One of the major improvement of SMCCC v1.1 is that it only clobbers
>> the first 4 registers, both on 32 and 64bit. This means that it
>> becomes very easy to provide an inline version of the SMC call
>> primitive, and avoid performing a function call to stash the
>> registers that would otherwise be clobbered by SMCCC v1.0.
> 
> This is disgusting... I love it :D

I expected nothing less from you! ;-)

> 
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>   include/linux/arm-smccc.h | 157 ++++++++++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 157 insertions(+)
>>
>> diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
>> index dd44d8458c04..bc5843728909 100644
>> --- a/include/linux/arm-smccc.h
>> +++ b/include/linux/arm-smccc.h
>> @@ -150,5 +150,162 @@ asmlinkage void __arm_smccc_hvc(unsigned long a0, unsigned long a1,
>>   
>>   #define arm_smccc_hvc_quirk(...) __arm_smccc_hvc(__VA_ARGS__)
>>   
>> +/* SMCCC v1.1 implementation madness follows */
>> +#ifdef CONFIG_ARM64
>> +
>> +#define SMCCC_SMC_INST	"smc	#0"
>> +#define SMCCC_HVC_INST	"hvc	#0"
>> +
>> +#define __arm_smccc_1_1_prologue(inst)					\
>> +	inst "\n"							\
>> +	"cbz	%[ptr], 1f\n"						\
>> +	"stp	%x[r0], %x[r1], %[ra0]\n"				\
>> +	"stp	%x[r2], %x[r3], %[ra2]\n"				\
>> +	"1:\n"								\
>> +	: [ra0] "=Ump" (*(&___res->a0)),				\
>> +	  [ra2] "=Ump" (*(&___res->a2)),
> 
> Rather than embedding a guaranteed spill to memory, I wonder if there's 
> money in just always declaring r0-r3 as in-out operands, and propagating 
> them by value afterwards, i.e.:
> 
> 	asm(...);
> 	if (___res)
> 		*___res = (struct arm_smccc_res){ r0, r1, r2, r3 };
> 
> In theory, for sufficiently simple callers that might allow res to stay 
> in registers for its entire lifetime and give nicer codegen. It *might* 
> also simplify some of this macro machinery too, although at this point 
> in the evening I can't really tell...

I just implemented it, and this is indeed much better. In most cases,
the store gets optimized away, mostly because we either pass NULL (and
the condition is dropped) or the store doesn't need to take place as we
evaluate a condition and discard the structure, like in
check_smccc_arch_workaround_1.

In all cases, this allows for slightly reduced levels of cpp madness,
and better codegen. I also suspect it will solve Ard's register
allocation issue.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
