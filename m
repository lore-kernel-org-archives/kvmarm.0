Return-Path: <SRS0=PaY3=E5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22114C2D0E4
	for <kvmarm@archiver.kernel.org>; Mon, 23 Nov 2020 11:00:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 547942078E
	for <kvmarm@archiver.kernel.org>; Mon, 23 Nov 2020 11:00:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="u9OdSH8/"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 547942078E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B68904BAFD;
	Mon, 23 Nov 2020 06:00:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FC9p80UOFiVi; Mon, 23 Nov 2020 06:00:04 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 589234BAE4;
	Mon, 23 Nov 2020 06:00:04 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5910D4B83D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Nov 2020 05:55:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bliZIuICcO1i for <kvmarm@lists.cs.columbia.edu>;
 Mon, 23 Nov 2020 05:55:58 -0500 (EST)
Received: from mail-ot1-f67.google.com (mail-ot1-f67.google.com
 [209.85.210.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 133904B7D4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Nov 2020 05:55:58 -0500 (EST)
Received: by mail-ot1-f67.google.com with SMTP id f16so15458056otl.11
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Nov 2020 02:55:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=dAaII84HcEXvbNnxDSLxHAH0+A0aTsvl9gY1tLGjitA=;
 b=u9OdSH8/A0gwoY9Zp72hxARskG+k/xWPCFPPnekC1ftQBMBE3PMoJsjJCHyV+SqI/s
 JeOsSvWTrpdPFaEbCadkDjXXuHbKumLaCgmWJB/EDqL+kHQwmCDR/NfBpvmw8Iz0cq0s
 ZyL8RfhMY8yi/AOQokmbwGEoDgleZ+07GhQlQmFbesCSjbf+vFfz+xsngppSgufZ0Y9C
 bHvWyXrYir9R2F+HXr3ZhTAmvLwlbb4DJD0ynzhzO8A97UVzCZ1G4yoFX38Y8uXIhy6e
 w7bPzcZ40eHS6fAqnKXRL8HnuL2kc+VbjbVIUhDxbxALOu82FyP8TcoCLju3BIIUbSwq
 xyPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=dAaII84HcEXvbNnxDSLxHAH0+A0aTsvl9gY1tLGjitA=;
 b=defJi5ptGRwiLRlxVkWrzRlK25x3ZXcRN2lOnJjXZIxWwuxhQFO3uLKBVLqhaTbcNz
 WdNU1nUZnLhE0bZUfqcA69F5ksFkg1xwNpU3Spd2SbHLweCsTqN2na9pTxnaUHYulk61
 orO0T2SfEoSXK4HLPmvMPSBdn0dMsrStiTm+S0iDHyR1wMgGWfdvZUDDfSCoKTL2ro7S
 i2t/FW0K3U+iFOJYJXhpwsTTua7pHEpLqTr0k1AkKtFwTGNbOHIWligH7SD3sl7He6jz
 h2T1N1aL6Ro2l72CJooTQ4DexHTXDc293HTwa1G1M8ZBtwXDu8d9qmO4ze5okOSwdc+H
 akaQ==
X-Gm-Message-State: AOAM532eTSR1GTGQV1zKiFYo/fs5Qs73g1yGXH1HFqVTQW6mi7jFkp2/
 BgrRM2VT9iB9IsCjSzMCWTpt+iBr5wgq8hxTW6Tq6w==
X-Google-Smtp-Source: ABdhPJwRt9ZTExdG3bTGNmtLDlC7Bo8D2sx0n1oualDFMvNUtVyUQdSRJK5olUqVyqT+fdvVmIdmSzl4mhaczHMK7zo=
X-Received: by 2002:a05:6830:1e08:: with SMTP id
 s8mr1944890otr.144.1606128957173; 
 Mon, 23 Nov 2020 02:55:57 -0800 (PST)
MIME-Version: 1.0
References: <20201117181607.1761516-1-qperret@google.com>
 <20201117181607.1761516-14-qperret@google.com>
In-Reply-To: <20201117181607.1761516-14-qperret@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 23 Nov 2020 10:55:20 +0000
Message-ID: <CA+EHjTwebfoJLpure-mHNzCnmLwnNEi6yh66OLFGrhH_+ysExA@mail.gmail.com>
Subject: Re: [RFC PATCH 13/27] KVM: arm64: Enable access to sanitized CPU
 features at EL2
To: Quentin Perret <qperret@google.com>
X-Mailman-Approved-At: Mon, 23 Nov 2020 06:00:03 -0500
Cc: "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE"
 <devicetree@vger.kernel.org>, kernel-team@android.com,
 Frank Rowand <frowand.list@gmail.com>, Android KVM <android-kvm@google.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 open list <linux-kernel@vger.kernel.org>, Rob Herring <robh+dt@kernel.org>,
 "moderated list:ARM64 PORT \(AARCH64 ARCHITECTURE\)"
 <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>,
 "open list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>
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

Hi Quentin,

On Tue, Nov 17, 2020 at 6:16 PM 'Quentin Perret' via kernel-team
<kernel-team@android.com> wrote:
>
> Introduce the infrastructure in KVM enabling to copy CPU feature
> registers into EL2-owned data-structures, to allow reading sanitised
> values directly at EL2 in nVHE.
>
> Given that only a subset of these features are being read by the
> hypervisor, the ones that need to be copied are to be listed under
> <asm/kvm_cpufeature.h> together with the name of the nVHE variable that
> will hold the copy.
>
> While at it, introduce the first user of this infrastructure by
> implementing __flush_dcache_area at EL2, which needs
> arm64_ftr_reg_ctrel0.
>
> Signed-off-by: Quentin Perret <qperret@google.com>
> ---
>  arch/arm64/include/asm/cpufeature.h     |  1 +
>  arch/arm64/include/asm/kvm_cpufeature.h | 17 ++++++++++++++
>  arch/arm64/kernel/cpufeature.c          | 12 ++++++++++
>  arch/arm64/kernel/image-vars.h          |  2 ++
>  arch/arm64/kvm/arm.c                    | 31 +++++++++++++++++++++++++
>  arch/arm64/kvm/hyp/nvhe/Makefile        |  3 ++-
>  arch/arm64/kvm/hyp/nvhe/cache.S         | 13 +++++++++++
>  arch/arm64/kvm/hyp/nvhe/cpufeature.c    |  8 +++++++
>  8 files changed, 86 insertions(+), 1 deletion(-)
>  create mode 100644 arch/arm64/include/asm/kvm_cpufeature.h
>  create mode 100644 arch/arm64/kvm/hyp/nvhe/cache.S
>  create mode 100644 arch/arm64/kvm/hyp/nvhe/cpufeature.c
>
> diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
> index da250e4741bd..3dfbd76fb647 100644
> --- a/arch/arm64/include/asm/cpufeature.h
> +++ b/arch/arm64/include/asm/cpufeature.h
> @@ -600,6 +600,7 @@ void __init setup_cpu_features(void);
>  void check_local_cpu_capabilities(void);
>
>  u64 read_sanitised_ftr_reg(u32 id);
> +int copy_ftr_reg(u32 id, struct arm64_ftr_reg *dst);
>
>  static inline bool cpu_supports_mixed_endian_el0(void)
>  {
> diff --git a/arch/arm64/include/asm/kvm_cpufeature.h b/arch/arm64/include/asm/kvm_cpufeature.h
> new file mode 100644
> index 000000000000..d34f85cba358
> --- /dev/null
> +++ b/arch/arm64/include/asm/kvm_cpufeature.h
> @@ -0,0 +1,17 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Copyright (C) 2020 - Google LLC
> + * Author: Quentin Perret <qperret@google.com>
> + */

Missing include guard.


> +
> +#include <asm/cpufeature.h>
> +
> +#ifndef KVM_HYP_CPU_FTR_REG
> +#if defined(__KVM_NVHE_HYPERVISOR__)
> +#define KVM_HYP_CPU_FTR_REG(id, name) extern struct arm64_ftr_reg name;
> +#else
> +#define KVM_HYP_CPU_FTR_REG(id, name) DECLARE_KVM_NVHE_SYM(name);
> +#endif
> +#endif
> +
> +KVM_HYP_CPU_FTR_REG(SYS_CTR_EL0, arm64_ftr_reg_ctrel0)
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index dd5bc0f0cf0d..3bc86d1423f8 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -1116,6 +1116,18 @@ u64 read_sanitised_ftr_reg(u32 id)
>  }
>  EXPORT_SYMBOL_GPL(read_sanitised_ftr_reg);
>
> +int copy_ftr_reg(u32 id, struct arm64_ftr_reg *dst)
> +{
> +       struct arm64_ftr_reg *regp = get_arm64_ftr_reg(id);
> +
> +       if (!regp)
> +               return -EINVAL;
> +
> +       memcpy(dst, regp, sizeof(*regp));
> +
> +       return 0;
> +}
> +
>  #define read_sysreg_case(r)    \
>         case r:         return read_sysreg_s(r)
>
> diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
> index dd8ccc9efb6a..c35d768672eb 100644
> --- a/arch/arm64/kernel/image-vars.h
> +++ b/arch/arm64/kernel/image-vars.h
> @@ -116,6 +116,8 @@ __kvm_nvhe___memcpy                 = __kvm_nvhe___pi_memcpy;
>  __kvm_nvhe___memset                    = __kvm_nvhe___pi_memset;
>  #endif
>
> +_kvm_nvhe___flush_dcache_area          = __kvm_nvhe___pi___flush_dcache_area;
> +
>  #endif /* CONFIG_KVM */
>
>  #endif /* __ARM64_KERNEL_IMAGE_VARS_H */
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 391cf6753a13..c7f8fca97202 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -34,6 +34,7 @@
>  #include <asm/virt.h>
>  #include <asm/kvm_arm.h>
>  #include <asm/kvm_asm.h>
> +#include <asm/kvm_cpufeature.h>
>  #include <asm/kvm_mmu.h>
>  #include <asm/kvm_emulate.h>
>  #include <asm/sections.h>
> @@ -1636,6 +1637,29 @@ static void teardown_hyp_mode(void)
>         }
>  }
>
> +#undef KVM_HYP_CPU_FTR_REG
> +#define KVM_HYP_CPU_FTR_REG(id, name) \
> +       { .sys_id = id, .dst = (struct arm64_ftr_reg *)&kvm_nvhe_sym(name) },
> +static const struct __ftr_reg_copy_entry {
> +       u32                     sys_id;
> +       struct arm64_ftr_reg    *dst;
> +} hyp_ftr_regs[] = {
> +       #include <asm/kvm_cpufeature.h>
> +};
> +
> +static int copy_cpu_ftr_regs(void)
> +{
> +       int i, ret;
> +
> +       for (i = 0; i < ARRAY_SIZE(hyp_ftr_regs); i++) {
> +               ret = copy_ftr_reg(hyp_ftr_regs[i].sys_id, hyp_ftr_regs[i].dst);
> +               if (ret)
> +                       return ret;
> +       }
> +
> +       return 0;
> +}
> +
>  /**
>   * Inits Hyp-mode on all online CPUs
>   */
> @@ -1644,6 +1668,13 @@ static int init_hyp_mode(void)
>         int cpu;
>         int err = 0;
>
> +       /*
> +        * Copy the required CPU feature register in their EL2 counterpart
> +        */
> +       err = copy_cpu_ftr_regs();
> +       if (err)
> +               return err;
> +
>         /*
>          * Allocate Hyp PGD and setup Hyp identity mapping
>          */
> diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
> index 9e5eacfec6ec..72cfe53f106f 100644
> --- a/arch/arm64/kvm/hyp/nvhe/Makefile
> +++ b/arch/arm64/kvm/hyp/nvhe/Makefile
> @@ -10,7 +10,8 @@ lib-objs := clear_page.o copy_page.o memcpy.o memset.o
>  lib-objs := $(addprefix ../../../lib/, $(lib-objs))
>
>  obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o host.o \
> -        hyp-main.o hyp-smp.o psci-relay.o early_alloc.o stub.o page_alloc.o
> +        hyp-main.o hyp-smp.o psci-relay.o early_alloc.o stub.o page_alloc.o \
> +        cache.o cpufeature.o
>  obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
>          ../fpsimd.o ../hyp-entry.o ../exception.o
>  obj-y += $(lib-objs)
> diff --git a/arch/arm64/kvm/hyp/nvhe/cache.S b/arch/arm64/kvm/hyp/nvhe/cache.S
> new file mode 100644
> index 000000000000..36cef6915428
> --- /dev/null
> +++ b/arch/arm64/kvm/hyp/nvhe/cache.S
> @@ -0,0 +1,13 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Code copied from arch/arm64/mm/cache.S.
> + */
> +
> +#include <linux/linkage.h>
> +#include <asm/assembler.h>
> +#include <asm/alternative.h>
> +
> +SYM_FUNC_START_PI(__flush_dcache_area)
> +       dcache_by_line_op civac, sy, x0, x1, x2, x3
> +       ret
> +SYM_FUNC_END_PI(__flush_dcache_area)
> diff --git a/arch/arm64/kvm/hyp/nvhe/cpufeature.c b/arch/arm64/kvm/hyp/nvhe/cpufeature.c
> new file mode 100644
> index 000000000000..a887508f996f
> --- /dev/null
> +++ b/arch/arm64/kvm/hyp/nvhe/cpufeature.c
> @@ -0,0 +1,8 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (C) 2020 - Google LLC
> + * Author: Quentin Perret <qperret@google.com>
> + */
> +
> +#define KVM_HYP_CPU_FTR_REG(id, name) struct arm64_ftr_reg name;
> +#include <asm/kvm_cpufeature.h>
> --
> 2.29.2.299.gdc1121823c-goog
>
> --
> To unsubscribe from this group and stop receiving emails from it, send an email to kernel-team+unsubscribe@android.com.
>

/fuad
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
