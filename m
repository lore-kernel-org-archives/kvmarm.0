From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] KVM: arm/arm64: Revert to old way of checking for device
 mapping in stage2_flush_ptes().
Date: Thu, 3 Dec 2015 09:09:36 +0100
Message-ID: <CAKv+Gu8qBy_aBC2ZUB5D3ZNMdkdy-Q+XTD2bOXfnM_g1239e7A@mail.gmail.com>
References: <1448975032-7156-1-git-send-email-p.fedin@samsung.com>
	<CAKv+Gu-WhtTZoPEmRSa8Ypcc9SZ-d6NABDSfZ6tTx14Tyt+AdQ@mail.gmail.com>
	<007c01d12d9a$36dd6eb0$a4984c10$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <007c01d12d9a$36dd6eb0$a4984c10$@samsung.com>
Sender: stable-owner@vger.kernel.org
To: Pavel Fedin <p.fedin@samsung.com>
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, KVM devel mailing list <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 3 December 2015 at 08:14, Pavel Fedin <p.fedin@samsung.com> wrote:
>  Hello!
>
>> > diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
>> > index 7dace90..51ad98f 100644
>> > --- a/arch/arm/kvm/mmu.c
>> > +++ b/arch/arm/kvm/mmu.c
>> > @@ -310,7 +310,8 @@ static void stage2_flush_ptes(struct kvm *kvm, pmd_t *pmd,
>> >
>> >         pte = pte_offset_kernel(pmd, addr);
>> >         do {
>> > -               if (!pte_none(*pte) && !kvm_is_device_pfn(__phys_to_pfn(addr)))
>> > +               if (!pte_none(*pte) &&
>> > +                   (pte_val(*pte) & PAGE_S2_DEVICE) != PAGE_S2_DEVICE)
>>
>> I think your analysis is correct, but does that not apply to both instances?
>
>  No no, another one is correct, since it operates on real PFN (at least looks like so). I have verified my fix against the original problem (crash on Exynos5410 without generic timer), and it still works fine there.
>

I don't think so. Regardless of whether you are manipulating HYP
mappings or stage-2 mappings, the physical address is always the
output, not the input of the translation, so addr is always either a
virtual address or a intermediate physical address, whereas
pfn_valid() operates on host physical addresses.

>> And instead of reverting, could we fix this properly instead?
>
>  Of course, i'm not against alternate approaches, feel free to. I've just suggested what i could, to fix things quickly. I'm indeed no expert in KVM memory management yet. After all, this is what mailing lists are for.
>

OK. I will follow up with a patch, as Christoffer requested. I'd
appreciate it if you could test to see if it also fixes the current
issue, and the original arch timer issue.

Thanks,
Ard.
