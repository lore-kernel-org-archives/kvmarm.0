Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69485C43334
	for <kvmarm@archiver.kernel.org>; Wed,  8 Jun 2022 17:22:34 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D03324B1EC;
	Wed,  8 Jun 2022 13:22:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yxSVrf9fp+Vo; Wed,  8 Jun 2022 13:22:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 90A784B204;
	Wed,  8 Jun 2022 13:22:32 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DC6D64B204
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Jun 2022 13:22:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id flJFg-hw2Yyk for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Jun 2022 13:22:29 -0400 (EDT)
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com
 [209.85.221.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7EF974B1EC
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Jun 2022 13:22:29 -0400 (EDT)
Received: by mail-wr1-f50.google.com with SMTP id p10so29223769wrg.12
 for <kvmarm@lists.cs.columbia.edu>; Wed, 08 Jun 2022 10:22:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=B+RipUWYNMLeY/oYRMhKJcIyF3eyXnDrThQxLnJtJ/4=;
 b=VbuiN8M4rPEtCsxfAOKq6djZLBP8Z09jLiB5E+50UbeLe1DyRPL04iCxdpUXPFmf4O
 tO2C+3zK3zva4OByvkV7cFUQpVlJNHtXs6cFLVxxp0eQpK5jOg3g1ErYQfw3d/kn1siM
 JqzuOE8Y2Fe0PpMZmKNjqwBN/78WtJ3TzqUBvUvenOup0z3ZN/9kF4Y9ufmY+m+3iLHz
 4XaGXS6i/2APuVBwkkbgPZH/FaP7oFy0L5wyFaZ20qMPI8O6W5L8wfckA/Cqv9hzlUZv
 3HRPKHWX7UIAR4D3mQ3fbcyMPfrrg9lPA2e6WWpxYkTGkOXcuRlGBpCS8hlyhhNdXY7b
 +W9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=B+RipUWYNMLeY/oYRMhKJcIyF3eyXnDrThQxLnJtJ/4=;
 b=28S2Uq5S43AGQRODMK1ewl1oiNNEB2lzZUvKa9gC217Kmi62bkTXNNBpYgLFIAmWug
 XBERw+2kG1nxxeCBYKg5NCMucjLXzaUZ7vd7iE5hjVHMPGkZG8hqKO7e7I0SWDaUQljb
 yfjI9fkAmXoeRlPFPa+zY6O4HTUh/7tV1yASLzLE5ngDxC6QxRrKU23yb2GIoAoYqXSs
 rY5xk7JrlOG9K3ox52ta1dGcIrymKCRKnVyS2B0G+K6UIojH0NmsHsJNN9HmJe6JAPhg
 SChbzjsjQ+vi8UhlmE1UIMjTTXBiKFlRN+iJ3wEiAom+CVyTvb1IXEQpI9SKG+TRG+EC
 toIw==
X-Gm-Message-State: AOAM532LqNwvu70GhmILQSBWfmkGgIXM1sqa8ayxKnHT2JRH4AhSPRoD
 wI+0Vfz7EngWYOxmGowbtPzxLHMmEHNue3ydgXm0Vg==
X-Google-Smtp-Source: ABdhPJzj7HbZLSivmEF68CKctXVCcbUidRcUXxew7OVgd/Q1ovBW9vLIR0DdV0vVzQluBSNqGW6kjayJZlmVfOiV0cY=
X-Received: by 2002:a05:6000:18a9:b0:218:7791:a9ad with SMTP id
 b9-20020a05600018a900b002187791a9admr3373050wri.116.1654708948112; Wed, 08
 Jun 2022 10:22:28 -0700 (PDT)
MIME-Version: 1.0
References: <20220607165105.639716-1-kaleshsingh@google.com>
 <20220607165105.639716-3-kaleshsingh@google.com>
 <87leu7zk11.wl-maz@kernel.org>
In-Reply-To: <87leu7zk11.wl-maz@kernel.org>
From: Kalesh Singh <kaleshsingh@google.com>
Date: Wed, 8 Jun 2022 10:22:16 -0700
Message-ID: <CAC_TJvetC5ZEee_x1nUf0ZJRk-eTAzJj4A4o+MOzZLS0tDGVCQ@mail.gmail.com>
Subject: Re: [PATCH v3 2/5] KVM: arm64: Compile stacktrace.nvhe.o
To: Marc Zyngier <maz@kernel.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>,
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

On Wed, Jun 8, 2022 at 12:33 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Tue, 07 Jun 2022 17:50:44 +0100,
> Kalesh Singh <kaleshsingh@google.com> wrote:
> >
> > Recompile stack unwinding code for use with the nVHE hypervisor. This is
> > a preparatory patch that will allow reusing most of the kernel unwinding
> > logic in the nVHE hypervisor.
> >
> > Suggested-by: Mark Rutland <mark.rutland@arm.com>
> > Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
> > Reviewed-by: Mark Brown <broonie@kernel.org>
> > ---
> >
> > Changes in v3:
> >   - Add Mark's Reviewed-by tag
> >
> > Changes in v2:
> >   - Split out refactoring of common unwinding logic into a separate patch,
> >     per Mark Brown
> >
> >  arch/arm64/include/asm/stacktrace.h | 18 +++++++++-----
> >  arch/arm64/kernel/stacktrace.c      | 37 ++++++++++++++++-------------
> >  arch/arm64/kvm/hyp/nvhe/Makefile    |  3 ++-
> >  3 files changed, 35 insertions(+), 23 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/stacktrace.h b/arch/arm64/include/asm/stacktrace.h
> > index aec9315bf156..f5af9a94c5a6 100644
> > --- a/arch/arm64/include/asm/stacktrace.h
> > +++ b/arch/arm64/include/asm/stacktrace.h
> > @@ -16,12 +16,14 @@
> >  #include <asm/sdei.h>
> >
> >  enum stack_type {
> > -     STACK_TYPE_UNKNOWN,
> > +#ifndef __KVM_NVHE_HYPERVISOR__
> >       STACK_TYPE_TASK,
> >       STACK_TYPE_IRQ,
> >       STACK_TYPE_OVERFLOW,
> >       STACK_TYPE_SDEI_NORMAL,
> >       STACK_TYPE_SDEI_CRITICAL,
> > +#endif /* !__KVM_NVHE_HYPERVISOR__ */
> > +     STACK_TYPE_UNKNOWN,
>
> What is the reason for this reordering? I have the sinking feeling
> that this could play badly with the logic that assumes that it is
> legal to switch from a lesser stack type to a higher one, and could
> allow switching to a duff stack.

HI Marc. Thanks for reviewing.

I only reordered the enum to group the common types. But I don't have
a strong opinion on it. The unwinding doesn't depend on the ordering
in this enum. When we transition form stack 'A'-->'B', we set the
stack_done bit for stack A so that we never transition back to 'A', as
it's not valid to transition back to a previous stack. But the order
of the sequence itself is not something enforced.

>
> I would at least like to see a justification of why this isn't less
> safe than the current code.
>
> [...]
>
> > index f9fe4dc21b1f..c0ff0d6fc403 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/Makefile
> > +++ b/arch/arm64/kvm/hyp/nvhe/Makefile
> > @@ -14,7 +14,8 @@ lib-objs := $(addprefix ../../../lib/, $(lib-objs))
> >
> >  obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o host.o \
> >        hyp-main.o hyp-smp.o psci-relay.o early_alloc.o page_alloc.o \
> > -      cache.o setup.o mm.o mem_protect.o sys_regs.o pkvm.o
> > +      cache.o setup.o mm.o mem_protect.o sys_regs.o pkvm.o \
> > +      ../../../kernel/stacktrace.o
>
> This, I positively hate. It is only a marginally better than the
> cross-arch references we used to have with arch/arm/kvm. I'd be much
> more happy with an include file containing the shared code. It would
> also allow the removal of some of the #ifdeferry. Note that this is
> the approach that we ended up adopting for the VHE/nVHE split.
>

Also thought about moving stuff to some header file, but I thought
this might be less intrusive. Let me prototype to see how they
compare.

Thanks,
Kalesh

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
