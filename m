Return-Path: <SRS0=ijLG=C2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76AADC433E2
	for <kvmarm@archiver.kernel.org>; Thu, 17 Sep 2020 07:51:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EFE7C21973
	for <kvmarm@archiver.kernel.org>; Thu, 17 Sep 2020 07:51:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="dyKzxUO8"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EFE7C21973
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F01C4B86F;
	Thu, 17 Sep 2020 03:51:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IkO84SpopSH4; Thu, 17 Sep 2020 03:51:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 282894B865;
	Thu, 17 Sep 2020 03:51:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B45474B768
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Sep 2020 02:37:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qHjGuk2eIho1 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 17 Sep 2020 02:37:20 -0400 (EDT)
Received: from mail-oi1-f193.google.com (mail-oi1-f193.google.com
 [209.85.167.193])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 709AF4B741
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Sep 2020 02:37:20 -0400 (EDT)
Received: by mail-oi1-f193.google.com with SMTP id t76so1249277oif.7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Sep 2020 23:37:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=DmH7lVb417eXI2VeqeItQgKBp0xKHSxQ9iYZKyDox1E=;
 b=dyKzxUO8iJ6MybLJ52ubrLm+liYaOMZR++Y5xaNiwrDBw/iA3Nut6Yn841d9KubXm4
 Q/Hnp7VOy43qKf+4ZlHubvF2Hdp9iphzEQCUzgi9oCE+cpXws2VNr6dYgd1yt+hcf7RQ
 ovD/bqaoaPuu0pb0BMYefZ2SPU7qCJy0sih2cTdUHk8AAGVDcnMfHgFBt8oqfzwr2Tu/
 39Gb2P8mjacNiJ31cgYTzquiQCF5rabvKIYewuU8dFzVNMdaMOQ4ZY3kN4zf5tdfOPvX
 yop7vE70Lw2Nlbx3pGduzbVq+QT8e+Xb6ko5Nl4aOdowhMgtb+NGMkJvWPP3h+N08sRH
 J4kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=DmH7lVb417eXI2VeqeItQgKBp0xKHSxQ9iYZKyDox1E=;
 b=jIZu0ogac2wzMDtorkRSax6w/8xyRNM+dgJ1zcz60iFXFJASPvB1vOu+UgqJGBw3kS
 ex8ako4DicdYryFsc67iJM/unaYRgb3KO08nVrARysIg/NzIcuV2QM9axF7KxfYq75Y3
 jvwh6oEOC5CLv1xsJ4ZyjbPVrfoa3tkYiSD4Fr5IZToTgxjDomveMxI/SwZIWDCSD7hO
 pUrGi0OPtDqwrnPdFNo11/9lnHciQgxxcHCy8XBVNmjPEwQBW39EStjz9sJZlG730D3r
 gxKqIA6BW+ny1nfCNtl73SPGwP9TWaKub05easkwpuGneOfhtporsrfgGLXBd/SXxytI
 2jdw==
X-Gm-Message-State: AOAM533WyLJH2uakd6QUAPCUgvXjNtF0CISBInwYSw+irT+OotFOlDrQ
 mid0iAr6lAJ6ua+svuW+oi7ajVLreyDlVEKcr1/Nsw==
X-Google-Smtp-Source: ABdhPJx2jnXpIUmp24nTKDkWxZRLjM1Wslz6+lowH+iNNw8va1V6kY9UCGOGi/uVM7SEkQXpHTIqXCSF8rXYgnPrFO0=
X-Received: by 2002:aca:5158:: with SMTP id f85mr5592894oib.121.1600324639579; 
 Wed, 16 Sep 2020 23:37:19 -0700 (PDT)
MIME-Version: 1.0
References: <20200914172750.852684-1-georgepope@google.com>
 <20200914172750.852684-7-georgepope@google.com>
 <202009141509.CDDC8C8@keescook>
 <20200915102458.GA1650630@google.com>
 <CANpmjNOTcS_vvZ1swh1iHYaRbTvGKnPAe4Q2DpR1MGhk_oZDeA@mail.gmail.com>
 <20200915120105.GA2294884@google.com>
 <CANpmjNPpq7LfTHYesz2wTVw6Pqv0FQ2gc-vmSB6Mdov+XWPZiw@mail.gmail.com>
 <20200916074027.GA2946587@google.com>
 <CANpmjNMT9-a8qKZSvGWBPAb9x9y1DkrZMSvHGq++_TcEv=7AuA@mail.gmail.com>
 <20200916121401.GA3362356@google.com>
 <20200916134029.GA1146904@elver.google.com>
In-Reply-To: <20200916134029.GA1146904@elver.google.com>
From: Marco Elver <elver@google.com>
Date: Thu, 17 Sep 2020 08:37:07 +0200
Message-ID: <CANpmjNOfgeR0zpL-4AtOt0FL56BFZ_sud-mR3CrYB7OCMg0PaA@mail.gmail.com>
Subject: Re: [PATCH 06/14] Fix CFLAGS for UBSAN_BOUNDS on Clang
To: George Popescu <georgepope@google.com>
X-Mailman-Approved-At: Thu, 17 Sep 2020 03:51:33 -0400
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

On Wed, 16 Sep 2020 at 15:40, Marco Elver <elver@google.com> wrote:
> On Wed, Sep 16, 2020 at 12:14PM +0000, George Popescu wrote:
> > On Wed, Sep 16, 2020 at 10:32:40AM +0200, Marco Elver wrote:
> > > On Wed, 16 Sep 2020 at 09:40, George Popescu <georgepope@google.com> wrote:
> > > > On Tue, Sep 15, 2020 at 07:32:28PM +0200, Marco Elver wrote:
> > > > > On Tue, 15 Sep 2020 at 14:01, George Popescu <georgepope@google.com> wrote:
> > > > > > On Tue, Sep 15, 2020 at 01:18:11PM +0200, Marco Elver wrote:
> > > > > > > On Tue, 15 Sep 2020 at 12:25, George Popescu <georgepope@google.com> wrote:
> > > > > > > > On Mon, Sep 14, 2020 at 03:13:14PM -0700, Kees Cook wrote:
> > > > > > > > > On Mon, Sep 14, 2020 at 05:27:42PM +0000, George-Aurelian Popescu wrote:
> > > > > > > > > > From: George Popescu <georgepope@google.com>
> > > > > > > > > >
> > > > > > > > > > When the kernel is compiled with Clang, UBSAN_BOUNDS inserts a brk after
> > > > > > > > > > the handler call, preventing it from printing any information processed
> > > > > > > > > > inside the buffer.
> > > > > > > > > > For Clang -fsanitize=bounds expands to -fsanitize=array-bounds and
> > > > > > > > > > -fsanitize=local-bounds, and the latter adds a brk after the handler
> > > > > > > > > > call
> > > > > > > > >
> > > > > > > > This would mean losing the local-bounds coverage. I tried to  test it without
> > > > > > > > local-bounds and with a locally defined array on the stack and it works fine
> > > > > > > > (the handler is called and the error reported). For me it feels like
> > > > > > > > --array-bounds and --local-bounds are triggered for the same type of
> > > > > > > > undefined_behaviours but they are handling them different.
> > > > > > >
> > > > > > > Does -fno-sanitize-trap=bounds help?
> [...]
> > > Your full config would be good, because it includes compiler version etc.
> > My full config is:
>
> Thanks. Yes, I can reproduce, and the longer I keep digging I start
> wondering why we have local-bounds at all.
>
> It appears that local-bounds finds a tiny subset of the issues that
> KASAN finds:
>
>         http://lists.llvm.org/pipermail/cfe-commits/Week-of-Mon-20131021/091536.html
>         http://llvm.org/viewvc/llvm-project?view=revision&revision=193205
>
> fsanitize=undefined also does not include local-bounds:
>
>         https://clang.llvm.org/docs/UndefinedBehaviorSanitizer.html#available-checks
>
> And the reason is that we do want to enable KASAN and UBSAN together;
> but local-bounds is useless overhead if we already have KASAN.
>
> I'm inclined to say that what you propose is reasonable (but the commit
> message needs to be more detailed explaining the relationship with
> KASAN) -- but I have no idea if this is going to break somebody's
> usecase (e.g. find some OOB bugs, but without KASAN -- but then why not
> use KASAN?!)

So, it seems that local-bounds can still catch some rare OOB accesses,
where KASAN fails to catch it because the access might skip over the
redzone.

The other more interesting bit of history is that
-fsanitize=local-bounds used to be -fbounds-checking, and meant for
production use as a hardening feature:
http://lists.llvm.org/pipermail/llvm-dev/2012-May/049972.html

And local-bounds just does not behave like any other sanitizer as a
result, it just traps. The fact that it's enabled via
-fsanitize=local-bounds (or just bounds) but hasn't much changed in
behaviour is a little unfortunate.

I suppose there are 3 options:

1. George implements trap handling somehow. Is this feasible? If not,
why not? Maybe that should also have been explained in the commit
message.

2. Only enable -fsanitize=local-bounds if UBSAN_TRAP was selected, at
least for as long as Clang traps for local-bounds. I think this makes
sense either way, because if we do not expect UBSAN to trap, it really
should not trap!

3. Change the compiler. As always, this will take a while to implement
and then to reach whoever should have that updated compiler.

Preferences?

Thanks,
-- Marco
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
