From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] KVM: arm/arm64: Revert to old way of checking for device
 mapping in stage2_flush_ptes().
Date: Wed, 2 Dec 2015 20:04:42 +0100
Message-ID: <CAKv+Gu8Lau1HEgR5ogMTB-5h53FkTbZeNWN4zgvCph=3mSTXpw@mail.gmail.com>
References: <1448975032-7156-1-git-send-email-p.fedin@samsung.com>
	<20151202185040.GT18376@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20151202185040.GT18376@cbox>
Sender: stable-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Pavel Fedin <p.fedin@samsung.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, KVM devel mailing list <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 2 December 2015 at 19:50, Christoffer Dall
<christoffer.dall@linaro.org> wrote:
> On Tue, Dec 01, 2015 at 04:03:52PM +0300, Pavel Fedin wrote:
>> This function takes stage-II physical addresses (A.K.A. IPA), on input, not
>> real physical addresses. This causes kvm_is_device_pfn() to return wrong
>> values, depending on how much guest and host memory maps match. This
>> results in completely broken KVM on some boards. The problem has been
>> caught on Samsung proprietary hardware.
>>
>> Cc: stable@vger.kernel.org
>
> cc'ing stable doesn't make sense here as the bug was introduced in
> v4.4-rc3 and we didn't release v4.4 yet...
>
>> Fixes: e6fab5442345 ("ARM/arm64: KVM: test properly for a PTE's uncachedness")
>>
>> Signed-off-by: Pavel Fedin <p.fedin@samsung.com>
>> ---
>>  arch/arm/kvm/mmu.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
>> index 7dace90..51ad98f 100644
>> --- a/arch/arm/kvm/mmu.c
>> +++ b/arch/arm/kvm/mmu.c
>> @@ -310,7 +310,8 @@ static void stage2_flush_ptes(struct kvm *kvm, pmd_t *pmd,
>>
>>       pte = pte_offset_kernel(pmd, addr);
>>       do {
>> -             if (!pte_none(*pte) && !kvm_is_device_pfn(__phys_to_pfn(addr)))
>> +             if (!pte_none(*pte) &&
>> +                 (pte_val(*pte) & PAGE_S2_DEVICE) != PAGE_S2_DEVICE)
>>                       kvm_flush_dcache_pte(*pte);
>>       } while (pte++, addr += PAGE_SIZE, addr != end);
>>  }
>
> You are right that there was a bug in the fix, but your fix is not the
> right one.
>
> Either we have to apply an actual mask and the compare against the value
> (yes, I know, because of the UXN bit we get lucky so far, but that's too
> brittle), or we should do a translation fo the gfn to a pfn.  Is there
> anything preventing us to do the following?
>
> if (!pte_none(*pte) && !kvm_is_device_pfn(pte_pfn(*pte)))
>

Yes, that looks better. I got confused by addr being a 'phys_addr_t'
but obviously, the address inside the PTE is the one we need to test
for device-ness, so I think we should replace both instances with this

-- 
Ard.
