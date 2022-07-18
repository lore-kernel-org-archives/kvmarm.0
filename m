Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4B2EC43334
	for <kvmarm@archiver.kernel.org>; Mon, 18 Jul 2022 09:46:46 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D8914D482;
	Mon, 18 Jul 2022 05:46:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id CnB+EXXY4JXV; Mon, 18 Jul 2022 05:46:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 25D2F4D47F;
	Mon, 18 Jul 2022 05:46:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C4A04D478
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2022 05:46:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aVXn7cRklHFG for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Jul 2022 05:46:43 -0400 (EDT)
Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com
 [209.85.160.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 14E764D47B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2022 05:46:43 -0400 (EDT)
Received: by mail-oa1-f43.google.com with SMTP id
 586e51a60fabf-10bffc214ffso22348549fac.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2022 02:46:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=U2yhmbyv01uOIjeRobhIVpb+L4tkyRO4O4gfBMzGBhI=;
 b=lfPfnFdCPXV+PYM/byQameMx4f1n+wR1U6kVW+W7ZXvueXuwHTda2POXkZBbNuTwra
 ZuHqWOD9twyWuEZd7kVrVCnDPgGzUXoSuqBlE2d8fGS6KrIssr2YGNi/2yhM8KYa2pr6
 uoTWw57eDXSVvJeTXdngK3KyeLFB/MDfzXXtqQuGKOsMu+q5QPH0r7DL+Igz+IGwzHap
 6vRXiCPKIQ0q8u3u/VA7ODLXI0jcxzEO2svrquiJEdfcinWaIu0XLoLgc9P+tgqvaBdi
 YTAWDt096eIfN/D0tDzu5UT4XfLMhDh1EsICVvzwDdnx+4vKZFYpomAIXjxJYqbfhUVS
 k+OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=U2yhmbyv01uOIjeRobhIVpb+L4tkyRO4O4gfBMzGBhI=;
 b=ckGC2UD1xL6vhxBFg9e7JA7XwfcNeYJ668/p4v4arvhRbhSWu2nK2Ih68GZlkmaszD
 /V1iGXEDChq81jEjmJiVP9M0JR+qb/Gv1FF3nYn/r2F+Nk+aj/8K4BQfVtNbtsSkui6Y
 Ls5z5FLSbatkBxryxFF0KOtVoNc8Az/b9EQFtsGVGORyzi53pyhSX6ozoWAm6yhvNxsT
 dvWy8Kd44EAlpLaztuGDXPBJN191eVjpx/Dqwp5GdjfR5LXoFe0GL9CbpfceRuitWZsO
 zhqdii05fnvsjibJkg/KGCBHnUi3IQmiLCQc0ePxpRpfq8FdvWZq0Mk7qGmSld8w6WZ9
 2Mvg==
X-Gm-Message-State: AJIora8e3fU93z/1aCXS8NDlyTn9pVSHdZuwt5q/nwbifejq86J084U0
 5Yz3NZNSvHJ4xClSK3WEwfIm5M8AlOK+ewQJYnTlqA==
X-Google-Smtp-Source: AGRyM1tiyXNFK3NUMUmemwqQqPJMdNJcCB/etqOMbIVxms1eVnfZb8oK+DYQrOYHFVrFuXShXg9xgeZXf0UF/AlVWfQ=
X-Received: by 2002:a05:6808:1182:b0:32d:a9d3:4e0 with SMTP id
 j2-20020a056808118200b0032da9d304e0mr14930043oil.146.1658137602109; Mon, 18
 Jul 2022 02:46:42 -0700 (PDT)
MIME-Version: 1.0
References: <20220715061027.1612149-1-kaleshsingh@google.com>
 <20220715061027.1612149-8-kaleshsingh@google.com>
In-Reply-To: <20220715061027.1612149-8-kaleshsingh@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 18 Jul 2022 10:46:06 +0100
Message-ID: <CA+EHjTxrdacNE-kd2kUSHRZXdgtLZkzwZcamiHaAW4=yfGWtwQ@mail.gmail.com>
Subject: Re: [PATCH v4 07/18] KVM: arm64: On stack overflow switch to hyp
 overflow_stack
To: Kalesh Singh <kaleshsingh@google.com>
Cc: wangkefeng.wang@huawei.com, elver@google.com, catalin.marinas@arm.com,
 ast@kernel.org, vincenzo.frascino@arm.com, will@kernel.org,
 android-mm@google.com, maz@kernel.org, kvmarm@lists.cs.columbia.edu,
 madvenka@linux.microsoft.com, andreyknvl@gmail.com, kernel-team@android.com,
 drjones@redhat.com, broonie@kernel.org, linux-arm-kernel@lists.infradead.org,
 russell.king@oracle.com, linux-kernel@vger.kernel.org, mhiramat@kernel.org
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

Hi Kalesh,

On Fri, Jul 15, 2022 at 7:11 AM Kalesh Singh <kaleshsingh@google.com> wrote:
>
> On hyp stack overflow switch to 16-byte aligned secondary stack.
> This provides us stack space to better handle overflows; and is
> used in a subsequent patch to dump the hypervisor stacktrace.
>
> Signed-off-by: Kalesh Singh <kaleshsingh@google.com>

Reviewed-by: Fuad Tabba <tabba@google.com>

Thanks,
/fuad


> ---
>  arch/arm64/kvm/hyp/nvhe/Makefile     |  2 +-
>  arch/arm64/kvm/hyp/nvhe/host.S       |  9 ++-------
>  arch/arm64/kvm/hyp/nvhe/stacktrace.c | 11 +++++++++++
>  3 files changed, 14 insertions(+), 8 deletions(-)
>  create mode 100644 arch/arm64/kvm/hyp/nvhe/stacktrace.c
>
> diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
> index f9fe4dc21b1f..524e7dad5739 100644
> --- a/arch/arm64/kvm/hyp/nvhe/Makefile
> +++ b/arch/arm64/kvm/hyp/nvhe/Makefile
> @@ -14,7 +14,7 @@ lib-objs := $(addprefix ../../../lib/, $(lib-objs))
>
>  obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o host.o \
>          hyp-main.o hyp-smp.o psci-relay.o early_alloc.o page_alloc.o \
> -        cache.o setup.o mm.o mem_protect.o sys_regs.o pkvm.o
> +        cache.o setup.o mm.o mem_protect.o sys_regs.o pkvm.o stacktrace.o
>  obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
>          ../fpsimd.o ../hyp-entry.o ../exception.o ../pgtable.o
>  obj-$(CONFIG_DEBUG_LIST) += list_debug.o
> diff --git a/arch/arm64/kvm/hyp/nvhe/host.S b/arch/arm64/kvm/hyp/nvhe/host.S
> index ea6a397b64a6..b6c0188c4b35 100644
> --- a/arch/arm64/kvm/hyp/nvhe/host.S
> +++ b/arch/arm64/kvm/hyp/nvhe/host.S
> @@ -177,13 +177,8 @@ SYM_FUNC_END(__host_hvc)
>         b       hyp_panic
>
>  .L__hyp_sp_overflow\@:
> -       /*
> -        * Reset SP to the top of the stack, to allow handling the hyp_panic.
> -        * This corrupts the stack but is ok, since we won't be attempting
> -        * any unwinding here.
> -        */
> -       ldr_this_cpu    x0, kvm_init_params + NVHE_INIT_STACK_HYP_VA, x1
> -       mov     sp, x0
> +       /* Switch to the overflow stack */
> +       adr_this_cpu sp, overflow_stack + OVERFLOW_STACK_SIZE, x0
>
>         b       hyp_panic_bad_stack
>         ASM_BUG()
> diff --git a/arch/arm64/kvm/hyp/nvhe/stacktrace.c b/arch/arm64/kvm/hyp/nvhe/stacktrace.c
> new file mode 100644
> index 000000000000..a3d5b34e1249
> --- /dev/null
> +++ b/arch/arm64/kvm/hyp/nvhe/stacktrace.c
> @@ -0,0 +1,11 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * KVM nVHE hypervisor stack tracing support.
> + *
> + * Copyright (C) 2022 Google LLC
> + */
> +#include <asm/memory.h>
> +#include <asm/percpu.h>
> +
> +DEFINE_PER_CPU(unsigned long [OVERFLOW_STACK_SIZE/sizeof(long)], overflow_stack)
> +       __aligned(16);
> --
> 2.37.0.170.g444d1eabd0-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
