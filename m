Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E106C433EF
	for <kvmarm@archiver.kernel.org>; Fri, 15 Jul 2022 13:59:27 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 52EFF4BEAD;
	Fri, 15 Jul 2022 09:59:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5IcrQhCpSYhQ; Fri, 15 Jul 2022 09:59:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DA75A4BF0B;
	Fri, 15 Jul 2022 09:59:25 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6393E4BEF6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jul 2022 09:59:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lM3Xys19EEJT for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Jul 2022 09:59:23 -0400 (EDT)
Received: from mail-oo1-f49.google.com (mail-oo1-f49.google.com
 [209.85.161.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E1DC24BEFB
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jul 2022 09:59:22 -0400 (EDT)
Received: by mail-oo1-f49.google.com with SMTP id
 t11-20020a4ad0ab000000b004356ab59d3bso902493oor.7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jul 2022 06:59:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=AmN5vZN/krTVYfsavcGk8WwebH0j/DqeS7sGA8C1Ozs=;
 b=KRNVWAsXguRj1fOUfoVYotTEnW7ouSLcXdVbczsjaR7SdtZpWUUK8uGIq4eAzx4BpX
 OD7Zb7h3vjCYGQX5qT5k7UIOrZt0iCPz5czdj1gcWHg/cgoZJnnMnK+avBfLm+UI2DdW
 crPEMsGcBMjTvIlJ5fELIpxnyjBvKkmrQrfVzJNG7BXxniTEwV2aMEmWOOXLE69f6Ch0
 MIewZFs4rihwSYY23mMiwAbaq5Kr21BN/MArPhRwppH0pomPdG7yc0EtU73t7Aq+3O8F
 RNNWlhw7bp2fLgsKDtjSB3cAJtvgIFi9ng4v1Jc9l4t+T3XoG31kDnPV3tRzOhjpGBVA
 KWCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=AmN5vZN/krTVYfsavcGk8WwebH0j/DqeS7sGA8C1Ozs=;
 b=Rxg60RPdFDLuwaSovD6kW/US/YmKQ81RxIWUZ7sCqarj6rX0N2AY+0gdXPeDmYv8LN
 plqfgcC8Y2O+PKXtetrFQPvWdXpCL6cU5BUGsJv+C/sxrGwItW3/D5L27latTDcE4iDz
 w7SXhTrovZjjC2MrVgBSkrBuWCAe0/2ELnXaAmWqc72VqL5IzAMKnLSqXp1ecttId4Nj
 UnF48dN4yDJn65e79IwBewEA2+p7jSYjPhIzDSrYvWXfaiDJEMa/5tT3PfUFMmEvvrrY
 YZHR0s/ctNXCIVVYf0UpFzdKEohJFN7gfvucYnIMKl20fQO478r+D5N/o3P1TeB54Dkk
 TPJQ==
X-Gm-Message-State: AJIora/I1miWAkPhyZBP7nCsPWTiZtLinen6gXvRchdv8+D1dw8T/Gz5
 k9J4v6VrHqCrqlce5jAlsUbJeoiJk9Ha6Etax8jB2Q==
X-Google-Smtp-Source: AGRyM1vUK933GDT5UP0WVhsSmUyvv+YpR9uC9PhV9r55540k2trF66OdFzqqgFRYrbh42arxCWxPrs4MUmMbdQzWVBk=
X-Received: by 2002:a4a:d4ce:0:b0:435:71d5:9bf7 with SMTP id
 r14-20020a4ad4ce000000b0043571d59bf7mr3019637oos.0.1657893562126; Fri, 15 Jul
 2022 06:59:22 -0700 (PDT)
MIME-Version: 1.0
References: <20220715061027.1612149-1-kaleshsingh@google.com>
 <20220715061027.1612149-6-kaleshsingh@google.com>
In-Reply-To: <20220715061027.1612149-6-kaleshsingh@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 15 Jul 2022 14:58:46 +0100
Message-ID: <CA+EHjTwfe761uWSYLf__mcDYaGCSQOvheQy8iwWkSjJ1z=OcFA@mail.gmail.com>
Subject: Re: [PATCH v4 05/18] arm64: stacktrace: Factor out common unwind()
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
> Move unwind() to stacktrace/common.h, and as a result
> the kernel unwind_next() to asm/stacktrace.h. This allow
> reusing unwind() in the implementation of the nVHE HYP
> stack unwinder, later in the series.
>
> Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
> ---

Reviewed-by: Fuad Tabba <tabba@google.com>

Thanks,
/fuad


>  arch/arm64/include/asm/stacktrace.h        | 51 ++++++++++++++++
>  arch/arm64/include/asm/stacktrace/common.h | 19 ++++++
>  arch/arm64/kernel/stacktrace.c             | 67 ----------------------
>  3 files changed, 70 insertions(+), 67 deletions(-)
>
> diff --git a/arch/arm64/include/asm/stacktrace.h b/arch/arm64/include/asm/stacktrace.h
> index a4f8b84fb459..4fa07f0f913d 100644
> --- a/arch/arm64/include/asm/stacktrace.h
> +++ b/arch/arm64/include/asm/stacktrace.h
> @@ -11,6 +11,7 @@
>  #include <linux/llist.h>
>
>  #include <asm/memory.h>
> +#include <asm/pointer_auth.h>
>  #include <asm/ptrace.h>
>  #include <asm/sdei.h>
>
> @@ -78,4 +79,54 @@ static inline bool on_accessible_stack(const struct task_struct *tsk,
>
>         return false;
>  }
> +
> +/*
> + * Unwind from one frame record (A) to the next frame record (B).
> + *
> + * We terminate early if the location of B indicates a malformed chain of frame
> + * records (e.g. a cycle), determined based on the location and fp value of A
> + * and the location (but not the fp value) of B.
> + */
> +static inline int notrace unwind_next(struct unwind_state *state)
> +{
> +       struct task_struct *tsk = state->task;
> +       unsigned long fp = state->fp;
> +       struct stack_info info;
> +       int err;
> +
> +       /* Final frame; nothing to unwind */
> +       if (fp == (unsigned long)task_pt_regs(tsk)->stackframe)
> +               return -ENOENT;
> +
> +       err = unwind_next_common(state, &info, NULL);
> +       if (err)
> +               return err;
> +
> +       state->pc = ptrauth_strip_insn_pac(state->pc);
> +
> +#ifdef CONFIG_FUNCTION_GRAPH_TRACER
> +       if (tsk->ret_stack &&
> +               (state->pc == (unsigned long)return_to_handler)) {
> +               unsigned long orig_pc;
> +               /*
> +                * This is a case where function graph tracer has
> +                * modified a return address (LR) in a stack frame
> +                * to hook a function return.
> +                * So replace it to an original value.
> +                */
> +               orig_pc = ftrace_graph_ret_addr(tsk, NULL, state->pc,
> +                                               (void *)state->fp);
> +               if (WARN_ON_ONCE(state->pc == orig_pc))
> +                       return -EINVAL;
> +               state->pc = orig_pc;
> +       }
> +#endif /* CONFIG_FUNCTION_GRAPH_TRACER */
> +#ifdef CONFIG_KRETPROBES
> +       if (is_kretprobe_trampoline(state->pc))
> +               state->pc = kretprobe_find_ret_addr(tsk, (void *)state->fp, &state->kr_cur);
> +#endif
> +
> +       return 0;
> +}
> +NOKPROBE_SYMBOL(unwind_next);
>  #endif /* __ASM_STACKTRACE_H */
> diff --git a/arch/arm64/include/asm/stacktrace/common.h b/arch/arm64/include/asm/stacktrace/common.h
> index 5f5d74a286f3..f86efe71479d 100644
> --- a/arch/arm64/include/asm/stacktrace/common.h
> +++ b/arch/arm64/include/asm/stacktrace/common.h
> @@ -9,6 +9,7 @@
>
>  #include <linux/bitmap.h>
>  #include <linux/bitops.h>
> +#include <linux/kprobes.h>
>  #include <linux/types.h>
>
>  enum stack_type {
> @@ -69,6 +70,8 @@ static inline bool on_accessible_stack(const struct task_struct *tsk,
>                                        unsigned long sp, unsigned long size,
>                                        struct stack_info *info);
>
> +static inline int unwind_next(struct unwind_state *state);
> +
>  static inline bool on_stack(unsigned long sp, unsigned long size,
>                             unsigned long low, unsigned long high,
>                             enum stack_type type, struct stack_info *info)
> @@ -192,4 +195,20 @@ static inline int unwind_next_common(struct unwind_state *state,
>
>         return 0;
>  }
> +
> +static inline void notrace unwind(struct unwind_state *state,
> +                                 stack_trace_consume_fn consume_entry,
> +                                 void *cookie)
> +{
> +       while (1) {
> +               int ret;
> +
> +               if (!consume_entry(cookie, state->pc))
> +                       break;
> +               ret = unwind_next(state);
> +               if (ret < 0)
> +                       break;
> +       }
> +}
> +NOKPROBE_SYMBOL(unwind);
>  #endif /* __ASM_STACKTRACE_COMMON_H */
> diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
> index eef3cf6bf2d7..9fa60ee48499 100644
> --- a/arch/arm64/kernel/stacktrace.c
> +++ b/arch/arm64/kernel/stacktrace.c
> @@ -7,14 +7,12 @@
>  #include <linux/kernel.h>
>  #include <linux/export.h>
>  #include <linux/ftrace.h>
> -#include <linux/kprobes.h>
>  #include <linux/sched.h>
>  #include <linux/sched/debug.h>
>  #include <linux/sched/task_stack.h>
>  #include <linux/stacktrace.h>
>
>  #include <asm/irq.h>
> -#include <asm/pointer_auth.h>
>  #include <asm/stack_pointer.h>
>  #include <asm/stacktrace.h>
>
> @@ -69,71 +67,6 @@ static inline void unwind_init_from_task(struct unwind_state *state,
>         state->pc = thread_saved_pc(task);
>  }
>
> -/*
> - * Unwind from one frame record (A) to the next frame record (B).
> - *
> - * We terminate early if the location of B indicates a malformed chain of frame
> - * records (e.g. a cycle), determined based on the location and fp value of A
> - * and the location (but not the fp value) of B.
> - */
> -static int notrace unwind_next(struct unwind_state *state)
> -{
> -       struct task_struct *tsk = state->task;
> -       unsigned long fp = state->fp;
> -       struct stack_info info;
> -       int err;
> -
> -       /* Final frame; nothing to unwind */
> -       if (fp == (unsigned long)task_pt_regs(tsk)->stackframe)
> -               return -ENOENT;
> -
> -       err = unwind_next_common(state, &info, NULL);
> -       if (err)
> -               return err;
> -
> -       state->pc = ptrauth_strip_insn_pac(state->pc);
> -
> -#ifdef CONFIG_FUNCTION_GRAPH_TRACER
> -       if (tsk->ret_stack &&
> -               (state->pc == (unsigned long)return_to_handler)) {
> -               unsigned long orig_pc;
> -               /*
> -                * This is a case where function graph tracer has
> -                * modified a return address (LR) in a stack frame
> -                * to hook a function return.
> -                * So replace it to an original value.
> -                */
> -               orig_pc = ftrace_graph_ret_addr(tsk, NULL, state->pc,
> -                                               (void *)state->fp);
> -               if (WARN_ON_ONCE(state->pc == orig_pc))
> -                       return -EINVAL;
> -               state->pc = orig_pc;
> -       }
> -#endif /* CONFIG_FUNCTION_GRAPH_TRACER */
> -#ifdef CONFIG_KRETPROBES
> -       if (is_kretprobe_trampoline(state->pc))
> -               state->pc = kretprobe_find_ret_addr(tsk, (void *)state->fp, &state->kr_cur);
> -#endif
> -
> -       return 0;
> -}
> -NOKPROBE_SYMBOL(unwind_next);
> -
> -static void notrace unwind(struct unwind_state *state,
> -                          stack_trace_consume_fn consume_entry, void *cookie)
> -{
> -       while (1) {
> -               int ret;
> -
> -               if (!consume_entry(cookie, state->pc))
> -                       break;
> -               ret = unwind_next(state);
> -               if (ret < 0)
> -                       break;
> -       }
> -}
> -NOKPROBE_SYMBOL(unwind);
> -
>  static bool dump_backtrace_entry(void *arg, unsigned long where)
>  {
>         char *loglvl = arg;
> --
> 2.37.0.170.g444d1eabd0-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
