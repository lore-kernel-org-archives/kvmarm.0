Return-Path: <SRS0=95sP=VA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02EFAC06511
	for <kvmarm@archiver.kernel.org>; Wed,  3 Jul 2019 07:27:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B29BA21882
	for <kvmarm@archiver.kernel.org>; Wed,  3 Jul 2019 07:27:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="S/9wjNxz"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B29BA21882
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5754A4A503;
	Wed,  3 Jul 2019 03:27:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9wYYDZgTvdSU; Wed,  3 Jul 2019 03:27:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 369AA4A4EB;
	Wed,  3 Jul 2019 03:27:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EB8DC4A4CD
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Jul 2019 17:06:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rARdXCKrRCIk for <kvmarm@lists.cs.columbia.edu>;
 Tue,  2 Jul 2019 17:06:29 -0400 (EDT)
Received: from mail-lj1-f194.google.com (mail-lj1-f194.google.com
 [209.85.208.194])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B34934A2E5
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Jul 2019 17:06:29 -0400 (EDT)
Received: by mail-lj1-f194.google.com with SMTP id 16so5672ljv.10
 for <kvmarm@lists.cs.columbia.edu>; Tue, 02 Jul 2019 14:06:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=16juguPwtTD1vWpUNQpyIYEAEOADqNOzx5F+yEENpfM=;
 b=S/9wjNxzHSQ44lx7QK89mdaRsjoKX1ZHgfg3NuCejeCzRPPew2tWGQF+4K7vlloGvm
 tyN6KUOOcr3VvGxxqoNTkXQVxwWSdgw6rRxyFAtqS2wmE4uIzfvXER5NQaV0WvTgDSO/
 G7CftJYBPlUxgiiZGrDHr7XemlK99J37xqC6ZOicBwBXGmkzZiihRX4yIIpvZp2yFexg
 a7FQYsjQ7dRg4vmj1VZqWbV5+hptW5EvSKIt7hNJxWmqz6RxXpQcQrlL4oP+c+fXuPnm
 JcF2i68p+gi5kx0i/DM9PMGUD2oVxl7Rs4ZjGSg8mLnFJjXxbx6vHt20X8U5l6/jqpk/
 XrvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=16juguPwtTD1vWpUNQpyIYEAEOADqNOzx5F+yEENpfM=;
 b=PYvmR+B6dNGrLJ4105QcE6jIJuIbNrTRyrVF1dcE+zcpctvEv/L7SttCkjlvQ5r94i
 ZR4GRjTOlP+mLQGHAg0CLgycU8DaWpnCV1f8nP6SozEGaMP1wSDqpKu5pned75PRAmpX
 aKIh+boyanahGKiWfxf+McZ/74c+D5kk+qz6atdGxcsxiOwUXnpAHim8XyLNZ4LCzDsO
 DYbfSjetEAOeRA4lcEb2bsan1s5U8TNhklnDy3YJuXONcDHsvJTWMzj0L222RTMxU7m3
 WHaTIwzTXsZdgqX1mIzl2q8qWhnYx41NVO/Abcd9gSA/HMudlytFkytzsny/rXvIcgfA
 wtWA==
X-Gm-Message-State: APjAAAVT2r3SXd4t8OWwe5PGoGipSQcqO/6AlS2zTmJH6wMpuYlGV4jG
 bwUA9D61nolx7spsvL0OSILDqQ9qLiBDAoEVMrbBKg==
X-Google-Smtp-Source: APXvYqzqBXDeMKmpI7HFc6XkzadQ68osH+Li6FhgxXGtJx4NhJW7ZyaamzfpJOk299AcYNEfRxB1ATHZc5WRU8OT9jg=
X-Received: by 2002:a2e:a0cf:: with SMTP id f15mr18775412ljm.180.1562101588459; 
 Tue, 02 Jul 2019 14:06:28 -0700 (PDT)
MIME-Version: 1.0
References: <20190617221134.9930-1-f.fainelli@gmail.com>
In-Reply-To: <20190617221134.9930-1-f.fainelli@gmail.com>
From: Linus Walleij <linus.walleij@linaro.org>
Date: Tue, 2 Jul 2019 23:06:16 +0200
Message-ID: <CACRpkdbqW2kJNdPi6JPupaHA_qRTWG-MsUxeCz0c38MRujOSSA@mail.gmail.com>
Subject: Re: [PATCH v6 0/6] KASan for arm
To: Florian Fainelli <f.fainelli@gmail.com>
X-Mailman-Approved-At: Wed, 03 Jul 2019 03:27:53 -0400
Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>, mhocko@suse.com,
 Catalin Marinas <catalin.marinas@arm.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 David Howells <dhowells@redhat.com>,
 Masahiro Yamada <yamada.masahiro@socionext.com>,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Alexander Potapenko <glider@google.com>, kvmarm@lists.cs.columbia.edu,
 Jonathan Corbet <corbet@lwn.net>, liuwenliang@huawei.com,
 Daniel Lezcano <daniel.lezcano@linaro.org>,
 Russell King <linux@armlinux.org.uk>, kasan-dev@googlegroups.com,
 bcm-kernel-feedback-list <bcm-kernel-feedback-list@broadcom.com>,
 Dmitry Vyukov <dvyukov@google.com>, Geert Uytterhoeven <geert@linux-m68k.org>,
 Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>,
 Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>,
 philip@cog.systems, jinb.park7@gmail.com, Thomas Gleixner <tglx@linutronix.de>,
 Linux ARM <linux-arm-kernel@lists.infradead.org>,
 Nicolas Pitre <nico@fluxnic.net>, Greg KH <gregkh@linuxfoundation.org>,
 Ard Biesheuvel <ard.biesheuvel@linaro.org>,
 Linux Doc Mailing List <linux-doc@vger.kernel.org>,
 Rob Landley <rob@landley.net>, Philippe Ombredanne <pombredanne@nexb.com>,
 Andrew Morton <akpm@linux-foundation.org>, thgarnie@google.com,
 kirill.shutemov@linux.intel.com
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

Hi Florian,

On Tue, Jun 18, 2019 at 12:11 AM Florian Fainelli <f.fainelli@gmail.com> wrote:

> Abbott submitted a v5 about a year ago here:
>
> and the series was not picked up since then, so I rebased it against
> v5.2-rc4 and re-tested it on a Brahma-B53 (ARMv8 running AArch32 mode)
> and Brahma-B15, both LPAE and test-kasan is consistent with the ARM64
> counter part.
>
> We were in a fairly good shape last time with a few different people
> having tested it, so I am hoping we can get that included for 5.4 if
> everything goes well.

Thanks for picking this up. I was trying out KASan in the past,
got sidetracked and honestly lost interest a bit because it was
boring. But I do realize that it is really neat, so I will try to help
out with some review and test on a bunch of hardware I have.

At one point I even had this running on the ARMv4 SA1100
(no joke!) and if I recall correctly, I got stuck because of things
that might very well have been related to using a very fragile
Arm testchip that later broke down completely in the l2cache
when we added the spectre/meltdown fixes.

I start reviewing and testing.

Yours,
Linus Walleij
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
