Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B957DC433EF
	for <kvmarm@archiver.kernel.org>; Wed, 23 Feb 2022 12:56:44 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 26E124C204;
	Wed, 23 Feb 2022 07:56:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@intel.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pMC52doDwRyp; Wed, 23 Feb 2022 07:56:42 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 38D794C418;
	Wed, 23 Feb 2022 07:56:42 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C2AC44C491
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Feb 2022 07:36:35 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fz1v+i7btD9D for <kvmarm@lists.cs.columbia.edu>;
 Wed, 23 Feb 2022 07:36:33 -0500 (EST)
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3FD814C1F7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Feb 2022 07:36:33 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
 d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
 t=1645619793; x=1677155793;
 h=date:from:to:cc:subject:message-id:references:
 mime-version:in-reply-to;
 bh=OdSCkrvWTIGBVhz8S1EekPKKnza/NTZR76i2du7AwlM=;
 b=mhPRaYcT7h1+951AWxu/VcmGuO6ttpMVVpt12qX8Ukqd2xxeQO9XZoIH
 ogo1aeh3eiW7bMB/9Cs4bX6gx77GPxdpwSTUUJ93UqmX0lrpMwWaMTWGq
 zIWQQOUuVybkqDdewFvWRmLGh+k+1rhCE6VyQNyWp+iZouzp50P6etVj7
 vxZVVnML19jBnAUTjZRXA3tFWpNwAfLZFKCCNITV9P/c8ooJFtg1Gzhyt
 iYdihCzIAhNPzpjM/bwDH+2Z/JI6MkS1xfiHXP93jjnqN+V4zvQMUBUC9
 Ek2DzVsPSEHkq7FBBllGO/begwfiOTnTEDQT1hm6qgJiimsinytTtt0nR Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10266"; a="232573440"
X-IronPort-AV: E=Sophos;i="5.88,390,1635231600"; d="scan'208";a="232573440"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
 by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 23 Feb 2022 04:36:31 -0800
X-IronPort-AV: E=Sophos;i="5.88,390,1635231600"; d="scan'208";a="532666200"
Received: from rli9-dbox.sh.intel.com (HELO rli9-dbox) ([10.239.159.142])
 by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 23 Feb 2022 04:36:26 -0800
Date: Wed, 23 Feb 2022 20:34:05 +0800
From: Philip Li <philip.li@intel.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [kbuild-all] Re: [PATCH v2 6/9] KVM: arm64: Detect and handle
 hypervisor stack overflows
Message-ID: <YhYpvfZaSjrAtkZp@rli9-dbox>
References: <20220222165212.2005066-7-kaleshsingh@google.com>
 <202202231727.L621fVgD-lkp@intel.com>
 <875yp63ptg.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <875yp63ptg.wl-maz@kernel.org>
X-Mailman-Approved-At: Wed, 23 Feb 2022 07:56:41 -0500
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Wed, Feb 23, 2022 at 09:16:59AM +0000, Marc Zyngier wrote:
> On Wed, 23 Feb 2022 09:05:18 +0000,
> kernel test robot <lkp@intel.com> wrote:
> > 
> > Hi Kalesh,
> > 
> > Thank you for the patch! Perhaps something to improve:
> >
> > [auto build test WARNING on cfb92440ee71adcc2105b0890bb01ac3cddb8507]
> > 
> > url:    https://github.com/0day-ci/linux/commits/Kalesh-Singh/KVM-arm64-Hypervisor-stack-enhancements/20220223-010522
> > base:   cfb92440ee71adcc2105b0890bb01ac3cddb8507
> > config: arm64-randconfig-r011-20220221 (https://download.01.org/0day-ci/archive/20220223/202202231727.L621fVgD-lkp@intel.com/config)
> > compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project d271fc04d5b97b12e6b797c6067d3c96a8d7470e)
> > reproduce (this is a W=1 build):
> >         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
> >         chmod +x ~/bin/make.cross
> >         # install arm64 cross compiling tool for clang build
> >         # apt-get install binutils-aarch64-linux-gnu
> >         # https://github.com/0day-ci/linux/commit/7fe99fd40f7c4b2973218045ca5b9c9160524db1
> >         git remote add linux-review https://github.com/0day-ci/linux
> >         git fetch --no-tags linux-review Kalesh-Singh/KVM-arm64-Hypervisor-stack-enhancements/20220223-010522
> >         git checkout 7fe99fd40f7c4b2973218045ca5b9c9160524db1
> >         # save the config file to linux build tree
> >         mkdir build_dir
> >         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=arm64 SHELL=/bin/bash arch/arm64/
> > 
> > If you fix the issue, kindly add following tag as appropriate
> > Reported-by: kernel test robot <lkp@intel.com>
> > 
> > All warnings (new ones prefixed by >>):
> > 
> >    include/linux/stddef.h:8:14: note: expanded from macro 'NULL'
> >    #define NULL ((void *)0)
> >                 ^~~~~~~~~~~
> >    arch/arm64/kvm/hyp/nvhe/switch.c:200:27: warning: initializer overrides prior initialization of this subobject [-Winitializer-overrides]
> >            [ESR_ELx_EC_FP_ASIMD]           = kvm_hyp_handle_fpsimd,
> >                                              ^~~~~~~~~~~~~~~~~~~~~
> >    arch/arm64/kvm/hyp/nvhe/switch.c:196:28: note: previous initialization is here
> >            [0 ... ESR_ELx_EC_MAX]          = NULL,
> >                                              ^~~~
> >    include/linux/stddef.h:8:14: note: expanded from macro 'NULL'
> >    #define NULL ((void *)0)
> >                 ^~~~~~~~~~~
> 
> Kalesh, please ignore this nonsense. There may be things to improve,
> but this is *NOT* one of them.
> 
> These reports are pretty useless, and just lead people to ignore real
> bug reports.

Hi Kalesh, sorry there're some irrelevant issues mixed in the report,
kindly ignore them. And the valuable ones are the new ones that
prefixed by >>, as the below one in original report.

>> arch/arm64/kvm/hyp/nvhe/switch.c:372:17: warning: no previous prototype for function 'hyp_panic_bad_stack' [-Wmissing-prototypes]
   void __noreturn hyp_panic_bad_stack(void)
                   ^
Thanks

> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
> _______________________________________________
> kbuild-all mailing list -- kbuild-all@lists.01.org
> To unsubscribe send an email to kbuild-all-leave@lists.01.org
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
