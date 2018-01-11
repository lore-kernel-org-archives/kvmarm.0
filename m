From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] KVM: arm/arm64: Check pagesize when allocating a
 hugepage at Stage 2
Date: Thu, 11 Jan 2018 13:15:42 +0100
Message-ID: <20180111121542.GG15307@cbox>
References: <20180104182433.3790-1-punit.agrawal@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180104182433.3790-1-punit.agrawal@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Punit Agrawal <punit.agrawal@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Jan 04, 2018 at 06:24:33PM +0000, Punit Agrawal wrote:
> KVM only supports PMD hugepages at stage 2 but doesn't actually check
> that the provided hugepage memory pagesize is PMD_SIZE before populating
> stage 2 entries.
> 
> In cases where the backing hugepage size is smaller than PMD_SIZE (such
> as when using contiguous hugepages),

what are contiguous hugepages and how are they created vs. a normal
hugetlbfs?  Is this a kernel config thing, or how does it work?

> KVM can end up creating stage 2
> mappings that extend beyond the supplied memory.
> 
> Fix this by checking for the pagesize of userspace vma before creating
> PMD hugepage at stage 2.
> 
> Fixes: ad361f093c1e31d ("KVM: ARM: Support hugetlbfs backed huge pages")
> Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
> Cc: Christoffer Dall <christoffer.dall@linaro.org>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  virt/kvm/arm/mmu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
> index b4b69c2d1012..9dea96380339 100644
> --- a/virt/kvm/arm/mmu.c
> +++ b/virt/kvm/arm/mmu.c
> @@ -1310,7 +1310,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  		return -EFAULT;
>  	}
>  
> -	if (is_vm_hugetlb_page(vma) && !logging_active) {
> +	if (vma_kernel_pagesize(vma) == PMD_SIZE && !logging_active) {

Don't we need to also fix this in kvm_send_hwpoison_signal?

(which probably implies this will then need a backport without that for
older stable kernels.  Has this been an issue from the start or did we
add contiguous hugepage support at some point?)

>  		hugetlb = true;
>  		gfn = (fault_ipa & PMD_MASK) >> PAGE_SHIFT;
>  	} else {
> -- 
> 2.15.1
> 

Thanks,
-Christoffer
