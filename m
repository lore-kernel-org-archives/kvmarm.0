Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AB37CCA479
	for <kvmarm@archiver.kernel.org>; Mon, 18 Jul 2022 16:51:58 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E1C924D2CE;
	Mon, 18 Jul 2022 12:51:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Qvotl2JC6P1k; Mon, 18 Jul 2022 12:51:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 27B9E4D467;
	Mon, 18 Jul 2022 12:51:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F3FA54D44F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2022 12:51:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ljKikwpodmZp for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Jul 2022 12:51:51 -0400 (EDT)
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com
 [209.85.221.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D203D4D2CE
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2022 12:51:51 -0400 (EDT)
Received: by mail-wr1-f45.google.com with SMTP id d16so17907096wrv.10
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2022 09:51:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=PAbDl1PRM5nJcEKcI6Ytvs7hiGOzTQVF+JIk15dOA88=;
 b=n5udodEAa/PhqseWRA+ZivosTL+aHxlWiMaVXsWsHZeKg72WFl+q1bjcvEIKJGsXbs
 RPtworRU8Nh1Cwv3GXk0n/mYI4XiC1YfEuJnfhNedphfctJ327KC83r8YiDGb/sBkL+E
 XmUeJXLrY9YW/3OUjWA9vNqnCvnqNxrPg15pTeOicsw3EyemCxVJP4y1v7l++F+xEAOJ
 2su/h+SGAbOfp1TCEcaP+E8bUk2BQFUxLbYPsl3W8zNRYhyNQdQkm6aF1qWD1BxKDxb4
 KvaUN4IuTL+e3uuThg2ACcxOutr+PidsEjVo0kigDgA+GaX5R1S87jJUM6Wdlx4D2tfT
 DnFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=PAbDl1PRM5nJcEKcI6Ytvs7hiGOzTQVF+JIk15dOA88=;
 b=3A85rV3Q9H6Gp7RWhSkwHBDB0MroYInljT0baV8jgSXY5X5BYfDB1wDSOeD3fffZg7
 VxVd91eIdD/LRLa9byjFZlYOVtvfeYG7IH6djgdLPjT1pCqE+sz9zgPGxzRz696WXs5F
 h9fMG2XE+GLk/TzkU/+0filVVQ3ud1DpM3VUfGpY8MJxBvWhDIfBa7dVPW8jjeU0VmoY
 vIzNbKtMnUT9wtgCtOftxea+BJ6EQDwtNDVAoxuFs7fKKPuyefyRKRVLQZONEnelFtnF
 xwBbe0lqCg9eLh8k5kYp7EhdKa5MMfUBi5NviWO68/rg5RJ/bznUAMDZLl90/c4libMy
 j5iQ==
X-Gm-Message-State: AJIora8GWdfCfQaRfBSaG0Y5ImD/qKL+7kkoJ0Pzh+mWD/vN3j/SmybN
 0j0Sd+7awZzeAoySNyOwFa7d8lruHJ+19FFvw7N9Og==
X-Google-Smtp-Source: AGRyM1uiGKWRYqdXWTkzEYeZ3M32/orW5NzHDsHKznhO1+2vVhPaYRL6sJmL5DodgqnLocvJeqHO6XvZNDEU4APTl4g=
X-Received: by 2002:a5d:6c65:0:b0:21d:b7c0:9930 with SMTP id
 r5-20020a5d6c65000000b0021db7c09930mr23007398wrz.500.1658163110612; Mon, 18
 Jul 2022 09:51:50 -0700 (PDT)
MIME-Version: 1.0
References: <20220715061027.1612149-1-kaleshsingh@google.com>
 <20220715061027.1612149-12-kaleshsingh@google.com>
 <877d4a513o.wl-maz@kernel.org>
In-Reply-To: <877d4a513o.wl-maz@kernel.org>
From: Kalesh Singh <kaleshsingh@google.com>
Date: Mon, 18 Jul 2022 09:51:39 -0700
Message-ID: <CAC_TJvewAfGACxwZ57W+fDsXOYBNnjxaKUt3Es9Ou0vDO3H_0w@mail.gmail.com>
Subject: Re: [PATCH v4 11/18] KVM: arm64: Stub implementation of non-protected
 nVHE HYP stack unwinder
To: Marc Zyngier <maz@kernel.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Alexei Starovoitov <ast@kernel.org>,
 vincenzo.frascino@arm.com, Will Deacon <will@kernel.org>,
 kvmarm <kvmarm@lists.cs.columbia.edu>,
 "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>,
 andreyknvl@gmail.com, "Cc: Android Kernel" <kernel-team@android.com>,
 Marco Elver <elver@google.com>, Mark Brown <broonie@kernel.org>,
 "moderated list:ARM64 PORT \(AARCH64 ARCHITECTURE\)"
 <linux-arm-kernel@lists.infradead.org>, russell.king@oracle.com,
 LKML <linux-kernel@vger.kernel.org>, Masami Hiramatsu <mhiramat@kernel.org>
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

On Mon, Jul 18, 2022 at 12:31 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Fri, 15 Jul 2022 07:10:20 +0100,
> Kalesh Singh <kaleshsingh@google.com> wrote:
> >
> > Add stub implementations of non-protected nVHE stack unwinder, for
> > building. These are implemented later in this series.
> >
> > Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
> > ---
> >  arch/arm64/include/asm/stacktrace/nvhe.h | 22 ++++++++++++++++++++++
> >  1 file changed, 22 insertions(+)
> >
> > diff --git a/arch/arm64/include/asm/stacktrace/nvhe.h b/arch/arm64/include/asm/stacktrace/nvhe.h
> > index 1eac4e57f2ae..36cf7858ddd8 100644
> > --- a/arch/arm64/include/asm/stacktrace/nvhe.h
> > +++ b/arch/arm64/include/asm/stacktrace/nvhe.h
> > @@ -8,6 +8,12 @@
> >   *      the HYP memory. The stack is unwinded in EL2 and dumped to a shared
> >   *      buffer where the host can read and print the stacktrace.
> >   *
> > + *   2) Non-protected nVHE mode - the host can directly access the
> > + *      HYP stack pages and unwind the HYP stack in EL1. This saves having
> > + *      to allocate shared buffers for the host to read the unwinded
> > + *      stacktrace.
> > + *
> > + *
> >   * Copyright (C) 2022 Google LLC
> >   */
> >  #ifndef __ASM_STACKTRACE_NVHE_H
> > @@ -53,5 +59,21 @@ static int notrace unwind_next(struct unwind_state *state)
> >  NOKPROBE_SYMBOL(unwind_next);
> >  #endif       /* CONFIG_PROTECTED_NVHE_STACKTRACE */
> >
> > +/*
> > + * Non-protected nVHE HYP stack unwinder
> > + */
> > +#else        /* !__KVM_NVHE_HYPERVISOR__ */
>
> I don't get this path. This either represents the VHE hypervisor or
> the kernel proper. Which one is it?

Hi Marc. This is run from kernel proper context. And it's the
unwinding for conventional nVHE (non-protected). The unwinding is done
from the host kernel in EL1.

>
> > +static inline bool on_overflow_stack(unsigned long sp, unsigned long size,
> > +                                  struct stack_info *info)
> > +{
> > +     return false;
> > +}
> > +
> > +static int notrace unwind_next(struct unwind_state *state)
> > +{
> > +     return 0;
> > +}
> > +NOKPROBE_SYMBOL(unwind_next);
> > +
> >  #endif       /* __KVM_NVHE_HYPERVISOR__ */
> >  #endif       /* __ASM_STACKTRACE_NVHE_H */
>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
>
> --
> To unsubscribe from this group and stop receiving emails from it, send an email to kernel-team+unsubscribe@android.com.
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
