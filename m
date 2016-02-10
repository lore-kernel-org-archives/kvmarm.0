From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 07/28] ARM: KVM: Add system register accessor macros
Date: Wed, 10 Feb 2016 17:32:24 +0000
Message-ID: <56BB7428.1010506@arm.com>
References: <1454583645-10144-1-git-send-email-marc.zyngier@arm.com>
 <1454583645-10144-8-git-send-email-marc.zyngier@arm.com>
 <20160210172539.GQ5171@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20160210172539.GQ5171@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 10/02/16 17:25, Christoffer Dall wrote:
> On Thu, Feb 04, 2016 at 11:00:24AM +0000, Marc Zyngier wrote:
>> In order to move system register (CP15, mostly) access to C code,
>> add a few macros to facilitate this, and minimize the difference
>> between 32 and 64bit CP15 registers.
>>
>> This will get heavily used in the following patches.
>>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>  arch/arm/kvm/hyp/hyp.h | 15 +++++++++++++++
>>  1 file changed, 15 insertions(+)
>>
>> diff --git a/arch/arm/kvm/hyp/hyp.h b/arch/arm/kvm/hyp/hyp.h
>> index c723870..727089f 100644
>> --- a/arch/arm/kvm/hyp/hyp.h
>> +++ b/arch/arm/kvm/hyp/hyp.h
>> @@ -27,4 +27,19 @@
>>  #define kern_hyp_va(v) (v)
>>  #define hyp_kern_va(v) (v)
>>  
>> +#define __ACCESS_CP15(CRn, Op1, CRm, Op2)	\
>> +	"mrc", "mcr", __stringify(p15, Op1, %0, CRn, CRm, Op2), u32
>> +#define __ACCESS_CP15_64(Op1, CRm)		\
>> +	"mrrc", "mcrr", __stringify(p15, Op1, %Q0, %R0, CRm), u64
>> +
>> +#define __write_sysreg(v, r, w, c, t)	asm volatile(w " " c : : "r" ((t)(v)))
>> +#define write_sysreg(v, ...)		__write_sysreg(v, __VA_ARGS__)
>> +
>> +#define __read_sysreg(r, w, c, t) ({				\
>> +	t __val;						\
>> +	asm volatile(r " " c : "=r" (__val));			\
>> +	__val;							\
>> +})
>> +#define read_sysreg(...)		__read_sysreg(__VA_ARGS__)
>> +
>>  #endif /* __ARM_KVM_HYP_H__ */
>> -- 
>> 2.1.4
>>
> 
> I sort of figured that a reviewed-by tag on patches that actually use
> these macros would be an implicit review of this code.
> 
> not feeling comfortable enough that I read this jibberish perfectly in
> isolation, but given that the stuff compiles and works, I'll just ack
> it:
> 
> Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
> 

Yeah, this is admittedly cryptic. Despite my efforts, I'm still
considering C (and the preprocessor) as an evolved macro-assembler.

I guess next time, I'll rewrite it in OCaml.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
