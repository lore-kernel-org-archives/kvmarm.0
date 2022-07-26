Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85257C00140
	for <kvmarm@archiver.kernel.org>; Tue, 26 Jul 2022 16:34:14 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 130724C7AE;
	Tue, 26 Jul 2022 12:34:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ruZRHU4hHsYR; Tue, 26 Jul 2022 12:34:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C9B304C6B1;
	Tue, 26 Jul 2022 12:34:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1D18E4C685
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jul 2022 12:34:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2nLSuZ5-3rmh for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Jul 2022 12:34:10 -0400 (EDT)
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com
 [209.85.128.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 927D24C64B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jul 2022 12:34:10 -0400 (EDT)
Received: by mail-wm1-f45.google.com with SMTP id v5so9084481wmj.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jul 2022 09:34:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=zNuHcN01lk0zD77Guzu6nAd1WQIrupT+rckkvnxcSjk=;
 b=cNY2dYLaXmzLvhUIi81qOUbXAxvu5GpvbtfvNiPIYJd9whNae8VPqYDF4zN5I93JlG
 UQdxo8KfIx1BXAkwY4pnm3g0NAA7Jv5241bYaKvSIcnnTTH42kSciIR8aytPE4ZDYdCx
 rAV2eFlgz2zLue0UToN+POdT/c42RzEOu1tyRX4YCANdaOu7Dg24CpDHOhm26ds0bZnC
 H23EaNc2w5EujYUlkAQX/Jb3whyHtUT0Z149O6NrOW6T6yL7b8SIBW/+0NyQq5aI9yL/
 buwJK1r926ak/oaIMYheIwl1NHusT3v3LPjLcwbNO44O3LCwnQijflohrAKrKrVg3cNO
 e3ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=zNuHcN01lk0zD77Guzu6nAd1WQIrupT+rckkvnxcSjk=;
 b=skez4aUrCJgGEHj3T+L08J63ONHAcBD6IeS1syBfbNxb69SqAVk7x1TnMdRYlbZGd8
 b75fCCbTZb08P4tLfKnQl1DcaezJIaeCaNTYqd51v9GuhC0YfA5dJuF/l0T1XxxqG4Ai
 4JMfp7EqsaLoGIRITnfGz44N9LT9amwwD7tu0B2Y0h8LXOH7v+OLF+/ir6POizWtqro2
 0Pn5XK7KA6CKwhkp5KCSuZAX29wiPsUAxpY4BPy8z/nnIDvFt2uXXgIfnyyv/WOwCm4k
 py6xIrCMFemvNWj8JEWqgzi1pe0x5RTjg1vwZjbMqaWAX0bbW1J0pmvUI2D1p8xeSV47
 Eb6w==
X-Gm-Message-State: AJIora9TK2MJO7s4IpzindOavTYVUrYTd4HYGoWzzElimwriVeAj6S8q
 CiA/q4xlx8laws9CgTcRk5CryuBnj76lNfCorzh1qg==
X-Google-Smtp-Source: AGRyM1sIcVwhPJOd+33POtj3o7l5afK54GdWG7FskWi6ARFNvOwNJkHL7C83CoFNPy9lzsn5GTWu5FlWHFJ0ZWfLwZs=
X-Received: by 2002:a1c:7213:0:b0:3a3:155a:dd5d with SMTP id
 n19-20020a1c7213000000b003a3155add5dmr26489wmc.178.1658853249048; Tue, 26 Jul
 2022 09:34:09 -0700 (PDT)
MIME-Version: 1.0
References: <20220726073750.3219117-1-kaleshsingh@google.com>
 <20220726073750.3219117-3-kaleshsingh@google.com>
 <878rofyibe.wl-maz@kernel.org>
In-Reply-To: <878rofyibe.wl-maz@kernel.org>
From: Kalesh Singh <kaleshsingh@google.com>
Date: Tue, 26 Jul 2022 09:33:57 -0700
Message-ID: <CAC_TJvehHBr9Qa5akpgLB6GGNzRKPdx855a89Aq8HWnvuGN0rg@mail.gmail.com>
Subject: Re: [PATCH v6 02/17] arm64: stacktrace: Factor out
 on_accessible_stack_common()
To: Marc Zyngier <maz@kernel.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Alexei Starovoitov <ast@kernel.org>,
 vincenzo.frascino@arm.com, Will Deacon <will@kernel.org>,
 android-mm@google.com, kvmarm <kvmarm@lists.cs.columbia.edu>,
 "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>,
 "Cc: Android Kernel" <kernel-team@android.com>, Marco Elver <elver@google.com>,
 Mark Brown <broonie@kernel.org>,
 "moderated list:ARM64 PORT \(AARCH64 ARCHITECTURE\)"
 <linux-arm-kernel@lists.infradead.org>, andreyknvl@gmail.com,
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

On Tue, Jul 26, 2022 at 9:01 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Tue, 26 Jul 2022 08:37:35 +0100,
> Kalesh Singh <kaleshsingh@google.com> wrote:
> >
> > Move common on_accessible_stack checks to stacktrace/common.h. This is
> > used in the implementation of the nVHE hypervisor unwinder later in
> > this series.
> >
> > Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
> > Reviewed-by: Fuad Tabba <tabba@google.com>
> > Reviewed-by: Mark Brown <broonie@kernel.org>
> > Tested-by: Fuad Tabba <tabba@google.com>
> > ---
> >
> > Changes in v6:
> >   - Add Fuad's Tested-by tag
> >
> > Changes in v5:
> >   - Add Reviewed-by tags from Mark Brown and Fuad
> >   - Remove random whitespace change, per Mark Brown
> >
> >  arch/arm64/include/asm/stacktrace.h        |  6 ++----
> >  arch/arm64/include/asm/stacktrace/common.h | 18 ++++++++++++++++++
> >  2 files changed, 20 insertions(+), 4 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/stacktrace.h b/arch/arm64/include/asm/stacktrace.h
> > index 79f455b37c84..43f4b4a6d383 100644
> > --- a/arch/arm64/include/asm/stacktrace.h
> > +++ b/arch/arm64/include/asm/stacktrace.h
> > @@ -65,8 +65,8 @@ static inline bool on_accessible_stack(const struct task_struct *tsk,
> >                                      unsigned long sp, unsigned long size,
> >                                      struct stack_info *info)
> >  {
> > -     if (info)
> > -             info->type = STACK_TYPE_UNKNOWN;
> > +     if (on_accessible_stack_common(tsk, sp, size, info))
> > +             return true;
> >
> >       if (on_task_stack(tsk, sp, size, info))
> >               return true;
> > @@ -74,8 +74,6 @@ static inline bool on_accessible_stack(const struct task_struct *tsk,
> >               return false;
> >       if (on_irq_stack(sp, size, info))
> >               return true;
> > -     if (on_overflow_stack(sp, size, info))
> > -             return true;
> >       if (on_sdei_stack(sp, size, info))
> >               return true;
> >
> > diff --git a/arch/arm64/include/asm/stacktrace/common.h b/arch/arm64/include/asm/stacktrace/common.h
> > index 64ae4f6b06fe..f58b786460d3 100644
> > --- a/arch/arm64/include/asm/stacktrace/common.h
> > +++ b/arch/arm64/include/asm/stacktrace/common.h
> > @@ -62,6 +62,9 @@ struct unwind_state {
> >       struct task_struct *task;
> >  };
> >
> > +static inline bool on_overflow_stack(unsigned long sp, unsigned long size,
> > +                                  struct stack_info *info);
> > +
> >  static inline bool on_stack(unsigned long sp, unsigned long size,
> >                           unsigned long low, unsigned long high,
> >                           enum stack_type type, struct stack_info *info)
> > @@ -80,6 +83,21 @@ static inline bool on_stack(unsigned long sp, unsigned long size,
> >       return true;
> >  }
> >
> > +static inline bool on_accessible_stack_common(const struct task_struct *tsk,
> > +                                           unsigned long sp,
> > +                                           unsigned long size,
> > +                                           struct stack_info *info)
> > +{
> > +     if (info)
> > +             info->type = STACK_TYPE_UNKNOWN;
> > +
> > +     /*
> > +      * Both the kernel and nvhe hypervisor make use of
> > +      * an overflow_stack
> > +      */
> > +     return on_overflow_stack(sp, size, info);
> > +}
>
> on_accessible_stack has the following comment:
>
> /*
>  * We can only safely access per-cpu stacks from current in a non-preemptible
>  * context.
>  */
>
> With this change, I don't think we satisfy this requirement anymore,
> as we're checking the overflow stack *before* the preemptible check,
> which is a big change in behaviour.
>
> The hypervisor doesn't have this requirement: the unwinding is either
> done out of context (nVHE, where EL1 unwinds EL2) or in a
> non-preemptible section (pKVM, where the whole thing is
> non-preemptible). But the kernel is usually preemptible, so this patch
> needs fixing.
>
> I'll see if I can address it locally (I'm currently moving things
> around, stay tuned).

Hi Marc,

You are right it changes the order of the checks. I think the simplest
way then is to drop this patch, and replace uses of on_accessible
_stack_common().

Thanks,
Kalesh

>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
