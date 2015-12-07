From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3 01/22] arm64: Add macros to read/write system registers
Date: Mon, 07 Dec 2015 17:51:55 +0000
Message-ID: <5665C73B.8080602@arm.com>
References: <1449485618-9443-1-git-send-email-marc.zyngier@arm.com> <1449485618-9443-2-git-send-email-marc.zyngier@arm.com> <20151207173520.GJ7083@e104818-lin.cambridge.arm.com> <20151207174537.GD28024@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20151207174537.GD28024@leverpostej>
Sender: kvm-owner@vger.kernel.org
To: Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Steve Capper <Steve.Capper@linaro.org>, kvm@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, =?windows-1252?Q?Alex_Benn=E9e?= <alex.bennee@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 07/12/15 17:45, Mark Rutland wrote:
> On Mon, Dec 07, 2015 at 05:35:20PM +0000, Catalin Marinas wrote:
>> On Mon, Dec 07, 2015 at 10:53:17AM +0000, Marc Zyngier wrote:
>>> From: Mark Rutland <mark.rutland@arm.com>
>>>
>>> Rather than crafting custom macros for reading/writing each system
>>> register provide generics accessors, read_sysreg and write_sysreg, for
>>> this purpose.
>>>
>>> Unlike read_cpuid, calls to read_exception_reg are never expected
>>> to be optimized away or replaced with synthetic values.
>>
>> What's read_exception_reg? Is it a macro somewhere?
> 
> That was what read_sysreg used to be called on a local branch of mine. I
> didn't spot that when reworking the patch.
> 
> So s/read_exception_reg/read_sysreg/ here.
> 
>>> +#define read_sysreg(r) ({					\
>>> +	u64 __val;						\
>>> +	asm volatile("mrs %0, " __stringify(r) : "=r" (__val));	\
>>> +	__val;							\
>>> +})
>>
>> And maybe a comment here on why this is always volatile.
> 
> Makes sense to me.
> 
> Marc, are you happy to turn the last sentence from the commit message
> into a comment here (with the substitution)?

Sure, I'll update the patch and push the branch out again, together with
Catalin's Ack.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
