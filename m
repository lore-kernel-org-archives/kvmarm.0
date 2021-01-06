Return-Path: <SRS0=pXP7=GJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31466C433DB
	for <kvmarm@archiver.kernel.org>; Wed,  6 Jan 2021 02:16:37 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A6E5322D6E
	for <kvmarm@archiver.kernel.org>; Wed,  6 Jan 2021 02:16:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A6E5322D6E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 118434B2F6;
	Tue,  5 Jan 2021 21:16:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HXKzi+an23oB; Tue,  5 Jan 2021 21:16:34 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DDB9A4B30D;
	Tue,  5 Jan 2021 21:16:34 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ADFDE4B2F6
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Jan 2021 21:16:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zyluvg8fA23f for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 Jan 2021 21:16:32 -0500 (EST)
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com
 [209.85.167.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 450374B266
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Jan 2021 21:16:32 -0500 (EST)
Received: by mail-lf1-f48.google.com with SMTP id y19so3090970lfa.13
 for <kvmarm@lists.cs.columbia.edu>; Tue, 05 Jan 2021 18:16:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=KVsuCyT2jZU85zfYB+NIaPMS8ajkTMctJkhL7DKcYnE=;
 b=Utw66Ga679gB2x3y5LiM4QONKAQiITNcTW8HyxmeGLR0PjIQ3Uy5LVUiSpE8gpmbUs
 pXFegXW94vtdZlbxnKOkMMvu2GMRHgG4PJQ23weqzoFjMdaR5OwVVle1+nQfp2JXhdnh
 wT0smE/+Ai3+QvZ7UIjHrsoKgQ9e1wQONqt7oLaiP2H13BQJxP2zyFzWG/62SUtyaKLx
 hy0SBZmUXo2mxYOAF+SsiIIYf+2IxFJuJbAYTWIkSwnHxrUqY+PsfR7g7AnxrFzEyGAf
 CB16irwArYaiB4RamOsMPmrsRPlRgHzj2yXnjoRISboFtxwbgjBIC6YAPFLXb/0Pnh8Z
 CIwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=KVsuCyT2jZU85zfYB+NIaPMS8ajkTMctJkhL7DKcYnE=;
 b=GJgvIAeoyCCPFro/DszGDchqsafTLjfVJqFBDV9xykwMu+g5q/GWOLYJC/IMLCdK87
 rzwuI3dfNrjm2luOFLZI/00l8mXAduB8Hj7rc1fxs/IziqIFsgxE7t8BoZbgf4WRLAPg
 CZpfsa40I5MtrZLEr34K/gO3+txWrok9Re6tc+yYRURyiVG5LL4Xmm9BaWWUqfuE8vWr
 /4Qy/HLEgT1p6EkW9w9zhM/ba1nthbDs7An6k3X1VXJX2EEa0iL80dijPJEQnBHRgJAd
 MBl1EEuD8rNCcdD0dLdr2iCXeloboABoLjlL9UXZI/LF3BwlpHzz3+QAL5py64bRXUnr
 B62g==
X-Gm-Message-State: AOAM532C51LLMiZ9aJmf+jcwy++8auqJ34XlvodYWgjV7PXvbprAW8Ur
 r6iEEcE+RNJ2bbW0FbylF3/3Ed6CPxtjNh1jpYXiXA==
X-Google-Smtp-Source: ABdhPJxT+0/WlixsZVte1tikv55+uEMMQDYoOSMDqObQoTvJnCg5Bpd19CjKrRZCrUW4mO6FytZtWtUsYU9igflQN/g=
X-Received: by 2002:a19:7fc8:: with SMTP id a191mr897666lfd.178.1609899390736; 
 Tue, 05 Jan 2021 18:16:30 -0800 (PST)
MIME-Version: 1.0
References: <20210104135011.2063104-1-maz@kernel.org>
 <20210104135011.2063104-12-maz@kernel.org>
In-Reply-To: <20210104135011.2063104-12-maz@kernel.org>
From: Jing Zhang <jingzhangos@google.com>
Date: Tue, 5 Jan 2021 20:16:18 -0600
Message-ID: <CAAdAUtjNiBACFbxp-0x_ar9RcnFDkiSoGqOn0XKiwtJAd3qCHg@mail.gmail.com>
Subject: Re: [PATCH v2 11/17] arm64: cpufeature: Add an early command-line
 cpufeature override facility
To: Marc Zyngier <maz@kernel.org>
Cc: kernel-team@android.com, Catalin Marinas <catalin.marinas@arm.com>,
 Ard Biesheuvel <ardb@kernel.org>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Mon, Jan 4, 2021 at 8:20 AM Marc Zyngier <maz@kernel.org> wrote:
>
> In order to be able to override CPU features at boot time,
> let's add a command line parser that matches options of the
> form "cpureg.feature=value", and store the corresponding
> value into the override val/mask pair.
>
> No features are currently defined, so no expected change in
> functionnality.
Typo: functionnality -> functionality
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kernel/Makefile         |   2 +-
>  arch/arm64/kernel/head.S           |   1 +
>  arch/arm64/kernel/idreg-override.c | 119 +++++++++++++++++++++++++++++
>  3 files changed, 121 insertions(+), 1 deletion(-)
>  create mode 100644 arch/arm64/kernel/idreg-override.c
>
> diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
> index 86364ab6f13f..2262f0392857 100644
> --- a/arch/arm64/kernel/Makefile
> +++ b/arch/arm64/kernel/Makefile
> @@ -17,7 +17,7 @@ obj-y                 := debug-monitors.o entry.o irq.o fpsimd.o              \
>                            return_address.o cpuinfo.o cpu_errata.o              \
>                            cpufeature.o alternative.o cacheinfo.o               \
>                            smp.o smp_spin_table.o topology.o smccc-call.o       \
> -                          syscall.o proton-pack.o
> +                          syscall.o proton-pack.o idreg-override.o
>
>  targets                        += efi-entry.o
>
> diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
> index d74e5f84042e..b3c4dd04f74b 100644
> --- a/arch/arm64/kernel/head.S
> +++ b/arch/arm64/kernel/head.S
> @@ -435,6 +435,7 @@ SYM_FUNC_START_LOCAL(__primary_switched)
>
>         mov     x0, x21                         // pass FDT address in x0
>         bl      early_fdt_map                   // Try mapping the FDT early
> +       bl      init_shadow_regs
>         bl      switch_to_vhe
>  #if defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS)
>         bl      kasan_early_init
> diff --git a/arch/arm64/kernel/idreg-override.c b/arch/arm64/kernel/idreg-override.c
> new file mode 100644
> index 000000000000..392f93b67103
> --- /dev/null
> +++ b/arch/arm64/kernel/idreg-override.c
> @@ -0,0 +1,119 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Early cpufeature override framework
> + *
> + * Copyright (C) 2020 Google LLC
> + * Author: Marc Zyngier <maz@kernel.org>
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/libfdt.h>
> +
> +#include <asm/cacheflush.h>
> +#include <asm/setup.h>
> +
> +struct reg_desc {
> +       const char * const      name;
> +       u64 * const             val;
> +       u64 * const             mask;
> +       struct {
> +               const char * const      name;
> +               u8                       shift;
> +       }                       fields[];
> +};
> +
> +static const struct reg_desc * const regs[] __initdata = {
> +};
> +
> +static int __init find_field(const char *cmdline, const struct reg_desc *reg,
> +                            int f, u64 *v)
> +{
> +       char buf[256], *str;
> +       size_t len;
> +
> +       snprintf(buf, ARRAY_SIZE(buf), "%s.%s=", reg->name, reg->fields[f].name);
> +
> +       str = strstr(cmdline, buf);
> +       if (!(str == cmdline || (str > cmdline && *(str - 1) == ' ')))
> +               return -1;
> +
> +       str += strlen(buf);
> +       len = strcspn(str, " ");
> +       len = min(len, ARRAY_SIZE(buf) - 1);
> +       strncpy(buf, str, len);
> +       buf[len] = 0;
> +
> +       return kstrtou64(buf, 0, v);
> +}
> +
> +static void __init match_options(const char *cmdline)
> +{
> +       int i;
> +
> +       for (i = 0; i < ARRAY_SIZE(regs); i++) {
> +               int f;
> +
> +               if (!regs[i]->val || !regs[i]->mask)
> +                       continue;
> +
> +               for (f = 0; regs[i]->fields[f].name; f++) {
> +                       u64 v;
> +
> +                       if (find_field(cmdline, regs[i], f, &v))
> +                               continue;
> +
> +                       *regs[i]->val  |= (v & 0xf) << regs[i]->fields[f].shift;
> +                       *regs[i]->mask |= 0xfUL << regs[i]->fields[f].shift;
> +               }
> +       }
> +}
> +
> +static __init void parse_cmdline(void)
> +{
> +       if (!IS_ENABLED(CONFIG_CMDLINE_FORCE)) {
> +               const u8 *prop;
> +               void *fdt;
> +               int node;
> +
> +               fdt = get_early_fdt_ptr();
> +               if (!fdt)
> +                       goto out;
> +
> +               node = fdt_path_offset(fdt, "/chosen");
> +               if (node < 0)
> +                       goto out;
> +
> +               prop = fdt_getprop(fdt, node, "bootargs", NULL);
> +               if (!prop)
> +                       goto out;
> +
> +               match_options(prop);
> +
> +               if (!IS_ENABLED(CONFIG_CMDLINE_EXTEND))
> +                       return;
> +       }
> +
> +out:
> +       match_options(CONFIG_CMDLINE);
> +}
> +
> +void __init init_shadow_regs(void)
> +{
> +       int i;
> +
> +       for (i = 0; i < ARRAY_SIZE(regs); i++) {
> +               if (regs[i]->val)
> +                       *regs[i]->val  = 0;
> +               if (regs[i]->mask)
> +                       *regs[i]->mask = 0;
> +       }
> +
> +       parse_cmdline();
> +
> +       for (i = 0; i < ARRAY_SIZE(regs); i++) {
> +               if (regs[i]->val)
> +                       __flush_dcache_area(regs[i]->val, sizeof(*regs[i]->val));
> +               if (regs[i]->mask)
> +                       __flush_dcache_area(regs[i]->mask, sizeof(*regs[i]->mask));
> +       }
Could you shed some light on the usage of __flush_dcache_area here? Thanks.
> +}
> --
> 2.29.2
>
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
