From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 2/3] KVM: arm64: Access CNTHCTL_EL2 bit fields correctly
 on VHE systems
Date: Mon, 16 Jan 2017 14:11:58 +0000
Message-ID: <c82f705e-c32a-15b1-92f6-d7694f91fe0e@arm.com>
References: <1484307093-29153-1-git-send-email-marc.zyngier@arm.com>
 <1484307093-29153-3-git-send-email-marc.zyngier@arm.com>
 <20170113123612.GA31994@cbox> <d496020c-a097-ffd5-adb7-7edb7c1a214e@arm.com>
 <e0d1473f-0cf9-a801-585b-4385bc5b35ab@arm.com>
 <61f7dbf1-e20d-e9e4-950c-6a224619cf31@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <61f7dbf1-e20d-e9e4-950c-6a224619cf31@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Suzuki K Poulose <Suzuki.Poulose@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Eric Auger <eric.auger@redhat.com>, Jintack Lim <jintack@cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 16/01/17 13:30, Marc Zyngier wrote:
> On 13/01/17 14:56, Suzuki K Poulose wrote:
>> On 13/01/17 13:30, Marc Zyngier wrote:
>>> [+ Suzuki, who wrote the whole cpus_have_const_cap thing]
>>>
> 
> [...]
> 
>>> But maybe we should have have some stronger guarantees that we'll
>>> always get things inlined, and that the "const" side is enforced:
>>
>> Agreed.
>>
>>>
>>> diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
>>> index b4989df..4710469 100644
>>> --- a/arch/arm64/include/asm/cpufeature.h
>>> +++ b/arch/arm64/include/asm/cpufeature.h
>>> @@ -105,10 +105,11 @@ static inline bool cpu_have_feature(unsigned int num)
>>>  }
>>>
>>>  /* System capability check for constant caps */
>>> -static inline bool cpus_have_const_cap(int num)
>>> +static __always_inline bool cpus_have_const_cap(int num)
>>
>> I think we should have the above change and make it inline always.
>>
>>>  {
>>> -	if (num >= ARM64_NCAPS)
>>> -		return false;
>>> +	BUILD_BUG_ON(!__builtin_constant_p(num));
>>
>> This is not needed, as the compilation would fail if num is not a constant with
>> static key code.

I also just checked this, and it doesn't fail if the compiler doesn't
directly supports jump labels (we then fallback to the static key being
a standard memory access).

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
