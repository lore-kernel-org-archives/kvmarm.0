From: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Subject: Re: [PATCH 15/17] kvm: arm64: Get rid of fake page table levels
Date: Wed, 13 Apr 2016 18:49:59 +0100
Message-ID: <570E86C7.1020606@arm.com>
References: <1459787177-12767-1-git-send-email-suzuki.poulose@arm.com>
 <1459787177-12767-16-git-send-email-suzuki.poulose@arm.com>
 <20160408150523.GX8961@cbox> <570BB5C9.8040509@arm.com>
 <20160412121414.GA3039@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B7CAC40B40
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Apr 2016 13:48:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gPqkETW3wnrr for <kvmarm@lists.cs.columbia.edu>;
 Wed, 13 Apr 2016 13:48:22 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3F02149B54
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Apr 2016 13:48:21 -0400 (EDT)
In-Reply-To: <20160412121414.GA3039@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 12/04/16 13:14, Christoffer Dall wrote:
> On Mon, Apr 11, 2016 at 03:33:45PM +0100, Suzuki K Poulose wrote:
>> On 08/04/16 16:05, Christoffer Dall wrote:
>>> On Mon, Apr 04, 2016 at 05:26:15PM +0100, Suzuki K Poulose wrote:
>>
>>>> diff --git a/arch/arm64/include/asm/stage2_pgtable.h b/arch/arm64/include/asm/stage2_pgtable.h
>>>> index 751227d..139b4db 100644
>>>> --- a/arch/arm64/include/asm/stage2_pgtable.h
>>>> +++ b/arch/arm64/include/asm/stage2_pgtable.h
>>>> @@ -22,32 +22,55 @@
>>>>   #include <asm/pgtable.h>
>>>>
>>>>   /*
>>>> - * In the case where PGDIR_SHIFT is larger than KVM_PHYS_SHIFT, we can address
>>>> - * the entire IPA input range with a single pgd entry, and we would only need
>>>> - * one pgd entry.  Note that in this case, the pgd is actually not used by
>>>> - * the MMU for Stage-2 translations, but is merely a fake pgd used as a data
>>>> - * structure for the kernel pgtable macros to work.
>>>> + * The hardware mandates concatenation of upto 16 tables at stage2 entry level.
>>>
>>> s/upto/up to/
>>>
>>>> + * Now, the minimum number of bits resolved at any level is (PAGE_SHIFT - 3),
>>>> + * or in other words log2(PTRS_PER_PTE). On arm64, the smallest PAGE_SIZE
>>>
>>> not sure the log2 comment helps here.
>>
>> OK, will address both the above comments.
>>
>>>
>>>> + * supported is 4k, which means (PAGE_SHIFT - 3) > 4 holds for all page sizes.
>>>> + * This implies, the total number of page table levels at stage2 expected
>>>> + * by the hardware is actually the number of levels required for (KVM_PHYS_SHIFT - 4)
>>>> + * in normal translations(e.g, stage-1), since we cannot have another level in
>>>> + * the range (KVM_PHYS_SHIFT, KVM_PHYS_SHIFT - 4).
>>>
>>> Is it not a design decision to always choose the maximum number of
>>> concatinated initial-level stage2 tables (with the constraint that
>>> there's a minimum number required)?
>>

I have changed the above comment to :

/*
  * The hardware supports concatenation of up to 16 tables at stage2 entry level
  * and we use the feature whenever possible.
  *
  * Now, the minimum number of bits resolved at any level is (PAGE_SHIFT - 3).
  * On arm64, the smallest PAGE_SIZE supported is 4k, which means
  *             (PAGE_SHIFT - 3) > 4 holds for all page sizes.
  * This implies, the total number of page table levels at stage2 expected
  * by the hardware is actually the number of levels required for (KVM_PHYS_SHIFT - 4)
  * in normal translations(e.g, stage1), since we cannot have another level in
  * the range (KVM_PHYS_SHIFT, KVM_PHYS_SHIFT - 4).
  */



>>>> + * At the moment, we do not support a combination of guest IPA and host VA_BITS
>>>> + * where
>>>> + *       STAGE2_PGTABLE_LEVELS > CONFIG_PGTABLE_LEVELS
>>>
>>> can you change this comment to reverse the statement to avoid someone
>>> seeing this as a constraint, when in fact it's a negative invariant?
>>>
>>> So the case we don't support is a sufficiently larger IPA space compared
>>> to the host VA space such that the above happens?  (Since at the same
>>> IPA space size as host VA space size, the stage-2 levels will always be
>>> less than or equal to the host levels.)
>>
>> Correct.
>>
>>>
>>> I don't see how that would ever work with userspace either so I think
>>> this is a safe assumption and not something that ever needs fixing.  In
>>
>> For e.g, we can perfectly run a guest with 40bit IPA under a host with 16K+36bit
>> VA. The moment we go above 40bit IPA, we could trigger the conditions above.
>> I think it is perfectly fine for the guest to choose higher IPA width, and place
>> its memory well above as long as the qemu/lkvm doesn't exhaust its VA. I just
>> tried booting a VM with memory at 0x70_0000_0000 on a 16K+36bitVA host and it
>> boots perfectly fine.
>>
>
> Right, I was thinking about it as providing more than 36bits of *memory*
> not address space in this case, so you're right, it is at least a
> theoretically possible case.
>

I have reworded the comment as follows:
/*
  * With all the supported VA_BITs and 40bit guest IPA, the following condition
  * is always true:
  *
  *       CONFIG_PGTABLE_LEVELS >= STAGE2_PGTABLE_LEVELS
  *
  * We base our stage-2 page table walker helpers on this assumption and
  * fall back to using the host version of the helper wherever possible.
  * i.e, if a particular level is not folded (e.g, PUD) at stage2, we fall back
  * to using the host version, since it is guaranteed it is not folded at host.
  *
  * If the condition breaks in the future, we can rearrange the host level
  * definitions and reuse them for stage2. Till then...
  */
#if STAGE2_PGTABLE_LEVELS > CONFIG_PGTABLE_LEVELS
#error "Unsupported combination of guest IPA and host VA_BITS."
#endif

---

Please let me know your comments.


Cheers
Suzuki
