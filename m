Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B387C43334
	for <kvmarm@archiver.kernel.org>; Wed,  8 Jun 2022 17:53:09 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A03E64B2A0;
	Wed,  8 Jun 2022 13:53:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ftfiL7boxF98; Wed,  8 Jun 2022 13:53:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 66DD94B20D;
	Wed,  8 Jun 2022 13:53:07 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 13C674B20A
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Jun 2022 13:53:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8LdwWlP7NSvb for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Jun 2022 13:53:05 -0400 (EDT)
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com
 [209.85.128.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B25F74B204
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Jun 2022 13:53:05 -0400 (EDT)
Received: by mail-wm1-f46.google.com with SMTP id z9so4516961wmf.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 08 Jun 2022 10:53:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=YI9Mc2y8PFJNJ6+277vO+Lm0SzBPppWh2ZCOqdRyG6U=;
 b=T6/f1qoAHYT15Hdc059V8LrdJ4GLuSvSfJhPDPXC+CHKqgTSOEQjMe4N5wpirC9FtU
 RM1ZClrDDtGGUlsCUAvtRIHYu9T+qgfZPKRBdo1OkSLN/NVYr5H+xiWvptYKDx6wqeny
 98WMYiqOFUzT7s9uim5WWfH7PaQ5W60nWnLtQu1OSsqgNpTO7ud2I//C7+LUHkz58v62
 rsQ/j9znMPtuROLFr+FjZXc0UwWxNvrenPI2c7c0cAxxB5dJ7AiY12fFjqgLSjIZ0nPl
 3nYmv2UftqPeTJRZ2lCEraPv7280jJJyl1DnnOuSEjLXO4M22RgXjayoWXjoMjFvWeBv
 rQ8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=YI9Mc2y8PFJNJ6+277vO+Lm0SzBPppWh2ZCOqdRyG6U=;
 b=CiBTy9pX1Eckc3/4LImZeyjwxPlg1A7ym/kd6fkt1iJHXRCbV02LS+a9ffqpj8HDwm
 vxN098cBRc3rCPPWrsUZ7TraOSyGjPGjMefa0EWZlNnOs2y8DoCV0jyFESBC/RjKmRMD
 nikszBls2mWx41Zc2xlby2SFx3Ezrmtg7eQCl3+Ad8j7N7FlyTatcAxy8d4LFt5jVODn
 OhJUm9ZYUDKzgQVnRNn6+YmsjMzYVmTM8DBh4+shXsWdbPmzWe+YA2dEt0aq6wJrzhFh
 tVbxLaBJsyDkykidyZt4G5TA7LsmJAiU8bK09Yi6tbuAmTQ1n+DMI9pizKN/qQrkGz18
 Y9/g==
X-Gm-Message-State: AOAM532Y1X3swCY8L4J1KO3yz/sKdSw4kHh2+IXCABtAZr5G6WYHtDDk
 edjvf8pALOjQIVJs7NOUjZ5IHTF26JnRS5NaD6L1Pg==
X-Google-Smtp-Source: ABdhPJxtB5s3HTyhMQ+95dATyPUIRZjpYXUhC4AvkAPE7C5j7bf9s29ofjL8I/77hpbnAS2cfihV8ammb75j3F8npfU=
X-Received: by 2002:a1c:7901:0:b0:39c:4252:d7f1 with SMTP id
 l1-20020a1c7901000000b0039c4252d7f1mr380895wme.178.1654710784341; Wed, 08 Jun
 2022 10:53:04 -0700 (PDT)
MIME-Version: 1.0
References: <20220607165105.639716-1-kaleshsingh@google.com>
 <20220607165105.639716-4-kaleshsingh@google.com>
 <87k09rzk0o.wl-maz@kernel.org>
In-Reply-To: <87k09rzk0o.wl-maz@kernel.org>
From: Kalesh Singh <kaleshsingh@google.com>
Date: Wed, 8 Jun 2022 10:52:53 -0700
Message-ID: <CAC_TJvdCuGNEJC4M+bV6o48CSJRs_4GEUb3iiP_4ro79q=KesA@mail.gmail.com>
Subject: Re: [PATCH v3 3/5] KVM: arm64: Add hypervisor overflow stack
To: Marc Zyngier <maz@kernel.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>,
 Peter Zijlstra <peterz@infradead.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Alexei Starovoitov <ast@kernel.org>,
 Will Deacon <will@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 kvmarm <kvmarm@lists.cs.columbia.edu>,
 "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>,
 "moderated list:ARM64 PORT \(AARCH64 ARCHITECTURE\)"
 <linux-arm-kernel@lists.infradead.org>,
 "Cc: Android Kernel" <kernel-team@android.com>,
 Mark Brown <broonie@kernel.org>, "T.J. Mercier" <tjmercier@google.com>,
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

On Wed, Jun 8, 2022 at 12:34 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Tue, 07 Jun 2022 17:50:45 +0100,
> Kalesh Singh <kaleshsingh@google.com> wrote:
> >
> > Allocate and switch to 16-byte aligned secondary stack on overflow. This
> > provides us stack space to better handle overflows; and is used in
> > a subsequent patch to dump the hypervisor stacktrace.
> >
> > Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
> > ---
> >  arch/arm64/kernel/stacktrace.c | 3 +++
> >  arch/arm64/kvm/hyp/nvhe/host.S | 9 ++-------
> >  2 files changed, 5 insertions(+), 7 deletions(-)
> >
> > diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
> > index a84e38d41d38..f346b4c66f1c 100644
> > --- a/arch/arm64/kernel/stacktrace.c
> > +++ b/arch/arm64/kernel/stacktrace.c
> > @@ -242,4 +242,7 @@ noinline notrace void arch_stack_walk(stack_trace_consume_fn consume_entry,
> >
> >       unwind(task, &state, consume_entry, cookie);
> >  }
> > +#else /* __KVM_NVHE_HYPERVISOR__ */
> > +DEFINE_PER_CPU(unsigned long [PAGE_SIZE/sizeof(long)], overflow_stack)
> > +     __aligned(16);
>
> Does this need to be a whole page? With 64kB pages, this is
> potentially a lot of memory for something that will hardly ever be
> used. The rest of the kernel limits this to 4kB, which seems more
> reasonable. There is no guard page anyway, so PAGE_SIZE doesn't
> provide any extra protection.

My oversight on the !4kB page sizes. I think this could be as small as:

    (STACK_SIZE - 1) / 2 + sizeof(long)

         '/ 2'                        : Min frame size (x29, x30)
         '+ sizeof(long)'      : To round up

since we only save the one address (PC) for each frame. WDYT?

Thanks,
Kalesh

>
> >  #endif /* !__KVM_NVHE_HYPERVISOR__ */
> > diff --git a/arch/arm64/kvm/hyp/nvhe/host.S b/arch/arm64/kvm/hyp/nvhe/host.S
> > index ea6a397b64a6..4e3032a244e1 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/host.S
> > +++ b/arch/arm64/kvm/hyp/nvhe/host.S
> > @@ -177,13 +177,8 @@ SYM_FUNC_END(__host_hvc)
> >       b       hyp_panic
> >
> >  .L__hyp_sp_overflow\@:
> > -     /*
> > -      * Reset SP to the top of the stack, to allow handling the hyp_panic.
> > -      * This corrupts the stack but is ok, since we won't be attempting
> > -      * any unwinding here.
> > -      */
> > -     ldr_this_cpu    x0, kvm_init_params + NVHE_INIT_STACK_HYP_VA, x1
> > -     mov     sp, x0
> > +     /* Switch to the overflow stack */
> > +     adr_this_cpu sp, overflow_stack + PAGE_SIZE, x0
> >
> >       b       hyp_panic_bad_stack
> >       ASM_BUG()
> > --
> > 2.36.1.255.ge46751e96f-goog
> >
> >
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
