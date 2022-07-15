Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F33CC433EF
	for <kvmarm@archiver.kernel.org>; Fri, 15 Jul 2022 13:59:09 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A62D04BEFB;
	Fri, 15 Jul 2022 09:59:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HDOz8yNkTfgj; Fri, 15 Jul 2022 09:59:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4F96E4BEAD;
	Fri, 15 Jul 2022 09:59:07 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 23EC34BE93
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jul 2022 09:59:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nLjZLqRvIbpf for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Jul 2022 09:59:04 -0400 (EDT)
Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com
 [209.85.167.173])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BD7894BE90
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jul 2022 09:59:04 -0400 (EDT)
Received: by mail-oi1-f173.google.com with SMTP id r191so6148644oie.7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jul 2022 06:59:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=QvY29V/GM0mH1NqPcwS/Tuc0R9fYJIruV6sTb6TXI7Q=;
 b=TQgLEenxazdws7SAjjHTqasunR2EnCav01e3+lfRmImyX7Zc86iZpGxN3bx0wKUnp1
 QOeThI79bl1YWoFSH8X87Thc9NYgF2i/BbtuDAexxa0jepJ/VUYg5vmAdiSlm50EJZ9R
 +9zne5LBxOxEdxi2tgJ4p72cbEUhuiqmLyKz4zeTTm46gi5kywSEMsi0wniUFgmkX3oh
 n25rRcB/vgjjNNH2jDOnUIbT7vAJGfpgbJnQqE16ZWlZzJgPfKZC91lhhNqxGobbUnFC
 greNyvFlAviZffzNpY2wxPSPOwsbxoOGjkMc++yBEIa9jD7BINdr4g+2XPLmUvEXXxGd
 3E2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=QvY29V/GM0mH1NqPcwS/Tuc0R9fYJIruV6sTb6TXI7Q=;
 b=T2k0Vra8Lobfxh7nGrhyriBIhJI237M/kaghshD8NoogzKqYsYzG61JW447GRUtHNH
 kc+1+opv811RvA3KrfyqBPUWppWNdm5tOzPvz8U/P/5HaErFoiFHdPb4WoViMoYkqp9w
 EdbzwzFfyRM4T6fonwVp7jUUJDCjYdA2eSkWInrxMiT1pcpitFv6WBMMQYITjhKcIjtj
 q8UnutBhrbPJ69Lk2vobdIzwoszbXlYvUSVVywKAIEsq/CwhggBRzoCRtSOIAm8OyYct
 H9GbgK7/R6m/Zq6nz+P3H+cw+LZhNarBWTiXJ1sum9Q2sVGX4ouOZlAU+5SdmN+iNmf4
 prKQ==
X-Gm-Message-State: AJIora8MlXYYTt61EwFuKcDHvpzjSTWmL6ud0mwYhqoH+wnpVuh+Z1U5
 SHehTW5L6J2/2WJc9fK3Kt0z6AXf2cAy3e3QF5Chww==
X-Google-Smtp-Source: AGRyM1vxgZjKkuDI5/wzHx61/ekf3zJdK1KuYe2+bO8Nmwp5DWyBuh0+xl9Yf7quQUx7gopiDiGvDXqpKG8WcMJK8es=
X-Received: by 2002:a05:6808:1182:b0:32d:a9d3:4e0 with SMTP id
 j2-20020a056808118200b0032da9d304e0mr9681619oil.146.1657893543854; Fri, 15
 Jul 2022 06:59:03 -0700 (PDT)
MIME-Version: 1.0
References: <20220715061027.1612149-1-kaleshsingh@google.com>
 <20220715061027.1612149-2-kaleshsingh@google.com>
In-Reply-To: <20220715061027.1612149-2-kaleshsingh@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 15 Jul 2022 14:58:27 +0100
Message-ID: <CA+EHjTypfypdE=bf5iH87UpQU+feozd486DAXk02Q9PAMqk0BA@mail.gmail.com>
Subject: Re: [PATCH v4 01/18] arm64: stacktrace: Add shared header for common
 stack unwinding code
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

On Fri, Jul 15, 2022 at 7:10 AM Kalesh Singh <kaleshsingh@google.com> wrote:
>
> In order to reuse the arm64 stack unwinding logic for the nVHE
> hypervisor stack, move the common code to a shared header
> (arch/arm64/include/asm/stacktrace/common.h).
>
> The nVHE hypervisor cannot safely link against kernel code, so we
> make use of the shared header to avoid duplicated logic later in
> this series.
>
> Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
> ---

Reviewed-by: Fuad Tabba <tabba@google.com>

Thanks,
/fuad


>  arch/arm64/include/asm/stacktrace.h        |  35 +------
>  arch/arm64/include/asm/stacktrace/common.h | 105 +++++++++++++++++++++
>  arch/arm64/kernel/stacktrace.c             |  57 -----------
>  3 files changed, 106 insertions(+), 91 deletions(-)
>  create mode 100644 arch/arm64/include/asm/stacktrace/common.h
>
> diff --git a/arch/arm64/include/asm/stacktrace.h b/arch/arm64/include/asm/stacktrace.h
> index aec9315bf156..79f455b37c84 100644
> --- a/arch/arm64/include/asm/stacktrace.h
> +++ b/arch/arm64/include/asm/stacktrace.h
> @@ -8,52 +8,19 @@
>  #include <linux/percpu.h>
>  #include <linux/sched.h>
>  #include <linux/sched/task_stack.h>
> -#include <linux/types.h>
>  #include <linux/llist.h>
>
>  #include <asm/memory.h>
>  #include <asm/ptrace.h>
>  #include <asm/sdei.h>
>
> -enum stack_type {
> -       STACK_TYPE_UNKNOWN,
> -       STACK_TYPE_TASK,
> -       STACK_TYPE_IRQ,
> -       STACK_TYPE_OVERFLOW,
> -       STACK_TYPE_SDEI_NORMAL,
> -       STACK_TYPE_SDEI_CRITICAL,
> -       __NR_STACK_TYPES
> -};
> -
> -struct stack_info {
> -       unsigned long low;
> -       unsigned long high;
> -       enum stack_type type;
> -};
> +#include <asm/stacktrace/common.h>
>
>  extern void dump_backtrace(struct pt_regs *regs, struct task_struct *tsk,
>                            const char *loglvl);
>
>  DECLARE_PER_CPU(unsigned long *, irq_stack_ptr);
>
> -static inline bool on_stack(unsigned long sp, unsigned long size,
> -                           unsigned long low, unsigned long high,
> -                           enum stack_type type, struct stack_info *info)
> -{
> -       if (!low)
> -               return false;
> -
> -       if (sp < low || sp + size < sp || sp + size > high)
> -               return false;
> -
> -       if (info) {
> -               info->low = low;
> -               info->high = high;
> -               info->type = type;
> -       }
> -       return true;
> -}
> -
>  static inline bool on_irq_stack(unsigned long sp, unsigned long size,
>                                 struct stack_info *info)
>  {
> diff --git a/arch/arm64/include/asm/stacktrace/common.h b/arch/arm64/include/asm/stacktrace/common.h
> new file mode 100644
> index 000000000000..64ae4f6b06fe
> --- /dev/null
> +++ b/arch/arm64/include/asm/stacktrace/common.h
> @@ -0,0 +1,105 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Common arm64 stack unwinder code.
> + *
> + * Copyright (C) 2012 ARM Ltd.
> + */
> +#ifndef __ASM_STACKTRACE_COMMON_H
> +#define __ASM_STACKTRACE_COMMON_H
> +
> +#include <linux/bitmap.h>
> +#include <linux/bitops.h>
> +#include <linux/types.h>
> +
> +enum stack_type {
> +       STACK_TYPE_UNKNOWN,
> +       STACK_TYPE_TASK,
> +       STACK_TYPE_IRQ,
> +       STACK_TYPE_OVERFLOW,
> +       STACK_TYPE_SDEI_NORMAL,
> +       STACK_TYPE_SDEI_CRITICAL,
> +       __NR_STACK_TYPES
> +};
> +
> +struct stack_info {
> +       unsigned long low;
> +       unsigned long high;
> +       enum stack_type type;
> +};
> +
> +/*
> + * A snapshot of a frame record or fp/lr register values, along with some
> + * accounting information necessary for robust unwinding.
> + *
> + * @fp:          The fp value in the frame record (or the real fp)
> + * @pc:          The lr value in the frame record (or the real lr)
> + *
> + * @stacks_done: Stacks which have been entirely unwound, for which it is no
> + *               longer valid to unwind to.
> + *
> + * @prev_fp:     The fp that pointed to this frame record, or a synthetic value
> + *               of 0. This is used to ensure that within a stack, each
> + *               subsequent frame record is at an increasing address.
> + * @prev_type:   The type of stack this frame record was on, or a synthetic
> + *               value of STACK_TYPE_UNKNOWN. This is used to detect a
> + *               transition from one stack to another.
> + *
> + * @kr_cur:      When KRETPROBES is selected, holds the kretprobe instance
> + *               associated with the most recently encountered replacement lr
> + *               value.
> + *
> + * @task:        The task being unwound.
> + */
> +struct unwind_state {
> +       unsigned long fp;
> +       unsigned long pc;
> +       DECLARE_BITMAP(stacks_done, __NR_STACK_TYPES);
> +       unsigned long prev_fp;
> +       enum stack_type prev_type;
> +#ifdef CONFIG_KRETPROBES
> +       struct llist_node *kr_cur;
> +#endif
> +       struct task_struct *task;
> +};
> +
> +static inline bool on_stack(unsigned long sp, unsigned long size,
> +                           unsigned long low, unsigned long high,
> +                           enum stack_type type, struct stack_info *info)
> +{
> +       if (!low)
> +               return false;
> +
> +       if (sp < low || sp + size < sp || sp + size > high)
> +               return false;
> +
> +       if (info) {
> +               info->low = low;
> +               info->high = high;
> +               info->type = type;
> +       }
> +       return true;
> +}
> +
> +static inline void unwind_init_common(struct unwind_state *state,
> +                                     struct task_struct *task)
> +{
> +       state->task = task;
> +#ifdef CONFIG_KRETPROBES
> +       state->kr_cur = NULL;
> +#endif
> +
> +       /*
> +        * Prime the first unwind.
> +        *
> +        * In unwind_next() we'll check that the FP points to a valid stack,
> +        * which can't be STACK_TYPE_UNKNOWN, and the first unwind will be
> +        * treated as a transition to whichever stack that happens to be. The
> +        * prev_fp value won't be used, but we set it to 0 such that it is
> +        * definitely not an accessible stack address.
> +        */
> +       bitmap_zero(state->stacks_done, __NR_STACK_TYPES);
> +       state->prev_fp = 0;
> +       state->prev_type = STACK_TYPE_UNKNOWN;
> +}
> +
> +#endif /* __ASM_STACKTRACE_COMMON_H */
> diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
> index fcaa151b81f1..94a5dd2ab8fd 100644
> --- a/arch/arm64/kernel/stacktrace.c
> +++ b/arch/arm64/kernel/stacktrace.c
> @@ -18,63 +18,6 @@
>  #include <asm/stack_pointer.h>
>  #include <asm/stacktrace.h>
>
> -/*
> - * A snapshot of a frame record or fp/lr register values, along with some
> - * accounting information necessary for robust unwinding.
> - *
> - * @fp:          The fp value in the frame record (or the real fp)
> - * @pc:          The lr value in the frame record (or the real lr)
> - *
> - * @stacks_done: Stacks which have been entirely unwound, for which it is no
> - *               longer valid to unwind to.
> - *
> - * @prev_fp:     The fp that pointed to this frame record, or a synthetic value
> - *               of 0. This is used to ensure that within a stack, each
> - *               subsequent frame record is at an increasing address.
> - * @prev_type:   The type of stack this frame record was on, or a synthetic
> - *               value of STACK_TYPE_UNKNOWN. This is used to detect a
> - *               transition from one stack to another.
> - *
> - * @kr_cur:      When KRETPROBES is selected, holds the kretprobe instance
> - *               associated with the most recently encountered replacement lr
> - *               value.
> - *
> - * @task:        The task being unwound.
> - */
> -struct unwind_state {
> -       unsigned long fp;
> -       unsigned long pc;
> -       DECLARE_BITMAP(stacks_done, __NR_STACK_TYPES);
> -       unsigned long prev_fp;
> -       enum stack_type prev_type;
> -#ifdef CONFIG_KRETPROBES
> -       struct llist_node *kr_cur;
> -#endif
> -       struct task_struct *task;
> -};
> -
> -static void unwind_init_common(struct unwind_state *state,
> -                              struct task_struct *task)
> -{
> -       state->task = task;
> -#ifdef CONFIG_KRETPROBES
> -       state->kr_cur = NULL;
> -#endif
> -
> -       /*
> -        * Prime the first unwind.
> -        *
> -        * In unwind_next() we'll check that the FP points to a valid stack,
> -        * which can't be STACK_TYPE_UNKNOWN, and the first unwind will be
> -        * treated as a transition to whichever stack that happens to be. The
> -        * prev_fp value won't be used, but we set it to 0 such that it is
> -        * definitely not an accessible stack address.
> -        */
> -       bitmap_zero(state->stacks_done, __NR_STACK_TYPES);
> -       state->prev_fp = 0;
> -       state->prev_type = STACK_TYPE_UNKNOWN;
> -}
> -
>  /*
>   * Start an unwind from a pt_regs.
>   *
> --
> 2.37.0.170.g444d1eabd0-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
