Return-Path: <SRS0=ijLG=C2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 895E5C43461
	for <kvmarm@archiver.kernel.org>; Thu, 17 Sep 2020 11:35:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EEDC620795
	for <kvmarm@archiver.kernel.org>; Thu, 17 Sep 2020 11:35:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="MZtwfo2W"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EEDC620795
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2C48E4B308;
	Thu, 17 Sep 2020 07:35:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qtu2Yo56hY9K; Thu, 17 Sep 2020 07:35:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ED2384B345;
	Thu, 17 Sep 2020 07:35:47 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C89D44B30B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Sep 2020 07:35:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eEwXBY0Q78xg for <kvmarm@lists.cs.columbia.edu>;
 Thu, 17 Sep 2020 07:35:45 -0400 (EDT)
Received: from mail-wr1-f66.google.com (mail-wr1-f66.google.com
 [209.85.221.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5EF024B308
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Sep 2020 07:35:45 -0400 (EDT)
Received: by mail-wr1-f66.google.com with SMTP id z1so1698790wrt.3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Sep 2020 04:35:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=EtH4/cbuQgykQYd+jjjiuY8limbLr894Hm1Wfr5TKQE=;
 b=MZtwfo2Wkr6xjMeQYiz0AzKCHXOeKN48g2ul8ghIqc3xiqk9zQf+HOBZ+UHRPpswvD
 9SBgHRwMaFLJDl27uhHNtO8R/rVQPrHwHvld1k1cSpz8o0eAbb3ZsN9tjQpOpqlJKGlW
 GrwSOQnzS9k0pLp3WVTGsfCkX2nwuK4/KULnQidX0PveC+EMFDCZsR5EPDsAU4hnW/C4
 FwjND5Y6WgjF+MR48bLLBhiZwio2a9ADpBpQiFIj+6TTVuegNGnGK+5dwnjCcZZiHSIO
 9G8jASY5hC9NeCi7D/s0svoVNRSESbWKf5XK5jmgjExYi5hfODHSRbI3XH+jyy9nFahP
 i+zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=EtH4/cbuQgykQYd+jjjiuY8limbLr894Hm1Wfr5TKQE=;
 b=nH+IBPSkL9SCpnkrrZUcK0nYNSQjhPNm709MfHAq40bKFbppC64KML3E5dfKG9sevf
 g54kXkB3D1THaF8yn0TXmwS0is/7jMI8sEQlf9WjeIJGbHgSAJIJIoPubuu7+CnIa+1i
 jBPu5+ioAvzvTh8s+0HR38BkJ71SZn7oVcFLiPsVBhFfBGFxcdU9DHQcQwrkTfULbfsg
 /Y/NaapzeJYGpCWrQfeiQzhm4jaBHPX6oJcDtDaDWYMW6X2gjUUV869zK6X4dq7qs44i
 lss1u2AYBNgaFXwFQONx8aG48P5TMOuJcm9Z3vGC8dbky3unRqydApnmbZ3l3VM8GljU
 a8kA==
X-Gm-Message-State: AOAM53345/q3GVXp9Pw1c81IETIYMZlDnk7JuhvXS7dOixkznyywkF4T
 Ed4zcwk9HUVezphBBNSvOlN1tw==
X-Google-Smtp-Source: ABdhPJwAdcQbPsLcZZV58AgYAMNaXQbRRw54r+D+72HaJLI/PEWaAMsAwIznC1PUJ+lKzs+dj/3gLQ==
X-Received: by 2002:adf:df87:: with SMTP id z7mr32658549wrl.239.1600342544219; 
 Thu, 17 Sep 2020 04:35:44 -0700 (PDT)
Received: from google.com (49.222.77.34.bc.googleusercontent.com.
 [34.77.222.49])
 by smtp.gmail.com with ESMTPSA id f14sm10591991wme.22.2020.09.17.04.35.42
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 17 Sep 2020 04:35:42 -0700 (PDT)
Date: Thu, 17 Sep 2020 11:35:40 +0000
From: George Popescu <georgepope@google.com>
To: Marco Elver <elver@google.com>
Subject: Re: [PATCH 06/14] Fix CFLAGS for UBSAN_BOUNDS on Clang
Message-ID: <20200917113540.GA1742660@google.com>
References: <202009141509.CDDC8C8@keescook>
 <20200915102458.GA1650630@google.com>
 <CANpmjNOTcS_vvZ1swh1iHYaRbTvGKnPAe4Q2DpR1MGhk_oZDeA@mail.gmail.com>
 <20200915120105.GA2294884@google.com>
 <CANpmjNPpq7LfTHYesz2wTVw6Pqv0FQ2gc-vmSB6Mdov+XWPZiw@mail.gmail.com>
 <20200916074027.GA2946587@google.com>
 <CANpmjNMT9-a8qKZSvGWBPAb9x9y1DkrZMSvHGq++_TcEv=7AuA@mail.gmail.com>
 <20200916121401.GA3362356@google.com>
 <20200916134029.GA1146904@elver.google.com>
 <CANpmjNOfgeR0zpL-4AtOt0FL56BFZ_sud-mR3CrYB7OCMg0PaA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CANpmjNOfgeR0zpL-4AtOt0FL56BFZ_sud-mR3CrYB7OCMg0PaA@mail.gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Alexander Potapenko <glider@google.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, Fangrui Song <maskray@google.com>,
 maz@kernel.org, Masahiro Yamada <masahiroy@kernel.org>,
 kasan-dev <kasan-dev@googlegroups.com>,
 clang-built-linux <clang-built-linux@googlegroups.com>,
 Linux ARM <linux-arm-kernel@lists.infradead.org>,
 Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>,
 Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
 Andrey Konovalov <andreyknvl@google.com>, broonie@kernel.org,
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

On Thu, Sep 17, 2020 at 08:37:07AM +0200, Marco Elver wrote:
> On Wed, 16 Sep 2020 at 15:40, Marco Elver <elver@google.com> wrote:
> > On Wed, Sep 16, 2020 at 12:14PM +0000, George Popescu wrote:
> > > On Wed, Sep 16, 2020 at 10:32:40AM +0200, Marco Elver wrote:
> > > > On Wed, 16 Sep 2020 at 09:40, George Popescu <georgepope@google.com> wrote:
> > > > > On Tue, Sep 15, 2020 at 07:32:28PM +0200, Marco Elver wrote:
> > > > > > On Tue, 15 Sep 2020 at 14:01, George Popescu <georgepope@google.com> wrote:
> > > > > > > On Tue, Sep 15, 2020 at 01:18:11PM +0200, Marco Elver wrote:
> > > > > > > > On Tue, 15 Sep 2020 at 12:25, George Popescu <georgepope@google.com> wrote:
> > > > > > > > > On Mon, Sep 14, 2020 at 03:13:14PM -0700, Kees Cook wrote:
> > > > > > > > > > On Mon, Sep 14, 2020 at 05:27:42PM +0000, George-Aurelian Popescu wrote:
> > > > > > > > > > > From: George Popescu <georgepope@google.com>
> > > > > > > > > > >
> > > > > > > > > > > When the kernel is compiled with Clang, UBSAN_BOUNDS inserts a brk after
> > > > > > > > > > > the handler call, preventing it from printing any information processed
> > > > > > > > > > > inside the buffer.
> > > > > > > > > > > For Clang -fsanitize=bounds expands to -fsanitize=array-bounds and
> > > > > > > > > > > -fsanitize=local-bounds, and the latter adds a brk after the handler
> > > > > > > > > > > call
> > > > > > > > > >
> > > > > > > > > This would mean losing the local-bounds coverage. I tried to  test it without
> > > > > > > > > local-bounds and with a locally defined array on the stack and it works fine
> > > > > > > > > (the handler is called and the error reported). For me it feels like
> > > > > > > > > --array-bounds and --local-bounds are triggered for the same type of
> > > > > > > > > undefined_behaviours but they are handling them different.
> > > > > > > >
> > > > > > > > Does -fno-sanitize-trap=bounds help?
> > [...]
> > > > Your full config would be good, because it includes compiler version etc.
> > > My full config is:
> >
> > Thanks. Yes, I can reproduce, and the longer I keep digging I start
> > wondering why we have local-bounds at all.
> >
> > It appears that local-bounds finds a tiny subset of the issues that
> > KASAN finds:
> >
> >         http://lists.llvm.org/pipermail/cfe-commits/Week-of-Mon-20131021/091536.html
> >         http://llvm.org/viewvc/llvm-project?view=revision&revision=193205
> >
> > fsanitize=undefined also does not include local-bounds:
> >
> >         https://clang.llvm.org/docs/UndefinedBehaviorSanitizer.html#available-checks
> >
> > And the reason is that we do want to enable KASAN and UBSAN together;
> > but local-bounds is useless overhead if we already have KASAN.
> >
> > I'm inclined to say that what you propose is reasonable (but the commit
> > message needs to be more detailed explaining the relationship with
> > KASAN) -- but I have no idea if this is going to break somebody's
> > usecase (e.g. find some OOB bugs, but without KASAN -- but then why not
> > use KASAN?!)
> 
> So, it seems that local-bounds can still catch some rare OOB accesses,
> where KASAN fails to catch it because the access might skip over the
> redzone.
> 
> The other more interesting bit of history is that
> -fsanitize=local-bounds used to be -fbounds-checking, and meant for
> production use as a hardening feature:
> http://lists.llvm.org/pipermail/llvm-dev/2012-May/049972.html
> 
> And local-bounds just does not behave like any other sanitizer as a
> result, it just traps. The fact that it's enabled via
> -fsanitize=local-bounds (or just bounds) but hasn't much changed in
> behaviour is a little unfortunate.

> I suppose there are 3 options:
> 
> 1. George implements trap handling somehow. Is this feasible? If not,
> why not? Maybe that should also have been explained in the commit
> message.
> 
> 2. Only enable -fsanitize=local-bounds if UBSAN_TRAP was selected, at
> least for as long as Clang traps for local-bounds. I think this makes
> sense either way, because if we do not expect UBSAN to trap, it really
> should not trap!
> 
> 3. Change the compiler. As always, this will take a while to implement
> and then to reach whoever should have that updated compiler.
> 
> Preferences?
Considering of what you said above, I find option 2 the most elegant.
The first one doesn't sound doable for the moment, also the third.
I will edit this patch considering your comments and resend it to the
list.
Thank you for your support.

Thanks,
George


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
