From: Christopher Covington <cov@codeaurora.org>
Subject: Re: [PATCH v3 3/5] arm64: Create and use __tlbi_dsb() macros
Date: Fri, 13 Jan 2017 10:12:36 -0500
Message-ID: <8f8057f5-d33f-15b3-de9f-6e718c23e97d@codeaurora.org>
References: <20170111144118.17062-1-cov@codeaurora.org>
 <20170111144118.17062-3-cov@codeaurora.org> <20170112165852.GH13843@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 25B4640665
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Jan 2017 10:11:06 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3mj3bzzifejT for <kvmarm@lists.cs.columbia.edu>;
 Fri, 13 Jan 2017 10:11:05 -0500 (EST)
Received: from smtp.codeaurora.org (smtp.codeaurora.org [198.145.29.96])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 193C7402EC
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Jan 2017 10:11:04 -0500 (EST)
In-Reply-To: <20170112165852.GH13843@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Will Deacon <will.deacon@arm.com>
Cc: Mark Langsdorf <mlangsdo@redhat.com>, Jon Masters <jcm@redhat.com>, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, timur@codeaurora.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi Will,

On 01/12/2017 11:58 AM, Will Deacon wrote:
> Hi Christopher,
> 
> On Wed, Jan 11, 2017 at 09:41:16AM -0500, Christopher Covington wrote:
>> This refactoring will allow an errata workaround that repeats tlbi dsb
>> sequences to only change one location. This is not intended to change the
>> generated assembly and comparison of before and after preprocessor output
>> of arch/arm64/mm/mmu.c and vmlinux objdump shows no functional changes.
>>
>> Signed-off-by: Christopher Covington <cov@codeaurora.org>
>> ---
>>  arch/arm64/include/asm/tlbflush.h | 104 +++++++++++++++++++++++++-------------
>>  1 file changed, 69 insertions(+), 35 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/tlbflush.h b/arch/arm64/include/asm/tlbflush.h
>> index deab523..f28813c 100644
>> --- a/arch/arm64/include/asm/tlbflush.h
>> +++ b/arch/arm64/include/asm/tlbflush.h
>> @@ -25,22 +25,69 @@
>>  #include <asm/cputype.h>
>>  
>>  /*
>> - * Raw TLBI operations.
>> + * Raw TLBI, DSB operations
>>   *
>> - * Where necessary, use the __tlbi() macro to avoid asm()
>> - * boilerplate. Drivers and most kernel code should use the TLB
>> - * management routines in preference to the macro below.
>> + * Where necessary, use __tlbi_*dsb() macros to avoid asm() boilerplate.
>> + * Drivers and most kernel code should use the TLB management routines in
>> + * preference to the macros below.
>>   *
>> - * The macro can be used as __tlbi(op) or __tlbi(op, arg), depending
>> - * on whether a particular TLBI operation takes an argument or
>> - * not. The macros handles invoking the asm with or without the
>> - * register argument as appropriate.
>> + * The __tlbi_dsb() macro handles invoking the asm without any register
>> + * argument, with a single register argument, and with start (included)
>> + * and end (excluded) range of register arguments. For example:
>> + *
>> + * __tlbi_dsb(op, attr)
>> + *
>> + * 	tlbi op
>> + *	dsb attr
>> + *
>> + * __tlbi_dsb(op, attr, addr)
>> + *
>> + *	mov %[addr], =addr
>> + *	tlbi op, %[addr]
>> + *	dsb attr
>> + *
>> + * __tlbi_range_dsb(op, attr, start, end)
>> + *
>> + * 	mov %[arg], =start
>> + *	mov %[end], =end
>> + * for:
>> + * 	tlbi op, %[addr]
>> + * 	add %[addr], %[addr], #(1 << (PAGE_SHIFT - 12))
>> + * 	cmp %[addr], %[end]
>> + * 	b.ne for
>> + * 	dsb attr
>>   */
>> -#define __TLBI_0(op, arg)		asm ("tlbi " #op)
>> -#define __TLBI_1(op, arg)		asm ("tlbi " #op ", %0" : : "r" (arg))
>> -#define __TLBI_N(op, arg, n, ...)	__TLBI_##n(op, arg)
>>  
>> -#define __tlbi(op, ...)		__TLBI_N(op, ##__VA_ARGS__, 1, 0)
>> +#define __TLBI_FOR_0(ig0, ig1, ig2)
>> +#define __TLBI_INSTR_0(op, ig1, ig2)	"tlbi " #op
>> +#define __TLBI_IO_0(ig0, ig1, ig2)	: :
>> +
>> +#define __TLBI_FOR_1(ig0, ig1, ig2)
>> +#define __TLBI_INSTR_1(op, ig0, ig1)	"tlbi " #op ", %0"
>> +#define __TLBI_IO_1(ig0, arg, ig1)	: : "r" (arg)
>> +
>> +#define __TLBI_FOR_2(ig0, start, ig1)	unsigned long addr;		       \
>> +					for (addr = start; addr < end;	       \
>> +						addr += 1 << (PAGE_SHIFT - 12))
>> +#define __TLBI_INSTR_2(op, ig0, ig1)	"tlbi " #op ", %0"
>> +#define __TLBI_IO_2(ig0, ig1, ig2)	: : "r" (addr)
>> +
>> +#define __TLBI_FOR_N(op, a1, a2, n, ...)	__TLBI_FOR_##n(op, a1, a2)
>> +#define __TLBI_INSTR_N(op, a1, a2, n, ...)	__TLBI_INSTR_##n(op, a1, a2)
>> +#define __TLBI_IO_N(op, a1, a2, n, ...)	__TLBI_IO_##n(op, a1, a2)
>> +
>> +#define __TLBI_FOR(op, ...)		__TLBI_FOR_N(op, ##__VA_ARGS__, 2, 1, 0)
>> +#define __TLBI_INSTR(op, ...)		__TLBI_INSTR_N(op, ##__VA_ARGS__, 2, 1, 0)
>> +#define __TLBI_IO(op, ...)		__TLBI_IO_N(op, ##__VA_ARGS__, 2, 1, 0)
>> +
>> +#define __tlbi_asm_dsb(as, op, attr, ...) do {				       \
>> +		__TLBI_FOR(op, ##__VA_ARGS__)				       \
>> +			asm (__TLBI_INSTR(op, ##__VA_ARGS__)		       \
>> +			__TLBI_IO(op, ##__VA_ARGS__));			       \
>> +		asm volatile (	     as			"\ndsb " #attr "\n"    \
>> +		: : : "memory"); } while (0)
>> +
>> +#define __tlbi_dsb(...)	__tlbi_asm_dsb("", ##__VA_ARGS__)
> 
> I can't deny that this is cool, but ultimately it's completely unreadable.
> What I was thinking you'd do would be make __tlbi expand to:
> 
>   tlbi
>   dsb
>   tlbi
>   dsb
> 
> for Falkor, and:
> 
>   tlbi
>   nop
>   nop
>   nop
> 
> for everybody else.

Thanks for the suggestion. So would __tlbi take a dsb sharability argument in
your proposal? Or would it be communicated in some other fashion, maybe inferred
from the tlbi argument? Or would the workaround dsbs all be the worst/broadest
case?

> Wouldn't that localise this change sufficiently that you wouldn't need
> to change all the callers and encode the looping in your cpp macros?
> 
> I realise you get an extra dsb in some places with that change, but I'd
> like to see numbers for the impact of that on top of the workaround. If
> it's an issue, then an alternative sequence would be:
> 
>   tlbi
>   dsb
>   tlbi
> 
> and you'd rely on the existing dsb to complete that.
> 
> Having said that, I don't understand how your current loop code works
> when the workaround is applied. AFAICT, you end up emitting something
> like:
> 
> dsb ishst
> for i in 0 to n
> 	tlbi va+i
> dsb
> tlbi va+n
> dsb
> 
> which looks wrong to me. Am I misreading something here?

You're right, I am off by 1 << (PAGE_SHIFT - 12) here. I would need to
increment, compare, not take the loop branch (regular for loop stuff),
then decrement (missing) and perform TLB invalidation again (present but
using incorrect value).

Thanks,
Cov

-- 
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm
Technologies, Inc. Qualcomm Technologies, Inc. is a member of the Code
Aurora Forum, a Linux Foundation Collaborative Project.
