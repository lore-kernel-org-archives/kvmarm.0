From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v6 13/18] kvm: arm64: Switch to per VM IPA limit
Date: Tue, 2 Oct 2018 09:58:27 +0200
Message-ID: <ecaafbc4-ea70-d0e6-ced0-8ab90f445e4b@redhat.com>
References: <20180926163258.20218-1-suzuki.poulose@arm.com>
 <20180926163258.20218-14-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180926163258.20218-14-suzuki.poulose@arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Suzuki K Poulose <suzuki.poulose@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, marc.zyngier@arm.com, cdall@kernel.org, will.deacon@arm.com, dave.martin@arm.com, peter.maydell@linaro.org, pbonzini@redhat.com, rkrcmar@redhat.com, julien.grall@arm.com, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Suzuki,
On 9/26/18 6:32 PM, Suzuki K Poulose wrote:
> Now that we can manage the stage2 page table per VM, switch the
> configuration details to per VM instance. The VTCR is updated
> with the values specific to the VM based on the configuration.
> We store the IPA size and the number of stage2 page table levels
> for the guest already in VTCR. Decode it back from the vtcr
> field wherever we need it.
> 
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Christoffer Dall <cdall@kernel.org>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>

Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric
> ---
>  arch/arm64/include/asm/kvm_arm.h        | 2 ++
>  arch/arm64/include/asm/kvm_mmu.h        | 2 +-
>  arch/arm64/include/asm/stage2_pgtable.h | 2 +-
>  arch/arm64/kvm/reset.c                  | 2 +-
>  4 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
> index f913adb44f93..e4240568cc18 100644
> --- a/arch/arm64/include/asm/kvm_arm.h
> +++ b/arch/arm64/include/asm/kvm_arm.h
> @@ -197,6 +197,8 @@
>  	VTCR_EL2_SL0_TO_LVLS(((vtcr) & VTCR_EL2_SL0_MASK) >> VTCR_EL2_SL0_SHIFT)
>  
>  #define VTCR_EL2_FLAGS			(VTCR_EL2_COMMON_BITS | VTCR_EL2_TGRAN)
> +#define VTCR_EL2_IPA(vtcr)		(64 - ((vtcr) & VTCR_EL2_T0SZ_MASK))
> +
>  /*
>   * ARM VMSAv8-64 defines an algorithm for finding the translation table
>   * descriptors in section D4.2.8 in ARM DDI 0487C.a.
> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> index ac3ca9690bad..77b1af9e64db 100644
> --- a/arch/arm64/include/asm/kvm_mmu.h
> +++ b/arch/arm64/include/asm/kvm_mmu.h
> @@ -142,7 +142,7 @@ static inline unsigned long __kern_hyp_va(unsigned long v)
>   */
>  #define KVM_PHYS_SHIFT	(40)
>  
> -#define kvm_phys_shift(kvm)		KVM_PHYS_SHIFT
> +#define kvm_phys_shift(kvm)		VTCR_EL2_IPA(kvm->arch.vtcr)
>  #define kvm_phys_size(kvm)		(_AC(1, ULL) << kvm_phys_shift(kvm))
>  #define kvm_phys_mask(kvm)		(kvm_phys_size(kvm) - _AC(1, ULL))
>  
> diff --git a/arch/arm64/include/asm/stage2_pgtable.h b/arch/arm64/include/asm/stage2_pgtable.h
> index 36a0a1165003..c62fe118a898 100644
> --- a/arch/arm64/include/asm/stage2_pgtable.h
> +++ b/arch/arm64/include/asm/stage2_pgtable.h
> @@ -43,7 +43,7 @@
>   */
>  #define stage2_pgtable_levels(ipa)	ARM64_HW_PGTABLE_LEVELS((ipa) - 4)
>  #define STAGE2_PGTABLE_LEVELS		stage2_pgtable_levels(KVM_PHYS_SHIFT)
> -#define kvm_stage2_levels(kvm)		stage2_pgtable_levels(kvm_phys_shift(kvm))
> +#define kvm_stage2_levels(kvm)		VTCR_EL2_LVLS(kvm->arch.vtcr)
>  
>  /*
>   * With all the supported VA_BITs and 40bit guest IPA, the following condition
> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index 1ced1e37374e..2bf41e007390 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -160,7 +160,7 @@ int kvm_arm_config_vm(struct kvm *kvm, unsigned long type)
>  	if (phys_shift > KVM_PHYS_SHIFT)
>  		phys_shift = KVM_PHYS_SHIFT;
>  	vtcr |= VTCR_EL2_T0SZ(phys_shift);
> -	vtcr |= VTCR_EL2_LVLS_TO_SL0(kvm_stage2_levels(kvm));
> +	vtcr |= VTCR_EL2_LVLS_TO_SL0(stage2_pgtable_levels(phys_shift));
>  
>  	/*
>  	 * Enable the Hardware Access Flag management, unconditionally
> 
