From: Jia He <hejianet@gmail.com>
Subject: Re: [PATCH v2 2/2] KVM: arm/arm64: harden unmap_stage2_ptes in case
 end is not PAGE_SIZE aligned
Date: Fri, 8 Jun 2018 16:59:42 +0800
Message-ID: <42df5a9e-23bc-79ac-3d10-66da9f05c0ca@gmail.com>
References: <1526635630-18917-1-git-send-email-hejianet@gmail.com>
 <1526635630-18917-2-git-send-email-hejianet@gmail.com>
 <2185a61e-c157-e177-9bad-83b6f27fd784@arm.com>
 <50c98169-1606-48bf-0489-124adefd2a54@gmail.com>
 <20180608083414.GA5097@C02W217FHV2R.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180608083414.GA5097@C02W217FHV2R.local>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, Suzuki.Poulose@arm.com, linux-kernel@vger.kernel.org, jia.he@hxt-semitech.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer
I ever sent out the v3 patch set with the single patch 1/2
[link] https://patchwork.kernel.org/patch/10413803/
Sorry,I ping-ed the wrong mail thread ;-).

Cheers,
Jia

On 6/8/2018 4:34 PM, Christoffer Dall Wrote:
> On Fri, May 18, 2018 at 09:04:40PM +0800, Jia He wrote:
>>
>>
>> On 5/18/2018 5:48 PM, Marc Zyngier Wrote:
>>> On 18/05/18 10:27, Jia He wrote:
>>>> If it passes addr=0x202920000,size=0xfe00 to unmap_stage2_range->
>>>> ...->unmap_stage2_ptes, unmap_stage2_ptes will get addr=0x202920000,
>>>> end=0x20292fe00. After first while loop addr=0x202930000, end=0x20292fe00,
>>>> then addr!=end. Thus it will touch another pages by put_pages() in the
>>>> 2nd loop.
>>>>
>>>> This patch fixes it by hardening the break condition of while loop.
>>>>
>>>> Signed-off-by: jia.he@hxt-semitech.com
>>>> ---
>>>> v2: newly added
>>>>
>>>>  virt/kvm/arm/mmu.c | 2 +-
>>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
>>>> index 8dac311..45cd040 100644
>>>> --- a/virt/kvm/arm/mmu.c
>>>> +++ b/virt/kvm/arm/mmu.c
>>>> @@ -217,7 +217,7 @@ static void unmap_stage2_ptes(struct kvm *kvm, pmd_t *pmd,
>>>>  
>>>>  			put_page(virt_to_page(pte));
>>>>  		}
>>>> -	} while (pte++, addr += PAGE_SIZE, addr != end);
>>>> +	} while (pte++, addr += PAGE_SIZE, addr < end);
>>>>  
>>>>  	if (stage2_pte_table_empty(start_pte))
>>>>  		clear_stage2_pmd_entry(kvm, pmd, start_addr);
>>>>
>>>
>>> I don't think this change is the right thing to do. You get that failure
>>> because you're being passed a size that is not a multiple of PAGE_SIZE.
>>> That's the mistake.
>>>
>>> You should ensure that this never happens, rather than changing the page
>>> table walkers (which are consistent with the way this kind of code is
>>> written in other places of the kernel). As you mentioned in your first
>>> patch, the real issue is that KSM is broken, and this is what should be
>>> fixed.
>>>
>> Got it, thanks
>> Should I resend the patch 1/2 without any changes after droping patch 2/2?
>>
> 
> That's fine if you trim the commit message to make it look nicer.
> 
> Also, in the future, please include a cover letter if you send more than
> one patch to the list.
> 
> Thanks,
> -Christoffer
> 
