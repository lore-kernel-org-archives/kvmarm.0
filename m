From: Amit Daniel Kachhap <amit.kachhap@arm.com>
Subject: Re: [PATCH v5 1/5] arm64: Add utilities to save restore pointer
 authentication keys
Date: Thu, 14 Feb 2019 16:23:53 +0530
Message-ID: <41ab78a2-b2c0-61e9-e582-f2174d4203b5@arm.com>
References: <1548658727-14271-1-git-send-email-amit.kachhap@arm.com>
 <1548658727-14271-2-git-send-email-amit.kachhap@arm.com>
 <88ccd568-f027-6cdf-b4f1-6709d76102c1@arm.com>
 <adbeb25c-fa88-41fd-7819-5f412a762b64@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <adbeb25c-fa88-41fd-7819-5f412a762b64@arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Kristina Martsenko <kristina.martsenko@arm.com>, James Morse <james.morse@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, Dave Martin <Dave.Martin@arm.com>, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 2/13/19 11:02 PM, Kristina Martsenko wrote:
> On 31/01/2019 16:20, James Morse wrote:
>> Hi Amit,
>>
>> On 28/01/2019 06:58, Amit Daniel Kachhap wrote:
>>> The keys can be switched either inside an assembly or such
>>> functions which do not have pointer authentication checks, so a GCC
>>> attribute is added to enable it.
>>>
>>> A function ptrauth_keys_store is added which is similar to existing
>>> function ptrauth_keys_switch but saves the key values in memory.
>>> This may be useful for save/restore scenarios when CPU changes
>>> privilege levels, suspend/resume etc.
>>
>>
>>> diff --git a/arch/arm64/include/asm/pointer_auth.h b/arch/arm64/include/asm/pointer_auth.h
>>> index 15d4951..98441ce 100644
>>> --- a/arch/arm64/include/asm/pointer_auth.h
>>> +++ b/arch/arm64/include/asm/pointer_auth.h
>>> @@ -11,6 +11,13 @@
>>>   
>>>   #ifdef CONFIG_ARM64_PTR_AUTH
>>>   /*
>>> + * Compile the function without pointer authentication instructions. This
>>> + * allows pointer authentication to be enabled/disabled within the function
>>> + * (but leaves the function unprotected by pointer authentication).
>>> + */
>>> +#define __no_ptrauth	__attribute__((target("sign-return-address=none")))
>>
>> The documentation[0] for this says 'none' is the default. Will this only
>> take-effect once the kernel supports pointer-auth for the host? (Is this just
>> documentation until then?)
> 
> Yes, I don't think this should be in this series, since we're not
> building the kernel with pointer auth yet.
I added it to stress on some functions which should be pointer 
authentication safe. Yes this can be dropped and a small comment may 
also do.

//Amit D
> 
>>
>> ('noptrauth' would fit with 'notrace' slightly better)
> 
> (But worse with e.g. __noreturn, __notrace_funcgraph, __init,
> __always_inline, __exception. Not sure what the pattern is. Would
> __noptrauth be better?)
> 
> Thanks,
> Kristina
> 
>>
>> [0]
>> https://gcc.gnu.org/onlinedocs/gcc/AArch64-Function-Attributes.html#AArch64-Function-Attributes
>>
> 
