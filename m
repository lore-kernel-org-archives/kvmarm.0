Return-Path: <SRS0=2KC8=AG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD6DEC433E0
	for <kvmarm@archiver.kernel.org>; Thu, 25 Jun 2020 18:26:35 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 61F2020781
	for <kvmarm@archiver.kernel.org>; Thu, 25 Jun 2020 18:26:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="HpNWW9Mw"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 61F2020781
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E16CA4B10C;
	Thu, 25 Jun 2020 14:26:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IxBO2xpd5W8S; Thu, 25 Jun 2020 14:26:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CAFAC4B0FF;
	Thu, 25 Jun 2020 14:26:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B31F64A551
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Jun 2020 14:26:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 23kPeIOotxB5 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 25 Jun 2020 14:26:31 -0400 (EDT)
Received: from mail-pj1-f65.google.com (mail-pj1-f65.google.com
 [209.85.216.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5BAA74A4E1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Jun 2020 14:26:31 -0400 (EDT)
Received: by mail-pj1-f65.google.com with SMTP id h22so3664751pjf.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Jun 2020 11:26:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=ETOuWEoyx3l3QXnbkpa1FViwhlbDdj5RYMJCyJ/ebAM=;
 b=HpNWW9MwE6vq1Anc++U5txnTPeoSIrQ5ogp/CEHf3tIl/tnClkkszSCuLVxsOR4GPr
 qcQFsZrY1WgOj2xyyC4B017aZ0SuioqBQfuR9KnIkgAV64f3VaENBCHAG8DhybTBfLWK
 nEFxBn9j+386lOrjYHH726Abn7OdM3h2OFxvJqy5JV3xyI9J3wmHkmuLKsxidkQM0CMc
 EPug7d2CnudNRbjNrBVRx4MWrw8Oq4VXLovuCt05RFqTRT8U6a+Cl07V05KuUk8znw0t
 kgonB3v/6h4/vMMeve6EqnJsVah4jQabfhkmvBLZi0X9dlQkDwQnDrKzuz714RG2j/Hc
 aRHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=ETOuWEoyx3l3QXnbkpa1FViwhlbDdj5RYMJCyJ/ebAM=;
 b=jfFyo5zeHmeG6Lxu10bFIZu+7du1CAk/7hxhszjL82uY6umFE4ikPT1CU8k+HdL83R
 R/UC+ePeEA8cIYt6IPbF3hUlt2NfIF1gzVB3WL+vM6qViHGfLi+Layly6d1xJsll2HEM
 K2Oth5NsbyIr0QYstdgr9wyvAtcKEP2aQjTX3xrSbfPyJsPjFutDx1a/O0nFG55nvlKQ
 gI0MknTQ3dDsdRDW5k7/eYoMIJBgoCxQlL9+EpKxiDJCAoXPEJiTu+mCPRIlepY8IQV0
 dWpfJRtF3xlgbbwM4aEsYoS0FJQVgku7eKzP3pYmLtETW8y8wW+1H83zxRbyZU1nQeuO
 kfHg==
X-Gm-Message-State: AOAM533mr5NHDh7BdGwoypWWbnfIZmdSYuc3xp+SG831cZaVVSzfs5/j
 fISbEX2ADZJyZqVougubcPqaC0I1Eu2X3ZgPsab6Vw==
X-Google-Smtp-Source: ABdhPJx842ihVSXEC+dRBn4T1wBfiF1wZmkEpTThe17QN8NnIH9b7pknjYgr+o16BK9UFkYWqyd4uw/Uf/cSkjGAC0Q=
X-Received: by 2002:a17:902:b698:: with SMTP id
 c24mr33333972pls.223.1593109590004; 
 Thu, 25 Jun 2020 11:26:30 -0700 (PDT)
MIME-Version: 1.0
References: <20200618122537.9625-9-dbrazdil@google.com>
 <202006251244.YDWclRrq%lkp@intel.com>
 <d807e83db1f1052378b6998f683e4617@kernel.org>
 <20200625083441.GB7584@willie-the-truck>
In-Reply-To: <20200625083441.GB7584@willie-the-truck>
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Thu, 25 Jun 2020 11:26:18 -0700
Message-ID: <CAKwvOd=TswBPY7J-VH6hm80O0eq6GPA_7YUsuddwq3RHaDMQfA@mail.gmail.com>
Subject: Re: [PATCH v3 08/15] arm64: kvm: Split hyp/switch.c to VHE/nVHE
To: Will Deacon <will@kernel.org>
Cc: kbuild-all@lists.01.org, kernel test robot <lkp@intel.com>,
 android-kvm@google.com, Marc Zyngier <maz@kernel.org>,
 LKML <linux-kernel@vger.kernel.org>,
 clang-built-linux <clang-built-linux@googlegroups.com>,
 Linux ARM <linux-arm-kernel@lists.infradead.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Philip Li <philip.li@intel.com>,
 kvmarm@lists.cs.columbia.edu
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

On Thu, Jun 25, 2020 at 1:34 AM Will Deacon <will@kernel.org> wrote:
>
> On Thu, Jun 25, 2020 at 09:16:03AM +0100, Marc Zyngier wrote:
> > On 2020-06-25 06:03, kernel test robot wrote:
> > > Hi David,
> > >
> > > Thank you for the patch! Perhaps something to improve:
> > >
> > > [auto build test WARNING on linus/master]
> > > [also build test WARNING on v5.8-rc2 next-20200624]
> > > [cannot apply to kvmarm/next arm64/for-next/core arm-perf/for-next/perf]
> > > [If your patch is applied to the wrong git tree, kindly drop us a note.
> > > And when submitting patch, we suggest to use  as documented in
> > > https://git-scm.com/docs/git-format-patch]
> > >
> > > url:
> > > https://github.com/0day-ci/linux/commits/David-Brazdil/Split-off-nVHE-hyp-code/20200618-203230
> > > base:
> > > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
> > > 1b5044021070efa3259f3e9548dc35d1eb6aa844
> > > config: arm64-randconfig-r021-20200624 (attached as .config)
> > > compiler: clang version 11.0.0 (https://github.com/llvm/llvm-project
> > > 8911a35180c6777188fefe0954a2451a2b91deaf)
> > > reproduce (this is a W=1 build):
> > >         wget
> > > https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross
> > > -O ~/bin/make.cross
> > >         chmod +x ~/bin/make.cross
> > >         # install arm64 cross compiling tool for clang build
> > >         # apt-get install binutils-aarch64-linux-gnu
> > >         # save the attached .config to linux build tree
> > >         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross
> > > ARCH=arm64
> > >
> > > If you fix the issue, kindly add following tag as appropriate
> > > Reported-by: kernel test robot <lkp@intel.com>
> > >
> > > All warnings (new ones prefixed by >>):
> > >
> > > > > arch/arm64/kvm/hyp/nvhe/switch.c:244:28: warning: no previous
> > > > > prototype for function 'hyp_panic' [-Wmissing-prototypes]
> > >    void __hyp_text __noreturn hyp_panic(struct kvm_cpu_context
> > > *host_ctxt)
> >
> > I really wish we could turn these warnings off. They don't add much.
> > Or is there an annotation we could stick on the function (something
> > like __called_from_asm_please_leave_me_alone springs to mind...)?
>
> Agreed, I've caught myself skim-reading the kbuild robot reports now
> because they're often just noise, and then having to force myself to look at
> them properly when I remember. Even just something in the subject to
> say "the only problems are W=1 warnings" would help. Is that possible?

When the W=1 reports started showing up, it took me a while to figure
out these warnings were only enabled at W=1.  I asked Philip to help
denote these in the reports, and Philip was kind enough to add a note
in the report about W=1.  I agree that the note could still be more
prominent.  Another part of me wants to move -Wmissing-prototypes to
W=2, but that's just biding time until 0day starts reporting on those.

-- 
Thanks,
~Nick Desaulniers
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
