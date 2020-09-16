Return-Path: <SRS0=cLXx=CZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E08AC35257
	for <kvmarm@archiver.kernel.org>; Wed, 16 Sep 2020 07:40:37 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 48B762076C
	for <kvmarm@archiver.kernel.org>; Wed, 16 Sep 2020 07:40:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="gjM7bxmS"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 48B762076C
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7ADC94B348;
	Wed, 16 Sep 2020 03:40:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6-+40sE9GeNv; Wed, 16 Sep 2020 03:40:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 752DD4B351;
	Wed, 16 Sep 2020 03:40:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 59CA54B348
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Sep 2020 03:40:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xMi7TTwKNj8S for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Sep 2020 03:40:31 -0400 (EDT)
Received: from mail-wm1-f68.google.com (mail-wm1-f68.google.com
 [209.85.128.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6124C4B345
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Sep 2020 03:40:31 -0400 (EDT)
Received: by mail-wm1-f68.google.com with SMTP id a9so1863590wmm.2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Sep 2020 00:40:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=tqvp+bkIU1TWNlZpwcv+TKRU2X5GojmD5HYurFQV7BY=;
 b=gjM7bxmS6+Hzs07rV/WLqiZ7oypbPZeeynUIbEGf+1I9i5xUZgFTr9pBvxoJKit3lh
 /TC/qQi6Hp2TtnCO/NeCATHt2bkpPA/JZvcO9Wttw2I/Sc/8JV0ACXRCD1k8lq2qSH2u
 xFt8e4VclXK6orUp/sR81UNyuRsBU9CKP69jotta8/o3ZN0y/ATIUSrKa0W8LIOgRy2n
 DkB86wfYPzlKcUglMBue1jJjXIt1v3N2MKI2EvcrO/plB1MItPyrUhAx217Bc/mR4MCH
 vj2Ii+bGg1WlPNB/9eezKaFrqWjQ4uNrrqwZjwW+1wrycv8XxA+imCdxpWXZ+TBspfEU
 cO6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=tqvp+bkIU1TWNlZpwcv+TKRU2X5GojmD5HYurFQV7BY=;
 b=ssdQr4g7PmgTr7SD6VPpeL1Y9LAz/WNh24lYOwD+X6zgBA+kH4HvQ7JwKBpd3YdLtE
 OQJp7x6wBOFDUjUJJF3UJGQ+gNKvPnXg/yVaFM019wBNUzPqKYu0CPjoasHj4pGSoXHR
 j9MZqJf3jzmUZqEBEVSmw8J6ZloHaT4pWozgpy5vgtWgjb2boKL3HXKTieJvPZ3HBm0g
 iXIzg9LpjRH28SkJ6Hrtj0k3x4HAj2Wbl2IeO+o5y9KbcRo6j3XZoVoye2lnIbm4h4Nw
 tN4LK4pFHXTdYd5bjcFMNfEWyxkfHGv0gCGvEImTI4uh6UuUikht3oClGVkaSSrr8zCN
 83eQ==
X-Gm-Message-State: AOAM532ujnZa6DAji1IZ3ot6O6HaonybuzXwNnU1Ix4FVKLwwgIaa8R/
 mNiVBlxWDJnHpTODxG0vvtVx6w==
X-Google-Smtp-Source: ABdhPJx/FHKbG/LfARiaWGrhnM+fErvXhr1oAsC0Dy1+R1K4G2d1MrURncNcx4OJ1k5GECgPKBKUBg==
X-Received: by 2002:a1c:9a57:: with SMTP id c84mr3177066wme.136.1600242029785; 
 Wed, 16 Sep 2020 00:40:29 -0700 (PDT)
Received: from google.com (49.222.77.34.bc.googleusercontent.com.
 [34.77.222.49])
 by smtp.gmail.com with ESMTPSA id u66sm3770553wme.12.2020.09.16.00.40.28
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 16 Sep 2020 00:40:29 -0700 (PDT)
Date: Wed, 16 Sep 2020 07:40:27 +0000
From: George Popescu <georgepope@google.com>
To: Marco Elver <elver@google.com>
Subject: Re: [PATCH 06/14] Fix CFLAGS for UBSAN_BOUNDS on Clang
Message-ID: <20200916074027.GA2946587@google.com>
References: <20200914172750.852684-1-georgepope@google.com>
 <20200914172750.852684-7-georgepope@google.com>
 <202009141509.CDDC8C8@keescook>
 <20200915102458.GA1650630@google.com>
 <CANpmjNOTcS_vvZ1swh1iHYaRbTvGKnPAe4Q2DpR1MGhk_oZDeA@mail.gmail.com>
 <20200915120105.GA2294884@google.com>
 <CANpmjNPpq7LfTHYesz2wTVw6Pqv0FQ2gc-vmSB6Mdov+XWPZiw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CANpmjNPpq7LfTHYesz2wTVw6Pqv0FQ2gc-vmSB6Mdov+XWPZiw@mail.gmail.com>
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

On Tue, Sep 15, 2020 at 07:32:28PM +0200, Marco Elver wrote:
> On Tue, 15 Sep 2020 at 14:01, George Popescu <georgepope@google.com> wrote:
> >
> > On Tue, Sep 15, 2020 at 01:18:11PM +0200, Marco Elver wrote:
> > > On Tue, 15 Sep 2020 at 12:25, George Popescu <georgepope@google.com> wrote:
> > > > On Mon, Sep 14, 2020 at 03:13:14PM -0700, Kees Cook wrote:
> > > > > On Mon, Sep 14, 2020 at 05:27:42PM +0000, George-Aurelian Popescu wrote:
> > > > > > From: George Popescu <georgepope@google.com>
> > > > > >
> > > > > > When the kernel is compiled with Clang, UBSAN_BOUNDS inserts a brk after
> > > > > > the handler call, preventing it from printing any information processed
> > > > > > inside the buffer.
> > > > > > For Clang -fsanitize=bounds expands to -fsanitize=array-bounds and
> > > > > > -fsanitize=local-bounds, and the latter adds a brk after the handler
> > > > > > call
> > > > >
> > > > This would mean losing the local-bounds coverage. I tried to  test it without
> > > > local-bounds and with a locally defined array on the stack and it works fine
> > > > (the handler is called and the error reported). For me it feels like
> > > > --array-bounds and --local-bounds are triggered for the same type of
> > > > undefined_behaviours but they are handling them different.
> > >
> > > Does -fno-sanitize-trap=bounds help?>
> >
> > I tried replacing it with:
> >       ifdef CONFIG_CC_IS_CLANG
> >             CFLAGS_UBSAN += $(call cc-option, -fno-sanitize-trap=bounds)
> >             CFLAGS_UBSAN += $(call cc-option, -fsanitize=bounds)
> >       else
> >             CFLAGS_UBSAN += $(call cc-option, -fsanitize=bounds)
> >       endif
> >
> > The code traps.
> 
> What's your config? Do you have CONFIG_UBSAN_TRAP=y? If so, you have 2
> options: honor UBSAN_TRAP and crash the kernel, or have a
> 'CFLAGS_REMOVE_... = -fsanitize-undefined-trap-on-error' for the files
> where you can't deal with traps> 

I don't have CONFIG_UBSAN_TRAP=y. My .config is:
CONFIG_ARCH_HAS_UBSAN_SANITIZE_ALL=y
CONFIG_UBSAN=y
# CONFIG_UBSAN_TRAP is not set
CONFIG_UBSAN_KCOV_BROKEN=y
CONFIG_UBSAN_MISC=y
CONFIG_UBSAN_SANITIZE_ALL=y
# CONFIG_UBSAN_ALIGNMENT is not set
CONFIG_TEST_UBSAN=m

Thanks,
George
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
