From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] KVM: arm/arm64: Check pagesize when allocating a
 hugepage at Stage 2
Date: Thu, 11 Jan 2018 14:49:42 +0100
Message-ID: <20180111134942.GH15307@cbox>
References: <20180104182433.3790-1-punit.agrawal@arm.com>
 <20180111121542.GG15307@cbox>
 <87mv1kr1m4.fsf@e105922-lin.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87mv1kr1m4.fsf@e105922-lin.cambridge.arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Punit Agrawal <punit.agrawal@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Jan 11, 2018 at 01:01:07PM +0000, Punit Agrawal wrote:
> Christoffer Dall <christoffer.dall@linaro.org> writes:
> 
> > On Thu, Jan 04, 2018 at 06:24:33PM +0000, Punit Agrawal wrote:
> >> KVM only supports PMD hugepages at stage 2 but doesn't actually check
> >> that the provided hugepage memory pagesize is PMD_SIZE before populating
> >> stage 2 entries.
> >> 
> >> In cases where the backing hugepage size is smaller than PMD_SIZE (such
> >> as when using contiguous hugepages),
> >
> > what are contiguous hugepages and how are they created vs. a normal
> > hugetlbfs?  Is this a kernel config thing, or how does it work?
> 
> Contiguous hugepages use the "Contiguous" bit (bit 52) in the page table
> entry (pte), to mark successive entries as forming a block mapping.
> 
> The number of successive ptes that can be combined depend on the granule
> size. E.g., for 4KB granule, 16 last-level ptes can form a 64KB
> hugepage. or 16 adjacent PMD entries can form a 32MB hugepage.
> 
> There's no difference in instantiating contiguous hugepages vs normal
> hugepages from a user's perspective other than passing in the
> appropriate hugepage size.
> 
> There is no explicit config for contiguous hugepages - instead the
> architectural helper to setup "hugepagesz" (see setup_hugepagesz() in
> arch/arm64/mm/hugetlbpage.c") dictates the supported sizes.
> 
> Contiguous hugepage support has been enabled/disabled a few times for
> arm64 - the latest of which is 5cd028b9d90403b ("arm64: Re-enable
> support for contiguous hugepages").
> 
> >
> >> KVM can end up creating stage 2
> >> mappings that extend beyond the supplied memory.
> >> 
> >> Fix this by checking for the pagesize of userspace vma before creating
> >> PMD hugepage at stage 2.
> >> 
> >> Fixes: ad361f093c1e31d ("KVM: ARM: Support hugetlbfs backed huge pages")
> >> Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
> >> Cc: Christoffer Dall <christoffer.dall@linaro.org>
> >> Cc: Marc Zyngier <marc.zyngier@arm.com>
> >> ---
> >>  virt/kvm/arm/mmu.c | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >> 
> >> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
> >> index b4b69c2d1012..9dea96380339 100644
> >> --- a/virt/kvm/arm/mmu.c
> >> +++ b/virt/kvm/arm/mmu.c
> >> @@ -1310,7 +1310,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> >>  		return -EFAULT;
> >>  	}
> >>  
> >> -	if (is_vm_hugetlb_page(vma) && !logging_active) {
> >> +	if (vma_kernel_pagesize(vma) == PMD_SIZE && !logging_active) {
> >
> > Don't we need to also fix this in kvm_send_hwpoison_signal?
> 
> I think we are OK here as the signal is delivered to userspace using the
> hva and the lsb_shift is derived from the vma as well, i.e., stage 2 is
> not involved here.
> 
> Does that make sense?
> 

Yes, you're right.

> >
> > (which probably implies this will then need a backport without that for
> > older stable kernels.  Has this been an issue from the start or did we
> > add contiguous hugepage support at some point?)
> 
> I think kvm was missed out in the first (and subsequent) enabling of
> contiguous hugepage support. The functionality didn't start out broken
> initially.
> 
> Note that applying the fix as far back as it applies isn't harmful
> though.
> 

It's a bit misleading to have the "Fixes: ad361f093c1e31d" tag, in that
it may have people running old kernels think this could be affecting
their workloads.  I know it's unlikely, but still.  Shouldn't the tag be
Fixes 66b3923a1a0f "arm64: hugetlb: add support for PTE contiguous bit"
?

That would make it a
Cc: <stable@vger.kernel.org> # v4.5+

Thanks,
-Christoffer
