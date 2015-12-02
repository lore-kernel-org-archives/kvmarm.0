From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] KVM: arm/arm64: Revert to old way of checking for device
 mapping in stage2_flush_ptes().
Date: Wed, 2 Dec 2015 18:41:59 +0100
Message-ID: <CAKv+Gu-WhtTZoPEmRSa8Ypcc9SZ-d6NABDSfZ6tTx14Tyt+AdQ@mail.gmail.com>
References: <1448975032-7156-1-git-send-email-p.fedin@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1448975032-7156-1-git-send-email-p.fedin@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: Pavel Fedin <p.fedin@samsung.com>
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, KVM devel mailing list <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Pavel,

Thanks for getting to the bottom of this.

On 1 December 2015 at 14:03, Pavel Fedin <p.fedin@samsung.com> wrote:
> This function takes stage-II physical addresses (A.K.A. IPA), on input, not
> real physical addresses. This causes kvm_is_device_pfn() to return wrong
> values, depending on how much guest and host memory maps match. This
> results in completely broken KVM on some boards. The problem has been
> caught on Samsung proprietary hardware.
>
> Cc: stable@vger.kernel.org
> Fixes: e6fab5442345 ("ARM/arm64: KVM: test properly for a PTE's uncachedness")
>

That commit is not in a release yet, so no need for cc stable

> Signed-off-by: Pavel Fedin <p.fedin@samsung.com>
> ---
>  arch/arm/kvm/mmu.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
> index 7dace90..51ad98f 100644
> --- a/arch/arm/kvm/mmu.c
> +++ b/arch/arm/kvm/mmu.c
> @@ -310,7 +310,8 @@ static void stage2_flush_ptes(struct kvm *kvm, pmd_t *pmd,
>
>         pte = pte_offset_kernel(pmd, addr);
>         do {
> -               if (!pte_none(*pte) && !kvm_is_device_pfn(__phys_to_pfn(addr)))
> +               if (!pte_none(*pte) &&
> +                   (pte_val(*pte) & PAGE_S2_DEVICE) != PAGE_S2_DEVICE)

I think your analysis is correct, but does that not apply to both instances?
And instead of reverting, could we fix this properly instead?

>                         kvm_flush_dcache_pte(*pte);
>         } while (pte++, addr += PAGE_SIZE, addr != end);
>  }
> --
> 2.4.4
>
