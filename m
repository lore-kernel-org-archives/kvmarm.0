Return-Path: <SRS0=2KC8=AG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C91AC433E0
	for <kvmarm@archiver.kernel.org>; Thu, 25 Jun 2020 08:34:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 19A4220720
	for <kvmarm@archiver.kernel.org>; Thu, 25 Jun 2020 08:34:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="BwbQSy30"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 19A4220720
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B14F04B2AC;
	Thu, 25 Jun 2020 04:34:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 12T2kmHHpnR6; Thu, 25 Jun 2020 04:34:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 847B94B2F8;
	Thu, 25 Jun 2020 04:34:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7261A4B2F8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Jun 2020 04:34:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0PQCtDVvq5tq for <kvmarm@lists.cs.columbia.edu>;
 Thu, 25 Jun 2020 04:34:48 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3C2024B2AC
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Jun 2020 04:34:48 -0400 (EDT)
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 123A820720;
 Thu, 25 Jun 2020 08:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1593074087;
 bh=yE7w4pBtr9gWM6b8JXlrez/Wof9L3MU2WqOiRKy3bh0=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=BwbQSy30KnXDM4git3UTct2s83H/Mt5+9CoksJpi55joPEP+L/4ocObw6nhLitLJQ
 3z9+DHpHhmX6SjuVjOBnrL/ldxbaTXRnlVR7x/UdJpcnp7/DgEkkW6Q3eEEzOX3xB+
 M/ul54Y2xF+Z5mA+5goaKxP+wtpK/UfbK2wv6reI=
Date: Thu, 25 Jun 2020 09:34:41 +0100
From: Will Deacon <will@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v3 08/15] arm64: kvm: Split hyp/switch.c to VHE/nVHE
Message-ID: <20200625083441.GB7584@willie-the-truck>
References: <20200618122537.9625-9-dbrazdil@google.com>
 <202006251244.YDWclRrq%lkp@intel.com>
 <d807e83db1f1052378b6998f683e4617@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <d807e83db1f1052378b6998f683e4617@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: kbuild-all@lists.01.org, kernel test robot <lkp@intel.com>,
 android-kvm@google.com, Catalin Marinas <catalin.marinas@arm.com>,
 linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
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

On Thu, Jun 25, 2020 at 09:16:03AM +0100, Marc Zyngier wrote:
> On 2020-06-25 06:03, kernel test robot wrote:
> > Hi David,
> > 
> > Thank you for the patch! Perhaps something to improve:
> > 
> > [auto build test WARNING on linus/master]
> > [also build test WARNING on v5.8-rc2 next-20200624]
> > [cannot apply to kvmarm/next arm64/for-next/core arm-perf/for-next/perf]
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
> > > > arch/arm64/kvm/hyp/nvhe/switch.c:244:28: warning: no previous
> > > > prototype for function 'hyp_panic' [-Wmissing-prototypes]
> >    void __hyp_text __noreturn hyp_panic(struct kvm_cpu_context
> > *host_ctxt)
> 
> I really wish we could turn these warnings off. They don't add much.
> Or is there an annotation we could stick on the function (something
> like __called_from_asm_please_leave_me_alone springs to mind...)?

Agreed, I've caught myself skim-reading the kbuild robot reports now
because they're often just noise, and then having to force myself to look at
them properly when I remember. Even just something in the subject to
say "the only problems are W=1 warnings" would help. Is that possible?

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
