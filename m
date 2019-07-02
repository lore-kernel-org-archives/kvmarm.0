Return-Path: <SRS0=95sP=VA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14501C0650E
	for <kvmarm@archiver.kernel.org>; Wed,  3 Jul 2019 07:27:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C450B21897
	for <kvmarm@archiver.kernel.org>; Wed,  3 Jul 2019 07:27:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="chfL2Y+v"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C450B21897
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 747924A4FC;
	Wed,  3 Jul 2019 03:27:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vftYwv4bIQyh; Wed,  3 Jul 2019 03:27:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E7024A4E1;
	Wed,  3 Jul 2019 03:27:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A31414A445
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Jul 2019 17:56:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oBqOQ4aYC3pG for <kvmarm@lists.cs.columbia.edu>;
 Tue,  2 Jul 2019 17:56:51 -0400 (EDT)
Received: from mail-lj1-f193.google.com (mail-lj1-f193.google.com
 [209.85.208.193])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7312F4A2E5
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Jul 2019 17:56:51 -0400 (EDT)
Received: by mail-lj1-f193.google.com with SMTP id 16so129090ljv.10
 for <kvmarm@lists.cs.columbia.edu>; Tue, 02 Jul 2019 14:56:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=uy9P4Bv7MoU15f1hxa9HUk41ddeWB4vxhHhX7nu5AF8=;
 b=chfL2Y+vcu0HLio56W5yCpYcO12fzccTTuvBbkGhkNe/aF5ZgcfKOE24xS40HsFMlc
 Ut8Bz0uCuff4zpfBt474goph+OPSk+NhNQVgLSimuL3/Ah0v11JGh/8rGaKti0yddSiM
 q/0fOfoab+9/DUCSuDVGXRkPBEodmSnVOEGRZxSGePAp5QYIi/4446bzXKyWwa+Z9QVU
 JorSbzfYLEjhFTeRYS7/jv30gSLerU7/hW/VDodF7UL5D3eT6ZP0fWQXg/OaUFUv2/fn
 GcIo0P7LqaWgUcqGlOiipgnrK233+5QeGPJ94GG6q7nHRhDMqNxm2bzPhj2Qys7AxdxL
 UO4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=uy9P4Bv7MoU15f1hxa9HUk41ddeWB4vxhHhX7nu5AF8=;
 b=HasTvhL4+y6kZn9kiXAGx0HxkyNYIw+haD4jEwoK9Y3qh+PzyDzq9UX/21vfrJ4s68
 VdTQXWiars6wMsnCwfrIOcl2wpzkdH2rdRNI2tB3AL+7bbGLZiMihYSEJHcBhglrrbAJ
 8SCmuQ0Yaxi8uVP2ETLZw16YUUuwukqgod774MAf9FwtI4eKzpgoittpZz56twRq/Bte
 GyF/2iYZ9IDyZumywgM2N3mLo85OMkwrEC7sMfEepj0O83AEMS1gKd63F6aOB/ySSFlM
 v3kOL0lKp7SYsYEIJVg98xP1txjhx+1mI7KLIkUnZ7iCu9IwstLCh+QJ1ga+4wqjtHoo
 4HhQ==
X-Gm-Message-State: APjAAAX/JS5PcGMRe9bjDkIbFU4XGnHP/UG+YXfew7BL2GnM1TJFCA5I
 0U43PKGZvPfqrdkIo4pFYxgePWn53p1Dd+lOsc03og==
X-Google-Smtp-Source: APXvYqybYGFXeKm3HudJJDld+RvqFOCnrMTby4Ii2vx9EH9qEyc7WekPspTFOFMLIfLcDmLdtXWyHbCAfNQSt4Z3QxE=
X-Received: by 2002:a2e:8195:: with SMTP id e21mr167967ljg.62.1562104610089;
 Tue, 02 Jul 2019 14:56:50 -0700 (PDT)
MIME-Version: 1.0
References: <20190617221134.9930-1-f.fainelli@gmail.com>
 <20190617221134.9930-3-f.fainelli@gmail.com>
In-Reply-To: <20190617221134.9930-3-f.fainelli@gmail.com>
From: Linus Walleij <linus.walleij@linaro.org>
Date: Tue, 2 Jul 2019 23:56:38 +0200
Message-ID: <CACRpkdb3P6oQTK9FGUkMj4kax8us3rKH6c36pX=HD1_wMqcoJQ@mail.gmail.com>
Subject: Re: [PATCH v6 2/6] ARM: Disable instrumentation for some code
To: Florian Fainelli <f.fainelli@gmail.com>
X-Mailman-Approved-At: Wed, 03 Jul 2019 03:27:53 -0400
Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>, mhocko@suse.com,
 Catalin Marinas <catalin.marinas@arm.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 David Howells <dhowells@redhat.com>,
 Masahiro Yamada <yamada.masahiro@socionext.com>,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Alexander Potapenko <glider@google.com>, kvmarm@lists.cs.columbia.edu,
 Jonathan Corbet <corbet@lwn.net>, Abbott Liu <liuwenliang@huawei.com>,
 Daniel Lezcano <daniel.lezcano@linaro.org>,
 Russell King <linux@armlinux.org.uk>, kasan-dev@googlegroups.com,
 bcm-kernel-feedback-list <bcm-kernel-feedback-list@broadcom.com>,
 Dmitry Vyukov <dvyukov@google.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>,
 Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>,
 Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>,
 philip@cog.systems, jinb.park7@gmail.com, Thomas Gleixner <tglx@linutronix.de>,
 Linux ARM <linux-arm-kernel@lists.infradead.org>,
 Nicolas Pitre <nico@fluxnic.net>, Greg KH <gregkh@linuxfoundation.org>,
 Ard Biesheuvel <ard.biesheuvel@linaro.org>,
 Linux Doc Mailing List <linux-doc@vger.kernel.org>,
 Geert Uytterhoeven <geert@linux-m68k.org>, Rob Landley <rob@landley.net>,
 Philippe Ombredanne <pombredanne@nexb.com>,
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

On Tue, Jun 18, 2019 at 12:11 AM Florian Fainelli <f.fainelli@gmail.com> wrote:

> @@ -236,7 +236,8 @@ static int unwind_pop_register(struct unwind_ctrl_block *ctrl,
>                 if (*vsp >= (unsigned long *)ctrl->sp_high)
>                         return -URC_FAILURE;
>
> -       ctrl->vrs[reg] = *(*vsp)++;
> +       ctrl->vrs[reg] = READ_ONCE_NOCHECK(*(*vsp));
> +       (*vsp)++;

I would probably even put in a comment here so it is clear why we
do this. Passers-by may not know that READ_ONCE_NOCHECK() is
even related to KASan.

Other than that,
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
