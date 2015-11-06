From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [PATCH] KVM: arm: Fix crash in free_hyp_pgds() if timer
 initialization fails
Date: Fri, 06 Nov 2015 12:32:51 +0300
Message-ID: <002601d11876$1bc3cf40$534b6dc0$@samsung.com>
References: <1445931608-8824-1-git-send-email-p.fedin@samsung.com>
 <20151105152440.GF5819@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 75F4F49840
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Nov 2015 04:29:41 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2iSGy6ott1A7 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 Nov 2015 04:29:38 -0500 (EST)
Received: from mailout3.w1.samsung.com (mailout3.w1.samsung.com
 [210.118.77.13])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 69D2849767
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Nov 2015 04:29:36 -0500 (EST)
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NXD003P4ZUSBC60@mailout3.w1.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Fri, 06 Nov 2015 09:32:52 +0000 (GMT)
In-reply-to: <20151105152440.GF5819@cbox>
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
To: 'Christoffer Dall' <christoffer.dall@linaro.org>
Cc: 'Marc Zyngier' <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

 Hello!

> > diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
> > index 7b42012..839dd970 100644
> > --- a/arch/arm/kvm/mmu.c
> > +++ b/arch/arm/kvm/mmu.c
> > @@ -213,7 +213,10 @@ static void unmap_ptes(struct kvm *kvm, pmd_t *pmd,
> >  			kvm_tlb_flush_vmid_ipa(kvm, addr);
> >
> >  			/* No need to invalidate the cache for device mappings */
> > -			if ((pte_val(old_pte) & PAGE_S2_DEVICE) != PAGE_S2_DEVICE)
> > +			if (((pte_val(old_pte) & PAGE_S2_DEVICE)
> > +			     != PAGE_S2_DEVICE) &&
> > +			    ((pte_val(old_pte) & PAGE_HYP_DEVICE)
> > +			     != PAGE_HYP_DEVICE))
> >  				kvm_flush_dcache_pte(old_pte);
> >
> >  			put_page(virt_to_page(pte));
> > --
> > 2.4.4
> >
> 
> Did you check if PAGE_HYP_DEVICE can mean something sane on a stage-2
> page table entry and vice verse?

 I tried to, the chain of macros and variables is complicated enough not to
get 200% sure, but anyway PAGE_HYP_DEVICE (as well as PAGE_S2_DEVICE)
includes PROT_PTE_DEVICE, so this is definitely device.
 I even tried to construct some mask in order to make a single check for only
DEVICE flags, but, to make things even less understandable and predictable,
the same code with different bitfields is reused by ARM64. So, i thought that
it will be more reliable just to add a second test.

> 
> Also, the commit message and formatting here is horrible, see this
> reworked version:

[skip]

 It's OK, to tell the truth the commit message is not that much important
for me, but i know that sometimes these changes require good elaboration,
so i included as much information as possible, together with crash
backtrace. I've seen something like this in "git log" before.
 Could you give me some directions on how to write better messages? And
about formatting, IIRC i adhere to "75 chars per line" rule, and always
(well, almost, unless forget to do so ;) ) run checkpatch.

> diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
> index 6984342..f0c3aef 100644
> --- a/arch/arm/kvm/mmu.c
> +++ b/arch/arm/kvm/mmu.c
> @@ -206,18 +206,20 @@ static void unmap_ptes(struct kvm *kvm, pmd_t *pmd,
> 
>  	start_pte = pte = pte_offset_kernel(pmd, addr);
>  	do {
> -		if (!pte_none(*pte)) {
> -			pte_t old_pte = *pte;
> +		if (pte_none(*pte))
> +			continue;
> 
> -			kvm_set_pte(pte, __pte(0));
> -			kvm_tlb_flush_vmid_ipa(kvm, addr);
> +		pte_t old_pte = *pte;
> 
> -			/* No need to invalidate the cache for device mappings */
> -			if ((pte_val(old_pte) & PAGE_S2_DEVICE) != PAGE_S2_DEVICE)
> -				kvm_flush_dcache_pte(old_pte);
> +		kvm_set_pte(pte, __pte(0));
> +		kvm_tlb_flush_vmid_ipa(kvm, addr);
> 
> -			put_page(virt_to_page(pte));
> -		}
> +		/* No need to invalidate the cache for device mappings */
> +		if ((pte_val(old_pte) & PAGE_S2_DEVICE) != PAGE_S2_DEVICE &&
> +		    (pte_val(old_pte) & PAGE_HYP_DEVICE) != PAGE_HYP_DEVICE)
> +			kvm_flush_dcache_pte(old_pte);
> +
> +		put_page(virt_to_page(pte));
>  	} while (pte++, addr += PAGE_SIZE, addr != end);
> 
>  	if (kvm_pte_table_empty(kvm, start_pte))
> --

 I see you inverted pte_none() check, and now kbuild bot complains about
"mixed declarations and code".

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia
