Return-Path: <SRS0=hOah=3G=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E0A6C33C9E
	for <kvmarm@archiver.kernel.org>; Fri, 17 Jan 2020 21:05:48 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 67B2C20684
	for <kvmarm@archiver.kernel.org>; Fri, 17 Jan 2020 21:05:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="cHQbz9Me"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 67B2C20684
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 84DCE4B0FC;
	Fri, 17 Jan 2020 16:05:46 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PP6+sYzreXHj; Fri, 17 Jan 2020 16:05:42 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4CCD14B161;
	Fri, 17 Jan 2020 16:05:42 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 114024B158
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jan 2020 16:05:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Sll1FZSvUBvU for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Jan 2020 16:05:36 -0500 (EST)
Received: from mail-lj1-f195.google.com (mail-lj1-f195.google.com
 [209.85.208.195])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DA7314B0FC
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jan 2020 16:05:35 -0500 (EST)
Received: by mail-lj1-f195.google.com with SMTP id j1so27814490lja.2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jan 2020 13:05:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=ZBkS9S8oFTr7ty1NIiAX5JrGRHx/96iPY51B8fxdR2Y=;
 b=cHQbz9MerebtnThsNe1yZb3HrtSTeIETgYrDu7Q6ONNqX19PijFVSf1lIzu4QilAmq
 hnzwI7P9xI2x5Nd23oDV61kz+2bLOlRlL10WS0JzuDLyURLzzSJmFejdlEtxX62vduXq
 TpK3nS16M0AtekVAN7KXLTgm+8OVHS0eXGhicVmwjML/hqokK/cH4dVEcUKTav6rGeHG
 F2mggp9KMtiE0o776HZy0j2hC+yCq9L9owGloa+hAahvM5W8iEcIFR2imdSPMy3FtcK2
 qu8VkJVvrJS72NCEqvK6tJF2u/4NncgSSpbA7HFFqnczDZ/uro6Wxu9pbLQt70yvz9qn
 t7xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=ZBkS9S8oFTr7ty1NIiAX5JrGRHx/96iPY51B8fxdR2Y=;
 b=ExjpE9Ry54kTq09G1vbgPjc2gMMQk7yNQCdS+lHPzzDJWruGht56oavn/GDBT1uo21
 aw3nbkLFDsJrlhS1eEzz1GKFWOdPaH55JGH1irJA3ZhGJ6oRew4B3cySmXaNgcuZIweI
 gOfkpbrW33a1pXCi8fGE7Q9/KfaCMr970FjZyLV6WGrkR1b86/ponNkATtkQoImEKFiA
 gIqoog7cVn6qdn51dUSrxSTPAoTAA3CHOzULDeruCNE0g1MPtM6teKJYol4kGbe1CPTC
 yYCvvRO8Ye2/1imOd4QgYCXW5iiKS8NKQr4pQuNeGkjGyEOo/HXRE/eRakq3POvQbziy
 NUeQ==
X-Gm-Message-State: APjAAAWa7NPuAelXs4ubMN0itiNfuoBRiHeoQYalMaSG3j17V1KXgauq
 sfaOpGK/584ypcOz8a8xICInPhHolNW2xOtqLk8hxg==
X-Google-Smtp-Source: APXvYqwUSECeAUfn+Q3aKc4hgEvhvTGDwKPCeuq5cHdmTnCOCRP0mwkFi9O47FkIodi5rljBhCBu+PmnCppplmipwMc=
X-Received: by 2002:a2e:9143:: with SMTP id q3mr6695400ljg.199.1579295134552; 
 Fri, 17 Jan 2020 13:05:34 -0800 (PST)
MIME-Version: 1.0
References: <20190617221134.9930-1-f.fainelli@gmail.com>
 <20191114181243.q37rxoo3seds6oxy@pengutronix.de>
 <7322163f-e08e-a6b7-b143-e9d59917ee5b@gmail.com>
 <20191115070842.2x7psp243nfo76co@pengutronix.de>
 <20191115114416.ba6lmwb7q4gmepzc@pengutronix.de>
 <60bda4a9-f4f8-3641-2612-17fab3173b29@gmail.com>
 <CACRpkdYJR3gQCb4WXwF4tGzk+tT7jMcV9=nDK0PFkeh+0G11bA@mail.gmail.com>
 <2639dfb0-9e48-cc0f-27e5-34308f790293@gmail.com>
In-Reply-To: <2639dfb0-9e48-cc0f-27e5-34308f790293@gmail.com>
From: Linus Walleij <linus.walleij@linaro.org>
Date: Fri, 17 Jan 2020 22:05:23 +0100
Message-ID: <CACRpkdYs-jeYO+8avOryJnXdWsB9AkPy7Q5FRQ1gGC1NU35MHA@mail.gmail.com>
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

On Fri, Jan 17, 2020 at 8:55 PM Florian Fainelli <f.fainelli@gmail.com> wrote:

> [Me]
> > Can we start to submit these patches to Russell's patch tracker?
> > Any more testing I should be doing?
>
> Let me submit and rebase v7 get the auto builders some days to see if it
> exposes a new build issue and then we toss it to RMK's patch tracker and
> fix bugs from there?

OK you can add my Tested-by: Linus Walleij <linus.walleij@linaro.org>
to the patches.

Thanks,
Linus Walleij
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
