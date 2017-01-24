From: Christopher Covington <cov@codeaurora.org>
Subject: Re: [PATCH v3 3/5] arm64: Create and use __tlbi_dsb() macros
Date: Tue, 24 Jan 2017 17:03:59 -0500
Message-ID: <968e0d85-164d-36ff-8f00-bee6ff2e875e@codeaurora.org>
References: <20170111144118.17062-1-cov@codeaurora.org>
 <20170111144118.17062-3-cov@codeaurora.org> <20170112165852.GH13843@arm.com>
 <8f8057f5-d33f-15b3-de9f-6e718c23e97d@codeaurora.org>
 <20170113161209.GI3253@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B6EDE400E9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Jan 2017 17:03:58 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VdICxXz0z4lH for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 Jan 2017 17:03:56 -0500 (EST)
Received: from smtp.codeaurora.org (smtp.codeaurora.org [198.145.29.96])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 931E140064
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Jan 2017 17:03:56 -0500 (EST)
In-Reply-To: <20170113161209.GI3253@arm.com>
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
Cc: Mark Langsdorf <mlangsdo@redhat.com>, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Jon Masters <jcm@redhat.com>, timur@codeaurora.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Catalin Marinas <catalin.marinas@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi Will,

On 01/13/2017 11:12 AM, Will Deacon wrote:
> On Fri, Jan 13, 2017 at 10:12:36AM -0500, Christopher Covington wrote:
>> On 01/12/2017 11:58 AM, Will Deacon wrote:
>>> On Wed, Jan 11, 2017 at 09:41:16AM -0500, Christopher Covington wrote:
>>>> +#define __tlbi_asm_dsb(as, op, attr, ...) do {				       \
>>>> +		__TLBI_FOR(op, ##__VA_ARGS__)				       \
>>>> +			asm (__TLBI_INSTR(op, ##__VA_ARGS__)		       \
>>>> +			__TLBI_IO(op, ##__VA_ARGS__));			       \
>>>> +		asm volatile (	     as			"\ndsb " #attr "\n"    \
>>>> +		: : : "memory"); } while (0)
>>>> +
>>>> +#define __tlbi_dsb(...)	__tlbi_asm_dsb("", ##__VA_ARGS__)
>>>
>>> I can't deny that this is cool, but ultimately it's completely unreadable.
>>> What I was thinking you'd do would be make __tlbi expand to:
>>>
>>>   tlbi
>>>   dsb
>>>   tlbi
>>>   dsb
>>>
>>> for Falkor, and:
>>>
>>>   tlbi
>>>   nop
>>>   nop
>>>   nop
>>>
>>> for everybody else.

I've implemented this (minus the last dsb / nop) in the next revision.

>> Thanks for the suggestion. So would __tlbi take a dsb sharability argument in
>> your proposal? Or would it be communicated in some other fashion, maybe inferred
>> from the tlbi argument? Or would the workaround dsbs all be the worst/broadest
>> case?
> 
> I think always using inner-shareable should be ok. If you wanted to optimise
> this, you'd want to avoid the workaround altogether for non-shareable
> invalidation, but that's fairly rare and I doubt you'd be able to measure
> the impact.

I did not originally notice that Shanker's original workaround implementation
unnecessarily applies the workaround to non-shareable invalidations. They're
not affected by the erratum. But as you say, it's simpler to modify __tlbi for
all cases. I'm not currently worried about that performance impact.

>>> Wouldn't that localise this change sufficiently that you wouldn't need
>>> to change all the callers and encode the looping in your cpp macros?
>>>
>>> I realise you get an extra dsb in some places with that change, but I'd
>>> like to see numbers for the impact of that on top of the workaround. If
>>> it's an issue, then an alternative sequence would be:
>>>
>>>   tlbi
>>>   dsb
>>>   tlbi
>>>
>>> and you'd rely on the existing dsb to complete that.
>>>
>>> Having said that, I don't understand how your current loop code works
>>> when the workaround is applied. AFAICT, you end up emitting something
>>> like:
>>>
>>> dsb ishst
>>> for i in 0 to n
>>> 	tlbi va+i
>>> dsb
>>> tlbi va+n
>>> dsb
>>>
>>> which looks wrong to me. Am I misreading something here?
>>
>> You're right, I am off by 1 << (PAGE_SHIFT - 12) here. I would need to
>> increment, compare, not take the loop branch (regular for loop stuff),
>> then decrement (missing) and perform TLB invalidation again (present but
>> using incorrect value).
> 
> It also strikes me as odd that you only need one extra TLBI after the loop
> has finished, as opposed to a tlbi; dsb; tlbi loop body (which is what you'd
> get if you modified __tlbi as I suggest).
> 
> Is it sufficient to have one extra TLBI after the loop and, if so, is the
> performance impact of my suggestion therefore unacceptable?

One is sufficient according to the errata documentation. I've described that
aspect in the commit message of the next revision.

I've suggested colleagues follow up regarding performance. But reliable
functionality comes first.

Thanks,
Cov

-- 
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm
Technologies, Inc. Qualcomm Technologies, Inc. is a member of the Code
Aurora Forum, a Linux Foundation Collaborative Project.
