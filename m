Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17D55C43334
	for <kvmarm@archiver.kernel.org>; Mon, 18 Jul 2022 17:33:13 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A63134D7B2;
	Mon, 18 Jul 2022 13:33:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FY0A9Y5Xkgaw; Mon, 18 Jul 2022 13:33:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D0094D79C;
	Mon, 18 Jul 2022 13:33:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F3BA64D746
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2022 13:33:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zWZVVXDbLyPl for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Jul 2022 13:33:04 -0400 (EDT)
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com
 [209.85.128.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9DCDF4D6FC
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2022 13:33:04 -0400 (EDT)
Received: by mail-wm1-f47.google.com with SMTP id
 az2-20020a05600c600200b003a301c985fcso7524579wmb.4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2022 10:33:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=+GhSiJA8jNsER0UOznMgRktrQLMwzPG3Lkdw+33iL48=;
 b=DVpMJwQkF5I84C5a0bD/n0SGDKhI8JmAiylD9fmz59B8jFXrW5DzKsxyYiuwdhGLvm
 K4gULiPfi6uauHtwJd2OIRawraFt+4S6N4KPFQEXI0286+Iz5uri3jFYjtWo7UNzRDbq
 WO/sHs2EbpJKexJf2/tIF2biRfjE38wrxW6d0gZkNTo64HJbndH7E73QqrQQbQSXP8IW
 +2es2frz9Bo5NJ4Ed4m92YziZGBbbEVM0o9C24Sru2nHI1xnBwSVrqYMNffmWR61pa9D
 12jZHHKA2uzOcv8qjjqzDwaga2LDQK5UYlTyUy8DbMjzhxEGoWrK4gduH418liVMZ7We
 plfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=+GhSiJA8jNsER0UOznMgRktrQLMwzPG3Lkdw+33iL48=;
 b=rS3sBgGyYdXzuVrB0G6n1q+MiRPeygjlNiTK6FXWGFaeI+5WXvdHd77bK5qAKXTGKw
 CYu7NRjOJrzcfFNyltQ7n3wyuqjlZ/pokKMBpDLGATCAjGzRXh6pnlJpTKiw97UQbkC9
 7GcdHmu5RrADkbA1o64DOVrnIX4lxw+Z+qvU6Yxp8Ohf8qEemJuEwB1Qk5hGhqfNkdE3
 8aXLEy0Nc/NY9KawKZdT+9E09vPjuJyI9fqFf4jfp7l6N22DWTQxgD2K3XMKEEEuFByW
 xDCWyTQ3vEKUl3Xrow/LYoOUu2KAVdfVk00GcIgJpfh1KmLYMB0Oluo0CGja64hpETwQ
 lRZA==
X-Gm-Message-State: AJIora9C9DIiQSbepG5RSeliHO354c0VaCwFzqARE2Rx09z/wL/zXLCn
 A1ruwm9qN6/Qe38ykzdOgbl/A2Cfgu7gBQQ8/5Q7jg==
X-Google-Smtp-Source: AGRyM1tdOOSVY9WqE1GNkbUPuJZIHQeZx/yxe+w4lvoTvSD+QSC1W6nuhwTjhl40mPLwy38Rmfsy+mkoP0zaF4gbspQ=
X-Received: by 2002:a1c:7213:0:b0:3a3:155a:dd5d with SMTP id
 n19-20020a1c7213000000b003a3155add5dmr9625060wmc.178.1658165583538; Mon, 18
 Jul 2022 10:33:03 -0700 (PDT)
MIME-Version: 1.0
References: <20220715061027.1612149-1-kaleshsingh@google.com>
 <20220715061027.1612149-13-kaleshsingh@google.com>
 <87tu7ezrso.wl-maz@kernel.org>
In-Reply-To: <87tu7ezrso.wl-maz@kernel.org>
From: Kalesh Singh <kaleshsingh@google.com>
Date: Mon, 18 Jul 2022 10:32:52 -0700
Message-ID: <CAC_TJvcc0VZhp+u+2YpXuQ-UcGC+YTKy1PEoPCmbm+_WXo6cVw@mail.gmail.com>
Subject: Re: [PATCH v4 12/18] KVM: arm64: Save protected-nVHE (pKVM) hyp
 stacktrace
To: Marc Zyngier <maz@kernel.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>, Marco Elver <elver@google.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Alexei Starovoitov <ast@kernel.org>,
 vincenzo.frascino@arm.com, Will Deacon <will@kernel.org>,
 android-mm@google.com, kvmarm <kvmarm@lists.cs.columbia.edu>,
 "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>,
 "moderated list:ARM64 PORT \(AARCH64 ARCHITECTURE\)"
 <linux-arm-kernel@lists.infradead.org>, andreyknvl@gmail.com,
 "Cc: Android Kernel" <kernel-team@android.com>,
 Andrew Jones <drjones@redhat.com>, Mark Brown <broonie@kernel.org>,
 russell.king@oracle.com, LKML <linux-kernel@vger.kernel.org>,
 Masami Hiramatsu <mhiramat@kernel.org>
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

On Mon, Jul 18, 2022 at 2:36 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Fri, 15 Jul 2022 07:10:21 +0100,
> Kalesh Singh <kaleshsingh@google.com> wrote:
> >
> > In protected nVHE mode, the host cannot access private owned hypervisor
> > memory. Also the hypervisor aims to remains simple to reduce the attack
> > surface and does not provide any printk support.
> >
> > For the above reasons, the approach taken to provide hypervisor stacktraces
> > in protected mode is:
> >    1) Unwind and save the hyp stack addresses in EL2 to a shared buffer
> >       with the host (done in this patch).
> >    2) Delegate the dumping and symbolization of the addresses to the
> >       host in EL1 (later patch in the series).
> >
> > Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
> > ---
> >  arch/arm64/include/asm/stacktrace/nvhe.h | 18 ++++++
> >  arch/arm64/kvm/hyp/nvhe/stacktrace.c     | 70 ++++++++++++++++++++++++
> >  2 files changed, 88 insertions(+)
> >
> > diff --git a/arch/arm64/include/asm/stacktrace/nvhe.h b/arch/arm64/include/asm/stacktrace/nvhe.h
> > index 36cf7858ddd8..456a6ae08433 100644
> > --- a/arch/arm64/include/asm/stacktrace/nvhe.h
> > +++ b/arch/arm64/include/asm/stacktrace/nvhe.h
> > @@ -21,6 +21,22 @@
> >
> >  #include <asm/stacktrace/common.h>
> >
> > +/**
> > + * kvm_nvhe_unwind_init - Start an unwind from the given nVHE HYP fp and pc
> > + *
> > + * @fp : frame pointer at which to start the unwinding.
> > + * @pc : program counter at which to start the unwinding.
> > + */
> > +static __always_inline void kvm_nvhe_unwind_init(struct unwind_state *state,
> > +                                              unsigned long fp,
> > +                                              unsigned long pc)
> > +{
> > +     unwind_init_common(state, NULL);
>
> Huh. Be careful here. This function is only 'inline', which means it
> may not be really inlined. We've had tons of similar issues like this
> in the past, and although this will not break at runtime anymore, it
> will definitely stop the kernel from linking.

Ahh, there are a few other always inline *unwind_init* functions that
use this. I'll update in the next version.

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
