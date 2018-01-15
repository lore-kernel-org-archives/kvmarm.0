From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v4 03/19] arm64: asm-offsets: Remove potential circular dependency
Date: Mon, 15 Jan 2018 10:46:31 +0100
Message-ID: <CAMJs5B-mqPnxrZk6w3Utn-+WBA03WkWw4jXxcXM+k=EM0gz5Xg@mail.gmail.com>
References: <20180104184334.16571-1-marc.zyngier@arm.com> <20180104184334.16571-4-marc.zyngier@arm.com>
 <20180115083449.GD21403@cbox> <cbe5c186-1adc-ef3e-e52e-5d60548c352a@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <cbe5c186-1adc-ef3e-e52e-5d60548c352a@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, James Morse <james.morse@arm.com>, Steve Capper <steve.capper@arm.com>, Peter Maydell <peter.maydell@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jan 15, 2018 at 9:42 AM, Marc Zyngier <marc.zyngier@arm.com> wrote:
> On 15/01/18 08:34, Christoffer Dall wrote:
>> On Thu, Jan 04, 2018 at 06:43:18PM +0000, Marc Zyngier wrote:
>>> So far, we've been lucky enough that none of the include files
>>> that asm-offsets.c requires include asm-offsets.h. This is
>>> about to change, and would introduce a nasty circular dependency...
>>>
>>> Let's now guard the inclusion of asm-offsets.h so that it never
>>> gets pulled from asm-offsets.c. The same issue exists between
>>> bounce.c and include/generated/bounds.h, and is worked around
>>> by using the existing guard symbol.
>>>
>>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>>> ---
>>>  arch/arm64/include/asm/asm-offsets.h | 2 ++
>>>  arch/arm64/kernel/asm-offsets.c      | 2 ++
>>>  2 files changed, 4 insertions(+)
>>>
>>> diff --git a/arch/arm64/include/asm/asm-offsets.h b/arch/arm64/include/asm/asm-offsets.h
>>> index d370ee36a182..7d6531a81eb3 100644
>>> --- a/arch/arm64/include/asm/asm-offsets.h
>>> +++ b/arch/arm64/include/asm/asm-offsets.h
>>> @@ -1 +1,3 @@
>>> +#if !defined(__GENERATING_ASM_OFFSETS_H) && !defined(__GENERATING_BOUNDS_H)
>>
>> I don't understand why we need to check __GENERATING_BOUNDS_H here?
>> What is the interaction between asm-offsets and bounds?
>
> bound.c ends up including asm-offsets.h as well once you start adding
> the dependency between it and alternatives.h. See the report there:
>
> https://www.spinics.net/lists/arm-kernel/msg623723.html
>
> which this check addresses.
>
Ah, I see.

Thanks,
-Christoffer
