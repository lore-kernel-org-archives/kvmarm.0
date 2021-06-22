Return-Path: <SRS0=VGwd=LQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54ECDC48BE5
	for <kvmarm@archiver.kernel.org>; Tue, 22 Jun 2021 09:46:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D795E6135F
	for <kvmarm@archiver.kernel.org>; Tue, 22 Jun 2021 09:46:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D795E6135F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 52A3340825;
	Tue, 22 Jun 2021 05:46:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GpS2K3OPgxlL; Tue, 22 Jun 2021 05:46:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E12C240642;
	Tue, 22 Jun 2021 05:46:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7561140617
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Jun 2021 05:46:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jVGkHZT-HrLk for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Jun 2021 05:46:52 -0400 (EDT)
Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com
 [209.85.210.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 87FF0402DB
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Jun 2021 05:46:52 -0400 (EDT)
Received: by mail-ot1-f41.google.com with SMTP id
 h24-20020a9d64180000b029036edcf8f9a6so20661189otl.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Jun 2021 02:46:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=d1UfC4H1ralRKZkEo08JAlC57I2hJMgtts4Z/YHiLVE=;
 b=IpAgVOz9yIT+DkcxS5rerGZVtoHeldBqGk2MUylaBF9eN0Nujq5+45xPaci0QvPlCi
 SwlENnorPSrZkGIi7nWTxcQYcUjUNbcrMAcZeDsyjDGj3jXJh65mQlj0stkRacLmK0LO
 398DqiZA1SF01Wv5z/a8O7+MhOoYM04LpMnsNcCxXkCFGQ3h9dCihcTg+nz5GrUGEBCs
 GX+yAZyS6OS17/vtkG/YFplgH/bAsNYjCdGuEVlWyIyWwTgps1z9jOiHE6GSl437s/ET
 tv9RcJAHGlfYi5GFdWBCLz2ON1hgMFqcDZOCLw02y9cJxtR8tR3PGQpgiypIGQWVho82
 m13g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=d1UfC4H1ralRKZkEo08JAlC57I2hJMgtts4Z/YHiLVE=;
 b=X2k2Fm9OchNwZ9oAFf0TdEA+DkJe6dOl9YIcCDDC4gD478ioy/5YXPSvxoIC7XL+tw
 RsSIYlaSsrzfM3vAzWOqGJcaYVzWEf3YSqDj1SMpcEcXkSO3CgEsRyfXiSADRkfWBs9S
 Ttx4NAUmzVT0D3AVRbJWZZja009Es13PsR/zOGrqQDyv7F0mMeNwxDTmSrtAM86MLkV6
 GBrQ4Xxky4tWa3l7BLwAPeViuIWpt9L90sp32O2k99xxCdxi+DxUUQhZQR2zwEsULMCE
 FxJ+qVOz9L6D3qhw0Wkgpxj5M3pUIM1kuAqLLwjtBXyx2avkx2i/ly4NgUGhorbKmhbJ
 789A==
X-Gm-Message-State: AOAM530gW3yBZErT8DTH5ODF9nOiZxhhPkBwN58ylijC+HXv4usXYSWa
 /PRLmfKl7oxPSfgCVmN57Zt8z2NczrSfbxw+VIG5Dw==
X-Google-Smtp-Source: ABdhPJyMnWJ/gEe46ieCeEy/6Avin0t5ldg5f3moyL/01IXlHdTQP8jtukid0+EKqPjLSSIr725dvAv6OwiBnnLDwHY=
X-Received: by 2002:a05:6830:1598:: with SMTP id
 i24mr2396544otr.52.1624355211738; 
 Tue, 22 Jun 2021 02:46:51 -0700 (PDT)
MIME-Version: 1.0
References: <20210621111716.37157-1-steven.price@arm.com>
 <20210621111716.37157-4-steven.price@arm.com>
In-Reply-To: <20210621111716.37157-4-steven.price@arm.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 22 Jun 2021 10:46:15 +0100
Message-ID: <CA+EHjTzhJ5rkQ+GW643f_R7XP9L5SH0EGD78Ux=MGqfHGq2BbA@mail.gmail.com>
Subject: Re: [PATCH v17 3/6] KVM: arm64: Save/restore MTE registers
To: Steven Price <steven.price@arm.com>
Cc: Juan Quintela <quintela@redhat.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Richard Henderson <richard.henderson@linaro.org>, qemu-devel@nongnu.org,
 "Dr. David Alan Gilbert" <dgilbert@redhat.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
 Thomas Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>,
 Dave Martin <Dave.Martin@arm.com>, linux-kernel@vger.kernel.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi,

> diff --git a/arch/arm64/include/asm/kvm_mte.h b/arch/arm64/include/asm/kvm_mte.h
> new file mode 100644
> index 000000000000..88dd1199670b
> --- /dev/null
> +++ b/arch/arm64/include/asm/kvm_mte.h
> @@ -0,0 +1,66 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (C) 2020-2021 ARM Ltd.
> + */
> +#ifndef __ASM_KVM_MTE_H
> +#define __ASM_KVM_MTE_H
> +
> +#ifdef __ASSEMBLY__
> +
> +#include <asm/sysreg.h>
> +
> +#ifdef CONFIG_ARM64_MTE
> +
> +.macro mte_switch_to_guest g_ctxt, h_ctxt, reg1
> +alternative_if_not ARM64_MTE
> +       b       .L__skip_switch\@
> +alternative_else_nop_endif
> +       mrs     \reg1, hcr_el2
> +       tbz     \reg1, #(HCR_ATA_SHIFT), .L__skip_switch\@
> +
> +       mrs_s   \reg1, SYS_RGSR_EL1
> +       str     \reg1, [\h_ctxt, #CPU_RGSR_EL1]
> +       mrs_s   \reg1, SYS_GCR_EL1
> +       str     \reg1, [\h_ctxt, #CPU_GCR_EL1]
> +
> +       ldr     \reg1, [\g_ctxt, #CPU_RGSR_EL1]
> +       msr_s   SYS_RGSR_EL1, \reg1
> +       ldr     \reg1, [\g_ctxt, #CPU_GCR_EL1]
> +       msr_s   SYS_GCR_EL1, \reg1
> +
> +.L__skip_switch\@:
> +.endm
> +
> +.macro mte_switch_to_hyp g_ctxt, h_ctxt, reg1
> +alternative_if_not ARM64_MTE
> +       b       .L__skip_switch\@
> +alternative_else_nop_endif
> +       mrs     \reg1, hcr_el2
> +       tbz     \reg1, #(HCR_ATA_SHIFT), .L__skip_switch\@
> +
> +       mrs_s   \reg1, SYS_RGSR_EL1
> +       str     \reg1, [\g_ctxt, #CPU_RGSR_EL1]
> +       mrs_s   \reg1, SYS_GCR_EL1
> +       str     \reg1, [\g_ctxt, #CPU_GCR_EL1]
> +
> +       ldr     \reg1, [\h_ctxt, #CPU_RGSR_EL1]
> +       msr_s   SYS_RGSR_EL1, \reg1
> +       ldr     \reg1, [\h_ctxt, #CPU_GCR_EL1]
> +       msr_s   SYS_GCR_EL1, \reg1
> +
> +       isb
> +
> +.L__skip_switch\@:
> +.endm
> +
> +#else /* CONFIG_ARM64_MTE */

nit: !CONFIG_ARM64_MTE (clearer and matches the style in kvm_ptrauth.h)

Cheers,
/fuad


> +
> +.macro mte_switch_to_guest g_ctxt, h_ctxt, reg1
> +.endm
> +
> +.macro mte_switch_to_hyp g_ctxt, h_ctxt, reg1
> +.endm
> +
> +#endif /* CONFIG_ARM64_MTE */
> +#endif /* __ASSEMBLY__ */
> +#endif /* __ASM_KVM_MTE_H */
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index 65d15700a168..347ccac2341e 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -651,7 +651,8 @@
>
>  #define INIT_SCTLR_EL2_MMU_ON                                          \
>         (SCTLR_ELx_M  | SCTLR_ELx_C | SCTLR_ELx_SA | SCTLR_ELx_I |      \
> -        SCTLR_ELx_IESB | SCTLR_ELx_WXN | ENDIAN_SET_EL2 | SCTLR_EL2_RES1)
> +        SCTLR_ELx_IESB | SCTLR_ELx_WXN | ENDIAN_SET_EL2 |              \
> +        SCTLR_ELx_ITFSB | SCTLR_EL2_RES1)
>
>  #define INIT_SCTLR_EL2_MMU_OFF \
>         (SCTLR_EL2_RES1 | ENDIAN_SET_EL2)
> diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
> index 0cb34ccb6e73..6f0044cb233e 100644
> --- a/arch/arm64/kernel/asm-offsets.c
> +++ b/arch/arm64/kernel/asm-offsets.c
> @@ -111,6 +111,8 @@ int main(void)
>    DEFINE(VCPU_WORKAROUND_FLAGS,        offsetof(struct kvm_vcpu, arch.workaround_flags));
>    DEFINE(VCPU_HCR_EL2,         offsetof(struct kvm_vcpu, arch.hcr_el2));
>    DEFINE(CPU_USER_PT_REGS,     offsetof(struct kvm_cpu_context, regs));
> +  DEFINE(CPU_RGSR_EL1,         offsetof(struct kvm_cpu_context, sys_regs[RGSR_EL1]));
> +  DEFINE(CPU_GCR_EL1,          offsetof(struct kvm_cpu_context, sys_regs[GCR_EL1]));
>    DEFINE(CPU_APIAKEYLO_EL1,    offsetof(struct kvm_cpu_context, sys_regs[APIAKEYLO_EL1]));
>    DEFINE(CPU_APIBKEYLO_EL1,    offsetof(struct kvm_cpu_context, sys_regs[APIBKEYLO_EL1]));
>    DEFINE(CPU_APDAKEYLO_EL1,    offsetof(struct kvm_cpu_context, sys_regs[APDAKEYLO_EL1]));
> diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
> index e831d3dfd50d..435346ea1504 100644
> --- a/arch/arm64/kvm/hyp/entry.S
> +++ b/arch/arm64/kvm/hyp/entry.S
> @@ -13,6 +13,7 @@
>  #include <asm/kvm_arm.h>
>  #include <asm/kvm_asm.h>
>  #include <asm/kvm_mmu.h>
> +#include <asm/kvm_mte.h>
>  #include <asm/kvm_ptrauth.h>
>
>         .text
> @@ -51,6 +52,9 @@ alternative_else_nop_endif
>
>         add     x29, x0, #VCPU_CONTEXT
>
> +       // mte_switch_to_guest(g_ctxt, h_ctxt, tmp1)
> +       mte_switch_to_guest x29, x1, x2
> +
>         // Macro ptrauth_switch_to_guest format:
>         //      ptrauth_switch_to_guest(guest cxt, tmp1, tmp2, tmp3)
>         // The below macro to restore guest keys is not implemented in C code
> @@ -142,6 +146,9 @@ SYM_INNER_LABEL(__guest_exit, SYM_L_GLOBAL)
>         // when this feature is enabled for kernel code.
>         ptrauth_switch_to_hyp x1, x2, x3, x4, x5
>
> +       // mte_switch_to_hyp(g_ctxt, h_ctxt, reg1)
> +       mte_switch_to_hyp x1, x2, x3
> +
>         // Restore hyp's sp_el0
>         restore_sp_el0 x2, x3
>
> diff --git a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
> index cce43bfe158f..de7e14c862e6 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
> @@ -14,6 +14,7 @@
>  #include <asm/kvm_asm.h>
>  #include <asm/kvm_emulate.h>
>  #include <asm/kvm_hyp.h>
> +#include <asm/kvm_mmu.h>
>
>  static inline void __sysreg_save_common_state(struct kvm_cpu_context *ctxt)
>  {
> @@ -26,6 +27,16 @@ static inline void __sysreg_save_user_state(struct kvm_cpu_context *ctxt)
>         ctxt_sys_reg(ctxt, TPIDRRO_EL0) = read_sysreg(tpidrro_el0);
>  }
>
> +static inline bool ctxt_has_mte(struct kvm_cpu_context *ctxt)
> +{
> +       struct kvm_vcpu *vcpu = ctxt->__hyp_running_vcpu;
> +
> +       if (!vcpu)
> +               vcpu = container_of(ctxt, struct kvm_vcpu, arch.ctxt);
> +
> +       return kvm_has_mte(kern_hyp_va(vcpu->kvm));
> +}
> +
>  static inline void __sysreg_save_el1_state(struct kvm_cpu_context *ctxt)
>  {
>         ctxt_sys_reg(ctxt, CSSELR_EL1)  = read_sysreg(csselr_el1);
> @@ -46,6 +57,11 @@ static inline void __sysreg_save_el1_state(struct kvm_cpu_context *ctxt)
>         ctxt_sys_reg(ctxt, PAR_EL1)     = read_sysreg_par();
>         ctxt_sys_reg(ctxt, TPIDR_EL1)   = read_sysreg(tpidr_el1);
>
> +       if (ctxt_has_mte(ctxt)) {
> +               ctxt_sys_reg(ctxt, TFSR_EL1) = read_sysreg_el1(SYS_TFSR);
> +               ctxt_sys_reg(ctxt, TFSRE0_EL1) = read_sysreg_s(SYS_TFSRE0_EL1);
> +       }
> +
>         ctxt_sys_reg(ctxt, SP_EL1)      = read_sysreg(sp_el1);
>         ctxt_sys_reg(ctxt, ELR_EL1)     = read_sysreg_el1(SYS_ELR);
>         ctxt_sys_reg(ctxt, SPSR_EL1)    = read_sysreg_el1(SYS_SPSR);
> @@ -107,6 +123,11 @@ static inline void __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt)
>         write_sysreg(ctxt_sys_reg(ctxt, PAR_EL1),       par_el1);
>         write_sysreg(ctxt_sys_reg(ctxt, TPIDR_EL1),     tpidr_el1);
>
> +       if (ctxt_has_mte(ctxt)) {
> +               write_sysreg_el1(ctxt_sys_reg(ctxt, TFSR_EL1), SYS_TFSR);
> +               write_sysreg_s(ctxt_sys_reg(ctxt, TFSRE0_EL1), SYS_TFSRE0_EL1);
> +       }
> +
>         if (!has_vhe() &&
>             cpus_have_final_cap(ARM64_WORKAROUND_SPECULATIVE_AT) &&
>             ctxt->__hyp_running_vcpu) {
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 36f67f8deae1..5c75b24eae21 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1309,6 +1309,20 @@ static bool access_ccsidr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>         return true;
>  }
>
> +static unsigned int mte_visibility(const struct kvm_vcpu *vcpu,
> +                                  const struct sys_reg_desc *rd)
> +{
> +       return REG_HIDDEN;
> +}
> +
> +#define MTE_REG(name) {                                \
> +       SYS_DESC(SYS_##name),                   \
> +       .access = undef_access,                 \
> +       .reset = reset_unknown,                 \
> +       .reg = name,                            \
> +       .visibility = mte_visibility,           \
> +}
> +
>  /* sys_reg_desc initialiser for known cpufeature ID registers */
>  #define ID_SANITISED(name) {                   \
>         SYS_DESC(SYS_##name),                   \
> @@ -1477,8 +1491,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>         { SYS_DESC(SYS_ACTLR_EL1), access_actlr, reset_actlr, ACTLR_EL1 },
>         { SYS_DESC(SYS_CPACR_EL1), NULL, reset_val, CPACR_EL1, 0 },
>
> -       { SYS_DESC(SYS_RGSR_EL1), undef_access },
> -       { SYS_DESC(SYS_GCR_EL1), undef_access },
> +       MTE_REG(RGSR_EL1),
> +       MTE_REG(GCR_EL1),
>
>         { SYS_DESC(SYS_ZCR_EL1), NULL, reset_val, ZCR_EL1, 0, .visibility = sve_visibility },
>         { SYS_DESC(SYS_TRFCR_EL1), undef_access },
> @@ -1505,8 +1519,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>         { SYS_DESC(SYS_ERXMISC0_EL1), trap_raz_wi },
>         { SYS_DESC(SYS_ERXMISC1_EL1), trap_raz_wi },
>
> -       { SYS_DESC(SYS_TFSR_EL1), undef_access },
> -       { SYS_DESC(SYS_TFSRE0_EL1), undef_access },
> +       MTE_REG(TFSR_EL1),
> +       MTE_REG(TFSRE0_EL1),
>
>         { SYS_DESC(SYS_FAR_EL1), access_vm_reg, reset_unknown, FAR_EL1 },
>         { SYS_DESC(SYS_PAR_EL1), NULL, reset_unknown, PAR_EL1 },
> --
> 2.20.1
>
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
