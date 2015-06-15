From: Mario Smarduch <m.smarduch@samsung.com>
Subject: Re: [PATCH] arm64: KVM: Optimize arm64 guest exit VFP/SIMD register
 save/restore
Date: Mon, 15 Jun 2015 11:44:11 -0700
Message-ID: <557F1CFB.8040106@samsung.com>
References: <557CACC4.8040405@samsung.com> <557EA23D.4090200@arm.com>
 <557F13A5.9030603@samsung.com> <557F1765.8040405@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <557F1765.8040405@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>, Catalin Marinas <Catalin.Marinas@arm.com>, Will Deacon <Will.Deacon@arm.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 06/15/2015 11:20 AM, Marc Zyngier wrote:
> On 15/06/15 19:04, Mario Smarduch wrote:
>> On 06/15/2015 03:00 AM, Marc Zyngier wrote:
>>> Hi Mario,
>>>
>>> I was working on a more ambitious patch series, 
>>> but we probably ought to
>>> start small, and this looks fairly sensible to me.
>>
>> Hi Marc,
>>    thanks for reviewing, I was thinking to post this
>> first and next iteration on guest access switch
>> back to host registers only upon  return to user space or
>> vCPU context switch. This should save more cycles for
>> various exits.
>>
>> Were you thinking along the same lines or something
>> altogether different?
> 
> That's mostly what I had in mind. Basically staying away from touching
> the FP registers until vcpu_put(). I had it mostly working, but
> experienced some interesting corruption cases, specially when using
> 32bit guests.
> 
>>
>>>
>>> A few minor comments below.
>>>
>>> On 13/06/15 23:20, Mario Smarduch wrote:
>>>> Currently VFP/SIMD registers are always saved and restored
>>>> on Guest entry and exit.
>>>>
>>>> This patch only saves and restores VFP/SIMD registers on
>>>> Guest access. To do this cptr_el2 VFP/SIMD trap is set
>>>> on Guest entry and later checked on exit. This follows
>>>> the ARMv7 VFPv3 implementation. Running an informal test
>>>> there are high number of exits that don't access VFP/SIMD
>>>> registers.
>>>
>>> It would be good to add some numbers here. How often do we exit without
>>> having touched the FPSIMD regs? For which workload?
>>
>> Lmbench is what I typically use, with ssh server, i.e., cause page
>> faults and interrupts - usually registers are not touched.
>> I'll run the tests again and define usually.
>>
>> Any other loads you had in mind?
> 
> Not really (apart from running hackbench, of course...;-). I'd just like
> to see the numbers in the commit message, so that we can document the
> improvement (and maybe track regressions).

Ok I understand.

> 
> [...]
> 
>>>
>>>>  	skip_debug_state x3, 1f
>>>>  	// Clear the dirty flag for the next run, as all the state has
>>>>  	// already been saved. Note that we nuke the whole 64bit word.
>>>> @@ -1166,6 +1211,10 @@ el1_sync:					// Guest trapped into EL2
>>>>  	mrs	x1, esr_el2
>>>>  	lsr	x2, x1, #ESR_ELx_EC_SHIFT
>>>>
>>>> +	/* Guest accessed VFP/SIMD registers, save host, restore Guest */
>>>> +	cmp	x2, #ESR_ELx_EC_FP_ASIMD
>>>> +	b.eq	switch_to_guest_vfp
>>>> +
>>>
>>> I'd prefer you moved that hunk to el1_trap, where we handle all the
>>> traps coming from the guest.
>>
>> I'm thinking would it make sense to update the armv7 side as
>> well. When reading both exit handlers the flow mirrors
>> each other.
> 
> The 32bit code is starting to show its age, and could probably do with a
> refactor. If you have some cycles to spare, that'd be quite interesting.

Yep, will do, ARMv7 is still very relevant.

> 
> Thanks,
> 
> 	M.
> 

