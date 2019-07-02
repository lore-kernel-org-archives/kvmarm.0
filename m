Return-Path: <SRS0=95sP=VA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80F8FC5B578
	for <kvmarm@archiver.kernel.org>; Wed,  3 Jul 2019 07:27:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EB6E221881
	for <kvmarm@archiver.kernel.org>; Wed,  3 Jul 2019 07:27:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="WU9xE1Va"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EB6E221881
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3628D4A32E;
	Wed,  3 Jul 2019 03:27:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3WdPKIqSBy1W; Wed,  3 Jul 2019 03:27:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 184B44A4E6;
	Wed,  3 Jul 2019 03:27:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 562224A4CD
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Jul 2019 17:04:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oDoM0FiLVn5l for <kvmarm@lists.cs.columbia.edu>;
 Tue,  2 Jul 2019 17:04:03 -0400 (EDT)
Received: from mail-lf1-f65.google.com (mail-lf1-f65.google.com
 [209.85.167.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 24C784A2E5
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Jul 2019 17:04:03 -0400 (EDT)
Received: by mail-lf1-f65.google.com with SMTP id 62so117394lfa.8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 02 Jul 2019 14:04:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=BWuzzOxwUVGbMCvFD/kQRaZgbqg2U0ttqAGoU0tIxDc=;
 b=WU9xE1VaEDXdGOfDOaQ8eCNlTBcxHe1uPjWOXfL0akhUDkfR9pYxvy2vkEDfni+c8h
 WMVK/5ptG9BAQJtthbU9xhXp41aX/dRI7O6DGRbzSic+KQYV4r79fr3F33IPwBk4A9/w
 GB0kyYoceOYaI2Zwrbm6QbIM8AP0naUmdNCuQ2tAPmooOIqjVKYIIcMIkgONM7r947bm
 Rcb/3dBlykiu3KSgumMs5axcfx87QLCZKcPVy2M8OzJauDqJh5Z1Bo7FTS75GRY0iu0+
 IdLBkAJI8wJkTgpnoj96Ri0vBe8IfwgD2+EBl9ikgM/r7w39QRdydkoW0ChmAqm5YMzc
 LsVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=BWuzzOxwUVGbMCvFD/kQRaZgbqg2U0ttqAGoU0tIxDc=;
 b=ixapQrAeELynVa2ecmkwHJC1OI4K8zPzITe94ZLkrRF38NNFCTqYsMFUj2lD9+nCJA
 4Gvt4QZmZntMuMYkZ2DB0A2uhS1CQMHX4VxnEg3MIFVXIPvnq2uaVCme7dqR9XCL5zBh
 7hqERrmUZo+W712D7iTI+J0jobKwJRI5RgpXdieX9O1NpMLdrnODydN8VvKGyq4taIsY
 0H9A6emI9svytusFx01EEiMfoV5+Q3OGsbASOJajmU611gtODN4cvnSCBWxdnBk85Cg9
 Omsm+FFA6pUIwJ8JQL8VM0Ee3Vm7YmYv7m/Ovx1ZfDqS3JQ2V7U/vnUrtkqI8gHtKniG
 cfog==
X-Gm-Message-State: APjAAAViReJ/Kxtm5vDkPli78tPuwrxPUAOzb9ZG7hRpZuqLSrohK4e1
 4YhgFaYXXEI6dgF67BsODDcPU2+o5sSVg2n77wBa6A==
X-Google-Smtp-Source: APXvYqxPy3MzRImB1p5uGBTXdcSHdB32SVAS4jpsrlLbMd+boV/5IuiNLeQxCDIw30/585vq93owljYh5YviaC4jL+c=
X-Received: by 2002:a19:dc0d:: with SMTP id t13mr1324771lfg.152.1562101441838; 
 Tue, 02 Jul 2019 14:04:01 -0700 (PDT)
MIME-Version: 1.0
References: <20190617221134.9930-1-f.fainelli@gmail.com>
 <20190617221134.9930-2-f.fainelli@gmail.com>
In-Reply-To: <20190617221134.9930-2-f.fainelli@gmail.com>
From: Linus Walleij <linus.walleij@linaro.org>
Date: Tue, 2 Jul 2019 23:03:50 +0200
Message-ID: <CACRpkdZGqiiax2m5L1y3=Enw0Q5cLc-idAQNae34uenf-drHDw@mail.gmail.com>
Subject: Re: [PATCH v6 1/6] ARM: Add TTBR operator for kasan_init
To: Florian Fainelli <f.fainelli@gmail.com>,
 Russell King <rmk+kernel@armlinux.org.uk>
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

Hi Florian!

thanks for your patch!

On Tue, Jun 18, 2019 at 12:11 AM Florian Fainelli <f.fainelli@gmail.com> wrote:

> From: Abbott Liu <liuwenliang@huawei.com>
>
> The purpose of this patch is to provide set_ttbr0/get_ttbr0 to
> kasan_init function. The definitions of cp15 registers should be in
> arch/arm/include/asm/cp15.h rather than arch/arm/include/asm/kvm_hyp.h,
> so move them.
>
> Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
> Reported-by: Marc Zyngier <marc.zyngier@arm.com>
> Signed-off-by: Abbott Liu <liuwenliang@huawei.com>
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

> +#include <linux/stringify.h>

What is this for? I think it can be dropped.

This stuff adding a whole bunch of accessors:

> +static inline void set_par(u64 val)
> +{
> +       if (IS_ENABLED(CONFIG_ARM_LPAE))
> +               write_sysreg(val, PAR_64);
> +       else
> +               write_sysreg(val, PAR_32);
> +}

Can we put that in a separate patch since it is not
adding any users, so this is a pure refactoring patch for
the current code?

Yours,
Linus Walleij
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
