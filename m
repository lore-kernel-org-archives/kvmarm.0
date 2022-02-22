Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40E86C433F5
	for <kvmarm@archiver.kernel.org>; Wed, 23 Feb 2022 11:02:44 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EB0864C498;
	Wed, 23 Feb 2022 06:02:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id CTfEdFzQiyWu; Wed, 23 Feb 2022 06:02:42 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2314F4C4AA;
	Wed, 23 Feb 2022 06:02:32 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7A28C49EE8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Feb 2022 15:20:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zQkLm6QUWnuV for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Feb 2022 15:20:32 -0500 (EST)
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com
 [209.85.128.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EF3B6408D5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Feb 2022 15:20:31 -0500 (EST)
Received: by mail-wm1-f44.google.com with SMTP id c192so12344735wma.4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Feb 2022 12:20:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=wOey4rPC2TeiOe1tuJcJnl76pBFzOll2hU5Aq8ViVuo=;
 b=Z0MMnMKZ8ChPYc9QvuVfaVyvcvMHdxyCx7Is/qVaUayOmS0S1TjILQ8IvSCnBsBDbx
 Uu7SeMoZNephvMZZVlrLGOE8iXzf3Vs3JQqJexz+9cWxhY7I0l7BrQG6VNnjyy8YKiWI
 sGq2n1zU0bXPpVmAHWQixJ5KWIOO9CsM2UenDDVcRVkkXLqBKeNkUon5zYp2N0B9kMpt
 56uk2w5vx0mMlwrdlMeMmUcXIPz68sBx0I5mPa/5eEw2eHD3c9bse/ULzM0f51yFNly6
 MDe+LiFQFyhnTBXWaXJ+B/XWFwARwHsJyF4r6J+zNz59UQPgHHKonmCN1x5eqfB1Urb/
 RpEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=wOey4rPC2TeiOe1tuJcJnl76pBFzOll2hU5Aq8ViVuo=;
 b=Ir4XCwvJHnBKvAt4VcyRpVh0LrEtPLyzvIU71oKxCHgDM+Tzj7BAPzNrEqZYFZ5JQk
 yNvqLBdQhsRfBgBys6/vJpjF7nrqCy/STd9KcXBCpQ9TFawU5ezdhyRYztYeuaagwS1A
 VvXudDKv9EB6O6VtskKNdidvRiD7s+GIkNc/aZjLHUNInWOqTAB4DEroWwo/uClNdMxm
 cJD50/snL+VmHuil7vEoabVM/64dYzH7snhlVke4xuDSQwkrovkAy1UyMvEtHUOkwlag
 iv+/spMFG+6hKcKEfZAdzaN0ISFysn6xCPSW6eOiZL6K9uUyya+NmosAZUAtFa2Oj3Y3
 tehA==
X-Gm-Message-State: AOAM531lIep2pHywRCkjTfDylaCSKOwrImTvv7exodiLufPPJCFAIFaI
 xN7SvxpgfuZYEALfBC7PknrbUrPzrTqqt8XxQXXuhA==
X-Google-Smtp-Source: ABdhPJwB6dHixzfnFB/aFW5sbmzpMc+ZugeT0IDT1VPile7+mVN6XZnPjFDa4fuF2gd1rm7gYsaquR4HrkRhYX6DvtY=
X-Received: by 2002:a05:600c:4fc4:b0:37c:9116:ef3d with SMTP id
 o4-20020a05600c4fc400b0037c9116ef3dmr4551689wmq.167.1645561230799; Tue, 22
 Feb 2022 12:20:30 -0800 (PST)
MIME-Version: 1.0
References: <20220222165212.2005066-1-kaleshsingh@google.com>
 <20220222165212.2005066-6-kaleshsingh@google.com> <YhUsQZUqgb94EjmD@lakrids>
In-Reply-To: <YhUsQZUqgb94EjmD@lakrids>
From: Kalesh Singh <kaleshsingh@google.com>
Date: Tue, 22 Feb 2022 12:20:19 -0800
Message-ID: <CAC_TJvdo2UwrZwKGhZUTnCF--CNsKJFKe+tZOQWgs0=BhpBF0g@mail.gmail.com>
Subject: Re: [PATCH v2 5/9] arm64: asm: Introduce test_sp_overflow macro
To: Mark Rutland <mark.rutland@arm.com>
X-Mailman-Approved-At: Wed, 23 Feb 2022 06:02:29 -0500
Cc: "moderated list:ARM64 PORT \(AARCH64 ARCHITECTURE\)"
 <linux-arm-kernel@lists.infradead.org>,
 "Cc: Android Kernel" <kernel-team@android.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>, Will Deacon <will@kernel.org>,
 Peter Collingbourne <pcc@google.com>, Marc Zyngier <maz@kernel.org>,
 LKML <linux-kernel@vger.kernel.org>, Joey Gouly <joey.gouly@arm.com>,
 kvmarm@lists.cs.columbia.edu, Catalin Marinas <catalin.marinas@arm.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Suren Baghdasaryan <surenb@google.com>
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

On Tue, Feb 22, 2022 at 10:32 AM Mark Rutland <mark.rutland@arm.com> wrote:
>
> On Tue, Feb 22, 2022 at 08:51:06AM -0800, Kalesh Singh wrote:
> > From: Quentin Perret <qperret@google.com>
> >
> > The asm entry code in the kernel uses a trick to check if VMAP'd stacks
> > have overflowed by aligning them at THREAD_SHIFT * 2 granularity and
> > checking the SP's THREAD_SHIFT bit.
> >
> > Protected KVM will soon make use of a similar trick to detect stack
> > overflows, so factor out the asm code in a re-usable macro.
> >
> > Signed-off-by: Quentin Perret <qperret@google.com>
> > [Kalesh - Resolve minor conflicts]
> > Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
> > ---
> >  arch/arm64/include/asm/assembler.h | 11 +++++++++++
> >  arch/arm64/kernel/entry.S          |  7 +------
> >  2 files changed, 12 insertions(+), 6 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
> > index e8bd0af0141c..ad40eb0eee83 100644
> > --- a/arch/arm64/include/asm/assembler.h
> > +++ b/arch/arm64/include/asm/assembler.h
> > @@ -850,4 +850,15 @@ alternative_endif
> >
> >  #endif /* GNU_PROPERTY_AARCH64_FEATURE_1_DEFAULT */
> >
> > +/*
> > + * Test whether the SP has overflowed, without corrupting a GPR.
> > + */
> > +.macro test_sp_overflow shift, label
> > +     add     sp, sp, x0                      // sp' = sp + x0
> > +     sub     x0, sp, x0                      // x0' = sp' - x0 = (sp + x0) - x0 = sp
> > +     tbnz    x0, #\shift, \label
> > +     sub     x0, sp, x0                      // x0'' = sp' - x0' = (sp + x0) - sp = x0
> > +     sub     sp, sp, x0                      // sp'' = sp' - x0 = (sp + x0) - x0 = sp
> > +.endm
>
> I'm a little unhappy about factoring this out, since it's not really
> self-contained and leaves sp and x0 partially-swapped when it branches
> to the label. You can't really make that clear with comments on the
> macro, and you need comments at each use-sire, so I'd ratehr we just
> open-coded a copy of this.
>
> > +
> >  #endif       /* __ASM_ASSEMBLER_H */
> > diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
> > index 772ec2ecf488..ce99ee30c77e 100644
> > --- a/arch/arm64/kernel/entry.S
> > +++ b/arch/arm64/kernel/entry.S
> > @@ -53,15 +53,10 @@ alternative_else_nop_endif
> >       sub     sp, sp, #PT_REGS_SIZE
> >  #ifdef CONFIG_VMAP_STACK
> >       /*
> > -      * Test whether the SP has overflowed, without corrupting a GPR.
> >        * Task and IRQ stacks are aligned so that SP & (1 << THREAD_SHIFT)
> >        * should always be zero.
> >        */
> > -     add     sp, sp, x0                      // sp' = sp + x0
> > -     sub     x0, sp, x0                      // x0' = sp' - x0 = (sp + x0) - x0 = sp
> > -     tbnz    x0, #THREAD_SHIFT, 0f
> > -     sub     x0, sp, x0                      // x0'' = sp' - x0' = (sp + x0) - sp = x0
> > -     sub     sp, sp, x0                      // sp'' = sp' - x0 = (sp + x0) - x0 = sp
> > +     test_sp_overflow THREAD_SHIFT, 0f
> >       b       el\el\ht\()_\regsize\()_\label
> >
> >  0:
>
> Further to my comment above, immediately after this we have:
>
>         /* Stash the original SP (minus PT_REGS_SIZE) in tpidr_el0. */
>         msr     tpidr_el0, x0
>
>         /* Recover the original x0 value and stash it in tpidrro_el0 */
>         sub     x0, sp, x0
>         msr     tpidrro_el0, x0
>
> ... which is really surprising with the `test_sp_overflow` macro because
> it's not clear that modifies x0 and sp in this way.

Hi Mark,

I agree the macro hides the fact that sp and x0 are left in an
'corrupt' state if the branch happens. Not a problem in this case but
it could be misleading to new users. I'll remove this per your
suggestion in the next version.

Thanks,
Kalesh
>
> Thanks,
> Mark.
> ...
>
> > --
> > 2.35.1.473.g83b2b277ed-goog
> >
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
