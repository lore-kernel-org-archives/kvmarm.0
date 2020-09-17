Return-Path: <SRS0=ijLG=C2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFFC5C43464
	for <kvmarm@archiver.kernel.org>; Thu, 17 Sep 2020 22:21:54 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3B63D206DB
	for <kvmarm@archiver.kernel.org>; Thu, 17 Sep 2020 22:21:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="ciFNzf+h"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3B63D206DB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8BA4E4B316;
	Thu, 17 Sep 2020 18:21:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@chromium.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KGLW-YZNSauL; Thu, 17 Sep 2020 18:21:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6476A4B2D6;
	Thu, 17 Sep 2020 18:21:52 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 60FF24B27E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Sep 2020 18:21:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OqrbI21SLbvW for <kvmarm@lists.cs.columbia.edu>;
 Thu, 17 Sep 2020 18:21:50 -0400 (EDT)
Received: from mail-pl1-f194.google.com (mail-pl1-f194.google.com
 [209.85.214.194])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2DD734B1E8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Sep 2020 18:21:50 -0400 (EDT)
Received: by mail-pl1-f194.google.com with SMTP id j7so1864561plk.11
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Sep 2020 15:21:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chromium.org; s=google;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=9DPIpM4LW2/8oZNQwQFTEuyuoQvJ/tNgC5mR+LCoUuA=;
 b=ciFNzf+hWaaGAKU6nkGzF1KKLKx3MJ70q8Ni0LPweKihXGvpq6moFu4zD/nw+2Lsu2
 hG7z5Vbe2Fr+pZbcXaXgeQOOcwOSHXdKYdGRyAb3lYBBjHrdV/XrZmxlXYGyh8CQWs4j
 ANuu2VhQPJzyzwyw6dJ3li/I9SmdUgDjG3jzY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=9DPIpM4LW2/8oZNQwQFTEuyuoQvJ/tNgC5mR+LCoUuA=;
 b=WEBoXy2DFIZEg5B6wLnIRt+DG6jDZDkHgY3/mjm0nXPNgorrQ8gTZsFVkbiGFnvvmZ
 a1N2cIeN7+0h6pxzsFiijsTEgRk9rJdcfsQYyZs76XJBBqmJEF4f5pZMMRWB+lGzAC9Q
 eW6G2aKb8xiKhpAIkpTMDfPgHTMMZI/TRuTN4URkoPBxKPBecVav6e1rI1NAaPYcnsgq
 7tVmvHUOajBIysiWkb0pc3GLXYQHzs989alABpj7dG0uGJA22rnylPI/fZ/tUaLSmNxa
 myghWrY0mrxKZ+KvPuE/WQW3jYrUeRYIgVhQEhPCD82nEV0B+satA6oxgGRi5h36dVUW
 30Dw==
X-Gm-Message-State: AOAM530u2liC/OWwamdiL5J0u5+8PHy8WVOdAxpVllPI68EH6EWB0Szr
 RwI4d5ZX+SpTBXUTU7tL1hlQPw==
X-Google-Smtp-Source: ABdhPJwbTUDkLG7CpK2l4q0THRgaxSIQsaFQZa0MeaaJn7k/XwhUlLp3dEUsHAcW8oF24GhOQ/5eBg==
X-Received: by 2002:a17:902:c212:b029:d1:e629:92f4 with SMTP id
 18-20020a170902c212b02900d1e62992f4mr12676668pll.75.1600381309149; 
 Thu, 17 Sep 2020 15:21:49 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
 by smtp.gmail.com with ESMTPSA id m5sm627685pjn.19.2020.09.17.15.21.48
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 17 Sep 2020 15:21:48 -0700 (PDT)
Date: Thu, 17 Sep 2020 15:21:47 -0700
From: Kees Cook <keescook@chromium.org>
To: George Popescu <georgepope@google.com>
Subject: Re: [PATCH 06/14] Fix CFLAGS for UBSAN_BOUNDS on Clang
Message-ID: <202009171519.951D26DB@keescook>
References: <20200915102458.GA1650630@google.com>
 <CANpmjNOTcS_vvZ1swh1iHYaRbTvGKnPAe4Q2DpR1MGhk_oZDeA@mail.gmail.com>
 <20200915120105.GA2294884@google.com>
 <CANpmjNPpq7LfTHYesz2wTVw6Pqv0FQ2gc-vmSB6Mdov+XWPZiw@mail.gmail.com>
 <20200916074027.GA2946587@google.com>
 <CANpmjNMT9-a8qKZSvGWBPAb9x9y1DkrZMSvHGq++_TcEv=7AuA@mail.gmail.com>
 <20200916121401.GA3362356@google.com>
 <20200916134029.GA1146904@elver.google.com>
 <CANpmjNOfgeR0zpL-4AtOt0FL56BFZ_sud-mR3CrYB7OCMg0PaA@mail.gmail.com>
 <20200917113540.GA1742660@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200917113540.GA1742660@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Alexander Potapenko <glider@google.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, Fangrui Song <maskray@google.com>,
 maz@kernel.org, Masahiro Yamada <masahiroy@kernel.org>,
 kasan-dev <kasan-dev@googlegroups.com>,
 clang-built-linux <clang-built-linux@googlegroups.com>,
 Linux ARM <linux-arm-kernel@lists.infradead.org>,
 Marco Elver <elver@google.com>, Arnd Bergmann <arnd@arndb.de>,
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

On Thu, Sep 17, 2020 at 11:35:40AM +0000, George Popescu wrote:
> On Thu, Sep 17, 2020 at 08:37:07AM +0200, Marco Elver wrote:
> > So, it seems that local-bounds can still catch some rare OOB accesses,
> > where KASAN fails to catch it because the access might skip over the
> > redzone.
> > 
> > The other more interesting bit of history is that
> > -fsanitize=local-bounds used to be -fbounds-checking, and meant for
> > production use as a hardening feature:
> > http://lists.llvm.org/pipermail/llvm-dev/2012-May/049972.html
> > 
> > And local-bounds just does not behave like any other sanitizer as a
> > result, it just traps. The fact that it's enabled via
> > -fsanitize=local-bounds (or just bounds) but hasn't much changed in
> > behaviour is a little unfortunate.
> 
> > I suppose there are 3 options:
> > 
> > 1. George implements trap handling somehow. Is this feasible? If not,
> > why not? Maybe that should also have been explained in the commit
> > message.
> > 
> > 2. Only enable -fsanitize=local-bounds if UBSAN_TRAP was selected, at
> > least for as long as Clang traps for local-bounds. I think this makes
> > sense either way, because if we do not expect UBSAN to trap, it really
> > should not trap!
> > 
> > 3. Change the compiler. As always, this will take a while to implement
> > and then to reach whoever should have that updated compiler.
> > 
> > Preferences?
> Considering of what you said above, I find option 2 the most elegant.
> The first one doesn't sound doable for the moment, also the third.
> I will edit this patch considering your comments and resend it to the
> list.

I have a slightly different suggestion that is very nearly #2 above:
split local-bounds into a separate CONFIG that requires UBSAN_TRAP, and
then carefully document both:
- what does it catch that "bounds" doesn't
- why it only operates in trap mode

The rationale I have is that I don't like the coverage of some
mitigation or detection to "silently" vary between builds. e.g. someone
would build with/without UBSAN_TRAP and end up with unexpectedly
different coverage. I'd rather there be a separate CONFIG that appears.

-- 
Kees Cook
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
