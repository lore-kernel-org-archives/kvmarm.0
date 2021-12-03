Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FB07C433F5
	for <kvmarm@archiver.kernel.org>; Fri,  3 Dec 2021 08:32:56 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BC6CC49F8F;
	Fri,  3 Dec 2021 03:32:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4MPTnUSTUBSh; Fri,  3 Dec 2021 03:32:54 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 074374A19A;
	Fri,  3 Dec 2021 03:32:54 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B256249F8F
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Dec 2021 03:32:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LgVX+PVLGAcz for <kvmarm@lists.cs.columbia.edu>;
 Fri,  3 Dec 2021 03:32:50 -0500 (EST)
Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com
 [209.85.167.175])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 91B5240630
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Dec 2021 03:32:50 -0500 (EST)
Received: by mail-oi1-f175.google.com with SMTP id n66so4422941oia.9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 03 Dec 2021 00:32:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=YPat5V59RJ/piamiqR6wjkP7Wm3bKZc+ND35AS6ZUvE=;
 b=lSCi5nVccs6dRY2wwdY3uH3YQmkZSQBJd1MRWWgw7CRwupENY+H4I5dHhu1xJ97HId
 1wON/2BvZSARoJVy1uq3kZPtdGWf+/XpkIm/H47nsN1hyxY1XEtslGKYb0l3PUmiMlmZ
 t782653/y9clQfaLSkfpCARRiFjtAJenRXnRiSDgw6R8AI3kj0VJgA4RAwZoNtLg4wnH
 iQmlO5Wt7KPyn9ZDSrTdaNpYTNtCEtzA4q9fn4rBMFOc+fw2IsugwlqnEtn2uTrSHPZn
 mO1uIDXojTE/OonFOqJr1vg6JT+Jn2OUxCjdLPm0JIUiU/W8qXp8WgkzO1h5nfXTX0B5
 RHHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=YPat5V59RJ/piamiqR6wjkP7Wm3bKZc+ND35AS6ZUvE=;
 b=7ywIsNrMdDTmkE1psA59Ws8yOLuPGWwGAIA3saukxuCohrfu41i5ZzENsv3Q8gmxC0
 fHov6IgxU5PQv7i97w+R3LrPqYAklySQo3cMiSCPF1n3lxxlVXnvMYZ9rtf6WxjN++Yl
 sGIN2PcxxQ4vjJsXb6VZB/GQOCwD08tCOfIcJwdZDBExbOf0+VS8NbiUxdnzKHzilhHs
 6Ggbcf7NMb72RrlKi0IjkeR2WBQL+ul0diNUgILZwe9tEIxf8cl1TkisgHcEgQTDOoxN
 mv9S0q3PRFizlZK6s6eiOM9cRnFFOQPN8lVSLJVP+jL/DaiBkXsAKZN1fLGvbaJTmnzU
 a7dQ==
X-Gm-Message-State: AOAM531lWzQQFHpYm6KaHQvQzihYJfMSjenqfck34FHjelJGmaH7X7t9
 klcMJ7F0LcFaWPgYFsg1FSqMf1ICuuOzcOtPsxRR4Q==
X-Google-Smtp-Source: ABdhPJxSRxKuK1G03O4Z7NzJmb0LTniTpMsmSicam+fcLx+DNBrAisld+ha+OMJyW/754X9wq4Ut3AOvYWPGY+vkoBM=
X-Received: by 2002:a05:6808:485:: with SMTP id
 z5mr8808304oid.96.1638520369623; 
 Fri, 03 Dec 2021 00:32:49 -0800 (PST)
MIME-Version: 1.0
References: <20211202171048.26924-1-will@kernel.org>
 <20211202171048.26924-4-will@kernel.org>
In-Reply-To: <20211202171048.26924-4-will@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 3 Dec 2021 08:32:13 +0000
Message-ID: <CA+EHjTwPfAMOGYvshF0ZSWtC8ex+59mK2TZ7K6BDo=hx-iOfZQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] KVM: arm64: Move host EL1 code out of hyp/ directory
To: Will Deacon <will@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
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

Hi Will,

On Thu, Dec 2, 2021 at 5:11 PM Will Deacon <will@kernel.org> wrote:
>
> kvm/hyp/reserved_mem.c contains host code executing at EL1 and is not
> linked into the hypervisor object. Move the file into kvm/pkvm.c and
> rework the headers so that the definitions shared between the host and
> the hypervisor live in asm/kvm_pkvm.h.

It's good to have only hyp code in hyp.

Tested-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

> Signed-off-by: Will Deacon <will@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_pkvm.h             | 71 +++++++++++++++++++
>  arch/arm64/kvm/Makefile                       |  2 +-
>  arch/arm64/kvm/hyp/Makefile                   |  2 +-
>  arch/arm64/kvm/hyp/include/nvhe/mm.h          | 57 ---------------
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c         |  1 +
>  arch/arm64/kvm/hyp/nvhe/mm.c                  |  1 +
>  arch/arm64/kvm/hyp/nvhe/setup.c               |  1 +
>  arch/arm64/kvm/{hyp/reserved_mem.c => pkvm.c} |  8 +--
>  8 files changed, 80 insertions(+), 63 deletions(-)
>  create mode 100644 arch/arm64/include/asm/kvm_pkvm.h
>  rename arch/arm64/kvm/{hyp/reserved_mem.c => pkvm.c} (94%)
>
> diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
> new file mode 100644
> index 000000000000..9f4ad2a8df59
> --- /dev/null
> +++ b/arch/arm64/include/asm/kvm_pkvm.h
> @@ -0,0 +1,71 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2020 - Google LLC
> + * Author: Quentin Perret <qperret@google.com>
> + */
> +#ifndef __ARM64_KVM_PKVM_H__
> +#define __ARM64_KVM_PKVM_H__
> +
> +#include <linux/memblock.h>
> +#include <asm/kvm_pgtable.h>
> +
> +#define HYP_MEMBLOCK_REGIONS 128
> +
> +extern struct memblock_region kvm_nvhe_sym(hyp_memory)[];
> +extern unsigned int kvm_nvhe_sym(hyp_memblock_nr);
> +
> +static inline unsigned long __hyp_pgtable_max_pages(unsigned long nr_pages)
> +{
> +       unsigned long total = 0, i;
> +
> +       /* Provision the worst case scenario */
> +       for (i = 0; i < KVM_PGTABLE_MAX_LEVELS; i++) {
> +               nr_pages = DIV_ROUND_UP(nr_pages, PTRS_PER_PTE);
> +               total += nr_pages;
> +       }
> +
> +       return total;
> +}
> +
> +static inline unsigned long __hyp_pgtable_total_pages(void)
> +{
> +       unsigned long res = 0, i;
> +
> +       /* Cover all of memory with page-granularity */
> +       for (i = 0; i < kvm_nvhe_sym(hyp_memblock_nr); i++) {
> +               struct memblock_region *reg = &kvm_nvhe_sym(hyp_memory)[i];
> +               res += __hyp_pgtable_max_pages(reg->size >> PAGE_SHIFT);
> +       }
> +
> +       return res;
> +}
> +
> +static inline unsigned long hyp_s1_pgtable_pages(void)
> +{
> +       unsigned long res;
> +
> +       res = __hyp_pgtable_total_pages();
> +
> +       /* Allow 1 GiB for private mappings */
> +       res += __hyp_pgtable_max_pages(SZ_1G >> PAGE_SHIFT);
> +
> +       return res;
> +}
> +
> +static inline unsigned long host_s2_pgtable_pages(void)
> +{
> +       unsigned long res;
> +
> +       /*
> +        * Include an extra 16 pages to safely upper-bound the worst case of
> +        * concatenated pgds.
> +        */
> +       res = __hyp_pgtable_total_pages() + 16;
> +
> +       /* Allow 1 GiB for MMIO mappings */
> +       res += __hyp_pgtable_max_pages(SZ_1G >> PAGE_SHIFT);
> +
> +       return res;
> +}
> +
> +#endif /* __ARM64_KVM_PKVM_H__ */
> diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
> index 0b561752f8d8..8ca8cf6f5619 100644
> --- a/arch/arm64/kvm/Makefile
> +++ b/arch/arm64/kvm/Makefile
> @@ -15,7 +15,7 @@ kvm-y := $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o $(KVM)/eventfd.o \
>          arm.o mmu.o mmio.o psci.o perf.o hypercalls.o pvtime.o \
>          inject_fault.o va_layout.o handle_exit.o \
>          guest.o debug.o reset.o sys_regs.o \
> -        vgic-sys-reg-v3.o fpsimd.o pmu.o \
> +        vgic-sys-reg-v3.o fpsimd.o pmu.o pkvm.o \
>          arch_timer.o trng.o\
>          vgic/vgic.o vgic/vgic-init.o \
>          vgic/vgic-irqfd.o vgic/vgic-v2.o \
> diff --git a/arch/arm64/kvm/hyp/Makefile b/arch/arm64/kvm/hyp/Makefile
> index b726332eec49..687598e41b21 100644
> --- a/arch/arm64/kvm/hyp/Makefile
> +++ b/arch/arm64/kvm/hyp/Makefile
> @@ -10,4 +10,4 @@ subdir-ccflags-y := -I$(incdir)                               \
>                     -DDISABLE_BRANCH_PROFILING          \
>                     $(DISABLE_STACKLEAK_PLUGIN)
>
> -obj-$(CONFIG_KVM) += vhe/ nvhe/ pgtable.o reserved_mem.o
> +obj-$(CONFIG_KVM) += vhe/ nvhe/ pgtable.o
> diff --git a/arch/arm64/kvm/hyp/include/nvhe/mm.h b/arch/arm64/kvm/hyp/include/nvhe/mm.h
> index c9a8f535212e..ef6a58a04235 100644
> --- a/arch/arm64/kvm/hyp/include/nvhe/mm.h
> +++ b/arch/arm64/kvm/hyp/include/nvhe/mm.h
> @@ -10,9 +10,6 @@
>  #include <nvhe/memory.h>
>  #include <nvhe/spinlock.h>
>
> -#define HYP_MEMBLOCK_REGIONS 128
> -extern struct memblock_region kvm_nvhe_sym(hyp_memory)[];
> -extern unsigned int kvm_nvhe_sym(hyp_memblock_nr);
>  extern struct kvm_pgtable pkvm_pgtable;
>  extern hyp_spinlock_t pkvm_pgd_lock;
>  extern struct hyp_pool hpool;
> @@ -39,58 +36,4 @@ static inline void hyp_vmemmap_range(phys_addr_t phys, unsigned long size,
>         *end = ALIGN(*end, PAGE_SIZE);
>  }
>
> -static inline unsigned long __hyp_pgtable_max_pages(unsigned long nr_pages)
> -{
> -       unsigned long total = 0, i;
> -
> -       /* Provision the worst case scenario */
> -       for (i = 0; i < KVM_PGTABLE_MAX_LEVELS; i++) {
> -               nr_pages = DIV_ROUND_UP(nr_pages, PTRS_PER_PTE);
> -               total += nr_pages;
> -       }
> -
> -       return total;
> -}
> -
> -static inline unsigned long __hyp_pgtable_total_pages(void)
> -{
> -       unsigned long res = 0, i;
> -
> -       /* Cover all of memory with page-granularity */
> -       for (i = 0; i < kvm_nvhe_sym(hyp_memblock_nr); i++) {
> -               struct memblock_region *reg = &kvm_nvhe_sym(hyp_memory)[i];
> -               res += __hyp_pgtable_max_pages(reg->size >> PAGE_SHIFT);
> -       }
> -
> -       return res;
> -}
> -
> -static inline unsigned long hyp_s1_pgtable_pages(void)
> -{
> -       unsigned long res;
> -
> -       res = __hyp_pgtable_total_pages();
> -
> -       /* Allow 1 GiB for private mappings */
> -       res += __hyp_pgtable_max_pages(SZ_1G >> PAGE_SHIFT);
> -
> -       return res;
> -}
> -
> -static inline unsigned long host_s2_pgtable_pages(void)
> -{
> -       unsigned long res;
> -
> -       /*
> -        * Include an extra 16 pages to safely upper-bound the worst case of
> -        * concatenated pgds.
> -        */
> -       res = __hyp_pgtable_total_pages() + 16;
> -
> -       /* Allow 1 GiB for MMIO mappings */
> -       res += __hyp_pgtable_max_pages(SZ_1G >> PAGE_SHIFT);
> -
> -       return res;
> -}
> -
>  #endif /* __KVM_HYP_MM_H */
> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> index c1a90dd022b8..92262e89672d 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> @@ -9,6 +9,7 @@
>  #include <asm/kvm_hyp.h>
>  #include <asm/kvm_mmu.h>
>  #include <asm/kvm_pgtable.h>
> +#include <asm/kvm_pkvm.h>
>  #include <asm/stage2_pgtable.h>
>
>  #include <hyp/fault.h>
> diff --git a/arch/arm64/kvm/hyp/nvhe/mm.c b/arch/arm64/kvm/hyp/nvhe/mm.c
> index 2fabeceb889a..9e0ff5a700dd 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mm.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mm.c
> @@ -8,6 +8,7 @@
>  #include <asm/kvm_hyp.h>
>  #include <asm/kvm_mmu.h>
>  #include <asm/kvm_pgtable.h>
> +#include <asm/kvm_pkvm.h>
>  #include <asm/spectre.h>
>
>  #include <nvhe/early_alloc.h>
> diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
> index 578f71798c2e..51e68a040d8a 100644
> --- a/arch/arm64/kvm/hyp/nvhe/setup.c
> +++ b/arch/arm64/kvm/hyp/nvhe/setup.c
> @@ -8,6 +8,7 @@
>  #include <asm/kvm_hyp.h>
>  #include <asm/kvm_mmu.h>
>  #include <asm/kvm_pgtable.h>
> +#include <asm/kvm_pkvm.h>
>
>  #include <nvhe/early_alloc.h>
>  #include <nvhe/fixed_config.h>
> diff --git a/arch/arm64/kvm/hyp/reserved_mem.c b/arch/arm64/kvm/pkvm.c
> similarity index 94%
> rename from arch/arm64/kvm/hyp/reserved_mem.c
> rename to arch/arm64/kvm/pkvm.c
> index 578670e3f608..ebecb7c045f4 100644
> --- a/arch/arm64/kvm/hyp/reserved_mem.c
> +++ b/arch/arm64/kvm/pkvm.c
> @@ -8,10 +8,9 @@
>  #include <linux/memblock.h>
>  #include <linux/sort.h>
>
> -#include <asm/kvm_host.h>
> +#include <asm/kvm_pkvm.h>
>
> -#include <nvhe/memory.h>
> -#include <nvhe/mm.h>
> +#include "hyp_constants.h"
>
>  static struct memblock_region *hyp_memory = kvm_nvhe_sym(hyp_memory);
>  static unsigned int *hyp_memblock_nr_ptr = &kvm_nvhe_sym(hyp_memblock_nr);
> @@ -82,7 +81,8 @@ void __init kvm_hyp_reserve(void)
>         do {
>                 prev = nr_pages;
>                 nr_pages = hyp_mem_pages + prev;
> -               nr_pages = DIV_ROUND_UP(nr_pages * sizeof(struct hyp_page), PAGE_SIZE);
> +               nr_pages = DIV_ROUND_UP(nr_pages * STRUCT_HYP_PAGE_SIZE,
> +                                       PAGE_SIZE);
>                 nr_pages += __hyp_pgtable_max_pages(nr_pages);
>         } while (nr_pages != prev);
>         hyp_mem_pages += nr_pages;
> --
> 2.34.0.rc2.393.gf8c9666880-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
