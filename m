Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 799BFC433F5
	for <kvmarm@archiver.kernel.org>; Fri, 25 Feb 2022 14:59:56 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3537C4BA3C;
	Fri, 25 Feb 2022 09:59:56 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bMjKWpN6RNIm; Fri, 25 Feb 2022 09:59:54 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A7B034BA6A;
	Fri, 25 Feb 2022 09:59:47 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3715B4BB2B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 22:12:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xGv+1TeK5Cug for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Feb 2022 22:12:08 -0500 (EST)
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com
 [209.85.221.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7163B4BB1B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 22:12:08 -0500 (EST)
Received: by mail-wr1-f44.google.com with SMTP id j17so2513324wrc.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 19:12:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=2tXA6AeT/n84QHis5S/egaFq21pdbXEw9XfX//TKVfM=;
 b=c7GYzBUZ9xR/BVJG5gvZgCEJWk3vhp6OQX6HWlS9iuFRLcxYPGbKRSEHM+64LlVY1g
 8xIbBZr9zBJEu7O0NERNKR5d52ZiltX0nnRUgH6OAgMUPcQivl9IpnKHLQGvN62wGriA
 kaUUenhCahjCZ9/EhzF+CSapnzjWiiPFc2iltfDulLHS1VY2pkUuHv8b5rInK+IusWXU
 SVhF1Gmh1MfaLf+S62E0LFzQGLSnTxV2EPxsWoTGrPcFP95/JgZ7mcxX/3PoPAFif7Ro
 qyu9JeOC94XiTIrVVFdNtmrBGN2vNFmJnpxfnWKUnxKVGmb9jS3EdJNWec8tPVaN4ArF
 Q8Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=2tXA6AeT/n84QHis5S/egaFq21pdbXEw9XfX//TKVfM=;
 b=1/B90oIoFiLsYFbHGEFbpaVkt9B3954kP9Hf5SYxdR42RiAGFu4E2v1TDYiffnqb4t
 HnmF4poXDoVdCCjSbWkcyvzXXBwpisTRfxnXsPwwTUzy9UyuXIYo1i+cqIqoq8r0aZCG
 Fk4IfCsLjJuuwauU2qBM2ax5W61AZFMj+kS5jDvmSjTIH7mtV8Ti6AVWVEv7hs6k5COe
 AgwPNbdEjRyzqndoW+MiKgWZTYkgLLlwAnkURHyNdjmoPxy726IzDcWTWVT7X/U/jlS8
 6Vo94nUzbt/jySzVp7Ov908VAxvcdPnf4vHcg2kKwf6dXGmghbXNrBMlblI58FpbseLF
 YPng==
X-Gm-Message-State: AOAM532achsfiR84jqP5yHmKPzmeOUpDYwlVXv3p7sfjYbRdUdBR4oYT
 q6peFjlFHvM30zEP66YBdSxD5cIRu82Pr3a7L/ovqw==
X-Google-Smtp-Source: ABdhPJxpp13+Gj6zLNHG/fdOzoKqtaJB14AbGDQVpFLIsU1SU8SdTUT1E0oKQs51V54e00SfilVyzOkbf0DXzqyfito=
X-Received: by 2002:adf:ca08:0:b0:1ed:c0bc:c212 with SMTP id
 o8-20020adfca08000000b001edc0bcc212mr4359347wrh.577.1645758727122; Thu, 24
 Feb 2022 19:12:07 -0800 (PST)
MIME-Version: 1.0
References: <20220222165212.2005066-7-kaleshsingh@google.com>
 <202202231727.L621fVgD-lkp@intel.com> <875yp63ptg.wl-maz@kernel.org>
 <YhYpvfZaSjrAtkZp@rli9-dbox> <cb750267af0636c49d2f8aa354f086a5@kernel.org>
 <CAMj1kXHsNsQXbeeS1zcy+xYA7kSE5apbLpChohfvkABS7Z6jKg@mail.gmail.com>
 <89c48bd2a9b32b4607d1515714fa3c1b@kernel.org>
 <16f47fa9-90b4-0b5c-33cb-cb004fc39266@intel.com>
In-Reply-To: <16f47fa9-90b4-0b5c-33cb-cb004fc39266@intel.com>
From: Kalesh Singh <kaleshsingh@google.com>
Date: Thu, 24 Feb 2022 19:11:55 -0800
Message-ID: <CAC_TJvd2a4DJUgvFLAHyBJT-eZNWwwohuTG=NOfvaOpyTTd3oA@mail.gmail.com>
Subject: Re: [kbuild-all] Re: [PATCH v2 6/9] KVM: arm64: Detect and handle
 hypervisor stack overflows
To: "Chen, Rong A" <rong.a.chen@intel.com>
X-Mailman-Approved-At: Fri, 25 Feb 2022 09:59:45 -0500
Cc: Catalin Marinas <catalin.marinas@arm.com>, llvm@lists.linux.dev,
 Joey Gouly <joey.gouly@arm.com>, Will Deacon <will@kernel.org>,
 kernel test robot <lkp@intel.com>, Marc Zyngier <maz@kernel.org>,
 kvmarm <kvmarm@lists.cs.columbia.edu>,
 Android Kernel Team <kernel-team@android.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Suren Baghdasaryan <surenb@google.com>, Peter Collingbourne <pcc@google.com>,
 Linux ARM <linux-arm-kernel@lists.infradead.org>, kbuild-all@lists.01.org,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>
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

On Thu, Feb 24, 2022 at 6:12 PM Chen, Rong A <rong.a.chen@intel.com> wrote:
>
>
>
> On 2/24/2022 6:39 PM, Marc Zyngier wrote:
> > On 2022-02-23 12:56, Ard Biesheuvel wrote:
> >> On Wed, 23 Feb 2022 at 13:54, Marc Zyngier <maz@kernel.org> wrote:
> >>>
> >>> On 2022-02-23 12:34, Philip Li wrote:
> >>> > On Wed, Feb 23, 2022 at 09:16:59AM +0000, Marc Zyngier wrote:
> >>> >> On Wed, 23 Feb 2022 09:05:18 +0000,
> >>> >> kernel test robot <lkp@intel.com> wrote:
> >>> >> >
> >>> >> > Hi Kalesh,
> >>> >> >
> >>> >> > Thank you for the patch! Perhaps something to improve:
> >>> >> >
> >>> >> > [auto build test WARNING on
> >>> cfb92440ee71adcc2105b0890bb01ac3cddb8507]
> >>> >> >
> >>> >> > url:
> >>> https://github.com/0day-ci/linux/commits/Kalesh-Singh/KVM-arm64-Hypervisor-stack-enhancements/20220223-010522
> >>>
> >>> >> > base:   cfb92440ee71adcc2105b0890bb01ac3cddb8507
> >>> >> > config: arm64-randconfig-r011-20220221
> >>> (https://download.01.org/0day-ci/archive/20220223/202202231727.L621fVgD-lkp@intel.com/config)
> >>>
> >>> >> > compiler: clang version 15.0.0
> >>> (https://github.com/llvm/llvm-project
> >>> d271fc04d5b97b12e6b797c6067d3c96a8d7470e)
> >>> >> > reproduce (this is a W=1 build):
> >>> >> >         wget
> >>> https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross
> >>> -O ~/bin/make.cross
> >>> >> >         chmod +x ~/bin/make.cross
> >>> >> >         # install arm64 cross compiling tool for clang build
> >>> >> >         # apt-get install binutils-aarch64-linux-gnu
> >>> >> >         #
> >>> https://github.com/0day-ci/linux/commit/7fe99fd40f7c4b2973218045ca5b9c9160524db1
> >>>
> >>> >> >         git remote add linux-review
> >>> https://github.com/0day-ci/linux
> >>> >> >         git fetch --no-tags linux-review
> >>> Kalesh-Singh/KVM-arm64-Hypervisor-stack-enhancements/20220223-010522
> >>> >> >         git checkout 7fe99fd40f7c4b2973218045ca5b9c9160524db1
> >>> >> >         # save the config file to linux build tree
> >>> >> >         mkdir build_dir
> >>> >> >         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang
> >>> make.cross W=1 O=build_dir ARCH=arm64 SHELL=/bin/bash arch/arm64/
> >>> >> >
> >>> >> > If you fix the issue, kindly add following tag as appropriate
> >>> >> > Reported-by: kernel test robot <lkp@intel.com>
> >>> >> >
> >>> >> > All warnings (new ones prefixed by >>):
> >>> >> >
> >>> >> >    include/linux/stddef.h:8:14: note: expanded from macro 'NULL'
> >>> >> >    #define NULL ((void *)0)
> >>> >> >                 ^~~~~~~~~~~
> >>> >> >    arch/arm64/kvm/hyp/nvhe/switch.c:200:27: warning: initializer
> >>> overrides prior initialization of this subobject
> >>> [-Winitializer-overrides]
> >>> >> >            [ESR_ELx_EC_FP_ASIMD]           = kvm_hyp_handle_fpsimd,
> >>> >> >                                              ^~~~~~~~~~~~~~~~~~~~~
> >>> >> >    arch/arm64/kvm/hyp/nvhe/switch.c:196:28: note: previous
> >>> initialization is here
> >>> >> >            [0 ... ESR_ELx_EC_MAX]          = NULL,
> >>> >> >                                              ^~~~
> >>> >> >    include/linux/stddef.h:8:14: note: expanded from macro 'NULL'
> >>> >> >    #define NULL ((void *)0)
> >>> >> >                 ^~~~~~~~~~~
> >>> >>
> >>> >> Kalesh, please ignore this nonsense. There may be things to improve,
> >>> >> but this is *NOT* one of them.
> >>> >>
> >>> >> These reports are pretty useless, and just lead people to ignore real
> >>> >> bug reports.
> >>> >
> >>> > Hi Kalesh, sorry there're some irrelevant issues mixed in the report,
> >>> > kindly ignore them. And the valuable ones are the new ones that
> >>> > prefixed by >>, as the below one in original report.
> >>> >
> >>> >>> arch/arm64/kvm/hyp/nvhe/switch.c:372:17: warning: no previous
> >>> >>> prototype for function 'hyp_panic_bad_stack' [-Wmissing-prototypes]
> >>> >    void __noreturn hyp_panic_bad_stack(void)
> >>> >                    ^
> >>>
> >>> This is only called from assembly code, so a prototype wouldn't bring
> >>> much.
> >>>
> >>
> >> Should probably be marked as 'asmlinkage' then. I've suggested many
> >> times already that this bogus diagnostic should either be disabled, or
> >> disregard 'asmlinkage' symbols.
> >
> > Yes, asmlinkage is definitely missing.
> >
> > But it is pretty obvious that the robot people aren't interested in
> > fixing this particular issue, given how long we have been suggesting
> > this...
> >
> >          M.
>
> Hi Marc, Ard,
>
> We have ignored the warning related to asmlinkage according to the below
> advice:
>
> https://lore.kernel.org/lkml/CAMj1kXHrRYagSVniSetHdG15rkQS+fm4zVOtN=Zda3W0QaEoJA@mail.gmail.com/
>
> do you want the bot ignore such warning if asmlinkage not specified?

Hi Rong,

I have added asmlinkage to the functions without a prototype in later
versions of the patch.

Perhaps the report should be updated to say "functions only called
from assembly code should be annotated with the asmlinkage attribute"
if the error is a missing prototype

Thanks,
Kalesh
>
> Best Regards,
> Rong Chen
>
> --
> To unsubscribe from this group and stop receiving emails from it, send an email to kernel-team+unsubscribe@android.com.
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
