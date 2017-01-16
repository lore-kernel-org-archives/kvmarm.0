From: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Subject: Re: [PATCH 2/3] KVM: arm64: Access CNTHCTL_EL2 bit fields correctly
 on VHE systems
Date: Mon, 16 Jan 2017 14:19:45 +0000
Message-ID: <bab6015b-00f1-6e6a-29ee-9b35c626f692@arm.com>
References: <1484307093-29153-1-git-send-email-marc.zyngier@arm.com>
 <1484307093-29153-3-git-send-email-marc.zyngier@arm.com>
 <20170113123612.GA31994@cbox> <d496020c-a097-ffd5-adb7-7edb7c1a214e@arm.com>
 <e0d1473f-0cf9-a801-585b-4385bc5b35ab@arm.com>
 <61f7dbf1-e20d-e9e4-950c-6a224619cf31@arm.com>
 <c82f705e-c32a-15b1-92f6-d7694f91fe0e@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EC6A740421
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Jan 2017 09:17:59 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2Fl8Yh82SYFe for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 Jan 2017 09:17:59 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EBC0340187
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Jan 2017 09:17:58 -0500 (EST)
In-Reply-To: <c82f705e-c32a-15b1-92f6-d7694f91fe0e@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 16/01/17 14:11, Marc Zyngier wrote:
> On 16/01/17 13:30, Marc Zyngier wrote:
>> On 13/01/17 14:56, Suzuki K Poulose wrote:
>>> On 13/01/17 13:30, Marc Zyngier wrote:
>>>> [+ Suzuki, who wrote the whole cpus_have_const_cap thing]
>>>>
>>
>> [...]
>>
>>>> But maybe we should have have some stronger guarantees that we'll
>>>> always get things inlined, and that the "const" side is enforced:
>>>
>>> Agreed.
>>>
>>>>
>>>> diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
>>>> index b4989df..4710469 100644
>>>> --- a/arch/arm64/include/asm/cpufeature.h
>>>> +++ b/arch/arm64/include/asm/cpufeature.h
>>>> @@ -105,10 +105,11 @@ static inline bool cpu_have_feature(unsigned int num)
>>>>  }
>>>>
>>>>  /* System capability check for constant caps */
>>>> -static inline bool cpus_have_const_cap(int num)
>>>> +static __always_inline bool cpus_have_const_cap(int num)
>>>
>>> I think we should have the above change and make it inline always.
>>>
>>>>  {
>>>> -	if (num >= ARM64_NCAPS)
>>>> -		return false;
>>>> +	BUILD_BUG_ON(!__builtin_constant_p(num));
>>>
>>> This is not needed, as the compilation would fail if num is not a constant with
>>> static key code.
>
> I also just checked this, and it doesn't fail if the compiler doesn't
> directly supports jump labels (we then fallback to the static key being
> a standard memory access).

Ah, I missed that part of the story. Sorry about that. Please go ahead with the
changes. I had a similar check in my first version and was dropped later with a
similar review comment. We hadn't considered older tool chain.


Suzuki
