Return-Path: <SRS0=+Nyp=G4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C86AC433E0
	for <kvmarm@archiver.kernel.org>; Mon, 25 Jan 2021 14:19:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E351423104
	for <kvmarm@archiver.kernel.org>; Mon, 25 Jan 2021 14:19:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E351423104
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7EEFD4B5CD;
	Mon, 25 Jan 2021 09:19:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 54jro8irpdRt; Mon, 25 Jan 2021 09:19:46 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B5C1F4B5E8;
	Mon, 25 Jan 2021 09:19:46 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5ECA64B5D2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Jan 2021 09:19:45 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8J-uUwM0mCqA for <kvmarm@lists.cs.columbia.edu>;
 Mon, 25 Jan 2021 09:19:44 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EDC5D4B5CD
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Jan 2021 09:19:43 -0500 (EST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE63323117
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Jan 2021 14:19:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1611584382;
 bh=LCMQOyJMAQwTuq+WlqxVGMTLi/0FAqvJ22aw194lgxI=;
 h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
 b=DaWR7j1J58mizEgkcag9Hm0dtR0zEiuVG54Cq4GSNqU3PrYSaeJyGJKpopunpiD3v
 SpFsY5e4FIFGro+VG5cYqNSDc683n/pcJbGAcSsMHzUpUhYMsQsANh0i2fooa+2f9W
 /6WQcpFT0cIabnIQ+9F42Vrb7T5Zrd90X0yNaoDhDB2QSmfzaxrXe+IOB330K/iAOs
 9OWUcZirusic7SM/d1qVLXIk6jDTqLFR5YJSpN0hgbc+oQndI5mYl7ZngfCTQ3ovY3
 jxK8ze54Vv2BnJS3r9ONd9NyBUZalC/uTNj8OSdB9WuRp4fkbWxQ+72lfjTUx3E7fn
 DJjocEcPslMmg==
Received: by mail-oi1-f171.google.com with SMTP id j25so9482091oii.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Jan 2021 06:19:42 -0800 (PST)
X-Gm-Message-State: AOAM530CIhKo9o8MKEns7oxlt31TEfcLyJStvbPN5dtgvkdA+liGts3g
 2pCmAcf3PhC3cwMjICU+tvjd4D2sOxPJV5IEw4o=
X-Google-Smtp-Source: ABdhPJycFapm0GSfAYp3s6H/vsGsdUkTreAjs/ReR8YlvArX3N+k02jydV1b6AOhhJ4D/gB22pOmLxNKDK/TRG3ndiA=
X-Received: by 2002:aca:d98a:: with SMTP id q132mr253061oig.33.1611584381829; 
 Mon, 25 Jan 2021 06:19:41 -0800 (PST)
MIME-Version: 1.0
References: <20210125105019.2946057-1-maz@kernel.org>
 <20210125105019.2946057-19-maz@kernel.org>
 <CAMj1kXFcc+0At5+9Keo1MF=TeGE9-eOHtSpK7yVy5jzwXt6KCA@mail.gmail.com>
 <3a98ff1db79c90c96038b924eb534643@kernel.org>
In-Reply-To: <3a98ff1db79c90c96038b924eb534643@kernel.org>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Mon, 25 Jan 2021 15:19:30 +0100
X-Gmail-Original-Message-ID: <CAMj1kXGTu8AtMnm7NxB8M2xFuXHSKzAx2hjjeaAW2v-usvavVQ@mail.gmail.com>
Message-ID: <CAMj1kXGTu8AtMnm7NxB8M2xFuXHSKzAx2hjjeaAW2v-usvavVQ@mail.gmail.com>
Subject: Re: [PATCH v5 18/21] arm64: Move "nokaslr" over to the early
 cpufeature infrastructure
To: Marc Zyngier <maz@kernel.org>
Cc: Prasad Sodagudi <psodagud@codeaurora.org>,
 Srinivas Ramana <sramana@codeaurora.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Ajay Patil <pajay@qti.qualcomm.com>,
 Android Kernel Team <kernel-team@android.com>, Will Deacon <will@kernel.org>,
 kvmarm <kvmarm@lists.cs.columbia.edu>,
 Linux ARM <linux-arm-kernel@lists.infradead.org>
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

On Mon, 25 Jan 2021 at 14:54, Marc Zyngier <maz@kernel.org> wrote:
>
> On 2021-01-25 12:54, Ard Biesheuvel wrote:
> > On Mon, 25 Jan 2021 at 11:53, Marc Zyngier <maz@kernel.org> wrote:
> >>
> >> Given that the early cpufeature infrastructure has borrowed quite
> >> a lot of code from the kaslr implementation, let's reimplement
> >> the matching of the "nokaslr" option with it.
> >>
> >> Signed-off-by: Marc Zyngier <maz@kernel.org>
> >> Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> >> Acked-by: David Brazdil <dbrazdil@google.com>
> >> ---
> >>  arch/arm64/kernel/idreg-override.c | 15 +++++++++++++
> >>  arch/arm64/kernel/kaslr.c          | 36
> >> ++----------------------------
> >>  2 files changed, 17 insertions(+), 34 deletions(-)
> >>
> >> diff --git a/arch/arm64/kernel/idreg-override.c
> >> b/arch/arm64/kernel/idreg-override.c
> >> index cbb8eaa48742..3ccf51b84ba4 100644
> >> --- a/arch/arm64/kernel/idreg-override.c
> >> +++ b/arch/arm64/kernel/idreg-override.c
> >> @@ -31,8 +31,22 @@ static const struct ftr_set_desc mmfr1 __initdata =
> >> {
> >>         },
> >>  };
> >>
> >> +extern struct arm64_ftr_override kaslr_feature_override;
> >> +
> >> +static const struct ftr_set_desc kaslr __initdata = {
> >
> > This should be __initconst not __initdata (below too)
> >
> >> +       .name           = "kaslr",
> >> +#ifdef CONFIG_RANDOMIZE_BASE
> >> +       .override       = &kaslr_feature_override,
> >> +#endif
> >> +       .fields         = {
> >> +               { "disabled", 0 },
> >> +               {}
> >> +       },
> >> +};
> >> +
> >>  static const struct ftr_set_desc * const regs[] __initdata = {
> >>         &mmfr1,
> >> +       &kaslr,
> >>  };
> >>
> >>  static const struct {
> >> @@ -41,6 +55,7 @@ static const struct {
> >>  } aliases[] __initdata = {
> >>         { "kvm-arm.mode=nvhe",          "id_aa64mmfr1.vh=0" },
> >>         { "kvm-arm.mode=protected",     "id_aa64mmfr1.vh=0" },
> >> +       { "nokaslr",                    "kaslr.disabled=1" },
> >>  };
> >>
> >
> > This struct now takes up
> > - ~100 bytes for the characters themselves (which btw are not emitted
> > into __initdata or __initconst)
> > - 6x8 bytes for the char pointers
> > - 6x24 bytes for the RELA relocations that annotate these pointers as
> > quantities that need to be relocated at boot (on a kernel built with
> > KASLR)
> >
> > I know it's only a drop in the ocean, but in this case, where the
> > struct is statically declared and defined only once, and in the same
> > place, we could easily turn this into
> >
> > static const struct {
> >    char alias[24];
> >    char param[20];
> > };
> >
> > and get rid of all the overhead. The only slightly annoying thing is
> > that the array sizes need to be kept in sync with the largest instance
> > appearing in the array, but this is easy when the struct type is
> > declared in the same place where its only instance is defined.
>
> Fair enough. I personally find the result butt-ugly, but I agree
> that it certainly saves some memory. Does the following work for
> you? I can even give symbolic names to the various constants (how
> generous of me! ;-).
>

To be honest, I was anticipating more of a discussion, but this looks
reasonable to me. Does 'char    feature[80];' really need 80 bytes
though?

> diff --git a/arch/arm64/kernel/idreg-override.c
> b/arch/arm64/kernel/idreg-override.c
> index d1310438d95c..9e7043bdc808 100644
> --- a/arch/arm64/kernel/idreg-override.c
> +++ b/arch/arm64/kernel/idreg-override.c
> @@ -14,15 +14,15 @@
>   #include <asm/setup.h>
>
>   struct ftr_set_desc {
> -       const char                      *name;
> +       char                            name[20];
>         struct arm64_ftr_override       *override;
>         struct {
> -               const char              *name;
> +               char                    name[20];
>                 u8                      shift;
>         }                               fields[];
>   };
>
> -static const struct ftr_set_desc mmfr1 __initdata = {
> +static const struct ftr_set_desc mmfr1 __initconst = {
>         .name           = "id_aa64mmfr1",
>         .override       = &id_aa64mmfr1_override,
>         .fields         = {
> @@ -31,7 +31,7 @@ static const struct ftr_set_desc mmfr1 __initdata = {
>         },
>   };
>
> -static const struct ftr_set_desc pfr1 __initdata = {
> +static const struct ftr_set_desc pfr1 __initconst = {
>         .name           = "id_aa64pfr1",
>         .override       = &id_aa64pfr1_override,
>         .fields         = {
> @@ -40,7 +40,7 @@ static const struct ftr_set_desc pfr1 __initdata = {
>         },
>   };
>
> -static const struct ftr_set_desc isar1 __initdata = {
> +static const struct ftr_set_desc isar1 __initconst = {
>         .name           = "id_aa64isar1",
>         .override       = &id_aa64isar1_override,
>         .fields         = {
> @@ -54,7 +54,7 @@ static const struct ftr_set_desc isar1 __initdata = {
>
>   extern struct arm64_ftr_override kaslr_feature_override;
>
> -static const struct ftr_set_desc kaslr __initdata = {
> +static const struct ftr_set_desc kaslr __initconst = {
>         .name           = "kaslr",
>   #ifdef CONFIG_RANDOMIZE_BASE
>         .override       = &kaslr_feature_override,
> @@ -65,7 +65,7 @@ static const struct ftr_set_desc kaslr __initdata = {
>         },
>   };
>
> -static const struct ftr_set_desc * const regs[] __initdata = {
> +static const struct ftr_set_desc * const regs[] __initconst = {
>         &mmfr1,
>         &pfr1,
>         &isar1,
> @@ -73,9 +73,9 @@ static const struct ftr_set_desc * const regs[]
> __initdata = {
>   };
>
>   static const struct {
> -       const char      *alias;
> -       const char      *feature;
> -} aliases[] __initdata = {
> +       char    alias[30];
> +       char    feature[80];
> +} aliases[] __initconst = {
>         { "kvm-arm.mode=nvhe",          "id_aa64mmfr1.vh=0" },
>         { "kvm-arm.mode=protected",     "id_aa64mmfr1.vh=0" },
>         { "arm64.nobti",                "id_aa64pfr1.bt=0" },
>
> --
> Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
