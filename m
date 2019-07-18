Return-Path: <SRS0=vMTE=VP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D64F4C76191
	for <kvmarm@archiver.kernel.org>; Thu, 18 Jul 2019 07:51:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 67303208C0
	for <kvmarm@archiver.kernel.org>; Thu, 18 Jul 2019 07:51:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 67303208C0
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arndb.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8F7AF4A56F;
	Thu, 18 Jul 2019 03:51:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id J3xKjlYnuwse; Thu, 18 Jul 2019 03:51:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 87E6D4A570;
	Thu, 18 Jul 2019 03:51:21 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9D7894A56E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Jul 2019 03:51:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QI7mj2vIJ1Pb for <kvmarm@lists.cs.columbia.edu>;
 Thu, 18 Jul 2019 03:51:18 -0400 (EDT)
Received: from mail-qt1-f195.google.com (mail-qt1-f195.google.com
 [209.85.160.195])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8AD5E4A560
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Jul 2019 03:51:18 -0400 (EDT)
Received: by mail-qt1-f195.google.com with SMTP id k10so26261307qtq.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Jul 2019 00:51:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=AMIbdcIyPjXgBsFnQdrxIvDXu584wusUv2Znj2VCflY=;
 b=k6pP16aS5ITMgxfA4YeUfndA8UuuNRaAD7zD2wKB7bdyefg9qe7y5+6kQEFbJxItoy
 g+GmK2dGKSddniKuCwvLunIkVx3U8M2NJjCru3z5D6ZWNJWEJWtTKWrW/bFe6h0bTMFD
 TE3nFTAKQvKR2Z+ZHy3AIzEe6FgBegJ/ynwzDibjQICLPviUargGi+5lUQzmzmmhIFuJ
 4KylvkDCkFOTQJLdOV9RS+qOrhZR6hqY91p3SH+JoUYN/HBebAhU7yDbsR+KwhMeO6do
 B7dOWsahpV2JCORe5LxnHTpw1FlUjE5Y8OV4cxl6YYNBqgtqP0mc8w/BDIhHBLlfjgP4
 pw3Q==
X-Gm-Message-State: APjAAAV3MQD6Kh4jspY8OLz1jggyoXC2uYR/sYyJlU+ZUEQmYgxiDGu4
 HAI/q8SNFkV+A9M3ByOfYCVcuzjbgas7VyT98Ck=
X-Google-Smtp-Source: APXvYqyzjKBdgrNsfXbtaWuBwJsPbX/hOAYTtfb23UeIC61bLsX6rwes0aTlraCVeKg7z22IOXq9fA3u8pg4isBRck0=
X-Received: by 2002:ac8:5311:: with SMTP id t17mr30079223qtn.304.1563436278053; 
 Thu, 18 Jul 2019 00:51:18 -0700 (PDT)
MIME-Version: 1.0
References: <20190617221134.9930-1-f.fainelli@gmail.com>
 <CACRpkdbqW2kJNdPi6JPupaHA_qRTWG-MsUxeCz0c38MRujOSSA@mail.gmail.com>
 <0ba50ae2-be09-f633-ab1f-860e8b053882@broadcom.com>
In-Reply-To: <0ba50ae2-be09-f633-ab1f-860e8b053882@broadcom.com>
From: Arnd Bergmann <arnd@arndb.de>
Date: Thu, 18 Jul 2019 09:51:01 +0200
Message-ID: <CAK8P3a2QBQrBU+bBBL20kR+qJfmspCNjiw05jHTa-q6EDfodMg@mail.gmail.com>
Subject: Re: [PATCH v6 0/6] KASan for arm
To: Florian Fainelli <florian.fainelli@broadcom.com>
Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>,
 Michal Hocko <mhocko@suse.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Linus Walleij <linus.walleij@linaro.org>, David Howells <dhowells@redhat.com>,
 Masahiro Yamada <yamada.masahiro@socionext.com>,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Alexander Potapenko <glider@google.com>, kvmarm@lists.cs.columbia.edu,
 Florian Fainelli <f.fainelli@gmail.com>, Jonathan Corbet <corbet@lwn.net>,
 Abbott Liu <liuwenliang@huawei.com>,
 Daniel Lezcano <daniel.lezcano@linaro.org>,
 Russell King <linux@armlinux.org.uk>, kasan-dev <kasan-dev@googlegroups.com>,
 Geert Uytterhoeven <geert@linux-m68k.org>,
 Linux ARM <linux-arm-kernel@lists.infradead.org>,
 bcm-kernel-feedback-list <bcm-kernel-feedback-list@broadcom.com>,
 Kees Cook <keescook@chromium.org>, Marc Zyngier <marc.zyngier@arm.com>,
 Andre Przywara <andre.przywara@arm.com>,
 Philippe Ombredanne <pombredanne@nexb.com>, Jinbum Park <jinb.park7@gmail.com>,
 Thomas Gleixner <tglx@linutronix.de>, Dmitry Vyukov <dvyukov@google.com>,
 Nicolas Pitre <nico@fluxnic.net>, Greg KH <gregkh@linuxfoundation.org>,
 Ard Biesheuvel <ard.biesheuvel@linaro.org>,
 Linux Doc Mailing List <linux-doc@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Rob Landley <rob@landley.net>, philip@cog.systems,
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

On Thu, Jul 11, 2019 at 7:00 PM Florian Fainelli
<florian.fainelli@broadcom.com> wrote:
> On 7/2/19 2:06 PM, Linus Walleij wrote:

>
> Great, thanks a lot for taking a look. FYI, I will be on holiday from
> July 19th till August 12th, if you think you have more feedback between
> now and then, I can try to pick it up and submit a v7 with that feedback
> addressed, or it will happen when I return, or you can pick it up if you
> refer, all options are possible!
>
> @Arnd, should we squash your patches in as well?

Yes, please do. I don't remember if I sent you all of them already,
here is the list of patches that I have applied locally on top of your
series to get a clean randconfig build:

123c3262f872 KASAN: push back KASAN_STACK to clang-10
d63dd9e2afd9 [HACK] ARM: disable KASAN+XIP_KERNEL
879eb3c22240 kasan: increase 32-bit stack frame warning limit
053555034bdf kasan: disable CONFIG_KASAN_STACK with clang on arm32
6c1a78a448c2 ARM: fix kasan link failures

      Arnd
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
