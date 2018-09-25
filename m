From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v5 17/18] kvm: arm64: Limit the minimum number of page
 table levels
Date: Tue, 25 Sep 2018 12:00:48 +0200
Message-ID: <59231541-311f-e04b-3e6b-e073a8392316@redhat.com>
References: <20180917104144.19188-1-suzuki.poulose@arm.com>
 <20180917104144.19188-18-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180917104144.19188-18-suzuki.poulose@arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Suzuki K Poulose <suzuki.poulose@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, marc.zyngier@arm.com, cdall@kernel.org, pbonzini@redhat.com, rkrcmar@redhat.com, will.deacon@arm.com, catalin.marinas@arm.com, james.morse@arm.com, dave.martin@arm.com, julien.grall@arm.com, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Suzuki,

On 9/17/18 12:41 PM, Suzuki K Poulose wrote:
> Since we are about to remove the lower limit on the IPA size,
> make sure that we do not go to 1 level page table (e.g, with
> 32bit IPA on 64K host with concatenation) to avoid splitting
> the host PMD huge pages at stage2.
> 
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Christoffer Dall <cdall@kernel.org>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
>  arch/arm64/include/asm/stage2_pgtable.h |  8 +++++++-
>  arch/arm64/kvm/reset.c                  | 12 +++++++++++-
>  2 files changed, 18 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/stage2_pgtable.h b/arch/arm64/include/asm/stage2_pgtable.h
> index 352ec4158fdf..6a56fdff0823 100644
> --- a/arch/arm64/include/asm/stage2_pgtable.h
> +++ b/arch/arm64/include/asm/stage2_pgtable.h
> @@ -72,8 +72,14 @@
>  /*
>   * The number of PTRS across all concatenated stage2 tables given by the
>   * number of bits resolved at the initial level.
> + * If we force more number of levels than necessary, we may have
more levels?
> + * stage2_pgdir_shift > IPA, in which case, stage2_pgd_ptrs will have
> + * one entry.
>   */
> -#define __s2_pgd_ptrs(ipa, lvls)	(1 << ((ipa) - pt_levels_pgdir_shift((lvls))))
> +#define pgd_ptrs_shift(ipa, pgdir_shift)	\
> +	((ipa) > (pgdir_shift) ? ((ipa) - (pgdir_shift)) : 0)
> +#define __s2_pgd_ptrs(ipa, lvls)		\
> +	(1 << (pgd_ptrs_shift((ipa), pt_levels_pgdir_shift(lvls))))
>  #define __s2_pgd_size(ipa, lvls)	(__s2_pgd_ptrs((ipa), (lvls)) * sizeof(pgd_t))
>  
>  #define stage2_pgd_ptrs(kvm)		__s2_pgd_ptrs(kvm_phys_shift(kvm), kvm_stage2_levels(kvm))
> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index 76972b19bdd7..0393bb974b23 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -190,10 +190,19 @@ int kvm_arm_config_vm(struct kvm *kvm, unsigned long type)
>  {
>  	u64 vtcr = VTCR_EL2_FLAGS;
>  	u64 parange;
> +	u8 lvls;
>  
>  	if (type)
>  		return -EINVAL;
>  
> +	/*
> +	 * Use a minimum 2 level page table to prevent splitting
> +	 * host PMD huge pages at stage2.
> +	 */
> +	lvls = stage2_pgtable_levels(KVM_PHYS_SHIFT);
> +	if (lvls < 2)
> +		lvls = 2;
> +
>  	parange = read_sanitised_ftr_reg(SYS_ID_AA64MMFR0_EL1) & 7;
>  	if (parange > ID_AA64MMFR0_PARANGE_MAX)
>  		parange = ID_AA64MMFR0_PARANGE_MAX;
> @@ -210,7 +219,8 @@ int kvm_arm_config_vm(struct kvm *kvm, unsigned long type)
>  	vtcr |= (kvm_get_vmid_bits() == 16) ?
>  		VTCR_EL2_VS_16BIT :
>  		VTCR_EL2_VS_8BIT;
> -	vtcr |= VTCR_EL2_LVLS_TO_SL0(stage2_pgtable_levels(KVM_PHYS_SHIFT));
> +
nit: new line not requested

Thanks

Eric
> +	vtcr |= VTCR_EL2_LVLS_TO_SL0(lvls);
>  	vtcr |= VTCR_EL2_T0SZ(KVM_PHYS_SHIFT);
>  
>  	kvm->arch.vtcr = vtcr;
> 
