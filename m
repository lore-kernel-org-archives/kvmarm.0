Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3200C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 21 Jul 2022 09:59:58 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A25B4C973;
	Thu, 21 Jul 2022 05:59:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jkrRcDxoQVxG; Thu, 21 Jul 2022 05:59:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1ED294C960;
	Thu, 21 Jul 2022 05:59:57 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6B0B74C94C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2022 05:59:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RX+jOnpYHmkD for <kvmarm@lists.cs.columbia.edu>;
 Thu, 21 Jul 2022 05:59:54 -0400 (EDT)
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com
 [209.85.218.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2634E4C954
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2022 05:59:54 -0400 (EDT)
Received: by mail-ej1-f45.google.com with SMTP id ss3so2199260ejc.11
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2022 02:59:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=YRuj5aWsShz9jBaLwek0rK4p5Pf7KkoKG3tMbRUcKb4=;
 b=TyTUbJW3Oel0yeLIXKJoooWk7FIEJOV+gb8QtrYbB6QDVzgwMOWkD8jOXUqSg/N+wX
 eH4htGxC73E0r5kp3JnF9TtfwAkp3/ts+GobF22K8d6PUCb8yM8en4tsAJ4n7Uvfl51K
 JvlT8QxY/tqO2n7HVJN018YB6s2YNMIh3FPYKuwr8XnRKlvsT924QkzuVJXbKyZbkEex
 rOi4wjEA8B6MDoyIbzlLg7l7cX5sQkQoTDpQGj8b3FBxtOzNQsV2ggQe+ek2ofTtPM4B
 AjXLyFluovVgNtzFfl+sItcQuGK08VZ93lEinKTw8iK8oe2j4JHFoqj9vHsI4CLbgB4F
 W9UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=YRuj5aWsShz9jBaLwek0rK4p5Pf7KkoKG3tMbRUcKb4=;
 b=PjNgtSRtc9dJx5pNVtSXtbOTiEN3ODAixccNWRGIoGg+E/NWQyF0pABfuvV7GHD0I2
 1PDdhQZc6l6m9Wrf4qX6FlIxCeYpo4mNU9UYfcwegxpvu3m1FsBJzdKbgFCJiki/MnBz
 FmrJ+mvYViT1OSuCdo2thqGqbkEMFPUkaOmGWyaavCegZTpsGGKRmbEr2i+CGKjQop/H
 dX72s2K5HvfezH7i6DEX3nEub8PdDd8sHBqUwbFu8tAmJWUdvRwYKV71ML5wmK/PlamD
 nt1/ezSbajC1MKFDv0YQoE1iJPm2vfKLRUFcZwl5UiblgBZ/at4bShCvAVbhyBz7H41K
 Inag==
X-Gm-Message-State: AJIora8JI3hF2SizZZ6DH1nhksyBNX5yCqrSoeWNMwMueEt7jsG53EX9
 Ua+T4cuC6EFhH2tVsSRmKLPnepHZwqZE3v80NAev/Q==
X-Google-Smtp-Source: AGRyM1t/qVesbs7dKOtAbMkwDi3wAd1KAXVNo7EHGxe/fuV6MDJG76vZdRfMeEm/jZtDQwF+LhqMVK4rrBBVRzoNfRk=
X-Received: by 2002:a17:907:72c6:b0:72f:b01:2723 with SMTP id
 du6-20020a17090772c600b0072f0b012723mr26071762ejc.439.1658397593110; Thu, 21
 Jul 2022 02:59:53 -0700 (PDT)
MIME-Version: 1.0
References: <20220721055728.718573-1-kaleshsingh@google.com>
 <20220721055728.718573-18-kaleshsingh@google.com>
In-Reply-To: <20220721055728.718573-18-kaleshsingh@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 21 Jul 2022 10:59:16 +0100
Message-ID: <CA+EHjTza-fm0j5FU3n4huYTtiNTEDZ7qx10iYW7NSZ=eoUKYVQ@mail.gmail.com>
Subject: Re: [PATCH v5 17/17] KVM: arm64: Introduce hyp_dump_backtrace()
To: Kalesh Singh <kaleshsingh@google.com>
Cc: wangkefeng.wang@huawei.com, catalin.marinas@arm.com, ast@kernel.org,
 vincenzo.frascino@arm.com, will@kernel.org, kvmarm@lists.cs.columbia.edu,
 maz@kernel.org, madvenka@linux.microsoft.com, kernel-team@android.com,
 elver@google.com, broonie@kernel.org, linux-arm-kernel@lists.infradead.org,
 andreyknvl@gmail.com, linux-kernel@vger.kernel.org, mhiramat@kernel.org
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

On Thu, Jul 21, 2022 at 6:58 AM Kalesh Singh <kaleshsingh@google.com> wrote:
>
> In non-protected nVHE mode, unwinds and dumps the hypervisor backtrace
> from EL1. This is possible beacuase the host can directly access the
> hypervisor stack pages in non-proteced mode.

because and non-protected

>
> Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
> ---
>
> Changes in v5:
>   - Move code out from nvhe.h header to handle_exit.c, per Marc
>   - Fix stacktrace symoblization when CONFIG_RAMDOMIZE_BASE is enabled,
>     per Fuad
>   - Use regular comments instead of doc comments, per Fuad
>
>  arch/arm64/kvm/handle_exit.c | 65 +++++++++++++++++++++++++++++++-----
>  1 file changed, 56 insertions(+), 9 deletions(-)
>
> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> index ad568da5c7d7..432b6b26f4ad 100644
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c
> @@ -17,6 +17,7 @@
>  #include <asm/kvm_emulate.h>
>  #include <asm/kvm_mmu.h>
>  #include <asm/debug-monitors.h>
> +#include <asm/stacktrace/nvhe.h>
>  #include <asm/traps.h>
>
>  #include <kvm/arm_hypercalls.h>
> @@ -318,6 +319,56 @@ void handle_exit_early(struct kvm_vcpu *vcpu, int exception_index)
>                 kvm_handle_guest_serror(vcpu, kvm_vcpu_get_esr(vcpu));
>  }
>
> +/*
> + * kvm_nvhe_print_backtrace_entry - Symbolizes and prints the HYP stack address
> + */
> +static void kvm_nvhe_print_backtrace_entry(unsigned long addr,
> +                                                 unsigned long hyp_offset)
> +{
> +       unsigned long va_mask = GENMASK_ULL(vabits_actual - 1, 0);
> +
> +       /* Mask tags and convert to kern addr */
> +       addr = (addr & va_mask) + hyp_offset;
> +       kvm_err(" [<%016lx>] %pB\n", addr, (void *)(addr + kaslr_offset()));
> +}
> +
> +/*
> + * hyp_dump_backtrace_entry - Dump an entry of the non-protected nVHE HYP stacktrace
> + *
> + * @arg    : the hypervisor offset, used for address translation
> + * @where  : the program counter corresponding to the stack frame
> + */
> +static bool hyp_dump_backtrace_entry(void *arg, unsigned long where)
> +{
> +       kvm_nvhe_print_backtrace_entry(where, (unsigned long)arg);
> +
> +       return true;
> +}
> +
> +/*
> + * hyp_dump_backtrace - Dump the non-proteced nVHE HYP backtrace.

non-protected

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad


> + *
> + * @hyp_offset: hypervisor offset, used for address translation.
> + *
> + * The host can directly access HYP stack pages in non-protected
> + * mode, so the unwinding is done directly from EL1. This removes
> + * the need for shared buffers between host and hypervisor for
> + * the stacktrace.
> + */
> +static void hyp_dump_backtrace(unsigned long hyp_offset)
> +{
> +       struct kvm_nvhe_stacktrace_info *stacktrace_info;
> +       struct unwind_state state;
> +
> +       stacktrace_info = this_cpu_ptr_nvhe_sym(kvm_stacktrace_info);
> +
> +       kvm_nvhe_unwind_init(&state, stacktrace_info->fp, stacktrace_info->pc);
> +
> +       kvm_err("Non-protected nVHE HYP call trace:\n");
> +       unwind(&state, hyp_dump_backtrace_entry, (void *)hyp_offset);
> +       kvm_err("---- End of Non-protected nVHE HYP call trace ----\n");
> +}
> +
>  #ifdef CONFIG_PROTECTED_NVHE_STACKTRACE
>  DECLARE_KVM_NVHE_PER_CPU(unsigned long [NVHE_STACKTRACE_SIZE/sizeof(long)],
>                          pkvm_stacktrace);
> @@ -336,18 +387,12 @@ static void pkvm_dump_backtrace(unsigned long hyp_offset)
>  {
>         unsigned long *stacktrace_entry
>                 = (unsigned long *)this_cpu_ptr_nvhe_sym(pkvm_stacktrace);
> -       unsigned long va_mask, pc;
> -
> -       va_mask = GENMASK_ULL(vabits_actual - 1, 0);
>
>         kvm_err("Protected nVHE HYP call trace:\n");
>
> -       /* The stack trace is terminated by a null entry */
> -       for (; *stacktrace_entry; stacktrace_entry++) {
> -               /* Mask tags and convert to kern addr */
> -               pc = (*stacktrace_entry & va_mask) + hyp_offset;
> -               kvm_err(" [<%016lx>] %pB\n", pc, (void *)(pc + kaslr_offset()));
> -       }
> +       /* The saved stacktrace is terminated by a null entry */
> +       for (; *stacktrace_entry; stacktrace_entry++)
> +               kvm_nvhe_print_backtrace_entry(*stacktrace_entry, hyp_offset);
>
>         kvm_err("---- End of Protected nVHE HYP call trace ----\n");
>  }
> @@ -367,6 +412,8 @@ static void kvm_nvhe_dump_backtrace(unsigned long hyp_offset)
>  {
>         if (is_protected_kvm_enabled())
>                 pkvm_dump_backtrace(hyp_offset);
> +       else
> +               hyp_dump_backtrace(hyp_offset);
>  }
>
>  void __noreturn __cold nvhe_hyp_panic_handler(u64 esr, u64 spsr,
> --
> 2.37.0.170.g444d1eabd0-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
