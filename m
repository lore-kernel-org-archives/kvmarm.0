From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] kvm: arm64: Relax the restriction on using stage2 PUD
 huge mapping
Date: Wed, 30 Jan 2019 10:21:53 +0000
Message-ID: <ddff61a6-bc43-564e-c1ee-ed2c2764fad6@arm.com>
References: <1548789137-4446-1-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1548789137-4446-1-git-send-email-suzuki.poulose@arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Suzuki K Poulose <suzuki.poulose@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, cdall@kernel.org, Christoffer Dall <christoffer.dall@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 29/01/2019 19:12, Suzuki K Poulose wrote:
> We restrict mapping the PUD huge pages in stage2 to only when the
> stage2 has 4 level page table, leaving the feature unused with
> the default IPA size. But we could use it even with a 3
> level page table, i.e, when the PUD level is folded into PGD,
> just like the stage1. Relax the condition to allow using the
> PUD huge page mappings at stage2 when it is possible.
> 
> Cc: Christoffer Dall <christoffer.dall@arm.com>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
>  virt/kvm/arm/mmu.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
> index fbdf3ac..30251e2 100644
> --- a/virt/kvm/arm/mmu.c
> +++ b/virt/kvm/arm/mmu.c
> @@ -1695,11 +1695,14 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  
>  	vma_pagesize = vma_kernel_pagesize(vma);
>  	/*
> -	 * PUD level may not exist for a VM but PMD is guaranteed to
> -	 * exist.
> +	 * The stage2 has a minimum of 2 level table (For arm64 see
> +	 * kvm_arm_setup_stage2()). Hence, we are guaranteed that we can
> +	 * use PMD_SIZE huge mappings (even when the PMD is folded into PGD).
> +	 * As for PUD huge maps, we must make sure that we have at least
> +	 * 3 levels, i.e, PMD is not folded.
>  	 */
>  	if ((vma_pagesize == PMD_SIZE ||
> -	     (vma_pagesize == PUD_SIZE && kvm_stage2_has_pud(kvm))) &&
> +	     (vma_pagesize == PUD_SIZE && kvm_stage2_has_pmd(kvm))) &&
>  	    !force_pte) {
>  		gfn = (fault_ipa & huge_page_mask(hstate_vma(vma))) >> PAGE_SHIFT;
>  	}
> 

For the record, it took a 10 minute discussion with Suzuki  to
understand that the above is actually correct, even if massively
confusing. Why is it correct:

- In a 4 level stage-2, each of PGD/PUD/PMD exists on its own, and start
level is 0
- In a 3 level stage-2, PGD and PUD are fused as the start level is 1,
and PMD exists on its own
- In a 2 level stage-2, both PGD, PUD and PMD are fused, and start level
is 2.

>From the above, we can extract that you can always have a block mapping
at the PUD level if you have a standalone PMD, and that's the logic this
patch is using.

Now, the *real* reason is that you can map a given size in your S2PT,
not that some level is fused or not. What we want is probably a helper
that says:

bool kvm_stage2_can_map_block_size(struct kvm *kvm, size_t sz)
{
	return sz >= PMD_SIZE && stage2_pgdir_size(kvm) >= sz);
}

and the above becomes:

if (kvm_stage2_can_map_block_size(kvm, vma_pagesize)) && !force_pte)

which I find much nicer.

I guess I can still take the above as a fix if Christoffer is happy with
it, but if you think my above hack is correct, I'd like things to be
cleaned-up in the near future.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
