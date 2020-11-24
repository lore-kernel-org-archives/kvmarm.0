Return-Path: <SRS0=ECKt=E6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48AE0C2D0E4
	for <kvmarm@archiver.kernel.org>; Tue, 24 Nov 2020 14:09:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 71D7A206FB
	for <kvmarm@archiver.kernel.org>; Tue, 24 Nov 2020 14:09:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="XtDdcDt3"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 71D7A206FB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 026A94BC06;
	Tue, 24 Nov 2020 09:09:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id apPADjF8UIV5; Tue, 24 Nov 2020 09:09:14 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8FC234BD61;
	Tue, 24 Nov 2020 09:09:14 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EBECB4BD55
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Nov 2020 09:09:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id t-lF8-G5L7+5 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 Nov 2020 09:09:12 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AB6804B930
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Nov 2020 09:09:12 -0500 (EST)
Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com
 [209.85.210.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 5FD94206FB
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Nov 2020 14:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1606226951;
 bh=xognvjsytGj3akJ5LEQ71E+KBAhbOlqmPPB8px69Qp0=;
 h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
 b=XtDdcDt3433O/UKIhEsFWGlwSsfAmOFPSWJ/CfXRQlwHQyD8QY5LDGcFDCWh6yI//
 opFvkJ4NaSKNE+XaOQFevNvdx9anLQPzZhGNbx7aYgzTzzN9fwBF9nJ4JkGyvy/ywa
 pUerazLkjbstIcnO0f7nCFlEtekdKgLvAYkYB43s=
Received: by mail-ot1-f43.google.com with SMTP id l36so19438004ota.4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Nov 2020 06:09:11 -0800 (PST)
X-Gm-Message-State: AOAM533EeLvmoaTMGzpOS0fpjzGPZU+J3/xvFlF6geA7e0En9h+buzmY
 XNMODNJ5oM9ibBGMuVww/+UC6i5RnnmhokFPPIo=
X-Google-Smtp-Source: ABdhPJxP9c5r3xRR6eKId2+eDoJlAYjem8Qv3lNy8uEeC9FGwM2kxRA23AIDh6vAm0s0dGArxN0nZ3qovNeDMfX/qLI=
X-Received: by 2002:a9d:62c1:: with SMTP id z1mr3391150otk.108.1606226950606; 
 Tue, 24 Nov 2020 06:09:10 -0800 (PST)
MIME-Version: 1.0
References: <20201119162543.78001-1-dbrazdil@google.com>
 <20201119162543.78001-7-dbrazdil@google.com>
In-Reply-To: <20201119162543.78001-7-dbrazdil@google.com>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Tue, 24 Nov 2020 15:08:59 +0100
X-Gmail-Original-Message-ID: <CAMj1kXH8sPjU2C7E++J+yP8FnfWbgEVGtj4i-XXqOF7DGxiaOw@mail.gmail.com>
Message-ID: <CAMj1kXH8sPjU2C7E++J+yP8FnfWbgEVGtj4i-XXqOF7DGxiaOw@mail.gmail.com>
Subject: Re: [RFC PATCH 6/6] kvm: arm64: Remove hyp_symbol_addr
To: David Brazdil <dbrazdil@google.com>
Cc: Android Kernel Team <kernel-team@android.com>,
 Marc Zyngier <maz@kernel.org>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Linux ARM <linux-arm-kernel@lists.infradead.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 kvmarm <kvmarm@lists.cs.columbia.edu>
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

On Thu, 19 Nov 2020 at 17:26, David Brazdil <dbrazdil@google.com> wrote:
>
> The helper was used to force PC-relative addressing in hyp code because
> absolute addressing via constant-pools used to generate kernel VAs. This
> was cumbersome and required programmers to remember to use the helper
> whenever they wanted to take a pointer.
>
> Now that hyp relocations are fixed up, there is no need for the helper
> any logner. Remove it.
>
> Signed-off-by: David Brazdil <dbrazdil@google.com>

Acked-by: Ard Biesheuvel <ardb@kernel.org>

> ---
>  arch/arm64/include/asm/kvm_asm.h         | 20 --------------------
>  arch/arm64/kvm/hyp/include/hyp/switch.h  |  4 ++--
>  arch/arm64/kvm/hyp/nvhe/hyp-smp.c        |  4 ++--
>  arch/arm64/kvm/hyp/nvhe/psci-relay.c     |  4 ++--
>  arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c |  2 +-
>  5 files changed, 7 insertions(+), 27 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> index 1a86581e581e..1961d23c0c40 100644
> --- a/arch/arm64/include/asm/kvm_asm.h
> +++ b/arch/arm64/include/asm/kvm_asm.h
> @@ -203,26 +203,6 @@ extern void __vgic_v3_init_lrs(void);
>
>  extern u32 __kvm_get_mdcr_el2(void);
>
> -/*
> - * Obtain the PC-relative address of a kernel symbol
> - * s: symbol
> - *
> - * The goal of this macro is to return a symbol's address based on a
> - * PC-relative computation, as opposed to a loading the VA from a
> - * constant pool or something similar. This works well for HYP, as an
> - * absolute VA is guaranteed to be wrong. Only use this if trying to
> - * obtain the address of a symbol (i.e. not something you obtained by
> - * following a pointer).
> - */
> -#define hyp_symbol_addr(s)                                             \
> -       ({                                                              \
> -               typeof(s) *addr;                                        \
> -               asm("adrp       %0, %1\n"                               \
> -                   "add        %0, %0, :lo12:%1\n"                     \
> -                   : "=r" (addr) : "S" (&s));                          \
> -               addr;                                                   \
> -       })
> -
>  #define __KVM_EXTABLE(from, to)                                                \
>         "       .pushsection    __kvm_ex_table, \"a\"\n"                \
>         "       .align          3\n"                                    \
> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> index 84473574c2e7..54f4860cd87c 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> @@ -505,8 +505,8 @@ static inline void __kvm_unexpected_el2_exception(void)
>         struct exception_table_entry *entry, *end;
>         unsigned long elr_el2 = read_sysreg(elr_el2);
>
> -       entry = hyp_symbol_addr(__start___kvm_ex_table);
> -       end = hyp_symbol_addr(__stop___kvm_ex_table);
> +       entry = &__start___kvm_ex_table;
> +       end = &__stop___kvm_ex_table;
>
>         while (entry < end) {
>                 addr = (unsigned long)&entry->insn + entry->insn;
> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-smp.c b/arch/arm64/kvm/hyp/nvhe/hyp-smp.c
> index ceb427aabb91..6870d9f3d4b7 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-smp.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-smp.c
> @@ -33,8 +33,8 @@ unsigned long __hyp_per_cpu_offset(unsigned int cpu)
>         if (cpu >= ARRAY_SIZE(kvm_arm_hyp_percpu_base))
>                 hyp_panic();
>
> -       cpu_base_array = (unsigned long*)hyp_symbol_addr(kvm_arm_hyp_percpu_base);
> +       cpu_base_array = (unsigned long*)(&kvm_arm_hyp_percpu_base[0]);
>         this_cpu_base = kern_hyp_va(cpu_base_array[cpu]);
> -       elf_base = (unsigned long)hyp_symbol_addr(__per_cpu_start);
> +       elf_base = (unsigned long)&__per_cpu_start;
>         return this_cpu_base - elf_base;
>  }
> diff --git a/arch/arm64/kvm/hyp/nvhe/psci-relay.c b/arch/arm64/kvm/hyp/nvhe/psci-relay.c
> index 313ef42f0eab..f64380a49a72 100644
> --- a/arch/arm64/kvm/hyp/nvhe/psci-relay.c
> +++ b/arch/arm64/kvm/hyp/nvhe/psci-relay.c
> @@ -147,7 +147,7 @@ static int psci_cpu_suspend(u64 func_id, struct kvm_cpu_context *host_ctxt)
>          * point if it is a deep sleep state.
>          */
>         ret = psci_call(func_id, power_state,
> -                       __hyp_pa(hyp_symbol_addr(__kvm_hyp_cpu_entry)),
> +                       __hyp_pa(__kvm_hyp_cpu_entry),
>                         __hyp_pa(cpu_params));
>
>         release_reset_state(cpu_state);
> @@ -182,7 +182,7 @@ static int psci_cpu_on(u64 func_id, struct kvm_cpu_context *host_ctxt)
>                 return PSCI_RET_ALREADY_ON;
>
>         ret = psci_call(func_id, mpidr,
> -                       __hyp_pa(hyp_symbol_addr(__kvm_hyp_cpu_entry)),
> +                       __hyp_pa(__kvm_hyp_cpu_entry),
>                         __hyp_pa(cpu_params));
>
>         /*
> diff --git a/arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c b/arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c
> index 8f0585640241..87a54375bd6e 100644
> --- a/arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c
> +++ b/arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c
> @@ -64,7 +64,7 @@ int __vgic_v2_perform_cpuif_access(struct kvm_vcpu *vcpu)
>         }
>
>         rd = kvm_vcpu_dabt_get_rd(vcpu);
> -       addr  = hyp_symbol_addr(kvm_vgic_global_state)->vcpu_hyp_va;
> +       addr  = kvm_vgic_global_state.vcpu_hyp_va;
>         addr += fault_ipa - vgic->vgic_cpu_base;
>
>         if (kvm_vcpu_dabt_iswrite(vcpu)) {
> --
> 2.29.2.299.gdc1121823c-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
