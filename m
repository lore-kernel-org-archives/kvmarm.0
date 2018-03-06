From: Shanker Donthineni <shankerd@codeaurora.org>
Subject: Re: [PATCH v6] arm64: Add support for new control bits CTR_EL0.DIC
 and CTR_EL0.IDC
Date: Tue, 6 Mar 2018 13:33:00 -0600
Message-ID: <dbc6e162-d245-a685-8bfe-f506d18e19e3@codeaurora.org>
References: <1519877640-11944-1-git-send-email-shankerd@codeaurora.org>
 <20180306134405.GB18080@arm.com>
 <d6182273-c23a-c4fa-ce40-c87055bfb338@codeaurora.org>
 <20180306152318.GE17454@arm.com>
 <cbdce6fd-a1db-4f12-ccea-adfe9fe7c057@codeaurora.org>
Reply-To: shankerd@codeaurora.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cbdce6fd-a1db-4f12-ccea-adfe9fe7c057@codeaurora.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Will Deacon <will.deacon@arm.com>
Cc: Philip Elcan <pelcan@codeaurora.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, linux-kernel <linux-kernel@vger.kernel.org>, Robin Murphy <robin.murphy@arm.com>, kvmarm <kvmarm@lists.cs.columbia.edu>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Will,

On 03/06/2018 12:48 PM, Shanker Donthineni wrote:
> Hi Will,
> 
> On 03/06/2018 09:23 AM, Will Deacon wrote:
>> Hi Shanker,
>>
>> On Tue, Mar 06, 2018 at 08:47:27AM -0600, Shanker Donthineni wrote:
>>> On 03/06/2018 07:44 AM, Will Deacon wrote:
>>>> I think this is a slight asymmetry with the code for the I-side. On the
>>>> I-side, you hook into invalidate_icache_by_line, whereas on the D-side you
>>>> hook into the callers of dcache_by_line_op. Why is that?
>>>>
>>>
>>> There is no particular reason other than complexity of the macro with another 
>>> alternative. I tried to avoid this change by updating __clean_dcache_area_pou().
>>> I can change if you're interested to see both I-Side and D-Side changes are
>>> symmetric some thing like this...
>>>
>>>  .macro dcache_by_line_op op, domain, kaddr, size, tmp1, tmp2
>>>   
>>>   .if	(\op == cvau)
>>>   alternative_if ARM64_HAS_CACHE_IDC
>>>         dsb	ishst
>>>         b       9997f
>>>   alternative_else_nop_endif
>>>   .endif
>>>
>>> 	dcache_line_size \tmp1, \tmp2
>>> 	add	\size, \kaddr, \size
>>> 	sub	\tmp2, \tmp1, #1
>>> 	bic	\kaddr, \kaddr, \tmp2
>>>  9998:
>>> 	.if	(\op == cvau || \op == cvac)
>>>  alternative_if_not ARM64_WORKAROUND_CLEAN_CACHE
>>> 	dc	\op, \kaddr
>>>  alternative_else
>>> 	dc	civac, \kaddr
>>>  alternative_endif
>>> 	.elseif	(\op == cvap)
>>>  alternative_if ARM64_HAS_DCPOP
>>> 	sys 3, c7, c12, 1, \kaddr	// dc cvap
>>>  alternative_else
>>> 	dc	cvac, \kaddr
>>>  alternative_endif
>>> 	.else
>>> 	dc	\op, \kaddr
>>> 	.endif
>>> 	add	\kaddr, \kaddr, \tmp1
>>> 	cmp	\kaddr, \size
>>> 	b.lo	9998b
>>> 	dsb	\domain
>>> 9997:
>>> 	.endm
>>
>> I think it would be cleaner the other way round, actually -- move the check
>> out of invalidate_icache_by_line and into its two callers.
>>
> 
> Sure, I'll send out the next patch with your suggestions.
> 
>>>> I notice that the only user other than
>>>> flush_icache_range/__flush_cache_user_range or invalidate_icache_by_line
>>>> is in KVM, via invalidate_icache_range. If you want to hook in there, why
>>>> aren't you also patching __flush_icache_all? If so, I'd rather have the
>>>> I-side code consistent with the D-side code and do this in the handful of
>>>> callers. We might even be able to elide a branch or two that way.
>>>>
>>>
>>> Agree with you, it saves function calls overhead. I'll do this change...
>>>
>>> static void invalidate_icache_guest_page(kvm_pfn_t pfn, unsigned long size)
>>> {
>>> 	if (cpus_have_const_cap(ARM64_HAS_CACHE_DIC)
>>> 	    __invalidate_icache_guest_page(pfn, size);
>>> }
>>>
>>>
>>>> I'm going to assume that I-cache aliases are all coherent if DIC=1, so it's
>>>> safe to elide our alias sync code.
>>>>
>>>
>>> I'm not sure about I-cache whether aliases are all coherent if DIC=1 ot not.
>>> Unfortunately I don't have any hardware to test DIC=1. I've verified IDC=1.
>>
>> I checked with our architects and aliases don't pose a problem here, so you
>> can ignore me :)
>>
> 
> I also confirmed with Thomas Speier, we can skip __flush_icache_all() if DIC=1.
> 
>  
Planning to patch __flush_icache_all() itself instead of changing the callers. This
way we can avoid "ic ialluis" completely. Is this okay for you? 

static inline void __flush_icache_all(void)
{
       /* Instruction cache invalidation is not required for I/D coherence? */
      if (!cpus_have_const_cap(ARM64_HAS_CACHE_DIC)) {
               asm("ic ialluis");
               dsb(ish);
       }
}

>> Will
>>
>> _______________________________________________
>> linux-arm-kernel mailing list
>> linux-arm-kernel@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>>
> 

-- 
Shanker Donthineni
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project.
