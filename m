Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AA9DC433EF
	for <kvmarm@archiver.kernel.org>; Wed, 23 Feb 2022 11:02:45 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D94784C47B;
	Wed, 23 Feb 2022 06:02:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xCEogSxcRZd6; Wed, 23 Feb 2022 06:02:43 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 416654C47C;
	Wed, 23 Feb 2022 06:02:32 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 898F149E2A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Feb 2022 15:30:24 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id B+au3EYqMiux for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Feb 2022 15:30:23 -0500 (EST)
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com
 [209.85.221.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 61C7E40FD8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Feb 2022 15:30:23 -0500 (EST)
Received: by mail-wr1-f53.google.com with SMTP id j17so8962174wrc.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Feb 2022 12:30:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=D/GUDwwIIoMRy8+dHgUhur8ijOgSxklxDJwa/sFpEOU=;
 b=hbNMa9MZ9iJNQgmN4fGGpGPNabVhNX9ToIjlcX39Q/sK5fiV2J2eGt24KeSKBiJZGx
 DwkfyOmMCVUm/WfBrt3me5yTRPrLGRISo2XZK0sZ0FqgdqzPxjNyk8nhQx7xVb0psNyG
 FhpiEgcDuIrKz1xWjSrzscir+5dQctS83sItdwFetXJU04NyvT28b19BKAc+WRaSr4VL
 pM7fEN6ozvC07qhjKiQ1lp22NV7p/SM7Exs4KMi9Ac2hkE6tmg8Gfq/yzGOhkHJuxoyl
 VeCE6GoL8KwFBQMAwMdOoLZ0z2k2G0glacuMwspNZVJup4D1BUFstEUBWUD31hjl+Dpv
 ZISw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=D/GUDwwIIoMRy8+dHgUhur8ijOgSxklxDJwa/sFpEOU=;
 b=tLhAVzSggJ9IQl9dpNHWjXeQU3MnXxSMgVe8agCv8nttfyCP0CEu/C+v9LMP0R1QHP
 ePGHLHUMb8QlzTOuKiRQ5i+j5iUDpf+cwSY+PHqt0NAT4MfOh5ROIQ+OpvRyrI65yj+N
 luhUMrWaygQDt2e71KYSdykKWU3IBvtU7x+kEtdpUi1wV4Xbuh8woVTaUW2wPRnVXejK
 yi8OsEketi3FpAOAr42s0qIEKB2NolYxElEnlOMU1WqbNo1guK2GNLC3nCpyzWWOFoWL
 HXYAc1Li7nXmkSHxHESfIoMXpoW362e/Y+UdvIInyYTatkbZ7sGZAwsq8hnJPnHpFYAb
 k29Q==
X-Gm-Message-State: AOAM533FAXraEoqdWsAb2d8JQlgYe+bktrscZPT4w6Vn7XL3vWMZsGWc
 EIHUuIT7e+b3KQPzUlfJacu1JrKZh6aXAeqt8g2p3w==
X-Google-Smtp-Source: ABdhPJxomxRQYTPPF7tW+jgDdOTc5ewiGXelXfxHh2vVMN5OcnyAqrPnJg07kVWIlZWOyQ63eBOlqeJBhlNML7EE+B0=
X-Received: by 2002:a05:6000:1684:b0:1ea:8651:56fe with SMTP id
 y4-20020a056000168400b001ea865156femr4059311wrd.577.1645561822103; Tue, 22
 Feb 2022 12:30:22 -0800 (PST)
MIME-Version: 1.0
References: <20220222165212.2005066-1-kaleshsingh@google.com>
 <20220222165212.2005066-5-kaleshsingh@google.com> <YhUxhEHNKlqip51u@lakrids>
In-Reply-To: <YhUxhEHNKlqip51u@lakrids>
From: Kalesh Singh <kaleshsingh@google.com>
Date: Tue, 22 Feb 2022 12:30:11 -0800
Message-ID: <CAC_TJvff+2bSa-RVJ49jenb-yJ_mgEHumnQqoaOedV24GrKb5A@mail.gmail.com>
Subject: Re: [PATCH v2 4/9] KVM: arm64: Add guard pages for pKVM (protected
 nVHE) hypervisor stack
To: Mark Rutland <mark.rutland@arm.com>
X-Mailman-Approved-At: Wed, 23 Feb 2022 06:02:29 -0500
Cc: "moderated list:ARM64 PORT \(AARCH64 ARCHITECTURE\)"
 <linux-arm-kernel@lists.infradead.org>,
 "Cc: Android Kernel" <kernel-team@android.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>, Will Deacon <will@kernel.org>,
 Peter Collingbourne <pcc@google.com>, Marc Zyngier <maz@kernel.org>,
 LKML <linux-kernel@vger.kernel.org>, Joey Gouly <joey.gouly@arm.com>,
 kvmarm@lists.cs.columbia.edu, Catalin Marinas <catalin.marinas@arm.com>,
 Suren Baghdasaryan <surenb@google.com>
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

On Tue, Feb 22, 2022 at 10:55 AM Mark Rutland <mark.rutland@arm.com> wrote:
>
> On Tue, Feb 22, 2022 at 08:51:05AM -0800, Kalesh Singh wrote:
> > Maps the stack pages in the flexible private VA range and allocates
> > guard pages below the stack as unbacked VA space. The stack is aligned
> > to twice its size to aid overflow detection (implemented in a subsequent
> > patch in the series).
> >
> > Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
> > ---
> >  arch/arm64/kvm/hyp/nvhe/setup.c | 25 +++++++++++++++++++++----
> >  1 file changed, 21 insertions(+), 4 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
> > index 27af337f9fea..69df21320b09 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/setup.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/setup.c
> > @@ -105,11 +105,28 @@ static int recreate_hyp_mappings(phys_addr_t phys, unsigned long size,
> >               if (ret)
> >                       return ret;
> >
> > -             end = (void *)per_cpu_ptr(&kvm_init_params, i)->stack_hyp_va;
> > +             /*
> > +              * Private mappings are allocated upwards from __io_map_base
> > +              * so allocate the guard page first then the stack.
> > +              */
> > +             start = (void *)pkvm_alloc_private_va_range(PAGE_SIZE, PAGE_SIZE);
> > +             if (IS_ERR_OR_NULL(start))
> > +                     return PTR_ERR(start);
>
> As on a prior patch, this usage of PTR_ERR() pattern is wrong when the
> ptr is NULL.

Ack. I'll fix these in the next version.

Thanks,
Kalesh
>
> > +             /*
> > +              * The stack is aligned to twice its size to facilitate overflow
> > +              * detection.
> > +              */
> > +             end = (void *)per_cpu_ptr(&kvm_init_params, i)->stack_pa;
> >               start = end - PAGE_SIZE;
> > -             ret = pkvm_create_mappings(start, end, PAGE_HYP);
> > -             if (ret)
> > -                     return ret;
> > +             start = (void *)__pkvm_create_private_mapping((phys_addr_t)start,
> > +                                     PAGE_SIZE, PAGE_SIZE * 2, PAGE_HYP);
> > +             if (IS_ERR_OR_NULL(start))
> > +                     return PTR_ERR(start);
>
> Likewise.
>
> Thanks,
> Mark.
>
> > +             end = start + PAGE_SIZE;
> > +
> > +             /* Update stack_hyp_va to end of the stack's private VA range */
> > +             per_cpu_ptr(&kvm_init_params, i)->stack_hyp_va = (unsigned long) end;
> >       }
> >
> >       /*
> > --
> > 2.35.1.473.g83b2b277ed-goog
> >
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
