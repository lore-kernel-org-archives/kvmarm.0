Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E5B3C43334
	for <kvmarm@archiver.kernel.org>; Fri, 15 Jul 2022 13:59:20 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0F3D84BD62;
	Fri, 15 Jul 2022 09:59:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UwQz0ufnz98n; Fri, 15 Jul 2022 09:59:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A17394BF06;
	Fri, 15 Jul 2022 09:59:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BE9614BEAC
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jul 2022 09:59:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qLnTghvxVPsc for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Jul 2022 09:59:16 -0400 (EDT)
Received: from mail-oa1-f52.google.com (mail-oa1-f52.google.com
 [209.85.160.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9C2474BD62
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jul 2022 09:59:16 -0400 (EDT)
Received: by mail-oa1-f52.google.com with SMTP id
 586e51a60fabf-1013ecaf7e0so6252780fac.13
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jul 2022 06:59:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=wcsiyFdNFlbE2rwHs7o7QvxeNqnz8T+pUXB7pzwL5zw=;
 b=HtL3JWOJOghzPqgLPB7YqHgA2lckvHP41fn/FCQZM8i011Y+6JWlkGM9nBv8NJvuya
 I+4qWfkE6/iIRdKoOTEJQ6YpTJYPyfVT4+xw/CWNNl/vAUd1m2YgEI1q4EOP97BaRoRQ
 QyRM1pUwmCrI9FMKqk2ZD5mJFuzkR7MAD2/nQLpMwcz5yR7Y0NjqEiZADEcyN46BHxe7
 PHD+44GBS1HVr+jboVL3Egb7fMAz64mWyw92QlwNCKeIXr43kiIRWxrbrghl8NQcFCJH
 Wdsw+7VIQmesZZcJHDxuZdoBMNQ9zSIozirctEKwX6C7rhLkSHrs2ZSR1XJqxtFeuWyz
 HlqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=wcsiyFdNFlbE2rwHs7o7QvxeNqnz8T+pUXB7pzwL5zw=;
 b=IOkUvKeu8ExmMq9ViiBzBhlsOipa7pXvplfRBWWHsWU4RffRJRew2CvfVO/tqPhk60
 +YU5oDkE1bUd52Gwh4IN3diV7vRjxw6qjhtqw5R40ZW2OiY1YMrvrggbnc9X4GXqbPjr
 DoB6QF53vwJRkXYbGGH05JqwocroKjfl1+FiNWzFvHCOaFXwD6NZ/DCpSQ3hml5LMJmy
 OMLmh9yTrKaRCfpZeMdDhOiEgwk5jkT0NZx4m9ACZ76KqDokzCxeKjQ40Q4FpTeune7Y
 Jj9/078HkD8EuTHF6FDR5ZZDXxxj+ZNDBE/hmqHzH8s3uzs6kgxOUqVO0rlBOSWCywFy
 0C+Q==
X-Gm-Message-State: AJIora9183dryfAxVxXmxpWgcZEJ9ImiHr5f9EvZ3rP35nHYvGdSCAmu
 8rMqr+EVdjyCYIkQxqvhABDw68bBZIm3yz1Lue7SQw==
X-Google-Smtp-Source: AGRyM1vN9stDDiwyjYZaFj2tqJauPKZ02qkA+d7Xw+uXJrgYM9JMcfdEH00b7lz//bn2BiUohjo1Tz2Dib5qBtar/No=
X-Received: by 2002:a05:6871:890:b0:10b:f3eb:b45d with SMTP id
 r16-20020a056871089000b0010bf3ebb45dmr7916926oaq.294.1657893555927; Fri, 15
 Jul 2022 06:59:15 -0700 (PDT)
MIME-Version: 1.0
References: <20220715061027.1612149-1-kaleshsingh@google.com>
 <20220715061027.1612149-4-kaleshsingh@google.com>
In-Reply-To: <20220715061027.1612149-4-kaleshsingh@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 15 Jul 2022 14:58:40 +0100
Message-ID: <CA+EHjTyDbH=7Bqo61CEadSKRsRHKsSWQcf=kbx5T_Fsj0-bL4g@mail.gmail.com>
Subject: Re: [PATCH v4 03/18] arm64: stacktrace: Factor out
 unwind_next_common()
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
> Move common unwind_next logic to stacktrace/common.h. This allows
> reusing the code in the implementation the nVHE hypervisor stack
> unwinder, later in this series.
>
> Signed-off-by: Kalesh Singh <kaleshsingh@google.com>

Reviewed-by: Fuad Tabba <tabba@google.com>

Thanks,
/fuad


> ---
>  arch/arm64/include/asm/stacktrace/common.h | 50 ++++++++++++++++++++++
>  arch/arm64/kernel/stacktrace.c             | 41 ++----------------
>  2 files changed, 54 insertions(+), 37 deletions(-)
>
> diff --git a/arch/arm64/include/asm/stacktrace/common.h b/arch/arm64/include/asm/stacktrace/common.h
> index f58b786460d3..0c5cbfdb56b5 100644
> --- a/arch/arm64/include/asm/stacktrace/common.h
> +++ b/arch/arm64/include/asm/stacktrace/common.h
> @@ -65,6 +65,10 @@ struct unwind_state {
>  static inline bool on_overflow_stack(unsigned long sp, unsigned long size,
>                                      struct stack_info *info);
>
> +static inline bool on_accessible_stack(const struct task_struct *tsk,
> +                                      unsigned long sp, unsigned long size,
> +                                      struct stack_info *info);
> +
>  static inline bool on_stack(unsigned long sp, unsigned long size,
>                             unsigned long low, unsigned long high,
>                             enum stack_type type, struct stack_info *info)
> @@ -120,4 +124,50 @@ static inline void unwind_init_common(struct unwind_state *state,
>         state->prev_type = STACK_TYPE_UNKNOWN;
>  }
>
> +static inline int unwind_next_common(struct unwind_state *state,
> +                                    struct stack_info *info)
> +{
> +       struct task_struct *tsk = state->task;
> +       unsigned long fp = state->fp;
> +
> +       if (fp & 0x7)
> +               return -EINVAL;
> +
> +       if (!on_accessible_stack(tsk, fp, 16, info))
> +               return -EINVAL;
> +
> +       if (test_bit(info->type, state->stacks_done))
> +               return -EINVAL;
> +
> +       /*
> +        * As stacks grow downward, any valid record on the same stack must be
> +        * at a strictly higher address than the prior record.
> +        *
> +        * Stacks can nest in several valid orders, e.g.
> +        *
> +        * TASK -> IRQ -> OVERFLOW -> SDEI_NORMAL
> +        * TASK -> SDEI_NORMAL -> SDEI_CRITICAL -> OVERFLOW
> +        *
> +        * ... but the nesting itself is strict. Once we transition from one
> +        * stack to another, it's never valid to unwind back to that first
> +        * stack.
> +        */
> +       if (info->type == state->prev_type) {
> +               if (fp <= state->prev_fp)
> +                       return -EINVAL;
> +       } else {
> +               __set_bit(state->prev_type, state->stacks_done);
> +       }
> +
> +       /*
> +        * Record this frame record's values and location. The prev_fp and
> +        * prev_type are only meaningful to the next unwind_next() invocation.
> +        */
> +       state->fp = READ_ONCE(*(unsigned long *)(fp));
> +       state->pc = READ_ONCE(*(unsigned long *)(fp + 8));
> +       state->prev_fp = fp;
> +       state->prev_type = info->type;
> +
> +       return 0;
> +}
>  #endif /* __ASM_STACKTRACE_COMMON_H */
> diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
> index 94a5dd2ab8fd..834851939364 100644
> --- a/arch/arm64/kernel/stacktrace.c
> +++ b/arch/arm64/kernel/stacktrace.c
> @@ -81,48 +81,15 @@ static int notrace unwind_next(struct unwind_state *state)
>         struct task_struct *tsk = state->task;
>         unsigned long fp = state->fp;
>         struct stack_info info;
> +       int err;
>
>         /* Final frame; nothing to unwind */
>         if (fp == (unsigned long)task_pt_regs(tsk)->stackframe)
>                 return -ENOENT;
>
> -       if (fp & 0x7)
> -               return -EINVAL;
> -
> -       if (!on_accessible_stack(tsk, fp, 16, &info))
> -               return -EINVAL;
> -
> -       if (test_bit(info.type, state->stacks_done))
> -               return -EINVAL;
> -
> -       /*
> -        * As stacks grow downward, any valid record on the same stack must be
> -        * at a strictly higher address than the prior record.
> -        *
> -        * Stacks can nest in several valid orders, e.g.
> -        *
> -        * TASK -> IRQ -> OVERFLOW -> SDEI_NORMAL
> -        * TASK -> SDEI_NORMAL -> SDEI_CRITICAL -> OVERFLOW
> -        *
> -        * ... but the nesting itself is strict. Once we transition from one
> -        * stack to another, it's never valid to unwind back to that first
> -        * stack.
> -        */
> -       if (info.type == state->prev_type) {
> -               if (fp <= state->prev_fp)
> -                       return -EINVAL;
> -       } else {
> -               __set_bit(state->prev_type, state->stacks_done);
> -       }
> -
> -       /*
> -        * Record this frame record's values and location. The prev_fp and
> -        * prev_type are only meaningful to the next unwind_next() invocation.
> -        */
> -       state->fp = READ_ONCE(*(unsigned long *)(fp));
> -       state->pc = READ_ONCE(*(unsigned long *)(fp + 8));
> -       state->prev_fp = fp;
> -       state->prev_type = info.type;
> +       err = unwind_next_common(state, &info);
> +       if (err)
> +               return err;
>
>         state->pc = ptrauth_strip_insn_pac(state->pc);
>
> --
> 2.37.0.170.g444d1eabd0-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
