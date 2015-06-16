From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] arm64: KVM: Optimize arm64 guest exit VFP/SIMD register
 save/restore
Date: Tue, 16 Jun 2015 09:30:59 +0100
Message-ID: <557FDEC3.3090308@arm.com>
References: <557CACC4.8040405@samsung.com> <557EA23D.4090200@arm.com> <557F13A5.9030603@samsung.com> <557F1765.8040405@arm.com> <557F922A.6070306@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <557F922A.6070306@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: Mario Smarduch <m.smarduch@samsung.com>
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>, Catalin Marinas <Catalin.Marinas@arm.com>, Will Deacon <Will.Deacon@arm.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 16/06/15 04:04, Mario Smarduch wrote:
> On 06/15/2015 11:20 AM, Marc Zyngier wrote:
>> On 15/06/15 19:04, Mario Smarduch wrote:
>>> On 06/15/2015 03:00 AM, Marc Zyngier wrote:
>>>> Hi Mario,
>>>>
> [ ... ]
>>>>
>>>> On 13/06/15 23:20, Mario Smarduch wrote:
>>>>> Currently VFP/SIMD registers are always saved and restored
>>>>> on Guest entry and exit.
>>>>>
>>>>> This patch only saves and restores VFP/SIMD registers on
>>>>> Guest access. To do this cptr_el2 VFP/SIMD trap is set
>>>>> on Guest entry and later checked on exit. This follows
>>>>> the ARMv7 VFPv3 implementation. Running an informal test
>>>>> there are high number of exits that don't access VFP/SIMD
>>>>> registers.
>>>>
>>>> It would be good to add some numbers here. How often do we exit without
>>>> having touched the FPSIMD regs? For which workload?
>>>
>>> Lmbench is what I typically use, with ssh server, i.e., cause page
>>> faults and interrupts - usually registers are not touched.
>>> I'll run the tests again and define usually.
>>>
>>> Any other loads you had in mind?
>>
>> Not really (apart from running hackbench, of course...;-). I'd just like
>> to see the numbers in the commit message, so that we can document the
>> improvement (and maybe track regressions).
> 
> Hi Marc,
>    some ballpark numbers.
> 
>    hackbench about 30% of the time optimized path is taken
> (for 10*40 test).
> 
> Lmbench3 upwards of 50% for context switching, memory bw,
> pipe, proc creation, sys call. There are lot more tests
> but I limited to these tests. In addition other processes
> are running in background NTP, SSH, ... doing their own
> thing.
> 
> I added a tmp counter to kvm_vcpu_arch to count vfpsimd
> events.

That looks good. Please include these numbers in the commit message for
v2 of that patch.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
