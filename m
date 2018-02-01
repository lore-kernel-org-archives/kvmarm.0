From: Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH v3 16/18] arm/arm64: smccc: Implement SMCCC v1.1 inline
 primitive
Date: Thu, 1 Feb 2018 14:18:00 +0000
Message-ID: <135c00ef-2ee8-550e-afdd-8a217233b6c3@arm.com>
References: <20180201114657.7323-1-marc.zyngier@arm.com>
 <20180201114657.7323-17-marc.zyngier@arm.com>
 <6082f2bf-58be-8493-013e-e27f5a0d2570@arm.com>
 <0af501c9-2481-cb42-e1da-a884f7379942@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <0af501c9-2481-cb42-e1da-a884f7379942@arm.com>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Peter Maydell <peter.maydell@linaro.org>, Christoffer Dall <christoffer.dall@linaro.org>, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Andrew Jones <drjones@redhat.com>, Hanjun Guo <guohanjun@huawei.com>, Jayachandran C <jnair@caviumnetworks.com>, Jon Masters <jcm@redhat.com>, Russell King - ARM Linux <linux@armlinux.org.uk>
List-Id: kvmarm@lists.cs.columbia.edu

On 01/02/18 13:54, Marc Zyngier wrote:
> On 01/02/18 13:34, Robin Murphy wrote:
>> On 01/02/18 11:46, Marc Zyngier wrote:
>>> One of the major improvement of SMCCC v1.1 is that it only clobbers
>>> the first 4 registers, both on 32 and 64bit. This means that it
>>> becomes very easy to provide an inline version of the SMC call
>>> primitive, and avoid performing a function call to stash the
>>> registers that would otherwise be clobbered by SMCCC v1.0.
>>>
>>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>>> ---
>>>    include/linux/arm-smccc.h | 143 ++++++++++++++++++++++++++++++++++++++++++++++
>>>    1 file changed, 143 insertions(+)
>>>
>>> diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
>>> index dd44d8458c04..575aabe85905 100644
>>> --- a/include/linux/arm-smccc.h
>>> +++ b/include/linux/arm-smccc.h
>>> @@ -150,5 +150,148 @@ asmlinkage void __arm_smccc_hvc(unsigned long a0, unsigned long a1,
>>>    
>>>    #define arm_smccc_hvc_quirk(...) __arm_smccc_hvc(__VA_ARGS__)
>>>    
>>> +/* SMCCC v1.1 implementation madness follows */
>>> +#ifdef CONFIG_ARM64
>>> +
>>> +#define SMCCC_SMC_INST	"smc	#0"
>>> +#define SMCCC_HVC_INST	"hvc	#0"
>>
>> Nit: Maybe the argument can go in the template and we just define the
>> instruction mnemonics here?
>>
>>> +
>>> +#endif
>>> +
>>> +#ifdef CONFIG_ARM
>>
>> #elif ?
> 
> Sure, why not.
> 
>>
>>> +#include <asm/opcodes-sec.h>
>>> +#include <asm/opcodes-virt.h>
>>> +
>>> +#define SMCCC_SMC_INST	__SMC(0)
>>> +#define SMCCC_HVC_INST	__HVC(0)
>>
>> Oh, I see, it was to line up with this :(
>>
>> I do wonder if we could just embed an asm(".arch armv7-a+virt\n") (if
>> even necessary) for ARM, then take advantage of the common mnemonics for
>> all 3 instruction sets instead of needing manual encoding tricks? I
>> don't think we should ever be pulling this file in for non-v7 builds.
>>
>> I suppose that strictly that appears to need binutils 2.21 rather than
>> the offical supported minimum of 2.20, but are people going to be
>> throwing SMCCC configs at antique toolchains in practice?
> 
> It has been an issue in the past, back when we merged KVM. We settled on
> a hybrid solution where code outside of KVM would not rely on a newer
> toolchain, hence the macros that Dave introduced. Maybe we've moved on
> and we can take that bold step?

Either way I think we can happily throw that on the "future cleanup" 
pile right now as it's not directly relevant to the purpose of the 
patch; I'm sure we don't want to make potential backporting even more 
difficult.

>>
>>> +
>>> +#endif
>>> +
>>> +#define ___count_args(_0, _1, _2, _3, _4, _5, _6, _7, _8, x, ...) x
>>> +
>>> +#define __count_args(...)						\
>>> +	___count_args(__VA_ARGS__, 7, 6, 5, 4, 3, 2, 1, 0)
>>> +
>>> +#define __constraint_write_0						\
>>> +	"+r" (r0), "=&r" (r1), "=&r" (r2), "=&r" (r3)
>>> +#define __constraint_write_1						\
>>> +	"+r" (r0), "+r" (r1), "=&r" (r2), "=&r" (r3)
>>> +#define __constraint_write_2						\
>>> +	"+r" (r0), "+r" (r1), "+r" (r2), "=&r" (r3)
>>> +#define __constraint_write_3						\
>>> +	"+r" (r0), "+r" (r1), "+r" (r2), "+r" (r3)
>>> +#define __constraint_write_4	__constraint_write_3
>>> +#define __constraint_write_5	__constraint_write_4
>>> +#define __constraint_write_6	__constraint_write_5
>>> +#define __constraint_write_7	__constraint_write_6
>>> +
>>> +#define __constraint_read_0
>>> +#define __constraint_read_1
>>> +#define __constraint_read_2
>>> +#define __constraint_read_3
>>> +#define __constraint_read_4	"r" (r4)
>>> +#define __constraint_read_5	__constraint_read_4, "r" (r5)
>>> +#define __constraint_read_6	__constraint_read_5, "r" (r6)
>>> +#define __constraint_read_7	__constraint_read_6, "r" (r7)
>>> +
>>> +#define __declare_arg_0(a0, res)					\
>>> +	struct arm_smccc_res   *___res = res;				\
>>
>> Looks like the declaration of ___res could simply be factored out to the
>> template...
> 
> Tried that. But...
> 
>>
>>> +	register u32           r0 asm("r0") = a0;			\
>>> +	register unsigned long r1 asm("r1");				\
>>> +	register unsigned long r2 asm("r2");				\
>>> +	register unsigned long r3 asm("r3")
>>> +
>>> +#define __declare_arg_1(a0, a1, res)					\
>>> +	struct arm_smccc_res   *___res = res;				\
>>> +	register u32           r0 asm("r0") = a0;			\
>>> +	register typeof(a1)    r1 asm("r1") = a1;			\
>>> +	register unsigned long r2 asm("r2");				\
>>> +	register unsigned long r3 asm("r3")
>>> +
>>> +#define __declare_arg_2(a0, a1, a2, res)				\
>>> +	struct arm_smccc_res   *___res = res;				\
>>> +	register u32           r0 asm("r0") = a0;			\
>>> +	register typeof(a1)    r1 asm("r1") = a1;			\
>>> +	register typeof(a2)    r2 asm("r2") = a2;			\
>>> +	register unsigned long r3 asm("r3")
>>> +
>>> +#define __declare_arg_3(a0, a1, a2, a3, res)				\
>>> +	struct arm_smccc_res   *___res = res;				\
>>> +	register u32           r0 asm("r0") = a0;			\
>>> +	register typeof(a1)    r1 asm("r1") = a1;			\
>>> +	register typeof(a2)    r2 asm("r2") = a2;			\
>>> +	register typeof(a3)    r3 asm("r3") = a3
>>> +
>>> +#define __declare_arg_4(a0, a1, a2, a3, a4, res)			\
>>> +	__declare_arg_3(a0, a1, a2, a3, res);				\
>>> +	register typeof(a4) r4 asm("r4") = a4
>>> +
>>> +#define __declare_arg_5(a0, a1, a2, a3, a4, a5, res)			\
>>> +	__declare_arg_4(a0, a1, a2, a3, a4, res);			\
>>> +	register typeof(a5) r5 asm("r5") = a5
>>> +
>>> +#define __declare_arg_6(a0, a1, a2, a3, a4, a5, a6, res)		\
>>> +	__declare_arg_5(a0, a1, a2, a3, a4, a5, res);			\
>>> +	register typeof(a6) r6 asm("r6") = a6
>>> +
>>> +#define __declare_arg_7(a0, a1, a2, a3, a4, a5, a6, a7, res)		\
>>> +	__declare_arg_6(a0, a1, a2, a3, a4, a5, a6, res);		\
>>> +	register typeof(a7) r7 asm("r7") = a7
>>> +
>>> +#define ___declare_args(count, ...) __declare_arg_ ## count(__VA_ARGS__)
>>> +#define __declare_args(count, ...)  ___declare_args(count, __VA_ARGS__)
>>> +
>>> +#define ___constraints(count)						\
>>> +	: __constraint_write_ ## count					\
>>> +	: __constraint_read_ ## count					\
>>> +	: "memory"
>>> +#define __constraints(count)	___constraints(count)
>>> +
>>> +/*
>>> + * We have an output list that is not necessarily used, and GCC feels
>>> + * entitled to optimise the whole sequence away. "volatile" is what
>>> + * makes it stick.
>>> + */
>>> +#define __arm_smccc_1_1(inst, ...)					\
>>> +	do {								\
>>> +		__declare_args(__count_args(__VA_ARGS__), __VA_ARGS__);	\
>>> +		asm volatile(inst "\n"					\
>>> +			     __constraints(__count_args(__VA_ARGS__)));	\
>>> +		if (___res)						\
>>> +			*___res = (typeof(*___res)){r0, r1, r2, r3};	\
>>
>> ...especially since there's no obvious indication of where it comes from
>> when you're looking here.
> 
> ... we don't have the variable name at all here (it is the last
> parameter, and that doesn't quite work with the idea of variadic macros...).
> 
> The alternative would be to add a set of macros that return the result
> parameter, based on the number of inputs. Not sure that's an improvement.

Ah, right, the significance of it being the *last* argument hadn't 
clicked indeed. A whole barrage of extra macros just to extract res on 
its own would be rather clunky, so let's just keep the nice streamlined 
(if ever-so-slightly non-obvious) implementation as it is and ignore my 
ramblings.

Robin.
