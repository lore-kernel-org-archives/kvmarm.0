From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [PATCH v2] ARM/arm64: KVM: correct PTE uncachedness check
Date: Thu, 03 Dec 2015 11:45:49 +0300
Message-ID: <008901d12da7$033469d0$099d3d70$@samsung.com>
References: <1449131122-29186-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 590EB498A1
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Dec 2015 03:44:55 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gbhg7hnFtj4L for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Dec 2015 03:44:53 -0500 (EST)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 866264989A
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Dec 2015 03:44:53 -0500 (EST)
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NYR0003HXOF0A90@mailout1.w1.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Thu, 03 Dec 2015 08:45:51 +0000 (GMT)
In-reply-to: <1449131122-29186-1-git-send-email-ard.biesheuvel@linaro.org>
Content-language: ru
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: 'Ard Biesheuvel' <ard.biesheuvel@linaro.org>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

 Tested-by: Pavel Fedin <p.fedin@samsung.com>

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia


> -----Original Message-----
> From: Ard Biesheuvel [mailto:ard.biesheuvel@linaro.org]
> Sent: Thursday, December 03, 2015 11:25 AM
> To: linux-arm-kernel@lists.infradead.org; kvmarm@lists.cs.columbia.edu;
> christoffer.dall@linaro.org; p.fedin@samsung.com
> Cc: Ard Biesheuvel
> Subject: [PATCH v2] ARM/arm64: KVM: correct PTE uncachedness check
> 
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
> index 7dace909d5cf..61d96a645ff3 100644
> --- a/arch/arm/kvm/mmu.c
> +++ b/arch/arm/kvm/mmu.c
> @@ -218,7 +218,7 @@ static void unmap_ptes(struct kvm *kvm, pmd_t *pmd,
>  			kvm_tlb_flush_vmid_ipa(kvm, addr);
> 
>  			/* No need to invalidate the cache for device mappings */
> -			if (!kvm_is_device_pfn(__phys_to_pfn(addr)))
> +			if (!kvm_is_device_pfn(pte_pfn(old_pte)))
>  				kvm_flush_dcache_pte(old_pte);
> 
>  			put_page(virt_to_page(pte));
> @@ -310,7 +310,7 @@ static void stage2_flush_ptes(struct kvm *kvm, pmd_t *pmd,
> 
>  	pte = pte_offset_kernel(pmd, addr);
>  	do {
> -		if (!pte_none(*pte) && !kvm_is_device_pfn(__phys_to_pfn(addr)))
> +		if (!pte_none(*pte) && !kvm_is_device_pfn(pte_pfn(*pte)))
>  			kvm_flush_dcache_pte(*pte);
>  	} while (pte++, addr += PAGE_SIZE, addr != end);
>  }
> --
> 1.9.1
