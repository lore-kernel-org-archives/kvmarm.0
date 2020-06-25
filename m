Return-Path: <SRS0=8LgP=AH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76CACC433E0
	for <kvmarm@archiver.kernel.org>; Fri, 26 Jun 2020 08:26:58 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EC6E920775
	for <kvmarm@archiver.kernel.org>; Fri, 26 Jun 2020 08:26:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="oKVWfvoG"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EC6E920775
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 53F3A4B157;
	Fri, 26 Jun 2020 04:26:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id v0i44tsbrrmZ; Fri, 26 Jun 2020 04:26:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7AF474B15A;
	Fri, 26 Jun 2020 04:26:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 33CBD4B0C1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Jun 2020 13:56:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6gXPcPK3F084 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 25 Jun 2020 13:56:12 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0EE134B0A1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Jun 2020 13:56:12 -0400 (EDT)
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com
 [209.85.128.48])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id A4EC620899
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Jun 2020 17:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1593107770;
 bh=P85gb0RYxs8bdscv/UzJZV8GMZKO6FNZmtLISXWaRkI=;
 h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
 b=oKVWfvoGv7fuIwzL2lqOsnY8d0mXHBPXz6dV//HQfdCW1l2sfTW2ApQkAZO+2jvXH
 N0NKmYVRu3N7wTkF8pT1cJRqAVMcYDkz5u5tt107w2JCYbcC4uTvmEWDOWR1AkdRHp
 L+E6hvq2jfQPexZDLIr8zDUu+RZSNmNoPvube2N8=
Received: by mail-wm1-f48.google.com with SMTP id o8so6439624wmh.4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Jun 2020 10:56:10 -0700 (PDT)
X-Gm-Message-State: AOAM530RcpE+C4Qow0TZfx6zjkW4fmkMy3SFECzYrlVldiDAMpnrqVMY
 vvdQ/VNoDxvmZ/Wt77P30kdAScLC7Xp+bfwykCv86Q==
X-Google-Smtp-Source: ABdhPJyD6H4S6WO9N1l9zzdg3mNnfR0NeQ/s4mEYulZWDN4TxbiqvfmMcS6fjAEL2b515bNpz9Ocp+EVy/cNkq/McJw=
X-Received: by 2002:a1c:b143:: with SMTP id a64mr4970455wmf.133.1593107769134; 
 Thu, 25 Jun 2020 10:56:09 -0700 (PDT)
MIME-Version: 1.0
References: <20200618122537.9625-9-dbrazdil@google.com>
 <202006251244.YDWclRrq%lkp@intel.com>
 <d807e83db1f1052378b6998f683e4617@kernel.org>
In-Reply-To: <d807e83db1f1052378b6998f683e4617@kernel.org>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Thu, 25 Jun 2020 19:55:58 +0200
X-Gmail-Original-Message-ID: <CAKv+Gu-82CKeKvYozmnqnoBDDdJUfc3xxfXv6w4LHPnN5uvyGA@mail.gmail.com>
Message-ID: <CAKv+Gu-82CKeKvYozmnqnoBDDdJUfc3xxfXv6w4LHPnN5uvyGA@mail.gmail.com>
Subject: Re: [PATCH v3 08/15] arm64: kvm: Split hyp/switch.c to VHE/nVHE
To: Marc Zyngier <maz@kernel.org>
X-Mailman-Approved-At: Fri, 26 Jun 2020 04:26:54 -0400
Cc: kbuild-all@lists.01.org, kernel test robot <lkp@intel.com>,
 android-kvm@google.com, Catalin Marinas <catalin.marinas@arm.com>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 clang-built-linux <clang-built-linux@googlegroups.com>,
 Will Deacon <will@kernel.org>, kvmarm <kvmarm@lists.cs.columbia.edu>,
 linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
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

On Thu, 25 Jun 2020 at 10:16, Marc Zyngier <maz@kernel.org> wrote:
>
> On 2020-06-25 06:03, kernel test robot wrote:
> > Hi David,
> >
> > Thank you for the patch! Perhaps something to improve:
> >
> > [auto build test WARNING on linus/master]
> > [also build test WARNING on v5.8-rc2 next-20200624]
> > [cannot apply to kvmarm/next arm64/for-next/core
> > arm-perf/for-next/perf]
> > [If your patch is applied to the wrong git tree, kindly drop us a note.
> > And when submitting patch, we suggest to use  as documented in
> > https://git-scm.com/docs/git-format-patch]
> >
> > url:
> > https://github.com/0day-ci/linux/commits/David-Brazdil/Split-off-nVHE-hyp-code/20200618-203230
> > base:
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
> > 1b5044021070efa3259f3e9548dc35d1eb6aa844
> > config: arm64-randconfig-r021-20200624 (attached as .config)
> > compiler: clang version 11.0.0 (https://github.com/llvm/llvm-project
> > 8911a35180c6777188fefe0954a2451a2b91deaf)
> > reproduce (this is a W=1 build):
> >         wget
> > https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross
> > -O ~/bin/make.cross
> >         chmod +x ~/bin/make.cross
> >         # install arm64 cross compiling tool for clang build
> >         # apt-get install binutils-aarch64-linux-gnu
> >         # save the attached .config to linux build tree
> >         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross
> > ARCH=arm64
> >
> > If you fix the issue, kindly add following tag as appropriate
> > Reported-by: kernel test robot <lkp@intel.com>
> >
> > All warnings (new ones prefixed by >>):
> >
> >>> arch/arm64/kvm/hyp/nvhe/switch.c:244:28: warning: no previous
> >>> prototype for function 'hyp_panic' [-Wmissing-prototypes]
> >    void __hyp_text __noreturn hyp_panic(struct kvm_cpu_context
> > *host_ctxt)
>
> I really wish we could turn these warnings off. They don't add much.
> Or is there an annotation we could stick on the function (something
> like __called_from_asm_please_leave_me_alone springs to mind...)?
>

We should define 'asmlinkage' to whatever makes this warning go away.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
