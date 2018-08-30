From: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH] KVM: arm/arm64: Clean dcache to PoC when changing PTE
 due to CoW
Date: Thu, 30 Aug 2018 14:20:52 +0200
Message-ID: <20180830122052.GD4029@e113682-lin.lund.arm.com>
References: <20180823153342.158230-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8A9F94A209
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Aug 2018 08:20:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 947Zkv8EhHX1 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Aug 2018 08:20:56 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2BC2640A67
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Aug 2018 08:20:56 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20180823153342.158230-1-marc.zyngier@arm.com>
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
Cc: punit.agrawal@arm.com, kvm@vger.kernel.org, Mike Galbraith <efault@gmx.de>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

[Adding Andrea and Steve in CC]

On Thu, Aug 23, 2018 at 04:33:42PM +0100, Marc Zyngier wrote:
> When triggering a CoW, we unmap the RO page via an MMU notifier
> (invalidate_range_start), and then populate the new PTE using another
> one (change_pte). In the meantime, we'll have copied the old page
> into the new one.
> 
> The problem is that the data for the new page is sitting in the
> cache, and should the guest have an uncached mapping to that page
> (or its MMU off), following accesses will bypass the cache.
> 
> In a way, this is similar to what happens on a translation fault:
> We need to clean the page to the PoC before mapping it. So let's just
> do that.
> 
> This fixes a KVM unit test regression observed on a HiSilicon platform,
> and subsequently reproduced on Seattle.
> 
> Fixes: a9c0e12ebee5 ("KVM: arm/arm64: Only clean the dcache on translation fault")
> Reported-by: Mike Galbraith <efault@gmx.de>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  virt/kvm/arm/mmu.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
> index 1d90d79706bd..287c8e274655 100644
> --- a/virt/kvm/arm/mmu.c
> +++ b/virt/kvm/arm/mmu.c
> @@ -1811,13 +1811,20 @@ static int kvm_set_spte_handler(struct kvm *kvm, gpa_t gpa, u64 size, void *data
>  void kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte)
>  {
>  	unsigned long end = hva + PAGE_SIZE;
> +	kvm_pfn_t pfn = pte_pfn(pte);
>  	pte_t stage2_pte;
>  
>  	if (!kvm->arch.pgd)
>  		return;
>  
>  	trace_kvm_set_spte_hva(hva);
> -	stage2_pte = pfn_pte(pte_pfn(pte), PAGE_S2);
> +
> +	/*
> +	 * We've moved a page around, probably through CoW, so let's treat
> +	 * just like a translation fault and clean the cache to the PoC.
> +	 */
> +	clean_dcache_guest_page(pfn, PAGE_SIZE);
> +	stage2_pte = pfn_pte(pfn, PAGE_S2);
>  	handle_hva_to_gpa(kvm, hva, end, &kvm_set_spte_handler, &stage2_pte);
>  }

How does this work for pmd mappings?

Are we guaranteed that a pmd mapping (hugetlbfs or THP) is split before
a CoW happens?

Steve tells me that we share THP mappings on fork and that we back THPs
by a zero page, so CoW with THP should be possible.

Thanks,
    Christoffer
