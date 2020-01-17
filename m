Return-Path: <SRS0=hOah=3G=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7180C33CB8
	for <kvmarm@archiver.kernel.org>; Fri, 17 Jan 2020 10:13:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 579D124653
	for <kvmarm@archiver.kernel.org>; Fri, 17 Jan 2020 10:13:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="JZtAPVZY"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 579D124653
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B5CA14B218;
	Fri, 17 Jan 2020 05:13:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ttbGdzr+XtxD; Fri, 17 Jan 2020 05:13:48 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0CDD04B208;
	Fri, 17 Jan 2020 05:13:48 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 72D844B203
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jan 2020 05:13:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wf6U9brS6oXY for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Jan 2020 05:13:43 -0500 (EST)
Received: from mail-lj1-f194.google.com (mail-lj1-f194.google.com
 [209.85.208.194])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 17CC44B1FF
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jan 2020 05:13:43 -0500 (EST)
Received: by mail-lj1-f194.google.com with SMTP id a13so25868273ljm.10
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jan 2020 02:13:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=5Jhg4+UAB/mfmS/kvRrF2GKzyf6Tn27Jkcr+2SRy5OE=;
 b=JZtAPVZYG36wekyZYFjYNz63EBXhO9thOFOWavIBZaF6brqIuhH4QmJ/RyadxDwpF0
 tqgFwvmRZU0d+6gq48nDYrfnWBrIl3KOTVFbOF61H5AArNOBt1AibiaQIjhbyQC/WHxx
 sOODAD9I5mWn8l27u+y/scXSDEhjqTKzIRFMwxzcYLbaMMGOccVWGfbBWhocsqUwR6oq
 RemQe435CNyIhBtHlQ7mcxMtfEMn3o1ymJjbc7YMxccJ5nsZwkBdmzi7ZDN+5mhbKkSN
 TwPEwzfhUp+wIdlP/gLVlMTVYunVs+iJ2ljt5qt6juxEuO8jex7ENFPo0JSlG56g2Aiz
 uy6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=5Jhg4+UAB/mfmS/kvRrF2GKzyf6Tn27Jkcr+2SRy5OE=;
 b=nHIRNE4lRzD6XZNAw1LTd/F2Os5N4Fb/hWqL5SQctHceqZwLtio5JwDK2m3727gzkt
 UZ1qebszsI3QnKGkICgQ/36+P8HBY0A/VYGqg8YLQZjNLXpfHP0r+yn5Kq+gsBVoiagw
 doC5dL8h4EXemj1AIqlyOx6z8ANJ0dgtxxJMJ0G8x1EeT3xPBitQaA0fnZo3X6N2fz7u
 5Slc15AH0cALerCb0KQyH3l3X9eMxzpXTWJqnIUvlOqRALbSrNzAVXUpkWeMn9q0btOM
 OfEvXsG61qExRQ100YlJ6T0hgIZepPgDX8DumpyQkAEBxUfdogGRprVUwzMuXRXiDiQM
 KScw==
X-Gm-Message-State: APjAAAXf7w4Z27pXPrny9+RWxLx8So+bRi1ce+Dce7mJh6uddCEATaIv
 I0jjq6BnE853Vj9SDE2dI8/0uF1RtZepwAq+2hUG7Q==
X-Google-Smtp-Source: APXvYqwMboC6xc8+uyhTbyFk+OuGSIgc+KbllCY1pv69DqczX6VA3ZVNZ98GcDj4lK4WjnF/z3/hoHDiXYy2YV86J+4=
X-Received: by 2002:a2e:918c:: with SMTP id f12mr5288808ljg.66.1579256021661; 
 Fri, 17 Jan 2020 02:13:41 -0800 (PST)
MIME-Version: 1.0
References: <20190617221134.9930-1-f.fainelli@gmail.com>
 <20191114181243.q37rxoo3seds6oxy@pengutronix.de>
 <7322163f-e08e-a6b7-b143-e9d59917ee5b@gmail.com>
 <20191115070842.2x7psp243nfo76co@pengutronix.de>
 <20191115114416.ba6lmwb7q4gmepzc@pengutronix.de>
 <60bda4a9-f4f8-3641-2612-17fab3173b29@gmail.com>
In-Reply-To: <60bda4a9-f4f8-3641-2612-17fab3173b29@gmail.com>
From: Linus Walleij <linus.walleij@linaro.org>
Date: Fri, 17 Jan 2020 11:13:30 +0100
Message-ID: <CACRpkdYJR3gQCb4WXwF4tGzk+tT7jMcV9=nDK0PFkeh+0G11bA@mail.gmail.com>
Subject: Re: [PATCH v6 0/6] KASan for arm
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>,
 Michal Hocko <mhocko@suse.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Marco Felsch <m.felsch@pengutronix.de>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 David Howells <dhowells@redhat.com>,
 Masahiro Yamada <yamada.masahiro@socionext.com>,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Alexander Potapenko <glider@google.com>, kvmarm@lists.cs.columbia.edu,
 Rob Landley <rob@landley.net>, Jonathan Corbet <corbet@lwn.net>,
 Abbott Liu <liuwenliang@huawei.com>,
 Daniel Lezcano <daniel.lezcano@linaro.org>,
 Russell King <linux@armlinux.org.uk>, kasan-dev <kasan-dev@googlegroups.com>,
 bcm-kernel-feedback-list <bcm-kernel-feedback-list@broadcom.com>,
 Linux ARM <linux-arm-kernel@lists.infradead.org>,
 Geert Uytterhoeven <geert@linux-m68k.org>, Kees Cook <keescook@chromium.org>,
 Arnd Bergmann <arnd@arndb.de>, Marc Zyngier <marc.zyngier@arm.com>,
 Andre Przywara <andre.przywara@arm.com>, philip@cog.systems,
 Jinbum Park <jinb.park7@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
 Dmitry Vyukov <dvyukov@google.com>, Nicolas Pitre <nico@fluxnic.net>,
 Greg KH <gregkh@linuxfoundation.org>,
 Ard Biesheuvel <ard.biesheuvel@linaro.org>,
 Linux Doc Mailing List <linux-doc@vger.kernel.org>,
 Sascha Hauer <kernel@pengutronix.de>,
 Philippe Ombredanne <pombredanne@nexb.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Thomas Garnier <thgarnie@google.com>,
 "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
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

On Tue, Nov 19, 2019 at 1:14 AM Florian Fainelli <f.fainelli@gmail.com> wrote:
> On 11/15/19 3:44 AM, Marco Felsch wrote:
> >
> > With your v7 it is working on my imx6 but unfortunately I can't run my
> > gstreamer testcase. My CPU load goes to 100% after starting gstreamer
> > and nothing happens.. But the test_kasan module works =) So I decided to
> > check a imx6quadplus but this target did not boot.. I used another
> > toolchain for the imx6quadplus gcc-9 instead of gcc-8. So it seems that
> > something went wrong during compilation. Because you didn't changed
> > something within the logic.
> >
> > I wonder why we must not define the CONFIG_KASAN_SHADOW_OFFSET for arm.
>
> That is was oversight. I have pushed updates to the branch here:
>
> https://github.com/ffainelli/linux/pull/new/kasan-v7

I just git Kasan back on my radar because it needs to be fixed some day.

I took this branch for a ride on some QEMU and some real hardware.
Here I use the test module and just hacked it into the kernel instead of
as a module, it then crashes predictably but performs all the KASan
tests first and it works file, as in provokes the right warnings from
KASan.

Tested systems:

QEMU ARM RealView PBA8
QEMU ARM RealView PBX A9
QEMU ARM Versatile AB
Hardware Integrator CP
Hardware Versatile AB with IB2

Can we start to submit these patches to Russell's patch tracker?
Any more testing I should be doing?

Yours,
Linus Walleij
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
