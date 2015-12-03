From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] ARM/arm64: KVM: correct PTE uncachedness check
Date: Thu, 3 Dec 2015 09:21:41 +0100
Message-ID: <CAKv+Gu_H=1Lm_dU4fXKJywZ28zjZkx=6PumBnf0WgV=r=mUuKA@mail.gmail.com>
References: <1449130857-21740-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5DDD6498ED
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Dec 2015 03:20:11 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KxyeuhXgLaYf for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Dec 2015 03:20:10 -0500 (EST)
Received: from mail-ig0-f173.google.com (mail-ig0-f173.google.com
 [209.85.213.173])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9BB7C498E9
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Dec 2015 03:20:10 -0500 (EST)
Received: by igvg19 with SMTP id g19so7976778igv.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 03 Dec 2015 00:21:41 -0800 (PST)
In-Reply-To: <1449130857-21740-1-git-send-email-ard.biesheuvel@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Christoffer Dall <christoffer.dall@linaro.org>, Pavel Fedin <p.fedin@samsung.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

PLEASE disregard, this patch is wrong. v2 coming up


On 3 December 2015 at 09:20, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> Commit e6fab5442345 ("ARM/arm64: KVM: test properly for a PTE's
> uncachedness") modified the logic to test whether a HYP or stage-2
> mapping needs flushing, from [incorrectly] interpreting the page table
> attributes to [incorrectly] checking whether the PFN that backs the
> mapping is covered by host system RAM. The PFN number is part of the
> output of the translation, not the input, so we have to use pte_pfn()
> on the contents of the PTE, not __phys_to_pfn() on the HYP virtual
> address or stage-2 intermediate physical address.
>
> Fixes: e6fab5442345 ("ARM/arm64: KVM: test properly for a PTE's uncachedness")
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  arch/arm/kvm/mmu.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
> index 7dace909d5cf..9708c342795f 100644
> --- a/arch/arm/kvm/mmu.c
> +++ b/arch/arm/kvm/mmu.c
> @@ -218,7 +218,7 @@ static void unmap_ptes(struct kvm *kvm, pmd_t *pmd,
>                         kvm_tlb_flush_vmid_ipa(kvm, addr);
>
>                         /* No need to invalidate the cache for device mappings */
> -                       if (!kvm_is_device_pfn(__phys_to_pfn(addr)))
> +                       if (!kvm_is_device_pfn(pte_pfn(addr)))
>                                 kvm_flush_dcache_pte(old_pte);
>
>                         put_page(virt_to_page(pte));
> @@ -310,7 +310,7 @@ static void stage2_flush_ptes(struct kvm *kvm, pmd_t *pmd,
>
>         pte = pte_offset_kernel(pmd, addr);
>         do {
> -               if (!pte_none(*pte) && !kvm_is_device_pfn(__phys_to_pfn(addr)))
> +               if (!pte_none(*pte) && !kvm_is_device_pfn(pte_pfn(addr)))
>                         kvm_flush_dcache_pte(*pte);
>         } while (pte++, addr += PAGE_SIZE, addr != end);
>  }
> --
> 1.9.1
>
