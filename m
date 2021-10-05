Return-Path: <SRS0=da30=OZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49E99C433F5
	for <kvmarm@archiver.kernel.org>; Tue,  5 Oct 2021 09:33:54 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BC7726137D
	for <kvmarm@archiver.kernel.org>; Tue,  5 Oct 2021 09:33:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org BC7726137D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 15CB64B2DE;
	Tue,  5 Oct 2021 05:33:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dzEE7bwS7N4Q; Tue,  5 Oct 2021 05:33:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 862464B2E2;
	Tue,  5 Oct 2021 05:33:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 30EA74B2DE
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Oct 2021 05:33:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EF07p4ngUxEV for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 Oct 2021 05:33:48 -0400 (EDT)
Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com
 [209.85.210.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B4BEA4B2DA
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Oct 2021 05:33:48 -0400 (EDT)
Received: by mail-ot1-f53.google.com with SMTP id
 u20-20020a9d7214000000b0054e170300adso38889otj.13
 for <kvmarm@lists.cs.columbia.edu>; Tue, 05 Oct 2021 02:33:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=KtTm1fsj62/Cv7KLIe5ToJ+jFNaak4h5EtZo8Y0hu0M=;
 b=kSRxgJJq25tgEAt6dz+S8AJQYtCf47zfib02opPKwG+wKYsq7aLmoWW2Wg1+WGl7j2
 EByRMzQkuE7OX2c3tJbHW6MGQetPvDV/tBl6p5DFQYjfBl/cg12eYhIbWUEMjcWRMTtF
 imApZqoqHSOrM1fDGKHwZ0/uZtSqSNFcADg2Yzw6kdC+2FavBUNbY6CGNGcKB5cfgyte
 qKjO7N6TR/egj2pB8GaWNHtRM3+gIapxI0xWRUjwho8fN5MH8p4yct6obtwQECcwq/y8
 y/VQbXG+X8FedDvSbwyp2zqAYgEj9ydEziL/d+sWLZX6mfV20JM2xkSRqSL3nN+y2Clb
 Op9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=KtTm1fsj62/Cv7KLIe5ToJ+jFNaak4h5EtZo8Y0hu0M=;
 b=l7i9XmClh36AMB7Ul6oGTqRbXGSV7t+fC3J8LGPA+WdPXZmwYYk78O3KG1v96ZTa+F
 rAhpg3uiKv6Vpe2XKfJGbZvQkxSKjtCc5JIrB24busejhrFfHH2SLaJKLW3FzjeTHWze
 YibGVygfwesTOG2g7y1aojCPbFY1Qy8p5tr2KJhg9kd3W8cxaNUxk9UyGrkga7qZd/gU
 KxoXvlQvIgjcF85dYHnDB+erNGzxTbLBgP52YUSe0gNo/3W+ulPfhR/PmBdNwXVMcVTL
 0nMsmGaxzfh7w3yuCGWQo5vtAH2EMQByoOJDmrC9IU07o+6N6++AocWXjtCKSquww1uZ
 GmvQ==
X-Gm-Message-State: AOAM531p+oyA2TLmKMe+q/j8PNp/e2cJHNUsx91QaIZAiANCekLi68Kb
 zhAEx4S6Mslaad3lzi7SDtzfcKQmDb0yPAasGFb/3g==
X-Google-Smtp-Source: ABdhPJzdM0yL3ykSTBsGY92LMwLHYvI+dcF/cAcRLmMwD+MrZvul1RXjTEcJL5KIV+ghUYQCj7Fq/p9ZgVwSbB0d/KY=
X-Received: by 2002:a9d:6752:: with SMTP id w18mr13293430otm.117.1633426427804; 
 Tue, 05 Oct 2021 02:33:47 -0700 (PDT)
MIME-Version: 1.0
References: <20210922124704.600087-1-tabba@google.com>
 <20210922124704.600087-10-tabba@google.com>
 <87r1czrfjd.wl-maz@kernel.org>
In-Reply-To: <87r1czrfjd.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 5 Oct 2021 10:33:11 +0100
Message-ID: <CA+EHjTzB60zSsROsu_Zf2Y_qr3eRrtj9vcZaMkVwoMs0jp-ZsA@mail.gmail.com>
Subject: Re: [PATCH v6 09/12] KVM: arm64: Initialize trap registers for
 protected VMs
To: Marc Zyngier <maz@kernel.org>
Cc: kernel-team@android.com, kvm@vger.kernel.org, pbonzini@redhat.com,
 will@kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

Hi Marc,

On Tue, Oct 5, 2021 at 10:23 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Wed, 22 Sep 2021 13:47:01 +0100,
> Fuad Tabba <tabba@google.com> wrote:
> >
> > Protected VMs have more restricted features that need to be
> > trapped. Moreover, the host should not be trusted to set the
> > appropriate trapping registers and their values.
> >
> > Initialize the trapping registers, i.e., hcr_el2, mdcr_el2, and
> > cptr_el2 at EL2 for protected guests, based on the values of the
> > guest's feature id registers.
> >
> > No functional change intended as trap handlers introduced in the
> > previous patch are still not hooked in to the guest exit
> > handlers.
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_asm.h       |   1 +
> >  arch/arm64/include/asm/kvm_host.h      |   2 +
> >  arch/arm64/kvm/arm.c                   |   8 ++
> >  arch/arm64/kvm/hyp/include/nvhe/pkvm.h |  14 ++
> >  arch/arm64/kvm/hyp/nvhe/Makefile       |   2 +-
> >  arch/arm64/kvm/hyp/nvhe/hyp-main.c     |  10 ++
> >  arch/arm64/kvm/hyp/nvhe/pkvm.c         | 186 +++++++++++++++++++++++++
> >  7 files changed, 222 insertions(+), 1 deletion(-)
> >  create mode 100644 arch/arm64/kvm/hyp/include/nvhe/pkvm.h
> >  create mode 100644 arch/arm64/kvm/hyp/nvhe/pkvm.c
> >
> > diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> > index e86045ac43ba..a460e1243cef 100644
> > --- a/arch/arm64/include/asm/kvm_asm.h
> > +++ b/arch/arm64/include/asm/kvm_asm.h
> > @@ -64,6 +64,7 @@
> >  #define __KVM_HOST_SMCCC_FUNC___pkvm_cpu_set_vector          18
> >  #define __KVM_HOST_SMCCC_FUNC___pkvm_prot_finalize           19
> >  #define __KVM_HOST_SMCCC_FUNC___kvm_adjust_pc                        20
> > +#define __KVM_HOST_SMCCC_FUNC___pkvm_vcpu_init_traps         21
> >
> >  #ifndef __ASSEMBLY__
> >
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index f8be56d5342b..4a323aa27a6b 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -780,6 +780,8 @@ static inline bool kvm_vm_is_protected(struct kvm *kvm)
> >       return false;
> >  }
> >
> > +void kvm_init_protected_traps(struct kvm_vcpu *vcpu);
> > +
> >  int kvm_arm_vcpu_finalize(struct kvm_vcpu *vcpu, int feature);
> >  bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu);
> >
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index 6aa7b0c5bf21..3af6d59d1919 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -620,6 +620,14 @@ static int kvm_vcpu_first_run_init(struct kvm_vcpu *vcpu)
> >
> >       ret = kvm_arm_pmu_v3_enable(vcpu);
> >
> > +     /*
> > +      * Initialize traps for protected VMs.
> > +      * NOTE: Move to run in EL2 directly, rather than via a hypercall, once
> > +      * the code is in place for first run initialization at EL2.
> > +      */
> > +     if (kvm_vm_is_protected(kvm))
> > +             kvm_call_hyp_nvhe(__pkvm_vcpu_init_traps, vcpu);
> > +
> >       return ret;
> >  }
> >
> > diff --git a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
> > new file mode 100644
> > index 000000000000..e6c259db6719
> > --- /dev/null
> > +++ b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
> > @@ -0,0 +1,14 @@
> > +/* SPDX-License-Identifier: GPL-2.0-only */
> > +/*
> > + * Copyright (C) 2021 Google LLC
> > + * Author: Fuad Tabba <tabba@google.com>
> > + */
> > +
> > +#ifndef __ARM64_KVM_NVHE_PKVM_H__
> > +#define __ARM64_KVM_NVHE_PKVM_H__
> > +
> > +#include <asm/kvm_host.h>
> > +
> > +void __pkvm_vcpu_init_traps(struct kvm_vcpu *vcpu);
> > +
> > +#endif /* __ARM64_KVM_NVHE_PKVM_H__ */
>
> We need to stop adding these small files with only two lines in
> them. Please merge this with nvhe/trap_handler.h, for example, and
> rename the whole thing to pkvm.h if you want.

Will do.

> > diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
> > index 0bbe37a18d5d..c3c11974fa3b 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/Makefile
> > +++ b/arch/arm64/kvm/hyp/nvhe/Makefile
> > @@ -14,7 +14,7 @@ lib-objs := $(addprefix ../../../lib/, $(lib-objs))
> >
> >  obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o host.o \
> >        hyp-main.o hyp-smp.o psci-relay.o early_alloc.o stub.o page_alloc.o \
> > -      cache.o setup.o mm.o mem_protect.o sys_regs.o
> > +      cache.o setup.o mm.o mem_protect.o sys_regs.o pkvm.o
> >  obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
> >        ../fpsimd.o ../hyp-entry.o ../exception.o ../pgtable.o
> >  obj-y += $(lib-objs)
> > diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > index 8ca1104f4774..f59e0870c343 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > @@ -15,6 +15,7 @@
> >
> >  #include <nvhe/mem_protect.h>
> >  #include <nvhe/mm.h>
> > +#include <nvhe/pkvm.h>
> >  #include <nvhe/trap_handler.h>
> >
> >  DEFINE_PER_CPU(struct kvm_nvhe_init_params, kvm_init_params);
> > @@ -160,6 +161,14 @@ static void handle___pkvm_prot_finalize(struct kvm_cpu_context *host_ctxt)
> >  {
> >       cpu_reg(host_ctxt, 1) = __pkvm_prot_finalize();
> >  }
> > +
> > +static void handle___pkvm_vcpu_init_traps(struct kvm_cpu_context *host_ctxt)
> > +{
> > +     DECLARE_REG(struct kvm_vcpu *, vcpu, host_ctxt, 1);
> > +
> > +     __pkvm_vcpu_init_traps(kern_hyp_va(vcpu));
> > +}
> > +
> >  typedef void (*hcall_t)(struct kvm_cpu_context *);
> >
> >  #define HANDLE_FUNC(x)       [__KVM_HOST_SMCCC_FUNC_##x] = (hcall_t)handle_##x
> > @@ -185,6 +194,7 @@ static const hcall_t host_hcall[] = {
> >       HANDLE_FUNC(__pkvm_host_share_hyp),
> >       HANDLE_FUNC(__pkvm_create_private_mapping),
> >       HANDLE_FUNC(__pkvm_prot_finalize),
> > +     HANDLE_FUNC(__pkvm_vcpu_init_traps),
> >  };
> >
> >  static void handle_host_hcall(struct kvm_cpu_context *host_ctxt)
> > diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> > new file mode 100644
> > index 000000000000..cc6139631dc4
> > --- /dev/null
> > +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> > @@ -0,0 +1,186 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +/*
> > + * Copyright (C) 2021 Google LLC
> > + * Author: Fuad Tabba <tabba@google.com>
> > + */
> > +
> > +#include <linux/kvm_host.h>
> > +#include <linux/mm.h>
> > +#include <asm/kvm_fixed_config.h>
> > +#include <nvhe/sys_regs.h>
> > +
> > +/*
> > + * Set trap register values based on features in ID_AA64PFR0.
> > + */
> > +static void pvm_init_traps_aa64pfr0(struct kvm_vcpu *vcpu)
> > +{
> > +     const u64 feature_ids = get_pvm_id_aa64pfr0(vcpu);
> > +     u64 hcr_set = 0;
> > +     u64 hcr_clear = 0;
> > +     u64 cptr_set = 0;
> > +
> > +     /* Trap AArch32 guests */
> > +     if (FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL0), feature_ids) <
> > +                 ID_AA64PFR0_ELx_32BIT_64BIT ||
> > +         FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1), feature_ids) <
> > +                 ID_AA64PFR0_ELx_32BIT_64BIT)
> > +             hcr_set |= HCR_RW | HCR_TID0;
>
> We have defined that pVMs don't have AArch32 at all. So RW should
> always be set. And if RW is set, the TID0 serves no purpose as EL1 is
> AArch64, as it only traps AArch32 EL1 accesses.
>
> I like the fact that this is all driven from the feature set, but it
> is also a bit unreadable. So I'd drop it in favour of:
>
>         u64 hcr_set = HCR_RW;
>
> at the top of the function.

Sure. What I could do, which I mentioned in a reply to your comments
on patch 12/12, is to have a build time assertion that checks that
AArch32 is not supported for pvms.

Cheers,
/fuad


> > +
> > +     /* Trap RAS unless all current versions are supported */
> > +     if (FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_RAS), feature_ids) <
> > +         ID_AA64PFR0_RAS_V1P1) {
> > +             hcr_set |= HCR_TERR | HCR_TEA;
> > +             hcr_clear |= HCR_FIEN;
> > +     }
> > +
> > +     /* Trap AMU */
> > +     if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_AMU), feature_ids)) {
> > +             hcr_clear |= HCR_AMVOFFEN;
> > +             cptr_set |= CPTR_EL2_TAM;
> > +     }
> > +
> > +     /*
> > +      * Linux guests assume support for floating-point and Advanced SIMD. Do
> > +      * not change the trapping behavior for these from the KVM default.
> > +      */
> > +     BUILD_BUG_ON(!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_FP),
> > +                             PVM_ID_AA64PFR0_ALLOW));
> > +     BUILD_BUG_ON(!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_ASIMD),
> > +                             PVM_ID_AA64PFR0_ALLOW));
> > +
> > +     /* Trap SVE */
> > +     if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_SVE), feature_ids))
> > +             cptr_set |= CPTR_EL2_TZ;
> > +
> > +     vcpu->arch.hcr_el2 |= hcr_set;
> > +     vcpu->arch.hcr_el2 &= ~hcr_clear;
> > +     vcpu->arch.cptr_el2 |= cptr_set;
> > +}
> > +
> > +/*
> > + * Set trap register values based on features in ID_AA64PFR1.
> > + */
> > +static void pvm_init_traps_aa64pfr1(struct kvm_vcpu *vcpu)
> > +{
> > +     const u64 feature_ids = get_pvm_id_aa64pfr1(vcpu);
> > +     u64 hcr_set = 0;
> > +     u64 hcr_clear = 0;
> > +
> > +     /* Memory Tagging: Trap and Treat as Untagged if not supported. */
> > +     if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR1_MTE), feature_ids)) {
> > +             hcr_set |= HCR_TID5;
> > +             hcr_clear |= HCR_DCT | HCR_ATA;
> > +     }
> > +
> > +     vcpu->arch.hcr_el2 |= hcr_set;
> > +     vcpu->arch.hcr_el2 &= ~hcr_clear;
> > +}
> > +
> > +/*
> > + * Set trap register values based on features in ID_AA64DFR0.
> > + */
> > +static void pvm_init_traps_aa64dfr0(struct kvm_vcpu *vcpu)
> > +{
> > +     const u64 feature_ids = get_pvm_id_aa64dfr0(vcpu);
> > +     u64 mdcr_set = 0;
> > +     u64 mdcr_clear = 0;
> > +     u64 cptr_set = 0;
> > +
> > +     /* Trap/constrain PMU */
> > +     if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_PMUVER), feature_ids)) {
> > +             mdcr_set |= MDCR_EL2_TPM | MDCR_EL2_TPMCR;
> > +             mdcr_clear |= MDCR_EL2_HPME | MDCR_EL2_MTPME |
> > +                           MDCR_EL2_HPMN_MASK;
> > +     }
> > +
> > +     /* Trap Debug */
> > +     if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_DEBUGVER), feature_ids))
> > +             mdcr_set |= MDCR_EL2_TDRA | MDCR_EL2_TDA | MDCR_EL2_TDE;
> > +
> > +     /* Trap OS Double Lock */
> > +     if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_DOUBLELOCK), feature_ids))
> > +             mdcr_set |= MDCR_EL2_TDOSA;
> > +
> > +     /* Trap SPE */
> > +     if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_PMSVER), feature_ids)) {
> > +             mdcr_set |= MDCR_EL2_TPMS;
> > +             mdcr_clear |= MDCR_EL2_E2PB_MASK << MDCR_EL2_E2PB_SHIFT;
> > +     }
> > +
> > +     /* Trap Trace Filter */
> > +     if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_TRACE_FILT), feature_ids))
> > +             mdcr_set |= MDCR_EL2_TTRF;
> > +
> > +     /* Trap Trace */
> > +     if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_TRACEVER), feature_ids))
> > +             cptr_set |= CPTR_EL2_TTA;
> > +
> > +     vcpu->arch.mdcr_el2 |= mdcr_set;
> > +     vcpu->arch.mdcr_el2 &= ~mdcr_clear;
> > +     vcpu->arch.cptr_el2 |= cptr_set;
> > +}
> > +
> > +/*
> > + * Set trap register values based on features in ID_AA64MMFR0.
> > + */
> > +static void pvm_init_traps_aa64mmfr0(struct kvm_vcpu *vcpu)
> > +{
> > +     const u64 feature_ids = get_pvm_id_aa64mmfr0(vcpu);
> > +     u64 mdcr_set = 0;
> > +
> > +     /* Trap Debug Communications Channel registers */
> > +     if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64MMFR0_FGT), feature_ids))
> > +             mdcr_set |= MDCR_EL2_TDCC;
> > +
> > +     vcpu->arch.mdcr_el2 |= mdcr_set;
> > +}
> > +
> > +/*
> > + * Set trap register values based on features in ID_AA64MMFR1.
> > + */
> > +static void pvm_init_traps_aa64mmfr1(struct kvm_vcpu *vcpu)
> > +{
> > +     const u64 feature_ids = get_pvm_id_aa64mmfr1(vcpu);
> > +     u64 hcr_set = 0;
> > +
> > +     /* Trap LOR */
> > +     if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64MMFR1_LOR), feature_ids))
> > +             hcr_set |= HCR_TLOR;
> > +
> > +     vcpu->arch.hcr_el2 |= hcr_set;
> > +}
> > +
> > +/*
> > + * Set baseline trap register values.
> > + */
> > +static void pvm_init_trap_regs(struct kvm_vcpu *vcpu)
> > +{
> > +     const u64 hcr_trap_feat_regs = HCR_TID3;
> > +     const u64 hcr_trap_impdef = HCR_TACR | HCR_TIDCP | HCR_TID1;
> > +
> > +     /*
> > +      * Always trap:
> > +      * - Feature id registers: to control features exposed to guests
> > +      * - Implementation-defined features
> > +      */
> > +     vcpu->arch.hcr_el2 |= hcr_trap_feat_regs | hcr_trap_impdef;
> > +
> > +     /* Clear res0 and set res1 bits to trap potential new features. */
> > +     vcpu->arch.hcr_el2 &= ~(HCR_RES0);
> > +     vcpu->arch.mdcr_el2 &= ~(MDCR_EL2_RES0);
> > +     vcpu->arch.cptr_el2 |= CPTR_NVHE_EL2_RES1;
> > +     vcpu->arch.cptr_el2 &= ~(CPTR_NVHE_EL2_RES0);
> > +}
> > +
> > +/*
> > + * Initialize trap register values for protected VMs.
> > + */
> > +void __pkvm_vcpu_init_traps(struct kvm_vcpu *vcpu)
> > +{
> > +     pvm_init_trap_regs(vcpu);
> > +     pvm_init_traps_aa64pfr0(vcpu);
> > +     pvm_init_traps_aa64pfr1(vcpu);
> > +     pvm_init_traps_aa64dfr0(vcpu);
> > +     pvm_init_traps_aa64mmfr0(vcpu);
> > +     pvm_init_traps_aa64mmfr1(vcpu);
> > +}
>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
