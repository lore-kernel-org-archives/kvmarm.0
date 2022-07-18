Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 278F2C43334
	for <kvmarm@archiver.kernel.org>; Mon, 18 Jul 2022 17:09:52 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A9EF4D3DB;
	Mon, 18 Jul 2022 13:09:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZD56HfhxKAUF; Mon, 18 Jul 2022 13:09:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6210F4D3E1;
	Mon, 18 Jul 2022 13:09:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 440D44D3E1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2022 13:09:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oqtbsKADASLb for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Jul 2022 13:09:49 -0400 (EDT)
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com
 [209.85.221.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0752C4D3DB
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2022 13:09:48 -0400 (EDT)
Received: by mail-wr1-f42.google.com with SMTP id a5so17988059wrx.12
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2022 10:09:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=CRxPlNSYkYSm35uiYRBFTU8crdYHEWHvBXSEXMN6VP0=;
 b=S2DVeNOT5mYNSXmNtSQt8P9HlMZLBPTDBDd+ni5sZowLF+0QEC/n+/AWq2d3wW4Bw0
 2Qhv6901BsJjy13IPdZj3XjlhtH8D15Tf1QG77NZcNsHnyB9oJ+FoSvYg5wDCVsiNDZh
 bohhuB+5hVmf6hWIzXGjgqWtHReIs0YhT1Tjaz8Qz3VEBXpGix49oLjeBlKC7OEINOAo
 CVAPvXOWK8L+nzbll7P3kAACY3HZIbu9MRQaBMhcIrLgnQ33pshR/6nSPiEyOAnmDGwn
 VDxB9VcJ+cl8QvfolToor4LDRPJ+gj1M4cNchuf+fcSXzvsOZrhWzfFNNVsYIgGvh0RS
 b3mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=CRxPlNSYkYSm35uiYRBFTU8crdYHEWHvBXSEXMN6VP0=;
 b=eSA4j57b+n9o/Gr4LvtJ6BYktSwESaTNwZEBl8xmCQPyDyDg+f88k0Y3pI+CcayHti
 DLKRZyl8gaqwyd7buGpiH3uLfL+OBmu6yN/H2Ds1z9M3fDGxcFwVu0URIzVnhv3FG7zx
 lL7Gq6z7xZnH2VDgJxeDPnTGEfNqai06pbG8mx3sDnsXvN5ie7I6so+NcDqTZiPUK53H
 TncozyqeChnBvX+YTKCRA4zhI/jNsglTUQkFAO9A3gxFy1YNsnFO5Y63W2sXlHY6erbC
 vGOY2NaUtgN6CJN7qjOMYwGy4Uzkn23uIKROcilA68dkmRQIongaHjSCEO86J4TW4S1P
 AfQQ==
X-Gm-Message-State: AJIora/7RTA6FPTYDk4H8rfN8bTNnNqsCOGuDF7rl1J6FbnJnNwGP53G
 n+QuF5WiRIECV3fm1N+cR4U5BEVJhifKaE9nttw2cg==
X-Google-Smtp-Source: AGRyM1tW6szJjClDeMP0rbtsXYy0fEocgRbX/Hxy1ioFyWfpCUpvg6n7/Kb8za7cH4w7H+iG7eAZHfScX+PE+FriedM=
X-Received: by 2002:adf:f20a:0:b0:21e:2608:9390 with SMTP id
 p10-20020adff20a000000b0021e26089390mr3106382wro.577.1658164187743; Mon, 18
 Jul 2022 10:09:47 -0700 (PDT)
MIME-Version: 1.0
References: <20220715235824.2549012-1-kaleshsingh@google.com>
 <CA+EHjTxXX_d8M9VGCBokoKCCuvOoR_1u4JrSNKPTdN3qp9bQog@mail.gmail.com>
In-Reply-To: <CA+EHjTxXX_d8M9VGCBokoKCCuvOoR_1u4JrSNKPTdN3qp9bQog@mail.gmail.com>
From: Kalesh Singh <kaleshsingh@google.com>
Date: Mon, 18 Jul 2022 10:09:36 -0700
Message-ID: <CAC_TJvdPwL76o-qE_Tw5R06JPeVLgy5O4nBYia=pzmEjA5dvng@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: Fix hypervisor address symbolization
To: Fuad Tabba <tabba@google.com>
Cc: android-mm@google.com, "Cc: Android Kernel" <kernel-team@android.com>,
 Marc Zyngier <maz@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
 "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>,
 Mark Brown <broonie@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, kvmarm <kvmarm@lists.cs.columbia.edu>,
 "moderated list:ARM64 PORT \(AARCH64 ARCHITECTURE\)"
 <linux-arm-kernel@lists.infradead.org>
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

On Mon, Jul 18, 2022 at 2:08 AM Fuad Tabba <tabba@google.com> wrote:
>
> Hi Kalesh,
>
> On Sat, Jul 16, 2022 at 12:58 AM Kalesh Singh <kaleshsingh@google.com> wrote:
> >
> > With CONFIG_RANDOMIZE_BASE=y vmlinux addresses will resolve correctly
> > from kallsyms. Fix this by adding the KASLR offset before printing the
> > symbols.
> >
> > Based on arm64 for-next/stacktrace.
> >
> > Fixes: 6ccf9cb557bd ("KVM: arm64: Symbolize the nVHE HYP addresses")
> > Reported-by: Fuad Tabba <tabba@google.com>
> > Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
> > ---
>
> Even with this patch applied I still don't get symbolization unless I
> disable randomization, either by setting CONFIG_RANDOMIZE_BASE=n or
> pass nokaslr as a kernel parameter. I tried both and in either case it
> works.

Hi Fuad,

Thanks for testing it. The fix only addressed the symbolization for
the hyp panic address. I plan to fix the symbolization of stacktrace
in the next version of this series.

--Kalesh

>
> Thanks,
> /fuad
>
>
> >  arch/arm64/kvm/handle_exit.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> > index f66c0142b335..e43926ef2bc2 100644
> > --- a/arch/arm64/kvm/handle_exit.c
> > +++ b/arch/arm64/kvm/handle_exit.c
> > @@ -347,10 +347,10 @@ void __noreturn __cold nvhe_hyp_panic_handler(u64 esr, u64 spsr,
> >                         kvm_err("nVHE hyp BUG at: %s:%u!\n", file, line);
> >                 else
> >                         kvm_err("nVHE hyp BUG at: [<%016llx>] %pB!\n", panic_addr,
> > -                                       (void *)panic_addr);
> > +                                       (void *)(panic_addr + kaslr_offset()));
> >         } else {
> >                 kvm_err("nVHE hyp panic at: [<%016llx>] %pB!\n", panic_addr,
> > -                               (void *)panic_addr);
> > +                               (void *)(panic_addr + kaslr_offset()));
> >         }
> >
> >         /*
> >
> > base-commit: 82a592c13b0aeff94d84d54183dae0b26384c95f
> > --
> > 2.37.0.170.g444d1eabd0-goog
> >
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
