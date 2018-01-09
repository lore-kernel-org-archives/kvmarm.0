From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v2 2/2] arm64: Implement branch predictor hardening for
 Falkor
Date: Tue, 9 Jan 2018 08:22:27 +0000
Message-ID: <CAKv+Gu9mLQn7cWy_0=p2KdnkKRGT9SMAskhez9n_aEGF+5SOxA@mail.gmail.com>
References: <1515447068-20977-1-git-send-email-shankerd@codeaurora.org>
 <1515447068-20977-2-git-send-email-shankerd@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0173549D14
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Jan 2018 03:17:48 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qbYq6eE1yjbo for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Jan 2018 03:17:46 -0500 (EST)
Received: from mail-it0-f68.google.com (mail-it0-f68.google.com
 [209.85.214.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9C71B40D25
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Jan 2018 03:17:46 -0500 (EST)
Received: by mail-it0-f68.google.com with SMTP id c16so10654912itc.5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 09 Jan 2018 00:22:28 -0800 (PST)
In-Reply-To: <1515447068-20977-2-git-send-email-shankerd@codeaurora.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Shanker Donthineni <shankerd@codeaurora.org>
Cc: Thomas Speier <tspeier@codeaurora.org>, Sean Campbell <scampbel@codeaurora.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, Paolo Bonzini <pbonzini@redhat.com>, kvmarm <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 8 January 2018 at 21:31, Shanker Donthineni <shankerd@codeaurora.org> wrote:
> Falkor is susceptible to branch predictor aliasing and can
> theoretically be attacked by malicious code. This patch
> implements a mitigation for these attacks, preventing any
> malicious entries from affecting other victim contexts.
>
> Signed-off-by: Shanker Donthineni <shankerd@codeaurora.org>
> ---
> Changes since v1:
>   Corrected typo to fix the compilation errors if HARDEN_BRANCH_PREDICTOR=n
>
> This patch requires FALKOR MIDR which is available in upstream v4.15-rc7
>   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/arch/arm64?h=v4.15-rc7&id=c622cc013cece073722592cff1ac6643a33b1622 ans also
>   attached this v2 patch series.
>
>  arch/arm64/include/asm/cpucaps.h |  3 ++-
>  arch/arm64/include/asm/kvm_asm.h |  2 ++
>  arch/arm64/kernel/bpi.S          |  8 +++++++
>  arch/arm64/kernel/cpu_errata.c   | 49 ++++++++++++++++++++++++++++++++++++++--
>  arch/arm64/kvm/hyp/entry.S       | 12 ++++++++++
>  arch/arm64/kvm/hyp/switch.c      | 10 ++++++++
>  6 files changed, 81 insertions(+), 3 deletions(-)
>
> diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
> index 51616e7..7049b48 100644
> --- a/arch/arm64/include/asm/cpucaps.h
> +++ b/arch/arm64/include/asm/cpucaps.h
> @@ -43,7 +43,8 @@
>  #define ARM64_SVE                              22
>  #define ARM64_UNMAP_KERNEL_AT_EL0              23
>  #define ARM64_HARDEN_BRANCH_PREDICTOR          24
> +#define ARM64_HARDEN_BP_POST_GUEST_EXIT                25
>
> -#define ARM64_NCAPS                            25
> +#define ARM64_NCAPS                            26
>
>  #endif /* __ASM_CPUCAPS_H */
> diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> index ab4d0a9..24961b7 100644
> --- a/arch/arm64/include/asm/kvm_asm.h
> +++ b/arch/arm64/include/asm/kvm_asm.h
> @@ -68,6 +68,8 @@
>
>  extern u32 __init_stage2_translation(void);
>
> +extern void __qcom_hyp_sanitize_btac_predictors(void);
> +
>  #endif
>
>  #endif /* __ARM_KVM_ASM_H__ */
> diff --git a/arch/arm64/kernel/bpi.S b/arch/arm64/kernel/bpi.S
> index 2b10d52..44ffcda 100644
> --- a/arch/arm64/kernel/bpi.S
> +++ b/arch/arm64/kernel/bpi.S
> @@ -77,3 +77,11 @@ ENTRY(__psci_hyp_bp_inval_start)
>         ldp     x2, x3, [sp], #16
>         ldp     x0, x1, [sp], #16
>  ENTRY(__psci_hyp_bp_inval_end)
> +
> +ENTRY(__qcom_hyp_sanitize_link_stack_start)
> +       stp     x29, x30, [sp, #-16]!
> +       .rept   16
> +       bl      . + 4
> +       .endr
> +       ldp     x29, x30, [sp], #16
> +ENTRY(__qcom_hyp_sanitize_link_stack_end)
> diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
> index cb0fb37..9ee9d2e 100644
> --- a/arch/arm64/kernel/cpu_errata.c
> +++ b/arch/arm64/kernel/cpu_errata.c
> @@ -54,6 +54,8 @@ static int cpu_enable_trap_ctr_access(void *__unused)
>
>  #ifdef CONFIG_KVM
>  extern char __psci_hyp_bp_inval_start[], __psci_hyp_bp_inval_end[];
> +extern char __qcom_hyp_sanitize_link_stack_start[];
> +extern char __qcom_hyp_sanitize_link_stack_end[];
>
>  static void __copy_hyp_vect_bpi(int slot, const char *hyp_vecs_start,
>                                 const char *hyp_vecs_end)
> @@ -96,8 +98,10 @@ static void __install_bp_hardening_cb(bp_hardening_cb_t fn,
>         spin_unlock(&bp_lock);
>  }
>  #else
> -#define __psci_hyp_bp_inval_start      NULL
> -#define __psci_hyp_bp_inval_end                NULL
> +#define __psci_hyp_bp_inval_start              NULL
> +#define __psci_hyp_bp_inval_end                        NULL
> +#define __qcom_hyp_sanitize_link_stack_start   NULL
> +#define __qcom_hyp_sanitize_link_stack_end     NULL
>
>  static void __install_bp_hardening_cb(bp_hardening_cb_t fn,
>                                       const char *hyp_vecs_start,
> @@ -138,6 +142,29 @@ static int enable_psci_bp_hardening(void *data)
>
>         return 0;
>  }
> +
> +static void qcom_link_stack_sanitization(void)
> +{
> +       u64 tmp;
> +
> +       asm volatile("mov       %0, x30         \n"
> +                    ".rept     16              \n"
> +                    "bl        . + 4           \n"
> +                    ".endr                     \n"
> +                    "mov       x30, %0         \n"
> +                    : "=&r" (tmp));
> +}
> +

Couldn't you just add x30 to the clobber list here?

> +static int qcom_enable_link_stack_sanitization(void *data)
> +{
> +       const struct arm64_cpu_capabilities *entry = data;
> +
> +       install_bp_hardening_cb(entry, qcom_link_stack_sanitization,
> +                               __qcom_hyp_sanitize_link_stack_start,
> +                               __qcom_hyp_sanitize_link_stack_end);
> +
> +       return 0;
> +}
>  #endif /* CONFIG_HARDEN_BRANCH_PREDICTOR */
>
>  #define MIDR_RANGE(model, min, max) \
> @@ -302,6 +329,24 @@ static int enable_psci_bp_hardening(void *data)
>                 MIDR_ALL_VERSIONS(MIDR_CORTEX_A75),
>                 .enable = enable_psci_bp_hardening,
>         },
> +       {
> +               .capability = ARM64_HARDEN_BRANCH_PREDICTOR,
> +               MIDR_ALL_VERSIONS(MIDR_QCOM_FALKOR_V1),
> +               .enable = qcom_enable_link_stack_sanitization,
> +       },
> +       {
> +               .capability = ARM64_HARDEN_BRANCH_PREDICTOR,
> +               MIDR_ALL_VERSIONS(MIDR_QCOM_FALKOR),
> +               .enable = qcom_enable_link_stack_sanitization,
> +       },
> +       {
> +               .capability = ARM64_HARDEN_BP_POST_GUEST_EXIT,
> +               MIDR_ALL_VERSIONS(MIDR_QCOM_FALKOR_V1),
> +       },
> +       {
> +               .capability = ARM64_HARDEN_BP_POST_GUEST_EXIT,
> +               MIDR_ALL_VERSIONS(MIDR_QCOM_FALKOR),
> +       },
>  #endif
>         {
>         }
> diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
> index 12ee62d..9c45c6a 100644
> --- a/arch/arm64/kvm/hyp/entry.S
> +++ b/arch/arm64/kvm/hyp/entry.S
> @@ -196,3 +196,15 @@ alternative_endif
>
>         eret
>  ENDPROC(__fpsimd_guest_restore)
> +
> +ENTRY(__qcom_hyp_sanitize_btac_predictors)
> +       /**
> +        * Call SMC64 with Silicon provider serviceID 23<<8 (0xc2001700)
> +        * 0xC2000000-0xC200FFFF: assigned to SiP Service Calls
> +        * b15-b0: contains SiP functionID
> +        */
> +       movz    x0, #0x1700
> +       movk    x0, #0xc200, lsl #16
> +       smc     #0
> +       ret
> +ENDPROC(__qcom_hyp_sanitize_btac_predictors)
> diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> index 4d273f6..7e37379 100644
> --- a/arch/arm64/kvm/hyp/switch.c
> +++ b/arch/arm64/kvm/hyp/switch.c
> @@ -406,6 +406,16 @@ int __hyp_text __kvm_vcpu_run(struct kvm_vcpu *vcpu)
>                 /* 0 falls through to be handled out of EL2 */
>         }
>
> +       if (cpus_have_const_cap(ARM64_HARDEN_BP_POST_GUEST_EXIT)) {
> +               u32 midr = read_cpuid_id();
> +
> +               /* Apply BTAC predictors mitigation to all Falkor chips */
> +               if (((midr & MIDR_CPU_MODEL_MASK) == MIDR_QCOM_FALKOR) ||
> +                   ((midr & MIDR_CPU_MODEL_MASK) == MIDR_QCOM_FALKOR_V1)) {
> +                       __qcom_hyp_sanitize_btac_predictors();
> +               }
> +       }
> +
>         fp_enabled = __fpsimd_enabled();
>
>         __sysreg_save_guest_state(guest_ctxt);
> --
> Qualcomm Datacenter Technologies, Inc. on behalf of the Qualcomm Technologies, Inc.
> Qualcomm Technologies, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project.
>
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
