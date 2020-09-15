Return-Path: <SRS0=e8ws=CY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 449F0C433E2
	for <kvmarm@archiver.kernel.org>; Tue, 15 Sep 2020 13:01:41 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8488020936
	for <kvmarm@archiver.kernel.org>; Tue, 15 Sep 2020 13:01:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="CBedkHDF"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8488020936
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C3784B1D9;
	Tue, 15 Sep 2020 09:01:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HcqGf2FQfGmr; Tue, 15 Sep 2020 09:01:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8D7FB4B205;
	Tue, 15 Sep 2020 09:01:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 780174B23C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Sep 2020 07:18:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aIoc-L4GDVud for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Sep 2020 07:18:23 -0400 (EDT)
Received: from mail-oi1-f193.google.com (mail-oi1-f193.google.com
 [209.85.167.193])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 846D24B239
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Sep 2020 07:18:23 -0400 (EDT)
Received: by mail-oi1-f193.google.com with SMTP id 185so3371638oie.11
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Sep 2020 04:18:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=vsszHnIr30DAX2BPN/LLCsGS7XfGFhrJzeIuxHrcQeU=;
 b=CBedkHDFIyVGiS3Lx+LWTTvlrVQleDAbgic65e4G96FygTtFkMq914TzMOizRIfuPu
 VCbrwdf+0Q2W/F6W7QKym3P+PeHZw6YQMv459vgtmYNXak396wDwGu+380xAhvQTTE8g
 cWAhxwGXZy9JeRgQPKzXzVW0Ui5AKbuSNXqrDhdPEdIWztw6jdLvOBnhnCGTgBz7ggsZ
 PNDCgLnt2yO51Qj7Jjvh3lTiGwqUVWZRI0yi/SjHdL6/cmqNRv/6Cj9p0MsPaaMHwvdU
 1UD8hq2A8HEs9bROX2DjA+jGrSF1AbVbsvsoY/jZ6vh2Ph2wC0uBgAwS7gblNOLHA+PZ
 ZHhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=vsszHnIr30DAX2BPN/LLCsGS7XfGFhrJzeIuxHrcQeU=;
 b=Vrq1/hKs1b6KElDfyBxI7ysoZfITbCyt/jc8ACFpRGprKkHWowXrNaLNZcIfju+H+K
 0eMMRAWilZaUOucb8/XPJYQbC+WzG2VRDFwg4NrDcHqgU7D7ciD2CwVdzw6GDqLEcEZo
 wR/uS2UoautGIi80tk3yw3P3AHBpNbamxXy9nZB/Lk90fx0nqhHr2J0peB7hej8Ys6iX
 1xIgc225+O6EegsIsQpmFQ8cl0GboMV3/j+e5YyXKeU4a00cHKXeYoXVxFuHZz8JP9LY
 LAXbbW85SXYB4/BCenNSoeeVWUHqY3/T4WS9mtcGFa/zo72fYfIL2hnw4EczJCPsP8A9
 bZ0A==
X-Gm-Message-State: AOAM532XrK0iJ3jYp/N1w138tFtk/hCblqasPXfhyaqMvzXggB3re+a1
 4ImVtB1zbiwmigQkjpVewDf+Bbw9tuyAVyOh6miCEA==
X-Google-Smtp-Source: ABdhPJxxyr3+yo6yQC3hYUIK/C90MlSgyTKxpkX4r5dqGfnI8B0pV1KvA3KhUXz1Pv6WLnJNX2Q1yKRy1KUwXPG9yYM=
X-Received: by 2002:aca:54d1:: with SMTP id i200mr2939948oib.172.1600168702680; 
 Tue, 15 Sep 2020 04:18:22 -0700 (PDT)
MIME-Version: 1.0
References: <20200914172750.852684-1-georgepope@google.com>
 <20200914172750.852684-7-georgepope@google.com>
 <202009141509.CDDC8C8@keescook>
 <20200915102458.GA1650630@google.com>
In-Reply-To: <20200915102458.GA1650630@google.com>
From: Marco Elver <elver@google.com>
Date: Tue, 15 Sep 2020 13:18:11 +0200
Message-ID: <CANpmjNOTcS_vvZ1swh1iHYaRbTvGKnPAe4Q2DpR1MGhk_oZDeA@mail.gmail.com>
Subject: Re: [PATCH 06/14] Fix CFLAGS for UBSAN_BOUNDS on Clang
To: George Popescu <georgepope@google.com>
X-Mailman-Approved-At: Tue, 15 Sep 2020 09:01:37 -0400
Cc: Thomas Gleixner <tglx@linutronix.de>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, maskray@google.com, maz@kernel.org,
 Masahiro Yamada <masahiroy@kernel.org>,
 clang-built-linux <clang-built-linux@googlegroups.com>,
 Linux ARM <linux-arm-kernel@lists.infradead.org>,
 Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>,
 Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, broonie@kernel.org,
 Nathan Chancellor <natechancellor@gmail.com>,
 Dmitry Vyukov <dvyukov@google.com>, Michal Marek <michal.lkml@markovi.net>,
 Nick Desaulniers <ndesaulniers@google.com>,
 LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
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

On Tue, 15 Sep 2020 at 12:25, George Popescu <georgepope@google.com> wrote:
> On Mon, Sep 14, 2020 at 03:13:14PM -0700, Kees Cook wrote:
> > On Mon, Sep 14, 2020 at 05:27:42PM +0000, George-Aurelian Popescu wrote:
> > > From: George Popescu <georgepope@google.com>
> > >
> > > When the kernel is compiled with Clang, UBSAN_BOUNDS inserts a brk after
> > > the handler call, preventing it from printing any information processed
> > > inside the buffer.
> > > For Clang -fsanitize=bounds expands to -fsanitize=array-bounds and
> > > -fsanitize=local-bounds, and the latter adds a brk after the handler
> > > call
> >
> > That sounds like a compiler bug?

> Actually in clang 12 documentation is written that -fsanitize=bounds
> expands to that. GCC  doesn't have those two options, only the
> -fsanitize=bounds which looks similar to -fsanitize=array-bounds from
> clang. So I don't see it as a compiler bug, just a misuse of flags.

Clang just allows to be more selective, but ultimately we want to
cover as many bug-classes as possible. There is little point in giving
up checks with Clang just because GCC doesn't implement them. If there
are other valid reasons to give it up, that's fine, but so far it
seems we never ran into the issue you ran into -- which is also a bit
odd, because I do see in the instrumentation passes that
fsanitize=bounds emits traps sometimes.

[...]
> > >  ifdef CONFIG_UBSAN_BOUNDS
> > > -      CFLAGS_UBSAN += $(call cc-option, -fsanitize=bounds)
> > > +      # For Clang -fsanitize=bounds translates to -fsanitize=array-bounds and
> > > +      # -fsanitize=local-bounds; the latter adds a brk right after the
> > > +      # handler is called.
> > > +      ifdef CONFIG_CC_IS_CLANG
> > > +            CFLAGS_UBSAN += $(call cc-option, -fsanitize=array-bounds)
> >
> > This would mean losing the local-bounds coverage? Isn't that for locally
> > defined arrays on the stack?

> This would mean losing the local-bounds coverage. I tried to  test it without
> local-bounds and with a locally defined array on the stack and it works fine
> (the handler is called and the error reported). For me it feels like
> --array-bounds and --local-bounds are triggered for the same type of
> undefined_behaviours but they are handling them different.

Does -fno-sanitize-trap=bounds help?

Thanks,
-- Marco
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
