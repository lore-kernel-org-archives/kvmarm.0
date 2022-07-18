Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA355C43334
	for <kvmarm@archiver.kernel.org>; Mon, 18 Jul 2022 15:26:31 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1F7084D781;
	Mon, 18 Jul 2022 11:26:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QchoYgG9Pt0p; Mon, 18 Jul 2022 11:26:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 683514D783;
	Mon, 18 Jul 2022 11:26:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 73BC04D77F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2022 11:26:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nCIQI0Ns4IW9 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Jul 2022 11:26:26 -0400 (EDT)
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com
 [209.85.221.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9DCD94D77C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2022 11:26:26 -0400 (EDT)
Received: by mail-wr1-f45.google.com with SMTP id e15so12322376wro.5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2022 08:26:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=9BBVisBKsOuFCaWJW8FqdMGsV9Mygag9vrni2gyPgdU=;
 b=CUyuRNfL6dcWl8MLZeFSVk8tNPeTGHtXtUStezWSKnMCMQCNstnVXqZYu5JxnTR7XJ
 MgEdWQe6GIYxOm9d0jUxEMbXZT4QzlhuDtqLAQnNlmOC+xKs4Xob9FYC+fBNTcHUxnsy
 HHcRYuBLWUxSZtpxe60S0/VvOUxudhJXeHOT4xNfRz4zbnJzfaaBMegZLqUlfoJ/sbDP
 1dlE6XpeeUeaBRCQsaPU1W4T0Nyu7pYANTvJe4gR6Ua3pjAm9Kxk5U+W3v4VP7m+g6em
 pKl61h4thU0W5+v4LUaPCmtWfiTGO1Hssft8jq+dHhj2k/2FhkyImBMazQ2s7EkJw5th
 rTBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=9BBVisBKsOuFCaWJW8FqdMGsV9Mygag9vrni2gyPgdU=;
 b=SfBKlgbpm5OujcnA2jQLskD9EOu4lHq1/uqAx/c8aJ3x2U656r1QWFkhrlkleTZg4S
 27jYaPfij7dz9mv6uD0De8pCdgn+gQ81svWabI3L7GypbdCDgkNUn0WLdzgOloc87wq7
 SeFScDqEHGkCEG6LwCZr3wK2PK5IWQXlFWbyG4LVA0ogaHLhiM/1M8rM72iE3qlLvncj
 WJ8WKsfjSWvlcwyL6WQwSV6Ibs6CXALkpo3KVwNeHipNrgwSJsXlSU+xHV3nB0/eG5J+
 R3W7EgGpGckgF4vejedlXL3oKT8pJk4WbEG1JnVel4OJFrnVJzCN9vVRriicrNcB02Wh
 Mp7w==
X-Gm-Message-State: AJIora8U+xsZ6CO7H+ICXK7raqbanh/IYl8CYsXGuDn3/s0BobnUsaAV
 pK3L1do1eGa/LZocKtvJ7+pboKceVrsYahkAnGNL/A==
X-Google-Smtp-Source: AGRyM1tfqA8v+n1Iv8tYAEsEUB8q11/C1gFI8FcWWbqI2+1eCRD0k/mPREZSFCgipbsHK41VXaxBHzuGqizqDY8qyP0=
X-Received: by 2002:a05:6000:1e04:b0:21d:7ec3:fe5a with SMTP id
 bj4-20020a0560001e0400b0021d7ec3fe5amr23615636wrb.116.1658157985222; Mon, 18
 Jul 2022 08:26:25 -0700 (PDT)
MIME-Version: 1.0
References: <20220715061027.1612149-1-kaleshsingh@google.com>
 <20220715061027.1612149-2-kaleshsingh@google.com>
 <YtVXokYGdlq1maQu@shell.armlinux.org.uk>
In-Reply-To: <YtVXokYGdlq1maQu@shell.armlinux.org.uk>
From: Kalesh Singh <kaleshsingh@google.com>
Date: Mon, 18 Jul 2022 08:26:14 -0700
Message-ID: <CAC_TJvfZG6CQOdSKeiNfVQhmL2TyeEuFbo9qo9yT20Qh49d3ZQ@mail.gmail.com>
Subject: Re: [PATCH v4 01/18] arm64: stacktrace: Add shared header for common
 stack unwinding code
To: "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc: wangkefeng.wang@huawei.com, catalin.marinas@arm.com, elver@google.com,
 vincenzo.frascino@arm.com, will@kernel.org, android-mm@google.com,
 maz@kernel.org, kvmarm@lists.cs.columbia.edu, madvenka@linux.microsoft.com,
 linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
 drjones@redhat.com, ast@kernel.org, broonie@kernel.org, andreyknvl@gmail.com,
 linux-kernel@vger.kernel.org, mhiramat@kernel.org
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

On Mon, Jul 18, 2022 at 5:52 AM Russell King (Oracle)
<linux@armlinux.org.uk> wrote:
>
> Hi,
>
> Can you please explain why you are targetting my @oracle.com email
> address with this patch set?
>
> This causes me problems as I use Outlook's Web interface for that
> which doesn't appear to cope with the threading, and most certainly
> is only capable of top-reply only which is against Linux kernel email
> standards.

Hi Russell,

Sorry I wasn't aware of it (I got your oracle email from
get_maintainer script). Going forward I'll use the one you responded
from instead.

Thanks,
Kalesh

>
> Thanks.
>
> On Thu, Jul 14, 2022 at 11:10:10PM -0700, Kalesh Singh wrote:
> > In order to reuse the arm64 stack unwinding logic for the nVHE
> > hypervisor stack, move the common code to a shared header
> > (arch/arm64/include/asm/stacktrace/common.h).
> >
> > The nVHE hypervisor cannot safely link against kernel code, so we
> > make use of the shared header to avoid duplicated logic later in
> > this series.
> >
> > Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
> > ---
> >  arch/arm64/include/asm/stacktrace.h        |  35 +------
> >  arch/arm64/include/asm/stacktrace/common.h | 105 +++++++++++++++++++++
> >  arch/arm64/kernel/stacktrace.c             |  57 -----------
> >  3 files changed, 106 insertions(+), 91 deletions(-)
> >  create mode 100644 arch/arm64/include/asm/stacktrace/common.h
> >
> > diff --git a/arch/arm64/include/asm/stacktrace.h b/arch/arm64/include/asm/stacktrace.h
> > index aec9315bf156..79f455b37c84 100644
> > --- a/arch/arm64/include/asm/stacktrace.h
> > +++ b/arch/arm64/include/asm/stacktrace.h
> > @@ -8,52 +8,19 @@
> >  #include <linux/percpu.h>
> >  #include <linux/sched.h>
> >  #include <linux/sched/task_stack.h>
> > -#include <linux/types.h>
> >  #include <linux/llist.h>
> >
> >  #include <asm/memory.h>
> >  #include <asm/ptrace.h>
> >  #include <asm/sdei.h>
> >
> > -enum stack_type {
> > -     STACK_TYPE_UNKNOWN,
> > -     STACK_TYPE_TASK,
> > -     STACK_TYPE_IRQ,
> > -     STACK_TYPE_OVERFLOW,
> > -     STACK_TYPE_SDEI_NORMAL,
> > -     STACK_TYPE_SDEI_CRITICAL,
> > -     __NR_STACK_TYPES
> > -};
> > -
> > -struct stack_info {
> > -     unsigned long low;
> > -     unsigned long high;
> > -     enum stack_type type;
> > -};
> > +#include <asm/stacktrace/common.h>
> >
> >  extern void dump_backtrace(struct pt_regs *regs, struct task_struct *tsk,
> >                          const char *loglvl);
> >
> >  DECLARE_PER_CPU(unsigned long *, irq_stack_ptr);
> >
> > -static inline bool on_stack(unsigned long sp, unsigned long size,
> > -                         unsigned long low, unsigned long high,
> > -                         enum stack_type type, struct stack_info *info)
> > -{
> > -     if (!low)
> > -             return false;
> > -
> > -     if (sp < low || sp + size < sp || sp + size > high)
> > -             return false;
> > -
> > -     if (info) {
> > -             info->low = low;
> > -             info->high = high;
> > -             info->type = type;
> > -     }
> > -     return true;
> > -}
> > -
> >  static inline bool on_irq_stack(unsigned long sp, unsigned long size,
> >                               struct stack_info *info)
> >  {
> > diff --git a/arch/arm64/include/asm/stacktrace/common.h b/arch/arm64/include/asm/stacktrace/common.h
> > new file mode 100644
> > index 000000000000..64ae4f6b06fe
> > --- /dev/null
> > +++ b/arch/arm64/include/asm/stacktrace/common.h
> > @@ -0,0 +1,105 @@
> > +/* SPDX-License-Identifier: GPL-2.0-only */
> > +/*
> > + * Common arm64 stack unwinder code.
> > + *
> > + * Copyright (C) 2012 ARM Ltd.
> > + */
> > +#ifndef __ASM_STACKTRACE_COMMON_H
> > +#define __ASM_STACKTRACE_COMMON_H
> > +
> > +#include <linux/bitmap.h>
> > +#include <linux/bitops.h>
> > +#include <linux/types.h>
> > +
> > +enum stack_type {
> > +     STACK_TYPE_UNKNOWN,
> > +     STACK_TYPE_TASK,
> > +     STACK_TYPE_IRQ,
> > +     STACK_TYPE_OVERFLOW,
> > +     STACK_TYPE_SDEI_NORMAL,
> > +     STACK_TYPE_SDEI_CRITICAL,
> > +     __NR_STACK_TYPES
> > +};
> > +
> > +struct stack_info {
> > +     unsigned long low;
> > +     unsigned long high;
> > +     enum stack_type type;
> > +};
> > +
> > +/*
> > + * A snapshot of a frame record or fp/lr register values, along with some
> > + * accounting information necessary for robust unwinding.
> > + *
> > + * @fp:          The fp value in the frame record (or the real fp)
> > + * @pc:          The lr value in the frame record (or the real lr)
> > + *
> > + * @stacks_done: Stacks which have been entirely unwound, for which it is no
> > + *               longer valid to unwind to.
> > + *
> > + * @prev_fp:     The fp that pointed to this frame record, or a synthetic value
> > + *               of 0. This is used to ensure that within a stack, each
> > + *               subsequent frame record is at an increasing address.
> > + * @prev_type:   The type of stack this frame record was on, or a synthetic
> > + *               value of STACK_TYPE_UNKNOWN. This is used to detect a
> > + *               transition from one stack to another.
> > + *
> > + * @kr_cur:      When KRETPROBES is selected, holds the kretprobe instance
> > + *               associated with the most recently encountered replacement lr
> > + *               value.
> > + *
> > + * @task:        The task being unwound.
> > + */
> > +struct unwind_state {
> > +     unsigned long fp;
> > +     unsigned long pc;
> > +     DECLARE_BITMAP(stacks_done, __NR_STACK_TYPES);
> > +     unsigned long prev_fp;
> > +     enum stack_type prev_type;
> > +#ifdef CONFIG_KRETPROBES
> > +     struct llist_node *kr_cur;
> > +#endif
> > +     struct task_struct *task;
> > +};
> > +
> > +static inline bool on_stack(unsigned long sp, unsigned long size,
> > +                         unsigned long low, unsigned long high,
> > +                         enum stack_type type, struct stack_info *info)
> > +{
> > +     if (!low)
> > +             return false;
> > +
> > +     if (sp < low || sp + size < sp || sp + size > high)
> > +             return false;
> > +
> > +     if (info) {
> > +             info->low = low;
> > +             info->high = high;
> > +             info->type = type;
> > +     }
> > +     return true;
> > +}
> > +
> > +static inline void unwind_init_common(struct unwind_state *state,
> > +                                   struct task_struct *task)
> > +{
> > +     state->task = task;
> > +#ifdef CONFIG_KRETPROBES
> > +     state->kr_cur = NULL;
> > +#endif
> > +
> > +     /*
> > +      * Prime the first unwind.
> > +      *
> > +      * In unwind_next() we'll check that the FP points to a valid stack,
> > +      * which can't be STACK_TYPE_UNKNOWN, and the first unwind will be
> > +      * treated as a transition to whichever stack that happens to be. The
> > +      * prev_fp value won't be used, but we set it to 0 such that it is
> > +      * definitely not an accessible stack address.
> > +      */
> > +     bitmap_zero(state->stacks_done, __NR_STACK_TYPES);
> > +     state->prev_fp = 0;
> > +     state->prev_type = STACK_TYPE_UNKNOWN;
> > +}
> > +
> > +#endif       /* __ASM_STACKTRACE_COMMON_H */
> > diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
> > index fcaa151b81f1..94a5dd2ab8fd 100644
> > --- a/arch/arm64/kernel/stacktrace.c
> > +++ b/arch/arm64/kernel/stacktrace.c
> > @@ -18,63 +18,6 @@
> >  #include <asm/stack_pointer.h>
> >  #include <asm/stacktrace.h>
> >
> > -/*
> > - * A snapshot of a frame record or fp/lr register values, along with some
> > - * accounting information necessary for robust unwinding.
> > - *
> > - * @fp:          The fp value in the frame record (or the real fp)
> > - * @pc:          The lr value in the frame record (or the real lr)
> > - *
> > - * @stacks_done: Stacks which have been entirely unwound, for which it is no
> > - *               longer valid to unwind to.
> > - *
> > - * @prev_fp:     The fp that pointed to this frame record, or a synthetic value
> > - *               of 0. This is used to ensure that within a stack, each
> > - *               subsequent frame record is at an increasing address.
> > - * @prev_type:   The type of stack this frame record was on, or a synthetic
> > - *               value of STACK_TYPE_UNKNOWN. This is used to detect a
> > - *               transition from one stack to another.
> > - *
> > - * @kr_cur:      When KRETPROBES is selected, holds the kretprobe instance
> > - *               associated with the most recently encountered replacement lr
> > - *               value.
> > - *
> > - * @task:        The task being unwound.
> > - */
> > -struct unwind_state {
> > -     unsigned long fp;
> > -     unsigned long pc;
> > -     DECLARE_BITMAP(stacks_done, __NR_STACK_TYPES);
> > -     unsigned long prev_fp;
> > -     enum stack_type prev_type;
> > -#ifdef CONFIG_KRETPROBES
> > -     struct llist_node *kr_cur;
> > -#endif
> > -     struct task_struct *task;
> > -};
> > -
> > -static void unwind_init_common(struct unwind_state *state,
> > -                            struct task_struct *task)
> > -{
> > -     state->task = task;
> > -#ifdef CONFIG_KRETPROBES
> > -     state->kr_cur = NULL;
> > -#endif
> > -
> > -     /*
> > -      * Prime the first unwind.
> > -      *
> > -      * In unwind_next() we'll check that the FP points to a valid stack,
> > -      * which can't be STACK_TYPE_UNKNOWN, and the first unwind will be
> > -      * treated as a transition to whichever stack that happens to be. The
> > -      * prev_fp value won't be used, but we set it to 0 such that it is
> > -      * definitely not an accessible stack address.
> > -      */
> > -     bitmap_zero(state->stacks_done, __NR_STACK_TYPES);
> > -     state->prev_fp = 0;
> > -     state->prev_type = STACK_TYPE_UNKNOWN;
> > -}
> > -
> >  /*
> >   * Start an unwind from a pt_regs.
> >   *
> > --
> > 2.37.0.170.g444d1eabd0-goog
> >
> >
> > _______________________________________________
> > linux-arm-kernel mailing list
> > linux-arm-kernel@lists.infradead.org
> > http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> >
>
> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
