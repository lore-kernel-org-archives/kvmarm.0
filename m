Return-Path: <SRS0=e8ws=CY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEA60C433E2
	for <kvmarm@archiver.kernel.org>; Tue, 15 Sep 2020 17:45:48 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E9B2020659
	for <kvmarm@archiver.kernel.org>; Tue, 15 Sep 2020 17:45:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="d0JaJ9en"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E9B2020659
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3794D4B2CC;
	Tue, 15 Sep 2020 13:45:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id kT73kcI65-pB; Tue, 15 Sep 2020 13:45:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2CA694B2B7;
	Tue, 15 Sep 2020 13:45:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AF4FA4B24B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Sep 2020 13:32:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6ulmPH1V44aI for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Sep 2020 13:32:41 -0400 (EDT)
Received: from mail-oo1-f66.google.com (mail-oo1-f66.google.com
 [209.85.161.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BB8134B249
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Sep 2020 13:32:41 -0400 (EDT)
Received: by mail-oo1-f66.google.com with SMTP id k13so971357oor.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Sep 2020 10:32:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=PAtDVfuEJhlt1elf5/lgoBo+0AnWtv6A1Q7VC77Ff04=;
 b=d0JaJ9en3sRyhoZPnW1QJJsxEdsVuPco3gIwh9SOrfnk19I2FwZ7GOdGlPhvQTrY1k
 txY0wp2cgnvWub0vDpMs/MJk8Pu0yM9YHo71bPPgXGTmrj9nzguJi8qtik3HijV58bFt
 d2O3luG/WR9UWz1jRPucM/caqSWmjD+RDDJXnr1xoFcys3qOaGdlWvq4ZmxcVwZrx/uI
 ozBsIng1hGBF00/o2vwNEvqKXH5n+W0odVBB5j6WYIu+mwKz8DADLNADAd9ic1lxeC/z
 G1T+PpfVFVmx/i24SgJG/1ndRmiiK8yYYYDVKwOqn1uak0gt53v94/41Wg3i8R6SJtn0
 JVNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=PAtDVfuEJhlt1elf5/lgoBo+0AnWtv6A1Q7VC77Ff04=;
 b=euTqYcYmg19R2qMydFQAHPap4gUMY28TmYNzgSmifoOKtUBjFhA+bEWu9t76WrHs8/
 77/XtVxH+m/gRwI4IR328V6XXP2/3Z1eC8+pHjvfU+jCeJzYmNFc9HaXtHOtD7GrAkT/
 Ws3F6bOQLblaujYiA2DjD2xjQH+kqIWlBQMGYIG20Y0AfvUNwColKAGJbAhvcayajVLk
 anQZ2bFv+uPfdljLs+Q/HbDyH2WdUrYtRTqDiu3FnoxxrADnSUcd43S/d7OIbOjAz4XV
 aIUDFqjZaBvzw8ARTgXBDHDmYcVfZCTzqvpyXhm9NYGHF5tu2UwEYHrTLNTelOieA1rr
 wxtQ==
X-Gm-Message-State: AOAM533F1vouYEDy5EA4wM9d0RUkrv9c9NkncdrgpyP2CMrjeU5tdWBt
 8pYlgo0wKkYW50ftvMrbXFOxJxi+YCvmqUZYdfduOg==
X-Google-Smtp-Source: ABdhPJyCzInxRpJlSmxXfBdbgreenCQjI8gKUscz7zGArVGzNAylhuh/sQNja0PJx+ORauOO7/zkeU7+nZkaJKmgHdU=
X-Received: by 2002:a4a:751a:: with SMTP id j26mr14993283ooc.14.1600191160831; 
 Tue, 15 Sep 2020 10:32:40 -0700 (PDT)
MIME-Version: 1.0
References: <20200914172750.852684-1-georgepope@google.com>
 <20200914172750.852684-7-georgepope@google.com>
 <202009141509.CDDC8C8@keescook>
 <20200915102458.GA1650630@google.com>
 <CANpmjNOTcS_vvZ1swh1iHYaRbTvGKnPAe4Q2DpR1MGhk_oZDeA@mail.gmail.com>
 <20200915120105.GA2294884@google.com>
In-Reply-To: <20200915120105.GA2294884@google.com>
From: Marco Elver <elver@google.com>
Date: Tue, 15 Sep 2020 19:32:28 +0200
Message-ID: <CANpmjNPpq7LfTHYesz2wTVw6Pqv0FQ2gc-vmSB6Mdov+XWPZiw@mail.gmail.com>
Subject: Re: [PATCH 06/14] Fix CFLAGS for UBSAN_BOUNDS on Clang
To: George Popescu <georgepope@google.com>
X-Mailman-Approved-At: Tue, 15 Sep 2020 13:45:45 -0400
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

On Tue, 15 Sep 2020 at 14:01, George Popescu <georgepope@google.com> wrote:
>
> On Tue, Sep 15, 2020 at 01:18:11PM +0200, Marco Elver wrote:
> > On Tue, 15 Sep 2020 at 12:25, George Popescu <georgepope@google.com> wrote:
> > > On Mon, Sep 14, 2020 at 03:13:14PM -0700, Kees Cook wrote:
> > > > On Mon, Sep 14, 2020 at 05:27:42PM +0000, George-Aurelian Popescu wrote:
> > > > > From: George Popescu <georgepope@google.com>
> > > > >
> > > > > When the kernel is compiled with Clang, UBSAN_BOUNDS inserts a brk after
> > > > > the handler call, preventing it from printing any information processed
> > > > > inside the buffer.
> > > > > For Clang -fsanitize=bounds expands to -fsanitize=array-bounds and
> > > > > -fsanitize=local-bounds, and the latter adds a brk after the handler
> > > > > call
> > > >
> > > This would mean losing the local-bounds coverage. I tried to  test it without
> > > local-bounds and with a locally defined array on the stack and it works fine
> > > (the handler is called and the error reported). For me it feels like
> > > --array-bounds and --local-bounds are triggered for the same type of
> > > undefined_behaviours but they are handling them different.
> >
> > Does -fno-sanitize-trap=bounds help?>
>
> I tried replacing it with:
>       ifdef CONFIG_CC_IS_CLANG
>             CFLAGS_UBSAN += $(call cc-option, -fno-sanitize-trap=bounds)
>             CFLAGS_UBSAN += $(call cc-option, -fsanitize=bounds)
>       else
>             CFLAGS_UBSAN += $(call cc-option, -fsanitize=bounds)
>       endif
>
> The code traps.

What's your config? Do you have CONFIG_UBSAN_TRAP=y? If so, you have 2
options: honor UBSAN_TRAP and crash the kernel, or have a
'CFLAGS_REMOVE_... = -fsanitize-undefined-trap-on-error' for the files
where you can't deal with traps.

Thanks,
-- Marco
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
