Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1200C43334
	for <kvmarm@archiver.kernel.org>; Thu, 21 Jul 2022 09:59:05 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 850384C938;
	Thu, 21 Jul 2022 05:59:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2dJQVsD5wB0z; Thu, 21 Jul 2022 05:59:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 468A24C93D;
	Thu, 21 Jul 2022 05:59:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 013924C91D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2022 05:59:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6XjUfsGrFd3c for <kvmarm@lists.cs.columbia.edu>;
 Thu, 21 Jul 2022 05:59:01 -0400 (EDT)
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com
 [209.85.218.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 94EEE4C8FA
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2022 05:59:01 -0400 (EDT)
Received: by mail-ej1-f53.google.com with SMTP id bp15so2263324ejb.6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2022 02:59:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=pZvUKHJNTfmBnKV8kgAnzPvrEetHhpiiwn0CmD7YnH8=;
 b=gCb97B26rLG9bG6wWGSo2AzrAVTY7CYKpx+TdQI13hc+pfM6pvmLXVFX8n8MkbI+rT
 /TZcpud5Pwcv8YJm1cFZiz6E6C1/FmLuR7ARLCN2X6yQV65eoNokK3JxnCv0eq0Pnvo9
 fnBJ2Dm6zYJh+FktFH/xMiqctQwQUtO6/SyBIIa+9LjOkBUUN1gcSyo8stmauamoAixp
 qPdPaOg49j6rqBvrMyK0RLBbfOL8Fexvb33IjNca2bT8VUotOcadcKpBh5IAWDYgFJqt
 /m21CqY9/cFF8LUXvF7KOehl/NDK4XeChBOJmKYU9d4FGzrVFbGAyDk4FJ6OqLpFMfo3
 pyng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=pZvUKHJNTfmBnKV8kgAnzPvrEetHhpiiwn0CmD7YnH8=;
 b=CNoYZPSMgjTbGXlucrVhMpo7ISlsR7Qoeb/dMjRJICZqdVB+Kw7Gkl0Y8dw1TDr6os
 yS5RRYMI0aem0kesc/Gkyevuw871n7YFhIg5kVF+d3sGQBggRye+itSnzdO2oXVFCHOU
 urlnA+qx8KrtkAzNkZ1NZrmyYC98keKOzALAA+be8bmmnQBvTxosksM/5cBCdtkLSz+P
 EfrwvhaydK6QQ5YJSGz7hqr1YvoGnQ0/OtGLfwwyVsNqTF7vBNCnUnKm+BUWcQAfPCQx
 Yl8WXtRl8Ndo5neJif51LpIKHpJlb7lI4YXqRdu9G+GhGGwQN11pxNUru40F9wgDfytl
 NSqQ==
X-Gm-Message-State: AJIora9Z+L4bpJpLT64kHZj0tQcmUZUVBfGxHpicVT0VxcvXJI+cV9In
 YCwg82nUZnpvndrCMVeWiaPIMcY11EDGOICPuXcmgA==
X-Google-Smtp-Source: AGRyM1tcz6e/l4Oph01eihlks0EVOmphItgj8l47cRLt7S4wfGEFGfhtupc4cemx3y5ufynf45Jpj7Lr4NpZRkNlJCE=
X-Received: by 2002:a17:906:84e8:b0:72b:6d91:a0d1 with SMTP id
 zp8-20020a17090684e800b0072b6d91a0d1mr39865923ejb.60.1658397540482; Thu, 21
 Jul 2022 02:59:00 -0700 (PDT)
MIME-Version: 1.0
References: <20220721055728.718573-1-kaleshsingh@google.com>
 <20220721055728.718573-13-kaleshsingh@google.com>
In-Reply-To: <20220721055728.718573-13-kaleshsingh@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 21 Jul 2022 10:58:23 +0100
Message-ID: <CA+EHjTxpgn2-Bi_-JoAnb_2iGJGxE+qHnZu7EvSE5ksS8KPciQ@mail.gmail.com>
Subject: Re: [PATCH v5 12/17] KVM: arm64: Save protected-nVHE (pKVM) hyp
 stacktrace
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
> In protected nVHE mode, the host cannot access private owned hypervisor
> memory. Also the hypervisor aims to remains simple to reduce the attack
> surface and does not provide any printk support.
>
> For the above reasons, the approach taken to provide hypervisor stacktraces
> in protected mode is:
>    1) Unwind and save the hyp stack addresses in EL2 to a shared buffer
>       with the host (done in this patch).
>    2) Delegate the dumping and symbolization of the addresses to the
>       host in EL1 (later patch in the series).
>
> On hyp_panic(), the hypervisor prepares the stacktrace before returning to
> the host.
>
> Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
> ---

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad


>
> Changes in v5:
>   - Comment/clarify pkvm_save_backtrace_entry(), per Fuad
>   - kvm_nvhe_unwind_init(), doesn't need to be always inline, make it
>     inline instead to avoid linking issues, per Marc
>   - Use regular comments instead of doc comments, per Fuad
>
>  arch/arm64/include/asm/stacktrace/nvhe.h | 17 ++++++
>  arch/arm64/kvm/hyp/nvhe/stacktrace.c     | 78 ++++++++++++++++++++++++
>  arch/arm64/kvm/hyp/nvhe/switch.c         |  6 ++
>  3 files changed, 101 insertions(+)
>
> diff --git a/arch/arm64/include/asm/stacktrace/nvhe.h b/arch/arm64/include/asm/stacktrace/nvhe.h
> index 3078501f8e22..05d7e03e0a8c 100644
> --- a/arch/arm64/include/asm/stacktrace/nvhe.h
> +++ b/arch/arm64/include/asm/stacktrace/nvhe.h
> @@ -21,6 +21,23 @@
>
>  #include <asm/stacktrace/common.h>
>
> +/*
> + * kvm_nvhe_unwind_init - Start an unwind from the given nVHE HYP fp and pc
> + *
> + * @state : unwind_state to initialize
> + * @fp    : frame pointer at which to start the unwinding.
> + * @pc    : program counter at which to start the unwinding.
> + */
> +static inline void kvm_nvhe_unwind_init(struct unwind_state *state,
> +                                       unsigned long fp,
> +                                       unsigned long pc)
> +{
> +       unwind_init_common(state, NULL);
> +
> +       state->fp = fp;
> +       state->pc = pc;
> +}
> +
>  static inline bool on_accessible_stack(const struct task_struct *tsk,
>                                        unsigned long sp, unsigned long size,
>                                        struct stack_info *info)
> diff --git a/arch/arm64/kvm/hyp/nvhe/stacktrace.c b/arch/arm64/kvm/hyp/nvhe/stacktrace.c
> index 96c8b93320eb..60461c033a04 100644
> --- a/arch/arm64/kvm/hyp/nvhe/stacktrace.c
> +++ b/arch/arm64/kvm/hyp/nvhe/stacktrace.c
> @@ -11,4 +11,82 @@ DEFINE_PER_CPU(unsigned long [OVERFLOW_STACK_SIZE/sizeof(long)], overflow_stack)
>
>  #ifdef CONFIG_PROTECTED_NVHE_STACKTRACE
>  DEFINE_PER_CPU(unsigned long [NVHE_STACKTRACE_SIZE/sizeof(long)], pkvm_stacktrace);
> +
> +/*
> + * pkvm_save_backtrace_entry - Saves a protected nVHE HYP stacktrace entry
> + *
> + * @arg    : the position of the entry in the stacktrace buffer
> + * @where  : the program counter corresponding to the stack frame
> + *
> + * Save the return address of a stack frame to the shared stacktrace buffer.
> + * The host can access this shared buffer from EL1 to dump the backtrace.
> + */
> +static bool pkvm_save_backtrace_entry(void *arg, unsigned long where)
> +{
> +       unsigned long **stacktrace_entry = (unsigned long **)arg;
> +       int nr_entries = NVHE_STACKTRACE_SIZE / sizeof(long);
> +       unsigned long *stacktrace_start, *stacktrace_end;
> +
> +       stacktrace_start = (unsigned long *)this_cpu_ptr(pkvm_stacktrace);
> +       stacktrace_end = stacktrace_start + nr_entries;
> +
> +       /*
> +        * Need 2 free slots: 1 for current entry and 1 for the
> +        * trailing zero entry delimiter.
> +        */
> +       if (*stacktrace_entry > stacktrace_end - 2)
> +               return false;
> +
> +       /* Save the current entry */
> +       **stacktrace_entry = where;
> +
> +       /* Add trailing zero entry delimiter */
> +       *(*stacktrace_entry + 1) = 0UL;
> +
> +       /*
> +        * Increment the current entry position. The zero entry
> +        * will be overwritten by the next backtrace entry (if any)
> +        */
> +       ++*stacktrace_entry;
> +
> +       return true;
> +}
> +
> +/*
> + * pkvm_save_backtrace - Saves the protected nVHE HYP stacktrace
> + *
> + * @fp : frame pointer at which to start the unwinding.
> + * @pc : program counter at which to start the unwinding.
> + *
> + * Save the unwinded stack addresses to the shared stacktrace buffer.
> + * The host can access this shared buffer from EL1 to dump the backtrace.
> + */
> +static void pkvm_save_backtrace(unsigned long fp, unsigned long pc)
> +{
> +       void *stacktrace_entry = (void *)this_cpu_ptr(pkvm_stacktrace);
> +       struct unwind_state state;
> +
> +       kvm_nvhe_unwind_init(&state, fp, pc);
> +
> +       unwind(&state, pkvm_save_backtrace_entry, &stacktrace_entry);
> +}
> +#else /* !CONFIG_PROTECTED_NVHE_STACKTRACE */
> +static void pkvm_save_backtrace(unsigned long fp, unsigned long pc)
> +{
> +}
>  #endif /* CONFIG_PROTECTED_NVHE_STACKTRACE */
> +
> +/*
> + * kvm_nvhe_prepare_backtrace - prepare to dump the nVHE backtrace
> + *
> + * @fp : frame pointer at which to start the unwinding.
> + * @pc : program counter at which to start the unwinding.
> + *
> + * Saves the information needed by the host to dump the nVHE hypervisor
> + * backtrace.
> + */
> +void kvm_nvhe_prepare_backtrace(unsigned long fp, unsigned long pc)
> +{
> +       if (is_protected_kvm_enabled())
> +               pkvm_save_backtrace(fp, pc);
> +}
> diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
> index 6db801db8f27..64e13445d0d9 100644
> --- a/arch/arm64/kvm/hyp/nvhe/switch.c
> +++ b/arch/arm64/kvm/hyp/nvhe/switch.c
> @@ -34,6 +34,8 @@ DEFINE_PER_CPU(struct kvm_host_data, kvm_host_data);
>  DEFINE_PER_CPU(struct kvm_cpu_context, kvm_hyp_ctxt);
>  DEFINE_PER_CPU(unsigned long, kvm_hyp_vector);
>
> +extern void kvm_nvhe_prepare_backtrace(unsigned long fp, unsigned long pc);
> +
>  static void __activate_traps(struct kvm_vcpu *vcpu)
>  {
>         u64 val;
> @@ -375,6 +377,10 @@ asmlinkage void __noreturn hyp_panic(void)
>                 __sysreg_restore_state_nvhe(host_ctxt);
>         }
>
> +       /* Prepare to dump kvm nvhe hyp stacktrace */
> +       kvm_nvhe_prepare_backtrace((unsigned long)__builtin_frame_address(0),
> +                                  _THIS_IP_);
> +
>         __hyp_do_panic(host_ctxt, spsr, elr, par);
>         unreachable();
>  }
> --
> 2.37.0.170.g444d1eabd0-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
