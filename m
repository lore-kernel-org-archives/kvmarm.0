From: Riku Voipio <riku.voipio@linaro.org>
Subject: Re: [PATCH 1/2] Makefile: allow overriding CFLAGS on the command line
Date: Wed, 4 Nov 2015 12:02:23 +0200
Message-ID: <CAAqcGHk=TMzmtAqAvy5q2XEkY0uf=49N-NX11BnSUv6zHfMwCw@mail.gmail.com>
References: <1446225650-19710-1-git-send-email-andre.przywara@arm.com>
 <1446225650-19710-2-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BDC2A4985B
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Nov 2015 04:59:12 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8hM+2Yz85J3r for <kvmarm@lists.cs.columbia.edu>;
 Wed,  4 Nov 2015 04:59:11 -0500 (EST)
Received: from mail-wi0-f182.google.com (mail-wi0-f182.google.com
 [209.85.212.182])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 66A36497E0
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Nov 2015 04:59:11 -0500 (EST)
Received: by wicll6 with SMTP id ll6so28499793wic.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 04 Nov 2015 02:02:23 -0800 (PST)
In-Reply-To: <1446225650-19710-2-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andre Przywara <andre.przywara@arm.com>
Cc: Will Deacon <will.deacon@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 30 October 2015 at 19:20, Andre Przywara <andre.przywara@arm.com> wrote:
> When a Makefile variable is set on the make command line, all
> Makefile-internal assignments to that very variable are _ignored_.
> Since we add quite some essential values to CFLAGS internally,
> specifying some CFLAGS on the command line will usually break the
> build (and not fix any include file problems you hoped to overcome
> with that).
> Somewhat against intuition GNU make provides the "override" directive
> to change this behavior; with that assignments in the Makefile get
> _appended_ to the value given on the command line. [1]
>
> Change any internal assignments to use that directive, so that a user
> can use:
> $ make CFLAGS=/path/to/my/include/dir
> to teach kvmtool about non-standard header file locations (helpful
> for cross-compilation) or to tweak other compiler options.
>
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>
> [1] https://www.gnu.org/software/make/manual/html_node/Override-Directive.html
> ---
>  Makefile | 15 +++++++--------
>  1 file changed, 7 insertions(+), 8 deletions(-)
>
> diff --git a/Makefile b/Makefile
> index f8f7cc4..77a7c9f 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -15,9 +15,7 @@ include config/utilities.mak
>  include config/feature-tests.mak
>
>  CC     := $(CROSS_COMPILE)gcc
> -CFLAGS :=
>  LD     := $(CROSS_COMPILE)ld
> -LDFLAGS        :=

This breaks builds of debian packages as dpkg-buildpackage sets LDFLAGS
to something unsuitable for guest init.

Looks like this has been an issue before:

commit 57fa349a9792a629e4ed2d89e1309cc96dcc39af
Author: Will Deacon <will.deacon@arm.com>
Date:   Thu Jun 4 16:25:36 2015 +0100

    Don't inherit CFLAGS and LDFLAGS from the environment

    kvmtool doesn't build with arbitrary flags, so let's clear CFLAGS and
    LDFLAGS by default at the top of the Makefile, allowing people to add
    additional options there if they really want to.

    Reported by Dave Jones, who ended up passing -std=gnu99 by mistake.

I think it's better to have EXTRA_CFLAGS and EXTRA_LDFLAGS like the kernel
has.

>  FIND   := find
>  CSCOPE := cscope
> @@ -162,7 +160,7 @@ ifeq ($(ARCH), arm)
>         OBJS            += arm/aarch32/kvm-cpu.o
>         ARCH_INCLUDE    := $(HDRS_ARM_COMMON)
>         ARCH_INCLUDE    += -Iarm/aarch32/include
> -       CFLAGS          += -march=armv7-a
> +       override CFLAGS += -march=armv7-a
>
>         ARCH_WANT_LIBFDT := y
>  endif
> @@ -274,12 +272,12 @@ endif
>  ifeq ($(LTO),1)
>         FLAGS_LTO := -flto
>         ifeq ($(call try-build,$(SOURCE_HELLO),$(CFLAGS),$(FLAGS_LTO)),y)
> -               CFLAGS          += $(FLAGS_LTO)
> +               override CFLAGS += $(FLAGS_LTO)
>         endif
>  endif
>
>  ifeq ($(call try-build,$(SOURCE_STATIC),,-static),y)
> -       CFLAGS          += -DCONFIG_GUEST_INIT
> +       override CFLAGS += -DCONFIG_GUEST_INIT
>         GUEST_INIT      := guest/init
>         GUEST_OBJS      = guest/guest_init.o
>         ifeq ($(ARCH_PRE_INIT),)
> @@ -331,7 +329,8 @@ DEFINES     += -DKVMTOOLS_VERSION='"$(KVMTOOLS_VERSION)"'
>  DEFINES        += -DBUILD_ARCH='"$(ARCH)"'
>
>  KVM_INCLUDE := include
> -CFLAGS += $(CPPFLAGS) $(DEFINES) -I$(KVM_INCLUDE) -I$(ARCH_INCLUDE) -O2 -fno-strict-aliasing -g
> +override CFLAGS        += $(CPPFLAGS) $(DEFINES) -I$(KVM_INCLUDE) -I$(ARCH_INCLUDE)
> +override CFLAGS        += -O2 -fno-strict-aliasing -g
>
>  WARNINGS += -Wall
>  WARNINGS += -Wformat=2
> @@ -349,10 +348,10 @@ WARNINGS += -Wvolatile-register-var
>  WARNINGS += -Wwrite-strings
>  WARNINGS += -Wno-format-nonliteral
>
> -CFLAGS += $(WARNINGS)
> +override CFLAGS        += $(WARNINGS)
>
>  ifneq ($(WERROR),0)
> -       CFLAGS += -Werror
> +       override CFLAGS += -Werror
>  endif
>
>  all: $(PROGRAM) $(PROGRAM_ALIAS) $(GUEST_INIT) $(GUEST_PRE_INIT)
> --
> 2.5.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
