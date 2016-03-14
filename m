From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [RFC PATCH 04/12] kvm-arm: Rename kvm_pmd_huge to huge_pmd
Date: Mon, 14 Mar 2016 17:06:02 +0000
Message-ID: <20160314170602.GD5920@leverpostej>
References: <1457974391-28456-1-git-send-email-suzuki.poulose@arm.com>
 <1457974391-28456-5-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1457974391-28456-5-git-send-email-suzuki.poulose@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: christoffer.dall@linaro.org, marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, will.deacon@arm.com, catalin.marinas@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Mar 14, 2016 at 04:53:03PM +0000, Suzuki K Poulose wrote:
> kvm_pmd_huge doesn't have any dependency on the page table
> where the pmd lives (i.e, hyp vs. stage2). So, rename it to
> huge_pmd() to make it explicit.
> 
> kvm_p.d_* wrappers will be used for helpers which differ
> across hyp vs stage2.
> 
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
>  arch/arm/kvm/mmu.c |   18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
> index a16631c..3b038bb 100644
> --- a/arch/arm/kvm/mmu.c
> +++ b/arch/arm/kvm/mmu.c
> @@ -44,7 +44,7 @@ static phys_addr_t hyp_idmap_vector;
>  
>  #define hyp_pgd_order get_order(PTRS_PER_PGD * sizeof(pgd_t))
>  
> -#define kvm_pmd_huge(_x)	(pmd_huge(_x) || pmd_trans_huge(_x))
> +#define huge_pmd(_x)		(pmd_huge(_x) || pmd_trans_huge(_x))

I note that in arch/arm we have pmd_thp_or_huge() for this in
arch/arm/include/asm/pgtable-{2,3}level.h.

If we're going to rename this, it's probably best to align on that name,
which will also avoid and confusion as to the difference between
pmd_huge and huge_pmd.

Similarly, it might best live in pgtable.h if it isn't KVM-specific.

Thanks,
Mark.
