Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0ED14C43334
	for <kvmarm@archiver.kernel.org>; Thu, 21 Jul 2022 09:59:14 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B771D4C942;
	Thu, 21 Jul 2022 05:59:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id o7FuaslkBLYm; Thu, 21 Jul 2022 05:59:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 707EB4C94A;
	Thu, 21 Jul 2022 05:59:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6160C4C93D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2022 05:59:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WUfL3uSl5mYc for <kvmarm@lists.cs.columbia.edu>;
 Thu, 21 Jul 2022 05:59:10 -0400 (EDT)
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com
 [209.85.218.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 09E784C942
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2022 05:59:09 -0400 (EDT)
Received: by mail-ej1-f46.google.com with SMTP id ez10so2182447ejc.13
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2022 02:59:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=ICWtRl11EBLkBuC8EKMztaMYVbdXxjQF2E9VxjALgEA=;
 b=WE9n3XArdq7o+kzZ13s0vVvM7r42mMYB85W4rZvYcjhnt9r9XI5WbIKrjfW1LQ1pZo
 4fVZ1r/gPV499EesnIUsH8/MWOY20iAEm2+xGjR9KwHQBrsI9oS9+8qrC3JcYcoGSuDz
 S9eIWpz9x8RfGmZjQ+JZaXzfj6NvJ9/sYg+VD2tIoCHNXHeaNnyeoQpI5bLB+0ivhEqV
 a9gxnXEBoATbkdyY+gfySkgoHPGutTbCt/BPyng0x12sMOIdkXPGgI22eLE3kU7m/gQ9
 RydAP1+0G3mYntwQK5R9Vvpu482j61AuTxmLn/cJolqCYiX3YLHELJit8Zhx687II1lL
 eKNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=ICWtRl11EBLkBuC8EKMztaMYVbdXxjQF2E9VxjALgEA=;
 b=EoEFnp2NdJXKPPbfYoMwD1/cHYOJ1U+6ceECsoBji7nfI4cjIAWWTZYxFN7eKny32e
 jycvBxg36KNLT3QOfPZxxDx2ULQDcODD0dUiqn9uiR5yAWLF3TURkJTBswkeiJ7Lk9wJ
 qi5BM5/c2SyDm/klMW5qpAh98ZDq21U40tLv8xVkNMA8O4GVIcCvLWrR86R/oib9lRJQ
 mZu8RQSpWZ+hAiTBR1DO47Lh34DqCm1GZrQKbbaSKXmdPsFonmLIVfHGVJdaGfAZ4CQ5
 YFAZq4biQk1dQHz+NAktud3DEY1SiuRfMgMlNmS23JGFDLAJ7x/xTPA7+aFGTSB7nW+d
 KLZg==
X-Gm-Message-State: AJIora+ePos5It/PooLHfQQl1MJ8kpUuseftjwRmk2gaQGKXGVV+F9fS
 Dmvc+NCZ7S+PF7Ctm6k5IRT/uROwyugXq0FGxUk77Q==
X-Google-Smtp-Source: AGRyM1sjg+ZFLlpWNaGHG3a6g5PxuklNxTpGOLm/IgklW+n1Stkn0tqCWIQ3ZsPM3p/lMtRZYk/TmwDVwdphzfzbS60=
X-Received: by 2002:a17:907:7ea7:b0:72b:6e6b:4895 with SMTP id
 qb39-20020a1709077ea700b0072b6e6b4895mr39726176ejc.338.1658397549012; Thu, 21
 Jul 2022 02:59:09 -0700 (PDT)
MIME-Version: 1.0
References: <20220721055728.718573-1-kaleshsingh@google.com>
 <20220721055728.718573-14-kaleshsingh@google.com>
In-Reply-To: <20220721055728.718573-14-kaleshsingh@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 21 Jul 2022 10:58:32 +0100
Message-ID: <CA+EHjTxpHxojNdRm21hYgcWqFJCzPx3jch2bdVqZ4+2NQqNvDA@mail.gmail.com>
Subject: Re: [PATCH v5 13/17] KVM: arm64: Prepare non-protected nVHE
 hypervisor stacktrace
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
> In non-protected nVHE mode (non-pKVM) the host can directly access
> hypervisor memory; and unwinding of the hypervisor stacktrace is
> done from EL1 to save on memory for shared buffers.
>
> To unwind the hypervisor stack from EL1 the host needs to know the
> starting point for the unwind and information that will allow it to
> translate hypervisor stack addresses to the corresponding kernel
> addresses. This patch sets up this book keeping. It is made use of
> later in the series.
>
> Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
> ---

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad


>
> Changes in v5:
>   - Use regular comments instead of doc comments, per Fuad
>
>  arch/arm64/include/asm/kvm_asm.h         | 16 ++++++++++++++++
>  arch/arm64/include/asm/stacktrace/nvhe.h |  4 ++++
>  arch/arm64/kvm/hyp/nvhe/stacktrace.c     | 24 ++++++++++++++++++++++++
>  3 files changed, 44 insertions(+)
>
> diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> index 2e277f2ed671..53035763e48e 100644
> --- a/arch/arm64/include/asm/kvm_asm.h
> +++ b/arch/arm64/include/asm/kvm_asm.h
> @@ -176,6 +176,22 @@ struct kvm_nvhe_init_params {
>         unsigned long vtcr;
>  };
>
> +/*
> + * Used by the host in EL1 to dump the nVHE hypervisor backtrace on
> + * hyp_panic() in non-protected mode.
> + *
> + * @stack_base:                 hyp VA of the hyp_stack base.
> + * @overflow_stack_base:        hyp VA of the hyp_overflow_stack base.
> + * @fp:                         hyp FP where the backtrace begins.
> + * @pc:                         hyp PC where the backtrace begins.
> + */
> +struct kvm_nvhe_stacktrace_info {
> +       unsigned long stack_base;
> +       unsigned long overflow_stack_base;
> +       unsigned long fp;
> +       unsigned long pc;
> +};
> +
>  /* Translate a kernel address @ptr into its equivalent linear mapping */
>  #define kvm_ksym_ref(ptr)                                              \
>         ({                                                              \
> diff --git a/arch/arm64/include/asm/stacktrace/nvhe.h b/arch/arm64/include/asm/stacktrace/nvhe.h
> index 05d7e03e0a8c..8f02803a005f 100644
> --- a/arch/arm64/include/asm/stacktrace/nvhe.h
> +++ b/arch/arm64/include/asm/stacktrace/nvhe.h
> @@ -19,6 +19,7 @@
>  #ifndef __ASM_STACKTRACE_NVHE_H
>  #define __ASM_STACKTRACE_NVHE_H
>
> +#include <asm/kvm_asm.h>
>  #include <asm/stacktrace/common.h>
>
>  /*
> @@ -52,6 +53,9 @@ static inline bool on_accessible_stack(const struct task_struct *tsk,
>   * In protected mode, the unwinding is done by the hypervisor in EL2.
>   */
>
> +DECLARE_PER_CPU(unsigned long [OVERFLOW_STACK_SIZE/sizeof(long)], overflow_stack);
> +DECLARE_PER_CPU(struct kvm_nvhe_init_params, kvm_init_params);
> +
>  #ifdef CONFIG_PROTECTED_NVHE_STACKTRACE
>  static inline bool on_overflow_stack(unsigned long sp, unsigned long size,
>                                      struct stack_info *info)
> diff --git a/arch/arm64/kvm/hyp/nvhe/stacktrace.c b/arch/arm64/kvm/hyp/nvhe/stacktrace.c
> index 60461c033a04..cbd365f4f26a 100644
> --- a/arch/arm64/kvm/hyp/nvhe/stacktrace.c
> +++ b/arch/arm64/kvm/hyp/nvhe/stacktrace.c
> @@ -9,6 +9,28 @@
>  DEFINE_PER_CPU(unsigned long [OVERFLOW_STACK_SIZE/sizeof(long)], overflow_stack)
>         __aligned(16);
>
> +DEFINE_PER_CPU(struct kvm_nvhe_stacktrace_info, kvm_stacktrace_info);
> +
> +/*
> + * hyp_prepare_backtrace - Prepare non-protected nVHE backtrace.
> + *
> + * @fp : frame pointer at which to start the unwinding.
> + * @pc : program counter at which to start the unwinding.
> + *
> + * Save the information needed by the host to unwind the non-protected
> + * nVHE hypervisor stack in EL1.
> + */
> +static void hyp_prepare_backtrace(unsigned long fp, unsigned long pc)
> +{
> +       struct kvm_nvhe_stacktrace_info *stacktrace_info = this_cpu_ptr(&kvm_stacktrace_info);
> +       struct kvm_nvhe_init_params *params = this_cpu_ptr(&kvm_init_params);
> +
> +       stacktrace_info->stack_base = (unsigned long)(params->stack_hyp_va - PAGE_SIZE);
> +       stacktrace_info->overflow_stack_base = (unsigned long)this_cpu_ptr(overflow_stack);
> +       stacktrace_info->fp = fp;
> +       stacktrace_info->pc = pc;
> +}
> +
>  #ifdef CONFIG_PROTECTED_NVHE_STACKTRACE
>  DEFINE_PER_CPU(unsigned long [NVHE_STACKTRACE_SIZE/sizeof(long)], pkvm_stacktrace);
>
> @@ -89,4 +111,6 @@ void kvm_nvhe_prepare_backtrace(unsigned long fp, unsigned long pc)
>  {
>         if (is_protected_kvm_enabled())
>                 pkvm_save_backtrace(fp, pc);
> +       else
> +               hyp_prepare_backtrace(fp, pc);
>  }
> --
> 2.37.0.170.g444d1eabd0-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
