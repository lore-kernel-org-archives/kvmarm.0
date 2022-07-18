Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E16DFC433EF
	for <kvmarm@archiver.kernel.org>; Mon, 18 Jul 2022 17:27:23 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 702BE4D739;
	Mon, 18 Jul 2022 13:27:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id kBncNnB08t5F; Mon, 18 Jul 2022 13:27:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 32FFD4D746;
	Mon, 18 Jul 2022 13:27:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 370174D739
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2022 13:27:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8C-XbrDYV5zU for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Jul 2022 13:27:20 -0400 (EDT)
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com
 [209.85.221.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E77D04D71F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2022 13:27:19 -0400 (EDT)
Received: by mail-wr1-f51.google.com with SMTP id r14so18114601wrg.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2022 10:27:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=NarkEMjRQJGNapnFE354uoBB/FLZcCCiwC99PqFL5qY=;
 b=S68ky+N9MIZZqrGTw9WcCJuhoDR9m6g+zzdzjK+mpiGOlOMkgUPViUE0yazvxbTVav
 Yrq5OCexwM9wOYoRIMSmHKvc1e1P1m2lzlsgZsk2EINVKLs8FbE86MSoh6jbX/64wkKa
 TmI3gVVD5vqZl8NwUinYueWQFaCGVMMcBymaWzUannVPb7zYVB2aes/zUjEB7Gqvz8oP
 ckNfx0wCYQeIKHff5noIKIPvpUTw9XiQOQs7/yQitKejqOP2jE8lybHPfHJRsnt3DgcJ
 F4v8L+of8kaCZh2iyCodYJ8P9j81QmB/E5GcG0DzpcCt6yBrW7SIvBDgrvYpLW7gCO2l
 PB1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=NarkEMjRQJGNapnFE354uoBB/FLZcCCiwC99PqFL5qY=;
 b=MD6r9ESrYL0KsJDL+wk7pPJsExEzw9dXR9Ln8r3SCTWcy1WuscFon9boolTyMkpm2+
 TLemOeEUmQ38XoUukA9lOZq8No4L5gMlWd6JswJAVPFUf/Q1htBSqg9Nacojz5ua5emO
 Bfma78YowbLHQv98F2MwMNzLjTYyneKdFMIRG0zqqJAgQHu8P/skuR6otx3/VBveNbKJ
 JGiGwawoEZsypvoiMlm1JfQewwXEd7S+tdt9Puq1RHNHLpnMnZLqDN/FT4VRkZ+4sgWv
 MfgnzSepm1s9YzONAkXPRb+VgKH7Fsqzw/5g3JqdfeaP2T2JIR7kg2c3/2Il95Gpqy6W
 o0iQ==
X-Gm-Message-State: AJIora9ObfBIRPaoIGyqqsJ2pz3GTGWWoilJbJRf84uieXZYo3zNsaaj
 k63L7f8NzJVcLUYj0K49fQ0VWjVqopnYFTqS8DzSZQ==
X-Google-Smtp-Source: AGRyM1uwq/757n/imP51CRNLieGFzZptqlZ7Lr0+jvfWuU7btodZ8udc9faDQUfo4/sXOUPE8dWEAhnfKnXpHMNeznk=
X-Received: by 2002:a05:6000:1e04:b0:21d:7ec3:fe5a with SMTP id
 bj4-20020a0560001e0400b0021d7ec3fe5amr23991658wrb.116.1658165238673; Mon, 18
 Jul 2022 10:27:18 -0700 (PDT)
MIME-Version: 1.0
References: <20220715061027.1612149-1-kaleshsingh@google.com>
 <20220715061027.1612149-10-kaleshsingh@google.com>
 <87bktm51xf.wl-maz@kernel.org>
In-Reply-To: <87bktm51xf.wl-maz@kernel.org>
From: Kalesh Singh <kaleshsingh@google.com>
Date: Mon, 18 Jul 2022 10:27:07 -0700
Message-ID: <CAC_TJvdP4joAFP0bgfKGbqsXDANGAzUiwijmhvqJsGGEqkwRdA@mail.gmail.com>
Subject: Re: [PATCH v4 09/18] KVM: arm64: Allocate shared pKVM hyp stacktrace
 buffers
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

On Mon, Jul 18, 2022 at 12:13 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Fri, 15 Jul 2022 07:10:18 +0100,
> Kalesh Singh <kaleshsingh@google.com> wrote:
> >
> > In protected nVHE mode the host cannot directly access
> > hypervisor memory, so we will dump the hypervisor stacktrace
> > to a shared buffer with the host.
> >
> > The minimum size do the buffer required, assuming the min frame
>
> s/do/for/ ?
Ack

>
> > size of [x29, x30] (2 * sizeof(long)), is half the combined size of
> > the hypervisor and overflow stacks plus an additional entry to
> > delimit the end of the stacktrace.
>
> Let me see if I understand this: the maximum stack size is the
> combination of the HYP and overflow stacks, and the smallest possible
> stack frame is 128bit (only FP+LR). The buffer thus needs to provide
> one 64bit entry per stack frame that fits in the combined stack, plus
> one entry as an end marker.
>
> So the resulting size is half of the combined stack size, plus a
> single 64bit word. Is this correct?

That understanding is correct. So for the 64 KB pages is slightly more
than half a page (overflow stack is 4KB).

>
> >
> > The stacktrace buffers are used later in the seried to dump the
> > nVHE hypervisor stacktrace when using protected-mode.
> >
> > Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
> > ---
> >  arch/arm64/include/asm/memory.h      | 7 +++++++
> >  arch/arm64/kvm/hyp/nvhe/stacktrace.c | 4 ++++
> >  2 files changed, 11 insertions(+)
> >
> > diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
> > index 0af70d9abede..28a4893d4b84 100644
> > --- a/arch/arm64/include/asm/memory.h
> > +++ b/arch/arm64/include/asm/memory.h
> > @@ -113,6 +113,13 @@
> >
> >  #define OVERFLOW_STACK_SIZE  SZ_4K
> >
> > +/*
> > + * With the minimum frame size of [x29, x30], exactly half the combined
> > + * sizes of the hyp and overflow stacks is needed to save the unwinded
> > + * stacktrace; plus an additional entry to delimit the end.
> > + */
> > +#define NVHE_STACKTRACE_SIZE ((OVERFLOW_STACK_SIZE + PAGE_SIZE) / 2 + sizeof(long))
> > +
> >  /*
> >   * Alignment of kernel segments (e.g. .text, .data).
> >   *
> > diff --git a/arch/arm64/kvm/hyp/nvhe/stacktrace.c b/arch/arm64/kvm/hyp/nvhe/stacktrace.c
> > index a3d5b34e1249..69e65b457f1c 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/stacktrace.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/stacktrace.c
> > @@ -9,3 +9,7 @@
> >
> >  DEFINE_PER_CPU(unsigned long [OVERFLOW_STACK_SIZE/sizeof(long)], overflow_stack)
> >       __aligned(16);
> > +
> > +#ifdef CONFIG_PROTECTED_NVHE_STACKTRACE
> > +DEFINE_PER_CPU(unsigned long [NVHE_STACKTRACE_SIZE/sizeof(long)], pkvm_stacktrace);
> > +#endif /* CONFIG_PROTECTED_NVHE_STACKTRACE */
>
> OK, so the allocation exists even if KVM is not running in protected
> mode. I guess this is OK for now, but definitely reinforces my request
> that this is only there when compiled for debug mode.
>

Yes, but in the case you aren't running protected mode you can avoid
it by setting PROTECTED_NVHE_STACKTRACE=n.

Thanks,
Kalesh

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
