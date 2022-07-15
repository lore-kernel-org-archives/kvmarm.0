Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2AEEC43334
	for <kvmarm@archiver.kernel.org>; Fri, 15 Jul 2022 13:57:24 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 55B1F4BEAD;
	Fri, 15 Jul 2022 09:57:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5laVhUG1-LTn; Fri, 15 Jul 2022 09:57:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 05D3B4BE4E;
	Fri, 15 Jul 2022 09:57:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E8BCB4BE4E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jul 2022 09:57:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cvcPqOZ1vozk for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Jul 2022 09:57:20 -0400 (EDT)
Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com
 [209.85.210.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9D26C4BE32
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jul 2022 09:57:20 -0400 (EDT)
Received: by mail-ot1-f42.google.com with SMTP id
 e1-20020a05683013c100b0061c1a6b8d11so3529458otq.8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jul 2022 06:57:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=2XHahTg74pR+fkQl0PaxFy6RUNnpsVoD/zCOueSWNd8=;
 b=p0HgT3PGyYvztwjwFj8z7NtqUsPnYsp1YPiFfmRvUtVULL4G7D1ndsRl1PS00SN5Ks
 hQjVLUaVDF8R14z7XHQlO+nxs62MkNjaW3YtFcjdM0bxfQmudN7M3ZJOn2qEQXrm7ktr
 bCE2S/3KNkMgMdasia903BH9il6g57PwJmI4afERGUCRlkj+/w8K+NQkap3trsXZ+M2l
 ehO3RXXas0BQ9JA4hyrp2pChEvjnqVx+vS7cYwIVOu+/3lGjmSR4UQettA0MhEa7qSjT
 yCou3YB5b3kbAH5OX8HYMYjQdn5yTWFxj0o2q2ycr+JvFBxs5jegRVI5V2+DSVwbFFhf
 lRjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=2XHahTg74pR+fkQl0PaxFy6RUNnpsVoD/zCOueSWNd8=;
 b=sXjwuMVGKtnAPxJE6B59g0v44O9A0LN1GWK9tNPD+6PDNJBekU4KiF7P3aCbM4Acjl
 ZlJsRPD9Gfe/TcPHEUKn3WQrcmfW6mwOnYfGsWAUmqXtFSPOxmHfDX8M96X1qKNmLZ/K
 UhWtXp5haGLCs5+lgpUcDCXgUWuC4D1rtx1EU8qFgMAv6mZ8GKb1uU0DJDOdf5gvze+z
 z3yPKcznolxZGvZKy1TzzMlY2tfLq/4LBlUrcjiTRPGzaDOk5lQXcwbyj9QZgofFQKxk
 DUcLw/xO6zlNPWFo0UeVdJDzM2QeCR0NbtIF2BqlQyKjBOFpblH4LboRHuP9omwA2YqS
 Be3w==
X-Gm-Message-State: AJIora9MT0rkM+Grjb20jb2aoXmDgsHWlzbMAB5kRE3byOZDkoNXpMS4
 jQqKLqsQRp7cxThL2MW0pE6Od5BQJpafGw8K3y8tEQ==
X-Google-Smtp-Source: AGRyM1ugZdhz9Xe3Y3Svns/5bQ2HVTfV3rH4NMXhH9+Km8OrNBqqEwuj2Jd9a5eYcmQWqrKgUATY9xPEup6CwisER5Q=
X-Received: by 2002:a9d:5f1a:0:b0:61c:50a1:df3 with SMTP id
 f26-20020a9d5f1a000000b0061c50a10df3mr5414193oti.102.1657893439804; Fri, 15
 Jul 2022 06:57:19 -0700 (PDT)
MIME-Version: 1.0
References: <20220715061027.1612149-1-kaleshsingh@google.com>
 <20220715061027.1612149-5-kaleshsingh@google.com>
In-Reply-To: <20220715061027.1612149-5-kaleshsingh@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 15 Jul 2022 14:56:44 +0100
Message-ID: <CA+EHjTzv9VFnp+6kCw0pMuUxqXtmthujg7ga=Fkexz9jEq29LA@mail.gmail.com>
Subject: Re: [PATCH v4 04/18] arm64: stacktrace: Handle frame pointer from
 different address spaces
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

On Fri, Jul 15, 2022 at 7:11 AM 'Kalesh Singh' via kernel-team
<kernel-team@android.com> wrote:
>
> The unwinder code is made reusable so that it can be used to
> unwind various types of stacks. One usecase is unwinding the
> nVHE hyp stack from the host (EL1) in non-protected mode. This
> means that the unwinder must be able to tracnslate HYP stack

s/tracnslate/translate

> addresses to kernel addresses.
>
> Add a callback (stack_trace_translate_fp_fn) to allow specifying
> the translation function.
>
> Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
> ---
>  arch/arm64/include/asm/stacktrace/common.h | 26 ++++++++++++++++++++--
>  arch/arm64/kernel/stacktrace.c             |  2 +-
>  2 files changed, 25 insertions(+), 3 deletions(-)
>
> diff --git a/arch/arm64/include/asm/stacktrace/common.h b/arch/arm64/include/asm/stacktrace/common.h
> index 0c5cbfdb56b5..5f5d74a286f3 100644
> --- a/arch/arm64/include/asm/stacktrace/common.h
> +++ b/arch/arm64/include/asm/stacktrace/common.h
> @@ -123,9 +123,22 @@ static inline void unwind_init_common(struct unwind_state *state,
>         state->prev_fp = 0;
>         state->prev_type = STACK_TYPE_UNKNOWN;
>  }
> +/**
> + * stack_trace_translate_fp_fn() - Translates a non-kernel frame pointer to
> + * a kernel address.
> + *
> + * @fp:   the frame pointer to be updated to it's kernel address.
> + * @type: the stack type associated with frame pointer @fp
> + *
> + * Returns true and success and @fp is updated to the corresponding
> + * kernel virtual address; otherwise returns false.
> + */

Please add a newline before the new block.

Also, something which you have done in comment blocks in this patch as
well as future patches (so I won't mention them again) is use the
opening comment mark /** , which is meant for kernel-doc comments
(https://www.kernel.org/doc/html/latest/doc-guide/kernel-doc.html).
However, this block, and many if not most of the others don't seem to
be conformant (scripts/kernel-doc -v -none
arch/arm64/include/asm/stacktrace/common.h).

I think the easiest thing to do is to format them as a normal block: /*.


> +typedef bool (*stack_trace_translate_fp_fn)(unsigned long *fp,
> +                                           enum stack_type type);
>
>  static inline int unwind_next_common(struct unwind_state *state,
> -                                    struct stack_info *info)
> +                                    struct stack_info *info,
> +                                    stack_trace_translate_fp_fn translate_fp)
>  {
>         struct task_struct *tsk = state->task;
>         unsigned long fp = state->fp;
> @@ -159,13 +172,22 @@ static inline int unwind_next_common(struct unwind_state *state,
>                 __set_bit(state->prev_type, state->stacks_done);
>         }
>
> +       /* Record fp as prev_fp before attempting to get the next fp */
> +       state->prev_fp = fp;
> +
> +       /*
> +        * If fp is not from the current address space perform the necessary
> +        * translation before dereferencing it to get the next fp.
> +        */
> +       if (translate_fp && !translate_fp(&fp, info->type))
> +               return -EINVAL;
> +

A call to unwind_next_common could fail having updated state->prev_fp
as well as state->stacks_done. I think that it might be better to
rework it so that there aren't any side effects should a call fail.

Thanks,
/fuad





>         /*
>          * Record this frame record's values and location. The prev_fp and
>          * prev_type are only meaningful to the next unwind_next() invocation.
>          */
>         state->fp = READ_ONCE(*(unsigned long *)(fp));
>         state->pc = READ_ONCE(*(unsigned long *)(fp + 8));
> -       state->prev_fp = fp;
>         state->prev_type = info->type;
>
>         return 0;
> diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
> index 834851939364..eef3cf6bf2d7 100644
> --- a/arch/arm64/kernel/stacktrace.c
> +++ b/arch/arm64/kernel/stacktrace.c
> @@ -87,7 +87,7 @@ static int notrace unwind_next(struct unwind_state *state)
>         if (fp == (unsigned long)task_pt_regs(tsk)->stackframe)
>                 return -ENOENT;
>
> -       err = unwind_next_common(state, &info);
> +       err = unwind_next_common(state, &info, NULL);
>         if (err)
>                 return err;
>
> --
> 2.37.0.170.g444d1eabd0-goog
>
> --
> To unsubscribe from this group and stop receiving emails from it, send an email to kernel-team+unsubscribe@android.com.
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
