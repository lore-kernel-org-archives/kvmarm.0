From: Mario Smarduch <m.smarduch@samsung.com>
Subject: Re: [PATCH] arm64: KVM: Optimize arm64 guest exit VFP/SIMD register
 save/restore
Date: Mon, 15 Jun 2015 20:04:10 -0700
Message-ID: <557F922A.6070306@samsung.com>
References: <557CACC4.8040405@samsung.com> <557EA23D.4090200@arm.com>
 <557F13A5.9030603@samsung.com> <557F1765.8040405@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3827C551D1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Jun 2015 22:53:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LXB9yiwNVXJU for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Jun 2015 22:53:43 -0400 (EDT)
Received: from usmailout4.samsung.com (mailout4.w2.samsung.com
 [211.189.100.14])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D6B74550E2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Jun 2015 22:53:42 -0400 (EDT)
Received: from uscpsbgex3.samsung.com
 (u124.gpu85.samsung.co.kr [203.254.195.124]) by usmailout4.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NQ0008N6OJ4NG00@usmailout4.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Mon, 15 Jun 2015 23:04:16 -0400 (EDT)
In-reply-to: <557F1765.8040405@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Catalin Marinas <Catalin.Marinas@arm.com>, Will Deacon <Will.Deacon@arm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 06/15/2015 11:20 AM, Marc Zyngier wrote:
> On 15/06/15 19:04, Mario Smarduch wrote:
>> On 06/15/2015 03:00 AM, Marc Zyngier wrote:
>>> Hi Mario,
>>>
[ ... ]
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

Hi Marc,
   some ballpark numbers.

   hackbench about 30% of the time optimized path is taken
(for 10*40 test).

Lmbench3 upwards of 50% for context switching, memory bw,
pipe, proc creation, sys call. There are lot more tests
but I limited to these tests. In addition other processes
are running in background NTP, SSH, ... doing their own
thing.

I added a tmp counter to kvm_vcpu_arch to count vfpsimd
events.

- Mario
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
> 
> Thanks,
> 
> 	M.
> 
