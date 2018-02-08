From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v1 14/16] kvm: arm64: Switch to per VM IPA
Date: Thu, 8 Feb 2018 12:00:35 +0100
Message-ID: <20180208110035.GG29286@cbox>
References: <20180109190414.4017-1-suzuki.poulose@arm.com>
 <20180109190414.4017-15-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180109190414.4017-15-suzuki.poulose@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, linux-kernel@vger.kernel.org, kristina.martsenko@arm.com, peter.maydell@linaro.org, pbonzini@redhat.com, rkrcmar@redhat.com, will.deacon@arm.com, ard.biesheuvel@linaro.org, mark.rutland@arm.com, catalin.marinas@arm.com, Christoffer Dall <cdall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Jan 09, 2018 at 07:04:09PM +0000, Suzuki K Poulose wrote:
> Now that we can manage the stage2 page table per VM, switch the
> configuration details to per VM instance. We keep track of the
> IPA bits, number of page table levels and the VTCR bits (which
> depends on the IPA and the number of levels).
> 
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Christoffer Dall <cdall@linaro.org>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
>  arch/arm/include/asm/kvm_mmu.h          |  1 +
>  arch/arm64/include/asm/kvm_host.h       | 12 ++++++++++++
>  arch/arm64/include/asm/kvm_mmu.h        | 22 ++++++++++++++++++++--
>  arch/arm64/include/asm/stage2_pgtable.h |  1 -
>  arch/arm64/kvm/hyp/switch.c             |  3 +--
>  virt/kvm/arm/arm.c                      |  2 +-
>  6 files changed, 35 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
> index 440c80589453..dd592fe45660 100644
> --- a/arch/arm/include/asm/kvm_mmu.h
> +++ b/arch/arm/include/asm/kvm_mmu.h
> @@ -48,6 +48,7 @@
>  #define kvm_vttbr_baddr_mask(kvm)	VTTBR_BADDR_MASK
>  
>  #define stage2_pgd_size(kvm)	(PTRS_PER_S2_PGD * sizeof(pgd_t))
> +#define kvm_init_stage2_config(kvm)	do { } while (0)
>  int create_hyp_mappings(void *from, void *to, pgprot_t prot);
>  int create_hyp_io_mappings(void *from, void *to, phys_addr_t);
>  void free_hyp_pgds(void);
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 9a9ddeb33c84..1e66e5ab3dde 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -64,6 +64,18 @@ struct kvm_arch {
>  	/* VTTBR value associated with above pgd and vmid */
>  	u64    vttbr;
>  
> +	/* Private bits of VTCR_EL2 for this VM */
> +	u64    vtcr_private;

As to my comments in the previous patch, why isn't this simply u64 vtcr;

Thanks,
-Christoffer

> +	/* Size of the PA size for this guest */
> +	u8     phys_shift;
> +	/*
> +	 * Number of levels in page table. We could always calculate
> +	 * it from phys_shift above. We cache it for faster switches
> +	 * in stage2 page table helpers.
> +	 */
> +	u8     s2_levels;
> +
> +
>  	/* The last vcpu id that ran on each physical CPU */
>  	int __percpu *last_vcpu_ran;
>  
> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> index 483185ed2ecd..ab6a8b905065 100644
> --- a/arch/arm64/include/asm/kvm_mmu.h
> +++ b/arch/arm64/include/asm/kvm_mmu.h
> @@ -134,11 +134,12 @@ static inline unsigned long __kern_hyp_va(unsigned long v)
>  /*
>   * We currently only support a 40bit IPA.
>   */
> -#define KVM_PHYS_SHIFT	(40)
> +#define KVM_PHYS_SHIFT_DEFAULT	(40)
>  
> -#define kvm_phys_shift(kvm)		KVM_PHYS_SHIFT
> +#define kvm_phys_shift(kvm)		(kvm->arch.phys_shift)
>  #define kvm_phys_size(kvm)		(_AC(1, ULL) << kvm_phys_shift(kvm))
>  #define kvm_phys_mask(kvm)		(kvm_phys_size(kvm) - _AC(1, ULL))
> +#define kvm_stage2_levels(kvm)		(kvm->arch.s2_levels)
>  
>  static inline bool kvm_page_empty(void *ptr)
>  {
> @@ -346,5 +347,22 @@ static inline u64 kvm_vttbr_baddr_mask(struct kvm *kvm)
>  	return GENMASK_ULL(PHYS_MASK_SHIFT - 1, x);
>  }
>  
> +/*
> + * kvm_init_stage2_config: Initialise the VM specific stage2 page table
> + * details to default IPA size.
> + */
> +static inline void kvm_init_stage2_config(struct kvm *kvm)
> +{
> +	/*
> +	 * The stage2 PGD is dependent on the settings we initialise here
> +	 * and should be allocated only after this step.
> +	 */
> +	VM_BUG_ON(kvm->arch.pgd != NULL);
> +	kvm->arch.phys_shift = KVM_PHYS_SHIFT_DEFAULT;
> +	kvm->arch.s2_levels = stage2_pt_levels(kvm->arch.phys_shift);
> +	kvm->arch.vtcr_private = VTCR_EL2_SL0(kvm->arch.s2_levels) |
> +				 TCR_T0SZ(kvm->arch.phys_shift);
> +}
> +
>  #endif /* __ASSEMBLY__ */
>  #endif /* __ARM64_KVM_MMU_H__ */
> diff --git a/arch/arm64/include/asm/stage2_pgtable.h b/arch/arm64/include/asm/stage2_pgtable.h
> index 33e8ebb25037..9b75b83da643 100644
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
> diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> index 523471f0af7b..d0725562ee3f 100644
> --- a/arch/arm64/kvm/hyp/switch.c
> +++ b/arch/arm64/kvm/hyp/switch.c
> @@ -160,8 +160,7 @@ static void __hyp_text __activate_vm(struct kvm_vcpu *vcpu)
>  	u64 vtcr = read_sysreg(vtcr_el2);
>  
>  	vtcr &= ~VTCR_EL2_PRIVATE_MASK;
> -	vtcr |= VTCR_EL2_SL0(stage2_pt_levels(kvm)) |
> -		VTCR_EL2_T0SZ(kvm_phys_shift(kvm));
> +	vtcr |= kvm->arch.vtcr_private;
>  	write_sysreg(vtcr, vtcr_el2);
>  	write_sysreg(kvm->arch.vttbr, vttbr_el2);
>  }
> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> index 8564ed907b18..e0bf8d19fcfe 100644
> --- a/virt/kvm/arm/arm.c
> +++ b/virt/kvm/arm/arm.c
> @@ -143,7 +143,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>  	/* The maximum number of VCPUs is limited by the host's GIC model */
>  	kvm->arch.max_vcpus = vgic_present ?
>  				kvm_vgic_get_max_vcpus() : KVM_MAX_VCPUS;
> -
> +	kvm_init_stage2_config(kvm);
>  	return ret;
>  }
>  
> -- 
> 2.13.6
> 
