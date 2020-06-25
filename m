Return-Path: <SRS0=2KC8=AG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5445C433DF
	for <kvmarm@archiver.kernel.org>; Thu, 25 Jun 2020 08:16:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4514C2081A
	for <kvmarm@archiver.kernel.org>; Thu, 25 Jun 2020 08:16:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="iL2oGQgx"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4514C2081A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C67A34B494;
	Thu, 25 Jun 2020 04:16:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id D8I+ynlktpiM; Thu, 25 Jun 2020 04:16:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F24214B493;
	Thu, 25 Jun 2020 04:16:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 40ED14B47F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Jun 2020 04:16:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id p1aUZ1s3aH1A for <kvmarm@lists.cs.columbia.edu>;
 Thu, 25 Jun 2020 04:16:06 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 96BC34B481
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Jun 2020 04:16:06 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 65BF6207FC;
 Thu, 25 Jun 2020 08:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1593072965;
 bh=MPqzxqlkLelCCKm2NSBBivueFsMTrj5zghx/JYvmDos=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=iL2oGQgxl7cBdkY9GmZCHCXDsYU7SyMCIRn/zVaiJclsOjqSG0cvWh8OH/4Etip+T
 ysc31KkZoevPkSZHEf1wCj90WehZeMFWM5bLpoFc46CDHeCtYgskvJGZqzlulxmiUo
 nDbHMuvsM8e7K6B9QsrHQf/2m0ZzO8Gc+WZ89v7E=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1joN3D-006HU5-Ud; Thu, 25 Jun 2020 09:16:04 +0100
MIME-Version: 1.0
Date: Thu, 25 Jun 2020 09:16:03 +0100
From: Marc Zyngier <maz@kernel.org>
To: kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v3 08/15] arm64: kvm: Split hyp/switch.c to VHE/nVHE
In-Reply-To: <202006251244.YDWclRrq%lkp@intel.com>
References: <20200618122537.9625-9-dbrazdil@google.com>
 <202006251244.YDWclRrq%lkp@intel.com>
User-Agent: Roundcube Webmail/1.4.5
Message-ID: <d807e83db1f1052378b6998f683e4617@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: lkp@intel.com, dbrazdil@google.com, will@kernel.org,
 catalin.marinas@arm.com, james.morse@arm.com, julien.thierry.kdev@gmail.com,
 suzuki.poulose@arm.com, kbuild-all@lists.01.org,
 clang-built-linux@googlegroups.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 android-kvm@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kbuild-all@lists.01.org, android-kvm@google.com,
 Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 clang-built-linux@googlegroups.com, linux-arm-kernel@lists.infradead.org,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 2020-06-25 06:03, kernel test robot wrote:
> Hi David,
> 
> Thank you for the patch! Perhaps something to improve:
> 
> [auto build test WARNING on linus/master]
> [also build test WARNING on v5.8-rc2 next-20200624]
> [cannot apply to kvmarm/next arm64/for-next/core 
> arm-perf/for-next/perf]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use  as documented in
> https://git-scm.com/docs/git-format-patch]
> 
> url:
> https://github.com/0day-ci/linux/commits/David-Brazdil/Split-off-nVHE-hyp-code/20200618-203230
> base:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
> 1b5044021070efa3259f3e9548dc35d1eb6aa844
> config: arm64-randconfig-r021-20200624 (attached as .config)
> compiler: clang version 11.0.0 (https://github.com/llvm/llvm-project
> 8911a35180c6777188fefe0954a2451a2b91deaf)
> reproduce (this is a W=1 build):
>         wget
> https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross
> -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # install arm64 cross compiling tool for clang build
>         # apt-get install binutils-aarch64-linux-gnu
>         # save the attached .config to linux build tree
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross 
> ARCH=arm64
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> 
> All warnings (new ones prefixed by >>):
> 
>>> arch/arm64/kvm/hyp/nvhe/switch.c:244:28: warning: no previous 
>>> prototype for function 'hyp_panic' [-Wmissing-prototypes]
>    void __hyp_text __noreturn hyp_panic(struct kvm_cpu_context 
> *host_ctxt)

I really wish we could turn these warnings off. They don't add much.
Or is there an annotation we could stick on the function (something
like __called_from_asm_please_leave_me_alone springs to mind...)?

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
