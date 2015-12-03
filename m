From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [PATCH] KVM: arm/arm64: Revert to old way of checking for device
 mapping in stage2_flush_ptes().
Date: Thu, 03 Dec 2015 10:14:12 +0300
Message-ID: <007c01d12d9a$36dd6eb0$a4984c10$@samsung.com>
References: <1448975032-7156-1-git-send-email-p.fedin@samsung.com>
 <CAKv+Gu-WhtTZoPEmRSa8Ypcc9SZ-d6NABDSfZ6tTx14Tyt+AdQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <stable-owner@vger.kernel.org>
In-reply-to: <CAKv+Gu-WhtTZoPEmRSa8Ypcc9SZ-d6NABDSfZ6tTx14Tyt+AdQ@mail.gmail.com>
Content-language: ru
Sender: stable-owner@vger.kernel.org
To: 'Ard Biesheuvel' <ard.biesheuvel@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, 'KVM devel mailing list' <kvm@vger.kernel.org>, 'Marc Zyngier' <marc.zyngier@arm.com>, 'Christoffer Dall' <christoffer.dall@linaro.org>, stable@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

 Hello!

> > diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
> > index 7dace90..51ad98f 100644
> > --- a/arch/arm/kvm/mmu.c
> > +++ b/arch/arm/kvm/mmu.c
> > @@ -310,7 +310,8 @@ static void stage2_flush_ptes(struct kvm *kvm, pmd_t *pmd,
> >
> >         pte = pte_offset_kernel(pmd, addr);
> >         do {
> > -               if (!pte_none(*pte) && !kvm_is_device_pfn(__phys_to_pfn(addr)))
> > +               if (!pte_none(*pte) &&
> > +                   (pte_val(*pte) & PAGE_S2_DEVICE) != PAGE_S2_DEVICE)
> 
> I think your analysis is correct, but does that not apply to both instances?

 No no, another one is correct, since it operates on real PFN (at least looks like so). I have verified my fix against the original problem (crash on Exynos5410 without generic timer), and it still works fine there.

> And instead of reverting, could we fix this properly instead?

 Of course, i'm not against alternate approaches, feel free to. I've just suggested what i could, to fix things quickly. I'm indeed no expert in KVM memory management yet. After all, this is what mailing lists are for.

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia
