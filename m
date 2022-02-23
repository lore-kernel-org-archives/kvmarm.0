Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 651CCC433F5
	for <kvmarm@archiver.kernel.org>; Wed, 23 Feb 2022 12:57:18 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0A7564C4FC;
	Wed, 23 Feb 2022 07:57:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RLY+-O+67Y7I; Wed, 23 Feb 2022 07:57:16 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6997B4C3FA;
	Wed, 23 Feb 2022 07:57:16 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D29814C3CD
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Feb 2022 07:57:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MLqmp+9Q0Z7p for <kvmarm@lists.cs.columbia.edu>;
 Wed, 23 Feb 2022 07:57:13 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 30E924C256
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Feb 2022 07:57:13 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 077DD6148F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Feb 2022 12:57:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BDE0C340F1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Feb 2022 12:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1645621031;
 bh=T3RPLphnpfjwjFji7iWJDHhlKcmc/lW8LSE7GNk2LKQ=;
 h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
 b=oRYCnN+JtWTk+ZS+CT7d6jaqcSPRpUuFonbOK9xP0xB7QUUTpeIRYil0Z6yC0IrpP
 +STyaafk7/Yc//R5yR3Na6Wq8JTsYEQhJulAeoMOY2cxmshWudggYn9SYfYhvPbjqz
 S1XqLyRVOh1UX3uZwyDM/14Yi7HSPfG4EpA2kazhE8+xmwWUoOWTd1WMI99ANMWTg5
 oUulsYyUXWW2XP5os7plGfrs4dIepLnvkI1ZUGsK82KQIbU31vVFcj+qNNgPrdztYc
 n9a+b11/5Pe1Vquy+iQtBZEfvkVQqFxTCFvave+ELkO89WpT/CSxx1FVOJ2uZ5FkkF
 B3pJD/7n4mIIQ==
Received: by mail-yb1-f179.google.com with SMTP id y6so47773558ybc.5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Feb 2022 04:57:11 -0800 (PST)
X-Gm-Message-State: AOAM532zglF9D4KrGwVH9ZEPv+apxZq8822LCXlr1trnFHfzcg1KbVGP
 dDVHunAJW5o+1rPJeCLBzOaeEIDbLZx84gEYNKM=
X-Google-Smtp-Source: ABdhPJwEL3v2n7dXLiGGSxBUDiI1buHwdZ4ctEc1Ksn2/qthjXJ6pwsBtWyB0/G9MaH4qLrswEBFghsg5dkZhl8K2zI=
X-Received: by 2002:a25:e014:0:b0:619:a368:c3b5 with SMTP id
 x20-20020a25e014000000b00619a368c3b5mr27062454ybg.383.1645621030432; Wed, 23
 Feb 2022 04:57:10 -0800 (PST)
MIME-Version: 1.0
References: <20220222165212.2005066-7-kaleshsingh@google.com>
 <202202231727.L621fVgD-lkp@intel.com> <875yp63ptg.wl-maz@kernel.org>
 <YhYpvfZaSjrAtkZp@rli9-dbox> <cb750267af0636c49d2f8aa354f086a5@kernel.org>
In-Reply-To: <cb750267af0636c49d2f8aa354f086a5@kernel.org>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Wed, 23 Feb 2022 13:56:59 +0100
X-Gmail-Original-Message-ID: <CAMj1kXHsNsQXbeeS1zcy+xYA7kSE5apbLpChohfvkABS7Z6jKg@mail.gmail.com>
Message-ID: <CAMj1kXHsNsQXbeeS1zcy+xYA7kSE5apbLpChohfvkABS7Z6jKg@mail.gmail.com>
Subject: Re: [kbuild-all] Re: [PATCH v2 6/9] KVM: arm64: Detect and handle
 hypervisor stack overflows
To: Marc Zyngier <maz@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, llvm@lists.linux.dev,
 Joey Gouly <joey.gouly@arm.com>, Kalesh Singh <kaleshsingh@google.com>,
 Will Deacon <will@kernel.org>, kvmarm <kvmarm@lists.cs.columbia.edu>,
 kernel test robot <lkp@intel.com>, surenb@google.com,
 Android Kernel Team <kernel-team@android.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Peter Collingbourne <pcc@google.com>,
 Linux ARM <linux-arm-kernel@lists.infradead.org>, kbuild-all@lists.01.org,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Philip Li <philip.li@intel.com>, Paolo Bonzini <pbonzini@redhat.com>
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

On Wed, 23 Feb 2022 at 13:54, Marc Zyngier <maz@kernel.org> wrote:
>
> On 2022-02-23 12:34, Philip Li wrote:
> > On Wed, Feb 23, 2022 at 09:16:59AM +0000, Marc Zyngier wrote:
> >> On Wed, 23 Feb 2022 09:05:18 +0000,
> >> kernel test robot <lkp@intel.com> wrote:
> >> >
> >> > Hi Kalesh,
> >> >
> >> > Thank you for the patch! Perhaps something to improve:
> >> >
> >> > [auto build test WARNING on cfb92440ee71adcc2105b0890bb01ac3cddb8507]
> >> >
> >> > url:    https://github.com/0day-ci/linux/commits/Kalesh-Singh/KVM-arm64-Hypervisor-stack-enhancements/20220223-010522
> >> > base:   cfb92440ee71adcc2105b0890bb01ac3cddb8507
> >> > config: arm64-randconfig-r011-20220221 (https://download.01.org/0day-ci/archive/20220223/202202231727.L621fVgD-lkp@intel.com/config)
> >> > compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project d271fc04d5b97b12e6b797c6067d3c96a8d7470e)
> >> > reproduce (this is a W=1 build):
> >> >         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
> >> >         chmod +x ~/bin/make.cross
> >> >         # install arm64 cross compiling tool for clang build
> >> >         # apt-get install binutils-aarch64-linux-gnu
> >> >         # https://github.com/0day-ci/linux/commit/7fe99fd40f7c4b2973218045ca5b9c9160524db1
> >> >         git remote add linux-review https://github.com/0day-ci/linux
> >> >         git fetch --no-tags linux-review Kalesh-Singh/KVM-arm64-Hypervisor-stack-enhancements/20220223-010522
> >> >         git checkout 7fe99fd40f7c4b2973218045ca5b9c9160524db1
> >> >         # save the config file to linux build tree
> >> >         mkdir build_dir
> >> >         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=arm64 SHELL=/bin/bash arch/arm64/
> >> >
> >> > If you fix the issue, kindly add following tag as appropriate
> >> > Reported-by: kernel test robot <lkp@intel.com>
> >> >
> >> > All warnings (new ones prefixed by >>):
> >> >
> >> >    include/linux/stddef.h:8:14: note: expanded from macro 'NULL'
> >> >    #define NULL ((void *)0)
> >> >                 ^~~~~~~~~~~
> >> >    arch/arm64/kvm/hyp/nvhe/switch.c:200:27: warning: initializer overrides prior initialization of this subobject [-Winitializer-overrides]
> >> >            [ESR_ELx_EC_FP_ASIMD]           = kvm_hyp_handle_fpsimd,
> >> >                                              ^~~~~~~~~~~~~~~~~~~~~
> >> >    arch/arm64/kvm/hyp/nvhe/switch.c:196:28: note: previous initialization is here
> >> >            [0 ... ESR_ELx_EC_MAX]          = NULL,
> >> >                                              ^~~~
> >> >    include/linux/stddef.h:8:14: note: expanded from macro 'NULL'
> >> >    #define NULL ((void *)0)
> >> >                 ^~~~~~~~~~~
> >>
> >> Kalesh, please ignore this nonsense. There may be things to improve,
> >> but this is *NOT* one of them.
> >>
> >> These reports are pretty useless, and just lead people to ignore real
> >> bug reports.
> >
> > Hi Kalesh, sorry there're some irrelevant issues mixed in the report,
> > kindly ignore them. And the valuable ones are the new ones that
> > prefixed by >>, as the below one in original report.
> >
> >>> arch/arm64/kvm/hyp/nvhe/switch.c:372:17: warning: no previous
> >>> prototype for function 'hyp_panic_bad_stack' [-Wmissing-prototypes]
> >    void __noreturn hyp_panic_bad_stack(void)
> >                    ^
>
> This is only called from assembly code, so a prototype wouldn't bring
> much.
>

Should probably be marked as 'asmlinkage' then. I've suggested many
times already that this bogus diagnostic should either be disabled, or
disregard 'asmlinkage' symbols.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
