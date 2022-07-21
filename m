Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12445C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 21 Jul 2022 09:58:06 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6EB1A4C8FF;
	Thu, 21 Jul 2022 05:58:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id D+QS+MIcRW1j; Thu, 21 Jul 2022 05:58:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C5564C8FD;
	Thu, 21 Jul 2022 05:58:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6577B4C8FA
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2022 05:58:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Qm8xeZ9e74R3 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 21 Jul 2022 05:58:03 -0400 (EDT)
Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com
 [209.85.167.173])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2DA3E4C8F7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2022 05:58:03 -0400 (EDT)
Received: by mail-oi1-f173.google.com with SMTP id r13so946532oie.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2022 02:58:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=922HOs43jADDLlZ+kbLPGVukcElYdtVFtonl3ox1eBk=;
 b=CRL29VsWnaW7UfajvqFr8IUaq+Usy/I1MAzJ/6NSQCCfBdUG2uFpznfU4nF+E5EEL7
 0n520y581CNOOiYMuyTryzcs8aNGl0N8qUVBSqTX3gWU6DA6fixQNkR5SXXRlis03G0I
 t3BQVRclAbElk+f15/597Mp5etOAUMt3zi5Y3+Sy27JzsQfvQKKkZG9QSisOa4HzmWPA
 3UvKdUarhKYnIKRPe/udYK8yFJQPAN4qw8c6cCi1oL4nZRSmicSS8NCqIzdDTxQj/a9t
 CX/uvKWVATWLteU+1WjVk9hie4z0zZfi+vc2UK8oLN4SoBGQPnPgDc0ar5Yd5fW3JN5k
 tPEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=922HOs43jADDLlZ+kbLPGVukcElYdtVFtonl3ox1eBk=;
 b=VsPeihQfP05SrASOAQReCaY/v6WTGvorjf8MHZTKAwceofZP9ZQL2/T798OzYJOUoe
 sMqKPSD0FO0UH0PEskMC5c3HOT/r6emyTqijP4X29EWkoqKTa33NQ4g/Go9wxhLLp1LG
 VfjYxlGIwn1mfQzuccTevR5p/X6XcK/eoMbBJTpNLGXMNYzAaH2U3H9Ap+G4HKyv7VaU
 fimeitX0iHpLZ59ROzW4437rMa99TF5AhErZT70UnB9xKWC3Hi8CXa5PRyPghqJtnjW7
 tFW5E+whkxdtq1p23Fua1TibHl/VbYcEqT8Mp3C3ixughlaMQ7P5ud3xWhusDkSFXQJi
 Ph8Q==
X-Gm-Message-State: AJIora/hMIgqoeXxOOCVKInDWGcENwmw+zAcQ5KKG4FTLS2q0QGyNRBq
 GpgLNBxtmcAfIympvAc1En3sI010Czt1GyTcozCWVw==
X-Google-Smtp-Source: AGRyM1tFc8U7bBM5qNf2MkAsegfPZllChk75m7DCjf49ukC0noL9viy/ruQiv6reR8B24k4toofoCb2IVxgRJkTEZ/k=
X-Received: by 2002:a05:6808:1596:b0:337:8c17:b17f with SMTP id
 t22-20020a056808159600b003378c17b17fmr4487728oiw.294.1658397482410; Thu, 21
 Jul 2022 02:58:02 -0700 (PDT)
MIME-Version: 1.0
References: <20220721055728.718573-1-kaleshsingh@google.com>
 <20220721055728.718573-5-kaleshsingh@google.com>
In-Reply-To: <20220721055728.718573-5-kaleshsingh@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 21 Jul 2022 10:57:26 +0100
Message-ID: <CA+EHjTxJbG754ghqD9WkY0hyk54Ti_eG4irmVbCzKy50DBLvjA@mail.gmail.com>
Subject: Re: [PATCH v5 04/17] arm64: stacktrace: Handle frame pointer from
 different address spaces
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


On Thu, Jul 21, 2022 at 6:57 AM Kalesh Singh <kaleshsingh@google.com> wrote:
>
> The unwinder code is made reusable so that it can be used to
> unwind various types of stacks. One usecase is unwinding the
> nVHE hyp stack from the host (EL1) in non-protected mode. This
> means that the unwinder must be able to translate HYP stack
> addresses to kernel addresses.
>
> Add a callback (stack_trace_translate_fp_fn) to allow specifying
> the translation function.
>
> Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
> ---
> Changes in v5:
>   - Fix typo in commit text, per Fuad
>   - Update unwind_next_common() to not have side effects on failure, per Fuad
>   - Use regular comment instead of doc comments, per Fuad
>
>  arch/arm64/include/asm/stacktrace/common.h | 29 +++++++++++++++++++---
>  arch/arm64/kernel/stacktrace.c             |  2 +-
>  2 files changed, 26 insertions(+), 5 deletions(-)
>
> diff --git a/arch/arm64/include/asm/stacktrace/common.h b/arch/arm64/include/asm/stacktrace/common.h
> index 0c5cbfdb56b5..e89c8c39858d 100644
> --- a/arch/arm64/include/asm/stacktrace/common.h
> +++ b/arch/arm64/include/asm/stacktrace/common.h
> @@ -124,11 +124,25 @@ static inline void unwind_init_common(struct unwind_state *state,
>         state->prev_type = STACK_TYPE_UNKNOWN;
>  }
>
> +/*
> + * stack_trace_translate_fp_fn() - Translates a non-kernel frame pointer to
> + * a kernel address.
> + *
> + * @fp:   the frame pointer to be updated to it's kernel address.

nit: it's -> its

Otherwise

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad





> + * @type: the stack type associated with frame pointer @fp
> + *
> + * Returns true and success and @fp is updated to the corresponding
> + * kernel virtual address; otherwise returns false.
> + */
> +typedef bool (*stack_trace_translate_fp_fn)(unsigned long *fp,
> +                                           enum stack_type type);
> +
>  static inline int unwind_next_common(struct unwind_state *state,
> -                                    struct stack_info *info)
> +                                    struct stack_info *info,
> +                                    stack_trace_translate_fp_fn translate_fp)
>  {
> +       unsigned long fp = state->fp, kern_fp = fp;
>         struct task_struct *tsk = state->task;
> -       unsigned long fp = state->fp;
>
>         if (fp & 0x7)
>                 return -EINVAL;
> @@ -139,6 +153,13 @@ static inline int unwind_next_common(struct unwind_state *state,
>         if (test_bit(info->type, state->stacks_done))
>                 return -EINVAL;
>
> +       /*
> +        * If fp is not from the current address space perform the necessary
> +        * translation before dereferencing it to get the next fp.
> +        */
> +       if (translate_fp && !translate_fp(&kern_fp, info->type))
> +               return -EINVAL;
> +
>         /*
>          * As stacks grow downward, any valid record on the same stack must be
>          * at a strictly higher address than the prior record.
> @@ -163,8 +184,8 @@ static inline int unwind_next_common(struct unwind_state *state,
>          * Record this frame record's values and location. The prev_fp and
>          * prev_type are only meaningful to the next unwind_next() invocation.
>          */
> -       state->fp = READ_ONCE(*(unsigned long *)(fp));
> -       state->pc = READ_ONCE(*(unsigned long *)(fp + 8));
> +       state->fp = READ_ONCE(*(unsigned long *)(kern_fp));
> +       state->pc = READ_ONCE(*(unsigned long *)(kern_fp + 8));
>         state->prev_fp = fp;
>         state->prev_type = info->type;
>
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
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
