From: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH] KVM: arm/arm64: Clean dcache to PoC when changing PTE
 due to CoW
Date: Tue, 4 Sep 2018 15:37:27 +0200
Message-ID: <20180904133727.GR4029@e113682-lin.lund.arm.com>
References: <20180823153342.158230-1-marc.zyngier@arm.com>
 <20180830122052.GD4029@e113682-lin.lund.arm.com>
 <87a7oy7amd.fsf@e105922-lin.cambridge.arm.com>
 <20180904090343.GN4029@e113682-lin.lund.arm.com>
 <87sh2p5xmu.fsf@e105922-lin.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9335D49F89
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Sep 2018 09:37:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jAfAH1l+5+Me for <kvmarm@lists.cs.columbia.edu>;
 Tue,  4 Sep 2018 09:37:30 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1705A40A6E
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Sep 2018 09:37:30 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <87sh2p5xmu.fsf@e105922-lin.cambridge.arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Punit Agrawal <punit.agrawal@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Mike Galbraith <efault@gmx.de>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Sep 04, 2018 at 12:07:37PM +0100, Punit Agrawal wrote:
> Christoffer Dall <christoffer.dall@arm.com> writes:
> 
> > On Mon, Sep 03, 2018 at 06:29:30PM +0100, Punit Agrawal wrote:
> >> Christoffer Dall <christoffer.dall@arm.com> writes:
> >> 
> >> > [Adding Andrea and Steve in CC]
> >> >
> >> > On Thu, Aug 23, 2018 at 04:33:42PM +0100, Marc Zyngier wrote:
> >> >> When triggering a CoW, we unmap the RO page via an MMU notifier
> >> >> (invalidate_range_start), and then populate the new PTE using another
> >> >> one (change_pte). In the meantime, we'll have copied the old page
> >> >> into the new one.
> >> >> 
> >> >> The problem is that the data for the new page is sitting in the
> >> >> cache, and should the guest have an uncached mapping to that page
> >> >> (or its MMU off), following accesses will bypass the cache.
> >> >> 
> >> >> In a way, this is similar to what happens on a translation fault:
> >> >> We need to clean the page to the PoC before mapping it. So let's just
> >> >> do that.
> >> >> 
> >> >> This fixes a KVM unit test regression observed on a HiSilicon platform,
> >> >> and subsequently reproduced on Seattle.
> >> >> 
> >> >> Fixes: a9c0e12ebee5 ("KVM: arm/arm64: Only clean the dcache on translation fault")
> >> >> Reported-by: Mike Galbraith <efault@gmx.de>
> >> >> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> >> >> ---
> >> >>  virt/kvm/arm/mmu.c | 9 ++++++++-
> >> >>  1 file changed, 8 insertions(+), 1 deletion(-)
> >> >> 
> >> >> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
> >> >> index 1d90d79706bd..287c8e274655 100644
> >> >> --- a/virt/kvm/arm/mmu.c
> >> >> +++ b/virt/kvm/arm/mmu.c
> >> >> @@ -1811,13 +1811,20 @@ static int kvm_set_spte_handler(struct kvm *kvm, gpa_t gpa, u64 size, void *data
> >> >>  void kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte)
> >> >>  {
> >> >>  	unsigned long end = hva + PAGE_SIZE;
> >> >> +	kvm_pfn_t pfn = pte_pfn(pte);
> >> >>  	pte_t stage2_pte;
> >> >>  
> >> >>  	if (!kvm->arch.pgd)
> >> >>  		return;
> >> >>  
> >> >>  	trace_kvm_set_spte_hva(hva);
> >> >> -	stage2_pte = pfn_pte(pte_pfn(pte), PAGE_S2);
> >> >> +
> >> >> +	/*
> >> >> +	 * We've moved a page around, probably through CoW, so let's treat
> >> >> +	 * just like a translation fault and clean the cache to the PoC.
> >> >> +	 */
> >> >> +	clean_dcache_guest_page(pfn, PAGE_SIZE);
> >> >> +	stage2_pte = pfn_pte(pfn, PAGE_S2);
> >> >>  	handle_hva_to_gpa(kvm, hva, end, &kvm_set_spte_handler, &stage2_pte);
> >> >>  }
> >> >
> >> > How does this work for pmd mappings?
> >> 
> >> kvm_set_spte_hva() isn't called for PMD mappings. But...
> >> 
> >> >
> >> > Are we guaranteed that a pmd mapping (hugetlbfs or THP) is split before
> >> > a CoW happens?
> >> >
> >> > Steve tells me that we share THP mappings on fork and that we back THPs
> >> > by a zero page, so CoW with THP should be possible.
> >> >
> >> 
> >> ...the problem seems to affect handling write permission faults for CoW
> >> or zero pages.
> >> 
> >> The memory gets unmapped at stage 2 due to the invalidate notifier (in
> >> hugetlb_cow() for hugetlbfs and do_huge_pmd_wp_page() for THP) 
> >
> > So just to make sure I get this right.  For a pte CoW, Linux calls the
> > set_spte function to simply change the pte mapping, without doing any
> > unmapping at stage 2, 
> 
> No.
> 
> I hadn't checked into the PTE CoW for zero pages when replying but was
> relying on Marc's commit log. I've outlined the flow below.
> 
> > but with pmd, we unmap and wait to take another fault as an
> > alternative method?
> 
> Having looked at handling of CoW handling for the different page sizes,
> here's my understanding of the steps for CoW faults - note the slight
> variance when dealing with PTE entries.
> 
> * Guest takes a stage 2 permission fault (user_mem_abort())
> 
> * The host mapping is updated to point to another page (either zeroed or
>   contents copied). This happens via the get_user_pages_unlocked()
>   invoked via gfn_to_pfn_prot().
> 
> * For all page sizes, mmu_invalidate_range_start() notifiers are called
>   which will unmap the memory at stage 2.
> 
> * For PTE (wp_page_copy), set_pte_at_notify() is called which eventually
>   calls kvm_set_pte_hva() modified in $SUBJECT.
> 
>   For hugepages (hugetlb_cow) and annonymous THP (do_huge_pmd_wp_page)
>   there are no notifying versions of page table entry updaters so stage
>   2 entries remain unmapped.
> 
> * mmu_notifier_invalidate_range_end() is called. This updates
>   mmu_notifier_seq which will abort the stage 2 fault handling in
>   user_mem_abort().
> 
> * As stage 2 was left unmapped for hugepages (no change_pte notifier),
>   there'll be a subsequent translation fault where the mapped page will
>   be cleaned/invalidated.
> 
> > Why the two different approaches depending on the mapping size?
> 
> I'm not sure why hugepage change notifier doesn't exist.
> 

Probably it's simply not implemented yet, or not considered important
because the number of faults are reduced with larger mappings anyhow.

> >
> >> while the
> >> cache maintenance for the newly allocated page will be skipped due to
> >> the !FSC_PERM. 
> >
> > If the above holds, then the subsequent fault would be similar to any
> > other fault which should work via the normal mechanism (dcache clean +
> > XN on fault, icache invalidation on permission fault).
> >> 
> >> Hmm... smells like there might be a problem here. I'll try and put
> >> together a fix.
> >> 
> >
> > It's not clear to me if we have a problem, or just different ways of
> > handling the PMD vs. PTE CoW case?
> 
> With the above context, I don't think there is a problem for hugepage
> handling. The missing dcache maintenance addressed by $SUBJECT should be
> sufficient for PTEs.
> 

Agreed.

Thanks for the explanation!

    Christoffer
