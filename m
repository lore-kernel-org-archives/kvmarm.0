Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CF80C43334
	for <kvmarm@archiver.kernel.org>; Mon, 18 Jul 2022 10:07:43 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C09104D4D7;
	Mon, 18 Jul 2022 06:07:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gUc4e2VyMivA; Mon, 18 Jul 2022 06:07:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 586D94D4DB;
	Mon, 18 Jul 2022 06:07:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E90B4D4D7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2022 06:07:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UgOuJwseLWzL for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Jul 2022 06:07:39 -0400 (EDT)
Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com
 [209.85.210.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E7EEB4D4D2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2022 06:07:38 -0400 (EDT)
Received: by mail-ot1-f50.google.com with SMTP id
 cb12-20020a056830618c00b00616b871cef3so8793504otb.5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2022 03:07:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=G1B6LYic7bwDg6gUAL/jCgt+JOlqR4ifyS5aTqPKrh0=;
 b=UrRegEvgPG/jfL/dTEzLtOHbQnT4nLgaRrymQ49RRzhmYlHF+O/jiDozArIukNwL70
 aoL/5Ccyc5I9l9zZNmm3atZ7sP6lR87VCBAO4eU3XjMJ7S1BflZKm+aWOUbZeUzIvZnb
 oll4eQNo1XPtDZpsmMOUPvQT87touG3F/SnR/t9CzPoCgcWPWvlLn+SEK6uR2pK7FZI4
 tqXhIrFnpgJXlB8fXQE/sw2igM+pcNtQs6hCwE8fD4LwZD2AUPUPemiW9Mqdr+PQp2kB
 RZjSxduPY0l1QTOQPxxbIxLOIk5X1py6qkPCTcj+e+jpfru4faiCWHE/+ucGnSJ512lq
 t02A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=G1B6LYic7bwDg6gUAL/jCgt+JOlqR4ifyS5aTqPKrh0=;
 b=P5mDIPW5lKWSqCFB/WXY/+V5NT7sfZlgHS/PlX5wPf0VozUgrH+Ejbws8DHlpROpb/
 9b5TXdtWRCR5sPsIa2k8b2fQVKUnnx1tKsuy1aYX+2l8lH+gACepYGiyYdgjArAfAMWD
 6cjBoYlSfpa9ZIF4c920ip8htBxVE/fLOMTEDqgGzQyIC26auDsN+oVi1LWHKW/28vN9
 RNqeKk+R0pxhaeQdosovP03p3kwOekQkYejs4fD1lXfbckHnzfmIGy3vrLWgH6c2O1Vd
 8t0g0lqC5gOFtjGK1lyjrWMFrnz9GIEBrNDjrbtt+KX2iFAbVe/rwrc5wY2LIqssvNa2
 53Og==
X-Gm-Message-State: AJIora8XGeCryYsLnogGTDjnKifml12de+NHOBhapQmFz6bXyrPG0nWO
 NgVCvUX8+L92elkszI0wQ9BUkk2h7XwYKcDSgJYX4g==
X-Google-Smtp-Source: AGRyM1ujoTWX6QWprhwkAQ746MHzUqCvowmZ3vcJ0lh4yknvlPC4dPBONKcRGGIrdbY+40/9rxyxa6G4CCS8RwlIeUk=
X-Received: by 2002:a05:6830:108a:b0:61c:9fb5:6784 with SMTP id
 y10-20020a056830108a00b0061c9fb56784mr1830589oto.299.1658138857268; Mon, 18
 Jul 2022 03:07:37 -0700 (PDT)
MIME-Version: 1.0
References: <20220715061027.1612149-1-kaleshsingh@google.com>
 <20220715061027.1612149-13-kaleshsingh@google.com>
In-Reply-To: <20220715061027.1612149-13-kaleshsingh@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 18 Jul 2022 11:07:00 +0100
Message-ID: <CA+EHjTw8VwFHYHzpyt+sqwo7CDhGm+F+h2+AX=5FtYcXPECGUA@mail.gmail.com>
Subject: Re: [PATCH v4 12/18] KVM: arm64: Save protected-nVHE (pKVM) hyp
 stacktrace
To: Kalesh Singh <kaleshsingh@google.com>
Cc: wangkefeng.wang@huawei.com, catalin.marinas@arm.com, ast@kernel.org,
 vincenzo.frascino@arm.com, will@kernel.org, maz@kernel.org,
 kvmarm@lists.cs.columbia.edu, madvenka@linux.microsoft.com,
 andreyknvl@gmail.com, kernel-team@android.com, elver@google.com,
 broonie@kernel.org, linux-arm-kernel@lists.infradead.org,
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
> Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
> ---
>  arch/arm64/include/asm/stacktrace/nvhe.h | 18 ++++++
>  arch/arm64/kvm/hyp/nvhe/stacktrace.c     | 70 ++++++++++++++++++++++++
>  2 files changed, 88 insertions(+)
>
> diff --git a/arch/arm64/include/asm/stacktrace/nvhe.h b/arch/arm64/include/asm/stacktrace/nvhe.h
> index 36cf7858ddd8..456a6ae08433 100644
> --- a/arch/arm64/include/asm/stacktrace/nvhe.h
> +++ b/arch/arm64/include/asm/stacktrace/nvhe.h
> @@ -21,6 +21,22 @@
>
>  #include <asm/stacktrace/common.h>
>
> +/**
> + * kvm_nvhe_unwind_init - Start an unwind from the given nVHE HYP fp and pc
> + *
> + * @fp : frame pointer at which to start the unwinding.
> + * @pc : program counter at which to start the unwinding.
> + */
> +static __always_inline void kvm_nvhe_unwind_init(struct unwind_state *state,
> +                                                unsigned long fp,
> +                                                unsigned long pc)
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
> @@ -33,6 +49,8 @@ static inline bool on_accessible_stack(const struct task_struct *tsk,
>   */
>  #ifdef __KVM_NVHE_HYPERVISOR__
>
> +extern void kvm_nvhe_prepare_backtrace(unsigned long fp, unsigned long pc);
> +
>  #ifdef CONFIG_PROTECTED_NVHE_STACKTRACE
>  static inline bool on_overflow_stack(unsigned long sp, unsigned long size,
>                                      struct stack_info *info)
> diff --git a/arch/arm64/kvm/hyp/nvhe/stacktrace.c b/arch/arm64/kvm/hyp/nvhe/stacktrace.c
> index 96c8b93320eb..832a536e440f 100644
> --- a/arch/arm64/kvm/hyp/nvhe/stacktrace.c
> +++ b/arch/arm64/kvm/hyp/nvhe/stacktrace.c
> @@ -11,4 +11,74 @@ DEFINE_PER_CPU(unsigned long [OVERFLOW_STACK_SIZE/sizeof(long)], overflow_stack)
>
>  #ifdef CONFIG_PROTECTED_NVHE_STACKTRACE
>  DEFINE_PER_CPU(unsigned long [NVHE_STACKTRACE_SIZE/sizeof(long)], pkvm_stacktrace);
> +
> +/**
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
> +       unsigned long **stacktrace_pos = (unsigned long **)arg;
> +       unsigned long stacktrace_start, stacktrace_end;
> +
> +       stacktrace_start = (unsigned long)this_cpu_ptr(pkvm_stacktrace);
> +       stacktrace_end = stacktrace_start + NVHE_STACKTRACE_SIZE - (2 * sizeof(long));

I guess this is related to my comment in patch 9, but why does the end
happen at 2 * instead of just 1 * before the actual end? I guess
because it's inclusive. That said, a comment would be helpful.

Thanks,
/fuad

> +
> +       if ((unsigned long) *stacktrace_pos > stacktrace_end)
> +               return false;
> +
> +       /* Save the entry to the current pos in stacktrace buffer */
> +       **stacktrace_pos = where;
> +
> +       /* A zero entry delimits the end of the stacktrace. */
> +       *(*stacktrace_pos + 1) = 0UL;
> +
> +       /* Increment the current pos */
> +       ++*stacktrace_pos;
> +
> +       return true;
> +}
> +
> +/**
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
> +       void *stacktrace_start = (void *)this_cpu_ptr(pkvm_stacktrace);
> +       struct unwind_state state;
> +
> +       kvm_nvhe_unwind_init(&state, fp, pc);
> +
> +       unwind(&state, pkvm_save_backtrace_entry, &stacktrace_start);
> +}
> +#else /* !CONFIG_PROTECTED_NVHE_STACKTRACE */
> +static void pkvm_save_backtrace(unsigned long fp, unsigned long pc)
> +{
> +}
>  #endif /* CONFIG_PROTECTED_NVHE_STACKTRACE */
> +
> +/**
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
> --
> 2.37.0.170.g444d1eabd0-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
