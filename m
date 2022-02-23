Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFCB2C433F5
	for <kvmarm@archiver.kernel.org>; Wed, 23 Feb 2022 12:54:23 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B1004C4D3;
	Wed, 23 Feb 2022 07:54:23 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hCAXIHNf4SRI; Wed, 23 Feb 2022 07:54:21 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C14B44C4E2;
	Wed, 23 Feb 2022 07:54:21 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A17144C4A2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Feb 2022 07:54:20 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FrNG1O4DhQKH for <kvmarm@lists.cs.columbia.edu>;
 Wed, 23 Feb 2022 07:54:19 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 508384C4A1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Feb 2022 07:54:19 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 60930614A2;
 Wed, 23 Feb 2022 12:54:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 713F8C340E7;
 Wed, 23 Feb 2022 12:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1645620857;
 bh=KabldDCUxNI5N0bArBHqR/7UI4fMhp6C7OzTfnPNseY=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=sX+0/Zl3DoDwAA+MolP7ywo2/n7hs2TkupNKHBYtTmASBUZdHGID4QJ3iTR5MeoEW
 RtU8wvSgg/5ZOMxZFGb89LUzOQS/PP+U6tVplQNYYlR3Tji+8E4xRPDaD94AuJGGq9
 y1NgFWrQRk6E9kJve6icn8xklej+TgzeuuCr0ijH37b8qVuEKXGTh5XApZ+VIY8aoB
 BFBfKLXoyU9vrQZCAy8S4igxLoXn/DueNfKaPvLFXVp8sk9zkadRRcVU2WLn/xz/1K
 MqSOnYQ+yDHnhux+EwT+49wXk4npgC2KG6a/J/d7pstO38QspF5dfjspQtiHvx4enQ
 dlEpV4sGLs2Qw==
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1nMr9q-009u6b-UM; Wed, 23 Feb 2022 12:54:15 +0000
MIME-Version: 1.0
Date: Wed, 23 Feb 2022 12:54:14 +0000
From: Marc Zyngier <maz@kernel.org>
To: Philip Li <philip.li@intel.com>
Subject: Re: [kbuild-all] Re: [PATCH v2 6/9] KVM: arm64: Detect and handle
 hypervisor stack overflows
In-Reply-To: <YhYpvfZaSjrAtkZp@rli9-dbox>
References: <20220222165212.2005066-7-kaleshsingh@google.com>
 <202202231727.L621fVgD-lkp@intel.com> <875yp63ptg.wl-maz@kernel.org>
 <YhYpvfZaSjrAtkZp@rli9-dbox>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <cb750267af0636c49d2f8aa354f086a5@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: philip.li@intel.com, kaleshsingh@google.com, lkp@intel.com,
 llvm@lists.linux.dev, kbuild-all@lists.01.org, will@kernel.org,
 qperret@google.com, tabba@google.com, surenb@google.com,
 kernel-team@android.com, catalin.marinas@arm.com, james.morse@arm.com,
 alexandru.elisei@arm.com, suzuki.poulose@arm.com, ardb@kernel.org,
 mark.rutland@arm.com, pasha.tatashin@soleen.com, joey.gouly@arm.com,
 pcc@google.com, ascull@google.com, pbonzini@redhat.com, yuzenghui@huawei.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Catalin Marinas <catalin.marinas@arm.com>, llvm@lists.linux.dev,
 Joey Gouly <joey.gouly@arm.com>, Kalesh Singh <kaleshsingh@google.com>,
 will@kernel.org, kernel test robot <lkp@intel.com>, surenb@google.com,
 kvmarm@lists.cs.columbia.edu, kernel-team@android.com,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Peter Collingbourne <pcc@google.com>, linux-arm-kernel@lists.infradead.org,
 kbuild-all@lists.01.org, linux-kernel@vger.kernel.org,
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 2022-02-23 12:34, Philip Li wrote:
> On Wed, Feb 23, 2022 at 09:16:59AM +0000, Marc Zyngier wrote:
>> On Wed, 23 Feb 2022 09:05:18 +0000,
>> kernel test robot <lkp@intel.com> wrote:
>> >
>> > Hi Kalesh,
>> >
>> > Thank you for the patch! Perhaps something to improve:
>> >
>> > [auto build test WARNING on cfb92440ee71adcc2105b0890bb01ac3cddb8507]
>> >
>> > url:    https://github.com/0day-ci/linux/commits/Kalesh-Singh/KVM-arm64-Hypervisor-stack-enhancements/20220223-010522
>> > base:   cfb92440ee71adcc2105b0890bb01ac3cddb8507
>> > config: arm64-randconfig-r011-20220221 (https://download.01.org/0day-ci/archive/20220223/202202231727.L621fVgD-lkp@intel.com/config)
>> > compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project d271fc04d5b97b12e6b797c6067d3c96a8d7470e)
>> > reproduce (this is a W=1 build):
>> >         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>> >         chmod +x ~/bin/make.cross
>> >         # install arm64 cross compiling tool for clang build
>> >         # apt-get install binutils-aarch64-linux-gnu
>> >         # https://github.com/0day-ci/linux/commit/7fe99fd40f7c4b2973218045ca5b9c9160524db1
>> >         git remote add linux-review https://github.com/0day-ci/linux
>> >         git fetch --no-tags linux-review Kalesh-Singh/KVM-arm64-Hypervisor-stack-enhancements/20220223-010522
>> >         git checkout 7fe99fd40f7c4b2973218045ca5b9c9160524db1
>> >         # save the config file to linux build tree
>> >         mkdir build_dir
>> >         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=arm64 SHELL=/bin/bash arch/arm64/
>> >
>> > If you fix the issue, kindly add following tag as appropriate
>> > Reported-by: kernel test robot <lkp@intel.com>
>> >
>> > All warnings (new ones prefixed by >>):
>> >
>> >    include/linux/stddef.h:8:14: note: expanded from macro 'NULL'
>> >    #define NULL ((void *)0)
>> >                 ^~~~~~~~~~~
>> >    arch/arm64/kvm/hyp/nvhe/switch.c:200:27: warning: initializer overrides prior initialization of this subobject [-Winitializer-overrides]
>> >            [ESR_ELx_EC_FP_ASIMD]           = kvm_hyp_handle_fpsimd,
>> >                                              ^~~~~~~~~~~~~~~~~~~~~
>> >    arch/arm64/kvm/hyp/nvhe/switch.c:196:28: note: previous initialization is here
>> >            [0 ... ESR_ELx_EC_MAX]          = NULL,
>> >                                              ^~~~
>> >    include/linux/stddef.h:8:14: note: expanded from macro 'NULL'
>> >    #define NULL ((void *)0)
>> >                 ^~~~~~~~~~~
>> 
>> Kalesh, please ignore this nonsense. There may be things to improve,
>> but this is *NOT* one of them.
>> 
>> These reports are pretty useless, and just lead people to ignore real
>> bug reports.
> 
> Hi Kalesh, sorry there're some irrelevant issues mixed in the report,
> kindly ignore them. And the valuable ones are the new ones that
> prefixed by >>, as the below one in original report.
> 
>>> arch/arm64/kvm/hyp/nvhe/switch.c:372:17: warning: no previous 
>>> prototype for function 'hyp_panic_bad_stack' [-Wmissing-prototypes]
>    void __noreturn hyp_panic_bad_stack(void)
>                    ^

This is only called from assembly code, so a prototype wouldn't bring 
much.

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
