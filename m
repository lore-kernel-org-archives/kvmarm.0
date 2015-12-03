From: Mario Smarduch <m.smarduch@samsung.com>
Subject: Re: [PATCH v4 1/3] KVM/arm/arm64: add hooks for armv7 fp/simd lazy
 switch support
Date: Thu, 03 Dec 2015 12:10:54 -0800
Message-ID: <5660A1CE.8010203@samsung.com>
References: <1447539130-4613-1-git-send-email-m.smarduch@samsung.com>
 <1447539130-4613-2-git-send-email-m.smarduch@samsung.com>
 <566063BE.7080005@arm.com> <56609633.3030307@samsung.com>
 <566096D6.50402@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <566096D6.50402@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, antonios.motakis@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu



On 12/3/2015 11:24 AM, Marc Zyngier wrote:
> On 03/12/15 19:21, Mario Smarduch wrote:
>>
>>
>> On 12/3/2015 7:46 AM, Marc Zyngier wrote:
>>> On 14/11/15 22:12, Mario Smarduch wrote:
>>>> This patch adds vcpu fields to track lazy state, save host FPEXC, and
>>>> offsets to fields.
>>>>
>>>> Signed-off-by: Mario Smarduch <m.smarduch@samsung.com>
>>>> ---
>>>>  arch/arm/include/asm/kvm_host.h | 6 ++++++
>>>>  arch/arm/kernel/asm-offsets.c   | 2 ++
>>>>  2 files changed, 8 insertions(+)
>>>>
>>>> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
>>>> index 3df1e97..f1bf551 100644
>>>> --- a/arch/arm/include/asm/kvm_host.h
>>>> +++ b/arch/arm/include/asm/kvm_host.h
>>>> @@ -107,6 +107,12 @@ struct kvm_vcpu_arch {
>>>>  	/* Interrupt related fields */
>>>>  	u32 irq_lines;		/* IRQ and FIQ levels */
>>>>  
>>>> +	/* fp/simd dirty flag true if guest accessed register file */
>>>> +	bool    vfp_dirty;
>>>
>>> I think we do not need this bool, because it is already represented by
>>> the state of the trapping bits.
>>
>> The trapping bit state is lost on exit since they're cleared, no?
> 
> But that's what should actually be preserved, no? At the moment, you
> maintain some side state to reflect what the trapping state is. You
> might as well keep it around all the time.

Ok I see, you should be able to preserve and use the trap registers. I'll rework
it.

> 
> Thanks,
> 
> 	M.
> 
