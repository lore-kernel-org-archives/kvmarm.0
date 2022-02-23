Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C917C433EF
	for <kvmarm@archiver.kernel.org>; Wed, 23 Feb 2022 09:06:36 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 75DB34C3F8;
	Wed, 23 Feb 2022 04:06:35 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@intel.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id aE3QLeNr0vhA; Wed, 23 Feb 2022 04:06:33 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 542F74C358;
	Wed, 23 Feb 2022 04:06:33 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BFBB34C2CA
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Feb 2022 04:06:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CYiZbmPd7TWZ for <kvmarm@lists.cs.columbia.edu>;
 Wed, 23 Feb 2022 04:06:28 -0500 (EST)
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 787604C333
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Feb 2022 04:06:28 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
 d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
 t=1645607188; x=1677143188;
 h=date:from:to:cc:subject:message-id:references:
 mime-version:in-reply-to;
 bh=UmG8QUkK9khDhXRiw9N34JhJQ0VKWF9hY6tPnln+/Xk=;
 b=WzLddWY58TZxBZv+9edDcNUl9oNsryK+gyXz7k60AASS8uHa7uh3r7n0
 XKlYMpd6DlZPdCrtBiRnsv+wN4XxYq7ZfjLdrJGNCoiq8ke29ZS/rv+er
 vpgFCumGcnRUTPCMgMB3dlpmTBrBUSBmQL6Wo91CgdDza9zpL+76o8PHg
 Ue1OV52ineTkYjPS3cnwBMwhvhXjHCugAzpIadNHZIm8g/9Lk8uOJ8I05
 i1HDsrDzRADkYfKN9xnDT8wxX1xFrOj9PswttoA4PcmqtZhQ5kjunnj8T
 MyscgCqNPAuuflFNl2UepSoH3lnPn/ilq+Mk7LKSXII26bS8QJ8Qoz7ZM g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10266"; a="251656540"
X-IronPort-AV: E=Sophos;i="5.88,390,1635231600"; d="scan'208";a="251656540"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
 by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 23 Feb 2022 01:06:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,390,1635231600"; d="scan'208";a="543248029"
Received: from lkp-server01.sh.intel.com (HELO 788b1cd46f0d) ([10.239.97.150])
 by fmsmga007.fm.intel.com with ESMTP; 23 Feb 2022 01:06:21 -0800
Received: from kbuild by 788b1cd46f0d with local (Exim 4.92)
 (envelope-from <lkp@intel.com>)
 id 1nMnbJ-0001C6-7M; Wed, 23 Feb 2022 09:06:21 +0000
Date: Wed, 23 Feb 2022 17:05:18 +0800
From: kernel test robot <lkp@intel.com>
To: Kalesh Singh <kaleshsingh@google.com>
Subject: Re: [PATCH v2 6/9] KVM: arm64: Detect and handle hypervisor stack
 overflows
Message-ID: <202202231727.L621fVgD-lkp@intel.com>
References: <20220222165212.2005066-7-kaleshsingh@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220222165212.2005066-7-kaleshsingh@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: Catalin Marinas <catalin.marinas@arm.com>, llvm@lists.linux.dev,
 Joey Gouly <joey.gouly@arm.com>, Kalesh Singh <kaleshsingh@google.com>,
 will@kernel.org, maz@kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
 Pasha Tatashin <pasha.tatashin@soleen.com>, surenb@google.com,
 Peter Collingbourne <pcc@google.com>, kbuild-all@lists.01.org,
 linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
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
config: arm64-randconfig-r011-20220221 (https://download.01.org/0day-ci/archive/20220223/202202231727.L621fVgD-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project d271fc04d5b97b12e6b797c6067d3c96a8d7470e)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install arm64 cross compiling tool for clang build
        # apt-get install binutils-aarch64-linux-gnu
        # https://github.com/0day-ci/linux/commit/7fe99fd40f7c4b2973218045ca5b9c9160524db1
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Kalesh-Singh/KVM-arm64-Hypervisor-stack-enhancements/20220223-010522
        git checkout 7fe99fd40f7c4b2973218045ca5b9c9160524db1
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=arm64 SHELL=/bin/bash arch/arm64/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   include/linux/stddef.h:8:14: note: expanded from macro 'NULL'
   #define NULL ((void *)0)
                ^~~~~~~~~~~
   arch/arm64/kvm/hyp/nvhe/switch.c:200:27: warning: initializer overrides prior initialization of this subobject [-Winitializer-overrides]
           [ESR_ELx_EC_FP_ASIMD]           = kvm_hyp_handle_fpsimd,
                                             ^~~~~~~~~~~~~~~~~~~~~
   arch/arm64/kvm/hyp/nvhe/switch.c:196:28: note: previous initialization is here
           [0 ... ESR_ELx_EC_MAX]          = NULL,
                                             ^~~~
   include/linux/stddef.h:8:14: note: expanded from macro 'NULL'
   #define NULL ((void *)0)
                ^~~~~~~~~~~
   arch/arm64/kvm/hyp/nvhe/switch.c:201:27: warning: initializer overrides prior initialization of this subobject [-Winitializer-overrides]
           [ESR_ELx_EC_IABT_LOW]           = kvm_hyp_handle_iabt_low,
                                             ^~~~~~~~~~~~~~~~~~~~~~~
   arch/arm64/kvm/hyp/nvhe/switch.c:196:28: note: previous initialization is here
           [0 ... ESR_ELx_EC_MAX]          = NULL,
                                             ^~~~
   include/linux/stddef.h:8:14: note: expanded from macro 'NULL'
   #define NULL ((void *)0)
                ^~~~~~~~~~~
   arch/arm64/kvm/hyp/nvhe/switch.c:202:27: warning: initializer overrides prior initialization of this subobject [-Winitializer-overrides]
           [ESR_ELx_EC_DABT_LOW]           = kvm_hyp_handle_dabt_low,
                                             ^~~~~~~~~~~~~~~~~~~~~~~
   arch/arm64/kvm/hyp/nvhe/switch.c:196:28: note: previous initialization is here
           [0 ... ESR_ELx_EC_MAX]          = NULL,
                                             ^~~~
   include/linux/stddef.h:8:14: note: expanded from macro 'NULL'
   #define NULL ((void *)0)
                ^~~~~~~~~~~
   arch/arm64/kvm/hyp/nvhe/switch.c:203:22: warning: initializer overrides prior initialization of this subobject [-Winitializer-overrides]
           [ESR_ELx_EC_PAC]                = kvm_hyp_handle_ptrauth,
                                             ^~~~~~~~~~~~~~~~~~~~~~
   arch/arm64/kvm/hyp/nvhe/switch.c:196:28: note: previous initialization is here
           [0 ... ESR_ELx_EC_MAX]          = NULL,
                                             ^~~~
   include/linux/stddef.h:8:14: note: expanded from macro 'NULL'
   #define NULL ((void *)0)
                ^~~~~~~~~~~
   arch/arm64/kvm/hyp/nvhe/switch.c:208:24: warning: initializer overrides prior initialization of this subobject [-Winitializer-overrides]
           [ESR_ELx_EC_SYS64]              = kvm_handle_pvm_sys64,
                                             ^~~~~~~~~~~~~~~~~~~~
   arch/arm64/kvm/hyp/nvhe/switch.c:207:28: note: previous initialization is here
           [0 ... ESR_ELx_EC_MAX]          = NULL,
                                             ^~~~
   include/linux/stddef.h:8:14: note: expanded from macro 'NULL'
   #define NULL ((void *)0)
                ^~~~~~~~~~~
   arch/arm64/kvm/hyp/nvhe/switch.c:209:22: warning: initializer overrides prior initialization of this subobject [-Winitializer-overrides]
           [ESR_ELx_EC_SVE]                = kvm_handle_pvm_restricted,
                                             ^~~~~~~~~~~~~~~~~~~~~~~~~
   arch/arm64/kvm/hyp/nvhe/switch.c:207:28: note: previous initialization is here
           [0 ... ESR_ELx_EC_MAX]          = NULL,
                                             ^~~~
   include/linux/stddef.h:8:14: note: expanded from macro 'NULL'
   #define NULL ((void *)0)
                ^~~~~~~~~~~
   arch/arm64/kvm/hyp/nvhe/switch.c:210:27: warning: initializer overrides prior initialization of this subobject [-Winitializer-overrides]
           [ESR_ELx_EC_FP_ASIMD]           = kvm_handle_pvm_fpsimd,
                                             ^~~~~~~~~~~~~~~~~~~~~
   arch/arm64/kvm/hyp/nvhe/switch.c:207:28: note: previous initialization is here
           [0 ... ESR_ELx_EC_MAX]          = NULL,
                                             ^~~~
   include/linux/stddef.h:8:14: note: expanded from macro 'NULL'
   #define NULL ((void *)0)
                ^~~~~~~~~~~
   arch/arm64/kvm/hyp/nvhe/switch.c:211:27: warning: initializer overrides prior initialization of this subobject [-Winitializer-overrides]
           [ESR_ELx_EC_IABT_LOW]           = kvm_hyp_handle_iabt_low,
                                             ^~~~~~~~~~~~~~~~~~~~~~~
   arch/arm64/kvm/hyp/nvhe/switch.c:207:28: note: previous initialization is here
           [0 ... ESR_ELx_EC_MAX]          = NULL,
                                             ^~~~
   include/linux/stddef.h:8:14: note: expanded from macro 'NULL'
   #define NULL ((void *)0)
                ^~~~~~~~~~~
   arch/arm64/kvm/hyp/nvhe/switch.c:212:27: warning: initializer overrides prior initialization of this subobject [-Winitializer-overrides]
           [ESR_ELx_EC_DABT_LOW]           = kvm_hyp_handle_dabt_low,
                                             ^~~~~~~~~~~~~~~~~~~~~~~
   arch/arm64/kvm/hyp/nvhe/switch.c:207:28: note: previous initialization is here
           [0 ... ESR_ELx_EC_MAX]          = NULL,
                                             ^~~~
   include/linux/stddef.h:8:14: note: expanded from macro 'NULL'
   #define NULL ((void *)0)
                ^~~~~~~~~~~
   arch/arm64/kvm/hyp/nvhe/switch.c:213:22: warning: initializer overrides prior initialization of this subobject [-Winitializer-overrides]
           [ESR_ELx_EC_PAC]                = kvm_hyp_handle_ptrauth,
                                             ^~~~~~~~~~~~~~~~~~~~~~
   arch/arm64/kvm/hyp/nvhe/switch.c:207:28: note: previous initialization is here
           [0 ... ESR_ELx_EC_MAX]          = NULL,
                                             ^~~~
   include/linux/stddef.h:8:14: note: expanded from macro 'NULL'
   #define NULL ((void *)0)
                ^~~~~~~~~~~
   arch/arm64/kvm/hyp/nvhe/switch.c:350:17: warning: no previous prototype for function 'hyp_panic' [-Wmissing-prototypes]
   void __noreturn hyp_panic(void)
                   ^
   arch/arm64/kvm/hyp/nvhe/switch.c:350:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   void __noreturn hyp_panic(void)
   ^
   static 
>> arch/arm64/kvm/hyp/nvhe/switch.c:372:17: warning: no previous prototype for function 'hyp_panic_bad_stack' [-Wmissing-prototypes]
   void __noreturn hyp_panic_bad_stack(void)
                   ^
   arch/arm64/kvm/hyp/nvhe/switch.c:372:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   void __noreturn hyp_panic_bad_stack(void)
   ^
   static 
   arch/arm64/kvm/hyp/nvhe/switch.c:377:17: warning: no previous prototype for function 'kvm_unexpected_el2_exception' [-Wmissing-prototypes]
   asmlinkage void kvm_unexpected_el2_exception(void)
                   ^
   arch/arm64/kvm/hyp/nvhe/switch.c:377:12: note: declare 'static' if the function is not intended to be used outside of this translation unit
   asmlinkage void kvm_unexpected_el2_exception(void)
              ^
              static 
   16 warnings generated.


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
