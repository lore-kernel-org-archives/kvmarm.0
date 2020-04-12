Return-Path: <SRS0=25CW=54=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AD10C2BA19
	for <kvmarm@archiver.kernel.org>; Sun, 12 Apr 2020 00:33:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0240720CC7
	for <kvmarm@archiver.kernel.org>; Sun, 12 Apr 2020 00:33:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="kV/LeCGT"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0240720CC7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5CDAF4B2F8;
	Sat, 11 Apr 2020 20:33:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id b8lkB10KFkSj; Sat, 11 Apr 2020 20:33:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5936E4B2B2;
	Sat, 11 Apr 2020 20:33:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 484664B2B2
 for <kvmarm@lists.cs.columbia.edu>; Sat, 11 Apr 2020 20:33:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MkWTQwKnCFVC for <kvmarm@lists.cs.columbia.edu>;
 Sat, 11 Apr 2020 20:33:51 -0400 (EDT)
Received: from mail-lf1-f65.google.com (mail-lf1-f65.google.com
 [209.85.167.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1A8764B2AA
 for <kvmarm@lists.cs.columbia.edu>; Sat, 11 Apr 2020 20:33:51 -0400 (EDT)
Received: by mail-lf1-f65.google.com with SMTP id r17so3952432lff.2
 for <kvmarm@lists.cs.columbia.edu>; Sat, 11 Apr 2020 17:33:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=zsyaQJSTyWtQU6SNb3d/B5KGEXk22uVClxXXTgsbd6E=;
 b=kV/LeCGT51tDEQA6jixYwmFJMhwu+sfWPjZdgnLCFvMfPYUoeMciBwTxKz8slhIA9Q
 QWA2SQ0DoEF4KcBJ2ugrGlY6oybNlOP3mTjUj02Wr0RrkcNl2xtc81cOXyImM4uRmfCh
 qHFe6s3jbXCLQZHpY1gfAD4pb0z7WUFQaZtVlYfD3husYMs4QPBsa7IqM7dVgNiBcm0j
 l+CqzwLgWhQyQ6lYBMOXmRaHGTqL3jxOCcQSriocgol9p2VvpZTL7/pWWZWy4UhhPTI8
 w07GlQOHtAFmejubyEhftiSAWmxQa3xOjY0uZlHCLUd6DBp11BdB5BddyZZUhdfxf268
 Yyrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=zsyaQJSTyWtQU6SNb3d/B5KGEXk22uVClxXXTgsbd6E=;
 b=uYhaXBkTltZWXOAiD+8PwBpT14cUTIOc7qW43DPLiU5Y0fKr+i+8gQ4cZHElV5DNLJ
 h6DRmKhM2VfNJtGBCTPQicwPeDFho4CWHBuFc6EfkDL1q32kl1kq119KqxDml6tf/qSO
 J74qdjW9GdTK6baqiblOIE79YQCZJdPmMZNK0CdwIkStSNCyIxjHmRlT/amBbhhTdOP9
 jUr01eTX55Z6HlXqqF5lSCeldce5iZ0Cpbt9S1e39iz15Ja07A0m7NlSwu1a3OEjyONs
 isAgEUN0FL30+OsmJ1dW5eiZ03OTbt1onBldEPFGPRupPO5VsXPa6VqmxDKUxbSoem5v
 QGQw==
X-Gm-Message-State: AGi0PubQ2Ejk6SodA6BCWYjYmJFeykOoHzscWfZV5Ul1M+RTWb3GYm+t
 gj7LFLpgcTTSz+BhtisLKZHl96AG4omjjTL1Ra2rvQ==
X-Google-Smtp-Source: APiQypL4dP3s3w7dYreIWE/U9Pw7ftEq+ZzcH56ILtKHt9LXITsoPKEt+dyrtZrmqSv0ag9Tqx6r+iOrde8l3AYonrY=
X-Received: by 2002:a19:48c3:: with SMTP id v186mr6282470lfa.194.1586651629741; 
 Sat, 11 Apr 2020 17:33:49 -0700 (PDT)
MIME-Version: 1.0
References: <20200117224839.23531-1-f.fainelli@gmail.com>
 <20200117224839.23531-8-f.fainelli@gmail.com>
 <CAKv+Gu_6wWhi418=GpMjfMpE2E+XHbL-DYKT8MJ1jE3+VybrAg@mail.gmail.com>
In-Reply-To: <CAKv+Gu_6wWhi418=GpMjfMpE2E+XHbL-DYKT8MJ1jE3+VybrAg@mail.gmail.com>
From: Linus Walleij <linus.walleij@linaro.org>
Date: Sun, 12 Apr 2020 02:33:38 +0200
Message-ID: <CACRpkdbR2VG422X0-nhOeWtS3Mhm7M1+RKMozBZbg0Jv5c_TTQ@mail.gmail.com>
Subject: Re: [PATCH v7 7/7] ARM: Enable KASan for ARM
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>,
 Michal Hocko <mhocko@suse.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 David Howells <dhowells@redhat.com>,
 Masahiro Yamada <yamada.masahiro@socionext.com>,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Alexander Potapenko <glider@google.com>, kvmarm <kvmarm@lists.cs.columbia.edu>,
 Florian Fainelli <f.fainelli@gmail.com>, Jonathan Corbet <corbet@lwn.net>,
 Abbott Liu <liuwenliang@huawei.com>,
 Daniel Lezcano <daniel.lezcano@linaro.org>,
 Russell King <linux@armlinux.org.uk>, kasan-dev <kasan-dev@googlegroups.com>,
 bcm-kernel-feedback-list <bcm-kernel-feedback-list@broadcom.com>,
 linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
 Geert Uytterhoeven <geert@linux-m68k.org>, Kees Cook <keescook@chromium.org>,
 Arnd Bergmann <arnd@arndb.de>, Marc Zyngier <marc.zyngier@arm.com>,
 Andre Przywara <andre.przywara@arm.com>, Philip Derrin <philip@cog.systems>,
 Jinbum Park <jinb.park7@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
 Dmitry Vyukov <dvyukov@google.com>, Nicolas Pitre <nico@fluxnic.net>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Linux Doc Mailing List <linux-doc@vger.kernel.org>,
 Thomas Garnier <thgarnie@google.com>, Rob Landley <rob@landley.net>,
 Philippe Ombredanne <pombredanne@nexb.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Andrey Ryabinin <ryabinin@virtuozzo.com>,
 "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
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

On Fri, Apr 10, 2020 at 12:45 PM Ard Biesheuvel <ardb@kernel.org> wrote:

> > +CFLAGS_KERNEL          += -D__SANITIZE_ADDRESS__
(...)
> > -                                  $(call cc-option,-mno-single-pic-base)
> > +                                  $(call cc-option,-mno-single-pic-base) \
> > +                                  -D__SANITIZE_ADDRESS__
>
> I am not too crazy about this need to unconditionally 'enable' KASAN
> on the command line like this, in order to be able to disable it again
> when CONFIG_KASAN=y.
>
> Could we instead add something like this at the top of
> arch/arm/boot/compressed/string.c?
>
> #ifdef CONFIG_KASAN
> #undef memcpy
> #undef memmove
> #undef memset
> void *__memcpy(void *__dest, __const void *__src, size_t __n) __alias(memcpy);
> void *__memmove(void *__dest, __const void *__src, size_t count)
> __alias(memmove);
> void *__memset(void *s, int c, size_t count) __alias(memset);
> #endif

I obviously missed this before I sent out my new version of the series.
It bothers me too.

I will try this approach when I prepare the next iteration.

Thanks a lot!

Yours,
Linus Walleij
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
