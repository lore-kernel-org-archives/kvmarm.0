Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C5DBC433EF
	for <kvmarm@archiver.kernel.org>; Wed, 23 Feb 2022 02:05:24 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D7E304BD79;
	Tue, 22 Feb 2022 21:05:23 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@intel.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zhEsXqBOq3Ir; Tue, 22 Feb 2022 21:05:22 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EDA7D4BD75;
	Tue, 22 Feb 2022 21:05:21 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 87D7C4BD71
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Feb 2022 21:05:20 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VmybatGEwaBd for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Feb 2022 21:05:18 -0500 (EST)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B26E34BD6C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Feb 2022 21:05:17 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
 d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
 t=1645581917; x=1677117917;
 h=date:from:to:cc:subject:message-id:references:
 mime-version:in-reply-to;
 bh=hijXHNoJz4XA0M+7ZFzjHKzc//6MWWg3TV351e6dqnM=;
 b=iWcm8HpIO4aWweieqtBHVea0u2y3gsenGkXeVf2W5lHbdqLPNHzpI7a8
 v7BCqDOsnNE+vgtZ3COYyhZISWZqPu7bEMUM2oQV2CVgwQJ8KBgHDnvvx
 /If5ruUpqSy8BMGgkbFIU9qRwumTdXldFo2FZOsFqBc1onTSHojs/akHC
 wJ/t8hccD3dr4jnNvqBmzeENbRR7Nh0+8z7DEGyZbjR0L9rgesJKV3lrl
 WvrbVlCnZUHk/2PisIWbhehoIazdfHYQXETAWB26u51F3aaGYuvc51uBF
 W6l+S1ObFd5D5tdAQmUcZjt777cFBAgq3icUnPUjHeAa1PAdl9xXqFKJ6 w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10266"; a="276476398"
X-IronPort-AV: E=Sophos;i="5.88,389,1635231600"; d="scan'208";a="276476398"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
 by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 22 Feb 2022 18:05:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,389,1635231600"; d="scan'208";a="543159958"
Received: from lkp-server01.sh.intel.com (HELO 788b1cd46f0d) ([10.239.97.150])
 by fmsmga007.fm.intel.com with ESMTP; 22 Feb 2022 18:05:11 -0800
Received: from kbuild by 788b1cd46f0d with local (Exim 4.92)
 (envelope-from <lkp@intel.com>)
 id 1nMh1i-0000qd-Ot; Wed, 23 Feb 2022 02:05:10 +0000
Date: Wed, 23 Feb 2022 10:04:26 +0800
From: kernel test robot <lkp@intel.com>
To: Kalesh Singh <kaleshsingh@google.com>
Subject: Re: [PATCH v2 6/9] KVM: arm64: Detect and handle hypervisor stack
 overflows
Message-ID: <202202230932.BKc5SFqd-lkp@intel.com>
References: <20220222165212.2005066-7-kaleshsingh@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220222165212.2005066-7-kaleshsingh@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: Catalin Marinas <catalin.marinas@arm.com>, Joey Gouly <joey.gouly@arm.com>,
 Kalesh Singh <kaleshsingh@google.com>, will@kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 kernel-team@android.com, Pasha Tatashin <pasha.tatashin@soleen.com>,
 surenb@google.com, Peter Collingbourne <pcc@google.com>,
 kbuild-all@lists.01.org, linux-kernel@vger.kernel.org, maz@kernel.org,
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

Hi Kalesh,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on cfb92440ee71adcc2105b0890bb01ac3cddb8507]

url:    https://github.com/0day-ci/linux/commits/Kalesh-Singh/KVM-arm64-Hypervisor-stack-enhancements/20220223-010522
base:   cfb92440ee71adcc2105b0890bb01ac3cddb8507
config: arm64-defconfig (https://download.01.org/0day-ci/archive/20220223/202202230932.BKc5SFqd-lkp@intel.com/config)
compiler: aarch64-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/7fe99fd40f7c4b2973218045ca5b9c9160524db1
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Kalesh-Singh/KVM-arm64-Hypervisor-stack-enhancements/20220223-010522
        git checkout 7fe99fd40f7c4b2973218045ca5b9c9160524db1
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=arm64 SHELL=/bin/bash arch/arm64/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   arch/arm64/kvm/hyp/nvhe/switch.c:197:43: warning: initialized field overwritten [-Woverride-init]
     197 |         [ESR_ELx_EC_CP15_32]            = kvm_hyp_handle_cp15_32,
         |                                           ^~~~~~~~~~~~~~~~~~~~~~
   arch/arm64/kvm/hyp/nvhe/switch.c:197:43: note: (near initialization for 'hyp_exit_handlers[3]')
   arch/arm64/kvm/hyp/nvhe/switch.c:198:43: warning: initialized field overwritten [-Woverride-init]
     198 |         [ESR_ELx_EC_SYS64]              = kvm_hyp_handle_sysreg,
         |                                           ^~~~~~~~~~~~~~~~~~~~~
   arch/arm64/kvm/hyp/nvhe/switch.c:198:43: note: (near initialization for 'hyp_exit_handlers[24]')
   arch/arm64/kvm/hyp/nvhe/switch.c:199:43: warning: initialized field overwritten [-Woverride-init]
     199 |         [ESR_ELx_EC_SVE]                = kvm_hyp_handle_fpsimd,
         |                                           ^~~~~~~~~~~~~~~~~~~~~
   arch/arm64/kvm/hyp/nvhe/switch.c:199:43: note: (near initialization for 'hyp_exit_handlers[25]')
   arch/arm64/kvm/hyp/nvhe/switch.c:200:43: warning: initialized field overwritten [-Woverride-init]
     200 |         [ESR_ELx_EC_FP_ASIMD]           = kvm_hyp_handle_fpsimd,
         |                                           ^~~~~~~~~~~~~~~~~~~~~
   arch/arm64/kvm/hyp/nvhe/switch.c:200:43: note: (near initialization for 'hyp_exit_handlers[7]')
   arch/arm64/kvm/hyp/nvhe/switch.c:201:43: warning: initialized field overwritten [-Woverride-init]
     201 |         [ESR_ELx_EC_IABT_LOW]           = kvm_hyp_handle_iabt_low,
         |                                           ^~~~~~~~~~~~~~~~~~~~~~~
   arch/arm64/kvm/hyp/nvhe/switch.c:201:43: note: (near initialization for 'hyp_exit_handlers[32]')
   arch/arm64/kvm/hyp/nvhe/switch.c:202:43: warning: initialized field overwritten [-Woverride-init]
     202 |         [ESR_ELx_EC_DABT_LOW]           = kvm_hyp_handle_dabt_low,
         |                                           ^~~~~~~~~~~~~~~~~~~~~~~
   arch/arm64/kvm/hyp/nvhe/switch.c:202:43: note: (near initialization for 'hyp_exit_handlers[36]')
   arch/arm64/kvm/hyp/nvhe/switch.c:203:43: warning: initialized field overwritten [-Woverride-init]
     203 |         [ESR_ELx_EC_PAC]                = kvm_hyp_handle_ptrauth,
         |                                           ^~~~~~~~~~~~~~~~~~~~~~
   arch/arm64/kvm/hyp/nvhe/switch.c:203:43: note: (near initialization for 'hyp_exit_handlers[9]')
   arch/arm64/kvm/hyp/nvhe/switch.c:208:43: warning: initialized field overwritten [-Woverride-init]
     208 |         [ESR_ELx_EC_SYS64]              = kvm_handle_pvm_sys64,
         |                                           ^~~~~~~~~~~~~~~~~~~~
   arch/arm64/kvm/hyp/nvhe/switch.c:208:43: note: (near initialization for 'pvm_exit_handlers[24]')
   arch/arm64/kvm/hyp/nvhe/switch.c:209:43: warning: initialized field overwritten [-Woverride-init]
     209 |         [ESR_ELx_EC_SVE]                = kvm_handle_pvm_restricted,
         |                                           ^~~~~~~~~~~~~~~~~~~~~~~~~
   arch/arm64/kvm/hyp/nvhe/switch.c:209:43: note: (near initialization for 'pvm_exit_handlers[25]')
   arch/arm64/kvm/hyp/nvhe/switch.c:210:43: warning: initialized field overwritten [-Woverride-init]
     210 |         [ESR_ELx_EC_FP_ASIMD]           = kvm_handle_pvm_fpsimd,
         |                                           ^~~~~~~~~~~~~~~~~~~~~
   arch/arm64/kvm/hyp/nvhe/switch.c:210:43: note: (near initialization for 'pvm_exit_handlers[7]')
   arch/arm64/kvm/hyp/nvhe/switch.c:211:43: warning: initialized field overwritten [-Woverride-init]
     211 |         [ESR_ELx_EC_IABT_LOW]           = kvm_hyp_handle_iabt_low,
         |                                           ^~~~~~~~~~~~~~~~~~~~~~~
   arch/arm64/kvm/hyp/nvhe/switch.c:211:43: note: (near initialization for 'pvm_exit_handlers[32]')
   arch/arm64/kvm/hyp/nvhe/switch.c:212:43: warning: initialized field overwritten [-Woverride-init]
     212 |         [ESR_ELx_EC_DABT_LOW]           = kvm_hyp_handle_dabt_low,
         |                                           ^~~~~~~~~~~~~~~~~~~~~~~
   arch/arm64/kvm/hyp/nvhe/switch.c:212:43: note: (near initialization for 'pvm_exit_handlers[36]')
   arch/arm64/kvm/hyp/nvhe/switch.c:213:43: warning: initialized field overwritten [-Woverride-init]
     213 |         [ESR_ELx_EC_PAC]                = kvm_hyp_handle_ptrauth,
         |                                           ^~~~~~~~~~~~~~~~~~~~~~
   arch/arm64/kvm/hyp/nvhe/switch.c:213:43: note: (near initialization for 'pvm_exit_handlers[9]')
   arch/arm64/kvm/hyp/nvhe/switch.c:350:17: warning: no previous prototype for 'hyp_panic' [-Wmissing-prototypes]
     350 | void __noreturn hyp_panic(void)
         |                 ^~~~~~~~~
>> arch/arm64/kvm/hyp/nvhe/switch.c:372:17: warning: no previous prototype for 'hyp_panic_bad_stack' [-Wmissing-prototypes]
     372 | void __noreturn hyp_panic_bad_stack(void)
         |                 ^~~~~~~~~~~~~~~~~~~
   arch/arm64/kvm/hyp/nvhe/switch.c:377:17: warning: no previous prototype for 'kvm_unexpected_el2_exception' [-Wmissing-prototypes]
     377 | asmlinkage void kvm_unexpected_el2_exception(void)
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~


vim +/hyp_panic_bad_stack +372 arch/arm64/kvm/hyp/nvhe/switch.c

   371	
 > 372	void __noreturn hyp_panic_bad_stack(void)
   373	{
   374		hyp_panic();
   375	}
   376	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
