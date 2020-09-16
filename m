Return-Path: <SRS0=cLXx=CZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1AC9C2BB84
	for <kvmarm@archiver.kernel.org>; Wed, 16 Sep 2020 09:01:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DDB7E20738
	for <kvmarm@archiver.kernel.org>; Wed, 16 Sep 2020 09:01:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="PS2WB70x"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DDB7E20738
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 56A9D4B377;
	Wed, 16 Sep 2020 05:01:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Ar8L2rU6ACtK; Wed, 16 Sep 2020 05:01:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9CC4C4B3B1;
	Wed, 16 Sep 2020 05:01:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E88434B2F6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Sep 2020 04:32:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IcXz5NrkGIjI for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Sep 2020 04:32:53 -0400 (EDT)
Received: from mail-ot1-f66.google.com (mail-ot1-f66.google.com
 [209.85.210.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 16A014B1B2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Sep 2020 04:32:53 -0400 (EDT)
Received: by mail-ot1-f66.google.com with SMTP id m12so5959606otr.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Sep 2020 01:32:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=gutnwyq/fY1R+B0kj3zMSfdQMIw4d9tjzY6YslUPxq0=;
 b=PS2WB70x9ySf7kxgHgUr09U5FuNJgjvgaH7MMVEi0w25wj+geORkHkwqZc6VzcevOQ
 hCiEAnLVhUXjSlfOS/9LyAWzsln3c5crRxRoQqAuBiTozsIvZrtIZiM8OPXSSAy9Vae7
 OMDs11gtOlkCkG/6Uw/jn9znWaF+uoVU/C8MX31oKa9yxTGAe460K1qfCI8awGr7H8z3
 6k+OgXFK6UAPvAOVBG0ab6JFxnyX6o+ajKqqqNU8mHtleCW4IaanfL2KUVXoPA9N90ZA
 qgRYedd2f9Q0CTxAQi3665Ew2/NkBkKd0kVGjtH4Awdg11uBiQ484d2fJCsAhk4O2Zlx
 Meug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=gutnwyq/fY1R+B0kj3zMSfdQMIw4d9tjzY6YslUPxq0=;
 b=PU+PZd+duBQ5Jb1KeCdqHdncFKYXtKg3n4h70cUFWkBcwrivKSn22bGRdxABCk/gX4
 GMUhgBRaY4co9qBZRyJa6WpT8G1SGjQHBi2iGc4DMthC/BvdSfYF5xw1JrnsKfqJtKR4
 Nx45AOtWSQOmOybLSb/VhdLuZ52pIr/PKhYPZ/1DcmgaL4U5Ziir1MRdiczW5yH7RKn5
 UlsU7ZdJhjdHz3J/xGIsW/MjeVvMKzC+9kLXos+lC9oAX80exXFlY8CA47phhJHWu1E1
 WOXeDnKqfHWScmXt7NAK/MuIHu1/RpIbWeeqCtfMSz3thKBhd/FVb6AzMACSTTiJPSxX
 qr1w==
X-Gm-Message-State: AOAM531ezzdSQym5vCkRv/a4adFCc8zhDGO6bSJB1Q/puIbAucY0gXXh
 dkQnTWsRI+fcS4UGoFcMTqv237vVbL5TLscGx20Fdw==
X-Google-Smtp-Source: ABdhPJwe6y4pKih3pRHaHK/yYYM4kOk8WdhzR+Jnvf9pdfuOu3tT6QfG19o4rzngArJRA/kONhSAKRQW+ccjYcRX+jI=
X-Received: by 2002:a05:6830:1e8c:: with SMTP id
 n12mr16510993otr.17.1600245172173; 
 Wed, 16 Sep 2020 01:32:52 -0700 (PDT)
MIME-Version: 1.0
References: <20200914172750.852684-1-georgepope@google.com>
 <20200914172750.852684-7-georgepope@google.com>
 <202009141509.CDDC8C8@keescook>
 <20200915102458.GA1650630@google.com>
 <CANpmjNOTcS_vvZ1swh1iHYaRbTvGKnPAe4Q2DpR1MGhk_oZDeA@mail.gmail.com>
 <20200915120105.GA2294884@google.com>
 <CANpmjNPpq7LfTHYesz2wTVw6Pqv0FQ2gc-vmSB6Mdov+XWPZiw@mail.gmail.com>
 <20200916074027.GA2946587@google.com>
In-Reply-To: <20200916074027.GA2946587@google.com>
From: Marco Elver <elver@google.com>
Date: Wed, 16 Sep 2020 10:32:40 +0200
Message-ID: <CANpmjNMT9-a8qKZSvGWBPAb9x9y1DkrZMSvHGq++_TcEv=7AuA@mail.gmail.com>
Subject: Re: [PATCH 06/14] Fix CFLAGS for UBSAN_BOUNDS on Clang
To: George Popescu <georgepope@google.com>
X-Mailman-Approved-At: Wed, 16 Sep 2020 05:01:11 -0400
Cc: Thomas Gleixner <tglx@linutronix.de>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, Fangrui Song <maskray@google.com>,
 maz@kernel.org, Masahiro Yamada <masahiroy@kernel.org>,
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

On Wed, 16 Sep 2020 at 09:40, George Popescu <georgepope@google.com> wrote:
>
> On Tue, Sep 15, 2020 at 07:32:28PM +0200, Marco Elver wrote:
> > On Tue, 15 Sep 2020 at 14:01, George Popescu <georgepope@google.com> wrote:
> > >
> > > On Tue, Sep 15, 2020 at 01:18:11PM +0200, Marco Elver wrote:
> > > > On Tue, 15 Sep 2020 at 12:25, George Popescu <georgepope@google.com> wrote:
> > > > > On Mon, Sep 14, 2020 at 03:13:14PM -0700, Kees Cook wrote:
> > > > > > On Mon, Sep 14, 2020 at 05:27:42PM +0000, George-Aurelian Popescu wrote:
> > > > > > > From: George Popescu <georgepope@google.com>
> > > > > > >
> > > > > > > When the kernel is compiled with Clang, UBSAN_BOUNDS inserts a brk after
> > > > > > > the handler call, preventing it from printing any information processed
> > > > > > > inside the buffer.
> > > > > > > For Clang -fsanitize=bounds expands to -fsanitize=array-bounds and
> > > > > > > -fsanitize=local-bounds, and the latter adds a brk after the handler
> > > > > > > call
> > > > > >
> > > > > This would mean losing the local-bounds coverage. I tried to  test it without
> > > > > local-bounds and with a locally defined array on the stack and it works fine
> > > > > (the handler is called and the error reported). For me it feels like
> > > > > --array-bounds and --local-bounds are triggered for the same type of
> > > > > undefined_behaviours but they are handling them different.
> > > >
> > > > Does -fno-sanitize-trap=bounds help?>
> > >
> > > I tried replacing it with:
> > >       ifdef CONFIG_CC_IS_CLANG
> > >             CFLAGS_UBSAN += $(call cc-option, -fno-sanitize-trap=bounds)
> > >             CFLAGS_UBSAN += $(call cc-option, -fsanitize=bounds)
> > >       else
> > >             CFLAGS_UBSAN += $(call cc-option, -fsanitize=bounds)
> > >       endif
> > >
> > > The code traps.
> >
> > What's your config? Do you have CONFIG_UBSAN_TRAP=y? If so, you have 2
> > options: honor UBSAN_TRAP and crash the kernel, or have a
> > 'CFLAGS_REMOVE_... = -fsanitize-undefined-trap-on-error' for the files
> > where you can't deal with traps>
>
> I don't have CONFIG_UBSAN_TRAP=y. My .config is:
> CONFIG_ARCH_HAS_UBSAN_SANITIZE_ALL=y
> CONFIG_UBSAN=y
> # CONFIG_UBSAN_TRAP is not set
> CONFIG_UBSAN_KCOV_BROKEN=y
> CONFIG_UBSAN_MISC=y
> CONFIG_UBSAN_SANITIZE_ALL=y
> # CONFIG_UBSAN_ALIGNMENT is not set
> CONFIG_TEST_UBSAN=m

Your full config would be good, because it includes compiler version etc.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
