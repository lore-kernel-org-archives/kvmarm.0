From: Punit Agrawal <punit.agrawal@arm.com>
Subject: Re: [PATCH v2 14/17] kvm: arm64: Switch to per VM IPA limit
Date: Fri, 13 Apr 2018 17:27:57 +0100
Message-ID: <87muy7vzoy.fsf@e105922-lin.cambridge.arm.com>
References: <1522156531-28348-1-git-send-email-suzuki.poulose@arm.com>
        <1522156531-28348-15-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1522156531-28348-15-git-send-email-suzuki.poulose@arm.com>
        (Suzuki K. Poulose's message of "Tue, 27 Mar 2018 14:15:24 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, ard.biesheuvel@linaro.org, kvm@vger.kernel.org, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, kristina.martsenko@arm.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi Suzuki,

I haven't had a chance to look at the code but noticed one issue below.

Suzuki K Poulose <suzuki.poulose@arm.com> writes:

> Now that we can manage the stage2 page table per VM, switch the
> configuration details to per VM instance. We keep track of the
> IPA bits, number of page table levels and the VTCR bits (which
> depends on the IPA and the number of levels). While at it, remove
> unused pgd_lock field from kvm_arch for arm64.
>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Christoffer Dall <cdall@kernel.org>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
>  arch/arm64/include/asm/kvm_host.h       | 14 ++++++++++++--
>  arch/arm64/include/asm/kvm_mmu.h        | 11 +++++++++--
>  arch/arm64/include/asm/stage2_pgtable.h |  1 -
>  arch/arm64/kvm/hyp/switch.c             |  3 +--
>  virt/kvm/arm/mmu.c                      |  4 ++++
>  5 files changed, 26 insertions(+), 7 deletions(-)
>

[...]

> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> index bb458bf..e86d7f4 100644
> --- a/arch/arm64/include/asm/kvm_mmu.h
> +++ b/arch/arm64/include/asm/kvm_mmu.h
> @@ -136,9 +136,10 @@ static inline unsigned long __kern_hyp_va(unsigned long v)
>   */
>  #define KVM_PHYS_SHIFT	(40)
>  
> -#define kvm_phys_shift(kvm)		KVM_PHYS_SHIFT
> +#define kvm_phys_shift(kvm)		(kvm->arch.phys_shift)
>  #define kvm_phys_size(kvm)		(_AC(1, ULL) << kvm_phys_shift(kvm))
>  #define kvm_phys_mask(kvm)		(kvm_phys_size(kvm) - _AC(1, ULL))
> +#define kvm_stage2_levels(kvm)		(kvm->arch.s2_levels)
>  
>  static inline bool kvm_page_empty(void *ptr)
>  {

[...]

> diff --git a/arch/arm64/include/asm/stage2_pgtable.h b/arch/arm64/include/asm/stage2_pgtable.h
> index 33e8ebb..9b75b83 100644
> --- a/arch/arm64/include/asm/stage2_pgtable.h
> +++ b/arch/arm64/include/asm/stage2_pgtable.h
> @@ -44,7 +44,6 @@
>   */
>  #define __s2_pgd_ptrs(pa, lvls)	(1 << ((pa) - pt_levels_pgdir_shift((lvls))))
>  
> -#define kvm_stage2_levels(kvm)		stage2_pt_levels(kvm_phys_shift(kvm))
>  #define stage2_pgdir_shift(kvm)	\
>  		pt_levels_pgdir_shift(kvm_stage2_levels(kvm))
>  #define stage2_pgdir_size(kvm)		(_AC(1, UL) << stage2_pgdir_shift((kvm)))

[...]

> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
> index 7a264c6..746f38e 100644
> --- a/virt/kvm/arm/mmu.c
> +++ b/virt/kvm/arm/mmu.c
> @@ -753,6 +753,10 @@ int kvm_alloc_stage2_pgd(struct kvm *kvm)
>  		return -EINVAL;
>  	}
>  
> +	/* Make sure we have the stage2 configured for this VM */
> +	if (WARN_ON(!kvm_stage2_levels(kvm)))
> +		return -EINVAL;
> +

This hunk breaks the 32-bit build as kvm_stag2_levels() isn't defined on
arm.

Thanks,
Punit

>  	/* Allocate the HW PGD, making sure that each page gets its own refcount */
>  	pgd = alloc_pages_exact(stage2_pgd_size(kvm), GFP_KERNEL | __GFP_ZERO);
>  	if (!pgd)
