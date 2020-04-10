Return-Path: <SRS0=QOrb=52=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE0F9C2BB85
	for <kvmarm@archiver.kernel.org>; Fri, 10 Apr 2020 11:19:06 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 743B720753
	for <kvmarm@archiver.kernel.org>; Fri, 10 Apr 2020 11:19:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="OTKASfAN"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 743B720753
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1AB194B181;
	Fri, 10 Apr 2020 07:19:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1nj+UCEvIszg; Fri, 10 Apr 2020 07:19:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E9D524B19B;
	Fri, 10 Apr 2020 07:19:02 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CF2884B139
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Apr 2020 06:45:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NR86Cp6fPg9F for <kvmarm@lists.cs.columbia.edu>;
 Fri, 10 Apr 2020 06:45:49 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6BF8A4B13D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Apr 2020 06:45:49 -0400 (EDT)
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com
 [209.85.128.46])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 2A20D214D8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Apr 2020 10:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1586515548;
 bh=UqujX8a43UgZ2wUq7+fHBdtk9fNTH/dOK9O/vJ62NsM=;
 h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
 b=OTKASfANggkF37DxhfvdvwCPeTVJkE4IDlUmSzTKdXah4Elde0A1NoLT3z8pLzf+B
 aGPqOGTJrRgdOS5OX2sB7sklYAOnq5zqlZiHUQ5jNBFdiSaXCOYsPLSc7yKe3WKXg1
 cyRaJgVZRtEAdDkp4vIUasg3udPuVbRYmqYtmDgg=
Received: by mail-wm1-f46.google.com with SMTP id e26so2097560wmk.5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Apr 2020 03:45:48 -0700 (PDT)
X-Gm-Message-State: AGi0Puamf/qJhH2P8rEAVPfIsJKSQ10qiSBTKEwwAK6+jV62CuIgC1Qn
 gmrN+Lj2DKTLcw22PNirueVBA1kQjU1+ca0/iDd6hw==
X-Google-Smtp-Source: APiQypLdUVvA7CnaTTssOnJwPrxl1HW+oM2zu/RKuq6utGp1zVYRYHMkZBBXsZe+0MrT9FW/+152MfO9CABs8P181vo=
X-Received: by 2002:a7b:c050:: with SMTP id u16mr4992457wmc.68.1586515545554; 
 Fri, 10 Apr 2020 03:45:45 -0700 (PDT)
MIME-Version: 1.0
References: <20200117224839.23531-1-f.fainelli@gmail.com>
 <20200117224839.23531-8-f.fainelli@gmail.com>
In-Reply-To: <20200117224839.23531-8-f.fainelli@gmail.com>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Fri, 10 Apr 2020 12:45:34 +0200
X-Gmail-Original-Message-ID: <CAKv+Gu_6wWhi418=GpMjfMpE2E+XHbL-DYKT8MJ1jE3+VybrAg@mail.gmail.com>
Message-ID: <CAKv+Gu_6wWhi418=GpMjfMpE2E+XHbL-DYKT8MJ1jE3+VybrAg@mail.gmail.com>
Subject: Re: [PATCH v7 7/7] ARM: Enable KASan for ARM
To: Florian Fainelli <f.fainelli@gmail.com>
X-Mailman-Approved-At: Fri, 10 Apr 2020 07:19:01 -0400
Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>,
 Michal Hocko <mhocko@suse.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 David Howells <dhowells@redhat.com>,
 Masahiro Yamada <yamada.masahiro@socionext.com>,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Alexander Potapenko <glider@google.com>, kvmarm <kvmarm@lists.cs.columbia.edu>,
 Jonathan Corbet <corbet@lwn.net>, Abbott Liu <liuwenliang@huawei.com>,
 Daniel Lezcano <daniel.lezcano@linaro.org>,
 Russell King <linux@armlinux.org.uk>, kasan-dev <kasan-dev@googlegroups.com>,
 bcm-kernel-feedback-list@broadcom.com, Dmitry Vyukov <dvyukov@google.com>,
 Geert Uytterhoeven <geert@linux-m68k.org>, Kees Cook <keescook@chromium.org>,
 Arnd Bergmann <arnd@arndb.de>, Marc Zyngier <marc.zyngier@arm.com>,
 Andre Przywara <andre.przywara@arm.com>, Philip Derrin <philip@cog.systems>,
 Jinbum Park <jinb.park7@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
 linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
 Nicolas Pitre <nico@fluxnic.net>,
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

On Fri, 17 Jan 2020 at 23:52, Florian Fainelli <f.fainelli@gmail.com> wrote:
>
> From: Andrey Ryabinin <ryabinin@virtuozzo.com>
>
> This patch enables the kernel address sanitizer for ARM. XIP_KERNEL has
> not been tested and is therefore not allowed.
>
> Acked-by: Dmitry Vyukov <dvyukov@google.com>
> Tested-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Abbott Liu <liuwenliang@huawei.com>
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  Documentation/dev-tools/kasan.rst     | 4 ++--
>  arch/arm/Kconfig                      | 9 +++++++++
>  arch/arm/boot/compressed/Makefile     | 1 +
>  drivers/firmware/efi/libstub/Makefile | 3 ++-
>  4 files changed, 14 insertions(+), 3 deletions(-)
>
> diff --git a/Documentation/dev-tools/kasan.rst b/Documentation/dev-tools/kasan.rst
> index e4d66e7c50de..6acd949989c3 100644
> --- a/Documentation/dev-tools/kasan.rst
> +++ b/Documentation/dev-tools/kasan.rst
> @@ -21,8 +21,8 @@ global variables yet.
>
>  Tag-based KASAN is only supported in Clang and requires version 7.0.0 or later.
>
> -Currently generic KASAN is supported for the x86_64, arm64, xtensa and s390
> -architectures, and tag-based KASAN is supported only for arm64.
> +Currently generic KASAN is supported for the x86_64, arm, arm64, xtensa and
> +s390 architectures, and tag-based KASAN is supported only for arm64.
>
>  Usage
>  -----
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index 96dab76da3b3..70a7eb50984e 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -65,6 +65,7 @@ config ARM
>         select HAVE_ARCH_BITREVERSE if (CPU_32v7M || CPU_32v7) && !CPU_32v6
>         select HAVE_ARCH_JUMP_LABEL if !XIP_KERNEL && !CPU_ENDIAN_BE32 && MMU
>         select HAVE_ARCH_KGDB if !CPU_ENDIAN_BE32 && MMU
> +       select HAVE_ARCH_KASAN if MMU && !XIP_KERNEL
>         select HAVE_ARCH_MMAP_RND_BITS if MMU
>         select HAVE_ARCH_SECCOMP_FILTER if AEABI && !OABI_COMPAT
>         select HAVE_ARCH_THREAD_STRUCT_WHITELIST
> @@ -212,6 +213,14 @@ config ARCH_MAY_HAVE_PC_FDC
>  config ZONE_DMA
>         bool
>
> +config KASAN_SHADOW_OFFSET
> +       hex
> +       depends on KASAN
> +       default 0x1f000000 if PAGE_OFFSET=0x40000000
> +       default 0x5f000000 if PAGE_OFFSET=0x80000000
> +       default 0x9f000000 if PAGE_OFFSET=0xC0000000
> +       default 0xffffffff
> +
>  config ARCH_SUPPORTS_UPROBES
>         def_bool y
>
> diff --git a/arch/arm/boot/compressed/Makefile b/arch/arm/boot/compressed/Makefile
> index 83991a0447fa..efda24b00a44 100644
> --- a/arch/arm/boot/compressed/Makefile
> +++ b/arch/arm/boot/compressed/Makefile
> @@ -25,6 +25,7 @@ endif
>
>  GCOV_PROFILE           := n
>  KASAN_SANITIZE         := n
> +CFLAGS_KERNEL          += -D__SANITIZE_ADDRESS__
>
>  # Prevents link failures: __sanitizer_cov_trace_pc() is not linked in.
>  KCOV_INSTRUMENT                := n
> diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
> index c35f893897e1..c8b36824189b 100644
> --- a/drivers/firmware/efi/libstub/Makefile
> +++ b/drivers/firmware/efi/libstub/Makefile
> @@ -20,7 +20,8 @@ cflags-$(CONFIG_ARM64)                := $(subst $(CC_FLAGS_FTRACE),,$(KBUILD_CFLAGS)) \
>                                    -fpie $(DISABLE_STACKLEAK_PLUGIN)
>  cflags-$(CONFIG_ARM)           := $(subst $(CC_FLAGS_FTRACE),,$(KBUILD_CFLAGS)) \
>                                    -fno-builtin -fpic \
> -                                  $(call cc-option,-mno-single-pic-base)
> +                                  $(call cc-option,-mno-single-pic-base) \
> +                                  -D__SANITIZE_ADDRESS__
>

I am not too crazy about this need to unconditionally 'enable' KASAN
on the command line like this, in order to be able to disable it again
when CONFIG_KASAN=y.

Could we instead add something like this at the top of
arch/arm/boot/compressed/string.c?

#ifdef CONFIG_KASAN
#undef memcpy
#undef memmove
#undef memset
void *__memcpy(void *__dest, __const void *__src, size_t __n) __alias(memcpy);
void *__memmove(void *__dest, __const void *__src, size_t count)
__alias(memmove);
void *__memset(void *s, int c, size_t count) __alias(memset);
#endif
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
