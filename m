Return-Path: <SRS0=QOrb=52=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDE94C2BBC7
	for <kvmarm@archiver.kernel.org>; Fri, 10 Apr 2020 11:19:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7663320753
	for <kvmarm@archiver.kernel.org>; Fri, 10 Apr 2020 11:19:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="Kp997bcL"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7663320753
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2FD074B1AE;
	Fri, 10 Apr 2020 07:19:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7brgNjowZGxt; Fri, 10 Apr 2020 07:19:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0EF044B1A0;
	Fri, 10 Apr 2020 07:19:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6B1224B139
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Apr 2020 06:47:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sf2Pca6d9zHS for <kvmarm@lists.cs.columbia.edu>;
 Fri, 10 Apr 2020 06:47:36 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4BDEE4B0DD
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Apr 2020 06:47:36 -0400 (EDT)
Received: from mail-io1-f48.google.com (mail-io1-f48.google.com
 [209.85.166.48])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 32FAA214D8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Apr 2020 10:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1586515655;
 bh=U3wmJx6hLjdbpi9nNIeT1fEN5cdk/6ttAPKJ4Brye00=;
 h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
 b=Kp997bcLfABP723lf8fm7ymzoCZy/BOcnjK6rtWodOzvp8kJN74/xyXNE0RPwAZnX
 ipCy6HSzeQykN+E0hK/HgtKDpuccoOP68HJoF4S+4bywrx6uMTA+sziQCSvnmwEMW2
 cym5bSmxRYBoYkThrYRtGNNvsrN8XqromYU8b5eI=
Received: by mail-io1-f48.google.com with SMTP id n10so1380199iom.3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Apr 2020 03:47:35 -0700 (PDT)
X-Gm-Message-State: AGi0PuZCCrwuXyGNCPdObrJ8H65SXZSNSmxmr6U1Wa3b8bkFRbMbwFIr
 BpXSqKW3JBK2Ithf/qutXUflCVCOtTQGw8Swi38=
X-Google-Smtp-Source: APiQypKXvEl7sIHmBvdTO2/Sq82nNedbtcTWI9il5KSUN0FhnjNovFdxXB0laKwHoxVv+x13Op2+8K9kQu7VpjrjlQY=
X-Received: by 2002:a5d:8b57:: with SMTP id c23mr3679119iot.161.1586515654446; 
 Fri, 10 Apr 2020 03:47:34 -0700 (PDT)
MIME-Version: 1.0
References: <20200117224839.23531-1-f.fainelli@gmail.com>
 <20200117224839.23531-8-f.fainelli@gmail.com>
 <CAKv+Gu_6wWhi418=GpMjfMpE2E+XHbL-DYKT8MJ1jE3+VybrAg@mail.gmail.com>
In-Reply-To: <CAKv+Gu_6wWhi418=GpMjfMpE2E+XHbL-DYKT8MJ1jE3+VybrAg@mail.gmail.com>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Fri, 10 Apr 2020 12:47:23 +0200
X-Gmail-Original-Message-ID: <CAMj1kXEmSk6Sq+WPAMc=x=HyP2EzVYbNYjB-4YSLByUurbXa0A@mail.gmail.com>
Message-ID: <CAMj1kXEmSk6Sq+WPAMc=x=HyP2EzVYbNYjB-4YSLByUurbXa0A@mail.gmail.com>
Subject: Re: [PATCH v7 7/7] ARM: Enable KASan for ARM
To: Florian Fainelli <f.fainelli@gmail.com>,
 Linus Walleij <linus.walleij@linaro.org>
X-Mailman-Approved-At: Fri, 10 Apr 2020 07:19:01 -0400
Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>,
 Michal Hocko <mhocko@suse.com>, Catalin Marinas <catalin.marinas@arm.com>,
 David Howells <dhowells@redhat.com>,
 Masahiro Yamada <yamada.masahiro@socionext.com>,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Alexander Potapenko <glider@google.com>, kvmarm <kvmarm@lists.cs.columbia.edu>,
 Jonathan Corbet <corbet@lwn.net>, Abbott Liu <liuwenliang@huawei.com>,
 Daniel Lezcano <daniel.lezcano@linaro.org>,
 Russell King <linux@armlinux.org.uk>, kasan-dev <kasan-dev@googlegroups.com>,
 Geert Uytterhoeven <geert@linux-m68k.org>,
 linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
 bcm-kernel-feedback-list@broadcom.com, Kees Cook <keescook@chromium.org>,
 Arnd Bergmann <arnd@arndb.de>, Marc Zyngier <marc.zyngier@arm.com>,
 Andre Przywara <andre.przywara@arm.com>,
 Philippe Ombredanne <pombredanne@nexb.com>, Jinbum Park <jinb.park7@gmail.com>,
 Thomas Gleixner <tglx@linutronix.de>, Dmitry Vyukov <dvyukov@google.com>,
 Nicolas Pitre <nico@fluxnic.net>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Linux Doc Mailing List <linux-doc@vger.kernel.org>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Andrey Ryabinin <ryabinin@virtuozzo.com>, Rob Landley <rob@landley.net>,
 Philip Derrin <philip@cog.systems>, Andrew Morton <akpm@linux-foundation.org>,
 Thomas Garnier <thgarnie@google.com>,
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

(+ Linus)

On Fri, 10 Apr 2020 at 12:45, Ard Biesheuvel <ardb@kernel.org> wrote:
>
> On Fri, 17 Jan 2020 at 23:52, Florian Fainelli <f.fainelli@gmail.com> wrote:
> >
> > From: Andrey Ryabinin <ryabinin@virtuozzo.com>
> >
> > This patch enables the kernel address sanitizer for ARM. XIP_KERNEL has
> > not been tested and is therefore not allowed.
> >
> > Acked-by: Dmitry Vyukov <dvyukov@google.com>
> > Tested-by: Linus Walleij <linus.walleij@linaro.org>
> > Signed-off-by: Abbott Liu <liuwenliang@huawei.com>
> > Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> > ---
> >  Documentation/dev-tools/kasan.rst     | 4 ++--
> >  arch/arm/Kconfig                      | 9 +++++++++
> >  arch/arm/boot/compressed/Makefile     | 1 +
> >  drivers/firmware/efi/libstub/Makefile | 3 ++-
> >  4 files changed, 14 insertions(+), 3 deletions(-)
> >
> > diff --git a/Documentation/dev-tools/kasan.rst b/Documentation/dev-tools/kasan.rst
> > index e4d66e7c50de..6acd949989c3 100644
> > --- a/Documentation/dev-tools/kasan.rst
> > +++ b/Documentation/dev-tools/kasan.rst
> > @@ -21,8 +21,8 @@ global variables yet.
> >
> >  Tag-based KASAN is only supported in Clang and requires version 7.0.0 or later.
> >
> > -Currently generic KASAN is supported for the x86_64, arm64, xtensa and s390
> > -architectures, and tag-based KASAN is supported only for arm64.
> > +Currently generic KASAN is supported for the x86_64, arm, arm64, xtensa and
> > +s390 architectures, and tag-based KASAN is supported only for arm64.
> >
> >  Usage
> >  -----
> > diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> > index 96dab76da3b3..70a7eb50984e 100644
> > --- a/arch/arm/Kconfig
> > +++ b/arch/arm/Kconfig
> > @@ -65,6 +65,7 @@ config ARM
> >         select HAVE_ARCH_BITREVERSE if (CPU_32v7M || CPU_32v7) && !CPU_32v6
> >         select HAVE_ARCH_JUMP_LABEL if !XIP_KERNEL && !CPU_ENDIAN_BE32 && MMU
> >         select HAVE_ARCH_KGDB if !CPU_ENDIAN_BE32 && MMU
> > +       select HAVE_ARCH_KASAN if MMU && !XIP_KERNEL
> >         select HAVE_ARCH_MMAP_RND_BITS if MMU
> >         select HAVE_ARCH_SECCOMP_FILTER if AEABI && !OABI_COMPAT
> >         select HAVE_ARCH_THREAD_STRUCT_WHITELIST
> > @@ -212,6 +213,14 @@ config ARCH_MAY_HAVE_PC_FDC
> >  config ZONE_DMA
> >         bool
> >
> > +config KASAN_SHADOW_OFFSET
> > +       hex
> > +       depends on KASAN
> > +       default 0x1f000000 if PAGE_OFFSET=0x40000000
> > +       default 0x5f000000 if PAGE_OFFSET=0x80000000
> > +       default 0x9f000000 if PAGE_OFFSET=0xC0000000
> > +       default 0xffffffff
> > +
> >  config ARCH_SUPPORTS_UPROBES
> >         def_bool y
> >
> > diff --git a/arch/arm/boot/compressed/Makefile b/arch/arm/boot/compressed/Makefile
> > index 83991a0447fa..efda24b00a44 100644
> > --- a/arch/arm/boot/compressed/Makefile
> > +++ b/arch/arm/boot/compressed/Makefile
> > @@ -25,6 +25,7 @@ endif
> >
> >  GCOV_PROFILE           := n
> >  KASAN_SANITIZE         := n
> > +CFLAGS_KERNEL          += -D__SANITIZE_ADDRESS__
> >
> >  # Prevents link failures: __sanitizer_cov_trace_pc() is not linked in.
> >  KCOV_INSTRUMENT                := n
> > diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
> > index c35f893897e1..c8b36824189b 100644
> > --- a/drivers/firmware/efi/libstub/Makefile
> > +++ b/drivers/firmware/efi/libstub/Makefile
> > @@ -20,7 +20,8 @@ cflags-$(CONFIG_ARM64)                := $(subst $(CC_FLAGS_FTRACE),,$(KBUILD_CFLAGS)) \
> >                                    -fpie $(DISABLE_STACKLEAK_PLUGIN)
> >  cflags-$(CONFIG_ARM)           := $(subst $(CC_FLAGS_FTRACE),,$(KBUILD_CFLAGS)) \
> >                                    -fno-builtin -fpic \
> > -                                  $(call cc-option,-mno-single-pic-base)
> > +                                  $(call cc-option,-mno-single-pic-base) \
> > +                                  -D__SANITIZE_ADDRESS__
> >
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
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
