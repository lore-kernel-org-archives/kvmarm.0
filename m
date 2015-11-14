From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 2/2] arm: kvm: Fix STRICT_MM_TYPECHECK errors
Date: Sat, 14 Nov 2015 08:02:37 +0100
Message-ID: <CAKv+Gu-2yx2j-ke2DNTq7aiNyzrog2fQxsWaSwwF1FPUR-nr0w@mail.gmail.com>
References: <1447207401-12023-1-git-send-email-labbott@fedoraproject.org>
 <1447207401-12023-2-git-send-email-labbott@fedoraproject.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 19D8A4970D
 for <kvmarm@lists.cs.columbia.edu>; Sat, 14 Nov 2015 02:02:19 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id P0Rb6iNg6niP for <kvmarm@lists.cs.columbia.edu>;
 Sat, 14 Nov 2015 02:02:17 -0500 (EST)
Received: from mail-io0-f172.google.com (mail-io0-f172.google.com
 [209.85.223.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B2544419D1
 for <kvmarm@lists.cs.columbia.edu>; Sat, 14 Nov 2015 02:02:17 -0500 (EST)
Received: by iouu10 with SMTP id u10so111075347iou.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Nov 2015 23:02:37 -0800 (PST)
In-Reply-To: <1447207401-12023-2-git-send-email-labbott@fedoraproject.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Laura Abbott <labbott@fedoraproject.org>
Cc: Russell King <linux@arm.linux.org.uk>, KVM devel mailing list <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 11 November 2015 at 03:03, Laura Abbott <labbott@fedoraproject.org> wrote:
>
> PAGE_S2_DEVICE is a pgprot val and needs to be accessed using the proper
> accessors. Switch to these accessors to avoid errors with
> STRICT_MM_TYPECHECK.
>
> Signed-off-by: Laura Abbott <labbott@fedoraproject.org>
> ---
> Found in the course of other work

Already fixed here:
http://thread.gmane.org/gmane.comp.emulators.kvm.devel/142953

Looks like we may need a mutex :-)

> ---
>  arch/arm/kvm/mmu.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
> index 6984342..43f8162 100644
> --- a/arch/arm/kvm/mmu.c
> +++ b/arch/arm/kvm/mmu.c
> @@ -213,7 +213,8 @@ static void unmap_ptes(struct kvm *kvm, pmd_t *pmd,
>                         kvm_tlb_flush_vmid_ipa(kvm, addr);
>
>                         /* No need to invalidate the cache for device mappings */
> -                       if ((pte_val(old_pte) & PAGE_S2_DEVICE) != PAGE_S2_DEVICE)
> +                       if ((pte_val(old_pte) & pgprot_val(PAGE_S2_DEVICE)) !=
> +                            pgprot_val(PAGE_S2_DEVICE))
>                                 kvm_flush_dcache_pte(old_pte);
>
>                         put_page(virt_to_page(pte));
> @@ -306,7 +307,8 @@ static void stage2_flush_ptes(struct kvm *kvm, pmd_t *pmd,
>         pte = pte_offset_kernel(pmd, addr);
>         do {
>                 if (!pte_none(*pte) &&
> -                   (pte_val(*pte) & PAGE_S2_DEVICE) != PAGE_S2_DEVICE)
> +                   (pte_val(*pte) & pgprot_val(PAGE_S2_DEVICE)) !=
> +                    pgprot_val(PAGE_S2_DEVICE))
>                         kvm_flush_dcache_pte(*pte);
>         } while (pte++, addr += PAGE_SIZE, addr != end);
>  }
> --
> 2.5.0
>
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
