From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] KVM: arm/arm64: Check memslot bounds before mapping
 hugepages
Date: Mon, 10 Sep 2018 10:56:36 +0100
Message-ID: <1e88db29-9bfd-7a47-ba36-c025c121c223@arm.com>
References: <20180904163937.12759-1-koomi@moshbit.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180904163937.12759-1-koomi@moshbit.net>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Lukas Braun <koomi@moshbit.net>, Christoffer Dall <christoffer.dall@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
Cc: Ralph Palutke <ralph.palutke@fau.de>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Lukas,

On 04/09/18 17:39, Lukas Braun wrote:
> Userspace can create a memslot with memory backed by (transparent)
> hugepages, but with bounds that do not align with hugepages.
> In that case, we cannot map the entire region in the guest as hugepages
> without exposing additional host memory to the guest and potentially
> interfering with other memslots.
> Consequently, this patch adds a bounds check when populating guest page
> tables and forces the creation of regular PTEs if mapping an entire
> hugepage would violate the memslots bounds.
> 
> Signed-off-by: Lukas Braun <koomi@moshbit.net>
> ---
>  virt/kvm/arm/mmu.c | 15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
> index ed162a6c57c5..bdbec1d136a1 100644
> --- a/virt/kvm/arm/mmu.c
> +++ b/virt/kvm/arm/mmu.c
> @@ -1504,6 +1504,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  		hugetlb = true;
>  		gfn = (fault_ipa & PMD_MASK) >> PAGE_SHIFT;
>  	} else {
> +		unsigned long pmd_fn_mask = PTRS_PER_PMD - 1;
> +
>  		/*
>  		 * Pages belonging to memslots that don't have the same
>  		 * alignment for userspace and IPA cannot be mapped using
> @@ -1513,8 +1515,17 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  		 * unmapping, updates, and splits of the THP or other pages
>  		 * in the stage-2 block range.
>  		 */
> -		if ((memslot->userspace_addr & ~PMD_MASK) !=
> -		    ((memslot->base_gfn << PAGE_SHIFT) & ~PMD_MASK))
> +		int aligned = ((memslot->userspace_addr & ~PMD_MASK) ==
> +			((memslot->base_gfn << PAGE_SHIFT) & ~PMD_MASK));

This should most probably be a bool, together with the in_bounds variable.

> +
> +		/*
> +		 * We also can't map a huge page if it would violate the bounds
> +		 * of the containing memslot.
> +		 */
> +		int in_bounds = ((memslot->base_gfn <= (gfn & ~pmd_fn_mask)) &&
> +			((memslot->base_gfn + memslot->npages) > (gfn | pmd_fn_mask)));

It's the morning, and I haven't had much coffee, but this looks 
confusing as hell. Most of the reasoning here is done in terms of 
addresses, and you're now mixing it with a different unit, making the 
result more unreadable.

I find it easier to read it as:

diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index b3c9cc73b0f1..3729ca414fc3 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -1516,6 +1516,14 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		if ((memslot->userspace_addr & ~PMD_MASK) !=
 		    ((memslot->base_gfn << PAGE_SHIFT) & ~PMD_MASK))
 			force_pte = true;
+
+		/*
+		 * Force PTE mapping if a THP would lead to map
+		 * something outside of the memslot.
+		 */
+		if ((fault_ipa & S2_PMD_MASK) < (memslot->base_gfn << PAGE_SHIFT) ||
+		    ALIGN(fault_ipa, S2_PMD_SIZE) >= ((memslot->base_gfn + memslot->npages) << PAGE_SHIFT))
+			force_pte = true;
 	}
 	up_read(&current->mm->mmap_sem);
 
which is of course completely untested.

> +
> +		if (!aligned || !in_bounds)
>  			force_pte = true;
>  	}
>  	up_read(&current->mm->mmap_sem);
> 

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
