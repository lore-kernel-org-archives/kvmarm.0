From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v1 13/16] kvm: arm64: Configure VTCR per VM
Date: Thu, 8 Feb 2018 19:04:14 +0100
Message-ID: <CAMJs5B_yvM8XNT=g8uN63G1G6uwGQcYF_0dxbC1Gaeb+j6UvpQ@mail.gmail.com>
References: <20180109190414.4017-1-suzuki.poulose@arm.com> <20180109190414.4017-14-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180109190414.4017-14-suzuki.poulose@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Linux ARM <linux-arm-kernel@lists.infradead.org>, KVM <kvm@vger.kernel.org>, kvmarm@lists.cs.columbia.edu, Marc Zyngier <marc.zyngier@arm.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Kristina Martsenko <kristina.martsenko@arm.com>, Peter Maydell <peter.maydell@linaro.org>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Will Deacon <will.deacon@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Christoffer Dall <cdall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Jan 09, 2018 at 07:04:08PM +0000, Suzuki K Poulose wrote:
> We set VTCR_EL2 very early during the stage2 init and don't
> touch it ever. This is fine as we had a fixed IPA size. This
> patch changes the behavior to set the VTCR for a given VM,
> depending on its stage2 table. The common configuration for
> VTCR is still performed during the early init. But the SL0
> and T0SZ are programmed for each VM and is cleared once we
> exit the VM.
>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Christoffer Dall <cdall@linaro.org>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
>  arch/arm64/include/asm/kvm_arm.h  | 16 ++++++----------
>  arch/arm64/include/asm/kvm_asm.h  |  2 +-
>  arch/arm64/include/asm/kvm_host.h |  8 +++++---
>  arch/arm64/kvm/hyp/s2-setup.c     | 16 +---------------
>  arch/arm64/kvm/hyp/switch.c       |  9 +++++++++
>  5 files changed, 22 insertions(+), 29 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
> index eb90d349e55f..d5c40816f073 100644
> --- a/arch/arm64/include/asm/kvm_arm.h
> +++ b/arch/arm64/include/asm/kvm_arm.h
> @@ -115,9 +115,7 @@
>  #define VTCR_EL2_IRGN0_WBWA TCR_IRGN0_WBWA
>  #define VTCR_EL2_SL0_SHIFT 6
>  #define VTCR_EL2_SL0_MASK (3 << VTCR_EL2_SL0_SHIFT)
> -#define VTCR_EL2_SL0_LVL1 (1 << VTCR_EL2_SL0_SHIFT)
>  #define VTCR_EL2_T0SZ_MASK 0x3f
> -#define VTCR_EL2_T0SZ_40B 24
>  #define VTCR_EL2_VS_SHIFT 19
>  #define VTCR_EL2_VS_8BIT (0 << VTCR_EL2_VS_SHIFT)
>  #define VTCR_EL2_VS_16BIT (1 << VTCR_EL2_VS_SHIFT)
> @@ -139,38 +137,36 @@
>   * D4-23 and D4-25 in ARM DDI 0487A.b.
>   */
>
> -#define VTCR_EL2_T0SZ_IPA VTCR_EL2_T0SZ_40B
>  #define VTCR_EL2_COMMON_BITS (VTCR_EL2_SH0_INNER | VTCR_EL2_ORGN0_WBWA | \
>   VTCR_EL2_IRGN0_WBWA | VTCR_EL2_RES1)
> +#define VTCR_EL2_PRIVATE_MASK (VTCR_EL2_SL0_MASK | VTCR_EL2_T0SZ_MASK)
>
>  #ifdef CONFIG_ARM64_64K_PAGES
>  /*
>   * Stage2 translation configuration:
>   * 64kB pages (TG0 = 1)
> - * 2 level page tables (SL = 1)
>   */
> -#define VTCR_EL2_TGRAN_FLAGS (VTCR_EL2_TG0_64K | VTCR_EL2_SL0_LVL1)
> +#define VTCR_EL2_TGRAN VTCR_EL2_TG0_64K
>  #define VTCR_EL2_TGRAN_SL0_BASE 3UL
>
>  #elif defined(CONFIG_ARM64_16K_PAGES)
>  /*
>   * Stage2 translation configuration:
>   * 16kB pages (TG0 = 2)
> - * 2 level page tables (SL = 1)
>   */
> -#define VTCR_EL2_TGRAN_FLAGS (VTCR_EL2_TG0_16K | VTCR_EL2_SL0_LVL1)
> +#define VTCR_EL2_TGRAN VTCR_EL2_TG0_16K
>  #define VTCR_EL2_TGRAN_SL0_BASE 3UL
>  #else /* 4K */
>  /*
>   * Stage2 translation configuration:
>   * 4kB pages (TG0 = 0)
> - * 3 level page tables (SL = 1)
>   */
> -#define VTCR_EL2_TGRAN_FLAGS (VTCR_EL2_TG0_4K | VTCR_EL2_SL0_LVL1)
> +#define VTCR_EL2_TGRAN VTCR_EL2_TG0_4K
>  #define VTCR_EL2_TGRAN_SL0_BASE 2UL
>  #endif
>
> -#define VTCR_EL2_FLAGS (VTCR_EL2_COMMON_BITS | VTCR_EL2_TGRAN_FLAGS)
> +#define VTCR_EL2_FLAGS (VTCR_EL2_COMMON_BITS | VTCR_EL2_TGRAN)
> +
>  /*
>   * VTCR_EL2:SL0 indicates the entry level for Stage2 translation.
>   * Interestingly, it depends on the page size.
> diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> index ab4d0a926043..21cfd1fe692c 100644
> --- a/arch/arm64/include/asm/kvm_asm.h
> +++ b/arch/arm64/include/asm/kvm_asm.h
> @@ -66,7 +66,7 @@ extern void __vgic_v3_init_lrs(void);
>
>  extern u32 __kvm_get_mdcr_el2(void);
>
> -extern u32 __init_stage2_translation(void);
> +extern void __init_stage2_translation(void);
>
>  #endif
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index ea6cb5b24258..9a9ddeb33c84 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -380,10 +380,12 @@ int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
>
>  static inline void __cpu_init_stage2(void)
>  {
> - u32 parange = kvm_call_hyp(__init_stage2_translation);
> + u32 ps;
>
> - WARN_ONCE(parange < 40,
> -  "PARange is %d bits, unsupported configuration!", parange);
> + kvm_call_hyp(__init_stage2_translation);
> + ps = id_aa64mmfr0_parange_to_phys_shift(read_sysreg(id_aa64mmfr0_el1));
> + WARN_ONCE(ps < 40,
> +  "PARange is %d bits, unsupported configuration!", ps);
>  }
>
>  /*
> diff --git a/arch/arm64/kvm/hyp/s2-setup.c b/arch/arm64/kvm/hyp/s2-setup.c
> index b1129c83c531..5c26ad4b8ac9 100644
> --- a/arch/arm64/kvm/hyp/s2-setup.c
> +++ b/arch/arm64/kvm/hyp/s2-setup.c
> @@ -19,13 +19,11 @@
>  #include <asm/kvm_arm.h>
>  #include <asm/kvm_asm.h>
>  #include <asm/kvm_hyp.h>
> -#include <asm/cpufeature.h>
>
> -u32 __hyp_text __init_stage2_translation(void)
> +void __hyp_text __init_stage2_translation(void)
>  {
>   u64 val = VTCR_EL2_FLAGS;
>   u64 parange;
> - u32 phys_shift;
>   u64 tmp;
>
>   /*
> @@ -38,16 +36,6 @@ u32 __hyp_text __init_stage2_translation(void)
>   parange = ID_AA64MMFR0_PARANGE_MAX;
>   val |= parange << 16;
>
> - /* Compute the actual PARange... */
> - phys_shift = id_aa64mmfr0_parange_to_phys_shift(parange);
> -
> - /*
> - * ... and clamp it to 40 bits, unless we have some braindead
> - * HW that implements less than that. In all cases, we'll
> - * return that value for the rest of the kernel to decide what
> - * to do.
> - */
> - val |= 64 - (phys_shift > 40 ? 40 : phys_shift);
>
>   /*
>   * Check the availability of Hardware Access Flag / Dirty Bit
> @@ -67,6 +55,4 @@ u32 __hyp_text __init_stage2_translation(void)
>   VTCR_EL2_VS_8BIT;
>
>   write_sysreg(val, vtcr_el2);
> -
> - return phys_shift;
>  }
> diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> index f7c651f3a8c0..523471f0af7b 100644
> --- a/arch/arm64/kvm/hyp/switch.c
> +++ b/arch/arm64/kvm/hyp/switch.c
> @@ -157,11 +157,20 @@ static void __hyp_text __deactivate_traps(struct kvm_vcpu *vcpu)
>  static void __hyp_text __activate_vm(struct kvm_vcpu *vcpu)
>  {
>   struct kvm *kvm = kern_hyp_va(vcpu->kvm);
> + u64 vtcr = read_sysreg(vtcr_el2);
> +
> + vtcr &= ~VTCR_EL2_PRIVATE_MASK;
> + vtcr |= VTCR_EL2_SL0(stage2_pt_levels(kvm)) |
> + VTCR_EL2_T0SZ(kvm_phys_shift(kvm));
> + write_sysreg(vtcr, vtcr_el2);

If we're writing VTCR_EL2 on each entry, do we really need to read the
value back first and calculate things on every entry to the VM?  It
seems to me we should be able to compute the vtcr_el2 and store it on
struct kvm, and simply restore that per-VM value upon entering the VM?

>   write_sysreg(kvm->arch.vttbr, vttbr_el2);
>  }
>
>  static void __hyp_text __deactivate_vm(struct kvm_vcpu *vcpu)
>  {
> + u64 vtcr = read_sysreg(vtcr_el2) & ~VTCR_EL2_PRIVATE_MASK;
> +
> + write_sysreg(vtcr, vtcr_el2);

Why do we need to care about restoring VTCR when returning to the host?

>   write_sysreg(0, vttbr_el2);
>  }
>
> --
> 2.13.6
>

Thanks,
-Christoffer
