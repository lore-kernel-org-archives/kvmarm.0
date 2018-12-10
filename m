From: Steven Price <steven.price@arm.com>
Subject: Re: [PATCH 03/12] arm/arm64: Provide a wrapper for SMCCC 1.1 calls
Date: Mon, 10 Dec 2018 13:52:17 +0000
Message-ID: <32c77d11-047d-cc78-7be2-9a7a72b08deb@arm.com>
References: <20181128144527.44710-1-steven.price@arm.com>
 <20181128144527.44710-4-steven.price@arm.com>
 <20181210102736.2iluzzfuryfnf4rk@lakrids.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E39D24A1D8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Dec 2018 08:52:22 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mlcnUoPAQcJY for <kvmarm@lists.cs.columbia.edu>;
 Mon, 10 Dec 2018 08:52:21 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 45F5149F87
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Dec 2018 08:52:21 -0500 (EST)
In-Reply-To: <20181210102736.2iluzzfuryfnf4rk@lakrids.cambridge.arm.com>
Content-Language: en-GB
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Mark Rutland <mark.rutland@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 10/12/2018 10:27, Mark Rutland wrote:
> On Wed, Nov 28, 2018 at 02:45:18PM +0000, Steven Price wrote:
>> SMCCC 1.1 calls may use either HVC or SMC depending on the PSCI
>> conduit. Rather than coding this in every call site provide a macro
>> which uses the correct instruction. The macro also handles the case
>> where no PSCI conduit is configured returning a not supported error
>> in res, along with returning the conduit used for the call.
>>
>> This allow us to remove some duplicated code and will be useful later
>> when adding paravirtualized time hypervisor calls.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>>  include/linux/arm-smccc.h | 44 +++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 44 insertions(+)
>>
>> diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
>> index 18863d56273c..b047009e7a0a 100644
>> --- a/include/linux/arm-smccc.h
>> +++ b/include/linux/arm-smccc.h
>> @@ -311,5 +311,49 @@ asmlinkage void __arm_smccc_hvc(unsigned long a0, unsigned long a1,
>>  #define SMCCC_RET_NOT_SUPPORTED			-1
>>  #define SMCCC_RET_NOT_REQUIRED			-2
>>  
>> +/* Like arm_smccc_1_1* but always returns SMCCC_RET_NOT_SUPPORTED.
>> + * Used when the PSCI conduit is not defined. The empty asm statement
>> + * avoids compiler warnings about unused variables.
>> + */
>> +#define __fail_smccc_1_1(...)						\
>> +	do {								\
>> +		__declare_args(__count_args(__VA_ARGS__), __VA_ARGS__);	\
>> +		asm ("" __constraints(__count_args(__VA_ARGS__)));	\
>> +		if (___res)						\
>> +			___res->a0 = SMCCC_RET_NOT_SUPPORTED;		\
>> +	} while (0)
>> +
>> +/*
>> + * arm_smccc_1_1() - make an SMCCC v1.1 compliant call
>> + *
>> + * This is a variadic macro taking one to eight source arguments, and
>> + * an optional return structure.
>> + *
>> + * @a0-a7: arguments passed in registers 0 to 7
>> + * @res: result values from registers 0 to 3
>> + *
>> + * This macro will make either an HVC call or an SMC call depending on the
>> + * current PSCI conduit. If no valid conduit is available then -1
>> + * (SMCCC_RET_NOT_SUPPORTED) is returned in @res.a0 (if supplied).
>> + *
>> + * The return value also provides the conduit that was used.
>> + */
>> +#define arm_smccc_1_1(...) ({						\
> 
> As a minor nit, could we please give call this something like
> arm_smccc_1_1_call() or arm_smccc_1_1_invoke(), to make it clear what
> action this performs?

Sure, arm_smccc_1_1_call() works for me.

> I had some patches [1] cleaning up the SMCCC API, it would be nice if we
> could pick up some of those as preparatory bits, before we spread some
> of the current design warts (e.g. SMCCC depending on PSCI definitions).

Looks like a similar approach, just extended to include
s/PSCI_CONDUIT/SMCCC_CONDUIT/ and making arm_smccc_1_1_* return res.
Would you like me to drop this (and the next) patch in favour of yours?

Thanks,

Steve

> Thanks,
> Mark.
> 
> [1] git://git.kernel.org/pub/scm/linux/kernel/git/mark/linux.git arm64/smccc-cleanup
> 
>> +		int method = psci_ops.conduit;				\
>> +		switch (method) {					\
>> +		case PSCI_CONDUIT_HVC:					\
>> +			arm_smccc_1_1_hvc(__VA_ARGS__);			\
>> +			break;						\
>> +		case PSCI_CONDUIT_SMC:					\
>> +			arm_smccc_1_1_smc(__VA_ARGS__);			\
>> +			break;						\
>> +		default:						\
>> +			__fail_smccc_1_1(__VA_ARGS__);			\
>> +			method = PSCI_CONDUIT_NONE;			\
>> +			break;						\
>> +		}							\
>> +		method;							\
>> +	})
>> +
>>  #endif /*__ASSEMBLY__*/
>>  #endif /*__LINUX_ARM_SMCCC_H*/
>> -- 
>> 2.19.2
>>
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
> 
