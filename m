Return-Path: <SRS0=NdW8=5F=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 655B8C4332E
	for <kvmarm@archiver.kernel.org>; Fri, 20 Mar 2020 09:26:58 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DD71820739
	for <kvmarm@archiver.kernel.org>; Fri, 20 Mar 2020 09:26:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="tbq+fbIO"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DD71820739
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 596584A4A3;
	Fri, 20 Mar 2020 05:26:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xxr5S7JmUL0j; Fri, 20 Mar 2020 05:26:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 58F964A534;
	Fri, 20 Mar 2020 05:26:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 27DA94A4A3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Mar 2020 05:26:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qbRC8qCg0kZg for <kvmarm@lists.cs.columbia.edu>;
 Fri, 20 Mar 2020 05:26:54 -0400 (EDT)
Received: from mail-lj1-f194.google.com (mail-lj1-f194.google.com
 [209.85.208.194])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D87F74A49F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Mar 2020 05:26:53 -0400 (EDT)
Received: by mail-lj1-f194.google.com with SMTP id a2so5641959ljk.6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Mar 2020 02:26:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=Xb2+TkejQMyeRgV2FN7crNaJyjiX8rMU6p7e/O+WXs0=;
 b=tbq+fbIOQCPDoIaCZyKPTLUNOGRkJRUrZkJZAQgonMZpLrWXjWX7Qtc+As8KQ5LXdG
 sTWgnaH15HiCIBzv4PNxsm/oEkGNFwjnF3FFhpvXSm2a0Cxoxbi+DZihSyN5j3+h8RZA
 UJfIbNdNm5vzWcpNFnkp8nIYwubgVmtCTwheuBGl5A1KEQZR2w4QGAul1X4jx6ilWgqq
 e7W+zpYkxhoss0ivMVNoGTH87T4HRNDcMqQ9J+tvCiQOWHZa8Eiqjd0kgx0tQ864WYn9
 jAXVKp5AI3xJmdEDtOJgME9RmxQvtjMvVByhDfeX3DY3a7HmxlcC82UHbIwmjWXnUIH0
 Y5uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=Xb2+TkejQMyeRgV2FN7crNaJyjiX8rMU6p7e/O+WXs0=;
 b=NOHqiBx5RUlZYGDlHGG51bWCOeeE3rhc80uirgOkyZXUeqJ+kYkfWC5br/LjHSxUz6
 lkMxBk9C9UASiJeuA02k2bsITtZFrf0hD/DxJWtyF7i6RfwoEILdU7z3J3Cvv6EOxRY1
 rBg9eKIUP63GWR8uSl+dsjZMoXqiqQJCPiCYXWGIq6WupZscooy1vZpsWyJbNLmlCViT
 1tZ6gMMxKODLAFYNFtnMbyPnvHQ16lqc0ExY5w0hZLsOTF//Vy7IU22cyKNHDGr5rRyK
 SjTzpSZM30jTC6nZZJl/RlCJdfmqTJKxznkse6luOe4u1hcCU7fEF5+urJtTwiciRS2X
 NUdQ==
X-Gm-Message-State: ANhLgQ1SAK+MRbRWRqjGju+mZV3dn4H3ftBUm/K4Jd2i6S56lp2rm25q
 ymSUhfL+9PMVhVZh+2IYRXpobI9qfR2VbOFlpoucmw==
X-Google-Smtp-Source: ADFU+vtuJ0t8Nqq40yxEBdJE/UuZY+X1aSolICR4o1I8kWzUt2hZ40fB2rvEyc9S2cEgGGbq33gRugkfewIJCU8F73I=
X-Received: by 2002:a2e:8ecf:: with SMTP id e15mr4982788ljl.223.1584696412508; 
 Fri, 20 Mar 2020 02:26:52 -0700 (PDT)
MIME-Version: 1.0
References: <20190617221134.9930-1-f.fainelli@gmail.com>
 <20191114181243.q37rxoo3seds6oxy@pengutronix.de>
 <7322163f-e08e-a6b7-b143-e9d59917ee5b@gmail.com>
 <20191115070842.2x7psp243nfo76co@pengutronix.de>
 <20191115114416.ba6lmwb7q4gmepzc@pengutronix.de>
 <60bda4a9-f4f8-3641-2612-17fab3173b29@gmail.com>
 <CACRpkdYJR3gQCb4WXwF4tGzk+tT7jMcV9=nDK0PFkeh+0G11bA@mail.gmail.com>
 <2639dfb0-9e48-cc0f-27e5-34308f790293@gmail.com>
 <CACRpkdZ8JA=DXOxzYwyvBxCMd2Q5uzLTn87AVK7wdrxHFo5ydQ@mail.gmail.com>
 <20200305094328.sizz4vm4wamywdct@pengutronix.de>
In-Reply-To: <20200305094328.sizz4vm4wamywdct@pengutronix.de>
From: Linus Walleij <linus.walleij@linaro.org>
Date: Fri, 20 Mar 2020 10:26:40 +0100
Message-ID: <CACRpkdYzSZY0r=YYiosvi2CA7mia5oiXAWUkbYSqjU1PZ_6w=g@mail.gmail.com>
Subject: Re: [PATCH v6 0/6] KASan for arm
To: Marco Felsch <m.felsch@pengutronix.de>
Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>,
 Michal Hocko <mhocko@suse.com>, Catalin Marinas <catalin.marinas@arm.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 David Howells <dhowells@redhat.com>,
 Masahiro Yamada <yamada.masahiro@socionext.com>,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Alexander Potapenko <glider@google.com>, kvmarm@lists.cs.columbia.edu,
 Florian Fainelli <f.fainelli@gmail.com>, Rob Landley <rob@landley.net>,
 Jonathan Corbet <corbet@lwn.net>, Abbott Liu <liuwenliang@huawei.com>,
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

On Thu, Mar 5, 2020 at 10:44 AM Marco Felsch <m.felsch@pengutronix.de> wrote:
> On 20-03-05 09:43, Linus Walleij wrote:
> > Hi Florian,
> >
> > On Fri, Jan 17, 2020 at 8:55 PM Florian Fainelli <f.fainelli@gmail.com> wrote:
> >
> > > Let me submit and rebase v7 get the auto builders some days to see if it
> > > exposes a new build issue and then we toss it to RMK's patch tracker and
> > > fix bugs from there?
> >
> > Sorry for hammering, can we get some initial patches going into
> > Russell's patch tracker here? I can sign them off and put them in
> > if you don't have time.
>
> I've tested the branch on several imx6 based boards with different
> toolchains. Some boards booting normal and some of them are lost in
> space... I didn't debugged it yet just wanted to inform you.

Hm. I will bring up the KASan stack on more boards.

If the system is anywhere close to being low on memory they
will naturally crash, this is an unavoidable side effect of KASan
or anything else that just chew of a big chunk of memory, that I ran into,
as I was booting from initramfs on very memory
constrained systems.

Yours,
Linus Walleij
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
