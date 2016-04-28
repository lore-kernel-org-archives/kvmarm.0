From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH] arm/arm64: KVM: Enforce Break-Before-Make on Stage-2
 page tables
Date: Thu, 28 Apr 2016 17:07:05 +0100
Message-ID: <20160428160705.GA17867@leverpostej>
References: <1461856591-5751-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CD4F741390
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Apr 2016 12:05:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yPNakSXNKqcz for <kvmarm@lists.cs.columbia.edu>;
 Thu, 28 Apr 2016 12:04:58 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CA9B1412D0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Apr 2016 12:04:58 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <1461856591-5751-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Apr 28, 2016 at 04:16:31PM +0100, Marc Zyngier wrote:
> The ARM architecture mandates that when changing a page table entry
> from a valid entry to another valid entry, an invalid entry is first
> written, TLB invalidated, and only then the new entry being written.
> 
> The current code doesn't respect this, directly writing the new
> entry and only then invalidating TLBs. Let's fix it up.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

FWIW, this looks correct to me.

Acked-by: Mark Rutland <mark.rutland@arm.com>

Mark.

> ---
>  arch/arm/kvm/mmu.c | 17 +++++++++++------
>  1 file changed, 11 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
> index 58dbd5c..edf1cd1 100644
> --- a/arch/arm/kvm/mmu.c
> +++ b/arch/arm/kvm/mmu.c
> @@ -893,11 +893,14 @@ static int stage2_set_pmd_huge(struct kvm *kvm, struct kvm_mmu_memory_cache
>  	VM_BUG_ON(pmd_present(*pmd) && pmd_pfn(*pmd) != pmd_pfn(*new_pmd));
>  
>  	old_pmd = *pmd;
> -	kvm_set_pmd(pmd, *new_pmd);
> -	if (pmd_present(old_pmd))
> +	if (pmd_present(old_pmd)) {
> +		pmd_clear(pmd);
>  		kvm_tlb_flush_vmid_ipa(kvm, addr);
> -	else
> +	} else {
>  		get_page(virt_to_page(pmd));
> +	}
> +
> +	kvm_set_pmd(pmd, *new_pmd);
>  	return 0;
>  }
>  
> @@ -946,12 +949,14 @@ static int stage2_set_pte(struct kvm *kvm, struct kvm_mmu_memory_cache *cache,
>  
>  	/* Create 2nd stage page table mapping - Level 3 */
>  	old_pte = *pte;
> -	kvm_set_pte(pte, *new_pte);
> -	if (pte_present(old_pte))
> +	if (pte_present(old_pte)) {
> +		kvm_set_pte(pte, __pte(0));
>  		kvm_tlb_flush_vmid_ipa(kvm, addr);
> -	else
> +	} else {
>  		get_page(virt_to_page(pte));
> +	}
>  
> +	kvm_set_pte(pte, *new_pte);
>  	return 0;
>  }
>  
> -- 
> 2.1.4
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
> 
